//
//  PlanetMarkDouglasEngine.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 7/18/25.
//

import SwiftUI
import Combine

// MARK: - Trading Psychology Framework Based on Mark Douglas Principles

@MainActor
class PlanetMarkDouglasEngine: ObservableObject {
    
    // MARK: - Core Psychology States
    
    @Published var currentMindset: TradingMindset = .probabilistic
    @Published var fearLevel: Double = 0.0
    @Published var greedLevel: Double = 0.0
    @Published var confidenceLevel: Double = 0.85
    @Published var disciplineScore: Double = 0.90
    @Published var probabilisticThinking: Double = 0.95
    
    // MARK: - Bot Personality Profiles
    
    @Published var activeBotPersonalities: [BotPersonality] = []
    @Published var masterTraderArchetypes: [MasterTraderArchetype] = []
    
    // MARK: - Real-time Psychology Monitoring
    
    @Published var currentEmotionalState: PsychologyEmotionalState = .zen
    @Published var recentPsychologyEvents: [PsychologyEvent] = []
    @Published var dailyMindsetReport: DailyMindsetReport = DailyMindsetReport.sample
    
    // MARK: - ✅ ADDED: Missing Properties for PlaybookView
    @Published var riskAcceptance: Double = 0.85
    @Published var consistencyLevel: Double = 0.88
    
    private var psychologyTimer: Timer?
    
    init() {
        setupMasterTraderArchetypes()
        generateBotPersonalities()
        startPsychologyMonitoring()
    }
    
    deinit {
        psychologyTimer?.invalidate()
    }
    
    // MARK: - Mark Douglas Core Principles Implementation
    
    func applyProbabilisticThinking(to signal: SharedTypes.AutoTradingSignal) -> EnhancedTradingSignal {
        // "Think in probabilities, not certainties" - Mark Douglas
        let probabilityScore = calculateProbabilityScore(signal)
        let riskMindset = assessRiskMindset(signal)
        
        return EnhancedTradingSignal(
            originalSignal: signal,
            probabilityScore: probabilityScore,
            markDouglasCompliance: calculateMarkDouglasCompliance(signal),
            emotionalNeutrality: calculateEmotionalNeutrality(),
            disciplineRating: disciplineScore,
            fearGreedIndex: calculateFearGreedIndex(),
            recommendedAction: determineAction(probabilityScore: probabilityScore)
        )
    }
    
    func processTradeOutcome(_ result: SharedTypes.SharedTradeResult, for signal: SharedTypes.AutoTradingSignal) {
        // Learn from every trade outcome without emotional attachment
        let lesson = extractPsychologyLesson(result: result, signal: signal)
        recentPsychologyEvents.append(lesson)
        
        // Keep only recent events
        if recentPsychologyEvents.count > 100 {
            recentPsychologyEvents.removeFirst(recentPsychologyEvents.count - 100)
        }
        
        // Adjust psychology parameters based on Mark Douglas principles
        adjustPsychologyParameters(based: result)
        updateBotPersonalities(with: lesson)
    }
    
    // MARK: - Bot Personality System
    
