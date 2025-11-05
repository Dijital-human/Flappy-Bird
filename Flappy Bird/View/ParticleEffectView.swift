//
//  ParticleEffectView.swift
//  Flappy Bird
//
//  Partikul effekti görünüşü - animasiya üçün
//  Particle Effect View - for animations
//

import SwiftUI

/// Partikul effekti görünüşü / Particle Effect View
struct ParticleEffectView: View {
    let position: CGPoint
    let color: Color
    @State private var particles: [Particle] = []
    @State private var animationProgress: Double = 0
    
    var body: some View {
        ZStack {
            ForEach(particles) { particle in
                ZStack {
                    // Outer glow / Xarici parıltı
                    Circle()
                        .fill(
                            RadialGradient(
                                gradient: Gradient(colors: [
                                    color.opacity(particle.opacity * 0.5),
                                    Color.clear
                                ]),
                                center: .center,
                                startRadius: 0,
                                endRadius: particle.size * 1.5
                            )
                        )
                        .frame(width: particle.size * 3, height: particle.size * 3)
                        .blur(radius: 3)
                    
                    // Main particle / Əsas partikul
                Circle()
                        .fill(
                            RadialGradient(
                                gradient: Gradient(colors: [
                                    color.opacity(particle.opacity),
                                    color.opacity(particle.opacity * 0.6),
                                    Color.clear
                                ]),
                                center: .center,
                                startRadius: 0,
                                endRadius: particle.size
                            )
                        )
                    .frame(width: particle.size, height: particle.size)
                    
                    // Shine effect / Parıltı effekti
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.white.opacity(particle.opacity * 0.8),
                                    Color.clear
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: particle.size * 0.4, height: particle.size * 0.4)
                        .offset(x: -particle.size * 0.2, y: -particle.size * 0.2)
                }
                    .position(particle.position)
                .scaleEffect(particle.scale)
            }
        }
        .onAppear {
            // Partikulları yaradır / Creates particles
            createParticles()
        }
    }
    
    // MARK: - Particle Creation / Partikul yaratma
    
    /// Partikulları yaradır / Creates particles
    private func createParticles() {
        // 30 partikul yaradır (daha çox effekt) / Creates 30 particles (more effect)
        for i in 0..<30 {
            let angle = Double(i) * (2 * .pi / 30)
            let speed = Double.random(in: 40...100)
            let particle = Particle(
                id: UUID(),
                position: position,
                velocity: CGPoint(
                    x: cos(angle) * speed,
                    y: sin(angle) * speed
                ),
                size: CGFloat.random(in: 4...10),
                opacity: 1.0,
                scale: 1.0
            )
            particles.append(particle)
        }
        
        // Partikulları hərəkət etdirir / Moves particles
        animateParticles()
    }
    
    /// Partikulları animasiya edir / Animates particles
    private func animateParticles() {
        // 0.8 saniyə ərzində partikulları animasiya edir / Animates particles over 0.8 seconds
        withAnimation(.easeOut(duration: 0.8)) {
            for i in particles.indices {
                particles[i].position.x += particles[i].velocity.x
                particles[i].position.y += particles[i].velocity.y
                particles[i].opacity = 0.0
                particles[i].size = 0
                particles[i].scale = 0
            }
        }
        
        // Partikulları silir / Removes particles
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            particles.removeAll()
        }
    }
}

/// Partikul modeli / Particle Model
struct Particle: Identifiable {
    let id: UUID
    var position: CGPoint
    let velocity: CGPoint
    var size: CGFloat
    var opacity: Double
    var scale: CGFloat
}
