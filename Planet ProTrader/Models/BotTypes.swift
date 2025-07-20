//
//  BotTypes.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 7/19/25.
//

import SwiftUI
import Foundation

// MARK: - Bot Core Types

struct AdvancedBot: Identifiable, Codable {
    let id: String
    let name: String
    var personality: BotPersonalityProfile
    let specialization: BotSpecialization
    let learningCapabilities: [SharedTypes.LearningCapability]
    let tradingTimeframes: [TradingTimeframe]
    let maxPositions: Int
    let riskPerTrade: Double
    let averageHoldTime: Int
    let winRateTarget: Double
    var performance: BotPerformanceMetrics
    var isActive: Bool
    var isLearning: Bool
    var isTrading: Bool
    var createdAt: Date
    var generation: Int
    
    init(
        id: String,
        name: String,
        personality: BotPersonalityProfile,
        specialization: BotSpecialization,
        learningCapabilities: [SharedTypes.LearningCapability],
        tradingTimeframes: [TradingTimeframe],
        maxPositions: Int,
        riskPerTrade: Double,
        averageHoldTime: Int,
        winRateTarget: Double
    ) {
        self.id = id
        self.name = name
        self.personality = personality
        self.specialization = specialization
        self.learningCapabilities = learningCapabilities
        self.tradingTimeframes = tradingTimeframes
        self.maxPositions = maxPositions
        self.riskPerTrade = riskPerTrade
        self.averageHoldTime = averageHoldTime
        self.winRateTarget = winRateTarget
        self.performance = BotPerformanceMetrics(
            id: UUID(),
            name: name,
            profitLoss: 0.0,
            returnPercentage: 0.0,
            winRate: 0.0,
            totalTrades: 0,
            maxDrawdown: 0.0,
            sharpeRatio: 0.0,
            averageWin: 0.0,
            averageLoss: 0.0,
            profitFactor: 1.0,
            lastUpdated: Date()
        )
        self.isActive = true
        self.isLearning = true
        self.isTrading = false
        self.createdAt = Date()
        self.generation = 1
    }
    
    // MARK: - Learning Methods
    
    func learnFromScreenshot(_ event: LearningEvent) async {
        // Process screenshot learning data
        await updateLearningProgress()
    }
    
    func learnFromTranscript(_ event: LearningEvent) async {
        // Process transcript learning data
        await updateLearningProgress()
    }
    
    func learnFromTradeOutcome(_ event: LearningEvent) async {
        // Process trade outcome and adjust strategy
        await updatePerformanceMetrics(event)
    }
    
    // MARK: - Bot Management
    
    mutating func evolvePersonality() {
        // Gradually evolve personality based on performance
        if performance.profitLoss > 0.8 {
            personality.confidence = min(personality.confidence + 0.01, 1.0)
        } else if performance.profitLoss < 0.4 {
            personality.aggressiveness = max(personality.aggressiveness - 0.01, 0.1)
        }
    }
    
    mutating func activate() {
        isActive = true
    }
    
    mutating func deactivate() {
        isActive = false
        isTrading = false
    }
    
    mutating func reset() {
        performance = BotPerformanceMetrics(
            id: UUID(),
            name: name,
            profitLoss: 0.0,
            returnPercentage: 0.0,
            winRate: 0.0,
            totalTrades: 0,
            maxDrawdown: 0.0,
            sharpeRatio: 0.0,
            averageWin: 0.0,
            averageLoss: 0.0,
            profitFactor: 1.0,
            lastUpdated: Date()
        )
        isActive = true
        isLearning = true
        isTrading = false
    }
    
    // MARK: - Private Methods
    
    private func updateLearningProgress() async {
        // Update learning metrics
    }
    
    private func updatePerformanceMetrics(_ event: LearningEvent) async {
        // Update performance based on trade outcome
    }
}

// MARK: - Bot Personality

struct BotPersonalityProfile: Codable {
    var aggressiveness: Double
    var patience: Double
    var riskTolerance: Double
    var adaptability: Double
    var analyticalDepth: Double
    var emotionalControl: Double
    var decisionSpeed: Double
    var learningRate: Double
    var confidence: Double
    let traits: [String]
    let communicationStyle: CommunicationStyle
    let preferredMarketConditions: [MarketCondition]
    
    init(
        aggressiveness: Double,
        patience: Double,
        riskTolerance: Double,
        adaptability: Double,
        analyticalDepth: Double,
        emotionalControl: Double,
        decisionSpeed: Double,
        learningRate: Double,
        traits: [String],
        communicationStyle: CommunicationStyle,
        preferredMarketConditions: [MarketCondition]
    ) {
        self.aggressiveness = aggressiveness
        self.patience = patience
        self.riskTolerance = riskTolerance
        self.adaptability = adaptability
        self.analyticalDepth = analyticalDepth
        self.emotionalControl = emotionalControl
        self.decisionSpeed = decisionSpeed
        self.learningRate = learningRate
        self.confidence = 0.5 // Start with moderate confidence
        self.traits = traits
        self.communicationStyle = communicationStyle
        self.preferredMarketConditions = preferredMarketConditions
    }
    
