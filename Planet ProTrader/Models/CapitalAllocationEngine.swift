//
//  CapitalAllocationEngine.swift
//  GOLDEX AI
//
//  Created by Keonta on 7/13/25.
//

import Foundation
import SwiftUI

// MARK: - Capital Allocation Engine
class CapitalAllocationEngine: ObservableObject {
    
    // MARK: - Published Properties
    @Published var isActive = false
    @Published var isOptimizing = false
    @Published var totalCapital: Double = 100000.0
    @Published var allocatedCapital: Double = 0.0
    @Published var availableCapital: Double = 100000.0
    @Published var allocationStrategy: AllocationStrategy = .balanced
    @Published var accounts: [TradingAccount] = []
    @Published var riskTiers: [RiskTier] = []
    @Published var brokerAllocations: [BrokerAllocation] = []
    @Published var pairAllocations: [PairAllocation] = []
    @Published var timeframeAllocations: [TimeframeAllocation] = []
    @Published var portfolioMetrics: PortfolioMetrics = PortfolioMetrics()
    @Published var lastOptimizationTime = Date()
    @Published var rebalancingStatus: RebalancingStatus = .balanced
    
    // MARK: - Allocation Strategy
    enum AllocationStrategy: CaseIterable {
        case conservative
        case balanced
        case aggressive
        case adaptive
        case custom
        
        var displayName: String {
            switch self {
            case .conservative: return "Conservative"
            case .balanced: return "Balanced"
            case .aggressive: return "Aggressive"
            case .adaptive: return "Adaptive"
            case .custom: return "Custom"
            }
        }
        
        var description: String {
            switch self {
            case .conservative: return "Low risk, steady returns"
            case .balanced: return "Balanced risk-reward profile"
            case .aggressive: return "High risk, high reward potential"
            case .adaptive: return "Adjusts to market conditions"
            case .custom: return "User-defined parameters"
            }
        }
        
        var riskLevel: Double {
            switch self {
            case .conservative: return 0.2
            case .balanced: return 0.5
            case .aggressive: return 0.8
            case .adaptive: return 0.6
            case .custom: return 0.5
            }
        }
        
        var color: Color {
            switch self {
            case .conservative: return .green
            case .balanced: return .blue
            case .aggressive: return .red
            case .adaptive: return .purple
            case .custom: return .orange
            }
        }
    }
    
    // MARK: - Trading Account
    struct TradingAccount: Identifiable {
        let id = UUID()
        let name: String
        let broker: String
        let accountType: AccountType
        var balance: Double
        var equity: Double
        var margin: Double
        var freeMargin: Double
        var marginLevel: Double
        var allocation: Double
        var targetAllocation: Double
        var performance: AccountPerformance
        var riskMetrics: AccountRiskMetrics
        var isActive: Bool
        var lastUpdate: Date
        
        enum AccountType {
            case demo
            case live
            case prop
            case managed
            
            var displayName: String {
                switch self {
                case .demo: return "Demo"
                case .live: return "Live"
                case .prop: return "Prop"
                case .managed: return "Managed"
                }
            }
            
            var color: Color {
                switch self {
                case .demo: return .gray
                case .live: return .green
                case .prop: return .blue
                case .managed: return .purple
                }
            }
        }
        
        struct AccountPerformance {
            var totalReturn: Double
            var monthlyReturn: Double
            var weeklyReturn: Double
            var dailyReturn: Double
            var winRate: Double
            var profitFactor: Double
            var sharpeRatio: Double
            var maxDrawdown: Double
            var consecutiveWins: Int
            var consecutiveLosses: Int
        }
        
        struct AccountRiskMetrics {
            var var95: Double // Value at Risk at 95% confidence
            var maxDrawdown: Double
            var volatility: Double
            var correlation: Double
            var beta: Double
            var riskScore: Double
        }
        
