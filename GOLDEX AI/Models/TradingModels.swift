//
//  TradingModels.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 7/13/25.
//

import Foundation
import SwiftUI

// MARK: - Type aliases for backwards compatibility
typealias GoldSignal = TradingModels.GoldSignal

// MARK: - TradingModels Namespace

enum TradingModels {
    
    // MARK: - Gold Signal Model
    
    struct GoldSignal: Identifiable, Codable {
        let id: UUID
        let timestamp: Date
        let type: SharedTypes.TradeDirection
        let entryPrice: Double
        let stopLoss: Double
        let takeProfit: Double
        let confidence: Double
        let reasoning: String
        let timeframe: String
        let status: SignalStatus
        let accuracy: Double?
        
        enum SignalStatus: String, Codable, CaseIterable {
            case pending = "Pending"
            case active = "Active"
            case completed = "Completed"
            case cancelled = "Cancelled"
        }
        
        init(
            id: UUID = UUID(),
            timestamp: Date = Date(),
            type: SharedTypes.TradeDirection,
            entryPrice: Double,
            stopLoss: Double,
            takeProfit: Double,
            confidence: Double,
            reasoning: String,
            timeframe: String,
            status: SignalStatus = .pending,
            accuracy: Double? = nil
        ) {
            self.id = id
            self.timestamp = timestamp
            self.type = type
            self.entryPrice = entryPrice
            self.stopLoss = stopLoss
            self.takeProfit = takeProfit
            self.confidence = confidence
            self.reasoning = reasoning
            self.timeframe = timeframe
            self.status = status
            self.accuracy = accuracy
        }
        
        var formattedEntryPrice: String {
            String(format: "%.2f", entryPrice)
        }
        
        var formattedStopLoss: String {
            String(format: "%.2f", stopLoss)
        }
        
        var formattedTakeProfit: String {
            String(format: "%.2f", takeProfit)
        }
        
        var formattedConfidence: String {
            String(format: "%.1f%%", confidence * 100)
        }
        
        var directionColor: Color {
            type == .buy ? .green : .red
        }
        
        var statusColor: Color {
            switch status {
            case .pending: return .orange
            case .active: return .blue
            case .completed: return .green
            case .cancelled: return .red
            }
        }
        
        var riskRewardRatio: Double {
            let risk = abs(entryPrice - stopLoss)
            let reward = abs(takeProfit - entryPrice)
            return risk > 0 ? reward / risk : 0
        }
        
        var formattedRiskReward: String {
            String(format: "1:%.1f", riskRewardRatio)
        }
    }
    
    // MARK: - Market Data Model
    
    struct MarketData: Codable {
        let currentPrice: Double
        let change24h: Double
        let changePercentage: Double
        let high24h: Double
        let low24h: Double
        let volume: Double
        let lastUpdated: Date
        
        var formattedCurrentPrice: String {
            String(format: "%.2f", currentPrice)
        }
        
        var formattedChange24h: String {
            let sign = change24h >= 0 ? "+" : ""
            return "\(sign)$\(String(format: "%.2f", change24h))"
        }
        
        var formattedChangePercentage: String {
            let sign = changePercentage >= 0 ? "+" : ""
            return "\(sign)\(String(format: "%.2f", changePercentage))%"
        }
        
        var changeColor: Color {
            change24h >= 0 ? .green : .red
        }
    }
    
    // MARK: - Candlestick Data Model
    
    struct CandlestickData: Identifiable, Codable {
        let id: UUID
        let timestamp: Date
        let open: Double
        let high: Double
        let low: Double
        let close: Double
        let volume: Double
        
        init(
            id: UUID = UUID(),
            timestamp: Date,
            open: Double,
            high: Double,
            low: Double,
            close: Double,
            volume: Double
        ) {
            self.id = id
            self.timestamp = timestamp
            self.open = open
            self.high = high
            self.low = low
            self.close = close
            self.volume = volume
        }
        
        var isBullish: Bool {
            close > open
        }
        
        var body: Double {
            abs(close - open)
        }
        
        var upperWick: Double {
            high - max(open, close)
        }
        
        var lowerWick: Double {
            min(open, close) - low
        }
        
        var range: Double {
            high - low
        }
        
        var candleColor: Color {
            isBullish ? .green : .red
        }
    }
    
    // MARK: - MACD Data Model
    
    struct MACDData: Codable {
        let macd: Double
        let signal: Double
        let histogram: Double
        
        var isBullish: Bool {
            macd > signal
        }
        
