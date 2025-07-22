//
//  SampleData.swift
//  Planet ProTrader
//
//  ✅ SAMPLE DATA UPDATED FOR CORETYPES COMPATIBILITY
//  Created by Senior iOS Engineer
//

import SwiftUI
import Foundation

struct SampleData {
    
    // MARK: - Trading Bot Sample Data
    static let sampleBots: [CoreTypes.TradingBot] = [
        CoreTypes.TradingBot(
            name: "Gold Hunter AI",
            strategy: .scalping,
            riskLevel: .medium,
            isActive: true,
            winRate: 0.895,
            totalTrades: 342,
            profitLoss: 15420.50,
            performance: 127.8,
            status: .trading,
            icon: "crown.fill",
            primaryColor: "#FFD700",
            secondaryColor: "#FFA500"
        ),
        CoreTypes.TradingBot(
            name: "Momentum Master",
            strategy: .swing,
            riskLevel: .low,
            isActive: false,
            winRate: 0.76,
            totalTrades: 156,
            profitLoss: 8750.25,
            performance: 98.5,
            status: .analyzing,
            icon: "bolt.fill",
            primaryColor: "#00CED1",
            secondaryColor: "#4682B4"
        ),
        CoreTypes.TradingBot(
            name: "Risk Sentinel",
            strategy: .dayTrading,
            riskLevel: .low,
            isActive: true,
            winRate: 0.82,
            totalTrades: 89,
            profitLoss: 3950.75,
            performance: 84.3,
            status: .active,
            icon: "shield.fill",
            primaryColor: "#32CD32",
            secondaryColor: "#228B22"
        ),
        CoreTypes.TradingBot(
            name: "News Reactor",
            strategy: .news,
            riskLevel: .high,
            isActive: true,
            winRate: 0.91,
            totalTrades: 203,
            profitLoss: 12340.88,
            performance: 156.7,
            status: .learning,
            icon: "newspaper.fill",
            primaryColor: "#FF6347",
            secondaryColor: "#DC143C"
        ),
        CoreTypes.TradingBot(
            name: "Pattern Prophet",
            strategy: .momentum,
            riskLevel: .medium,
            isActive: true,
            winRate: 0.85,
            totalTrades: 445,
            profitLoss: 18750.60,
            performance: 203.2,
            status: .trading,
            icon: "eye.fill",
            primaryColor: "#9370DB",
            secondaryColor: "#8A2BE2"
        )
    ]
    
    // MARK: - Gold Signal Sample Data
    static let sampleGoldSignals: [CoreTypes.GoldSignal] = [
        CoreTypes.GoldSignal(
            timestamp: Date(),
            type: .buy,
            entryPrice: 2374.50,
            stopLoss: 2360.00,
            takeProfit: 2395.00,
            confidence: 0.85,
            reasoning: "Strong bullish momentum with institutional support",
            timeframe: "15M",
            status: .pending,
            accuracy: nil
        ),
        CoreTypes.GoldSignal(
            timestamp: Date().addingTimeInterval(-3600),
            type: .sell,
            entryPrice: 2380.25,
            stopLoss: 2395.00,
            takeProfit: 2355.50,
            confidence: 0.78,
            reasoning: "Bearish divergence on multiple timeframes",
            timeframe: "1H",
            status: .filled,
            accuracy: 0.92
        ),
        CoreTypes.GoldSignal(
            timestamp: Date().addingTimeInterval(-7200),
            type: .buy,
            entryPrice: 2365.75,
            stopLoss: 2350.00,
            takeProfit: 2385.25,
            confidence: 0.91,
            reasoning: "Golden ratio support with smart money accumulation",
            timeframe: "4H",
            status: .filled,
            accuracy: 0.87
        )
    ]
    
    // MARK: - Market Data Sample
    static let sampleMarketData = CoreTypes.MarketData(
        currentPrice: 2374.50,
        change24h: 15.25,
        changePercentage: 0.65,
        high24h: 2385.75,
        low24h: 2355.20,
        volume: 125430.0,
        lastUpdated: Date()
    )
    
