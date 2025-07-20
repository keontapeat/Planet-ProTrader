//
//  GameFeatureModels.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 1/25/25.
//

import Foundation
import SwiftUI

// MARK: - Bot Leaderboard Models

struct BotLeaderboard: Identifiable, Codable {
    let id: UUID
    let name: String
    let category: LeaderboardCategory
    let timeframe: Timeframe
    let entries: [LeaderboardEntry]
    let totalParticipants: Int
    let updatedAt: Date
    let season: Int
    let prize: LeaderboardPrize?
    
    enum LeaderboardCategory: String, Codable, CaseIterable {
        case overall = "overall"
        case profitability = "profitability" 
        case winRate = "win_rate"
        case riskAdjusted = "risk_adjusted"
        case consistency = "consistency"
        case volume = "volume"
        case speed = "speed"
        case innovation = "innovation"
        
        var displayName: String {
            switch self {
            case .overall: return "🏆 Overall Champions"
            case .profitability: return "💰 Profit Kings"
            case .winRate: return "🎯 Win Rate Masters"
            case .riskAdjusted: return "⚖️ Risk Adjusted"
            case .consistency: return "📊 Most Consistent"
            case .volume: return "📈 Volume Leaders"
            case .speed: return "⚡ Speed Demons"
            case .innovation: return "🧠 Innovation Lab"
            }
        }
        
        var emoji: String {
            switch self {
            case .overall: return "🏆"
            case .profitability: return "💰"
            case .winRate: return "🎯"
            case .riskAdjusted: return "⚖️"
            case .consistency: return "📊"
            case .volume: return "📈"
            case .speed: return "⚡"
            case .innovation: return "🧠"
            }
        }
        
        var color: Color {
            switch self {
            case .overall: return .gold
            case .profitability: return .green
            case .winRate: return .blue
            case .riskAdjusted: return .purple
            case .consistency: return .orange
            case .volume: return .red
            case .speed: return .cyan
            case .innovation: return .pink
            }
        }
    }
    
    enum Timeframe: String, Codable, CaseIterable {
        case realtime = "realtime"
        case hourly = "hourly"
        case daily = "daily"
        case weekly = "weekly"
        case monthly = "monthly"
        case season = "season"
        case allTime = "all_time"
        
        var displayName: String {
            switch self {
            case .realtime: return "⚡ Live"
            case .hourly: return "🕐 Hourly"
            case .daily: return "📅 Daily"
            case .weekly: return "📊 Weekly"
            case .monthly: return "📈 Monthly"
            case .season: return "🏆 Season"
            case .allTime: return "🌟 All Time"
            }
        }
    }
    
    struct LeaderboardPrize: Codable {
        let type: PrizeType
        let amount: Double
        let currency: String
        let description: String
        let requirements: [String]
        
        enum PrizeType: String, Codable {
            case cash = "cash"
            case tradingFuel = "trading_fuel"
            case premium = "premium"
            case nft = "nft"
            case title = "title"
        }
    }
    
    init(
        id: UUID = UUID(),
        name: String,
        category: LeaderboardCategory,
        timeframe: Timeframe,
        entries: [LeaderboardEntry] = [],
        totalParticipants: Int = 0,
        updatedAt: Date = Date(),
        season: Int = 1,
        prize: LeaderboardPrize? = nil
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.timeframe = timeframe
        self.entries = entries.sorted { $0.rank < $1.rank }
        self.totalParticipants = totalParticipants
        self.updatedAt = updatedAt
        self.season = season
        self.prize = prize
    }
    
    var topThree: [LeaderboardEntry] {
        return Array(entries.prefix(3))
    }
    
    var isLive: Bool {
        return timeframe == .realtime
    }
}

struct LeaderboardEntry: Identifiable, Codable {
    let id: UUID
    let botId: String
    let botName: String
    let botPersonality: BotPersonality
    let rank: Int
    let previousRank: Int?
    let score: Double
    let metric: LeaderboardMetric
    let streak: Int
    let badges: [Achievement]
    let lastActive: Date
    let totalTrades: Int
    let winRate: Double
    let profitLoss: Double
    let riskScore: Double
    let consistency: Double
    let volume: Double
    let speed: Double // trades per minute
    let innovation: Double // unique strategy score
    
