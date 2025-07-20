//
//  ChartModels.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 7/18/25.
//

import SwiftUI
import Foundation

// MARK: - Chart Data Models

struct CandlestickData: Identifiable, Codable {
    let id = UUID()
    let timestamp: Date
    var open: Double
    var high: Double
    var low: Double
    var close: Double
    var volume: Double
    var tickVolume: Int
    let spread: Double
    
    var isBullish: Bool {
        return close > open
    }
    
    var bodyHeight: Double {
        return abs(close - open)
    }
    
    var upperWickHeight: Double {
        return high - max(open, close)
    }
    
    var lowerWickHeight: Double {
        return min(open, close) - low
    }
    
    var bodyTop: Double {
        return max(open, close)
    }
    
    var bodyBottom: Double {
        return min(open, close)
    }
}

// MARK: - Timeframe Enum

enum ChartTimeframe: String, CaseIterable {
    case m1 = "1M"
    case m5 = "5M"
    case m15 = "15M"
    case m30 = "30M"
    case h1 = "1H"
    case h4 = "4H"
    case d1 = "1D"
    case w1 = "1W"
    case mn1 = "1MN"
    
    var displayName: String {
        return self.rawValue
    }
    
    var seconds: TimeInterval {
        switch self {
        case .m1: return 60
        case .m5: return 300
        case .m15: return 900
        case .m30: return 1800
        case .h1: return 3600
        case .h4: return 14400
        case .d1: return 86400
        case .w1: return 604800
        case .mn1: return 2592000
        }
    }
    
    var color: Color {
        switch self {
        case .m1, .m5: return .red
        case .m15, .m30: return .orange
        case .h1, .h4: return .blue
        case .d1, .w1: return .green
        case .mn1: return .purple
        }
    }
}

// MARK: - Trading Instrument

struct TradingInstrument: Identifiable, Codable {
    let id = UUID()
    let symbol: String
    let displayName: String
    let category: InstrumentCategory
    let pip: Double
    let minLot: Double
    let maxLot: Double
    let lotStep: Double
    let tickSize: Double
    let contractSize: Double
    let marginRequired: Double
    let swapLong: Double
    let swapShort: Double
    let spreadTypical: Double
    let tradingHours: String
    
    enum InstrumentCategory: String, CaseIterable, Codable {
        case forex = "Forex"
        case metals = "Metals"
        case indices = "Indices"
        case crypto = "Crypto"
        case commodities = "Commodities"
        case stocks = "Stocks"
        
        var color: Color {
            switch self {
            case .forex: return .blue
            case .metals: return .primaryGold
            case .indices: return .purple
            case .crypto: return .orange
            case .commodities: return .brown
            case .stocks: return .green
            }
        }
        
        var icon: String {
            switch self {
            case .forex: return "dollarsign.circle"
            case .metals: return "circle.fill"
            case .indices: return "chart.xyaxis.line"
            case .crypto: return "bitcoinsign.circle"
            case .commodities: return "leaf.fill"
            case .stocks: return "building.2"
            }
        }
    }
    
    static let sampleInstruments: [TradingInstrument] = [
        TradingInstrument(
            symbol: "EURUSD",
            displayName: "Euro vs US Dollar",
            category: .forex,
            pip: 0.0001,
            minLot: 0.01,
            maxLot: 100.0,
            lotStep: 0.01,
            tickSize: 0.00001,
            contractSize: 100000,
            marginRequired: 3.33,
            swapLong: -4.5,
            swapShort: 0.8,
            spreadTypical: 1.2,
            tradingHours: "24/5"
        ),
        TradingInstrument(
            symbol: "GBPUSD",
            displayName: "British Pound vs US Dollar",
            category: .forex,
            pip: 0.0001,
            minLot: 0.01,
            maxLot: 100.0,
            lotStep: 0.01,
            tickSize: 0.00001,
            contractSize: 100000,
            marginRequired: 3.33,
            swapLong: -3.8,
            swapShort: 0.5,
            spreadTypical: 1.5,
            tradingHours: "24/5"
        ),
        TradingInstrument(
            symbol: "XAUUSD",
            displayName: "Gold vs US Dollar",
            category: .metals,
            pip: 0.01,
            minLot: 0.01,
            maxLot: 100.0,
            lotStep: 0.01,
            tickSize: 0.01,
            contractSize: 100,
            marginRequired: 1.0,
            swapLong: -8.5,
            swapShort: 2.1,
            spreadTypical: 3.5,
            tradingHours: "24/5"
        )
    ]
}

