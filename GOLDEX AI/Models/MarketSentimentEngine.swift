//
//  MarketSentimentEngine.swift
//  GOLDEX AI
//
//  Created by Keonta on 7/13/25.
//

import Foundation
import SwiftUI

// MARK: - Market Sentiment Engine™
class MarketSentimentEngine: ObservableObject {
    
    // MARK: - Published Properties
    @Published var isActive = false
    @Published var isAnalyzing = false
    @Published var overallSentiment: MarketSentiment = .neutral
    @Published var retailSentiment: RetailSentiment = RetailSentiment()
    @Published var institutionalSentiment: InstitutionalSentiment = InstitutionalSentiment()
    @Published var fearGreedIndex: FearGreedIndex = FearGreedIndex()
    @Published var newsSentiment: NewsSentiment = NewsSentiment()
    @Published var socialSentiment: SocialSentiment = SocialSentiment()
    @Published var volatilityWarnings: [VolatilityWarning] = []
    @Published var tradingRecommendations: [TradingRecommendation] = []
    @Published var lastAnalysisTime = Date()
    
    // MARK: - Market Sentiment
    enum MarketSentiment: CaseIterable {
        case extremeFear
        case fear
        case neutral
        case greed
        case extremeGreed
        
        var displayName: String {
            switch self {
            case .extremeFear: return "Extreme Fear"
            case .fear: return "Fear"
            case .neutral: return "Neutral"
            case .greed: return "Greed"
            case .extremeGreed: return "Extreme Greed"
            }
        }
        
        var color: Color {
            switch self {
            case .extremeFear: return .red
            case .fear: return .orange
            case .neutral: return .gray
            case .greed: return .green
            case .extremeGreed: return .purple
            }
        }
        
        var value: Double {
            switch self {
            case .extremeFear: return 0.0
            case .fear: return 0.25
            case .neutral: return 0.5
            case .greed: return 0.75
            case .extremeGreed: return 1.0
            }
        }
        
        var tradingAdvice: String {
            switch self {
            case .extremeFear: return "Contrarian opportunity - Consider buying"
            case .fear: return "Cautious buying opportunities"
            case .neutral: return "Normal trading conditions"
            case .greed: return "Be cautious - Consider taking profits"
            case .extremeGreed: return "High risk - Avoid new positions"
            }
        }
    }
    
    // MARK: - Retail Sentiment
    struct RetailSentiment {
        var bullishPercentage: Double = 0.0
        var bearishPercentage: Double = 0.0
        var confidence: Double = 0.0
        var positionSize: Double = 0.0
        var leverageUsage: Double = 0.0
        var fomoCLevel: Double = 0.0
        var panicLevel: Double = 0.0
        var sources: [SentimentSource] = []
        
        var sentiment: MarketSentiment {
            let netBullish = bullishPercentage - bearishPercentage
            
            switch netBullish {
            case ..<(-0.6): return .extremeFear
            case (-0.6)..<(-0.2): return .fear
            case (-0.2)...(0.2): return .neutral
            case 0.2...0.6: return .greed
            default: return .extremeGreed
            }
        }
        
        struct SentimentSource {
            let name: String
            let bullishPercentage: Double
            let reliability: Double
            let lastUpdate: Date
        }
        
        mutating func updateRetailSentiment() {
            bullishPercentage = Double.random(in: 0.2...0.8)
            bearishPercentage = 1.0 - bullishPercentage
            confidence = Double.random(in: 0.3...0.9)
            positionSize = Double.random(in: 0.1...0.8)
            leverageUsage = Double.random(in: 0.2...0.9)
            fomoCLevel = Double.random(in: 0.1...0.7)
            panicLevel = Double.random(in: 0.1...0.6)
            
            sources = [
                SentimentSource(name: "Forex Factory", bullishPercentage: Double.random(in: 0.3...0.7), reliability: 0.85, lastUpdate: Date()),
                SentimentSource(name: "Twitter/X", bullishPercentage: Double.random(in: 0.2...0.8), reliability: 0.65, lastUpdate: Date()),
                SentimentSource(name: "Reddit", bullishPercentage: Double.random(in: 0.25...0.75), reliability: 0.60, lastUpdate: Date()),
                SentimentSource(name: "TradingView", bullishPercentage: Double.random(in: 0.35...0.65), reliability: 0.75, lastUpdate: Date())
            ]
        }
    }
    