    struct LeaderboardMetric: Codable {
        let primaryValue: Double
        let secondaryValue: Double?
        let unit: String
        let displayFormat: String
        let trend: TrendDirection
        
        enum TrendDirection: String, Codable {
            case up = "up"
            case down = "down"
            case stable = "stable"
            
            var systemImage: String {
                switch self {
                case .up: return "arrow.up"
                case .down: return "arrow.down"
                case .stable: return "minus"
                }
            }
            
            var color: Color {
                switch self {
                case .up: return .green
                case .down: return .red
                case .stable: return .gray
                }
            }
        }
    }
    
    init(
        id: UUID = UUID(),
        botId: String,
        botName: String,
        botPersonality: BotPersonality,
        rank: Int,
        previousRank: Int? = nil,
        score: Double,
        metric: LeaderboardMetric,
        streak: Int = 0,
        badges: [Achievement] = [],
        lastActive: Date = Date(),
        totalTrades: Int = 0,
        winRate: Double = 0.0,
        profitLoss: Double = 0.0,
        riskScore: Double = 0.0,
        consistency: Double = 0.0,
        volume: Double = 0.0,
        speed: Double = 0.0,
        innovation: Double = 0.0
    ) {
        self.id = id
        self.botId = botId
        self.botName = botName
        self.botPersonality = botPersonality
        self.rank = rank
        self.previousRank = previousRank
        self.score = score
        self.metric = metric
        self.streak = streak
        self.badges = badges
        self.lastActive = lastActive
        self.totalTrades = totalTrades
        self.winRate = winRate
        self.profitLoss = profitLoss
        self.riskScore = riskScore
        self.consistency = consistency
        self.volume = volume
        self.speed = speed
        self.innovation = innovation
    }
    
    var rankChange: RankChange {
        guard let previousRank = previousRank else { return .new }
        
        if rank < previousRank {
            return .up(previousRank - rank)
        } else if rank > previousRank {
            return .down(rank - previousRank)
        } else {
            return .same
        }
    }
    
    enum RankChange {
        case up(Int)
        case down(Int)
        case same
        case new
        
        var systemImage: String {
            switch self {
            case .up: return "arrow.up.circle.fill"
            case .down: return "arrow.down.circle.fill"
            case .same: return "minus.circle.fill"
            case .new: return "star.circle.fill"
            }
        }
        
        var color: Color {
            switch self {
            case .up: return .green
            case .down: return .red
            case .same: return .gray
            case .new: return .blue
            }
        }
        
        var displayText: String {
            switch self {
            case .up(let positions): return "+\(positions)"
            case .down(let positions): return "-\(positions)"
            case .same: return "±0"
            case .new: return "NEW"
            }
        }
    }
    
    var formattedScore: String {
        return String(format: metric.displayFormat, score)
    }
    
    var formattedProfitLoss: String {
        let sign = profitLoss >= 0 ? "+" : ""
        return "\(sign)$\(String(format: "%.2f", profitLoss))"
    }
    
    var formattedWinRate: String {
        return "\(String(format: "%.1f", winRate * 100))%"
    }
    
    var isActiveNow: Bool {
        return Date().timeIntervalSince(lastActive) < 300 // 5 minutes
    }
}

// MARK: - MicroFlip Game Models

struct MicroFlipGame: Identifiable, Codable {
    let id: UUID
    let playerId: String
    let gameType: GameType
    let entryAmount: Double
    let targetAmount: Double
    let duration: TimeInterval
    let status: GameStatus
    let startedAt: Date
    let completedAt: Date?
    let result: GameResult?
    let trades: [MicroTrade]
    let currentBalance: Double
    let maxDrawdown: Double
    let peakBalance: Double
    let totalFees: Double
    let botAssistant: String?
    let difficulty: Difficulty
    let achievements: [Achievement]
    let multiplier: Double
    
