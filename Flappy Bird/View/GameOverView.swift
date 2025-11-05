//
//  GameOverView.swift
//  Flappy Bird
//
//  Oyun bitmə ekranı - oyun bitdikdən sonra
//  Game Over Screen - after game ends
//

import SwiftUI

/// Oyun bitmə ekranı görünüşü / Game Over Screen View
struct GameOverView: View {
    @ObservedObject var gameModel: GameModel
    @ObservedObject var localizationModel: LocalizationModel
    let onRestart: () -> Void
    let onShowInterstitial: () -> Void
    let onShowRewardedAd: (() -> Void)?  // Rewarded reklam göstərmə funksiyası / Show rewarded ad function
    let onHome: () -> Void  // Ana ekrana qayıtma funksiyası / Return to home function
    
    @State private var titleScale: CGFloat = 0.5
    @State private var titleOpacity: Double = 0
    @State private var cardScale: CGFloat = 0.8
    @State private var cardOpacity: Double = 0
    @State private var buttonScale: CGFloat = 0.9
    @State private var buttonOpacity: Double = 0
    @State private var glowIntensity: Double = 0.5
    @State private var pulseScale: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            // Dynamic fon rəngi (gradient) / Dynamic background color (gradient)
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.red.opacity(0.5 + glowIntensity * 0.2),
                    Color.orange.opacity(0.4 + glowIntensity * 0.2),
                    Color.red.opacity(0.6 + glowIntensity * 0.2)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Animated particles in background / Arxa planda animasiyalı partikullar
            ForEach(0..<5, id: \.self) { index in
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                Color.white.opacity(0.2),
                                Color.clear
                            ]),
                            center: .center,
                            startRadius: 0,
                            endRadius: 50
                        )
                    )
                    .frame(width: CGFloat(30 + index * 10), height: CGFloat(30 + index * 10))
                    .offset(
                        x: CGFloat(index * 80 - 160) + sin(Double(index) * 0.5 + Date().timeIntervalSince1970) * 30,
                        y: CGFloat(index * 60 - 120) + cos(Double(index) * 0.3 + Date().timeIntervalSince1970) * 40
                    )
                    .blur(radius: 10)
            }
            
            VStack(spacing: 35) {
                    // Modern oyun bitmə başlığı / Modern game over title
                ZStack {
                    // Glow effect / Glow effect
                Text(localizationModel.translate("game_over"))
                        .font(.system(size: 55, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                        .blur(radius: 8)
                        .scaleEffect(titleScale)
                        .opacity(titleOpacity)
                    
                    // Main text / Əsas mətn
                    Text(localizationModel.translate("game_over"))
                        .font(.system(size: 55, weight: .bold, design: .rounded))
                        .foregroundStyle(
                            LinearGradient.common(
                                colors: [
                                    Color.white,
                                    Color.red.opacity(0.9),
                                    Color.white
                                ]
                            )
                        )
                        .multipleShadows(shadows: [
                            (.black.opacity(0.8), 12, 0, 4),
                            (.red.opacity(0.5), 20, 0, 0)
                        ])
                        .scaleEffect(titleScale)
                        .opacity(titleOpacity)
                }
                    .padding(.top, 50)
                
                // Modern skor kartı / Modern score card
                VStack(spacing: 15) {
                    // Yeni rekord göstəricisi (animasiyalı) / New record indicator (animated)
                    if gameModel.isNewRecord {
                        ZStack {
                            // Pulsing glow / Pulsing parıltı
                            RoundedRectangle(cornerRadius: 15)
                                .fill(
                                    RadialGradient(
                                        gradient: Gradient(colors: [
                                            Color.yellow.opacity(0.6),
                                            Color.clear
                                        ]),
                                        center: .center,
                                        startRadius: 0,
                                        endRadius: 100
                                    )
                                )
                                .frame(width: 200, height: 80)
                                .blur(radius: 15)
                                .scaleEffect(pulseScale)
                            
                        VStack(spacing: 5) {
                            Image(systemName: "star.fill")
                                    .font(.system(size: 30, weight: .bold))
                                    .foregroundStyle(
                                        LinearGradient(
                                            gradient: Gradient(colors: [Color.yellow, Color.orange]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .rotationEffect(.degrees(pulseScale * 360))
                                    .animation(.linear(duration: 2).repeatForever(autoreverses: false), value: pulseScale)
                            
                            Text(localizationModel.translate("new_record"))
                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                                    .foregroundStyle(
                                        LinearGradient.common(
                                            colors: [Color.yellow, Color.orange]
                                        )
                                    )
                                    .shadow(color: .black.opacity(0.6), radius: 5, x: 0, y: 2)
                        }
                        .padding(.vertical, 15)
                        .padding(.horizontal, 30)
                        .glassmorphism(
                            cornerRadius: 15,
                            borderWidth: 2,
                            borderColors: [Color.yellow.opacity(0.8), Color.orange.opacity(0.6)],
                            shadowRadius: 15,
                            shadowColor: .black.opacity(0.4)
                        )
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(
                                    LinearGradient.common(
                                        colors: [
                                            Color.yellow.opacity(0.4),
                                            Color.orange.opacity(0.3)
                                        ]
                                    )
                                )
                        )
                        }
                        .scaleEffect(cardScale)
                        .opacity(cardOpacity)
                    }
                    
                    // Modern cari skor / Modern current score
                    VStack(spacing: 8) {
                        Text(localizationModel.translate("your_score"))
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            .foregroundColor(.white.opacity(0.9))
                        
                        ZStack {
                            // Glow effect / Glow effect
                        Text("\(gameModel.score)")
                                .font(.system(size: 42, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                                .blur(radius: 4)
                            
                            // Main text / Əsas mətn
                            Text("\(gameModel.score)")
                                .font(.system(size: 42, weight: .bold, design: .rounded))
                                .foregroundStyle(
                                    LinearGradient.common(
                                        colors: [
                                            Color.white,
                                            Color.yellow.opacity(0.9),
                                            Color.white
                                        ]
                                    )
                                )
                                .multipleShadows(shadows: [
                                    (.black.opacity(0.7), 10, 0, 4),
                                    (.yellow.opacity(0.5), 15, 0, 0)
                                ])
                        }
                    }
                    .padding(.vertical, 25)
                    .padding(.horizontal, 50)
                    .glassmorphism(
                        cornerRadius: 25,
                        borderWidth: 2,
                        borderColors: [Color.white.opacity(0.3), Color.white.opacity(0.2)],
                        shadowRadius: 15,
                        shadowColor: .black.opacity(0.4)
                    )
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(
                                LinearGradient.common(
                                    colors: [
                                        Color.white.opacity(0.25),
                                        Color.white.opacity(0.15)
                                    ]
                                )
                            )
                    )
                    .scaleEffect(cardScale)
                    .opacity(cardOpacity)
                    
                    // Modern yüksək skor / Modern high score
                    if gameModel.highScore > 0 {
                        VStack(spacing: 5) {
                            Text(localizationModel.translate("best_score"))
                                .font(.system(size: 14, weight: .medium, design: .rounded))
                                .foregroundColor(.yellow.opacity(0.95))
                            
                            Text("\(gameModel.highScore)")
                                .font(.system(size: 32, weight: .bold, design: .rounded))
                                .foregroundStyle(
                                    LinearGradient.common(
                                        colors: [Color.yellow, Color.orange]
                                    )
                                )
                                .shadow(color: .black.opacity(0.6), radius: 8, x: 0, y: 3)
                        }
                        .padding(.vertical, 18)
                        .padding(.horizontal, 35)
                        .glassmorphism(
                            cornerRadius: 18,
                            borderWidth: 1.5,
                            borderColors: [Color.yellow.opacity(0.6), Color.orange.opacity(0.4)],
                            shadowRadius: 12,
                            shadowColor: .black.opacity(0.3)
                        )
                        .background(
                            RoundedRectangle(cornerRadius: 18)
                                .fill(
                                    LinearGradient.common(
                                        colors: [
                                            Color.yellow.opacity(0.25),
                                            Color.orange.opacity(0.2)
                                        ]
                                    )
                                )
                        )
                        .scaleEffect(cardScale)
                        .opacity(cardOpacity)
                    }
                }
                
                Spacer()
                
                // Modern düymələr / Modern buttons
                VStack(spacing: 20) {
                    // Modern yenidən başlatma düyməsi / Modern restart button
                    ModernButton(
                        icon: "arrow.clockwise",
                        text: localizationModel.translate("play_again"),
                        colors: [Color.green, Color.green.opacity(0.8)],
                        scale: buttonScale,
                        opacity: buttonOpacity,
                        delay: 0.0
                    ) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                            // Reklam məntiqini burada yoxlamaq lazım deyil, onRestart callback-də yoxlanılacaq
                            // Ad logic is not checked here, it will be checked in onRestart callback
                        onRestart()
                        }
                    }
                    
                    // Modern rewarded ad düyməsi / Modern rewarded ad button
                    if let onShowRewardedAd = onShowRewardedAd {
                        ModernButton(
                            icon: "star.fill",
                            text: localizationModel.translate("watch_ad_for_bonus"),
                            colors: [Color.orange, Color.orange.opacity(0.8)],
                            scale: buttonScale,
                            opacity: buttonOpacity,
                            delay: 0.1
                        ) {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                onShowRewardedAd()
                            }
                        }
                    }
                    
                    // Modern paylaşım düyməsi / Modern share button
                    ModernButton(
                        icon: "square.and.arrow.up",
                        text: localizationModel.translate("share"),
                        colors: [Color.purple, Color.purple.opacity(0.8)],
                        scale: buttonScale,
                        opacity: buttonOpacity,
                        delay: 0.2
                    ) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        ShareView.shareScore(score: gameModel.score, highScore: gameModel.highScore)
                        }
                    }
                    
                    // Modern ana ekrana qayıtma düyməsi / Modern home button
                    ModernButton(
                        icon: "house.fill",
                        text: localizationModel.translate("home"),
                        colors: [Color.blue, Color.blue.opacity(0.8)],
                        scale: buttonScale,
                        opacity: buttonOpacity,
                        delay: 0.3
                    ) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                            // Reklam məntiqini burada yoxlamaq lazım deyil, onHome callback-də yoxlanılacaq
                            // Ad logic is not checked here, it will be checked in onHome callback
                            onHome()
                        }
                    }
                }
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            startAnimations()
        }
    }
    
    // MARK: - Animations / Animasiyalar
    
    /// Animasiyaları başlatır / Starts animations
    private func startAnimations() {
        // Title animation / Başlıq animasiyası
        withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.1)) {
            titleScale = 1.0
            titleOpacity = 1.0
        }
        
        // Card animation / Kart animasiyası
        withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.3)) {
            cardScale = 1.0
            cardOpacity = 1.0
        }
        
        // Button animation / Düymə animasiyası
        withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.5)) {
            buttonScale = 1.0
            buttonOpacity = 1.0
        }
        
        // Glow animation / Parıltı animasiyası
        withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
            glowIntensity = 1.0
        }
        
        // Pulse animation / Pulse animasiyası
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            pulseScale = 1.1
        }
    }
}

