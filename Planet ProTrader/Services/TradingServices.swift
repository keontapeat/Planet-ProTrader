//
//  TradingServices.swift
//  Planet ProTrader - Trading Business Logic
//
//  Advanced Trading Services and Logic
//  Created by Elite Engineering Team
//

import SwiftUI
import Foundation
import Combine

// MARK: - Trading View Model

@MainActor
class TradingViewModel: ObservableObject {
    @Published var currentPrice: Double = 2374.85
    @Published var priceChange: Double = 12.45
    @Published var priceChangePercentage: Double = 0.52
    @Published var isAutoTradingEnabled = false
    @Published var activeSignals: [GoldSignal] = []
    @Published var recentTrades: [Trade] = []
    @Published var marketData: MarketData?
    @Published var isLoading = false
    
    private var priceUpdateTimer: Timer?
    private var cancellables = Set<AnyCancellable>()
    
    struct Trade: Identifiable, Codable {
        let id: UUID
        let symbol: String
        let direction: TradeDirection
        let entryPrice: Double
        let exitPrice: Double?
        let lotSize: Double
        let openTime: Date
        let closeTime: Date?
        let profitLoss: Double
        let status: TradeStatus
        
        init(
            id: UUID = UUID(),
            symbol: String = "XAUUSD",
            direction: TradeDirection,
            entryPrice: Double,
            exitPrice: Double? = nil,
            lotSize: Double,
            openTime: Date = Date(),
            closeTime: Date? = nil,
            profitLoss: Double = 0,
            status: TradeStatus = .open
        ) {
            self.id = id
            self.symbol = symbol
            self.direction = direction
            self.entryPrice = entryPrice
            self.exitPrice = exitPrice
            self.lotSize = lotSize
            self.openTime = openTime
            self.closeTime = closeTime
            self.profitLoss = profitLoss
            self.status = status
        }
        
        var formattedProfitLoss: String {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.currencyCode = "USD"
            formatter.positivePrefix = "+"
            return formatter.string(from: NSNumber(value: profitLoss)) ?? "$0.00"
        }
        
        var durationString: String {
            let duration = (closeTime ?? Date()).timeIntervalSince(openTime)
            let hours = Int(duration / 3600)
            let minutes = Int((duration.truncatingRemainder(dividingBy: 3600)) / 60)
            return "\(hours)h \(minutes)m"
        }
    }
    
    init() {
        setupInitialData()
        startPriceUpdates()
    }
    
    deinit {
        stopPriceUpdates()
    }
    
    func refreshAllData() {
        Task {
            await refreshMarketData()
            await refreshSignals()
            await refreshTrades()
        }
    }
    
    func startAutoTrading() {
        isAutoTradingEnabled = true
        
        // Simulate starting auto trading
        Task {
            await simulateAutoTradingStart()
        }
    }
    
    func stopAutoTrading() {
        isAutoTradingEnabled = false
        
        // Simulate stopping auto trading
        Task {
            await simulateAutoTradingStop()
        }
    }
    
    private func setupInitialData() {
        marketData = MarketData(
            symbol: "XAUUSD",
            currentPrice: currentPrice,
            change24h: priceChange,
            changePercentage: priceChangePercentage,
            high24h: 2387.25,
            low24h: 2364.80,
            volume: 125000
        )
        
        activeSignals = GoldSignal.sampleSignals
        recentTrades = createSampleTrades()
    }
    
