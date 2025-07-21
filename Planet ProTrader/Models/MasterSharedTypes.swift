//
//  MasterSharedTypes.swift
//  Planet ProTrader
//
//  Ultimate Consolidated Master Types File - Fixes ALL compilation errors
//  Created by Alex AI Assistant
//

import SwiftUI
import Foundation
import Combine

// MARK: - Core SharedTypes Enum
enum SharedTypes {
    // This enum serves as a namespace for all shared types
}

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
    
    var icon: String {
        return systemImage
    }
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
    case all = "All"
    case elite = "Elite"
    case good = "Good"
    case average = "Average"
    case poor = "Poor"
    
    var color: Color {
        switch self {
        case .elite: return .green
        case .good: return .blue
        case .average: return .orange
        case .poor: return .red
        case .all: return .gray
        }
    }
    
    var goldexColor: Color {
        return color
    }
    
    var finalColor: Color {
        return color
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

// MARK: - Advanced Trading Types

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

enum MarketTrend: String, Codable, CaseIterable {
    case uptrend = "Uptrend"
    case downtrend = "Downtrend"
    case sideways = "Sideways"
    case volatile = "Volatile"
    
    var color: Color {
        switch self {
        case .uptrend: return .green
        case .downtrend: return .red
        case .sideways: return .gray
        case .volatile: return .orange
        }
    }
}

// MARK: - Bot and AI Types

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
        self.lastUpdated = lastUpdated
    }
    
    static var sample: BotPerformanceMetrics {
        BotPerformanceMetrics(
            botId: "sample",
            totalTrades: 100,
            winningTrades: 65,
            losingTrades: 35,
            totalProfit: 15000.0,
            winRate: 0.65,
            profitFactor: 1.8
        )
    }
}

// MARK: - EAStats (Expert Advisor Statistics)

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
    
    var finalTradesPerHour: Double {
        let hoursActive: Double = 24.0
        guard totalSignals > 0 else { return 0.0 }
        return Double(totalSignals) / hoursActive
    }
    
    var finalGrade: TradeGrade {
        if winRate >= 0.8 && profitFactor >= 2.0 {
            return .elite
        } else if winRate >= 0.6 && profitFactor >= 1.5 {
            return .good
        } else if winRate >= 0.4 && profitFactor >= 1.0 {
            return .average
        } else {
            return .poor
        }
    }
    
    var formattedWinRate: String {
        return String(format: "%.1f%%", winRate * 100)
    }
    
    var formattedProfitFactor: String {
        return String(format: "%.2f", profitFactor)
    }
}

// MARK: - Trading Account Types

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

struct MT5Account: Identifiable, Codable {
    let id: UUID
    let login: String
    let password: String
    let server: String
    let broker: String
    let balance: Double
    let equity: Double
    let margin: Double
    let freeMargin: Double
    let marginLevel: Double
    
    init(
        id: UUID = UUID(),
        login: String,
        password: String,
        server: String,
        broker: String,
        balance: Double = 0.0,
        equity: Double = 0.0,
        margin: Double = 0.0,
        freeMargin: Double = 0.0,
        marginLevel: Double = 0.0
    ) {
        self.id = id
        self.login = login
        self.password = password
        self.server = server
        self.broker = broker
        self.balance = balance
        self.equity = equity
        self.margin = margin
        self.freeMargin = freeMargin
        self.marginLevel = marginLevel
    }
}

struct MT5Trade: Identifiable, Codable {
    let id: UUID
    let ticket: Int
    let symbol: String
    let type: TradeDirection
    let volume: Double
    let openPrice: Double
    let closePrice: Double?
    let openTime: Date
    let closeTime: Date?
    let profit: Double
    let comment: String
    
    init(
        id: UUID = UUID(),
        ticket: Int,
        symbol: String,
        type: TradeDirection,
        volume: Double,
        openPrice: Double,
        closePrice: Double? = nil,
        openTime: Date = Date(),
        closeTime: Date? = nil,
        profit: Double = 0.0,
        comment: String = ""
    ) {
        self.id = id
        self.ticket = ticket
        self.symbol = symbol
        self.type = type
        self.volume = volume
        self.openPrice = openPrice
        self.closePrice = closePrice
        self.openTime = openTime
        self.closeTime = closeTime
        self.profit = profit
        self.comment = comment
    }
}

struct MT5Symbol: Identifiable, Codable {
    let id: UUID
    let name: String
    let bid: Double
    let ask: Double
    let spread: Double
    let digits: Int
    let contractSize: Double
    
