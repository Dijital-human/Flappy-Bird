//
//  TutorialView.swift
//  Flappy Bird
//
//  Tutorial ekranı - ilk dəfə oynayanlar üçün təlimat
//  Tutorial Screen - instructions for first-time players
//

import SwiftUI

/// Tutorial ekranı görünüşü / Tutorial Screen View
struct TutorialView: View {
    let onClose: () -> Void  // Bağlama callback-i / Close callback
    
    @State private var currentPage: Int = 0
    
    // Tutorial səhifələri / Tutorial pages
    let pages: [(title: String, description: String, icon: String)] = [
        ("Oyunu Başlat", "Ekrana toxunaraq quşu uçurun", "hand.tap.fill"),
        ("Boruları Keçin", "Boruları keçərək xal qazanın", "arrow.right.circle.fill"),
        ("Toqquşmadan Qaçın", "Borulara və yerə toxunmamaya çalışın", "exclamationmark.triangle.fill"),
        ("Hazırsınız!", "Oyunu başlatmaq üçün hazır olun", "checkmark.circle.fill")
    ]
    
    var body: some View {
        ZStack {
            // Yarımşəffaf fon / Semi-transparent background
            Color.black.opacity(0.7)
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Bağlama düyməsi / Close button
                HStack {
                    Spacer()
                    Button(action: onClose) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                    }
                    .padding(20)
                }
                
                // Tutorial məzmunu / Tutorial content
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        VStack(spacing: 30) {
                            // İkon / Icon
                            Image(systemName: pages[index].icon)
                                .font(.system(size: 80))
                                .foregroundColor(.white)
                            
                            // Başlıq / Title
                            Text(pages[index].title)
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.white)
                            
                            // Təsvir / Description
                            Text(pages[index].description)
                                .font(.system(size: 18))
                                .foregroundColor(.white.opacity(0.9))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                        }
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .frame(height: 400)
                
                // Başlama düyməsi / Start button
                if currentPage == pages.count - 1 {
                    Button(action: onClose) {
                        Text("Başla")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 50)
                            .padding(.vertical, 15)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.blue, Color.purple]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(25)
                    }
                }
                
                Spacer()
            }
        }
    }
}

