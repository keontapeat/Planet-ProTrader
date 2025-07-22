//
//  UnifiedTradingBot.swift
//  Planet ProTrader
//
//  ✅ MASTER: Single source of truth for TradingBot
//  Replaces all duplicate TradingBot definitions
//

import SwiftUI
import Foundation

// MARK: - Master TradingBot Model

struct TradingBot: Identifiable, Codable, Hashable {
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
    
    // UI-specific properties
    let icon: String
    let primaryColor: String
    let secondaryColor: String
    let status: TradingStatus
    let profit: Double
    
    // MARK: - Enums
    
    enum TradingStrategy: String, Codable, CaseIterable {
        case scalping = "Scalping"
        case swing = "Swing Trading" 
        case dayTrading = "Day Trading"
        case news = "News Trading"
        case momentum = "Momentum"
        case reversal = "Reversal"
        case arbitrage = "Arbitrage"
        case martingale = "Martingale"
        
        var displayName: String { rawValue }
        
        var description: String {
            switch self {
            case .scalping: return "High-frequency short-term trades"
            case .swing: return "Multi-day position trading"
            case .dayTrading: return "Intraday position management"
            case .news: return "Event-driven trading signals"
            case .momentum: return "Trend following strategy"
            case .reversal: return "Counter-trend identification"
            case .arbitrage: return "Price discrepancy exploitation"
            case .martingale: return "Progressive position sizing"
            }
        }
    }
    
    enum TradingStatus: String, Codable, CaseIterable {
        case trading = "Trading"
        case analyzing = "Analyzing"
        case active = "Active"
        case learning = "Learning"
        case paused = "Paused"
        case stopped = "Stopped"
        case error = "Error"
        
        var color: Color {
            switch self {
            case .trading: return .green
            case .analyzing: return .blue
            case .active: return .green
            case .learning: return .orange
            case .paused: return .yellow
            case .stopped: return .gray
            case .error: return .red
            }
        }
        
        var systemImage: String {
            switch self {
            case .trading: return "chart.line.uptrend.xyaxis"
            case .analyzing: return "brain.head.profile"
            case .active: return "bolt.fill"
            case .learning: return "book.fill"
            case .paused: return "pause.fill"
            case .stopped: return "stop.fill"
            case .error: return "exclamationmark.triangle.fill"
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
    
    // MARK: - Initializers
    
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
        icon: String = "brain.head.profile",
        primaryColor: String = "#FFD700",
        secondaryColor: String = "#FFA500",
        status: TradingStatus = .active,
        profit: Double? = nil
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
        self.icon = icon
        self.primaryColor = primaryColor
        self.secondaryColor = secondaryColor
        self.status = status
        self.profit = profit ?? profitLoss
    }
    
    // MARK: - Computed Properties
    
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
    
    var formattedPerformance: String {
        let sign = performance >= 0 ? "+" : ""
        return "\(sign)\(String(format: "%.1f", performance))%"
    }
    
    var riskLevelText: String { riskLevel.displayName }
    var riskLevelColor: Color { riskLevel.color }
    
    // MARK: - Sample Data
    
    static let sampleBots: [TradingBot] = [
        TradingBot(
            name: "Gold Hunter AI",
            strategy: .scalping,
            riskLevel: .medium,
            isActive: true,
            winRate: 0.89,
            totalTrades: 342,
            profitLoss: 15420.50,
            performance: 127.8,
            icon: "crown.fill",
            primaryColor: "#FFD700",
            secondaryColor: "#FFA500",
            status: .trading,
            profit: 15420.50
        ),
        TradingBot(
            name: "Momentum Master",
            strategy: .momentum,
            riskLevel: .low,
            isActive: false,
            winRate: 0.76,
            totalTrades: 156,
            profitLoss: 8750.25,
            performance: 98.5,
            icon: "bolt.fill",
            primaryColor: "#00CED1",
            secondaryColor: "#4682B4",
            status: .analyzing,
            profit: 8750.25
        ),
        TradingBot(
            name: "Risk Sentinel",
            strategy: .reversal,
            riskLevel: .low,
            isActive: true,
            winRate: 0.82,
            totalTrades: 89,
            profitLoss: 3950.75,
            performance: 84.3,
            icon: "shield.fill",
            primaryColor: "#32CD32",
            secondaryColor: "#228B22",
            status: .active,
            profit: 3950.75
        ),
        TradingBot(
            name: "News Reactor",
            strategy: .news,
            riskLevel: .high,
            isActive: true,
            winRate: 0.91,
            totalTrades: 203,
            profitLoss: 12340.88,
            performance: 156.7,
            icon: "newspaper.fill",
            primaryColor: "#FF6347",
            secondaryColor: "#DC143C",
            status: .learning,
            profit: 12340.88
        ),
        TradingBot(
            name: "Pattern Prophet",
            strategy: .swing,
            riskLevel: .medium,
            isActive: true,
            winRate: 0.85,
            totalTrades: 445,
            profitLoss: 18750.60,
            performance: 203.2,
            icon: "eye.fill",
            primaryColor: "#9370DB",
            secondaryColor: "#8A2BE2",
            status: .trading,
            profit: 18750.60
        )
    ]
    
    static let empty: [TradingBot] = []
}

// MARK: - Extensions

extension TradingBot {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: TradingBot, rhs: TradingBot) -> Bool {
        lhs.id == rhs.id
    }
}

#Preview {
    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
        ForEach(TradingBot.sampleBots.prefix(4)) { bot in
            VStack(spacing: 8) {
                HStack {
                    Image(systemName: bot.icon)
                        .foregroundColor(Color(hex: bot.primaryColor))
                    Text(bot.name)
                        .font(.headline)
                        .lineLimit(1)
                    Spacer()
                }
                
                HStack {
                    Text("Status:")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(bot.status.rawValue)
                        .font(.caption)
                        .foregroundColor(bot.statusColor)
                    Spacer()
                }
                
                HStack {
                    Text("Performance:")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(bot.formattedPerformance)
                        .font(.caption.bold())
                        .foregroundColor(bot.performanceColor)
                    Spacer()
                }
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(12)
        }
    }
    .padding()
}