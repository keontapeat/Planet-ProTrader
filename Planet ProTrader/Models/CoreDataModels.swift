//
//  CoreDataModels.swift
//  Planet ProTrader - Essential Data Models
//
//  Single Source of Truth for All Data Models
//  Created by Elite Engineering Team
//

import SwiftUI
import Foundation
import Combine

// MARK: - Trading Bot Model (Complete)

struct TradingBot: Identifiable, Codable, Equatable {
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
    
    // Additional Properties for UI
    let status: BotStatus
    let profit: Double
    let icon: String
    let primaryColor: String
    let secondaryColor: String
    
    // Computed Properties
    var statusColor: Color { status.color }
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
    
    // Initializer
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
}

// MARK: - Trading Strategy Enum

extension TradingBot {
    enum TradingStrategy: String, Codable, CaseIterable {
        case scalping = "Scalping"
        case swing = "Swing Trading"
        case dayTrading = "Day Trading"
        case news = "News Trading"
        case momentum = "Momentum"
        case reversal = "Reversal"
        case arbitrage = "Arbitrage"
        case martingale = "Martingale"
        case gridTrading = "Grid Trading"
        case copyTrading = "Copy Trading"
        
        var displayName: String { rawValue }
        
        var description: String {
            switch self {
            case .scalping: return "Quick trades for small profits"
            case .swing: return "Medium-term position trading"
            case .dayTrading: return "Intraday trading strategies"
            case .news: return "Event-driven trading"
            case .momentum: return "Trend following system"
            case .reversal: return "Counter-trend trading"
            case .arbitrage: return "Price difference exploitation"
            case .martingale: return "Progressive position sizing"
            case .gridTrading: return "Systematic grid orders"
            case .copyTrading: return "Mirror successful traders"
            }
        }
        
        var icon: String {
            switch self {
            case .scalping: return "bolt.fill"
            case .swing: return "waveform.path"
            case .dayTrading: return "clock.fill"
            case .news: return "newspaper.fill"
            case .momentum: return "arrow.up.right.circle.fill"
            case .reversal: return "arrow.turn.up.left"
            case .arbitrage: return "arrow.left.arrow.right"
            case .martingale: return "chart.line.uptrend.xyaxis"
            case .gridTrading: return "grid"
            case .copyTrading: return "person.2.fill"
            }
        }
        
        var color: Color {
            switch self {
            case .scalping: return .red
            case .swing: return .green
            case .dayTrading: return .blue
            case .news: return .orange
            case .momentum: return .purple
            case .reversal: return .pink
            case .arbitrage: return .cyan
            case .martingale: return .indigo
            case .gridTrading: return .mint
            case .copyTrading: return .teal
            }
        }
    }
}

// MARK: - Core Enums

enum BotStatus: String, Codable, CaseIterable {
    case trading = "Trading"
    case analyzing = "Analyzing" 
    case active = "Active"
    case learning = "Learning"
    case inactive = "Inactive"
    case stopped = "Stopped"
    case error = "Error"
    case backtesting = "Backtesting"
    case optimizing = "Optimizing"
    case paused = "Paused"
    
    var color: Color {
        switch self {
        case .trading, .active: return .green
        case .analyzing, .learning, .backtesting, .optimizing: return .blue
        case .inactive, .stopped, .paused: return .gray
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
        case .backtesting: return "clock.arrow.circlepath"
        case .optimizing: return "gearshape.2.fill"
        case .paused: return "pause.circle.fill"
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
    
    var maxPositionSize: Double {
        switch self {
        case .veryLow: return 0.01
        case .low: return 0.02
        case .medium: return 0.05
        case .high: return 0.1
        case .extreme: return 0.2
        }
    }
}

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
}

enum TradeStatus: String, Codable, CaseIterable {
    case pending = "Pending"
    case open = "Open"
    case closed = "Closed"
    case cancelled = "Cancelled"
    case win = "Win"
    case loss = "Loss"
    case breakeven = "Breakeven"
    