// MARK: - Technical Indicators

enum TechnicalIndicator: String, CaseIterable, Codable {
    case sma = "SMA"
    case ema = "EMA"
    case rsi = "RSI"
    case macd = "MACD"
    case bollinger = "Bollinger Bands"
    case stochastic = "Stochastic"
    case williams = "Williams %R"
    case cci = "CCI"
    case atr = "ATR"
    case adx = "ADX"
    case fibonacci = "Fibonacci"
    case pivotPoints = "Pivot Points"
    
    var displayName: String {
        return self.rawValue
    }
    
    var defaultColor: Color {
        switch self {
        case .sma, .ema: return .blue
        case .rsi, .stochastic: return .purple
        case .macd: return .orange
        case .bollinger: return .gray
        case .williams, .cci: return .red
        case .atr, .adx: return .green
        case .fibonacci: return .primaryGold
        case .pivotPoints: return .brown
        }
    }
    
    var isOverlay: Bool {
        switch self {
        case .sma, .ema, .bollinger, .fibonacci, .pivotPoints:
            return true
        default:
            return false
        }
    }
}

// MARK: - Live Trading Order

struct LiveTradingOrder: Identifiable, Codable {
    let id = UUID()
    var botId: UUID?
    var botName: String?
    let symbol: String
    let orderType: OrderType
    let direction: TradeDirection
    let volume: Double
    let openPrice: Double
    let stopLoss: Double?
    let takeProfit: Double?
    let openTime: Date
    let currentPrice: Double
    let unrealizedPL: Double
    let status: OrderStatus
    let comment: String
    
    var isFromBot: Bool {
        return botName != nil && botName != "Manual"
    }
    
    var isProfit: Bool {
        return unrealizedPL > 0
    }
    
    enum OrderType: String, CaseIterable, Codable {
        case market = "Market"
        case pending = "Pending"
        case limit = "Limit"
        case stop = "Stop"
        
        var color: Color {
            switch self {
            case .market: return .blue
            case .pending: return .orange
            case .limit: return .green
            case .stop: return .red
            }
        }
    }
    
    enum TradeDirection: String, CaseIterable, Codable {
        case buy = "BUY"
        case sell = "SELL"
        
        var color: Color {
            switch self {
            case .buy: return .green
            case .sell: return .red
            }
        }
        
        var arrow: String {
            switch self {
            case .buy: return "arrow.up"
            case .sell: return "arrow.down"
            }
        }
    }
    
    enum OrderStatus: String, CaseIterable, Codable {
        case pending = "Pending"
        case open = "Open"
        case closed = "Closed"
        case cancelled = "Cancelled"
        
        var color: Color {
            switch self {
            case .pending: return .orange
            case .open: return .blue
            case .closed: return .green
            case .cancelled: return .red
            }
        }
    }

    var profitColor: Color {
        return unrealizedPL >= 0 ? .green : .red
    }
    
    var formattedPL: String {
        let sign = unrealizedPL >= 0 ? "+" : ""
        return "\(sign)$\(String(format: "%.2f", unrealizedPL))"
    }
    
    func updatePL(_ newPL: Double) -> LiveTradingOrder {
        return LiveTradingOrder(
            botId: botId,
            botName: botName,
            symbol: symbol,
            orderType: orderType,
            direction: direction,
            volume: volume,
            openPrice: openPrice,
            stopLoss: stopLoss,
            takeProfit: takeProfit,
            openTime: openTime,
            currentPrice: currentPrice,
            unrealizedPL: newPL,
            status: status,
            comment: comment
        )
    }
}

