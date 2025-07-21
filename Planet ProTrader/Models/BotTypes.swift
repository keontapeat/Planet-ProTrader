//
//  BotTypes.swift
//  GOLDEX AI  
//
//  Fixed All Codable and Type Issues - Uses Master Types
//  Updated by Alex AI Assistant
//

import SwiftUI
import Foundation

// MARK: - Bot Core Types

struct AdvancedBot: Identifiable, Codable {
    let id: UUID
    let name: String
    var personality: BotPersonalityProfile
    let specialization: BotSpecialization
    let learningCapabilities: [LearningCapability]
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
    
    // Add missing properties that are referenced in views
    var icon: String
    var primaryColor: String
    var secondaryColor: String
    var status: BotStatus
    var winRate: Double
    
    init(
        id: UUID = UUID(),
        name: String,
        personality: BotPersonalityProfile,
        specialization: BotSpecialization,
        learningCapabilities: [LearningCapability] = [],
        tradingTimeframes: [TradingTimeframe] = [.oneHour],
        maxPositions: Int = 3,
        riskPerTrade: Double = 0.02,
        averageHoldTime: Int = 240,
        winRateTarget: Double = 0.65,
        icon: String = "robot",
        primaryColor: String = "#007AFF",
        secondaryColor: String = "#5AC8FA"
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
        self.icon = icon
        self.primaryColor = primaryColor
        self.secondaryColor = secondaryColor
        
        // Initialize performance metrics
        self.performance = BotPerformanceMetrics(
            botId: id.uuidString,
            totalTrades: 0,
            winningTrades: 0,
            losingTrades: 0,
            totalProfit: 0.0,
            winRate: 0.0,
            profitFactor: 1.0,
            maxDrawdown: 0.0
        )
        
        self.isActive = true
        self.isLearning = true
        self.isTrading = false
        self.createdAt = Date()
        self.generation = 1
        self.status = .inactive
        self.winRate = 0.0
    }
    
    // MARK: - Learning Methods
    
    func learnFromScreenshot(_ event: LearningEvent) async {
        await updateLearningProgress()
    }
    
    func learnFromTranscript(_ event: LearningEvent) async {
        await updateLearningProgress()
    }
    
    func learnFromTradeOutcome(_ event: LearningEvent) async {
        await updatePerformanceMetrics(event)
    }
    
    // MARK: - Bot Management
    
    mutating func evolvePersonality() {
        if performance.winRate >= 0.8 {
            personality.confidence = min(personality.confidence + 0.01, 1.0)
        } else if performance.winRate < 0.4 {
            personality.aggressiveness = max(personality.aggressiveness - 0.01, 0.1)
        }
    }
    
    mutating func activate() {
        isActive = true
        status = .active
    }
    
    mutating func deactivate() {
        isActive = false
        isTrading = false
        status = .inactive
    }
    
    mutating func reset() {
        performance = BotPerformanceMetrics(
            botId: id.uuidString,
            totalTrades: 0,
            winningTrades: 0,
            losingTrades: 0,
            totalProfit: 0.0,
            winRate: 0.0,
            profitFactor: 1.0,
            maxDrawdown: 0.0
        )
        isActive = true
        isLearning = true
        isTrading = false
        status = .learning
    }
    
    // MARK: - Private Methods
    
    private func updateLearningProgress() async {
        // Update learning metrics
    }
    
    private func updatePerformanceMetrics(_ event: LearningEvent) async {
        // Update performance based on trade outcome
    }
}

// MARK: - Enhanced Bot Personality Profile

struct BotPersonalityProfile: Identifiable, Codable {
    let id: UUID
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
    let name: String
    let personality: String
    let experience: String
    let specialties: [String]
    let analysisTypes: [String]
    let timeframes: [String]
    