        var momentum: String {
            if histogram > 0 {
                return "Bullish"
            } else if histogram < 0 {
                return "Bearish"
            } else {
                return "Neutral"
            }
        }
        
        var momentumColor: Color {
            histogram > 0 ? .green : histogram < 0 ? .red : .gray
        }
    }
    
    // MARK: - Fibonacci Levels Model
    
    struct FibonacciLevels: Codable {
        let levels: [FibLevel]
        let swingHigh: Double
        let swingLow: Double
        let direction: FibDirection
        
        enum FibDirection: String, Codable {
            case uptrend = "Uptrend"
            case downtrend = "Downtrend"
        }
        
        struct FibLevel: Codable {
            let percentage: Double
            let price: Double
            let label: String
            
            var formattedPrice: String {
                String(format: "%.2f", price)
            }
            
            var formattedPercentage: String {
                String(format: "%.1f%%", percentage * 100)
            }
        }
    }
    
    // MARK: - Technical Indicators Model
    
    struct TechnicalIndicators: Codable {
        let rsi: Double
        let macd: MACDData
        let movingAverages: MovingAverages
        let bollinger: BollingerBands
        let stochastic: Stochastic
        
        struct MovingAverages: Codable {
            let sma20: Double
            let sma50: Double
            let sma200: Double
            let ema20: Double
            let ema50: Double
            
            var trend: String {
                if sma20 > sma50 && sma50 > sma200 {
                    return "Strong Bullish"
                } else if sma20 < sma50 && sma50 < sma200 {
                    return "Strong Bearish"
                } else if sma20 > sma50 {
                    return "Bullish"
                } else {
                    return "Bearish"
                }
            }
            
            var trendColor: Color {
                if trend.contains("Bullish") {
                    return .green
                } else if trend.contains("Bearish") {
                    return .red
                } else {
                    return .gray
                }
            }
        }
        
        struct BollingerBands: Codable {
            let upper: Double
            let middle: Double
            let lower: Double
            let bandwidth: Double
            
            var squeeze: Bool {
                bandwidth < 0.1
            }
            
            var position: String {
                if upper > middle && middle > lower {
                    return "Expanding"
                } else {
                    return "Contracting"
                }
            }
        }
        
        struct Stochastic: Codable {
            let k: Double
            let d: Double
            
            var signal: String {
                if k > 80 && d > 80 {
                    return "Overbought"
                } else if k < 20 && d < 20 {
                    return "Oversold"
                } else {
                    return "Neutral"
                }
            }
            
            var signalColor: Color {
                switch signal {
                case "Overbought": return .red
                case "Oversold": return .green
                default: return .gray
                }
            }
        }
        
        var rsiSignal: String {
            if rsi > 70 {
                return "Overbought"
            } else if rsi < 30 {
                return "Oversold"
            } else {
                return "Neutral"
            }
        }
        
        var rsiColor: Color {
            switch rsiSignal {
            case "Overbought": return .red
            case "Oversold": return .green
            default: return .gray
            }
        }
    }
    
    // MARK: - Trade Result Model
    
    struct TradeResult: Identifiable, Codable {
        let id: UUID
        let symbol: String
        let direction: SharedTypes.TradeDirection
        let entryPrice: Double
        let exitPrice: Double
        let lotSize: Double
        let profit: Double
        let success: Bool
        let timestamp: Date
        
        init(
            id: UUID = UUID(),
            symbol: String,
            direction: SharedTypes.TradeDirection,
            entryPrice: Double,
            exitPrice: Double,
            lotSize: Double,
            profit: Double,
            success: Bool,
            timestamp: Date = Date()
        ) {
            self.id = id
            self.symbol = symbol
            self.direction = direction
            self.entryPrice = entryPrice
            self.exitPrice = exitPrice
            self.lotSize = lotSize
            self.profit = profit
            self.success = success
            self.timestamp = timestamp
        }
    }
    
    // MARK: - Trading Session Model
    
    struct TradingSession: Codable {
        let name: String
        let startTime: Date
        let endTime: Date
        let isActive: Bool
        let volume: Double
        let volatility: Double
        
        var formattedVolume: String {
            if volume >= 1_000_000 {
                return String(format: "%.1fM", volume / 1_000_000)
            } else if volume >= 1_000 {
                return String(format: "%.1fK", volume / 1_000)
            } else {
                return String(format: "%.0f", volume)
            }
        }
        
        var sessionColor: Color {
            isActive ? .green : .gray
        }
        
        var volatilityLevel: String {
            if volatility > 0.8 {
                return "High"
            } else if volatility > 0.4 {
                return "Medium"
            } else {
                return "Low"
            }
        }
    }
}

