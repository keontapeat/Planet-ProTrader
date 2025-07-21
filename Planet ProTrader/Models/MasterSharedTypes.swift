//
//  MasterSharedTypes.swift
//  Planet ProTrader
//
//  Single Source of Truth for All Types - Cleaned and Optimized
//  Created by AI Assistant
//

import SwiftUI
import Foundation
import Combine

// MARK: - Core Trading Enums

enum TradeDirection: String, Codable, CaseIterable {
    case buy = "BUY"
    case sell = "SELL"
    case long = "LONG" 
    case short = "SHORT"
    
    var displayName: String {
        switch self {
        case .buy, .long: return "Buy"
        case .sell, .short: return "Sell"
        }
    }
    
    var color: Color {
        switch self {
        case .buy, .long: return .green
        case .sell, .short: return .red
        }
    }
    
    var systemImage: String {
        switch self {
        case .buy, .long: return "arrow.up.circle.fill"
        case .sell, .short: return "arrow.down.circle.fill"
        }
    }
    
    var icon: String { return systemImage }
}

enum TradingMode: String, Codable, CaseIterable {
    case auto = "Auto"
    case manual = "Manual"
    case scalp = "Scalp"
    case swing = "Swing"
    case position = "Position"
    case backtest = "Backtest"
    case news = "News"
    case sentiment = "Sentiment"
    case patterns = "Patterns"
    case riskManagement = "Risk Management"
    case psychology = "Psychology"
    case institutional = "Institutional"
    case contrarian = "Contrarian"
    
    var displayName: String { rawValue }
    
    var icon: String {
        switch self {
        case .auto: return "gearshape.2"
        case .manual: return "hand.point.up.braille"
        case .scalp: return "bolt.fill"
        case .swing: return "waveform.path"
        case .position: return "chart.line.uptrend.xyaxis"
        case .backtest: return "clock.arrow.circlepath"
        case .news: return "newspaper"
        case .sentiment: return "heart"
        case .patterns: return "waveform.path.ecg"
        case .riskManagement: return "shield"
        case .psychology: return "brain"
        case .institutional: return "building.columns"
        case .contrarian: return "arrow.triangle.2.circlepath"
        }
    }
}

enum BrokerType: String, Codable, CaseIterable {
    case mt5 = "MT5"
    case mt4 = "MT4"
    case coinexx = "Coinexx"
    case forex = "Forex.com"
    case manual = "Manual"
    case tradeLocker = "TradeLocker"
    case xtb = "XTB"
    case hankotrade = "HankoTrade"
    
    var displayName: String { rawValue }
    
    var icon: String {
        switch self {
        case .mt5, .mt4: return "chart.bar"
        case .coinexx: return "bitcoinsign.circle"
        case .forex: return "dollarsign.circle"
        case .manual: return "hand.point.up"
        case .tradeLocker: return "lock"
        case .xtb: return "x.circle"
        case .hankotrade: return "h.circle"
        }
    }
    
    var color: Color {
        switch self {
        case .mt5, .mt4: return .blue
        case .coinexx: return .orange
        case .forex: return .green
        case .manual: return .gray
        case .tradeLocker: return .purple
        case .xtb: return .red
        case .hankotrade: return .cyan
        }
    }
}

enum TradeGrade: String, CaseIterable, Codable {
    case excellent = "Excellent"
    case elite = "Elite"
    case good = "Good"
    case average = "Average"
    case poor = "Poor"
    case all = "All"
    
    var color: Color {
        switch self {
        case .excellent, .elite: return .green
        case .good: return .blue
        case .average: return .orange
        case .poor: return .red
        case .all: return .gray
        }
    }
}

enum TradeStatus: String, Codable, CaseIterable {
    case pending = "Pending"
    case open = "Open"
    case closed = "Closed"
    case cancelled = "Cancelled"
    case win = "Win"
    case loss = "Loss"
    case takeProfit = "Take Profit"
    case stopLoss = "Stop Loss"
    
    var color: Color {
        switch self {
        case .pending: return .orange
        case .open: return .blue
        case .closed: return .gray
        case .cancelled: return .red
        case .win, .takeProfit: return .green
        case .loss, .stopLoss: return .red
        }
    }
}

enum BotStatus: String, CaseIterable, Codable {
    case active = "Active"
    case inactive = "Inactive"
    case learning = "Learning"
    case analyzing = "Analyzing"
    case trading = "Trading"
    case paused = "Paused"
    case error = "Error"
    case connecting = "Connecting"
    case connected = "Connected"
    case offline = "Offline"
    
    var color: Color {
        switch self {
        case .active, .trading, .connected: return .green
        case .inactive, .paused, .offline: return .gray
        case .learning, .analyzing: return .blue
        case .error: return .red
        case .connecting: return .orange
        }
    }
    
    var systemImage: String {
        switch self {
        case .active, .trading: return "play.circle.fill"
        case .inactive, .offline: return "stop.circle"
        case .learning: return "brain"
        case .analyzing: return "magnifyingglass"
        case .paused: return "pause.circle"
        case .error: return "exclamationmark.triangle"
        case .connecting: return "arrow.triangle.2.circlepath"
        case .connected: return "checkmark.circle.fill"
        }
    }
}

enum RiskLevel: String, Codable, CaseIterable {
    case veryLow = "Very Low"
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    case extreme = "Extreme"
    
