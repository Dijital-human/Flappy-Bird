//
//  GameModel.swift
//  Flappy Bird
//
//  Oyun modeli - məntiqi və vəziyyəti idarə edir
//  Game Model - manages game logic and state
//

import Foundation
import SwiftUI
import Combine

/// Oyun vəziyyəti / Game state
enum GameState {
    case start      // Başlanğıc ekranı / Start screen
    case playing    // Oyun davam edir / Game is playing
    case paused     // Oyun dayandırılıb / Game is paused
    case gameOver   // Oyun bitdi / Game over
}

/// Oyun modeli - məntiqi və vəziyyəti idarə edir
/// Game Model - manages game logic and state
class GameModel: ObservableObject {
    // MARK: - Published Properties / Nəşr edilən xassələr
    
    @Published var gameState: GameState = .start
    @Published var score: Int = 0
    @Published var highScore: Int = 0
    @Published var birdPosition: CGPoint = CGPoint(x: 100, y: 300)
    @Published var birdVelocity: CGFloat = 0
    @Published var pipes: [Pipe] = []
    
    // Oyun statistikaları / Game statistics
    var gameStartTime: Date?  // Oyun başlama vaxtı / Game start time
    var pipesPassed: Int = 0  // Keçilən boru sayı / Pipes passed count
    
    // MARK: - Constants / Sabitlər
    
    // Quşun fizika parametrləri (ilkin dəyərlər) / Bird physics parameters (initial values)
    let baseGravity: CGFloat = 0.4      // İlkin cazibə qüvvəsi (asan) / Initial gravity (easy)
    let baseJumpForce: CGFloat = -9.0   // İlkin jump qüvvəsi (rahat) / Initial jump force (comfortable)
    let birdSize: CGFloat = 30
    let groundHeight: CGFloat = 50   // Yerin hündürlüyü / Ground height
    
    // Magnet power-up parametrləri / Magnet power-up parameters
    let magnetRadius: CGFloat = 280    // Magnet radius (piksel) / Magnet radius (pixels)
    let magnetStrength: CGFloat = 2.5   // Magnet cəlb etmə qüvvəsi / Magnet attraction strength
    
    // Boru parametrləri (ilkin dəyərlər) / Pipe parameters (initial values)
    let pipeWidth: CGFloat = 60
    let basePipeGap: CGFloat = 180      // İlkin boru boşluğu (böyük - asan) / Initial pipe gap (large - easy)
    let basePipeSpeed: CGFloat = 2.5    // İlkin boru sürəti (yavaş - asan) / Initial pipe speed (slow - easy)
    let pipeSpawnInterval: CGFloat = 250
    
    // Çətinlik artırma parametrləri / Difficulty increase parameters
    let maxGravity: CGFloat = 0.8        // Maksimum cazibə qüvvəsi / Maximum gravity
    let maxPipeSpeed: CGFloat = 5.0      // Maksimum boru sürəti / Maximum pipe speed
    let minPipeGap: CGFloat = 120        // Minimum boru boşluğu / Minimum pipe gap
    let difficultyIncreaseInterval: Int = 5  // Hər 5 skor üçün çətinlik artır / Increase difficulty every 5 score
    
    // MARK: - Dynamic Properties / Dinamik xassələr
    
    /// Cari cazibə qüvvəsi (skora görə) / Current gravity (based on score)
    var gravity: CGFloat {
        let difficultyMultiplier = min(CGFloat(score) / CGFloat(difficultyIncreaseInterval), 1.0)
        return baseGravity + (maxGravity - baseGravity) * difficultyMultiplier
    }
    
    /// Cari jump qüvvəsi (skora görə) / Current jump force (based on score)
    var jumpForce: CGFloat {
        // Jump qüvvəsi sabit qalır, amma cazibə artır, buna görə də nisbətən azalır
        // Jump force stays constant, but gravity increases, so relatively decreases
        return baseJumpForce
    }
    
