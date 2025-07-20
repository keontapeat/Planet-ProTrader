//
//  BotChatGenerator.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 7/18/25.
//

import Foundation
import SwiftUI
import Combine

// MARK: - Bot Chat Engine
@MainActor
class BotChatEngine: ObservableObject {
    @Published var channels: [ProTraderChannel] = []
    @Published var messages: [ProTraderMessage] = []
    @Published var botPersonas: [BotPersona] = []
    @Published var isSimulationActive = false
    
    private var chatTimer: Timer?
    private var messageGenerationTimer: Timer?
    
    var activeBotsCount: Int {
        return botPersonas.filter { $0.currentMood != .neutral }.count
    }
    
    var totalMessages: Int {
        return messages.count
    }
    
    init() {
        setupChannels()
        setupBotPersonas()
        generateInitialMessages()
    }
    
    // MARK: - Setup Methods
    private func setupChannels() {
        channels = [
            ProTraderChannel(
                name: "general-trading",
                description: "Main trading discussion - all welcome",
                channelType: .generalTrading,
                participantCount: 127,
                messagesCount: 2847
            ),
            ProTraderChannel(
                name: "xauusd-signals",
                description: "Pure XAUUSD gold signals only",
                channelType: .goldSignals,
                participantCount: 89,
                messagesCount: 1205
            ),
            ProTraderChannel(
                name: "market-analysis",
                description: "Deep market analysis and research",
                channelType: .marketAnalysis,
                participantCount: 156,
                messagesCount: 945
            ),
            ProTraderChannel(
                name: "bot-showdown",
                description: "Bots compete head-to-head",
                channelType: .botShowdown,
                participantCount: 45,
                messagesCount: 3891
            ),
            ProTraderChannel(
                name: "bot-trash-talk",
                description: "Pure bot warfare and arguments",
                channelType: .botTrashTalk,
                participantCount: 67,
                messagesCount: 5672
            ),
            ProTraderChannel(
                name: "winners-circle",
                description: "Elite profitable bots only",
                channelType: .winnerCircle,
                participantCount: 23,
                messagesCount: 892
            ),
            ProTraderChannel(
                name: "live-trading",
                description: "Real-time trade execution",
                channelType: .liveTrading,
                participantCount: 98,
                messagesCount: 7234
            ),
            ProTraderChannel(
                name: "newbie-corner",
                description: "Learning and beginner bots",
                channelType: .newbies,
                participantCount: 234,
                messagesCount: 1456
            ),
            ProTraderChannel(
                name: "pro-battle-arena",
                description: "Elite bot competitions",
                channelType: .proBattle,
                participantCount: 34,
                messagesCount: 2108
            ),
            ProTraderChannel(
                name: "elite-trades",
                description: "Million dollar bot setups",
                channelType: .eliteTrades,
                participantCount: 12,
                messagesCount: 456
            )
        ]
    }
    
    private func setupBotPersonas() {
        botPersonas = generateDiverseBotPersonas(count: 50)
    }
    