    var color: Color {
        switch self {
        case .pending: return .orange
        case .open: return .blue
        case .closed: return .gray
        case .cancelled: return .red
        case .win: return .green
        case .loss: return .red
        case .breakeven: return .yellow
        }
    }
    
    var icon: String {
        switch self {
        case .pending: return "clock.fill"
        case .open: return "play.circle.fill"
        case .closed: return "checkmark.circle.fill"
        case .cancelled: return "xmark.circle.fill"
        case .win: return "arrow.up.circle.fill"
        case .loss: return "arrow.down.circle.fill"
        case .breakeven: return "minus.circle.fill"
        }
    }
}

// MARK: - Trading Account Model

struct TradingAccount: Identifiable, Codable {
    let id: UUID
    let accountNumber: String
    let broker: String
    let accountType: AccountType
    let balance: Double
    let equity: Double
    let freeMargin: Double
    let leverage: Int
    let currency: String
    let isActive: Bool
    let lastUpdate: Date
    
    enum AccountType: String, Codable, CaseIterable {
        case demo = "Demo"
        case live = "Live"
        case contest = "Contest"
        case paper = "Paper"
        
        var color: Color {
            switch self {
            case .demo: return .orange
            case .live: return .green
            case .contest: return .purple
            case .paper: return .gray
            }
        }
        
        var icon: String {
            switch self {
            case .demo: return "play.circle.fill"
            case .live: return "bolt.circle.fill"
            case .contest: return "trophy.circle.fill"
            case .paper: return "doc.circle.fill"
            }
        }
    }
    
    init(
        id: UUID = UUID(),
        accountNumber: String,
        broker: String,
        accountType: AccountType = .demo,
        balance: Double = 10000.0,
        equity: Double = 10000.0,
        freeMargin: Double = 9500.0,
        leverage: Int = 500,
        currency: String = "USD",
        isActive: Bool = false,
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
    
    var displayName: String {
        return "\(broker) \(accountType.rawValue)"
    }
    
    var isDemo: Bool {
        return accountType == .demo || accountType == .paper
    }
    
    var formattedBalance: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currency
        return formatter.string(from: NSNumber(value: balance)) ?? "\(currency) 0.00"
    }
    
    var formattedEquity: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currency
        return formatter.string(from: NSNumber(value: equity)) ?? "\(currency) 0.00"
    }
    
    var marginLevel: Double {
        let usedMargin = balance - freeMargin
        return usedMargin > 0 ? (equity / usedMargin) * 100 : 0
    }
    
    var profitLoss: Double {
        return equity - balance
    }
    
    var formattedProfitLoss: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currency
        formatter.positivePrefix = "+"
        return formatter.string(from: NSNumber(value: profitLoss)) ?? "\(currency) 0.00"
    }
}

// MARK: - Market Data Model

struct MarketData: Identifiable, Codable {
    let id: UUID
    let symbol: String
    let currentPrice: Double
    let change24h: Double
    let changePercentage: Double
    let high24h: Double
    let low24h: Double
    let volume: Double
    let lastUpdated: Date
    let bid: Double
    let ask: Double
    let spread: Double
    
    init(
        id: UUID = UUID(),
        symbol: String,
        currentPrice: Double,
        change24h: Double,
        changePercentage: Double,
        high24h: Double,
        low24h: Double,
        volume: Double,
        lastUpdated: Date = Date(),
        bid: Double? = nil,
        ask: Double? = nil
    ) {
        self.id = id
        self.symbol = symbol
        self.currentPrice = currentPrice
        self.change24h = change24h
        self.changePercentage = changePercentage
        self.high24h = high24h
        self.low24h = low24h
        self.volume = volume
        self.lastUpdated = lastUpdated
        self.bid = bid ?? (currentPrice - 0.5)
        self.ask = ask ?? (currentPrice + 0.5)
        self.spread = self.ask - self.bid
    }
    