        mutating func updatePerformance() {
            performance.totalReturn = Double.random(in: -0.2...0.8)
            performance.monthlyReturn = Double.random(in: -0.1...0.3)
            performance.weeklyReturn = Double.random(in: -0.05...0.15)
            performance.dailyReturn = Double.random(in: -0.02...0.05)
            performance.winRate = Double.random(in: 0.4...0.8)
            performance.profitFactor = Double.random(in: 0.8...2.5)
            performance.sharpeRatio = Double.random(in: 0.3...2.0)
            performance.maxDrawdown = Double.random(in: 0.05...0.3)
            performance.consecutiveWins = Int.random(in: 1...10)
            performance.consecutiveLosses = Int.random(in: 1...5)
            
            riskMetrics.var95 = Double.random(in: 0.02...0.15)
            riskMetrics.maxDrawdown = performance.maxDrawdown
            riskMetrics.volatility = Double.random(in: 0.1...0.4)
            riskMetrics.correlation = Double.random(in: 0.2...0.8)
            riskMetrics.beta = Double.random(in: 0.5...1.5)
            riskMetrics.riskScore = Double.random(in: 0.3...0.8)
            
            lastUpdate = Date()
        }
    }
    
    // MARK: - Risk Tier
    struct RiskTier: Identifiable {
        let id = UUID()
        let name: String
        let riskLevel: TradingTypes.RiskLevel
        var allocation: Double
        var targetAllocation: Double
        var accounts: [UUID]
        var maxDrawdown: Double
        var positionSize: Double
        var leverage: Double
        var stopLoss: Double
        var takeProfit: Double
        var isActive: Bool
    }
    
    // MARK: - Broker Allocation
    struct BrokerAllocation: Identifiable {
        let id = UUID()
        let brokerName: String
        let brokerType: BrokerType
        var allocation: Double
        var targetAllocation: Double
        var accounts: [UUID]
        var reliability: Double
        var spreads: Double
        var execution: Double
        var regulation: RegulationType
        var isActive: Bool
        
        enum BrokerType {
            case retail
            case institutional
            case prop
            case prime
            
            var displayName: String {
                switch self {
                case .retail: return "Retail"
                case .institutional: return "Institutional"
                case .prop: return "Prop"
                case .prime: return "Prime"
                }
            }
        }
        
        enum RegulationType {
            case fca
            case cysec
            case asic
            case cftc
            case unregulated
            
            var displayName: String {
                switch self {
                case .fca: return "FCA"
                case .cysec: return "CySEC"
                case .asic: return "ASIC"
                case .cftc: return "CFTC"
                case .unregulated: return "Unregulated"
                }
            }
        }
    }
    
    // MARK: - Pair Allocation
    struct PairAllocation: Identifiable {
        let id = UUID()
        let pair: String
        let category: PairCategory
        var allocation: Double
        var targetAllocation: Double
        var correlation: Double
        var volatility: Double
        var liquidity: Double
        var performance: PairPerformance
        var isActive: Bool
        
        enum PairCategory {
            case major
            case minor
            case exotic
            case metal
            case crypto
            
            var displayName: String {
                switch self {
                case .major: return "Major"
                case .minor: return "Minor"
                case .exotic: return "Exotic"
                case .metal: return "Metal"
                case .crypto: return "Crypto"
                }
            }
            
            var color: Color {
                switch self {
                case .major: return .blue
                case .minor: return .green
                case .exotic: return .orange
                case .metal: return .yellow
                case .crypto: return .purple
                }
            }
        }
        
        struct PairPerformance {
            var totalReturn: Double
            var winRate: Double
            var profitFactor: Double
            var averageWin: Double
            var averageLoss: Double
            var maxDrawdown: Double
        }
    }
    
    // MARK: - Timeframe Allocation
    struct TimeframeAllocation: Identifiable {
        let id = UUID()
        let timeframe: String
        let category: TimeframeCategory
        var allocation: Double
        var targetAllocation: Double
        var winRate: Double
        var profitFactor: Double
        var frequency: Double
        var isActive: Bool
        
        enum TimeframeCategory {
            case scalping
            case intraday
            case swing
            case position
            