    // MARK: - Institutional Sentiment
    struct InstitutionalSentiment {
        var positioningData: PositioningData = PositioningData()
        var flowData: FlowData = FlowData()
        var orderBookData: OrderBookData = OrderBookData()
        var darkPoolActivity: Double = 0.0
        var smartMoneyMoves: [SmartMoneyMove] = []
        var institutionalConfidence: Double = 0.0
        
        struct PositioningData {
            var netLong: Double = 0.0
            var netShort: Double = 0.0
            var positionChanges: Double = 0.0
            var leverageRatio: Double = 0.0
        }
        
        struct FlowData {
            var inflowRate: Double = 0.0
            var outflowRate: Double = 0.0
            var netFlow: Double = 0.0
            var flowVelocity: Double = 0.0
        }
        
        struct OrderBookData {
            var bidLiquidity: Double = 0.0
            var askLiquidity: Double = 0.0
            var liquidityImbalance: Double = 0.0
            var largeOrderActivity: Double = 0.0
        }
        
        struct SmartMoneyMove {
            let id = UUID()
            let type: MoveType
            let size: Double
            let impact: Double
            let timestamp: Date
            let description: String
            
            enum MoveType {
                case accumulation
                case distribution
                case hedging
                case arbitrage
                case momentum
                
                var displayName: String {
                    switch self {
                    case .accumulation: return "Accumulation"
                    case .distribution: return "Distribution"
                    case .hedging: return "Hedging"
                    case .arbitrage: return "Arbitrage"
                    case .momentum: return "Momentum"
                    }
                }
            }
        }
        
        mutating func updateInstitutionalSentiment() {
            positioningData.netLong = Double.random(in: 0.3...0.8)
            positioningData.netShort = 1.0 - positioningData.netLong
            positioningData.positionChanges = Double.random(in: -0.3...0.3)
            positioningData.leverageRatio = Double.random(in: 1.5...8.0)
            
            flowData.inflowRate = Double.random(in: 0.2...0.9)
            flowData.outflowRate = Double.random(in: 0.1...0.8)
            flowData.netFlow = flowData.inflowRate - flowData.outflowRate
            flowData.flowVelocity = Double.random(in: 0.3...0.9)
            
            orderBookData.bidLiquidity = Double.random(in: 0.4...0.9)
            orderBookData.askLiquidity = Double.random(in: 0.3...0.8)
            orderBookData.liquidityImbalance = orderBookData.bidLiquidity - orderBookData.askLiquidity
            orderBookData.largeOrderActivity = Double.random(in: 0.2...0.8)
            
            darkPoolActivity = Double.random(in: 0.1...0.7)
            institutionalConfidence = Double.random(in: 0.4...0.9)
            
            smartMoneyMoves = [
                SmartMoneyMove(type: .accumulation, size: Double.random(in: 50...200), impact: Double.random(in: 0.5...0.9), timestamp: Date(), description: "Large institutional accumulation detected"),
                SmartMoneyMove(type: .distribution, size: Double.random(in: 30...150), impact: Double.random(in: 0.4...0.8), timestamp: Date(), description: "Smart money distribution pattern"),
                SmartMoneyMove(type: .hedging, size: Double.random(in: 20...100), impact: Double.random(in: 0.3...0.7), timestamp: Date(), description: "Hedging activity increased")
            ]
        }
    }
    
    // MARK: - Fear & Greed Index
    struct FearGreedIndex {
        var currentValue: Double = 0.5
        var previousValue: Double = 0.5
        var trend: IndexTrend = .stable
        var components: [IndexComponent] = []
        var historicalData: [HistoricalReading] = []
        
        enum IndexTrend {
            case rising
            case falling
            case stable
            
            var displayName: String {
                switch self {
                case .rising: return "Rising"
                case .falling: return "Falling"
                case .stable: return "Stable"
                }
            }
            
            var color: Color {
                switch self {
                case .rising: return .green
                case .falling: return .red
                case .stable: return .gray
                }
            }
        }
        
        struct IndexComponent {
            let name: String
            let value: Double
            let weight: Double
            let contribution: Double
        }
        
        struct HistoricalReading {
            let value: Double
            let date: Date
        }
        
