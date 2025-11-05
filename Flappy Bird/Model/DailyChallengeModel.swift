//
//  DailyChallengeModel.swift
//  Flappy Bird
//
//  Gündəlik challenge modeli - hər gün fərqli tapşırıq
//  Daily Challenge Model - different challenge each day
//

import Foundation
import Combine

/// Gündəlik challenge tipi / Daily challenge type
enum ChallengeType: String, Codable {
    case scoreTarget = "score_target"      // Xüsusi skor hədəfi / Specific score target
    case surviveTime = "survive_time"      // Müəyyən vaxt sağ qalmaq / Survive for specific time
    case passPipes = "pass_pipes"          // Müəyyən sayda boru keçmək / Pass specific number of pipes
    case noPowerUps = "no_power_ups"       // Power-up istifadə etmədən oynamaq / Play without power-ups
}

/// Gündəlik challenge modeli / Daily Challenge Model
class DailyChallengeModel: ObservableObject {
    // MARK: - Published Properties / Nəşr edilən xassələr
    
    @Published var currentChallenge: DailyChallenge?
    @Published var isCompleted: Bool = false
    @Published var progress: Double = 0.0
    
    // MARK: - Constants / Sabitlər
    
    private let challengeKey = "dailyChallenge"
    private let challengeDateKey = "dailyChallengeDate"
    private let challengeProgressKey = "dailyChallengeProgress"
    
    // MARK: - Initialization / İnitializasiya
    
    init() {
        // Yükləyir və ya yeni challenge yaradır / Loads or creates new challenge
        loadOrCreateChallenge()
    }
    
    // MARK: - Challenge Management / Challenge idarəetməsi
    
    /// Challenge yükləyir və ya yeni yaradır / Loads or creates new challenge
    private func loadOrCreateChallenge() {
        // Son challenge tarixini yoxlayır / Checks last challenge date
        let lastDate = UserDefaults.standard.string(forKey: challengeDateKey)
        let today = getTodayString()
        
        // Əgər bugünkü challenge yoxdursa, yeni yaradır / If today's challenge doesn't exist, creates new
        if lastDate != today {
            createNewChallenge()
        } else {
            // Bugünkü challenge-i yükləyir / Loads today's challenge
            loadChallenge()
        }
    }
    
    /// Bugünkü tarix string formatında / Today's date in string format
    private func getTodayString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
    
    /// Yeni challenge yaradır / Creates new challenge
    private func createNewChallenge() {
        // Təsadüfi challenge tipi seçir / Selects random challenge type
        let types: [ChallengeType] = [.scoreTarget, .surviveTime, .passPipes]
        let randomType = types.randomElement() ?? .scoreTarget
        
        // Challenge dəyərlərini təyin edir / Sets challenge values
        var targetValue: Int = 0
        switch randomType {
        case .scoreTarget:
            targetValue = Int.random(in: 20...50)
        case .surviveTime:
            targetValue = Int.random(in: 30...60) // Saniyə / Seconds
        case .passPipes:
            targetValue = Int.random(in: 10...25)
        case .noPowerUps:
            targetValue = 1
        }
        
        // Yeni challenge yaradır / Creates new challenge
        let challenge = DailyChallenge(
            type: randomType,
            targetValue: targetValue,
            date: getTodayString(),
            reward: calculateReward(for: randomType, target: targetValue)
        )
        
        currentChallenge = challenge
        isCompleted = false
        progress = 0.0
        
        // Yaddaşa yazır / Saves to storage
        saveChallenge()
    }
    
    /// Challenge-i yaddaşdan yükləyir / Loads challenge from storage
    private func loadChallenge() {
        guard let data = UserDefaults.standard.data(forKey: challengeKey),
              let challenge = try? JSONDecoder().decode(DailyChallenge.self, from: data) else {
            // Yükləyə bilmirsə, yeni yaradır / If can't load, creates new
            createNewChallenge()
            return
        }
        
        currentChallenge = challenge
        progress = UserDefaults.standard.double(forKey: challengeProgressKey)
        isCompleted = progress >= 1.0
    }
    
    /// Challenge-i yaddaşa yazır / Saves challenge to storage
    private func saveChallenge() {
        guard let challenge = currentChallenge else { return }
        
        if let data = try? JSONEncoder().encode(challenge) {
            UserDefaults.standard.set(data, forKey: challengeKey)
            UserDefaults.standard.set(challenge.date, forKey: challengeDateKey)
            UserDefaults.standard.set(progress, forKey: challengeProgressKey)
        }
    }
    
    /// Mükafatı hesablayır / Calculates reward
    private func calculateReward(for type: ChallengeType, target: Int) -> Int {
        // Challenge tipinə görə mükafat / Reward based on challenge type
        switch type {
        case .scoreTarget:
            return target * 2
        case .surviveTime:
            return target * 3
        case .passPipes:
            return target * 4
        case .noPowerUps:
            return 50
        }
    }
    
    /// Challenge irəliləməsini yeniləyir / Updates challenge progress
    func updateProgress(currentValue: Int) {
        guard let challenge = currentChallenge,
              !isCompleted else { return }
        
        // İrəliləməni hesablayır / Calculates progress
        let newProgress = min(Double(currentValue) / Double(challenge.targetValue), 1.0)
        progress = newProgress
        
        // Tamamlanıb yoxlayır / Checks if completed
        if newProgress >= 1.0 && !isCompleted {
            isCompleted = true
            // Mükafatı yaddaşa yazır / Saves reward
            let currentReward = UserDefaults.standard.integer(forKey: "dailyChallengeReward")
            UserDefaults.standard.set(currentReward + challenge.reward, forKey: "dailyChallengeReward")
        }
        
        // Yaddaşa yazır / Saves to storage
        UserDefaults.standard.set(progress, forKey: challengeProgressKey)
    }
    
    /// Challenge-i tamamlandı kimi qeyd edir / Marks challenge as completed
    func completeChallenge() {
        isCompleted = true
        progress = 1.0
        UserDefaults.standard.set(progress, forKey: challengeProgressKey)
    }
}

/// Gündəlik challenge struktur / Daily Challenge Structure
struct DailyChallenge: Codable {
    let type: ChallengeType
    let targetValue: Int
    let date: String
    let reward: Int
}

