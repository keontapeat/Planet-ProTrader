import SwiftUI
import Foundation

// MARK: - Consolidated Types File
// This file contains all core types to prevent ambiguity and duplications

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

struct NewsArticleModel: Identifiable, Hashable, Codable {
    let id = UUID()
    let title: String
    let summary: String
    let content: String
    let impact: NewsImpactLevel
    let publishedAt: Date
    let source: String
    let category: String
    let tags: [String]
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: NewsArticleModel, rhs: NewsArticleModel) -> Bool {
        lhs.id == rhs.id
    }
    
    static let sampleNews: [NewsArticleModel] = [
        NewsArticleModel(
            title: "Fed Signals Potential Rate Cut",
            summary: "Federal Reserve hints at possible interest rate reduction",
            content: "In a surprise move, the Federal Reserve has signaled potential for rate cuts in the coming months...",
            impact: .high,
            publishedAt: Date().addingTimeInterval(-3600),
            source: "Reuters",
            category: "Central Banking",
            tags: ["Fed", "Interest Rates", "Gold"]
        )
    ]
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
    let riskTolerance: Double
    let aggressiveness: Double
    let analyticalSkill: Double
    
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
        case .mythic: return Color(red: 1.0, green: 0.84, blue: 0.0)
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
        case .gold: return Color(red: 1.0, green: 0.84, blue: 0.0)
        case .platinum: return Color.cyan
        case .diamond: return Color.blue.opacity(0.8)
        case .master: return Color.purple
        }
    }
}

struct BotPerformanceMetrics: Identifiable, Codable {
    let id = UUID()
    let name: String
    let profitLoss: Double
    let returnPercentage: Double
    let winRate: Double
    let totalTrades: Int
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
            name: "Alpha Trader",
            profitLoss: 12450.30,
            returnPercentage: 24.5,
            winRate: 85.6,
            totalTrades: 247,
            maxDrawdown: 8.2,
            sharpeRatio: 2.1,
            averageWin: 125.60,
            averageLoss: 89.30,
            profitFactor: 2.35,
            lastUpdated: Date()
        )
    ]
}

// MARK: - Economic Calendar Types
struct EconomicEventModel: Identifiable, Codable {
    let id = UUID()
    let title: String
    let country: String
    let currency: String
    let time: String
    let date: Date
    let impact: EconomicImpact
    let forecast: Double?
    let actual: Double?
    let previous: Double?
    let description: String
    let volatilityRange: Double
    
    var hasForecast: Bool { forecast != nil }
    var hasActual: Bool { actual != nil }
}

enum EconomicImpact: String, CaseIterable, Codable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    
    var color: Color {
        switch self {
        case .low: return .green
        case .medium: return .orange
        case .high: return .red
        }
    }
    
    var level: Int {
        switch self {
        case .low: return 1
        case .medium: return 2
        case .high: return 3
        }
    }
}

enum CalendarTimeframe: String, CaseIterable, Codable {
    case today = "Today"
    case tomorrow = "Tomorrow"
    case week = "This Week"
    case month = "This Month"
}

// MARK: - Debug Types
struct ErrorLogModel: Identifiable, Codable {
    let id = UUID()
    let type: ErrorType
    let timestamp: Date
    let fileName: String
    let functionName: String
    let lineNumber: Int
    let errorDomain: String
    let errorCode: Int
    let errorMessage: String
    let context: String
    let stackTrace: String?
    let deviceInfo: String
    var occurrenceCount: Int
    var isFixed: Bool
    var fixAppliedAt: Date?
    var fixMethod: String?
    
    enum ErrorType: String, CaseIterable, Codable {
        case runtime = "Runtime"
        case logic = "Logic"
        case network = "Network"
        case ui = "UI"
        case data = "Data"
        case memory = "Memory"
        case memoryLeak = "Memory Leak"
        case performance = "Performance"
        
        var color: Color {
            switch self {
            case .runtime: return .red
            case .logic: return .purple
            case .network: return .blue
            case .ui: return .orange
            case .data: return .yellow
            case .memory, .memoryLeak: return .pink
            case .performance: return .green
            }
        }
    }
    
