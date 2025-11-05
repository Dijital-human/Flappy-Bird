//
//  CountdownView.swift
//  Flappy Bird
//
//  Countdown ekranı - oyun başlanğıcından əvvəl 3-2-1
//  Countdown Screen - 3-2-1 before game starts
//

import SwiftUI

/// Countdown ekranı görünüşü / Countdown Screen View
struct CountdownView: View {
    @ObservedObject var localizationModel: LocalizationModel
    @State private var countdown: Int = 3
    @State private var opacity: Double = 1.0
    @State private var timer: Timer?
    let onFinish: () -> Void  // Countdown bitdikdə çağırılır / Called when countdown finishes
    
    var body: some View {
        ZStack {
            // Yarımşəffaf fon / Semi-transparent background
            Color.black.opacity(0.3)
                .ignoresSafeArea()
            
            // Countdown nömrəsi / Countdown number
            Text(countdown > 0 ? "\(countdown)" : localizationModel.translate("go"))
                .font(.system(size: 100, weight: .bold))
                .foregroundColor(.white)
                .shadow(color: .black, radius: 10)
                .opacity(opacity)
                .scaleEffect(countdown > 0 ? 1.0 : 1.5)
        }
        .onAppear {
            // Countdown animasiyasını başlatır / Starts countdown animation
            startCountdown()
        }
        .onDisappear {
            // Timer-i təmizləyir / Cleans up timer
            timer?.invalidate()
            timer = nil
        }
    }
    
    // MARK: - Animation / Animasiya
    
    /// Countdown animasiyasını başlatır / Starts countdown animation
    private func startCountdown() {
        // Timer ilə countdown-i idarə edir / Manages countdown with timer
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            withAnimation(.easeInOut(duration: 0.3)) {
                opacity = 0.3
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                countdown -= 1
                
                withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                    opacity = 1.0
                }
                
                if countdown < 0 {
                    timer.invalidate()
                    self.timer = nil
                    // Countdown bitdikdə oyunu başlatır / Starts game when countdown finishes
                    onFinish()
                }
            }
        }
    }
}