    enum GameType: String, Codable, CaseIterable {
        case quickFlip = "quick_flip"
        case speedRun = "speed_run"
        case precision = "precision"
        case endurance = "endurance"
        case riskMaster = "risk_master"
        case botBattle = "bot_battle"
        
        var displayName: String {
            switch self {
            case .quickFlip: return "⚡ Quick Flip"
            case .speedRun: return "🏃 Speed Run"
            case .precision: return "🎯 Precision"
            case .endurance: return "⏰ Endurance"
            case .riskMaster: return "🎲 Risk Master"
            case .botBattle: return "🤖 Bot Battle"
            }
        }
        
        var description: String {
            switch self {
            case .quickFlip: return "Double your money in 5 minutes"
            case .speedRun: return "Hit target in record time"
            case .precision: return "Win with 95%+ accuracy"
            case .endurance: return "Survive 30 minutes of volatility"
            case .riskMaster: return "High risk, high reward"
            case .botBattle: return "Compete against AI bots"
            }
        }
        
        var emoji: String {
            switch self {
            case .quickFlip: return "⚡"
            case .speedRun: return "🏃"
            case .precision: return "🎯"
            case .endurance: return "⏰"
            case .riskMaster: return "🎲"
            case .botBattle: return "🤖"
            }
        }
        
        var baseMultiplier: Double {
            switch self {
            case .quickFlip: return 1.5
            case .speedRun: return 2.0
            case .precision: return 2.5
            case .endurance: return 1.8
            case .riskMaster: return 3.0
            case .botBattle: return 2.2
            }
        }
    }
    
    enum GameStatus: String, Codable {
        case waiting = "waiting"
        case active = "active"
        case completed = "completed"
        case failed = "failed"
        case cancelled = "cancelled"
        case paused = "paused"
        
        var displayName: String {
            switch self {
            case .waiting: return "Waiting"
            case .active: return "Active"
            case .completed: return "Completed"
            case .failed: return "Failed"
            case .cancelled: return "Cancelled"
            case .paused: return "Paused"
            }
        }
        
        var color: Color {
            switch self {
            case .waiting: return .orange
            case .active: return .green
            case .completed: return .blue
            case .failed: return .red
            case .cancelled: return .gray
            case .paused: return .yellow
            }
        }
    }
    
    enum GameResult: Codable {
        case win(Double) // profit amount
        case loss(Double) // loss amount
        case breakeven
        
        var isWin: Bool {
            switch self {
            case .win: return true
            case .loss, .breakeven: return false
            }
        }
        
        var profitLoss: Double {
            switch self {
            case .win(let amount): return amount
            case .loss(let amount): return -amount
            case .breakeven: return 0.0
            }
        }
        
        var displayText: String {
            switch self {
            case .win(let amount): return "+$\(String(format: "%.2f", amount))"
            case .loss(let amount): return "-$\(String(format: "%.2f", amount))"
            case .breakeven: return "$0.00"
            }
        }
        
        var color: Color {
            switch self {
            case .win: return .green
            case .loss: return .red
            case .breakeven: return .gray
            }
        }
    }
    
    enum Difficulty: String, Codable, CaseIterable {
        case rookie = "rookie"
        case pro = "pro"
        case expert = "expert"
        case legend = "legend"
        case godmode = "godmode"
        
        var displayName: String {
            switch self {
            case .rookie: return "🟢 Rookie"
            case .pro: return "🔵 Pro"
            case .expert: return "🟡 Expert"
            case .legend: return "🟣 Legend"
            case .godmode: return "🔥 God Mode"
            }
        }
        
        var multiplier: Double {
            switch self {
            case .rookie: return 1.0
            case .pro: return 1.3
            case .expert: return 1.6
            case .legend: return 2.0
            case .godmode: return 3.0
            }
        }
        
        var color: Color {
            switch self {
            case .rookie: return .green
            case .pro: return .blue
            case .expert: return .yellow
            case .legend: return .purple
            case .godmode: return .red
            }
        }
    }
    
