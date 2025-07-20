//
//  SharedTypes.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 7/13/25.
//

import Foundation
import SwiftUI

// MARK: - SharedTypes Namespace

enum SharedTypes {
    
    // MARK: - Trading Direction
    
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
    
    // MARK: - Trading Mode
    
    enum TradingMode: String, Codable, CaseIterable {
        case auto = "Auto"
        case manual = "Manual"
        case scalp = "Scalp"
        case swing = "Swing"
        case position = "Position"
        case backtest = "Backtest"
        
        var description: String {
            switch self {
            case .auto: return "Fully automated trading"
            case .manual: return "Manual trade execution"
            case .scalp: return "Quick scalping trades"
            case .swing: return "Swing trading strategy"
            case .position: return "Long-term position trading"
            case .backtest: return "Backtesting mode"
            }
        }
        
        var color: Color {
            switch self {
            case .auto: return .green
            case .manual: return .blue
            case .scalp: return .orange
            case .swing: return .purple
            case .position: return .indigo
            case .backtest: return .cyan
            }
        }
    }
    
    // MARK: - Broker Type
    
    enum BrokerType: String, Codable, CaseIterable {
        case mt5 = "MT5"
        case mt4 = "MT4"
        case coinexx = "Coinexx"
        case forex = "Forex.com"
        case manual = "Manual"
        case tradeLocker = "TradeLocker"
        case xtb = "XTB"
        case hankotrade = "HankoTrade"
        
        var displayName: String {
            rawValue
        }
        
        var color: Color {
            switch self {
            case .mt5: return .blue
            case .mt4: return .green
            case .coinexx: return .orange
            case .forex: return .purple
            case .manual: return .gray
            case .tradeLocker: return .indigo
            case .xtb: return .red
            case .hankotrade: return .cyan
            }
        }
        
        var systemImage: String {
            switch self {
            case .mt5, .mt4: return "chart.xyaxis.line"
            case .coinexx: return "building.columns"
            case .forex: return "dollarsign.circle"
            case .manual: return "hand.point.up"
            case .tradeLocker: return "lock.shield"
            case .xtb: return "building.2"
            case .hankotrade: return "chart.line.uptrend.xyaxis"
            }
        }
        
        var icon: String {
            return systemImage
        }
    }
    
    // MARK: - Market Session
    
    enum MarketSession: String, Codable, CaseIterable {
        case sydney = "Sydney"
        case tokyo = "Tokyo"
        case london = "London"
        case newYork = "New York"
        
        var color: Color {
            switch self {
            case .sydney: return .blue
            case .tokyo: return .red
            case .london: return .green
            case .newYork: return .orange
            }
        }
        
        var timeZone: String {
            switch self {
            case .sydney: return "AEDT"
            case .tokyo: return "JST"
            case .london: return "GMT"
            case .newYork: return "EST"
            }
        }
    }
    
    // MARK: - Market Sentiment
    
    enum MarketSentiment: String, Codable, CaseIterable {
        case bullish = "Bullish"
        case bearish = "Bearish"
        case neutral = "Neutral"
        
        var color: Color {
            switch self {
            case .bullish: return .green
            case .bearish: return .red
            case .neutral: return .gray
            }
        }
    }
    
    // MARK: - Trading Account Details
    
    struct TradingAccountDetails: Identifiable, Codable {
        let id: UUID
        let accountNumber: String
        let accountName: String
        let brokerType: BrokerType
        let serverName: String
        let platform: String
        let balance: Double
        let equity: Double
        let currency: String
        let leverage: String
        let isDemo: Bool
        let isConnected: Bool
        let lastUpdate: Date
        
        enum AccountType: String, Codable, CaseIterable {
            case demo = "Demo"
            case live = "Live"
        }
        
        init(
            id: UUID = UUID(),
            accountNumber: String,
            accountName: String,
            brokerType: BrokerType,
            serverName: String,
            platform: String = "MT5",
            balance: Double,
            equity: Double,
            currency: String = "USD",
            leverage: String = "1:500",
            isDemo: Bool = true,
            isConnected: Bool = false,
            lastUpdate: Date = Date()
        ) {
            self.id = id
            self.accountNumber = accountNumber
            self.accountName = accountName
            self.brokerType = brokerType
            self.serverName = serverName
            self.platform = platform
            self.balance = balance
            self.equity = equity
            self.currency = currency
            self.leverage = leverage
            self.isDemo = isDemo
            self.isConnected = isConnected
            self.lastUpdate = lastUpdate
        }
        