    private func setupMasterTraderArchetypes() {
        masterTraderArchetypes = [
            MasterTraderArchetype(
                name: "Mark Douglas - The Zone Master",
                coreBeliefs: [
                    "Anything can happen",
                    "You don't need to know what's going to happen next to make money",
                    "There is a random distribution between wins and losses for any given set of variables",
                    "An edge is nothing more than an indication of a higher probability",
                    "Every moment in the market is unique"
                ],
                tradingStyle: .probabilistic,
                riskTolerance: 0.02,
                winRateExpectation: 0.65,
                maxDrawdown: 0.10,
                psychologyStrengths: ["Emotional neutrality", "Probabilistic thinking", "Consistent execution"]
            ),
            MasterTraderArchetype(
                name: "ICT - The Market Maker",
                coreBeliefs: [
                    "Markets are algorithmic and manipulated",
                    "Look for institutional order flow",
                    "Trade the manipulation, don't fight it",
                    "Time is more important than price",
                    "Smart money leaves footprints"
                ],
                tradingStyle: .institutional,
                riskTolerance: 0.01,
                winRateExpectation: 0.75,
                maxDrawdown: 0.08,
                psychologyStrengths: ["Pattern recognition", "Patience", "Market structure awareness"]
            ),
            MasterTraderArchetype(
                name: "Swaggy C - The Momentum Hunter",
                coreBeliefs: [
                    "Ride the wave when it's moving",
                    "Cut losses quick, let winners run",
                    "Volume and momentum tell the story",
                    "Multiple timeframe confirmation",
                    "Risk management is everything"
                ],
                tradingStyle: .momentum,
                riskTolerance: 0.025,
                winRateExpectation: 0.58,
                maxDrawdown: 0.12,
                psychologyStrengths: ["Quick decision making", "Momentum recognition", "Adaptive risk management"]
            ),
            MasterTraderArchetype(
                name: "Larry Williams - The Contrarian",
                coreBeliefs: [
                    "When everyone is bullish, be bearish",
                    "Market extremes create opportunities",
                    "COT data reveals true sentiment",
                    "Seasonal patterns matter",
                    "Trade against the crowd"
                ],
                tradingStyle: .contrarian,
                riskTolerance: 0.03,
                winRateExpectation: 0.62,
                maxDrawdown: 0.15,
                psychologyStrengths: ["Contrarian thinking", "Sentiment analysis", "Long-term perspective"]
            ),
            MasterTraderArchetype(
                name: "Tom Hougaard - The Scalper",
                coreBeliefs: [
                    "Small frequent wins compound",
                    "Read the tape, not the news",
                    "Market microstructure is key",
                    "Emotions are the enemy",
                    "Consistency over big wins"
                ],
                tradingStyle: .scalping,
                riskTolerance: 0.005,
                winRateExpectation: 0.68,
                maxDrawdown: 0.05,
                psychologyStrengths: ["Laser focus", "Quick execution", "Emotional control"]
            )
        ]
    }
    
    private func generateBotPersonalities() {
        activeBotPersonalities = []
        
        // Create 1,000 unique bot personalities based on master archetypes
        for i in 0..<1000 {
            let baseArchetype = masterTraderArchetypes.randomElement()!
            let personality = createUniquePersonality(from: baseArchetype, botId: i)
            activeBotPersonalities.append(personality)
        }
    }
    
    private func createUniquePersonality(from archetype: MasterTraderArchetype, botId: Int) -> BotPersonality {
        // Create slight variations of master archetypes for uniqueness
        let riskVariation = Double.random(in: -0.005...0.005)
        let winRateVariation = Double.random(in: -0.05...0.05)
        let drawdownVariation = Double.random(in: -0.02...0.02)
        
        return BotPersonality(
            id: "BOT_\(String(format: "%04d", botId))",
            name: "\(archetype.name) Clone #\(botId)",
            baseArchetype: archetype.name,
            coreBeliefs: archetype.coreBeliefs,
            tradingStyle: archetype.tradingStyle,
            riskTolerance: max(0.001, archetype.riskTolerance + riskVariation),
            winRateExpectation: max(0.45, min(0.85, archetype.winRateExpectation + winRateVariation)),
            maxDrawdown: max(0.03, min(0.25, archetype.maxDrawdown + drawdownVariation)),
            psychologyStrengths: archetype.psychologyStrengths,
            currentConfidence: Double.random(in: 0.7...0.95),
            tradesExecuted: 0,
            currentStreak: 0,
            learningRate: Double.random(in: 0.01...0.05),
            adaptabilityScore: Double.random(in: 0.6...0.9),
            specialization: generateSpecialization()
        )
    }
    
    private func generateSpecialization() -> String {
        let specializations = [
            "London Session Expert", "New York Close Specialist", "Asian Range Trader",
            "News Event Hunter", "Breakout Master", "Reversal Detector",
            "Trend Follower", "Range Bound Specialist", "Volatility Trader",
            "Support/Resistance Expert", "Pattern Recognition AI", "Volume Analysis Pro"
        ]
        return specializations.randomElement()!
    }
    
    // MARK: - Psychology Calculation Methods
    
