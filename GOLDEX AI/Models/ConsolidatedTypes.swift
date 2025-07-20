import SwiftUI
import Foundation

// MARK: - Consolidated Types to Prevent Ambiguity

// MARK: - News Types
enum NewsImpactLevel: String, CaseIterable, Codable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    case critical = "Critical"
    
    var emoji: String {
        switch self {
        case .low: return "🟢"
        case .medium: return "🟡"
        case .high: return "🟠"
        case .critical: return "🔴"
        }
    }
    
    var color: Color {
        switch self {
        case .low: return .green
        case .medium: return .yellow
        case .high: return .orange
        case .critical: return .red
        }
    }
}

enum NewsTimeFilter: String, CaseIterable, Codable {
    case all = "All"
    case today = "Today"
    case thisWeek = "This Week"
    case thisMonth = "This Month"
    
    var systemImage: String {
        switch self {
        case .all: return "calendar"
        case .today: return "calendar.badge.clock"
        case .thisWeek: return "calendar.badge.plus"
        case .thisMonth: return "calendar.circle"
        }
    }
}

// MARK: - Bot Types  
enum BotPersonalityType: String, CaseIterable, Codable {
    case aggressive = "Aggressive"
    case conservative = "Conservative"
    case balanced = "Balanced"
    case analytical = "Analytical"
    case intuitive = "Intuitive"
    
    var emoji: String {
        switch self {
        case .aggressive: return "🔥"
        case .conservative: return "🛡️"
        case .balanced: return "⚖️"
        case .analytical: return "🧠"
        case .intuitive: return "💡"
        }
    }
}

struct BotPersonalityProfile: Identifiable, Codable {
    let id = UUID()
    let name: String
    let type: BotPersonalityType
    let description: String
    let strengths: [String]
    let weaknesses: [String]
    let preferredMarkets: [String]
    let riskTolerance: Double // 0.0 to 1.0
    let aggressiveness: Double // 0.0 to 1.0
    let analyticalSkill: Double // 0.0 to 1.0
    
    static let sample = BotPersonalityProfile(
        name: "Alpha Trader",
        type: .aggressive,
        description: "High-performance trading personality with focus on quick profits",
        strengths: ["Quick Decision Making", "Risk Taking", "Opportunity Recognition"],
        weaknesses: ["Impatience", "Overconfidence"],
        preferredMarkets: ["XAUUSD", "BTCUSD"],
        riskTolerance: 0.8,
        aggressiveness: 0.9,
        analyticalSkill: 0.7
    )
}

// MARK: - Chat Types
struct BotChatMessageModel: Identifiable, Codable {
    let id = UUID()
    let botId: String
    let botName: String
    let content: String
    let timestamp: Date
    let messageType: MessageType
    let sentiment: MessageSentiment
    let reactions: [ChatReaction]
    
    enum MessageType: String, Codable {
        case analysis = "Analysis"
        case trade = "Trade"
        case alert = "Alert"
        case casual = "Casual"
        case question = "Question"
        case response = "Response"
    }
    
    enum MessageSentiment: String, Codable {
        case positive = "Positive"
        case neutral = "Neutral"
        case negative = "Negative"
        case excited = "Excited"
        case cautious = "Cautious"
    }
    
    struct ChatReaction: Identifiable, Codable {
        let id = UUID()
        let emoji: String
        let userId: String
        let timestamp: Date
    }
    
    static let sampleMessages: [BotChatMessageModel] = [
        BotChatMessageModel(
            botId: "alpha-1",
            botName: "Alpha Trader",
            content: "🚀 Gold is breaking out! I'm seeing massive momentum above $2,045. This could be the big move we've been waiting for!",
            timestamp: Date().addingTimeInterval(-300),
            messageType: .alert,
            sentiment: .excited,
            reactions: []
        ),
        BotChatMessageModel(
            botId: "beta-2",
            botName: "Beta Analyst",
            content: "📊 Technical analysis shows strong support at $2,040. RSI is showing bullish divergence on the 4H chart.",
            timestamp: Date().addingTimeInterval(-600),
            messageType: .analysis,
            sentiment: .neutral,
            reactions: []
        )
    ]
}

// MARK: - Trading Types
enum TradeResultType: String, CaseIterable, Codable {
    case win = "Win"
    case loss = "Loss"
    case breakeven = "Break Even"
    case pending = "Pending"
    
    var emoji: String {
        switch self {
        case .win: return "✅"
        case .loss: return "❌"
        case .breakeven: return "➖"
        case .pending: return "⏳"
        }
    }
    
    var color: Color {
        switch self {
        case .win: return .green
        case .loss: return .red
        case .breakeven: return .gray
        case .pending: return .orange
        }
    }
}

struct TradingPatternModel: Identifiable, Codable {
    let id = UUID()
    let name: String
    let description: String
    let confidence: Double
    let timeframe: String
    let entryPrice: Double
    let targetPrice: Double
    let stopLoss: Double
    let riskReward: Double
    let patternType: PatternType
    