        var name: String { accountName }
        var server: String { serverName }
        var accountType: AccountType { isDemo ? .demo : .live }
        var formattedBalance: String { String(format: "$%.2f", balance) }
        var formattedEquity: String { String(format: "$%.2f", equity) }
        var accountTypeText: String { isDemo ? "Demo" : "Live" }
        var accountTypeColor: Color { isDemo ? .orange : .green }
        var connectionStatusColor: Color { isConnected ? .green : .red }
        var connectionStatusText: String { isConnected ? "Connected" : "Disconnected" }
    }
    
    // MARK: - Broker Credentials
    
    struct BrokerCredentials: Codable {
        let login: String
        let password: String
        let server: String
        let brokerType: BrokerType
        
        init(login: String, password: String, server: String, brokerType: BrokerType) {
            self.login = login
            self.password = password
            self.server = server
            self.brokerType = brokerType
        }
    }
    
    // MARK: - Auto Trading Signal
    
    struct AutoTradingSignal: Identifiable, Codable {
        let id: UUID
        let timestamp: Date
        let symbol: String
        let direction: TradeDirection
        let entryPrice: Double
        let stopLoss: Double
        let takeProfit: Double
        let lotSize: Double
        let confidence: Double
        let reasoning: String
        let timeframe: String
        let isExecuted: Bool
        
        init(
            id: UUID = UUID(),
            timestamp: Date = Date(),
            symbol: String,
            direction: TradeDirection,
            entryPrice: Double,
            stopLoss: Double,
            takeProfit: Double,
            lotSize: Double,
            confidence: Double,
            reasoning: String,
            timeframe: String,
            isExecuted: Bool = false
        ) {
            self.id = id
            self.timestamp = timestamp
            self.symbol = symbol
            self.direction = direction
            self.entryPrice = entryPrice
            self.stopLoss = stopLoss
            self.takeProfit = takeProfit
            self.lotSize = lotSize
            self.confidence = confidence
            self.reasoning = reasoning
            self.timeframe = timeframe
            self.isExecuted = isExecuted
        }
        
        var formattedConfidence: String { String(format: "%.1f%%", confidence * 100) }
        var formattedLotSize: String { String(format: "%.2f", lotSize) }
        
        var riskRewardRatio: Double {
            let risk = abs(entryPrice - stopLoss)
            let reward = abs(takeProfit - entryPrice)
            return risk > 0 ? reward / risk : 0
        }
    }
    
    // MARK: - Shared Trade Result
    
    struct SharedTradeResult: Codable {
        let success: Bool
        let tradeId: String?
        let profit: Double
        let message: String
        let timestamp: Date
        
        init(success: Bool, tradeId: String? = nil, profit: Double, message: String, timestamp: Date = Date()) {
            self.success = success
            self.tradeId = tradeId
            self.profit = profit
            self.message = message
            self.timestamp = timestamp
        }
        
        var formattedProfit: String {
            let sign = profit >= 0 ? "+" : ""
            return "\(sign)$\(String(format: "%.2f", profit))"
        }
        
        var profitColor: Color {
            profit >= 0 ? .green : .red
        }
    }
    
    // MARK: - Shared Trade Outcome
    
    struct SharedTradeOutcome: Codable {
        let tradeId: String
        let success: Bool
        let profit: Double
        let confidence: Double
        let timestamp: Date
        
        init(tradeId: String, success: Bool, profit: Double, confidence: Double, timestamp: Date = Date()) {
            self.tradeId = tradeId
            self.success = success
            self.profit = profit
            self.confidence = confidence
            self.timestamp = timestamp
        }
    }
    
    // MARK: - Flip Types
    
    enum FlipMode: String, Codable, CaseIterable {
        case conservative = "Conservative"
        case balanced = "Balanced"
        case aggressive = "Aggressive"
        case extreme = "Extreme"
        
        var expectedDuration: TimeInterval {
            switch self {
            case .conservative: return 7200 // 2 hours
            case .balanced: return 3600 // 1 hour
            case .aggressive: return 1800 // 30 minutes
            case .extreme: return 900 // 15 minutes
            }
        }
    }
    
    enum FlipRiskLevel: String, Codable, CaseIterable {
        case low = "Low"
        case medium = "Medium"
        case high = "High"
        case extreme = "Extreme"
    }
    
