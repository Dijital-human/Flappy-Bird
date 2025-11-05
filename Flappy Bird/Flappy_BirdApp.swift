//
//  Flappy_BirdApp.swift
//  Flappy Bird
//
//  Flappy Bird iOS Game
//  Flappy Bird iOS Oyunu
//
//  Təsvir / Description:
//  Bu oyun Flappy Bird stilində iOS mobil oyunudur.
//  SwiftUI və MVC arxitekturası ilə yaradılıb.
//  AdMob reklam inteqrasiyası daxildir.
//  Skor UserDefaults ilə saxlanılır.
//
//  This is a Flappy Bird-style iOS mobile game.
//  Built with SwiftUI and MVC architecture.
//  Includes AdMob ad integration.
//  Score is saved using UserDefaults.
//
//  Xüsusiyyətlər / Features:
//  - Quş idarəetməsi (tap ilə yuxarı) / Bird control (up with tap)
//  - Borular və toqquşma yoxlaması / Pipes and collision detection
//  - Skor sistemi / Score system
//  - Yüksək skor saxlanması / High score persistence
//  - AdMob banner və interstitial reklamlar / AdMob banner and interstitial ads
//
//  Created by Famil Mustafayev on 04.11.25.
//

import SwiftUI
import GoogleMobileAds

@main
struct Flappy_BirdApp: App {
    // AdMob-u başlatır / Initializes AdMob
    init() {
        // AdMob SDK-nı başlatır / Initializes AdMob SDK
        // QEYD: Burada real AdMob App ID-nizi dəyişdirməyi unutmayın
        // NOTE: Remember to replace this with your real AdMob App ID
        // Yeni SDK-da start() metodu async və ya completion handler qəbul etmir / New SDK start() is async or doesn't accept completion handler
        // AdMob Info.plist-də GADApplicationIdentifier vasitəsilə avtomatik başlayır / AdMob auto-starts via GADApplicationIdentifier in Info.plist
        
        // Test rejimini aktivləşdirir (inkişaf zamanı) / Enables test mode (during development)
        // İstehsal üçün bu sətri silin / Remove this line for production
        // MobileAds.shared.requestConfiguration.testDeviceIdentifiers = ["YOUR_DEVICE_ID"]
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
