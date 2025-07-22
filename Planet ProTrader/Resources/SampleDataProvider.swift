//
//  SampleDataProvider.swift
//  Planet ProTrader - Sample Data Provider
//
//  Comprehensive Sample Data for Development & Previews
//  Created by Elite Engineering Team
//

import SwiftUI
import Foundation

// MARK: - Sample Data Provider

struct SampleDataProvider {
    
    // MARK: - Trading Bots
    
    static let premiumBots: [TradingBot] = [
        TradingBot(
            name: "GoldMaster Elite",
            strategy: .scalping,
            riskLevel: .high,
            isActive: true,
            winRate: 0.892,
            totalTrades: 2847,
            profitLoss: 15420.88,
            performance: 154.2,
            status: .trading,
            icon: "crown.fill",
            primaryColor: "#FFD700",
            secondaryColor: "#FFA500"
        ),
        TradingBot(
            name: "News Hunter Pro",
            strategy: .news,
            riskLevel: .extreme,
            isActive: true,
            winRate: 0.934,
            totalTrades: 1205,
            profitLoss: 28750.45,
            performance: 287.5,
            status: .analyzing,
            icon: "newspaper.fill",
            primaryColor: "#FF6347",
            secondaryColor: "#DC143C"
        ),
        TradingBot(
            name: "Momentum Beast",
            strategy: .momentum,
            riskLevel: .medium,
            isActive: false,
            winRate: 0.876,
            totalTrades: 892,
            profitLoss: 12340.67,
            performance: 123.4,
            status: .learning,
            icon: "bolt.fill",
            primaryColor: "#9370DB",
            secondaryColor: "#8A2BE2"
        ),
        TradingBot(
            name: "Swing Master",
            strategy: .swing,
            riskLevel: .low,
            isActive: true,
            winRate: 0.785,
            totalTrades: 456,
            profitLoss: 8950.33,
            performance: 89.5,
            status: .active,
            icon: "waveform.path",
            primaryColor: "#00CED1",
            secondaryColor: "#4682B4"
        ),
        TradingBot(
            name: "Grid Arbitrage",
            strategy: .gridTrading,
            riskLevel: .medium,
            isActive: false,
            winRate: 0.671,
            totalTrades: 3421,
            profitLoss: 5670.12,
            performance: 56.7,
            status: .stopped,
            icon: "grid",
            primaryColor: "#32CD32",
            secondaryColor: "#228B22"
        ),
        TradingBot(
            name: "Reversal Hunter",
            strategy: .reversal,
            riskLevel: .high,
            isActive: true,
            winRate: 0.823,
            totalTrades: 678,
            profitLoss: 11230.89,
            performance: 112.3,
            status: .backtesting,
            icon: "arrow.turn.up.left",
            primaryColor: "#FF69B4",
            secondaryColor: "#FF1493"
        ),
        TradingBot(
            name: "Day Trader AI",
            strategy: .dayTrading,
            riskLevel: .medium,
            isActive: true,
            winRate: 0.794,
            totalTrades: 1567,
            profitLoss: 9876.54,
            performance: 98.8,
            status: .optimizing,
            icon: "clock.fill",
            primaryColor: "#4169E1",
            secondaryColor: "#0000CD"
        ),
        TradingBot(
            name: "Copy Master",
            strategy: .copyTrading,
            riskLevel: .low,
            isActive: false,
            winRate: 0.745,
            totalTrades: 234,
            profitLoss: 3456.78,
            performance: 34.6,
            status: .paused,
            icon: "person.2.fill",
            primaryColor: "#20B2AA",
            secondaryColor: "#008B8B"
        )
    ]
    
    // MARK: - Trading Accounts
    