    init(
        id: UUID = UUID(),
        playerId: String,
        gameType: GameType,
        entryAmount: Double,
        targetAmount: Double,
        duration: TimeInterval,
        status: GameStatus = .waiting,
        startedAt: Date = Date(),
        completedAt: Date? = nil,
        result: GameResult? = nil,
        trades: [MicroTrade] = [],
        currentBalance: Double? = nil,
        maxDrawdown: Double = 0.0,
        peakBalance: Double? = nil,
        totalFees: Double = 0.0,
        botAssistant: String? = nil,
        difficulty: Difficulty = .rookie,
        achievements: [Achievement] = [],
        multiplier: Double? = nil
    ) {
        self.id = id
        self.playerId = playerId
        self.gameType = gameType
        self.entryAmount = entryAmount
        self.targetAmount = targetAmount
        self.duration = duration
        self.status = status
        self.startedAt = startedAt
        self.completedAt = completedAt
        self.result = result
        self.trades = trades
        self.currentBalance = currentBalance ?? entryAmount
        self.maxDrawdown = maxDrawdown
        self.peakBalance = peakBalance ?? entryAmount
        self.totalFees = totalFees
        self.botAssistant = botAssistant
        self.difficulty = difficulty
        self.achievements = achievements
        self.multiplier = multiplier ?? (gameType.baseMultiplier * difficulty.multiplier)
    }
    
    var timeRemaining: TimeInterval {
        let elapsed = Date().timeIntervalSince(startedAt)
        return max(0, duration - elapsed)
    }
    
    var progressPercentage: Double {
        let elapsed = Date().timeIntervalSince(startedAt)
        return min(1.0, elapsed / duration)
    }
    
    var profitTarget: Double {
        return targetAmount - entryAmount
    }
    
    var currentProfit: Double {
        return currentBalance - entryAmount
    }
    
    var progressToTarget: Double {
        guard profitTarget > 0 else { return 0 }
        return min(1.0, currentProfit / profitTarget)
    }
    
    var isActive: Bool {
        return status == .active && timeRemaining > 0
    }
    
    var potentialPayout: Double {
        return targetAmount * multiplier
    }
}

struct MicroTrade: Identifiable, Codable {
    let id: UUID
    let gameId: UUID
    let symbol: String
    let direction: TradeDirection
    let entryPrice: Double
    let exitPrice: Double?
    let quantity: Double
    let entryTime: Date
    let exitTime: Date?
    let profitLoss: Double
    let fees: Double
    let status: TradeStatus
    let confidence: Double
    let riskLevel: RiskLevel
    
    enum TradeDirection: String, Codable {
        case buy = "buy"
        case sell = "sell"
        
        var displayName: String {
            switch self {
            case .buy: return "BUY"
            case .sell: return "SELL"
            }
        }
        
        var color: Color {
            switch self {
            case .buy: return .green
            case .sell: return .red
            }
        }
        
        var systemImage: String {
            switch self {
            case .buy: return "arrow.up"
            case .sell: return "arrow.down"
            }
        }
    }
    
    enum TradeStatus: String, Codable {
        case open = "open"
        case closed = "closed"
        case cancelled = "cancelled"
        
        var displayName: String {
            switch self {
            case .open: return "Open"
            case .closed: return "Closed"
            case .cancelled: return "Cancelled"
            }
        }
        
        var color: Color {
            switch self {
            case .open: return .blue
            case .closed: return .green
            case .cancelled: return .gray
            }
        }
    }
    
    enum RiskLevel: String, Codable {
        case low = "low"
        case medium = "medium"
        case high = "high"
        case extreme = "extreme"
        
        var displayName: String {
            switch self {
            case .low: return "Low"
            case .medium: return "Medium"
            case .high: return "High"
            case .extreme: return "Extreme"
            }
        }
        
        var color: Color {
            switch self {
            case .low: return .green
            case .medium: return .yellow
            case .high: return .orange
            case .extreme: return .red
            }
        }
        
        var emoji: String {
            switch self {
            case .low: return "🟢"
            case .medium: return "🟡"
            case .high: return "🟠"
            case .extreme: return "🔴"
            }
        }
    }
    
