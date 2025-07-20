import SwiftUI
import Foundation

// MARK: - MicroFlip Game Model
struct MicroFlipGame: Identifiable, Codable {
    let id = UUID()
    let gameType: GameType
    let difficulty: Difficulty
    let betAmount: Double
    let startTime: Date
    var endTime: Date?
    var outcome: GameOutcome?
    var playerChoice: PlayerChoice?
    var actualResult: FlipResult?
    var winAmount: Double?
    
    // Game settings
    let timeLimit: TimeInterval
    let multiplier: Double
    
    var isCompleted: Bool {
        outcome != nil && endTime != nil
    }
    
    var duration: TimeInterval? {
        guard let endTime = endTime else { return nil }
        return endTime.timeIntervalSince(startTime)
    }
    
    var profitLoss: Double {
        guard let winAmount = winAmount else { return -betAmount }
        return winAmount - betAmount
    }
    
    enum GameType: String, Codable, CaseIterable {
        case quickFlip = "Quick Flip"
        case powerFlip = "Power Flip"
        case megaFlip = "Mega Flip"
        case ultraFlip = "Ultra Flip"
        
        var description: String {
            switch self {
            case .quickFlip: return "Fast-paced 15 second flips"
            case .powerFlip: return "30 second strategic flips"
            case .megaFlip: return "60 second mega multipliers"
            case .ultraFlip: return "120 second ultra challenges"
            }
        }
        
        var timeLimit: TimeInterval {
            switch self {
            case .quickFlip: return 15
            case .powerFlip: return 30
            case .megaFlip: return 60
            case .ultraFlip: return 120
            }
        }
        
        var baseMultiplier: Double {
            switch self {
            case .quickFlip: return 1.8
            case .powerFlip: return 2.2
            case .megaFlip: return 3.5
            case .ultraFlip: return 5.0
            }
        }
        
        var emoji: String {
            switch self {
            case .quickFlip: return "⚡"
            case .powerFlip: return "💪"
            case .megaFlip: return "💎"
            case .ultraFlip: return "🚀"
            }
        }
    }
    
    enum Difficulty: String, Codable, CaseIterable {
        case rookie = "Rookie"
        case trader = "Trader"
        case pro = "Pro"
        case legend = "Legend"
        
        var description: String {
            switch self {
            case .rookie: return "Easy wins, lower multipliers"
            case .trader: return "Balanced risk and reward"
            case .pro: return "Higher stakes, bigger wins"
            case .legend: return "Ultimate challenge mode"
            }
        }
        
        var difficultyMultiplier: Double {
            switch self {
            case .rookie: return 0.8
            case .trader: return 1.0
            case .pro: return 1.5
            case .legend: return 2.0
            }
        }
        
        var winProbability: Double {
            switch self {
            case .rookie: return 0.65
            case .trader: return 0.50
            case .pro: return 0.45
            case .legend: return 0.35
            }
        }
        
        var emoji: String {
            switch self {
            case .rookie: return "🟢"
            case .trader: return "🟡"
            case .pro: return "🟠"
            case .legend: return "🔴"
            }
        }
        
        var color: Color {
            switch self {
            case .rookie: return .green
            case .trader: return .yellow
            case .pro: return .orange
            case .legend: return .red
            }
        }
    }
    
    enum PlayerChoice: String, Codable {
        case heads = "Heads"
        case tails = "Tails"
        
        var emoji: String {
            switch self {
            case .heads: return "🪙"
            case .tails: return "⭐"
            }
        }
    }
    
    enum FlipResult: String, Codable, CaseIterable {
        case heads = "Heads"
        case tails = "Tails"
        
        var emoji: String {
            switch self {
            case .heads: return "🪙"
            case .tails: return "⭐"
            }
        }
    }
    
    enum GameOutcome: String, Codable {
        case win = "Win"
        case loss = "Loss"
        case timeout = "Timeout"
        
        var emoji: String {
            switch self {
            case .win: return "🎉"
            case .loss: return "😔"
            case .timeout: return "⏰"
            }
        }
        
        var color: Color {
            switch self {
            case .win: return .green
            case .loss: return .red
            case .timeout: return .orange
            }
        }
    }
}

