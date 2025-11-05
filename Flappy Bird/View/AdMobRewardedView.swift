//
//  AdMobRewardedView.swift
//  Flappy Bird
//
//  Rewarded reklam idarəçisi - bonus xal üçün reklam izləmə
//  Rewarded Ad Manager - watch ad for bonus score
//

import SwiftUI
import UIKit
import GoogleMobileAds
import Combine

/// Rewarded reklam idarəçisi / Rewarded Ad Manager
@MainActor
class AdMobRewardedManager: NSObject, ObservableObject, FullScreenContentDelegate {
    // MARK: - Published Properties / Nəşr edilən xassələr
    
    @Published var rewardedAdLoaded: Bool = false
    @Published var rewardGranted: Bool = false
    
    // MARK: - Properties / Xassələr
    
    private var rewardedAd: RewardedAd?
    private var onRewardEarned: ((Int) -> Void)?  // Mükafat callback-i / Reward callback
    
    // MARK: - Constants / Sabitlər
    
    // QEYD: Real tətbiq üçün bu test ad unit ID-ni dəyişdirin
    // NOTE: For real app, replace this test ad unit ID
    private let rewardedAdUnitID = "ca-app-pub-3940256099942544/1712485313"  // Test ID / Test ID
    
    // MARK: - Initialization / İnitializasiya
    
    override init() {
        super.init()
        // Rewarded reklamı yükləyir / Loads rewarded ad
        loadRewardedAd()
    }
    
    // MARK: - Rewarded Ad Management / Rewarded reklam idarəetməsi
    
    /// Rewarded reklamı yükləyir / Loads rewarded ad
    func loadRewardedAd() {
        // Rewarded reklam yükləməsi / Rewarded ad loading
        RewardedAd.load(with: rewardedAdUnitID, request: Request()) { ad, error in
            Task { @MainActor [weak self] in
            guard let self = self else { return }
            
            if let error = error {
                // Xəta baş verərsə, konsola yazır / If error occurs, logs to console
                print("Rewarded reklam yüklənmə xətası / Rewarded ad loading error: \(error.localizedDescription)")
                self.rewardedAdLoaded = false
                return
            }
            
            // Reklam yükləndi / Ad loaded
            self.rewardedAd = ad
            self.rewardedAd?.fullScreenContentDelegate = self
            self.rewardedAdLoaded = true
            }
        }
    }
    
    /// Rewarded reklamı göstərir / Shows rewarded ad
    func showRewardedAd(onRewardEarned: @escaping (Int) -> Void) {
        guard let rewardedAd = rewardedAd, rewardedAdLoaded else {
            // Reklam yüklənməyibsə, yükləyir / If ad not loaded, loads it
            loadRewardedAd()
            return
        }
        
        // Mükafat callback-i təyin edir / Sets reward callback
        self.onRewardEarned = onRewardEarned
        
        // Rewarded reklamı göstərir / Shows rewarded ad
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            rewardedAd.present(from: rootViewController) { [weak self] in
                // Mükafat verilir / Reward granted
                self?.rewardGranted = true
                self?.onRewardEarned?(10)  // 10 xal mükafat / 10 points reward
            }
        }
    }
    
    // MARK: - FullScreenContentDelegate / FullScreenContentDelegate
    
    /// Reklam göstəriləndə çağırılır / Called when ad is presented
    func adWillPresentFullScreenContent(_ ad: FullScreenPresentingAd) {
        // Musiqini dayandırır / Stops music
        NotificationCenter.default.post(name: NSNotification.Name("PauseBackgroundMusic"), object: nil)
        print("🔇 Musiqi dayandırıldı (rewarded reklam göstərilir) / Music paused (rewarded ad showing)")
    }
    
    /// Reklam bağlandıqda çağırılır / Called when ad is dismissed
    func ad(_ ad: FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        // Xəta baş verərsə, yeni reklam yükləyir / If error occurs, loads new ad
        loadRewardedAd()
        // Musiqini yenidən başlatır (xəta baş verərsə) / Resumes music (if error occurred)
        NotificationCenter.default.post(name: NSNotification.Name("ResumeBackgroundMusic"), object: nil)
    }
    
    /// Reklam bağlandıqda çağırılır / Called when ad is dismissed
    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        // Yeni reklam yükləyir / Loads new ad
        loadRewardedAd()
        // Musiqini yenidən başlatır / Resumes music
        NotificationCenter.default.post(name: NSNotification.Name("ResumeBackgroundMusic"), object: nil)
        print("🔊 Musiqi davam edir (rewarded reklam bağlandı) / Music resumed (rewarded ad dismissed)")
    }
}

