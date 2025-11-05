//
//  AudioManager.swift
//  Flappy Bird
//
//  Audio idarəçisi - səs effektləri və musiqi idarə edir
//  Audio Manager - manages sound effects and music
//

import Foundation
import AVFoundation
import AudioToolbox
import Combine

/// Audio idarəçisi - səs effektləri və musiqi idarə edir
/// Audio Manager - manages sound effects and music
class AudioManager: ObservableObject {
    // MARK: - Published Properties / Nəşr edilən xassələr
    
    @Published var isSoundEnabled: Bool = true {
        didSet {
            // Ses ayarını yaddaşa yazır / Saves sound setting to storage
            UserDefaults.standard.set(isSoundEnabled, forKey: "isSoundEnabled")
        }
    }
    
    @Published var isMusicEnabled: Bool = true {
        didSet {
            // Musiqi ayarını yaddaşa yazır / Saves music setting to storage
            UserDefaults.standard.set(isMusicEnabled, forKey: "isMusicEnabled")
            if !isMusicEnabled {
                // Musiqini dayandırır / Stops music
                stopBackgroundMusic()
            } else {
                // Musiqini başlatır / Starts music
                playBackgroundMusic()
            }
        }
    }
    
    // MARK: - Audio Players / Audio pleyerları
    
    private var jumpSoundPlayer: AVAudioPlayer?
    private var scoreSoundPlayer: AVAudioPlayer?
    private var gameOverSoundPlayer: AVAudioPlayer?
    private var powerUpSoundPlayer: AVAudioPlayer?
    private var backgroundMusicPlayer: AVAudioPlayer?
    
    // MARK: - Initialization / İnitializasiya
    
    init() {
        // Ayarları yaddaşdan yükləyir / Loads settings from storage
        loadSettings()
        // Audio session-u konfiqurasiya edir / Configures audio session
        setupAudioSession()
        // Background musiqisini başlatır / Starts background music
        // Kiçik gecikmə ilə ki, audio session hazır olsun / Small delay so audio session is ready
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.playBackgroundMusic()
        }
        
