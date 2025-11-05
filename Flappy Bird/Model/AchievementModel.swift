//
//  AchievementModel.swift
//  Flappy Bird
//
//  Achievement modeli - nailiyyətlər sistemi
//  Achievement Model - achievements system
//

import Foundation
import Combine
import SwiftUI

/// Achievement tipi / Achievement type
enum AchievementType: String, Codable, CaseIterable {
    case firstScore = "first_score"              // İlk xal / First score
    case score10 = "score_10"                   // 10 xal / 10 points
    case score50 = "score_50"                   // 50 xal / 50 points
    case score100 = "score_100"                 // 100 xal / 100 points
    case score500 = "score_500"                 // 500 xal / 500 points
    case score1000 = "score_1000"               // 1000 xal / 1000 points
    case play10Games = "play_10_games"          // 10 oyun oyna / Play 10 games
    case play50Games = "play_50_games"          // 50 oyun oyna / Play 50 games
    case play100Games = "play_100_games"        // 100 oyun oyna / Play 100 games
    case perfectGame = "perfect_game"           // Mükəmməl oyun / Perfect game
    case noPowerUpWin = "no_powerup_win"        // Power-up olmadan qazan / Win without power-ups
    case dailyChallengeComplete = "daily_challenge"  // Gündəlik challenge tamamla / Complete daily challenge
}

/// Achievement modeli / Achievement Model
class AchievementModel: ObservableObject {
    // MARK: - Published Properties / Nəşr edilən xassələr
    
    @Published var completedAchievements: Set<AchievementType> = []
    
    // MARK: - Constants / Sabitlər
    
    private let achievementsKey = "completedAchievements"
    
    // MARK: - Initialization / İnitializasiya
    
    init() {
        // Tamamlanmış achievement-ləri yükləyir / Loads completed achievements
        loadAchievements()
    }
    
    // MARK: - Achievement Management / Achievement idarəetməsi
    
    /// Achievement-ləri yükləyir / Loads achievements
    private func loadAchievements() {
        if let data = UserDefaults.standard.array(forKey: achievementsKey) as? [String] {
            completedAchievements = Set(data.compactMap { AchievementType(rawValue: $0) })
        }
    }
    
    /// Achievement-i yaddaşa yazır / Saves achievement to storage
    private func saveAchievements() {
        let array = Array(completedAchievements).map { $0.rawValue }
        UserDefaults.standard.set(array, forKey: achievementsKey)
    }
    
    /// Achievement-i tamamlandı kimi qeyd edir / Marks achievement as completed
    func completeAchievement(_ type: AchievementType) {
        guard !completedAchievements.contains(type) else { return }
        
        completedAchievements.insert(type)
        saveAchievements()
        
        // Notification göndərir / Sends notification
        NotificationCenter.default.post(
            name: NSNotification.Name("AchievementUnlocked"),
            object: nil,
            userInfo: ["achievement": type]
        )
    }
    
    /// Achievement-in tamamlanıb-tamamlanmadığını yoxlayır / Checks if achievement is completed
    func isCompleted(_ type: AchievementType) -> Bool {
        return completedAchievements.contains(type)
    }
    
    /// Achievement-ləri yoxlayır və tamamlananları qeyd edir / Checks achievements and marks completed ones
    func checkAchievements(score: Int, gamesPlayed: Int, dailyChallengeCompleted: Bool) {
        // Xal achievement-ləri / Score achievements
        if score >= 10 && !isCompleted(.score10) {
            completeAchievement(.score10)
        }
        if score >= 50 && !isCompleted(.score50) {
            completeAchievement(.score50)
        }
        if score >= 100 && !isCompleted(.score100) {
            completeAchievement(.score100)
        }
        if score >= 500 && !isCompleted(.score500) {
            completeAchievement(.score500)
        }
        if score >= 1000 && !isCompleted(.score1000) {
            completeAchievement(.score1000)
        }
        
        // İlk xal / First score
        if score > 0 && !isCompleted(.firstScore) {
            completeAchievement(.firstScore)
        }
        
        // Oyun sayı achievement-ləri / Games played achievements
        if gamesPlayed >= 10 && !isCompleted(.play10Games) {
            completeAchievement(.play10Games)
        }
        if gamesPlayed >= 50 && !isCompleted(.play50Games) {
            completeAchievement(.play50Games)
        }
        if gamesPlayed >= 100 && !isCompleted(.play100Games) {
            completeAchievement(.play100Games)
        }
        
        // Gündəlik challenge / Daily challenge
        if dailyChallengeCompleted && !isCompleted(.dailyChallengeComplete) {
            completeAchievement(.dailyChallengeComplete)
        }
    }
}

/// Achievement məlumatı / Achievement Information
struct AchievementInfo {
    let type: AchievementType
    let name: String
    let description: String
    let icon: String
    let color: Color
    
    /// Achievement məlumatını qaytarır / Returns achievement information
    static func info(for type: AchievementType) -> AchievementInfo {
        switch type {
        case .firstScore:
            return AchievementInfo(
                type: .firstScore,
                name: "İlk Xal",
                description: "İlk xalınızı qazanın",
                icon: "star.fill",
                color: .yellow
            )
        case .score10:
            return AchievementInfo(
                type: .score10,
                name: "Başlanğıc",
                description: "10 xal qazan",
                icon: "1.circle.fill",
                color: .green
            )
        case .score50:
            return AchievementInfo(
                type: .score50,
                name: "Təcrübəli",
                description: "50 xal qazan",
                icon: "5.circle.fill",
                color: .blue
            )
        case .score100:
            return AchievementInfo(
                type: .score100,
                name: "Məharətli",
                description: "100 xal qazan",
                icon: "100.circle.fill",
                color: .purple
            )
        case .score500:
            return AchievementInfo(
                type: .score500,
                name: "Usta",
                description: "500 xal qazan",
                icon: "crown.fill",
                color: .orange
            )
        case .score1000:
            return AchievementInfo(
                type: .score1000,
                name: "Əfsanə",
                description: "1000 xal qazan",
                icon: "star.circle.fill",
                color: .red
            )
        case .play10Games:
            return AchievementInfo(
                type: .play10Games,
                name: "Həvəskar",
                description: "10 oyun oyna",
                icon: "gamecontroller.fill",
                color: .cyan
            )
        case .play50Games:
            return AchievementInfo(
                type: .play50Games,
                name: "Dedikasiya",
                description: "50 oyun oyna",
                icon: "gamecontroller.fill",
                color: .indigo
            )
        case .play100Games:
            return AchievementInfo(
                type: .play100Games,
                name: "Fanatik",
                description: "100 oyun oyna",
                icon: "gamecontroller.fill",
                color: .pink
            )
        case .perfectGame:
            return AchievementInfo(
                type: .perfectGame,
                name: "Mükəmməl",
                description: "Mükəmməl oyun oyna",
                icon: "checkmark.seal.fill",
                color: .yellow
            )
        case .noPowerUpWin:
            return AchievementInfo(
                type: .noPowerUpWin,
                name: "Təmiz Qələbə",
                description: "Power-up olmadan qazan",
                icon: "shield.fill",
                color: .white
            )
        case .dailyChallengeComplete:
            return AchievementInfo(
                type: .dailyChallengeComplete,
                name: "Gündəlik Məşq",
                description: "Gündəlik challenge tamamla",
                icon: "calendar",
                color: .orange
            )
        }
    }
}

