//
//  HapticManager.swift
//  Flappy Bird
//
//  Haptic feedback idarəçisi - vibrasiya idarə edir
//  Haptic Feedback Manager - manages vibration
//

import Foundation
import UIKit

/// Haptic feedback idarəçisi - vibrasiya idarə edir
/// Haptic Feedback Manager - manages vibration
class HapticManager {
    // MARK: - Singleton / Singleton
    
    static let shared = HapticManager()
    
    private init() {}
    
    // MARK: - Haptic Feedback Methods / Haptic feedback metodları
    
    /// Yüngül tap vibrasiyası / Light tap vibration
    func playLightImpact() {
        // Yüngül vibrasiya oynatır / Plays light vibration
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    /// Orta tap vibrasiyası / Medium tap vibration
    func playMediumImpact() {
        // Orta vibrasiya oynatır / Plays medium vibration
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    /// Güclü tap vibrasiyası / Strong tap vibration
    func playHeavyImpact() {
        // Güclü vibrasiya oynatır / Plays strong vibration
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
    }
    
    /// Uğur vibrasiyası / Success vibration
    func playSuccess() {
        // Uğur vibrasiyası oynatır / Plays success vibration
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    /// Xəta vibrasiyası / Error vibration
    func playError() {
        // Xəta vibrasiyası oynatır / Plays error vibration
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }
    
    /// Xəbərdarlıq vibrasiyası / Warning vibration
    func playWarning() {
        // Xəbərdarlıq vibrasiyası oynatır / Plays warning vibration
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
    }
    
    /// Seçim vibrasiyası / Selection vibration
    func playSelection() {
        // Seçim vibrasiyası oynatır / Plays selection vibration
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
    
    /// Ritmik vibrasiya (sıra) / Rhythmic vibration (sequence)
    func playRhythmPattern() {
        // Ritmik vibrasiya oynatır / Plays rhythmic vibration
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        
        // Ritmik növbələr / Rhythmic sequence
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            generator.impactOccurred()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            generator.impactOccurred()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            generator.impactOccurred()
        }
    }
    
    /// Dual vibrasiya (ikiqat) / Dual vibration (double)
    func playDualImpact() {
        // Dual vibrasiya oynatır / Plays dual vibration
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            generator.impactOccurred()
        }
    }
    
    /// Uzun vibrasiya / Long vibration
    func playLongImpact() {
        // Uzun vibrasiya oynatır / Plays long vibration
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.prepare()
        generator.impactOccurred()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            generator.impactOccurred()
        }
    }
}

