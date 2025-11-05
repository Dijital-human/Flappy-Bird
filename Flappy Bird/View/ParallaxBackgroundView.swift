//
//  ParallaxBackgroundView.swift
//  Flappy Bird
//
//  Parallax arxa plan görünüşü - dərinlik effekti
//  Parallax Background View - depth effect
//

import SwiftUI

/// Parallax arxa plan görünüşü / Parallax Background View
struct ParallaxBackgroundView: View {
    @State private var offset1: CGFloat = 0
    @State private var offset2: CGFloat = 0
    @State private var offset3: CGFloat = 0
    @State private var rotation1: Double = 0
    @State private var rotation2: Double = 0
    @State private var scale1: CGFloat = 1.0
    @State private var scale2: CGFloat = 1.0
    @State private var glowIntensity: Double = 0.5
    
    let gradientColors: [Color]
    
    var body: some View {
        ZStack {
            // Arxa plan təbəqələri (parallax effekti üçün) / Background layers (for parallax effect)
            // 1. Ən arxada (yavaş hərəkət, rotation, scale) / 1. Furthest back (slow movement, rotation, scale)
            ZStack {
            LinearGradient(
                gradient: Gradient(colors: gradientColors),
                startPoint: .top,
                endPoint: .bottom
            )
                .scaleEffect(scale1)
                .rotationEffect(.degrees(rotation1))
                
                // Glow effect / Glow effect
                RadialGradient(
                    gradient: Gradient(colors: [
                        gradientColors.first?.opacity(0.3 * glowIntensity) ?? .clear,
                        Color.clear
                    ]),
                    center: .center,
                    startRadius: 0,
                    endRadius: 500
                )
                .blur(radius: 20)
            }
            .offset(y: offset1)
            .animation(.linear(duration: 25).repeatForever(autoreverses: true), value: offset1)
            
            // 2. Orta təbəqə (orta sürət, rotation) / 2. Middle layer (medium speed, rotation)
            LinearGradient(
                gradient: Gradient(colors: gradientColors.map { $0.opacity(0.85) }),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .scaleEffect(scale2)
            .rotationEffect(.degrees(rotation2))
            .offset(y: offset2)
            .animation(.linear(duration: 18).repeatForever(autoreverses: true), value: offset2)
            
            // 3. Ön təbəqə (sürətli hərəkət) / 3. Front layer (fast movement)
            LinearGradient(
                gradient: Gradient(colors: gradientColors.map { $0.opacity(0.7) }),
                startPoint: .trailing,
                endPoint: .leading
            )
            .offset(y: offset3)
            .animation(.linear(duration: 12).repeatForever(autoreverses: true), value: offset3)
            
            // Dynamic cloud effects / Dinamik bulud effektləri
            ForEach(0..<3, id: \.self) { index in
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                Color.white.opacity(0.1),
                                Color.clear
                            ]),
                            center: .center,
                            startRadius: 0,
                            endRadius: 100
                        )
                    )
                    .frame(width: CGFloat(150 + index * 50), height: CGFloat(150 + index * 50))
                    .offset(
                        x: CGFloat(index * 100 - 100) + sin(Double(index) * 0.5) * 50,
                        y: CGFloat(index * 80 - 100) + offset3 * 0.3
                    )
                    .blur(radius: 20)
            }
        }
        .onAppear {
            // Animasiyaları başlatır / Starts animations
            startAnimations()
        }
    }
    
    // MARK: - Animations / Animasiyalar
    
    /// Animasiyaları başlatır / Starts animations
    private func startAnimations() {
        // Offset animasiyaları / Offset animations
        offset1 = 60
        offset2 = 40
        offset3 = 25
        
        // Rotation animasiyaları / Rotation animations
        withAnimation(
            .linear(duration: 30)
                .repeatForever(autoreverses: false)
        ) {
            rotation1 = 360
        }
        
        withAnimation(
            .linear(duration: 20)
                .repeatForever(autoreverses: false)
        ) {
            rotation2 = -360
        }
        
        // Scale animasiyaları / Scale animations
        withAnimation(
            .easeInOut(duration: 8)
                .repeatForever(autoreverses: true)
        ) {
            scale1 = 1.1
        }
        
        withAnimation(
            .easeInOut(duration: 6)
                .repeatForever(autoreverses: true)
        ) {
            scale2 = 1.05
        }
        
        // Glow animasiyası / Glow animation
        withAnimation(
            .easeInOut(duration: 3)
                .repeatForever(autoreverses: true)
        ) {
            glowIntensity = 1.0
    }
}
}