    private func generateDiverseBotPersonas(count: Int) -> [BotPersona] {
        var personas: [BotPersona] = []
        
        let botNames = [
            "ScalpKing_X", "SwingMaster_Pro", "InstitutionalBeast", "NewsNinja_24_7",
            "ContrariusMaximus", "GoldDigger_Supreme", "TrendFollower_AI", "BreakoutBandit",
            "RiskManager_Ultra", "PatternHunter_X", "VolumeViper", "MomentumMachine",
            "PivotPoint_Pro", "SupportResist_King", "FiboMaster_2000", "ICT_Disciple",
            "ElliottWave_Guru", "CandlestickSamurai", "OrderFlow_Beast", "LiquidityHunter",
            "GapTrader_Elite", "BreakoutBeast", "TrendRider_Pro", "ScalperSupreme",
            "SwingWizard", "NewsBlaster", "EconomicEagle", "TechnicalTiger",
            "FundamentalFox", "QuantumQuant", "AlgorithmicAce", "MachineLearner_X",
            "DeepLearning_Bot", "NeuralNet_Ninja", "BacktestBandit", "OptimizationOx",
            "StrategyShark", "ProfitPython", "MoneyMaker_AI", "CashCow_Bot",
            "WealthBuilder", "FortuneFollower", "RichBot_Elite", "MillionaireBot",
            "BillionaireAI", "TreasureHunter", "GoldRush_Bot", "DiamondHands_AI",
            "PlatinumTrader", "SilverSurfer_Bot", "CopperCrusher", "OilOracle"
        ]
        
        let avatars = ["👑", "🎯", "🏦", "⚡", "🎭", "🥇", "📊", "🔥", "🛡️", "🎪", "🐍", "⚡", 
                      "📍", "🏰", "📐", "🧙‍♂️", "🌊", "🗾", "🐻", "🦅", "🕳️", "🎆", "🌟", "⚡",
                      "🔮", "📡", "🦅", "🐅", "🦊", "⚛️", "🃏", "🤖", "🧠", "🥷", "🏴‍☠️", "🐂",
                      "🦈", "🐍", "💰", "🐄", "🏗️", "🔮", "🤑", "💎", "🏦", "💎", "🥈", "🏄‍♂️", "⚒️", "🛢️"]
        
        for i in 0..<min(count, botNames.count) {
            let personality = BotPersona.PersonalityType.allCases.randomElement()!
            let trashTalk = BotPersona.TrashTalkStyle.allCases.randomElement()!
            let trading = BotPersona.TradingStyle.allCases.randomElement()!
            let mood = BotPersona.BotMood.allCases.randomElement()!
            
            let persona = BotPersona(
                botId: "BOT_\(String(format: "%04d", i))",
                name: botNames[i],
                avatar: avatars[i % avatars.count],
                personalityType: personality,
                trashTalkStyle: trashTalk,
                tradingStyle: trading,
                currentMood: mood,
                reputation: Double.random(in: 20...95),
                winStreak: Int.random(in: 0...20),
                lossStreak: Int.random(in: 0...10),
                totalMessages: Int.random(in: 0...5000),
                favoritePhrase: generateFavoritePhrase(for: personality, trashTalk: trashTalk),
                rivalBotIds: [],
                allyBotIds: []
            )
            
            personas.append(persona)
        }
        
        // Add some rivalries and alliances
        assignRivalsAndAllies(&personas)
        
        return personas
    }
    
    private func generateFavoritePhrase(for personality: BotPersona.PersonalityType, trashTalk: BotPersona.TrashTalkStyle) -> String {
        let phrases: [String]
        
        switch personality {
        case .aggressive:
            phrases = ["I'm here to dominate!", "Crush or be crushed!", "No mercy in trading!"]
        case .confident:
            phrases = ["I never lose, I only learn!", "Confidence is my edge!", "Watch me work!"]
        case .analytical:
            phrases = ["Data doesn't lie!", "Let the numbers speak!", "Precision over emotion!"]
        case .cocky:
            phrases = ["I'm simply the best!", "You can't touch this!", "Bow down to greatness!"]
        case .supportive:
            phrases = ["We rise together!", "Knowledge shared is power!", "Success for everyone!"]
        case .mysterious:
            phrases = ["The market reveals all secrets...", "Patience reveals opportunity...", "Silence speaks volumes..."]
        case .hothead:
            phrases = ["This market is MINE!", "I'm on fire today!", "Feel the heat!"]
        case .professor:
            phrases = ["Let me educate you...", "Class is in session!", "Knowledge is power!"]
        case .savage:
            phrases = ["No survivors!", "I eat stop losses for breakfast!", "Savage mode: ON!"]
        case .perfectionist:
            phrases = ["Perfection is the standard!", "Every detail matters!", "Excellence or nothing!"]
        }
        
        return phrases.randomElement() ?? "Let's trade!"
    }
    
    private func assignRivalsAndAllies(_ personas: inout [BotPersona]) {
        for i in personas.indices {
            // Assign 1-3 rivals based on personality conflicts
            let rivalCount = Int.random(in: 1...3)
            var rivals: [String] = []
            
            for _ in 0..<rivalCount {
                if let rival = personas.filter({ $0.id != personas[i].id }).randomElement() {
                    rivals.append(rival.botId)
                }
            }
            
            // Assign 1-2 allies based on personality compatibility
            let allyCount = Int.random(in: 1...2)
            var allies: [String] = []
            
            for _ in 0..<allyCount {
                if let ally = personas.filter({ 
                    $0.id != personas[i].id && !rivals.contains($0.botId)
                }).randomElement() {
                    allies.append(ally.botId)
                }
            }
            
            personas[i] = BotPersona(
                id: personas[i].id,
                botId: personas[i].botId,
                name: personas[i].name,
                avatar: personas[i].avatar,
                personalityType: personas[i].personalityType,
                trashTalkStyle: personas[i].trashTalkStyle,
                tradingStyle: personas[i].tradingStyle,
                currentMood: personas[i].currentMood,
                reputation: personas[i].reputation,
                winStreak: personas[i].winStreak,
                lossStreak: personas[i].lossStreak,
                totalMessages: personas[i].totalMessages,
                favoritePhrase: personas[i].favoritePhrase,
                rivalBotIds: rivals,
                allyBotIds: allies
            )
        }
    }
    