    static let tradingAccounts: [TradingAccount] = [
        TradingAccount(
            accountNumber: "MT5-78901234",
            broker: "MetaTrader 5 Pro",
            accountType: .live,
            balance: 25000.0,
            equity: 27845.67,
            freeMargin: 24500.0,
            leverage: 500,
            currency: "USD",
            isActive: true
        ),
        TradingAccount(
            accountNumber: "DEMO-12345678",
            broker: "MT5 Demo",
            accountType: .demo,
            balance: 10000.0,
            equity: 11247.85,
            freeMargin: 9500.0,
            leverage: 1000,
            currency: "USD",
            isActive: false
        ),
        TradingAccount(
            accountNumber: "OANDA-87654321",
            broker: "OANDA Live",
            accountType: .live,
            balance: 15000.0,
            equity: 15678.90,
            freeMargin: 14200.0,
            leverage: 50,
            currency: "USD",
            isActive: false
        ),
        TradingAccount(
            accountNumber: "CONTEST-99887766",
            broker: "Elite Contest",
            accountType: .contest,
            balance: 50000.0,
            equity: 68420.33,
            freeMargin: 45000.0,
            leverage: 200,
            currency: "USD",
            isActive: false
        )
    ]
    
    // MARK: - Gold Signals
    
    static let goldSignals: [GoldSignal] = [
        GoldSignal(
            type: .buy,
            entryPrice: 2374.85,
            stopLoss: 2364.50,
            takeProfit: 2395.20,
            confidence: 0.94,
            reasoning: "Strong bullish momentum confirmed by multiple timeframe analysis. RSI oversold bounce with volume confirmation.",
            timeframe: "H1",
            status: .active,
            accuracy: 0.91,
            source: .ai
        ),
        GoldSignal(
            type: .sell,
            entryPrice: 2378.20,
            stopLoss: 2385.00,
            takeProfit: 2365.50,
            confidence: 0.87,
            reasoning: "Resistance level reached with bearish divergence on MACD. Key psychological level rejection.",
            timeframe: "M15",
            status: .pending,
            accuracy: 0.85,
            source: .technical
        ),
        GoldSignal(
            type: .buy,
            entryPrice: 2370.50,
            stopLoss: 2360.00,
            takeProfit: 2390.00,
            confidence: 0.96,
            reasoning: "Federal Reserve dovish stance creating bullish sentiment. Economic uncertainty driving gold demand.",
            timeframe: "H4",
            status: .filled,
            accuracy: 0.93,
            source: .news
        ),
        GoldSignal(
            type: .sell,
            entryPrice: 2382.40,
            stopLoss: 2390.80,
            takeProfit: 2368.90,
            confidence: 0.82,
            reasoning: "Double top pattern formation with negative divergence. Volume declining on recent highs.",
            timeframe: "H1",
            status: .cancelled,
            accuracy: 0.78,
            source: .pattern
        ),
        GoldSignal(
            type: .buy,
            entryPrice: 2366.75,
            stopLoss: 2355.20,
            takeProfit: 2388.30,
            confidence: 0.89,
            reasoning: "Market sentiment analysis shows extreme fear. Contrarian opportunity with strong fundamentals.",
            timeframe: "D1",
            status: .expired,
            accuracy: 0.86,
            source: .sentiment
        )
    ]
    
    // MARK: - Market Data
    
    static let marketData: [MarketData] = [
        MarketData(
            symbol: "XAUUSD",
            currentPrice: 2374.85,
            change24h: 12.45,
            changePercentage: 0.53,
            high24h: 2387.25,
            low24h: 2364.80,
            volume: 125487
        ),
        MarketData(
            symbol: "XAGUSD",
            currentPrice: 24.67,
            change24h: -0.23,
            changePercentage: -0.92,
            high24h: 25.12,
            low24h: 24.45,
            volume: 89764
        ),
        MarketData(
            symbol: "EURUSD",
            currentPrice: 1.0845,
            change24h: 0.0012,
            changePercentage: 0.11,
            high24h: 1.0858,
            low24h: 1.0832,
            volume: 234567
        ),
        MarketData(
            symbol: "GBPUSD",
            currentPrice: 1.2678,
            change24h: -0.0034,
            changePercentage: -0.27,
            high24h: 1.2712,
            low24h: 1.2654,
            volume: 156789
        )
    ]
    
    // MARK: - Price History Data
    
