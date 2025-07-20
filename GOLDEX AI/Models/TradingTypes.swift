//
//  TradingTypes.swift
//  GOLDEX AI
//
//  Created by Goldex AI on 7/19/25.
//

import Foundation
import SwiftUI

// MARK: - Trading Types Namespace
enum TradingTypes {
    
    // MARK: - Market Data Types
    struct GoldMarketData {
        let trend: SharedTypes.TrendDirection
        let volume: Double
        let supportLevel: Double
        let resistanceLevel: Double
        let rsi: Double
        let macd: Double
    }

    // MARK: - Gold Signal Types
    struct GoldSignal {
        let id = UUID()
        let type: SignalType
        let entryPrice: Double
        let stopLoss: Double
        let takeProfit: Double
        let confidence: Double
        let timeframe: Timeframe
        
        var riskRewardRatio: Double {
            let risk = abs(entryPrice - stopLoss)
            let reward = abs(takeProfit - entryPrice)
            return risk > 0 ? reward / risk : 0
        }
        
        enum SignalType: String, CaseIterable {
            case buy = "Buy"
            case sell = "Sell"
            case scalp = "Scalp"
            case swing = "Swing"
            
            var icon: String {
                switch self {
                case .buy: return "arrow.up.circle.fill"
                case .sell: return "arrow.down.circle.fill"
                case .scalp: return "bolt.circle.fill"
                case .swing: return "arrow.up.and.down.circle.fill"
                }
            }
            
            var color: Color {
                switch self {
                case .buy: return .green
                case .sell: return .red
                case .scalp: return .orange
                case .swing: return .blue
                }
            }
        }
        
        enum Timeframe: String, CaseIterable {
            case m1 = "1M"
            case m5 = "5M"
            case m15 = "15M"
            case h1 = "1H"
            case h4 = "4H"
            case daily = "1D"
        }
    }

    // MARK: - Risk Level Enum
    enum RiskLevel: String, CaseIterable, Codable {
        case low = "Low"
        case medium = "Medium"
        case high = "High"
        case critical = "Critical"
        
        var color: Color {
            switch self {
            case .low: return .green
            case .medium: return .yellow
            case .high: return .orange
            case .critical: return .red
            }
        }
    }

    // MARK: - Claude AI Trade Log for Flip Mode
    struct ClaudeFlipTradeLog {
        let id: String
        let flipId: String
        let accountId: String
        let signal: SharedTypes.AutoTradingSignal
        let tradeResult: SharedTypes.SharedTradeResult
        let timestamp: Date
    }
}