//
//  LocalizationModel.swift
//  Flappy Bird
//
//  Localization modeli - çoxdilli dəstək
//  Localization Model - multilingual support
//

import Foundation
import Combine
import SwiftUI

/// Dil tipi / Language type
enum Language: String, Codable, CaseIterable {
    case az = "az"  // Azərbaycan dili / Azerbaijani
    case en = "en"  // İngilis dili / English
    case ru = "ru"  // Rus dili / Russian
    case tr = "tr"  // Türk dili / Turkish
    
    /// Dilin görünüş adı / Display name of language
    var displayName: String {
        switch self {
        case .az: return "AZ"
        case .en: return "EN"
        case .ru: return "RU"
        case .tr: return "TR"
        }
    }
}

/// Localization modeli / Localization Model
class LocalizationModel: ObservableObject {
    // MARK: - Published Properties / Nəşr edilən xassələr
    
    @Published var currentLanguage: Language = .az
    
    // MARK: - Constants / Sabitlər
    
    private let languageKey = "selectedLanguage"
    
    // MARK: - Initialization / İnitializasiya
    
    init() {
        // Seçilmiş dili yükləyir / Loads selected language
        loadLanguage()
    }
    
    // MARK: - Language Management / Dil idarəetməsi
    
    /// Dili yükləyir / Loads language
    private func loadLanguage() {
        if let rawValue = UserDefaults.standard.string(forKey: languageKey),
           let language = Language(rawValue: rawValue) {
            currentLanguage = language
        } else {
            // Sistem dilini yoxlayır / Checks system language
            if let systemLanguage = Locale.current.languageCode {
                switch systemLanguage {
                case "az":
                    currentLanguage = .az
                case "en":
                    currentLanguage = .en
                case "ru":
                    currentLanguage = .ru
                case "tr":
                    currentLanguage = .tr
                default:
                    currentLanguage = .az
                }
            }
        }
    }
    
    /// Dili seçir / Selects language
    func selectLanguage(_ language: Language) {
        currentLanguage = language
        // Yaddaşa yazır / Saves to storage
        UserDefaults.standard.set(language.rawValue, forKey: languageKey)
    }
    
    /// Mətni tərcümə edir / Translates text
    func translate(_ key: String) -> String {
        return LocalizedStrings.string(for: key, language: currentLanguage)
    }
}

