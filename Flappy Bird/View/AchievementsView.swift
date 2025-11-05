//
//  AchievementsView.swift
//  Flappy Bird
//
//  Achievements ekranı - nailiyyətlər sistemi
//  Achievements Screen - achievements system
//

import SwiftUI

/// Achievements ekranı görünüşü / Achievements Screen View
struct AchievementsView: View {
    @ObservedObject var achievementModel: AchievementModel
    let onClose: () -> Void  // Bağlama callback-i / Close callback
    
    var body: some View {
        ZStack {
            // Yarımşəffaf fon / Semi-transparent background
            Color.black.opacity(0.7)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
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
                
                // Başlıq / Title
                Text("Nailiyyətlər")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                
                // Achievement siyahısı / Achievement list
                ScrollView {
                    LazyVStack(spacing: 15) {
                        ForEach(AchievementType.allCases, id: \.self) { type in
                            AchievementRow(
                                achievement: AchievementInfo.info(for: type),
                                isCompleted: achievementModel.isCompleted(type)
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
    }
}

/// Achievement sətri / Achievement Row
struct AchievementRow: View {
    let achievement: AchievementInfo
    let isCompleted: Bool
    
    var body: some View {
        HStack(spacing: 15) {
            // İkon / Icon
            Image(systemName: achievement.icon)
                .font(.system(size: 30))
                .foregroundColor(isCompleted ? achievement.color : .gray)
            
            // Məlumat / Information
            VStack(alignment: .leading, spacing: 5) {
                Text(achievement.name)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(isCompleted ? .white : .gray)
                
                Text(achievement.description)
                    .font(.system(size: 14))
                    .foregroundColor(isCompleted ? .white.opacity(0.8) : .gray.opacity(0.7))
            }
            
            Spacer()
            
            // Tamamlandı göstəricisi / Completion indicator
            if isCompleted {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                    .font(.system(size: 24))
            } else {
                Image(systemName: "circle")
                    .foregroundColor(.gray)
                    .font(.system(size: 24))
            }
        }
        .padding(15)
        .background(
            isCompleted ? Color.white.opacity(0.2) : Color.white.opacity(0.05)
        )
        .cornerRadius(15)
    }
}