    init(
        id: UUID = UUID(),
        name: String = "AI Trader",
        personality: String = "Analytical",
        aggressiveness: Double = 0.5,
        patience: Double = 0.7,
        riskTolerance: Double = 0.6,
        adaptability: Double = 0.8,
        analyticalDepth: Double = 0.9,
        emotionalControl: Double = 0.8,
        decisionSpeed: Double = 0.7,
        learningRate: Double = 0.8,
        traits: [String] = [],
        communicationStyle: CommunicationStyle = .analytical,
        preferredMarketConditions: [MarketCondition] = [.trending],
        experience: String = "Intermediate",
        specialties: [String] = [],
        analysisTypes: [String] = [],
        timeframes: [String] = []
    ) {
        self.id = id
        self.name = name
        self.personality = personality
        self.aggressiveness = aggressiveness
        self.patience = patience
        self.riskTolerance = riskTolerance
        self.adaptability = adaptability
        self.analyticalDepth = analyticalDepth
        self.emotionalControl = emotionalControl
        self.decisionSpeed = decisionSpeed
        self.learningRate = learningRate
        self.confidence = 0.5
        self.traits = traits
        self.communicationStyle = communicationStyle
        self.preferredMarketConditions = preferredMarketConditions
        self.experience = experience
        self.specialties = specialties
        self.analysisTypes = analysisTypes
        self.timeframes = timeframes
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

// MARK: - Learning Capabilities

enum LearningCapability: String, CaseIterable, Codable {
    case patternRecognition = "Pattern Recognition"
    case riskManagement = "Risk Management"
    case technicalAnalysis = "Technical Analysis"
    case fundamentalAnalysis = "Fundamental Analysis"
    case sentimentAnalysis = "Sentiment Analysis"
    case marketTiming = "Market Timing"
    case priceAction = "Price Action"
    case volumeAnalysis = "Volume Analysis"
    case microstructure = "Microstructure"
    case supportResistance = "Support Resistance"
    case fundamentals = "Fundamentals"
    case trendAnalysis = "Trend Analysis"
    case orderFlow = "Order Flow"
    case marketStructure = "Market Structure"
    case liquidity = "Liquidity"
    case extremes = "Extremes"
    case meanReversion = "Mean Reversion"
    case sentiment = "Sentiment"
    case socialMedia = "Social Media"
    case positioning = "Positioning"
    case newsAnalysis = "News Analysis"
    case eventTrading = "Event Trading"
    case volatility = "Volatility"
    case chartPatterns = "Chart Patterns"
    case candlesticks = "Candlesticks"
    case riskAssessment = "Risk Assessment"
    case portfolioManagement = "Portfolio Management"
    case correlation = "Correlation"
    case behaviorAnalysis = "Behavior Analysis"
    case emotionalPatterns = "Emotional Patterns"
    case marketPsychology = "Market Psychology"
    
    var description: String {
        switch self {
        case .patternRecognition: return "Identifies recurring market patterns"
        case .riskManagement: return "Optimizes risk-reward ratios"
        case .technicalAnalysis: return "Analyzes price action and indicators"
        case .fundamentalAnalysis: return "Evaluates economic factors"
        case .sentimentAnalysis: return "Gauges market sentiment"
        case .marketTiming: return "Times market entry and exit"
        default: return rawValue
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

struct BotTradeResult: Identifiable, Codable {
    let id: UUID
    let symbol: String
    let direction: TradeDirection
    let entryPrice: Double
    let exitPrice: Double
    let lotSize: Double
    let profit: Double
    let duration: TimeInterval
    let timestamp: Date
    let reason: String
    
    init(
        id: UUID = UUID(),
        symbol: String,
        direction: TradeDirection,
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

// MARK: - Learning Event

struct LearningEvent: Codable {
    let id: UUID
    let type: EventType
    let data: String
    let timestamp: Date
    
    enum EventType: String, Codable {
        case screenshot = "Screenshot"
        case transcript = "Transcript"
        case tradeOutcome = "Trade Outcome"
        case marketData = "Market Data"
    }
    
    init(
        id: UUID = UUID(),
        type: EventType,
        data: String,
        timestamp: Date = Date()
    ) {
        self.id = id
        self.type = type
        self.data = data
        self.timestamp = timestamp
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 16) {
        Text("🤖 Bot Types")
            .font(.title.bold())
            .foregroundColor(.blue)
        
        Text("All bot types with Codable conformance")
            .font(.subheadline)
            .foregroundColor(.secondary)
        
        HStack {
            VStack(alignment: .leading) {
                Text("Specializations:")
                    .font(.caption.bold())
                ForEach(Array(BotSpecialization.allCases.prefix(3)), id: \.self) { spec in
                    Text("• \(spec.rawValue)")
                        .font(.caption)
                        .foregroundColor(spec.color)
                }
            }
            
            Spacer()
            
            VStack(alignment: .leading) {
                Text("Timeframes:")
                    .font(.caption.bold())
                ForEach(Array(TradingTimeframe.allCases.prefix(3)), id: \.self) { tf in
                    Text("• \(tf.displayName)")
                        .font(.caption)
                        .foregroundColor(tf.color)
                }
            }
        }
    }
    .padding()
    .background(Color(.systemGray6))
    .cornerRadius(12)
}