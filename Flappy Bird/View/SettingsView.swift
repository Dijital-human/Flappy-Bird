//
//  SettingsView.swift
//  Flappy Bird
//
//  Ayarlar ekranı - oyun ayarlarını idarə edir
//  Settings Screen - manages game settings
//

import SwiftUI

/// Ayarlar ekranı görünüşü / Settings Screen View
struct SettingsView: View {
    @ObservedObject var settingsModel: SettingsModel
    @ObservedObject var audioManager: AudioManager
    @ObservedObject var localizationModel: LocalizationModel
    let onClose: () -> Void  // Bağlama funksiyası / Close function
    
    var body: some View {
        ZStack {
            // Yarımşəffaf fon / Semi-transparent background
            Color.black.opacity(0.7)
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Başlıq / Title
                Text(localizationModel.translate("settings"))
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(color: .black, radius: 8)
                    .padding(.top, 50)
                
                // Ayarlar / Settings
                VStack(spacing: 25) {
                    // Ses ayarı / Sound setting
                    HStack {
                        Image(systemName: "speaker.wave.2.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 24))
                        
                        Text(localizationModel.translate("sound_effects"))
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Toggle("", isOn: $settingsModel.soundEnabled)
                            .onChange(of: settingsModel.soundEnabled) { oldValue, newValue in
                                audioManager.isSoundEnabled = newValue
                            }
                    }
                    .padding(.horizontal, 30)
                    .padding(.vertical, 15)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.white.opacity(0.2))
                    )
                    
                    // Musiqi ayarı / Music setting
                    HStack {
                        Image(systemName: "music.note")
                            .foregroundColor(.white)
                            .font(.system(size: 24))
                        
                        Text(localizationModel.translate("background_music"))
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Toggle("", isOn: $settingsModel.musicEnabled)
                            .onChange(of: settingsModel.musicEnabled) { oldValue, newValue in
                                audioManager.isMusicEnabled = newValue
                            }
                    }
                    .padding(.horizontal, 30)
                    .padding(.vertical, 15)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.white.opacity(0.2))
                    )
                    
                    // Haptic ayarı / Haptic setting
                    HStack {
                        Image(systemName: "hand.tap.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 24))
                        
                        Text(localizationModel.translate("haptic_feedback"))
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Toggle("", isOn: $settingsModel.hapticEnabled)
                    }
                    .padding(.horizontal, 30)
                    .padding(.vertical, 15)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.white.opacity(0.2))
                    )
                    
                    // Dark mode ayarı / Dark mode setting
                    HStack {
                        Image(systemName: "moon.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 24))
                        
                        Text(localizationModel.translate("dark_mode"))
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Toggle("", isOn: $settingsModel.darkModeEnabled)
                    }
                    .padding(.horizontal, 30)
                    .padding(.vertical, 15)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.white.opacity(0.2))
                    )
                    
                    // Hava effektləri ayarı / Weather effects setting
                    HStack {
                        Image(systemName: "cloud.rain.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 24))
                        
                        Text(localizationModel.translate("weather_effects"))
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Toggle("", isOn: $settingsModel.weatherEffectsEnabled)
                    }
                    .padding(.horizontal, 30)
                    .padding(.vertical, 15)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.white.opacity(0.2))
                    )
                    
                    // Dil seçimi / Language selection
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "globe")
                                .foregroundColor(.white)
                                .font(.system(size: 24))
                            
                            Text(localizationModel.translate("language"))
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(.white)
                            
                            Spacer()
                        }
                        
                        // Dil seçim düymələri / Language selection buttons
                        HStack(spacing: 10) {
                            ForEach(Language.allCases, id: \.self) { language in
                                Button(action: {
                                    localizationModel.selectLanguage(language)
                                }) {
                                    Text(language.displayName)
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(localizationModel.currentLanguage == language ? .white : .white.opacity(0.7))
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 10)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(localizationModel.currentLanguage == language ? Color.blue.opacity(0.8) : Color.white.opacity(0.2))
                                        )
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 30)
                    .padding(.vertical, 15)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.white.opacity(0.2))
                    )
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                // Bağlama düyməsi / Close button
                Button(action: {
                    // Ayarları bağlayır / Closes settings
                    onClose()
                }) {
                    Text(localizationModel.translate("close"))
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 50)
                        .padding(.vertical, 15)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.8)]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(25)
                        .shadow(color: .black.opacity(0.4), radius: 8, x: 0, y: 4)
                }
                .padding(.bottom, 50)
            }
        }
    }
}

