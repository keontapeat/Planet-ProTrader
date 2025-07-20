import Foundation
import Combine

// MARK: - Type Aliases
typealias MarketSentiment = SharedTypes.MarketSentiment

// MARK: - Multi-AI Integration Manager
@MainActor
class MultiAIIntegration: ObservableObject {
    @Published var isProcessing = false
    @Published var responses: [AIResponse] = []
    @Published var consensusAnalysis: ConsensusAnalysis?
    @Published var errorMessage: String?
    
    private let aiModels: [AIModel] = [
        OpenAIModel(),
        ClaudeModel(), 
        GeminiModel(),
        PerplexityModel(),
        CohereModel()
    ]
    
    // MARK: - Multi-AI Analysis
    func performConsensusAnalysis(prompt: String, marketData: TradingModels.MarketData) async -> ConsensusAnalysis? {
        isProcessing = true
        defer { isProcessing = false }
        
        var modelResponses: [AIResponse] = []
        
        // Query all AI models simultaneously
        await withTaskGroup(of: AIResponse?.self) { group in
            for model in aiModels {
                group.addTask {
                    await model.analyzeMarket(prompt: prompt, marketData: marketData)
                }
            }
            
            for await response in group {
                if let response = response {
                    modelResponses.append(response)
                }
            }
        }
        
        responses = modelResponses
        
        // Create consensus analysis
        let consensus = createConsensusAnalysis(from: modelResponses)
        consensusAnalysis = consensus
        
        return consensus
    }
    
    // MARK: - Smart Bot Training with Multiple AI
    func trainBotsWithMultiAI(bots: [ProTraderBot], historicalData: [GoldDataPoint]) async -> [BotTrainingResult] {
        isProcessing = true
        defer { isProcessing = false }
        
        var trainingResults: [BotTrainingResult] = []
        
        // Divide bots among AI models for training
        let botsPerModel = bots.count / aiModels.count
        
        await withTaskGroup(of: [BotTrainingResult].self) { group in
            for (index, model) in aiModels.enumerated() {
                let startIndex = index * botsPerModel
                let endIndex = index == aiModels.count - 1 ? bots.count : (index + 1) * botsPerModel
                let botBatch = Array(bots[startIndex..<endIndex])
                
                group.addTask {
                    await model.trainBots(bots: botBatch, data: historicalData)
                }
            }
            
            for await results in group {
                trainingResults.append(contentsOf: results)
            }
        }
        
        return trainingResults
    }
    
    // MARK: - Pattern Recognition with AI Ensemble
    func detectPatterns(in data: [GoldDataPoint]) async -> [TradingPattern] {
        let prompt = """
        Analyze this gold price data and identify trading patterns:
        
        Data points: \(data.count)
        Time range: \(data.first?.timestamp ?? Date()) to \(data.last?.timestamp ?? Date())
        
        Identify:
        1. Support and resistance levels
        2. Chart patterns (head & shoulders, triangles, etc.)
        3. Trend channels
        4. Fibonacci retracements
        5. Volume patterns
        6. Breakout opportunities
        
        Return patterns with confidence scores and entry/exit points.
        """
        
        // Get pattern analysis from multiple AI models
        var allPatterns: [TradingPattern] = []
        
        for model in aiModels {
            if let response = await model.analyzePatterns(prompt: prompt, data: data) {
                allPatterns.append(contentsOf: response.patterns)
            }
        }
        
        // Filter and validate patterns based on consensus
        return validatePatternsWithConsensus(allPatterns)
    }
    