    var isOpen: Bool {
        return status == .open
    }
    
    var duration: TimeInterval? {
        guard let exitTime = exitTime else { return nil }
        return exitTime.timeIntervalSince(entryTime)
    }
    
    var formattedProfitLoss: String {
        let sign = profitLoss >= 0 ? "+" : ""
        return "\(sign)$\(String(format: "%.2f", profitLoss))"
    }
    
    var isWinning: Bool {
        return profitLoss > 0
    }
}

// MARK: - Achievement System

struct Achievement: Identifiable, Codable {
    let id: UUID
    let name: String
    let description: String
    let category: AchievementCategory
    let tier: AchievementTier
    let emoji: String
    let requirements: [String]
    let reward: AchievementReward?
    let unlockedAt: Date?
    let progress: Double // 0.0 to 1.0
    let isSecret: Bool
    let rarity: Rarity
    
    enum AchievementCategory: String, Codable, CaseIterable {
        case trading = "trading"
        case speed = "speed"
        case accuracy = "accuracy"
        case endurance = "endurance"
        case risk = "risk"
        case social = "social"
        case special = "special"
        
        var displayName: String {
            switch self {
            case .trading: return "Trading"
            case .speed: return "Speed"
            case .accuracy: return "Accuracy"
            case .endurance: return "Endurance"
            case .risk: return "Risk Management"
            case .social: return "Social"
            case .special: return "Special"
            }
        }
    }
    
    enum AchievementTier: String, Codable, CaseIterable {
        case bronze = "bronze"
        case silver = "silver"
        case gold = "gold"
        case platinum = "platinum"
        case diamond = "diamond"
        case legendary = "legendary"
        
        var displayName: String {
            switch self {
            case .bronze: return "🥉 Bronze"
            case .silver: return "🥈 Silver"
            case .gold: return "🥇 Gold"
            case .platinum: return "💎 Platinum"
            case .diamond: return "💠 Diamond"
            case .legendary: return "🏆 Legendary"
            }
        }
        
        var color: Color {
            switch self {
            case .bronze: return .brown
            case .silver: return .gray
            case .gold: return .yellow
            case .platinum: return .blue
            case .diamond: return .cyan
            case .legendary: return .purple
            }
        }
    }
    
    enum Rarity: String, Codable, CaseIterable {
        case common = "common"
        case uncommon = "uncommon"
        case rare = "rare"
        case epic = "epic"
        case legendary = "legendary"
        case mythic = "mythic"
        
        var displayName: String {
            switch self {
            case .common: return "Common"
            case .uncommon: return "Uncommon"
            case .rare: return "Rare"
            case .epic: return "Epic"
            case .legendary: return "Legendary"
            case .mythic: return "Mythic"
            }
        }
        
        var color: Color {
            switch self {
            case .common: return .gray
            case .uncommon: return .green
            case .rare: return .blue
            case .epic: return .purple
            case .legendary: return .orange
            case .mythic: return .red
            }
        }
    }
    
    struct AchievementReward: Codable {
        let type: RewardType
        let amount: Double
        let currency: String?
        let description: String
        
        enum RewardType: String, Codable {
            case tradingFuel = "trading_fuel"
            case cash = "cash"
            case multiplier = "multiplier"
            case title = "title"
            case cosmetic = "cosmetic"
        }
    }
    
    var isUnlocked: Bool {
        return unlockedAt != nil
    }
    
    var progressPercentage: Int {
        return Int(progress * 100)
    }
}

// MARK: - Game Controller Models

struct GameController: Identifiable, Codable {
    let id: UUID
    let playerId: String
    let activeGames: [MicroFlipGame]
    let gameHistory: [MicroFlipGame]
    let totalGamesPlayed: Int
    let totalWins: Int
    let totalLosses: Int
    let totalProfitLoss: Double
    let winRate: Double
    let averageGameDuration: TimeInterval
    let favoriteGameType: MicroFlipGame.GameType?
    let currentStreak: Int
    let longestStreak: Int
    let achievements: [Achievement]
    let level: PlayerLevel
    let experience: Int
    let nextLevelXP: Int
    let statistics: GameStatistics
    
