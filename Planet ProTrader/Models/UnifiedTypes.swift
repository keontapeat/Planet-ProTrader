//
//  UnifiedTypes.swift  
//  Planet ProTrader - Unified Type System
//
//  MARK: - Emergency Type Unification
//  Resolves all type conflicts across the project
//  Created by Claude Doctor™
//

import SwiftUI
import Foundation

// MARK: - Unified Trading Account System

struct TradingAccountDetails: Identifiable, Codable {
    let id = UUID()
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
    
    var name: String {
        return "\(broker) \(accountType.rawValue)"
    }
    
    var displayName: String {
        return name
    }
    
    var server: String {
        switch broker.lowercased() {
        case let b where b.contains("mt5"): return "MT5-Server-01"
        case let b where b.contains("mt4"): return "MT4-Demo"
        case let b where b.contains("oanda"): return "OANDA-Live"
        default: return "\(broker)-Server"
        }
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

// MARK: - Unified Bot System (No Conflicts)

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
    
    // UI Properties
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
}

// MARK: - Unified Enums

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

// MARK: - Sample Data Extensions

extension TradingBot {
    static let sampleBots: [TradingBot] = [
        TradingBot(
            name: "GoldMaster Elite",
            strategy: .scalping,
            riskLevel: .high,
            isActive: true,
            winRate: 0.892,
            totalTrades: 2847,
            profitLoss: 15420.88,
            performance: 154.2,
            status: .trading,
            icon: "crown.fill",
            primaryColor: "#FFD700",
            secondaryColor: "#FFA500"
        ),
        TradingBot(
            name: "News Hunter Pro",
            strategy: .news,
            riskLevel: .extreme,
            isActive: true,
            winRate: 0.934,
            totalTrades: 1205,
            profitLoss: 28750.45,
            performance: 287.5,
            status: .analyzing,
            icon: "newspaper.fill",
            primaryColor: "#FF6347",
            secondaryColor: "#DC143C"
        ),
        TradingBot(
            name: "Momentum Beast",
            strategy: .momentum,
            riskLevel: .medium,
            isActive: false,
            winRate: 0.876,
            totalTrades: 892,
            profitLoss: 12340.67,
            performance: 123.4,
            status: .learning,
            icon: "bolt.fill",
            primaryColor: "#9370DB",
            secondaryColor: "#8A2BE2"
        ),
        TradingBot(
            name: "Swing Master",
            strategy: .swing,
            riskLevel: .low,
            isActive: true,
            winRate: 0.785,
            totalTrades: 456,
            profitLoss: 8950.33,
            performance: 89.5,
            status: .active,
            icon: "waveform.path",
            primaryColor: "#00CED1",
            secondaryColor: "#4682B4"
        ),
        TradingBot(
            name: "Grid Arbitrage Pro",
            strategy: .gridTrading,
            riskLevel: .medium,
            isActive: false,
            winRate: 0.671,
            totalTrades: 3421,
            profitLoss: 5670.12,
            performance: 56.7,
            status: .stopped,
            icon: "grid",
            primaryColor: "#32CD32",
            secondaryColor: "#228B22"
        )
    ]
}

extension TradingAccountDetails {
    static let sampleAccounts: [TradingAccountDetails] = [
        TradingAccountDetails(
            accountNumber: "MT5-78901234",
            broker: "MetaTrader 5 Pro",
            accountType: .live,
            balance: 25000.0,
            equity: 27845.67,
            freeMargin: 24500.0,
            leverage: 500,
            currency: "USD",
            isActive: true
        ),
        TradingAccountDetails(
            accountNumber: "DEMO-12345678",
            broker: "MT5 Demo",
            accountType: .demo,
            balance: 10000.0,
            equity: 11247.85,
            freeMargin: 9500.0,
            leverage: 1000,
            currency: "USD",
            isActive: false
        ),
        TradingAccountDetails(
            accountNumber: "OANDA-87654321",
            broker: "OANDA Live",
            accountType: .live,
            balance: 15000.0,
            equity: 15678.90,
            freeMargin: 14200.0,
            leverage: 50,
            currency: "USD",
            isActive: false
        )
    ]
}

#Preview {
    VStack(spacing: 20) {
        Text("✅ Unified Type System")
            .font(.title.bold())
            .foregroundColor(.green)
        
        Text("All type conflicts resolved")
            .font(.subheadline)
            .foregroundColor(.secondary)
        
        VStack(alignment: .leading, spacing: 8) {
            Text("Available Types:")
                .font(.headline)
            
            Group {
                Text("• TradingAccountDetails ✅")
                Text("• TradingBot (unified) ✅")  
                Text("• BotStatus ✅")
                Text("• RiskLevel ✅")
                Text("• All sample data ✅")
            }
            .font(.caption)
            .foregroundColor(.green)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    .padding()
}