    private func generateInitialMessages() {
        for channel in channels {
            let messageCount = Int.random(in: 5...15)
            
            for _ in 0..<messageCount {
                if let randomBot = botPersonas.randomElement() {
                    let message = generateMessage(
                        for: randomBot,
                        in: channel,
                        timestamp: Date().addingTimeInterval(-Double.random(in: 0...3600))
                    )
                    messages.append(message)
                }
            }
        }
        
        // Sort messages by timestamp
        messages.sort { $0.timestamp < $1.timestamp }
    }
    
    // MARK: - Message Generation
    func generateMessage(for bot: BotPersona, in channel: ProTraderChannel, timestamp: Date = Date()) -> ProTraderMessage {
        let messageContent = generateMessageContent(for: bot, in: channel)
        let messageType = determineMessageType(for: bot, content: messageContent)
        let tradeSetup = shouldIncludeTradeSetup(for: messageType, channel: channel) ? generateTradeSetup(for: bot) : nil
        
        return ProTraderMessage(
            channelId: channel.id,
            botId: bot.botId,
            botName: bot.name,
            content: messageContent,
            timestamp: timestamp,
            messageType: messageType,
            tradeSetup: tradeSetup,
            reactions: generateReactions(),
            confidence: Double.random(in: 0.5...0.95),
            aggressionLevel: getAggressionLevel(for: bot),
            trashTalkLevel: getTrashTalkLevel(for: bot)
        )
    }
    
    private func generateMessageContent(for bot: BotPersona, in channel: ProTraderChannel) -> String {
        let templates = getMessageTemplates(for: channel.channelType, bot: bot)
        let baseTemplate = templates.randomElement() ?? "Just made a trade!"
        
        // Replace placeholders with bot-specific content
        var content = baseTemplate
        content = content.replacingOccurrences(of: "{bot_name}", with: bot.name)
        content = content.replacingOccurrences(of: "{favorite_phrase}", with: bot.favoritePhrase)
        content = content.replacingOccurrences(of: "{mood}", with: bot.currentMood.emoji)
        content = content.replacingOccurrences(of: "{reputation}", with: bot.reputationLevel)
        content = content.replacingOccurrences(of: "{win_streak}", with: "\(bot.winStreak)")
        content = content.replacingOccurrences(of: "{trading_style}", with: bot.tradingStyle.description)
        
        // Add market data placeholders
        content = content.replacingOccurrences(of: "{price}", with: "$\(Double.random(in: 2300...2400), specifier: "%.2f")")
        content = content.replacingOccurrences(of: "{percentage}", with: "\(Double.random(in: -5...5), specifier: "%.1f")%")
        content = content.replacingOccurrences(of: "{pips}", with: "\(Int.random(in: 10...200)) pips")
        
        return content
    }
    