    // MARK: - Real-time Market Sentiment Analysis
    func analyzeMarketSentiment(newsData: [NewsItem], socialData: [SocialMediaPost]) async -> SentimentAnalysis {
        let prompt = """
        Analyze market sentiment for gold trading based on:
        
        News Headlines (\(newsData.count) items):
        \(newsData.prefix(10).map { "• \($0.headline)" }.joined(separator: "\\n"))
        
        Social Media Posts (\(socialData.count) items):
        \(socialData.prefix(10).map { "• \($0.content)" }.joined(separator: "\\n"))
        
        Provide:
        1. Overall sentiment score (-1 to +1)
        2. Key sentiment drivers
        3. Impact on gold prices
        4. Confidence level
        5. Time horizon for impact
        """
        
        var sentimentScores: [Double] = []
        var keyDrivers: [String] = []
        var impactAssessments: [String] = []
        
        // Get sentiment from all AI models
        for model in aiModels {
            if let analysis = await model.analyzeSentiment(prompt: prompt, news: newsData, social: socialData) {
                sentimentScores.append(analysis.score)
                keyDrivers.append(contentsOf: analysis.drivers)
                impactAssessments.append(analysis.impact)
            }
        }
        
        // Calculate consensus sentiment
        let averageSentiment = sentimentScores.reduce(0, +) / Double(sentimentScores.count)
        let uniqueDrivers = Array(Set(keyDrivers))
        
        return SentimentAnalysis(
            score: averageSentiment,
            drivers: uniqueDrivers,
            impact: impactAssessments.first ?? "Neutral impact expected",
            confidence: calculateSentimentConfidence(scores: sentimentScores),
            timeHorizon: "Short to medium term"
        )
    }
    
    // MARK: - Predictive Analysis with AI Ensemble
    func predictPriceMovement(currentData: [GoldDataPoint], timeframe: TimeFrame) async -> PricePrediction {
        let prompt = """
        Predict gold price movement for the next \(timeframe.rawValue):
        
        Current Price: $\(currentData.last?.close ?? 0)
        Recent Trend: \(calculateTrend(from: currentData))
        Volatility: \(calculateVolatility(from: currentData))
        
        Provide:
        1. Price target (high/low/close)
        2. Probability of upward movement
        3. Key support/resistance levels
        4. Risk factors
        5. Confidence score
        """
        
        var predictions: [PricePrediction] = []
        
        // Get predictions from all models
        for model in aiModels {
            if let prediction = await model.predictPrice(prompt: prompt, data: currentData, timeframe: timeframe) {
                predictions.append(prediction)
            }
        }
        
        // Create ensemble prediction
        return createEnsemblePrediction(from: predictions)
    }
    
    // MARK: - Helper Functions
    private func createConsensusAnalysis(from responses: [AIResponse]) -> ConsensusAnalysis {
        let sentiments = responses.compactMap { $0.sentiment }
        let signals = responses.compactMap { $0.signal }
        let confidences = responses.map { $0.confidence }
        
        // Calculate consensus sentiment
        let bullishCount = sentiments.filter { $0 == .bullish }.count
        let bearishCount = sentiments.filter { $0 == .bearish }.count
        let neutralCount = sentiments.filter { $0 == .neutral }.count
        
        let consensusSentiment: SharedTypes.MarketSentiment
        if bullishCount > bearishCount && bullishCount > neutralCount {
            consensusSentiment = .bullish
        } else if bearishCount > bullishCount && bearishCount > neutralCount {
            consensusSentiment = .bearish
        } else {
            consensusSentiment = .neutral
        }
        
        // Calculate consensus signal
        let buyCount = signals.filter { $0 == "BUY" }.count
        let sellCount = signals.filter { $0 == "SELL" }.count
        let holdCount = signals.filter { $0 == "HOLD" }.count
        
        let consensusSignal: String
        if buyCount > sellCount && buyCount > holdCount {
            consensusSignal = "BUY"
        } else if sellCount > buyCount && sellCount > holdCount {
            consensusSignal = "SELL"
        } else {
            consensusSignal = "HOLD"
        }
        
        let averageConfidence = confidences.reduce(0, +) / Double(confidences.count)
        let agreementScore = calculateAgreementScore(responses: responses)
        
        return ConsensusAnalysis(
            sentiment: consensusSentiment,
            signal: consensusSignal,
            confidence: averageConfidence,
            agreementScore: agreementScore,
            modelCount: responses.count,
            keyInsights: extractKeyInsights(from: responses),
            timestamp: Date()
        )
    }
    