    var color: Color {
        switch self {
        case .veryLow: return .green
        case .low: return .blue
        case .medium: return .orange
        case .high: return .red
        case .extreme: return .purple
        }
    }
}

enum TimeFrame: String, Codable, CaseIterable {
    case oneMinute = "1M"
    case fiveMinute = "5M"
    case fifteenMinute = "15M"
    case thirtyMinute = "30M"
    case oneHour = "1H"
    case fourHour = "4H"
    case daily = "1D"
    case weekly = "1W"
    case monthly = "1MN"
    
    var displayName: String { rawValue }
    
    var minutes: Int {
        switch self {
        case .oneMinute: return 1
        case .fiveMinute: return 5
        case .fifteenMinute: return 15
        case .thirtyMinute: return 30
        case .oneHour: return 60
        case .fourHour: return 240
        case .daily: return 1440
        case .weekly: return 10080
        case .monthly: return 43200
        }
    }
}

enum TrendDirection: String, Codable, CaseIterable {
    case bullish = "Bullish"
    case bearish = "Bearish"
    case neutral = "Neutral"
    case sideways = "Sideways"
    
    var color: Color {
        switch self {
        case .bullish: return .green
        case .bearish: return .red
        case .neutral, .sideways: return .gray
        }
    }
    
    var icon: String {
        switch self {
        case .bullish: return "arrow.up.right"
        case .bearish: return "arrow.down.right"
        case .neutral: return "arrow.right"
        case .sideways: return "arrow.left.and.right"
        }
    }
}

enum MarketSentiment: String, Codable, CaseIterable {
    case bullish = "Bullish"
    case bearish = "Bearish"
    case neutral = "Neutral"
    case fearful = "Fearful"
    case greedy = "Greedy"
    
    var color: Color {
        switch self {
        case .bullish, .greedy: return .green
        case .bearish, .fearful: return .red
        case .neutral: return .gray
        }
    }
}

enum InsightPriority: String, CaseIterable, Codable {
    case low = "low"
    case medium = "medium"
    case high = "high"
    case critical = "critical"
    
    var color: Color {
        switch self {
        case .low: return .gray
        case .medium: return .orange
        case .high: return .red
        case .critical: return .purple
        }
    }
}

// MARK: - Learning Capabilities

enum LearningCapability: String, CaseIterable, Codable {
    case patternRecognition = "Pattern Recognition"
    case riskManagement = "Risk Management"
    case technicalAnalysis = "Technical Analysis"
    case fundamentalAnalysis = "Fundamental Analysis"
    case sentimentAnalysis = "Sentiment Analysis"
    case marketTiming = "Market Timing"
    case priceAction = "Price Action"
    case volumeAnalysis = "Volume Analysis"
    case microstructure = "Microstructure"
    case supportResistance = "Support Resistance"
    case fundamentals = "Fundamentals"
    case trendAnalysis = "Trend Analysis"
    case orderFlow = "Order Flow"
    case marketStructure = "Market Structure"
    case liquidity = "Liquidity"
    case extremes = "Extremes"
    case meanReversion = "Mean Reversion"
    case sentiment = "Sentiment"
    case socialMedia = "Social Media"
    case positioning = "Positioning"
    case newsAnalysis = "News Analysis"
    case eventTrading = "Event Trading"
    case volatility = "Volatility"
    case chartPatterns = "Chart Patterns"
    case candlesticks = "Candlesticks"
    case riskAssessment = "Risk Assessment"
    case portfolioManagement = "Portfolio Management"
    case correlation = "Correlation"
    case behaviorAnalysis = "Behavior Analysis"
    case emotionalPatterns = "Emotional Patterns"
    case marketPsychology = "Market Psychology"
    
    var description: String {
        switch self {
        case .patternRecognition: return "Identifies recurring market patterns"
        case .riskManagement: return "Optimizes risk-reward ratios"
        case .technicalAnalysis: return "Analyzes price action and indicators"
        case .fundamentalAnalysis: return "Evaluates economic factors"
        case .sentimentAnalysis: return "Gauges market sentiment"
        case .marketTiming: return "Times market entry and exit"
        default: return rawValue
        }
    }
}

// MARK: - Core Data Structures

struct TradingBot: Identifiable, Codable {
    let id: UUID
    let name: String
    var status: BotStatus
    let strategy: String
    let performance: Double
    let totalTrades: Int
    let winRate: Double
    let profit: Double
    let lastUpdate: Date
    let icon: String
    let primaryColor: String
    let secondaryColor: String
    
    init(
        id: UUID = UUID(),
        name: String,
        status: BotStatus = .inactive,
        strategy: String,
        performance: Double = 0.0,
        totalTrades: Int = 0,
        winRate: Double = 0.0,
        profit: Double = 0.0,
        lastUpdate: Date = Date(),
        icon: String = "robot",
        primaryColor: String = "#007AFF",
        secondaryColor: String = "#5AC8FA"
    ) {
        self.id = id
        self.name = name
        self.status = status
        self.strategy = strategy
        self.performance = performance
        self.totalTrades = totalTrades
        self.winRate = winRate
        self.profit = profit
        self.lastUpdate = lastUpdate
        self.icon = icon
        self.primaryColor = primaryColor
        self.secondaryColor = secondaryColor
    }
}