    enum FlipStrategy: String, Codable, CaseIterable {
        case scalping = "Scalping"
        case swing = "Swing"
        case dayTrading = "Day Trading"
        case breakout = "Breakout"
        
        var mode: FlipMode {
            switch self {
            case .scalping: return .aggressive
            case .swing: return .conservative
            case .dayTrading: return .aggressive
            case .breakout: return .aggressive
            }
        }
        
        var riskPerTrade: Double {
            switch self {
            case .scalping: return 5.0
            case .swing: return 2.5
            case .dayTrading: return 4.0
            case .breakout: return 3.0
            }
        }
    }
    
    struct FlipGoal: Identifiable, Codable {
        let id: UUID
        let startBalance: Double
        let targetBalance: Double
        let startDate: Date
        let targetDate: Date
        let currentBalance: Double
        let isActive: Bool
        let startingAmount: Double
        let targetAmount: Double
        let timeLimit: Int
        let riskTolerance: FlipRiskLevel
        let status: String
        let strategy: FlipStrategy
        
        init(
            id: UUID = UUID(),
            startBalance: Double,
            targetBalance: Double,
            startDate: Date,
            targetDate: Date,
            currentBalance: Double,
            isActive: Bool = true,
            startingAmount: Double? = nil,
            targetAmount: Double? = nil,
            timeLimit: Int = 30,
            riskTolerance: FlipRiskLevel = .medium,
            status: String = "ACTIVE",
            strategy: FlipStrategy = .dayTrading
        ) {
            self.id = id
            self.startBalance = startBalance
            self.targetBalance = targetBalance
            self.startDate = startDate
            self.targetDate = targetDate
            self.currentBalance = currentBalance
            self.isActive = isActive
            self.startingAmount = startingAmount ?? startBalance
            self.targetAmount = targetAmount ?? targetBalance
            self.timeLimit = timeLimit
            self.riskTolerance = riskTolerance
            self.status = status
            self.strategy = strategy
        }
        
        var progress: Double {
            let totalGain = targetBalance - startBalance
            let currentGain = currentBalance - startBalance
            return totalGain > 0 ? currentGain / totalGain : 0
        }
        
        var formattedProgress: String { String(format: "%.1f%%", progress * 100) }
        var formattedStartBalance: String { String(format: "$%.2f", startBalance) }
        var formattedTargetBalance: String { String(format: "$%.2f", targetBalance) }
        var formattedCurrentBalance: String { String(format: "$%.2f", currentBalance) }
    }
    
    struct FlipSignal: Identifiable, Codable {
        let id: UUID
        let timestamp: Date
        let direction: TradeDirection
        let entryPrice: Double
        let targetPrice: Double
        let stopPrice: Double
        let lotSize: Double
        let reasoning: String
        let isExecuted: Bool
        
        init(
            id: UUID = UUID(),
            timestamp: Date = Date(),
            direction: TradeDirection,
            entryPrice: Double,
            targetPrice: Double,
            stopPrice: Double,
            lotSize: Double,
            reasoning: String,
            isExecuted: Bool = false
        ) {
            self.id = id
            self.timestamp = timestamp
            self.direction = direction
            self.entryPrice = entryPrice
            self.targetPrice = targetPrice
            self.stopPrice = stopPrice
            self.lotSize = lotSize
            self.reasoning = reasoning
            self.isExecuted = isExecuted
        }
        
        var takeProfit: Double { targetPrice }
        var expectedDuration: TimeInterval { 3600 }
    }
    
    struct FlipStatus: Codable {
        let accountId: String
        let currentBalance: Double
        let targetBalance: Double
        let progress: Double
        let isActive: Bool
        let daysSinceStart: Int
    }
    
    struct FlipAlert: Codable {
        let id: String
        let message: String
        let priority: AlertPriority
        let timestamp: Date
        
        enum AlertPriority: String, Codable {
            case low = "Low"
            case medium = "Medium"
            case high = "High"
        }
    }
    
    struct FlipCompletion: Codable {
        let accountId: String
        let finalBalance: Double
        let initialBalance: Double
        let profit: Double
        let duration: TimeInterval
        let completedAt: Date
        let id: String
        let flipId: String
        let startingAmount: Double
        let finalAmount: Double
        let multiplier: Double
        let daysToComplete: Double
        let totalTrades: Int
        let winRate: Double
        let timestamp: Date
        