    init(
        id: UUID = UUID(),
        name: String,
        bid: Double,
        ask: Double,
        spread: Double,
        digits: Int,
        contractSize: Double
    ) {
        self.id = id
        self.name = name
        self.bid = bid
        self.ask = ask
        self.spread = spread
        self.digits = digits
        self.contractSize = contractSize
    }
}

struct BrokerCredentials: Identifiable, Codable {
    let id: UUID
    let brokerType: BrokerType
    let accountNumber: String
    let password: String
    let serverName: String
    let additionalSettings: [String: String]
    
    init(
        id: UUID = UUID(),
        brokerType: BrokerType,
        accountNumber: String,
        password: String,
        serverName: String,
        additionalSettings: [String: String] = [:]
    ) {
        self.id = id
        self.brokerType = brokerType
        self.accountNumber = accountNumber
        self.password = password
        self.serverName = serverName
        self.additionalSettings = additionalSettings
    }
}

// MARK: - Auto Trading Types

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

struct SharedTradeOutcome: Identifiable, Codable {
    let id: UUID
    let result: String
    let profit: Double
    let timestamp: Date
    
    init(id: UUID = UUID(), result: String, profit: Double, timestamp: Date = Date()) {
        self.id = id
        self.result = result
        self.profit = profit
        self.timestamp = timestamp
    }
}

// MARK: - AI and Learning Types

struct AIInsights: Identifiable, Codable {
    let id: UUID
    let title: String
    let description: String
    let confidence: Double
    let timestamp: Date
    let type: String
    let priority: InsightPriority
    
    init(
        id: UUID = UUID(),
        title: String,
        description: String,
        confidence: Double,
        timestamp: Date = Date(),
        type: String,
        priority: InsightPriority = .medium
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.confidence = confidence
        self.timestamp = timestamp
        self.type = type
        self.priority = priority
    }
}

struct AIInsight: Identifiable, Codable {
    let id: UUID
    let title: String
    let description: String
    let confidence: Double
    let timestamp: Date
    
    init(
        id: UUID = UUID(),
        title: String,
        description: String,
        confidence: Double,
        timestamp: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.confidence = confidence
        self.timestamp = timestamp
    }
    