    static func generatePriceHistory(days: Int = 30, basePrice: Double = 2374.85) -> [PricePoint] {
        var history: [PricePoint] = []
        var currentPrice = basePrice
        let now = Date()
        
        for i in 0..<days {
            let timestamp = now.addingTimeInterval(-Double(i) * 86400) // 24 hours ago
            let volatility = Double.random(in: 10...30)
            
            let open = currentPrice
            let high = open + Double.random(in: 0...volatility)
            let low = open - Double.random(in: 0...volatility)
            let close = low + Double.random(in: 0...(high - low))
            let volume = Double.random(in: 50000...200000)
            
            history.append(PricePoint(
                timestamp: timestamp,
                open: open,
                high: high,
                low: low,
                close: close,
                volume: volume
            ))
            
            currentPrice = close + Double.random(in: -5...5)
        }
        
        return history.reversed()
    }
    
    // MARK: - News Data
    
    static let newsItems: [NewsItem] = [
        NewsItem(
            title: "Federal Reserve Hints at Dovish Policy Stance",
            summary: "Recent statements from Fed officials suggest a more accommodative monetary policy approach, potentially boosting gold prices.",
            impact: .high,
            sentiment: .bullish,
            timestamp: Date().addingTimeInterval(-3600)
        ),
        NewsItem(
            title: "Geopolitical Tensions Rise in Eastern Europe",
            summary: "Escalating conflicts drive investors towards safe-haven assets including gold and precious metals.",
            impact: .medium,
            sentiment: .bullish,
            timestamp: Date().addingTimeInterval(-7200)
        ),
        NewsItem(
            title: "US Dollar Strengthens Against Major Currencies",
            summary: "Dollar index reaches multi-month highs, potentially pressuring gold prices in the near term.",
            impact: .medium,
            sentiment: .bearish,
            timestamp: Date().addingTimeInterval(-10800)
        ),
        NewsItem(
            title: "Central Bank Gold Purchases Hit Record High",
            summary: "Global central banks continue accumulating gold reserves, supporting long-term price outlook.",
            impact: .high,
            sentiment: .bullish,
            timestamp: Date().addingTimeInterval(-14400)
        )
    ]
    
    struct NewsItem: Identifiable {
        let id = UUID()
        let title: String
        let summary: String
        let impact: Impact
        let sentiment: Sentiment
        let timestamp: Date
        
        enum Impact: String, CaseIterable {
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
        }
        
        enum Sentiment: String, CaseIterable {
            case bullish = "Bullish"
            case bearish = "Bearish"
            case neutral = "Neutral"
            
