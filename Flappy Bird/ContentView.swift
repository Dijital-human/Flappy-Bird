//
//  ContentView.swift
//  Flappy Bird
//
//  Ana görünüş - oyunun bütün ekranlarını idarə edir
//  Main View - manages all game screens
//

import SwiftUI
import Combine

/// Ana görünüş - oyunun bütün ekranlarını idarə edir
/// Main View - manages all game screens
struct ContentView: View {
    // Oyun idarəçisi / Game controller
    @StateObject private var gameController = GameController()
    
    // Notification observer token / Notification observer token
    @State private var notificationObserver: NSObjectProtocol?
    
    var body: some View {
        ZStack {
            // Oyun vəziyyətinə görə müvafiq ekranı göstərir / Shows appropriate screen based on game state
            switch gameController.gameModel.gameState {
            case .start:
                // Başlanğıc ekranı / Start screen
                StartView(
                    gameModel: gameController.gameModel,
                    localizationModel: gameController.localizationModel,
                    onStart: {
                        // Oyunu başlatır / Starts the game
                        gameController.startGame()
                    },
                    onShowSettings: {
                        // Ayarlar ekranını göstərir / Shows settings screen
                        gameController.showSettingsScreen()
                    },
                    onShowStatistics: {
                        // Statistikalar ekranını göstərir / Shows statistics screen
                        gameController.showStatisticsScreen()
                    },
                    onShowTutorial: {
                        // Tutorial ekranını göstərir / Shows tutorial screen
                        gameController.showTutorialScreen()
                    },
                    onShowDailyChallenge: {
                        // Gündəlik challenge ekranını göstərir / Shows daily challenge screen
                        gameController.showDailyChallengeScreen()
                    },
                    onShowAchievements: {
                        // Achievements ekranını göstərir / Shows achievements screen
                        gameController.showAchievementsScreen()
                    },
                    onShowBirdSelection: {
                        // Quş seçimi ekranını göstərir / Shows bird selection screen
                        gameController.showBirdSelectionScreen()
                    },
                    onShowEnvironmentSelection: {
                        // Mühit seçimi ekranını göstərir / Shows environment selection screen
                        gameController.showEnvironmentSelectionScreen()
                    }
                )
                
            case .playing:
                // Oyun ekranı / Game screen
                VStack(spacing: 0) {
                    // Oyun sahəsi / Game area
                    GameView(
                        gameModel: gameController.gameModel,
                        gameController: gameController
                    )
                    
                    // Banner reklam / Banner ad
                    AdMobBannerView()
                        .frame(height: 50)
                        .background(Color.gray.opacity(0.1))
                }
                
            case .paused:
                // Pause ekranı / Pause screen
                ZStack {
                    // Oyun ekranı (arxada) / Game screen (background)
                    GameView(
                        gameModel: gameController.gameModel,
                        gameController: gameController
                    )
                    .blur(radius: 5)
                    
                    // Pause ekranı / Pause screen
                    PauseView(
                        onResume: {
                            // Oyunu davam etdirir / Resumes the game
                            gameController.resumeGame()
                        },
                        onHome: {
                            // Ana ekrana qayıdır / Returns to home screen
                            gameController.resetGame()
                        }
                    )
                }
                
            case .gameOver:
                // Oyun bitmə ekranı / Game over screen
                GameOverView(
                    gameModel: gameController.gameModel,
                    localizationModel: gameController.localizationModel,
                    onRestart: {
                        // Reklam məntiqinə görə interstitial reklamı göstərir (yalnız lazım olduqda) / Shows interstitial ad based on logic (only when needed)
                        gameController.showInterstitialAdIfNeeded()
                        // Oyunu yenidən başlatır / Restarts the game
                        gameController.restartGame()
                    },
                    onShowInterstitial: {
                        // Bu callback artıq istifadə olunmur / This callback is no longer used
                        // Reklam məntiqinə görə interstitial reklamı göstərir / Shows interstitial ad based on logic
                        gameController.showInterstitialAdIfNeeded()
                    },
                    onShowRewardedAd: {
                        // Rewarded reklamı göstərir və mükafat verir (interstitial yox) / Shows rewarded ad and grants reward (no interstitial)
                        gameController.showRewardedAd { bonusScore in
                            // Bonus xal əlavə edir / Adds bonus score
                            gameController.gameModel.score += bonusScore
                        }
                    },
                    onHome: {
                        // Reklam məntiqinə görə interstitial reklamı göstərir (yalnız lazım olduqda) / Shows interstitial ad based on logic (only when needed)
                        gameController.showInterstitialAdIfNeeded()
                        // Ana ekrana qayıdır / Returns to home screen
                        gameController.resetGame()
                    }
                )
            }
            
            // Countdown ekranı (oyun başlanğıcı) / Countdown screen (game start)
            if gameController.showCountdown {
                CountdownView(localizationModel: gameController.localizationModel) {
                    // Countdown bitdikdə oyunu başlatır / Starts game when countdown finishes
                    gameController.startGameAfterCountdown()
                }
            }
            
            // Ayarlar ekranı / Settings screen
            if gameController.showSettings {
                SettingsView(
                    settingsModel: gameController.settingsModel,
                    audioManager: gameController.audioManager,
                    localizationModel: gameController.localizationModel,
                    onClose: {
                        // Ayarları bağlayır / Closes settings
                        gameController.hideSettingsScreen()
                    }
                )
            }
            
            // Statistikalar ekranı / Statistics screen
            if gameController.showStatistics {
                StatisticsView(
                    statisticsModel: gameController.statisticsModel,
                    onClose: {
                        // Statistikaları bağlayır / Closes statistics
                        gameController.hideStatisticsScreen()
                    }
                )
            }
            
            // Tutorial ekranı / Tutorial screen
            if gameController.showTutorial {
                TutorialView {
                    // Tutorial-ı bağlayır / Closes tutorial
                    gameController.hideTutorialScreen()
                }
            }
            
            // Gündəlik challenge ekranı / Daily challenge screen
            if gameController.showDailyChallenge {
                DailyChallengeView(
                    challengeModel: gameController.dailyChallengeModel,
                    onClose: {
                        // Gündəlik challenge-ı bağlayır / Closes daily challenge
                        gameController.hideDailyChallengeScreen()
                    }
                )
            }
            
            // Achievements ekranı / Achievements screen
            if gameController.showAchievements {
                AchievementsView(
                    achievementModel: gameController.achievementModel,
                    onClose: {
                        // Achievements-ı bağlayır / Closes achievements
                        gameController.hideAchievementsScreen()
                    }
                )
            }
            
            // Quş seçimi ekranı / Bird selection screen
            if gameController.showBirdSelection {
                BirdSelectionView(
                    birdTypeModel: gameController.birdTypeModel,
                    onClose: {
                        // Quş seçimini bağlayır / Closes bird selection
                        gameController.hideBirdSelectionScreen()
                    }
                )
            }
            
            // Mühit seçimi ekranı / Environment selection screen
            if gameController.showEnvironmentSelection {
                EnvironmentSelectionView(
                    environmentModel: gameController.environmentModel,
                    onClose: {
                        // Mühit seçimini bağlayır / Closes environment selection
                        gameController.hideEnvironmentSelectionScreen()
                    }
                )
            }
        }
        .onAppear {
            // Oyun bitməsi notification-ını dinləyir / Listens to game over notification
            notificationObserver = NotificationCenter.default.addObserver(
                forName: .gameOver,
                object: nil,
                queue: .main
            ) { [weak gameController] notification in
                // Weak reference istifadə edir ki, memory leak olmasın / Uses weak reference to prevent memory leak
                guard let gameController = gameController else { return }
                // Oyun vaxtını və boru sayını alır / Gets play time and pipes passed
                let playTime = notification.userInfo?["playTime"] as? TimeInterval ?? 0
                let pipesPassed = notification.userInfo?["pipesPassed"] as? Int ?? 0
                // Oyun bitdikdə callback-i çağırır / Calls callback when game ends
                gameController.handleGameOver(playTime: playTime, pipesPassed: pipesPassed)
            }
            
            // Background musiqisini başlatır / Starts background music
            gameController.audioManager.playBackgroundMusic()
        }
        .onDisappear {
            // Notification observer-ı silir (memory leak qarşısını alır) / Removes notification observer (prevents memory leak)
            if let observer = notificationObserver {
                NotificationCenter.default.removeObserver(observer)
                notificationObserver = nil
            }
        }
    }
}

#Preview {
    ContentView()
}
