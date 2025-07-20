//
//  AdvancedTradingLogic.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 7/13/25.
//

import Foundation
import SwiftUI

// MARK: - Advanced Trading Logic Components

// MARK: - Timeframe-Specific Analyzer

class TimeframeAnalyzer {
    let timeframe: Timeframe
    
    init(timeframe: Timeframe) {
        self.timeframe = timeframe
    }
    
    func analyzeTimeframe(data: [TradingModels.CandlestickData]) -> TimeframeAnalysis {
        let trend = determineTrend(data: data)
        let momentum = calculateMomentum(data: data)
        let structure = analyzeStructure(data: data)
        let keyLevels = identifyKeyLevels(data: data)
        
        return TimeframeAnalysis(
            timeframe: timeframe,
            trend: trend,
            momentum: momentum,
            structure: structure,
            keyLevels: keyLevels,
            confluence: calculateTimeframeConfluence(trend: trend, momentum: momentum, structure: structure)
        )
    }
    
    private func determineTrend(data: [TradingModels.CandlestickData]) -> SharedTypes.TrendDirection {
        guard data.count >= 20 else { return .neutral }
        
        let closes = data.map { $0.close }
        let sma20 = closes.suffix(20).reduce(0, +) / 20
        let sma50 = closes.count >= 50 ? closes.suffix(50).reduce(0, +) / 50 : sma20
        
        let currentPrice = closes.last ?? 0
        
        if currentPrice > sma20 && sma20 > sma50 {
            return .bullish
        } else if currentPrice < sma20 && sma20 < sma50 {
            return .bearish
        } else {
            return .neutral
        }
    }
    
    private func calculateMomentum(data: [TradingModels.CandlestickData]) -> MomentumData {
        let closes = data.map { $0.close }
        let rsi = calculateRSI(closes)
        let macd = calculateMACD(closes)
        
        return MomentumData(
            rsi: rsi,
            macd: macd,
            strength: abs(macd.macd - macd.signal),
            direction: macd.macd > macd.signal ? .bullish : .bearish
        )
    }
    
    private func analyzeStructure(data: [TradingModels.CandlestickData]) -> StructureData {
        let highs = data.map { $0.high }
        let lows = data.map { $0.low }
        
        let higherHighs = countHigherHighs(highs: highs)
        let higherLows = countHigherLows(lows: lows)
        let lowerHighs = countLowerHighs(highs: highs)
        let lowerLows = countLowerLows(lows: lows)
        
        let structureType: StructureType
        if higherHighs >= 2 && higherLows >= 2 {
            structureType = .uptrend
        } else if lowerHighs >= 2 && lowerLows >= 2 {
            structureType = .downtrend
        } else {
            structureType = .range
        }
        
        return StructureData(
            type: structureType,
            strength: calculateStructureStrength(hh: higherHighs, hl: higherLows, lh: lowerHighs, ll: lowerLows),
            keyLevels: identifyStructuralLevels(data: data)
        )
    }
    
    private func identifyKeyLevels(data: [TradingModels.CandlestickData]) -> [AdvancedKeyLevel] {
        var levels: [AdvancedKeyLevel] = []
        
        let highs = data.map { $0.high }
        let lows = data.map { $0.low }
        
        for i in 2..<(data.count - 2) {
            if highs[i] > highs[i-1] && highs[i] > highs[i+1] &&
               highs[i] > highs[i-2] && highs[i] > highs[i+2] {
                levels.append(AdvancedKeyLevel(
                    price: highs[i],
                    type: .resistance,
                    strength: calculateLevelStrength(data: data, price: highs[i]),
                    timeframe: timeframe
                ))
            }
        }
        
        for i in 2..<(data.count - 2) {
            if lows[i] < lows[i-1] && lows[i] < lows[i+1] &&
               lows[i] < lows[i-2] && lows[i] < lows[i+2] {
                levels.append(AdvancedKeyLevel(
                    price: lows[i],
                    type: .support,
                    strength: calculateLevelStrength(data: data, price: lows[i]),
                    timeframe: timeframe
                ))
            }
        }
        
        return levels.sorted { $0.strength > $1.strength }.prefix(5).map { $0 }
    }
    