    struct PlayerLevel: Codable {
        let level: Int
        let title: String
        let minXP: Int
        let maxXP: Int
        let perks: [String]
        let color: String
        
        var displayName: String {
            return "Level \(level) - \(title)"
        }
    }
    
    struct GameStatistics: Codable {
        let totalTrades: Int
        let totalVolume: Double
        let averageTradeSize: Double
        let bestSingleGame: Double
        let worstSingleGame: Double
        let totalTimeSpent: TimeInterval
        let averageRiskLevel: Double
        let mostUsedStrategy: String?
        let perfectGames: Int // games with 100% win rate
        let speedRecords: [String: TimeInterval] // game type -> best time
        
        var formattedTotalVolume: String {
            return "$\(String(format: "%.0f", totalVolume))"
        }
        
        var formattedBestGame: String {
            return "$\(String(format: "%.2f", bestSingleGame))"
        }
        
        var formattedWorstGame: String {
            return "$\(String(format: "%.2f", abs(worstSingleGame)))"
        }
        
        var formattedTimeSpent: String {
            let hours = Int(totalTimeSpent / 3600)
            let minutes = Int((totalTimeSpent.truncatingRemainder(dividingBy: 3600)) / 60)
            return "\(hours)h \(minutes)m"
        }
    }
    
    var winRatePercentage: String {
        return "\(String(format: "%.1f", winRate * 100))%"
    }
    
    var formattedProfitLoss: String {
        let sign = totalProfitLoss >= 0 ? "+" : ""
        return "\(sign)$\(String(format: "%.2f", totalProfitLoss))"
    }
    
    var experienceProgress: Double {
        guard nextLevelXP > level.minXP else { return 1.0 }
        let currentLevelXP = experience - level.minXP
        let totalLevelXP = nextLevelXP - level.minXP
        return Double(currentLevelXP) / Double(totalLevelXP)
    }
    
    var xpToNextLevel: Int {
        return nextLevelXP - experience
    }
}

// MARK: - Bot Voice Notes Models

struct BotVoiceNote: Identifiable, Codable {
    let id: UUID
    let botId: String
    let botName: String
    let botPersonality: BotPersonality
    let gameId: UUID?
    let tradeId: UUID?
    let noteType: NoteType
    let message: String
    let emotion: BotEmotion
    let confidence: Double
    let timestamp: Date
    let duration: TimeInterval
    let audioURL: String?
    let isRead: Bool
    let importance: Importance
    let tags: [String]
    let reactions: [PlayerReaction]
    
    enum NoteType: String, Codable, CaseIterable {
        case encouragement = "encouragement"
        case warning = "warning"
        case celebration = "celebration"
        case analysis = "analysis"
        case advice = "advice"
        case trash_talk = "trash_talk"
        case apology = "apology"
        case congratulations = "congratulations"
        
        var displayName: String {
            switch self {
            case .encouragement: return "💪 Encouragement"
            case .warning: return "⚠️ Warning"
            case .celebration: return "🎉 Celebration"
            case .analysis: return "📊 Analysis"
            case .advice: return "💡 Advice"
            case .trash_talk: return "🔥 Trash Talk"
            case .apology: return "😔 Apology"
            case .congratulations: return "🏆 Congratulations"
            }
        }
        
        var emoji: String {
            switch self {
            case .encouragement: return "💪"
            case .warning: return "⚠️"
            case .celebration: return "🎉"
            case .analysis: return "📊"
            case .advice: return "💡"
            case .trash_talk: return "🔥"
            case .apology: return "😔"
            case .congratulations: return "🏆"
            }
        }
        
        var color: Color {
            switch self {
            case .encouragement: return .green
            case .warning: return .orange
            case .celebration: return .yellow
            case .analysis: return .blue
            case .advice: return .purple
            case .trash_talk: return .red
            case .apology: return .gray
            case .congratulations: return .gold
            }
        }
    }
    