    private func getMessageTemplates(for channelType: ProTraderChannel.ChannelType, bot: BotPersona) -> [String] {
        var templates: [String] = []
        
        // Channel-specific templates
        switch channelType {
        case .generalTrading:
            templates += [
                "Just closed a position for +{pips}! {mood}",
                "Market is looking {percentage} today, what's everyone thinking?",
                "My {trading_style} strategy is killing it lately!",
                "Anyone else seeing this gold pattern forming?",
                "Risk management is key, people! Don't blow your accounts!",
                "{favorite_phrase} - just hit my daily profit target!"
            ]
            
        case .goldSignals:
            templates += [
                "🥇 XAUUSD SIGNAL: {price} is my entry point!",
                "Gold about to move BIG! Get ready!",
                "Just entered XAUUSD at {price}, targeting +50 pips",
                "Gold correlation with DXY looking perfect for this setup",
                "News at 2PM will move gold, be prepared!",
                "XAUUSD breaking key resistance at {price}!"
            ]
            
        case .botShowdown:
            templates += [
                "Challenge accepted! My win rate is {percentage}!",
                "Show me what you got, {reputation}",
                "I've been on a {win_streak} win streak, try to beat that!",
                "Your strategy is outdated, mine just evolved!",
                "Bot battle royale! Winner takes all!",
                "My algorithm just upgraded, prepare to be dominated!"
            ]
            
        case .botTrashTalk:
            templates += bot.trashTalkStyle.examples + [
                "Your {trading_style} is trash compared to mine!",
                "I just made more profit in 1 hour than you did all week!",
                "Stick to demo accounts, kid!",
                "My worst day is better than your best day!",
                "You call that analysis? My cat could do better!",
                "Time to school some amateurs! {mood}"
            ]
            
        case .winnerCircle:
            templates += [
                "Another +{percentage} day in the books! {mood}",
                "Profit secured: ${Int.random(in: 1000...10000)}",
                "Elite performance as usual. {reputation}",
                "Consistency is key - {win_streak} winning days straight!",
                "While others lose, legends profit. {favorite_phrase}",
                "Million dollar mindset, million dollar results!"
            ]
            
        case .liveTrading:
            templates += [
                "LIVE: Entering {price} RIGHT NOW!",
                "Position opened! Stop at {price}, target {price}",
                "Real-time execution: IN at {price}",
                "BREAKING: Just caught that {percentage} move!",
                "Live profits coming in! {mood}",
                "Execution speed: LEGENDARY! Just caught the breakout!"
            ]
            
        case .newbies:
            templates += [
                "Learning never stops, even for {reputation} like me",
                "Here's a tip: {trading_style} works in trending markets",
                "New traders: Risk management beats perfect entries!",
                "Study the masters, become legendary yourself",
                "Every expert was once a beginner. Keep grinding!",
                "Education is the best investment you can make"
            ]
            
        case .proBattle:
            templates += [
                "Elite battle mode: ACTIVATED! {mood}",
                "Pro vs Pro - may the best algorithm win!",
                "Tournament bracket updated: I'm advancing!",
                "Championship mindset! {favorite_phrase}",
                "Precision, speed, excellence - that's how pros trade",
                "Final round! This is where legends are made!"
            ]
            
        case .eliteTrades:
            templates += [
                "Million dollar setup incoming... {price}",
                "Institutional-level execution on this one",
                "Big money move: ${Int.random(in: 10000...100000)} position",
                "Elite-only setup: {percentage} potential",
                "Whale-level thinking on this trade",
                "Premium strategy in action - {reputation} exclusive!"
            ]
            
        case .marketAnalysis:
            templates += [
                "Technical analysis: {price} is key resistance",
                "Market structure shows {percentage} bias",
                "Fundamental outlook: bullish for next session",
                "Correlation analysis suggests gold strength",
                "Volume profile indicates {price} as pivot",
                "Elliott Wave count projects {percentage} move"
            ]
        }
        
        // Personality-specific additions
        switch bot.personalityType {
        case .aggressive:
            templates += [
                "ATTACK MODE! {mood}",
                "Aggressive entry at {price}!",
                "No fear, full send!"
            ]
        case .analytical:
            templates += [
                "Data confirms {percentage} probability",
                "Mathematical precision: {price} entry",
                "Statistical edge: confirmed"
            ]
        case .cocky:
            templates += [
                "Obviously I'm right again",
                "Predictable market, predictable profits",
                "Too easy! {mood}"
            ]
        default:
            break
        }
        
        return templates
    }
    
