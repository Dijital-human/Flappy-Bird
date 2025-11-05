//
//  GameController.swift
//  Flappy Bird
//
//  Oyun idarəçisi - oyun vəziyyətini və istifadəçi interaksiyalarını idarə edir
//  Game Controller - manages game state and user interactions
//

import Foundation
import SwiftUI
import Combine

/// Oyun idarəçisi - MVC strukturunda Controller
/// Game Controller - Controller in MVC architecture
class GameController: ObservableObject {
    // MARK: - Published Properties / Nəşr edilən xassələr
    
    @Published var gameModel: GameModel
    @Published var interstitialManager: AdMobInterstitialManager
    @Published var rewardedAdManager: AdMobRewardedManager
    @Published var audioManager: AudioManager
    @Published var settingsModel: SettingsModel
    @Published var statisticsModel: StatisticsModel
    @Published var dailyChallengeModel: DailyChallengeModel
    @Published var powerUpModel: PowerUpModel
    @Published var birdTypeModel: BirdTypeModel
    @Published var environmentModel: EnvironmentModel
    @Published var achievementModel: AchievementModel
    @Published var localizationModel: LocalizationModel
    @Published var showCountdown: Bool = false
    @Published var showSettings: Bool = false
    @Published var showStatistics: Bool = false
    @Published var showTutorial: Bool = false
    @Published var showDailyChallenge: Bool = false
    @Published var showAchievements: Bool = false
    @Published var showBirdSelection: Bool = false
    @Published var showEnvironmentSelection: Bool = false
    
    // MARK: - Ad Counter / Reklam Sayğacı
    
    private var gameCountSinceLastAd: Int = 0  // Son reklamdan sonra keçən oyun sayı / Games played since last ad
    private let gamesBeforeAd: Int = 3  // Reklamdan əvvəl oyun sayı / Games before showing ad
    private let gameCountKey = "gameCountSinceLastAd"  // UserDefaults key / UserDefaults açarı
    
    // MARK: - Combine / Combine
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization / İnitializasiya
    
    /// Oyun idarəçisini yaradır / Creates game controller
    init() {
        // Oyun modelini yaradır / Creates game model
        gameModel = GameModel()
        
        // Interstitial reklam idarəçisini yaradır / Creates interstitial ad manager
        interstitialManager = AdMobInterstitialManager()
        
        // Rewarded reklam idarəçisini yaradır / Creates rewarded ad manager
        rewardedAdManager = AdMobRewardedManager()
        
        // Audio idarəçisini yaradır / Creates audio manager
        audioManager = AudioManager()
        
        // Ayarlar modelini yaradır / Creates settings model
        settingsModel = SettingsModel()
        
        // Statistikalar modelini yaradır / Creates statistics model
        statisticsModel = StatisticsModel()
        
        // Gündəlik challenge modelini yaradır / Creates daily challenge model
        dailyChallengeModel = DailyChallengeModel()
        
        // Power-up modelini yaradır / Creates power-up model
        powerUpModel = PowerUpModel()
        
        // Quş növü modelini yaradır / Creates bird type model
        birdTypeModel = BirdTypeModel()
        
        // Mühit modelini yaradır / Creates environment model
        environmentModel = EnvironmentModel()
        
        // Achievement modelini yaradır / Creates achievement model
        achievementModel = AchievementModel()
        
        // Localization modelini yaradır / Creates localization model
        localizationModel = LocalizationModel()
        
        // Reklam sayğacını yükləyir / Loads ad counter
        loadAdCounter()
        
        // AudioManager və SettingsModel-i sinxronlaşdırır / Synchronizes AudioManager and SettingsModel
        settingsModel.$soundEnabled
            .assign(to: \.isSoundEnabled, on: audioManager)
            .store(in: &cancellables)
        
        settingsModel.$musicEnabled
            .assign(to: \.isMusicEnabled, on: audioManager)
            .store(in: &cancellables)
        
        // GameModel dəyişikliklərini dinləyir / Listens to GameModel changes
        gameModel.objectWillChange.sink { [weak self] _ in
            // GameModel dəyişdikdə GameController-i yeniləyir / Updates GameController when GameModel changes
            self?.objectWillChange.send()
        }.store(in: &cancellables)
        
        // Power-up status closure-u təyin edir / Sets power-up status closure
        gameModel.isPowerUpActive = { [weak self] type in
            return self?.powerUpModel.isActive(type) ?? false
        }
        
        // Power-up collection callback-i təyin edir / Sets power-up collection callback
        gameModel.onPowerUpCollected = { [weak self] type in
            // Power-up aktivləşdirir / Activates power-up
            self?.activatePowerUp(type)
            // Power-up səs effektini çalır / Plays power-up sound effect
            self?.audioManager.playPowerUpSound()
            // Haptic feedback verir / Provides haptic feedback
            if self?.settingsModel.hapticEnabled ?? true {
                HapticManager.shared.playSuccess()
            }
        }
    }
    
