//
//  ChartDataService.swift
//  Planet ProTrader
//
//  Created by AI Assistant
//

import SwiftUI
import Combine
import Foundation

@MainActor
class ChartDataService: ObservableObject {
    static let shared = ChartDataService()
    
    // MARK: - Published Properties
    @Published var candleData: [CandlestickData] = []
    @Published var currentInstrument: TradingInstrument = .xauusd
    @Published var currentTimeframe: ChartTimeframe = .m15
    @Published var connectionStatus: ConnectionStatus = .connected
    @Published var isLoadingData = false
    @Published var isChartFullyLoaded = false
    
    // MARK: - Price Data
    @Published var currentPrice: Double = 2675.50
    @Published var bid: Double = 2675.45
    @Published var ask: Double = 2675.55
    @Published var lastUpdateTime = Date()
    
    // MARK: - Auto Trading
    @Published var isAutoTradingActive = true
    @Published var liveOrders: [LiveTradingOrder] = []
    @Published var botSignals: [BotSignal] = []
    @Published var activeBots: [TradingBot] = []
    @Published var botTrades: [PlaybookTrade] = []
    
    // MARK: - Performance Optimization
    @Published var visibleCandleData: [CandlestickData] = []
    @Published var reducedAnimationMode = false
    var cachedPriceRange: Double = 0
    
    // MARK: - Computed Properties
    var spread: Double {
        ask - bid
    }
    
    var totalBotPL: Double {
        liveOrders.filter { $0.isFromBot }.reduce(0) { $0 + $1.profitLoss }
    }
    
    var botWinRate: Double {
        let completedTrades = botTrades.filter { $0.result != .running }
        guard !completedTrades.isEmpty else { return 0.0 }
        let wins = completedTrades.filter { $0.result == .win }.count
        return Double(wins) / Double(completedTrades.count)
    }
    
    var activeBotTrades: Int {
        liveOrders.filter { $0.isFromBot }.count
    }
    
    // MARK: - Initialization
    
    private init() {
        setupRealtimeData()
        generateSampleData()
        startPriceUpdates()
    }
    
    // MARK: - Data Generation
    
    private func setupRealtimeData() {
        activeBots = TradingBot.sampleBots()
        botSignals = BotSignal.sample()
        generateSampleOrders()
    }
    
    private func generateSampleData() {
        isLoadingData = true
        
        var data: [CandlestickData] = []
        var currentPrice = 2670.0
        
        // Generate 100 sample candles
        for i in 0..<100 {
            let timestamp = Date().addingTimeInterval(-Double(100 - i) * 900) // 15 min intervals
            
            let open = currentPrice
            let volatility = Double.random(in: 0.5...3.0)
            let direction = Bool.random()
            
            let high = open + Double.random(in: 0.5...volatility)
            let low = open - Double.random(in: 0.5...volatility)
            let close = direction ? 
                Double.random(in: open...(high - 0.1)) : 
                Double.random(in: (low + 0.1)...open)
            
            let volume = Double.random(in: 100...1000)
            
            let candle = CandlestickData(
                timestamp: timestamp,
                open: open,
                high: high,
                low: low,
                close: close,
                volume: volume
            )
            
            data.append(candle)
            currentPrice = close
        }
        
        candleData = data
        updateVisibleData()
        
        // Simulate loading delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.isLoadingData = false
            self.isChartFullyLoaded = true
        }
    }
    
    private func generateSampleOrders() {
        liveOrders = [
            LiveTradingOrder(
                direction: .buy,
                volume: 0.1,
                openPrice: 2674.20,
                currentPrice: currentPrice,
                stopLoss: 2670.00,
                takeProfit: 2680.00,
                timestamp: Date().addingTimeInterval(-3600),
                botName: "Quantum AI Pro"
            ),
            LiveTradingOrder(
                direction: .sell,
                volume: 0.05,
                openPrice: 2676.80,
                currentPrice: currentPrice,
                stopLoss: 2680.00,
                takeProfit: 2670.00,
                timestamp: Date().addingTimeInterval(-1800),
                botName: "Neural Scalper"
            ),
            LiveTradingOrder(
                direction: .buy,
                volume: 0.2,
                openPrice: 2673.50,
                currentPrice: currentPrice,
                stopLoss: nil,
                takeProfit: 2678.00,
                timestamp: Date().addingTimeInterval(-900),
                botName: nil // Manual trade
            )
        ]
    }
    
    // MARK: - Real-time Updates
    
    private func startPriceUpdates() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            Task { @MainActor in
                self.updatePrices()
            }
        }
    }
    
    private func updatePrices() {
        // Simulate price movement
        let change = Double.random(in: -0.1...0.1)
        currentPrice += change
        bid = currentPrice - Double.random(in: 0.02...0.08)
        ask = currentPrice + Double.random(in: 0.02...0.08)
        
        // Update live orders with new prices
        for i in 0..<liveOrders.count {
            liveOrders[i] = LiveTradingOrder(
                direction: liveOrders[i].direction,
                volume: liveOrders[i].volume,
                openPrice: liveOrders[i].openPrice,
                currentPrice: currentPrice,
                stopLoss: liveOrders[i].stopLoss,
                takeProfit: liveOrders[i].takeProfit,
                timestamp: liveOrders[i].timestamp,
                botName: liveOrders[i].botName
            )
        }
        
        lastUpdateTime = Date()
    }
    
    // MARK: - Chart Operations
    
    func changeTimeframe(_ timeframe: ChartTimeframe) {
        currentTimeframe = timeframe
        // In real app, would fetch data for new timeframe
        generateSampleData()
    }
    
    func changeInstrument(_ instrument: TradingInstrument) {
        currentInstrument = instrument
        // In real app, would fetch data for new instrument
        generateSampleData()
    }
    
    private func updateVisibleData() {
        // Optimize by showing only visible candles
        let maxVisible = 100
        if candleData.count > maxVisible {
            visibleCandleData = Array(candleData.suffix(maxVisible))
        } else {
            visibleCandleData = candleData
        }
    }
    
    // MARK: - Utility Methods
    
    func getNextCandleCountdown() -> String {
        let interval: TimeInterval = {
            switch currentTimeframe {
            case .m1: return 60
            case .m5: return 300
            case .m15: return 900
            case .m30: return 1800
            case .h1: return 3600
            case .h4: return 14400
            case .d1: return 86400
            case .w1: return 604800
            case .mn1: return 2629746
            }
        }()
        
        let now = Date()
        let nextCandle = Date(timeIntervalSinceReferenceDate: 
            ceil(now.timeIntervalSinceReferenceDate / interval) * interval)
        let remaining = Int(nextCandle.timeIntervalSince(now))
        
        if remaining < 60 {
            return "\(remaining)s"
        } else if remaining < 3600 {
            return "\(remaining / 60)m \(remaining % 60)s"
        } else {
            return "\(remaining / 3600)h \(remaining % 3600 / 60)m"
        }
    }
    
    // MARK: - Async Data Generation (Performance Optimized)
    
    func generateSampleBotDataAsync() async {
        await Task.sleep(nanoseconds: 100_000_000) // 0.1 second delay
        
        // Generate additional bot signals
        let additionalSignals = [
            BotSignal(
                id: UUID(),
                timestamp: Date().addingTimeInterval(-600),
                direction: .buy,
                price: 2672.30,
                confidence: 0.78,
                botName: "Trend Master",
                candleIndex: 25,
                isActive: true
            )
        ]
        
        await MainActor.run {
            self.botSignals.append(contentsOf: additionalSignals)
        }
    }
}