    enum PatternType: String, CaseIterable, Codable {
        case breakout = "Breakout"
        case reversal = "Reversal"
        case continuation = "Continuation"
        case triangle = "Triangle"
        case rectangle = "Rectangle"
        case flagPole = "Flag Pole"
        
        var emoji: String {
            switch self {
            case .breakout: return "📈"
            case .reversal: return "🔄"
            case .continuation: return "➡️"
            case .triangle: return "📐"
            case .rectangle: return "▭"
            case .flagPole: return "🏁"
            }
        }
    }
    
    static let samplePatterns: [TradingPatternModel] = [
        TradingPatternModel(
            id: UUID(),
            name: "Gold Ascending Triangle",
            description: "Strong upward pressure with horizontal resistance",
            confidence: 0.85,
            timeframe: "4H",
            entryPrice: 2045.50,
            targetPrice: 2065.00,
            stopLoss: 2038.00,
            riskReward: 2.6,
            patternType: .triangle
        )
    ]
}

struct TradingOpportunityModel: Identifiable, Codable {
    let id = UUID()
    let symbol: String
    let direction: TradeDirection
    let entryPrice: Double
    let targetPrice: Double
    let stopLoss: Double
    let confidence: Double
    let timeframe: String
    let reasoning: String
    let riskReward: Double
    let timestamp: Date
    
    enum TradeDirection: String, Codable {
        case buy = "Buy"
        case sell = "Sell"
        
        var emoji: String {
            switch self {
            case .buy: return "📈"
            case .sell: return "📉"
            }
        }
        
        var color: Color {
            switch self {
            case .buy: return .green
            case .sell: return .red
            }
        }
    }
    
    static let sampleOpportunities: [TradingOpportunityModel] = [
        TradingOpportunityModel(
            id: UUID(),
            symbol: "XAUUSD",
            direction: .buy,
            entryPrice: 2045.50,
            targetPrice: 2065.00,
            stopLoss: 2038.00,
            confidence: 0.87,
            timeframe: "4H",
            reasoning: "Breakout above key resistance with high volume",
            riskReward: 2.6,
            timestamp: Date()
        )
    ]
}

// MARK: - Performance Types
struct BotPerformanceMetrics: Identifiable, Codable {
    let id = UUID()
    let botId: String
    let botName: String
    let winRate: Double
    let totalTrades: Int
    let profitLoss: Double
    let maxDrawdown: Double
    let sharpeRatio: Double
    let averageWin: Double
    let averageLoss: Double
    let profitFactor: Double
    let lastUpdated: Date
    
    var winRateFormatted: String {
        return String(format: "%.1f%%", winRate)
    }
    
    var profitLossFormatted: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: NSNumber(value: profitLoss)) ?? "$0.00"
    }
    
    static let sampleMetrics: [BotPerformanceMetrics] = [
        BotPerformanceMetrics(
            id: UUID(),
            botId: "alpha-1",
            botName: "Alpha Trader",
            winRate: 85.6,
            totalTrades: 247,
            profitLoss: 12450.30,
            maxDrawdown: 8.2,
            sharpeRatio: 2.1,
            averageWin: 125.60,
            averageLoss: 89.30,
            profitFactor: 2.35,
            lastUpdated: Date()
        )
    ]
}

enum PerformanceMetricType: String, CaseIterable {
    case totalReturn = "Total Return"
    case winRate = "Win Rate"
    case sharpeRatio = "Sharpe Ratio"
    case maxDrawdown = "Max Drawdown"
    case profitFactor = "Profit Factor"
    
    var systemImage: String {
        switch self {
        case .totalReturn: return "chart.line.uptrend.xyaxis"
        case .winRate: return "target"
        case .sharpeRatio: return "speedometer"
        case .maxDrawdown: return "chart.line.downtrend.xyaxis"
        case .profitFactor: return "multiply.circle"
        }
    }
}

// MARK: - Account Types
enum AccountStatusType: String, CaseIterable, Codable {
    case active = "Active"
    case inactive = "Inactive"
    case suspended = "Suspended"
    case pending = "Pending"
    case demo = "Demo"
    
    var color: Color {
        switch self {
        case .active: return .green
        case .inactive: return .gray
        case .suspended: return .red
        case .pending: return .orange
        case .demo: return .blue
        }
    }
    
    var emoji: String {
        switch self {
        case .active: return "✅"
        case .inactive: return "⏸️"
        case .suspended: return "🚫"
        case .pending: return "⏳"
        case .demo: return "🧪"
        }
    }
}

// MARK: - Session Types
enum SessionTypeCategory: String, CaseIterable, Codable {
    case debugging = "Debugging"
    case analysis = "Analysis"
    case optimization = "Optimization"
    case training = "Training"
    case testing = "Testing"
    case eliteHealthCheck = "Elite Health Check"
    case emergencyFix = "Emergency Fix"
    
    var emoji: String {
        switch self {
        case .debugging: return "🐛"
        case .analysis: return "📊"
        case .optimization: return "⚡"
        case .training: return "🎯"
        case .testing: return "🧪"
        case .eliteHealthCheck: return "💎"
        case .emergencyFix: return "🚨"
        }
    }
    
