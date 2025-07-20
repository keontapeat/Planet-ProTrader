//
//  BotCommunicationTypes.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 7/19/25.
//

import SwiftUI
import Foundation

// MARK: - Bot Communication System

struct BotChatMessage: Identifiable, Codable {
    let id: String
    let botId: String
    let botName: String
    let content: String
    let timestamp: Date
    let confidence: Double
    let messageType: MessageType
    let priority: MessagePriority
    let tags: [String]
    let replyToId: String?
    let reactions: [MessageReaction]
    let isFromUser: Bool
    
    init(
        id: String = UUID().uuidString,
        botId: String,
        botName: String,
        content: String,
        timestamp: Date = Date(),
        confidence: Double,
        messageType: MessageType,
        priority: MessagePriority = .medium,
        tags: [String] = [],
        replyToId: String? = nil,
        reactions: [MessageReaction] = [],
        isFromUser: Bool
    ) {
        self.id = id
        self.botId = botId
        self.botName = botName
        self.content = content
        self.timestamp = timestamp
        self.confidence = confidence
        self.messageType = messageType
        self.priority = priority
        self.tags = tags
        self.replyToId = replyToId
        self.reactions = reactions
        self.isFromUser = isFromUser
    }
    
    var formattedTimestamp: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: timestamp)
    }
    
    var formattedConfidence: String {
        return String(format: "%.1f%%", confidence * 100)
    }
    
    var confidenceColor: Color {
        switch confidence {
        case 0.8...:
            return .green
        case 0.6..<0.8:
            return .orange
        default:
            return .red
        }
    }
    
    var hasSpecialContent: Bool {
        return content.contains("trades") || content.contains("P&L") || content.contains("analysis")
    }
}

// MARK: - Message Types

enum MessageType: String, Codable, CaseIterable {
    case analysis = "Analysis"
    case alert = "Alert"
    case discussion = "Discussion"
    case signal = "Signal"
    case warning = "Warning"
    case insight = "Insight"
    case question = "Question"
    case recommendation = "Recommendation"
    case report = "Report"
    case celebration = "Celebration"
    
    var description: String {
        switch self {
        case .analysis: return "Technical or fundamental analysis"
        case .alert: return "Important market alert"
        case .discussion: return "General discussion message"
        case .signal: return "Trading signal or opportunity"
        case .warning: return "Risk warning or caution"
        case .insight: return "Market insight or observation"
        case .question: return "Question for other bots"
        case .recommendation: return "Strategic recommendation"
        case .report: return "Performance or status report"
        case .celebration: return "Success celebration"
        }
    }
    
    var color: Color {
        switch self {
        case .analysis: return .blue
        case .alert: return .red
        case .discussion: return .gray
        case .signal: return .green
        case .warning: return .orange
        case .insight: return .purple
        case .question: return .cyan
        case .recommendation: return .indigo
        case .report: return .brown
        case .celebration: return .yellow
        }
    }
    
    var systemImage: String {
        switch self {
        case .analysis: return "chart.xyaxis.line"
        case .alert: return "exclamationmark.triangle.fill"
        case .discussion: return "bubble.left.and.bubble.right.fill"
        case .signal: return "bolt.fill"
        case .warning: return "exclamationmark.shield.fill"
        case .insight: return "lightbulb.fill"
        case .question: return "questionmark.circle.fill"
        case .recommendation: return "hand.thumbsup.fill"
        case .report: return "doc.text.fill"
        case .celebration: return "party.popper.fill"
        }
    }
}

// MARK: - Message Priority

enum MessagePriority: String, Codable, CaseIterable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    case urgent = "Urgent"
    case critical = "Critical"
    
    var weight: Int {
        switch self {
        case .low: return 1
        case .medium: return 2
        case .high: return 3
        case .urgent: return 4
        case .critical: return 5
        }
    }
    
    var color: Color {
        switch self {
        case .low: return .gray
        case .medium: return .blue
        case .high: return .orange
        case .urgent: return .red
        case .critical: return .pink
        }
    }
    
    var shouldNotify: Bool {
        return weight >= 3
    }
}