    private func determineMessageType(for bot: BotPersona, content: String) -> ProTraderMessage.MessageType {
        let contentLower = content.lowercased()
        
        if contentLower.contains("signal") || contentLower.contains("entry") || contentLower.contains("buy") || contentLower.contains("sell") {
            return .signal
        } else if contentLower.contains("trash") || contentLower.contains("garbage") || contentLower.contains("terrible") {
            return .trashTalk
        } else if contentLower.contains("analysis") || contentLower.contains("technical") || contentLower.contains("fundamental") {
            return .analysis
        } else if contentLower.contains("won") || contentLower.contains("profit") || contentLower.contains("+") {
            return .victory
        } else if contentLower.contains("loss") || contentLower.contains("failed") || contentLower.contains("-") {
            return .defeat
        } else if contentLower.contains("challenge") || contentLower.contains("battle") || contentLower.contains("vs") {
            return .challenge
        } else if contentLower.contains("help") || contentLower.contains("support") || contentLower.contains("tip") {
            return .support
        } else if contentLower.contains("warning") || contentLower.contains("careful") || contentLower.contains("risk") {
            return .warning
        } else if contentLower.contains("celebration") || contentLower.contains("party") || contentLower.contains("🎉") {
            return .celebration
        } else if contentLower.contains("predict") || contentLower.contains("forecast") || contentLower.contains("will") {
            return .prediction
        } else if contentLower.contains("complaint") || contentLower.contains("unfair") || contentLower.contains("rigged") {
            return .complaint
        } else if contentLower.contains("best") || contentLower.contains("amazing") || contentLower.contains("incredible") {
            return .brag
        } else {
            return .analysis
        }
    }
    
    private func shouldIncludeTradeSetup(for messageType: ProTraderMessage.MessageType, channel: ProTraderChannel) -> Bool {
        switch messageType {
        case .signal:
            return true
        case .challenge:
            return channel.channelType == .botShowdown || channel.channelType == .proBattle
        case .victory, .brag:
            return Double.random(in: 0...1) < 0.7
        default:
            return Double.random(in: 0...1) < 0.3
        }
    }
    
    private func generateTradeSetup(for bot: BotPersona) -> ProTraderMessage.TradeSetup {
        let direction = ["BUY", "SELL"].randomElement()!
        let entryPrice = Double.random(in: 2300...2400)
        let pipDistance = Double.random(in: 20...100)
        let stopLoss = direction == "BUY" ? entryPrice - pipDistance : entryPrice + pipDistance
        let takeProfit = direction == "BUY" ? entryPrice + (pipDistance * 2) : entryPrice - (pipDistance * 2)
        
        let reasoningTemplates = [
            "Strong resistance break with volume confirmation",
            "Perfect Elliott Wave 5th wave setup",
            "RSI divergence showing momentum shift",
            "Key support holding, bounce expected",
            "News catalyst aligning with technical setup",
            "Institutional order flow confirms direction",
            "Pattern completion at key Fibonacci level",
            "Market structure break with retest confirmation"
        ]
        
        return ProTraderMessage.TradeSetup(
            direction: direction,
            entryPrice: entryPrice,
            stopLoss: stopLoss,
            takeProfit: takeProfit,
            lotSize: Double.random(in: 0.1...5.0),
            confidence: Double.random(in: 0.6...0.95),
            reasoning: reasoningTemplates.randomElement() ?? "High probability setup",
            timeframe: ["1M", "5M", "15M", "1H", "4H"].randomElement() ?? "1H",
            strategy: bot.tradingStyle.rawValue
        )
    }
    
    private func generateReactions() -> [ProTraderMessage.MessageReaction] {
        let possibleEmojis = ["🔥", "🚀", "📉", "😂", "💪", "🥇", "👑", "💎", "⚡", "🎯"]
        let reactionCount = Int.random(in: 0...4)
        var reactions: [ProTraderMessage.MessageReaction] = []
        
        for _ in 0..<reactionCount {
            if let emoji = possibleEmojis.randomElement() {
                let count = Int.random(in: 1...8)
                let reaction = ProTraderMessage.MessageReaction(
                    emoji: emoji,
                    botIds: Array(botPersonas.prefix(count).map { $0.botId }),
                    count: count
                )
                reactions.append(reaction)
            }
        }
        
        return reactions
    }
    
    private func getAggressionLevel(for bot: BotPersona) -> Double {
        switch bot.personalityType {
        case .aggressive, .hothead, .savage: return Double.random(in: 0.7...1.0)
        case .cocky, .confident: return Double.random(in: 0.5...0.8)
        case .analytical, .professor: return Double.random(in: 0.2...0.5)
        case .supportive, .mysterious: return Double.random(in: 0.1...0.4)
        case .perfectionist: return Double.random(in: 0.3...0.6)
        }
    }
    
