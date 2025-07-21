import Foundation
import SwiftUI
import Combine

@MainActor
class RealTimeAccountManager: ObservableObject {
    @Published var activeAccounts: [MasterSharedTypes.TradingAccountDetails] = []
    @Published var selectedAccountIndex: Int = 0
    @Published var isConnected: Bool = false
    @Published var lastUpdate: Date = Date()
    @Published var activeTrades: [RealTimeTrade] = []
    @Published var eaSignals: [EASignal] = []
    
    // Account balance properties - ALL REQUIRED PROPERTIES FOR HomeDashboardView
    @Published var balance: Double = 1270.45
    @Published var currentEquity: Double = 1270.45
    @Published var equity: Double = 1270.45  // ✅ FIXED: Matches HomeDashboardView usage
    @Published var floatingPnL: Double = 0.0
    @Published var todaysPnL: Double = 0.0
    @Published var todaysProfit: Double = 0.0  // ✅ FIXED: Added for HomeDashboardView
    @Published var freeMargin: Double = 0.0
    
    // Trading statistics  
    @Published var openPositions: [TradingPosition] = []
    @Published var currentDrawdown: Double = 0.0
    @Published var totalProfit: Double = 0.0
    @Published var totalLoss: Double = 0.0
    @Published var winRate: Double = 0.0
    @Published var averageWin: Double = 0.0
    @Published var averageLoss: Double = 0.0
    @Published var todayTrades: Int = 0
    @Published var bestTrade: Double = 0.0
    @Published var worstTrade: Double = 0.0
    
    // EA Status
    @Published var eaIsRunning: Bool = true
    @Published var eaCanTrade: Bool = true
    @Published var connectionStatus: String = "Connected"
    @Published var serverTime: Date = Date()
    @Published var eaPerformance: EAPerformance = EAPerformance()
    
    private var cancellables = Set<AnyCancellable>()
    private var refreshTimer: Timer?
    
    init() {
        setupDemoAccounts()
        setupDemoTrades()
        setupDemoSignals()
        startPeriodicRefresh()
    }
    
    deinit {
        refreshTimer?.invalidate()
        refreshTimer = nil
    }
    
    // MARK: - ✅ FIXED: All Computed Properties for HomeDashboardView
    
    var currentAccount: MasterSharedTypes.TradingAccountDetails? {
        guard selectedAccountIndex < activeAccounts.count else { return nil }
        return activeAccounts[selectedAccountIndex]
    }
    
    var formattedBalance: String {
        return String(format: "$%.2f", balance)
    }
    
    var formattedEquity: String {  // ✅ FIXED: Was missing
        return String(format: "$%.2f", equity)
    }
    
    var formattedTodaysProfit: String {  // ✅ FIXED: Was missing
        return String(format: "%+.2f", todaysProfit)
    }
    
    var todaysProfitColor: Color {  // ✅ FIXED: Was missing
        return todaysProfit >= 0 ? .green : .red
    }
    
    var totalOpenPL: Double {
        return openPositions.reduce(0) { $0 + $1.unrealizedPL }
    }
    
    var formattedOpenPL: String {
        let sign = totalOpenPL >= 0 ? "+" : ""
        return "\(sign)$\(String(format: "%.2f", totalOpenPL))"
    }
    
    var openPLColor: Color {
        return totalOpenPL >= 0 ? .green : .red
    }
    
    var formattedWinRate: String {
        return String(format: "%.1f%%", winRate * 100)
    }
    
    var formattedTodaysPnL: String {
        return String(format: "%+.2f", todaysPnL)
    }
    
    var formattedFloatingPnL: String {
        return String(format: "%+.2f", floatingPnL)
    }
    
    var pnlColor: Color {
        return todaysPnL >= 0 ? .green : .red
    }
    
    var eaStatusColor: Color {
        return eaIsRunning ? .green : .red
    }
    
    // MARK: - EA Control Methods
    
    func startEATrading() {
        eaIsRunning = true
        eaCanTrade = true
        connectionStatus = "EA Started"
        
        NotificationCenter.default.post(name: .eaStatusChanged, object: nil)
    }
    