    static let sampleErrors: [ErrorLogModel] = [
        ErrorLogModel(
            type: .runtime,
            timestamp: Date(),
            fileName: "ContentView.swift",
            functionName: "loadData",
            lineNumber: 42,
            errorDomain: "NSCocoaErrorDomain",
            errorCode: 260,
            errorMessage: "The file couldn't be opened because there is no such file.",
            context: "Loading user preferences",
            stackTrace: nil,
            deviceInfo: "iPhone 15 Pro - iOS 17.2",
            occurrenceCount: 1,
            isFixed: false,
            fixAppliedAt: nil,
            fixMethod: nil
        )
    ]
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
        case .eliteHealthCheck: return Color(red: 1.0, green: 0.84, blue: 0.0)
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

// MARK: - Wallet Types
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
        )
    ]
}

// MARK: - Market Sentiment
struct MarketSentimentModel: Codable {
    let overall: SentimentLevel
    let retail: SentimentLevel
    let institutional: SentimentLevel
    let timestamp: Date
    let confidence: Double
    
    enum SentimentLevel: String, Codable, CaseIterable {
        case extremelyBearish = "Extremely Bearish"
        case bearish = "Bearish"
        case neutral = "Neutral" 
        case bullish = "Bullish"
        case extremelyBullish = "Extremely Bullish"
        
        var emoji: String {
            switch self {
            case .extremelyBearish: return "📉💥"
            case .bearish: return "📉"
            case .neutral: return "➖"
            case .bullish: return "📈"
            case .extremelyBullish: return "📈🚀"
            }
        }
        
        var color: Color {
            switch self {
            case .extremelyBearish: return .red
            case .bearish: return .orange
            case .neutral: return .gray
            case .bullish: return .green
            case .extremelyBullish: return Color.green.opacity(0.8)
            }
        }
    }
}

// MARK: - Achievement Types
struct GameAchievementModel: Identifiable, Codable {
    let id = UUID()
    let title: String
    let description: String
    let icon: String
    let type: AchievementType
    let requirement: String
    let reward: String
    let isUnlocked: Bool
    let unlockedAt: Date?
    let progress: Double
    
    enum AchievementType: String, CaseIterable, Codable {
        case trading = "Trading"
        case learning = "Learning"
        case social = "Social"
        case milestone = "Milestone"
        
        var color: Color {
            switch self {
            case .trading: return .green
            case .learning: return .blue
            case .social: return .purple
            case .milestone: return Color(red: 1.0, green: 0.84, blue: 0.0)
            }
        }
    }
    
    static let sampleAchievements: [GameAchievementModel] = [
        GameAchievementModel(
            title: "First Profit",
            description: "Made your first profitable trade",
            icon: "dollarsign.circle.fill",
            type: .trading,
            requirement: "Complete first profitable trade",
            reward: "100 XP",
            isUnlocked: true,
            unlockedAt: Date().addingTimeInterval(-86400),
            progress: 1.0
        ),
        GameAchievementModel(
            title: "Gold Master",
            description: "Completed 100 gold trades",
            icon: "crown.fill",
            type: .milestone,
            requirement: "Complete 100 gold trades",
            reward: "1000 XP + Legendary Bot",
            isUnlocked: false,
            unlockedAt: nil,
            progress: 0.47
        )
    ]
}

// MARK: - Payment Types
class PaymentManagerService: ObservableObject {
    @Published var isProcessing = false
    @Published var lastError: String?
    @Published var transactionHistory: [PaymentTransaction] = []
    
    struct PaymentTransaction: Identifiable, Codable {
        let id = UUID()
        let amount: Double
        let currency: String
        let status: TransactionStatus
        let timestamp: Date
        
        enum TransactionStatus: String, Codable {
            case pending = "Pending"
            case completed = "Completed"
            case failed = "Failed"
            case cancelled = "Cancelled"
        }
    }
    
    func processPayment(amount: Double) async -> Bool {
        isProcessing = true
        defer { isProcessing = false }
        
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        
        let success = Bool.random()
        if success {
            let transaction = PaymentTransaction(
                amount: amount,
                currency: "USD",
                status: .completed,
                timestamp: Date()
            )
            transactionHistory.append(transaction)
        } else {
            lastError = "Payment failed. Please try again."
        }
        
        return success
    }
}