        init(
            accountId: String,
            finalBalance: Double,
            initialBalance: Double,
            profit: Double,
            duration: TimeInterval,
            completedAt: Date,
            id: String = UUID().uuidString,
            flipId: String = "",
            startingAmount: Double? = nil,
            finalAmount: Double? = nil,
            multiplier: Double? = nil,
            daysToComplete: Double? = nil,
            totalTrades: Int = 0,
            winRate: Double = 0.0,
            timestamp: Date? = nil
        ) {
            self.accountId = accountId
            self.finalBalance = finalBalance
            self.initialBalance = initialBalance
            self.profit = profit
            self.duration = duration
            self.completedAt = completedAt
            self.id = id
            self.flipId = flipId
            self.startingAmount = startingAmount ?? initialBalance
            self.finalAmount = finalAmount ?? finalBalance
            self.multiplier = multiplier ?? (finalBalance / initialBalance)
            self.daysToComplete = daysToComplete ?? (duration / 86400.0)
            self.totalTrades = totalTrades
            self.winRate = winRate
            self.timestamp = timestamp ?? completedAt
        }
    }
    
    struct FlipEvent: Codable {
        let id: String
        let accountId: String
        let eventType: String
        let description: String
        let timestamp: Date
        let message: String
        let flipId: String
        
        init(
            id: String,
            accountId: String,
            eventType: String,
            description: String,
            timestamp: Date,
            message: String? = nil,
            flipId: String = ""
        ) {
            self.id = id
            self.accountId = accountId
            self.eventType = eventType
            self.description = description
            self.timestamp = timestamp
            self.message = message ?? description
            self.flipId = flipId
        }
    }
    
    struct FlipTradeLog: Codable {
        let id: String
        let accountId: String
        let symbol: String
        let direction: TradeDirection
        let entryPrice: Double
        let exitPrice: Double
        let lotSize: Double
        let profit: Double
        let timestamp: Date
        let flipId: String
        let signal: AutoTradingSignal?
        let beforeScreenshot: String?
        let afterScreenshot: String?
        let tradeResult: SharedTradeResult?
        
        init(
            id: String,
            accountId: String,
            symbol: String,
            direction: TradeDirection,
            entryPrice: Double,
            exitPrice: Double,
            lotSize: Double,
            profit: Double,
            timestamp: Date,
            flipId: String = "",
            signal: AutoTradingSignal? = nil,
            beforeScreenshot: String? = nil,
            afterScreenshot: String? = nil,
            tradeResult: SharedTradeResult? = nil
        ) {
            self.id = id
            self.accountId = accountId
            self.symbol = symbol
            self.direction = direction
            self.entryPrice = entryPrice
            self.exitPrice = exitPrice
            self.lotSize = lotSize
            self.profit = profit
            self.timestamp = timestamp
            self.flipId = flipId
            self.signal = signal
            self.beforeScreenshot = beforeScreenshot
            self.afterScreenshot = afterScreenshot
            self.tradeResult = tradeResult
        }
    }
    
    // MARK: - Account Types
    
    struct DemoAccount: Codable {
        let id: String
        let login: String
        let server: String
        let balance: Double
        let equity: Double
        let currency: String
        let leverage: Int
        let isActive: Bool
        let createdAt: Date
        let password: String
        
        var brokerType: BrokerType { .coinexx }
        var startingBalance: Double { balance }
        var currentBalance: Double { balance }
        var flipId: String { id }
        var vpsIndex: Int { 0 }
        var status: AccountStatus { isActive ? .active : .inactive }
        
        enum AccountStatus: String, Codable {
            case active = "Active"
            case inactive = "Inactive"
            case initializing = "Initializing"
        }
        
        init(
            id: String,
            login: String,
            server: String,
            balance: Double,
            equity: Double,
            currency: String = "USD",
            leverage: Int = 500,
            isActive: Bool = true,
            createdAt: Date = Date(),
            password: String = "demo_password"
        ) {
            self.id = id
            self.login = login
            self.server = server
            self.balance = balance
            self.equity = equity
            self.currency = currency
            self.leverage = leverage
            self.isActive = isActive
            self.createdAt = createdAt
            self.password = password
        }
    }
    
    enum ConnectionStatus: String, Codable, CaseIterable {
        case connecting = "Connecting"
        case connected = "Connected"
        case disconnected = "Disconnected"
        case error = "Error"
        
