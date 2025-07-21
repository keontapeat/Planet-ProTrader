//
//  SharedTypes.swift
//  Planet ProTrader
//
//  Updated by AI Assistant on 1/25/25.
//

import Foundation
import SwiftUI
import Planet_ProTrader

// MARK: - SharedTypes Namespace (Keep existing unique types)

enum SharedTypes {
    
    // MARK: - Type Aliases for Consistency
    enum BrokerType: String, CaseIterable, Codable {
        case mt5 = "MetaTrader 5"
        case mt4 = "MetaTrader 4"
        case coinexx = "Coinexx"
        case tradeLocker = "TradeLocker"
        case xtb = "XTB"
        case hankotrade = "HankoTrade"
        case manual = "Manual"
        case forex = "Forex"
        
        var displayName: String {
            return rawValue
        }
    }
    
    enum TradeDirection: String, CaseIterable, Codable {
        case buy = "BUY"
        case sell = "SELL"
        
        var displayName: String {
            return rawValue
        }
        
        var color: Color {
            switch self {
            case .buy: return .green
            case .sell: return .red
            }
        }
        
        var arrow: String {
            switch self {
            case .buy: return "arrow.up.circle.fill"
            case .sell: return "arrow.down.circle.fill"
            }
        }
    }
    
    enum TradingMode: String, CaseIterable, Codable {
        case auto = "Auto"
        case manual = "Manual"
        case semiAuto = "Semi-Auto"
        
        var displayName: String {
            return rawValue
        }
    }
    
    enum TradeGrade: String, CaseIterable, Codable {
        case excellent = "A+"
        case good = "A"
        case average = "B"
        case poor = "C"
        case failed = "F"
        
        var color: Color {
            switch self {
            case .excellent: return .green
            case .good: return .mint
            case .average: return .yellow
            case .poor: return .orange
            case .failed: return .red
            }
        }
    }
    
    enum MarketSession: String, CaseIterable, Codable {
        case london = "London"
        case newYork = "New York"
        case tokyo = "Tokyo"
        case sydney = "Sydney"
        
        var displayName: String {
            return rawValue
        }
    }
    
    // Keep only types that are used with SharedTypes namespace prefix
    // All duplicate types moved to ConsolidatedSharedTypes.swift
    
    struct ActiveFlip: Identifiable, Codable {
        let id: UUID
        let goalId: UUID
        let startBalance: Double
        let targetBalance: Double
        let currentBalance: Double
        let progress: Double
        let daysRemaining: Int
        let strategy: String
        
        init(
            id: UUID = UUID(),
            goalId: UUID = UUID(),
            startBalance: Double,
            targetBalance: Double,
            currentBalance: Double,
            progress: Double,
            daysRemaining: Int,
            strategy: String = "Day Trading"
        ) {
            self.id = id
            self.goalId = goalId
            self.startBalance = startBalance
            self.targetBalance = targetBalance
            self.currentBalance = currentBalance
            self.progress = progress
            self.daysRemaining = daysRemaining
            self.strategy = strategy
        }
    }
    
    struct AutoTradingStatus: Identifiable, Codable {
        let id: UUID
        let isActive: Bool
        let mode: String
        let lastUpdate: Date
        let performance: Double
        let tradesCount: Int
        
        init(
            id: UUID = UUID(),
            isActive: Bool = false,
            mode: String = "Auto",
            lastUpdate: Date = Date(),
            performance: Double = 0.0,
            tradesCount: Int = 0
        ) {
            self.id = id
            self.isActive = isActive
            self.mode = mode
            self.lastUpdate = lastUpdate
            self.performance = performance
            self.tradesCount = tradesCount
        }
    }
    
    struct ConnectedAccount: Identifiable, Codable {
        let id: UUID
        let name: String
        let type: String
        let balance: Double
        let equity: Double
        let isConnected: Bool
        let lastSync: Date
        
        init(
            id: UUID = UUID(),
            name: String,
            type: String,
            balance: Double,
            equity: Double,
            isConnected: Bool = false,
            lastSync: Date = Date()
        ) {
            self.id = id
            self.name = name
            self.type = type
            self.balance = balance
            self.equity = equity
            self.isConnected = isConnected
            self.lastSync = lastSync
        }
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
    }
    