            var displayName: String {
                switch self {
                case .scalping: return "Scalping"
                case .intraday: return "Intraday"
                case .swing: return "Swing"
                case .position: return "Position"
                }
            }
            
            var color: Color {
                switch self {
                case .scalping: return .red
                case .intraday: return .orange
                case .swing: return .blue
                case .position: return .green
                }
            }
        }
    }
    
    // MARK: - Portfolio Metrics
    struct PortfolioMetrics {
        var totalValue: Double = 0.0
        var totalReturn: Double = 0.0
        var annualizedReturn: Double = 0.0
        var volatility: Double = 0.0
        var sharpeRatio: Double = 0.0
        var maxDrawdown: Double = 0.0
        var winRate: Double = 0.0
        var profitFactor: Double = 0.0
        var correlationMatrix: [[Double]] = []
        var riskMetrics: RiskMetrics = RiskMetrics()
        var diversificationScore: Double = 0.0
        var efficiencyScore: Double = 0.0
        var lastUpdate: Date = Date()
        
        struct RiskMetrics {
            var var95: Double = 0.0
            var cvar95: Double = 0.0
            var beta: Double = 0.0
            var alpha: Double = 0.0
            var trackingError: Double = 0.0
            var informationRatio: Double = 0.0
        }
        
        mutating func updateMetrics() {
            totalValue = Double.random(in: 95000...120000)
            totalReturn = Double.random(in: 0.05...0.35)
            annualizedReturn = Double.random(in: 0.1...0.5)
            volatility = Double.random(in: 0.15...0.35)
            sharpeRatio = Double.random(in: 0.8...2.5)
            maxDrawdown = Double.random(in: 0.05...0.25)
            winRate = Double.random(in: 0.55...0.75)
            profitFactor = Double.random(in: 1.2...2.8)
            diversificationScore = Double.random(in: 0.6...0.9)
            efficiencyScore = Double.random(in: 0.7...0.95)
            
            riskMetrics.var95 = Double.random(in: 0.02...0.08)
            riskMetrics.cvar95 = Double.random(in: 0.03...0.12)
            riskMetrics.beta = Double.random(in: 0.7...1.3)
            riskMetrics.alpha = Double.random(in: 0.02...0.08)
            riskMetrics.trackingError = Double.random(in: 0.05...0.15)
            riskMetrics.informationRatio = Double.random(in: 0.3...1.2)
            
            lastUpdate = Date()
        }
    }
    
    // MARK: - Rebalancing Status
    enum RebalancingStatus: CaseIterable {
        case balanced
        case minorImbalance
        case rebalanceNeeded
        case criticalImbalance
        case rebalancing
        
        var displayName: String {
            switch self {
            case .balanced: return "Balanced"
            case .minorImbalance: return "Minor Imbalance"
            case .rebalanceNeeded: return "Rebalance Needed"
            case .criticalImbalance: return "Critical Imbalance"
            case .rebalancing: return "Rebalancing..."
            }
        }
        
        var color: Color {
            switch self {
            case .balanced: return .green
            case .minorImbalance: return .yellow
            case .rebalanceNeeded: return .orange
            case .criticalImbalance: return .red
            case .rebalancing: return .blue
            }
        }
    }
    
    // MARK: - Initialization
    init() {
        initializeDefaultAllocations()
    }
    