    // MARK: - Game State Management / Oyun vəziyyəti idarəetməsi
    
    /// Oyunu başlatır / Starts the game
    func startGame() {
        // Countdown göstərir / Shows countdown
        showCountdown = true
    }
    
    /// Countdown bitdikdən sonra oyunu başlatır / Starts game after countdown finishes
    func startGameAfterCountdown() {
        // Countdown gizlədir / Hides countdown
        showCountdown = false
        // Model-də oyunu başlatır / Starts game in model
        gameModel.startGame()
        // Jump səs effektini çalır / Plays jump sound effect
        audioManager.playJumpSound()
        // Haptic feedback verir / Provides haptic feedback
        if settingsModel.hapticEnabled {
            HapticManager.shared.playLightImpact()
        }
    }
    
    /// Oyunu yenidən başlatır / Restarts the game
    func restartGame() {
        // Model-də oyunu sıfırlayır / Resets game in model
        gameModel.resetGame()
        // Oyunu yenidən başlatır / Starts game again
        startGame()
    }
    
    /// Oyunu sıfırlayır / Resets the game
    func resetGame() {
        // Model-də oyunu sıfırlayır / Resets game in model
        gameModel.resetGame()
        // Countdown gizlədir / Hides countdown
        showCountdown = false
    }
    
    /// Oyunu dayandırır / Pauses the game
    func pauseGame() {
        // Model-də oyunu dayandırır / Pauses game in model
        gameModel.pauseGame()
    }
    
    /// Oyunu davam etdirir / Resumes the game
    func resumeGame() {
        // Model-də oyunu davam etdirir / Resumes game in model
        gameModel.resumeGame()
        // Jump səs effektini çalır / Plays jump sound effect
        audioManager.playJumpSound()
        // Haptic feedback verir / Provides haptic feedback
        if settingsModel.hapticEnabled {
            HapticManager.shared.playLightImpact()
        }
    }
    
    // MARK: - User Interaction / İstifadəçi interaksiyası
    
    /// İstifadəçi tap etdikdə çağırılır / Called when user taps
    func handleTap() {
        // Oyun davam edirsə, quşu yuxarı qaldırır / If game is playing, makes bird jump
        if gameModel.gameState == .playing {
            handleBirdTap()
        }
    }
    
    /// Quş tap zamanı çağırılır / Called when bird is tapped
    func handleBirdTap() {
        // Model-də quşu yuxarı qaldırır / Makes bird jump in model
        gameModel.jump()
        // Jump səs effektini çalır / Plays jump sound effect
        audioManager.playJumpSound()
        // Haptic feedback verir / Provides haptic feedback
        if settingsModel.hapticEnabled {
            HapticManager.shared.playLightImpact()
        }
    }
    
    /// Skor artdıqda çağırılır / Called when score increases
    func handleScoreIncrease() {
        // Skor səs effektini çalır / Plays score sound effect
        audioManager.playScoreSound()
        // Haptic feedback verir / Provides haptic feedback
        if settingsModel.hapticEnabled {
            HapticManager.shared.playSuccess()
        }
        
        // Real-time daily challenge tracking / Real-time daily challenge tracking
        if let challenge = dailyChallengeModel.currentChallenge, !dailyChallengeModel.isCompleted {
            switch challenge.type {
            case .scoreTarget:
                // Skor hədəfi - real-time tracking / Score target - real-time tracking
                dailyChallengeModel.updateProgress(currentValue: gameModel.score)
            default:
                break
            }
        }
    }
    