        mutating func updateIndex() {
            previousValue = currentValue
            currentValue = Double.random(in: 0.0...1.0)
            
            if currentValue > previousValue + 0.05 {
                trend = .rising
            } else if currentValue < previousValue - 0.05 {
                trend = .falling
            } else {
                trend = .stable
            }
            
            components = [
                IndexComponent(name: "Market Momentum", value: Double.random(in: 0.0...1.0), weight: 0.25, contribution: 0.0),
                IndexComponent(name: "Stock Price Strength", value: Double.random(in: 0.0...1.0), weight: 0.25, contribution: 0.0),
                IndexComponent(name: "Stock Price Breadth", value: Double.random(in: 0.0...1.0), weight: 0.15, contribution: 0.0),
                IndexComponent(name: "Put/Call Ratio", value: Double.random(in: 0.0...1.0), weight: 0.1, contribution: 0.0),
                IndexComponent(name: "Market Volatility", value: Double.random(in: 0.0...1.0), weight: 0.1, contribution: 0.0),
                IndexComponent(name: "Safe Haven Demand", value: Double.random(in: 0.0...1.0), weight: 0.1, contribution: 0.0),
                IndexComponent(name: "Junk Bond Demand", value: Double.random(in: 0.0...1.0), weight: 0.05, contribution: 0.0)
            ]
            
            // Add historical reading
            historicalData.append(HistoricalReading(value: currentValue, date: Date()))
            
            // Keep only last 30 readings
            if historicalData.count > 30 {
                historicalData.removeFirst()
            }
        }
        
        var sentiment: MarketSentiment {
            switch currentValue {
            case 0.0...0.2: return .extremeFear
            case 0.2...0.4: return .fear
            case 0.4...0.6: return .neutral
            case 0.6...0.8: return .greed
            default: return .extremeGreed
            }
        }
    }
    
    // MARK: - News Sentiment
    struct NewsSentiment {
        var overallSentiment: Double = 0.0
        var newsItems: [NewsItem] = []
        var economicCalendar: [EconomicEvent] = []
        var newsCycles: [NewsCycle] = []
        var volatilityPrediction: Double = 0.0
        
        struct NewsItem {
            let id = UUID()
            let title: String
            let sentiment: Double
            let impact: NewsImpact
            let timestamp: Date
            let source: String
            let relevance: Double
            
            enum NewsImpact {
                case low
                case medium
                case high
                case critical
                
                var displayName: String {
                    switch self {
                    case .low: return "Low"
                    case .medium: return "Medium"
                    case .high: return "High"
                    case .critical: return "Critical"
                    }
                }
                
                var color: Color {
                    switch self {
                    case .low: return .green
                    case .medium: return .yellow
                    case .high: return .orange
                    case .critical: return .red
                    }
                }
            }
        }
        
        struct EconomicEvent {
            let id = UUID()
            let name: String
            let impact: NewsItem.NewsImpact
            let timeUntil: TimeInterval
            let currency: String
            let forecast: String
            let previous: String
        }
        
        struct NewsCycle {
            let id = UUID()
            let theme: String
            let duration: TimeInterval
            let intensity: Double
            let marketReaction: Double
        }
        
        mutating func updateNewsSentiment() {
            overallSentiment = Double.random(in: -1.0...1.0)
            
            newsItems = [
                NewsItem(title: "Federal Reserve considers interest rate changes", sentiment: Double.random(in: -0.5...0.5), impact: .high, timestamp: Date(), source: "Reuters", relevance: 0.9),
                NewsItem(title: "Gold prices surge on inflation concerns", sentiment: Double.random(in: 0.3...0.8), impact: .medium, timestamp: Date(), source: "Bloomberg", relevance: 0.85),
                NewsItem(title: "Geopolitical tensions affect market stability", sentiment: Double.random(in: -0.8...0.2), impact: .critical, timestamp: Date(), source: "Financial Times", relevance: 0.75),
                NewsItem(title: "Economic data shows mixed signals", sentiment: Double.random(in: -0.3...0.3), impact: .medium, timestamp: Date(), source: "Wall Street Journal", relevance: 0.7)
            ]
            
            economicCalendar = [
                EconomicEvent(name: "Non-Farm Payrolls", impact: .critical, timeUntil: 3600, currency: "USD", forecast: "200K", previous: "180K"),
                EconomicEvent(name: "CPI Data", impact: .high, timeUntil: 7200, currency: "USD", forecast: "0.3%", previous: "0.2%"),
                EconomicEvent(name: "Fed Speech", impact: .medium, timeUntil: 1800, currency: "USD", forecast: "N/A", previous: "N/A")
            ]
            
            volatilityPrediction = Double.random(in: 0.3...0.9)
        }
    }
    
