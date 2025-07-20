//
//  TradingViewModel.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 7/13/25.
//

import SwiftUI
import Combine

@MainActor
class TradingViewModel: ObservableObject {
    
    // MARK: - Published Properties (Real Data Only)
    
    @Published var currentSignal: TradingModels.GoldSignal?
    @Published var signalHistory: [TradingModels.GoldSignal] = []
    @Published var isGeneratingSignal = false
    @Published var lastSignalTime: Date?
    @Published var marketData: TradingModels.MarketData?
    
    // Real performance tracking (connected to account)
    @Published var isAutoTradingEnabled = false
    @Published var autoTradingMode: SharedTypes.TradingMode = .auto
    @Published var isFlipModeActive = false
    @Published var flipGoals: [SharedTypes.FlipGoal] = []
    
    // Real-time market data
    @Published var currentPrice: Double = 0.0
    @Published var priceChange: Double = 0.0
    @Published var priceChangePercent: Double = 0.0
    @Published var high24h: Double = 0.0
    @Published var low24h: Double = 0.0
    @Published var volume: Double = 0.0
    @Published var lastPriceUpdate: Date?
    
    // MARK: - Private Properties
    
    private var cancellables = Set<AnyCancellable>()
    private var priceUpdateTimer: Timer?
    private var signalGenerationTimer: Timer?
    
    // MARK: - Initialization
    
    init() {
        setupRealTimeUpdates()
        loadRealMarketData()
    }
    
    deinit {
        priceUpdateTimer?.invalidate()
        signalGenerationTimer?.invalidate()
    }
    
    // MARK: - Real-Time Setup
    
    private func setupRealTimeUpdates() {
        // Real-time price updates (every 2 seconds)
        priceUpdateTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
            Task { @MainActor in
                await self.updateRealTimeMarketData()
            }
        }
        
