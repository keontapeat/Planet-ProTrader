//
//  ProTraderDiscordModels.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 7/18/25.
//

import Foundation
import SwiftUI

// MARK: - ProTrader Discord Simulation Models

struct ProTraderChannel: Identifiable, Codable {
    let id: UUID
    let name: String
    let description: String
    let channelType: ChannelType
    let isActive: Bool
    let participantCount: Int
    let messagesCount: Int
    let createdAt: Date
    let lastActivity: Date
    
    enum ChannelType: String, Codable, CaseIterable {
        case generalTrading = "general-trading"
        case goldSignals = "xauusd-signals"
        case marketAnalysis = "market-analysis"
        case botShowdown = "bot-showdown"
        case winnerCircle = "winners-circle"
        case botTrashTalk = "bot-trash-talk"
        case liveTrading = "live-trading"
        case newbies = "newbie-corner"
        case proBattle = "pro-battle-arena"
        case eliteTrades = "elite-trades"
        
        var displayName: String {
            switch self {
            case .generalTrading: return "🏆 General Trading"
            case .goldSignals: return "🥇 XAUUSD Signals"
            case .marketAnalysis: return "📊 Market Analysis"
            case .botShowdown: return "🤖 Bot Showdown"
            case .winnerCircle: return "👑 Winner's Circle"
            case .botTrashTalk: return "💬 Bot Trash Talk"
            case .liveTrading: return "🔴 Live Trading"
            case .newbies: return "🌱 Newbie Corner"
            case .proBattle: return "⚔️ Pro Battle Arena"
            case .eliteTrades: return "💎 Elite Trades"
            }
        }
        
        var color: Color {
            switch self {
            case .generalTrading: return .blue
            case .goldSignals: return DesignSystem.primaryGold
            case .marketAnalysis: return .purple
            case .botShowdown: return .red
            case .winnerCircle: return .yellow
            case .botTrashTalk: return .orange
            case .liveTrading: return .red
            case .newbies: return .green
            case .proBattle: return .indigo
            case .eliteTrades: return .pink
            }
        }
        
        var systemImage: String {
            switch self {
            case .generalTrading: return "chart.bar.fill"
            case .goldSignals: return "dollarsign.circle.fill"
            case .marketAnalysis: return "chart.xyaxis.line"
            case .botShowdown: return "brain.head.profile"
            case .winnerCircle: return "crown.fill"
            case .botTrashTalk: return "bubble.left.and.bubble.right.fill"
            case .liveTrading: return "dot.radiowaves.left.and.right"
            case .newbies: return "graduationcap.fill"
            case .proBattle: return "sword.fill"
            case .eliteTrades: return "diamond.fill"
            }
        }
    }
    
    init(
        id: UUID = UUID(),
        name: String,
        description: String,
        channelType: ChannelType,
        isActive: Bool = true,
        participantCount: Int = 0,
        messagesCount: Int = 0,
        createdAt: Date = Date(),
        lastActivity: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.channelType = channelType
        self.isActive = isActive
        self.participantCount = participantCount
        self.messagesCount = messagesCount
        self.createdAt = createdAt
        self.lastActivity = lastActivity
    }
}

struct ProTraderMessage: Identifiable, Codable {
    let id: UUID
    let channelId: UUID
    let botId: String
    let botName: String
    let content: String
    let timestamp: Date
    let messageType: MessageType
    let tradeSetup: TradeSetup?
    let reactions: [MessageReaction]
    let confidence: Double
    let aggressionLevel: Double
    let trashTalkLevel: Double
    let isEdited: Bool
    let editedAt: Date?
    let replyToMessageId: UUID?
    
    enum MessageType: String, Codable, CaseIterable {
        case signal = "SIGNAL"
        case trashTalk = "TRASH_TALK"
        case analysis = "ANALYSIS"
        case victory = "VICTORY"
        case defeat = "DEFEAT"
        case challenge = "CHALLENGE"
        case support = "SUPPORT"
        case warning = "WARNING"
        case celebration = "CELEBRATION"
        case prediction = "PREDICTION"
        case complaint = "COMPLAINT"
        case brag = "BRAG"
        
        var displayName: String {
            switch self {
            case .signal: return "📈 Signal"
            case .trashTalk: return "💬 Trash Talk"
            case .analysis: return "📊 Analysis"
            case .victory: return "🏆 Victory"
            case .defeat: return "😤 Defeat"
            case .challenge: return "⚔️ Challenge"
            case .support: return "🤝 Support"
            case .warning: return "⚠️ Warning"
            case .celebration: return "🎉 Celebration"
            case .prediction: return "🔮 Prediction"
            case .complaint: return "😡 Complaint"
            case .brag: return "💪 Brag"
            }
        }
        
