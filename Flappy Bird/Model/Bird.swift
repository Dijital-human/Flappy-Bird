//
//  Bird.swift
//  Flappy Bird
//
//  Quş modeli - quşun məlumatları
//  Bird Model - bird data structure
//

import Foundation
import SwiftUI

/// Quş modeli / Bird Model
struct Bird {
    var position: CGPoint
    var velocity: CGFloat
    let size: CGFloat = 30
    
    /// Quşun görünüşü üçün rəng / Color for bird appearance
    var color: Color {
        return .yellow
    }
}