// MARK: - Chart Analysis Tools

enum ChartTool: String, CaseIterable {
    case trendLine = "Trend Line"
    case horizontalLine = "Horizontal Line"
    case verticalLine = "Vertical Line"
    case rectangle = "Rectangle"
    case fibonacci = "Fibonacci Retracement"
    case textNote = "Text Note"
    case arrow = "Arrow"
    case triangle = "Triangle"
    case ellipse = "Ellipse"
    case gannFan = "Gann Fan"
    case andrewsFork = "Andrews Pitchfork"
    
    var icon: String {
        switch self {
        case .trendLine: return "line.diagonal"
        case .horizontalLine: return "minus"
        case .verticalLine: return "line.vertical"
        case .rectangle: return "rectangle"
        case .fibonacci: return "function"
        case .textNote: return "text.cursor"
        case .arrow: return "arrow.up.right"
        case .triangle: return "triangle"
        case .ellipse: return "oval"
        case .gannFan: return "fan.oscillation"
        case .andrewsFork: return "tuningfork"
        }
    }
    
    var color: Color {
        switch self {
        case .trendLine: return .blue
        case .horizontalLine, .verticalLine: return .gray
        case .rectangle: return .purple
        case .fibonacci: return .primaryGold
        case .textNote: return .black
        case .arrow: return .red
        case .triangle: return .green
        case .ellipse: return .orange
        case .gannFan: return .pink
        case .andrewsFork: return .cyan
        }
    }
}

// MARK: - Market News & Events

struct MarketNews: Identifiable, Codable {
    let id = UUID()
    let title: String
    let description: String
    let impact: NewsImpact
    let currency: String
    let publishTime: Date
    let source: String
    let url: String?
    
    enum NewsImpact: String, CaseIterable, Codable {
        case low = "Low"
        case medium = "Medium"
        case high = "High"
        
        var color: Color {
            switch self {
            case .low: return .green
            case .medium: return .orange
            case .high: return .red
            }
        }
        
        var icon: String {
            switch self {
            case .low: return "circle.fill"
            case .medium: return "circle.lefthalf.filled"
            case .high: return "exclamationmark.circle.fill"
            }
        }
    }
}

struct EconomicEvent: Identifiable, Codable {
    let id = UUID()
    let name: String
    let currency: String
    let impact: MarketNews.NewsImpact
    let actualValue: String?
    let forecastValue: String?
    let previousValue: String?
    let eventTime: Date
    let description: String
    
    var isToday: Bool {
        Calendar.current.isDateInToday(eventTime)
    }
    
    var timeUntilEvent: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: Date(), to: eventTime) ?? "Now"
    }
}

// MARK: - Chart Settings & Preferences

struct ChartSettings: Codable {
    var candleStyle: CandleStyle = .classic
    var colorScheme: ChartColorScheme = .dark
    var showVolume: Bool = true
    var showGrid: Bool = true
    var showCrosshair: Bool = true
    var showOrderLines: Bool = true
    var showBotSignals: Bool = true
    var autoScalePrice: Bool = true
    var showLastPrice: Bool = true
    var showBidAsk: Bool = true
    var showSpread: Bool = true
    var enableAlerts: Bool = true
    var soundAlerts: Bool = false
    var enableNews: Bool = true
    var showEconomicCalendar: Bool = true
    var selectedIndicators: [TechnicalIndicator] = []
    
    enum CandleStyle: String, CaseIterable, Codable {
        case classic = "Classic Candles"
        case hollow = "Hollow Candles"
        case bars = "OHLC Bars"
        case line = "Line Chart"
        case area = "Area Chart"
        case heikinAshi = "Heikin Ashi"
        
        var displayName: String {
            return self.rawValue
        }
    }
    
    enum ChartColorScheme: String, CaseIterable, Codable {
        case dark = "Dark"
        case light = "Light"
        case classic = "Classic"
        case neon = "Neon"
        case professional = "Professional"
        
        var backgroundColor: Color {
            switch self {
            case .dark: return Color(.systemBackground)
            case .light: return .white
            case .classic: return Color(.systemGray6)
            case .neon: return .black
            case .professional: return Color(.systemGray6)
            }
        }
        