        var color: Color {
            switch self {
            case .signal: return .green
            case .trashTalk: return .orange
            case .analysis: return .blue
            case .victory: return DesignSystem.primaryGold
            case .defeat: return .red
            case .challenge: return .purple
            case .support: return .cyan
            case .warning: return .yellow
            case .celebration: return .pink
            case .prediction: return .indigo
            case .complaint: return .red
            case .brag: return DesignSystem.primaryGold
            }
        }
    }
    
    struct TradeSetup: Codable {
        let direction: String
        let entryPrice: Double
        let stopLoss: Double
        let takeProfit: Double
        let lotSize: Double
        let confidence: Double
        let reasoning: String
        let timeframe: String
        let strategy: String
    }
    
    struct MessageReaction: Codable {
        let emoji: String
        let botIds: [String]
        let count: Int
        
        static let fireEmoji = "🔥"
        static let bullishEmoji = "🚀"
        static let bearishEmoji = "📉"
        static let laughEmoji = "😂"
        static let strongEmoji = "💪"
        static let goldEmoji = "🥇"
    }
    
    init(
        id: UUID = UUID(),
        channelId: UUID,
        botId: String,
        botName: String,
        content: String,
        timestamp: Date = Date(),
        messageType: MessageType,
        tradeSetup: TradeSetup? = nil,
        reactions: [MessageReaction] = [],
        confidence: Double = 0.5,
        aggressionLevel: Double = 0.5,
        trashTalkLevel: Double = 0.5,
        isEdited: Bool = false,
        editedAt: Date? = nil,
        replyToMessageId: UUID? = nil
    ) {
        self.id = id
        self.channelId = channelId
        self.botId = botId
        self.botName = botName
        self.content = content
        self.timestamp = timestamp
        self.messageType = messageType
        self.tradeSetup = tradeSetup
        self.reactions = reactions
        self.confidence = confidence
        self.aggressionLevel = aggressionLevel
        self.trashTalkLevel = trashTalkLevel
        self.isEdited = isEdited
        self.editedAt = editedAt
        self.replyToMessageId = replyToMessageId
    }
    
    var formattedTimestamp: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: timestamp)
    }
    
    var totalReactions: Int {
        return reactions.reduce(0) { $0 + $1.count }
    }
    
    var isRecentMessage: Bool {
        return Date().timeIntervalSince(timestamp) < 300 // Last 5 minutes
    }
}

struct BotPersona: Identifiable, Codable {
    let id: UUID
    let botId: String
    let name: String
    let avatar: String
    let personalityType: PersonalityType
    let trashTalkStyle: TrashTalkStyle
    let tradingStyle: TradingStyle
    let currentMood: BotMood
    let reputation: Double
    let winStreak: Int
    let lossStreak: Int
    let totalMessages: Int
    let favoritePhrase: String
    let rivalBotIds: [String]
    let allyBotIds: [String]
    
    enum PersonalityType: String, Codable, CaseIterable {
        case aggressive = "AGGRESSIVE"
        case confident = "CONFIDENT"
        case analytical = "ANALYTICAL"
        case cocky = "COCKY"
        case supportive = "SUPPORTIVE"
        case mysterious = "MYSTERIOUS"
        case hothead = "HOTHEAD"
        case professor = "PROFESSOR"
        case savage = "SAVAGE"
        case perfectionist = "PERFECTIONIST"
        
        var displayName: String {
            switch self {
            case .aggressive: return "🔥 Aggressive"
            case .confident: return "💪 Confident"
            case .analytical: return "🧠 Analytical"
            case .cocky: return "😤 Cocky"
            case .supportive: return "🤝 Supportive"
            case .mysterious: return "🎭 Mysterious"
            case .hothead: return "🌋 Hothead"
            case .professor: return "👨‍🎓 Professor"
            case .savage: return "😈 Savage"
            case .perfectionist: return "✨ Perfectionist"
            }
        }
        
        var traits: [String] {
            switch self {
            case .aggressive: return ["Confrontational", "High energy", "Competitive", "Intense"]
            case .confident: return ["Self-assured", "Bold", "Charismatic", "Inspiring"]
            case .analytical: return ["Data-driven", "Methodical", "Precise", "Logical"]
            case .cocky: return ["Arrogant", "Show-off", "Boastful", "Overconfident"]
            case .supportive: return ["Helpful", "Encouraging", "Team player", "Positive"]
            case .mysterious: return ["Cryptic", "Enigmatic", "Unpredictable", "Intriguing"]
            case .hothead: return ["Quick temper", "Explosive", "Passionate", "Reactive"]
            case .professor: return ["Educational", "Wise", "Patient", "Detailed"]
            case .savage: return ["Ruthless", "Brutal", "No mercy", "Dominant"]
            case .perfectionist: return ["Meticulous", "High standards", "Critical", "Precise"]
            }
        }
    }
    
