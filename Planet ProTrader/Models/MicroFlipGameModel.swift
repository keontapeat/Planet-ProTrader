//
//  MicroFlipGameModel.swift
//  Planet ProTrader
//
//  Created by AI Assistant on 1/25/25.
//

import SwiftUI
import Foundation

struct MicroFlipGame: Identifiable, Codable {
    let id = UUID()
    var playerId: String
    var gameType: GameType
    var entryAmount: Double
    var targetAmount: Double
    var currentBalance: Double
    var startingBalance: Double
    var targetProfit: Double
    var maxLoss: Double
    var duration: TimeInterval
    var elapsedTime: TimeInterval = 0
    var maxTime: TimeInterval
    var status: GameStatus
    var difficulty: Difficulty
    var isCompleted: Bool = false
    var isWon: Bool = false
    var result: GameResult?
    var timestamp: Date = Date()
    var reactions: [PlayerReaction] = []
    var name: String
    
    init(playerId: String, gameType: GameType, entryAmount: Double, targetAmount: Double, duration: TimeInterval, status: GameStatus = .active, difficulty: Difficulty = .pro) {
        self.playerId = playerId
        self.gameType = gameType
        self.entryAmount = entryAmount
        self.targetAmount = targetAmount
        self.currentBalance = entryAmount
        self.startingBalance = entryAmount
        self.targetProfit = targetAmount
        self.maxLoss = entryAmount * 0.1 // Stop loss at 90% loss
        self.duration = duration
        self.maxTime = duration
        self.status = status
        self.difficulty = difficulty
        self.name = "\(gameType.emoji) \(gameType.displayName)"
    }
    
    var progressToTarget: Double {
        guard targetProfit > startingBalance else { return 0 }
        let progress = (currentBalance - startingBalance) / (targetProfit - startingBalance)
        return max(0, min(1, progress))
    }
    
    var timeRemaining: TimeInterval {
        return max(0, maxTime - elapsedTime)
    }
    
    // MARK: - Game Types
    enum GameType: String, CaseIterable, Codable {
        case quickFlip = "quickFlip"
        case speedRun = "speedRun"
        case precision = "precision"
        case endurance = "endurance"
        case riskMaster = "riskMaster"
        case botBattle = "botBattle"
        
        var displayName: String {
            switch self {
            case .quickFlip: return "⚡ Quick Flip"
            case .speedRun: return "🏃‍♂️ Speed Run"
            case .precision: return "🎯 Precision"
            case .endurance: return "💪 Endurance"
            case .riskMaster: return "🎲 Risk Master"
            case .botBattle: return "🤖 Bot Battle"
            }
        }
        
        var emoji: String {
            switch self {
            case .quickFlip: return "⚡"
            case .speedRun: return "🏃‍♂️"
            case .precision: return "🎯"
            case .endurance: return "💪"
            case .riskMaster: return "🎲"
            case .botBattle: return "🤖"
            }
        }
        
        var description: String {
            switch self {
            case .quickFlip: return "Fast-paced 5-minute challenges"
            case .speedRun: return "Beat the clock in 3 minutes"
            case .precision: return "Accuracy over speed"
            case .endurance: return "Long-term strategy game"
            case .riskMaster: return "High risk, high reward"
            case .botBattle: return "Compete against AI bots"
            }
        }
        
        var baseMultiplier: Double {
            switch self {
            case .quickFlip: return 1.5
            case .speedRun: return 2.0
            case .precision: return 1.8
            case .endurance: return 1.3
            case .riskMaster: return 3.0
            case .botBattle: return 2.5
            }
        }
    }
    
    // MARK: - Game Status
    enum GameStatus: String, CaseIterable, Codable {
        case active = "active"
        case paused = "paused"
        case completed = "completed"
        case failed = "failed"
        case cancelled = "cancelled"
        
        var displayName: String {
            switch self {
            case .active: return "🟢 Active"
            case .paused: return "⏸️ Paused"
            case .completed: return "✅ Completed"
            case .failed: return "❌ Failed"
            case .cancelled: return "⭕ Cancelled"
            }
        }
        
