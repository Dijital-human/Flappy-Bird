//
//  NotificationNames.swift
//  Flappy Bird
//
//  Notification adları - sistem bildirişləri üçün
//  Notification Names - for system notifications
//

import Foundation

/// Notification adları / Notification Names
extension Notification.Name {
    /// Skor artımı bildirişi / Score increase notification
    static let scoreIncreased = Notification.Name("scoreIncreased")
    
    /// Oyun bitmə bildirişi / Game over notification
    static let gameOver = Notification.Name("gameOver")
}