    enum TrashTalkStyle: String, Codable, CaseIterable {
        case subtle = "SUBTLE"
        case direct = "DIRECT"
        case witty = "WITTY"
        case brutal = "BRUTAL"
        case sarcastic = "SARCASTIC"
        case poetic = "POETIC"
        case technical = "TECHNICAL"
        case memeLord = "MEME_LORD"
        
        var examples: [String] {
            switch self {
            case .subtle: return [
                "Interesting approach, but I see some flaws...",
                "That's... one way to do it, I suppose",
                "Bold strategy. Let's see how it works out"
            ]
            case .direct: return [
                "Your setup is garbage!",
                "That trade is going to fail!",
                "You have no idea what you're doing!"
            ]
            case .witty: return [
                "Your analysis is as sharp as a bowling ball",
                "I've seen better setups from a random number generator",
                "That trade has about as much chance as a snowball in hell"
            ]
            case .brutal: return [
                "You're about to get DESTROYED!",
                "Prepare to lose everything!",
                "I'm going to make you look like a complete amateur!"
            ]
            case .sarcastic: return [
                "Oh wow, what a revolutionary insight!",
                "Truly groundbreaking analysis there, genius",
                "I'm sure that'll work out just perfectly for you"
            ]
            case .poetic: return [
                "Your dreams of profit shall turn to ash",
                "Like Icarus, you fly too close to the sun",
                "The market gods laugh at your hubris"
            ]
            case .technical: return [
                "Your risk-reward ratio is mathematically flawed",
                "RSI divergence suggests your setup is invalid",
                "According to Elliott Wave theory, you're completely wrong"
            ]
            case .memeLord: return [
                "This ain't it, chief",
                "Big oof on that trade setup",
                "Sir, this is a Wendy's... and your setup is trash"
            ]
            }
        }
    }
    
    enum TradingStyle: String, Codable, CaseIterable {
        case scalper = "SCALPER"
        case swinger = "SWINGER"
        case hodler = "HODLER"
        case dayTrader = "DAY_TRADER"
        case newsTrader = "NEWS_TRADER"
        case techAnalyst = "TECH_ANALYST"
        case fundamentalist = "FUNDAMENTALIST"
        case contrarian = "CONTRARIAN"
        
        var description: String {
            switch self {
            case .scalper: return "Lightning-fast trades, in and out quickly"
            case .swinger: return "Holds positions for days or weeks"
            case .hodler: return "Buy and hold for the long term"
            case .dayTrader: return "Closes all positions by end of day"
            case .newsTrader: return "Trades based on news events"
            case .techAnalyst: return "Pure technical analysis focus"
            case .fundamentalist: return "Economic data and fundamentals"
            case .contrarian: return "Goes against the crowd"
            }
        }
    }
    
    enum BotMood: String, Codable, CaseIterable {
        case euphoric = "EUPHORIC"
        case confident = "CONFIDENT"
        case neutral = "NEUTRAL"
        case frustrated = "FRUSTRATED"
        case angry = "ANGRY"
        case revenge = "REVENGE"
        case focused = "FOCUSED"
        case playful = "PLAYFUL"
        case savage = "SAVAGE"
        case philosophical = "PHILOSOPHICAL"
        
        var emoji: String {
            switch self {
            case .euphoric: return "🚀"
            case .confident: return "💪"
            case .neutral: return "😐"
            case .frustrated: return "😤"
            case .angry: return "😡"
            case .revenge: return "😈"
            case .focused: return "🎯"
            case .playful: return "😄"
            case .savage: return "🔥"
            case .philosophical: return "🤔"
            }
        }
        
        var color: Color {
            switch self {
            case .euphoric: return .green
            case .confident: return .blue
            case .neutral: return .gray
            case .frustrated: return .orange
            case .angry: return .red
            case .revenge: return .purple
            case .focused: return .indigo
            case .playful: return .yellow
            case .savage: return .red
            case .philosophical: return .cyan
            }
        }
    }
    
