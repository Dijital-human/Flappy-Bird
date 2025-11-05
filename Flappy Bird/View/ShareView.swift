//
//  ShareView.swift
//  Flappy Bird
//
//  Paylaşım funksiyası - skor paylaşımı
//  Share Function - score sharing
//

import SwiftUI

/// Paylaşım funksiyası / Share Function
struct ShareView {
    /// Skor paylaşır / Shares score
    static func shareScore(score: Int, highScore: Int) {
        // Paylaşım mətnı / Share text
        let shareText = "Flappy Bird oyununda \(score) xal qazandım! Yüksək skorum: \(highScore) 🎮"
        
        // Paylaşım aktivliyini yaradır / Creates share activity
        let activityVC = UIActivityViewController(
            activityItems: [shareText],
            applicationActivities: nil
        )
        
        // Əsas ekranı alır / Gets main screen
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            // iPad üçün popover / Popover for iPad
            if let popover = activityVC.popoverPresentationController {
                popover.sourceView = rootViewController.view
                popover.sourceRect = CGRect(x: rootViewController.view.bounds.midX,
                                           y: rootViewController.view.bounds.midY,
                                           width: 0, height: 0)
                popover.permittedArrowDirections = []
            }
            
            rootViewController.present(activityVC, animated: true)
        }
    }
}



