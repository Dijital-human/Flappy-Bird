//
//  ViewHelpers.swift
//  Flappy Bird
//
//  Reusable view helper komponentlər və modifier-lər
//  Reusable view helper components and modifiers
//
//

import SwiftUI

// MARK: - Glassmorphism Modifier / Glassmorphism Modifier

/// Glassmorphism effect modifier / Glassmorphism effekt modifier-i
struct GlassmorphismModifier: ViewModifier {
    let cornerRadius: CGFloat
    let borderWidth: CGFloat
    let borderColors: [Color]
    let shadowRadius: CGFloat
    let shadowColor: Color
    
    init(
        cornerRadius: CGFloat = 16,
        borderWidth: CGFloat = 2,
        borderColors: [Color] = [Color.white.opacity(0.6), Color.white.opacity(0.3)],
        shadowRadius: CGFloat = 10,
        shadowColor: Color = .black.opacity(0.2)
    ) {
        self.cornerRadius = cornerRadius
        self.borderWidth = borderWidth
        self.borderColors = borderColors
        self.shadowRadius = shadowRadius
        self.shadowColor = shadowColor
    }
    
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(
                                LinearGradient(
                                    gradient: Gradient(colors: borderColors),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: borderWidth
                            )
                    )
            )
            .shadow(color: shadowColor, radius: shadowRadius, x: 0, y: 5)
    }
}

extension View {
    /// Glassmorphism effect tətbiq edir / Applies glassmorphism effect
    func glassmorphism(
        cornerRadius: CGFloat = 16,
        borderWidth: CGFloat = 2,
        borderColors: [Color] = [Color.white.opacity(0.6), Color.white.opacity(0.3)],
        shadowRadius: CGFloat = 10,
        shadowColor: Color = .black.opacity(0.2)
    ) -> some View {
        modifier(GlassmorphismModifier(
            cornerRadius: cornerRadius,
            borderWidth: borderWidth,
            borderColors: borderColors,
            shadowRadius: shadowRadius,
            shadowColor: shadowColor
        ))
    }
}

// MARK: - Gradient Helpers / Gradient Köməkçiləri

/// Gradient helper extension / Gradient köməkçi extension
extension LinearGradient {
    /// Yayılmış gradient yaradır / Creates common gradient
    static func common(colors: [Color], startPoint: UnitPoint = .topLeading, endPoint: UnitPoint = .bottomTrailing) -> LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: colors),
            startPoint: startPoint,
            endPoint: endPoint
        )
    }
    
    /// Glow effect gradient / Glow effekt gradient
    static func glow(colors: [Color]) -> LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: colors.map { $0.opacity(0.6) }),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

extension RadialGradient {
    /// Yayılmış radial gradient yaradır / Creates common radial gradient
    static func common(
        colors: [Color],
        center: UnitPoint = .center,
        startRadius: CGFloat = 0,
        endRadius: CGFloat = 100
    ) -> RadialGradient {
        RadialGradient(
            gradient: Gradient(colors: colors),
            center: center,
            startRadius: startRadius,
            endRadius: endRadius
        )
    }
}

// MARK: - Animation Helpers / Animasiya Köməkçiləri

/// Animation helper extension / Animasiya köməkçi extension
extension Animation {
    /// Pulse animasiyası / Pulse animation
    static var pulse: Animation {
        .easeInOut(duration: 1.5).repeatForever(autoreverses: true)
    }
    
    /// Spring animasiyası (yayılmış) / Common spring animation
    static var commonSpring: Animation {
        .spring(response: 0.3, dampingFraction: 0.6)
    }
    
    /// Glow animasiyası / Glow animation
    static var glow: Animation {
        .easeInOut(duration: 2.0).repeatForever(autoreverses: true)
    }
}

// MARK: - Common View Modifiers / Yayılmış View Modifier-lər

extension View {
    /// Glow effect modifier / Glow effekt modifier-i
    func glowEffect(
        color: Color = .white,
        radius: CGFloat = 10,
        intensity: Double = 0.6
    ) -> some View {
        self
            .shadow(color: color.opacity(intensity), radius: radius, x: 0, y: 0)
            .shadow(color: color.opacity(intensity * 0.5), radius: radius * 1.5, x: 0, y: 0)
    }
    
    /// Multiple shadow modifier / Çoxlu shadow modifier-i
    @ViewBuilder
    func multipleShadows(
        shadows: [(color: Color, radius: CGFloat, x: CGFloat, y: CGFloat)]
    ) -> some View {
        let firstShadow = shadows.first
        let remainingShadows = Array(shadows.dropFirst())
        
        if let first = firstShadow {
            self.shadow(color: first.color, radius: first.radius, x: first.x, y: first.y)
                .modifier(MultipleShadowsModifier(shadows: remainingShadows))
        } else {
            self
        }
    }
}

/// Multiple shadows modifier / Çoxlu shadow modifier
struct MultipleShadowsModifier: ViewModifier {
    let shadows: [(color: Color, radius: CGFloat, x: CGFloat, y: CGFloat)]
    
    func body(content: Content) -> some View {
        shadows.reduce(AnyView(content)) { view, shadow in
            AnyView(view.shadow(color: shadow.color, radius: shadow.radius, x: shadow.x, y: shadow.y))
        }
    }
}

// MARK: - Button Style Helpers / Düymə Stili Köməkçiləri

/// Modern button style / Modern düymə stili
struct ModernButtonStyle: ButtonStyle {
    let colors: [Color]
    let cornerRadius: CGFloat
    let glowEnabled: Bool
    
    init(
        colors: [Color],
        cornerRadius: CGFloat = 25,
        glowEnabled: Bool = true
    ) {
        self.colors = colors
        self.cornerRadius = cornerRadius
        self.glowEnabled = glowEnabled
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .background(
                ZStack {
                    if glowEnabled {
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(LinearGradient.glow(colors: colors))
                            .blur(radius: 8)
                    }
                    
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(LinearGradient.common(colors: colors))
                        .overlay(
                            RoundedRectangle(cornerRadius: cornerRadius)
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
    }
}

extension ButtonStyle where Self == ModernButtonStyle {
    /// Modern button style / Modern düymə stili
    static func modern(
        colors: [Color],
        cornerRadius: CGFloat = 25,
        glowEnabled: Bool = true
    ) -> ModernButtonStyle {
        ModernButtonStyle(
            colors: colors,
            cornerRadius: cornerRadius,
            glowEnabled: glowEnabled
        )
    }
}

