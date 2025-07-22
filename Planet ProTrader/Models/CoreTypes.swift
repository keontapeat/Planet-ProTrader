//
//  CoreTypes.swift  
//  Planet ProTrader
//
//  SINGLE SOURCE OF TRUTH for all types
//  Replaces SharedTypes.swift and MasterSharedTypes.swift conflicts
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
    case scalping = "Scalping"
    case swing = "Swing"
    case conservative = "Conservative"
    case aggressive = "Aggressive"
    
    var displayName: String { rawValue }
    
    var icon: String {
        switch self {
        case .auto: return "gearshape.2.fill"
        case .manual: return "hand.point.up.fill"
        case .scalping: return "bolt.fill"
        case .swing: return "waveform.path"
        case .conservative: return "shield.fill"
        case .aggressive: return "flame.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .auto: return .blue
        case .manual: return .orange
        case .scalping: return .red
        case .swing: return .green
        case .conservative: return .cyan
        case .aggressive: return .purple
        }
    }
}

enum BrokerType: String, Codable, CaseIterable {
    case mt5 = "MT5"
    case mt4 = "MT4"
    case coinexx = "Coinexx"
    case forex = "Forex.com"
    case manual = "Manual"
    
    var displayName: String { rawValue }
    
    var icon: String {
        switch self {
        case .mt5, .mt4: return "chart.bar"
        case .coinexx: return "bitcoinsign.circle"
        case .forex: return "dollarsign.circle"
        case .manual: return "hand.point.up"
        }
    }
    
    var color: Color {
        switch self {
        case .mt5, .mt4: return .blue
        case .coinexx: return .orange
        case .forex: return .green
        case .manual: return .gray
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
    
    var color: Color {
        switch self {
        case .pending: return .orange
        case .open: return .blue
        case .closed: return .gray
        case .cancelled: return .red
        case .win: return .green
        case .loss: return .red
        }
    }
}

enum RiskLevel: Int, Codable, CaseIterable {
    case veryLow = 1
    case low = 2
    case medium = 3
    case high = 4
    case extreme = 5
    
    var displayName: String {
        switch self {
        case .veryLow: return "Very Low"
        case .low: return "Low"
        case .medium: return "Medium"
        case .high: return "High"
        case .extreme: return "Extreme"
        }
    }
    
    var color: Color {
        switch self {
        case .veryLow: return .green
        case .low: return .blue
        case .medium: return .orange
        case .high: return .red
        case .extreme: return .purple
        }
    }
    
    var multiplier: Double {
        switch self {
        case .veryLow: return 0.5
        case .low: return 0.75
        case .medium: return 1.0
        case .high: return 1.5
        case .extreme: return 2.0
        }
    }
}

// MARK: - Bot Status Enum

enum BotStatus: String, Codable, CaseIterable {
    case trading = "Trading"
    case analyzing = "Analyzing"
    case active = "Active"
    case learning = "Learning"
    case inactive = "Inactive"
    case stopped = "Stopped"
    case error = "Error"
    
    var color: Color {
        switch self {
        case .trading, .active: return .green
        case .analyzing, .learning: return .blue
        case .inactive, .stopped: return .gray
        case .error: return .red
        }
    }
    
    var icon: String {
        switch self {
        case .trading: return "chart.line.uptrend.xyaxis"
        case .analyzing: return "brain.head.profile"
        case .active: return "play.circle.fill"
        case .learning: return "book.circle"
        case .inactive: return "pause.circle"
        case .stopped: return "stop.circle"
        case .error: return "exclamationmark.triangle"
        }
    }
}

// MARK: - Core Data Models

struct TradingBot: Identifiable, Codable {
    let id: UUID
    let name: String
    let strategy: TradingStrategy
    let riskLevel: RiskLevel
    let isActive: Bool
    let winRate: Double
    let totalTrades: Int
    let profitLoss: Double
    let performance: Double
    let lastUpdate: Date
    
    let status: BotStatus
    let profit: Double
    let icon: String
    let primaryColor: String
    let secondaryColor: String
    
    enum TradingStrategy: String, Codable, CaseIterable {
        case scalping = "Scalping"
        case swing = "Swing Trading"
        case dayTrading = "Day Trading"
        case news = "News Trading"
        case momentum = "Momentum"
        case reversal = "Reversal"
        
        var displayName: String { rawValue }
    }
    
    init(
        id: UUID = UUID(),
        name: String,
        strategy: TradingStrategy,
        riskLevel: RiskLevel = .medium,
        isActive: Bool = false,
        winRate: Double = 0.0,
        totalTrades: Int = 0,
        profitLoss: Double = 0.0,
        performance: Double = 0.0,
        lastUpdate: Date = Date(),
        status: BotStatus = .inactive,
        profit: Double? = nil,
        icon: String = "brain.head.profile",
        primaryColor: String = "#FFD700",
        secondaryColor: String = "#FFA500"
    ) {
        self.id = id
        self.name = name
        self.strategy = strategy
        self.riskLevel = riskLevel
        self.isActive = isActive
        self.winRate = winRate
        self.totalTrades = totalTrades
        self.profitLoss = profitLoss
        self.performance = performance
        self.lastUpdate = lastUpdate
        self.status = status
        self.profit = profit ?? profitLoss
        self.icon = icon
        self.primaryColor = primaryColor
        self.secondaryColor = secondaryColor
    }
    
    var statusColor: Color {
        status.color
    }
    
    var performanceColor: Color {
        if performance > 15 { return .green }
        if performance > 10 { return .blue }
        if performance > 5 { return .orange }
        return .red
    }
    
    var formattedWinRate: String {
        String(format: "%.1f%%", winRate * 100)
    }
    
    var formattedProfitLoss: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: NSNumber(value: profitLoss)) ?? "$0.00"
    }
    