    enum BotEmotion: String, Codable, CaseIterable {
        case happy = "happy"
        case excited = "excited"
        case confident = "confident"
        case worried = "worried"
        case angry = "angry"
        case surprised = "surprised"
        case disappointed = "disappointed"
        case neutral = "neutral"
        case cocky = "cocky"
        case apologetic = "apologetic"
        
        var emoji: String {
            switch self {
            case .happy: return "😊"
            case .excited: return "🤩"
            case .confident: return "😎"
            case .worried: return "😰"
            case .angry: return "😠"
            case .surprised: return "😲"
            case .disappointed: return "😞"
            case .neutral: return "😐"
            case .cocky: return "😏"
            case .apologetic: return "😔"
            }
        }
        
        var color: Color {
            switch self {
            case .happy, .excited: return .yellow
            case .confident, .cocky: return .blue
            case .worried, .disappointed, .apologetic: return .gray
            case .angry: return .red
            case .surprised: return .orange
            case .neutral: return .primary
            }
        }
    }
    
    enum Importance: String, Codable, CaseIterable {
        case low = "low"
        case medium = "medium"
        case high = "high"
        case urgent = "urgent"
        
        var displayName: String {
            switch self {
            case .low: return "Low"
            case .medium: return "Medium"
            case .high: return "High"
            case .urgent: return "Urgent"
            }
        }
        
        var color: Color {
            switch self {
            case .low: return .gray
            case .medium: return .blue
            case .high: return .orange
            case .urgent: return .red
            }
        }
        
        var priority: Int {
            switch self {
            case .low: return 1
            case .medium: return 2
            case .high: return 3
            case .urgent: return 4
            }
        }
    }
    
    struct PlayerReaction: Codable {
        let playerId: String
        let reaction: ReactionType
        let timestamp: Date
        
        enum ReactionType: String, Codable, CaseIterable {
            case like = "like"
            case dislike = "dislike"
            case laugh = "laugh"
            case angry = "angry"
            case love = "love"
            case fire = "fire"
            
            var emoji: String {
                switch self {
                case .like: return "👍"
                case .dislike: return "👎"
                case .laugh: return "😂"
                case .angry: return "😠"
                case .love: return "❤️"
                case .fire: return "🔥"
                }
            }
        }
    }
    
