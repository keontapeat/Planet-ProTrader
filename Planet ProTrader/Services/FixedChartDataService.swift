//
//  FixedChartDataService.swift
//  Planet ProTrader
//
//  FIXED FOR BILLION DOLLAR EMPIRE
//

import Foundation
import SwiftUI

// MARK: - 🚀 FIXED CHART DATA SERVICE 🚀

class FixedChartDataService: ObservableObject {
    static let shared = FixedChartDataService()
    
    // MARK: - Published Properties
    @Published var candleData: [CandlestickData] = []
    @Published var visibleCandleData: [CandlestickData] = []
    @Published var currentInstrument = TradingInstrument.eurusd
    @Published var currentPrice: Double = 1.0875
    @Published var bid: Double = 1.0874
    @Published var ask: Double = 1.0876
    @Published var spread: Double = 0.0002
    @Published var isLoadingData = false
    @Published var isAutoTradingActive = true
    @Published var connectionStatus: ConnectionStatus = .connected
    @Published var lastUpdateTime = Date()
    @Published var liveOrders: [LiveTradingOrder] = []
    @Published var botSignals: [BotSignal] = []
    @Published var botTrades: [BotTrade] = []
    @Published var activeBots: [ActiveBot] = []
    @Published var totalBotPL: Double = 2847.50
    @Published var botWinRate: Double = 0.73
    @Published var activeBotTrades: Int = 12
    @Published var isChartFullyLoaded = true
    @Published var cachedPriceRange: Double = 0.0
    @Published var reducedAnimationMode = false
    
    private init() {
        setupInitialData()
    }
    
    private func setupInitialData() {
        // Generate sample candlestick data
        candleData = generateSampleCandleData()
        visibleCandleData = Array(candleData.suffix(100))
        
        // Generate sample live orders
        liveOrders = generateSampleLiveOrders()
        
        // Generate sample bot signals
        botSignals = generateSampleBotSignals()
        
        // Generate sample active bots
        activeBots = generateSampleActiveBots()
    }
    
    func changeTimeframe(_ timeframe: ChartTimeframe) {
        // Handle timeframe change
        isLoadingData = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.candleData = self.generateSampleCandleData()
            self.visibleCandleData = Array(self.candleData.suffix(100))
            self.isLoadingData = false
        }
    }
    
    func getNextCandleCountdown() -> String {
        let calendar = Calendar.current
        let now = Date()
        let nextMinute = calendar.dateInterval(of: .minute, for: now)?.end ?? now
        let timeInterval = nextMinute.timeIntervalSince(now)
        let seconds = Int(timeInterval)
        return "\(seconds)s"
    }
    
    func generateSampleBotDataAsync() async {
        // Generate sample bot data asynchronously
        await MainActor.run {
            self.botTrades = self.generateSampleBotTrades()
            self.activeBots = self.generateSampleActiveBots()
        }
    }
    
    // MARK: - Sample Data Generation
    
    private func generateSampleCandleData() -> [CandlestickData] {
        var data: [CandlestickData] = []
        var basePrice = 1.0875
        
        for i in 0..<200 {
            let open = basePrice
            let close = open + Double.random(in: -0.002...0.002)
            let high = max(open, close) + Double.random(in: 0...0.001)
            let low = min(open, close) - Double.random(in: 0...0.001)
            let volume = Double.random(in: 100...1000)
            
            let candle = CandlestickData(
                id: UUID(),
                timestamp: Date().addingTimeInterval(-Double(200-i) * 60),
                open: open,
                high: high,
                low: low,
                close: close,
                volume: volume
            )
            
            data.append(candle)
            basePrice = close
        }
        
        return data
    }
    
    private func generateSampleLiveOrders() -> [LiveTradingOrder] {
        return [
            LiveTradingOrder(
                id: UUID(),
                botName: "Quantum Scalper Pro",
                direction: .buy,
                openPrice: 1.0870,
                volume: 0.1,
                profitLoss: 47.50,
                isFromBot: true
            ),
            LiveTradingOrder(
                id: UUID(),
                botName: "Trend Hunter Elite",
                direction: .sell,
                openPrice: 1.0882,
                volume: 0.05,
                profitLoss: -12.30,
                isFromBot: true
            ),
            LiveTradingOrder(
                id: UUID(),
                botName: "Risk Guardian",
                direction: .buy,
                openPrice: 1.0865,
                volume: 0.02,
                profitLoss: 23.80,
                isFromBot: true
            )
        ]
    }
    
    private func generateSampleBotSignals() -> [BotSignal] {
        return [
            BotSignal(
                id: UUID(),
                botName: "Pattern Master",
                direction: .buy,
                price: 1.0875,
                confidence: 0.87,
                candleIndex: 150,
                isActive: true
            ),
            BotSignal(
                id: UUID(),
                botName: "News Hunter",
                direction: .sell,
                price: 1.0890,
                confidence: 0.92,
                candleIndex: 170,
                isActive: false
            )
        ]
    }
    
    private func generateSampleActiveBots() -> [ActiveBot] {
        return [
            ActiveBot(id: UUID(), name: "Quantum Pro", isPerformingWell: true),
            ActiveBot(id: UUID(), name: "Trend Elite", isPerformingWell: true),
            ActiveBot(id: UUID(), name: "Risk Guardian", isPerformingWell: false)
        ]
    }
    
    private func generateSampleBotTrades() -> [BotTrade] {
        return [
            BotTrade(id: UUID(), botName: "Quantum Pro", profit: 125.50),
            BotTrade(id: UUID(), botName: "Trend Elite", profit: 87.30),
            BotTrade(id: UUID(), botName: "Risk Guardian", profit: -45.20)
        ]
    }
}

// MARK: - Supporting Data Structures

struct CandlestickData: Identifiable, Codable {
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

struct LiveTradingOrder: Identifiable, Codable {
    let id: UUID
    let botName: String?
    let direction: TradeDirection
    let openPrice: Double
    let volume: Double
    let profitLoss: Double
    let isFromBot: Bool
    var stopLoss: Double? = nil
    var takeProfit: Double? = nil
    
    var isProfit: Bool { profitLoss > 0 }
    var profitColor: Color { profitLoss >= 0 ? .green : .red }
    var formattedPL: String { String(format: "%+.2f", profitLoss) }
}

struct BotSignal: Identifiable, Codable {
    let id: UUID
    let botName: String
    let direction: TradeDirection
    let price: Double
    let confidence: Double
    let candleIndex: Int
    let isActive: Bool
}

struct TradingInstrument: Codable {
    let symbol: String
    let displayName: String
    let pip: Double
    
    static let eurusd = TradingInstrument(symbol: "EURUSD", displayName: "Euro vs US Dollar", pip: 0.0001)
    static let gbpusd = TradingInstrument(symbol: "GBPUSD", displayName: "British Pound vs US Dollar", pip: 0.0001)
    static let xauusd = TradingInstrument(symbol: "XAUUSD", displayName: "Gold vs US Dollar", pip: 0.01)
}

struct ActiveBot: Identifiable, Codable {
    let id: UUID
    let name: String
    let isPerformingWell: Bool
}

struct BotTrade: Identifiable, Codable {
    let id: UUID
    let botName: String
    let profit: Double
}