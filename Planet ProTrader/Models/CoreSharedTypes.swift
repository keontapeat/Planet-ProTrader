//
//  CoreSharedTypes.swift  
//  Planet ProTrader
//
//  Created by AI Assistant on 1/25/25.
//

import Foundation
import SwiftUI

// MARK: - Core Trading Types

enum TrendDirection: String, CaseIterable, Codable {
    case up = "UP"
    case down = "DOWN"
    case sideways = "SIDEWAYS"
    case unknown = "UNKNOWN"
    
    var emoji: String {
        switch self {
        case .up: return "📈"
        case .down: return "📉"
        case .sideways: return "➡️"
        case .unknown: return "❓"
        }
    }
    
    var color: Color {
        switch self {
        case .up: return .green
        case .down: return .red
        case .sideways: return .orange
        case .unknown: return .gray
        }
    }
}

enum TradeDirection: String, CaseIterable, Codable {
    case buy = "BUY"
    case sell = "SELL"
    
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

enum TimeFrame: String, CaseIterable, Codable {
    case m1 = "1m"
    case m5 = "5m"
    case m15 = "15m"
    case m30 = "30m"
    case h1 = "1h"
    case h4 = "4h"
    case d1 = "1d"
    case w1 = "1w"
    case mn1 = "1M"
    
    var displayName: String {
        return rawValue
    }
    
    var minutes: Int {
        switch self {
        case .m1: return 1
        case .m5: return 5
        case .m15: return 15
        case .m30: return 30
        case .h1: return 60
        case .h4: return 240
        case .d1: return 1440
        case .w1: return 10080
        case .mn1: return 43200
        }
    }
}

enum RiskLevel: String, CaseIterable, Codable {
    case low = "LOW"
    case medium = "MEDIUM"
    case high = "HIGH"
    case extreme = "EXTREME"
    
    var color: Color {
        switch self {
        case .low: return .green
        case .medium: return .yellow
        case .high: return .orange
        case .extreme: return .red
        }
    }
    
    var emoji: String {
        switch self {
        case .low: return "🟢"
        case .medium: return "🟡"
        case .high: return "🟠"
        case .extreme: return "🔴"
        }
    }
}

enum MarketSession: String, CaseIterable, Codable {
    case tokyo = "TOKYO"
    case london = "LONDON"
    case newYork = "NEW_YORK"
    case sydney = "SYDNEY"
    case overlap = "OVERLAP"
    
    var emoji: String {
        switch self {
        case .tokyo: return "🌅"
        case .london: return "🏰"
        case .newYork: return "🗽"
        case .sydney: return "🏖️"
        case .overlap: return "⚡"
        }
    }
    
    var color: Color {
        switch self {
        case .tokyo: return .orange
        case .london: return .blue
        case .newYork: return .purple
        case .sydney: return .green
        case .overlap: return .red
        }
    }
}

// MARK: - Bot & Trading Types

enum BotStatus: String, CaseIterable, Codable {
    case active = "ACTIVE"
    case paused = "PAUSED"
    case stopped = "STOPPED"
    case training = "TRAINING"
    case error = "ERROR"
    
    var color: Color {
        switch self {
        case .active: return .green
        case .paused: return .yellow
        case .stopped: return .red
        case .training: return .blue
        case .error: return .red
        }
    }
    
    var emoji: String {
        switch self {
        case .active: return "🟢"
        case .paused: return "⏸️"
        case .stopped: return "🛑"
        case .training: return "🧠"
        case .error: return "❌"
        }
    }
}

enum TradeStatus: String, CaseIterable, Codable {
    case pending = "PENDING"
    case open = "OPEN"
    case closed = "CLOSED"
    case cancelled = "CANCELLED"
    
    var color: Color {
        switch self {
        case .pending: return .yellow
        case .open: return .blue
        case .closed: return .green
        case .cancelled: return .red
        }
    }
}

// MARK: - Data Point Structures

struct PriceData: Codable {
    let timestamp: Date
    let open: Double
    let high: Double
    let low: Double
    let close: Double
    let volume: Double?
    
    var bodySize: Double {
        abs(close - open)
    }
    
    var isBullish: Bool {
        close > open
    }
    
    var wickHigh: Double {
        high - max(open, close)
    }
    
    var wickLow: Double {
        min(open, close) - low
    }
}

struct MarketConditions: Codable {
    let volatility: Double
    let volume: Double
    let spread: Double
    let session: MarketSession
    let trend: TrendDirection
    let strength: Double
    let timestamp: Date
}

// MARK: - Performance Metrics

struct PerformanceMetrics: Codable {
    let totalTrades: Int
    let winRate: Double
    let totalProfit: Double
    let maxDrawdown: Double
    let sharpeRatio: Double
    let profitFactor: Double
    let averageWin: Double
    let averageLoss: Double
    let largestWin: Double
    let largestLoss: Double
    let consecutiveWins: Int
    let consecutiveLosses: Int
    
    var riskAdjustedReturn: Double {
        return totalProfit / max(maxDrawdown, 1.0)
    }
    
    var expectancy: Double {
        let winPercent = winRate / 100.0
        let lossPercent = 1.0 - winPercent
        return (winPercent * averageWin) - (lossPercent * abs(averageLoss))
    }
}

// MARK: - Error Types

enum TradingError: Error, LocalizedError {
    case invalidSymbol(String)
    case insufficientFunds
    case marketClosed
    case networkError(String)
    case authenticationFailed
    case invalidTradeSize
    case stopLossInvalid
    case takeProfitInvalid
    case botNotFound(String)
    case dataSourceError(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidSymbol(let symbol):
            return "Invalid trading symbol: \(symbol)"
        case .insufficientFunds:
            return "Insufficient funds for this trade"
        case .marketClosed:
            return "Market is currently closed"
        case .networkError(let message):
            return "Network error: \(message)"
        case .authenticationFailed:
            return "Authentication failed"
        case .invalidTradeSize:
            return "Invalid trade size"
        case .stopLossInvalid:
            return "Invalid stop loss level"
        case .takeProfitInvalid:
            return "Invalid take profit level"
        case .botNotFound(let id):
            return "Bot not found: \(id)"
        case .dataSourceError(let message):
            return "Data source error: \(message)"
        }
    }
}

// MARK: - Utility Extensions

extension Double {
    func toPips() -> String {
        return String(format: "%.1f pips", self)
    }
    
    func toCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: NSNumber(value: self)) ?? "$0.00"
    }
    
    func toPercentage(decimalPlaces: Int = 2) -> String {
        return String(format: "%.\(decimalPlaces)f%%", self)
    }
}

extension Date {
    func toTradingTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        formatter.timeZone = TimeZone(identifier: "GMT")
        return formatter.string(from: self)
    }
    
    func toTradingDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }
}