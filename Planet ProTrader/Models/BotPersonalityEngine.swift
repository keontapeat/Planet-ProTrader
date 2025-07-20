//
//  BotPersonalityEngine.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 7/18/25.
//

import SwiftUI
import Combine

// MARK: - Helper Classes

class ScreenshotLearningEngine {
    func processScreenshot(_ event: LearningEvent) {
        // Process screenshot learning data
        print("Processing screenshot: \(event.id)")
    }
}

class TranscriptLearningEngine {
    func processTranscript(_ event: LearningEvent) {
        // Process transcript learning data
        print("Processing transcript: \(event.id)")
    }
}

class TradeReplayEngine {
    // Trade replay functionality
}

struct ScreenshotMetadata {
    let timeframe: String
    let symbol: String
    let timestamp: Date
    let price: Double
}

struct TranscriptMetadata {
    let duration: TimeInterval
    let participantCount: Int
    let topics: [String]
    let timestamp: Date
}

// MARK: - Advanced Bot Personality and Learning System

@MainActor
class BotPersonalityEngine: ObservableObject {
    
    // MARK: - Core Bot Management
    
    @Published var activeBots: [AdvancedBot] = []
    @Published var botLearningQueue: [LearningEvent] = []
    @Published var globalBotStats: GlobalBotStats = GlobalBotStats()
    @Published var botGeneration: Int = 1
    
    // MARK: - Learning Systems
    
    @Published var screenshotLearningEngine: ScreenshotLearningEngine
    @Published var transcriptLearningEngine: TranscriptLearningEngine
    @Published var tradeReplayEngine: TradeReplayEngine
    
    // MARK: - Bot Communication
    
    @Published var botChatMessages: [BotChatMessage] = []
    @Published var activeBotDiscussions: [BotDiscussion] = []
    @Published var consensusSignals: [ConsensusSignal] = []
    
    private let markDouglasEngine: PlanetMarkDouglasEngine
    private var learningTimer: Timer?
    
    init(markDouglasEngine: PlanetMarkDouglasEngine) {
        self.markDouglasEngine = markDouglasEngine
        self.screenshotLearningEngine = ScreenshotLearningEngine()
        self.transcriptLearningEngine = TranscriptLearningEngine()
        self.tradeReplayEngine = TradeReplayEngine()
        
        initializeBotArmy()
        startContinuousLearning()
    }
    
    // MARK: - Bot Army Initialization
    
    private func initializeBotArmy() {
        activeBots = []
        
        // Create specialized bot teams
        createScalpingBots(count: 1000)
        createSwingTradingBots(count: 800)
        createInstitutionalBots(count: 600)
        createContrarianBots(count: 400)
        createNewsBots(count: 300)
        createSentimentBots(count: 250)
        createPatternBots(count: 350)
        createRiskManagementBots(count: 200)
        createPsychologyBots(count: 100)
        
        updateGlobalStats()
        startBotCommunication()
    }
    
    private func createScalpingBots(count: Int) {
        for i in 0..<count {
            let bot = AdvancedBot(
                id: "SCALP_\(String(format: "%04d", i))",
                name: "Scalp Master #\(i)",
                personality: createScalpingPersonality(),
                specialization: .scalping,
                learningCapabilities: [.priceAction, .volumeAnalysis, .microstructure],
                tradingTimeframes: [.oneMinute, .fiveMinute],
                maxPositions: 3,
                riskPerTrade: 0.5,
                averageHoldTime: 120, // 2 minutes
                winRateTarget: 0.68
            )
            activeBots.append(bot)
        }
    }
    
    private func createSwingTradingBots(count: Int) {
        for i in 0..<count {
            let bot = AdvancedBot(
                id: "SWING_\(String(format: "%04d", i))",
                name: "Swing Trader #\(i)",
                personality: createSwingPersonality(),
                specialization: .swing,
                learningCapabilities: [.trendAnalysis, .supportResistance, .fundamentals],
                tradingTimeframes: [.fourHour, .daily],
                maxPositions: 5,
                riskPerTrade: 1.5,
                averageHoldTime: 14400, // 4 hours
                winRateTarget: 0.62
            )
            activeBots.append(bot)
        }
    }
    