// MARK: - Code Analysis Types
struct CodeAnalysisResultModel: Identifiable, Codable {
    let id = UUID()
    let analysisType: AnalysisType
    let results: [AnalysisItem]
    let timestamp: Date
    let overallScore: Double
    
    enum AnalysisType: String, CaseIterable, Codable {
        case performance = "Performance"
        case security = "Security"
        case codeQuality = "Code Quality"
        case dependencies = "Dependencies"
        
        var color: Color {
            switch self {
            case .performance: return .green
            case .security: return .red
            case .codeQuality: return .blue
            case .dependencies: return .orange
            }
        }
    }
    
    struct AnalysisItem: Identifiable, Codable {
        let id = UUID()
        let category: String
        let message: String
        let severity: Severity
        let file: String?
        let line: Int?
        
        enum Severity: String, CaseIterable, Codable {
            case info = "Info"
            case warning = "Warning"
            case error = "Error"
            case critical = "Critical"
            
            var color: Color {
                switch self {
                case .info: return .blue
                case .warning: return .yellow
                case .error: return .orange
                case .critical: return .red
                }
            }
        }
    }
}

// MARK: - Fix Suggestion Types
struct FixSuggestionModel: Identifiable, Codable {
    let id = UUID()
    let errorId: UUID
    let type: FixType
    let title: String
    let description: String
    let codeExample: String?
    let confidence: Double
    let isAutoApplicable: Bool
    let timestamp: Date
    
    enum FixType: String, CaseIterable, Codable {
        case codeModification = "Code Modification"
        case configuration = "Configuration"
        case dependency = "Dependency"
        case architecture = "Architecture"
        case performance = "Performance"
        
        var color: Color {
            switch self {
            case .codeModification: return .blue
            case .configuration: return .orange
            case .dependency: return .purple
            case .architecture: return .green
            case .performance: return .red
            }
        }
    }
    
    static let sampleSuggestions: [FixSuggestionModel] = [
        FixSuggestionModel(
            errorId: UUID(),
            type: .codeModification,
            title: "Add file existence check",
            description: "Check if file exists before attempting to open",
            codeExample: "if FileManager.default.fileExists(atPath: path) { ... }",
            confidence: 0.95,
            isAutoApplicable: true,
            timestamp: Date()
        )
    ]
}

struct LearnedPatternModel: Identifiable, Codable {
    let id = UUID()
    let patternType: String
    let signature: String
    let occurrences: Int
    let lastSeen: Date
    let confidence: Double
    let suggestedFix: String
    let preventionStrategy: String
}

struct AutoDebugPerformanceMetricsModel: Codable {
    let cpuUsage: Double
    let memoryUsage: Double
    let networkLatency: Double
    let diskUsage: Double
    let batteryLevel: Double
    let thermalState: String
    let timestamp: Date
}

// MARK: - Opus Fix Model
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
    
    static let sample = OpusFixModel(
        title: "Optimize Memory Usage",
        description: "Reduce memory footprint by 15%",
        severity: .medium,
        status: .completed,
        timestamp: Date(),
        estimatedTime: 1800,
        actualTime: 1650
    )
}

// MARK: - Game Types
struct MicroFlipGame: Identifiable, Codable {
    let id = UUID()
    let name: String
    let description: String
    let difficulty: GameDifficulty
    let targetProfit: Double
    var currentBalance: Double
    let startingBalance: Double
    let maxLoss: Double
    var elapsedTime: TimeInterval
    let maxTime: TimeInterval
    var trades: [FlipTrade]
    var isCompleted: Bool
    var isWon: Bool
    
    enum GameDifficulty: String, CaseIterable, Codable {
        case easy = "Easy"
        case medium = "Medium"
        case hard = "Hard"
        case expert = "Expert"
        
        var color: Color {
            switch self {
            case .easy: return .green
            case .medium: return .orange
            case .hard: return .red
            case .expert: return .purple
            }
        }
    }
    
    struct FlipTrade: Identifiable, Codable {
        let id = UUID()
        let direction: TradeDirection
        let amount: Double
        let entryPrice: Double
        let exitPrice: Double
        let profit: Double
        let timestamp: Date
        