    var formattedProfit: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: NSNumber(value: profit)) ?? "$0.00"
    }
}

struct GoldSignal: Identifiable, Codable {
    let id = UUID()
    let timestamp: Date
    let type: TradeDirection
    let entryPrice: Double
    let stopLoss: Double
    let takeProfit: Double
    let confidence: Double
    let reasoning: String
    let timeframe: String
    let status: SignalStatus
    let accuracy: Double?
    
    enum SignalStatus: String, CaseIterable, Codable {
        case pending = "Pending"
        case active = "Active"
        case filled = "Filled"
        case cancelled = "Cancelled"
        case expired = "Expired"
        
        var color: Color {
            switch self {
            case .pending: return .orange
            case .active: return .blue
            case .filled: return .green
            case .cancelled: return .red
            case .expired: return .gray
            }
        }
    }
    
    var riskRewardRatio: Double {
        let risk = abs(entryPrice - stopLoss)
        let reward = abs(takeProfit - entryPrice)
        return risk > 0 ? reward / risk : 0
    }
    
    var formattedConfidence: String {
        String(format: "%.1f%%", confidence * 100)
    }
    
    var formattedRiskReward: String {
        String(format: "1:%.1f", riskRewardRatio)
    }
}

struct MarketData: Codable {
    let currentPrice: Double
    let change24h: Double
    let changePercentage: Double
    let high24h: Double
    let low24h: Double
    let volume: Double
    let lastUpdated: Date
    
    var formattedPrice: String {
        String(format: "$%.2f", currentPrice)
    }
    
    var formattedChange: String {
        let sign = change24h >= 0 ? "+" : ""
        return "\(sign)$\(String(format: "%.2f", change24h))"
    }
    
    var formattedChangePercentage: String {
        let sign = changePercentage >= 0 ? "+" : ""
        return "\(sign)\(String(format: "%.2f", changePercentage))%"
    }
    
    var changeColor: Color {
        change24h >= 0 ? .green : .red
    }
}

struct TradingAccountDetails: Identifiable, Codable {
    let id = UUID()
    let accountNumber: String
    let broker: BrokerType
    let accountType: String
    let balance: Double
    let equity: Double
    let freeMargin: Double
    let leverage: Int
    let isActive: Bool
    let lastUpdate: Date?
    let currency: String
    
    init(
        accountNumber: String,
        broker: BrokerType,
        accountType: String = "Demo",
        balance: Double = 10000.0,
        equity: Double = 10000.0,
        freeMargin: Double = 9500.0,
        leverage: Int = 500,
        isActive: Bool = false,
        lastUpdate: Date? = nil,
        currency: String = "USD"
    ) {
        self.accountNumber = accountNumber
        self.broker = broker
        self.accountType = accountType
        self.balance = balance
        self.equity = equity
        self.freeMargin = freeMargin
        self.leverage = leverage
        self.isActive = isActive
        self.lastUpdate = lastUpdate ?? Date()
        self.currency = currency
    }
    
    var name: String {
        return "\(broker.displayName) \(accountType)"
    }
    
    var server: String {
        switch broker {
        case .mt5: return "MT5-Server-01"
        case .mt4: return "MT4-Demo"
        case .coinexx: return "Coinexx-Live"
        case .forex: return "Forex-Demo"
        case .manual: return "Manual"
        }
    }
    
    var isDemo: Bool {
        return accountType.lowercased().contains("demo")
    }
    