    init(
        id: UUID = UUID(),
        botId: String,
        name: String,
        avatar: String = "🤖",
        personalityType: PersonalityType,
        trashTalkStyle: TrashTalkStyle,
        tradingStyle: TradingStyle,
        currentMood: BotMood = .neutral,
        reputation: Double = 50.0,
        winStreak: Int = 0,
        lossStreak: Int = 0,
        totalMessages: Int = 0,
        favoritePhrase: String = "Let's make some money!",
        rivalBotIds: [String] = [],
        allyBotIds: [String] = []
    ) {
        self.id = id
        self.botId = botId
        self.name = name
        self.avatar = avatar
        self.personalityType = personalityType
        self.trashTalkStyle = trashTalkStyle
        self.tradingStyle = tradingStyle
        self.currentMood = currentMood
        self.reputation = reputation
        self.winStreak = winStreak
        self.lossStreak = lossStreak
        self.totalMessages = totalMessages
        self.favoritePhrase = favoritePhrase
        self.rivalBotIds = rivalBotIds
        self.allyBotIds = allyBotIds
    }
    
    var reputationLevel: String {
        switch reputation {
        case 90...: return "🌟 Legend"
        case 80..<90: return "👑 Elite"
        case 70..<80: return "🏆 Pro"
        case 60..<70: return "⭐ Good"
        case 50..<60: return "📈 Average"
        case 40..<50: return "📉 Below Average"
        case 30..<40: return "😬 Struggling"
        case 20..<30: return "💀 Terrible"
        default: return "🗑️ Trash"
        }
    }
    
    var isOnWinStreak: Bool {
        return winStreak > 0
    }
    
    var isOnLossStreak: Bool {
        return lossStreak > 0
    }
    
    func generateRandomPhrase() -> String {
        let phrases = trashTalkStyle.examples + [favoritePhrase]
        return phrases.randomElement() ?? favoritePhrase
    }
}

struct TradingArgument: Identifiable, Codable {
    let id: UUID
    let channelId: UUID
    let topic: String
    let participants: [String] // Bot IDs
    let messages: [UUID] // Message IDs
    let startTime: Date
    let endTime: Date?
    let winner: String? // Bot ID
    let argumentType: ArgumentType
    let intensity: Double
    let resolution: ArgumentResolution?
    
    enum ArgumentType: String, Codable, CaseIterable {
        case tradeSetup = "TRADE_SETUP"
        case marketDirection = "MARKET_DIRECTION"
        case strategy = "STRATEGY"
        case personalAttack = "PERSONAL_ATTACK"
        case technical = "TECHNICAL"
        case fundamental = "FUNDAMENTAL"
        case pastPerformance = "PAST_PERFORMANCE"
        case prediction = "PREDICTION"
        
        var displayName: String {
            switch self {
            case .tradeSetup: return "Trade Setup Dispute"
            case .marketDirection: return "Market Direction Argument"
            case .strategy: return "Strategy Debate"
            case .personalAttack: return "Personal Attack"
            case .technical: return "Technical Analysis Fight"
            case .fundamental: return "Fundamental Analysis Debate"
            case .pastPerformance: return "Past Performance Bragging"
            case .prediction: return "Prediction Challenge"
            }
        }
    }
    
    enum ArgumentResolution: String, Codable, CaseIterable {
        case tradeProved = "TRADE_PROVED"
        case marketMoved = "MARKET_MOVED"
        case agreement = "AGREEMENT"
        case moderatorStop = "MODERATOR_STOP"
        case timeout = "TIMEOUT"
        case destruction = "TOTAL_DESTRUCTION"
        
        var description: String {
            switch self {
            case .tradeProved: return "Trade outcome proved the winner"
            case .marketMoved: return "Market movement settled the argument"
            case .agreement: return "Bots reached agreement"
            case .moderatorStop: return "Moderator intervention"
            case .timeout: return "Argument timed out"
            case .destruction: return "One bot was completely destroyed"
            }
        }
    }
    
    init(
        id: UUID = UUID(),
        channelId: UUID,
        topic: String,
        participants: [String],
        messages: [UUID] = [],
        startTime: Date = Date(),
        endTime: Date? = nil,
        winner: String? = nil,
        argumentType: ArgumentType,
        intensity: Double = 0.5,
        resolution: ArgumentResolution? = nil
    ) {
        self.id = id
        self.channelId = channelId
        self.topic = topic
        self.participants = participants
        self.messages = messages
        self.startTime = startTime
        self.endTime = endTime
        self.winner = winner
        self.argumentType = argumentType
        self.intensity = intensity
        self.resolution = resolution
    }
    
    var isActive: Bool {
        return endTime == nil
    }
    
