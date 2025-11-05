//
//  EnvironmentSelectionView.swift
//  Flappy Bird
//
//  Mühit seçimi ekranı - fərqli mühitlər
//  Environment Selection Screen - different environments
//

import SwiftUI

/// Mühit seçimi ekranı görünüşü / Environment Selection Screen View
struct EnvironmentSelectionView: View {
    @ObservedObject var environmentModel: EnvironmentModel
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
                Text("Mühitlər")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                
                // Mühit siyahısı / Environment list
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        ForEach(EnvironmentType.allCases, id: \.self) { type in
                            EnvironmentTypeCard(
                                type: type,
                                isSelected: environmentModel.selectedEnvironment == type,
                                isUnlocked: environmentModel.isUnlocked(type),
                                onSelect: {
                                    // Mühiti seçir / Selects environment
                                    environmentModel.selectEnvironment(type)
                                }
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
    }
}

/// Mühit növü kartı / Environment Type Card
struct EnvironmentTypeCard: View {
    let type: EnvironmentType
    let isSelected: Bool
    let isUnlocked: Bool
    let onSelect: () -> Void
    
    var body: some View {
        let info = EnvironmentInfo.info(for: type)
        
        Button(action: {
            // Yalnız açılmış mühitləri seçə bilər / Can only select unlocked environments
            guard isUnlocked else { return }
            onSelect()
        }) {
            VStack(spacing: 10) {
                // Mühit ikonu / Environment icon
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: info.gradientColors),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 120, height: 80)
                    
                    if !isUnlocked {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.gray)
                    }
                }
                
                // Ad / Name
                Text(info.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(isUnlocked ? .white : .gray)
                
                // Tələb / Requirement
                if !isUnlocked {
                    Text(info.unlockRequirement)
                        .font(.system(size: 12))
                        .foregroundColor(.gray.opacity(0.7))
                        .multilineTextAlignment(.center)
                }
                
                // Seçilmiş göstəricisi / Selected indicator
                if isSelected && isUnlocked {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.system(size: 20))
                }
            }
            .padding(15)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(isSelected ? Color.blue.opacity(0.3) : Color.white.opacity(0.1))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
            )
        }
        .disabled(!isUnlocked)
    }
}