        var color: Color {
            switch self {
            case .connected: return .green
            case .connecting: return .orange
            case .disconnected: return .gray
            case .error: return .red
            }
        }
    }
    
    struct VPSConnection: Codable {
        let id: String
        let ipAddress: String
        let port: Int
        let username: String
        let password: String
        let isConnected: Bool
        let lastPing: Date
        let status: ConnectionStatus
        var accountsRunning: Int
        let maxAccounts: Int
        
        init(
            id: String,
            ipAddress: String,
            port: Int = 22,
            username: String = "",
            password: String = "",
            isConnected: Bool = false,
            lastPing: Date = Date(),
            status: ConnectionStatus = .disconnected,
            accountsRunning: Int = 0,
            maxAccounts: Int = 5
        ) {
            self.id = id
            self.ipAddress = ipAddress
            self.port = port
            self.username = username
            self.password = password
            self.isConnected = isConnected
            self.lastPing = lastPing
            self.status = status
            self.accountsRunning = accountsRunning
            self.maxAccounts = maxAccounts
        }
    }
    
    // MARK: - Trading Types
    
    enum TradeResult: String, Codable {
        case win = "Win"
        case loss = "Loss"
        case breakeven = "Breakeven"
        case pending = "Pending"
    }
    
    struct AutoTrade: Codable {
        let id: String
        let symbol: String
        let direction: TradeDirection
        let entryPrice: Double
        let exitPrice: Double?
        let lotSize: Double
        let profit: Double
        let status: TradeStatus
        let timestamp: Date
        let mode: TradingMode
        let stopLoss: Double?
        let takeProfit: Double?
        let confidence: Double
        let reasoning: String
        let result: TradeResult?
        let profitLoss: Double?
        
        enum TradeStatus: String, Codable {
            case pending = "Pending"
            case open = "Open"
            case closed = "Closed"
            case cancelled = "Cancelled"
        }
        
        init(
            id: String,
            symbol: String,
            direction: TradeDirection,
            entryPrice: Double,
            exitPrice: Double? = nil,
            lotSize: Double,
            profit: Double,
            status: TradeStatus = .pending,
            timestamp: Date = Date(),
            mode: TradingMode = .auto,
            stopLoss: Double? = nil,
            takeProfit: Double? = nil,
            confidence: Double = 0.5,
            reasoning: String = "",
            result: TradeResult? = nil,
            profitLoss: Double? = nil
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
            self.mode = mode
            self.stopLoss = stopLoss
            self.takeProfit = takeProfit
            self.confidence = confidence
            self.reasoning = reasoning
            self.result = result
            self.profitLoss = profitLoss
        }
    }
    
    struct GoldexTrade: Codable {
        let id: String
        let symbol: String
        let direction: TradeDirection
        let entryPrice: Double
        let exitPrice: Double?
        let lotSize: Double
        let profit: Double
        let confidence: Double
        let timestamp: Date
        let entry: Double
        let stopLoss: Double?
        let takeProfit: Double?
        let result: String
        let pattern: String
        let duration: TimeInterval
        let takenAt: Date
        let riskPercent: Double
        let profitLoss: Double
        let winProbability: Double
        
        init(
            id: String,
            symbol: String,
            direction: TradeDirection,
            entryPrice: Double,
            exitPrice: Double? = nil,
            lotSize: Double,
            profit: Double,
            confidence: Double,
            timestamp: Date,
            entry: Double? = nil,
            stopLoss: Double? = nil,
            takeProfit: Double? = nil,
            result: String = "PENDING",
            pattern: String = "UNKNOWN",
            duration: TimeInterval = 0,
            takenAt: Date? = nil,
            riskPercent: Double = 0.0,
            profitLoss: Double = 0.0,
            winProbability: Double = 0.0
        ) {
            self.id = id
            self.symbol = symbol
            self.direction = direction
            self.entryPrice = entryPrice
            self.exitPrice = exitPrice
            self.lotSize = lotSize
            self.profit = profit
            self.confidence = confidence
            self.timestamp = timestamp
            self.entry = entry ?? entryPrice
            self.stopLoss = stopLoss
            self.takeProfit = takeProfit
            self.result = result
            self.pattern = pattern
            self.duration = duration
            self.takenAt = takenAt ?? timestamp
            self.riskPercent = riskPercent
            self.profitLoss = profitLoss
            self.winProbability = winProbability
        }
    }
    
