//
//  ChartDataService.swift
//  Planet ProTrader
//
//  ✅ FIXED: Complete chart data service with real-time updates
//  Created by AI Assistant on 1/25/25.
//

import SwiftUI
import Combine

@MainActor
class ChartDataService: ObservableObject {
    static let shared = ChartDataService()
    
    // MARK: - Published Properties
    @Published var candlestickData: [TradingModels.CandlestickData] = []
    @Published var technicalIndicators: TechnicalIndicators = TechnicalIndicators()
    @Published var currentTimeframe: ChartTimeframe = .m15
    @Published var isLoading = false
    @Published var lastUpdate = Date()
    @Published var connectionStatus: ConnectionStatus = .connected
    
    enum ConnectionStatus: String {
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
    }
    
    enum ChartTimeframe: String, CaseIterable {
        case m1 = "1M"
        case m5 = "5M"
        case m15 = "15M"
        case m30 = "30M"
        case h1 = "1H"
        case h4 = "4H"
        case d1 = "1D"
        
        var displayName: String { rawValue }
        
        var minutes: Int {
            switch self {
            case .m1: return 1
            case .m5: return 5
            case .m15: return 15
            case .m30: return 30
            case .h1: return 60
            case .h4: return 240
            case .d1: return 1440
            }
        }
    }
    
    struct TechnicalIndicators: Codable {
        var rsi: Double = 65.5
        var macd: MACDData = MACDData()
        var movingAverages: MovingAverages = MovingAverages()
        var bollinger: BollingerBands = BollingerBands()
        var stochastic: Stochastic = Stochastic()
        var volume: Double = 125840.0
        
        struct MACDData: Codable {
            let macd: Double
            let signal: Double
            let histogram: Double
            
            init(macd: Double = 12.8, signal: Double = 10.2, histogram: Double = 2.6) {
                self.macd = macd
                self.signal = signal
                self.histogram = histogram
            }
            
            var trend: String {
                histogram > 0 ? "Bullish" : histogram < 0 ? "Bearish" : "Neutral"
            }
            
            var color: Color {
                histogram > 0 ? .green : histogram < 0 ? .red : .gray
            }
        }
        
        struct MovingAverages: Codable {
            let sma20: Double
            let sma50: Double
            let sma200: Double
            let ema20: Double
            let ema50: Double
            
            init(sma20: Double = 2370.2, sma50: Double = 2365.8, sma200: Double = 2350.5, ema20: Double = 2372.1, ema50: Double = 2368.3) {
                self.sma20 = sma20
                self.sma50 = sma50
                self.sma200 = sma200
                self.ema20 = ema20
                self.ema50 = ema50
            }
            
            var trend: String {
                if sma20 > sma50 && sma50 > sma200 { return "Strong Bullish" }
                if sma20 < sma50 && sma50 < sma200 { return "Strong Bearish" }
                if sma20 > sma50 { return "Bullish" }
                return "Bearish"
            }
            
            var color: Color {
                trend.contains("Bullish") ? .green : trend.contains("Bearish") ? .red : .gray
            }
        }
        
        struct BollingerBands: Codable {
            let upper: Double
            let middle: Double
            let lower: Double
            let bandwidth: Double
            
            init(upper: Double = 2380.0, middle: Double = 2374.0, lower: Double = 2368.0, bandwidth: Double = 12.0) {
                self.upper = upper
                self.middle = middle
                self.lower = lower
                self.bandwidth = bandwidth
            }
            
            var squeeze: Bool { bandwidth < 10.0 }
            var position: String { squeeze ? "Squeeze" : "Expansion" }
        }
        
        struct Stochastic: Codable {
            let k: Double
            let d: Double
            
            init(k: Double = 75.5, d: Double = 72.8) {
                self.k = k
                self.d = d
            }
            
            var signal: String {
                if k > 80 && d > 80 { return "Overbought" }
                if k < 20 && d < 20 { return "Oversold" }
                return "Neutral"
            }
            
            var color: Color {
                switch signal {
                case "Overbought": return .red
                case "Oversold": return .green
                default: return .gray
                }
            }
        }
    }
    
    private var cancellables = Set<AnyCancellable>()
    private var updateTimer: Timer?
    
    private init() {
        setupInitialData()
        startRealTimeUpdates()
    }
    
    deinit {
        stopRealTimeUpdates()
    }
    
    // MARK: - Initial Setup
    private func setupInitialData() {
        // Generate initial candlestick data
        generateCandlestickData()
        updateTechnicalIndicators()
    }
    
    private func generateCandlestickData() {
        candlestickData.removeAll()
        
        let basePrice = 2374.0
        var currentPrice = basePrice
        
        // Generate 100 candlesticks
        for i in 0..<100 {
            let timestamp = Date().addingTimeInterval(-TimeInterval((99 - i) * currentTimeframe.minutes * 60))
            
            let open = currentPrice
            let priceMovement = Double.random(in: -10...15)
            let close = open + priceMovement
            
            let high = max(open, close) + Double.random(in: 0...8)
            let low = min(open, close) - Double.random(in: 0...8)
            
            let volume = Double.random(in: 500...2000)
            
            let candlestick = TradingModels.CandlestickData(
                timestamp: timestamp,
                open: open,
                high: high,
                low: low,
                close: close,
                volume: volume
            )
            
            candlestickData.append(candlestick)
            currentPrice = close
        }
    }
    
