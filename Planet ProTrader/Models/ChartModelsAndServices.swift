//
//  ChartModelsAndServices.swift
//  Planet ProTrader
//
//  Created by AI Assistant on 1/25/25.
//

import SwiftUI
import Foundation
import Combine

// MARK: - Chart Timeframe Enum

enum ChartTimeframe: String, CaseIterable, Codable {
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
        return rawValue
    }
    
    var color: Color {
        switch self {
        case .m1: return .red
        case .m5: return .orange
        case .m15: return .yellow
        case .m30: return .green
        case .h1: return .blue
        case .h4: return .purple
        case .d1: return .indigo
        case .w1: return .pink
        case .mn1: return .brown
        }
    }
}

// MARK: - Chart Settings

class ChartSettings: ObservableObject {
    @Published var showGrid = true
    @Published var showVolume = true
    @Published var showOrderLines = true
    @Published var showBotSignals = true
    @Published var showCrosshair = true
    @Published var showLastPrice = true
    @Published var showBidAsk = true
    @Published var showSpread = true
    @Published var autoScalePrice = true
    @Published var enableAlerts = true
    @Published var soundAlerts = true
    @Published var enableNews = true
    @Published var showEconomicCalendar = true
    @Published var colorScheme = ChartColorScheme.dark
    @Published var candleStyle = CandleStyle.candlestick
    @Published var selectedIndicators: Set<TechnicalIndicator> = []
    
    enum TechnicalIndicator: String, CaseIterable, Hashable {
        case sma = "SMA"
        case ema = "EMA"
        case rsi = "RSI"
        case macd = "MACD"
        case bollinger = "Bollinger Bands"
        case stochastic = "Stochastic"
        
        var displayName: String {
            return rawValue
        }
    }
    
    enum CandleStyle: String, CaseIterable, Codable {
        case candlestick = "Candlestick"
        case ohlcBar = "OHLC Bar"
        case line = "Line"
        case area = "Area"
        
        var displayName: String {
            return rawValue
        }
    }
    
    enum ChartColorScheme: String, CaseIterable, Codable {
        case dark = "Dark"
        case light = "Light"
        case auto = "Auto"
        
        var backgroundColor: Color {
            switch self {
            case .dark: return Color.black
            case .light: return Color.white
            case .auto: return Color(.systemBackground)
            }
        }
        
        var gridColor: Color {
            switch self {
            case .dark: return Color.gray
            case .light: return Color.gray.opacity(0.3)
            case .auto: return Color(.systemGray3)
            }
        }
        
        var bullCandleColor: Color {
            return Color.green
        }
        
        var bearCandleColor: Color {
            return Color.red
        }
        
        var textColor: Color {
            switch self {
            case .dark: return Color.white
            case .light: return Color.black
            case .auto: return Color(.label)
            }
        }
    }
    
    init() {
        // Default settings
    }
}

// MARK: - Live Trading Order

struct LiveTradingOrder: Identifiable, Codable {
    let id: UUID
    let botName: String?
    let direction: SharedTypes.TradeDirection
    let openPrice: Double
    let volume: Double
    let stopLoss: Double?
    let takeProfit: Double?
    let profitLoss: Double
    let isFromBot: Bool
    
    init(
        id: UUID = UUID(),
        botName: String? = nil,
        direction: SharedTypes.TradeDirection,
        openPrice: Double,
        volume: Double,
        stopLoss: Double? = nil,
        takeProfit: Double? = nil,
        profitLoss: Double = 0,
        isFromBot: Bool = false
    ) {
        self.id = id
        self.botName = botName
        self.direction = direction
        self.openPrice = openPrice
        self.volume = volume
        self.stopLoss = stopLoss
        self.takeProfit = takeProfit
        self.profitLoss = profitLoss
        self.isFromBot = isFromBot
    }
    
    var formattedPL: String {
        let sign = profitLoss >= 0 ? "+" : ""
        return "\(sign)$\(String(format: "%.2f", profitLoss))"
    }
    
    var profitColor: Color {
        return profitLoss >= 0 ? .green : .red
    }
    
    var isProfit: Bool {
        return profitLoss >= 0
    }
}

// MARK: - Bot Signal

struct BotSignal: Identifiable, Codable {
    let id: UUID
    let botName: String
    let direction: SharedTypes.TradeDirection
    let price: Double
    let confidence: Double
    let candleIndex: Int
    let isActive: Bool
    
    init(
        id: UUID = UUID(),
        botName: String,
        direction: SharedTypes.TradeDirection,
        price: Double,
        confidence: Double,
        candleIndex: Int,
        isActive: Bool = true
    ) {
        self.id = id
        self.botName = botName
        self.direction = direction
        self.price = price
        self.confidence = confidence
        self.candleIndex = candleIndex
        self.isActive = isActive
    }
}

// MARK: - Trading Instrument

struct TradingInstrument: Codable {
    let symbol: String
    let displayName: String
    let pip: Double
    let tickSize: Double
    let contractSize: Double
    
    init(symbol: String, displayName: String, pip: Double = 0.0001, tickSize: Double = 0.00001, contractSize: Double = 100000) {
        self.symbol = symbol
        self.displayName = displayName
        self.pip = pip
        self.tickSize = tickSize
        self.contractSize = contractSize
    }
    
    static let xauusd = TradingInstrument(
        symbol: "XAUUSD",
        displayName: "Gold vs US Dollar",
        pip: 0.01,
        tickSize: 0.01,
        contractSize: 100
    )
}

// MARK: - Connection Status

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
        case .connected: return "circle.fill"
        case .connecting: return "circle.dotted"
        case .disconnected: return "circle"
        case .error: return "exclamationmark.circle.fill"
        }
    }
}

// MARK: - Active Bot

