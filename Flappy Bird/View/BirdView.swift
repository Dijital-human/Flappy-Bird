//
//  BirdView.swift
//  Flappy Bird
//
//  Quş görünüşü - quşun vizual təsviri animasiya ilə
//  Bird View - visual representation of the bird with animation
//

import SwiftUI

/// Gözəl və sevimli quş görünüşü komponenti / Beautiful and cute bird view component
struct BirdView: View {
    let size: CGFloat
    let velocity: CGFloat
    var color: Color = .yellow  // Quş rəngi / Bird color
    @State private var wingAngle: Double = 0  // Qanad bucağı / Wing angle
    @State private var glowIntensity: Double = 0.5  // Glow intensivliyi / Glow intensity
    
    var body: some View {
        ZStack {
            // Glow effect (velocity-yə görə) / Glow effect (based on velocity)
            if velocity < -2 {
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                color.opacity(0.3 * glowIntensity),
                                color.opacity(0.1 * glowIntensity),
                                Color.clear
                            ]),
                            center: .center,
                            startRadius: size * 0.3,
                            endRadius: size * 1.0
                        )
                    )
                    .frame(width: size * 2.0, height: size * 2.0)
                    .blur(radius: 6)
            }
            
            // Gövdə / Body (oval forma, gradient, shine)
            Ellipse()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            color,
                            color.opacity(0.95),
                            color.opacity(0.9),
                            color.opacity(0.85)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: size * 0.85, height: size * 0.95)
                .overlay(
                    // Shine effect / Shine effect
                    Ellipse()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.white.opacity(0.4),
                                    Color.white.opacity(0.2),
                                    Color.clear
                                ]),
                                startPoint: .topLeading,
                                endPoint: .center
                            )
                        )
                        .frame(width: size * 0.6, height: size * 0.4)
                        .offset(x: -size * 0.1, y: -size * 0.2)
                )
                .shadow(color: color.opacity(0.5), radius: 6, x: 0, y: 3)
                .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
            
            // Sol qanad / Left wing (animasiya ilə, daha detallı)
            ZStack {
                // Əsas qanad / Main wing
            Ellipse()
                .fill(
                    LinearGradient(
                            gradient: Gradient(colors: [
                                color.opacity(0.95),
                                color.opacity(0.85),
                                color.opacity(0.7),
                                color.opacity(0.6)
                            ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                    .frame(width: size * 0.75, height: size * 0.4)
                    .overlay(
                        // Qanad parıltısı / Wing shine
                        Ellipse()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.white.opacity(0.3),
                                        Color.clear
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .center
                                )
                            )
                            .frame(width: size * 0.5, height: size * 0.25)
                            .offset(x: -size * 0.15, y: -size * 0.1)
                    )
            }
                .rotationEffect(.degrees(wingAngle))
            .offset(x: -size * 0.25, y: size * 0.15)
            .shadow(color: color.opacity(0.3), radius: 4, x: 3, y: 3)
            
            // Sağ qanad / Right wing (animasiya ilə, daha detallı)
            ZStack {
                // Əsas qanad / Main wing
            Ellipse()
                .fill(
                    LinearGradient(
                            gradient: Gradient(colors: [
                                color.opacity(0.95),
                                color.opacity(0.85),
                                color.opacity(0.7),
                                color.opacity(0.6)
                            ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                    .frame(width: size * 0.75, height: size * 0.4)
                    .overlay(
                        // Qanad parıltısı / Wing shine
                        Ellipse()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.white.opacity(0.3),
                                        Color.clear
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .center
                                )
                            )
                            .frame(width: size * 0.5, height: size * 0.25)
                            .offset(x: -size * 0.15, y: -size * 0.1)
                    )
            }
                .rotationEffect(.degrees(-wingAngle))
            .offset(x: size * 0.25, y: size * 0.15)
            .shadow(color: color.opacity(0.3), radius: 4, x: -3, y: 3)
            
            // Baş / Head (daha böyük və sevimli)
            ZStack {
            Circle()
                .fill(
                    LinearGradient(
                            gradient: Gradient(colors: [
                                color,
                                color.opacity(0.92),
                                color.opacity(0.85),
                                color.opacity(0.8)
                            ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                    .frame(width: size * 0.55, height: size * 0.55)
                    .overlay(
                        Circle()
                            .stroke(color.opacity(0.4), lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 2)
                
                // Baş parıltısı / Head shine
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                Color.white.opacity(0.5),
                                Color.white.opacity(0.3),
                                Color.clear
                            ]),
                            center: .topLeading,
                            startRadius: 0,
                            endRadius: size * 0.3
                        )
                    )
                    .frame(width: size * 0.55, height: size * 0.55)
            }
            .offset(x: -size * 0.18, y: -size * 0.22)
            
            // Göz / Eye (daha böyük və sevimli)
            ZStack {
                // Göz arxa planı / Eye background
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.white,
                                Color.white.opacity(0.98)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: size * 0.22, height: size * 0.22)
                    .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 2)
                    .overlay(
                        Circle()
                            .stroke(Color.black.opacity(0.1), lineWidth: 1.5)
                    )
                
                // Qara bəbək / Black pupil
                Circle()
                    .fill(Color.black)
                    .frame(width: size * 0.13, height: size * 0.13)
                    .offset(x: velocity < 0 ? -1.5 : 1.5, y: 0)  // Hərəkətə görə bəbək hərəkəti / Pupil moves based on movement
                
                // Göz parıltısı / Eye shine
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.9))
                        .frame(width: size * 0.07, height: size * 0.07)
                        .offset(x: -size * 0.04, y: -size * 0.04)
                    
                    Circle()
                        .fill(Color.white.opacity(0.6))
                        .frame(width: size * 0.04, height: size * 0.04)
                        .offset(x: -size * 0.05, y: -size * 0.05)
                }
            }
            .offset(x: -size * 0.12, y: -size * 0.27)
            
            // Dimdik / Beak (daha böyük və sevimli)
            ZStack {
            Path { path in
                    path.move(to: CGPoint(x: size * 0.22, y: -size * 0.22))
                    path.addLine(to: CGPoint(x: size * 0.48, y: -size * 0.17))
                    path.addLine(to: CGPoint(x: size * 0.22, y: -size * 0.12))
                path.closeSubpath()
            }
            .fill(
                LinearGradient(
                        gradient: Gradient(colors: [
                            Color.orange.opacity(0.98),
                            Color.orange.opacity(0.9),
                            Color.orange.opacity(0.8),
                            Color.orange.opacity(0.7)
                        ]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
                .overlay(
                    Path { path in
                        path.move(to: CGPoint(x: size * 0.22, y: -size * 0.22))
                        path.addLine(to: CGPoint(x: size * 0.48, y: -size * 0.17))
                        path.addLine(to: CGPoint(x: size * 0.22, y: -size * 0.12))
                        path.closeSubpath()
                    }
                    .stroke(Color.orange.opacity(0.4), lineWidth: 1.5)
                )
                
                // Dimdik parıltısı / Beak shine
                Path { path in
                    path.move(to: CGPoint(x: size * 0.24, y: -size * 0.2))
                    path.addLine(to: CGPoint(x: size * 0.42, y: -size * 0.17))
                    path.addLine(to: CGPoint(x: size * 0.24, y: -size * 0.14))
                    path.closeSubpath()
                }
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.white.opacity(0.4),
                            Color.clear
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
            }
            .shadow(color: .black.opacity(0.3), radius: 3, x: 1, y: 2)
            .offset(x: -size * 0.12)
            
            // Quyruq / Tail (daha detallı)
            ZStack {
            Path { path in
                    path.move(to: CGPoint(x: size * 0.48, y: size * 0.14))
                    path.addLine(to: CGPoint(x: size * 0.75, y: size * 0.28))
                    path.addLine(to: CGPoint(x: size * 0.75, y: size * 0.08))
                    path.addLine(to: CGPoint(x: size * 0.68, y: size * 0.11))
                path.closeSubpath()
            }
            .fill(
                LinearGradient(
                        gradient: Gradient(colors: [
                            color.opacity(0.95),
                            color.opacity(0.85),
                            color.opacity(0.7),
                            color.opacity(0.5)
                        ]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
                .overlay(
                    Path { path in
                        path.move(to: CGPoint(x: size * 0.48, y: size * 0.14))
                        path.addLine(to: CGPoint(x: size * 0.75, y: size * 0.28))
                        path.addLine(to: CGPoint(x: size * 0.75, y: size * 0.08))
                        path.addLine(to: CGPoint(x: size * 0.68, y: size * 0.11))
                        path.closeSubpath()
                    }
                    .stroke(color.opacity(0.4), lineWidth: 1.5)
                )
            }
            .shadow(color: color.opacity(0.3), radius: 4, x: 3, y: 3)
        }
        .rotationEffect(.degrees(velocity > 0 ? min(30, velocity * 5) : max(-30, velocity * 5))) // Hərəkətə görə fırlanır / Rotates based on movement
        .onAppear {
            // Qanad animasiyasını başlatır / Starts wing animation
            startWingAnimation()
            // Glow animasiyasını başlatır / Starts glow animation
            startGlowAnimation()
        }
    }
    
    // MARK: - Animation / Animasiya
    
    /// Qanad animasiyasını başlatır / Starts wing animation
    private func startWingAnimation() {
        // Velocity-yə görə qanad sürəti / Wing speed based on velocity
        let speed = abs(velocity) > 5 ? 0.1 : 0.15
        
        // Davamlı qanad çalması animasiyası / Continuous wing flapping animation
        withAnimation(
            Animation.easeInOut(duration: speed)
                .repeatForever(autoreverses: true)
        ) {
            wingAngle = 50 // Qanad bucağı / Wing angle
        }
    }
    
    /// Glow animasiyasını başlatır / Starts glow animation
    private func startGlowAnimation() {
        withAnimation(
            Animation.easeInOut(duration: 1.0)
                .repeatForever(autoreverses: true)
        ) {
            glowIntensity = 1.0
        }
    }
}

#Preview {
    ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.cyan.opacity(0.3)]),
                startPoint: .top,
                endPoint: .bottom
            )
        .ignoresSafeArea()
        
        BirdView(size: 30, velocity: -5)
    }
}