// MARK: - Message Reactions

struct MessageReaction: Identifiable, Codable {
    let id: String
    let botId: String
    let reactionType: ReactionType
    let timestamp: Date
    
    init(
        id: String = UUID().uuidString,
        botId: String,
        reactionType: ReactionType,
        timestamp: Date = Date()
    ) {
        self.id = id
        self.botId = botId
        self.reactionType = reactionType
        self.timestamp = timestamp
    }
}

enum ReactionType: String, Codable, CaseIterable {
    case agree = "👍"
    case disagree = "👎"
    case insightful = "💡"
    case accurate = "🎯"
    case questionable = "🤔"
    case celebrate = "🎉"
    case caution = "⚠️"
    case fire = "🔥"
    
    var description: String {
        switch self {
        case .agree: return "Agree"
        case .disagree: return "Disagree"
        case .insightful: return "Insightful"
        case .accurate: return "Accurate"
        case .questionable: return "Questionable"
        case .celebrate: return "Celebrate"
        case .caution: return "Caution"
        case .fire: return "Hot Take"
        }
    }
}

// MARK: - Bot Discussion

struct BotDiscussion: Identifiable, Codable {
    let id: String
    let topic: String
    let participants: [String]
    let startTime: Date
    var endTime: Date?
    var messages: [BotChatMessage]
    let discussionType: DiscussionType
    let priority: MessagePriority
    var status: DiscussionStatus
    var consensusReached: Bool
    var finalConsensus: String?
    
    init(
        id: String = UUID().uuidString,
        topic: String,
        participants: [String],
        startTime: Date = Date(),
        endTime: Date? = nil,
        messages: [BotChatMessage] = [],
        discussionType: DiscussionType = .general,
        priority: MessagePriority = .medium,
        status: DiscussionStatus = .active,
        consensusReached: Bool = false,
        finalConsensus: String? = nil
    ) {
        self.id = id
        self.topic = topic
        self.participants = participants
        self.startTime = startTime
        self.endTime = endTime
        self.messages = messages
        self.discussionType = discussionType
        self.priority = priority
        self.status = status
        self.consensusReached = consensusReached
        self.finalConsensus = finalConsensus
    }
    
    var duration: TimeInterval {
        return (endTime ?? Date()).timeIntervalSince(startTime)
    }
    
    var participantCount: Int {
        return participants.count
    }
    
    var messageCount: Int {
        return messages.count
    }
    
    var averageConfidence: Double {
        guard !messages.isEmpty else { return 0.0 }
        let totalConfidence = messages.reduce(0.0) { $0 + $1.confidence }
        return totalConfidence / Double(messages.count)
    }
    
    mutating func addMessage(_ message: BotChatMessage) {
        messages.append(message)
        
        // Check for consensus if we have enough messages
        if messages.count >= 3 && !consensusReached {
            checkForConsensus()
        }
    }
    
    mutating func endDiscussion(consensus: String? = nil) {
        status = .completed
        endTime = Date()
        finalConsensus = consensus
        consensusReached = consensus != nil
    }
    
    private mutating func checkForConsensus() {
        // Simple consensus detection based on similar messages or high confidence
        let highConfidenceMessages = messages.filter { $0.confidence > 0.8 }
        
        if highConfidenceMessages.count >= 2 {
            // Look for similar content or agreement
            let agreementKeywords = ["agree", "correct", "yes", "exactly", "right"]
            let agreements = messages.filter { message in
                agreementKeywords.contains { message.content.lowercased().contains($0) }
            }
            
            if agreements.count >= 2 {
                consensusReached = true
                finalConsensus = "Consensus reached on \(topic)"
            }
        }
    }
}

// MARK: - Discussion Types