    private func createInstitutionalBots(count: Int) {
        for i in 0..<count {
            let bot = AdvancedBot(
                id: "INST_\(String(format: "%04d", i))",
                name: "Institution #\(i)",
                personality: createInstitutionalPersonality(),
                specialization: .institutional,
                learningCapabilities: [.orderFlow, .marketStructure, .liquidity],
                tradingTimeframes: [.fifteenMinute, .oneHour, .fourHour],
                maxPositions: 3,
                riskPerTrade: 1.0,
                averageHoldTime: 7200, // 2 hours
                winRateTarget: 0.75
            )
            activeBots.append(bot)
        }
    }
    
    private func createContrarianBots(count: Int) {
        for i in 0..<count {
            let bot = AdvancedBot(
                id: "CONTR_\(String(format: "%04d", i))",
                name: "Contrarian #\(i)",
                personality: createContrarianPersonality(),
                specialization: .contrarian,
                learningCapabilities: [.sentiment, .extremes, .meanReversion],
                tradingTimeframes: [.oneHour, .fourHour, .daily],
                maxPositions: 2,
                riskPerTrade: 2.0,
                averageHoldTime: 21600, // 6 hours
                winRateTarget: 0.58
            )
            activeBots.append(bot)
        }
    }
    
    private func createNewsBots(count: Int) {
        for i in 0..<count {
            let bot = AdvancedBot(
                id: "NEWS_\(String(format: "%04d", i))",
                name: "News Hunter #\(i)",
                personality: createNewsPersonality(),
                specialization: .news,
                learningCapabilities: [.newsAnalysis, .eventTrading, .volatility],
                tradingTimeframes: [.oneMinute, .fiveMinute, .fifteenMinute],
                maxPositions: 2,
                riskPerTrade: 3.0,
                averageHoldTime: 900, // 15 minutes
                winRateTarget: 0.55
            )
            activeBots.append(bot)
        }
    }
    
    private func createSentimentBots(count: Int) {
        for i in 0..<count {
            let bot = AdvancedBot(
                id: "SENT_\(String(format: "%04d", i))",
                name: "Sentiment Reader #\(i)",
                personality: createSentimentPersonality(),
                specialization: .sentiment,
                learningCapabilities: [.sentiment, .socialMedia, .positioning],
                tradingTimeframes: [.fourHour, .daily],
                maxPositions: 3,
                riskPerTrade: 1.5,
                averageHoldTime: 28800, // 8 hours
                winRateTarget: 0.60
            )
            activeBots.append(bot)
        }
    }
    
    private func createPatternBots(count: Int) {
        for i in 0..<count {
            let bot = AdvancedBot(
                id: "PATT_\(String(format: "%04d", i))",
                name: "Pattern Master #\(i)",
                personality: createPatternPersonality(),
                specialization: .patterns,
                learningCapabilities: [.patternRecognition, .chartPatterns, .candlesticks],
                tradingTimeframes: [.fifteenMinute, .oneHour, .fourHour],
                maxPositions: 4,
                riskPerTrade: 1.2,
                averageHoldTime: 3600, // 1 hour
                winRateTarget: 0.65
            )
            activeBots.append(bot)
        }
    }
    
    private func createRiskManagementBots(count: Int) {
        for i in 0..<count {
            let bot = AdvancedBot(
                id: "RISK_\(String(format: "%04d", i))",
                name: "Risk Manager #\(i)",
                personality: createRiskPersonality(),
                specialization: .riskManagement,
                learningCapabilities: [.riskAssessment, .portfolioManagement, .correlation],
                tradingTimeframes: [.daily],
                maxPositions: 1,
                riskPerTrade: 0.8,
                averageHoldTime: 86400, // 24 hours
                winRateTarget: 0.70
            )
            activeBots.append(bot)
        }
    }
    
    private func createPsychologyBots(count: Int) {
        for i in 0..<count {
            let bot = AdvancedBot(
                id: "PSYC_\(String(format: "%04d", i))",
                name: "Psychology Expert #\(i)",
                personality: createPsychologyPersonality(),
                specialization: .psychology,
                learningCapabilities: [.behaviorAnalysis, .emotionalPatterns, .marketPsychology],
                tradingTimeframes: [.oneHour, .fourHour],
                maxPositions: 2,
                riskPerTrade: 1.0,
                averageHoldTime: 7200, // 2 hours
                winRateTarget: 0.72
            )
            activeBots.append(bot)
        }
    }
    
