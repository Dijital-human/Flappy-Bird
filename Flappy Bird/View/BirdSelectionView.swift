//
//  BirdSelectionView.swift
//  Flappy Bird
//
//  Quş seçimi ekranı - fərqli quş növləri
//  Bird Selection Screen - different bird types
//
//

import SwiftUI

/// Modern quş seçimi ekranı görünüşü / Modern Bird Selection Screen View
struct BirdSelectionView: View {
    @ObservedObject var birdTypeModel: BirdTypeModel
    let onClose: () -> Void  // Bağlama callback-i / Close callback
    
    @State private var cardScale: CGFloat = 0.8
    @State private var cardOpacity: Double = 0
    @State private var titleScale: CGFloat = 0.5
    @State private var titleOpacity: Double = 0
    
    var body: some View {
        ZStack {
            // Modern gradient fon / Modern gradient background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.blue.opacity(0.85),
                    Color.purple.opacity(0.75),
                    Color.pink.opacity(0.65)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
                .ignoresSafeArea()
            
            // Animated particles / Animasiyalı partikullar
            ForEach(0..<6, id: \.self) { index in
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                Color.white.opacity(0.3),
                                Color.clear
                            ]),
                            center: .center,
                            startRadius: 0,
                            endRadius: 35
                        )
                    )
                    .frame(width: CGFloat(15 + index * 4), height: CGFloat(15 + index * 4))
                    .offset(
                        x: CGFloat(index * 70 - 175) + sin(Double(index) * 0.5 + Date().timeIntervalSince1970 * 0.3) * 30,
                        y: CGFloat(index * 60 - 120) + cos(Double(index) * 0.3 + Date().timeIntervalSince1970 * 0.2) * 25
                    )
                    .blur(radius: 6)
            }
            
            VStack(spacing: 25) {
                // Modern bağlama düyməsi / Modern close button
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                            onClose()
                        }
                    }) {
                        ZStack {
                            // Glow effect / Glow effect
                            Circle()
                                .fill(Color.white.opacity(0.3))
                                .blur(radius: 8)
                                .frame(width: 50, height: 50)
                            
                            // Main button / Main button
                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color.white.opacity(0.3),
                                            Color.white.opacity(0.2)
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .overlay(
                                    Circle()
                                        .stroke(Color.white.opacity(0.4), lineWidth: 2)
                                )
                                .frame(width: 46, height: 46)
                            
                        Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 28, weight: .semibold))
                            .foregroundColor(.white)
                        }
                    }
                    .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                    .padding(20)
                }
                
                // Modern başlıq / Modern title
                ZStack {
                    // Glow effect / Glow effect
                Text("Quş Növləri")
                        .font(.system(size: 38, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                        .blur(radius: 6)
                        .scaleEffect(titleScale)
                        .opacity(titleOpacity)
                
                    // Main text / Əsas mətn
                    Text("Quş Növləri")
                        .font(.system(size: 38, weight: .bold, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.white,
                                    Color.cyan.opacity(0.9),
                                    Color.white
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .shadow(color: .black.opacity(0.7), radius: 10, x: 0, y: 4)
                        .shadow(color: .cyan.opacity(0.4), radius: 15, x: 0, y: 0)
                        .scaleEffect(titleScale)
                        .opacity(titleOpacity)
                }
                .padding(.bottom, 10)
                
                // Modern quş siyahısı / Modern bird list
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        ForEach(Array(BirdType.allCases.enumerated()), id: \.element) { index, type in
                            ModernBirdTypeCard(
                                type: type,
                                isSelected: birdTypeModel.selectedBirdType == type,
                                isUnlocked: birdTypeModel.isUnlocked(type),
                                scale: cardScale,
                                opacity: cardOpacity,
                                delay: Double(index) * 0.1,
                                onSelect: {
                                    // Quş növünü seçir / Selects bird type
                                    birdTypeModel.selectBirdType(type)
                                }
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
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
        withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.2)) {
            cardScale = 1.0
            cardOpacity = 1.0
        }
    }
}

/// Modern quş növü kartı / Modern Bird Type Card
struct ModernBirdTypeCard: View {
    let type: BirdType
    let isSelected: Bool
    let isUnlocked: Bool
    let scale: CGFloat
    let opacity: Double
    let delay: Double
    let onSelect: () -> Void
    
    @State private var glowIntensity: Double = 0.5
    @State private var isPressed = false
    
    var body: some View {
        let info = BirdTypeInfo.info(for: type)
        
        Button(action: {
            // Yalnız açılmış quşları seçə bilər / Can only select unlocked birds
            guard isUnlocked else { return }
            withAnimation(.spring(response: 0.2, dampingFraction: 0.5)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.2, dampingFraction: 0.5)) {
                    isPressed = false
                }
            onSelect()
            }
        }) {
            VStack(spacing: 12) {
                // Modern quş ikonu / Modern bird icon
                ZStack {
                    // Glow effect / Glow effect
                    Circle()
                        .fill(
                            RadialGradient(
                                gradient: Gradient(colors: [
                                    info.color.opacity(0.6 * glowIntensity),
                                    Color.clear
                                ]),
                                center: .center,
                                startRadius: 0,
                                endRadius: 50
                            )
                        )
                        .frame(width: 100, height: 100)
                        .blur(radius: 8)
                    
                    // Background circle / Arxa plan dairəsi
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    info.color.opacity(isUnlocked ? 0.4 : 0.15),
                                    info.color.opacity(isUnlocked ? 0.3 : 0.1)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 90, height: 90)
                        .overlay(
                            Circle()
                                .stroke(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            info.color.opacity(isUnlocked ? 0.7 : 0.3),
                                            info.color.opacity(isUnlocked ? 0.4 : 0.2)
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 2.5
                                )
                        )
                    
                    if isUnlocked {
                        BirdView(size: 45, velocity: 0, color: info.color)
                    } else {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 32, weight: .semibold))
                            .foregroundStyle(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.gray.opacity(0.8),
                                        Color.gray.opacity(0.6)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    }
                }
                .shadow(color: info.color.opacity(isUnlocked ? 0.4 : 0.1), radius: 8, x: 0, y: 4)
                
                // Modern ad / Modern name
                Text(info.name)
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                isUnlocked ? Color.white : Color.gray.opacity(0.8),
                                isUnlocked ? info.color.opacity(0.9) : Color.gray.opacity(0.6)
                            ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 2)
                
                // Modern tələb / Modern requirement
                if !isUnlocked {
                    Text(info.unlockRequirement)
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .foregroundColor(.gray.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .padding(.horizontal, 8)
                }
                
                // Modern seçilmiş göstəricisi / Modern selected indicator
                if isSelected && isUnlocked {
                    HStack(spacing: 6) {
                    Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 18, weight: .bold))
                        Text("Seçilmiş")
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                    }
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.green, Color.green.opacity(0.8)]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(Color.green.opacity(0.2))
                            .overlay(
                                Capsule()
                                    .stroke(Color.green.opacity(0.5), lineWidth: 1.5)
                            )
                    )
                    .shadow(color: .green.opacity(0.4), radius: 6, x: 0, y: 3)
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 22)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                isSelected && isUnlocked ? Color.white.opacity(0.35) : Color.white.opacity(0.2),
                                isSelected && isUnlocked ? Color.white.opacity(0.25) : Color.white.opacity(0.15)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
            )
            .overlay(
                        RoundedRectangle(cornerRadius: 22)
                            .stroke(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        isSelected && isUnlocked ? info.color.opacity(0.8) : Color.white.opacity(0.3),
                                        isSelected && isUnlocked ? info.color.opacity(0.5) : Color.white.opacity(0.2)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: isSelected && isUnlocked ? 3 : 2
                            )
            )
                    .shadow(color: .black.opacity(0.4), radius: 15, x: 0, y: 5)
            )
            .scaleEffect(isPressed ? 0.95 : scale)
            .opacity(opacity)
        }
        .disabled(!isUnlocked)
        .animation(.spring(response: 0.3, dampingFraction: 0.6).delay(delay), value: scale)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true).delay(delay)) {
                glowIntensity = 1.0
    }
}
    }
}
