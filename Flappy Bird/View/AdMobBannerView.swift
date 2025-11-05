//
//  AdMobBannerView.swift
//  Flappy Bird
//
//  AdMob Banner reklam görünüşü
//  AdMob Banner Ad View
//

import SwiftUI
import GoogleMobileAds

/// AdMob Banner reklamını SwiftUI ilə inteqrasiya etmək üçün UIViewRepresentable
/// UIViewRepresentable to integrate AdMob Banner ad with SwiftUI
struct AdMobBannerView: UIViewRepresentable {
    // Test reklam ID-si / Test ad unit ID
    // QEYD: Burada real reklam ID-nizi dəyişdirməyi unutmayın
    // NOTE: Remember to replace this with your real ad unit ID
    let adUnitID = "ca-app-pub-3940256099942544/2934735716" // Test ID / Test ID
    
    func makeUIView(context: Context) -> BannerView {
        // Banner reklam görünüşü yaradır / Creates banner ad view
        let bannerView = BannerView(adSize: AdSizeBanner)
        
        // Reklam ID-sini təyin edir / Sets ad unit ID
        bannerView.adUnitID = adUnitID
        
        // Root view controller tapır / Finds root view controller
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            bannerView.rootViewController = rootViewController
        }
        
        // Reklam yükləyir / Loads ad
        let request = Request()
        bannerView.load(request)
        
        return bannerView
    }
    
    func updateUIView(_ uiView: BannerView, context: Context) {
        // Görünüş yenilənəndə heç bir işləməyir / No action when view updates
    }
}