/// Modern düymə komponenti / Modern button component
struct ModernButton: View {
    let icon: String
    let text: String
    let colors: [Color]
    let scale: CGFloat
    let opacity: Double
    let delay: Double
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.2, dampingFraction: 0.5)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.2, dampingFraction: 0.5)) {
                    isPressed = false
                }
                action()
            }
        }) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                Text(text)
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
            }
            .foregroundColor(.white)
            .padding(.horizontal, 40)
            .padding(.vertical, 15)
            .background(
                ZStack {
                    // Glow effect / Glow effect
                    RoundedRectangle(cornerRadius: 25)
                        .fill(LinearGradient.glow(colors: colors))
                        .blur(radius: 8)
                    
                    // Main button / Əsas düymə
                    RoundedRectangle(cornerRadius: 25)
                        .fill(LinearGradient.common(colors: colors))
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(
                                    LinearGradient.common(
                                        colors: [Color.white.opacity(0.4), Color.white.opacity(0.1)]
                                    ),
                                    lineWidth: 1.5
                                )
                        )
                }
            )
            .shadow(color: .black.opacity(0.5), radius: 12, x: 0, y: 6)
            .scaleEffect(isPressed ? 0.95 : scale)
            .opacity(opacity)
        }
        .animation(.commonSpring.delay(delay), value: scale)
            }
        }