struct BotPerformanceMetrics: Identifiable, Codable {
    let id: UUID
    let botId: String
    let totalTrades: Int
    let winningTrades: Int
    let losingTrades: Int
    let totalProfit: Double
    let winRate: Double
    let profitFactor: Double
    let maxDrawdown: Double
    let averageWin: Double
    let averageLoss: Double
    let sharpeRatio: Double
    let lastUpdated: Date
    
    init(
        id: UUID = UUID(),
        botId: String,
        totalTrades: Int = 0,
        winningTrades: Int = 0,
        losingTrades: Int = 0,
        totalProfit: Double = 0.0,
        winRate: Double = 0.0,
        profitFactor: Double = 1.0,
        maxDrawdown: Double = 0.0,
        averageWin: Double = 0.0,
        averageLoss: Double = 0.0,
        sharpeRatio: Double = 0.0,
        lastUpdated: Date = Date()
    ) {
        self.id = id
        self.botId = botId
        self.totalTrades = totalTrades
        self.winningTrades = winningTrades
        self.losingTrades = losingTrades
        self.totalProfit = totalProfit
        self.winRate = winRate
        self.profitFactor = profitFactor
        self.maxDrawdown = maxDrawdown
        self.averageWin = averageWin
        self.averageLoss = averageLoss
        self.sharpeRatio = sharpeRatio
        self.lastUpdated = lastUpdated
    }
    
    var formattedWinRate: String {
        return String(format: "%.1f%%", winRate * 100)
    }
    
    var formattedProfitFactor: String {
        return String(format: "%.2f", profitFactor)
    }
    
    var formattedTotalProfit: String {
        return String(format: "$%.2f", totalProfit)
    }
    
    var performanceGrade: TradeGrade {
        switch winRate {
        case 0.8...: return .elite
        case 0.7..<0.8: return .excellent
        case 0.6..<0.7: return .good
        case 0.5..<0.6: return .average
        default: return .poor
        }
    }
}

struct BotPersonalityProfile: Identifiable, Codable {
    let id: UUID
    let name: String
    let personality: String
    let traits: [String]
    let riskTolerance: RiskLevel
    let tradingStyle: String
    let experience: String
    let specialties: [String]
    let analysisTypes: [String]
    let timeframes: [String]
    
    init(
        id: UUID = UUID(),
        name: String,
        personality: String,
        traits: [String] = [],
        riskTolerance: RiskLevel = .medium,
        tradingStyle: String = "Balanced",
        experience: String = "Intermediate",
        specialties: [String] = [],
        analysisTypes: [String] = [],
        timeframes: [String] = []
    ) {
        self.id = id
        self.name = name
        self.personality = personality
        self.traits = traits
        self.riskTolerance = riskTolerance
        self.tradingStyle = tradingStyle
        self.experience = experience
        self.specialties = specialties
        self.analysisTypes = analysisTypes
        self.timeframes = timeframes
    }
}

struct EAStats: Identifiable, Codable {
    let id: UUID
    var totalSignals: Int
    var winningSignals: Int
    var losingSignals: Int
    var pendingSignals: Int
    var totalProfit: Double
    var totalLoss: Double
    var averageWin: Double
    var averageLoss: Double
    var winRate: Double
    var profitFactor: Double
    var lastUpdated: Date
    
    init(
        id: UUID = UUID(),
        totalSignals: Int = 0,
        winningSignals: Int = 0,
        losingSignals: Int = 0,
        pendingSignals: Int = 0,
        totalProfit: Double = 0.0,
        totalLoss: Double = 0.0,
        averageWin: Double = 0.0,
        averageLoss: Double = 0.0,
        winRate: Double = 0.0,
        profitFactor: Double = 1.0,
        lastUpdated: Date = Date()
    ) {
        self.id = id
        self.totalSignals = totalSignals
        self.winningSignals = winningSignals
        self.losingSignals = losingSignals
        self.pendingSignals = pendingSignals
        self.totalProfit = totalProfit
        self.totalLoss = totalLoss
        self.averageWin = averageWin
        self.averageLoss = averageLoss
        self.winRate = winRate
        self.profitFactor = profitFactor
        self.lastUpdated = lastUpdated
    }
    
    var totalTrades: Int { totalSignals }
    
    var formattedWinRate: String {
        return String(format: "%.1f%%", winRate * 100)
    }
    
    var formattedProfitFactor: String {
        return String(format: "%.2f", profitFactor)
    }
}

struct TradingAccountDetails: Identifiable, Codable {
    let id: UUID
    let accountNumber: String
    let broker: BrokerType
    let accountType: String
    let balance: Double
    let equity: Double
    let freeMargin: Double
    let leverage: Int
    let currency: String
    let isActive: Bool
    let lastUpdate: Date
    
    init(
        id: UUID = UUID(),
        accountNumber: String,
        broker: BrokerType,
        accountType: String,
        balance: Double,
        equity: Double,
        freeMargin: Double,
        leverage: Int,
        currency: String = "USD",
        isActive: Bool = true,
        lastUpdate: Date = Date()
    ) {
        self.id = id
        self.accountNumber = accountNumber
        self.broker = broker
        self.accountType = accountType
        self.balance = balance
        self.equity = equity
        self.freeMargin = freeMargin
        self.leverage = leverage
        self.currency = currency
        self.isActive = isActive
        self.lastUpdate = lastUpdate
    }
}