// MARK: - Sample Data
extension MicroFlipGame {
    static let sampleGames: [MicroFlipGame] = [
        MicroFlipGame(
            gameType: .quickFlip,
            difficulty: .trader,
            betAmount: 100,
            startTime: Date().addingTimeInterval(-3600),
            endTime: Date().addingTimeInterval(-3590),
            outcome: .win,
            playerChoice: .heads,
            actualResult: .heads,
            winAmount: 180,
            timeLimit: GameType.quickFlip.timeLimit,
            multiplier: GameType.quickFlip.baseMultiplier * Difficulty.trader.difficultyMultiplier
        ),
        
        MicroFlipGame(
            gameType: .powerFlip,
            difficulty: .pro,
            betAmount: 250,
            startTime: Date().addingTimeInterval(-7200),
            endTime: Date().addingTimeInterval(-7170),
            outcome: .loss,
            playerChoice: .tails,
            actualResult: .heads,
            winAmount: 0,
            timeLimit: GameType.powerFlip.timeLimit,
            multiplier: GameType.powerFlip.baseMultiplier * Difficulty.pro.difficultyMultiplier
        ),
        
        MicroFlipGame(
            gameType: .megaFlip,
            difficulty: .legend,
            betAmount: 500,
            startTime: Date().addingTimeInterval(-10800),
            endTime: Date().addingTimeInterval(-10740),
            outcome: .win,
            playerChoice: .heads,
            actualResult: .heads,
            winAmount: 1750,
            timeLimit: GameType.megaFlip.timeLimit,
            multiplier: GameType.megaFlip.baseMultiplier * Difficulty.legend.difficultyMultiplier
        )
    ]
    
    static func createNewGame(type: GameType, difficulty: Difficulty, betAmount: Double) -> MicroFlipGame {
        return MicroFlipGame(
            gameType: type,
            difficulty: difficulty,
            betAmount: betAmount,
            startTime: Date(),
            endTime: nil,
            outcome: nil,
            playerChoice: nil,
            actualResult: nil,
            winAmount: nil,
            timeLimit: type.timeLimit,
            multiplier: type.baseMultiplier * difficulty.difficultyMultiplier
        )
    }
    
    mutating func makeChoice(_ choice: PlayerChoice) {
        self.playerChoice = choice
        executeFlip()
    }
    
    private mutating func executeFlip() {
        // Simulate coin flip with difficulty-based probability
        let random = Double.random(in: 0...1)
        let winProbability = difficulty.winProbability
        
        // Determine actual result
        actualResult = FlipResult.allCases.randomElement()!
        
        // Determine outcome based on choice and difficulty
        let playerWins: Bool
        if let playerChoice = playerChoice {
            if random < winProbability {
                // Player wins - match their choice
                playerWins = (playerChoice.rawValue == actualResult?.rawValue)
            } else {
                // Player loses - opposite of their choice
                playerWins = false
                actualResult = playerChoice == .heads ? .tails : .heads
            }
        } else {
            playerWins = false
        }
        
        // Set outcome and win amount
        if playerWins {
            outcome = .win
            winAmount = betAmount * multiplier
        } else {
            outcome = .loss
            winAmount = 0
        }
        
        endTime = Date()
    }
    
    mutating func timeout() {
        outcome = .timeout
        winAmount = 0
        endTime = Date()
    }
}

// MARK: - Game Statistics
struct FlipGameStats: Codable {
    let totalGames: Int
    let totalWins: Int
    let totalLosses: Int
    let totalTimeouts: Int
    let totalBetAmount: Double
    let totalWinAmount: Double
    let currentStreak: Int
    let longestWinStreak: Int
    let longestLossStreak: Int
    let favoriteGameType: MicroFlipGame.GameType?
    let preferredDifficulty: MicroFlipGame.Difficulty?
    
    var winRate: Double {
        guard totalGames > 0 else { return 0 }
        return Double(totalWins) / Double(totalGames) * 100
    }
    
    var totalProfit: Double {
        return totalWinAmount - totalBetAmount
    }
    
    var averageBet: Double {
        guard totalGames > 0 else { return 0 }
        return totalBetAmount / Double(totalGames)
    }
    