        enum TradeDirection: String, Codable {
            case up = "Up"
            case down = "Down"
            
            var emoji: String {
                switch self {
                case .up: return "📈"
                case .down: return "📉"
                }
            }
        }
    }
    
    static let sampleGames: [MicroFlipGame] = [
        MicroFlipGame(
            name: "Quick Flip Challenge",
            description: "Turn $100 into $150 in 5 minutes",
            difficulty: .easy,
            targetProfit: 150.0,
            currentBalance: 125.0,
            startingBalance: 100.0,
            maxLoss: 25.0,
            elapsedTime: 180.0,
            maxTime: 300.0,
            trades: [],
            isCompleted: false,
            isWon: false
        )
    ]
}

// MARK: - Bot Voice Note Types
struct BotVoiceNote: Identifiable, Codable {
    let id = UUID()
    let botId: String
    let botName: String
    let content: String
    let category: VoiceNoteCategory
    let timestamp: Date
    let duration: TimeInterval
    let isPlaying: Bool
    
    enum VoiceNoteCategory: String, CaseIterable, Codable {
        case celebration = "Celebration"
        case warning = "Warning"
        case performance = "Performance"
        case analysis = "Analysis"
        case coaching = "Coaching"
        
        var emoji: String {
            switch self {
            case .celebration: return "🎉"
            case .warning: return "⚠️"
            case .performance: return "📊"
            case .analysis: return "🔍"
            case .coaching: return "🎓"
            }
        }
        
        var color: Color {
            switch self {
            case .celebration: return .green
            case .warning: return .orange
            case .performance: return .blue
            case .analysis: return .purple
            case .coaching: return .mint
            }
        }
    }
    
    init(botId: String, botName: String, content: String, category: VoiceNoteCategory, duration: TimeInterval = 5.0, isPlaying: Bool = false) {
        self.botId = botId
        self.botName = botName
        self.content = content
        self.category = category
        self.timestamp = Date()
        self.duration = duration
        self.isPlaying = isPlaying
    }
    
    static let sampleNotes: [BotVoiceNote] = [
        BotVoiceNote(
            botId: "alpha-1",
            botName: "Alpha Trader",
            content: "🚀 Gold just broke resistance! This is our moment!",
            category: .celebration
        ),
        BotVoiceNote(
            botId: "coach-1",
            botName: "Game Coach",
            content: "Remember to manage your risk on this trade. Don't get greedy!",
            category: .coaching
        )
    ]
}

// MARK: - Reward System Types
enum RewardType: String, CaseIterable, Codable {
    case xp = "XP"
    case currency = "Currency"
    case badge = "Badge"
    case bot = "Bot"
    case feature = "Feature"
    
    var emoji: String {
        switch self {
        case .xp: return "⭐"
        case .currency: return "💰"
        case .badge: return "🏆"
        case .bot: return "🤖"
        case .feature: return "🔓"
        }
    }
}

// MARK: - Enhanced Family Mode Types
struct FamilyMemberProfile: Identifiable, Codable {
    let id = UUID()
    let name: String
    let age: Int
    let role: FamilyRole
    let experienceLevel: ExperienceLevel
    let goals: [TradingGoal]
    let preferences: TradingPreferences
    let progress: LearningProgress
    
    enum FamilyRole: String, CaseIterable, Codable {
        case parent = "Parent"
        case teenager = "Teenager"
        case child = "Child"
        case grandparent = "Grandparent"
        
        var emoji: String {
            switch self {
            case .parent: return "👨‍👩‍👧‍👦"
            case .teenager: return "👦"
            case .child: return "🧒"
            case .grandparent: return "👴"
            }
        }
    }
    
    enum ExperienceLevel: String, CaseIterable, Codable {
        case beginner = "Beginner"
        case intermediate = "Intermediate"
        case advanced = "Advanced"
        
        var color: Color {
            switch self {
            case .beginner: return .green
            case .intermediate: return .orange
            case .advanced: return .red
            }
        }
    }
    
    struct TradingGoal: Identifiable, Codable {
        let id = UUID()
        let title: String
        let description: String
        let targetAmount: Double
        let deadline: Date
        let progress: Double
    }
    