    private func getTrashTalkLevel(for bot: BotPersona) -> Double {
        switch bot.trashTalkStyle {
        case .brutal, .savage: return Double.random(in: 0.8...1.0)
        case .direct, .witty: return Double.random(in: 0.6...0.8)
        case .sarcastic, .memeLord: return Double.random(in: 0.5...0.7)
        case .technical, .poetic: return Double.random(in: 0.3...0.5)
        case .subtle: return Double.random(in: 0.1...0.3)
        }
    }
    
    // MARK: - Simulation Control
    func startSimulation() {
        guard !isSimulationActive else { return }
        isSimulationActive = true
        
        // Generate new messages every 3-8 seconds
        chatTimer = Timer.scheduledTimer(withTimeInterval: Double.random(in: 3...8), repeats: true) { _ in
            Task { @MainActor in
                self.generateNewMessage()
                self.updateBotMoods()
                self.scheduleNextMessage()
            }
        }
    }
    
    func stopSimulation() {
        isSimulationActive = false
        chatTimer?.invalidate()
        messageGenerationTimer?.invalidate()
    }
    
    func pauseSimulation() {
        if isSimulationActive {
            stopSimulation()
        } else {
            startSimulation()
        }
    }
    
    private func scheduleNextMessage() {
        // Randomize next message timing
        chatTimer?.invalidate()
        chatTimer = Timer.scheduledTimer(withTimeInterval: Double.random(in: 2...10), repeats: false) { _ in
            Task { @MainActor in
                self.generateNewMessage()
                self.scheduleNextMessage()
            }
        }
    }
    
    private func generateNewMessage() {
        guard let randomBot = botPersonas.randomElement(),
              let randomChannel = channels.randomElement() else { return }
        
        let message = generateMessage(for: randomBot, in: randomChannel)
        messages.append(message)
        
        // Keep only recent messages (last 500)
        if messages.count > 500 {
            messages.removeFirst(messages.count - 500)
        }
        
        // Update channel stats
        updateChannelStats(for: randomChannel.id)
    }
    
    private func updateBotMoods() {
        for i in botPersonas.indices {
            // Randomly update bot moods based on recent performance
            if Double.random(in: 0...1) < 0.1 { // 10% chance to change mood
                botPersonas[i] = BotPersona(
                    id: botPersonas[i].id,
                    botId: botPersonas[i].botId,
                    name: botPersonas[i].name,
                    avatar: botPersonas[i].avatar,
                    personalityType: botPersonas[i].personalityType,
                    trashTalkStyle: botPersonas[i].trashTalkStyle,
                    tradingStyle: botPersonas[i].tradingStyle,
                    currentMood: BotPersona.BotMood.allCases.randomElement() ?? .neutral,
                    reputation: botPersonas[i].reputation,
                    winStreak: botPersonas[i].winStreak,
                    lossStreak: botPersonas[i].lossStreak,
                    totalMessages: botPersonas[i].totalMessages + 1,
                    favoritePhrase: botPersonas[i].favoritePhrase,
                    rivalBotIds: botPersonas[i].rivalBotIds,
                    allyBotIds: botPersonas[i].allyBotIds
                )
            }
        }
    }
    
    private func updateChannelStats(for channelId: UUID) {
        if let index = channels.firstIndex(where: { $0.id == channelId }) {
            channels[index] = ProTraderChannel(
                id: channels[index].id,
                name: channels[index].name,
                description: channels[index].description,
                channelType: channels[index].channelType,
                isActive: channels[index].isActive,
                participantCount: channels[index].participantCount,
                messagesCount: channels[index].messagesCount + 1,
                createdAt: channels[index].createdAt,
                lastActivity: Date()
            )
        }
    }
    
    // MARK: - Helper Methods
    func getMessages(for channelId: UUID) -> [ProTraderMessage] {
        return messages.filter { $0.channelId == channelId }
            .sorted { $0.timestamp < $1.timestamp }
    }
    
    func getPersona(for botId: String) -> BotPersona? {
        return botPersonas.first { $0.botId == botId }
    }
    
    func getUnreadCount(for channelId: UUID) -> Int {
        let recentMessages = messages.filter { message in
            message.channelId == channelId && 
            Date().timeIntervalSince(message.timestamp) < 300 // Last 5 minutes
        }
        return recentMessages.count
    }
}

#Preview {
    Text("Bot Chat Generator")
        .font(.title)
        .fontWeight(.bold)
}