            var color: Color {
                switch self {
                case .bullish: return .bullishGreen
                case .bearish: return .bearishRed
                case .neutral: return .neutralGray
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
    
    struct PricePoint: Identifiable, Codable {
        let id = UUID()
        let timestamp: Date
        let open: Double
        let high: Double
        let low: Double
        let close: Double
        let volume: Double
        
        var bodyColor: Color {
            close >= open ? .bullishGreen : .bearishRed
        }
        
        var isGreen: Bool {
            close >= open
        }
    }
    
    // MARK: - Performance Metrics
    
    static let performanceMetrics = PerformanceMetrics(
        totalReturn: 1547.89,
        totalReturnPercentage: 15.48,
        sharpeRatio: 2.34,
        maxDrawdown: 0.032,
        winRate: 0.876,
        profitFactor: 2.41,
        averageWin: 87.45,
        averageLoss: -36.23,
        largestWin: 456.78,
        largestLoss: -123.45,
        totalTrades: 2847,
        winningTrades: 2494,
        losingTrades: 353
    )
    
    struct PerformanceMetrics {
        let totalReturn: Double
        let totalReturnPercentage: Double
        let sharpeRatio: Double
        let maxDrawdown: Double
        let winRate: Double
        let profitFactor: Double
        let averageWin: Double
        let averageLoss: Double
        let largestWin: Double
        let largestLoss: Double
        let totalTrades: Int
        let winningTrades: Int
        let losingTrades: Int
        
        var formattedTotalReturn: String {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.positivePrefix = "+"
            return formatter.string(from: NSNumber(value: totalReturn)) ?? "$0.00"
        }
        
        var formattedReturnPercentage: String {
            String(format: "+%.2f%%", totalReturnPercentage)
        }
        
        var formattedWinRate: String {
            String(format: "%.1f%%", winRate * 100)
        }
        
        var formattedMaxDrawdown: String {
            String(format: "%.1f%%", maxDrawdown * 100)
        }
        
        var formattedSharpeRatio: String {
            String(format: "%.2f", sharpeRatio)
        }
    }
    
    // MARK: - Utility Methods
    
    static func randomBot() -> TradingBot {
        premiumBots.randomElement() ?? premiumBots[0]
    }
    
    static func randomSignal() -> GoldSignal {
        goldSignals.randomElement() ?? goldSignals[0]
    }
    
    static func randomAccount() -> TradingAccount {
        tradingAccounts.randomElement() ?? tradingAccounts[0]
    }
    
    static func randomMarketData() -> MarketData {
        marketData.randomElement() ?? marketData[0]
    }
}

// MARK: - Mock Data for Development

extension SampleDataProvider {
    
    static func createMockEnvironment() -> (
        bots: [TradingBot],
        accounts: [TradingAccount],
        signals: [GoldSignal],
        prices: [PricePoint]
    ) {
        return (
            bots: Array(premiumBots.prefix(5)),
            accounts: Array(tradingAccounts.prefix(3)),
            signals: Array(goldSignals.prefix(4)),
            prices: Array(generatePriceHistory(days: 7).prefix(100))
        )
    }
    
    static var developmentConfiguration: DevelopmentConfig {
        DevelopmentConfig(
            enableMockData: true,
            simulateNetworkDelay: true,
            mockApiResponses: true,
            enableDebugMode: true,
            logLevel: .verbose
        )
    }
    
    struct DevelopmentConfig {
        let enableMockData: Bool
        let simulateNetworkDelay: Bool
        let mockApiResponses: Bool
        let enableDebugMode: Bool
        let logLevel: LogLevel
        
        enum LogLevel {
            case none, error, warning, info, verbose
        }
    }
}

// MARK: - Previews

#Preview("Sample Data Preview") {
    ScrollView {
        LazyVStack(spacing: 16) {
            // Sample Bot
            let sampleBot = SampleDataProvider.premiumBots.first!
            HStack(spacing: 12) {
                Circle()
                    .fill(Color(hex: sampleBot.primaryColor) ?? DesignSystem.primaryGold)
                    .frame(width: 50, height: 50)
                    .overlay(
                        Image(systemName: sampleBot.icon)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(sampleBot.name)
                        .font(.headline.bold())
                    
                    Text(sampleBot.strategy.displayName)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        Circle()
                            .fill(sampleBot.status.color)
                            .frame(width: 8, height: 8)
                        
                        Text(sampleBot.status.rawValue)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("+\(String(format: "%.1f", sampleBot.performance))%")
                        .font(.title3.bold())
                        .foregroundColor(.green)
                    
                    Text(sampleBot.formattedProfit)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .premiumGlassBackground()
            
            // Sample Performance Metrics
            let metrics = SampleDataProvider.performanceMetrics
            VStack(spacing: 12) {
                Text("Performance Overview")
                    .font(.title2.bold())
                
                HStack(spacing: 16) {
                    StatCard(title: "Total Return", value: metrics.formattedTotalReturn, color: .successGreen)
                    StatCard(title: "Win Rate", value: metrics.formattedWinRate, color: .infoBlue)
                    StatCard(title: "Sharpe Ratio", value: metrics.formattedSharpeRatio, color: DesignSystem.primaryGold)
                }
            }
            .padding()
            .premiumCardStyle()
            
            Text("✅ Sample Data Provider Ready")
                .font(.headline)
                .foregroundColor(.successGreen)
                .padding()
        }
        .padding()
    }
    .background(.premiumBackground)
    .preferredColorScheme(.light)
}