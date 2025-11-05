//
//  BirdTypeModel.swift
//  Flappy Bird
//
//  Quş növü modeli - fərqli quş növləri
//  Bird Type Model - different bird types
//

import Foundation
import Combine
import SwiftUI

/// Quş növü / Bird type
enum BirdType: String, Codable, CaseIterable {
    case classic = "classic"        // Klassik sarı quş / Classic yellow bird
    case red = "red"                // Qırmızı quş / Red bird
    case blue = "blue"              // Mavi quş / Blue bird
    case green = "green"            // Yaşıl quş / Green bird
    case purple = "purple"          // Bənövşəyi quş / Purple bird
    case rainbow = "rainbow"       // Göy quşağı quş / Rainbow bird
}

/// Quş növü modeli / Bird Type Model
class BirdTypeModel: ObservableObject {
    // MARK: - Published Properties / Nəşr edilən xassələr
    
    @Published var selectedBirdType: BirdType = .classic
    @Published var unlockedBirdTypes: Set<BirdType> = [.classic]  // Klassik quş başdan açıqdır / Classic bird is unlocked by default
    
    // MARK: - Constants / Sabitlər
    
    private let selectedBirdKey = "selectedBirdType"
    private let unlockedBirdsKey = "unlockedBirdTypes"
    
    // MARK: - Initialization / İnitializasiya
    
    init() {
        // Seçilmiş quş növünü yükləyir / Loads selected bird type
        loadSelectedBirdType()
        // Açılmış quş növlərini yükləyir / Loads unlocked bird types
        loadUnlockedBirdTypes()
    }
    
    // MARK: - Bird Type Management / Quş növü idarəetməsi
    
    /// Seçilmiş quş növünü yükləyir / Loads selected bird type
    private func loadSelectedBirdType() {
        if let rawValue = UserDefaults.standard.string(forKey: selectedBirdKey),
           let type = BirdType(rawValue: rawValue) {
            selectedBirdType = type
        }
    }
    
    /// Açılmış quş növlərini yükləyir / Loads unlocked bird types
    private func loadUnlockedBirdTypes() {
        if let data = UserDefaults.standard.array(forKey: unlockedBirdsKey) as? [String] {
            unlockedBirdTypes = Set(data.compactMap { BirdType(rawValue: $0) })
        }
    }
    
    /// Quş növünü seçir / Selects bird type
    func selectBirdType(_ type: BirdType) {
        // Yalnız açılmış quşları seçə bilər / Can only select unlocked birds
        guard unlockedBirdTypes.contains(type) else { return }
        
        selectedBirdType = type
        // Yaddaşa yazır / Saves to storage
        UserDefaults.standard.set(type.rawValue, forKey: selectedBirdKey)
    }
    
    /// Quş növünü açır / Unlocks bird type
    func unlockBirdType(_ type: BirdType) {
        unlockedBirdTypes.insert(type)
        // Yaddaşa yazır / Saves to storage
        let array = Array(unlockedBirdTypes).map { $0.rawValue }
        UserDefaults.standard.set(array, forKey: unlockedBirdsKey)
    }
    
    /// Quş növünün açılıb-açılmadığını yoxlayır / Checks if bird type is unlocked
    func isUnlocked(_ type: BirdType) -> Bool {
        return unlockedBirdTypes.contains(type)
    }
}

/// Quş növü məlumatı / Bird Type Information
struct BirdTypeInfo {
    let type: BirdType
    let name: String
    let description: String
    let color: Color
    let unlockRequirement: String
    
    /// Quş növü məlumatını qaytarır / Returns bird type information
    static func info(for type: BirdType) -> BirdTypeInfo {
        switch type {
        case .classic:
            return BirdTypeInfo(
                type: .classic,
                name: "Klassik",
                description: "Əsas quş",
                color: .yellow,
                unlockRequirement: "Başlanğıc"
            )
        case .red:
            return BirdTypeInfo(
                type: .red,
                name: "Qırmızı",
                description: "Qırmızı quş",
                color: .red,
                unlockRequirement: "50 xal qazan"
            )
        case .blue:
            return BirdTypeInfo(
                type: .blue,
                name: "Mavi",
                description: "Mavi quş",
                color: .blue,
                unlockRequirement: "100 xal qazan"
            )
        case .green:
            return BirdTypeInfo(
                type: .green,
                name: "Yaşıl",
                description: "Yaşıl quş",
                color: .green,
                unlockRequirement: "200 xal qazan"
            )
        case .purple:
            return BirdTypeInfo(
                type: .purple,
                name: "Bənövşəyi",
                description: "Bənövşəyi quş",
                color: .purple,
                unlockRequirement: "500 xal qazan"
            )
        case .rainbow:
            return BirdTypeInfo(
                type: .rainbow,
                name: "Göy Quşağı",
                description: "Xüsusi quş",
                color: .pink,
                unlockRequirement: "1000 xal qazan"
            )
        }
    }
}