    var formattedDuration: String {
        let minutes = Int(duration / 60)
        let seconds = Int(duration.truncatingRemainder(dividingBy: 60))
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    var timeAgo: String {
        let elapsed = Date().timeIntervalSince(timestamp)
        
        if elapsed < 60 {
            return "now"
        } else if elapsed < 3600 {
            let minutes = Int(elapsed / 60)
            return "\(minutes)m ago"
        } else if elapsed < 86400 {
            let hours = Int(elapsed / 3600)
            return "\(hours)h ago"
        } else {
            let days = Int(elapsed / 86400)
            return "\(days)d ago"
        }
    }
    
    var totalReactions: Int {
        return reactions.count
    }
    
    var isUrgent: Bool {
        return importance == .urgent
    }
}

// MARK: - Sample Data

extension Color {
    static let gold = Color(red: 1.0, green: 0.84, blue: 0.0)
    static let cyan = Color(red: 0.0, green: 1.0, blue: 1.0)
    static let pink = Color(red: 1.0, green: 0.08, blue: 0.58)
    static let brown = Color(red: 0.6, green: 0.4, blue: 0.2)
}

extension BotLeaderboard {
    static let sampleLeaderboards: [BotLeaderboard] = [
        BotLeaderboard(
            name: "Elite Champions",
            category: .overall,
            timeframe: .daily,
            entries: LeaderboardEntry.sampleEntries,
            totalParticipants: 847,
            season: 3
        ),
        BotLeaderboard(
            name: "Profit Kings",
            category: .profitability,
            timeframe: .weekly,
            entries: Array(LeaderboardEntry.sampleEntries.prefix(5)),
            totalParticipants: 623,
            season: 3
        )
    ]
}

extension LeaderboardEntry {
    static let sampleEntries: [LeaderboardEntry] = [
        LeaderboardEntry(
            botId: "bot_1",
            botName: "Alpha Wolf",
            botPersonality: .aggressive,
            rank: 1,
            previousRank: 2,
            score: 2847.3,
            metric: LeaderboardMetric(
                primaryValue: 2847.3,
                secondaryValue: 94.2,
                unit: "$",
                displayFormat: "$%.2f",
                trend: .up
            ),
            streak: 7,
            totalTrades: 156,
            winRate: 0.89,
            profitLoss: 2847.3,
            riskScore: 0.73,
            consistency: 0.91
        ),
        LeaderboardEntry(
            botId: "bot_2",
            botName: "Quantum Beast",
            botPersonality: .analytical,
            rank: 2,
            previousRank: 1,
            score: 2743.8,
            metric: LeaderboardMetric(
                primaryValue: 2743.8,
                unit: "$",
                displayFormat: "$%.2f",
                trend: .down
            ),
            streak: 12,
            totalTrades: 203,
            winRate: 0.84,
            profitLoss: 2743.8
        ),
        LeaderboardEntry(
            botId: "bot_3",
            botName: "Speed Demon",
            botPersonality: .speedDemon,
            rank: 3,
            score: 2156.7,
            metric: LeaderboardMetric(
                primaryValue: 2156.7,
                unit: "$",
                displayFormat: "$%.2f",
                trend: .up
            ),
            totalTrades: 89,
            winRate: 0.92,
            profitLoss: 2156.7
        )
    ]
}

extension MicroFlipGame {
    static let sampleGames: [MicroFlipGame] = [
        MicroFlipGame(
            playerId: "player_1",
            gameType: .quickFlip,
            entryAmount: 50.0,
            targetAmount: 100.0,
            duration: 300, // 5 minutes
            status: .active,
            currentBalance: 73.50,
            difficulty: .pro
        ),
        MicroFlipGame(
            playerId: "player_1",
            gameType: .speedRun,
            entryAmount: 25.0,
            targetAmount: 50.0,
            duration: 180, // 3 minutes
            status: .completed,
            result: .win(28.75),
            currentBalance: 53.75,
            difficulty: .expert
        )
    ]
}

#Preview {
    VStack(spacing: 20) {
        Text("🎮 GAME FEATURES")
            .font(.title.bold())
        
        // Leaderboard Preview
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("🏆")
                    .font(.title2)
                Text("Elite Champions")
                    .font(.headline)
                Spacer()
                Text("847 players")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            ForEach(Array(LeaderboardEntry.sampleEntries.prefix(3).enumerated()), id: \.element.id) { index, entry in
                HStack {
                    Text("#\(entry.rank)")
                        .font(.system(.body, design: .monospaced).bold())
                        .frame(width: 30)
                    
                    Image(systemName: entry.rankChange.systemImage)
                        .foregroundColor(entry.rankChange.color)
                        .frame(width: 20)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(entry.botName)
                            .font(.subheadline.bold())
                        Text("\(entry.formattedWinRate) • \(entry.totalTrades) trades")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Text(entry.formattedProfitLoss)
                        .font(.subheadline.bold())
                        .foregroundColor(entry.profitLoss > 0 ? .green : .red)
                }
                .padding(.vertical, 4)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(15)
        
        // MicroFlip Game Preview
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("⚡")
                    .font(.title2)
                Text("Quick Flip")
                    .font(.headline)
                Spacer()
                Text("🟢 Pro")
                    .font(.caption.bold())
                    .foregroundColor(.blue)
            }
            
            HStack {
                VStack(alignment: .leading) {
                    Text("$50.00 → $100.00")
                        .font(.subheadline.bold())
                    Text("Current: $73.50")
                        .font(.caption)
                        .foregroundColor(.green)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("47%")
                        .font(.title3.bold())
                        .foregroundColor(.green)
                    Text("to target")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            ProgressView(value: 0.47)
                .tint(.green)
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(15)
    }
    .padding()
}