    private func initializeDefaultAllocations() {
        // Initialize default accounts
        accounts = [
            TradingAccount(
                name: "Primary Account",
                broker: "Premium Broker",
                accountType: .live,
                balance: 50000,
                equity: 52000,
                margin: 2000,
                freeMargin: 50000,
                marginLevel: 2600,
                allocation: 0.5,
                targetAllocation: 0.5,
                performance: TradingAccount.AccountPerformance(
                    totalReturn: 0.15,
                    monthlyReturn: 0.03,
                    weeklyReturn: 0.008,
                    dailyReturn: 0.002,
                    winRate: 0.68,
                    profitFactor: 1.85,
                    sharpeRatio: 1.45,
                    maxDrawdown: 0.12,
                    consecutiveWins: 7,
                    consecutiveLosses: 3
                ),
                riskMetrics: TradingAccount.AccountRiskMetrics(
                    var95: 0.05,
                    maxDrawdown: 0.12,
                    volatility: 0.2,
                    correlation: 0.6,
                    beta: 1.1,
                    riskScore: 0.4
                ),
                isActive: true,
                lastUpdate: Date()
            ),
            TradingAccount(
                name: "Secondary Account",
                broker: "Backup Broker",
                accountType: .live,
                balance: 30000,
                equity: 31500,
                margin: 1500,
                freeMargin: 30000,
                marginLevel: 2100,
                allocation: 0.3,
                targetAllocation: 0.3,
                performance: TradingAccount.AccountPerformance(
                    totalReturn: 0.12,
                    monthlyReturn: 0.025,
                    weeklyReturn: 0.006,
                    dailyReturn: 0.0015,
                    winRate: 0.65,
                    profitFactor: 1.7,
                    sharpeRatio: 1.3,
                    maxDrawdown: 0.08,
                    consecutiveWins: 5,
                    consecutiveLosses: 2
                ),
                riskMetrics: TradingAccount.AccountRiskMetrics(
                    var95: 0.04,
                    maxDrawdown: 0.08,
                    volatility: 0.18,
                    correlation: 0.5,
                    beta: 0.9,
                    riskScore: 0.35
                ),
                isActive: true,
                lastUpdate: Date()
            ),
            TradingAccount(
                name: "Prop Account",
                broker: "Prop Firm",
                accountType: .prop,
                balance: 20000,
                equity: 21000,
                margin: 1000,
                freeMargin: 20000,
                marginLevel: 2100,
                allocation: 0.2,
                targetAllocation: 0.2,
                performance: TradingAccount.AccountPerformance(
                    totalReturn: 0.18,
                    monthlyReturn: 0.035,
                    weeklyReturn: 0.009,
                    dailyReturn: 0.0025,
                    winRate: 0.72,
                    profitFactor: 2.1,
                    sharpeRatio: 1.6,
                    maxDrawdown: 0.06,
                    consecutiveWins: 9,
                    consecutiveLosses: 2
                ),
                riskMetrics: TradingAccount.AccountRiskMetrics(
                    var95: 0.03,
                    maxDrawdown: 0.06,
                    volatility: 0.16,
                    correlation: 0.4,
                    beta: 0.8,
                    riskScore: 0.3
                ),
                isActive: true,
                lastUpdate: Date()
            )
        ]
        
        riskTiers = [
            RiskTier(
                name: "Conservative",
                riskLevel: .low,
                allocation: 0.4,
                targetAllocation: 0.4,
                accounts: [accounts[0].id],
                maxDrawdown: 0.05,
                positionSize: 0.01,
                leverage: 1.0,
                stopLoss: 0.02,
                takeProfit: 0.04,
                isActive: true
            ),
            RiskTier(
                name: "Moderate",
                riskLevel: .medium,
                allocation: 0.4,
                targetAllocation: 0.4,
                accounts: [accounts[1].id],
                maxDrawdown: 0.1,
                positionSize: 0.02,
                leverage: 2.0,
                stopLoss: 0.03,
                takeProfit: 0.06,
                isActive: true
            ),
            RiskTier(
                name: "Aggressive",
                riskLevel: .high,
                allocation: 0.2,
                targetAllocation: 0.2,
                accounts: [accounts[2].id],
                maxDrawdown: 0.15,
                positionSize: 0.03,
                leverage: 3.0,
                stopLoss: 0.04,
                takeProfit: 0.08,
                isActive: true
            )
        ]
        
        brokerAllocations = [
            BrokerAllocation(
                brokerName: "Premium Broker",
                brokerType: .institutional,
                allocation: 0.5,
                targetAllocation: 0.5,
                accounts: [accounts[0].id],
                reliability: 0.95,
                spreads: 0.8,
                execution: 0.9,
                regulation: .fca,
                isActive: true
            ),
            BrokerAllocation(
                brokerName: "Backup Broker",
                brokerType: .retail,
                allocation: 0.3,
                targetAllocation: 0.3,
                accounts: [accounts[1].id],
                reliability: 0.85,
                spreads: 1.2,
                execution: 0.8,
                regulation: .cysec,
                isActive: true
            ),
            BrokerAllocation(
                brokerName: "Prop Firm",
                brokerType: .prop,
                allocation: 0.2,
                targetAllocation: 0.2,
                accounts: [accounts[2].id],
                reliability: 0.9,
                spreads: 0.6,
                execution: 0.95,
                regulation: .cftc,
                isActive: true
            )
        ]
        
        pairAllocations = [
            PairAllocation(
                pair: "XAUUSD",
                category: .metal,
                allocation: 0.6,
                targetAllocation: 0.6,
                correlation: 0.3,
                volatility: 0.25,
                liquidity: 0.9,
                performance: PairAllocation.PairPerformance(
                    totalReturn: 0.18,
                    winRate: 0.7,
                    profitFactor: 1.9,
                    averageWin: 45,
                    averageLoss: -25,
                    maxDrawdown: 0.08
                ),
                isActive: true
            ),
            PairAllocation(
                pair: "EURUSD",
                category: .major,
                allocation: 0.2,
                targetAllocation: 0.2,
                correlation: 0.5,
                volatility: 0.15,
                liquidity: 0.95,
                performance: PairAllocation.PairPerformance(
                    totalReturn: 0.12,
                    winRate: 0.65,
                    profitFactor: 1.6,
                    averageWin: 35,
                    averageLoss: -22,
                    maxDrawdown: 0.06
                ),
                isActive: true
            ),
            PairAllocation(
                pair: "GBPUSD",
                category: .major,
                allocation: 0.2,
                targetAllocation: 0.2,
                correlation: 0.4,
                volatility: 0.2,
                liquidity: 0.85,
                performance: PairAllocation.PairPerformance(
                    totalReturn: 0.15,
                    winRate: 0.68,
                    profitFactor: 1.8,
                    averageWin: 42,
                    averageLoss: -24,
                    maxDrawdown: 0.07
                ),
                isActive: true
            )
        ]
        
        timeframeAllocations = [
            TimeframeAllocation(
                timeframe: "M15",
                category: .scalping,
                allocation: 0.2,
                targetAllocation: 0.2,
                winRate: 0.65,
                profitFactor: 1.5,
                frequency: 0.9,
                isActive: true
            ),
            TimeframeAllocation(
                timeframe: "H1",
                category: .intraday,
                allocation: 0.3,
                targetAllocation: 0.3,
                winRate: 0.7,
                profitFactor: 1.8,
                frequency: 0.7,
                isActive: true
            ),
            TimeframeAllocation(
                timeframe: "H4",
                category: .swing,
                allocation: 0.3,
                targetAllocation: 0.3,
                winRate: 0.75,
                profitFactor: 2.1,
                frequency: 0.5,
                isActive: true
            ),
            TimeframeAllocation(
                timeframe: "D1",
                category: .position,
                allocation: 0.2,
                targetAllocation: 0.2,
                winRate: 0.8,
                profitFactor: 2.5,
                frequency: 0.3,
                isActive: true
            )
        ]
        
        updateAllocations()
    }
    