struct AutoTrade: Identifiable, Codable {
    let id: UUID
    let symbol: String
    let direction: TradeDirection
    let entryPrice: Double
    let exitPrice: Double?
    let lotSize: Double
    let profit: Double
    let status: TradeStatus
    let timestamp: Date
    let botId: String
    
    init(
        id: UUID = UUID(),
        symbol: String,
        direction: TradeDirection,
        entryPrice: Double,
        exitPrice: Double? = nil,
        lotSize: Double,
        profit: Double = 0.0,
        status: TradeStatus = .pending,
        timestamp: Date = Date(),
        botId: String
    ) {
        self.id = id
        self.symbol = symbol
        self.direction = direction
        self.entryPrice = entryPrice
        self.exitPrice = exitPrice
        self.lotSize = lotSize
        self.profit = profit
        self.status = status
        self.timestamp = timestamp
        self.botId = botId
    }
    
    static func sample() -> AutoTrade {
        AutoTrade(
            symbol: "XAUUSD",
            direction: .buy,
            entryPrice: 2000.0,
            exitPrice: 2010.0,
            lotSize: 0.1,
            profit: 100.0,
            status: .closed,
            botId: "sample-bot"
        )
    }
}

struct AutoTradingSignal: Identifiable, Codable {
    let id: UUID
    let symbol: String
    let direction: TradeDirection
    let confidence: Double
    let entryPrice: Double
    let stopLoss: Double
    let takeProfit: Double
    let timestamp: Date
    let source: String
    
    init(
        id: UUID = UUID(),
        symbol: String,
        direction: TradeDirection,
        confidence: Double,
        entryPrice: Double,
        stopLoss: Double,
        takeProfit: Double,
        timestamp: Date = Date(),
        source: String
    ) {
        self.id = id
        self.symbol = symbol
        self.direction = direction
        self.confidence = confidence
        self.entryPrice = entryPrice
        self.stopLoss = stopLoss
        self.takeProfit = takeProfit
        self.timestamp = timestamp
        self.source = source
    }
}

struct SharedTradeResult: Identifiable, Codable {
    let id: UUID
    let symbol: String
    let direction: TradeDirection
    let profit: Double
    let timestamp: Date
    let success: Bool
    
    init(
        id: UUID = UUID(),
        symbol: String,
        direction: TradeDirection,
        profit: Double,
        timestamp: Date = Date(),
        success: Bool
    ) {
        self.id = id
        self.symbol = symbol
        self.direction = direction
        self.profit = profit
        self.timestamp = timestamp
        self.success = success
    }
}

struct AIInsight: Identifiable, Codable {
    let id: UUID
    let title: String
    let description: String
    let confidence: Double
    let timestamp: Date
    let priority: InsightPriority
    
    init(
        id: UUID = UUID(),
        title: String,
        description: String,
        confidence: Double,
        timestamp: Date = Date(),
        priority: InsightPriority = .medium
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.confidence = confidence
        self.timestamp = timestamp
        self.priority = priority
    }
    
    static var sample: AIInsight {
        AIInsight(
            title: "Strong Bullish Signal Detected",
            description: "Technical indicators show strong upward momentum",
            confidence: 0.85,
            priority: .high
        )
    }
}

struct PlaybookTrade: Identifiable, Codable {
    let id: UUID
    let symbol: String
    let direction: TradeDirection
    let entryPrice: Double
    let exitPrice: Double
    let profit: Double
    let grade: TradeGrade
    let timestamp: Date
    let notes: String
    
    init(
        id: UUID = UUID(),
        symbol: String,
        direction: TradeDirection,
        entryPrice: Double,
        exitPrice: Double,
        profit: Double,
        grade: TradeGrade,
        timestamp: Date = Date(),
        notes: String = ""
    ) {
        self.id = id
        self.symbol = symbol
        self.direction = direction
        self.entryPrice = entryPrice
        self.exitPrice = exitPrice
        self.profit = profit
        self.grade = grade
        self.timestamp = timestamp
        self.notes = notes
    }
}

struct FlipGoal: Identifiable, Codable {
    let id: UUID
    let startAmount: Double
    let targetAmount: Double
    let currentAmount: Double
    let timeframe: String
    let status: String
    
    init(
        id: UUID = UUID(),
        startAmount: Double,
        targetAmount: Double,
        currentAmount: Double,
        timeframe: String,
        status: String = "Active"
    ) {
        self.id = id
        self.startAmount = startAmount
        self.targetAmount = targetAmount
        self.currentAmount = currentAmount
        self.timeframe = timeframe
        self.status = status
    }
}

struct FlipTradeLog: Identifiable, Codable {
    let id: UUID
    let symbol: String
    let direction: TradeDirection
    let entryPrice: Double
    let exitPrice: Double
    let profit: Double
    let timestamp: Date
    
    init(
        id: UUID = UUID(),
        symbol: String,
        direction: TradeDirection,
        entryPrice: Double,
        exitPrice: Double,
        profit: Double,
        timestamp: Date = Date()
    ) {
        self.id = id
        self.symbol = symbol
        self.direction = direction
        self.entryPrice = entryPrice
        self.exitPrice = exitPrice
        self.profit = profit
        self.timestamp = timestamp
    }
}

struct FlipCompletion: Identifiable, Codable {
    let id: UUID
    let goalId: String
    let finalAmount: Double
    let success: Bool
    let timestamp: Date
    