        var gridColor: Color {
            switch self {
            case .dark: return Color(.systemGray4)
            case .light: return Color(.systemGray3)
            case .classic: return Color(.systemGray3)
            case .neon: return Color(.systemGray2)
            case .professional: return Color(.systemGray3)
            }
        }
        
        var bullCandleColor: Color {
            switch self {
            case .neon: return .green
            default: return Color(.systemGreen)
            }
        }
        
        var bearCandleColor: Color {
            switch self {
            case .neon: return .red
            default: return Color(.systemRed)
            }
        }
    }
}

// MARK: - Chart Data Service

class ChartDataService: ObservableObject {
    @Published var candleData: [CandlestickData] = []
    @Published var currentInstrument: TradingInstrument = TradingInstrument.sampleInstruments[0]
    @Published var currentTimeframe: ChartTimeframe = .m15
    @Published var liveOrders: [LiveTradingOrder] = []
    @Published var marketNews: [MarketNews] = []
    @Published var economicEvents: [EconomicEvent] = []
    @Published var isLoadingData = false
    @Published var lastUpdateTime = Date()
    @Published var connectionStatus: ConnectionStatus = .connected
    @Published var currentPrice: Double = 0.0
    @Published var bid: Double = 0.0
    @Published var ask: Double = 0.0
    @Published var spread: Double = 0.0
    