    private func updateTechnicalIndicators() {
        guard !candlestickData.isEmpty else { return }
        
        let closePrices = candlestickData.map { $0.close }
        
        // Calculate RSI
        let rsiValue = calculateRSI(prices: closePrices, period: 14)
        
        // Calculate Moving Averages
        let sma20 = calculateSMA(prices: closePrices, period: 20)
        let sma50 = calculateSMA(prices: closePrices, period: 50)
        let sma200 = calculateSMA(prices: closePrices, period: min(200, closePrices.count))
        let ema20 = calculateEMA(prices: closePrices, period: 20)
        let ema50 = calculateEMA(prices: closePrices, period: 50)
        
        // Calculate Bollinger Bands
        let bollinger = calculateBollingerBands(prices: closePrices, period: 20, multiplier: 2.0)
        
        // Calculate MACD
        let macd = calculateMACD(prices: closePrices)
        
        // Calculate Stochastic
        let stochastic = calculateStochastic()
        
        // Update indicators
        technicalIndicators = TechnicalIndicators(
            rsi: rsiValue,
            macd: TechnicalIndicators.MACDData(macd: macd.macd, signal: macd.signal, histogram: macd.histogram),
            movingAverages: TechnicalIndicators.MovingAverages(sma20: sma20, sma50: sma50, sma200: sma200, ema20: ema20, ema50: ema50),
            bollinger: TechnicalIndicators.BollingerBands(upper: bollinger.upper, middle: bollinger.middle, lower: bollinger.lower, bandwidth: bollinger.bandwidth),
            stochastic: stochastic,
            volume: candlestickData.suffix(20).map { $0.volume }.reduce(0, +)
        )
    }
    
    // MARK: - Real-Time Updates
    private func startRealTimeUpdates() {
        updateTimer = Timer.scheduledTimer(withTimeInterval: Double(currentTimeframe.minutes * 60), repeats: true) { _ in
            Task { @MainActor in
                self.updateLatestCandlestick()
            }
        }
    }
    
    private func stopRealTimeUpdates() {
        updateTimer?.invalidate()
        updateTimer = nil
    }
    
    private func updateLatestCandlestick() {
        guard let lastCandle = candlestickData.last else { return }
        
        // Update the current candlestick or create a new one
        let now = Date()
        let timeSinceLastCandle = now.timeIntervalSince(lastCandle.timestamp)
        
        if timeSinceLastCandle >= Double(currentTimeframe.minutes * 60) {
            // Create new candlestick
            addNewCandlestick()
        } else {
            // Update current candlestick
            updateCurrentCandlestick()
        }
        
        updateTechnicalIndicators()
        lastUpdate = Date()
    }
    
    private func addNewCandlestick() {
        guard let lastCandle = candlestickData.last else { return }
        
        let open = lastCandle.close
        let priceMovement = Double.random(in: -10...15)
        let close = open + priceMovement
        
        let high = max(open, close) + Double.random(in: 0...8)
        let low = min(open, close) - Double.random(in: 0...8)
        
        let newCandle = TradingModels.CandlestickData(
            timestamp: Date(),
            open: open,
            high: high,
            low: low,
            close: close,
            volume: Double.random(in: 500...2000)
        )
        
        candlestickData.append(newCandle)
        
        // Keep only last 100 candlesticks
        if candlestickData.count > 100 {
            candlestickData.removeFirst()
        }
    }
    
    private func updateCurrentCandlestick() {
        guard let lastIndex = candlestickData.indices.last else { return }
        
        let currentCandle = candlestickData[lastIndex]
        let priceChange = Double.random(in: -2...3)
        let newClose = currentCandle.close + priceChange
        
        let updatedCandle = TradingModels.CandlestickData(
            id: currentCandle.id,
            timestamp: currentCandle.timestamp,
            open: currentCandle.open,
            high: max(currentCandle.high, newClose),
            low: min(currentCandle.low, newClose),
            close: newClose,
            volume: currentCandle.volume + Double.random(in: 50...200)
        )
        
        candlestickData[lastIndex] = updatedCandle
    }
    
    // MARK: - Public Methods
    func changeTimeframe(_ timeframe: ChartTimeframe) {
        guard timeframe != currentTimeframe else { return }
        
        currentTimeframe = timeframe
        
        // Stop current updates
        stopRealTimeUpdates()
        
        // Regenerate data for new timeframe
        isLoading = true
        
        Task {
            // Simulate loading delay
            try? await Task.sleep(nanoseconds: 500_000_000)
            
            generateCandlestickData()
            updateTechnicalIndicators()
            
            isLoading = false
            
            // Restart updates with new timeframe
            startRealTimeUpdates()
        }
    }
    
