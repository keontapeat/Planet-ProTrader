import SwiftUI
import Foundation
import Combine

// MARK: - Wallet Manager
@MainActor
class WalletManager: ObservableObject {
    @Published var balance: Double = 25_430.50
    @Published var totalEarnings: Double = 47_230.80
    @Published var totalInvested: Double = 15_000.00
    @Published var availableCredit: Double = 10_000.00
    @Published var transactions: [ConsolidatedTypes.WalletTransaction] = []
    
    init() {
        loadTransactions()
    }
    
    private func loadTransactions() {
        // Load sample transactions
        transactions = ConsolidatedTypes.WalletTransaction.sampleTransactions
    }
    
    func deposit(amount: Double) {
        balance += amount
        let transaction = ConsolidatedTypes.WalletTransaction(
            type: .deposit,
            amount: amount,
            description: "Manual Deposit",
            timestamp: Date(),
            status: .completed
        )
        transactions.insert(transaction, at: 0)
    }
    
    func withdraw(amount: Double) -> Bool {
        guard amount <= balance else { return false }
        
        balance -= amount
        let transaction = ConsolidatedTypes.WalletTransaction(
            type: .withdrawal,
            amount: amount,
            description: "Manual Withdrawal",
            timestamp: Date(),
            status: .completed
        )
        transactions.insert(transaction, at: 0)
        return true
    }
}

// MARK: - Trading Bot Manager
@MainActor
class TradingBotManager: ObservableObject {
    static let shared = TradingBotManager()
    
    @Published var availableBots: [AdvancedTradingBot] = []
    @Published var activeBots: [AdvancedTradingBot] = []
    @Published var isLoading = false
    
    private init() {
        loadBots()
    }
    
    private func loadBots() {
        availableBots = AdvancedTradingBot.sampleBots
        activeBots = Array(availableBots.prefix(2))
    }
    
    func activateBot(_ bot: AdvancedTradingBot) {
        if !activeBots.contains(where: { $0.id == bot.id }) {
            activeBots.append(bot)
        }
    }
    
    func deactivateBot(_ bot: AdvancedTradingBot) {
        activeBots.removeAll { $0.id == bot.id }
    }
}

// MARK: - Trading Fuel Manager
@MainActor
class TradingFuelManager: ObservableObject {
    @Published var currentFuel: Double = 850.0
    @Published var maxFuel: Double = 1000.0
    @Published var fuelRate: Double = 2.5 // fuel per minute
    @Published var activities: [FuelActivity] = []
    @Published var alerts: [FuelAlert] = []
    
    var fuelPercentage: Double {
        return currentFuel / maxFuel
    }
    
    var fuelStatus: FuelStatus {
        switch fuelPercentage {
        case 0.8...: return .optimal
        case 0.5..<0.8: return .good
        case 0.2..<0.5: return .warning
        default: return .critical
        }
    }
    
    init() {
        loadSampleData()
        startFuelSimulation()
    }
    
    private func loadSampleData() {
        activities = FuelActivity.sampleActivities
        alerts = FuelAlert.sampleAlerts
    }
    
    private func startFuelSimulation() {
        Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
            self.updateFuel()
        }
    }
    
    private func updateFuel() {
        // Simulate fuel consumption and regeneration
        let consumption = Double.random(in: 1...5)
        let regeneration = fuelRate
        
        currentFuel = min(maxFuel, currentFuel - consumption + regeneration)
        
        // Add activity
        let activity = FuelActivity(
            type: .regeneration,
            amount: regeneration - consumption,
            description: "Auto fuel management",
            timestamp: Date()
        )
        activities.insert(activity, at: 0)
        
        // Check for alerts
        if fuelStatus == .critical {
            let alert = FuelAlert(
                type: .lowFuel,
                message: "Fuel critically low! Consider reducing activity.",
                severity: .high,
                timestamp: Date()
            )
            alerts.insert(alert, at: 0)
        }
    }
}

// MARK: - Consolidated Types
struct ConsolidatedTypes {
    struct WalletTransaction: Identifiable, Codable {
        let id = UUID()
        let type: TransactionType
        let amount: Double
        let status: TransactionStatus
        let description: String
        let timestamp: Date
        
        enum TransactionType: String, Codable, CaseIterable {
            case deposit = "Deposit"
            case withdrawal = "Withdrawal"
            case trade = "Trade"
            case bonus = "Bonus"
            case refund = "Refund"
            
            var emoji: String {
                switch self {
                case .deposit: return "💸"
                case .withdrawal: return "🚫"
                case .trade: return "📊"
                case .bonus: return "🎁"
                case .refund: return "↩️"
                }
            }
            
            var color: Color {
                switch self {
                case .deposit, .bonus, .refund: return .green
                case .withdrawal: return .red
                case .trade: return .blue
                }
            }
        }
        
        enum TransactionStatus: String, Codable {
            case pending = "Pending"
            case completed = "Completed"
            case failed = "Failed"
            
            var color: Color {
                switch self {
                case .pending: return .orange
                case .completed: return .green
                case .failed: return .red
                }
            }
        }
        
