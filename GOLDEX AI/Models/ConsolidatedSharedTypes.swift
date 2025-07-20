//
//  ConsolidatedSharedTypes.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 1/27/25.
//  Consolidated shared types to avoid duplicates
//

import Foundation
import SwiftUI

// MARK: - Shared Types Namespace
struct SharedTypesV2 {
    
    // MARK: - Bot Communication
    struct BotChatMessage: Identifiable, Codable {
        let id: UUID
        let botId: UUID
        let content: String
        let timestamp: Date
        let messageType: MessageType
        let isFromUser: Bool
        
        enum MessageType: String, Codable, CaseIterable {
            case text = "TEXT"
            case analysis = "ANALYSIS"
            case signal = "SIGNAL"
            case alert = "ALERT"
            case system = "SYSTEM"
        }
        
        init(id: UUID = UUID(), botId: UUID, content: String, messageType: MessageType = .text, isFromUser: Bool = false) {
            self.id = id
            self.botId = botId
            self.content = content
            self.timestamp = Date()
            self.messageType = messageType
            self.isFromUser = isFromUser
        }
    }
    
    // MARK: - Trading Patterns
    struct TradingPattern: Identifiable, Codable {
        let id: UUID
        let name: String
        let patternType: PatternType
        let confidence: Double
        let timeframe: String
        let description: String
        let strength: Double
        let signals: [String]
        let timestamp: Date
        
        enum PatternType: String, CaseIterable, Codable {
            case support = "SUPPORT"
            case resistance = "RESISTANCE"
            case breakout = "BREAKOUT"
            case reversal = "REVERSAL"
            case continuation = "CONTINUATION"
            case triangle = "TRIANGLE"
            case wedge = "WEDGE"
            case flag = "FLAG"
            case pennant = "PENNANT"
            case head_and_shoulders = "HEAD_AND_SHOULDERS"
        }
        
        init(id: UUID = UUID(), name: String, patternType: PatternType, confidence: Double, timeframe: String, description: String, strength: Double, signals: [String]) {
            self.id = id
            self.name = name
            self.patternType = patternType
            self.confidence = confidence
            self.timeframe = timeframe
            self.description = description
            self.strength = strength
            self.signals = signals
            self.timestamp = Date()
        }
    }
    
    // MARK: - Trading Opportunities
    struct TradingOpportunity: Identifiable, Codable {
        let id: UUID
        let title: String
        let signal: String
        let confidence: Double
        let entryPrice: Double
        let targetPrice: Double
        let stopLoss: Double
        let riskReward: Double
        let timeframe: String
        let analysis: String
        let timestamp: Date
        
        init(id: UUID = UUID(), title: String, signal: String, confidence: Double, entryPrice: Double, targetPrice: Double, stopLoss: Double, riskReward: Double, timeframe: String, analysis: String) {
            self.id = id
            self.title = title
            self.signal = signal
            self.confidence = confidence
            self.entryPrice = entryPrice
            self.targetPrice = targetPrice
            self.stopLoss = stopLoss
            self.riskReward = riskReward
            self.timeframe = timeframe
            self.analysis = analysis
            self.timestamp = Date()
        }
    }
    
    // MARK: - News Articles
    struct NewsArticle: Identifiable, Codable, Hashable {
        let id: UUID
        let title: String
        let content: String
        let summary: String
        let source: String
        let publishedAt: Date
        let impact: NewsImpact
        let category: NewsCategory
        let imageURL: String?
        let tags: [String]
        let sentiment: Double // -1.0 to 1.0
        
        init(id: UUID = UUID(), title: String, content: String, summary: String, source: String, publishedAt: Date = Date(), impact: NewsImpact, category: NewsCategory, imageURL: String? = nil, tags: [String] = [], sentiment: Double = 0.0) {
            self.id = id
            self.title = title
            self.content = content
            self.summary = summary
            self.source = source
            self.publishedAt = publishedAt
            self.impact = impact
            self.category = category
            self.imageURL = imageURL
            self.tags = tags
            self.sentiment = sentiment
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
        
        static func == (lhs: NewsArticle, rhs: NewsArticle) -> Bool {
            lhs.id == rhs.id
        }
    }
    
