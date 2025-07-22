//
//  TradingModels.swift
//  Planet ProTrader
//
//  ✅ FIXED: Complete TradingModels with CoreTypes integration
//  Created by Senior iOS Engineer on 1/25/25.
//

import SwiftUI
import Foundation

enum TradingModels {
    
    // MARK: - Gold Signal (Referenced by TradingViewModel)
    struct GoldSignal: Identifiable, Codable {
        let id: UUID
        let timestamp: Date
        let type: CoreTypes.TradeDirection  // ✅ FIXED: Use CoreTypes
        let entryPrice: Double
        let stopLoss: Double
        let takeProfit: Double
        let confidence: Double
        let reasoning: String
        let timeframe: String
        let status: SignalStatus
        var accuracy: Double?
        
        enum SignalStatus: String, Codable, CaseIterable {
            case pending = "Pending"
            case active = "Active" 
            case completed = "Completed"
            case cancelled = "Cancelled"
            
            var color: Color {
                switch self {
                case .pending: return .orange
                case .active: return .blue
                case .completed: return .green
                case .cancelled: return .red
                }
            }
        }
        
        init(
            timestamp: Date = Date(), 
            type: CoreTypes.TradeDirection, 
            entryPrice: Double, 
            stopLoss: Double, 
            takeProfit: Double, 
            confidence: Double, 
            reasoning: String, 
            timeframe: String, 
            status: SignalStatus = .pending, 
            accuracy: Double? = nil
        ) {
            self.id = UUID()
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
        
        // MARK: - Computed Properties
        var formattedEntryPrice: String {
            String(format: "$%.2f", entryPrice)
        }
        
        var formattedStopLoss: String {
            String(format: "$%.2f", stopLoss)
        }
        
        var formattedTakeProfit: String {
            String(format: "$%.2f", takeProfit)
        }
        
        var formattedConfidence: String {
            String(format: "%.1f%%", confidence * 100)
        }
        
        var riskRewardRatio: Double {
            let risk = abs(entryPrice - stopLoss)
            let reward = abs(takeProfit - entryPrice)
            guard risk > 0 else { return 0 }
            return reward / risk
        }
        
        var pipValue: Double {
            abs(takeProfit - entryPrice)
        }
        
        // MARK: - Sample Data
        static var sampleSignals: [GoldSignal] {
            [
                GoldSignal(
                    type: .buy,
                    entryPrice: 2374.50,
                    stopLoss: 2364.00,
                    takeProfit: 2395.00,
                    confidence: 0.87,
                    reasoning: "Strong bullish momentum with institutional volume confirmation. Golden ratio support holding.",
                    timeframe: "15M",
                    status: .active
                ),
                GoldSignal(
                    type: .sell,
                    entryPrice: 2380.00,
                    stopLoss: 2390.00,
                    takeProfit: 2360.00,
                    confidence: 0.92,
                    reasoning: "Key resistance level rejection with bearish divergence on multiple timeframes.",
                    timeframe: "1H",
                    status: .completed,
                    accuracy: 0.95
                )
            ]
        }
    }
    
    // MARK: - Market Data (Referenced by TradingViewModel)
    struct MarketData: Codable {
        let currentPrice: Double
        let change24h: Double
        let changePercentage: Double
        let high24h: Double
        let low24h: Double
        let volume: Double
        let lastUpdated: Date
        
        init(currentPrice: Double, change24h: Double, changePercentage: Double, high24h: Double, low24h: Double, volume: Double, lastUpdated: Date = Date()) {
            self.currentPrice = currentPrice
            self.change24h = change24h
            self.changePercentage = changePercentage
            self.high24h = high24h
            self.low24h = low24h
            self.volume = volume
            self.lastUpdated = lastUpdated
        }
        
        // MARK: - Computed Properties
        var formattedCurrentPrice: String {
            String(format: "$%.2f", currentPrice)
        }
        
        var formattedChange: String {
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
        
        var trend: TrendDirection {
            if changePercentage > 1.0 { return .bullish }
            if changePercentage < -1.0 { return .bearish }
            return .neutral
        }
        
        // MARK: - Sample Data
        static var sampleData: MarketData {
            MarketData(
                currentPrice: 2374.85,
                change24h: 12.75,
                changePercentage: 0.54,
                high24h: 2387.20,
                low24h: 2358.40,
                volume: 125000.0
            )
        }
    }
    
    // MARK: - Price Tick (For real-time updates)
    struct PriceTick: Identifiable, Codable {
        let id: UUID
        let symbol: String
        let price: Double
        let timestamp: Date
        let volume: Double
        
        init(symbol: String, price: Double, timestamp: Date = Date(), volume: Double = 0) {
            self.id = UUID()
            self.symbol = symbol
            self.price = price
            self.timestamp = timestamp
            self.volume = volume
        }
    }
    
    // MARK: - Trade Execution
    struct TradeExecution: Identifiable, Codable {
        let id: UUID
        let signal: GoldSignal
        let executionPrice: Double
        let executionTime: Date
        let slippage: Double
        let commission: Double
        let netProfit: Double
        let status: ExecutionStatus
        
        enum ExecutionStatus: String, Codable {
            case pending = "Pending"
            case executed = "Executed"
            case failed = "Failed"
            case cancelled = "Cancelled"
            
            var color: Color {
                switch self {
                case .pending: return .orange
                case .executed: return .green
                case .failed: return .red
                case .cancelled: return .gray
                }
            }
        }
        
        init(signal: GoldSignal, executionPrice: Double, executionTime: Date = Date(), slippage: Double = 0.0, commission: Double = 0.0, netProfit: Double = 0.0, status: ExecutionStatus = .pending) {
            self.id = UUID()
            self.signal = signal
            self.executionPrice = executionPrice
            self.executionTime = executionTime
            self.slippage = slippage
            self.commission = commission
            self.netProfit = netProfit
            self.status = status
        }
    }
    
    // MARK: - Trend Direction
    enum TrendDirection: String, Codable, CaseIterable {
        case bullish = "Bullish"
        case bearish = "Bearish"
        case neutral = "Neutral"
        
        var color: Color {
            switch self {
            case .bullish: return .green
            case .bearish: return .red
            case .neutral: return .gray
            }
        }
        
        var icon: String {
            switch self {
            case .bullish: return "arrow.up.circle.fill"
            case .bearish: return "arrow.down.circle.fill"
            case .neutral: return "minus.circle.fill"
            }
        }
    }
}

// MARK: - Type Aliases for Compatibility

// Create clean aliases to prevent conflicts
typealias TradingSignal = TradingModels.GoldSignal
typealias LiveMarketData = TradingModels.MarketData
typealias TradingExecution = TradingModels.TradeExecution

#Preview {
    VStack(spacing: 20) {
        Text("✅ Trading Models FIXED")
            .font(.title.bold())
            .foregroundColor(.green)
        
        Text("Fixed all type conflicts and integrated with CoreTypes")
            .font(.subheadline)
            .foregroundColor(.secondary)
        
        VStack(alignment: .leading, spacing: 8) {
            Text("✅ FIXED Issues:")
                .font(.headline)
            
            Group {
                Text("• CoreTypes.TradeDirection integration ✅")
                Text("• UUID Codable conformance ✅")
                Text("• Type conflict resolution ✅")
                Text("• Clean type aliases ✅")
                Text("• TrendDirection moved to local scope ✅")
                Text("• Proper formatting methods ✅")
            }
            .font(.caption)
            .foregroundColor(.green)
        }
    }
    .padding()
    .background(Color(.systemGroupedBackground))
    .cornerRadius(12)
}