    init(id: UUID = UUID(), goalId: String, finalAmount: Double, success: Bool, timestamp: Date = Date()) {
        self.id = id
        self.goalId = goalId
        self.finalAmount = finalAmount
        self.success = success
        self.timestamp = timestamp
    }
}

struct FlipEvent: Identifiable, Codable {
    let id: UUID
    let eventType: String
    let description: String
    let timestamp: Date
    
    init(id: UUID = UUID(), eventType: String, description: String, timestamp: Date = Date()) {
        self.id = id
        self.eventType = eventType
        self.description = description
        self.timestamp = timestamp
    }
}

enum FlipStrategy: String, CaseIterable, Codable {
    case conservative = "Conservative"
    case balanced = "Balanced"
    case aggressive = "Aggressive"
    case experimental = "Experimental"
}

struct PerformanceMetrics: Identifiable, Codable {
    let id: UUID
    let totalProfit: Double
    let totalTrades: Int
    let winRate: Double
    let averageWin: Double
    let averageLoss: Double
    let profitFactor: Double
    let maxDrawdown: Double
    let timestamp: Date
    
    init(
        id: UUID = UUID(),
        totalProfit: Double = 0.0,
        totalTrades: Int = 0,
        winRate: Double = 0.0,
        averageWin: Double = 0.0,
        averageLoss: Double = 0.0,
        profitFactor: Double = 1.0,
        maxDrawdown: Double = 0.0,
        timestamp: Date = Date()
    ) {
        self.id = id
        self.totalProfit = totalProfit
        self.totalTrades = totalTrades
        self.winRate = winRate
        self.averageWin = averageWin
        self.averageLoss = averageLoss
        self.profitFactor = profitFactor
        self.maxDrawdown = maxDrawdown
        self.timestamp = timestamp
    }
    
    static var sample: PerformanceMetrics {
        PerformanceMetrics(
            totalProfit: 15000.0,
            totalTrades: 150,
            winRate: 0.67,
            averageWin: 180.0,
            averageLoss: -90.0,
            profitFactor: 1.8,
            maxDrawdown: -500.0
        )
    }
}

// MARK: - Micro Flip Game Types

struct MicroFlipGame: Identifiable, Codable {
    let id: UUID
    let playerId: String
    let gameType: MicroFlipGame.GameType
    let difficulty: MicroFlipGame.Difficulty
    let entryAmount: Double
    var currentBalance: Double
    let startingBalance: Double
    let targetAmount: Double
    let targetProfit: Double
    let duration: TimeInterval
    let maxTime: TimeInterval
    var elapsedTime: TimeInterval
    var status: MicroFlipGame.GameStatus
    var playerChoice: MicroFlipGame.PlayerChoice?
    var result: MicroFlipGame.GameResult?
    let timestamp: Date
    var isCompleted: Bool
    var isWon: Bool
    let maxLoss: Double
    let name: String
    
    // Computed properties
    var progressToTarget: Double {
        guard targetProfit > 0 else { return 0 }
        return min(1.0, max(0, currentBalance / targetProfit))
    }
    
    var timeRemaining: TimeInterval {
        return max(0, maxTime - elapsedTime)
    }
    
    enum GameType: String, CaseIterable, Codable {
        case quickFlip = "Quick Flip"
        case speedRun = "Speed Run"
        case precision = "Precision"
        case endurance = "Endurance"
        case riskMaster = "Risk Master"
        case botBattle = "Bot Battle"
        
        var displayName: String {
            return "\(emoji) \(rawValue)"
        }
        
        var emoji: String {
            switch self {
            case .quickFlip: return "⚡"
            case .speedRun: return "🏃"
            case .precision: return "🎯"
            case .endurance: return "💪"
            case .riskMaster: return "🔥"
            case .botBattle: return "🤖"
            }
        }
        
        var description: String {
            switch self {
            case .quickFlip: return "Fast-paced trading in short bursts"
            case .speedRun: return "Race against time to hit targets"
            case .precision: return "Accuracy-focused trading challenges"
            case .endurance: return "Long-term strategic gameplay"
            case .riskMaster: return "High-risk, high-reward scenarios"
            case .botBattle: return "Compete against AI trading bots"
            }
        }
        
        var baseMultiplier: Double {
            switch self {
            case .quickFlip: return 1.5
            case .speedRun: return 2.0
            case .precision: return 1.8
            case .endurance: return 1.2
            case .riskMaster: return 3.0
            case .botBattle: return 2.5
            }
        }
    }
    
    enum Difficulty: String, CaseIterable, Codable {
        case rookie = "Rookie"
        case pro = "Pro"
        case expert = "Expert"
        case legend = "Legend"
        
        var displayName: String { rawValue }
        
        var color: Color {
            switch self {
            case .rookie: return .green
            case .pro: return .blue
            case .expert: return .orange
            case .legend: return .purple
            }
        }
    }
    
    enum GameStatus: String, Codable {
        case waiting = "Waiting"
        case active = "Active"
        case completed = "Completed"
        case expired = "Expired"
        case failed = "Failed"
        
        var displayName: String { rawValue }
        
        var color: Color {
            switch self {
            case .waiting: return .orange
            case .active: return .blue
            case .completed: return .green
            case .expired: return .gray
            case .failed: return .red
            }
        }
    }
    
    enum PlayerChoice: String, CaseIterable, Codable {
        case up = "Up"
        case down = "Down"
        case hold = "Hold"
    }
    