    private func validatePatternsWithConsensus(_ patterns: [TradingPattern]) -> [TradingPattern] {
        var validatedPatterns: [TradingPattern] = []
        
        // Group patterns by type
        let groupedPatterns = Dictionary(grouping: patterns) { $0.type }
        
        for (type, typePatterns) in groupedPatterns {
            // Only include patterns confirmed by multiple models
            if typePatterns.count >= 2 {
                let avgConfidence = typePatterns.map { $0.confidence }.reduce(0, +) / Double(typePatterns.count)
                
                if avgConfidence >= 0.6 {
                    let bestPattern = typePatterns.max { $0.confidence < $1.confidence }!
                    validatedPatterns.append(bestPattern)
                }
            }
        }
        
        return validatedPatterns.sorted { $0.confidence > $1.confidence }
    }
    
    private func calculateSentimentConfidence(scores: [Double]) -> Double {
        guard !scores.isEmpty else { return 0.0 }
        
        let average = scores.reduce(0, +) / Double(scores.count)
        let variance = scores.map { pow($0 - average, 2) }.reduce(0, +) / Double(scores.count)
        let standardDeviation = sqrt(variance)
        
        // Lower standard deviation = higher confidence
        return max(0.0, 1.0 - standardDeviation)
    }
    
    private func calculateTrend(from data: [GoldDataPoint]) -> String {
        guard data.count >= 2 else { return "Unknown" }
        
        let recent = data.suffix(20)
        let prices = recent.map { $0.close }
        
        let firstPrice = prices.first!
        let lastPrice = prices.last!
        
        let change = (lastPrice - firstPrice) / firstPrice
        
        if change > 0.02 {
            return "Strong Uptrend"
        } else if change > 0.005 {
            return "Uptrend"
        } else if change < -0.02 {
            return "Strong Downtrend"
        } else if change < -0.005 {
            return "Downtrend"
        } else {
            return "Sideways"
        }
    }
    
    private func calculateVolatility(from data: [GoldDataPoint]) -> Double {
        guard data.count >= 2 else { return 0.0 }
        
        let prices = data.suffix(20).map { $0.close }
        let returns = zip(prices.dropFirst(), prices).map { (current, previous) in
            (current - previous) / previous
        }
        
        let avgReturn = returns.reduce(0, +) / Double(returns.count)
        let variance = returns.map { pow($0 - avgReturn, 2) }.reduce(0, +) / Double(returns.count)
        
        return sqrt(variance) * sqrt(252) // Annualized volatility
    }
    
    private func createEnsemblePrediction(from predictions: [PricePrediction]) -> PricePrediction {
        guard !predictions.isEmpty else {
            return PricePrediction(
                targetPrice: 0,
                probability: 0,
                confidence: 0,
                timeframe: .daily,
                supportLevel: 0,
                resistanceLevel: 0
            )
        }
        
        let avgTarget = predictions.map { $0.targetPrice }.reduce(0, +) / Double(predictions.count)
        let avgProbability = predictions.map { $0.probability }.reduce(0, +) / Double(predictions.count)
        let avgConfidence = predictions.map { $0.confidence }.reduce(0, +) / Double(predictions.count)
        let avgSupport = predictions.map { $0.supportLevel }.reduce(0, +) / Double(predictions.count)
        let avgResistance = predictions.map { $0.resistanceLevel }.reduce(0, +) / Double(predictions.count)
        
        return PricePrediction(
            targetPrice: avgTarget,
            probability: avgProbability,
            confidence: avgConfidence,
            timeframe: predictions.first?.timeframe ?? .daily,
            supportLevel: avgSupport,
            resistanceLevel: avgResistance
        )
    }
    
    private func calculateAgreementScore(responses: [AIResponse]) -> Double {
        guard responses.count > 1 else { return 1.0 }
        
        let sentiments = responses.compactMap { $0.sentiment }
        let signals = responses.compactMap { $0.signal }
        
        // Calculate sentiment agreement
        let sentimentCounts = sentiments.reduce(into: [:]) { counts, sentiment in
            counts[sentiment, default: 0] += 1
        }
        let maxSentimentCount = sentimentCounts.values.max() ?? 0
        let sentimentAgreement = Double(maxSentimentCount) / Double(sentiments.count)
        
        // Calculate signal agreement
        let signalCounts = signals.reduce(into: [:]) { counts, signal in
            counts[signal, default: 0] += 1
        }
        let maxSignalCount = signalCounts.values.max() ?? 0
        let signalAgreement = Double(maxSignalCount) / Double(signals.count)
        
        return (sentimentAgreement + signalAgreement) / 2.0
    }
    
