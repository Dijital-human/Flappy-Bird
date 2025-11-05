//
//  WeatherEffectView.swift
//  Flappy Bird
//
//  Hava effektləri görünüşü - yağış, qar
//  Weather Effects View - rain, snow
//

import SwiftUI

/// Hava effekti tipi / Weather effect type
enum WeatherEffectType {
    case none
    case rain
    case snow
}

/// Hava effektləri görünüşü / Weather Effects View
struct WeatherEffectView: View {
    let type: WeatherEffectType
    @State private var particles: [WeatherParticle] = []
    @State private var timer: Timer?
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(particles) { particle in
                    WeatherParticleView(particle: particle, type: type, size: geometry.size)
                }
            }
            .onAppear {
                // Partikulları yaradır / Creates particles
                createParticles(in: geometry.size)
                // Animasiya başlatır / Starts animation
                startAnimation(in: geometry.size)
            }
            .onChange(of: type) { oldValue, newValue in
                // Effekt dəyişdikdə partikulları yeniləyir / Updates particles when effect changes
                timer?.invalidate()
                createParticles(in: geometry.size)
                startAnimation(in: geometry.size)
            }
            .onDisappear {
                // Timer dayandırır / Stops timer
                timer?.invalidate()
            }
        }
    }
    
    /// Partikulları yaradır / Creates particles
    private func createParticles(in size: CGSize) {
        let count = type == .rain ? 50 : 30
        particles = (0..<count).map { _ in
            WeatherParticle(
                id: UUID(),
                position: CGPoint(
                    x: CGFloat.random(in: 0...size.width),
                    y: CGFloat.random(in: -size.height...0)
                ),
                velocity: type == .rain ? CGFloat.random(in: 3...8) : CGFloat.random(in: 1...3)
            )
        }
    }
    
    /// Animasiyanı başlatır / Starts animation
    private func startAnimation(in size: CGSize) {
        timer = Timer.scheduledTimer(withTimeInterval: 0.016, repeats: true) { _ in
            for i in particles.indices {
                particles[i].position.y += particles[i].velocity
                
                // Ekranın aşağısından çıxırsa, yuxarıdan başlayır / If goes below screen, starts from top
                if particles[i].position.y > size.height {
                    particles[i].position.y = -20
                    particles[i].position.x = CGFloat.random(in: 0...size.width)
                }
            }
        }
    }
}

/// Hava partikulu / Weather Particle
struct WeatherParticle: Identifiable {
    let id: UUID
    var position: CGPoint
    let velocity: CGFloat
}

/// Hava partikulu görünüşü / Weather Particle View
struct WeatherParticleView: View {
    let particle: WeatherParticle
    let type: WeatherEffectType
    let size: CGSize
    
    var body: some View {
        Group {
            if type == .rain {
                // Yağış damcısı / Rain drop
                Path { path in
                    path.move(to: CGPoint(x: 0, y: 0))
                    path.addLine(to: CGPoint(x: 0, y: 8))
                }
                .stroke(Color.blue.opacity(0.6), lineWidth: 2)
            } else if type == .snow {
                // Qar dənəsi / Snowflake
                Circle()
                    .fill(Color.white.opacity(0.8))
                    .frame(width: 4, height: 4)
            }
        }
        .position(particle.position)
    }
}