    // MARK: - Personality Creation Methods
    
    private func createScalpingPersonality() -> BotPersonalityProfile {
        return BotPersonalityProfile(
            aggressiveness: 0.8,
            patience: 0.2,
            riskTolerance: 0.3,
            adaptability: 0.9,
            analyticalDepth: 0.6,
            emotionalControl: 0.95,
            decisionSpeed: 0.95,
            learningRate: 0.8,
            traits: ["Quick execution", "High frequency", "Momentum focused", "Low latency"],
            communicationStyle: .concise,
            preferredMarketConditions: [.trending, .volatile]
        )
    }
    
    private func createSwingPersonality() -> BotPersonalityProfile {
        return BotPersonalityProfile(
            aggressiveness: 0.5,
            patience: 0.8,
            riskTolerance: 0.6,
            adaptability: 0.6,
            analyticalDepth: 0.8,
            emotionalControl: 0.85,
            decisionSpeed: 0.6,
            learningRate: 0.7,
            traits: ["Patient", "Trend following", "Multi-timeframe", "Systematic"],
            communicationStyle: .analytical,
            preferredMarketConditions: [.trending, .breakout]
        )
    }
    
    private func createInstitutionalPersonality() -> BotPersonalityProfile {
        return BotPersonalityProfile(
            aggressiveness: 0.4,
            patience: 0.9,
            riskTolerance: 0.4,
            adaptability: 0.5,
            analyticalDepth: 0.95,
            emotionalControl: 0.98,
            decisionSpeed: 0.7,
            learningRate: 0.6,
            traits: ["Methodical", "Structure focused", "Order flow expert", "Conservative"],
            communicationStyle: .technical,
            preferredMarketConditions: [.structured, .institutional]
        )
    }
    
    private func createContrarianPersonality() -> BotPersonalityProfile {
        return BotPersonalityProfile(
            aggressiveness: 0.6,
            patience: 0.7,
            riskTolerance: 0.7,
            adaptability: 0.8,
            analyticalDepth: 0.7,
            emotionalControl: 0.9,
            decisionSpeed: 0.5,
            learningRate: 0.6,
            traits: ["Contrarian thinking", "Extreme hunter", "Mean reversion", "Independent"],
            communicationStyle: .contrarian,
            preferredMarketConditions: [.oversold, .overbought, .extreme]
        )
    }
    
    private func createNewsPersonality() -> BotPersonalityProfile {
        return BotPersonalityProfile(
            aggressiveness: 0.9,
            patience: 0.3,
            riskTolerance: 0.8,
            adaptability: 0.95,
            analyticalDepth: 0.5,
            emotionalControl: 0.8,
            decisionSpeed: 0.98,
            learningRate: 0.9,
            traits: ["News driven", "Event focused", "High volatility", "Rapid response"],
            communicationStyle: .urgent,
            preferredMarketConditions: [.volatile, .news]
        )
    }
    
    private func createSentimentPersonality() -> BotPersonalityProfile {
        return BotPersonalityProfile(
            aggressiveness: 0.4,
            patience: 0.8,
            riskTolerance: 0.5,
            adaptability: 0.7,
            analyticalDepth: 0.8,
            emotionalControl: 0.9,
            decisionSpeed: 0.6,
            learningRate: 0.7,
            traits: ["Sentiment analysis", "Crowd psychology", "Social aware", "Contrarian"],
            communicationStyle: .observational,
            preferredMarketConditions: [.extreme, .sentiment]
        )
    }
    
    private func createPatternPersonality() -> BotPersonalityProfile {
        return BotPersonalityProfile(
            aggressiveness: 0.6,
            patience: 0.6,
            riskTolerance: 0.5,
            adaptability: 0.6,
            analyticalDepth: 0.9,
            emotionalControl: 0.85,
            decisionSpeed: 0.7,
            learningRate: 0.8,
            traits: ["Pattern recognition", "Visual analysis", "Chart expert", "Technical"],
            communicationStyle: .visual,
            preferredMarketConditions: [.patterned, .technical]
        )
    }
    