    var averageWin: Double {
        guard totalWins > 0 else { return 0 }
        return totalWinAmount / Double(totalWins)
    }
    
    static let empty = FlipGameStats(
        totalGames: 0,
        totalWins: 0,
        totalLosses: 0,
        totalTimeouts: 0,
        totalBetAmount: 0,
        totalWinAmount: 0,
        currentStreak: 0,
        longestWinStreak: 0,
        longestLossStreak: 0,
        favoriteGameType: nil,
        preferredDifficulty: nil
    )
}

// MARK: - Flip Game Manager
@MainActor
class MicroFlipGameManager: ObservableObject {
    @Published var currentGame: MicroFlipGame?
    @Published var gameHistory: [MicroFlipGame] = []
    @Published var stats: FlipGameStats = .empty
    @Published var isFlipping = false
    @Published var showingGameResult = false
    
    init() {
        loadGameHistory()
        calculateStats()
    }
    
    func startNewGame(type: MicroFlipGame.GameType, difficulty: MicroFlipGame.Difficulty, betAmount: Double) {
        currentGame = MicroFlipGame.createNewGame(type: type, difficulty: difficulty, betAmount: betAmount)
    }
    
    func makeChoice(_ choice: MicroFlipGame.PlayerChoice) {
        guard var game = currentGame else { return }
        
        isFlipping = true
        
        // Animate the flip
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            game.makeChoice(choice)
            self.currentGame = game
            self.completeGame()
        }
    }
    
    private func completeGame() {
        guard let game = currentGame else { return }
        
        gameHistory.append(game)
        saveGameHistory()
        calculateStats()
        
        isFlipping = false
        showingGameResult = true
        
        // Clear current game after showing result
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.currentGame = nil
            self.showingGameResult = false
        }
    }
    
    private func loadGameHistory() {
        gameHistory = MicroFlipGame.sampleGames
    }
    
    private func saveGameHistory() {
        // In a real app, save to UserDefaults or Core Data
    }
    
    private func calculateStats() {
        let totalGames = gameHistory.count
        let wins = gameHistory.filter { $0.outcome == .win }.count
        let losses = gameHistory.filter { $0.outcome == .loss }.count
        let timeouts = gameHistory.filter { $0.outcome == .timeout }.count
        let totalBet = gameHistory.reduce(0) { $0 + $1.betAmount }
        let totalWon = gameHistory.compactMap { $0.winAmount }.reduce(0, +)
        
        // Calculate streaks
        var currentStreak = 0
        var longestWinStreak = 0
        var longestLossStreak = 0
        var tempWinStreak = 0
        var tempLossStreak = 0
        
        for game in gameHistory.reversed() {
            switch game.outcome {
            case .win:
                if currentStreak >= 0 {
                    currentStreak += 1
                } else {
                    currentStreak = 1
                }
                tempWinStreak += 1
                longestWinStreak = max(longestWinStreak, tempWinStreak)
                tempLossStreak = 0
                
            case .loss:
                if currentStreak <= 0 {
                    currentStreak -= 1
                } else {
                    currentStreak = -1
                }
                tempLossStreak += 1
                longestLossStreak = max(longestLossStreak, tempLossStreak)
                tempWinStreak = 0
                
            case .timeout, .none:
                break
            }
        }
        
        // Find favorite game type and difficulty
        let gameTypeCounts = Dictionary(grouping: gameHistory) { $0.gameType }
            .mapValues { $0.count }
        let favoriteGameType = gameTypeCounts.max(by: { $0.value < $1.value })?.key
        
        let difficultyCounts = Dictionary(grouping: gameHistory) { $0.difficulty }
            .mapValues { $0.count }
        let preferredDifficulty = difficultyCounts.max(by: { $0.value < $1.value })?.key
        
        stats = FlipGameStats(
            totalGames: totalGames,
            totalWins: wins,
            totalLosses: losses,
            totalTimeouts: timeouts,
            totalBetAmount: totalBet,
            totalWinAmount: totalWon,
            currentStreak: currentStreak,
            longestWinStreak: longestWinStreak,
            longestLossStreak: longestLossStreak,
            favoriteGameType: favoriteGameType,
            preferredDifficulty: preferredDifficulty
        )
    }
}