    enum GameResult: String, Codable {
        case win = "Win"
        case loss = "Loss"
        case tie = "Tie"
        
        var displayText: String {
            switch self {
            case .win: return "+$"
            case .loss: return "-$"
            case .tie: return "$"
            }
        }
        
        var color: Color {
            switch self {
            case .win: return .green
            case .loss: return .red
            case .tie: return .gray
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
        difficulty: Difficulty = .rookie,
        playerChoice: PlayerChoice? = nil,
        result: GameResult? = nil,
        timestamp: Date = Date()
    ) {
        self.id = id
        self.playerId = playerId
        self.gameType = gameType
        self.difficulty = difficulty
        self.entryAmount = entryAmount
        self.currentBalance = entryAmount
        self.startingBalance = entryAmount
        self.targetAmount = targetAmount
        self.targetProfit = targetAmount
        self.duration = duration
        self.maxTime = duration
        self.elapsedTime = 0
        self.status = status
        self.playerChoice = playerChoice
        self.result = result
        self.timestamp = timestamp
        self.isCompleted = false
        self.isWon = false
        self.maxLoss = entryAmount * 0.1 // 10% max loss
        self.name = gameType.displayName
    }
    
    static var sampleGames: [MicroFlipGame] {
        return [
            MicroFlipGame(
                playerId: "sample_player",
                gameType: .quickFlip,
                entryAmount: 100.0,
                targetAmount: 150.0,
                duration: 300,
                status: .active,
                difficulty: .rookie
            ),
            MicroFlipGame(
                playerId: "sample_player",
                gameType: .precision,
                entryAmount: 250.0,
                targetAmount: 450.0,
                duration: 600,
                status: .completed,
                difficulty: .pro
            ),
            MicroFlipGame(
                playerId: "sample_player",
                gameType: .speedRun,
                entryAmount: 500.0,
                targetAmount: 1000.0,
                duration: 180,
                status: .failed,
                difficulty: .expert
            )
        ]
    }
}

// MARK: - Voice Note Types

struct BotVoiceNote: Identifiable, Codable {
    let id: UUID
    let botName: String
    let botId: String
    let audioURL: String
    let transcript: String
    let duration: TimeInterval
    let timestamp: Date
    let topic: String
    let confidence: Double
    let isHighlighted: Bool
    let tags: [String]
    let priority: BotVoiceNote.VoiceNotePriority
    
    // Computed properties for compatibility
    var content: String { transcript }
    var category: VoiceNotePriority { priority }
    
    enum VoiceNotePriority: String, CaseIterable, Codable {
        case urgent = "Urgent"
        case tradeAlert = "Trade Alert"
        case celebration = "Celebration"
        case info = "Info"
        case warning = "Warning"
        case performance = "Performance"
        
        var color: Color {
            switch self {
            case .urgent: return .red
            case .tradeAlert: return .orange
            case .celebration: return .green
            case .info: return .blue
            case .warning: return .yellow
            case .performance: return .purple
            }
        }
        
        var systemImage: String {
            switch self {
            case .urgent: return "exclamationmark.triangle.fill"
            case .tradeAlert: return "bell.fill"
            case .celebration: return "party.popper.fill"
            case .info: return "info.circle.fill"
            case .warning: return "exclamationmark.triangle"
            case .performance: return "chart.line.uptrend.xyaxis"
            }
        }
    }
    
    // Primary initializer
    init(
        id: UUID = UUID(),
        botName: String,
        botId: String,
        audioURL: String,
        transcript: String,
        duration: TimeInterval,
        timestamp: Date = Date(),
        topic: String,
        confidence: Double,
        isHighlighted: Bool = false,
        tags: [String] = [],
        priority: VoiceNotePriority = .info
    ) {
        self.id = id
        self.botName = botName
        self.botId = botId
        self.audioURL = audioURL
        self.transcript = transcript
        self.duration = duration
        self.timestamp = timestamp
        self.topic = topic
        self.confidence = confidence
        self.isHighlighted = isHighlighted
        self.tags = tags
        self.priority = priority
    }
    
    // Convenience initializer for GameControllerView compatibility
    init(
        botId: String,
        botName: String,
        content: String,
        category: VoiceNotePriority
    ) {
        self.id = UUID()
        self.botId = botId
        self.botName = botName
        self.audioURL = ""
        self.transcript = content
        self.duration = 3.0
        self.timestamp = Date()
        self.topic = "Game Event"
        self.confidence = 0.8
        self.isHighlighted = category == .urgent || category == .tradeAlert
        self.tags = ["game", "microflip"]
        self.priority = category
    }
}

// MARK: - Family Mode Types

enum FamilyMemberType: String, CaseIterable, Codable {
    case parent = "Parent"
    case child = "Child"
    case teen = "Teen" 
    case adult = "Adult"
    case grandparent = "Grandparent"
    
    var emoji: String {
        switch self {
        case .parent: return "👨‍👩‍👧‍👦"
        case .child: return "👶"
        case .teen: return "🧑‍🎓"
        case .adult: return "🧑‍💼"
        case .grandparent: return "👴"
        }
    }
    