        init(type: TransactionType, amount: Double, description: String, timestamp: Date, status: TransactionStatus) {
            self.type = type
            self.amount = amount
            self.status = status
            self.description = description
            self.timestamp = timestamp
        }
        
        static let sampleTransactions: [WalletTransaction] = [
            WalletTransaction(
                type: .deposit,
                amount: 1000.0,
                description: "Initial deposit",
                timestamp: Date().addingTimeInterval(-86400),
                status: .completed
            ),
            WalletTransaction(
                type: .trade,
                amount: 250.50,
                description: "XAUUSD Trade Profit",
                timestamp: Date().addingTimeInterval(-7200),
                status: .completed
            ),
            WalletTransaction(
                type: .withdrawal,
                amount: -100.0,
                description: "Partial Withdrawal",
                timestamp: Date().addingTimeInterval(-3600),
                status: .completed
            )
        ]
    }
}

// MARK: - Advanced Trading Bot Model
struct AdvancedTradingBot: Identifiable, Codable {
    let id = UUID()
    let name: String
    let type: BotType
    let performance: BotPerformanceMetrics
    let isActive: Bool
    let configuration: BotConfiguration
    
    enum BotType: String, Codable, CaseIterable {
        case scalper = "Scalper"
        case swing = "Swing Trader"
        case news = "News Trader"
        case arbitrage = "Arbitrage"
        
        var emoji: String {
            switch self {
            case .scalper: return "⚡"
            case .swing: return "📈"
            case .news: return "📰"
            case .arbitrage: return "🔄"
            }
        }
    }
    
    struct BotConfiguration: Codable {
        let riskLevel: Double
        let maxPositionSize: Double
        let tradingPairs: [String]
        let strategies: [String]
    }
    
    struct BotPerformanceMetrics: Codable {
        let winRate: Double
        let totalTrades: Int
        let profitLoss: Double
        let maxDrawdown: Double
        let sharpeRatio: Double
    }
    
    static let sampleBots: [AdvancedTradingBot] = [
        AdvancedTradingBot(
            name: "Gold Rush Alpha",
            type: .scalper,
            performance: BotPerformanceMetrics(
                winRate: 85.6,
                totalTrades: 1247,
                profitLoss: 12450.30,
                maxDrawdown: 8.2,
                sharpeRatio: 2.1
            ),
            isActive: true,
            configuration: BotConfiguration(
                riskLevel: 3.5,
                maxPositionSize: 0.1,
                tradingPairs: ["XAUUSD"],
                strategies: ["RSI Divergence", "Support/Resistance"]
            )
        ),
        AdvancedTradingBot(
            name: "News Lightning",
            type: .news,
            performance: BotPerformanceMetrics(
                winRate: 78.3,
                totalTrades: 456,
                profitLoss: 8930.50,
                maxDrawdown: 12.1,
                sharpeRatio: 1.8
            ),
            isActive: false,
            configuration: BotConfiguration(
                riskLevel: 4.2,
                maxPositionSize: 0.15,
                tradingPairs: ["XAUUSD", "EURUSD"],
                strategies: ["Economic Calendar", "Sentiment Analysis"]
            )
        )
    ]
}

// MARK: - Supporting Types
enum FuelStatus {
    case optimal, good, warning, critical
    
    var color: Color {
        switch self {
        case .optimal: return .green
        case .good: return .blue
        case .warning: return .orange
        case .critical: return .red
        }
    }
    
    var emoji: String {
        switch self {
        case .optimal: return "🟢"
        case .good: return "🔵"
        case .warning: return "🟡"
        case .critical: return "🔴"
        }
    }
}

struct FuelActivity: Identifiable, Codable {
    let id = UUID()
    let type: ActivityType
    let amount: Double
    let description: String
    let timestamp: Date
    
    enum ActivityType: String, Codable {
        case consumption = "Consumption"
        case regeneration = "Regeneration"
        case boost = "Boost"
        
        var emoji: String {
            switch self {
            case .consumption: return "⬇️"
            case .regeneration: return "⬆️"
            case .boost: return "🚀"
            }
        }
    }
    
    static let sampleActivities: [FuelActivity] = [
        FuelActivity(
            type: .regeneration,
            amount: 15.5,
            description: "Auto regeneration cycle",
            timestamp: Date().addingTimeInterval(-300)
        ),
        FuelActivity(
            type: .consumption,
            amount: -8.2,
            description: "High-frequency trading burst",
            timestamp: Date().addingTimeInterval(-600)
        )
    ]
}

struct FuelAlert: Identifiable, Codable {
    let id = UUID()
    let type: AlertType
    let message: String
    let severity: Severity
    let timestamp: Date
    
    enum AlertType: String, Codable {
        case lowFuel = "Low Fuel"
        case highConsumption = "High Consumption"
        case systemOptimized = "System Optimized"
    }
    
    enum Severity: String, Codable {
        case low, medium, high
        
        var color: Color {
            switch self {
            case .low: return .blue
            case .medium: return .orange
            case .high: return .red
            }
        }
    }
    
    static let sampleAlerts: [FuelAlert] = [
        FuelAlert(
            type: .lowFuel,
            message: "Fuel level below 20%",
            severity: .high,
            timestamp: Date().addingTimeInterval(-900)
        )
    ]
}