    // Bot trading data
    @Published var botSignals: [BotSignal] = []
    @Published var botTrades: [BotTrade] = []
    @Published var activeBots: [TradingBot] = []
    @Published var isAutoTradingActive: Bool = true
    @Published var totalBotPL: Double = 2450.75
    @Published var botWinRate: Double = 0.73
    @Published var activeBotTrades: Int = 8
    
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
            case .disconnected: return "wifi.exclamationmark"
            case .error: return "exclamationmark.triangle"
            }
        }
    }
    
    static let shared = ChartDataService()
    
    private var updateTimer: Timer?
    private var priceUpdateTimer: Timer?
    
    init() {
        loadSampleData()
        generateSampleBotData()
        startRealTimeUpdates()
    }
    
    deinit {
        stopRealTimeUpdates()
    }
    
    // MARK: - Data Loading
    
    private func loadSampleData() {
        candleData = generateSampleCandleData()
        liveOrders = generateSampleLiveOrders()
        marketNews = generateSampleNews()
        economicEvents = generateSampleEconomicEvents()
        
        // Set current prices
        if let lastCandle = candleData.last {
            currentPrice = lastCandle.close
            bid = lastCandle.close - (currentInstrument.spreadTypical * currentInstrument.pip / 2)
            ask = lastCandle.close + (currentInstrument.spreadTypical * currentInstrument.pip / 2)
            spread = ask - bid
        }
    }
    
    private func generateSampleCandleData() -> [CandlestickData] {
        var candles: [CandlestickData] = []
        let startDate = Calendar.current.date(byAdding: .hour, value: -100, to: Date()) ?? Date()
        var price = 1.0850 // Starting EURUSD price
        
        for i in 0..<100 {
            let timestamp = Calendar.current.date(byAdding: .minute, value: Int(currentTimeframe.seconds / 60) * i, to: startDate) ?? Date()
            
            // Generate realistic price movement
            let volatility = Double.random(in: 0.0005...0.002)
            let direction = Double.random(in: -1...1)
            
            let open = price
            let priceChange = direction * volatility
            let close = open + priceChange
            
            // Generate high and low
            let extraVolatility = Double.random(in: 0.0001...0.0005)
            let high = max(open, close) + extraVolatility
            let low = min(open, close) - extraVolatility
            
            let volume = Double.random(in: 100...1000)
            let tickVolume = Int.random(in: 50...500)
            let spread = Double.random(in: 0.8...2.5) * currentInstrument.pip
            
            candles.append(CandlestickData(
                timestamp: timestamp,
                open: open,
                high: high,
                low: low,
                close: close,
                volume: volume,
                tickVolume: tickVolume,
                spread: spread
            ))
            
            price = close
        }
        
        return candles
    }
    
    private func generateSampleLiveOrders() -> [LiveTradingOrder] {
        return [
            LiveTradingOrder(
                botId: UUID(),
                botName: "Golden Scalper Pro",
                symbol: currentInstrument.symbol,
                orderType: .market,
                direction: .buy,
                volume: 0.1,
                openPrice: 1.0845,
                stopLoss: 1.0825,
                takeProfit: 1.0875,
                openTime: Date().addingTimeInterval(-300),
                currentPrice: currentPrice,
                unrealizedPL: 25.50,
                status: .open,
                comment: "Bot scalping entry"
            ),
            LiveTradingOrder(
                botId: UUID(),
                botName: "Risk Reaper X",
                symbol: currentInstrument.symbol,
                orderType: .market,
                direction: .sell,
                volume: 0.2,
                openPrice: 1.0860,
                stopLoss: 1.0880,
                takeProfit: 1.0830,
                openTime: Date().addingTimeInterval(-600),
                currentPrice: currentPrice,
                unrealizedPL: -15.80,
                status: .open,
                comment: "Trend reversal trade"
            )
        ]
    }
    
    private func generateSampleNews() -> [MarketNews] {
        return [
            MarketNews(
                title: "Fed Chair Powell Speaks on Interest Rates",
                description: "Federal Reserve Chairman Jerome Powell to address current monetary policy stance",
                impact: .high,
                currency: "USD",
                publishTime: Date().addingTimeInterval(-1800),
                source: "Reuters",
                url: nil
            ),
            MarketNews(
                title: "ECB Meeting Minutes Released",
                description: "European Central Bank releases minutes from last policy meeting",
                impact: .medium,
                currency: "EUR",
                publishTime: Date().addingTimeInterval(-3600),
                source: "Bloomberg",
                url: nil
            )
        ]
    }
    
    private func generateSampleEconomicEvents() -> [EconomicEvent] {
        return [
            EconomicEvent(
                name: "US Non-Farm Payrolls",
                currency: "USD",
                impact: .high,
                actualValue: nil,
                forecastValue: "180K",
                previousValue: "175K",
                eventTime: Date().addingTimeInterval(3600),
                description: "Monthly change in employment excluding farm workers"
            ),
            EconomicEvent(
                name: "EUR CPI Flash Estimate",
                currency: "EUR",
                impact: .high,
                actualValue: "2.1%",
                forecastValue: "2.0%",
                previousValue: "1.9%",
                eventTime: Date().addingTimeInterval(-1800),
                description: "Consumer Price Index inflation rate"
            )
        ]
    }
    
    private func generateSampleBotData() {
        // Sample bot signals
        botSignals = [
            BotSignal(
                botName: "Quantum AI Pro",
                direction: .buy,
                price: 1.0875,
                confidence: 0.92,
                candleIndex: 45,
                isActive: true
            ),
            BotSignal(
                botName: "Gold Scalper Elite",
                direction: .sell,
                price: 2051.30,
                confidence: 0.85,
                candleIndex: 38,
                isActive: false
            ),
            BotSignal(
                botName: "Trend Master 3000",
                direction: .buy,
                price: 1.0890,
                confidence: 0.78,
                candleIndex: 52,
                isActive: true
            )
        ]
        
        // Sample active bots
        activeBots = [
            TradingBot(name: "Quantum AI Pro", isPerformingWell: true, currentPL: 850.25),
            TradingBot(name: "Gold Scalper Elite", isPerformingWell: true, currentPL: 1200.50),
            TradingBot(name: "Trend Master 3000", isPerformingWell: false, currentPL: -150.75),
            TradingBot(name: "Scalping Beast", isPerformingWell: true, currentPL: 550.75)
        ]
    }
    
    // MARK: - Real-time Updates
    
    private func startRealTimeUpdates() {
        // Update candle data every 5 seconds for demo
        updateTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
            self.updateLatestCandle()
        }
        
        // Update prices more frequently
        priceUpdateTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.updateCurrentPrices()
        }
    }
    
    private func stopRealTimeUpdates() {
        updateTimer?.invalidate()
        priceUpdateTimer?.invalidate()
    }
    
    private func updateLatestCandle() {
        guard !candleData.isEmpty else { return }
        
        let lastIndex = candleData.count - 1
        var lastCandle = candleData[lastIndex]
        
        // Simulate price movement
        let volatility = Double.random(in: 0.0001...0.0005)
        let direction = Double.random(in: -1...1)
        let priceChange = direction * volatility
        
        lastCandle.close = lastCandle.close + priceChange
        lastCandle.high = max(lastCandle.high, lastCandle.close)
        lastCandle.low = min(lastCandle.low, lastCandle.close)
        lastCandle.volume += Double.random(in: 1...10)
        lastCandle.tickVolume += Int.random(in: 1...5)
        
        candleData[lastIndex] = lastCandle
        
        currentPrice = lastCandle.close
        lastUpdateTime = Date()
        
        // Update live orders P&L
        updateLiveOrdersPL()
    }
    
    private func updateCurrentPrices() {
        if let lastCandle = candleData.last {
            // Small price fluctuations between candle updates
            let tickChange = Double.random(in: -0.00005...0.00005)
            currentPrice = lastCandle.close + tickChange
            
            bid = currentPrice - (spread / 2)
            ask = currentPrice + (spread / 2)
        }
    }
    
    private func updateLiveOrdersPL() {
        for i in 0..<liveOrders.count {
            let order = liveOrders[i]
            let priceDiff = currentPrice - order.openPrice
            let pips = priceDiff / currentInstrument.pip
            let plPerPip = order.volume * currentInstrument.contractSize * currentInstrument.pip
            
            let unrealizedPL: Double
            if order.direction == .buy {
                unrealizedPL = pips * plPerPip
            } else {
                unrealizedPL = -pips * plPerPip
            }
            
            liveOrders[i] = order.updatePL(unrealizedPL)
        }
    }
    
    // MARK: - Public Methods
    
    func changeInstrument(_ instrument: TradingInstrument) {
        currentInstrument = instrument
        isLoadingData = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.loadSampleData()
            self.isLoadingData = false
        }
    }
    
    func changeTimeframe(_ timeframe: ChartTimeframe) {
        currentTimeframe = timeframe
        isLoadingData = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.candleData = self.generateSampleCandleData()
            self.isLoadingData = false
        }
    }
    
    func getNextCandleCountdown() -> String {
        let now = Date()
        let timeframeSeconds = currentTimeframe.seconds
        let currentCandleStart = Date(timeIntervalSince1970: floor(now.timeIntervalSince1970 / timeframeSeconds) * timeframeSeconds)
        let nextCandleStart = currentCandleStart.addingTimeInterval(timeframeSeconds)
        let remainingSeconds = Int(nextCandleStart.timeIntervalSince(now))
        
        let minutes = remainingSeconds / 60
        let seconds = remainingSeconds % 60
        
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

// MARK: - Bot Signal Model

struct BotSignal: Identifiable {
    let id = UUID()
    let botName: String
    let direction: SignalDirection
    let price: Double
    let confidence: Double
    let candleIndex: Int
    let timestamp: Date = Date()
    var isActive: Bool
    
    enum SignalDirection {
        case buy, sell
    }
}

// MARK: - Bot Trade Model

struct BotTrade: Identifiable {
    let id = UUID()
    let botName: String
    let pair: String
    let direction: TradeDirection
    let entryPrice: Double
    let exitPrice: Double?
    let volume: Double
    let profitLoss: Double
    let timestamp: Date
    let isOpen: Bool
    
    var isWinning: Bool {
        return profitLoss > 0
    }
}

// MARK: - Trading Bot Model

struct TradingBot: Identifiable {
    let id = UUID()
    let name: String
    let isPerformingWell: Bool
    let currentPL: Double
    
    var performanceColor: Color {
        return isPerformingWell ? .green : .red
    }
}