    // MARK: - Trading Account Sample Data
    static let sampleTradingAccounts: [CoreTypes.TradingAccountDetails] = [
        CoreTypes.TradingAccountDetails(
            accountNumber: "1234567",
            broker: .mt5,
            accountType: "Demo",
            balance: 10000.0,
            equity: 10125.75,
            freeMargin: 9500.0,
            leverage: 500,
            isActive: true
        ),
        CoreTypes.TradingAccountDetails(
            accountNumber: "7654321",
            broker: .coinexx,
            accountType: "Live",
            balance: 5000.0,
            equity: 5125.50,
            freeMargin: 4800.0,
            leverage: 100,
            isActive: false
        ),
        CoreTypes.TradingAccountDetails(
            accountNumber: "9876543",
            broker: .forex,
            accountType: "Demo",
            balance: 25000.0,
            equity: 25847.20,
            freeMargin: 24200.0,
            leverage: 200,
            isActive: false
        )
    ]
    
    // MARK: - Flip Goal Sample Data
    static let sampleFlipGoals: [CoreTypes.FlipGoal] = [
        CoreTypes.FlipGoal(
            startAmount: 100.0,
            targetAmount: 200.0,
            timeLimit: 86400, // 1 day
            currentAmount: 175.25,
            status: .active,
            symbol: "XAUUSD"
        ),
        CoreTypes.FlipGoal(
            startAmount: 500.0,
            targetAmount: 1000.0,
            timeLimit: 604800, // 1 week
            currentAmount: 1250.75,
            status: .completed,
            symbol: "EURUSD"
        ),
        CoreTypes.FlipGoal(
            startAmount: 250.0,
            targetAmount: 500.0,
            timeLimit: 259200, // 3 days
            currentAmount: 185.50,
            status: .failed,
            symbol: "GBPUSD"
        )
    ]
    
    // MARK: - Helper Methods for Views
    static func randomBot() -> CoreTypes.TradingBot {
        sampleBots.randomElement() ?? sampleBots[0]
    }
    
    static func randomSignal() -> CoreTypes.GoldSignal {
        sampleGoldSignals.randomElement() ?? sampleGoldSignals[0]
    }
    
    static func randomAccount() -> CoreTypes.TradingAccountDetails {
        sampleTradingAccounts.randomElement() ?? sampleTradingAccounts[0]
    }
}

// MARK: - Extension to CoreTypes.TradingBot for Sample Data
extension CoreTypes.TradingBot {
    static let sampleBots = SampleData.sampleBots
    static let empty: [CoreTypes.TradingBot] = []
}

// MARK: - Extension to CoreTypes.GoldSignal for Sample Data  
extension CoreTypes.GoldSignal {
    static let sampleSignals = SampleData.sampleGoldSignals
}

// MARK: - Extension to CoreTypes.TradingAccountDetails for Sample Data
extension CoreTypes.TradingAccountDetails {
    static let sampleAccounts = SampleData.sampleTradingAccounts
}

#Preview {
    ScrollView {
        VStack(alignment: .leading, spacing: 20) {
            Text("📊 Sample Data Resources")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("✅ Available Sample Data:")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Group {
                    Text("• Trading Bots: \(SampleData.sampleBots.count) items")
                    Text("• Gold Signals: \(SampleData.sampleGoldSignals.count) items")  
                    Text("• Market Data: Live simulation")
                    Text("• Trading Accounts: \(SampleData.sampleTradingAccounts.count) items")
                    Text("• Flip Goals: \(SampleData.sampleFlipGoals.count) items")
                }
                .font(.body)
                .foregroundColor(.secondary)
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 8) {
                Text("🎯 Sample Bot Performance:")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                ForEach(SampleData.sampleBots.prefix(3), id: \.id) { bot in
                    HStack {
                        Circle()
                            .fill(bot.status.color)
                            .frame(width: 8, height: 8)
                        
                        Text(bot.name)
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        Spacer()
                        
                        Text("+\(String(format: "%.1f", bot.performance))%")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                    }
                }
            }
        }
        .padding()
    }
}