    func stopEATrading() {
        eaIsRunning = false
        eaCanTrade = false
        connectionStatus = "EA Stopped"
        
        NotificationCenter.default.post(name: .eaStatusChanged, object: nil)
    }
    
    func pauseEATrading() {
        eaCanTrade = false
        connectionStatus = "EA Paused"
        
        NotificationCenter.default.post(name: .eaStatusChanged, object: nil)
    }
    
    func resumeEATrading() {
        eaCanTrade = true
        connectionStatus = "EA Resumed"
        
        NotificationCenter.default.post(name: .eaStatusChanged, object: nil)
    }
    
    // MARK: - Public Methods
    
    func switchToAccount(at index: Int) {
        guard index < activeAccounts.count else { return }
        selectedAccountIndex = index
        
        if let account = currentAccount {
            balance = account.balance
            currentEquity = account.equity
            equity = account.equity
            todaysPnL = Double.random(in: -100...200)
            todaysProfit = todaysPnL  // ✅ FIXED: Sync these values
        }
        
        NotificationCenter.default.post(name: .accountBalanceUpdated, object: nil)
        
        Task {
            await refreshAccountData()
        }
    }
    
    func refreshAccountData() async {
        isConnected = true
        lastUpdate = Date()
        serverTime = Date()
        
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        for i in 0..<activeAccounts.count {
            activeAccounts[i] = generateUpdatedAccount(from: activeAccounts[i])
        }
        
        if let account = currentAccount {
            balance = account.balance
            currentEquity = account.equity
            equity = account.equity
            todaysPnL = Double.random(in: -100...200)
            todaysProfit = todaysPnL  // ✅ FIXED: Keep in sync
            floatingPnL = account.equity - account.balance
        }
        
        updateTradingStatistics()
        NotificationCenter.default.post(name: .accountBalanceUpdated, object: nil)
    }
    
    func refreshAccountData() {
        Task {
            await refreshAccountData()
        }
    }
    
    func addAccount(_ account: MasterSharedTypes.TradingAccountDetails) {
        activeAccounts.append(account)
    }
    
    func removeAccount(at index: Int) {
        guard index < activeAccounts.count else { return }
        activeAccounts.remove(at: index)
        
        if selectedAccountIndex >= activeAccounts.count {
            selectedAccountIndex = max(0, activeAccounts.count - 1)
        }
    }
    
    // MARK: - Private Methods
    
    private func setupDemoAccounts() {
        activeAccounts = [
            MasterSharedTypes.TradingAccountDetails(
                accountNumber: "845638",
                broker: .coinexx,
                accountType: "Demo",
                balance: 1270.45,
                equity: 1270.45,
                freeMargin: 1000.0,
                leverage: 100
            ),
            MasterSharedTypes.TradingAccountDetails(
                accountNumber: "123456",
                broker: .mt5,
                accountType: "Live",
                balance: 5000.0,
                equity: 5247.50,
                freeMargin: 4500.0,
                leverage: 50,
                isActive: false
            )
        ]
        
        if let account = currentAccount {
            balance = account.balance
            equity = account.equity
            currentEquity = account.equity
            todaysProfit = Double.random(in: -100...200)
            todaysPnL = todaysProfit  // ✅ FIXED: Keep in sync
        }
    }
    