    struct TradingSession: Identifiable, Codable {
        let id: UUID
        let name: String
        let startTime: Date
        let endTime: Date
        let isActive: Bool
        let timezone: String
        
        init(
            id: UUID = UUID(),
            name: String,
            startTime: Date,
            endTime: Date,
            isActive: Bool = false,
            timezone: String = "UTC"
        ) {
            self.id = id
            self.name = name
            self.startTime = startTime
            self.endTime = endTime
            self.isActive = isActive
            self.timezone = timezone
        }
    }
    
    struct AIInsight: Identifiable, Codable {
        let id: UUID
        let title: String
        let description: String
        let confidence: Double
        let timestamp: Date
        let priority: String
        let category: String
        
        init(
            id: UUID = UUID(),
            title: String,
            description: String,
            confidence: Double,
            timestamp: Date = Date(),
            priority: String = "medium",
            category: String = "Market Analysis"
        ) {
            self.id = id
            self.title = title
            self.description = description
            self.confidence = confidence
            self.timestamp = timestamp
            self.priority = priority
            self.category = category
        }
    }
    
    struct RecentActivity: Identifiable, Codable {
        let id: UUID
        let type: String
        let description: String
        let timestamp: Date
        let icon: String
        
        init(
            id: UUID = UUID(),
            type: String,
            description: String,
            timestamp: Date = Date(),
            icon: String = "clock"
        ) {
            self.id = id
            self.type = type
            self.description = description
            self.timestamp = timestamp
            self.icon = icon
        }
    }
    
    struct TradingOpportunity: Identifiable, Codable {
        let id: UUID
        let symbol: String
        let direction: String
        let confidence: Double
        let entryPrice: Double
        let targetPrice: Double
        let stopLoss: Double
        let reasoning: String
        let timestamp: Date
        
        init(
            id: UUID = UUID(),
            symbol: String,
            direction: String,
            confidence: Double,
            entryPrice: Double,
            targetPrice: Double,
            stopLoss: Double,
            reasoning: String,
            timestamp: Date = Date()
        ) {
            self.id = id
            self.symbol = symbol
            self.direction = direction
            self.confidence = confidence
            self.entryPrice = entryPrice
            self.targetPrice = targetPrice
            self.stopLoss = stopLoss
            self.reasoning = reasoning
            self.timestamp = timestamp
        }
    }
    
    // MARK: - Core Structs
    
    struct EAStats: Identifiable, Codable {
        let id: UUID
        let name: String
        let totalTrades: Int
        let winRate: Double
        let totalProfit: Double
        let isActive: Bool
        let lastUpdate: Date
        
        init(
            id: UUID = UUID(),
            name: String,
            totalTrades: Int = 0,
            winRate: Double = 0.0,
            totalProfit: Double = 0.0,
            isActive: Bool = false,
            lastUpdate: Date = Date()
        ) {
            self.id = id
            self.name = name
            self.totalTrades = totalTrades
            self.winRate = winRate
            self.totalProfit = totalProfit
            self.isActive = isActive
            self.lastUpdate = lastUpdate
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
        
        init(
            id: UUID = UUID(),
            symbol: String,
            direction: TradeDirection,
            entryPrice: Double,
            exitPrice: Double,
            profit: Double,
            grade: TradeGrade,
            timestamp: Date = Date()
        ) {
            self.id = id
            self.symbol = symbol
            self.direction = direction
            self.entryPrice = entryPrice
            self.exitPrice = exitPrice
            self.profit = profit
            self.grade = grade
            self.timestamp = timestamp
        }
    }
    
    struct AutoTrade: Identifiable, Codable {
        let id: UUID
        let symbol: String
        let direction: TradeDirection
        let volume: Double
        let entryPrice: Double
        let currentPrice: Double
        let stopLoss: Double?
        let takeProfit: Double?
        let profit: Double
        let isOpen: Bool
        let openTime: Date
        let closeTime: Date?
        
