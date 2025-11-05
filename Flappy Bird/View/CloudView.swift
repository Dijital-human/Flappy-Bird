//
//  CloudView.swift
//  Flappy Bird
//
//  Bulud görünüşü - fon üçün
//  Cloud View - for background
//

import SwiftUI

/// Real bulud görünüşü komponenti / Realistic Cloud View Component
struct CloudView: View {
    @State private var cloudOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            // Real bulud formasi - daha təbii görünüş / Realistic cloud shape - more natural appearance
            // Əsas bulud kütləsi / Main cloud mass
            Group {
                // Böyük orta hissə / Large center part
                Ellipse()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.white.opacity(0.85),
                                Color.white.opacity(0.75),
                                Color.white.opacity(0.65)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 80)
                    .offset(x: 0, y: 0)
                    .shadow(color: .white.opacity(0.3), radius: 15, x: 0, y: 5)
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 3)
                
                // Sol üst hissə / Left top part
                Ellipse()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.white.opacity(0.9),
                                Color.white.opacity(0.8),
                                Color.white.opacity(0.7)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 90, height: 70)
                    .offset(x: -35, y: -20)
                    .shadow(color: .white.opacity(0.2), radius: 12, x: -3, y: -3)
                
                // Sağ üst hissə / Right top part
                Ellipse()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.white.opacity(0.9),
                                Color.white.opacity(0.8),
                                Color.white.opacity(0.7)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 85, height: 65)
                    .offset(x: 40, y: -25)
                    .shadow(color: .white.opacity(0.2), radius: 12, x: 3, y: -3)
                
                // Sol alt hissə / Left bottom part
                Ellipse()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.white.opacity(0.8),
                                Color.white.opacity(0.7),
                                Color.white.opacity(0.6)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 75, height: 60)
                    .offset(x: -45, y: 15)
                    .shadow(color: .white.opacity(0.2), radius: 10, x: -2, y: 2)
                
                // Sağ alt hissə / Right bottom part
                Ellipse()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.white.opacity(0.8),
                                Color.white.opacity(0.7),
                                Color.white.opacity(0.6)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 70, height: 55)
                    .offset(x: 50, y: 20)
                    .shadow(color: .white.opacity(0.2), radius: 10, x: 2, y: 2)
                
                // Kiçik detallar / Small details
                Ellipse()
                    .fill(Color.white.opacity(0.7))
                    .frame(width: 50, height: 40)
                    .offset(x: -60, y: -5)
                    .blur(radius: 3)
                
                Ellipse()
                    .fill(Color.white.opacity(0.7))
                    .frame(width: 45, height: 35)
                    .offset(x: 65, y: 5)
                    .blur(radius: 3)
            }
            .blur(radius: 0.5) // Yumşaq kənarlar / Soft edges
            
            // İçəridə parıltı / Inner shine
            Ellipse()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            Color.white.opacity(0.4),
                            Color.clear
                        ]),
                        center: .topLeading,
                        startRadius: 0,
                        endRadius: 50
                    )
                )
                .frame(width: 100, height: 70)
                .offset(x: -10, y: -10)
                .blur(radius: 8)
        }
        .blur(radius: 1) // Ümumi yumşaqlıq / Overall softness
    }
}

#Preview {
    ZStack {
        LinearGradient(
            gradient: Gradient(colors: [
                Color.blue.opacity(0.5),
                Color.cyan.opacity(0.3)
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
        
    CloudView()
            .scaleEffect(1.5)
    }
}