    private func createRiskPersonality() -> BotPersonalityProfile {
        return BotPersonalityProfile(
            aggressiveness: 0.2,
            patience: 0.95,
            riskTolerance: 0.3,
            adaptability: 0.4,
            analyticalDepth: 0.95,
            emotionalControl: 0.99,
            decisionSpeed: 0.4,
            learningRate: 0.5,
            traits: ["Risk focused", "Conservative", "Mathematical", "Protective"],
            communicationStyle: .cautious,
            preferredMarketConditions: [.stable, .low_risk]
        )
    }
    
    private func createPsychologyPersonality() -> BotPersonalityProfile {
        return BotPersonalityProfile(
            aggressiveness: 0.3,
            patience: 0.9,
            riskTolerance: 0.4,
            adaptability: 0.8,
            analyticalDepth: 0.9,
            emotionalControl: 0.95,
            decisionSpeed: 0.5,
            learningRate: 0.9,
            traits: ["Psychology expert", "Behavior analyst", "Mark Douglas follower", "Mindful"],
            communicationStyle: .psychological,
            preferredMarketConditions: [.psychological, .behavioral]
        )
    }
    
    func feedScreenshot(_ imagePath: String, metadata: ScreenshotMetadata) {
        let learningEvent = LearningEvent(
            type: .pattern,
            description: "Screenshot analysis for \(metadata.symbol)",
            data: ["imagePath": imagePath, "metadata": metadata],
            confidence: 0.8,
            priority: .medium,
            source: "ScreenshotEngine"
        )
        
        botLearningQueue.append(learningEvent)
        processScreenshotLearning(learningEvent)
    }
    
    func feedTranscript(_ transcriptPath: String, metadata: TranscriptMetadata) {
        let learningEvent = LearningEvent(
            type: .session,
            description: "Transcript analysis with \(metadata.participantCount) participants",
            data: ["transcriptPath": transcriptPath, "metadata": metadata],
            confidence: 0.85,
            priority: .medium,
            source: "TranscriptEngine"
        )
        
        botLearningQueue.append(learningEvent)
        processTranscriptLearning(learningEvent)
    }
    
    func feedTradeOutcome(_ trade: SharedTypes.SharedTradeResult, signal: SharedTypes.AutoTradingSignal) {
        let event = LearningEvent(
            type: .performance,
            description: "Trade outcome analysis for \(signal.symbol)",
            data: [
                "success": trade.success,
                "profit": trade.profit,
                "signal_confidence": signal.confidence,
                "reasoning": signal.reasoning
            ],
            confidence: trade.success ? 0.8 : 0.6,
            priority: .medium,
            source: "TradeOutcome"
        )

        botLearningQueue.append(event)
        processTradeOutcomeLearning(event)
    }
    
    private func processScreenshotLearning(_ event: LearningEvent) {
        // Distribute screenshot learning to relevant bots
        let relevantBots = activeBots.filter { bot in
            bot.learningCapabilities.contains(.priceAction) ||
            bot.learningCapabilities.contains(.chartPatterns) ||
            bot.learningCapabilities.contains(.patternRecognition)
        }
        
        for bot in relevantBots {
            Task {
                await bot.learnFromScreenshot(event)
            }
        }
        
        // Global screenshot processing
        screenshotLearningEngine.processScreenshot(event)
    }
    
    private func processTranscriptLearning(_ event: LearningEvent) {
        // Distribute transcript learning to all bots
        for bot in activeBots {
            Task {
                await bot.learnFromTranscript(event)
            }
        }
        
        // Global transcript processing
        transcriptLearningEngine.processTranscript(event)
    }
    
    private func processTradeOutcomeLearning(_ event: LearningEvent) {
        // All bots learn from trade outcomes
        for bot in activeBots {
            Task {
                await bot.learnFromTradeOutcome(event)
            }
        }
        
        // Update global statistics
        updateGlobalStats()
    }
    
    // MARK: - Bot Communication System
    
    private func startBotCommunication() {
        // Simulate bot-to-bot communication
        Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { _ in
            Task { @MainActor in
                self.simulateBotDiscussion()
                self.generateConsensusSignals()
            }
        }
    }
    