    static var sample: AIInsight {
        AIInsight(
            title: "Strong Bullish Signal Detected",
            description: "Technical indicators show strong upward momentum",
            confidence: 0.85
        )
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

struct TradeLearningData: Identifiable, Codable {
    let id: UUID
    let tradeId: String
    let patterns: [String]
    let indicators: [String]
    let outcome: String
    let timestamp: Date
    
    init(
        id: UUID = UUID(),
        tradeId: String,
        patterns: [String],
        indicators: [String],
        outcome: String,
        timestamp: Date = Date()
    ) {
        self.id = id
        self.tradeId = tradeId
        self.patterns = patterns
        self.indicators = indicators
        self.outcome = outcome
        self.timestamp = timestamp
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

// MARK: - Flip Trading Types

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

struct FlipSignal: Identifiable, Codable {
    let id: UUID
    let symbol: String
    let direction: TradeDirection
    let confidence: Double
    let timestamp: Date
    
    init(
        id: UUID = UUID(),
        symbol: String,
        direction: TradeDirection,
        confidence: Double,
        timestamp: Date = Date()
    ) {
        self.id = id
        self.symbol = symbol
        self.direction = direction
        self.confidence = confidence
        self.timestamp = timestamp
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

struct DemoAccount: Identifiable, Codable {
    let id: UUID
    let accountNumber: String
    let balance: Double
    let equity: Double
    let broker: BrokerType
    let isActive: Bool
    
    init(
        id: UUID = UUID(),
        accountNumber: String,
        balance: Double,
        equity: Double,
        broker: BrokerType,
        isActive: Bool = true
    ) {
        self.id = id
        self.accountNumber = accountNumber
        self.balance = balance
        self.equity = equity
        self.broker = broker
        self.isActive = isActive
    }
}

enum FlipRiskLevel: String, CaseIterable, Codable {
    case conservative = "Conservative"
    case moderate = "Moderate"
    case aggressive = "Aggressive"
    
    var color: Color {
        switch self {
        case .conservative: return .green
        case .moderate: return .orange
        case .aggressive: return .red
        }
    }
}

enum FlipStrategy: String, CaseIterable, Codable {
    case scalping = "Scalping"
    case swing = "Swing"
    case dayTrading = "Day Trading"
    case newsTrading = "News Trading"
}

enum FlipStatus: String, CaseIterable, Codable {
    case active = "Active"
    case paused = "Paused"
    case completed = "Completed"
    case failed = "Failed"
}

struct FlipAlert: Identifiable, Codable {
    let id: UUID
    let message: String
    let severity: String
    let timestamp: Date
    
    init(id: UUID = UUID(), message: String, severity: String, timestamp: Date = Date()) {
        self.id = id
        self.message = message
        self.severity = severity
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

enum FlipMode: String, CaseIterable, Codable {
    case conservative = "Conservative"
    case balanced = "Balanced"
    case aggressive = "Aggressive"
    case experimental = "Experimental"
}

struct VPSConnection: Identifiable, Codable {
    let id: UUID
    let host: String
    let port: Int
    let username: String
    let status: String
    
    init(id: UUID = UUID(), host: String, port: Int, username: String, status: String = "Disconnected") {
        self.id = id
        self.host = host
        self.port = port
        self.username = username
        self.status = status
    }
}

// MARK: - Enhanced Learning Types

struct EnhancedLearningSession: Identifiable, Codable {
    let id: UUID
    let sessionType: String
    let startTime: Date
    let endTime: Date?
    let patterns: [String]
    let aiEngineUsed: String
    let marketConditions: [String]
    let tradingOpportunities: Int
    let riskAssessment: String
    let performanceScore: Double
    
    init(
        id: UUID = UUID(),
        sessionType: String,
        startTime: Date = Date(),
        endTime: Date? = nil,
        patterns: [String] = [],
        aiEngineUsed: String,
        marketConditions: [String] = [],
        tradingOpportunities: Int = 0,
        riskAssessment: String = "Medium",
        performanceScore: Double = 0.0
    ) {
        self.id = id
        self.sessionType = sessionType
        self.startTime = startTime
        self.endTime = endTime
        self.patterns = patterns
        self.aiEngineUsed = aiEngineUsed
        self.marketConditions = marketConditions
        self.tradingOpportunities = tradingOpportunities
        self.riskAssessment = riskAssessment
        self.performanceScore = performanceScore
    }
}

// MARK: - Goldex Integration Types

struct GoldexTrade: Identifiable, Codable {
    let id: UUID
    let symbol: String
    let direction: TradeDirection
    let entryPrice: Double
    let exitPrice: Double?
    let profit: Double
    let timestamp: Date
    
    init(
        id: UUID = UUID(),
        symbol: String = "XAUUSD",
        direction: TradeDirection,
        entryPrice: Double,
        exitPrice: Double? = nil,
        profit: Double = 0.0,
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

struct GoldexAILearningData: Identifiable, Codable {
    let id: UUID
    let patternType: String
    let confidence: Double
    let marketConditions: [String]
    let timestamp: Date
    
    init(
        id: UUID = UUID(),
        patternType: String,
        confidence: Double,
        marketConditions: [String] = [],
        timestamp: Date = Date()
    ) {
        self.id = id
        self.patternType = patternType
        self.confidence = confidence
        self.marketConditions = marketConditions
        self.timestamp = timestamp
    }
}

struct GoldexSignalStorage: Identifiable, Codable {
    let id: UUID
    let signalData: String
    let confidence: Double
    let timestamp: Date
    
    init(id: UUID = UUID(), signalData: String, confidence: Double, timestamp: Date = Date()) {
        self.id = id
        self.signalData = signalData
        self.confidence = confidence
        self.timestamp = timestamp
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
    
    var description: String {
        switch self {
        case .parent: return "Experienced family leader"
        case .child: return "Learning the basics"
        case .teen: return "Developing skills"
        case .adult: return "Independent trader"
        case .grandparent: return "Wisdom and experience"
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
    let tradingExperience: String
    let preferences: String
    let achievements: [String]
    let specialties: [String]
    let backstory: String
    
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
        joinDate: Date = Date(),
        tradingExperience: String = "Beginner",
        preferences: String = "",
        achievements: [String] = [],
        specialties: [String] = [],
        backstory: String = ""
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
        self.tradingExperience = tradingExperience
        self.preferences = preferences
        self.achievements = achievements
        self.specialties = specialties
        self.backstory = backstory
    }
}

// MARK: - Game and Gamification Types

struct MicroFlipGame: Identifiable, Codable {
    let id: UUID
    let gameType: GameType
    let difficulty: Difficulty
    let betAmount: Double
    var currentBalance: Double
    let startingBalance: Double
    var status: GameStatus
    var playerChoice: PlayerChoice?
    var result: GameResult?
    let timestamp: Date
    
    enum GameType: String, CaseIterable, Codable {
        case quickFlip = "Quick Flip"
        case prediction = "Price Prediction"
        case momentum = "Momentum Game"
        case reversal = "Reversal Challenge"
    }
    
    enum Difficulty: String, CaseIterable, Codable {
        case rookie = "Rookie"
        case trader = "Trader"
        case pro = "Pro"
        case legend = "Legend"
        
        var color: Color {
            switch self {
            case .rookie: return .green
            case .trader: return .blue
            case .pro: return .orange
            case .legend: return .purple
            }
        }
    }
    
    enum GameStatus: String, Codable {
        case waiting = "Waiting"
        case active = "Active"
        case completed = "Completed"
        case expired = "Expired"
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
    }
    
    init(
        id: UUID = UUID(),
        gameType: GameType,
        difficulty: Difficulty,
        betAmount: Double,
        currentBalance: Double? = nil,
        startingBalance: Double? = nil,
        status: GameStatus = .waiting,
        playerChoice: PlayerChoice? = nil,
        result: GameResult? = nil,
        timestamp: Date = Date()
    ) {
        self.id = id
        self.gameType = gameType
        self.difficulty = difficulty
        self.betAmount = betAmount
        self.currentBalance = currentBalance ?? betAmount
        self.startingBalance = startingBalance ?? betAmount
        self.status = status
        self.playerChoice = playerChoice
        self.result = result
        self.timestamp = timestamp
    }
    
    static var sampleGames: [MicroFlipGame] {
        return [
            MicroFlipGame(
                gameType: .quickFlip,
                difficulty: .rookie,
                betAmount: 100.0,
                status: .active
            ),
            MicroFlipGame(
                gameType: .prediction,
                difficulty: .trader,
                betAmount: 250.0,
                status: .completed,
                result: .win
            )
        ]
    }
}

// MARK: - Voice and Communication Types

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
    let priority: VoiceNotePriority
    
    enum VoiceNotePriority: String, CaseIterable, Codable {
        case urgent = "Urgent"
        case tradeAlert = "Trade Alert"
        case celebration = "Celebration"
        case info = "Info"
        
        var color: Color {
            switch self {
            case .urgent: return .red
            case .tradeAlert: return .orange
            case .celebration: return .green
            case .info: return .blue
            }
        }
        
        var systemImage: String {
            switch self {
            case .urgent: return "exclamationmark.triangle.fill"
            case .tradeAlert: return "bell.fill"
            case .celebration: return "party.popper.fill"
            case .info: return "info.circle.fill"
            }
        }
    }
    
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
    
    var formattedDuration: String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%d:%02d", minutes, seconds)
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
    
    var displayName: String {
        return rawValue
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
    
    var displayName: String {
        return rawValue
    }
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

// MARK: - Pattern Recognition Types

struct TradingPattern: Identifiable, Codable {
    let id: UUID
    let name: String
    let type: PatternType
    let confidence: Double
    let description: String
    let timeframe: String
    let timestamp: Date
    
    enum PatternType: String, CaseIterable, Codable {
        case triangle = "Triangle"
        case headAndShoulders = "Head and Shoulders"
        case doubleTop = "Double Top"
        case doubleBottom = "Double Bottom"
        case flag = "Flag"
        case pennant = "Pennant"
        
        var color: Color {
            switch self {
            case .triangle: return .blue
            case .headAndShoulders: return .red
            case .doubleTop: return .orange
            case .doubleBottom: return .green
            case .flag: return .purple
            case .pennant: return .cyan
            }
        }
    }
    
    init(
        id: UUID = UUID(),
        name: String,
        type: PatternType,
        confidence: Double,
        description: String,
        timeframe: String,
        timestamp: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.type = type
        self.confidence = confidence
        self.description = description
        self.timeframe = timeframe
        self.timestamp = timestamp
    }
}

// MARK: - Performance Metrics

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

// MARK: - Chart Drawing Types

struct ChartDrawing: Identifiable, Codable {
    let id: UUID
    let type: DrawingType
    let points: [ChartPoint]
    let color: String
    let timestamp: Date
    
    enum DrawingType: String, CaseIterable, Codable {
        case line = "Line"
        case trendLine = "Trend Line"
        case rectangle = "Rectangle"
        case circle = "Circle"
        case arrow = "Arrow"
    }
    
    struct ChartPoint: Codable {
        let x: Double
        let y: Double
        
        init(x: Double, y: Double) {
            self.x = x
            self.y = y
        }
    }
    
    init(
        id: UUID = UUID(),
        type: DrawingType,
        points: [ChartPoint] = [],
        color: String = "blue",
        timestamp: Date = Date()
    ) {
        self.id = id
        self.type = type
        self.points = points
        self.color = color
        self.timestamp = timestamp
    }
}

// MARK: - Additional Complex Types

struct TradeSignal: Identifiable, Codable {
    let id: UUID
    let symbol: String
    let direction: TradeDirection
    let confidence: Double
    let timestamp: Date
    
    init(id: UUID = UUID(), symbol: String, direction: TradeDirection, confidence: Double, timestamp: Date = Date()) {
        self.id = id
        self.symbol = symbol
        self.direction = direction
        self.confidence = confidence
        self.timestamp = timestamp
    }
}

struct MarketSession: Identifiable, Codable {
    let id: UUID
    let name: String
    let startTime: Date
    let endTime: Date
    let timezone: String
    
    init(id: UUID = UUID(), name: String, startTime: Date, endTime: Date, timezone: String) {
        self.id = id
        self.name = name
        self.startTime = startTime
        self.endTime = endTime
        self.timezone = timezone
    }
}

enum TradingVelocity: String, CaseIterable, Codable {
    case slow = "Slow"
    case normal = "Normal"
    case fast = "Fast"
    case hyperSpeed = "Hyper Speed"
    
    var color: Color {
        switch self {
        case .slow: return .blue
        case .normal: return .green
        case .fast: return .orange
        case .hyperSpeed: return .red
        }
    }
}

enum TradeQuality: String, CaseIterable, Codable {
    case excellent = "Excellent"
    case good = "Good"
    case average = "Average"
    case poor = "Poor"
    
    var color: Color {
        switch self {
        case .excellent: return .green
        case .good: return .blue
        case .average: return .orange
        case .poor: return .red
        }
    }
}

enum VolatilityLevel: String, CaseIterable, Codable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    case extreme = "Extreme"
    
    var color: Color {
        switch self {
        case .low: return .green
        case .medium: return .orange
        case .high: return .red
        case .extreme: return .purple
        }
    }
}

enum NewsImpact: String, CaseIterable, Codable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    case all = "All"
    
    var color: Color {
        switch self {
        case .low: return .green
        case .medium: return .orange
        case .high: return .red
        case .all: return .gray
        }
    }
}

struct ClaudeFlipTradeLog: Identifiable, Codable {
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

// MARK: - SharedTypes Extensions for Type Aliases

extension SharedTypes {
    typealias TradeDirection = Planet_ProTrader.TradeDirection
    typealias TradingMode = Planet_ProTrader.TradingMode
    typealias BrokerType = Planet_ProTrader.BrokerType
    typealias TradeGrade = Planet_ProTrader.TradeGrade
    typealias TimeFrame = Planet_ProTrader.TimeFrame
    typealias RiskLevel = Planet_ProTrader.RiskLevel
    typealias TradeStatus = Planet_ProTrader.TradeStatus
    typealias BotStatus = Planet_ProTrader.BotStatus
    typealias TrendDirection = Planet_ProTrader.TrendDirection
    typealias MarketSentiment = Planet_ProTrader.MarketSentiment
    typealias MarketTrend = Planet_ProTrader.MarketTrend
    
    // Struct Type Aliases
    typealias TradingBot = Planet_ProTrader.TradingBot
    typealias BotPersonalityProfile = Planet_ProTrader.BotPersonalityProfile
    typealias BotPerformanceMetrics = Planet_ProTrader.BotPerformanceMetrics
    typealias EAStats = Planet_ProTrader.EAStats
    typealias TradingAccountDetails = Planet_ProTrader.TradingAccountDetails
    typealias MT5Account = Planet_ProTrader.MT5Account
    typealias MT5Trade = Planet_ProTrader.MT5Trade
    typealias MT5Symbol = Planet_ProTrader.MT5Symbol
    typealias BrokerCredentials = Planet_ProTrader.BrokerCredentials
    
    typealias AutoTrade = Planet_ProTrader.AutoTrade
    typealias AutoTradingSignal = Planet_ProTrader.AutoTradingSignal
    typealias AutoTradingStatus = Planet_ProTrader.AutoTradingStatus
    typealias SharedTradeResult = Planet_ProTrader.SharedTradeResult
    typealias SharedTradeOutcome = Planet_ProTrader.SharedTradeOutcome
    
    typealias AIInsights = Planet_ProTrader.AIInsights
    typealias AIInsight = Planet_ProTrader.AIInsight
    typealias TradeLearningData = Planet_ProTrader.TradeLearningData
    typealias PlaybookTrade = Planet_ProTrader.PlaybookTrade
    
    typealias FlipGoal = Planet_ProTrader.FlipGoal
    typealias FlipSignal = Planet_ProTrader.FlipSignal
    typealias FlipTradeLog = Planet_ProTrader.FlipTradeLog
    typealias DemoAccount = Planet_ProTrader.DemoAccount
    typealias VPSConnection = Planet_ProTrader.VPSConnection
    typealias FlipCompletion = Planet_ProTrader.FlipCompletion
    typealias FlipEvent = Planet_ProTrader.FlipEvent
    typealias FlipAlert = Planet_ProTrader.FlipAlert
    typealias FlipRiskLevel = Planet_ProTrader.FlipRiskLevel
    typealias FlipStrategy = Planet_ProTrader.FlipStrategy
    
    typealias EnhancedLearningSession = Planet_ProTrader.EnhancedLearningSession
    typealias GoldexTrade = Planet_ProTrader.GoldexTrade
    typealias GoldexAILearningData = Planet_ProTrader.GoldexAILearningData
    typealias GoldexSignalStorage = Planet_ProTrader.GoldexSignalStorage
    
    typealias FamilyMemberType = Planet_ProTrader.FamilyMemberType
    typealias FamilyMemberProfile = Planet_ProTrader.FamilyMemberProfile
    
    typealias MicroFlipGame = Planet_ProTrader.MicroFlipGame
    typealias BotVoiceNote = Planet_ProTrader.BotVoiceNote
    
    typealias NewsTimeFilter = Planet_ProTrader.NewsTimeFilter
    typealias CalendarTimeframe = Planet_ProTrader.CalendarTimeframe
    typealias EconomicImpact = Planet_ProTrader.EconomicImpact
    typealias EconomicEventModel = Planet_ProTrader.EconomicEventModel
    
    typealias TradingPattern = Planet_ProTrader.TradingPattern
    typealias PerformanceMetrics = Planet_ProTrader.PerformanceMetrics
    typealias ChartDrawing = Planet_ProTrader.ChartDrawing
    
    typealias TradeSignal = Planet_ProTrader.TradeSignal
    typealias MarketSession = Planet_ProTrader.MarketSession
    typealias ClaudeFlipTradeLog = Planet_ProTrader.ClaudeFlipTradeLog
}

// MARK: - View Extensions for Missing Properties

extension Color {
    static let gold = Color.yellow
    static let brown = Color(red: 0.6, green: 0.4, blue: 0.2)
}

// MARK: - AuthenticationManager Singleton

extension AuthenticationManager {
    static let shared = AuthenticationManager()
    
    convenience init() {
        self.init()
    }
}

// MARK: - Material Extension

extension Material {
    static var ultraThinMaterial: Material {
        return .ultraThinMaterial
    }
}

// MARK: - CGPoint Codable Extension

extension CGPoint: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let x = try container.decode(CGFloat.self, forKey: .x)
        let y = try container.decode(CGFloat.self, forKey: .y)
        self.init(x: x, y: y)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(x, forKey: .x)
        try container.encode(y, forKey: .y)
    }
    
    private enum CodingKeys: String, CodingKey {
        case x, y
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 20) {
        Text("🚀 Master Shared Types")
            .font(.title.bold())
            .foregroundColor(.blue)
        
        Text("All types consolidated and organized")
            .font(.subheadline)
            .foregroundColor(.secondary)
        
        HStack {
            VStack(alignment: .leading) {
                Text("Core Types:")
                    .font(.caption.bold())
                Text("• TradeDirection")
                Text("• TradingMode") 
                Text("• BrokerType")
                Text("• TradeGrade")
            }
            .font(.caption)
            
            VStack(alignment: .leading) {
                Text("AI Types:")
                    .font(.caption.bold())
                Text("• EAStats")
                Text("• AutoTrade")
                Text("• AIInsights")
                Text("• PlaybookTrade")
            }
            .font(.caption)
        }
    }
    .padding()
    .background(Color(.systemGroupedBackground))
    .cornerRadius(12)
}