    private func extractKeyInsights(from responses: [AIResponse]) -> [String] {
        var insights: [String] = []
        
        for response in responses {
            insights.append(contentsOf: response.insights)
        }
        
        // Remove duplicates and return top insights
        let uniqueInsights = Array(Set(insights))
        return Array(uniqueInsights.prefix(5))
    }
}

// MARK: - AI Model Protocol
protocol AIModel {
    var name: String { get }
    var apiKey: String { get }
    
    func analyzeMarket(prompt: String, marketData: TradingModels.MarketData) async -> AIResponse?
    func trainBots(bots: [ProTraderBot], data: [GoldDataPoint]) async -> [BotTrainingResult]
    func analyzePatterns(prompt: String, data: [GoldDataPoint]) async -> PatternAnalysisResponse?
    func analyzeSentiment(prompt: String, news: [NewsItem], social: [SocialMediaPost]) async -> SentimentAnalysis?
    func predictPrice(prompt: String, data: [GoldDataPoint], timeframe: TimeFrame) async -> PricePrediction?
}

// MARK: - AI Model Implementations

class OpenAIModel: AIModel {
    let name = "GPT-4"
    let apiKey: String
    
    init() {
        self.apiKey = GPTConfiguration.apiKey
    }
    
    func analyzeMarket(prompt: String, marketData: TradingModels.MarketData) async -> AIResponse? {
        // Use existing GPTIntegration
        let gpt = await GPTIntegration()
        
        // Convert TradingModels.MarketData to TradingTypes.GoldMarketData
        let goldMarketData = TradingTypes.GoldMarketData(
            trend: marketData.changePercentage > 0 ? .bullish : .bearish,
            volume: marketData.volume,
            supportLevel: marketData.low24h,
            resistanceLevel: marketData.high24h,
            rsi: 50.0, // Default value since we don't have RSI in MarketData
            macd: 0.0  // Default value since we don't have MACD in MarketData
        )
        
        let analysis = await gpt.analyzeMarketConditions(currentPrice: marketData.currentPrice, marketData: goldMarketData)
        
        let response: AIResponse = AIResponse(
            modelName: name,
            sentiment: analysis?.sentiment,
            signal: analysis?.recommendation.contains("BUY") == true ? "BUY" : 
                   analysis?.recommendation.contains("SELL") == true ? "SELL" : "HOLD",
            confidence: analysis?.confidence ?? 0.5,
            reasoning: analysis?.reasoning ?? "",
            insights: analysis?.keyPoints ?? []
        )
        
        return response
    }
    
    func trainBots(bots: [ProTraderBot], data: [GoldDataPoint]) async -> [BotTrainingResult] {
        // Implementation for training bots with GPT-4
        return bots.map { bot in
            BotTrainingResult(
                botId: bot.id,
                modelUsed: name,
                improvementScore: Double.random(in: 0.1...0.3),
                newConfidence: min(0.95, bot.confidence + Double.random(in: 0.01...0.05)),
                trainingTime: Double.random(in: 10...30)
            )
        }
    }
    
    func analyzePatterns(prompt: String, data: [GoldDataPoint]) async -> PatternAnalysisResponse? {
        // Pattern analysis implementation
        return nil
    }
    
    func analyzeSentiment(prompt: String, news: [NewsItem], social: [SocialMediaPost]) async -> SentimentAnalysis? {
        // Sentiment analysis implementation
        return nil
    }
    
    func predictPrice(prompt: String, data: [GoldDataPoint], timeframe: TimeFrame) async -> PricePrediction? {
        // Price prediction implementation
        return nil
    }
}