    private func startPriceUpdates() {
        priceUpdateTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
            self?.updatePrice()
        }
    }
    
    private func stopPriceUpdates() {
        priceUpdateTimer?.invalidate()
        priceUpdateTimer = nil
    }
    
    private func updatePrice() {
        let volatility = 0.5
        let change = Double.random(in: -volatility...volatility)
        currentPrice += change
        priceChange += change
        priceChangePercentage = (priceChange / (currentPrice - priceChange)) * 100
        
        // Update market data
        if var data = marketData {
            data = MarketData(
                id: data.id,
                symbol: data.symbol,
                currentPrice: currentPrice,
                change24h: priceChange,
                changePercentage: priceChangePercentage,
                high24h: max(data.high24h, currentPrice),
                low24h: min(data.low24h, currentPrice),
                volume: data.volume,
                lastUpdated: Date()
            )
            marketData = data
        }
    }
    
    private func refreshMarketData() async {
        isLoading = true
        
        // Simulate API call
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        updatePrice()
        isLoading = false
    }
    
    private func refreshSignals() async {
        // Simulate signal refresh
        try? await Task.sleep(nanoseconds: 300_000_000)
        
        // Randomly update signal statuses
        for i in activeSignals.indices {
            if Double.random(in: 0...1) > 0.8 {
                let newStatus: GoldSignal.SignalStatus = [.active, .filled, .cancelled].randomElement() ?? .active
                activeSignals[i] = GoldSignal(
                    id: activeSignals[i].id,
                    timestamp: activeSignals[i].timestamp,
                    type: activeSignals[i].type,
                    entryPrice: activeSignals[i].entryPrice,
                    stopLoss: activeSignals[i].stopLoss,
                    takeProfit: activeSignals[i].takeProfit,
                    confidence: activeSignals[i].confidence,
                    reasoning: activeSignals[i].reasoning,
                    timeframe: activeSignals[i].timeframe,
                    status: newStatus,
                    accuracy: activeSignals[i].accuracy,
                    source: activeSignals[i].source
                )
            }
        }
    }
    
    private func refreshTrades() async {
        // Simulate trade refresh
        try? await Task.sleep(nanoseconds: 200_000_000)
        
        // Randomly close some open trades
        for i in recentTrades.indices where recentTrades[i].status == .open {
            if Double.random(in: 0...1) > 0.9 {
                let pnl = Double.random(in: -100...200)
                recentTrades[i] = Trade(
                    id: recentTrades[i].id,
                    symbol: recentTrades[i].symbol,
                    direction: recentTrades[i].direction,
                    entryPrice: recentTrades[i].entryPrice,
                    exitPrice: currentPrice,
                    lotSize: recentTrades[i].lotSize,
                    openTime: recentTrades[i].openTime,
                    closeTime: Date(),
                    profitLoss: pnl,
                    status: pnl > 0 ? .win : .loss
                )
            }
        }
    }
    
    private func simulateAutoTradingStart() async {
        isLoading = true
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        // Add new signal when auto trading starts
        let newSignal = GoldSignal(
            type: .buy,
            entryPrice: currentPrice,
            stopLoss: currentPrice - 10.0,
            takeProfit: currentPrice + 20.0,
            confidence: 0.85,
            reasoning: "Auto trading initiated - bullish momentum detected",
            status: .active
        )
        activeSignals.insert(newSignal, at: 0)
        
        isLoading = false
    }
    
    private func simulateAutoTradingStop() async {
        isLoading = true
        try? await Task.sleep(nanoseconds: 800_000_000)
        
        // Cancel pending signals
        for i in activeSignals.indices where activeSignals[i].status == .pending {
            activeSignals[i] = GoldSignal(
                id: activeSignals[i].id,
                timestamp: activeSignals[i].timestamp,
                type: activeSignals[i].type,
                entryPrice: activeSignals[i].entryPrice,
                stopLoss: activeSignals[i].stopLoss,
                takeProfit: activeSignals[i].takeProfit,
                confidence: activeSignals[i].confidence,
                reasoning: activeSignals[i].reasoning,
                timeframe: activeSignals[i].timeframe,
                status: .cancelled,
                accuracy: activeSignals[i].accuracy,
                source: activeSignals[i].source
            )
        }
        
        isLoading = false
    }
    
    private func createSampleTrades() -> [Trade] {
        return [
            Trade(
                direction: .buy,
                entryPrice: 2370.50,
                exitPrice: 2385.20,
                lotSize: 0.1,
                openTime: Date().addingTimeInterval(-3600),
                closeTime: Date().addingTimeInterval(-1800),
                profitLoss: 147.0,
                status: .win
            ),
            Trade(
                direction: .sell,
                entryPrice: 2378.25,
                lotSize: 0.05,
                openTime: Date().addingTimeInterval(-1200),
                profitLoss: -25.50,
                status: .open
            ),
            Trade(
                direction: .buy,
                entryPrice: 2365.80,
                exitPrice: 2362.10,
                lotSize: 0.08,
                openTime: Date().addingTimeInterval(-7200),
                closeTime: Date().addingTimeInterval(-5400),
                profitLoss: -29.60,
                status: .loss
            )
        ]
    }
    
    // MARK: - Computed Properties
    
    var formattedCurrentPrice: String {
        String(format: "$%.2f", currentPrice)
    }
    
    var formattedPriceChange: String {
        let sign = priceChange >= 0 ? "+" : ""
        return "\(sign)$\(String(format: "%.2f", priceChange))"
    }
    
    var priceColor: Color {
        priceChange >= 0 ? .green : .red
    }
    
    var openTradesCount: Int {
        recentTrades.filter { $0.status == .open }.count
    }
    
    var totalProfitLoss: Double {
        recentTrades.reduce(0) { $0 + $1.profitLoss }
    }
    
    var winningTrades: Int {
        recentTrades.filter { $0.status == .win }.count
    }
    
    var losingTrades: Int {
        recentTrades.filter { $0.status == .loss }.count
    }
    
    var winRate: Double {
        let completedTrades = winningTrades + losingTrades
        return completedTrades > 0 ? Double(winningTrades) / Double(completedTrades) : 0
    }
}