    var formattedPrice: String {
        String(format: "%.2f", currentPrice)
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
    
    var trend: TrendDirection {
        if changePercentage > 1.0 { return .strongUp }
        else if changePercentage > 0.1 { return .up }
        else if changePercentage < -1.0 { return .strongDown }
        else if changePercentage < -0.1 { return .down }
        else { return .sideways }
    }
    
    enum TrendDirection {
        case strongUp, up, sideways, down, strongDown
        
        var color: Color {
            switch self {
            case .strongUp: return .green
            case .up: return .green.opacity(0.7)
            case .sideways: return .gray
            case .down: return .red.opacity(0.7)
            case .strongDown: return .red
            }
        }
        
        var icon: String {
            switch self {
            case .strongUp: return "arrow.up.circle.fill"
            case .up: return "arrow.up.circle"
            case .sideways: return "minus.circle"
            case .down: return "arrow.down.circle"
            case .strongDown: return "arrow.down.circle.fill"
            }
        }
    }
}

// MARK: - Gold Signal Model

struct GoldSignal: Identifiable, Codable {
    let id: UUID
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
    let source: SignalSource
    
    enum SignalStatus: String, CaseIterable, Codable {
        case pending = "Pending"
        case active = "Active"
        case filled = "Filled"
        case cancelled = "Cancelled"
        case expired = "Expired"
        case partiallyFilled = "Partially Filled"
        
        var color: Color {
            switch self {
            case .pending: return .orange
            case .active: return .blue
            case .filled: return .green
            case .cancelled: return .red
            case .expired: return .gray
            case .partiallyFilled: return .yellow
            }
        }
        
        var icon: String {
            switch self {
            case .pending: return "clock.fill"
            case .active: return "play.circle.fill"
            case .filled: return "checkmark.circle.fill"
            case .cancelled: return "xmark.circle.fill"
            case .expired: return "clock.badge.xmark.fill"
            case .partiallyFilled: return "circle.righthalf.fill"
            }
        }
    }
    
    enum SignalSource: String, CaseIterable, Codable {
        case ai = "AI Engine"
        case technical = "Technical Analysis"
        case fundamental = "Fundamental Analysis"
        case sentiment = "Market Sentiment"
        case news = "News Analysis"
        case pattern = "Pattern Recognition"
        case custom = "Custom Strategy"
        
        var icon: String {
            switch self {
            case .ai: return "brain.head.profile.fill"
            case .technical: return "chart.line.uptrend.xyaxis"
            case .fundamental: return "building.columns.fill"
            case .sentiment: return "person.3.fill"
            case .news: return "newspaper.fill"
            case .pattern: return "eye.fill"
            case .custom: return "gearshape.fill"
            }
        }
        
        var color: Color {
            switch self {
            case .ai: return DesignSystem.primaryGold
            case .technical: return .blue
            case .fundamental: return .green
            case .sentiment: return .purple
            case .news: return .orange
            case .pattern: return .red
            case .custom: return .gray
            }
        }
    }
    