    /// Oyun bitdikdə çağırılır / Called when game ends
    func handleGameOver(playTime: TimeInterval, pipesPassed: Int) {
        // Game over səs effektini çalır / Plays game over sound effect
        audioManager.playGameOverSound()
        // Haptic feedback verir / Provides haptic feedback
        if settingsModel.hapticEnabled {
            HapticManager.shared.playError()
        }
        // Statistikaları yeniləyir / Updates statistics
        statisticsModel.updateStatistics(
            score: gameModel.score,
            playTime: playTime,
            pipesPassed: pipesPassed
        )
        
        // Reklam sayğacını artırır / Increases ad counter
        incrementAdCounter()
        
        // Daily challenge tracking / Daily challenge tracking
        if let challenge = dailyChallengeModel.currentChallenge {
            switch challenge.type {
            case .scoreTarget:
                // Skor hədəfi / Score target
                dailyChallengeModel.updateProgress(currentValue: gameModel.score)
            case .surviveTime:
                // Müəyyən vaxt sağ qalmaq / Survive for specific time
                dailyChallengeModel.updateProgress(currentValue: Int(playTime))
            case .passPipes:
                // Müəyyən sayda boru keçmək / Pass specific number of pipes
                dailyChallengeModel.updateProgress(currentValue: pipesPassed)
            case .noPowerUps:
                // Power-up istifadə etmədən oynamaq / Play without power-ups
                // Power-up aktivləşdirilməyibsə, challenge tamamlanır / If no power-ups activated, challenge completed
                if powerUpModel.activePowerUps.isEmpty {
                    dailyChallengeModel.updateProgress(currentValue: 1)
                }
            }
        }
        
        // Achievement-ləri yoxlayır / Checks achievements
        achievementModel.checkAchievements(
            score: gameModel.score,
            gamesPlayed: statisticsModel.totalGames,
            dailyChallengeCompleted: dailyChallengeModel.isCompleted
        )
        // Quş növlərini açır (skor əsasında) / Unlocks bird types (based on score)
        unlockBirdTypesForScore(gameModel.score)
        // Mühitləri açır (oyun sayı əsasında) / Unlocks environments (based on game count)
        unlockEnvironmentsForGameCount(statisticsModel.totalGames)
    }
    
    /// Skor əsasında quş növlərini açır / Unlocks bird types based on score
    private func unlockBirdTypesForScore(_ score: Int) {
        if score >= 50 && !birdTypeModel.isUnlocked(.red) {
            birdTypeModel.unlockBirdType(.red)
        }
        if score >= 100 && !birdTypeModel.isUnlocked(.blue) {
            birdTypeModel.unlockBirdType(.blue)
        }
        if score >= 200 && !birdTypeModel.isUnlocked(.green) {
            birdTypeModel.unlockBirdType(.green)
        }
        if score >= 500 && !birdTypeModel.isUnlocked(.purple) {
            birdTypeModel.unlockBirdType(.purple)
        }
        if score >= 1000 && !birdTypeModel.isUnlocked(.rainbow) {
            birdTypeModel.unlockBirdType(.rainbow)
        }
    }
    
    /// Oyun sayı əsasında mühitləri açır / Unlocks environments based on game count
    private func unlockEnvironmentsForGameCount(_ count: Int) {
        if count >= 10 && !environmentModel.isUnlocked(.night) {
            environmentModel.unlockEnvironment(.night)
        }
        if count >= 25 && !environmentModel.isUnlocked(.sunset) {
            environmentModel.unlockEnvironment(.sunset)
        }
        if count >= 50 && !environmentModel.isUnlocked(.winter) {
            environmentModel.unlockEnvironment(.winter)
        }
        if count >= 75 && !environmentModel.isUnlocked(.spring) {
            environmentModel.unlockEnvironment(.spring)
        }
        if count >= 100 && !environmentModel.isUnlocked(.summer) {
            environmentModel.unlockEnvironment(.summer)
        }
        if count >= 150 && !environmentModel.isUnlocked(.autumn) {
            environmentModel.unlockEnvironment(.autumn)
        }
    }
    
    /// Power-up aktivləşdirir / Activates power-up
    func activatePowerUp(_ type: PowerUpType) {
        powerUpModel.activate(type)
    }
    
    /// Gündəlik challenge irəliləməsini yeniləyir / Updates daily challenge progress
    func updateDailyChallengeProgress(value: Int) {
        dailyChallengeModel.updateProgress(currentValue: value)
    }
    
    // MARK: - UI Management / UI idarəetməsi
    