    private func setupDemoTrades() {
        activeTrades = [
            RealTimeTrade(
                ticket: "123456789",
                symbol: "XAUUSD",
                direction: .buy,
                openPrice: 2670.50,
                currentPrice: 2675.25,
                lotSize: 0.01,
                floatingPnL: 47.50,
                openTime: Date().addingTimeInterval(-3600)
            ),
            RealTimeTrade(
                ticket: "987654321",
                symbol: "XAUUSD",
                direction: .sell,
                openPrice: 2680.00,
                currentPrice: 2675.25,
                lotSize: 0.02,
                floatingPnL: 95.00,
                openTime: Date().addingTimeInterval(-1800)
            )
        ]
        
        openPositions = [
            TradingPosition(
                id: UUID(),
                symbol: "XAUUSD",
                direction: .buy,
                lotSize: 0.01,
                entryPrice: 2670.50,
                currentPrice: 2675.25,
                stopLoss: 2650.00,
                takeProfit: 2700.00,
                openTime: Date().addingTimeInterval(-3600),
                unrealizedPL: 47.50,
                realizedPL: 0,
                closeTime: nil
            ),
            TradingPosition(
                id: UUID(),
                symbol: "XAUUSD",
                direction: .sell,
                lotSize: 0.02,
                entryPrice: 2680.00,
                currentPrice: 2675.25,
                stopLoss: 2690.00,
                takeProfit: 2660.00,
                openTime: Date().addingTimeInterval(-1800),
                unrealizedPL: 95.00,
                realizedPL: 0,
                closeTime: nil
            )
        ]
    }
    
    private func setupDemoSignals() {
        eaSignals = [
            EASignal(
                direction: .buy,
                confidence: 0.85,
                reasoning: "Strong bullish momentum above 2670 support",
                timestamp: Date().addingTimeInterval(-300)
            ),
            EASignal(
                direction: .sell,
                confidence: 0.72,
                reasoning: "Resistance at 2680 level holding",
                timestamp: Date().addingTimeInterval(-600)
            ),
            EASignal(
                direction: .hold,
                confidence: 0.45,
                reasoning: "Mixed signals, waiting for clearer direction",
                timestamp: Date().addingTimeInterval(-900)
            )
        ]
    }
    
    private func updateTradingStatistics() {
        todayTrades = Int.random(in: 15...25)
        winRate = Double.random(in: 0.6...0.8)
        bestTrade = Double.random(in: 50...150)
        worstTrade = Double.random(in: -75...(-25))
        freeMargin = balance * 0.8
        
        totalProfit = Double.random(in: 500...1500)
        totalLoss = Double.random(in: -500...(-100))
        averageWin = bestTrade
        averageLoss = worstTrade
        currentDrawdown = Double.random(in: 0...5)
        
        eaPerformance = EAPerformance(
            totalTrades: todayTrades,
            winningTrades: Int(Double(todayTrades) * winRate),
            losingTrades: Int(Double(todayTrades) * (1 - winRate)),
            totalProfit: todaysPnL,
            averageWin: bestTrade,
            averageLoss: worstTrade,
            winRate: winRate,
            profitFactor: abs(todaysPnL / worstTrade),
            tradesPerHour: Double(todayTrades) / 8.0
        )
    }
    
    private func startPeriodicRefresh() {
        refreshTimer = Timer.scheduledTimer(withTimeInterval: 30.0, repeats: true) { _ in
            Task {
                await self.refreshAccountData()
            }
        }
    }
    
    private func generateUpdatedAccount(from account: MasterSharedTypes.TradingAccountDetails) -> MasterSharedTypes.TradingAccountDetails {
        let balanceChange = Double.random(in: -50...50)
        let profitChange = Double.random(in: -25...25)
        
        return MasterSharedTypes.TradingAccountDetails(
            accountNumber: account.accountNumber,
            broker: account.broker,
            accountType: account.accountType,
            balance: max(0, account.balance + balanceChange),
            equity: max(0, account.equity + balanceChange + profitChange),
            freeMargin: account.freeMargin,
            leverage: account.leverage,
            isActive: account.accountType == "Demo" ? true : Bool.random()
        )
    }
}

// MARK: - TradingPosition struct (FIXED: Updated to use MasterSharedTypes.TradeDirection)
struct TradingPosition: Identifiable, Codable {
    let id: UUID
    let symbol: String
    let direction: MasterSharedTypes.TradeDirection  // ✅ FIXED: Use MasterSharedTypes
    let lotSize: Double
    let entryPrice: Double
    var currentPrice: Double
    let stopLoss: Double
    let takeProfit: Double
    let openTime: Date
    var unrealizedPL: Double
    var realizedPL: Double
    var closeTime: Date?
    