    var primaryColor: Color {
        switch self {
        case .parent: return .blue
        case .child: return .green
        case .teen: return .orange
        case .adult: return .purple
        case .grandparent: return .brown
        }
    }
}

struct FamilyMemberProfile: Identifiable, Codable {
    let id: UUID
    let name: String
    let memberType: FamilyMemberType
    let age: Int
    let role: String
    let experience: String
    let goals: [String]
    let progress: Double
    let avatar: String
    let isActive: Bool
    let joinDate: Date
    
    init(
        id: UUID = UUID(),
        name: String,
        memberType: FamilyMemberType,
        age: Int,
        role: String,
        experience: String,
        goals: [String] = [],
        progress: Double = 0.0,
        avatar: String = "",
        isActive: Bool = true,
        joinDate: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.memberType = memberType
        self.age = age
        self.role = role
        self.experience = experience
        self.goals = goals
        self.progress = progress
        self.avatar = avatar
        self.isActive = isActive
        self.joinDate = joinDate
    }
}

// MARK: - News and Calendar Types

struct NewsTimeFilter: RawRepresentable, CaseIterable, Codable, Hashable {
    let rawValue: String
    
    init(rawValue: String) {
        self.rawValue = rawValue
    }
    
    static let all = NewsTimeFilter(rawValue: "All")
    static let lastHour = NewsTimeFilter(rawValue: "Last Hour")
    static let last6Hours = NewsTimeFilter(rawValue: "Last 6 Hours")
    static let today = NewsTimeFilter(rawValue: "Today")
    static let lastWeek = NewsTimeFilter(rawValue: "Last Week")
    
    static var allCases: [NewsTimeFilter] {
        return [.all, .lastHour, .last6Hours, .today, .lastWeek]
    }
}

struct CalendarTimeframe: RawRepresentable, CaseIterable, Codable {
    let rawValue: String
    
    init(rawValue: String) {
        self.rawValue = rawValue
    }
    
    static let today = CalendarTimeframe(rawValue: "Today")
    static let tomorrow = CalendarTimeframe(rawValue: "Tomorrow")
    static let thisWeek = CalendarTimeframe(rawValue: "This Week")
    static let nextWeek = CalendarTimeframe(rawValue: "Next Week")
    static let thisMonth = CalendarTimeframe(rawValue: "This Month")
    static let all = CalendarTimeframe(rawValue: "All")
    
    static var allCases: [CalendarTimeframe] = [.today, .tomorrow, .thisWeek, .nextWeek, .thisMonth, .all]
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
}

struct EconomicEventModel: Identifiable, Codable {
    let id: UUID
    let title: String
    let currency: String
    let impact: EconomicImpact
    let dateTime: Date
    let forecast: String?
    let previous: String?
    let actual: String?
    let description: String
    let category: String
    
    init(
        id: UUID = UUID(),
        title: String,
        currency: String,
        impact: EconomicImpact,
        dateTime: Date,
        forecast: String? = nil,
        previous: String? = nil,
        actual: String? = nil,
        description: String = "",
        category: String = "Economic"
    ) {
        self.id = id
        self.title = title
        self.currency = currency
        self.impact = impact
        self.dateTime = dateTime
        self.forecast = forecast
        self.previous = previous
        self.actual = actual
        self.description = description
        self.category = category
    }
}

struct NewsArticleModel: Identifiable, Hashable, Codable {
    let id = UUID()
    let title: String
    let summary: String
    let content: String
    let impact: EconomicImpact
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
}

// MARK: - Chart Types

enum ChartTimeframe: String, CaseIterable, Codable {
    case m1 = "1M"
    case m5 = "5M"
    case m15 = "15M"
    case m30 = "30M"
    case h1 = "1H"
    case h4 = "4H"
    case d1 = "1D"
    case w1 = "1W"
    case mn1 = "1MN"
}

struct ChartSettings: Codable {
    var showGrid: Bool = true
    var showVolume: Bool = true
    var selectedTimeframe: ChartTimeframe = .m15
    var indicatorsEnabled: Bool = true
    
    init() {}
}

// MARK: - Error and Debug Types

struct ErrorLogModel: Identifiable, Codable {
    let id = UUID()
    let type: ErrorLogModel.ErrorType
    let message: String
    let timestamp: Date
    let fileName: String
    let severity: ErrorLogModel.Severity
    
    enum ErrorType: String, CaseIterable, Codable {
        case runtime = "Runtime"
        case logic = "Logic"
        case network = "Network"
        case ui = "UI"
        case data = "Data"
    }
    
    enum Severity: String, CaseIterable, Codable {
        case low = "Low"
        case medium = "Medium"
        case high = "High"
        case critical = "Critical"
        
        var systemImage: String {
            switch self {
            case .low: return "info.circle"
            case .medium: return "exclamationmark.triangle"
            case .high: return "exclamationmark.circle"
            case .critical: return "xmark.octagon"
            }
        }
        
        var color: Color {
            switch self {
            case .low: return .blue
            case .medium: return .orange
            case .high: return .red
            case .critical: return .purple
            }
        }
    }
    
    var severityColor: Color { severity.color }
    
    static let samples: [ErrorLogModel] = [
        ErrorLogModel(
            type: .runtime,
            message: "Sample error message",
            timestamp: Date(),
            fileName: "TestFile.swift",
            severity: .medium
        )
    ]
}

struct DebugSession: Identifiable, Codable {
    let id: UUID
    let startTime: Date
    let endTime: Date?
    let errorsFound: Int
    let errorsFixed: Int
    