    enum TradeGrade: String, Codable, CaseIterable {
        case all = "All"
        case elite = "Elite"
        case good = "Good"
        case average = "Average"
        case poor = "Poor"
    }
    
    struct PlaybookTrade: Codable {
        let id: String
        let symbol: String
        let direction: TradeDirection
        let entryPrice: Double
        let exitPrice: Double
        let lotSize: Double
        let profit: Double
        let grade: TradeGrade
        let reasoning: String
        let timestamp: Date
        
        init(
            id: String,
            symbol: String,
            direction: TradeDirection,
            entryPrice: Double,
            exitPrice: Double,
            lotSize: Double,
            profit: Double,
            grade: TradeGrade,
            reasoning: String,
            timestamp: Date = Date()
        ) {
            self.id = id
            self.symbol = symbol
            self.direction = direction
            self.entryPrice = entryPrice
            self.exitPrice = exitPrice
            self.lotSize = lotSize
            self.profit = profit
            self.grade = grade
            self.reasoning = reasoning
            self.timestamp = timestamp
        }
    }
    
    // MARK: - AI and Learning Types
    
    struct AIInsights: Codable {
        let id: String
        let insights: [String]
        let confidence: Double
        let timestamp: Date
        
        init(id: String, insights: [String], confidence: Double, timestamp: Date = Date()) {
            self.id = id
            self.insights = insights
            self.confidence = confidence
            self.timestamp = timestamp
        }
    }
    
    struct TradeLearningData: Codable {
        let id: String
        let patterns: [String]
        let outcomes: [String]
        let accuracy: Double
        let timestamp: Date
        
        init(id: String, patterns: [String], outcomes: [String], accuracy: Double, timestamp: Date = Date()) {
            self.id = id
            self.patterns = patterns
            self.outcomes = outcomes
            self.accuracy = accuracy
            self.timestamp = timestamp
        }
    }
    
    struct GoldexAILearningData: Codable {
        let id: String
        let learningPoints: [String]
        let accuracy: Double
        let tradesAnalyzed: Int
        let timestamp: Date
        let totalTrades: Int
        let winningTrades: Int
        let recentLosses: Int
        let patternPerformance: [String: Double]
        let timePerformance: [String: Double]
        let patterns: [String]
        
        init(
            id: String,
            learningPoints: [String],
            accuracy: Double,
            tradesAnalyzed: Int,
            timestamp: Date = Date(),
            totalTrades: Int = 0,
            winningTrades: Int = 0,
            recentLosses: Int = 0,
            patternPerformance: [String: Double] = [:],
            timePerformance: [String: Double] = [:],
            patterns: [String] = []
        ) {
            self.id = id
            self.learningPoints = learningPoints
            self.accuracy = accuracy
            self.tradesAnalyzed = tradesAnalyzed
            self.timestamp = timestamp
            self.totalTrades = totalTrades
            self.winningTrades = winningTrades
            self.recentLosses = recentLosses
            self.patternPerformance = patternPerformance
            self.timePerformance = timePerformance
            self.patterns = patterns
        }
    }
    
    struct ClaudeTradeData: Codable {
        let id: String
        let symbol: String
        let direction: TradeDirection
        let entryPrice: Double
        let exitPrice: Double
        let lotSize: Double
        let profit: Double
        let timestamp: Date
        let success: Bool
        
        init(
            id: String,
            symbol: String,
            direction: TradeDirection,
            entryPrice: Double,
            exitPrice: Double,
            lotSize: Double,
            profit: Double,
            timestamp: Date = Date(),
            success: Bool
        ) {
            self.id = id
            self.symbol = symbol
            self.direction = direction
            self.entryPrice = entryPrice
            self.exitPrice = exitPrice
            self.lotSize = lotSize
            self.profit = profit
            self.timestamp = timestamp
            self.success = success
        }
    }
    
    // MARK: - Signal and Storage Types
    
    struct GoldexSignalStorage: Codable {
        let id: String
        let symbol: String
        let direction: TradeDirection
        let confidence: Double
        let reasoning: String
        let timestamp: Date
        let entryPrice: Double
        let stopLoss: Double?
        let takeProfit: Double?
        
