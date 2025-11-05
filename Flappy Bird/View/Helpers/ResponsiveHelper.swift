//
//  ResponsiveHelper.swift
//  Flappy Bird
//
//  Responsive dizayn köməkçi funksiyaları
//  Responsive design helper functions
//

import SwiftUI

/// Responsive dizayn köməkçi funksiyaları / Responsive design helper functions
extension View {
    /// Responsive font size hesablayır / Calculates responsive font size
    func responsiveFont(_ baseSize: CGFloat, relativeTo geometry: GeometryProxy, minSize: CGFloat = 12, maxSize: CGFloat = 100) -> CGFloat {
        let screenWidth = geometry.size.width
        let scaleFactor = min(screenWidth / 375, 1.5) // iPhone SE (375pt) əsasında
        let calculatedSize = baseSize * scaleFactor
        return max(minSize, min(maxSize, calculatedSize))
    }
    
    /// Responsive padding hesablayır / Calculates responsive padding
    func responsivePadding(_ basePadding: CGFloat, relativeTo geometry: GeometryProxy) -> CGFloat {
        let screenWidth = geometry.size.width
        let scaleFactor = screenWidth / 375 // iPhone SE (375pt) əsasında
        return basePadding * min(scaleFactor, 1.2)
    }
    
    /// Responsive size hesablayır / Calculates responsive size
    func responsiveSize(_ baseSize: CGFloat, relativeTo geometry: GeometryProxy, minSize: CGFloat = 20, maxSize: CGFloat = 200) -> CGFloat {
        let screenWidth = geometry.size.width
        let scaleFactor = min(screenWidth / 375, 1.3)
        let calculatedSize = baseSize * scaleFactor
        return max(minSize, min(maxSize, calculatedSize))
    }
    
    /// Responsive corner radius hesablayır / Calculates responsive corner radius
    func responsiveCornerRadius(_ baseRadius: CGFloat, relativeTo geometry: GeometryProxy) -> CGFloat {
        let screenWidth = geometry.size.width
        let scaleFactor = min(screenWidth / 375, 1.2)
        return baseRadius * scaleFactor
    }
}

/// Responsive sizing struktur / Responsive sizing structure
struct ResponsiveSizing {
    let geometry: GeometryProxy
    
    init(geometry: GeometryProxy) {
        self.geometry = geometry
    }
    
    /// Font size hesablayır (sadə versiya) / Calculates font size (simple version)
    func font(_ baseSize: CGFloat) -> CGFloat {
        let screenWidth = geometry.size.width
        let scaleFactor = Swift.min(screenWidth / 375, 1.5)
        return baseSize * scaleFactor
    }
    
    /// Font size hesablayır (min/max ilə) / Calculates font size (with min/max)
    func font(_ baseSize: CGFloat, minSize: CGFloat, maxSize: CGFloat) -> CGFloat {
        let screenWidth = geometry.size.width
        let scaleFactor = Swift.min(screenWidth / 375, 1.5)
        let calculatedSize = baseSize * scaleFactor
        return Swift.max(minSize, Swift.min(maxSize, calculatedSize))
    }
    
    /// Size hesablayır (sadə versiya) / Calculates size (simple version)
    func size(_ baseSize: CGFloat) -> CGFloat {
        let screenWidth = geometry.size.width
        let scaleFactor = Swift.min(screenWidth / 375, 1.3)
        return baseSize * scaleFactor
    }
    
    /// Size hesablayır (min/max ilə) / Calculates size (with min/max)
    func size(_ baseSize: CGFloat, minSize: CGFloat, maxSize: CGFloat) -> CGFloat {
        let screenWidth = geometry.size.width
        let scaleFactor = Swift.min(screenWidth / 375, 1.3)
        let calculatedSize = baseSize * scaleFactor
        return Swift.max(minSize, Swift.min(maxSize, calculatedSize))
    }
    
    /// Padding hesablayır / Calculates padding
    func padding(_ basePadding: CGFloat) -> CGFloat {
        let screenWidth = geometry.size.width
        let scaleFactor = Swift.min(screenWidth / 375, 1.2)
        return basePadding * scaleFactor
    }
    
    /// Corner radius hesablayır / Calculates corner radius
    func cornerRadius(_ baseRadius: CGFloat) -> CGFloat {
        let screenWidth = geometry.size.width
        let scaleFactor = Swift.min(screenWidth / 375, 1.2)
        return baseRadius * scaleFactor
    }
    
    /// Spacing hesablayır / Calculates spacing
    func spacing(_ baseSpacing: CGFloat) -> CGFloat {
        let screenWidth = geometry.size.width
        let scaleFactor = Swift.min(screenWidth / 375, 1.2)
        return baseSpacing * scaleFactor
    }
}

