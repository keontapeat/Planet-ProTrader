//
//  ChartDataService.swift
//  Planet ProTrader
//
//  Created by Senior iOS Engineer - Missing Dependency Fix
//

import SwiftUI
import Combine

@MainActor
class ChartDataService: ObservableObject {
    static let shared = ChartDataService()
    
    // MARK: - Published Properties
    @Published var currentInstrument = TradingInstrument.sampleInstruments[0]
    @Published var currentPrice: Double = 2374.50
    @Published var bid: Double = 2374.25
    @Published var ask: Double = 2374.75
    @Published var spread: Double = 0.50
    @Published var isLoadingData = false
    @Published var connectionStatus: ConnectionStatus = .connected
    @Published var lastUpdateTime = Date()
    @Published var candleData: [CandlestickData] = []
    @Published var visibleCandleData: [CandlestickData] = []
    @Published var liveOrders: [LiveTradingOrder] = []
    @Published var botSignals: [BotSignal] = []
    @Published var botTrades: [LiveTradingOrder] = []
    @Published var activeBots: [ActiveBot] = []
    @Published var isAutoTradingActive = false
    @Published var totalBotPL: Double = 247.50
    @Published var botWinRate: Double = 0.87
    @Published var activeBotTrades = 3
    @Published var isChartFullyLoaded = false
    @Published var cachedPriceRange: Double = 0.0
    @Published var reducedAnimationMode = false
    
    enum ConnectionStatus: String, CaseIterable {
        case connected = "Connected"
        case connecting = "Connecting"
        case disconnected = "Disconnected"
        case error = "Error"
        
        var color: Color {
            switch self {
            case .connected: return .green
            case .connecting: return .orange
            case .disconnected: return .gray
            case .error: return .red
            }
        }
        
        var icon: String {
            switch self {
            case .connected: return "wifi"
            case .connecting: return "wifi.slash"
            case .disconnected: return "wifi.slash"
            case .error: return "wifi.exclamationmark"
            }
        }
    }
    
    struct ActiveBot {
        let id = UUID()
        let name: String
        let isPerformingWell: Bool
        
        init(name: String, isPerformingWell: Bool = true) {
            self.name = name
            self.isPerformingWell = isPerformingWell
        }
    }
    
    private init() {
        generateSampleData()
        startRealTimeUpdates()
    }
    
    func changeTimeframe(_ timeframe: MasterSharedTypes.ChartTimeframe) {
        generateSampleData()
    }
    
    func getNextCandleCountdown() -> String {
        let countdown = 60 - Calendar.current.component(.second, from: Date())
        return "\(countdown)s"
    }
    
    func generateSampleBotDataAsync() async {
        isLoadingData = true
        
        // Simulate loading delay
        try? await Task.sleep(for: .seconds(0.5))
        
        await MainActor.run {
            generateBotData()
            isChartFullyLoaded = true
            isLoadingData = false
        }
    }
    
    private func generateSampleData() {
        // Generate candlestick data
        candleData = (0..<100).map { index in
            let basePrice = 2374.50
            let variation = Double.random(in: -5...5)
            let open = basePrice + variation
            let close = open + Double.random(in: -2...2)
            let high = max(open, close) + Double.random(in: 0...1)
            let low = min(open, close) - Double.random(in: 0...1)
            
            return CandlestickData(
                id: UUID(),
                timestamp: Date().addingTimeInterval(-Double(index) * 300),
                open: open,
                high: high,
                low: low,
                close: close,
                volume: Double.random(in: 1000...5000)
            )
        }
        
        visibleCandleData = Array(candleData.prefix(50))
        
        // Generate live orders
        liveOrders = [
            LiveTradingOrder(
                symbol: "XAUUSD",
                type: .buy,
                size: 0.01,
                entryPrice: 2373.25,
                currentPL: 47.50
            ),
            LiveTradingOrder(
                symbol: "XAUUSD", 
                type: .sell,
                size: 0.02,
                entryPrice: 2375.80,
                currentPL: -23.20
            )
        ]
        
        generateBotData()
    }
    
    private func generateBotData() {
        activeBots = [
            ActiveBot(name: "Gold Scalper Pro", isPerformingWell: true),
            ActiveBot(name: "Trend Master", isPerformingWell: true),
            ActiveBot(name: "Risk Guardian", isPerformingWell: false)
        ]
        
        botSignals = [
            BotSignal(
                botId: "bot1",
                signal: "Strong Buy Signal",
                confidence: 0.89,
                direction: .buy
            )
        ]
        
        isAutoTradingActive = true
    }
    
    private func startRealTimeUpdates() {
        Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
            Task { @MainActor in
                self.updatePrices()
            }
        }
    }
    
    private func updatePrices() {
        currentPrice = 2374.50 + Double.random(in: -3...3)
        bid = currentPrice - 0.25
        ask = currentPrice + 0.25
        spread = ask - bid
        lastUpdateTime = Date()
    }
}

struct CandlestickData: Identifiable {
    let id: UUID
    let timestamp: Date
    let open: Double
    let high: Double
    let low: Double
    let close: Double
    let volume: Double
    
    var isBullish: Bool { close > open }
    var bodyHeight: Double { abs(close - open) }
    var upperWickHeight: Double { high - max(open, close) }
    var lowerWickHeight: Double { min(open, close) - low }
}

#Preview {
    Text("Chart Data Service ✅")
        .font(.title.bold())
        .foregroundColor(.green)
}