        init(
            id: String,
            symbol: String,
            direction: TradeDirection,
            confidence: Double,
            reasoning: String,
            timestamp: Date = Date(),
            entryPrice: Double,
            stopLoss: Double? = nil,
            takeProfit: Double? = nil
        ) {
            self.id = id
            self.symbol = symbol
            self.direction = direction
            self.confidence = confidence
            self.reasoning = reasoning
            self.timestamp = timestamp
            self.entryPrice = entryPrice
            self.stopLoss = stopLoss
            self.takeProfit = takeProfit
        }
    }
    
    // MARK: - MT5 Types
    
    struct MT5Account: Codable {
        let login: String
        let password: String
        let server: String
        let company: String
        let balance: Double
        let equity: Double
        let margin: Double
        let freeMargin: Double
        let currency: String
        let leverage: Int
        let isConnected: Bool
        
        init(
            login: String,
            password: String,
            server: String,
            company: String,
            balance: Double,
            equity: Double,
            margin: Double = 0.0,
            freeMargin: Double? = nil,
            currency: String = "USD",
            leverage: Int = 500,
            isConnected: Bool = false
        ) {
            self.login = login
            self.password = password
            self.server = server
            self.company = company
            self.balance = balance
            self.equity = equity
            self.margin = margin
            self.freeMargin = freeMargin ?? balance
            self.currency = currency
            self.leverage = leverage
            self.isConnected = isConnected
        }
    }
    
    struct MT5Trade: Codable {
        let ticket: String
        let symbol: String
        let direction: TradeDirection
        let volume: Double
        let openPrice: Double
        let currentPrice: Double
        let profit: Double
        let openTime: Date
        let stopLoss: Double
        let takeProfit: Double
        let comment: String
        
        var type: TradeDirection { return direction }
        
        init(
            ticket: String,
            symbol: String,
            direction: TradeDirection,
            volume: Double,
            openPrice: Double,
            currentPrice: Double,
            profit: Double,
            openTime: Date = Date(),
            stopLoss: Double = 0.0,
            takeProfit: Double = 0.0,
            comment: String = ""
        ) {
            self.ticket = ticket
            self.symbol = symbol
            self.direction = direction
            self.volume = volume
            self.openPrice = openPrice
            self.currentPrice = currentPrice
            self.profit = profit
            self.openTime = openTime
            self.stopLoss = stopLoss
            self.takeProfit = takeProfit
            self.comment = comment
        }
    }
    
    struct MT5Symbol: Codable {
        let name: String
        let description: String
        let bid: Double
        let ask: Double
        let spread: Double
        
        init(name: String, description: String, bid: Double, ask: Double, spread: Double) {
            self.name = name
            self.description = description
            self.bid = bid
            self.ask = ask
            self.spread = spread
        }
    }
    
    // MARK: - EAStats and Performance
    
    struct EAStats: Codable {
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
        
        init() {
            self.totalSignals = 0
            self.winningSignals = 0
            self.losingSignals = 0
            self.pendingSignals = 0
            self.totalProfit = 0.0
            self.totalLoss = 0.0
            self.averageWin = 0.0
            self.averageLoss = 0.0
            self.winRate = 0.0
            self.profitFactor = 1.0
            self.lastUpdated = Date()
        }
        
        mutating func updateStats() {
            winRate = totalSignals > 0 ? Double(winningSignals) / Double(totalSignals) : 0.0
            averageWin = winningSignals > 0 ? totalProfit / Double(winningSignals) : 0.0
            averageLoss = losingSignals > 0 ? totalLoss / Double(losingSignals) : 0.0
            profitFactor = totalLoss > 0 ? totalProfit / totalLoss : totalProfit > 0 ? 999.0 : 1.0
            lastUpdated = Date()
        }
        
        mutating func addSignalResult(profit: Double) {
            totalSignals += 1
            
            if profit > 0 {
                winningSignals += 1
                totalProfit += profit
            } else {
                losingSignals += 1
                totalLoss += abs(profit)
            }
            
            updateStats()
        }
        
        var formattedWinRate: String {
            return String(format: "%.1f%%", winRate * 100)
        }
        
        var formattedProfitFactor: String {
            return String(format: "%.2f", profitFactor)
        }
    }
    
    // MARK: - Family Mode Types
    
    struct FamilyMemberProfile: Identifiable, Codable {
        let id = UUID()
        let name: String
        let age: Int
        let role: MemberRole
        let experienceLevel: ExperienceLevel
        let goals: [String]
        let progress: Double
        let avatar: String
        let permissions: [Permission]
        let tradingExperience: ExperienceLevel
        let preferences: TradingPreferences
        let achievements: [String]
        let joinDate: Date
        var isActive: Bool
        