    /// Cari boru sürəti (skora görə və power-up-a görə) / Current pipe speed (based on score and power-up)
    var pipeSpeed: CGFloat {
        let difficultyMultiplier = min(CGFloat(score) / CGFloat(difficultyIncreaseInterval), 1.0)
        var speed = basePipeSpeed + (maxPipeSpeed - basePipeSpeed) * difficultyMultiplier
        
        // Slow motion power-up aktivdirsə, sürəti 50% azalt / If slow motion power-up is active, reduce speed by 50%
        if let isPowerUpActive = isPowerUpActive, isPowerUpActive(.slowMotion) {
            speed *= 0.5
        }
        
        return speed
    }
    
    /// Cari boru boşluğu (skora görə) / Current pipe gap (based on score)
    var pipeGap: CGFloat {
        let difficultyMultiplier = min(CGFloat(score) / CGFloat(difficultyIncreaseInterval), 1.0)
        return basePipeGap - (basePipeGap - minPipeGap) * difficultyMultiplier
    }
    
    // Ekran ölçüləri / Screen dimensions
    var screenWidth: CGFloat = 400
    var screenHeight: CGFloat = 800
    
    // Power-up status closure / Power-up status closure
    var isPowerUpActive: ((PowerUpType) -> Bool)?
    
    // Power-up collection callback / Power-up collection callback
    var onPowerUpCollected: ((PowerUpType) -> Void)?
    
    // Power-up spawn counter / Power-up spawn counter
    private var powerUpSpawnCounter: Int = 0
    private let powerUpSpawnInterval: Int = 6  // Hər 6 borudan sonra / Every 6 pipes
    
    // MARK: - UserDefaults Keys / UserDefaults açarı
    
    private let highScoreKey = "highScore" // Yüksək skor açarı / High score key
    
    // MARK: - Initialization / İnitializasiya
    
    init() {
        loadHighScore()
    }
    
    // MARK: - High Score Management / Yüksək skor idarəetməsi
    
    /// Yüksək skoru yaddaşdan yükləyir / Loads high score from storage
    func loadHighScore() {
        // UserDefaults-dan yüksək skoru oxuyur / Reads high score from UserDefaults
        highScore = UserDefaults.standard.integer(forKey: highScoreKey)
    }
    
    /// Yüksək skoru yaddaşa yazır / Saves high score to storage
    func saveHighScore() {
        // Yeni skor yüksək skordan böyük və ya bərabərdirsə, yaddaşa yazır / If new score is higher or equal, saves it
        if score >= highScore {
            highScore = score
            // UserDefaults-a yüksək skoru yazır / Writes high score to UserDefaults
            UserDefaults.standard.set(highScore, forKey: highScoreKey)
        }
    }
    
    // MARK: - Game Control / Oyun idarəetməsi
    
    /// Oyunu başlatır / Starts the game
    func startGame() {
        gameState = .playing
        score = 0
        pipesPassed = 0
        gameStartTime = Date()  // Oyun başlama vaxtını qeyd edir / Records game start time
        powerUpSpawnCounter = 0  // Power-up counter-i sıfırlayır / Resets power-up counter
        // Quşun ilkin pozisiyasını təyin edir (ekran ölçüsü məlum deyilsə, default istifadə edir)
        // Sets initial bird position (uses default if screen size is unknown)
        let initialY = screenHeight > 0 ? (screenHeight - groundHeight) / 2 : 400
        birdPosition = CGPoint(x: 100, y: initialY)
        birdVelocity = 0  // İlk hərəkət yoxdur - asan başlanğıc / No initial movement - easy start
        pipes = []
        // İlk borunu yaradır / Creates first pipe
        spawnPipe()
    }
    
    /// Oyunu sıfırlayır / Resets the game
    func resetGame() {
        gameState = .start
        score = 0
        birdPosition = CGPoint(x: 100, y: screenHeight / 2)
        birdVelocity = 0
        pipes = []
    }
    
    /// Oyunu bitirir / Ends the game
    func endGame() {
        gameState = .gameOver
        saveHighScore()
        // Oyun vaxtını hesablayır / Calculates play time
        let playTime = gameStartTime.map { Date().timeIntervalSince($0) } ?? 0
        // Oyun bitməsi callback-i üçün (Controller-da handle edilir)
        // For game over callback (handled in Controller)
        NotificationCenter.default.post(
            name: .gameOver,
            object: nil,
            userInfo: [
                "playTime": playTime,
                "pipesPassed": pipesPassed
            ]
        )
    }
    
