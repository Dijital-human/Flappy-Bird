//
//  StatisticsView.swift
//  Flappy Bird
//
//  Statistikalar ekranı - oyun statistikalarını göstərir
//  Statistics Screen - shows game statistics
//
//

import SwiftUI

/// Statistikalar ekranı görünüşü / Statistics Screen View
struct StatisticsView: View {
    @ObservedObject var statisticsModel: StatisticsModel
    let onClose: () -> Void  // Bağlama funksiyası / Close function
    
    @State private var cardScale: CGFloat = 0.8
    @State private var cardOpacity: Double = 0
    @State private var titleScale: CGFloat = 0.5
    @State private var titleOpacity: Double = 0
    
    var body: some View {
        ZStack {
            // Modern gradient fon / Modern gradient background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.blue.opacity(0.8),
                    Color.purple.opacity(0.7),
                    Color.pink.opacity(0.6)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
                .ignoresSafeArea()
            
            // Animated particles / Animasiyalı partikullar
            ForEach(0..<8, id: \.self) { index in
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                Color.white.opacity(0.3),
                                Color.clear
                            ]),
                            center: .center,
                            startRadius: 0,
                            endRadius: 40
                        )
                    )
                    .frame(width: CGFloat(20 + index * 5), height: CGFloat(20 + index * 5))
                    .offset(
                        x: CGFloat(index * 60 - 210) + sin(Double(index) * 0.5 + Date().timeIntervalSince1970 * 0.5) * 40,
                        y: CGFloat(index * 50 - 150) + cos(Double(index) * 0.3 + Date().timeIntervalSince1970 * 0.3) * 30
                    )
                    .blur(radius: 8)
            }
            
            VStack(spacing: 30) {
                // Modern başlıq / Modern title
                ZStack {
                    // Glow effect / Glow effect
                Text("Statistics")
                        .font(.system(size: 42, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                        .blur(radius: 6)
                        .scaleEffect(titleScale)
                        .opacity(titleOpacity)
                    
                    // Main text / Əsas mətn
                    Text("Statistics")
                        .font(.system(size: 42, weight: .bold, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.white,
                                    Color.cyan.opacity(0.9),
                                    Color.white
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .shadow(color: .black.opacity(0.7), radius: 10, x: 0, y: 4)
                        .shadow(color: .cyan.opacity(0.4), radius: 15, x: 0, y: 0)
                        .scaleEffect(titleScale)
                        .opacity(titleOpacity)
                }
                    .padding(.top, 50)
                
                ScrollView {
                    // Modern statistikalar kartları / Modern statistics cards
                    VStack(spacing: 18) {
                    // Oyun sayı / Games played
                        ModernStatisticsCard(
                        icon: "gamecontroller.fill",
                        title: "Games Played",
                        value: "\(statisticsModel.totalGames)",
                            color: .blue,
                            scale: cardScale,
                            opacity: cardOpacity,
                            delay: 0.1
                    )
                    
                    // Ümumi skor / Total score
                        ModernStatisticsCard(
                        icon: "star.fill",
                        title: "Total Score",
                            value: formatNumber(statisticsModel.totalScore),
                            color: .yellow,
                            scale: cardScale,
                            opacity: cardOpacity,
                            delay: 0.2
                    )
                    
                        // Orta skor / Average score (düzəldilmiş formatlaşdırma)
                        ModernStatisticsCard(
                        icon: "chart.bar.fill",
                        title: "Average Score",
                            value: formatAverageScore(statisticsModel.averageScore),
                            color: .green,
                            scale: cardScale,
                            opacity: cardOpacity,
                            delay: 0.3
                    )
                    
                    // Maksimum skor / Max score
                        ModernStatisticsCard(
                        icon: "trophy.fill",
                        title: "Best Score",
                        value: "\(statisticsModel.maxScore)",
                            color: .orange,
                            scale: cardScale,
                            opacity: cardOpacity,
                            delay: 0.4
                    )
                    
                    // Ən yaxşı seriya / Best streak
                        ModernStatisticsCard(
                        icon: "flame.fill",
                        title: "Best Streak",
                        value: "\(statisticsModel.bestStreak)",
                            color: .red,
                            scale: cardScale,
                            opacity: cardOpacity,
                            delay: 0.5
                    )
                    
                    // Ən uzun oyun / Longest game
                        ModernStatisticsCard(
                        icon: "clock.fill",
                        title: "Longest Game",
                            value: formatTime(statisticsModel.longestGame),
                            color: .purple,
                            scale: cardScale,
                            opacity: cardOpacity,
                            delay: 0.6
                    )
                    
                    // Keçilən borular / Pipes passed
                        ModernStatisticsCard(
                        icon: "arrow.right.circle.fill",
                        title: "Pipes Passed",
                            value: formatNumber(statisticsModel.totalPipesPassed),
                            color: .cyan,
                            scale: cardScale,
                            opacity: cardOpacity,
                            delay: 0.7
                    )
                }
                .padding(.horizontal, 20)
                }
                
                Spacer()
                
                // Modern bağlama düyməsi / Modern close button
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    onClose()
                    }
                }) {
                    HStack(spacing: 10) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 20, weight: .semibold))
                    Text("Close")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                    }
                        .foregroundColor(.white)
                        .padding(.horizontal, 50)
                    .padding(.vertical, 16)
                        .background(
                        ZStack {
                            // Glow effect / Glow effect
                            RoundedRectangle(cornerRadius: 30)
                                .fill(
                            LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color.blue.opacity(0.6),
                                            Color.purple.opacity(0.6)
                                        ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                                .blur(radius: 8)
                            
                            // Main button / Əsas düymə
                            RoundedRectangle(cornerRadius: 30)
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color.blue,
                                            Color.purple.opacity(0.9)
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 30)
                                        .stroke(
                                            LinearGradient(
                                                gradient: Gradient(colors: [
                                                    Color.white.opacity(0.4),
                                                    Color.white.opacity(0.1)
                                                ]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            lineWidth: 1.5
                                        )
                                )
                        }
                    )
                    .shadow(color: .black.opacity(0.5), radius: 12, x: 0, y: 6)
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
        withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.2)) {
            cardScale = 1.0
            cardOpacity = 1.0
        }
    }
    
    // MARK: - Formatting Helpers / Formatlaşdırma köməkçiləri
    
    /// Rəqəmi formatlaşdırır / Formats number
    private func formatNumber(_ number: Int) -> String {
        if number >= 1000000 {
            return String(format: "%.1fM", Double(number) / 1000000.0)
        } else if number >= 1000 {
            return String(format: "%.1fK", Double(number) / 1000.0)
        }
        return "\(number)"
    }
    
    /// Orta skoru formatlaşdırır / Formats average score
    private func formatAverageScore(_ score: Double) -> String {
        if score == 0.0 {
            return "0.0"
        }
        // Əgər tam ədəddirsə, ondalıq hissəni göstərmə / If whole number, don't show decimal
        if score.truncatingRemainder(dividingBy: 1) == 0 {
            return String(format: "%.0f", score)
        }
        // Əks halda bir ondalıq yeri göstər / Otherwise show one decimal place
        return String(format: "%.1f", score)
    }
    
    /// Vaxtı formatlaşdırır / Formats time
    private func formatTime(_ time: TimeInterval) -> String {
        if time < 60 {
            return String(format: "%.0fs", time)
        } else {
            let minutes = Int(time) / 60
            let seconds = Int(time) % 60
            return String(format: "%dm %ds", minutes, seconds)
        }
    }
}