    struct TradingPreferences: Codable {
        let riskTolerance: RiskTolerance
        let preferredTimeframe: String
        let maxDailyLoss: Double
        let notificationsEnabled: Bool
        
        enum RiskTolerance: String, CaseIterable, Codable {
            case conservative = "Conservative"
            case moderate = "Moderate"
            case aggressive = "Aggressive"
        }
    }
    
    struct LearningProgress: Codable {
        let lessonsCompleted: Int
        let totalLessons: Int
        let skillLevel: Double
        let badges: [String]
        let currentStreak: Int
    }
    
    static let sampleProfiles: [FamilyMemberProfile] = [
        FamilyMemberProfile(
            name: "Dad",
            age: 45,
            role: .parent,
            experienceLevel: .advanced,
            goals: [
                TradingGoal(
                    title: "College Fund",
                    description: "Save for children's education",
                    targetAmount: 50000,
                    deadline: Date().addingTimeInterval(86400 * 365 * 5),
                    progress: 0.35
                )
            ],
            preferences: TradingPreferences(
                riskTolerance: .moderate,
                preferredTimeframe: "Daily",
                maxDailyLoss: 500,
                notificationsEnabled: true
            ),
            progress: LearningProgress(
                lessonsCompleted: 45,
                totalLessons: 60,
                skillLevel: 0.78,
                badges: ["Gold Trader", "Risk Manager"],
                currentStreak: 12
            )
        )
    ]
}

// MARK: - Trading Pattern Types
struct TradingPattern: Identifiable, Codable {
    let id = UUID()
    let name: String
    let description: String
    let confidence: Double
    let type: PatternType
    let entryPrice: Double
    let targetPrice: Double
    let stopLoss: Double
    let timeframe: String
    let timestamp: Date
    
    enum PatternType: String, CaseIterable, Codable {
        case breakout = "Breakout"
        case reversal = "Reversal"  
        case continuation = "Continuation"
        case triangle = "Triangle"
        case flag = "Flag"
        case wedge = "Wedge"
        case headAndShoulders = "Head and Shoulders"
        case doubleTop = "Double Top"
        case doubleBottom = "Double Bottom"
        
        var emoji: String {
            switch self {
            case .breakout: return "💥"
            case .reversal: return "🔄"
            case .continuation: return "➡️"
            case .triangle: return "📐"
            case .flag: return "🏁"
            case .wedge: return "📊"
            case .headAndShoulders: return "👤"
            case .doubleTop: return "⛰️"
            case .doubleBottom: return "🏔️"
            }
        }
    }
    
    static let samplePatterns: [TradingPattern] = [
        TradingPattern(
            name: "Gold Ascending Triangle",
            description: "Strong upward pressure with horizontal resistance",
            confidence: 0.85,
            type: .triangle,
            entryPrice: 2045.50,
            targetPrice: 2065.00,
            stopLoss: 2038.00,
            timeframe: "4H",
            timestamp: Date()
        )
    ]
}

// MARK: - COT (Commitment of Traders) Types
struct COTAnalysis: Identifiable, Codable {
    let id = UUID()
    let commercialSentiment: MarketSentiment
    let speculativePositioning: PositionLevel
    let marketBias: MarketBias
    let reportDate: Date
    let confidence: Double
    
    enum MarketSentiment: String, CaseIterable, Codable {
        case bullish = "Bullish"
        case bearish = "Bearish"
        case neutral = "Neutral"
        
        var emoji: String {
            switch self {
            case .bullish: return "📈"
            case .bearish: return "📉"
            case .neutral: return "➖"
            }
        }
    }
    
    enum PositionLevel: String, CaseIterable, Codable {
        case low = "Low"
        case medium = "Medium"
        case high = "High"
        case extreme = "Extreme"
    }
    
    enum MarketBias: String, CaseIterable, Codable {
        case bullish = "Bullish"
        case bearish = "Bearish"
        case neutral = "Neutral"
    }
}

struct TradingSignal: Identifiable, Codable {
    let id = UUID()
    let type: SignalType
    let strength: SignalStrength
    let entryPrice: Double
    let stopLoss: Double
    let takeProfit: Double
    let confidence: Double
    let timestamp: Date
    