    private func calculateTimeframeConfluence(trend: SharedTypes.TrendDirection, momentum: MomentumData, structure: StructureData) -> Double {
        var confluence = 0.0
        
        if (trend == .bullish && structure.type == .uptrend) ||
           (trend == .bearish && structure.type == .downtrend) {
            confluence += 0.4
        }
        
        if (trend == .bullish && momentum.direction == .bullish) ||
           (trend == .bearish && momentum.direction == .bearish) {
            confluence += 0.3
        }
        
        confluence += structure.strength * 0.3
        
        return min(1.0, confluence)
    }
    
    private func calculateRSI(_ prices: [Double]) -> Double {
        guard prices.count > 14 else { return 50 }
        
        var gains: [Double] = []
        var losses: [Double] = []
        
        for i in 1..<prices.count {
            let change = prices[i] - prices[i-1]
            gains.append(max(0, change))
            losses.append(max(0, -change))
        }
        
        let avgGain = gains.suffix(14).reduce(0, +) / 14
        let avgLoss = losses.suffix(14).reduce(0, +) / 14
        
        guard avgLoss != 0 else { return 100 }
        let rs = avgGain / avgLoss
        return 100 - (100 / (1 + rs))
    }
    
    private func calculateMACD(_ prices: [Double]) -> TradingModels.MACDData {
        let ema12 = calculateEMA(prices, period: 12)
        let ema26 = calculateEMA(prices, period: 26)
        let macdLine = ema12 - ema26
        let signalLine = calculateEMA([macdLine], period: 9)
        
        return TradingModels.MACDData(
            macd: macdLine,
            signal: signalLine,
            histogram: macdLine - signalLine
        )
    }
    
    private func calculateEMA(_ prices: [Double], period: Int) -> Double {
        guard !prices.isEmpty else { return 0 }
        let multiplier = 2.0 / (Double(period) + 1.0)
        var ema = prices[0]
        
        for price in prices.dropFirst() {
            ema = (price * multiplier) + (ema * (1 - multiplier))
        }
        
        return ema
    }
    
    private func countHigherHighs(highs: [Double]) -> Int {
        var count = 0
        for i in 1..<highs.count {
            if highs[i] > highs[i-1] { count += 1 }
        }
        return count
    }
    
    private func countHigherLows(lows: [Double]) -> Int {
        var count = 0
        for i in 1..<lows.count {
            if lows[i] > lows[i-1] { count += 1 }
        }
        return count
    }
    
    private func countLowerHighs(highs: [Double]) -> Int {
        var count = 0
        for i in 1..<highs.count {
            if highs[i] < highs[i-1] { count += 1 }
        }
        return count
    }
    
    private func countLowerLows(lows: [Double]) -> Int {
        var count = 0
        for i in 1..<lows.count {
            if lows[i] < lows[i-1] { count += 1 }
        }
        return count
    }
    
    private func calculateStructureStrength(hh: Int, hl: Int, lh: Int, ll: Int) -> Double {
        let totalPoints = hh + hl + lh + ll
        guard totalPoints > 0 else { return 0 }
        
        let trendStrength = max(hh + hl, lh + ll)
        return Double(trendStrength) / Double(totalPoints)
    }
    
    private func identifyStructuralLevels(data: [TradingModels.CandlestickData]) -> [StructuralLevel] {
        return [] // Placeholder implementation
    }
    
    private func calculateLevelStrength(data: [TradingModels.CandlestickData], price: Double) -> Double {
        let tolerance = price * 0.001 // 0.1% tolerance
        var touchCount = 0
        
        for candle in data {
            if abs(candle.high - price) <= tolerance || abs(candle.low - price) <= tolerance {
                touchCount += 1
            }
        }
        
        return min(1.0, Double(touchCount) / 5.0) // Normalize to 0-1 scale
    }
}

// MARK: - Market Structure Analyzer

