//
//  DisplayLinkView.swift
//  Flappy Bird
//
//  CADisplayLink wrapper - 60 FPS üçün optimal performans
//  CADisplayLink wrapper - optimal performance for 60 FPS
//
//

import SwiftUI
import UIKit
import QuartzCore

/// CADisplayLink wrapper - ekran yeniləməsi ilə sinxron işləyir
/// CADisplayLink wrapper - works synchronously with screen refresh
struct DisplayLinkView: UIViewRepresentable {
    let isActive: Bool
    let onUpdate: () -> Void
    
    func makeUIView(context: Context) -> DisplayLinkWrapper {
        let wrapper = DisplayLinkWrapper()
        wrapper.onUpdate = onUpdate
        wrapper.isActive = isActive
        return wrapper
    }
    
    func updateUIView(_ uiView: DisplayLinkWrapper, context: Context) {
        // Update callback-i və aktivlik vəziyyətini yeniləyir / Updates update callback and active state
        uiView.onUpdate = onUpdate
        uiView.isActive = isActive
    }
}

/// CADisplayLink wrapper class - UIView-dən miras alır
/// CADisplayLink wrapper class - inherits from UIView
class DisplayLinkWrapper: UIView {
    private var displayLink: CADisplayLink?
    var onUpdate: (() -> Void)? {
        didSet {
            // Callback dəyişdikdə heç bir iş görmürük / No action when callback changes
        }
    }
    
    var isActive: Bool = false {
        didSet {
            // Aktivlik vəziyyəti dəyişdikdə DisplayLink-i idarə et / Manages DisplayLink when active state changes
            if isActive && displayLink == nil {
                start()
            } else if !isActive && displayLink != nil {
                stop()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // İlk yaradılanda başlatmırıq, isActive true olduqda başlayır / Don't start initially, starts when isActive is true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    /// CADisplayLink-i quraşdırır və başlatır / Sets up and starts CADisplayLink
    private func start() {
        guard displayLink == nil else { return }
        
        // CADisplayLink yaradır - ekran yeniləməsi ilə sinxron işləyir / Creates CADisplayLink - works synchronously with screen refresh
        displayLink = CADisplayLink(target: self, selector: #selector(displayLinkFired))
        
        // Prefered frame rate 60 FPS (iOS 15+) / Prefered frame rate 60 FPS (iOS 15+)
        if #available(iOS 15.0, *) {
            displayLink?.preferredFrameRateRange = CAFrameRateRange(minimum: 60, maximum: 60, preferred: 60)
        }
        
        // RunLoop-a əlavə edir / Adds to RunLoop
        displayLink?.add(to: .main, forMode: .common)
    }
    
    /// DisplayLink çağırıldıqda / When DisplayLink fires
    @objc private func displayLinkFired() {
        // Update callback-i çağırır (hər frame-də) / Calls update callback (every frame)
        onUpdate?()
    }
    
    /// DisplayLink-i dayandırır / Stops DisplayLink
    private func stop() {
        displayLink?.invalidate()
        displayLink = nil
    }
    
    deinit {
        // Cleanup - DisplayLink-i dayandırır / Cleanup - stops DisplayLink
        stop()
    }
}