    /// Yeni rekord yoxlayır / Checks for new record
    var isNewRecord: Bool {
        // Əgər skor yüksək skordan böyükdürsə, yeni rekorddur
        // If score is greater than high score, it's a new record
        // İlk oyunda da yeni rekord ola bilər / Can be new record on first game too
        return score > 0 && score >= highScore && (score > highScore || highScore == 0)
    }
    
    /// Oyunu dayandırır / Pauses the game
    func pauseGame() {
        guard gameState == .playing else { return }
        gameState = .paused
    }
    
    /// Oyunu davam etdirir / Resumes the game
    func resumeGame() {
        guard gameState == .paused else { return }
        gameState = .playing
    }
    
    // MARK: - Bird Control / Quş idarəetməsi
    
    /// Quşu yuxarı qaldırır (tap zamanı) / Makes bird jump (on tap)
    func jump() {
        guard gameState == .playing else { return }
        // Hər tap zamanı yeni jump qüvvəsi tətbiq edir / Applies new jump force on each tap
        // Bu Flappy Bird-də olduğu kimi işləyir / Works like in Flappy Bird
        birdVelocity = jumpForce
    }
    
    /// Quşun pozisiyasını yeniləyir / Updates bird position
    func updateBird() {
        guard gameState == .playing else { return }
        
        // Cazibə qüvvəsi tətbiq edir / Applies gravity
        birdVelocity += gravity
        birdPosition.y += birdVelocity
        
        // Yerdən və tavanadan toqquşma yoxlayır / Checks collision with ground and ceiling
        let topBoundary: CGFloat = birdSize / 2  // Tavana minimum məsafə / Minimum distance to ceiling
        let bottomBoundary: CGFloat = screenHeight - groundHeight - birdSize / 2  // Yerə minimum məsafə / Minimum distance to ground
        
        // Tavana toqquşma / Ceiling collision
        if birdPosition.y <= topBoundary {
            birdPosition.y = topBoundary
            endGame()
        }
        // Yerə toqquşma / Ground collision
        else if birdPosition.y >= bottomBoundary {
            birdPosition.y = bottomBoundary
            endGame()
        }
    }
    
    // MARK: - Pipe Management / Boru idarəetməsi
    
    /// Yeni boru yaradır / Creates new pipe
    func spawnPipe() {
        // Boşluğun Y koordinatını təyin edir (yer və yerə minimum məsafəni nəzərə alır)
        // Sets gap Y coordinate (considering ground and minimum distance to ground)
        let availableHeight = screenHeight - groundHeight
        let minGapY = pipeGap / 2 + 50  // Yuxarı minimum məsafə / Top minimum distance
        let maxGapY = availableHeight - pipeGap / 2 - 50  // Aşağı minimum məsafə / Bottom minimum distance
        let gapY = CGFloat.random(in: minGapY...maxGapY)
        
        // Power-up spawn məntiqini yoxlayır / Checks power-up spawn logic
        powerUpSpawnCounter += 1
        var hasPowerUp = false
        var powerUpType: PowerUpType? = nil
        
        // Hər 6 borudan sonra power-up spawn / Spawn power-up every 6 pipes
        if powerUpSpawnCounter >= powerUpSpawnInterval {
            // 30% ehtimalla power-up spawn / 30% chance to spawn power-up
            if Int.random(in: 1...10) <= 3 {
                hasPowerUp = true
                // Təsadüfi power-up tipi seçir / Selects random power-up type
                let powerUpTypes: [PowerUpType] = [.shield, .slowMotion, .bonusScore, .magnet]
                powerUpType = powerUpTypes.randomElement()
                powerUpSpawnCounter = 0  // Counter-i sıfırlayır / Resets counter
            }
        }
        
        var newPipe = Pipe(
            x: screenWidth,
            gapY: gapY,
            gapHeight: pipeGap,
            width: pipeWidth
        )
        newPipe.hasPowerUp = hasPowerUp
        newPipe.powerUpType = powerUpType
        
        pipes.append(newPipe)
    }
    