class MarketStructureAnalyzer {
    func analyzeStructure(data: [TradingModels.CandlestickData]) async -> MarketStructureResult {
        let swingPoints = identifySwingPoints(data: data)
        let trendDirection = determineTrendDirection(swingPoints: swingPoints)
        let fibLevels = calculateFibonacciLevels(data: data)
        let keyLevels = identifyKeyLevels(data: data)
        
        return MarketStructureResult(
            bias: trendDirection,
            swingPoints: swingPoints,
            fibonacciLevels: fibLevels,
            keyLevels: keyLevels,
            structureStrength: calculateStructureStrength(swingPoints: swingPoints)
        )
    }
    
    private func identifySwingPoints(data: [TradingModels.CandlestickData]) -> [SwingPoint] {
        var swingPoints: [SwingPoint] = []
        let lookback = 5
        
        for i in lookback..<(data.count - lookback) {
            let current = data[i]
            
            var isSwingHigh = true
            for j in (i-lookback)...(i+lookback) {
                if j != i && data[j].high >= current.high {
                    isSwingHigh = false
                    break
                }
            }
            
            if isSwingHigh {
                swingPoints.append(SwingPoint(
                    price: current.high,
                    type: .high,
                    timestamp: current.timestamp,
                    strength: calculateSwingStrength(data: data, index: i, isHigh: true)
                ))
            }
            
            var isSwingLow = true
            for j in (i-lookback)...(i+lookback) {
                if j != i && data[j].low <= current.low {
                    isSwingLow = false
                    break
                }
            }
            
            if isSwingLow {
                swingPoints.append(SwingPoint(
                    price: current.low,
                    type: .low,
                    timestamp: current.timestamp,
                    strength: calculateSwingStrength(data: data, index: i, isHigh: false)
                ))
            }
        }
        
        return swingPoints.sorted { $0.timestamp < $1.timestamp }
    }
    
    private func determineTrendDirection(swingPoints: [SwingPoint]) -> SharedTypes.TrendDirection {
        guard swingPoints.count >= 4 else { return .neutral }
        
        let highs = swingPoints.filter { $0.type == .high }.suffix(3)
        let lows = swingPoints.filter { $0.type == .low }.suffix(3)
        
        if highs.count >= 2 && lows.count >= 2 {
            let higherHighs = highs.enumerated().dropFirst().allSatisfy { index, swing in
                swing.price > highs[index].price
            }
            let higherLows = lows.enumerated().dropFirst().allSatisfy { index, swing in
                swing.price > lows[index].price
            }
            
            if higherHighs && higherLows {
                return .bullish
            }
        }
        
        if highs.count >= 2 && lows.count >= 2 {
            let lowerHighs = highs.enumerated().dropFirst().allSatisfy { index, swing in
                swing.price < highs[index].price
            }
            let lowerLows = lows.enumerated().dropFirst().allSatisfy { index, swing in
                swing.price < lows[index].price
            }
            
            if lowerHighs && lowerLows {
                return .bearish
            }
        }
        
        return .neutral
    }
    
    private func calculateFibonacciLevels(data: [TradingModels.CandlestickData]) -> TradingModels.FibonacciLevels {
        guard data.count >= 2 else { 
            return TradingModels.FibonacciLevels(
                levels: [],
                swingHigh: 0,
                swingLow: 0,
                direction: .uptrend
            )
        }

        let highs = data.map { $0.high }
        let lows = data.map { $0.low }
        let high = highs.max() ?? 0
        let low = lows.min() ?? 0
        let diff = high - low
        
        let fib0 = TradingModels.FibonacciLevels.FibLevel(percentage: 0.0, price: high, label: "0%")
        let fib236 = TradingModels.FibonacciLevels.FibLevel(percentage: 23.6, price: high - (diff * 0.236), label: "23.6%")
        let fib382 = TradingModels.FibonacciLevels.FibLevel(percentage: 38.2, price: high - (diff * 0.382), label: "38.2%")
        let fib5 = TradingModels.FibonacciLevels.FibLevel(percentage: 50.0, price: high - (diff * 0.5), label: "50%")
        let fib618 = TradingModels.FibonacciLevels.FibLevel(percentage: 61.8, price: high - (diff * 0.618), label: "61.8%")
        let fib786 = TradingModels.FibonacciLevels.FibLevel(percentage: 78.6, price: high - (diff * 0.786), label: "78.6%")
        let fib1 = TradingModels.FibonacciLevels.FibLevel(percentage: 100.0, price: low, label: "100%")

        let fibLevels: [TradingModels.FibonacciLevels.FibLevel] = [fib0, fib236, fib382, fib5, fib618, fib786, fib1]

        return TradingModels.FibonacciLevels(
            levels: fibLevels,
            swingHigh: high,
            swingLow: low,
            direction: .uptrend
        )
    }
    
