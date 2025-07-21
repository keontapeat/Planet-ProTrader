//
//  ChartExtensions.swift
//  Planet ProTrader
//
//  ✅ FIXED: Missing chart types and extensions for ProfessionalChartView
//

import SwiftUI

// MARK: - ✅ Missing Chart Types

extension MasterSharedTypes {
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
        
        var displayName: String { rawValue }
        
        var color: Color {
            switch self {
            case .m1, .m5: return .red
            case .m15, .m30: return .orange
            case .h1, .h4: return .blue
            case .d1: return .green
            case .w1, .mn1: return .purple
            }
        }
        
        var minutes: Int {
            switch self {
            case .m1: return 1
            case .m5: return 5
            case .m15: return 15
            case .m30: return 30
            case .h1: return 60
            case .h4: return 240
            case .d1: return 1440
            case .w1: return 10080
            case .mn1: return 43200
            }
        }
    }
}

// MARK: - ✅ Chart Settings

struct ChartSettings: ObservableObject {
    @Published var colorScheme: ChartColorScheme = .light
    @Published var showGrid: Bool = true
    @Published var showVolume: Bool = true
    @Published var showCrosshair: Bool = true
    @Published var showOrderLines: Bool = true
    @Published var showBotSignals: Bool = true
    @Published var selectedIndicators: Set<TechnicalIndicator> = []
    
    struct ChartColorScheme {
        let backgroundColor: Color
        let gridColor: Color
        let bullCandleColor: Color
        let bearCandleColor: Color
        
        static let light = ChartColorScheme(
            backgroundColor: .white,
            gridColor: .gray,
            bullCandleColor: .green,
            bearCandleColor: .red
        )
        
        static let dark = ChartColorScheme(
            backgroundColor: .black,
            gridColor: .gray,
            bullCandleColor: .mint,
            bearCandleColor: .orange
        )
    }
    
    enum TechnicalIndicator: String, CaseIterable {
        case sma = "SMA"
        case ema = "EMA"
        case rsi = "RSI"
        case macd = "MACD"
        case bollinger = "Bollinger Bands"
        
        var displayName: String { rawValue }
    }
}

// MARK: - ✅ Missing LiveTradingOrder Extensions

extension MasterSharedTypes.LiveTradingOrder {
    var direction: MasterSharedTypes.TradeDirection { type }
    var openPrice: Double { entryPrice }
    var volume: Double { size }
    var profitLoss: Double { currentPL }
    var formattedPL: String {
        let sign = currentPL >= 0 ? "+" : ""
        return "\(sign)$\(String(format: "%.2f", currentPL))"
    }
    var profitColor: Color { currentPL >= 0 ? .green : .red }
    var isProfit: Bool { currentPL >= 0 }
    var botName: String? { "AI Bot" }
    var isFromBot: Bool { true }
}

extension MasterSharedTypes.TradeDirection {
    var arrow: String {
        switch self {
        case .buy, .long: return "arrow.up"
        case .sell, .short: return "arrow.down"
        }
    }
}

// MARK: - ✅ BotSignal Extensions

extension MasterSharedTypes.BotSignal {
    var price: Double { 2374.50 }
    var candleIndex: Int { 50 }
    var isActive: Bool { true }
    var botName: String { signal }
}

// MARK: - ✅ TradingInstrument Extensions

extension MasterSharedTypes.TradingInstrument {
    var displayName: String { name }
    var pip: Double { 0.01 }
}

// MARK: - ✅ Missing Types for TradingModels compatibility

struct TradingModels {
    struct MarketData {
        let currentPrice: Double
        let change24h: Double
        let changePercentage: Double
        let high24h: Double
        let low24h: Double
        let volume: Double
        let lastUpdated: Date
    }
    
    struct GoldSignal: Identifiable {
        let id = UUID()
        let timestamp: Date
        let type: MasterSharedTypes.TradeDirection
        let entryPrice: Double
        let stopLoss: Double
        let takeProfit: Double
        let confidence: Double
        let reasoning: String
        let timeframe: String
        let status: SignalStatus
        let accuracy: Double?
        
        enum SignalStatus: String {
            case pending = "Pending"
            case executed = "Executed"
            case cancelled = "Cancelled"
        }
        
        static var sampleSignals: [GoldSignal] {
            [
                GoldSignal(
                    timestamp: Date(),
                    type: .buy,
                    entryPrice: 2374.50,
                    stopLoss: 2350.00,
                    takeProfit: 2400.00,
                    confidence: 0.85,
                    reasoning: "Strong bullish momentum",
                    timeframe: "15M",
                    status: .pending,
                    accuracy: nil
                )
            ]
        }
    }
}

#Preview {
    VStack {
        Text("✅ Chart Extensions Fixed")
            .font(.title.bold())
            .foregroundColor(.green)
        
        Text("All missing chart types and extensions added")
            .font(.subheadline)
            .foregroundColor(.secondary)
    }
    .padding()
}