    private func calculateProbabilityScore(_ signal: SharedTypes.AutoTradingSignal) -> Double {
        // Implement Mark Douglas probability-based scoring
        var score = signal.confidence
        
        // Adjust based on current psychology state
        if currentMindset == .probabilistic {
            score *= 1.1
        }
        
        // Factor in fear/greed levels
        let emotionalAdjustment = 1.0 - (fearLevel + greedLevel) / 2.0
        score *= emotionalAdjustment
        
        return min(1.0, max(0.0, score))
    }
    
    private func calculateMarkDouglasCompliance(_ signal: SharedTypes.AutoTradingSignal) -> Double {
        var compliance = 0.0
        
        // Check adherence to Mark Douglas principles
        if signal.confidence >= 0.6 && signal.confidence <= 0.8 {
            compliance += 0.2 // Realistic probability thinking
        }
        
        if signal.stopLoss > 0 && signal.takeProfit > 0 {
            compliance += 0.3 // Predefined risk management
        }
        
        if disciplineScore > 0.8 {
            compliance += 0.3 // High discipline
        }
        
        if probabilisticThinking > 0.9 {
            compliance += 0.2 // Strong probabilistic mindset
        }
        
        return min(1.0, compliance)
    }
    
    private func calculateEmotionalNeutrality() -> Double {
        return 1.0 - ((fearLevel + greedLevel) / 2.0)
    }
    
    private func calculateFearGreedIndex() -> Double {
        return (fearLevel + greedLevel) / 2.0
    }
    
    private func assessRiskMindset(_ signal: SharedTypes.AutoTradingSignal) -> Double {
        // Assess risk mindset based on signal confidence and current psychology state
        var riskMindset = 0.5 // Base neutral mindset
        
        // Adjust based on signal confidence
        riskMindset += signal.confidence * 0.3
        
        // Adjust based on current emotional state
        switch currentEmotionalState {
        case .zen:
            riskMindset += 0.2
        case .confident:
            riskMindset += 0.1
        case .cautious:
            riskMindset -= 0.1
        case .stressed:
            riskMindset -= 0.2
        case .overwhelmed:
            riskMindset -= 0.3
        }
        
        // Adjust based on discipline score
        riskMindset += (disciplineScore - 0.5) * 0.2
        
        // Clamp between 0.0 and 1.0
        return max(0.0, min(1.0, riskMindset))
    }
    
    private func determineAction(probabilityScore: Double) -> TradingAction {
        switch probabilityScore {
        case 0.8...1.0:
            return .strongBuy
        case 0.6..<0.8:
            return .buy
        case 0.4..<0.6:
            return .hold
        case 0.2..<0.4:
            return .sell
        default:
            return .strongSell
        }
    }
    
    // MARK: - Learning and Adaptation
    
    private func extractPsychologyLesson(result: SharedTypes.SharedTradeResult, signal: SharedTypes.AutoTradingSignal) -> PsychologyEvent {
        let impact = result.success ? 0.05 : -0.02
        
        return PsychologyEvent(
            id: UUID().uuidString,
            timestamp: Date(),
            eventType: result.success ? .successfulTrade : .unsuccessfulTrade,
            description: result.message,
            psychologyImpact: impact,
            markDouglasLesson: generateMarkDouglasLesson(result: result),
            confidenceChange: impact,
            disciplineChange: result.success ? 0.01 : -0.01
        )
    }
    
    private func generateMarkDouglasLesson(result: SharedTypes.SharedTradeResult) -> String {
        let lessons = [
            "Every trade is independent - this outcome doesn't predict the next",
            "Focus on executing the process, not the outcome",
            "Losses are simply the cost of doing business",
            "Maintain emotional equilibrium regardless of results",
            "Trust your edge and execute consistently"
        ]
        return lessons.randomElement()!
    }
    
    private func adjustPsychologyParameters(based result: SharedTypes.SharedTradeResult) {
        if result.success {
            confidenceLevel = min(1.0, confidenceLevel + 0.01)
            fearLevel = max(0.0, fearLevel - 0.005)
            disciplineScore = min(1.0, disciplineScore + 0.005)
        } else {
            // Don't let losses significantly impact psychology (Mark Douglas principle)
            fearLevel = min(0.3, fearLevel + 0.002)
            greedLevel = max(0.0, greedLevel - 0.002)
        }
        
        // Always increase probabilistic thinking with experience
        probabilisticThinking = min(1.0, probabilisticThinking + 0.001)
    }
    