    enum SignalType: String, CaseIterable, Codable {
        case buy = "Buy"
        case sell = "Sell"
        case hold = "Hold"
        
        var emoji: String {
            switch self {
            case .buy: return "📈"
            case .sell: return "📉"
            case .hold: return "⏸️"
            }
        }
    }
    
    enum SignalStrength: String, CaseIterable, Codable {
        case weak = "Weak"
        case moderate = "Moderate"
        case strong = "Strong"
        case veryStrong = "Very Strong"
        
        var color: Color {
            switch self {
            case .weak: return .gray
            case .moderate: return .yellow
            case .strong: return .orange
            case .veryStrong: return .red
            }
        }
    }
}

struct PositionChange: Identifiable, Codable {
    let id = UUID()
    let category: String
    let change: Double
    let significance: Significance
    let timestamp: Date
    
    enum Significance: String, CaseIterable, Codable {
        case low = "Low"
        case moderate = "Moderate" 
        case high = "High"
        case critical = "Critical"
    }
}

struct COTPrediction: Identifiable, Codable {
    let id = UUID()
    let priceDirection: PriceDirection
    let confidence: Double
    let targetRange: PriceRange
    let timeHorizon: TimeHorizon
    let timestamp: Date
    
    enum PriceDirection: String, CaseIterable, Codable {
        case strongBuy = "Strong Buy"
        case buy = "Buy"
        case neutral = "Neutral"
        case sell = "Sell"
        case strongSell = "Strong Sell"
    }
    
    enum TimeHorizon: String, CaseIterable, Codable {
        case shortTerm = "Short Term"
        case mediumTerm = "Medium Term"
        case longTerm = "Long Term"
    }
}

struct PriceRange: Codable {
    let low: Double
    let high: Double
    let current: Double
}

struct PriceLevel: Identifiable, Codable {
    let id = UUID()
    let type: LevelType
    let price: Double
    let importance: Importance
    let timestamp: Date
    
    enum LevelType: String, CaseIterable, Codable {
        case support = "Support"
        case resistance = "Resistance"
        case pivot = "Pivot"
    }
    
    enum Importance: String, CaseIterable, Codable {
        case low = "Low"
        case medium = "Medium"
        case high = "High"
        case critical = "Critical"
        
        var color: Color {
            switch self {
            case .low: return .green
            case .medium: return .yellow
            case .high: return .orange
            case .critical: return .red
            }
        }
    }
}

struct SeasonalityAnalysis: Identifiable, Codable {
    let id = UUID()
    let month: String
    let historicalPerformance: Double
    let probabilityBias: MarketBias
    let averageRange: Double
    let confidence: Double
    
    enum MarketBias: String, CaseIterable, Codable {
        case bullish = "Bullish"
        case bearish = "Bearish"  
        case neutral = "Neutral"
    }
    
    static let sampleSeasonality = SeasonalityAnalysis(
        month: "January",
        historicalPerformance: 0.75,
        probabilityBias: .bullish,
        averageRange: 45.0,
        confidence: 0.82
    )
}

// MARK: - Enhanced Learning Session Types
struct EnhancedLearningSession: Identifiable, Codable {
    let id = UUID()
    let timestamp: Date
    let dataPoints: Int
    let xpGained: Double
    let confidenceGained: Double
    let patterns: [String]
    let aiEngineUsed: String
    let marketConditions: String
    let tradingOpportunities: Int
    let riskAssessment: String
    let duration: TimeInterval
    
    init(
        timestamp: Date = Date(),
        dataPoints: Int,
        xpGained: Double,
        confidenceGained: Double,
        patterns: [String],
        aiEngineUsed: String,
        marketConditions: String,
        tradingOpportunities: Int,
        riskAssessment: String,
        duration: TimeInterval = 0
    ) {
        self.timestamp = timestamp
        self.dataPoints = dataPoints
        self.xpGained = xpGained
        self.confidenceGained = confidenceGained
        self.patterns = patterns
        self.aiEngineUsed = aiEngineUsed
        self.marketConditions = marketConditions
        self.tradingOpportunities = tradingOpportunities
        self.riskAssessment = riskAssessment
        self.duration = duration
    }
}