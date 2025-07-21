//
//  SharedTypes.swift
//  Planet ProTrader
//
//  ✅ FIXED: Complete SharedTypes - Single Source of Truth
//  Created by AI Assistant on 1/25/25.
//

import SwiftUI
import Foundation
import Combine

// MARK: - Core Trading Types

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
    
    var displayName: String { rawValue }
    
    var icon: String {
        switch self {
        case .auto: return "gearshape.2"
        case .manual: return "hand.point.up.braille"
        case .scalp: return "bolt.fill"
        case .swing: return "waveform.path"
        case .position: return "chart.line.uptrend.xyaxis"
        case .backtest: return "clock.arrow.circlepath"
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
}

// MARK: - Core Data Models

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
}

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
        lastUpdate: Date = Date()
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
    }
}

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
        isConnected: Bool = true,
        lastUpdate: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.balance = balance
        self.brokerType = brokerType
        self.isConnected = isConnected
        self.lastUpdate = lastUpdate
    }
}

struct LiveBot: Identifiable, Codable {
    let id: UUID
    let name: String
    let strategy: String
    var dailyPL: Double
    let winRate: Double
    var tradesCount: Int
    var isTrading: Bool
    var currentPosition: String
    var currentPrice: Double
    
    init(
        id: UUID = UUID(),
        name: String,
        strategy: String,
        dailyPL: Double = 0.0,
        winRate: Double = 0.0,
        tradesCount: Int = 0,
        isTrading: Bool = false,
        currentPosition: String = "",
        currentPrice: Double = 0.0
    ) {
        self.id = id
        self.name = name
        self.strategy = strategy
        self.dailyPL = dailyPL
        self.winRate = winRate
        self.tradesCount = tradesCount
        self.isTrading = isTrading
        self.currentPosition = currentPosition
        self.currentPrice = currentPrice
    }
    
    func formatPrice(_ price: Double) -> String {
        return String(format: "$%.2f", price)
    }
}

// MARK: - Sample Data for Development

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
            performance: 15.2
        ),
        TradingBot(
            name: "Swing Trader Elite",
            strategy: .swing,
            riskLevel: .low,
            isActive: false,
            winRate: 0.72,
            totalTrades: 89,
            profitLoss: 1850.0,
            performance: 12.8
        ),
        TradingBot(
            name: "News Hunter",
            strategy: .news,
            riskLevel: .high,
            isActive: true,
            winRate: 0.78,
            totalTrades: 200,
            profitLoss: 3200.0,
            performance: 18.5
        )
    ]
}

extension AutoTrade {
    static let sampleTrades: [AutoTrade] = [
        AutoTrade(
            symbol: "XAUUSD",
            direction: .buy,
            entryPrice: 2370.50,
            exitPrice: 2375.25,
            lotSize: 0.1,
            profit: 475.0,
            status: .win,
            botId: "bot-1"
        ),
        AutoTrade(
            symbol: "XAUUSD",
            direction: .sell,
            entryPrice: 2380.00,
            exitPrice: 2375.50,
            lotSize: 0.2,
            profit: 900.0,
            status: .win,
            botId: "bot-2"
        )
    ]
}

extension ConnectedAccount {
    static let sampleAccounts: [ConnectedAccount] = [
        ConnectedAccount(
            name: "MT5 Demo Account",
            balance: "$10,000.00",
            brokerType: .mt5,
            isConnected: true
        ),
        ConnectedAccount(
            name: "Coinexx Live",
            balance: "$5,250.00",
            brokerType: .coinexx,
            isConnected: false
        )
    ]
}

extension LiveBot {
    static let sampleBots: [LiveBot] = [
        LiveBot(
            name: "ScalpMaster Pro",
            strategy: "1min Scalping",
            dailyPL: 2340.50,
            winRate: 89.5,
            tradesCount: 47,
            isTrading: true,
            currentPosition: "Long XAUUSD",
            currentPrice: 2374.85
        ),
        LiveBot(
            name: "TrendHunter AI",
            strategy: "Trend Following",
            dailyPL: 1820.75,
            winRate: 84.2,
            tradesCount: 23,
            isTrading: true,
            currentPosition: "Long EURUSD",
            currentPrice: 1.1025
        )
    ]
}

// MARK: - Extensions for SwiftUI

extension TradeDirection {
    var backgroundColor: Color {
        switch self {
        case .buy, .long: return .green.opacity(0.1)
        case .sell, .short: return .red.opacity(0.1)
        }
    }
}

extension TradingBot {
    var statusColor: Color {
        isActive ? .green : .gray
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
}

// MARK: - Type Aliases for Backward Compatibility

typealias GoldSignal = TradingModels.GoldSignal
typealias MarketData = TradingModels.MarketData

// MARK: - Preview

#Preview {
    VStack(spacing: 20) {
        Text("✅ SharedTypes Fixed")
            .font(.title.bold())
            .foregroundColor(.green)
        
        Text("All shared types consolidated")
            .font(.subheadline)
            .foregroundColor(.secondary)
        
        VStack(alignment: .leading, spacing: 4) {
            Text("Available Types:")
                .font(.headline)
            
            Group {
                Text("• TradeDirection ✅")
                Text("• TradingBot ✅")
                Text("• AutoTrade ✅")
                Text("• ConnectedAccount ✅")
                Text("• LiveBot ✅")
                Text("• All Enums ✅")
            }
            .font(.caption)
            .foregroundColor(.green)
        }
    }
    .padding()
    .background(Color(.systemGroupedBackground))
    .cornerRadius(12)
}