    private func updateBotPersonalities(with lesson: PsychologyEvent) {
        for i in activeBotPersonalities.indices {
            activeBotPersonalities[i].incorporate(lesson: lesson)
        }
    }
    
    // MARK: - Real-time Monitoring
    
    private func startPsychologyMonitoring() {
        psychologyTimer = Timer.scheduledTimer(withTimeInterval: 30.0, repeats: true) { _ in
            Task { @MainActor in
                self.updatePsychologyMetrics()
            }
        }
    }
    
    private func updatePsychologyMetrics() {
        // Simulate real-time psychology monitoring
        let marketStress = Double.random(in: 0.0...0.1)
        
        // Natural decay of extreme emotions (Mark Douglas principle)
        fearLevel = max(0.0, fearLevel - 0.01 + marketStress)
        greedLevel = max(0.0, greedLevel - 0.01 + marketStress)
        
        // Update emotional state
        updateEmotionalState()
        
        // Generate daily report
        if !Calendar.current.isDate(Date(), inSameDayAs: dailyMindsetReport.date) {
            generateDailyMindsetReport()
        }
    }
    
    private func updateEmotionalState() {
        let overallEmotionalLevel = (fearLevel + greedLevel) / 2.0
        
        switch overallEmotionalLevel {
        case 0.0..<0.1:
            currentEmotionalState = .zen
        case 0.1..<0.3:
            currentEmotionalState = .confident
        case 0.3..<0.5:
            currentEmotionalState = .cautious
        case 0.5..<0.7:
            currentEmotionalState = .stressed
        default:
            currentEmotionalState = .overwhelmed
        }
    }
    
    private func generateDailyMindsetReport() {
        dailyMindsetReport = DailyMindsetReport(
            date: Date(),
            overallScore: (confidenceLevel + disciplineScore + probabilisticThinking) / 3.0,
            fearGreedIndex: calculateFearGreedIndex(),
            disciplineRating: disciplineScore,
            probabilisticThinkingScore: probabilisticThinking,
            keyInsights: generateDailyInsights(),
            improvementAreas: identifyImprovementAreas(),
            markDouglasQuote: getRandomMarkDouglasQuote()
        )
    }
    
    private func generateDailyInsights() -> [String] {
        var insights: [String] = []
        
        if confidenceLevel > 0.9 {
            insights.append("Confidence levels are strong - maintain this mindset")
        }
        
        if fearLevel < 0.1 {
            insights.append("Fear is well controlled - excellent emotional management")
        }
        
        if disciplineScore > 0.85 {
            insights.append("Discipline remains high - key to long-term success")
        }
        
        if insights.isEmpty {
            insights.append("Continue working on psychological consistency")
        }
        
        return insights
    }
    
    private func identifyImprovementAreas() -> [String] {
        var areas: [String] = []
        
        if fearLevel > 0.2 {
            areas.append("Work on reducing fear through more experience")
        }
        
        if greedLevel > 0.3 {
            areas.append("Focus on controlling greed with proper position sizing")
        }
        
        if disciplineScore < 0.7 {
            areas.append("Strengthen discipline by following your trading plan")
        }
        
        if areas.isEmpty {
            areas.append("Maintain current psychological balance")
        }
        
        return areas
    }
    
    private func getRandomMarkDouglasQuote() -> String {
        let quotes = [
            "The hard reality is that every trade has an uncertain outcome.",
            "You don't need to know what's going to happen next to make money.",
            "Anything can happen, and you don't need to know what's going to happen next to make money.",
            "The market can do anything at any moment.",
            "Learning to think in probabilities will give you a trading edge.",
            "The consistency you seek is in your mind, not in the markets.",
            "Predefine your risk before you put on a trade."
        ]
        return quotes.randomElement()!
    }
    
    // MARK: - ✅ ADDED: Missing Methods for PlaybookView
    