// MARK: - Broker Connector Service

@MainActor
class BrokerConnector: ObservableObject {
    @Published var connectedBrokers: [BrokerConnection] = []
    @Published var availableBrokers: [BrokerInfo] = []
    @Published var isConnecting = false
    @Published var connectionStatus: ConnectionStatus = .disconnected
    
    struct BrokerConnection: Identifiable {
        let id = UUID()
        let brokerInfo: BrokerInfo
        let accountNumber: String
        let status: ConnectionStatus
        let lastConnected: Date
        let ping: Int // in milliseconds
    }
    
    struct BrokerInfo: Identifiable {
        let id = UUID()
        let name: String
        let icon: String
        let color: Color
        let supportedInstruments: [String]
        let minDeposit: Double
        let maxLeverage: Int
        let spreads: [String: Double] // instrument -> spread
        let features: [String]
        
        static let availableBrokers = [
            BrokerInfo(
                name: "MetaTrader 5",
                icon: "chart.bar.fill",
                color: .blue,
                supportedInstruments: ["XAUUSD", "EURUSD", "GBPUSD", "USDJPY"],
                minDeposit: 100,
                maxLeverage: 1000,
                spreads: ["XAUUSD": 0.35, "EURUSD": 0.1],
                features: ["Expert Advisors", "Copy Trading", "Market Depth"]
            ),
            BrokerInfo(
                name: "cTrader",
                icon: "chart.line.uptrend.xyaxis",
                color: .green,
                supportedInstruments: ["XAUUSD", "SILVER", "OIL"],
                minDeposit: 500,
                maxLeverage: 500,
                spreads: ["XAUUSD": 0.28, "EURUSD": 0.08],
                features: ["Advanced Charts", "Level II Pricing", "ECN Trading"]
            ),
            BrokerInfo(
                name: "OANDA",
                icon: "dollarsign.circle.fill",
                color: .orange,
                supportedInstruments: ["XAUUSD", "FOREX", "CFDs"],
                minDeposit: 1,
                maxLeverage: 50,
                spreads: ["XAUUSD": 0.45, "EURUSD": 0.12],
                features: ["Micro Lots", "API Access", "TradingView Integration"]
            )
        ]
    }
    
    enum ConnectionStatus {
        case connected, connecting, disconnected, error
        
        var color: Color {
            switch self {
            case .connected: return .green
            case .connecting: return .blue
            case .disconnected: return .gray
            case .error: return .red
            }
        }
        
        var icon: String {
            switch self {
            case .connected: return "checkmark.circle.fill"
            case .connecting: return "arrow.clockwise.circle.fill"
            case .disconnected: return "xmark.circle.fill"
            case .error: return "exclamationmark.triangle.fill"
            }
        }
    }
    
    init() {
        availableBrokers = BrokerInfo.availableBrokers
    }
    
