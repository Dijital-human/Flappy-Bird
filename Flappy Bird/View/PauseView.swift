//
//  PauseView.swift
//  Flappy Bird
//
//  Pause ekranı - oyun dayandırıldıqda
//  Pause Screen - when game is paused
//

import SwiftUI

/// Pause ekranı görünüşü / Pause Screen View
struct PauseView: View {
    let onResume: () -> Void  // Oyunu davam etdirmə funksiyası / Resume game function
    let onHome: () -> Void    // Ana ekrana qayıtma funksiyası / Return to home function
    
    var body: some View {
        ZStack {
            // Yarımşəffaf fon / Semi-transparent background
            Color.black.opacity(0.7)
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Pause başlığı / Pause title
                Text("Paused")
                    .font(.system(size: 50, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(color: .black, radius: 8)
                
                // Düymələr / Buttons
                VStack(spacing: 20) {
                    // Davam etdirmə düyməsi / Resume button
                    Button(action: {
                        // Oyunu davam etdirir / Resumes the game
                        onResume()
                    }) {
                        HStack {
                            Image(systemName: "play.fill")
                            Text("Resume")
                        }
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 50)
                        .padding(.vertical, 18)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.green, Color.green.opacity(0.8)]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(30)
                        .shadow(color: .black.opacity(0.4), radius: 8, x: 0, y: 4)
                    }
                    
                    // Ana ekrana qayıtma düyməsi / Back to home button
                    Button(action: {
                        // Ana ekrana qayıdır / Returns to home screen
                        onHome()
                    }) {
                        HStack {
                            Image(systemName: "house.fill")
                            Text("Home")
                        }
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 15)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.8)]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(25)
                        .shadow(color: .black.opacity(0.4), radius: 8, x: 0, y: 4)
                    }
                }
            }
        }
    }
}

