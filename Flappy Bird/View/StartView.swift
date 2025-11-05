//
//  StartView.swift
//  Flappy Bird
//
//  Başlanğıc ekranı - oyun başlamazdan əvvəl
//  Start Screen - before game starts
//
//

import SwiftUI

/// Mükəmməl müasir başlanğıc ekranı görünüşü / Perfect modern start screen view
struct StartView: View {
    @ObservedObject var gameModel: GameModel
    @ObservedObject var localizationModel: LocalizationModel
    let onStart: () -> Void
    let onShowSettings: () -> Void
    let onShowStatistics: () -> Void
    let onShowTutorial: () -> Void
    let onShowDailyChallenge: () -> Void
    let onShowAchievements: () -> Void
    let onShowBirdSelection: () -> Void
    let onShowEnvironmentSelection: () -> Void
    
    @State private var animateBird = false
    @State private var pulseScale: CGFloat = 1.0
    @State private var cloudOffset1: CGFloat = 0
    @State private var cloudOffset2: CGFloat = 0
    @State private var cloudOffset3: CGFloat = 0
    @State private var titleScale: CGFloat = 0.8
    @State private var titleOpacity: Double = 0
    @State private var scoreCardScale: CGFloat = 0.9
    @State private var scoreCardOpacity: Double = 0
    @State private var backgroundRotation: Double = 0
    @State private var shimmerOffset: CGFloat = -200
    
    var body: some View {
        GeometryReader { geometry in
            let sizing = ResponsiveSizing(geometry: geometry)
            let safeArea = geometry.safeAreaInsets
            
            ZStack {
                // Background / Arxa plan
                backgroundView
                
                // Clouds / Buludlar
                cloudsView
                
                // Main content / Əsas məzmun
                ScrollView {
                    VStack(spacing: sizing.spacing(20)) {
                        // High score / Yüksək skor
                        if gameModel.highScore > 0 {
                            highScoreCard(geometry: geometry, sizing: sizing)
                                .padding(.top, safeArea.top + sizing.padding(20))
                                .padding(.horizontal, sizing.padding(20))
                        } else {
                            Spacer()
                                .frame(height: safeArea.top + sizing.padding(20))
                        }
                        
                        // Logo və title / Logo və başlıq
                        logoSection(geometry: geometry, sizing: sizing)
                            .padding(.vertical, sizing.padding(20))
                        
                        // Buttons / Düymələr
                        buttonsSection(geometry: geometry, sizing: sizing)
                            .padding(.bottom, safeArea.bottom + sizing.padding(20))
                    }
                    .frame(minHeight: geometry.size.height - safeArea.top - safeArea.bottom)
                }
            }
            .onAppear {
                animateBird = true
                pulseScale = 1.1
                startAnimations(geometry: geometry)
            }
        }
    }
    
    // MARK: - Background / Arxa plan
    
    private var backgroundView: some View {
        ZStack {
            // Main gradient / Əsas gradient
            backgroundGradientView
            
            // Shimmer effect / Shimmer effekti
            shimmerView
            
            // Radial overlay / Radial overlay
            radialGradientOverlay
        }
    }
    