    var personalityScore: Double {
        return (aggressiveness + patience + riskTolerance + adaptability + 
                analyticalDepth + emotionalControl + decisionSpeed + learningRate) / 8.0
    }
    
    var riskAdjustedScore: Double {
        return personalityScore * (1.0 - (riskTolerance * 0.2))
    }
}

// MARK: - Bot Specializations

enum BotSpecialization: String, Codable, CaseIterable {
    case scalping = "Scalping"
    case swing = "Swing"
    case institutional = "Institutional"
    case contrarian = "Contrarian"
    case news = "News"
    case sentiment = "Sentiment"
    case patterns = "Patterns"
    case riskManagement = "Risk Management"
    case psychology = "Psychology"
    
    var description: String {
        switch self {
        case .scalping: return "High-frequency, quick trades"
        case .swing: return "Medium-term trend following"
        case .institutional: return "Large order flow analysis"
        case .contrarian: return "Counter-trend strategies"
        case .news: return "News-driven trading"
        case .sentiment: return "Market sentiment analysis"
        case .patterns: return "Chart pattern recognition"
        case .riskManagement: return "Risk assessment and control"
        case .psychology: return "Market psychology insights"
        }
    }
    
    var color: Color {
        switch self {
        case .scalping: return .red
        case .swing: return .blue
        case .institutional: return .purple
        case .contrarian: return .orange
        case .news: return .yellow
        case .sentiment: return .green
        case .patterns: return .cyan
        case .riskManagement: return .gray
        case .psychology: return .pink
        }
    }
    
    var systemImage: String {
        switch self {
        case .scalping: return "bolt.fill"
        case .swing: return "waveform.path"
        case .institutional: return "building.columns.fill"
        case .contrarian: return "arrow.triangle.2.circlepath"
        case .news: return "newspaper.fill"
        case .sentiment: return "brain.head.profile"
        case .patterns: return "chart.xyaxis.line"
        case .riskManagement: return "shield.fill"
        case .psychology: return "heart.text.square.fill"
        }
    }
}

// MARK: - Trading Timeframes

enum TradingTimeframe: String, Codable, CaseIterable {
    case oneMinute = "1M"
    case fiveMinute = "5M"
    case fifteenMinute = "15M"
    case thirtyMinute = "30M"
    case oneHour = "1H"
    case fourHour = "4H"
    case daily = "1D"
    case weekly = "1W"
    
    var displayName: String {
        switch self {
        case .oneMinute: return "1 Minute"
        case .fiveMinute: return "5 Minutes"
        case .fifteenMinute: return "15 Minutes"
        case .thirtyMinute: return "30 Minutes"
        case .oneHour: return "1 Hour"
        case .fourHour: return "4 Hours"
        case .daily: return "Daily"
        case .weekly: return "Weekly"
        }
    }
    
    var minutes: Int {
        switch self {
        case .oneMinute: return 1
        case .fiveMinute: return 5
        case .fifteenMinute: return 15
        case .thirtyMinute: return 30
        case .oneHour: return 60
        case .fourHour: return 240
        case .daily: return 1440
        case .weekly: return 10080
        }
    }
    
    var color: Color {
        switch self {
        case .oneMinute, .fiveMinute: return .red
        case .fifteenMinute, .thirtyMinute: return .orange
        case .oneHour: return .yellow
        case .fourHour: return .green
        case .daily: return .blue
        case .weekly: return .purple
        }
    }
}

// MARK: - Communication Styles

enum CommunicationStyle: String, Codable, CaseIterable {
    case concise = "Concise"
    case analytical = "Analytical"
    case technical = "Technical"
    case contrarian = "Contrarian"
    case urgent = "Urgent"
    case observational = "Observational"
    case visual = "Visual"
    case cautious = "Cautious"
    case psychological = "Psychological"
    case aggressive = "Aggressive"
    case patient = "Patient"
    
    var description: String {
        switch self {
        case .concise: return "Brief and to the point"
        case .analytical: return "Data-driven analysis"
        case .technical: return "Technical indicator focused"
        case .contrarian: return "Counter-market perspective"
        case .urgent: return "Time-sensitive alerts"
        case .observational: return "Market observation based"
        case .visual: return "Chart pattern focused"
        case .cautious: return "Risk-aware communication"
        case .psychological: return "Psychology-based insights"
        case .aggressive: return "Bold trading stance"
        case .patient: return "Long-term perspective"
        }
    }
}

