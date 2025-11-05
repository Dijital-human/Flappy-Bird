//
//  SettingsModel.swift
//  Flappy Bird
//
//  Ayarlar modeli - oyun ayarlarını idarə edir
//  Settings Model - manages game settings
//

import Foundation
import Combine

/// Ayarlar modeli - oyun ayarlarını idarə edir
/// Settings Model - manages game settings
class SettingsModel: ObservableObject {
    // MARK: - Published Properties / Nəşr edilən xassələr
    
    @Published var soundEnabled: Bool = true {
        didSet {
            // Ses ayarını yaddaşa yazır / Saves sound setting to storage
            UserDefaults.standard.set(soundEnabled, forKey: "soundEnabled")
        }
    }
    
    @Published var musicEnabled: Bool = true {
        didSet {
            // Musiqi ayarını yaddaşa yazır / Saves music setting to storage
            UserDefaults.standard.set(musicEnabled, forKey: "musicEnabled")
        }
    }
    
    @Published var hapticEnabled: Bool = true {
        didSet {
            // Haptic ayarını yaddaşa yazır / Saves haptic setting to storage
            UserDefaults.standard.set(hapticEnabled, forKey: "hapticEnabled")
        }
    }
    
    @Published var darkModeEnabled: Bool = false {
        didSet {
            // Dark mode ayarını yaddaşa yazır / Saves dark mode setting to storage
            UserDefaults.standard.set(darkModeEnabled, forKey: "darkModeEnabled")
        }
    }
    
    @Published var weatherEffectsEnabled: Bool = true {
        didSet {
            // Hava effektləri ayarını yaddaşa yazır / Saves weather effects setting to storage
            UserDefaults.standard.set(weatherEffectsEnabled, forKey: "weatherEffectsEnabled")
        }
    }
    
    // MARK: - UserDefaults Keys / UserDefaults açarı
    
    private let soundEnabledKey = "soundEnabled"
    private let musicEnabledKey = "musicEnabled"
    private let hapticEnabledKey = "hapticEnabled"
    private let darkModeEnabledKey = "darkModeEnabled"
    private let weatherEffectsEnabledKey = "weatherEffectsEnabled"
    
    // MARK: - Initialization / İnitializasiya
    
    init() {
        // Ayarları yaddaşdan yükləyir / Loads settings from storage
        loadSettings()
    }
    
    // MARK: - Settings Management / Ayarlar idarəetməsi
    
    /// Ayarları yaddaşdan yükləyir / Loads settings from storage
    func loadSettings() {
        // UserDefaults-dan ayarları oxuyur / Reads settings from UserDefaults
        soundEnabled = UserDefaults.standard.object(forKey: soundEnabledKey) as? Bool ?? true
        musicEnabled = UserDefaults.standard.object(forKey: musicEnabledKey) as? Bool ?? true
        hapticEnabled = UserDefaults.standard.object(forKey: hapticEnabledKey) as? Bool ?? true
        darkModeEnabled = UserDefaults.standard.object(forKey: darkModeEnabledKey) as? Bool ?? false
        weatherEffectsEnabled = UserDefaults.standard.object(forKey: weatherEffectsEnabledKey) as? Bool ?? true
    }
}