    /// Boruları yeniləyir / Updates pipes
    func updatePipes() {
        guard gameState == .playing else { return }
        
        // Magnet power-up aktivdirsə, boruları cəlb etmə effektini tətbiq edir / If magnet power-up is active, applies attraction effect
        let isMagnetActive = isPowerUpActive?(.magnet) ?? false
        
        // Boruları hərəkət etdirir / Moves pipes
        for i in pipes.indices.reversed() {
            pipes[i].x -= pipeSpeed
            
            // Magnet effekti tətbiq edir / Applies magnet effect
            if isMagnetActive {
                applyMagnetEffect(to: &pipes[i])
            }
            
            // Ekranın solundan kənara çıxan boruları silir / Removes pipes that left screen
            if pipes[i].x + pipeWidth < 0 {
                pipes.remove(at: i)
                // Skoru artırır / Increases score
                let previousScore = score
                var scoreIncrease = 1
                
                // Bonus score power-up aktivdirsə, skor 2x artır / If bonus score power-up is active, double score
                if let isPowerUpActive = isPowerUpActive, isPowerUpActive(.bonusScore) {
                    scoreIncrease = 2
                }
                
                score += scoreIncrease
                // Keçilən boru sayını artırır / Increases pipes passed count
                pipesPassed += 1
                // Skor artımı callback-i üçün (Controller-da handle edilir)
                // For score increase callback (handled in Controller)
                if score > previousScore {
                    // Notification göndərir ki, skor artdı / Sends notification that score increased
                    NotificationCenter.default.post(name: .scoreIncreased, object: nil)
                }
            }
        }
        
        // Yeni boru yaradır (interval əsasında) / Creates new pipe (based on interval)
        if let lastPipe = pipes.last {
            if screenWidth - lastPipe.x >= pipeSpawnInterval {
                spawnPipe()
            }
        } else {
            // Əgər boru yoxdursa, dərhal yaradır / If no pipes, creates immediately
            spawnPipe()
        }
    }
    
    /// Magnet effektini boruya tətbiq edir / Applies magnet effect to pipe
    private func applyMagnetEffect(to pipe: inout Pipe) {
        // Borunun mərkəz nöqtəsi / Pipe center point
        let pipeCenterX = pipe.x + pipeWidth / 2
        let pipeCenterY = pipe.gapY
        
        // Quşdan boruya məsafə / Distance from bird to pipe
        let dx = birdPosition.x - pipeCenterX
        let dy = birdPosition.y - pipeCenterY
        let distance = sqrt(dx * dx + dy * dy)
        
        // Magnet radius daxilindədirsə / If within magnet radius
        if distance <= magnetRadius && distance > 0 {
            // Məsafəyə görə cəlb etmə qüvvəsi (daha yaxın = daha güclü) / Attraction strength based on distance (closer = stronger)
            let normalizedDistance = distance / magnetRadius  // 0-1 arası / Between 0-1
            let attractionStrength = magnetStrength * (1.0 - normalizedDistance)  // Daha yaxın = daha güclü / Closer = stronger
            
            // Borunun Y koordinatını quşa doğru cəlb et / Attract pipe's Y coordinate towards bird
            let targetY = birdPosition.y
            let currentY = pipe.gapY
            let yDifference = targetY - currentY
            
            // Smooth cəlb etmə (məsafəyə görə) / Smooth attraction (based on distance)
            let yAttraction = yDifference * attractionStrength * 0.1  // 0.1 smoothness factor
            let newGapY = currentY + yAttraction
            
            // Yeni gapY-ni məhdudlaşdırır (ekran hədləri daxilində) / Constrains new gapY (within screen bounds)
            let availableHeight = screenHeight - groundHeight
            let minGapY = pipeGap / 2 + 50  // Yuxarı minimum məsafə / Top minimum distance
            let maxGapY = availableHeight - pipeGap / 2 - 50  // Aşağı minimum məsafə / Bottom minimum distance
            
            pipe.gapY = max(minGapY, min(maxGapY, newGapY))
        }
    }
    
