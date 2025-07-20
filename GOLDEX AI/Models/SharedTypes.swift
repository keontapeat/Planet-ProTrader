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
    
    // MARK: - Trend Direction
    
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
        
        var systemImage: String {
            switch self {
            case .bullish: return "arrow.up.right"
            case .bearish: return "arrow.down.right"
            case .neutral: return "minus"
            case .sideways: return "arrow.right"
            }
        }
        
        var icon: String {
            return systemImage
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
        
        var name: String {
            accountName
        }
        
        var server: String {
            serverName
        }
        
        var accountType: AccountType {
            isDemo ? .demo : .live
        }
        
        var formattedBalance: String {
            String(format: "$%.2f", balance)
        }
        
        var formattedEquity: String {
            String(format: "$%.2f", equity)
        }
        
        var accountTypeText: String {
            isDemo ? "Demo" : "Live"
        }
        
        var accountTypeColor: Color {
            isDemo ? .orange : .green
        }
        
        var connectionStatusColor: Color {
            isConnected ? .green : .red
        }
        
        var connectionStatusText: String {
            isConnected ? "Connected" : "Disconnected"
        }
    }
    
    // MARK: - Connected Account
    
    struct ConnectedAccount: Identifiable, Codable {
        let id: UUID
        let name: String
        let balance: String
        let brokerType: BrokerType
        let isConnected: Bool
        let lastUpdate: Date
        
        init(
            id: UUID = UUID(),
            name: String,
            balance: String,
            brokerType: BrokerType,
            isConnected: Bool,
            lastUpdate: Date
        ) {
            self.id = id
            self.name = name
            self.balance = balance
            self.brokerType = brokerType
            self.isConnected = isConnected
            self.lastUpdate = lastUpdate
        }
        
        var statusColor: Color {
            isConnected ? .green : .red
        }
        
        var statusText: String {
            isConnected ? "Connected" : "Disconnected"
        }
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
            timestamp: Date,
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
        
        var formattedConfidence: String {
            String(format: "%.1f%%", confidence * 100)
        }
        
        var formattedLotSize: String {
            String(format: "%.2f", lotSize)
        }
        
        var riskRewardRatio: Double {
            let risk = abs(entryPrice - stopLoss)
            let reward = abs(takeProfit - entryPrice)
            return risk > 0 ? reward / risk : 0
        }
    }
    
    // MARK: - VPS Trade Result
    
    struct VPSTradeResult: Codable {
        let success: Bool
        let tradeId: String?
        let message: String
        let timestamp: Date
        let executionPrice: Double?
        
        init(success: Bool, tradeId: String? = nil, message: String, timestamp: Date = Date(), executionPrice: Double? = nil) {
            self.success = success
            self.tradeId = tradeId
            self.message = message
            self.timestamp = timestamp
            self.executionPrice = executionPrice
        }
        
        var statusColor: Color {
            success ? .green : .red
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
    
    // MARK: - Flip Goal
    
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
        
        var formattedProgress: String {
            String(format: "%.1f%%", progress * 100)
        }
        
        var formattedStartBalance: String {
            String(format: "$%.2f", startBalance)
        }
        
        var formattedTargetBalance: String {
            String(format: "$%.2f", targetBalance)
        }
        
        var formattedCurrentBalance: String {
            String(format: "$%.2f", currentBalance)
        }
        
        var progressColor: Color {
            if progress >= 1.0 {
                return .green
            } else if progress >= 0.5 {
                return .orange
            } else {
                return .red
            }
        }
        
        var statusText: String {
            if progress >= 1.0 {
                return "Completed"
            } else if isActive {
                return "Active"
            } else {
                return "Paused"
            }
        }
    }
    
    // MARK: - Flip Signal
    
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
            timestamp: Date,
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
        
        var formattedLotSize: String {
            String(format: "%.2f", lotSize)
        }
        
        var potentialProfit: Double {
            let priceDiff = abs(targetPrice - entryPrice)
            return priceDiff * lotSize * 100 // Simplified calculation
        }
        
        var formattedPotentialProfit: String {
            String(format: "$%.2f", potentialProfit)
        }
        
        // Additional properties for compatibility
        var takeProfit: Double { targetPrice }
        var expectedDuration: TimeInterval { 3600 } // 1 hour default
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
    
    // MARK: - Missing Types for Compilation
    
    // MARK: - Claude AI Integration Types
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
    }
    
    // MARK: - Flip Trading Types
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
        
        // Computed properties for compatibility
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
        
        var minConfidence: Double {
            switch self {
            case .scalping: return 80.0
            case .swing: return 90.0
            case .dayTrading: return 85.0
            case .breakout: return 87.0
            }
        }
        
        var timeframes: [String] {
            switch self {
            case .scalping: return ["1M", "5M", "15M"]
            case .swing: return ["4H", "1H", "15M"]
            case .dayTrading: return ["1H", "15M", "5M"]
            case .breakout: return ["15M", "5M", "1M"]
            }
        }
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
        
        init(accountId: String, finalBalance: Double, initialBalance: Double, profit: Double, duration: TimeInterval, completedAt: Date, id: String = UUID().uuidString, flipId: String = "", startingAmount: Double? = nil, finalAmount: Double? = nil, multiplier: Double? = nil, daysToComplete: Double? = nil, totalTrades: Int = 0, winRate: Double = 0.0, timestamp: Date? = nil) {
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
        
        init(id: String, accountId: String, eventType: String, description: String, timestamp: Date, message: String? = nil, flipId: String = "") {
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
        
        init(id: String, accountId: String, symbol: String, direction: TradeDirection, entryPrice: Double, exitPrice: Double, lotSize: Double, profit: Double, timestamp: Date, flipId: String = "", signal: AutoTradingSignal? = nil, beforeScreenshot: String? = nil, afterScreenshot: String? = nil, tradeResult: SharedTradeResult? = nil) {
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
        
        // Additional properties for flip mode compatibility
        var brokerType: BrokerType { .coinexx }
        var startingBalance: Double { balance }
        var currentBalance: Double { balance }
        var flipId: String { id }
        var vpsIndex: Int { 0 }
        var status: AccountStatus { isActive ? .active : .inactive }
        var password: String { "demo_password" }
        
        enum AccountStatus: String, Codable {
            case active = "Active"
            case inactive = "Inactive"
            case initializing = "Initializing"
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
        
        init(id: String, ipAddress: String, port: Int = 22, username: String = "", password: String = "", isConnected: Bool = false, lastPing: Date = Date(), status: ConnectionStatus = .disconnected, accountsRunning: Int = 0, maxAccounts: Int = 5) {
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
        
        init(id: String, symbol: String, direction: TradeDirection, entryPrice: Double, exitPrice: Double? = nil, lotSize: Double, profit: Double, confidence: Double, timestamp: Date, entry: Double? = nil, stopLoss: Double? = nil, takeProfit: Double? = nil, result: String = "PENDING", pattern: String = "UNKNOWN", duration: TimeInterval = 0, takenAt: Date? = nil, riskPercent: Double = 0.0, profitLoss: Double = 0.0, winProbability: Double = 0.0) {
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
    }
    
    enum TradeGrade: String, Codable, CaseIterable {
        case all = "All"
        case elite = "Elite"
        case good = "Good"
        case average = "Average"
        case poor = "Poor"
    }
    
    // MARK: - AI and Learning Types
    struct SharedTradeOutcome: Codable {
        let tradeId: String
        let success: Bool
        let profit: Double
        let confidence: Double
        let timestamp: Date
    }
    
    struct AIInsights: Codable {
        let id: String
        let insights: [String]
        let confidence: Double
        let timestamp: Date
    }
    
    struct TradeLearningData: Codable {
        let id: String
        let patterns: [String]
        let outcomes: [String]
        let accuracy: Double
        let timestamp: Date
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
        
        init(id: String, learningPoints: [String], accuracy: Double, tradesAnalyzed: Int, timestamp: Date, totalTrades: Int = 0, winningTrades: Int = 0, recentLosses: Int = 0, patternPerformance: [String: Double] = [:], timePerformance: [String: Double] = [:], patterns: [String] = []) {
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
        
        init(id: String, symbol: String, direction: TradeDirection, confidence: Double, reasoning: String, timestamp: Date, entryPrice: Double, stopLoss: Double? = nil, takeProfit: Double? = nil) {
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
    
    struct TradeSignal: Codable {
        let id: String
        let symbol: String
        let direction: TradeDirection
        let entryPrice: Double
        let confidence: Double
        let timestamp: Date
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
        
        init(login: String, password: String, server: String, company: String, isConnected: Bool = false, balance: Double, equity: Double, margin: Double = 0.0, freeMargin: Double? = nil, currency: String = "USD", leverage: Int = 500) {
            self.login = login
            self.password = password
            self.server = server
            self.company = company
            self.isConnected = isConnected
            self.balance = balance
            self.equity = equity
            self.margin = margin
            self.freeMargin = freeMargin ?? balance
            self.currency = currency
            self.leverage = leverage
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
        
        var type: TradeDirection {
            return direction
        }
    }
    
    struct MT5Symbol: Codable {
        let name: String
        let description: String
        let bid: Double
        let ask: Double
        let spread: Double
    }
    
    // MARK: - Performance and Analytics Types
    struct PerformanceMetrics: Codable {
        let totalTrades: Int
        let winRate: Double
        let totalProfit: Double
        let averageWin: Double
        let averageLoss: Double
        let profitFactor: Double
        
        static let sample = PerformanceMetrics(
            totalTrades: 100,
            winRate: 0.85,
            totalProfit: 1250.0,
            averageWin: 45.0,
            averageLoss: -25.0,
            profitFactor: 2.5
        )
    }
    
    enum InsightPriority: String, Codable, CaseIterable {
        case low = "Low"
        case medium = "Medium"
        case high = "High"
        case critical = "Critical"
    }
    
    struct AIInsight: Codable {
        let id: String
        let title: String
        let description: String
        let priority: InsightPriority
        let timestamp: Date
        
        static let sample = AIInsight(
            id: "1",
            title: "Market Opportunity",
            description: "Strong bullish signal detected",
            priority: .high,
            timestamp: Date()
        )
    }
    
    // MARK: - Dashboard Types
    struct ActiveFlip: Codable {
        let id: String
        let accountId: String
        let startBalance: Double
        let currentBalance: Double
        let targetBalance: Double
        let progress: Double
        let isActive: Bool
    }
    
    struct AutoTradingStatus: Codable {
        let isActive: Bool
        let mode: TradingMode
        let confidence: Double
        let tradesThisSession: Int
        let profit: Double
        
        static let sample = AutoTradingStatus(
            isActive: true,
            mode: .auto,
            confidence: 0.92,
            tradesThisSession: 15,
            profit: 245.0
        )
    }
    
    struct TradingSession: Codable {
        let id: String
        let name: String
        let startTime: Date
        let endTime: Date
        let isActive: Bool
        let volume: Double
    }
    
    struct RecentActivity: Codable {
        let id: String
        let description: String
        let type: ActivityType
        let timestamp: Date
        
        enum ActivityType: String, Codable {
            case trade = "Trade"
            case signal = "Signal"
            case analysis = "Analysis"
            case alert = "Alert"
        }
    }
    
    enum MarketSentiment: String, Codable, CaseIterable {
        case bullish = "Bullish"
        case bearish = "Bearish"
        case neutral = "Neutral"
    }
    
    // MARK: - Missing Firebase Performance Types
    struct GoldexPatternPerformance: Codable {
        let id: String
        let patternName: String
        let winRate: Double
        let totalTrades: Int
        let averageProfit: Double
        let timestamp: Date
    }
    
    struct GoldexTimePerformance: Codable {
        let id: String
        let timeSession: String
        let winRate: Double
        let totalProfit: Double
        let tradesExecuted: Int
        let timestamp: Date
    }
    
    // MARK: - Additional Trading Types
    
    struct EASignal: Identifiable, Codable {
        let id: String
        let timestamp: Date
        let symbol: String
        let direction: TradeDirection
        let confidence: Double
        let reasoning: String
        let entryPrice: Double
        let stopLoss: Double?
        let takeProfit: Double?
        let timeframe: String
        let priority: SignalPriority
        let isExecuted: Bool
        
        init(
            id: String = UUID().uuidString,
            timestamp: Date = Date(),
            symbol: String,
            direction: TradeDirection,
            confidence: Double,
            reasoning: String,
            entryPrice: Double,
            stopLoss: Double? = nil,
            takeProfit: Double? = nil,
            timeframe: String = "1H",
            priority: SignalPriority = .medium,
            isExecuted: Bool = false
        ) {
            self.id = id
            self.timestamp = timestamp
            self.symbol = symbol
            self.direction = direction
            self.confidence = confidence
            self.reasoning = reasoning
            self.entryPrice = entryPrice
            self.stopLoss = stopLoss
            self.takeProfit = takeProfit
            self.timeframe = timeframe
            self.priority = priority
            self.isExecuted = isExecuted
        }
        
        var formattedConfidence: String {
            return String(format: "%.1f%%", confidence * 100)
        }
        
        var riskRewardRatio: Double {
            guard let sl = stopLoss, let tp = takeProfit else { return 0.0 }
            let risk = abs(entryPrice - sl)
            let reward = abs(tp - entryPrice)
            return risk > 0 ? reward / risk : 0.0
        }
    }
    
    enum SignalPriority: String, Codable, CaseIterable {
        case low = "Low"
        case medium = "Medium"
        case high = "High"
        case urgent = "Urgent"
        
        var color: Color {
            switch self {
            case .low: return .gray
            case .medium: return .blue
            case .high: return .orange
            case .urgent: return .red
            }
        }
        
        var weight: Double {
            switch self {
            case .low: return 0.25
            case .medium: return 0.5
            case .high: return 0.75
            case .urgent: return 1.0
            }
        }
    }
    
    struct TradingPosition: Identifiable, Codable {
        let id: String
        let symbol: String
        let direction: TradeDirection
        let openPrice: Double
        let currentPrice: Double
        let lotSize: Double
        let floatingPnL: Double
        let openTime: Date
        let stopLoss: Double?
        let takeProfit: Double?
        let comment: String
        let magic: Int
        
        init(
            id: String = UUID().uuidString,
            symbol: String,
            direction: TradeDirection,
            openPrice: Double,
            currentPrice: Double,
            lotSize: Double,
            floatingPnL: Double,
            openTime: Date = Date(),
            stopLoss: Double? = nil,
            takeProfit: Double? = nil,
            comment: String = "",
            magic: Int = 0
        ) {
            self.id = id
            self.symbol = symbol
            self.direction = direction
            self.openPrice = openPrice
            self.currentPrice = currentPrice
            self.lotSize = lotSize
            self.floatingPnL = floatingPnL
            self.openTime = openTime
            self.stopLoss = stopLoss
            self.takeProfit = takeProfit
            self.comment = comment
            self.magic = magic
        }
        
        var formattedPnL: String {
            let sign = floatingPnL >= 0 ? "+" : ""
            return "\(sign)$\(String(format: "%.2f", floatingPnL))"
        }
        
        var pnlColor: Color {
            return floatingPnL >= 0 ? .green : .red
        }
        
        var priceDifference: Double {
            return currentPrice - openPrice
        }
        
        var pips: Double {
            return abs(priceDifference) * 10000 // Simplified pip calculation
        }
        
        var duration: TimeInterval {
            return Date().timeIntervalSince(openTime)
        }
        
        var formattedDuration: String {
            let hours = Int(duration) / 3600
            let minutes = Int(duration) % 3600 / 60
            return "\(hours)h \(minutes)m"
        }
    }
    
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
            // Recalculate derived metrics
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
        
        var performanceGrade: TradeGrade {
            if winRate >= 0.7 && profitFactor >= 2.0 {
                return .elite
            } else if winRate >= 0.6 && profitFactor >= 1.5 {
                return .good
            } else if winRate >= 0.5 && profitFactor >= 1.2 {
                return .average
            } else {
                return .poor
            }
        }
    }
    
    enum PerformanceGrade: String, Codable, CaseIterable {
        case excellent = "Excellent"
        case good = "Good"
        case average = "Average"
        case poor = "Poor"
        case terrible = "Terrible"
        
        var color: Color {
            switch self {
            case .excellent: return .green
            case .good: return .mint
            case .average: return .yellow
            case .poor: return .orange
            case .terrible: return .red
            }
        }
        
        var score: Double {
            switch self {
            case .excellent: return 1.0
            case .good: return 0.8
            case .average: return 0.6
            case .poor: return 0.4
            case .terrible: return 0.2
            }
        }
        
        var systemImage: String {
            switch self {
            case .excellent: return "star.fill"
            case .good: return "star.leadinghalf.filled"
            case .average: return "star"
            case .poor: return "star.slash"
            case .terrible: return "xmark.circle"
            }
        }
    }
    
    // MARK: - Learning Capability Types
    enum LearningCapability: String, Codable, CaseIterable {
        // Price Action Capabilities
        case priceAction = "Price Action"
        case volumeAnalysis = "Volume Analysis"
        case microstructure = "Microstructure"
        
        // Technical Analysis Capabilities
        case trendAnalysis = "Trend Analysis"
        case supportResistance = "Support Resistance"
        case patternRecognition = "Pattern Recognition"
        case chartPatterns = "Chart Patterns"
        case candlesticks = "Candlesticks"
        
        // Market Structure Capabilities
        case orderFlow = "Order Flow"
        case marketStructure = "Market Structure"
        case liquidity = "Liquidity"
        
        // Sentiment & Psychology Capabilities
        case sentiment = "Sentiment"
        case extremes = "Extremes"
        case meanReversion = "Mean Reversion"
        case behaviorAnalysis = "Behavior Analysis"
        case emotionalPatterns = "Emotional Patterns"
        case marketPsychology = "Market Psychology"
        
        // News & Events Capabilities
        case newsAnalysis = "News Analysis"
        case eventTrading = "Event Trading"
        case volatility = "Volatility"
        case socialMedia = "Social Media"
        case positioning = "Positioning"
        
        // Risk & Portfolio Capabilities
        case riskAssessment = "Risk Assessment"
        case portfolioManagement = "Portfolio Management"
        case correlation = "Correlation"
        
        // Fundamental Analysis
        case fundamentals = "Fundamentals"
        
        var description: String {
            switch self {
            case .priceAction: return "Analyzing price movements and market action"
            case .volumeAnalysis: return "Understanding volume patterns and flow"
            case .microstructure: return "Market microstructure and order book analysis"
            case .trendAnalysis: return "Identifying and following market trends"
            case .supportResistance: return "Key support and resistance level identification"
            case .patternRecognition: return "Advanced pattern recognition capabilities"
            case .chartPatterns: return "Classic chart pattern analysis"
            case .candlesticks: return "Japanese candlestick pattern expertise"
            case .orderFlow: return "Order flow and institutional activity tracking"
            case .marketStructure: return "Understanding market structure shifts"
            case .liquidity: return "Liquidity analysis and pool identification"
            case .sentiment: return "Market sentiment and crowd psychology"
            case .extremes: return "Identifying market extremes and reversals"
            case .meanReversion: return "Mean reversion strategy implementation"
            case .behaviorAnalysis: return "Trader behavior pattern analysis"
            case .emotionalPatterns: return "Emotional market cycle recognition"
            case .marketPsychology: return "Advanced market psychology insights"
            case .newsAnalysis: return "News impact analysis and trading"
            case .eventTrading: return "Event-driven trading strategies"
            case .volatility: return "Volatility analysis and exploitation"
            case .socialMedia: return "Social media sentiment tracking"
            case .positioning: return "Market positioning analysis"
            case .riskAssessment: return "Advanced risk assessment capabilities"
            case .portfolioManagement: return "Portfolio optimization and management"
            case .correlation: return "Asset correlation analysis"
            case .fundamentals: return "Fundamental analysis expertise"
            }
        }
        
        var category: LearningCategory {
            switch self {
            case .priceAction, .volumeAnalysis, .microstructure:
                return .priceAction
            case .trendAnalysis, .supportResistance, .patternRecognition, .chartPatterns, .candlesticks:
                return .technical
            case .orderFlow, .marketStructure, .liquidity:
                return .institutional
            case .sentiment, .extremes, .meanReversion, .behaviorAnalysis, .emotionalPatterns, .marketPsychology:
                return .psychology
            case .newsAnalysis, .eventTrading, .volatility, .socialMedia, .positioning:
                return .news
            case .riskAssessment, .portfolioManagement, .correlation:
                return .risk
            case .fundamentals:
                return .fundamental
            }
        }
    }
    
    // MARK: - Learning Categories
    enum LearningCategory: String, Codable, CaseIterable {
        case priceAction = "Price Action"
        case technical = "Technical Analysis"
        case institutional = "Institutional"
        case psychology = "Psychology"
        case news = "News & Events"
        case risk = "Risk Management"
        case fundamental = "Fundamental"
        
        var color: Color {
            switch self {
            case .priceAction: return .blue
            case .technical: return .green
            case .institutional: return .purple
            case .psychology: return .orange
            case .news: return .red
            case .risk: return .gray
            case .fundamental: return .indigo
            }
        }
        
        var systemImage: String {
            switch self {
            case .priceAction: return "chart.xyaxis.line"
            case .technical: return "waveform.path.ecg"
            case .institutional: return "building.columns"
            case .psychology: return "brain.head.profile"
            case .news: return "newspaper"
            case .risk: return "shield.checkerboard"
            case .fundamental: return "doc.text.magnifyingglass"
            }
        }
    }
    
    // MARK: - Missing Connection Status Types  
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
    
    // MARK: - Missing ProTrader Bot Army Types
    
    struct GoldDataPoint: Identifiable, Codable {
        let id = UUID()
        let date: Date
        let open: Double
        let high: Double
        let low: Double
        let close: Double
        let volume: Double?
        
        var timestamp: Date { date }
        
        init(date: Date, open: Double, high: Double, low: Double, close: Double, volume: Double? = nil) {
            self.date = date
            self.open = open
            self.high = high
            self.low = low
            self.close = close
            self.volume = volume
        }
    }
    
    class TrainingResults: ObservableObject {
        @Published var botsTrained: Int = 0
        @Published var dataPointsProcessed: Int = 0
        @Published var totalXPGained: Double = 0
        @Published var totalConfidenceGained: Double = 0
        @Published var newEliteBots: Int = 0
        @Published var newGodlikeBots: Int = 0
        @Published var trainingTime: Double = 0
        @Published var errors: [String] = []
        @Published var patterns: [String] = []
        @Published var startTime: Date = Date()
        @Published var endTime: Date?
        
        var summary: String {
            """
            🚀 Training Complete!
            
            📊 Bots Trained: \(botsTrained)
            📈 Data Points: \(dataPointsProcessed)
            ⭐ Total XP Gained: \(Int(totalXPGained))
            🧠 Confidence Boost: \(String(format: "%.2f%%", totalConfidenceGained))
            👑 New Godlike Bots: \(newGodlikeBots)
            💎 New Elite Bots: \(newEliteBots)
            ⏱️ Training Time: \(String(format: "%.2f", trainingTime))s
            
            Your ProTrader army just evolved to the next level!
            """
        }
        
        init() {}
    }
    
    struct LearningSession: Codable, Identifiable {
        let id = UUID()
        let timestamp: Date
        let dataPoints: Int
        let xpGained: Double
        let confidenceGained: Double
        let patterns: [String]
        let duration: TimeInterval
        
        init(timestamp: Date = Date(), dataPoints: Int, xpGained: Double, confidenceGained: Double, patterns: [String] = [], duration: TimeInterval = 0) {
            self.timestamp = timestamp
            self.dataPoints = dataPoints
            self.xpGained = xpGained
            self.confidenceGained = confidenceGained
            self.patterns = patterns
            self.duration = duration
        }
    }
    
    struct ProTraderBot: Identifiable, Codable {
        let id = UUID()
        let botNumber: Int
        let name: String
        var xp: Double
        var confidence: Double
        let strategy: TradingStrategy
        var wins: Int
        var losses: Int
        var totalTrades: Int
        var profitLoss: Double
        var learningHistory: [LearningSession]
        var lastTraining: Date?
        var isActive: Bool
        let specialization: BotSpecialization
        
        var winRate: Double {
            guard totalTrades > 0 else { return 0 }
            return (Double(wins) / Double(totalTrades)) * 100
        }
        
        var confidenceLevel: String {
            switch confidence {
            case 0.95...: return "GODLIKE"
            case 0.85..<0.95: return "ELITE"
            case 0.75..<0.85: return "VETERAN"
            case 0.65..<0.75: return "EXPERIENCED"
            case 0.55..<0.65: return "TRAINED"
            default: return "ROOKIE"
            }
        }
        
        init(botNumber: Int, name: String, xp: Double = 0, confidence: Double = 0.5, strategy: TradingStrategy, wins: Int = 0, losses: Int = 0, totalTrades: Int = 0, profitLoss: Double = 0, learningHistory: [LearningSession] = [], lastTraining: Date? = nil, isActive: Bool = true, specialization: BotSpecialization) {
            self.botNumber = botNumber
            self.name = name
            self.xp = xp
            self.confidence = confidence
            self.strategy = strategy
            self.wins = wins
            self.losses = losses
            self.totalTrades = totalTrades
            self.profitLoss = profitLoss
            self.learningHistory = learningHistory
            self.lastTraining = lastTraining
            self.isActive = isActive
            self.specialization = specialization
        }
    }
    
    enum TradingStrategy: String, CaseIterable, Codable {
        case scalping = "Scalping"
        case dayTrading = "Day Trading"
        case swingTrading = "Swing Trading"
        case momentum = "Momentum"
        case meanReversion = "Mean Reversion"
        case breakout = "Breakout"
        case trendFollowing = "Trend Following"
        case arbitrage = "Arbitrage"
        case gridTrading = "Grid Trading"
        case neuralNetwork = "Neural Network"
        case sentimentAnalysis = "Sentiment Analysis"
        case technicalAnalysis = "Technical Analysis"
        case fundamentalAnalysis = "Fundamental Analysis"
        case quantitative = "Quantitative"
        case highFrequency = "High Frequency"
    }
    
    enum BotSpecialization: String, CaseIterable, Codable {
        case technical = "Technical Analysis"
        case fundamental = "Fundamental Analysis"
        case sentiment = "Sentiment Analysis"
        case risk = "Risk Management"
        case volume = "Volume Analysis"
        case momentum = "Momentum Trading"
        case scalping = "Scalping Expert"
        case longTerm = "Long-term Strategy"
        case volatility = "Volatility Trading"
        case correlation = "Correlation Analysis"
        case macroeconomic = "Macroeconomic Analysis"
        case newsTrading = "News Trading"
        case algorithmicHFT = "High-Frequency Trading"
        case patternRecognition = "Pattern Recognition"
        case aiPrediction = "AI Prediction"
    }
    
    struct ArmyStats {
        let activeBots: Int
        let overallWinRate: Double
        let totalProfitLoss: Double
        let averageConfidence: Double
        let totalXP: Double
        let godlikeBots: Int
        let eliteBots: Int
        let veteranBots: Int
        let rookieBots: Int
        
        init(activeBots: Int = 0, overallWinRate: Double = 0, totalProfitLoss: Double = 0, averageConfidence: Double = 0, totalXP: Double = 0, godlikeBots: Int = 0, eliteBots: Int = 0, veteranBots: Int = 0, rookieBots: Int = 0) {
            self.activeBots = activeBots
            self.overallWinRate = overallWinRate
            self.totalProfitLoss = totalProfitLoss
            self.averageConfidence = averageConfidence
            self.totalXP = totalXP
            self.godlikeBots = godlikeBots
            self.eliteBots = eliteBots
            self.veteranBots = veteranBots
            self.rookieBots = rookieBots
        }
    }
    
    class CSVImporter: ObservableObject {
        @Published var isImporting = false
        @Published var progress: Double = 0.0
        @Published var lastImportedData: [GoldDataPoint] = []
        @Published var importStatus: String = ""
        
        func importData(from content: String) async throws -> [GoldDataPoint] {
            return []
        }
    }
    
    // MARK: - VPS Integration Types
    
    struct VPSConfig: Codable {
        let host: String
        let username: String
        let keyPath: String
        let mt5Path: String
        let dataPath: String
        let isConnected: Bool
        
        init(host: String, username: String, keyPath: String, mt5Path: String = "/root/.wine/drive_c/Program Files/MetaTrader 5", dataPath: String = "/root/mt5_data", isConnected: Bool = false) {
            self.host = host
            self.username = username
            self.keyPath = keyPath
            self.mt5Path = mt5Path
            self.dataPath = dataPath
            self.isConnected = isConnected
        }
    }
    
    struct MT5Credentials: Codable {
        let login: String
        let server: String
        let password: String
        
        init(login: String, server: String, password: String) {
            self.login = login
            self.server = server
            self.password = password
        }
    }
}

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

extension SharedTypes.FlipGoal {
    static let sampleGoals: [SharedTypes.FlipGoal] = [
        SharedTypes.FlipGoal(
            startBalance: 1000.0,
            targetBalance: 10000.0,
            startDate: Date().addingTimeInterval(-86400 * 7),
            targetDate: Date().addingTimeInterval(86400 * 23),
            currentBalance: 2450.0
        ),
        SharedTypes.FlipGoal(
            startBalance: 500.0,
            targetBalance: 2000.0,
            startDate: Date().addingTimeInterval(-86400 * 3),
            targetDate: Date().addingTimeInterval(86400 * 12),
            currentBalance: 750.0
        )
    ]
}

// MARK: - Preview Provider

struct SharedTypesPreview: PreviewProvider {
    static var previews: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Account Preview
                VStack(alignment: .leading, spacing: 12) {
                    Text("Sample Trading Account")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Account:")
                                .fontWeight(.medium)
                            Spacer()
                            Text("123456")
                        }
                        
                        HStack {
                            Text("Broker:")
                                .fontWeight(.medium)
                            Spacer()
                            Text("Coinexx")
                                .foregroundColor(.orange)
                        }
                        
                        HStack {
                            Text("Balance:")
                                .fontWeight(.medium)
                            Spacer()
                            Text("$1000.50")
                        }
                        
                        HStack {
                            Text("Status:")
                                .fontWeight(.medium)
                            Spacer()
                            Text("Connected")
                                .foregroundColor(.green)
                        }
                    }
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(12)
                
                // Flip Goal Preview
                VStack(alignment: .leading, spacing: 12) {
                    Text("Sample Flip Goal")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Start:")
                                .fontWeight(.medium)
                            Spacer()
                            Text("$1000.00")
                        }
                        
                        HStack {
                            Text("Target:")
                                .fontWeight(.medium)
                            Spacer()
                            Text("$10000.00")
                        }
                        
                        HStack {
                            Text("Current:")
                                .fontWeight(.medium)
                            Spacer()
                            Text("$2500.00")
                        }
                        
                        HStack {
                            Text("Progress:")
                                .fontWeight(.medium)
                            Spacer()
                            Text("25.0%")
                                .foregroundColor(.orange)
                        }
                    }
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(12)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Shared Types")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct SharedTypes_Previews: PreviewProvider {
    static var previews: some View {
        SharedTypesPreview.previews
    }
}