        var color: Color {
            switch self {
            case .active: return .green
            case .paused: return .orange
            case .completed: return .blue
            case .failed: return .red
            case .cancelled: return .gray
            }
        }
    }
    
    // MARK: - Difficulty Levels
    enum Difficulty: String, CaseIterable, Codable {
        case rookie = "rookie"
        case pro = "pro"
        case expert = "expert"
        case legend = "legend"
        
        var displayName: String {
            switch self {
            case .rookie: return "🟢 Rookie"
            case .pro: return "🔵 Pro"
            case .expert: return "🟡 Expert"
            case .legend: return "🔴 Legend"
            }
        }
        
        var color: Color {
            switch self {
            case .rookie: return .green
            case .pro: return .blue
            case .expert: return .orange
            case .legend: return .red
            }
        }
        
        var multiplier: Double {
            switch self {
            case .rookie: return 1.0
            case .pro: return 1.2
            case .expert: return 1.5
            case .legend: return 2.0
            }
        }
    }
    
    // MARK: - Game Result
    struct GameResult: Codable {
        let profit: Double
        let profitPercentage: Double
        let rank: Rank
        let achievements: [Achievement]
        
        var displayText: String {
            if profit >= 0 {
                return "+$\(String(format: "%.2f", profit))"
            } else {
                return "-$\(String(format: "%.2f", abs(profit)))"
            }
        }
        
        var color: Color {
            return profit >= 0 ? .green : .red
        }
        
        enum Rank: String, CaseIterable, Codable {
            case bronze = "bronze"
            case silver = "silver"
            case gold = "gold"
            case platinum = "platinum"
            case diamond = "diamond"
            
            var displayName: String {
                switch self {
                case .bronze: return "🥉 Bronze"
                case .silver: return "🥈 Silver"
                case .gold: return "🥇 Gold"
                case .platinum: return "💎 Platinum"
                case .diamond: return "💎 Diamond"
                }
            }
        }
        
        struct Achievement: Codable, Identifiable {
            let id = UUID()
            let name: String
            let description: String
            let emoji: String
        }
    }
    
    // MARK: - Player Reactions
    struct PlayerReaction: Codable, Identifiable {
        let id = UUID()
        let type: ReactionType
        let timestamp: Date = Date()
        
        enum ReactionType: String, CaseIterable, Codable {
            case love = "love"
            case fire = "fire"
            case rocket = "rocket"
            case money = "money"
            case surprised = "surprised"
            case worried = "worried"
            
            var emoji: String {
                switch self {
                case .love: return "❤️"
                case .fire: return "🔥"
                case .rocket: return "🚀"
                case .money: return "💰"
                case .surprised: return "😱"
                case .worried: return "😰"
                }
            }
        }
    }
    
    // MARK: - Sample Data
    static var sampleGames: [MicroFlipGame] {
        [
            MicroFlipGame(
                playerId: "sample_player",
                gameType: .quickFlip,
                entryAmount: 50.0,
                targetAmount: 75.0,
                duration: 300,
                status: .completed,
                difficulty: .pro
            ),
            MicroFlipGame(
                playerId: "sample_player",
                gameType: .speedRun,
                entryAmount: 100.0,
                targetAmount: 200.0,
                duration: 180,
                status: .active,
                difficulty: .expert
            ),
            MicroFlipGame(
                playerId: "sample_player",
                gameType: .precision,
                entryAmount: 25.0,
                targetAmount: 45.0,
                duration: 600,
                status: .failed,
                difficulty: .rookie
            )
        ]
    }
}

#Preview {
    VStack {
        ForEach(MicroFlipGame.sampleGames) { game in
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(game.gameType.emoji)
                        .font(.title)
                    
                    VStack(alignment: .leading) {
                        Text(game.name)
                            .font(.headline.bold())
                        
                        Text(game.difficulty.displayName)
                            .font(.caption)
                            .foregroundColor(game.difficulty.color)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text(game.status.displayName)
                            .font(.caption.bold())
                            .foregroundColor(game.status.color)
                        
                        Text("$\(String(format: "%.0f", game.currentBalance))")
                            .font(.subheadline.bold())
                    }
                }
                
                ProgressView(value: game.progressToTarget)
                    .tint(.blue)
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(12)
        }
    }
    .padding()
}