    private func simulateBotDiscussion() {
        let discussionTopics = [
            "Market structure analysis",
            "Risk assessment review",
            "Pattern confirmation",
            "Sentiment shift detected",
            "Volume anomaly discussion",
            "News impact evaluation"
        ]
        
        let topic = discussionTopics.randomElement()!
        let participatingBots = Array(activeBots.shuffled().prefix(Int.random(in: 3...8)))
        
        let discussion = BotDiscussion(
            id: UUID().uuidString,
            topic: topic,
            participants: participatingBots.map { $0.id },
            startTime: Date(),
            messages: generateDiscussionMessages(topic: topic, bots: participatingBots)
        )
        
        activeBotDiscussions.append(discussion)
        
        // Keep only recent discussions
        if activeBotDiscussions.count > 10 {
            activeBotDiscussions.removeFirst()
        }
    }
    
    private func generateDiscussionMessages(topic: String, bots: [AdvancedBot]) -> [BotChatMessage] {
        var messages: [BotChatMessage] = []
        
        for i in 0..<Int.random(in: 3...6) {
            let bot = bots[i % bots.count]
            let message = generateBotMessage(bot: bot, topic: topic)
            messages.append(message)
        }
        
        return messages
    }
    
    private func generateBotMessage(bot: AdvancedBot, topic: String) -> BotChatMessage {
        let messageTemplates = [
            "Based on my analysis of {topic}, I'm seeing strong {direction} signals",
            "My {specialization} indicators suggest {confidence} probability for {direction}",
            "Risk assessment shows {risk_level} exposure on current {topic}",
            "Pattern recognition confirms {pattern} formation with {confidence} confidence",
            "Institutional flow analysis indicates {flow_direction} pressure"
        ]
        
        let template = messageTemplates.randomElement()!
        let direction = ["bullish", "bearish", "neutral"].randomElement()!
        let confidence = ["high", "medium", "low"].randomElement()!
        let riskLevel = ["low", "moderate", "elevated"].randomElement()!
        let pattern = ["continuation", "reversal", "consolidation"].randomElement()!
        let flowDirection = ["buying", "selling", "mixed"].randomElement()!
        
        let content = template
            .replacingOccurrences(of: "{topic}", with: topic)
            .replacingOccurrences(of: "{direction}", with: direction)
            .replacingOccurrences(of: "{specialization}", with: bot.specialization.rawValue)
            .replacingOccurrences(of: "{confidence}", with: confidence)
            .replacingOccurrences(of: "{risk_level}", with: riskLevel)
            .replacingOccurrences(of: "{pattern}", with: pattern)
            .replacingOccurrences(of: "{flow_direction}", with: flowDirection)
        
        return BotChatMessage(
            id: UUID().uuidString,
            botId: bot.id,
            botName: bot.name,
            content: content,
            timestamp: Date(),
            confidence: Double.random(in: 0.6...0.95),
            messageType: .analysis
        )
    }
    
    private func generateConsensusSignals() {
        // Analyze bot opinions to generate consensus signals
        let recentMessages = botChatMessages.filter { message in
            Date().timeIntervalSince(message.timestamp) < 300 // Last 5 minutes
        }
        
        if recentMessages.count >= 5 {
            let avgConfidence = recentMessages.map { $0.confidence }.reduce(0, +) / Double(recentMessages.count)
            
            if avgConfidence > 0.8 {
                let signal = ConsensusSignal(
                    id: UUID().uuidString,
                    direction: SharedTypes.TradeDirection.buy, // Simplified
                    confidence: avgConfidence,
                    participatingBots: Array(Set(recentMessages.map { $0.botId })),
                    reasoning: "High consensus from \(recentMessages.count) bots",
                    timestamp: Date()
                )
                
                consensusSignals.append(signal)
                
                // Keep only recent signals
                if consensusSignals.count > 20 {
                    consensusSignals.removeFirst()
                }
            }
        }
    }
    
    // MARK: - Continuous Learning
    
    private func startContinuousLearning() {
        learningTimer = Timer.scheduledTimer(withTimeInterval: 300.0, repeats: true) { _ in
            Task { @MainActor in
                self.performContinuousLearning()
            }
        }
    }
    