        enum MemberRole: String, CaseIterable, Codable {
            case parent = "Parent"
            case child = "Child"
            case teen = "Teen"
            case adult = "Adult"
            
            var maxAllowedRisk: Double {
                switch self {
                case .parent: return 1.0
                case .child: return 0.1
                case .teen: return 0.3
                case .adult: return 0.8
                }
            }
        }
        
        enum ExperienceLevel: String, CaseIterable, Codable {
            case beginner = "Beginner"
            case intermediate = "Intermediate"
            case advanced = "Advanced"
            case expert = "Expert"
        }
        
        enum Permission: String, CaseIterable, Codable {
            case viewPortfolio = "View Portfolio"
            case makeTrades = "Make Trades"
            case manageSettings = "Manage Settings"
            case viewReports = "View Reports"
            case createBots = "Create Bots"
        }
        
        init(
            name: String,
            age: Int,
            role: MemberRole,
            experienceLevel: ExperienceLevel,
            goals: [String],
            progress: Double,
            avatar: String,
            permissions: [Permission],
            tradingExperience: ExperienceLevel,
            preferences: TradingPreferences,
            achievements: [String],
            joinDate: Date,
            isActive: Bool
        ) {
            self.name = name
            self.age = age
            self.role = role
            self.experienceLevel = experienceLevel
            self.goals = goals
            self.progress = progress
            self.avatar = avatar
            self.permissions = permissions
            self.tradingExperience = tradingExperience
            self.preferences = preferences
            self.achievements = achievements
            self.joinDate = joinDate
            self.isActive = isActive
        }
    }
    
    struct TradingPreferences: Codable {
        let riskTolerance: Double
        let favoriteStrategies: [String]
        let preferredMarkets: [String]
        
        init(riskTolerance: Double, favoriteStrategies: [String], preferredMarkets: [String]) {
            self.riskTolerance = riskTolerance
            self.favoriteStrategies = favoriteStrategies
            self.preferredMarkets = preferredMarkets
        }
    }
    
    // MARK: - Enhanced Learning Session
    
    struct EnhancedLearningSession: Codable {
        let timestamp: Date
        let dataPoints: Int
        let xpGained: Double
        let confidenceGained: Double
        let patternsDiscovered: [String]
        let aiEngineUsed: String
        let marketConditions: String
        let tradingOpportunities: [String]
        let riskAssessment: String
        
        init(
            timestamp: Date,
            dataPoints: Int,
            xpGained: Double,
            confidenceGained: Double,
            patternsDiscovered: [String],
            aiEngineUsed: String,
            marketConditions: Any,
            tradingOpportunities: Any,
            riskAssessment: Any
        ) {
            self.timestamp = timestamp
            self.dataPoints = dataPoints
            self.xpGained = xpGained
            self.confidenceGained = confidenceGained
            self.patternsDiscovered = patternsDiscovered
            self.aiEngineUsed = aiEngineUsed
            self.marketConditions = String(describing: marketConditions)
            self.tradingOpportunities = (tradingOpportunities as? [String]) ?? []
            self.riskAssessment = String(describing: riskAssessment)
        }
    }
    
} // MARK: - End of SharedTypes Enum

// MARK: - Sample Data Extensions

extension SharedTypes.TradingAccountDetails {
    static let sampleAccounts: [SharedTypes.TradingAccountDetails] = [
        SharedTypes.TradingAccountDetails(
            accountNumber: "845060",
            accountName: "Main Demo Account",
            brokerType: .coinexx,
            serverName: "Coinexx-Demo",
            platform: "MT5",
            balance: 1270.85,
            equity: 1285.50,
            isDemo: true,
            isConnected: true
        ),
        SharedTypes.TradingAccountDetails(
            accountNumber: "123456",
            accountName: "MT5 Live Account",
            brokerType: .mt5,
            serverName: "MT5-Live",
            platform: "MT5",
            balance: 5000.00,
            equity: 5125.75,
            isDemo: false,
            isConnected: false
        )
    ]
}

#Preview {
    VStack {
        Text("SharedTypes Preview")
            .font(.title)
        
        Text("Types available: TradeDirection, BrokerType, TradingMode")
            .font(.caption)
    }
    .padding()
}