    private func identifyKeyLevels(data: [TradingModels.CandlestickData]) -> [AdvancedKeyLevel] {
        return [] // Placeholder implementation
    }
    
    private func calculateStructureStrength(swingPoints: [SwingPoint]) -> Double {
        guard swingPoints.count >= 4 else { return 0 }
        
        let averageStrength = swingPoints.map { $0.strength }.reduce(0, +) / Double(swingPoints.count)
        return averageStrength
    }
    
    private func calculateSwingStrength(data: [TradingModels.CandlestickData], index: Int, isHigh: Bool) -> Double {
        let volume = data[index].volume
        let avgVolume = data.map { $0.volume }.reduce(0, +) / Double(data.count)
        let volumeStrength = volume / avgVolume
        
        return min(1.0, volumeStrength * 0.6 + 0.4)
    }
}

// MARK: - Data Structures

enum Timeframe: String, CaseIterable {
    case oneMinute = "1M"
    case fiveMinutes = "5M"
    case fifteenMinutes = "15M"
    case thirtyMinutes = "30M"
    case oneHour = "1H"
    case fourHours = "4H"
    case daily = "1D"
}

enum StructureType: String, CaseIterable {
    case uptrend = "Uptrend"
    case downtrend = "Downtrend"
    case range = "Range"
}

enum SwingType: String, CaseIterable {
    case high = "High"
    case low = "Low"
}

enum KeyLevelType: String, CaseIterable {
    case support = "Support"
    case resistance = "Resistance"
    case pivot = "Pivot"
}

struct TimeframeAnalysis {
    let timeframe: Timeframe
    let trend: SharedTypes.TrendDirection
    let momentum: MomentumData
    let structure: StructureData
    let keyLevels: [AdvancedKeyLevel]
    let confluence: Double
}

struct MomentumData {
    let rsi: Double
    let macd: TradingModels.MACDData
    let strength: Double
    let direction: SharedTypes.TrendDirection
}

struct StructureData {
    let type: StructureType
    let strength: Double
    let keyLevels: [StructuralLevel]
}

struct StructuralLevel {
    let price: Double
    let type: String
    let strength: Double
}

struct MarketStructureResult {
    let bias: SharedTypes.TrendDirection
    let swingPoints: [SwingPoint]
    let fibonacciLevels: TradingModels.FibonacciLevels
    let keyLevels: [AdvancedKeyLevel]
    let structureStrength: Double
}

struct SwingPoint {
    let price: Double
    let type: SwingType
    let timestamp: Date
    let strength: Double
}

struct AdvancedKeyLevel {
    let price: Double
    let type: KeyLevelType
    let strength: Double
    let timeframe: Timeframe
}

struct TimeframeBias {
    let direction: SharedTypes.TrendDirection
    let strength: Double
    let validity: TimeInterval
}

struct AdvancedSignalData {
    let bias: SharedTypes.TrendDirection
    let confidence: Double
    let factors: [String]
    let timestamp: Date
}

#Preview {
    VStack(spacing: 20) {
        Image(systemName: "brain.head.profile")
            .font(.system(size: 50))
            .foregroundColor(.blue)
        
        VStack(spacing: 8) {
            Text("Advanced Trading Logic")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Multi-Timeframe Analysis")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text("Smart Money Concepts & Market Structure")
                .font(.caption)
                .foregroundColor(.gray)
        }
        
        HStack(spacing: 20) {
            VStack {
                Text("90%+")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
                Text("Target Accuracy")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            VStack {
                Text("5")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                Text("Timeframes")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            VStack {
                Text("85%+")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.orange)
                Text("Min Confluence")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
    .padding()
}