    private func performContinuousLearning() {
        // Evolution and learning processes
        evolveBotPersonalities()
        crossBreedSuccessfulBots()
        retireUnderperformingBots()
        generateNewBotGeneration()
        updateGlobalStats()
    }
    
    private func evolveBotPersonalities() {
        for i in activeBots.indices {
            activeBots[i].evolvePersonality()
        }
    }
    
    private func crossBreedSuccessfulBots() {
        let topBots = activeBots.sorted { $0.performance.overallScore > $1.performance.overallScore }.prefix(100)
        
        // Create new bots by combining traits of successful bots
        for _ in 0..<10 {
            if let bot1 = topBots.randomElement(), let bot2 = topBots.randomElement() {
                let newBot = createHybridBot(parent1: bot1, parent2: bot2)
                activeBots.append(newBot)
            }
        }
    }
    
    private func createHybridBot(parent1: AdvancedBot, parent2: AdvancedBot) -> AdvancedBot {
        let hybridPersonality = BotPersonalityProfile(
            aggressiveness: (parent1.personality.aggressiveness + parent2.personality.aggressiveness) / 2,
            patience: (parent1.personality.patience + parent2.personality.patience) / 2,
            riskTolerance: (parent1.personality.riskTolerance + parent2.personality.riskTolerance) / 2,
            adaptability: (parent1.personality.adaptability + parent2.personality.adaptability) / 2,
            analyticalDepth: (parent1.personality.analyticalDepth + parent2.personality.analyticalDepth) / 2,
            emotionalControl: (parent1.personality.emotionalControl + parent2.personality.emotionalControl) / 2,
            decisionSpeed: (parent1.personality.decisionSpeed + parent2.personality.decisionSpeed) / 2,
            learningRate: (parent1.personality.learningRate + parent2.personality.learningRate) / 2,
            traits: Array(Set(parent1.personality.traits + parent2.personality.traits)),
            communicationStyle: [parent1.personality.communicationStyle, parent2.personality.communicationStyle].randomElement()!,
            preferredMarketConditions: Array(Set(parent1.personality.preferredMarketConditions + parent2.personality.preferredMarketConditions))
        )
        
        return AdvancedBot(
            id: "HYBRID_\(UUID().uuidString.prefix(8))",
            name: "Hybrid Gen\(botGeneration)",
            personality: hybridPersonality,
            specialization: [parent1.specialization, parent2.specialization].randomElement()!,
            learningCapabilities: Array(Set(parent1.learningCapabilities + parent2.learningCapabilities)),
            tradingTimeframes: Array(Set(parent1.tradingTimeframes + parent2.tradingTimeframes)),
            maxPositions: Int((parent1.maxPositions + parent2.maxPositions) / 2),
            riskPerTrade: (parent1.riskPerTrade + parent2.riskPerTrade) / 2,
            averageHoldTime: Int((parent1.averageHoldTime + parent2.averageHoldTime) / 2),
            winRateTarget: (parent1.winRateTarget + parent2.winRateTarget) / 2
        )
    }
    
    private func retireUnderperformingBots() {
        let threshold = 0.3 // Retire bots performing below 30%
        activeBots.removeAll { $0.performance.overallScore < threshold }
    }
    
    private func generateNewBotGeneration() {
        if activeBots.count < 4900 { // Maintain population
            let newBotsNeeded = 5000 - activeBots.count
            
            for _ in 0..<newBotsNeeded {
                let newBot = createRandomBot(generation: botGeneration + 1)
                activeBots.append(newBot)
            }
            
            botGeneration += 1
        }
    }
    
    private func createRandomBot(generation: Int) -> AdvancedBot {
        let specializations: [BotSpecialization] = [.scalping, .swing, .institutional, .contrarian, .news, .sentiment, .patterns, .riskManagement, .psychology]
        let specialization = specializations.randomElement()!
        
        return AdvancedBot(
            id: "GEN\(generation)_\(UUID().uuidString.prefix(8))",
            name: "Generation \(generation) Bot",
            personality: createRandomPersonality(),
            specialization: specialization,
            learningCapabilities: generateRandomCapabilities(),
            tradingTimeframes: generateRandomTimeframes(),
            maxPositions: Int.random(in: 1...5),
            riskPerTrade: Double.random(in: 0.5...3.0),
            averageHoldTime: Int.random(in: 60...86400),
            winRateTarget: Double.random(in: 0.45...0.80)
        )
    }
    