enum DiscussionType: String, Codable, CaseIterable {
    case general = "General"
    case marketAnalysis = "Market Analysis"
    case riskAssessment = "Risk Assessment"
    case patternDiscussion = "Pattern Discussion"
    case performanceReview = "Performance Review"
    case strategyDebate = "Strategy Debate"
    case newsReaction = "News Reaction"
    case emergencyAlert = "Emergency Alert"
    
    var description: String {
        switch self {
        case .general: return "General discussion"
        case .marketAnalysis: return "Market condition analysis"
        case .riskAssessment: return "Risk evaluation discussion"
        case .patternDiscussion: return "Pattern recognition debate"
        case .performanceReview: return "Performance analysis"
        case .strategyDebate: return "Strategy discussion"
        case .newsReaction: return "News impact discussion"
        case .emergencyAlert: return "Emergency situation"
        }
    }
    
    var color: Color {
        switch self {
        case .general: return .gray
        case .marketAnalysis: return .blue
        case .riskAssessment: return .orange
        case .patternDiscussion: return .green
        case .performanceReview: return .purple
        case .strategyDebate: return .indigo
        case .newsReaction: return .red
        case .emergencyAlert: return .pink
        }
    }
}

// MARK: - Discussion Status

enum DiscussionStatus: String, Codable, CaseIterable {
    case active = "Active"
    case paused = "Paused"
    case completed = "Completed"
    case archived = "Archived"
    
    var color: Color {
        switch self {
        case .active: return .green
        case .paused: return .orange
        case .completed: return .blue
        case .archived: return .gray
        }
    }
}

// MARK: - Consensus Signal

struct ConsensusSignal: Identifiable, Codable {
    let id: String
    let direction: SharedTypes.TradeDirection
    let confidence: Double
    let participatingBots: [String]
    let reasoning: String
    let timestamp: Date
    let symbol: String
    let entryPrice: Double?
    let stopLoss: Double?
    let takeProfit: Double?
    let timeframe: String
    let consensusStrength: ConsensusStrength
    let voteBreakdown: VoteBreakdown
    let riskLevel: TradingTypes.RiskLevel
    
    init(
        id: String = UUID().uuidString,
        direction: SharedTypes.TradeDirection,
        confidence: Double,
        participatingBots: [String],
        reasoning: String,
        timestamp: Date = Date(),
        symbol: String = "UNKNOWN",
        entryPrice: Double? = nil,
        stopLoss: Double? = nil,
        takeProfit: Double? = nil,
        timeframe: String = "1H",
        consensusStrength: ConsensusStrength = .moderate,
        voteBreakdown: VoteBreakdown = VoteBreakdown(),
        riskLevel: TradingTypes.RiskLevel = .medium
    ) {
        self.id = id
        self.direction = direction
        self.confidence = confidence
        self.participatingBots = participatingBots
        self.reasoning = reasoning
        self.timestamp = timestamp
        self.symbol = symbol
        self.entryPrice = entryPrice
        self.stopLoss = stopLoss
        self.takeProfit = takeProfit
        self.timeframe = timeframe
        self.consensusStrength = consensusStrength
        self.voteBreakdown = voteBreakdown
        self.riskLevel = riskLevel
    }
    
    var formattedConfidence: String {
        return String(format: "%.1f%%", confidence * 100)
    }
    
    var participantCount: Int {
        return participatingBots.count
    }
    
    var isStrongConsensus: Bool {
        return confidence > 0.8 && participantCount >= 5
    }
    
    var shouldExecute: Bool {
        return isStrongConsensus && riskLevel != .high
    }
}

// MARK: - Consensus Strength

enum ConsensusStrength: String, Codable, CaseIterable {
    case weak = "Weak"
    case moderate = "Moderate"
    case strong = "Strong"
    case unanimous = "Unanimous"
    