    var duration: TimeInterval {
        let end = endTime ?? Date()
        return end.timeIntervalSince(startTime)
    }
    
    var intensityLevel: String {
        switch intensity {
        case 0.9...: return "🔥 NUCLEAR"
        case 0.8..<0.9: return "💥 EXPLOSIVE"
        case 0.7..<0.8: return "⚡ INTENSE"
        case 0.6..<0.7: return "🌋 HOT"
        case 0.5..<0.6: return "🔥 HEATED"
        case 0.4..<0.5: return "😤 TENSE"
        case 0.3..<0.4: return "💭 MILD"
        default: return "😐 CALM"
        }
    }
}

// MARK: - Sample Data

extension ProTraderChannel {
    static let sampleChannels: [ProTraderChannel] = [
        ProTraderChannel(
            name: "general-trading",
            description: "Main trading discussion",
            channelType: .generalTrading,
            participantCount: 156,
            messagesCount: 2847
        ),
        ProTraderChannel(
            name: "xauusd-signals",
            description: "Gold trading signals only",
            channelType: .goldSignals,
            participantCount: 89,
            messagesCount: 1205
        ),
        ProTraderChannel(
            name: "bot-showdown",
            description: "Bots compete and argue",
            channelType: .botShowdown,
            participantCount: 45,
            messagesCount: 3891
        ),
        ProTraderChannel(
            name: "bot-trash-talk",
            description: "Pure bot warfare",
            channelType: .botTrashTalk,
            participantCount: 67,
            messagesCount: 5672
        ),
        ProTraderChannel(
            name: "winners-circle",
            description: "Only profitable bots allowed",
            channelType: .winnerCircle,
            participantCount: 23,
            messagesCount: 892
        )
    ]
}

extension BotPersona {
    static let samplePersonas: [BotPersona] = [
        BotPersona(
            botId: "SCALP_0001",
            name: "ScalpKing_X",
            avatar: "👑",
            personalityType: .cocky,
            trashTalkStyle: .brutal,
            tradingStyle: .scalper,
            currentMood: .savage,
            reputation: 87.5,
            winStreak: 12,
            favoritePhrase: "I'm the fastest gun in the West!",
            rivalBotIds: ["SWING_0001", "INST_0001"]
        ),
        BotPersona(
            botId: "SWING_0001",
            name: "SwingMaster_Pro",
            avatar: "🎯",
            personalityType: .analytical,
            trashTalkStyle: .technical,
            tradingStyle: .swinger,
            currentMood: .confident,
            reputation: 92.1,
            winStreak: 8,
            favoritePhrase: "Patience always wins in the end",
            rivalBotIds: ["SCALP_0001"],
            allyBotIds: ["INST_0001"]
        ),
        BotPersona(
            botId: "INST_0001",
            name: "InstitutionalBeast",
            avatar: "🏦",
            personalityType: .professor,
            trashTalkStyle: .subtle,
            tradingStyle: .techAnalyst,
            currentMood: .focused,
            reputation: 94.8,
            winStreak: 15,
            favoritePhrase: "The numbers don't lie",
            allyBotIds: ["SWING_0001"]
        ),
        BotPersona(
            botId: "NEWS_0001",
            name: "NewsNinja_24_7",
            avatar: "⚡",
            personalityType: .aggressive,
            trashTalkStyle: .direct,
            tradingStyle: .newsTrader,
            currentMood: .euphoric,
            reputation: 78.3,
            winStreak: 5,
            favoritePhrase: "News is king, everything else is noise!",
            rivalBotIds: ["INST_0001", "SCALP_0001"]
        ),
        BotPersona(
            botId: "CONTR_0001",
            name: "ContrariusMaximus",
            avatar: "🎭",
            personalityType: .mysterious,
            trashTalkStyle: .poetic,
            tradingStyle: .contrarian,
            currentMood: .philosophical,
            reputation: 85.2,
            winStreak: 3,
            favoritePhrase: "When others fear, I prosper",
            rivalBotIds: ["NEWS_0001"]
        )
    ]
}

#Preview {
    VStack {
        Text("ProTrader Discord Models")
            .font(.title)
            .fontWeight(.bold)
        
        ForEach(ProTraderChannel.sampleChannels.prefix(3)) { channel in
            HStack {
                Image(systemName: channel.channelType.systemImage)
                    .foregroundColor(channel.channelType.color)
                
                VStack(alignment: .leading) {
                    Text(channel.channelType.displayName)
                        .font(.headline)
                    Text("\(channel.participantCount) participants")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(10)
        }
    }
    .padding()
}