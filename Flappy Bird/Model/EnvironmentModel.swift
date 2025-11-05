//
//  EnvironmentModel.swift
//  Flappy Bird
//
//  Mühit modeli - fərqli mühitlər (gecə/gündüz, mövsümlər)
//  Environment Model - different environments (night/day, seasons)
//

import Foundation
import Combine
import SwiftUI

/// Mühit tipi / Environment type
enum EnvironmentType: String, Codable, CaseIterable {
    case day = "day"                // Gündüz / Day
    case night = "night"            // Gecə / Night
    case sunset = "sunset"          // Gün batımı / Sunset
    case winter = "winter"          // Qış / Winter
    case spring = "spring"          // Yaz / Spring
    case summer = "summer"          // Yay / Summer
    case autumn = "autumn"          // Payız / Autumn
    case space = "space"            // Kosmos / Space
}

/// Mühit modeli / Environment Model
class EnvironmentModel: ObservableObject {
    // MARK: - Published Properties / Nəşr edilən xassələr
    
    @Published var selectedEnvironment: EnvironmentType = .day
    @Published var unlockedEnvironments: Set<EnvironmentType> = [.day]  // Gündüz başdan açıqdır / Day is unlocked by default
    
    // MARK: - Constants / Sabitlər
    
    private let selectedEnvironmentKey = "selectedEnvironment"
    private let unlockedEnvironmentsKey = "unlockedEnvironments"
    
    // MARK: - Initialization / İnitializasiya
    
    init() {
        // Seçilmiş mühiti yükləyir / Loads selected environment
        loadSelectedEnvironment()
        // Açılmış mühitləri yükləyir / Loads unlocked environments
        loadUnlockedEnvironments()
    }
    
    // MARK: - Environment Management / Mühit idarəetməsi
    
    /// Seçilmiş mühiti yükləyir / Loads selected environment
    private func loadSelectedEnvironment() {
        if let rawValue = UserDefaults.standard.string(forKey: selectedEnvironmentKey),
           let type = EnvironmentType(rawValue: rawValue) {
            selectedEnvironment = type
        }
    }
    
    /// Açılmış mühitləri yükləyir / Loads unlocked environments
    private func loadUnlockedEnvironments() {
        if let data = UserDefaults.standard.array(forKey: unlockedEnvironmentsKey) as? [String] {
            unlockedEnvironments = Set(data.compactMap { EnvironmentType(rawValue: $0) })
        }
    }
    
    /// Mühiti seçir / Selects environment
    func selectEnvironment(_ type: EnvironmentType) {
        // Yalnız açılmış mühitləri seçə bilər / Can only select unlocked environments
        guard unlockedEnvironments.contains(type) else { return }
        
        selectedEnvironment = type
        // Yaddaşa yazır / Saves to storage
        UserDefaults.standard.set(type.rawValue, forKey: selectedEnvironmentKey)
    }
    
    /// Mühiti açır / Unlocks environment
    func unlockEnvironment(_ type: EnvironmentType) {
        unlockedEnvironments.insert(type)
        // Yaddaşa yazır / Saves to storage
        let array = Array(unlockedEnvironments).map { $0.rawValue }
        UserDefaults.standard.set(array, forKey: unlockedEnvironmentsKey)
    }
    
    /// Mühitin açılıb-açılmadığını yoxlayır / Checks if environment is unlocked
    func isUnlocked(_ type: EnvironmentType) -> Bool {
        return unlockedEnvironments.contains(type)
    }
}

/// Mühit məlumatı / Environment Information
struct EnvironmentInfo {
    let type: EnvironmentType
    let name: String
    let description: String
    let backgroundColor: Color
    let gradientColors: [Color]
    let unlockRequirement: String
    
    /// Mühit məlumatını qaytarır / Returns environment information
    static func info(for type: EnvironmentType) -> EnvironmentInfo {
        switch type {
        case .day:
            return EnvironmentInfo(
                type: .day,
                name: "Gündüz",
                description: "Günəşli gün",
                backgroundColor: Color(red: 0.5, green: 0.8, blue: 1.0),
                gradientColors: [
                    Color(red: 0.5, green: 0.8, blue: 1.0),
                    Color(red: 0.7, green: 0.9, blue: 1.0)
                ],
                unlockRequirement: "Başlanğıc"
            )
        case .night:
            return EnvironmentInfo(
                type: .night,
                name: "Gecə",
                description: "Ulduzlu gecə",
                backgroundColor: Color(red: 0.1, green: 0.1, blue: 0.3),
                gradientColors: [
                    Color(red: 0.1, green: 0.1, blue: 0.3),
                    Color(red: 0.2, green: 0.2, blue: 0.4)
                ],
                unlockRequirement: "10 oyun tamamla"
            )
        case .sunset:
            return EnvironmentInfo(
                type: .sunset,
                name: "Gün Batımı",
                description: "Gözəl gün batımı",
                backgroundColor: Color(red: 1.0, green: 0.6, blue: 0.4),
                gradientColors: [
                    Color(red: 1.0, green: 0.6, blue: 0.4),
                    Color(red: 0.8, green: 0.4, blue: 0.6)
                ],
                unlockRequirement: "25 oyun tamamla"
            )
        case .winter:
            return EnvironmentInfo(
                type: .winter,
                name: "Qış",
                description: "Qarlı qış",
                backgroundColor: Color(red: 0.9, green: 0.95, blue: 1.0),
                gradientColors: [
                    Color(red: 0.9, green: 0.95, blue: 1.0),
                    Color(red: 0.8, green: 0.9, blue: 1.0)
                ],
                unlockRequirement: "50 oyun tamamla"
            )
        case .spring:
            return EnvironmentInfo(
                type: .spring,
                name: "Yaz",
                description: "Çiçəkli yaz",
                backgroundColor: Color(red: 0.8, green: 1.0, blue: 0.8),
                gradientColors: [
                    Color(red: 0.8, green: 1.0, blue: 0.8),
                    Color(red: 0.9, green: 1.0, blue: 0.9)
                ],
                unlockRequirement: "75 oyun tamamla"
            )
        case .summer:
            return EnvironmentInfo(
                type: .summer,
                name: "Yay",
                description: "Günəşli yay",
                backgroundColor: Color(red: 1.0, green: 0.9, blue: 0.6),
                gradientColors: [
                    Color(red: 1.0, green: 0.9, blue: 0.6),
                    Color(red: 1.0, green: 0.95, blue: 0.8)
                ],
                unlockRequirement: "100 oyun tamamla"
            )
        case .autumn:
            return EnvironmentInfo(
                type: .autumn,
                name: "Payız",
                description: "Payız rəngləri",
                backgroundColor: Color(red: 0.9, green: 0.7, blue: 0.4),
                gradientColors: [
                    Color(red: 0.9, green: 0.7, blue: 0.4),
                    Color(red: 0.8, green: 0.6, blue: 0.3)
                ],
                unlockRequirement: "150 oyun tamamla"
            )
        case .space:
            return EnvironmentInfo(
                type: .space,
                name: "Kosmos",
                description: "Kosmos səyahəti",
                backgroundColor: Color(red: 0.1, green: 0.05, blue: 0.2),
                gradientColors: [
                    Color(red: 0.1, green: 0.05, blue: 0.2),
                    Color(red: 0.2, green: 0.1, blue: 0.3)
                ],
                unlockRequirement: "500 xal qazan"
            )
        }
    }
}