    func refreshData() async {
        isLoading = true
        connectionStatus = .connecting
        
        // Simulate API delay
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        generateCandlestickData()
        updateTechnicalIndicators()
        
        connectionStatus = .connected
        isLoading = false
        lastUpdate = Date()
    }
    
    func getLatestPrice() -> Double {
        return candlestickData.last?.close ?? 2374.0
    }
    
    func getPriceChange() -> Double {
        guard candlestickData.count >= 2 else { return 0 }
        let current = candlestickData.last!.close
        let previous = candlestickData[candlestickData.count - 2].close
        return current - previous
    }
    
    func getPriceChangePercent() -> Double {
        guard candlestickData.count >= 2 else { return 0 }
        let current = candlestickData.last!.close
        let previous = candlestickData[candlestickData.count - 2].close
        return ((current - previous) / previous) * 100
    }
    
    // MARK: - Technical Analysis Calculations
    private func calculateRSI(prices: [Double], period: Int) -> Double {
        guard prices.count >= period else { return 50.0 }
        
        let recentPrices = Array(prices.suffix(period + 1))
        var gains: [Double] = []
        var losses: [Double] = []
        
        for i in 1..<recentPrices.count {
            let change = recentPrices[i] - recentPrices[i - 1]
            if change > 0 {
                gains.append(change)
                losses.append(0)
            } else {
                gains.append(0)
                losses.append(-change)
            }
        }
        
        let avgGain = gains.reduce(0, +) / Double(gains.count)
        let avgLoss = losses.reduce(0, +) / Double(losses.count)
        
        guard avgLoss != 0 else { return 100.0 }
        
        let rs = avgGain / avgLoss
        return 100 - (100 / (1 + rs))
    }
    
    private func calculateSMA(prices: [Double], period: Int) -> Double {
        guard prices.count >= period else { return prices.last ?? 0 }
        
        let recentPrices = Array(prices.suffix(period))
        return recentPrices.reduce(0, +) / Double(recentPrices.count)
    }
    
    private func calculateEMA(prices: [Double], period: Int) -> Double {
        guard prices.count >= period else { return prices.last ?? 0 }
        
        let multiplier = 2.0 / (Double(period) + 1.0)
        let recentPrices = Array(prices.suffix(period))
        
        var ema = recentPrices[0]
        for i in 1..<recentPrices.count {
            ema = (recentPrices[i] * multiplier) + (ema * (1 - multiplier))
        }
        
        return ema
    }
    
    private func calculateBollingerBands(prices: [Double], period: Int, multiplier: Double) -> TechnicalIndicators.BollingerBands {
        let sma = calculateSMA(prices: prices, period: period)
        
        guard prices.count >= period else {
            return TechnicalIndicators.BollingerBands(upper: sma + 10, middle: sma, lower: sma - 10, bandwidth: 20)
        }
        
        let recentPrices = Array(prices.suffix(period))
        let variance = recentPrices.map { pow($0 - sma, 2) }.reduce(0, +) / Double(recentPrices.count)
        let stdDev = sqrt(variance)
        
        let upper = sma + (multiplier * stdDev)
        let lower = sma - (multiplier * stdDev)
        let bandwidth = upper - lower
        
        return TechnicalIndicators.BollingerBands(upper: upper, middle: sma, lower: lower, bandwidth: bandwidth)
    }
    
    private func calculateMACD(prices: [Double]) -> TechnicalIndicators.MACDData {
        let ema12 = calculateEMA(prices: prices, period: 12)
        let ema26 = calculateEMA(prices: prices, period: 26)
        let macd = ema12 - ema26
        
        // Simplified signal line calculation
        let signal = macd * 0.8
        let histogram = macd - signal
        
        return TechnicalIndicators.MACDData(macd: macd, signal: signal, histogram: histogram)
    }
    
    private func calculateStochastic() -> TechnicalIndicators.Stochastic {
        guard candlestickData.count >= 14 else {
            return TechnicalIndicators.Stochastic(k: 50, d: 50)
        }
        
        let recent = Array(candlestickData.suffix(14))
        let currentClose = recent.last!.close
        let highestHigh = recent.map { $0.high }.max()!
        let lowestLow = recent.map { $0.low }.min()!
        
        let k = ((currentClose - lowestLow) / (highestHigh - lowestLow)) * 100
        let d = k * 0.9 // Simplified D line
        
        return TechnicalIndicators.Stochastic(k: k, d: d)
    }
    
    // MARK: - Formatted Properties
    var formattedLatestPrice: String {
        String(format: "%.2f", getLatestPrice())
    }
    
    var formattedPriceChange: String {
        let change = getPriceChange()
        let sign = change >= 0 ? "+" : ""
        return "\(sign)\(String(format: "%.2f", change))"
    }
    
    var formattedPriceChangePercent: String {
        let change = getPriceChangePercent()
        let sign = change >= 0 ? "+" : ""
        return "\(sign)\(String(format: "%.2f", change))%"
    }
}