    // MARK: - Optimization Methods
    func startOptimization() {
        isOptimizing = true
        lastOptimizationTime = Date()
        
        // Update all performance metrics
        updatePerformanceMetrics()
        
        // Analyze current allocations
        analyzeAllocations()
        
        // Optimize allocations
        optimizeAllocations()
        
        // Check rebalancing needs
        checkRebalancingNeeds()
        
        // Complete optimization
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.completeOptimization()
        }
    }
    
    private func updatePerformanceMetrics() {
        // Update account performance
        for i in 0..<accounts.count {
            accounts[i].updatePerformance()
        }
        
        // Update portfolio metrics
        portfolioMetrics.updateMetrics()
        
        // Update allocations
        updateAllocations()
    }
    
    private func analyzeAllocations() {
        // Calculate current allocations
        let totalBalance = accounts.reduce(0) { $0 + $1.balance }
        
        for i in 0..<accounts.count {
            accounts[i].allocation = accounts[i].balance / totalBalance
        }
        
        // Analyze risk distribution
        analyzeRiskDistribution()
        
        // Analyze broker distribution
        analyzeBrokerDistribution()
        
        // Analyze pair distribution
        analyzePairDistribution()
    }
    
    private func optimizeAllocations() {
        // Optimize based on performance
        optimizeBasedOnPerformance()
        
        // Optimize based on risk
        optimizeBasedOnRisk()
        
        // Optimize based on correlation
        optimizeBasedOnCorrelation()
    }
    
    private func checkRebalancingNeeds() {
        let allocationDifferences = accounts.map { abs($0.allocation - $0.targetAllocation) }
        let maxDifference = allocationDifferences.max() ?? 0.0
        
        switch maxDifference {
        case 0.0...0.05:
            rebalancingStatus = .balanced
        case 0.05...0.1:
            rebalancingStatus = .minorImbalance
        case 0.1...0.2:
            rebalancingStatus = .rebalanceNeeded
        case 0.2...0.3:
            rebalancingStatus = .criticalImbalance
        default:
            rebalancingStatus = .criticalImbalance
        }
    }
    
    private func completeOptimization() {
        isOptimizing = false
        
        // Update final metrics
        updateAllocations()
        portfolioMetrics.updateMetrics()
    }
    
    private func updateAllocations() {
        allocatedCapital = accounts.reduce(0) { $0 + $1.balance }
        availableCapital = totalCapital - allocatedCapital
    }
    
    private func analyzeRiskDistribution() {
        // Update risk tier allocations
        for i in 0..<riskTiers.count {
            let accountsInTier = accounts.filter { riskTiers[i].accounts.contains($0.id) }
            let totalInTier = accountsInTier.reduce(0) { $0 + $1.balance }
            riskTiers[i].allocation = totalInTier / totalCapital
        }
    }
    
    private func analyzeBrokerDistribution() {
        // Update broker allocations
        for i in 0..<brokerAllocations.count {
            let accountsWithBroker = accounts.filter { brokerAllocations[i].accounts.contains($0.id) }
            let totalWithBroker = accountsWithBroker.reduce(0) { $0 + $1.balance }
            brokerAllocations[i].allocation = totalWithBroker / totalCapital
        }
    }
    
    private func analyzePairDistribution() {
        // Update pair allocations based on performance
        for i in 0..<pairAllocations.count {
            pairAllocations[i].performance.totalReturn = Double.random(in: -0.2...0.4)
            pairAllocations[i].performance.winRate = Double.random(in: 0.5...0.8)
            pairAllocations[i].performance.profitFactor = Double.random(in: 0.8...2.5)
        }
    }
    
    private func optimizeBasedOnPerformance() {
        // Allocate more to better performing accounts
        let sortedAccounts = accounts.sorted { $0.performance.totalReturn > $1.performance.totalReturn }
        
        for i in 0..<sortedAccounts.count {
            let performanceMultiplier = 1.0 + (sortedAccounts[i].performance.totalReturn * 0.1)
            let newTarget = sortedAccounts[i].targetAllocation * performanceMultiplier
            
            if let index = accounts.firstIndex(where: { $0.id == sortedAccounts[i].id }) {
                accounts[index].targetAllocation = min(0.6, max(0.1, newTarget))
            }
        }
        
        // Normalize allocations
        normalizeAllocations()
    }
    
    private func optimizeBasedOnRisk() {
        // Adjust allocations based on risk levels
        for i in 0..<accounts.count {
            let riskMultiplier = 1.0 / (1.0 + accounts[i].riskMetrics.riskScore)
            accounts[i].targetAllocation *= riskMultiplier
        }
        
        normalizeAllocations()
    }
    
    private func optimizeBasedOnCorrelation() {
        // Reduce allocations for highly correlated accounts
        for i in 0..<accounts.count {
            if accounts[i].riskMetrics.correlation > 0.8 {
                accounts[i].targetAllocation *= 0.9
            }
        }
        
        normalizeAllocations()
    }
    
    private func normalizeAllocations() {
        let totalTarget = accounts.reduce(0) { $0 + $1.targetAllocation }
        
        if totalTarget > 0 {
            for i in 0..<accounts.count {
                accounts[i].targetAllocation /= totalTarget
            }
        }
    }
    
    // MARK: - Rebalancing
    func startRebalancing() {
        guard rebalancingStatus != .balanced else { return }
        
        rebalancingStatus = .rebalancing
        
        // Simulate rebalancing process
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.executeRebalancing()
        }
    }
    
    private func executeRebalancing() {
        // Move capital between accounts to match target allocations
        for i in 0..<accounts.count {
            let targetBalance = accounts[i].targetAllocation * totalCapital
            let difference = targetBalance - accounts[i].balance
            
            if abs(difference) > 100 { // Only rebalance if difference is significant
                accounts[i].balance = targetBalance
                accounts[i].equity = targetBalance * (1.0 + Double.random(in: -0.05...0.05))
            }
        }
        
        // Update allocations
        updateAllocations()
        
        // Complete rebalancing
        rebalancingStatus = .balanced
    }
    
    // MARK: - Engine Control
    func activateEngine() {
        isActive = true
        startOptimization()
    }
    
    func deactivateEngine() {
        isActive = false
        isOptimizing = false
        rebalancingStatus = .balanced
    }
    
    // MARK: - Utility Methods
    func getTotalPortfolioValue() -> Double {
        return accounts.reduce(0) { $0 + $1.equity }
    }
    
    func getPortfolioReturn() -> Double {
        let totalEquity = getTotalPortfolioValue()
        return (totalEquity - totalCapital) / totalCapital
    }
    
    func getBestPerformingAccount() -> TradingAccount? {
        return accounts.max { $0.performance.totalReturn < $1.performance.totalReturn }
    }
    
    func getWorstPerformingAccount() -> TradingAccount? {
        return accounts.min { $0.performance.totalReturn < $1.performance.totalReturn }
    }
    
    func getAccountAllocation(accountId: UUID) -> Double {
        return accounts.first { $0.id == accountId }?.allocation ?? 0.0
    }
    
    func updateCapital(_ newCapital: Double) {
        let scaleFactor = newCapital / totalCapital
        totalCapital = newCapital
        
        // Scale all account balances proportionally
        for i in 0..<accounts.count {
            accounts[i].balance *= scaleFactor
            accounts[i].equity *= scaleFactor
        }
        
        updateAllocations()
    }
    
    func addAccount(_ account: TradingAccount) {
        accounts.append(account)
        updateAllocations()
    }
    
    func removeAccount(accountId: UUID) {
        accounts.removeAll { $0.id == accountId }
        updateAllocations()
    }
    
    func getAllocationSummary() -> AllocationSummary {
        return AllocationSummary(
            totalCapital: totalCapital,
            allocatedCapital: allocatedCapital,
            availableCapital: availableCapital,
            numberOfAccounts: accounts.count,
            numberOfBrokers: brokerAllocations.count,
            numberOfPairs: pairAllocations.count,
            rebalancingStatus: rebalancingStatus,
            lastOptimization: lastOptimizationTime
        )
    }
}

// MARK: - Supporting Types
struct AllocationSummary {
    let totalCapital: Double
    let allocatedCapital: Double
    let availableCapital: Double
    let numberOfAccounts: Int
    let numberOfBrokers: Int
    let numberOfPairs: Int
    let rebalancingStatus: CapitalAllocationEngine.RebalancingStatus
    let lastOptimization: Date
}

#Preview {
    VStack {
        Text("Capital Allocation Engine")
            .font(.title)
            .padding()
    }
}