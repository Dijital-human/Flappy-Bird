//
//  GameView.swift
//  Flappy Bird
//
//  Oyun ekranı - oyun davam edərkən
//  Game Screen - during gameplay
//

import SwiftUI
import Combine
import QuartzCore

/// Oyun ekranı görünüşü / Game Screen View
struct GameView: View {
    @ObservedObject var gameModel: GameModel
    @ObservedObject var gameController: GameController
    @State private var scoreAnimationScale: CGFloat = 1.0
    @State private var showParticleEffect: Bool = false
    @State private var particlePosition: CGPoint = .zero
    
    // Publisher cancellable / Publisher cancellable
    @State private var scoreNotificationCancellable: AnyCancellable?
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Parallax arxa plan (seçilmiş mühit ilə) / Parallax background (with selected environment)
                let envInfo = EnvironmentInfo.info(for: gameController.environmentModel.selectedEnvironment)
                ParallaxBackgroundView(gradientColors: envInfo.gradientColors)
                    .ignoresSafeArea()
                
                // Buludlar / Clouds
                CloudView()
                    .offset(x: -geometry.size.width * 0.3, y: -geometry.size.height * 0.3)
                
                CloudView()
                    .offset(x: geometry.size.width * 0.2, y: -geometry.size.height * 0.4)
                    .scaleEffect(0.8)
                
                CloudView()
                    .offset(x: -geometry.size.width * 0.1, y: -geometry.size.height * 0.2)
                    .scaleEffect(0.6)
                