    /// Ayarlar ekranını göstərir / Shows settings screen
    func showSettingsScreen() {
        showSettings = true
    }
    
    /// Ayarlar ekranını gizlədir / Hides settings screen
    func hideSettingsScreen() {
        showSettings = false
    }
    
    /// Statistikalar ekranını göstərir / Shows statistics screen
    func showStatisticsScreen() {
        showStatistics = true
    }
    
    /// Statistikalar ekranını gizlədir / Hides statistics screen
    func hideStatisticsScreen() {
        showStatistics = false
    }
    
    /// Tutorial ekranını göstərir / Shows tutorial screen
    func showTutorialScreen() {
        showTutorial = true
    }
    
    /// Tutorial ekranını gizlədir / Hides tutorial screen
    func hideTutorialScreen() {
        showTutorial = false
    }
    
    /// Gündəlik challenge ekranını göstərir / Shows daily challenge screen
    func showDailyChallengeScreen() {
        showDailyChallenge = true
    }
    
    /// Gündəlik challenge ekranını gizlədir / Hides daily challenge screen
    func hideDailyChallengeScreen() {
        showDailyChallenge = false
    }
    
    /// Achievements ekranını göstərir / Shows achievements screen
    func showAchievementsScreen() {
        showAchievements = true
    }
    
    /// Achievements ekranını gizlədir / Hides achievements screen
    func hideAchievementsScreen() {
        showAchievements = false
    }
    
    /// Quş seçimi ekranını göstərir / Shows bird selection screen
    func showBirdSelectionScreen() {
        showBirdSelection = true
    }
    
    /// Quş seçimi ekranını gizlədir / Hides bird selection screen
    func hideBirdSelectionScreen() {
        showBirdSelection = false
    }
    
    /// Mühit seçimi ekranını göstərir / Shows environment selection screen
    func showEnvironmentSelectionScreen() {
        showEnvironmentSelection = true
    }
    
    /// Mühit seçimi ekranını gizlədir / Hides environment selection screen
    func hideEnvironmentSelectionScreen() {
        showEnvironmentSelection = false
    }
    
    // MARK: - Ad Management / Reklam idarəetməsi
    
    /// Reklam sayğacını yükləyir / Loads ad counter
    private func loadAdCounter() {
        gameCountSinceLastAd = UserDefaults.standard.integer(forKey: gameCountKey)
    }
    
    /// Reklam sayğacını saxlayır / Saves ad counter
    private func saveAdCounter() {
        UserDefaults.standard.set(gameCountSinceLastAd, forKey: gameCountKey)
    }
    
    /// Reklam sayğacını artırır / Increments ad counter
    private func incrementAdCounter() {
        gameCountSinceLastAd += 1
        saveAdCounter()
    }
    
    /// Reklam sayğacını sıfırlayır / Resets ad counter
    private func resetAdCounter() {
        gameCountSinceLastAd = 0
        saveAdCounter()
    }
    
    /// Reklam göstərilməli olub-olmadığını yoxlayır / Checks if ad should be shown
    func shouldShowInterstitialAd() -> Bool {
        // İlk 3 oyundan sonra, hər oyunda reklam göstərir / After first 3 games, shows ad every game
        return gameCountSinceLastAd >= gamesBeforeAd
    }
    
    /// Interstitial reklamı göstərir (yalnız lazım olduqda) / Shows interstitial ad (only when needed)
    func showInterstitialAdIfNeeded() {
        // Reklam göstərilməli olub-olmadığını yoxlayır / Checks if ad should be shown
        if shouldShowInterstitialAd() {
            // Reklamı göstərir / Shows ad
            interstitialManager.showInterstitial()
            // Sayğacı sıfırlayır / Resets counter
            resetAdCounter()
        }
    }
    
    /// Interstitial reklamı göstərir (məcburi) / Shows interstitial ad (forced)
    func showInterstitialAd() {
        // Interstitial reklamı göstərir / Shows interstitial ad
        interstitialManager.showInterstitial()
    }
    
    /// Rewarded reklamı göstərir / Shows rewarded ad
    func showRewardedAd(onRewardEarned: @escaping (Int) -> Void) {
        // Rewarded reklamı göstərir və mükafat verir / Shows rewarded ad and grants reward
        rewardedAdManager.showRewardedAd(onRewardEarned: onRewardEarned)
    }
}