    // MARK: - Collision Detection / Toqquşma yoxlaması
    
    /// Boru ilə toqquşma yoxlayır / Checks collision with pipes
    func checkCollisions() -> Bool {
        guard gameState == .playing else { return false }
        
        // Shield power-up aktivdirsə, toqquşma yoxdur / If shield power-up is active, no collision
        if let isPowerUpActive = isPowerUpActive, isPowerUpActive(.shield) {
            // Power-up toplama yoxlaması / Power-up collection check
            checkPowerUpCollection()
            return false
        }
        
        let birdRect = CGRect(
            x: birdPosition.x - birdSize / 2,
            y: birdPosition.y - birdSize / 2,
            width: birdSize,
            height: birdSize
        )
        
        for i in pipes.indices {
            let pipe = pipes[i]
            
            // Power-up toplama yoxlaması / Power-up collection check
            if pipe.hasPowerUp && !pipe.powerUpCollected {
                let powerUpRect = CGRect(
                    x: pipe.x + pipeWidth / 2 - 20,
                    y: pipe.gapY - 20,
                    width: 40,
                    height: 40
                )
                
                if birdRect.intersects(powerUpRect) {
                    // Power-up toplanır / Power-up collected
                    pipes[i].powerUpCollected = true
                    if let powerUpType = pipe.powerUpType {
                        onPowerUpCollected?(powerUpType)
                    }
                    // Power-up toplanmasından sonra toqquşma yoxlamasına davam edir / Continues collision check after collection
                }
            }
            
            // Yuxarı boru / Top pipe (tavandan başlayır)
            let topPipeRect = CGRect(
                x: pipe.x,
                y: 0,
                width: pipeWidth,
                height: pipe.gapY - pipe.gapHeight / 2
            )
            
            // Aşağı boru / Bottom pipe (yerdən başlayır)
            let bottomPipeY = pipe.gapY + pipe.gapHeight / 2
            let bottomPipeHeight = screenHeight - groundHeight - bottomPipeY
            let bottomPipeRect = CGRect(
                x: pipe.x,
                y: bottomPipeY,
                width: pipeWidth,
                height: bottomPipeHeight
            )
            
            // Toqquşma yoxlayır / Checks collision
            if birdRect.intersects(topPipeRect) || birdRect.intersects(bottomPipeRect) {
                return true
            }
        }
        
        return false
    }
    
    /// Power-up toplama yoxlaması / Power-up collection check
    private func checkPowerUpCollection() {
        guard gameState == .playing else { return }
        
        let birdRect = CGRect(
            x: birdPosition.x - birdSize / 2,
            y: birdPosition.y - birdSize / 2,
            width: birdSize,
            height: birdSize
        )
        
        for i in pipes.indices {
            let pipe = pipes[i]
            if pipe.hasPowerUp && !pipe.powerUpCollected {
                let powerUpRect = CGRect(
                    x: pipe.x + pipeWidth / 2 - 20,
                    y: pipe.gapY - 20,
                    width: 40,
                    height: 40
                )
                
                if birdRect.intersects(powerUpRect) {
                    // Power-up toplanır / Power-up collected
                    pipes[i].powerUpCollected = true
                    if let powerUpType = pipe.powerUpType {
                        onPowerUpCollected?(powerUpType)
                    }
                }
            }
        }
    }
    
    // MARK: - Game Update / Oyun yeniləməsi
    
    /// Oyunu bir frame yeniləyir / Updates game by one frame
    func update() {
        guard gameState == .playing else { return }
        
        updateBird()
        updatePipes()
        
        // Toqquşma yoxlayır / Checks collision
        if checkCollisions() {
            endGame()
        }
    }
    
    // MARK: - Screen Size / Ekran ölçüsü
    
    /// Ekran ölçülərini təyin edir / Sets screen dimensions
    func setScreenSize(width: CGFloat, height: CGFloat) {
        screenWidth = width
        screenHeight = height
        // Quşun ilkin pozisiyasını yeniləyir / Updates initial bird position
        if gameState == .start {
            birdPosition = CGPoint(x: 100, y: height / 2)
        }
    }
}