    var formattedLotSize: String {
        String(format: "%.2f", lotSize)
    }
    
    var formattedEntryPrice: String {
        String(format: "%.2f", entryPrice)
    }
    
    var formattedCurrentPrice: String {
        String(format: "%.2f", currentPrice)
    }
    
    var formattedUnrealizedPL: String {
        let sign = unrealizedPL >= 0 ? "+" : ""
        return "\(sign)$\(String(format: "%.2f", unrealizedPL))"
    }
    
    var plColor: Color {
        unrealizedPL >= 0 ? .green : .red
    }
    
    var directionColor: Color {
        direction == .buy ? .green : .red
    }
    
    var isPositive: Bool {
        unrealizedPL >= 0
    }
}

// MARK: - EASignal and Supporting Types (FIXED: Updated to use MasterSharedTypes)
struct EASignal: Identifiable {
    let id = UUID()
    let direction: MasterSharedTypes.TradeDirection  // ✅ FIXED
    let confidence: Double
    let reasoning: String
    let timestamp: Date
    
    init(direction: MasterSharedTypes.TradeDirection, confidence: Double, reasoning: String, timestamp: Date) {
        self.direction = direction
        self.confidence = confidence
        self.reasoning = reasoning
        self.timestamp = timestamp
    }
}

// MARK: - Additional Supporting Types
struct RealTimeTrade: Identifiable {
    let id = UUID()
    let ticket: String
    let symbol: String
    let direction: MasterSharedTypes.TradeDirection  // ✅ FIXED
    let openPrice: Double
    let currentPrice: Double
    let lotSize: Double
    let floatingPnL: Double
    let openTime: Date
    
    init(ticket: String, symbol: String, direction: MasterSharedTypes.TradeDirection, openPrice: Double, currentPrice: Double, lotSize: Double, floatingPnL: Double, openTime: Date) {
        self.ticket = ticket
        self.symbol = symbol
        self.direction = direction
        self.openPrice = openPrice
        self.currentPrice = currentPrice
        self.lotSize = lotSize
        self.floatingPnL = floatingPnL
        self.openTime = openTime
    }
}

// MARK: - EA Performance
struct EAPerformance: Codable {
    let totalTrades: Int
    let winningTrades: Int
    let losingTrades: Int
    let totalProfit: Double
    let averageWin: Double
    let averageLoss: Double
    let winRate: Double
    let profitFactor: Double
    let tradesPerHour: Double
    
    init(totalTrades: Int = 0, winningTrades: Int = 0, losingTrades: Int = 0, totalProfit: Double = 0.0, averageWin: Double = 0.0, averageLoss: Double = 0.0, winRate: Double = 0.0, profitFactor: Double = 0.0, tradesPerHour: Double = 0.0) {
        self.totalTrades = totalTrades
        self.winningTrades = winningTrades
        self.losingTrades = losingTrades
        self.totalProfit = totalProfit
        self.averageWin = averageWin
        self.averageLoss = averageLoss
        self.winRate = winRate
        self.profitFactor = profitFactor
        self.tradesPerHour = tradesPerHour
    }
}

// MARK: - Extensions

extension RealTimeAccountManager {
    func connectToGoldexAPI() {
        Task {
            do {
                await refreshAccountData()
            } catch {
                print("Failed to connect to GOLDEX API: \(error)")
            }
        }
    }
}

#Preview("Real-Time Account Manager") {
    VStack(spacing: 20) {
        Text("GOLDEX AI - Account Manager ✅")
            .font(.title)
            .foregroundColor(DesignSystem.primaryGold)
        
        VStack(alignment: .leading, spacing: 8) {
            Text("Account Balance")
                .font(.headline)
            Text("$1,270.45")
                .font(.title2)
                .foregroundColor(.green)
            
            Text("Status: Connected")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
        
        VStack(alignment: .leading, spacing: 8) {
            Text("EA Status")
                .font(.headline)
            Text("Running")
                .font(.title2)
                .foregroundColor(.green)
            
            Text("Today's Trades: 15")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
    .padding()
    .environmentObject(RealTimeAccountManager())
}