    init(id: UUID = UUID(), startTime: Date = Date(), endTime: Date? = nil, errorsFound: Int = 0, errorsFixed: Int = 0) {
        self.id = id
        self.startTime = startTime
        self.endTime = endTime
        self.errorsFound = errorsFound
        self.errorsFixed = errorsFixed
    }
}

struct LearningEvent: Identifiable, Codable {
    let id: UUID
    let eventType: String
    let data: String
    let timestamp: Date
    let confidence: Double
    
    init(id: UUID = UUID(), eventType: String, data: String, timestamp: Date = Date(), confidence: Double = 0.0) {
        self.id = id
        self.eventType = eventType
        self.data = data
        self.timestamp = timestamp
        self.confidence = confidence
    }
}

// MARK: - Additional Supporting Types

enum AutoTradingStatus: String, Codable, CaseIterable {
    case active = "Active"
    case paused = "Paused"
    case stopped = "Stopped"
    case error = "Error"
    
    var color: Color {
        switch self {
        case .active: return .green
        case .paused: return .orange
        case .stopped: return .gray
        case .error: return .red
        }
    }
    
    static var sample: AutoTradingStatus {
        return .active
    }
}

struct EnhancedProTraderBot: Identifiable, Codable {
    let id: UUID
    let name: String
    let strategy: EnhancedProTraderBot.TradingStrategy
    let specialization: EnhancedProTraderBot.BotSpecialization
    let performance: PerformanceMetrics
    let isActive: Bool
    
    enum TradingStrategy: String, CaseIterable, Codable {
        case scalping = "Scalping"
        case swing = "Swing"
        case dayTrading = "Day Trading"
        case news = "News Trading"
    }
    
    enum BotSpecialization: String, CaseIterable, Codable {
        case gold = "Gold Trading"
        case forex = "Forex"
        case crypto = "Cryptocurrency"
        case indices = "Indices"
    }
    
    init(
        id: UUID = UUID(),
        name: String,
        strategy: TradingStrategy,
        specialization: BotSpecialization,
        performance: PerformanceMetrics,
        isActive: Bool = false
    ) {
        self.id = id
        self.name = name
        self.strategy = strategy
        self.specialization = specialization
        self.performance = performance
        self.isActive = isActive
    }
}

struct LiveTradingOrder: Identifiable, Codable {
    let id: UUID
    let symbol: String
    let type: TradeDirection
    let size: Double
    let entryPrice: Double
    let stopLoss: Double?
    let takeProfit: Double?
    let currentPL: Double
    let timestamp: Date
    
    init(
        id: UUID = UUID(),
        symbol: String,
        type: TradeDirection,
        size: Double,
        entryPrice: Double,
        stopLoss: Double? = nil,
        takeProfit: Double? = nil,
        currentPL: Double = 0.0,
        timestamp: Date = Date()
    ) {
        self.id = id
        self.symbol = symbol
        self.type = type
        self.size = size
        self.entryPrice = entryPrice
        self.stopLoss = stopLoss
        self.takeProfit = takeProfit
        self.currentPL = currentPL
        self.timestamp = timestamp
    }
}

struct BotSignal: Identifiable, Codable {
    let id: UUID
    let botId: String
    let signal: String
    let confidence: Double
    let timestamp: Date
    let direction: TradeDirection
    
    init(
        id: UUID = UUID(),
        botId: String,
        signal: String,
        confidence: Double,
        timestamp: Date = Date(),
        direction: TradeDirection
    ) {
        self.id = id
        self.botId = botId
        self.signal = signal
        self.confidence = confidence
        self.timestamp = timestamp
        self.direction = direction
    }
}

struct TradingInstrument: Identifiable, Codable {
    let id: UUID
    let symbol: String
    let name: String
    let currentPrice: Double
    let change: Double
    let changePercent: Double
    
    init(id: UUID = UUID(), symbol: String, name: String, currentPrice: Double, change: Double, changePercent: Double) {
        self.id = id
        self.symbol = symbol
        self.name = name
        self.currentPrice = currentPrice
        self.change = change
        self.changePercent = changePercent
    }
    
    static let sampleInstruments: [TradingInstrument] = [
        TradingInstrument(
            symbol: "XAUUSD",
            name: "Gold",
            currentPrice: 2045.50,
            change: 12.30,
            changePercent: 0.61
        )
    ]
}

// MARK: - Color Extensions

extension Color {
    static let gold = Color.yellow
    static let brown = Color(red: 0.6, green: 0.4, blue: 0.2)
}

// MARK: - Preview

#Preview {
    VStack(spacing: 20) {
        Text("🚀 Master Shared Types")
            .font(.title.bold())
            .foregroundColor(.blue)
        
        Text("Single source of truth for all types")
            .font(.subheadline)
            .foregroundColor(.secondary)
        
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Core Types:")
                    .font(.caption.bold())
                Text("• TradeDirection")
                Text("• TradingMode") 
                Text("• BrokerType")
                Text("• TradeGrade")
                Text("• BotPerformanceMetrics ✅")
                    .foregroundColor(.green)
            }
            .font(.caption)
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Bot Types:")
                    .font(.caption.bold())
                Text("• TradingBot")
                Text("• EAStats")
                Text("• AutoTrade")
                Text("• BotStatus")
            }
            .font(.caption)
        }
    }
    .padding()
    .background(Color(.systemGroupedBackground))
    .cornerRadius(12)
}