    var displayName: String {
        return name
    }
    
    var formattedBalance: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currency
        return formatter.string(from: NSNumber(value: balance)) ?? "$0.00"
    }
}

struct FlipGoal: Identifiable, Codable {
    let id = UUID()
    let startAmount: Double
    let targetAmount: Double
    let timeLimit: TimeInterval
    let currentAmount: Double
    let status: FlipStatus
    let startDate: Date
    let symbol: String
    
    enum FlipStatus: String, CaseIterable, Codable {
        case active = "Active"
        case completed = "Completed"
        case failed = "Failed"
        case paused = "Paused"
        
        var color: Color {
            switch self {
            case .active: return .blue
            case .completed: return .green
            case .failed: return .red
            case .paused: return .orange
            }
        }
    }
    
    var progress: Double {
        guard targetAmount > startAmount else { return 0 }
        return min(1.0, max(0, (currentAmount - startAmount) / (targetAmount - startAmount)))
    }
    
    init(
        startAmount: Double,
        targetAmount: Double,
        timeLimit: TimeInterval,
        currentAmount: Double? = nil,
        status: FlipStatus = .active,
        symbol: String = "XAUUSD"
    ) {
        self.startAmount = startAmount
        self.targetAmount = targetAmount
        self.timeLimit = timeLimit
        self.currentAmount = currentAmount ?? startAmount
        self.status = status
        self.startDate = Date()
        self.symbol = symbol
    }
}

// MARK: - Connected Account (Referenced in TradingViewModel)
struct ConnectedAccount: Identifiable, Codable {
    let id = UUID()
    let name: String
    let balance: String
    let brokerType: BrokerType
    let isConnected: Bool
    let lastUpdate: Date
    
    init(name: String, balance: String, brokerType: BrokerType, isConnected: Bool, lastUpdate: Date = Date()) {
        self.name = name
        self.balance = balance
        self.brokerType = brokerType
        self.isConnected = isConnected
        self.lastUpdate = lastUpdate
    }
}

// MARK: - Repository Protocol

protocol TradingRepositoryProtocol {
    func subscribeToRealTimeData(for symbol: String) -> AnyPublisher<Double, Never>
    func getCurrentPrice(for symbol: String) async -> Double?
    func getHistoricalData(for symbol: String, timeframe: String) async -> [GoldSignal]
}

// MARK: - Trading Repository Protocol Implementation
extension TradingRepositoryProtocol {
    // Additional methods can be added here if needed
}

// MARK: - Sample Data (Separated from Production Code)

extension TradingBot {
    static let sampleBots: [TradingBot] = [
        TradingBot(
            name: "GoldMaster Pro",
            strategy: .scalping,
            riskLevel: .medium,
            isActive: true,
            winRate: 0.85,
            totalTrades: 150,
            profitLoss: 2500.0,
            performance: 15.2,
            status: .trading,
            icon: "crown.fill",
            primaryColor: "#FFD700",
            secondaryColor: "#FFA500"
        ),
        TradingBot(
            name: "Swing Trader Elite",
            strategy: .swing,
            riskLevel: .low,
            isActive: false,
            winRate: 0.72,
            totalTrades: 89,
            profitLoss: 1850.0,
            performance: 12.8,
            status: .inactive,
            icon: "waveform.path",
            primaryColor: "#00CED1",
            secondaryColor: "#4682B4"
        ),
        TradingBot(
            name: "News Hunter",
            strategy: .news,
            riskLevel: .high,
            isActive: true,
            winRate: 0.78,
            totalTrades: 200,
            profitLoss: 3200.0,
            performance: 18.5,
            status: .analyzing,
            icon: "newspaper.fill",
            primaryColor: "#FF6347",
            secondaryColor: "#DC143C"
        )
    ]
}

#Preview {
    VStack(spacing: 20) {
        Text(" Core Types - Single Source of Truth")
            .font(.title.bold())
            .foregroundColor(.green)
        
        Text("Consolidated all type definitions")
            .font(.subheadline)
            .foregroundColor(.secondary)
        
        VStack(alignment: .leading, spacing: 4) {
            Text("Available Types:")
                .font(.headline)
            
            Group {
                Text("• TradeDirection ")
                Text("• TradingBot (with missing properties) ")
                Text("• GoldSignal ")
                Text("• MarketData ")
                Text("• TradingAccountDetails ")
                Text("• All required enums ")
            }
            .font(.caption)
            .foregroundColor(.green)
        }
    }
    .padding()
    .background(Color(.systemGroupedBackground))
    .cornerRadius(12)
}