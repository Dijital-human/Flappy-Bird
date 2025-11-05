//
//  AdMobInterstitialView.swift
//  Flappy Bird
//
//  AdMob Interstitial reklam idarəçisi
//  AdMob Interstitial Ad Manager
//

import Foundation
import GoogleMobileAds
import Combine

/// AdMob Interstitial reklam idarəçisi
/// AdMob Interstitial Ad Manager
@MainActor
class AdMobInterstitialManager: NSObject, ObservableObject {
    // Test reklam ID-si / Test ad unit ID
    // QEYD: Burada real reklam ID-nizi dəyişdirməyi unutmayın
    // NOTE: Remember to replace this with your real ad unit ID
    private let adUnitID = "ca-app-pub-3940256099942544/4411468910" // Test ID / Test ID
    
    @Published var interstitial: InterstitialAd?
    
    override init() {
        super.init()
        // Interstitial reklamı yükləyir / Loads interstitial ad
        loadInterstitial()
    }
    
    /// Interstitial reklamı yükləyir / Loads interstitial ad
    func loadInterstitial() {
        // Reklam sorğusu yaradır / Creates ad request
        let request = Request()
        
        // Interstitial reklamı yükləyir / Loads interstitial ad
        InterstitialAd.load(with: adUnitID, request: request) { [weak self] ad, error in
            Task { @MainActor [weak self] in
                guard let strongSelf = self else { return }
                
            if let error = error {
                // Xəta baş verərsə, konsola yazır / If error occurs, logs to console
                print("Interstitial reklam yüklənmədi / Interstitial ad failed to load: \(error.localizedDescription)")
                return
            }
            
            // Reklam uğurla yüklənibsə, saxlayır / If ad loaded successfully, stores it
                strongSelf.interstitial = ad
                strongSelf.interstitial?.fullScreenContentDelegate = strongSelf
            }
        }
    }
    
    /// Interstitial reklamı göstərir / Shows interstitial ad
    func showInterstitial() {
        // Reklam hazırdırsa, göstərir / If ad is ready, shows it
        guard let interstitial = interstitial else {
            // Reklam hazır deyilsə, yenidən yükləyir / If ad is not ready, reloads
            loadInterstitial()
            return
        }
        
        // Root view controller tapır / Finds root view controller
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            // Reklamı göstərir / Shows ad
            interstitial.present(from: rootViewController)
        }
    }
}

// MARK: - FullScreenContentDelegate / FullScreenContentDelegate

extension AdMobInterstitialManager: FullScreenContentDelegate {
    /// Reklam bağlandıqdan sonra çağırılır / Called after ad is dismissed
    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        // Reklam bağlandıqdan sonra yeni reklam yükləyir / Loads new ad after dismissal
        loadInterstitial()
        // Musiqini yenidən başlatır / Resumes music
        NotificationCenter.default.post(name: NSNotification.Name("ResumeBackgroundMusic"), object: nil)
        print("🔊 Musiqi davam edir (reklam bağlandı) / Music resumed (ad dismissed)")
    }
    
    /// Reklam göstəriləndə çağırılır / Called when ad is presented
    func adWillPresentFullScreenContent(_ ad: FullScreenPresentingAd) {
        // Reklam göstərildiyini qeyd edir / Notes that ad is presented
        // Musiqini dayandırır / Stops music
        NotificationCenter.default.post(name: NSNotification.Name("PauseBackgroundMusic"), object: nil)
        print("🔇 Musiqi dayandırıldı (reklam göstərilir) / Music paused (ad showing)")
    }
    
    /// Reklam yüklənmədiyi zaman çağırılır / Called when ad fails to load
    func ad(_ ad: FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        // Xəta baş verərsə, konsola yazır və yenidən yükləyir / If error occurs, logs and reloads
        print("Interstitial reklam göstərilmədi / Interstitial ad failed to present: \(error.localizedDescription)")
        loadInterstitial()
    }
}

