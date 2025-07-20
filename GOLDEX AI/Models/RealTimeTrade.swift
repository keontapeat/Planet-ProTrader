//
//  RealTimeTrade.swift
//  GOLDEX AI
//
//  Created by Keonta  on 7/17/25.
//

import Foundation
import SwiftUI

// MARK: - Real-Time Trade
struct RealTimeTrade: Identifiable, Codable {
    let id: UUID
    let ticket: String
    let symbol: String
    let direction: SharedTypes.TradeDirection
    let openPrice: Double
    let currentPrice: Double
    let lotSize: Double
    let floatingPnL: Double
    let openTime: Date
    
    init(ticket: String,
         symbol: String,
         direction: SharedTypes.TradeDirection,
         openPrice: Double,
         currentPrice: Double,
         lotSize: Double,
         floatingPnL: Double,
         openTime: Date) {
        self.id = UUID()
        self.ticket = ticket
        self.symbol = symbol
        self.direction = direction
        self.openPrice = openPrice
        self.currentPrice = currentPrice
        self.lotSize = lotSize
        self.floatingPnL = floatingPnL
        self.openTime = openTime
    }
    
    var pnlColor: Color {
        floatingPnL >= 0 ? .green : .red
    }
    
    var formattedPnL: String {
        return String(format: "%+.2f", floatingPnL)
    }
}

// MARK: - EA Signal
struct EASignal: Identifiable, Codable {
    let id: UUID
    let direction: SignalDirection
    let confidence: Double
    let reasoning: String
    let timestamp: Date
    
    enum SignalDirection: String, Codable, CaseIterable {
        case buy = "BUY"
        case sell = "SELL"
        case hold = "HOLD"
        
        var color: Color {
            switch self {
            case .buy: return .green
            case .sell: return .red
            case .hold: return .orange
            }
        }
        
        var icon: String {
            switch self {
            case .buy: return "arrow.up.circle.fill"
            case .sell: return "arrow.down.circle.fill"
            case .hold: return "pause.circle.fill"
            }
        }
    }
    
    init(direction: SignalDirection,
         confidence: Double,
         reasoning: String,
         timestamp: Date) {
        self.id = UUID()
        self.direction = direction
        self.confidence = confidence
        self.reasoning = reasoning
        self.timestamp = timestamp
    }
    
    var formattedConfidence: String {
        return String(format: "%.0f%%", confidence * 100)
    }
}

#Preview("Real-Time Trade & EA Signal") {
    VStack(spacing: 20) {
        Text("GOLDEX AI - Real-Time Data")
            .font(.title)
            .foregroundColor(DesignSystem.primaryGold)
        
        VStack(alignment: .leading, spacing: 8) {
            Text("Real-Time Trade Sample")
                .font(.headline)
            
            let sampleTrade = RealTimeTrade(
                ticket: "123456",
                symbol: "XAUUSD",
                direction: SharedTypes.TradeDirection.buy,
                openPrice: 2670.5,
                currentPrice: 2675.2,
                lotSize: 0.01,
                floatingPnL: 47.5,
                openTime: Date()
            )
            
            HStack {
                Image(systemName: sampleTrade.direction.icon)
                    .foregroundColor(sampleTrade.direction.color)
                VStack(alignment: .leading) {
                    Text("Ticket: \(sampleTrade.ticket)")
                    Text("Symbol: \(sampleTrade.symbol)")
                    Text("Direction: \(sampleTrade.direction.rawValue)")
                }
                Spacer()
                Text(sampleTrade.formattedPnL)
                    .foregroundColor(sampleTrade.pnlColor)
                    .font(.headline)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
        
        VStack(alignment: .leading, spacing: 8) {
            Text("EA Signal Sample")
                .font(.headline)
            
            let sampleSignal = EASignal(
                direction: .buy,
                confidence: 0.85,
                reasoning: "Strong bullish momentum detected",
                timestamp: Date()
            )
            
            HStack {
                Image(systemName: sampleSignal.direction.icon)
                    .foregroundColor(sampleSignal.direction.color)
                VStack(alignment: .leading) {
                    Text(sampleSignal.direction.rawValue)
                        .foregroundColor(sampleSignal.direction.color)
                        .font(.headline)
                    Text("Confidence: \(sampleSignal.formattedConfidence)")
                    Text("Reasoning: \(sampleSignal.reasoning)")
                        .font(.caption)
                }
                Spacer()
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
    .padding()
}