struct ActiveBot: Identifiable {
    let id: UUID
    let name: String
    let isPerformingWell: Bool
    
    init(id: UUID = UUID(), name: String, isPerformingWell: Bool) {
        self.id = id
        self.name = name
        self.isPerformingWell = isPerformingWell
    }
}

// MARK: - Chart Data Service

@MainActor
class ChartDataService: ObservableObject {
    static let shared = ChartDataService()
    
    // Published properties
    @Published var candleData: [TradingModels.CandlestickData] = []
    @Published var visibleCandleData: [TradingModels.CandlestickData] = []
    @Published var currentInstrument = TradingInstrument.xauusd
    @Published var currentPrice: Double = 2374.85
    @Published var bid: Double = 2374.83
    @Published var ask: Double = 2374.87
    @Published var spread: Double = 0.04
    @Published var isLoadingData = false
    @Published var connectionStatus: ConnectionStatus = .connected
    @Published var lastUpdateTime = Date()
    @Published var liveOrders: [LiveTradingOrder] = []
    @Published var botSignals: [BotSignal] = []
    @Published var botTrades: [String] = []
    @Published var isAutoTradingActive = true
    @Published var activeBots: [ActiveBot] = []
    @Published var totalBotPL: Double = 247.85
    @Published var botWinRate: Double = 0.73
    @Published var activeBotTrades: Int = 5
    @Published var isChartFullyLoaded = true
    
    // Performance optimization properties
    var cachedPriceRange: Double?
    var reducedAnimationMode = false
    
    private init() {
        setupSampleData()
        startRealTimeUpdates()
    }
    
    private func setupSampleData() {
        candleData = TradingModels.CandlestickData.sampleData
        visibleCandleData = candleData
        
        liveOrders = [
            LiveTradingOrder(
                botName: "AI Scalper Pro",
                direction: .buy,
                openPrice: 2374.50,
                volume: 0.01,
                stopLoss: 2350.00,
                takeProfit: 2400.00,
                profitLoss: 24.50,
                isFromBot: true
            ),
            LiveTradingOrder(
                botName: "Trend Hunter",
                direction: .sell,
                openPrice: 2380.20,
                volume: 0.02,
                stopLoss: 2390.00,
                takeProfit: 2360.00,
                profitLoss: -15.30,
                isFromBot: true
            )
        ]
        
        botSignals = [
            BotSignal(
                botName: "Quantum AI",
                direction: .buy,
                price: 2375.00,
                confidence: 0.89,
                candleIndex: 10
            )
        ]
        
        activeBots = [
            ActiveBot(name: "AI Scalper Pro", isPerformingWell: true),
            ActiveBot(name: "Trend Hunter", isPerformingWell: false),
            ActiveBot(name: "Quantum AI", isPerformingWell: true)
        ]
    }
    
    private func startRealTimeUpdates() {
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
            Task { @MainActor in
                self.updatePrices()
            }
        }
    }
    
    private func updatePrices() {
        currentPrice += Double.random(in: -2...2)
        bid = currentPrice - spread / 2
        ask = currentPrice + spread / 2
        lastUpdateTime = Date()
    }
    
    func changeTimeframe(_ timeframe: ChartTimeframe) {
        // Simulate timeframe change
        isLoadingData = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isLoadingData = false
        }
    }
    
    func getNextCandleCountdown() -> String {
        return "2:45"
    }
    
    func generateSampleBotDataAsync() async {
        // Async data generation for performance
        await Task.sleep(1_000_000_000) // 1 second
        // Add more bot data if needed
    }
}

// MARK: - Toast Manager

@MainActor
class ToastManager: ObservableObject {
    static let shared = ToastManager()
    
    @Published var isShowing = false
    @Published var message = ""
    @Published var type: ToastType = .info
    @Published var duration: Double = 3.0
    
    enum ToastType {
        case success
        case error
        case warning
        case info
        case trading
        
        var color: Color {
            switch self {
            case .success: return .green
            case .error: return .red
            case .warning: return .orange
            case .info: return .blue
            case .trading: return DesignSystem.primaryGold
            }
        }
        
        var icon: String {
            switch self {
            case .success: return "checkmark.circle.fill"
            case .error: return "xmark.circle.fill"
            case .warning: return "exclamationmark.triangle.fill"
            case .info: return "info.circle.fill"
            case .trading: return "chart.line.uptrend.xyaxis"
            }
        }
    }
    
    private init() {}
    
    func show(_ message: String, type: ToastType = .info, duration: Double = 3.0) {
        self.message = message
        self.type = type
        self.duration = duration
        
        withAnimation(.spring()) {
            isShowing = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            withAnimation(.spring()) {
                self.isShowing = false
            }
        }
    }
    
    func showSuccess(_ message: String) {
        show(message, type: .success)
    }
    
    func showError(_ message: String) {
        show(message, type: .error)
    }
    
    func showWarning(_ message: String) {
        show(message, type: .warning)
    }
    
    func showTrading(_ message: String) {
        show(message, type: .trading)
    }
}

// MARK: - Extensions for TradeDirection

extension SharedTypes.TradeDirection {
    var arrow: String {
        switch self {
        case .buy: return "arrow.up.circle.fill"
        case .sell: return "arrow.down.circle.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .buy: return .green
        case .sell: return .red
        }
    }
}

// MARK: - Extensions for CandlestickData

extension TradingModels.CandlestickData {
    var bodyHeight: Double {
        return abs(close - open)
    }
    
    var upperWickHeight: Double {
        return high - max(open, close)
    }
    
    var lowerWickHeight: Double {
        return min(open, close) - low
    }
}

#Preview {
    VStack {
        Text("Chart Models and Services")
            .font(.title)
        
        Text("ChartDataService, ToastManager, and related models")
            .font(.caption)
    }
    .padding()
}