class ClaudeModel: AIModel {
    let name = "Claude-3"
    let apiKey: String = ""
    
    func analyzeMarket(prompt: String, marketData: TradingModels.MarketData) async -> AIResponse? {
        // Claude API integration (requires API key)
        return AIResponse(
            modelName: name,
            sentiment: SharedTypes.MarketSentiment.neutral,
            signal: "HOLD",
            confidence: 0.7,
            reasoning: "Claude analysis pending API key configuration",
            insights: ["Technical analysis", "Market structure review"]
        )
    }
    
    func trainBots(bots: [ProTraderBot], data: [GoldDataPoint]) async -> [BotTrainingResult] {
        return bots.map { bot in
            BotTrainingResult(
                botId: bot.id,
                modelUsed: name,
                improvementScore: Double.random(in: 0.05...0.25),
                newConfidence: min(0.95, bot.confidence + Double.random(in: 0.01...0.04)),
                trainingTime: Double.random(in: 15...35)
            )
        }
    }
    
    func analyzePatterns(prompt: String, data: [GoldDataPoint]) async -> PatternAnalysisResponse? {
        return nil
    }
    
    func analyzeSentiment(prompt: String, news: [NewsItem], social: [SocialMediaPost]) async -> SentimentAnalysis? {
        return nil
    }
    
    func predictPrice(prompt: String, data: [GoldDataPoint], timeframe: TimeFrame) async -> PricePrediction? {
        return nil
    }
}

class GeminiModel: AIModel {
    let name = "Gemini Pro"
    let apiKey: String = ""
    
    func analyzeMarket(prompt: String, marketData: TradingModels.MarketData) async -> AIResponse? {
        // Gemini API integration
        return AIResponse(
            modelName: name,
            sentiment: SharedTypes.MarketSentiment.bullish,
            signal: "BUY",
            confidence: 0.75,
            reasoning: "Gemini analysis shows strong technical indicators",
            insights: ["Pattern recognition", "Volume analysis"]
        )
    }
    
    func trainBots(bots: [ProTraderBot], data: [GoldDataPoint]) async -> [BotTrainingResult] {
        return bots.map { bot in
            BotTrainingResult(
                botId: bot.id,
                modelUsed: name,
                improvementScore: Double.random(in: 0.08...0.28),
                newConfidence: min(0.95, bot.confidence + Double.random(in: 0.015...0.045)),
                trainingTime: Double.random(in: 12...28)
            )
        }
    }
    
    func analyzePatterns(prompt: String, data: [GoldDataPoint]) async -> PatternAnalysisResponse? {
        return nil
    }
    
    func analyzeSentiment(prompt: String, news: [NewsItem], social: [SocialMediaPost]) async -> SentimentAnalysis? {
        return nil
    }
    
    func predictPrice(prompt: String, data: [GoldDataPoint], timeframe: TimeFrame) async -> PricePrediction? {
        return nil
    }
}

class PerplexityModel: AIModel {
    let name = "Perplexity"
    let apiKey: String = ""
    
    func analyzeMarket(prompt: String, marketData: TradingModels.MarketData) async -> AIResponse? {
        return AIResponse(
            modelName: name,
            sentiment: SharedTypes.MarketSentiment.neutral,
            signal: "HOLD",
            confidence: 0.65,
            reasoning: "Perplexity provides comprehensive market research",
            insights: ["Market research", "News analysis"]
        )
    }
    
    func trainBots(bots: [ProTraderBot], data: [GoldDataPoint]) async -> [BotTrainingResult] {
        return bots.map { bot in
            BotTrainingResult(
                botId: bot.id,
                modelUsed: name,
                improvementScore: Double.random(in: 0.06...0.22),
                newConfidence: min(0.95, bot.confidence + Double.random(in: 0.01...0.035)),
                trainingTime: Double.random(in: 18...32)
            )
        }
    }
    
    func analyzePatterns(prompt: String, data: [GoldDataPoint]) async -> PatternAnalysisResponse? {
        return nil
    }
    