        init(
            id: UUID = UUID(),
            symbol: String,
            direction: TradeDirection,
            volume: Double,
            entryPrice: Double,
            currentPrice: Double,
            stopLoss: Double? = nil,
            takeProfit: Double? = nil,
            profit: Double = 0,
            isOpen: Bool = true,
            openTime: Date = Date(),
            closeTime: Date? = nil
        ) {
            self.id = id
            self.symbol = symbol
            self.direction = direction
            self.volume = volume
            self.entryPrice = entryPrice
            self.currentPrice = currentPrice
            self.stopLoss = stopLoss
            self.takeProfit = takeProfit
            self.profit = profit
            self.isOpen = isOpen
            self.openTime = openTime
            self.closeTime = closeTime
        }
    }
    
    enum LearningCapability: String, CaseIterable, Codable {
        case patternRecognition = "Pattern Recognition"
        case riskManagement = "Risk Management"
        case technicalAnalysis = "Technical Analysis"
        case fundamentalAnalysis = "Fundamental Analysis"
        case sentimentAnalysis = "Sentiment Analysis"
        case marketTiming = "Market Timing"
        
        var description: String {
            switch self {
            case .patternRecognition: return "Identifies recurring market patterns"
            case .riskManagement: return "Optimizes risk-reward ratios"
            case .technicalAnalysis: return "Analyzes price action and indicators"
            case .fundamentalAnalysis: return "Evaluates economic factors"
            case .sentimentAnalysis: return "Gauges market sentiment"
            case .marketTiming: return "Times market entry and exit"
            }
        }
        
        var icon: String {
            switch self {
            case .patternRecognition: return "waveform.path.ecg"
            case .riskManagement: return "shield.fill"
            case .technicalAnalysis: return "chart.line.uptrend.xyaxis"
            case .fundamentalAnalysis: return "doc.text.fill"
            case .sentimentAnalysis: return "brain.head.profile"
            case .marketTiming: return "clock.fill"
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

    struct TradingAccountDetails: Identifiable, Codable {
        let id: UUID
        let accountNumber: String
        let accountName: String
        let brokerType: BrokerType
        let serverName: String
        let balance: Double
        let equity: Double
        let isDemo: Bool
        let isConnected: Bool
        
        init(
            id: UUID = UUID(),
            accountNumber: String,
            accountName: String,
            brokerType: BrokerType,
            serverName: String,
            balance: Double,
            equity: Double,
            isDemo: Bool,
            isConnected: Bool = false
        ) {
            self.id = id
            self.accountNumber = accountNumber
            self.accountName = accountName
            self.brokerType = brokerType
            self.serverName = serverName
            self.balance = balance
            self.equity = equity
            self.isDemo = isDemo
            self.isConnected = isConnected
        }
        
        // Computed properties
        var name: String {
            return accountName
        }
        
        var formattedBalance: String {
            return String(format: "$%.2f", balance)
        }
        
        var server: String {
            return serverName
        }
        
        var accountTypeText: String {
            return isDemo ? "DEMO" : "LIVE"
        }
        
        var accountTypeColor: Color {
            return isDemo ? .orange : .green
        }
        
        enum AccountType {
            case demo
            case live
        }
        
        var accountType: AccountType {
            return isDemo ? .demo : .live
        }
    }
    
    struct FlipGoal: Identifiable, Codable {
        let id: UUID
        let name: String
        let startAmount: Double
        let targetAmount: Double
        let currentAmount: Double
        let startDate: Date
        let targetDate: Date
        let strategy: String
        
        init(
            id: UUID = UUID(),
            name: String,
            startAmount: Double,
            targetAmount: Double,
            currentAmount: Double = 0,
            startDate: Date = Date(),
            targetDate: Date,
            strategy: String
        ) {
            self.id = id
            self.name = name
            self.startAmount = startAmount
            self.targetAmount = targetAmount
            self.currentAmount = currentAmount
            self.startDate = startDate
            self.targetDate = targetDate
            self.strategy = strategy
        }
        
        var progress: Double {
            guard targetAmount > startAmount else { return 0 }
            return (currentAmount - startAmount) / (targetAmount - startAmount)
        }
        
        var formattedProgress: String {
            return String(format: "%.1f%%", progress * 100)
        }
    }
    
} // End SharedTypes namespace

#Preview {
    VStack {
        Text("SharedTypes Preview")
            .font(.title)
        
        Text("Consolidated type definitions")
            .font(.caption)
    }
    .padding()
}