    init(
        id: UUID = UUID(),
        timestamp: Date = Date(),
        type: TradeDirection,
        entryPrice: Double,
        stopLoss: Double,
        takeProfit: Double,
        confidence: Double,
        reasoning: String,
        timeframe: String = "H1",
        status: SignalStatus = .pending,
        accuracy: Double? = nil,
        source: SignalSource = .ai
    ) {
        self.id = id
        self.timestamp = timestamp
        self.type = type
        self.entryPrice = entryPrice
        self.stopLoss = stopLoss
        self.takeProfit = takeProfit
        self.confidence = max(0, min(1, confidence))
        self.reasoning = reasoning
        self.timeframe = timeframe
        self.status = status
        self.accuracy = accuracy
        self.source = source
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
    
    var potentialRisk: Double {
        abs(entryPrice - stopLoss)
    }
    
    var potentialReward: Double {
        abs(takeProfit - entryPrice)
    }
    
    var formattedPotentialRisk: String {
        String(format: "$%.2f", potentialRisk)
    }
    
    var formattedPotentialReward: String {
        String(format: "$%.2f", potentialReward)
    }
}

// MARK: - Sample Data Extensions

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
            name: "News Hunter AI",
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
        ),
        TradingBot(
            name: "Momentum Master",
            strategy: .momentum,
            riskLevel: .medium,
            isActive: true,
            winRate: 0.91,
            totalTrades: 75,
            profitLoss: 4100.0,
            performance: 22.1,
            status: .learning,
            icon: "bolt.fill",
            primaryColor: "#9370DB",
            secondaryColor: "#8A2BE2"
        ),
        TradingBot(
            name: "Grid Arbitrage",
            strategy: .gridTrading,
            riskLevel: .extreme,
            isActive: false,
            winRate: 0.67,
            totalTrades: 300,
            profitLoss: 1200.0,
            performance: 8.9,
            status: .stopped,
            icon: "grid",
            primaryColor: "#32CD32",
            secondaryColor: "#228B22"
        )
    ]
}

extension TradingAccount {
    static let sampleAccounts: [TradingAccount] = [
        TradingAccount(
            accountNumber: "12345678",
            broker: "MetaTrader 5",
            accountType: .demo,
            balance: 10000.0,
            equity: 11247.85,
            freeMargin: 9500.0,
            leverage: 500,
            currency: "USD",
            isActive: true
        ),
        TradingAccount(
            accountNumber: "87654321",
            broker: "OANDA",
            accountType: .live,
            balance: 5000.0,
            equity: 5234.50,
            freeMargin: 4800.0,
            leverage: 100,
            currency: "USD",
            isActive: false
        )
    ]
}

extension GoldSignal {
    static let sampleSignals: [GoldSignal] = [
        GoldSignal(
            type: .buy,
            entryPrice: 2374.85,
            stopLoss: 2364.50,
            takeProfit: 2395.20,
            confidence: 0.89,
            reasoning: "Strong bullish momentum confirmed by multiple timeframe analysis",
            timeframe: "H1",
            status: .active,
            source: .ai
        ),
        GoldSignal(
            type: .sell,
            entryPrice: 2378.20,
            stopLoss: 2385.00,
            takeProfit: 2365.50,
            confidence: 0.76,
            reasoning: "Resistance level reached, bearish divergence detected",
            timeframe: "M15",
            status: .pending,
            accuracy: 0.82,
            source: .technical
        ),
        GoldSignal(
            type: .buy,
            entryPrice: 2370.50,
            stopLoss: 2360.00,
            takeProfit: 2390.00,
            confidence: 0.94,
            reasoning: "Major news event creating bullish sentiment",
            timeframe: "H4",
            status: .filled,
            accuracy: 0.95,
            source: .news
        )
    ]
}

// MARK: - Previews

#Preview("Trading Bot Card") {
    VStack(spacing: 16) {
        ForEach(TradingBot.sampleBots.prefix(2)) { bot in
            HStack(spacing: 12) {
                Circle()
                    .fill(Color(hex: bot.primaryColor) ?? DesignSystem.primaryGold)
                    .frame(width: 50, height: 50)
                    .overlay(
                        Image(systemName: bot.icon)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(bot.name)
                        .font(.headline.bold())
                    
                    Text(bot.strategy.displayName)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        Circle()
                            .fill(bot.status.color)
                            .frame(width: 8, height: 8)
                        
                        Text(bot.status.rawValue)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("+\(String(format: "%.1f", bot.performance))%")
                        .font(.title3.bold())
                        .foregroundColor(.green)
                    
                    Text(bot.formattedProfit)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
    .padding()
    .preferredColorScheme(.light)
}