//
//  DailyChallengeView.swift
//  Flappy Bird
//
//  Gündəlik challenge ekranı - hər gün fərqli tapşırıq
//  Daily Challenge Screen - different challenge each day
//

import SwiftUI

/// Gündəlik challenge ekranı görünüşü / Daily Challenge Screen View
struct DailyChallengeView: View {
    @ObservedObject var challengeModel: DailyChallengeModel
    let onClose: () -> Void  // Bağlama callback-i / Close callback
    
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
                
                // Başlıq / Title
                Text("Gündəlik Challenge")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                
                // Challenge məzmunu / Challenge content
                if let challenge = challengeModel.currentChallenge {
                    VStack(spacing: 20) {
                        // Challenge tipi / Challenge type
                        Text(challengeTypeName(challenge.type))
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(.yellow)
                        
                        // Hədəf / Target
                        Text("Hədəf: \(challenge.targetValue)")
                            .font(.system(size: 20))
                            .foregroundColor(.white.opacity(0.9))
                        
                        // İrəliləmə / Progress
                        VStack(spacing: 10) {
                            ProgressView(value: challengeModel.progress)
                                .progressViewStyle(LinearProgressViewStyle(tint: .green))
                                .scaleEffect(x: 1, y: 2, anchor: .center)
                            
                            Text("\(Int(challengeModel.progress * 100))%")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 40)
                        
                        // Mükafat / Reward
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            Text("Mükafat: \(challenge.reward) xal")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(Color.green.opacity(0.3))
                        .cornerRadius(15)
                        
                        // Tamamlandı göstəricisi / Completion indicator
                        if challengeModel.isCompleted {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                Text("Tamamlandı!")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.green)
                            }
                            .padding()
                            .background(Color.green.opacity(0.2))
                            .cornerRadius(15)
                        }
                    }
                    .padding(30)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(20)
                } else {
                    Text("Challenge yoxdur")
                        .font(.system(size: 18))
                        .foregroundColor(.white.opacity(0.7))
                }
                
                Spacer()
            }
            .padding(20)
        }
    }
    
    /// Challenge tipi adını qaytarır / Returns challenge type name
    private func challengeTypeName(_ type: ChallengeType) -> String {
        switch type {
        case .scoreTarget:
            return "Xal Hədəfi"
        case .surviveTime:
            return "Müddət Hədəfi"
        case .passPipes:
            return "Boru Hədəfi"
        case .noPowerUps:
            return "Power-up Olmadan"
        }
    }
}