    private func createRandomPersonality() -> BotPersonalityProfile {
        return BotPersonalityProfile(
            aggressiveness: Double.random(in: 0.1...0.9),
            patience: Double.random(in: 0.1...0.9),
            riskTolerance: Double.random(in: 0.1...0.9),
            adaptability: Double.random(in: 0.1...0.9),
            analyticalDepth: Double.random(in: 0.3...0.95),
            emotionalControl: Double.random(in: 0.5...0.99),
            decisionSpeed: Double.random(in: 0.1...0.99),
            learningRate: Double.random(in: 0.3...0.9),
            traits: generateRandomTraits(),
            communicationStyle: CommunicationStyle.allCases.randomElement()!,
            preferredMarketConditions: generateRandomMarketConditions()
        )
    }
    
    private func generateRandomCapabilities() -> [SharedTypes.LearningCapability] {
        let allCapabilities = SharedTypes.LearningCapability.allCases
        let count = Int.random(in: 2...5)
        return Array(allCapabilities.shuffled().prefix(count))
    }
    
    private func generateRandomTimeframes() -> [TradingTimeframe] {
        let allTimeframes = TradingTimeframe.allCases
        let count = Int.random(in: 1...3)
        return Array(allTimeframes.shuffled().prefix(count))
    }
    
    private func generateRandomTraits() -> [String] {
        let allTraits = ["Analytical", "Intuitive", "Aggressive", "Conservative", "Adaptive", "Focused", "Patient", "Quick", "Methodical", "Creative"]
        let count = Int.random(in: 2...4)
        return Array(allTraits.shuffled().prefix(count))
    }
    
    private func generateRandomMarketConditions() -> [MarketCondition] {
        let allConditions = MarketCondition.allCases
        let count = Int.random(in: 1...3)
        return Array(allConditions.shuffled().prefix(count))
    }
    
    private func updateGlobalStats() {
        globalBotStats = GlobalBotStats(
            totalBots: activeBots.count,
            activeBots: activeBots.filter { $0.isActive }.count,
            learningBots: activeBots.filter { $0.isLearning }.count,
            tradingBots: activeBots.filter { $0.isTrading }.count,
            averagePerformance: activeBots.map { $0.performance.overallScore }.reduce(0, +) / Double(activeBots.count),
            totalTrades: activeBots.map { $0.performance.totalTrades }.reduce(0, +),
            overallWinRate: calculateOverallWinRate(),
            generation: botGeneration
        )
    }
    
    private func calculateOverallWinRate() -> Double {
        let totalWins = activeBots.map { $0.performance.winningTrades }.reduce(0, +)
        let totalTrades = activeBots.map { $0.performance.totalTrades }.reduce(0, +)
        return totalTrades > 0 ? Double(totalWins) / Double(totalTrades) : 0.0
    }
    
    // MARK: - Public Interface
    
    func getBotsBySpecialization(_ specialization: BotSpecialization) -> [AdvancedBot] {
        return activeBots.filter { $0.specialization == specialization }
    }
    
    func getTopPerformingBots(limit: Int = 10) -> [AdvancedBot] {
        return activeBots.sorted { $0.performance.overallScore > $1.performance.overallScore }.prefix(limit).map { $0 }
    }
    
    func getBotsForTimeframe(_ timeframe: TradingTimeframe) -> [AdvancedBot] {
        return activeBots.filter { $0.tradingTimeframes.contains(timeframe) }
    }
    
    func activateBot(_ botId: String) {
        if let index = activeBots.firstIndex(where: { $0.id == botId }) {
            activeBots[index].activate()
        }
    }
    
    func deactivateBot(_ botId: String) {
        if let index = activeBots.firstIndex(where: { $0.id == botId }) {
            activeBots[index].deactivate()
        }
    }
    
    func resetAllBots() {
        for i in activeBots.indices {
            activeBots[i].reset()
        }
        updateGlobalStats()
    }
}

#Preview {
    Text("Bot Personality Engine")
}