    // MARK: - Social Sentiment
    struct SocialSentiment {
        var twitterSentiment: Double = 0.0
        var redditSentiment: Double = 0.0
        var discordSentiment: Double = 0.0
        var telegramSentiment: Double = 0.0
        var influencerSentiment: Double = 0.0
        var socialTrends: [SocialTrend] = []
        var viralityScore: Double = 0.0
        
        struct SocialTrend {
            let id = UUID()
            let platform: String
            let trend: String
            let sentiment: Double
            let volume: Double
            let velocity: Double
        }
        
        mutating func updateSocialSentiment() {
            twitterSentiment = Double.random(in: -1.0...1.0)
            redditSentiment = Double.random(in: -1.0...1.0)
            discordSentiment = Double.random(in: -1.0...1.0)
            telegramSentiment = Double.random(in: -1.0...1.0)
            influencerSentiment = Double.random(in: -1.0...1.0)
            viralityScore = Double.random(in: 0.0...1.0)
            
            socialTrends = [
                SocialTrend(platform: "Twitter", trend: "#GoldRush", sentiment: Double.random(in: 0.2...0.8), volume: Double.random(in: 0.3...0.9), velocity: Double.random(in: 0.4...0.8)),
                SocialTrend(platform: "Reddit", trend: "r/Gold", sentiment: Double.random(in: -0.2...0.6), volume: Double.random(in: 0.2...0.7), velocity: Double.random(in: 0.3...0.7)),
                SocialTrend(platform: "Discord", trend: "Trading Channels", sentiment: Double.random(in: -0.4...0.4), volume: Double.random(in: 0.4...0.8), velocity: Double.random(in: 0.2...0.6))
            ]
        }
    }
    
    // MARK: - Volatility Warnings
    struct VolatilityWarning {
        let id = UUID()
        let type: WarningType
        let severity: Severity
        let timeframe: String
        let description: String
        let recommendation: String
        let timestamp: Date
        
        enum WarningType {
            case newsEvent
            case extremeSentiment
            case lowLiquidity
            case highVolatility
            case marketClosure
            
            var displayName: String {
                switch self {
                case .newsEvent: return "News Event"
                case .extremeSentiment: return "Extreme Sentiment"
                case .lowLiquidity: return "Low Liquidity"
                case .highVolatility: return "High Volatility"
                case .marketClosure: return "Market Closure"
                }
            }
            
            var icon: String {
                switch self {
                case .newsEvent: return "newspaper"
                case .extremeSentiment: return "exclamationmark.triangle"
                case .lowLiquidity: return "drop"
                case .highVolatility: return "waveform.path.ecg"
                case .marketClosure: return "clock"
                }
            }
        }
        
        enum Severity {
            case low
            case medium
            case high
            case critical
            
            var color: Color {
                switch self {
                case .low: return .green
                case .medium: return .yellow
                case .high: return .orange
                case .critical: return .red
                }
            }
        }
    }
    
    // MARK: - Trading Recommendations
    struct TradingRecommendation {
        let id = UUID()
        let type: RecommendationType
        let confidence: Double
        let description: String
        let reasoning: String
        let timestamp: Date
        
        enum RecommendationType {
            case avoid
            case reduce
            case normal
            case increase
            case aggressive
            
            var displayName: String {
                switch self {
                case .avoid: return "Avoid Trading"
                case .reduce: return "Reduce Position Size"
                case .normal: return "Normal Trading"
                case .increase: return "Increase Position Size"
                case .aggressive: return "Aggressive Trading"
                }
            }
            
            var color: Color {
                switch self {
                case .avoid: return .red
                case .reduce: return .orange
                case .normal: return .gray
                case .increase: return .green
                case .aggressive: return .blue
                }
            }
        }
    }
    