    private var backgroundGradientView: some View {
        let startX = 0.5 + 0.3 * cos(backgroundRotation)
        let startY = 0.5 + 0.3 * sin(backgroundRotation)
        let endX = 0.5 - 0.3 * cos(backgroundRotation)
        let endY = 0.5 - 0.3 * sin(backgroundRotation)
        
        return LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 0.2, green: 0.5, blue: 0.9),
                Color(red: 0.4, green: 0.7, blue: 1.0),
                Color(red: 0.6, green: 0.85, blue: 1.0),
                Color(red: 0.5, green: 0.8, blue: 0.95)
            ]),
            startPoint: UnitPoint(x: startX, y: startY),
            endPoint: UnitPoint(x: endX, y: endY)
        )
        .ignoresSafeArea()
    }
    
    private var shimmerView: some View {
        GeometryReader { geometry in
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.clear,
                    Color.white.opacity(0.2),
                    Color.clear
                ]),
                startPoint: .leading,
                endPoint: .trailing
            )
            .frame(width: geometry.size.width * 2)
            .offset(x: shimmerOffset)
            .blur(radius: 15)
        }
        .ignoresSafeArea()
    }
    
    private var radialGradientOverlay: some View {
        let radialCenterX = 0.5 + 0.2 * cos(backgroundRotation * 0.5)
        let radialCenterY = 0.3 + 0.2 * sin(backgroundRotation * 0.5)
        
        return RadialGradient(
            gradient: Gradient(colors: [
                Color.white.opacity(0.1),
                Color.clear,
                Color.blue.opacity(0.15)
            ]),
            center: UnitPoint(x: radialCenterX, y: radialCenterY),
            startRadius: 80,
            endRadius: 400
        )
        .ignoresSafeArea()
    }
    
    // MARK: - Clouds / Buludlar
    
    private var cloudsView: some View {
        ZStack {
            CloudView()
                .offset(x: cloudOffset1, y: -150)
                .scaleEffect(1.2)
                .opacity(0.9)
            
            CloudView()
                .offset(x: cloudOffset2, y: -200)
                .scaleEffect(1.0)
                .opacity(0.85)
            
            CloudView()
                .offset(x: cloudOffset3, y: -120)
                .scaleEffect(0.8)
                .opacity(0.8)
        }
    }
    
    // MARK: - Content Sections / Məzmun bölmələri
    
    @ViewBuilder
    private func highScoreCard(geometry: GeometryProxy, sizing: ResponsiveSizing) -> some View {
        HStack(spacing: sizing.spacing(12)) {
            Image(systemName: "crown.fill")
                .font(.system(size: sizing.font(20, minSize: 18, maxSize: 24), weight: .bold))
                .foregroundStyle(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.yellow, Color.orange]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            VStack(alignment: .leading, spacing: sizing.spacing(4)) {
                Text(localizationModel.translate("best_score"))
                    .font(.system(size: sizing.font(12, minSize: 11, maxSize: 14), weight: .semibold, design: .rounded))
                    .foregroundColor(.white.opacity(0.9))
                
                Text("\(gameModel.highScore)")
                    .font(.system(size: sizing.font(28, minSize: 24, maxSize: 32), weight: .black, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.yellow, Color.orange]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
            }
        }
        .padding(.horizontal, sizing.padding(20))
        .padding(.vertical, sizing.padding(12))
        .glassmorphism(
            cornerRadius: sizing.cornerRadius(16),
            borderWidth: 2,
            borderColors: [Color.yellow.opacity(0.6), Color.orange.opacity(0.4)],
            shadowRadius: 10,
            shadowColor: .black.opacity(0.2)
        )
        .scaleEffect(scoreCardScale)
        .opacity(scoreCardOpacity)
    }
    
    @ViewBuilder
    private func logoSection(geometry: GeometryProxy, sizing: ResponsiveSizing) -> some View {
        VStack(spacing: sizing.spacing(16)) {
            // Bird icon / Quş ikonu
            ZStack {
                Circle()
                    .fill(
                        RadialGradient.common(
                            colors: [
                                Color.yellow.opacity(0.4),
                                Color.orange.opacity(0.2),
                                Color.clear
                            ],
                            endRadius: sizing.size(60)
                        )
                    )
                    .frame(width: sizing.size(120, minSize: 100, maxSize: 140), height: sizing.size(120, minSize: 100, maxSize: 140))
                    .scaleEffect(pulseScale)
                
                BirdView(
                    size: sizing.size(70, minSize: 60, maxSize: 80),
                    velocity: -3
                )
                .rotationEffect(.degrees(animateBird ? -10 : 10))
                .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: animateBird)
            }
            
            // Title / Başlıq
            VStack(spacing: sizing.spacing(8)) {
                titleText(localizationModel.translate("flappy"), sizing: sizing)
                titleText(localizationModel.translate("bird"), sizing: sizing)
            }
        }
    }
    
    @ViewBuilder
    private func titleText(_ text: String, sizing: ResponsiveSizing) -> some View {
        let fontSize = sizing.font(48, minSize: 36, maxSize: 56)
        
        Text(text)
            .font(.system(size: fontSize, weight: .black, design: .rounded))
            .foregroundStyle(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 1.0, green: 0.9, blue: 0.5),
                        Color(red: 1.0, green: 0.7, blue: 0.2),
                        Color(red: 1.0, green: 0.6, blue: 0.1)
                    ]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .shadow(color: .black.opacity(0.6), radius: 12, x: 0, y: 4)
            .shadow(color: .orange.opacity(0.4), radius: 20, x: 0, y: 0)
            .scaleEffect(titleScale)
            .opacity(titleOpacity)
    }
    
    @ViewBuilder
    private func buttonsSection(geometry: GeometryProxy, sizing: ResponsiveSizing) -> some View {
        VStack(spacing: sizing.spacing(16)) {
            // Start button / Başlatma düyməsi
            startButton(geometry: geometry, sizing: sizing)
            
            // Icon buttons grid / İkon düymələr grid-i
            iconButtonsGrid(geometry: geometry, sizing: sizing)
        }
        .padding(.horizontal, sizing.padding(20))
    }
    
    @ViewBuilder
    private func startButton(geometry: GeometryProxy, sizing: ResponsiveSizing) -> some View {
        let buttonWidth = max(0, geometry.size.width - sizing.padding(40))
        let buttonHeight = sizing.size(60, minSize: 50, maxSize: 70)
        let fontSize = sizing.font(24, minSize: 20, maxSize: 28)
        
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                onStart()
            }
        }) {
            HStack(spacing: sizing.spacing(12)) {
                Image(systemName: "play.fill")
                    .font(.system(size: fontSize * 0.9, weight: .bold))
                    Text(localizationModel.translate("start_game_btn"))
                    .font(.system(size: fontSize, weight: .bold, design: .rounded))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: buttonHeight)
            .background(
                RoundedRectangle(cornerRadius: sizing.cornerRadius(20))
                    .fill(
                        LinearGradient.common(
                            colors: [
                                Color(red: 0.2, green: 0.95, blue: 0.5),
                                Color(red: 0.1, green: 0.85, blue: 0.4)
                            ]
                        )
                    )
                    .background(
                        RoundedRectangle(cornerRadius: sizing.cornerRadius(20))
                            .fill(.ultraThinMaterial)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: sizing.cornerRadius(20))
                            .stroke(Color.white.opacity(0.5), lineWidth: 2)
                    )
            )
            .multipleShadows(shadows: [
                (.black.opacity(0.4), 15, 0, 8),
                (.green.opacity(0.5), 25, 0, 0)
            ])
        }
        .scaleEffect(pulseScale * 0.98)
        .animation(.pulse, value: pulseScale)
    }
    
    @ViewBuilder
    private func iconButtonsGrid(geometry: GeometryProxy, sizing: ResponsiveSizing) -> some View {
        VStack(spacing: sizing.spacing(12)) {
            HStack(spacing: sizing.spacing(12)) {
                iconButton(icon: "questionmark.circle.fill", color: .blue, action: onShowTutorial, sizing: sizing)
                iconButton(icon: "calendar", color: .orange, action: onShowDailyChallenge, sizing: sizing)
                iconButton(icon: "trophy.fill", color: .yellow, action: onShowAchievements, sizing: sizing)
            }
            
            HStack(spacing: sizing.spacing(12)) {
                iconButton(icon: "gearshape.fill", color: .gray, action: onShowSettings, sizing: sizing)
                iconButton(icon: "chart.bar.fill", color: .purple, action: onShowStatistics, sizing: sizing)
                iconButton(icon: "bird.fill", color: .pink, action: onShowBirdSelection, sizing: sizing)
                iconButton(icon: "moon.fill", color: .indigo, action: onShowEnvironmentSelection, sizing: sizing)
            }
        }
    }
    
    @ViewBuilder
    private func iconButton(icon: String, color: Color, action: @escaping () -> Void, sizing: ResponsiveSizing) -> some View {
        let buttonSize = sizing.size(56, minSize: 50, maxSize: 64)
        let iconSize = sizing.font(22, minSize: 20, maxSize: 26)
        
        Button(action: {
            withAnimation(.commonSpring) {
                action()
            }
        }) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient.common(
                            colors: [
                                color.opacity(0.9),
                                color.opacity(0.75)
                            ]
                        )
                    )
                    .background(
                        Circle()
                            .fill(.ultraThinMaterial)
                    )
                    .overlay(
                        Circle()
                            .stroke(Color.white.opacity(0.6), lineWidth: 2)
                    )
                    .frame(width: buttonSize, height: buttonSize)
                
                Image(systemName: icon)
                    .font(.system(size: iconSize, weight: .semibold))
                    .foregroundColor(.white)
            }
        }
        .multipleShadows(shadows: [
            (color.opacity(0.6), 10, 0, 5),
            (.black.opacity(0.3), 8, 0, 4)
        ])
    }
    
    // MARK: - Animations / Animasiyalar
    
    private func startAnimations(geometry: GeometryProxy) {
        withAnimation(.linear(duration: 22).repeatForever(autoreverses: true)) {
            cloudOffset1 = -80
        }
        
        withAnimation(.linear(duration: 28).repeatForever(autoreverses: true)) {
            cloudOffset2 = 100
        }
        
        withAnimation(.linear(duration: 20).repeatForever(autoreverses: true)) {
            cloudOffset3 = -40
        }
        
        withAnimation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.3)) {
            titleScale = 1.0
            titleOpacity = 1.0
        }
        
        withAnimation(.spring(response: 0.7, dampingFraction: 0.7).delay(0.1)) {
            scoreCardScale = 1.0
            scoreCardOpacity = 1.0
        }
        
        withAnimation(.linear(duration: 20).repeatForever(autoreverses: false)) {
            backgroundRotation = .pi * 2
        }
        
        withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
            shimmerOffset = geometry.size.width + 200
        }
    }
}