        // Reklam notification-larını dinləyir / Listens to ad notifications
        setupAdNotifications()
    }
    
    /// Reklam notification-larını quraşdırır / Sets up ad notifications
    private func setupAdNotifications() {
        // Musiqini pause etmək üçün notification / Notification to pause music
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name("PauseBackgroundMusic"),
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.pauseBackgroundMusic()
        }
        
        // Musiqini resume etmək üçün notification / Notification to resume music
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name("ResumeBackgroundMusic"),
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.resumeBackgroundMusic()
        }
    }
    
    deinit {
        // Notification observer-ları silir / Removes notification observers
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Audio Session Setup / Audio session quraşdırması
    
    /// Audio session-u konfiqurasiya edir / Configures audio session
    private func setupAudioSession() {
        do {
            // Audio session-u aktivləşdirir / Activates audio session
            // .playback kateqoriyası istifadə olunur - musiqi background-da çalınır / .playback category is used - music plays in background
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
            print("✅ Audio session konfiqurasiya olundu / Audio session configured")
        } catch {
            // Xəta baş verərsə, konsola yazır / If error occurs, logs to console
            print("❌ Audio session konfiqurasiyası xətası / Audio session configuration error: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Settings Management / Ayarlar idarəetməsi
    
    /// Ayarları yaddaşdan yükləyir / Loads settings from storage
    private func loadSettings() {
        // UserDefaults-dan ayarları oxuyur / Reads settings from UserDefaults
        isSoundEnabled = UserDefaults.standard.object(forKey: "isSoundEnabled") as? Bool ?? true
        isMusicEnabled = UserDefaults.standard.object(forKey: "isMusicEnabled") as? Bool ?? true
    }
    
    // MARK: - Sound Effects / Səs effektləri
    
    /// Jump səs effektini çalır / Plays jump sound effect
    func playJumpSound() {
        guard isSoundEnabled else { return }
        // Sistem səsini istifadə edir / Uses system sound
        // QEYD: Real tətbiq üçün səs faylı əlavə edə bilərsiniz
        // NOTE: For real app, you can add sound file
        AudioServicesPlaySystemSound(1104) // Jump sound ID / Jump sound ID
    }
    
    /// Skor səs effektini çalır / Plays score sound effect
    func playScoreSound() {
        guard isSoundEnabled else { return }
        // Sistem səsini istifadə edir / Uses system sound
        AudioServicesPlaySystemSound(1054) // Score sound ID / Score sound ID
    }
    
    /// Oyun bitmə səs effektini çalır / Plays game over sound effect
    func playGameOverSound() {
        guard isSoundEnabled else { return }
        // Sistem səsini istifadə edir / Uses system sound
        AudioServicesPlaySystemSound(1057) // Game over sound ID / Game over sound ID
    }
    
    /// Power-up səs effektini çalır / Plays power-up sound effect
    func playPowerUpSound() {
        guard isSoundEnabled else { return }
        // Sistem səsini istifadə edir / Uses system sound
        AudioServicesPlaySystemSound(1052) // Power-up sound ID / Power-up sound ID
    }
    
    // MARK: - Background Music / Fon musiqisi
    
    /// Fon musiqisini çalır / Plays background music
    func playBackgroundMusic() {
        guard isMusicEnabled else {
            print("⚠️ Musiqi söndürülüb / Music is disabled")
            return
        }
        
        // Əgər musiqi artıq çalınır, davam etdirir / If music already playing, continues
        if backgroundMusicPlayer?.isPlaying == true {
            print("ℹ️ Musiqi artıq çalınır / Music already playing")
            return
        }
        
        // Audio session-u yenidən aktivləşdirir / Reactivates audio session
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("⚠️ Audio session aktivləşdirilə bilmədi / Audio session failed to activate: \(error.localizedDescription)")
        }
        
        // Background musiqi faylını yükləyir / Loads background music file
        // Həm .mp3, həm də .wav formatlarını dəstəkləyir / Supports both .mp3 and .wav formats
        
        var musicURL: URL?
        
        print("🔍 Musiqi faylını axtarır... / Searching for music file...")
        
        // Əvvəlcə .mp3 faylını yoxlayır / First checks for .mp3 file
        if let url = Bundle.main.url(forResource: "background_music", withExtension: "mp3") {
            musicURL = url
            print("✅ .mp3 faylı tapıldı / .mp3 file found")
        }
        // Sonra .wav faylını yoxlayır (tam adı ilə) / Then checks for .wav file (with full name)
        else if let url = Bundle.main.url(forResource: "516912__xythe__chill-tune-for-a-game", withExtension: "wav") {
            musicURL = url
            print("✅ .wav faylı tapıldı (tam adı ilə) / .wav file found (with full name)")
        }
        // Əgər yuxarıdakılar tapılmadısa, sadə "background_music" adı ilə .wav axtarır / If not found, searches for "background_music" with .wav
        else if let url = Bundle.main.url(forResource: "background_music", withExtension: "wav") {
            musicURL = url
            print("✅ .wav faylı tapıldı / .wav file found")
        }
        // Son variant: Bundle-dəki bütün .wav fayllarını axtarır / Last option: searches for all .wav files in Bundle
        else {
            // Bundle-dəki bütün faylları yoxlayır / Checks all files in Bundle
            if let resourcePath = Bundle.main.resourcePath {
                let fileManager = FileManager.default
                if let files = try? fileManager.contentsOfDirectory(atPath: resourcePath) {
                    print("🔍 Bundle-də \(files.count) fayl var / Found \(files.count) files in Bundle")
                    for file in files {
                        if file.contains("chill-tune") || file.contains("background_music") || file.hasSuffix(".wav") || file.hasSuffix(".mp3") {
                            let fullPath = (resourcePath as NSString).appendingPathComponent(file)
                            if fileManager.fileExists(atPath: fullPath) {
                                musicURL = URL(fileURLWithPath: fullPath)
                                print("✅ Fayl tapıldı: \(file) / File found: \(file)")
                                break
                            }
                        }
                    }
                }
            }
        }
        
        if let url = musicURL {
            do {
                backgroundMusicPlayer = try AVAudioPlayer(contentsOf: url)
                backgroundMusicPlayer?.numberOfLoops = -1  // Sonsuz loop / Infinite loop
                backgroundMusicPlayer?.volume = 0.5  // Volume 50% / 50% volume
                backgroundMusicPlayer?.prepareToPlay()  // Musiqini hazırlayır / Prepares music
                
                // Musiqini çalır / Plays music
                let success = backgroundMusicPlayer?.play() ?? false
                if success {
                    print("✅ Background musiqi başladı / Background music started: \(url.lastPathComponent)")
                    print("🔊 Volume: 50% / Volume: 50%")
                    print("🔄 Loop: Sonsuz / Loop: Infinite")
                    print("📁 Fayl yolu / File path: \(url.path)")
                } else {
                    print("❌ Musiqi çalına bilmədi / Music failed to play")
                    print("💡 Səbəb: AVAudioPlayer play() metodu false qaytardı / Reason: AVAudioPlayer play() returned false")
                }
            } catch {
                print("❌ Background musiqi yüklənə bilmədi / Background music failed to load: \(error.localizedDescription)")
                print("💡 İpucu: Musiqi faylının düzgün əlavə olunduğuna əmin olun / Tip: Make sure music file is properly added")
            }
        } else {
            print("⚠️ Background musiqi faylı tapılmadı / Background music file not found")
            print("💡 İpucu: Xcode-da proyektinizə musiqi faylını əlavə edin / Tip: Add music file to your Xcode project")
            print("📖 Bələdçi: BACKGROUND_MUSIC_GUIDE.md faylına baxın / Guide: See BACKGROUND_MUSIC_GUIDE.md file")
            print("📝 QEYD: Fayl 'Flappy Bird' folder-ına əlavə olunmalıdır, Assets.xcassets-ə yox / NOTE: File should be added to 'Flappy Bird' folder, not Assets.xcassets")
        }
    }
    
    /// Fon musiqisini dayandırır / Stops background music
    func stopBackgroundMusic() {
        backgroundMusicPlayer?.stop()
        backgroundMusicPlayer = nil
    }
    
    /// Musiqini pause edir (temporary stop) / Pauses music (temporary stop)
    func pauseBackgroundMusic() {
        guard let player = backgroundMusicPlayer, player.isPlaying else { return }
        player.pause()
        print("⏸️ Background musiqi pause edildi / Background music paused")
    }
    
    /// Musiqini yenidən başlatır (resume) / Resumes music
    func resumeBackgroundMusic() {
        guard let player = backgroundMusicPlayer, !player.isPlaying else { return }
        guard isMusicEnabled else { return }
        player.play()
        print("▶️ Background musiqi davam edir / Background music resumed")
    }
}

