//
//  StatisticsModel.swift
//  Flappy Bird
//
//  Statistikalar modeli - oyun statistikalarını idarə edir
//  Statistics Model - manages game statistics
//

import Foundation
import Combine

/// Statistikalar modeli - oyun statistikalarını idarə edir
/// Statistics Model - manages game statistics
class StatisticsModel: ObservableObject {
    // MARK: - Published Properties / Nəşr edilən xassələr
    
    @Published var totalGames: Int = 0
    @Published var totalScore: Int = 0
    @Published var averageScore: Double = 0.0
    @Published var maxScore: Int = 0
    @Published var bestStreak: Int = 0          // Ən yaxşı seriya / Best streak
    @Published var currentStreak: Int = 0       // Cari seriya / Current streak
    @Published var totalPlayTime: TimeInterval = 0  // Ümumi oyun vaxtı (saniyə) / Total play time (seconds)
    @Published var longestGame: TimeInterval = 0    // Ən uzun oyun (saniyə) / Longest game (seconds)
    @Published var totalPipesPassed: Int = 0    // Keçilən boru sayı / Total pipes passed
    
    // MARK: - UserDefaults Keys / UserDefaults açarı
    
    private let totalGamesKey = "totalGames"
    private let totalScoreKey = "totalScore"
    private let maxScoreKey = "maxScore"
    private let bestStreakKey = "bestStreak"
    private let currentStreakKey = "currentStreak"
    private let totalPlayTimeKey = "totalPlayTime"
    private let longestGameKey = "longestGame"
    private let totalPipesPassedKey = "totalPipesPassed"
    
    // MARK: - Initialization / İnitializasiya
    
    init() {
        // Statistikaları yaddaşdan yükləyir / Loads statistics from storage
        loadStatistics()
    }
    
    // MARK: - Statistics Management / Statistikalar idarəetməsi
    
    /// Statistikaları yaddaşdan yükləyir / Loads statistics from storage
    func loadStatistics() {
        // UserDefaults-dan statistikaları oxuyur / Reads statistics from UserDefaults
        totalGames = UserDefaults.standard.integer(forKey: totalGamesKey)
        totalScore = UserDefaults.standard.integer(forKey: totalScoreKey)
        maxScore = UserDefaults.standard.integer(forKey: maxScoreKey)
        bestStreak = UserDefaults.standard.integer(forKey: bestStreakKey)
        currentStreak = UserDefaults.standard.integer(forKey: currentStreakKey)
        totalPlayTime = UserDefaults.standard.double(forKey: totalPlayTimeKey)
        longestGame = UserDefaults.standard.double(forKey: longestGameKey)
        totalPipesPassed = UserDefaults.standard.integer(forKey: totalPipesPassedKey)
        
        // Orta skoru hesablayır / Calculates average score
        calculateAverageScore()
    }
    
    /// Oyun bitdikdən sonra statistikaları yeniləyir / Updates statistics after game ends
    func updateStatistics(score: Int, playTime: TimeInterval, pipesPassed: Int) {
        // Oyun sayını artırır / Increases game count
        totalGames += 1
        
        // Ümumi skoru artırır / Increases total score
        totalScore += score
        
        // Maksimum skoru yeniləyir / Updates max score
        if score > maxScore {
            maxScore = score
        }
        
        // Seriya yeniləməsi / Streak update
        if score > 0 {
            // Əgər xal varsa, seriyanı artırır / If has score, increases streak
            currentStreak += 1
            if currentStreak > bestStreak {
                bestStreak = currentStreak
            }
        } else {
            // Əgər xal yoxdursa, seriyanı sıfırlayır / If no score, resets streak
            currentStreak = 0
        }
        
        // Ümumi oyun vaxtını artırır / Increases total play time
        totalPlayTime += playTime
        
        // Ən uzun oyunu yeniləyir / Updates longest game
        if playTime > longestGame {
            longestGame = playTime
        }
        
        // Keçilən boru sayını artırır / Increases pipes passed count
        totalPipesPassed += pipesPassed
        
        // Orta skoru hesablayır / Calculates average score
        calculateAverageScore()
        
        // Statistikaları yaddaşa yazır / Saves statistics to storage
        saveStatistics()
    }
    
    /// Orta skoru hesablayır / Calculates average score
    private func calculateAverageScore() {
        if totalGames > 0 {
            // Orta skor = Ümumi skor / Oyun sayı / Average score = Total score / Game count
            averageScore = Double(totalScore) / Double(totalGames)
        } else {
            averageScore = 0.0
        }
    }
    
    /// Statistikaları yaddaşa yazır / Saves statistics to storage
    private func saveStatistics() {
        // UserDefaults-a statistikaları yazır / Writes statistics to UserDefaults
        UserDefaults.standard.set(totalGames, forKey: totalGamesKey)
        UserDefaults.standard.set(totalScore, forKey: totalScoreKey)
        UserDefaults.standard.set(maxScore, forKey: maxScoreKey)
        UserDefaults.standard.set(bestStreak, forKey: bestStreakKey)
        UserDefaults.standard.set(currentStreak, forKey: currentStreakKey)
        UserDefaults.standard.set(totalPlayTime, forKey: totalPlayTimeKey)
        UserDefaults.standard.set(longestGame, forKey: longestGameKey)
        UserDefaults.standard.set(totalPipesPassed, forKey: totalPipesPassedKey)
    }
    
    /// Statistikaları sıfırlayır / Resets statistics
    func resetStatistics() {
        totalGames = 0
        totalScore = 0
        averageScore = 0.0
        maxScore = 0
        bestStreak = 0
        currentStreak = 0
        totalPlayTime = 0
        longestGame = 0
        totalPipesPassed = 0
        
        // Statistikaları yaddaşdan silir / Removes statistics from storage
        UserDefaults.standard.removeObject(forKey: totalGamesKey)
        UserDefaults.standard.removeObject(forKey: totalScoreKey)
        UserDefaults.standard.removeObject(forKey: maxScoreKey)
        UserDefaults.standard.removeObject(forKey: bestStreakKey)
        UserDefaults.standard.removeObject(forKey: currentStreakKey)
        UserDefaults.standard.removeObject(forKey: totalPlayTimeKey)
        UserDefaults.standard.removeObject(forKey: longestGameKey)
        UserDefaults.standard.removeObject(forKey: totalPipesPassedKey)
    }
}