// MARK: - Sample Data Extensions

extension TradingModels.GoldSignal {
    static let sampleSignals: [TradingModels.GoldSignal] = [
        TradingModels.GoldSignal(
            timestamp: Date(),
            type: .buy,
            entryPrice: 2374.50,
            stopLoss: 2350.00,
            takeProfit: 2400.00,
            confidence: 0.89,
            reasoning: "Strong bullish momentum with institutional buying pressure",
            timeframe: "15M",
            status: TradingModels.GoldSignal.SignalStatus.active,
            accuracy: 0.85
        ),
        TradingModels.GoldSignal(
            timestamp: Date().addingTimeInterval(-3600),
            type: .sell,
            entryPrice: 2380.20,
            stopLoss: 2395.00,
            takeProfit: 2360.00,
            confidence: 0.92,
            reasoning: "Bearish divergence at resistance with volume confirmation",
            timeframe: "1H",
            status: TradingModels.GoldSignal.SignalStatus.completed,
            accuracy: 0.91
        ),
        TradingModels.GoldSignal(
            timestamp: Date().addingTimeInterval(-7200),
            type: .buy,
            entryPrice: 2365.75,
            stopLoss: 2340.00,
            takeProfit: 2395.00,
            confidence: 0.87,
            reasoning: "London session breakout with smart money accumulation",
            timeframe: "5M",
            status: TradingModels.GoldSignal.SignalStatus.completed,
            accuracy: 0.94
        )
    ]
}

extension TradingModels.MarketData {
    static let sampleData = TradingModels.MarketData(
        currentPrice: 2374.85,
        change24h: 12.35,
        changePercentage: 0.52,
        high24h: 2385.20,
        low24h: 2358.90,
        volume: 125840.0,
        lastUpdated: Date()
    )
}

extension TradingModels.CandlestickData {
    static let sampleData: [TradingModels.CandlestickData] = [
        TradingModels.CandlestickData(
            timestamp: Date().addingTimeInterval(-3600),
            open: 2370.50,
            high: 2375.80,
            low: 2368.20,
            close: 2374.90,
            volume: 1250.0
        ),
        TradingModels.CandlestickData(
            timestamp: Date().addingTimeInterval(-1800),
            open: 2374.90,
            high: 2378.50,
            low: 2372.10,
            close: 2376.20,
            volume: 1890.0
        ),
        TradingModels.CandlestickData(
            timestamp: Date(),
            open: 2376.20,
            high: 2380.15,
            low: 2374.85,
            close: 2378.90,
            volume: 2150.0
        )
    ]
}

// MARK: - Preview Provider

struct TradingModelsPreview: View {
    let sampleSignal = TradingModels.GoldSignal.sampleSignals[0]
    let sampleMarketData = TradingModels.MarketData.sampleData
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Signal Preview
                VStack(alignment: .leading, spacing: 12) {
                    Text("Sample Gold Signal")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Direction:")
                                .fontWeight(.medium)
                            Spacer()
                            Text(sampleSignal.type.rawValue)
                                .foregroundColor(sampleSignal.directionColor)
                        }
                        
                        HStack {
                            Text("Entry Price:")
                                .fontWeight(.medium)
                            Spacer()
                            Text(sampleSignal.formattedEntryPrice)
                        }
                        
                        HStack {
                            Text("Confidence:")
                                .fontWeight(.medium)
                            Spacer()
                            Text(sampleSignal.formattedConfidence)
                        }
                        
                        HStack {
                            Text("Risk:Reward:")
                                .fontWeight(.medium)
                            Spacer()
                            Text(sampleSignal.formattedRiskReward)
                        }
                    }
                    
                    Text(sampleSignal.reasoning)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(12)
                
                // Market Data Preview
                VStack(alignment: .leading, spacing: 12) {
                    Text("Market Data")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Current Price:")
                                .fontWeight(.medium)
                            Spacer()
                            Text(sampleMarketData.formattedCurrentPrice)
                        }
                        
                        HStack {
                            Text("24h Change:")
                                .fontWeight(.medium)
                            Spacer()
                            Text(sampleMarketData.formattedChange24h)
                                .foregroundColor(sampleMarketData.changeColor)
                        }
                        
                        HStack {
                            Text("Change %:")
                                .fontWeight(.medium)
                            Spacer()
                            Text(sampleMarketData.formattedChangePercentage)
                                .foregroundColor(sampleMarketData.changeColor)
                        }
                    }
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(12)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Trading Models")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    #if DEBUG
    static var previews: some View {
        TradingModelsPreview()
    }
    #endif
}