//
//  PowerUpModel.swift
//  Flappy Bird
//
//  Power-up modeli - müvəqqəti qabiliyyətlər
//  Power-up Model - temporary abilities
//

import Foundation
import Combine
import SwiftUI

/// Power-up tipi / Power-up type
enum PowerUpType: String, Codable {
    case shield = "shield"              // Qoruma - müvəqqəti zədəsizlik / Shield - temporary invincibility
    case slowMotion = "slow_motion"     // Yavaş hərəkət - borular yavaş hərəkət edir / Slow motion - pipes move slowly
    case bonusScore = "bonus_score"    // Bonus xal - ikili xal / Bonus score - double score
    case magnet = "magnet"             // Maqnit - boruları cəlb edir / Magnet - attracts pipes
}

/// Power-up modeli / Power-up Model
class PowerUpModel: ObservableObject {
    // MARK: - Published Properties / Nəşr edilən xassələr
    
    @Published var activePowerUps: [ActivePowerUp] = []
    @Published var availablePowerUps: [PowerUpType] = []
    
    // MARK: - Constants / Sabitlər
    
    private let powerUpDuration: TimeInterval = 5.0  // Power-up müddəti (saniyə) / Power-up duration (seconds)
    
    // MARK: - Initialization / İnitializasiya
    
    init() {
        // Mövcud power-up-ları yükləyir / Loads available power-ups
        loadAvailablePowerUps()
    }
    
    // MARK: - Power-up Management / Power-up idarəetməsi
    
    /// Mövcud power-up-ları yükləyir / Loads available power-ups
    private func loadAvailablePowerUps() {
        // İlkin olaraq bütün power-up-lar mövcuddur / Initially all power-ups are available
        availablePowerUps = [.shield, .slowMotion, .bonusScore, .magnet]
    }
    
    /// Power-up aktivləşdirir / Activates power-up
    func activate(_ type: PowerUpType) {
        // Aktivləşdirilmiş power-up-i yoxlayır / Checks if already activated
        if activePowerUps.contains(where: { $0.type == type }) {
            // Əgər artıq aktivdirsə, müddətini uzatır / If already active, extends duration
            if let index = activePowerUps.firstIndex(where: { $0.type == type }) {
                activePowerUps[index].endTime = Date().addingTimeInterval(powerUpDuration)
            }
            return
        }
        
        // Yeni power-up aktivləşdirir / Activates new power-up
        let powerUp = ActivePowerUp(
            type: type,
            startTime: Date(),
            endTime: Date().addingTimeInterval(powerUpDuration)
        )
        
        activePowerUps.append(powerUp)
        
        // Timer yoxlayır / Checks timer
        checkPowerUps()
    }
    
    /// Power-up-in aktiv olub-olmadığını yoxlayır / Checks if power-up is active
    func isActive(_ type: PowerUpType) -> Bool {
        return activePowerUps.contains { powerUp in
            powerUp.type == type && powerUp.endTime > Date()
        }
    }
    
    /// Power-up-ləri yoxlayır və müddəti bitənləri silir / Checks power-ups and removes expired ones
    func checkPowerUps() {
        let now = Date()
        activePowerUps.removeAll { $0.endTime <= now }
    }
    
    /// Power-up-in qalan müddətini qaytarır / Returns remaining time of power-up
    func remainingTime(for type: PowerUpType) -> TimeInterval {
        guard let powerUp = activePowerUps.first(where: { $0.type == type }) else {
            return 0
        }
        
        let remaining = powerUp.endTime.timeIntervalSinceNow
        return max(0, remaining)
    }
    
    /// Bütün power-up-ləri deaktivləşdirir / Deactivates all power-ups
    func deactivateAll() {
        activePowerUps.removeAll()
    }
}

/// Aktiv power-up struktur / Active Power-up Structure
struct ActivePowerUp: Identifiable, Equatable {
    let id = UUID()
    let type: PowerUpType
    let startTime: Date
    var endTime: Date
}

/// Power-up məlumatı / Power-up Information
struct PowerUpInfo {
    let type: PowerUpType
    let name: String
    let description: String
    let icon: String
    let color: Color
    
    /// Power-up məlumatını qaytarır / Returns power-up information
    static func info(for type: PowerUpType) -> PowerUpInfo {
        switch type {
        case .shield:
            return PowerUpInfo(
                type: .shield,
                name: "Qoruma",
                description: "Müvəqqəti zədəsiзlik",
                icon: "shield.fill",
                color: .blue
            )
        case .slowMotion:
            return PowerUpInfo(
                type: .slowMotion,
                name: "Yavaş Hərəkət",
                description: "Borular yavaş hərəkət edir",
                icon: "timer",
                color: .purple
            )
        case .bonusScore:
            return PowerUpInfo(
                type: .bonusScore,
                name: "Bonus Xal",
                description: "İkili xal qazanın",
                icon: "star.fill",
                color: .yellow
            )
        case .magnet:
            return PowerUpInfo(
                type: .magnet,
                name: "Maqnit",
                description: "Boruları cəlb edir",
                icon: "magnet",
                color: .red
            )
        }
    }
}

