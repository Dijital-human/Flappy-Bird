//
//  PowerUpIndicatorView.swift
//  Flappy Bird
//
//  Power-up göstərici ekranı - oyun zamanı aktiv power-up-lər
//  Power-up Indicator Screen - active power-ups during gameplay
//

import SwiftUI

/// Power-up göstərici görünüşü / Power-up Indicator View
struct PowerUpIndicatorView: View {
    @ObservedObject var powerUpModel: PowerUpModel
    
    var body: some View {
        VStack(spacing: 10) {
            // Aktiv power-up-lər / Active power-ups
            ForEach(powerUpModel.activePowerUps) { powerUp in
                if powerUp.endTime > Date() {
                    PowerUpBadge(type: powerUp.type, remainingTime: powerUpModel.remainingTime(for: powerUp.type))
                }
            }
        }
        .padding(.top, 100)
        .padding(.trailing, 20)
    }
}

/// Power-up nişanı / Power-up Badge
struct PowerUpBadge: View {
    let type: PowerUpType
    let remainingTime: TimeInterval
    
    var body: some View {
        let info = PowerUpInfo.info(for: type)
        
        HStack(spacing: 8) {
            // İkon / Icon
            Image(systemName: info.icon)
                .font(.system(size: 16))
                .foregroundColor(info.color)
            
            // Qalan müddət / Remaining time
            Text("\(Int(remainingTime))s")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.white)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(
            Capsule()
                .fill(Color.black.opacity(0.5))
        )
    }
}