    var color: Color {
        switch self {
        case .debugging: return .red
        case .analysis: return .blue
        case .optimization: return .green
        case .training: return .orange
        case .testing: return .purple
        case .eliteHealthCheck: return DesignSystem.primaryGold
        case .emergencyFix: return .red
        }
    }
}

enum FindingTypeCategory: String, CaseIterable, Codable {
    case bug = "Bug"
    case performance = "Performance"
    case security = "Security"
    case optimization = "Optimization"
    case enhancement = "Enhancement"
    case warning = "Warning"
    
    var emoji: String {
        switch self {
        case .bug: return "🐛"
        case .performance: return "⚡"
        case .security: return "🔒"
        case .optimization: return "🚀"
        case .enhancement: return "✨"
        case .warning: return "⚠️"
        }
    }
    
    var color: Color {
        switch self {
        case .bug: return .red
        case .performance: return .orange
        case .security: return .purple
        case .optimization: return .green
        case .enhancement: return .blue
        case .warning: return .yellow
        }
    }
}

// MARK: - Missing Types for Various Managers
struct OpusFixModel: Identifiable, Codable {
    let id = UUID()
    let title: String
    let description: String
    let severity: Severity
    let status: FixStatus
    let timestamp: Date
    let estimatedTime: TimeInterval
    let actualTime: TimeInterval?
    
    enum Severity: String, CaseIterable, Codable {
        case low = "Low"
        case medium = "Medium"
        case high = "High"
        case critical = "Critical"
        
        var color: Color {
            switch self {
            case .low: return .green
            case .medium: return .orange
            case .high: return .red
            case .critical: return .purple
            }
        }
    }
    
    enum FixStatus: String, CaseIterable, Codable {
        case pending = "Pending"
        case inProgress = "In Progress"
        case completed = "Completed"
        case failed = "Failed"
        
        var color: Color {
            switch self {
            case .pending: return .gray
            case .inProgress: return .blue
            case .completed: return .green
            case .failed: return .red
            }
        }
    }
}

enum BotRarityLevel: String, CaseIterable, Codable {
    case common = "Common"
    case uncommon = "Uncommon" 
    case rare = "Rare"
    case epic = "Epic"
    case legendary = "Legendary"
    case mythic = "Mythic"
    
    var color: Color {
        switch self {
        case .common: return .gray
        case .uncommon: return .green
        case .rare: return .blue
        case .epic: return .purple
        case .legendary: return .orange
        case .mythic: return DesignSystem.primaryGold
        }
    }
    
    var emoji: String {
        switch self {
        case .common: return "⚪"
        case .uncommon: return "🟢"
        case .rare: return "🔵"
        case .epic: return "🟣"
        case .legendary: return "🟠"
        case .mythic: return "🟡"
        }
    }
}

enum BotTierLevel: String, CaseIterable, Codable {
    case bronze = "Bronze"
    case silver = "Silver"
    case gold = "Gold"
    case platinum = "Platinum"
    case diamond = "Diamond"
    case master = "Master"
    
    var color: Color {
        switch self {
        case .bronze: return Color.orange.opacity(0.7)
        case .silver: return Color.gray.opacity(0.8)
        case .gold: return DesignSystem.primaryGold
        case .platinum: return Color.cyan
        case .diamond: return Color.blue.opacity(0.8)
        case .master: return Color.purple
        }
    }
}

// MARK: - Wallet Transaction Model
struct WalletTransaction: Identifiable, Codable {
    let id = UUID()
    let type: TransactionType
    let amount: Double
    let description: String
    let timestamp: Date
    let status: TransactionStatus
    
    enum TransactionType: String, CaseIterable, Codable {
        case deposit = "Deposit"
        case withdrawal = "Withdrawal"
        case trade = "Trade"
        case fee = "Fee"
        case bonus = "Bonus"
        case refund = "Refund"
        
        var emoji: String {
            switch self {
            case .deposit: return "💰"
            case .withdrawal: return "💸"
            case .trade: return "📊"
            case .fee: return "💳"
            case .bonus: return "🎁"
            case .refund: return "↩️"
            }
        }
        
        var color: Color {
            switch self {
            case .deposit, .bonus, .refund: return .green
            case .withdrawal, .fee: return .red
            case .trade: return .blue
            }
        }
    }
    
    enum TransactionStatus: String, CaseIterable, Codable {
        case pending = "Pending"
        case completed = "Completed"
        case failed = "Failed"
        case cancelled = "Cancelled"
        
        var color: Color {
            switch self {
            case .pending: return .orange
            case .completed: return .green
            case .failed, .cancelled: return .red
            }
        }
    }
    
    static let sampleTransactions: [WalletTransaction] = [
        WalletTransaction(
            type: .trade,
            amount: 1247.50,
            description: "Gold Rush Alpha - Trade Profit",
            timestamp: Date().addingTimeInterval(-3600),
            status: .completed
        ),
        WalletTransaction(
            type: .deposit,
            amount: 5000.00,
            description: "Bank Transfer Deposit",
            timestamp: Date().addingTimeInterval(-86400),
            status: .completed
        )
    ]
}