    func connectToBroker(_ broker: BrokerInfo, accountNumber: String, password: String) async {
        isConnecting = true
        connectionStatus = .connecting
        
        // Simulate connection process
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        
        // Simulate random connection success/failure
        let success = Double.random(in: 0...1) > 0.2
        
        if success {
            let connection = BrokerConnection(
                brokerInfo: broker,
                accountNumber: accountNumber,
                status: .connected,
                lastConnected: Date(),
                ping: Int.random(in: 50...200)
            )
            connectedBrokers.append(connection)
            connectionStatus = .connected
        } else {
            connectionStatus = .error
        }
        
        isConnecting = false
    }
    
    func disconnectFromBroker(_ connection: BrokerConnection) {
        connectedBrokers.removeAll { $0.id == connection.id }
        
        if connectedBrokers.isEmpty {
            connectionStatus = .disconnected
        }
    }
    
    func testConnection(_ connection: BrokerConnection) async -> Int {
        // Simulate ping test
        try? await Task.sleep(nanoseconds: 500_000_000)
        return Int.random(in: 30...500)
    }
}

// MARK: - Real Data Manager

@MainActor
class RealDataManager: ObservableObject {
    @Published var historicalData: [PricePoint] = []
    @Published var realTimePrice: Double = 2374.85
    @Published var isStreaming = false
    @Published var lastUpdate = Date()
    @Published var dataQuality: DataQuality = .excellent
    
    struct PricePoint: Identifiable {
        let id = UUID()
        let timestamp: Date
        let open: Double
        let high: Double
        let low: Double
        let close: Double
        let volume: Double
    }
    
    enum DataQuality: String, CaseIterable {
        case poor = "Poor"
        case fair = "Fair"
        case good = "Good"
        case excellent = "Excellent"
        
        var color: Color {
            switch self {
            case .poor: return .red
            case .fair: return .orange
            case .good: return .blue
            case .excellent: return .green
            }
        }
        
        var icon: String {
            switch self {
            case .poor: return "wifi.slash"
            case .fair: return "wifi.exclamationmark"
            case .good: return "wifi"
            case .excellent: return "wifi.circle.fill"
            }
        }
    }
    
    private var streamingTimer: Timer?
    
    func startRealTimeStreaming() {
        isStreaming = true
        
        streamingTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateRealTimePrice()
        }
    }
    
    func stopRealTimeStreaming() {
        isStreaming = false
        streamingTimer?.invalidate()
        streamingTimer = nil
    }
    
    func loadHistoricalData(timeframe: String, count: Int) async {
        // Simulate data loading
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        historicalData = generateSampleData(count: count)
        dataQuality = .excellent
    }
    
    private func updateRealTimePrice() {
        let volatility = 0.3
        let change = Double.random(in: -volatility...volatility)
        realTimePrice += change
        lastUpdate = Date()
        
        // Simulate occasional data quality changes
        if Double.random(in: 0...1) > 0.95 {
            dataQuality = DataQuality.allCases.randomElement() ?? .excellent
        }
    }
    
    private func generateSampleData(count: Int) -> [PricePoint] {
        var data: [PricePoint] = []
        var currentPrice = 2374.85
        let now = Date()
        
        for i in 0..<count {
            let timestamp = now.addingTimeInterval(TimeInterval(-i * 60))
            let volatility = Double.random(in: 0.5...2.0)
            
            let open = currentPrice
            let high = open + Double.random(in: 0...volatility)
            let low = open - Double.random(in: 0...volatility)
            let close = Double.random(in: low...high)
            let volume = Double.random(in: 1000...5000)
            
            data.append(PricePoint(
                timestamp: timestamp,
                open: open,
                high: high,
                low: low,
                close: close,
                volume: volume
            ))
            
            currentPrice = close
        }
        
        return data.reversed()
    }
}

// MARK: - Previews

#Preview("Trading Services") {
    VStack(spacing: 20) {
        Text("Trading Services Preview")
            .font(.title.bold())
        
        HStack(spacing: 16) {
            StatCard(title: "Current Price", value: "$2,374.85", color: .green, icon: "dollarsign.circle.fill")
            StatCard(title: "24h Change", value: "+0.52%", color: .green, icon: "arrow.up.circle.fill")
            StatCard(title: "Open Trades", value: "7", color: .blue, icon: "chart.bar.fill")
        }
        
        Text("✅ All Trading Services Ready")
            .font(.headline)
            .foregroundColor(.green)
    }
    .padding()
    .preferredColorScheme(.light)
}