/// Modern statistikalar kartı komponenti / Modern Statistics Card Component
struct ModernStatisticsCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    let scale: CGFloat
    let opacity: Double
    let delay: Double
    
    @State private var glowIntensity: Double = 0.5
    
    var body: some View {
        HStack(spacing: 20) {
            // Icon with glow / Parıltı ilə ikon
            ZStack {
                // Glow effect / Glow effect
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                color.opacity(0.6 * glowIntensity),
                                Color.clear
                            ]),
                            center: .center,
                            startRadius: 0,
                            endRadius: 30
                        )
                    )
                    .frame(width: 60, height: 60)
                    .blur(radius: 5)
                
                // Icon background / İkon arxa planı
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                color.opacity(0.3),
                                color.opacity(0.2)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 56, height: 56)
                    .overlay(
                        Circle()
                            .stroke(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        color.opacity(0.6),
                                        color.opacity(0.3)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 2
                            )
                    )
                
                // Icon / İkon
            Image(systemName: icon)
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                color,
                                color.opacity(0.8)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .font(.system(size: 26, weight: .semibold))
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.85))
                
                ZStack {
                    // Glow effect / Glow effect
                Text(value)
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                        .blur(radius: 3)
                    
                    // Main text / Əsas mətn
                    Text(value)
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.white,
                                    color.opacity(0.9),
                                    Color.white
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 2)
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 25)
        .padding(.vertical, 22)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.white.opacity(0.25),
                            Color.white.opacity(0.15)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: .black.opacity(0.4), radius: 15, x: 0, y: 5)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.white.opacity(0.4),
                                    Color.white.opacity(0.2)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2
                        )
                )
        )
        .scaleEffect(scale)
        .opacity(opacity)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true).delay(delay)) {
                glowIntensity = 1.0
    }
}
    }
}
