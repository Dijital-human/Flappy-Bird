//
//  Pipe.swift
//  Flappy Bird
//
//  Boru modeli - boruların məlumatları
//  Pipe Model - pipe data structure
//

import Foundation
import SwiftUI

/// Boru modeli / Pipe Model
struct Pipe: Identifiable {
    let id = UUID()
    var x: CGFloat
    var gapY: CGFloat      // Boşluğun mərkəzi Y koordinatı / Gap center Y coordinate
    var gapHeight: CGFloat // Boşluq hündürlüyü / Gap height
    var width: CGFloat
    var hasPowerUp: Bool = false  // Power-up var? / Has power-up?
    var powerUpType: PowerUpType?  // Power-up tipi / Power-up type
    var powerUpCollected: Bool = false  // Power-up toplanıb? / Power-up collected?
    
    /// Borunun görünüşü üçün rəng / Color for pipe appearance
    var color: Color {
        return .green
    }
    
    /// Yuxarı borunun hündürlüyü / Top pipe height
    var topHeight: CGFloat {
        return gapY - gapHeight / 2
    }
    
    /// Aşağı borunun başlanğıc Y koordinatı / Bottom pipe start Y coordinate
    var bottomY: CGFloat {
        return gapY + gapHeight / 2
    }
}