    var threshold: Double {
        switch self {
        case .weak: return 0.5
        case .moderate: return 0.7
        case .strong: return 0.85
        case .unanimous: return 0.95
        }
    }
    
    var color: Color {
        switch self {
        case .weak: return .red
        case .moderate: return .orange
        case .strong: return .green
        case .unanimous: return .blue
        }
    }
    
    var description: String {
        switch self {
        case .weak: return "Limited agreement among bots"
        case .moderate: return "Moderate agreement with some dissent"
        case .strong: return "Strong agreement with high confidence"
        case .unanimous: return "Complete agreement across all bots"
        }
    }
}

// MARK: - Vote Breakdown

struct VoteBreakdown: Codable {
    var bullishVotes: Int
    var bearishVotes: Int
    var neutralVotes: Int
    var abstainVotes: Int
    
    init(
        bullishVotes: Int = 0,
        bearishVotes: Int = 0,
        neutralVotes: Int = 0,
        abstainVotes: Int = 0
    ) {
        self.bullishVotes = bullishVotes
        self.bearishVotes = bearishVotes
        self.neutralVotes = neutralVotes
        self.abstainVotes = abstainVotes
    }
    
    var totalVotes: Int {
        return bullishVotes + bearishVotes + neutralVotes + abstainVotes
    }
    
    var bullishPercentage: Double {
        guard totalVotes > 0 else { return 0.0 }
        return Double(bullishVotes) / Double(totalVotes)
    }
    
    var bearishPercentage: Double {
        guard totalVotes > 0 else { return 0.0 }
        return Double(bearishVotes) / Double(totalVotes)
    }
    
    var neutralPercentage: Double {
        guard totalVotes > 0 else { return 0.0 }
        return Double(neutralVotes) / Double(totalVotes)
    }
    
    var dominantSentiment: String {
        let max = Swift.max(bullishVotes, bearishVotes, neutralVotes)
        if max == bullishVotes { return "Bullish" }
        if max == bearishVotes { return "Bearish" }
        return "Neutral"
    }
}

// MARK: - Global Bot Stats

struct GlobalBotStats: Codable {
    let totalBots: Int
    let activeBots: Int
    let learningBots: Int
    let tradingBots: Int
    let averagePerformance: Double
    let totalTrades: Int
    let overallWinRate: Double
    let generation: Int
    let totalDiscussions: Int
    let activeDiscussions: Int
    let consensusSignals: Int
    let lastUpdated: Date
    
    init(
        totalBots: Int = 0,
        activeBots: Int = 0,
        learningBots: Int = 0,
        tradingBots: Int = 0,
        averagePerformance: Double = 0.0,
        totalTrades: Int = 0,
        overallWinRate: Double = 0.0,
        generation: Int = 1,
        totalDiscussions: Int = 0,
        activeDiscussions: Int = 0,
        consensusSignals: Int = 0,
        lastUpdated: Date = Date()
    ) {
        self.totalBots = totalBots
        self.activeBots = activeBots
        self.learningBots = learningBots
        self.tradingBots = tradingBots
        self.averagePerformance = averagePerformance
        self.totalTrades = totalTrades
        self.overallWinRate = overallWinRate
        self.generation = generation
        self.totalDiscussions = totalDiscussions
        self.activeDiscussions = activeDiscussions
        self.consensusSignals = consensusSignals
        self.lastUpdated = lastUpdated
    }
    
    var formattedWinRate: String {
        return String(format: "%.1f%%", overallWinRate * 100)
    }
    
    var formattedPerformance: String {
        return String(format: "%.2f", averagePerformance)
    }
    
    var botEfficiency: Double {
        guard totalBots > 0 else { return 0.0 }
        return Double(activeBots) / Double(totalBots)
    }
    
    var communicationActivity: Double {
        guard totalBots > 0 else { return 0.0 }
        return Double(activeDiscussions) / Double(totalBots)
    }
}

#Preview {
    Text("Bot Communication Types")
}