    // MARK: - Analysis Methods
    func startAnalysis() {
        isAnalyzing = true
        lastAnalysisTime = Date()
        
        // Update all sentiment components
        updateAllSentiments()
        
        // Generate warnings and recommendations
        generateWarningsAndRecommendations()
        
        // Calculate overall sentiment
        calculateOverallSentiment()
        
        // Simulate analysis completion
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.isAnalyzing = false
        }
    }
    
    private func updateAllSentiments() {
        retailSentiment.updateRetailSentiment()
        institutionalSentiment.updateInstitutionalSentiment()
        fearGreedIndex.updateIndex()
        newsSentiment.updateNewsSentiment()
        socialSentiment.updateSocialSentiment()
    }
    
    private func generateWarningsAndRecommendations() {
        // Generate volatility warnings
        volatilityWarnings = []
        
        if fearGreedIndex.currentValue > 0.8 || fearGreedIndex.currentValue < 0.2 {
            volatilityWarnings.append(VolatilityWarning(
                type: .extremeSentiment,
                severity: .high,
                timeframe: "Next 4 hours",
                description: "Extreme sentiment detected - high volatility expected",
                recommendation: "Reduce position sizes and avoid new entries",
                timestamp: Date()
            ))
        }
        
        if newsSentiment.volatilityPrediction > 0.7 {
            volatilityWarnings.append(VolatilityWarning(
                type: .newsEvent,
                severity: .medium,
                timeframe: "Next 2 hours",
                description: "High-impact news event approaching",
                recommendation: "Monitor closely and be prepared for volatility",
                timestamp: Date()
            ))
        }
        
        // Generate trading recommendations
        tradingRecommendations = []
        
        let sentimentScore = overallSentiment.value
        
        if sentimentScore < 0.2 || sentimentScore > 0.8 {
            tradingRecommendations.append(TradingRecommendation(
                type: .avoid,
                confidence: 0.85,
                description: "Avoid new positions due to extreme sentiment",
                reasoning: "Extreme sentiment often leads to false breakouts and reversals",
                timestamp: Date()
            ))
        } else if sentimentScore < 0.4 || sentimentScore > 0.6 {
            tradingRecommendations.append(TradingRecommendation(
                type: .reduce,
                confidence: 0.7,
                description: "Reduce position sizes",
                reasoning: "Elevated sentiment increases risk of unexpected moves",
                timestamp: Date()
            ))
        } else {
            tradingRecommendations.append(TradingRecommendation(
                type: .normal,
                confidence: 0.6,
                description: "Normal trading conditions",
                reasoning: "Balanced sentiment allows for normal risk management",
                timestamp: Date()
            ))
        }
    }
    
    private func calculateOverallSentiment() {
        let retailWeight = 0.2
        let institutionalWeight = 0.3
        let fearGreedWeight = 0.25
        let newsWeight = 0.15
        let socialWeight = 0.1
        
        let weightedSentiment = (
            retailSentiment.sentiment.value * retailWeight +
            (institutionalSentiment.positioningData.netLong) * institutionalWeight +
            fearGreedIndex.currentValue * fearGreedWeight +
            ((newsSentiment.overallSentiment + 1.0) / 2.0) * newsWeight +
            ((socialSentiment.twitterSentiment + 1.0) / 2.0) * socialWeight
        )
        
        switch weightedSentiment {
        case 0.0...0.2:
            overallSentiment = .extremeFear
        case 0.2...0.4:
            overallSentiment = .fear
        case 0.4...0.6:
            overallSentiment = .neutral
        case 0.6...0.8:
            overallSentiment = .greed
        default:
            overallSentiment = .extremeGreed
        }
    }
    
    // MARK: - Engine Control
    func activateEngine() {
        isActive = true
        startAnalysis()
    }
    
    func deactivateEngine() {
        isActive = false
        isAnalyzing = false
        overallSentiment = .neutral
        volatilityWarnings.removeAll()
        tradingRecommendations.removeAll()
    }
    
    // MARK: - Trading Filters
    func shouldAvoidTrading() -> Bool {
        guard isActive else { return false }
        
        // Check for extreme sentiment
        if overallSentiment == .extremeFear || overallSentiment == .extremeGreed {
            return true
        }
        
        // Check for critical volatility warnings
        if volatilityWarnings.contains(where: { $0.severity == .critical }) {
            return true
        }
        
        // Check for avoid recommendations
        if tradingRecommendations.contains(where: { $0.type == .avoid }) {
            return true
        }
        
        return false
    }
    
    func getPositionSizeMultiplier() -> Double {
        guard isActive else { return 1.0 }
        
        if let recommendation = tradingRecommendations.first {
            switch recommendation.type {
            case .avoid:
                return 0.0
            case .reduce:
                return 0.5
            case .normal:
                return 1.0
            case .increase:
                return 1.5
            case .aggressive:
                return 2.0
            }
        }
        
        return 1.0
    }
}

#Preview {
    VStack {
        Text("Market Sentiment Engine")
            .font(.title)
            .padding()
    }
}