    func getMarkDouglasInsight() -> String {
        let insights = [
            "Your probabilistic thinking is strong at \(Int(probabilisticThinking * 100))%. This is the foundation of consistent trading success.",
            "Discipline score of \(Int(disciplineScore * 100))% shows excellent self-control. Mark Douglas would be impressed with your consistency.",
            "Current emotional state '\(currentEmotionalState.rawValue.lowercased())' indicates optimal trading psychology. Maintain this mindset.",
            "Fear level at \(Int(fearLevel * 100))% and greed at \(Int(greedLevel * 100))% - excellent emotional balance for decision making.",
            "Your risk acceptance of \(Int(riskAcceptance * 100))% aligns with professional trading psychology principles."
        ]
        return insights.randomElement() ?? insights[0]
    }
    
    func getFundamental() -> String {
        let fundamentals = [
            "Anything can happen in the markets - accept uncertainty as the only certainty.",
            "You don't need to know what's going to happen next to make money consistently.",
            "There is a random distribution between wins and losses for any given set of variables.",
            "An edge is nothing more than an indication of a higher probability of one outcome over another.",
            "Every moment in the market is unique, even though patterns may repeat.",
            "The consistency you seek is in your mind, not in the markets.",
            "Trading is a probability game, and you are the house if you think like one."
        ]
        return fundamentals.randomElement() ?? fundamentals[0]
    }
    
    // MARK: - Public Interface Methods
    
    func getBotPersonality(id: String) -> BotPersonality? {
        return activeBotPersonalities.first { $0.id == id }
    }
    
    func getTopPerformingBots(limit: Int = 10) -> [BotPersonality] {
        return Array(activeBotPersonalities
            .sorted { $0.currentConfidence > $1.currentConfidence }
            .prefix(limit))
    }
    
    func getBotsForSpecialization(_ specialization: String) -> [BotPersonality] {
        return activeBotPersonalities.filter { $0.specialization == specialization }
    }
    
    func resetPsychologyState() {
        fearLevel = 0.0
        greedLevel = 0.0
        confidenceLevel = 0.85
        disciplineScore = 0.90
        probabilisticThinking = 0.95
        currentMindset = .probabilistic
        currentEmotionalState = .zen
        recentPsychologyEvents.removeAll()
    }
    
    // MARK: - Statistics and Analytics
    
    func getPsychologyStatistics() -> PsychologyStatistics {
        let totalBots = activeBotPersonalities.count
        let avgConfidence = activeBotPersonalities.reduce(0.0) { $0 + $1.currentConfidence } / Double(totalBots)
        let totalTrades = activeBotPersonalities.reduce(0) { $0 + $1.tradesExecuted }
        
        return PsychologyStatistics(
            totalBots: totalBots,
            averageConfidence: avgConfidence,
            totalTradesExecuted: totalTrades,
            currentEmotionalState: currentEmotionalState,
            overallDisciplineScore: disciplineScore,
            fearGreedIndex: calculateFearGreedIndex()
        )
    }
}

// MARK: - Supporting Data Structures

enum TradingMindset: String, CaseIterable {
    case probabilistic = "Probabilistic"
    case emotional = "Emotional"
    case mechanical = "Mechanical"
    case intuitive = "Intuitive"
}

enum PsychologyEmotionalState: String, CaseIterable {
    case zen = "Zen"
    case confident = "Confident"
    case cautious = "Cautious"
    case stressed = "Stressed"
    case overwhelmed = "Overwhelmed"
    
    var color: Color {
        switch self {
        case .zen: return .green
        case .confident: return .blue
        case .cautious: return .orange
        case .stressed: return .red
        case .overwhelmed: return .purple
        }
    }
}

enum TradingAction: String, CaseIterable {
    case strongBuy = "Strong Buy"
    case buy = "Buy"
    case hold = "Hold"
    case sell = "Sell"
    case strongSell = "Strong Sell"
    
    var color: Color {
        switch self {
        case .strongBuy: return .green
        case .buy: return .mint
        case .hold: return .gray
        case .sell: return .orange
        case .strongSell: return .red
        }
    }
}

enum TradingStyleType: String, CaseIterable {
    case probabilistic = "Probabilistic"
    case institutional = "Institutional"
    case momentum = "Momentum"
    case contrarian = "Contrarian"
    case scalping = "Scalping"
}

