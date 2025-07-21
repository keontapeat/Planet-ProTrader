//
//  ChartModels.swift
//  Planet ProTrader
//
//  Created by AI Assistant
//

import SwiftUI
import Foundation

// MARK: - Chart Data Models

struct CandlestickData: Identifiable, Codable {
    let id = UUID()
    let timestamp: Date
    let open: Double
    let high: Double
    let low: Double
    let close: Double
    let volume: Double
    
    var isBullish: Bool {
        close > open
    }
    
    var bodyHeight: Double {
        abs(close - open)
    }
    
    var upperWickHeight: Double {
        high - max(open, close)
    }
    
    var lowerWickHeight: Double {
        min(open, close) - low
    }
}

enum ChartTimeframe: String, CaseIterable, Codable {
    case m1 = "1m"
    case m5 = "5m"
    case m15 = "15m"
    case m30 = "30m"
    case h1 = "1h"
    case h4 = "4h"
    case d1 = "1d"
    case w1 = "1w"
    case mn1 = "1M"
    
    var displayName: String {
        switch self {
        case .m1: return "1M"
        case .m5: return "5M"
        case .m15: return "15M"
        case .m30: return "30M"
        case .h1: return "1H"
        case .h4: return "4H"
        case .d1: return "1D"
        case .w1: return "1W"
        case .mn1: return "1MN"
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

struct TradingInstrument: Identifiable, Codable {
    let id = UUID()
    let symbol: String
    let displayName: String
    let pip: Double
    let digits: Int
    let minLot: Double
    let maxLot: Double
    let stepLot: Double
    
    static let xauusd = TradingInstrument(
        symbol: "XAUUSD",
        displayName: "Gold vs US Dollar",
        pip: 0.01,
        digits: 2,
        minLot: 0.01,
        maxLot: 100.0,
        stepLot: 0.01
    )
    
    static let eurusd = TradingInstrument(
        symbol: "EURUSD",
        displayName: "Euro vs US Dollar",
        pip: 0.0001,
        digits: 5,
        minLot: 0.01,
        maxLot: 100.0,
        stepLot: 0.01
    )
}

enum ConnectionStatus: String, CaseIterable {
    case connected = "Connected"
    case connecting = "Connecting"
    case disconnected = "Disconnected"
    case error = "Error"
    
    var color: Color {
        switch self {
        case .connected: return .green
        case .connecting: return .orange
        case .disconnected: return .red
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

// MARK: - Auto Trading Models

struct LiveTradingOrder: Identifiable, Codable {
    let id = UUID()
    let direction: TradeDirection
    let volume: Double
    let openPrice: Double
    let currentPrice: Double
    let stopLoss: Double?
    let takeProfit: Double?
    let timestamp: Date
    let botName: String?
    
    var profitLoss: Double {
        let pipDifference = direction == .buy ? 
            (currentPrice - openPrice) : 
            (openPrice - currentPrice)
        return pipDifference * volume * 100000 // Standard lot calculation
    }
    
    var isFromBot: Bool {
        botName != nil
    }
    
    var isProfit: Bool {
        profitLoss > 0
    }
    
    var profitColor: Color {
        profitLoss > 0 ? .green : profitLoss < 0 ? .red : .orange
    }
    
    var formattedPL: String {
        let sign = profitLoss >= 0 ? "+" : ""
        return "\(sign)$\(String(format: "%.2f", profitLoss))"
    }
}

struct BotSignal: Identifiable, Codable {
    let id = UUID()
    let timestamp: Date
    let direction: TradeDirection
    let price: Double
    let confidence: Double
    let botName: String
    let candleIndex: Int
    let isActive: Bool
    
    static func sample() -> [BotSignal] {
        return [
            BotSignal(
                id: UUID(),
                timestamp: Date(),
                direction: .buy,
                price: 2675.50,
                confidence: 0.85,
                botName: "Quantum AI",
                candleIndex: 45,
                isActive: true
            ),
            BotSignal(
                id: UUID(),
                timestamp: Date().addingTimeInterval(-300),
                direction: .sell,
                price: 2680.25,
                confidence: 0.92,
                botName: "Neural Pro",
                candleIndex: 30,
                isActive: false
            )
        ]
    }
}

struct TradingBot: Identifiable, Codable {
    let id = UUID()
    let name: String
    let isActive: Bool
    let profitLoss: Double
    let winRate: Double
    let tradesCount: Int
    
    var isPerformingWell: Bool {
        winRate > 0.6 && profitLoss > 0
    }
    
    static func sampleBots() -> [TradingBot] {
        return [
            TradingBot(
                id: UUID(),
                name: "Quantum AI Pro",
                isActive: true,
                profitLoss: 1250.75,
                winRate: 0.73,
                tradesCount: 45
            ),
            TradingBot(
                id: UUID(),
                name: "Neural Scalper",
                isActive: true,
                profitLoss: 890.50,
                winRate: 0.68,
                tradesCount: 32
            ),
            TradingBot(
                id: UUID(),
                name: "Trend Master",
                isActive: false,
                profitLoss: -125.25,
                winRate: 0.45,
                tradesCount: 18
            )
        ]
    }
}

// MARK: - Technical Indicators

enum TechnicalIndicator: String, CaseIterable, Identifiable {
    case sma = "SMA"
    case ema = "EMA"
    case rsi = "RSI"
    case macd = "MACD"
    case bollinger = "Bollinger Bands"
    case stochastic = "Stochastic"
    case atr = "ATR"
    case adx = "ADX"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .sma: return "Simple Moving Average"
        case .ema: return "Exponential Moving Average"
        case .rsi: return "Relative Strength Index"
        case .macd: return "MACD"
        case .bollinger: return "Bollinger Bands"
        case .stochastic: return "Stochastic Oscillator"
        case .atr: return "Average True Range"
        case .adx: return "Average Directional Index"
        }
    }
    
    var color: Color {
        switch self {
        case .sma: return .blue
        case .ema: return .orange
        case .rsi: return .purple
        case .macd: return .green
        case .bollinger: return .gray
        case .stochastic: return .red
        case .atr: return .brown
        case .adx: return .pink
        }
    }
}

// MARK: - Chart Settings

struct ChartColorScheme: Codable {
    let backgroundColor: Color
    let gridColor: Color
    let bullCandleColor: Color
    let bearCandleColor: Color
    let textColor: Color
    
    static let dark = ChartColorScheme(
        backgroundColor: Color.black,
        gridColor: Color.gray,
        bullCandleColor: Color.green,
        bearCandleColor: Color.red,
        textColor: Color.white
    )
    
    static let light = ChartColorScheme(
        backgroundColor: Color.white,
        gridColor: Color.gray,
        bullCandleColor: Color.green,
        bearCandleColor: Color.red,
        textColor: Color.black
    )
}

// Fix Color Codable conformance
extension Color: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let colorName = try container.decode(String.self)
        
        switch colorName {
        case "black": self = .black
        case "white": self = .white
        case "gray": self = .gray
        case "green": self = .green
        case "red": self = .red
        case "blue": self = .blue
        case "orange": self = .orange
        case "purple": self = .purple
        case "brown": self = .brown
        case "pink": self = .pink
        default: self = .primary
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        // Simplified encoding - in production you'd want more robust color encoding
        try container.encode("primary")
    }
}

class ChartSettings: ObservableObject, Codable {
    @Published var colorScheme: ChartColorScheme = .dark
    @Published var showGrid: Bool = true
    @Published var showVolume: Bool = true
    @Published var showOrderLines: Bool = true
    @Published var showBotSignals: Bool = true
    @Published var showCrosshair: Bool = true
    @Published var selectedIndicators: Set<TechnicalIndicator> = [.sma, .ema]
    @Published var candleWidth: CGFloat = 8.0
    @Published var maxVisibleCandles: Int = 100
    
    enum CodingKeys: CodingKey {
        case showGrid, showVolume, showOrderLines, showBotSignals, showCrosshair
        case candleWidth, maxVisibleCandles
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        showGrid = try container.decode(Bool.self, forKey: .showGrid)
        showVolume = try container.decode(Bool.self, forKey: .showVolume)
        showOrderLines = try container.decode(Bool.self, forKey: .showOrderLines)
        showBotSignals = try container.decode(Bool.self, forKey: .showBotSignals)
        showCrosshair = try container.decode(Bool.self, forKey: .showCrosshair)
        candleWidth = try container.decode(CGFloat.self, forKey: .candleWidth)
        maxVisibleCandles = try container.decode(Int.self, forKey: .maxVisibleCandles)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(showGrid, forKey: .showGrid)
        try container.encode(showVolume, forKey: .showVolume)
        try container.encode(showOrderLines, forKey: .showOrderLines)
        try container.encode(showBotSignals, forKey: .showBotSignals)
        try container.encode(showCrosshair, forKey: .showCrosshair)
        try container.encode(candleWidth, forKey: .candleWidth)
        try container.encode(maxVisibleCandles, forKey: .maxVisibleCandles)
    }
    
    init() {
        // Default initialization
    }
}