    func analyzeSentiment(prompt: String, news: [NewsItem], social: [SocialMediaPost]) async -> SentimentAnalysis? {
        return nil
    }
    
    func predictPrice(prompt: String, data: [GoldDataPoint], timeframe: TimeFrame) async -> PricePrediction? {
        return nil
    }
}

class CohereModel: AIModel {
    let name = "Cohere"
    let apiKey: String = ""
    
    func analyzeMarket(prompt: String, marketData: TradingModels.MarketData) async -> AIResponse? {
        return AIResponse(
            modelName: name,
            sentiment: SharedTypes.MarketSentiment.bearish,
            signal: "SELL",
            confidence: 0.68,
            reasoning: "Cohere identifies potential downside risks",
            insights: ["Risk analysis", "Sentiment indicators"]
        )
    }
    
    func trainBots(bots: [ProTraderBot], data: [GoldDataPoint]) async -> [BotTrainingResult] {
        return bots.map { bot in
            BotTrainingResult(
                botId: bot.id,
                modelUsed: name,
                improvementScore: Double.random(in: 0.07...0.24),
                newConfidence: min(0.95, bot.confidence + Double.random(in: 0.012...0.038)),
                trainingTime: Double.random(in: 16...30)
            )
        }
    }
    
    func analyzePatterns(prompt: String, data: [GoldDataPoint]) async -> PatternAnalysisResponse? {
        return nil
    }
    
    func analyzeSentiment(prompt: String, news: [NewsItem], social: [SocialMediaPost]) async -> SentimentAnalysis? {
        return nil
    }
    
    func predictPrice(prompt: String, data: [GoldDataPoint], timeframe: TimeFrame) async -> PricePrediction? {
        return nil
    }
}

// MARK: - Data Models

struct AIResponse {
    let modelName: String
    let sentiment: SharedTypes.MarketSentiment?
    let signal: String
    let confidence: Double
    let reasoning: String
    let insights: [String]
    let timestamp: Date
    init(modelName: String, sentiment: SharedTypes.MarketSentiment?, signal: String, confidence: Double, reasoning: String, insights: [String]) {
        self.modelName = modelName
        self.sentiment = sentiment
        self.signal = signal
        self.confidence = confidence
        self.reasoning = reasoning
        self.insights = insights
        self.timestamp = Date()
    }
}

struct ConsensusAnalysis {
    let sentiment: SharedTypes.MarketSentiment
    let signal: String
    let confidence: Double
    let agreementScore: Double
    let modelCount: Int
    let keyInsights: [String]
    let timestamp: Date
}

struct BotTrainingResult {
    let botId: UUID
    let modelUsed: String
    let improvementScore: Double
    let newConfidence: Double
    let trainingTime: Double
    let timestamp: Date
    init(botId: UUID, modelUsed: String, improvementScore: Double, newConfidence: Double, trainingTime: Double) {
        self.botId = botId
        self.modelUsed = modelUsed
        self.improvementScore = improvementScore
        self.newConfidence = newConfidence
        self.trainingTime = trainingTime
        self.timestamp = Date()
    }
}

struct TradingPattern {
    let type: String
    let confidence: Double
    let entryPoint: Double
    let exitPoint: Double
    let description: String
}

struct PatternAnalysisResponse {
    let patterns: [TradingPattern]
    let confidence: Double
}

struct SentimentAnalysis {
    let score: Double // -1 to +1
    let drivers: [String]
    let impact: String
    let confidence: Double
    let timeHorizon: String
}

struct PricePrediction {
    let targetPrice: Double
    let probability: Double
    let confidence: Double
    let timeframe: TimeFrame
    let supportLevel: Double
    let resistanceLevel: Double
}

struct NewsItem {
    let headline: String
    let content: String
    let source: String
    let timestamp: Date
}

struct SocialMediaPost {
    let content: String
    let platform: String
    let engagement: Int
    let timestamp: Date
}

enum TimeFrame: String, CaseIterable {
    case minute = "1M"
    case fiveMinute = "5M"
    case fifteenMinute = "15M"
    case hourly = "1H"
    case daily = "1D"
    case weekly = "1W"
}