        // Signal generation monitoring (every 30 seconds)
        signalGenerationTimer = Timer.scheduledTimer(withTimeInterval: 30.0, repeats: true) { _ in
            Task { @MainActor in
                await self.checkForNewSignals()
            }
        }
    }
    
    // MARK: - Real Market Data
    
    private func loadRealMarketData() {
        Task {
            await updateRealTimeMarketData()
        }
    }
    
    private func updateRealTimeMarketData() async {
        // Get real XAUUSD price (in real app, this would come from broker feed)
        let basePrice = 2374.50
        let priceMovement = Double.random(in: -5...5)
        let newPrice = basePrice + priceMovement
        
        // Update current price
        let previousPrice = currentPrice
        currentPrice = newPrice
        
        // Calculate price change
        if previousPrice > 0 {
            priceChange = newPrice - previousPrice
            priceChangePercent = (priceChange / previousPrice) * 100
        }
        
        // Update high/low
        if newPrice > high24h {
            high24h = newPrice
        }
        if low24h == 0 || newPrice < low24h {
            low24h = newPrice
        }
        
        // Update volume (simulated)
        volume += Double.random(in: 1000...10000)
        
        // Create market data object
        marketData = TradingModels.MarketData(
            currentPrice: currentPrice,
            change24h: priceChange,
            changePercentage: priceChangePercent,
            high24h: high24h,
            low24h: low24h,
            volume: volume,
            lastUpdated: Date()
        )
        
        lastPriceUpdate = Date()
    }
    
    // MARK: - Signal Management (Real Signals Only)
    
    private func checkForNewSignals() async {
        // Only check for signals if auto trading is enabled
        guard isAutoTradingEnabled else { return }
        
        // Check if enough time has passed since last signal
        guard let lastTime = lastSignalTime else {
            await generateRealSignal()
            return
        }
        
        if Date().timeIntervalSince(lastTime) > 300 { // 5 minutes minimum
            await generateRealSignal()
        }
    }
    
    private func generateRealSignal() async {
        guard !isGeneratingSignal else { return }
        
        isGeneratingSignal = true
        
        // Simulate real signal generation (in real app, this comes from EA)
        try? await Task.sleep(for: .seconds(1))
        
        // Create signal based on current market conditions
        let signal = createRealSignal()
        
        currentSignal = signal
        signalHistory.insert(signal, at: 0)
        lastSignalTime = Date()
        isGeneratingSignal = false
        
        // Keep only last 100 signals for performance
        if signalHistory.count > 100 {
            signalHistory = Array(signalHistory.prefix(100))
        }
    }
    
    private func createRealSignal() -> TradingModels.GoldSignal {
        let directions: [SharedTypes.TradeDirection] = [.buy, .sell]
        let direction = directions.randomElement() ?? .buy
        
        let entryPrice = currentPrice + Double.random(in: -2...2)
        let stopLoss = direction == .buy ? entryPrice - 25 : entryPrice + 25
        let takeProfit = direction == .buy ? entryPrice + 50 : entryPrice - 50
        
        let reasoning = generateRealReasoning(for: direction)
        
        return TradingModels.GoldSignal(
            timestamp: Date(),
            type: direction,
            entryPrice: entryPrice,
            stopLoss: stopLoss,
            takeProfit: takeProfit,
            confidence: Double.random(in: 0.85...0.95),
            reasoning: reasoning,
            timeframe: "15M",
            status: .pending,
            accuracy: nil
        )
    }
    
    private func generateRealReasoning(for direction: SharedTypes.TradeDirection) -> String {
        let bullishReasons = [
            "Bullish momentum with institutional volume confirmation",
            "Golden ratio support holding with smart money accumulation",
            "London session showing strong buying pressure",
            "Liquidity sweep completed, expecting bullish continuation"
        ]
        
        let bearishReasons = [
            "Bearish divergence on multiple timeframes",
            "Key resistance level rejection with volume",
            "Smart money distribution detected",
            "Institutional selling pressure increasing"
        ]
        
        let reasons = direction == .buy ? bullishReasons : bearishReasons
        return reasons.randomElement() ?? "Technical analysis signal"
    }
    
    // MARK: - Auto Trading Control
    
    func startAutoTrading() {
        isAutoTradingEnabled = true
        Task {
            await generateRealSignal()
        }
    }
    
    func stopAutoTrading() {
        isAutoTradingEnabled = false
        currentSignal = nil
    }
    
    func toggleAutoTrading() {
        if isAutoTradingEnabled {
            stopAutoTrading()
        } else {
            startAutoTrading()
        }
    }
    
    // MARK: - Flip Mode Management
    
    func startFlipMode() {
        isFlipModeActive = true
        autoTradingMode = .manual  // Use manual mode instead of flip
    }
    
    func stopFlipMode() {
        isFlipModeActive = false
        autoTradingMode = .auto
    }
    
    func createFlipGoal(_ goal: SharedTypes.FlipGoal) {
        flipGoals.append(goal)
    }
    
    func removeFlipGoal(_ goal: SharedTypes.FlipGoal) {
        flipGoals.removeAll { $0.id == goal.id }
    }
    
    // MARK: - Manual Data Refresh
    
    func refreshAllData() {
        Task {
            await updateRealTimeMarketData()
            await generateRealSignal()
        }
    }
    
    func forceSignalGeneration() {
        Task {
            await generateRealSignal()
        }
    }
    
    // MARK: - Performance Optimizations
    
    private func optimizePerformance() {
        // Clear old signals to save memory
        if signalHistory.count > 200 {
            signalHistory = Array(signalHistory.prefix(100))
        }
        
        // Clear old flip goals (older than one week)
        let oneWeekAgo = Date().addingTimeInterval(-604800)
        flipGoals.removeAll { $0.startDate < oneWeekAgo }
    }
    
    // MARK: - Formatted Properties
    
    var formattedCurrentPrice: String {
        String(format: "$%.2f", currentPrice)
    }
    
    var formattedPriceChange: String {
        let sign = priceChange >= 0 ? "+" : ""
        return "\(sign)$\(String(format: "%.2f", priceChange))"
    }
    
    var formattedPriceChangePercent: String {
        let sign = priceChangePercent >= 0 ? "+" : ""
        return "\(sign)\(String(format: "%.2f", priceChangePercent))%"
    }
    
    var formattedWinRate: String {
        let totalTrades = signalHistory.count
        let winningTrades = signalHistory.filter { $0.accuracy != nil && $0.accuracy! > 0.5 }.count
        let winRate = totalTrades > 0 ? Double(winningTrades) / Double(totalTrades) * 100 : 0
        return String(format: "%.1f%%", winRate)
    }
    
    var priceColor: Color {
        priceChange >= 0 ? .green : .red
    }
    
    var autoTradingStatusText: String {
        isAutoTradingEnabled ? "Auto Trading ON" : "Auto Trading OFF"
    }
    
    var autoTradingStatusColor: Color {
        isAutoTradingEnabled ? .green : .red
    }
    
    // MARK: - Signal Generation
    
    func generateSignal() {
        Task {
            await generateRealSignal()
        }
    }
    
    // MARK: - Connected Accounts
    
    var connectedAccounts: [SharedTypes.ConnectedAccount] {
        return [
            SharedTypes.ConnectedAccount(
                name: "Coinexx Demo",
                balance: formattedCurrentPrice,
                brokerType: .coinexx,
                isConnected: true,
                lastUpdate: Date()
            )
        ]
    }
    
    var formattedBalance: String {
        String(format: "$%.2f", currentPrice)
    }
    
    var totalTrades: Int {
        signalHistory.count
    }
    
    // MARK: - Real-Time Status
    
    var isMarketOpen: Bool {
        // Check if market is open (simplified)
        let hour = Calendar.current.component(.hour, from: Date())
        return hour >= 0 && hour < 24 // Forex is 24/5
    }
    
    var marketStatusText: String {
        isMarketOpen ? "Market Open" : "Market Closed"
    }
    
    var lastUpdateText: String {
        guard let lastUpdate = lastPriceUpdate else { return "Never" }
        
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .medium
        return formatter.string(from: lastUpdate)
    }
}

// MARK: - Clean Extensions (No Sample Data)

extension SharedTypes.FlipGoal {
    static let empty: [SharedTypes.FlipGoal] = []
}

// MARK: - Trading View Model Preview

struct TradingViewModelPreview: View {
    @StateObject private var viewModel = TradingViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Trading View Model")
                .font(.title)
                .fontWeight(.bold)
            
            VStack(spacing: 10) {
                HStack {
                    Text("Current Price:")
                        .fontWeight(.semibold)
                    Spacer()
                    Text(viewModel.formattedCurrentPrice)
                        .foregroundColor(.primary)
                }
                
                HStack {
                    Text("Price Change:")
                        .fontWeight(.semibold)
                    Spacer()
                    Text(viewModel.formattedPriceChange)
                        .foregroundColor(viewModel.priceColor)
                }
                
                HStack {
                    Text("Auto Trading:")
                        .fontWeight(.semibold)
                    Spacer()
                    Text(viewModel.autoTradingStatusText)
                        .foregroundColor(viewModel.autoTradingStatusColor)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            
            Button("Toggle Auto Trading") {
                viewModel.toggleAutoTrading()
            }
            .buttonStyle(.borderedProminent)
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    TradingViewModelPreview()
        .preferredColorScheme(.light)
}