/// Localized strings / Tərcümə olunmuş mətnlər
struct LocalizedStrings {
    /// Mətni tərcümə edir / Translates text
    static func string(for key: String, language: Language) -> String {
        let strings: [Language: [String: String]] = [
            .az: [
                "start_game": "Oyunu Başlat",
                "start_game_btn": "OYUNU BAŞLAT",
                "high_score": "Yüksək Skor",
                "best_score": "Best Score",
                "score": "Skor",
                "your_score": "Sizin Skor",
                "game_over": "Oyun Bitdi",
                "pause": "Pause",
                "resume": "Davam Et",
                "home": "Ev",
                "restart": "Yenidən Başlat",
                "play_again": "Yenidən Oyna",
                "settings": "Ayarlar",
                "statistics": "Statistikalar",
                "achievements": "Nailiyyətlər",
                "daily_challenge": "Gündəlik Challenge",
                "power_ups": "Power-up-lar",
                "bird_types": "Quş Növləri",
                "environments": "Mühitlər",
                "tutorial": "Təlimat",
                "share": "Paylaş",
                "sound": "Səs",
                "sound_effects": "Səs Effektləri",
                "music": "Musiqi",
                "background_music": "Arxa Plan Musiqisi",
                "haptics": "Haptic Feedback",
                "haptic_feedback": "Haptic Feedback",
                "language": "Dil",
                "new_record": "Yeni Rekord!",
                "tap_to_fly": "Uçmaq üçün toxun",
                "best_streak": "Ən Yaxşı Seriya",
                "total_games": "Ümumi Oyunlar",
                "average_score": "Orta Skor",
                "longest_game": "Ən Uzun Oyun",
                "watch_ad_for_bonus": "Reklam İzlə və Bonus Qazan",
                "flappy": "FLAPPY",
                "bird": "BIRD",
                "close": "Bağla",
                "weather_effects": "Hava Effektləri",
                "dark_mode": "Qaranlıq Rejim",
                "go": "Başla!"
            ],
            .en: [
                "start_game": "Start Game",
                "start_game_btn": "START GAME",
                "high_score": "High Score",
                "best_score": "Best Score",
                "score": "Score",
                "your_score": "Your Score",
                "game_over": "Game Over",
                "pause": "Pause",
                "resume": "Resume",
                "home": "Home",
                "restart": "Restart",
                "play_again": "Play Again",
                "settings": "Settings",
                "statistics": "Statistics",
                "achievements": "Achievements",
                "daily_challenge": "Daily Challenge",
                "power_ups": "Power-ups",
                "bird_types": "Bird Types",
                "environments": "Environments",
                "tutorial": "Tutorial",
                "share": "Share",
                "sound": "Sound",
                "sound_effects": "Sound Effects",
                "music": "Music",
                "background_music": "Background Music",
                "haptics": "Haptic Feedback",
                "haptic_feedback": "Haptic Feedback",
                "language": "Language",
                "new_record": "New Record!",
                "tap_to_fly": "Tap to Fly",
                "best_streak": "Best Streak",
                "total_games": "Total Games",
                "average_score": "Average Score",
                "longest_game": "Longest Game",
                "watch_ad_for_bonus": "Watch Ad for Bonus Score",
                "flappy": "FLAPPY",
                "bird": "BIRD",
                "close": "Close",
                "weather_effects": "Weather Effects",
                "dark_mode": "Dark Mode",
                "go": "GO!"
            ],
            .ru: [
                "start_game": "Начать игру",
                "start_game_btn": "НАЧАТЬ ИГРУ",
                "high_score": "Рекорд",
                "best_score": "Лучший счёт",
                "score": "Счёт",
                "your_score": "Ваш счёт",
                "game_over": "Игра окончена",
                "pause": "Пауза",
                "resume": "Продолжить",
                "home": "Домой",
                "restart": "Перезапуск",
                "play_again": "Играть снова",
                "settings": "Настройки",
                "statistics": "Статистика",
                "achievements": "Достижения",
                "daily_challenge": "Ежедневное задание",
                "power_ups": "Усиления",
                "bird_types": "Типы птиц",
                "environments": "Окружения",
                "tutorial": "Обучение",
                "share": "Поделиться",
                "sound": "Звук",
                "sound_effects": "Звуковые эффекты",
                "music": "Музыка",
                "background_music": "Фоновая музыка",
                "haptics": "Тактильная обратная связь",
                "haptic_feedback": "Тактильная обратная связь",
                "language": "Язык",
                "new_record": "Новый рекорд!",
                "tap_to_fly": "Нажмите, чтобы летать",
                "best_streak": "Лучшая серия",
                "total_games": "Всего игр",
                "average_score": "Средний счёт",
                "longest_game": "Самая длинная игра",
                "watch_ad_for_bonus": "Смотреть рекламу за бонус",
                "flappy": "FLAPPY",
                "bird": "BIRD",
                "close": "Закрыть",
                "weather_effects": "Погодные эффекты",
                "dark_mode": "Тёмный режим",
                "go": "ВПЕРЁД!"
            ],
            .tr: [
                "start_game": "Oyunu Başlat",
                "start_game_btn": "OYUNU BAŞLAT",
                "high_score": "Yüksek Skor",
                "best_score": "En İyi Skor",
                "score": "Skor",
                "your_score": "Skorunuz",
                "game_over": "Oyun Bitti",
                "pause": "Duraklat",
                "resume": "Devam Et",
                "home": "Ana Sayfa",
                "restart": "Yeniden Başlat",
                "play_again": "Tekrar Oyna",
                "settings": "Ayarlar",
                "statistics": "İstatistikler",
                "achievements": "Başarımlar",
                "daily_challenge": "Günlük Görev",
                "power_ups": "Güçlendirmeler",
                "bird_types": "Kuş Türleri",
                "environments": "Ortamlar",
                "tutorial": "Eğitim",
                "share": "Paylaş",
                "sound": "Ses",
                "sound_effects": "Ses Efektleri",
                "music": "Müzik",
                "background_music": "Arka Plan Müziği",
                "haptics": "Dokunsal Geri Bildirim",
                "haptic_feedback": "Dokunsal Geri Bildirim",
                "language": "Dil",
                "new_record": "Yeni Rekor!",
                "tap_to_fly": "Uçmak için dokun",
                "best_streak": "En İyi Seri",
                "total_games": "Toplam Oyun",
                "average_score": "Ortalama Skor",
                "longest_game": "En Uzun Oyun",
                "watch_ad_for_bonus": "Reklam İzle ve Bonus Kazan",
                "flappy": "FLAPPY",
                "bird": "BIRD",
                "close": "Kapat",
                "weather_effects": "Hava Efektleri",
                "dark_mode": "Karanlık Mod",
                "go": "BAŞLA!"
            ]
        ]
        
        return strings[language]?[key] ?? key
    }
}