// MARK: - Market Conditions

enum MarketCondition: String, Codable, CaseIterable {
    case trending = "Trending"
    case volatile = "Volatile"
    case breakout = "Breakout"
    case structured = "Structured"
    case institutional = "Institutional"
    case oversold = "Oversold"
    case overbought = "Overbought"
    case extreme = "Extreme"
    case news = "News"
    case sentiment = "Sentiment"
    case patterned = "Patterned"
    case technical = "Technical"
    case stable = "Stable"
    case low_risk = "Low Risk"
    case psychological = "Psychological"
    case behavioral = "Behavioral"
    case consolidation = "Consolidation"
    case reversal = "Reversal"
    
    var description: String {
        switch self {
        case .trending: return "Clear directional movement"
        case .volatile: return "High price fluctuation"
        case .breakout: return "Breaking key levels"
        case .structured: return "Organized market flow"
        case .institutional: return "Large player activity"
        case .oversold: return "Below fair value"
        case .overbought: return "Above fair value"
        case .extreme: return "Extreme market conditions"
        case .news: return "News-driven movement"
        case .sentiment: return "Sentiment-driven market"
        case .patterned: return "Clear chart patterns"
        case .technical: return "Technical level respect"
        case .stable: return "Low volatility environment"
        case .low_risk: return "Conservative conditions"
        case .psychological: return "Psychology-driven moves"
        case .behavioral: return "Behavioral pattern based"
        case .consolidation: return "Sideways price action"
        case .reversal: return "Trend change signals"
        }
    }
    
    var color: Color {
        switch self {
        case .trending: return .green
        case .volatile: return .red
        case .breakout: return .orange
        case .structured: return .blue
        case .institutional: return .purple
        case .oversold: return .cyan
        case .overbought: return .yellow
        case .extreme: return .pink
        case .news: return .indigo
        case .sentiment: return .mint
        case .patterned: return .teal
        case .technical: return .brown
        case .stable: return .gray
        case .low_risk: return .gray
        case .psychological: return .purple
        case .behavioral: return .indigo
        case .consolidation: return .orange
        case .reversal: return .red
        }
    }
}

// MARK: - Bot Trade Result 

struct BotTradeResult: Codable {
    let id: String
    let symbol: String
    let direction: SharedTypes.TradeDirection
    let entryPrice: Double
    let exitPrice: Double
    let lotSize: Double
    let profit: Double
    let duration: TimeInterval
    let timestamp: Date
    let reason: String
    
    init(
        id: String = UUID().uuidString,
        symbol: String,
        direction: SharedTypes.TradeDirection,
        entryPrice: Double,
        exitPrice: Double,
        lotSize: Double,
        profit: Double,
        duration: TimeInterval,
        timestamp: Date = Date(),
        reason: String = ""
    ) {
        self.id = id
        self.symbol = symbol
        self.direction = direction
        self.entryPrice = entryPrice
        self.exitPrice = exitPrice
        self.lotSize = lotSize
        self.profit = profit
        self.duration = duration
        self.timestamp = timestamp
        self.reason = reason
    }
    
    var formattedProfit: String {
        let sign = profit >= 0 ? "+" : ""
        return "\(sign)$\(String(format: "%.2f", profit))"
    }
    
    var profitColor: Color {
        return profit >= 0 ? .green : .red
    }
    
    var isWin: Bool {
        return profit > 0
    }
}

struct BotPerformanceMetrics: Codable {
    let id: UUID
    var name: String
    var profitLoss: Double
    var returnPercentage: Double
    var winRate: Double
    var totalTrades: Int
    var maxDrawdown: Double
    var sharpeRatio: Double
    var averageWin: Double
    var averageLoss: Double
    var profitFactor: Double
    var lastUpdated: Date
    
    init(
        id: UUID,
        name: String,
        profitLoss: Double,
        returnPercentage: Double,
        winRate: Double,
        totalTrades: Int,
        maxDrawdown: Double,
        sharpeRatio: Double,
        averageWin: Double,
        averageLoss: Double,
        profitFactor: Double,
        lastUpdated: Date
    ) {
        self.id = id
        self.name = name
        self.profitLoss = profitLoss
        self.returnPercentage = returnPercentage
        self.winRate = winRate
        self.totalTrades = totalTrades
        self.maxDrawdown = maxDrawdown
        self.sharpeRatio = sharpeRatio
        self.averageWin = averageWin
        self.averageLoss = averageLoss
        self.profitFactor = profitFactor
        self.lastUpdated = lastUpdated
    }
}

#Preview {
    Text("Bot Types Definitions")
}