struct MasterTraderArchetype {
    let name: String
    let coreBeliefs: [String]
    let tradingStyle: TradingStyleType
    let riskTolerance: Double
    let winRateExpectation: Double
    let maxDrawdown: Double
    let psychologyStrengths: [String]
}

struct BotPersonality: Identifiable {
    let id: String
    let name: String
    let baseArchetype: String
    let coreBeliefs: [String]
    let tradingStyle: TradingStyleType
    let riskTolerance: Double
    let winRateExpectation: Double
    let maxDrawdown: Double
    let psychologyStrengths: [String]
    var currentConfidence: Double
    var tradesExecuted: Int
    var currentStreak: Int
    let learningRate: Double
    let adaptabilityScore: Double
    let specialization: String
    
    mutating func incorporate(lesson: PsychologyEvent) {
        currentConfidence = max(0.1, min(1.0, currentConfidence + lesson.confidenceChange * learningRate))
        tradesExecuted += 1
        
        if lesson.eventType == .successfulTrade {
            currentStreak = max(0, currentStreak + 1)
        } else {
            currentStreak = min(0, currentStreak - 1)
        }
    }
    
    var performanceGrade: String {
        switch currentConfidence {
        case 0.9...: return "Elite"
        case 0.8..<0.9: return "Advanced"
        case 0.7..<0.8: return "Intermediate"
        case 0.6..<0.7: return "Developing"
        default: return "Novice"
        }
    }
}

struct EnhancedTradingSignal {
    let originalSignal: SharedTypes.AutoTradingSignal
    let probabilityScore: Double
    let markDouglasCompliance: Double
    let emotionalNeutrality: Double
    let disciplineRating: Double
    let fearGreedIndex: Double
    let recommendedAction: TradingAction
    
    var qualityScore: Double {
        return (probabilityScore + markDouglasCompliance + emotionalNeutrality + disciplineRating) / 4.0
    }
}

struct PsychologyEvent: Identifiable {
    let id: String
    let timestamp: Date
    let eventType: PsychologyEventType
    let description: String
    let psychologyImpact: Double
    let markDouglasLesson: String
    let confidenceChange: Double
    let disciplineChange: Double
}

enum PsychologyEventType: String, CaseIterable {
    case successfulTrade = "Successful Trade"
    case unsuccessfulTrade = "Unsuccessful Trade"
    case disciplineBreak = "Discipline Break"
    case emotionalDecision = "Emotional Decision"
    case learningMoment = "Learning Moment"
}

struct DailyMindsetReport {
    let date: Date
    let overallScore: Double
    let fearGreedIndex: Double
    let disciplineRating: Double
    let probabilisticThinkingScore: Double
    let keyInsights: [String]
    let improvementAreas: [String]
    let markDouglasQuote: String
    
    static let sample = DailyMindsetReport(
        date: Date(),
        overallScore: 0.87,
        fearGreedIndex: 0.15,
        disciplineRating: 0.91,
        probabilisticThinkingScore: 0.94,
        keyInsights: ["Strong discipline maintained", "Emotional control excellent"],
        improvementAreas: ["Continue building confidence"],
        markDouglasQuote: "Anything can happen, and you don't need to know what's going to happen next to make money."
    )
}

struct PsychologyStatistics {
    let totalBots: Int
    let averageConfidence: Double
    let totalTradesExecuted: Int
    let currentEmotionalState: PsychologyEmotionalState
    let overallDisciplineScore: Double
    let fearGreedIndex: Double
    
    var formattedAverageConfidence: String {
        String(format: "%.1f%%", averageConfidence * 100)
    }
    
    var formattedDisciplineScore: String {
        String(format: "%.1f%%", overallDisciplineScore * 100)
    }
}

#Preview {
    VStack(spacing: 20) {
        Text("Planet Mark Douglas Engine")
            .font(.title)
            .fontWeight(.bold)
        
        Text("Advanced Trading Psychology Framework")
            .font(.subheadline)
            .foregroundStyle(.secondary)
        
        Text("\"Think in probabilities, not certainties\"")
            .font(.caption)
            .italic()
            .foregroundStyle(.tertiary)
    }
    .padding()
}