                // Yer / Ground (daha realistik gradient və texture) / Ground (more realistic gradient and texture)
                ZStack {
                    // Yer gradient (daha realistik) / Ground gradient (more realistic)
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.4, green: 0.3, blue: 0.2).opacity(0.9),
                            Color(red: 0.5, green: 0.4, blue: 0.3).opacity(0.95),
                            Color(red: 0.6, green: 0.5, blue: 0.4)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: gameModel.groundHeight)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                    .ignoresSafeArea()
                    
                    // Yer texture (daha realistik otlar) / Ground texture (more realistic grass)
                    HStack(spacing: 0) {
                        ForEach(0..<Int(geometry.size.width / 15), id: \.self) { index in
                            VStack(spacing: 0) {
                                // Otlar / Grass
                                ForEach(0..<Int.random(in: 2...4), id: \.self) { _ in
                                    Rectangle()
                                        .fill(
                                            LinearGradient(
                                                gradient: Gradient(colors: [
                                                    Color.green.opacity(0.6),
                                                    Color.green.opacity(0.4)
                                                ]),
                                                startPoint: .top,
                                                endPoint: .bottom
                                            )
                                        )
                                        .frame(width: CGFloat.random(in: 1...3), height: CGFloat.random(in: 3...8))
                                        .offset(x: CGFloat.random(in: -2...2))
                                }
                            }
                            .frame(width: 15)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                    .offset(y: -gameModel.groundHeight / 2)
                    
                    // Yer üzəri (daha realistik) / Ground surface (more realistic)
                    Rectangle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(red: 0.3, green: 0.2, blue: 0.1).opacity(0.3),
                                    Color.clear
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(height: gameModel.groundHeight)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                }
                
                // Borular / Pipes (daha realistik dizayn) / Pipes (more realistic design)
                ForEach(gameModel.pipes) { pipe in
                    let pipeOpacity = min(1.0, (pipe.x + gameModel.pipeWidth) / (gameModel.screenWidth * 0.3)) // Entrance animasiya / Entrance animation
                    let pipeScale = min(1.0, (pipe.x + gameModel.pipeWidth) / (gameModel.screenWidth * 0.2)) // Scale animasiya / Scale animation
                    
                    // Yuxarı boru / Top pipe (daha realistik gradient və texture)
                    ZStack {
                        // Boru gövdəsi (daha realistik gradient) / Pipe body (more realistic gradient)
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color(red: 0.1, green: 0.6, blue: 0.1),
                                        Color(red: 0.2, green: 0.7, blue: 0.2),
                                        Color(red: 0.1, green: 0.6, blue: 0.1)
                                    ]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: gameModel.pipeWidth, height: pipe.topHeight)
                            .overlay(
                                // Boru texture (daha realistik) / Pipe texture (more realistic)
                                Rectangle()
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                Color.black.opacity(0.1),
                                                Color.clear,
                                                Color.black.opacity(0.1)
                                            ]),
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    )
                            )
                        
                        // Boru ucu (daha realistik) / Pipe cap (more realistic)
                        RoundedRectangle(cornerRadius: 8)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color(red: 0.15, green: 0.65, blue: 0.15),
                                        Color(red: 0.1, green: 0.6, blue: 0.1)
                                    ]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .frame(width: gameModel.pipeWidth + 12, height: 25)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.black.opacity(0.2), lineWidth: 2)
                            )
                            .offset(y: -pipe.topHeight / 2 + 12.5)
                    }
                    .opacity(pipeOpacity)
                    .scaleEffect(x: pipeScale, y: 1.0, anchor: .trailing)
                    .shadow(color: .black.opacity(0.3), radius: 5, x: 2, y: 0)
                    .position(x: pipe.x + gameModel.pipeWidth / 2, y: pipe.topHeight / 2)
                    
                    // Aşağı boru / Bottom pipe (yerdən başlayır, daha realistik dizayn)
                    Group {
                        let bottomPipeY = pipe.bottomY
                        let bottomPipeHeight = geometry.size.height - gameModel.groundHeight - bottomPipeY
                        ZStack {
                            // Boru gövdəsi (daha realistik gradient) / Pipe body (more realistic gradient)
                            Rectangle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color(red: 0.1, green: 0.6, blue: 0.1),
                                            Color(red: 0.2, green: 0.7, blue: 0.2),
                                            Color(red: 0.1, green: 0.6, blue: 0.1)
                                        ]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: gameModel.pipeWidth, height: bottomPipeHeight)
                                .overlay(
                                    // Boru texture (daha realistik) / Pipe texture (more realistic)
                                    Rectangle()
                                        .fill(
                                            LinearGradient(
                                                gradient: Gradient(colors: [
                                                    Color.black.opacity(0.1),
                                                    Color.clear,
                                                    Color.black.opacity(0.1)
                                                ]),
                                                startPoint: .top,
                                                endPoint: .bottom
                                            )
                                        )
                                )
                            
                            // Boru ucu (daha realistik) / Pipe cap (more realistic)
                            RoundedRectangle(cornerRadius: 8)
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color(red: 0.15, green: 0.65, blue: 0.15),
                                            Color(red: 0.1, green: 0.6, blue: 0.1)
                                        ]),
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .frame(width: gameModel.pipeWidth + 12, height: 25)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.black.opacity(0.2), lineWidth: 2)
                                )
                                .offset(y: bottomPipeHeight / 2 - 12.5)
                        }
                        .opacity(pipeOpacity)
                        .scaleEffect(x: pipeScale, y: 1.0, anchor: .trailing)
                        .shadow(color: .black.opacity(0.3), radius: 5, x: 2, y: 0)
                        .position(
                            x: pipe.x + gameModel.pipeWidth / 2,
                            y: bottomPipeY + bottomPipeHeight / 2
                        )
                    }
                    
                    // Power-up görünüşü / Power-up view
                    if pipe.hasPowerUp && !pipe.powerUpCollected, let powerUpType = pipe.powerUpType {
                        let powerUpInfo = PowerUpInfo.info(for: powerUpType)
                        let powerUpScale = min(1.0, (pipe.x + gameModel.pipeWidth) / (gameModel.screenWidth * 0.2))
                        
                        ZStack {
                            // Glow effect / Glow effect
                            Circle()
                                .fill(
                                    RadialGradient(
                                        gradient: Gradient(colors: [
                                            powerUpInfo.color.opacity(0.6),
                                            powerUpInfo.color.opacity(0.3),
                                            Color.clear
                                        ]),
                                        center: .center,
                                        startRadius: 15,
                                        endRadius: 35
                                    )
                                )
                                .frame(width: 70, height: 70)
                                .blur(radius: 5)
                            
                            // Power-up background / Power-up background
                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            powerUpInfo.color.opacity(0.95),
                                            powerUpInfo.color.opacity(0.85),
                                            powerUpInfo.color.opacity(0.75)
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 45, height: 45)
                                .overlay(
                                    Circle()
                                        .stroke(
                                            LinearGradient(
                                                gradient: Gradient(colors: [
                                                    Color.white.opacity(0.8),
                                                    Color.white.opacity(0.4)
                                                ]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            lineWidth: 2.5
                                        )
                                )
                                .shadow(color: powerUpInfo.color.opacity(0.7), radius: 12, x: 0, y: 0)
                                .shadow(color: .black.opacity(0.3), radius: 6, x: 0, y: 3)
                            
                            // Power-up icon / Power-up icon
                            Image(systemName: powerUpInfo.icon)
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.white)
                                .shadow(color: .black.opacity(0.3), radius: 2)
                        }
                        .scaleEffect(powerUpScale)
                        .rotationEffect(.degrees(pipe.x * 0.1)) // Yavaş fırlanma / Slow rotation
                        .position(
                            x: pipe.x + gameModel.pipeWidth / 2,
                            y: pipe.gapY
                        )
                    }
                }
                
                // Quş / Bird (seçilmiş quş növü ilə) / Bird (with selected bird type)
                ZStack {
                    // Magnet field effect (magnet aktiv olduqda) / Magnet field effect (when magnet is active)
                    if gameController.powerUpModel.isActive(.magnet) {
                        let magnetInfo = PowerUpInfo.info(for: .magnet)
                        let magnetRadius = gameModel.magnetRadius
                        
                        // Animated magnet field (pulsing effect) / Animated magnet field (pulsing effect)
                        ForEach(0..<3, id: \.self) { index in
                            Circle()
                                .stroke(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            magnetInfo.color.opacity(0.6 - Double(index) * 0.15),
                                            magnetInfo.color.opacity(0.3 - Double(index) * 0.1),
                                            Color.clear
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 3 - CGFloat(index)
                                )
                                .frame(width: magnetRadius * 2 - CGFloat(index * 30), height: magnetRadius * 2 - CGFloat(index * 30))
                                .blur(radius: CGFloat(index * 2))
                                .opacity(0.7 - Double(index) * 0.2)
                        }
                        
                        // Magnet field glow / Magnet field glow
                        Circle()
                            .fill(
                                RadialGradient(
                                    gradient: Gradient(colors: [
                                        magnetInfo.color.opacity(0.4),
                                        magnetInfo.color.opacity(0.2),
                                        magnetInfo.color.opacity(0.05),
                                        Color.clear
                                    ]),
                                    center: .center,
                                    startRadius: 0,
                                    endRadius: magnetRadius
                                )
                            )
                            .frame(width: magnetRadius * 2, height: magnetRadius * 2)
                            .blur(radius: 10)
                    }
                    
                    // Trail effect (velocity-yə görə) / Trail effect (based on velocity)
                    if gameModel.birdVelocity < -3 {
                        ForEach(0..<3, id: \.self) { index in
                            Circle()
                                .fill(
                                    RadialGradient(
                                        gradient: Gradient(colors: [
                                            BirdTypeInfo.info(for: gameController.birdTypeModel.selectedBirdType).color.opacity(0.3 - Double(index) * 0.1),
                                            Color.clear
                                        ]),
                                        center: .center,
                                        startRadius: 2,
                                        endRadius: 8
                                        )
                                )
                                .frame(width: CGFloat(8 - index * 2), height: CGFloat(8 - index * 2))
                                .offset(x: CGFloat(index * 3), y: CGFloat(index * 2))
                                .blur(radius: 2)
                        }
                        .offset(x: -gameModel.birdSize * 0.5, y: 0)
                    }
                    
                BirdView(
                    size: gameModel.birdSize,
                    velocity: gameModel.birdVelocity,
                    color: BirdTypeInfo.info(for: gameController.birdTypeModel.selectedBirdType).color
                )
                }
                .position(gameModel.birdPosition)
                
                // Skor göstəricisi (animasiya ilə) / Score display (with animation)
                VStack {
                    HStack {
                        // Modern pause düyməsi / Modern pause button
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                            gameController.pauseGame()
                            }
                        }) {
                            ZStack {
                                // Glow effect / Glow effect
                                Circle()
                                    .fill(Color.white.opacity(0.2))
                                    .frame(width: 50, height: 50)
                                    .blur(radius: 5)
                                
                                // Main button / Main button
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                Color.black.opacity(0.5),
                                                Color.black.opacity(0.4)
                                            ]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 48, height: 48)
                                    .overlay(
                                        Circle()
                                            .stroke(Color.white.opacity(0.3), lineWidth: 1.5)
                                    )
                                
                            Image(systemName: "pause.fill")
                                    .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                            }
                            .shadow(color: .black.opacity(0.4), radius: 8, x: 0, y: 4)
                        }
                        .padding(.leading, 20)
                        .padding(.top, 50)
                        
                        Spacer()
                    }
                    
                    // Modern skor mətnı / Modern score text
                    ZStack {
                        // Glow effect / Glow effect
                    Text("\(gameModel.score)")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                            .blur(radius: 3)
                            .scaleEffect(scoreAnimationScale)
                        
                        // Main text / Main text
                        Text("\(gameModel.score)")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.white,
                                        Color.yellow.opacity(0.9),
                                        Color.white
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .shadow(color: .black.opacity(0.6), radius: 8, x: 0, y: 3)
                            .shadow(color: .yellow.opacity(0.5), radius: 12, x: 0, y: 0)
                        .scaleEffect(scoreAnimationScale)
                    }
                        .padding(.top, 10)
                    
                    Spacer()
                }
                
                // Enhanced partikul effekti / Enhanced particle effect
                if showParticleEffect {
                    ZStack {
                        // Multiple particle layers / Çoxlu partikul təbəqələri
                    ParticleEffectView(position: particlePosition, color: .yellow)
                        ParticleEffectView(position: particlePosition, color: .orange)
                            .scaleEffect(0.8)
                            .offset(x: 5, y: 5)
                        ParticleEffectView(position: particlePosition, color: .white)
                            .scaleEffect(0.6)
                            .offset(x: -5, y: -5)
                    }
                }
                
                // Power-up göstəriciləri / Power-up indicators
                HStack {
                    Spacer()
                    PowerUpIndicatorView(powerUpModel: gameController.powerUpModel)
                }
                
                // Hava effektləri (ayarlar əsasında) / Weather effects (based on settings)
                if gameController.settingsModel.weatherEffectsEnabled {
                    let weatherType: WeatherEffectType = {
                        switch gameController.environmentModel.selectedEnvironment {
                        case .winter:
                            return .snow
                        case .spring, .summer:
                            return .rain
                        default:
                            return .none
                        }
                    }()
                    
                    if weatherType != .none {
                        WeatherEffectView(type: weatherType)
                            .ignoresSafeArea()
                    }
                }
            }
            .onAppear {
                // Ekran ölçülərini təyin edir / Sets screen dimensions
                gameModel.setScreenSize(width: geometry.size.width, height: geometry.size.height)
                
                // Oyun başlayıbsa, quşun pozisiyasını yeniləyir / If game started, updates bird position
                if gameModel.gameState == .playing {
                    let initialY = (geometry.size.height - gameModel.groundHeight) / 2
                    gameModel.birdPosition = CGPoint(x: 100, y: initialY)
                }
                
                // CADisplayLink avtomatik olaraq oyun vəziyyətinə görə idarə olunur / CADisplayLink is automatically managed based on game state
                
                // Skor artımı notification-ını dinləyir / Listens to score increase notification
                scoreNotificationCancellable = NotificationCenter.default.publisher(for: .scoreIncreased)
                    .sink { [weak gameController] _ in
                        // Weak reference istifadə edir ki, memory leak olmasın / Uses weak reference to prevent memory leak
                        guard let gameController = gameController else { return }
                        // Skor artımı animasiyası / Score increase animation
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                            scoreAnimationScale = 1.3
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                scoreAnimationScale = 1.0
                            }
                        }
                        // Skor artımı callback-i / Score increase callback
                        gameController.handleScoreIncrease()
                    }
            }
            .onDisappear {
                // Publisher-ı cancel edir (memory leak qarşısını alır) / Cancels publisher (prevents memory leak)
                scoreNotificationCancellable?.cancel()
                scoreNotificationCancellable = nil
            }
            .background(
                // CADisplayLink-i görünməz UIView ilə aktivləşdirir / Activates CADisplayLink with invisible UIView
                // Yalnız oyun oynanılanda aktiv olur / Only active when game is playing
                DisplayLinkView(isActive: gameModel.gameState == .playing) {
                    // Bu callback hər frame-də çağırılır (60 FPS) / This callback is called every frame (60 FPS)
                    updateGame()
                }
                .frame(width: 0, height: 0)
                .allowsHitTesting(false)
            )
            .onTapGesture {
                // Tap zamanı quşu yuxarı qaldırır / Makes bird jump on tap
                if gameModel.gameState == .playing {
                    gameController.handleBirdTap()
                    // Partikul effekti göstərir / Shows particle effect
                    particlePosition = gameModel.birdPosition
                    showParticleEffect = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                        showParticleEffect = false
                    }
                }
            }
        }
    }
    
    // MARK: - DisplayLink Management / CADisplayLink idarəetməsi
    
    /// Oyunu bir frame yeniləyir (CADisplayLink callback) / Updates game by one frame (CADisplayLink callback)
    private func updateGame() {
        // Yalnız oyun oynanılanda yeniləyir / Only updates when game is playing
        guard gameModel.gameState == .playing else { return }
        
        // Oyunu yeniləyir / Updates game
        gameModel.update()
        
        // Power-up-ləri yoxlayır / Checks power-ups
        gameController.powerUpModel.checkPowerUps()
        
        // Real-time daily challenge tracking / Real-time daily challenge tracking
        if let challenge = gameController.dailyChallengeModel.currentChallenge,
           !gameController.dailyChallengeModel.isCompleted {
            switch challenge.type {
            case .surviveTime:
                // Müəyyən vaxt sağ qalmaq - real-time tracking / Survive time - real-time tracking
                if let startTime = gameModel.gameStartTime {
                    let playTime = Date().timeIntervalSince(startTime)
                    gameController.dailyChallengeModel.updateProgress(currentValue: Int(playTime))
                }
            case .passPipes:
                // Müəyyən sayda boru keçmək - real-time tracking / Pass pipes - real-time tracking
                gameController.dailyChallengeModel.updateProgress(currentValue: gameModel.pipesPassed)
            default:
                break
            }
        }
    }
}