    // MARK: - News Impact
    enum NewsImpact: String, CaseIterable, Codable {
        case low = "LOW"
        case medium = "MEDIUM" 
        case high = "HIGH"
        case critical = "CRITICAL"
        
        var displayName: String {
            switch self {
            case .low: return "Low Impact"
            case .medium: return "Medium Impact"
            case .high: return "High Impact"
            case .critical: return "Critical Impact"
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
        
        var emoji: String {
            switch self {
            case .low: return "🟢"
            case .medium: return "🟡"
            case .high: return "🟠"
            case .critical: return "🔴"
            }
        }
    }
    
    // MARK: - News Category
    enum NewsCategory: String, CaseIterable, Codable {
        case markets = "MARKETS"
        case economics = "ECONOMICS"
        case politics = "POLITICS"
        case central_banks = "CENTRAL_BANKS"
        case commodities = "COMMODITIES"
        case crypto = "CRYPTO"
        case earnings = "EARNINGS"
        case analysis = "ANALYSIS"
        
        var displayName: String {
            switch self {
            case .markets: return "Markets"
            case .economics: return "Economics"
            case .politics: return "Politics"
            case .central_banks: return "Central Banks"
            case .commodities: return "Commodities"
            case .crypto: return "Crypto"
            case .earnings: return "Earnings"
            case .analysis: return "Analysis"
            }
        }
        
        var icon: String {
            switch self {
            case .markets: return "chart.xyaxis.line"
            case .economics: return "dollarsign.circle"
            case .politics: return "building.columns"
            case .central_banks: return "banknote"
            case .commodities: return "leaf"
            case .crypto: return "bitcoinsign.circle"
            case .earnings: return "chart.bar"
            case .analysis: return "brain.head.profile"
            }
        }
    }
    
    // MARK: - Bot Personality Profile
    struct BotPersonalityProfile: Identifiable, Codable {
        let id: UUID
        let name: String
        let characteristics: [String]
        let strengths: [String]
        let weaknesses: [String]
        let communicationStyle: CommunicationStyle
        let riskTolerance: RiskTolerance
        let tradingStyle: TradingStyle
        let specialties: [String]
        let catchphrases: [String]
        
        enum CommunicationStyle: String, CaseIterable, Codable {
            case aggressive = "AGGRESSIVE"
            case analytical = "ANALYTICAL"
            case friendly = "FRIENDLY"
            case professional = "PROFESSIONAL"
            case casual = "CASUAL"
            case mysterious = "MYSTERIOUS"
        }
        
        enum RiskTolerance: String, CaseIterable, Codable {
            case conservative = "CONSERVATIVE"
            case moderate = "MODERATE"
            case aggressive = "AGGRESSIVE"
            case extreme = "EXTREME"
        }
        
        enum TradingStyle: String, CaseIterable, Codable {
            case scalping = "SCALPING"
            case dayTrading = "DAY_TRADING"
            case swingTrading = "SWING_TRADING"
            case longTerm = "LONG_TERM"
            case news = "NEWS_BASED"
            case technical = "TECHNICAL"
            case fundamental = "FUNDAMENTAL"
        }
        
        init(id: UUID = UUID(), name: String, characteristics: [String], strengths: [String], weaknesses: [String], communicationStyle: CommunicationStyle, riskTolerance: RiskTolerance, tradingStyle: TradingStyle, specialties: [String], catchphrases: [String]) {
            self.id = id
            self.name = name
            self.characteristics = characteristics
            self.strengths = strengths
            self.weaknesses = weaknesses
            self.communicationStyle = communicationStyle
            self.riskTolerance = riskTolerance
            self.tradingStyle = tradingStyle
            self.specialties = specialties
            self.catchphrases = catchphrases
        }
    }
    
    // MARK: - Bot Performance
    struct BotPerformance: Identifiable, Codable {
        let id: UUID
        var totalTrades: Int
        var winningTrades: Int
        var losingTrades: Int
        var totalProfitLoss: Double
        var winRate: Double
        var averageWin: Double
        var averageLoss: Double
        var profitFactor: Double
        var sharpeRatio: Double
        var maxDrawdown: Double
        var currentStreak: Int
        var bestTrade: Double
        var worstTrade: Double
        var lastUpdated: Date
        
        init(id: UUID = UUID()) {
            self.id = id
            self.totalTrades = 0
            self.winningTrades = 0
            self.losingTrades = 0
            self.totalProfitLoss = 0.0
            self.winRate = 0.0
            self.averageWin = 0.0
            self.averageLoss = 0.0
            self.profitFactor = 0.0
            self.sharpeRatio = 0.0
            self.maxDrawdown = 0.0
            self.currentStreak = 0
            self.bestTrade = 0.0
            self.worstTrade = 0.0
            self.lastUpdated = Date()
        }
    }
    
    // MARK: - Economic Events
    struct EconomicEvent: Identifiable, Codable {
        let id: UUID
        let title: String
        let country: String
        let currency: String
        let impact: EconomicImpact
        let forecast: String?
        let previous: String?
        let actual: String?
        let timestamp: Date
        let description: String
        
        init(id: UUID = UUID(), title: String, country: String, currency: String, impact: EconomicImpact, forecast: String? = nil, previous: String? = nil, actual: String? = nil, timestamp: Date = Date(), description: String = "") {
            self.id = id
            self.title = title
            self.country = country
            self.currency = currency
            self.impact = impact
            self.forecast = forecast
            self.previous = previous
            self.actual = actual
            self.timestamp = timestamp
            self.description = description
        }
    }
    
    // MARK: - Economic Impact
    enum EconomicImpact: String, CaseIterable, Codable {
        case low = "LOW"
        case medium = "MEDIUM"
        case high = "HIGH"
        
        var displayName: String {
            switch self {
            case .low: return "Low"
            case .medium: return "Medium"
            case .high: return "High"
            }
        }
        
        var color: Color {
            switch self {
            case .low: return .green
            case .medium: return .yellow
            case .high: return .red
            }
        }
        
        var emoji: String {
            switch self {
            case .low: return "🟢"
            case .medium: return "🟡"
            case .high: return "🔴"
            }
        }
    }
    
    // MARK: - Market Sentiment
    struct MarketSentiment: Codable {
        let overall: Double // -1.0 to 1.0
        let bullish: Double
        let bearish: Double
        let neutral: Double
        let confidence: Double
        let timestamp: Date
        let sources: [String]
        
        init(overall: Double, bullish: Double, bearish: Double, neutral: Double, confidence: Double, sources: [String] = []) {
            self.overall = overall
            self.bullish = bullish
            self.bearish = bearish
            self.neutral = neutral
            self.confidence = confidence
            self.timestamp = Date()
            self.sources = sources
        }
        
        var sentimentText: String {
            switch overall {
            case 0.5...: return "Bullish"
            case 0.1..<0.5: return "Slightly Bullish"
            case -0.1...0.1: return "Neutral"
            case -0.5..<(-0.1): return "Slightly Bearish"
            default: return "Bearish"
            }
        }
        
        var sentimentColor: Color {
            switch overall {
            case 0.3...: return .green
            case 0.1..<0.3: return .mint
            case -0.1...0.1: return .gray
            case -0.3..<(-0.1): return .orange
            default: return .red
            }
        }
    }
    
    // MARK: - Account Status
    enum AccountStatus: String, CaseIterable, Codable {
        case active = "ACTIVE"
        case inactive = "INACTIVE"
        case suspended = "SUSPENDED"
        case pending = "PENDING"
        case closed = "CLOSED"
        
        var displayName: String {
            switch self {
            case .active: return "Active"
            case .inactive: return "Inactive"  
            case .suspended: return "Suspended"
            case .pending: return "Pending"
            case .closed: return "Closed"
            }
        }
        
        var color: Color {
            switch self {
            case .active: return .green
            case .inactive: return .gray
            case .suspended: return .orange
            case .pending: return .yellow
            case .closed: return .red
            }
        }
    }
    
    // MARK: - Session Types
    enum SessionType: String, CaseIterable, Codable {
        case eliteHealthCheck = "ELITE_HEALTH_CHECK"
        case emergencyFix = "EMERGENCY_FIX" 
        case performanceOptimization = "PERFORMANCE_OPTIMIZATION"
        case bugHunt = "BUG_HUNT"
        case codeReview = "CODE_REVIEW"
        case securityAudit = "SECURITY_AUDIT"
        
        var displayName: String {
            switch self {
            case .eliteHealthCheck: return "Elite Health Check"
            case .emergencyFix: return "Emergency Fix"
            case .performanceOptimization: return "Performance Optimization"
            case .bugHunt: return "Bug Hunt"
            case .codeReview: return "Code Review"
            case .securityAudit: return "Security Audit"
            }
        }
        
        var icon: String {
            switch self {
            case .eliteHealthCheck: return "checkmark.shield"
            case .emergencyFix: return "exclamationmark.triangle"
            case .performanceOptimization: return "speedometer"
            case .bugHunt: return "ladybug"
            case .codeReview: return "doc.text.magnifyingglass"
            case .securityAudit: return "lock.shield"
            }
        }
    }
    
    // MARK: - Finding Types
    enum FindingType: String, CaseIterable, Codable {
        case error = "ERROR"
        case warning = "WARNING"
        case info = "INFO"
        case suggestion = "SUGGESTION"
        case critical = "CRITICAL"
        
        var displayName: String {
            switch self {
            case .error: return "Error"
            case .warning: return "Warning"
            case .info: return "Info"
            case .suggestion: return "Suggestion"
            case .critical: return "Critical"
            }
        }
        
        var color: Color {
            switch self {
            case .error: return .red
            case .warning: return .orange
            case .info: return .blue
            case .suggestion: return .green
            case .critical: return .purple
            }
        }
        
        var icon: String {
            switch self {
            case .error: return "xmark.circle"
            case .warning: return "exclamationmark.triangle"
            case .info: return "info.circle"
            case .suggestion: return "lightbulb"
            case .critical: return "exclamationmark.octagon"
            }
        }
    }
    
    // MARK: - Time Filters
    enum NewsTimeFilter: String, CaseIterable, Codable {
        case all = "ALL"
        case today = "TODAY"
        case week = "WEEK"
        case month = "MONTH"
        case year = "YEAR"
        
        var displayName: String {
            switch self {
            case .all: return "All Time"
            case .today: return "Today"
            case .week: return "This Week"
            case .month: return "This Month"
            case .year: return "This Year"
            }
        }
    }
    
    // MARK: - Calendar Timeframes
    enum CalendarTimeframe: String, CaseIterable, Codable {
        case today = "TODAY"
        case tomorrow = "TOMORROW"
        case week = "WEEK"
        case month = "MONTH"
        
        var displayName: String {
            switch self {
            case .today: return "Today"
            case .tomorrow: return "Tomorrow"
            case .week: return "This Week"
            case .month: return "This Month"
            }
        }
    }
}

// MARK: - Type Aliases for Backward Compatibility
typealias BotChatMessage = SharedTypesV2.BotChatMessage
typealias TradingPattern = SharedTypesV2.TradingPattern
typealias TradingOpportunity = SharedTypesV2.TradingOpportunity
typealias NewsArticle = SharedTypesV2.NewsArticle
typealias NewsImpact = SharedTypesV2.NewsImpact
typealias NewsCategory = SharedTypesV2.NewsCategory
typealias BotPersonalityProfile = SharedTypesV2.BotPersonalityProfile
typealias BotPerformance = SharedTypesV2.BotPerformance
typealias EconomicEvent = SharedTypesV2.EconomicEvent
typealias EconomicImpact = SharedTypesV2.EconomicImpact
typealias MarketSentiment = SharedTypesV2.MarketSentiment
typealias AccountStatus = SharedTypesV2.AccountStatus
typealias SessionType = SharedTypesV2.SessionType
typealias FindingType = SharedTypesV2.FindingType
typealias NewsTimeFilter = SharedTypesV2.NewsTimeFilter
typealias CalendarTimeframe = SharedTypesV2.CalendarTimeframe

#Preview("Consolidated Shared Types") {
    VStack {
        Text("Consolidated Shared Types")
            .font(.title)
            .padding()
        
        Text("This file contains all shared types to avoid duplicates")
            .font(.caption)
            .foregroundColor(.secondary)
            .padding()
    }
}