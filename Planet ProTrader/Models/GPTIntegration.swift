//
//  GPTIntegration.swift
//  GOLDEX AI
//
//  Created by Goldex AI on 7/19/25.
//

import Foundation
import Combine

// MARK: - GPT Models & Configuration
struct GPTConfiguration {
    static var apiKey: String {
        // Get from UserDefaults or APIConfiguration
        if let data = UserDefaults.standard.data(forKey: "GOLDEX_API_KEYS"),
           let decoded = try? JSONDecoder().decode([String: String].self, from: data) {
            return decoded["openai_key"] ?? ""
        }
        return ""
    }
    static let baseURL = "https://api.openai.com/v1"
    static let model = "gpt-4-turbo-preview"
    static let maxTokens = 4096
}

// MARK: - GPT Request/Response Models
struct GPTRequest: Codable {
    let model: String
    let messages: [GPTMessage]
    let maxTokens: Int
    let temperature: Double
    let stream: Bool
    
    enum CodingKeys: String, CodingKey {
        case model, messages, temperature, stream
        case maxTokens = "max_tokens"
    }
}

struct GPTMessage: Codable {
    let role: String
    let content: String
}

struct GPTResponse: Codable {
    let id: String
    let object: String
    let created: Int
    let model: String
    let choices: [GPTChoice]
    let usage: GPTUsage?
}

struct GPTChoice: Codable {
    let index: Int
    let message: GPTMessage
    let finishReason: String?
    
    enum CodingKeys: String, CodingKey {
        case index, message
        case finishReason = "finish_reason"
    }
}

struct GPTUsage: Codable {
    let promptTokens: Int
    let completionTokens: Int
    let totalTokens: Int
    
    enum CodingKeys: String, CodingKey {
        case promptTokens = "prompt_tokens"
        case completionTokens = "completion_tokens"
        case totalTokens = "total_tokens"
    }
}

// MARK: - GPT Analysis Models
struct GPTMarketAnalysis {
    let sentiment: SharedTypes.MarketSentiment
    let keyPoints: [String]
    let recommendation: String
    let confidence: Double
    let reasoning: String
    let timeframe: String
    let riskLevel: TradingTypes.RiskLevel
}

struct GPTSignalAnalysis {
    let signal: GoldSignal
    let explanation: String
    let reasoning: String
    let keyFactors: [String]
    let riskAssessment: String
    let confidence: Double
    let suggestedAction: String
}

struct GPTNewsAnalysis {
    let sentiment: SharedTypes.MarketSentiment
    let impact: TradingTypes.NewsImpact
    let keyEvents: [String]
    let marketExpectation: String
    let timeHorizon: String
    let confidenceLevel: Double
}

struct GPTRiskAssessment {
    let marketConditions: String
    let recommendedPositionSize: Double
    let stopLossDistance: Double
    let confidenceScore: Double
    let riskLevel: TradingTypes.RiskLevel
    let reasoning: String
}

// MARK: - Main GPT Integration Class
@MainActor
class GPTIntegration: ObservableObject {
    @Published var isLoading = false
    @Published var lastResponse: String = ""
    @Published var errorMessage: String?
    @Published var analysisHistory: [GPTMarketAnalysis] = []
    @Published var chatHistory: [GPTMessage] = []
    
    private let session = URLSession.shared
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Core GPT-4 API Call
    private func callGPT4(messages: [GPTMessage]) async throws -> GPTResponse {
        guard let url = URL(string: "\(GPTConfiguration.baseURL)/chat/completions") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(GPTConfiguration.apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let gptRequest = GPTRequest(
            model: GPTConfiguration.model,
            messages: messages,
            maxTokens: GPTConfiguration.maxTokens,
            temperature: 0.7,
            stream: false
        )
        
        request.httpBody = try JSONEncoder().encode(gptRequest)
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        if httpResponse.statusCode != 200 {
            let errorString = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw NSError(domain: "GPTError", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorString])
        }
        
        return try JSONDecoder().decode(GPTResponse.self, from: data)
    }
    
    // MARK: - Market Analysis with GPT-4
    func analyzeMarketConditions(currentPrice: Double, marketData: TradingTypes.GoldMarketData) async -> GPTMarketAnalysis? {
        isLoading = true
        defer { isLoading = false }
        
        let prompt = """
        GOLDEX GPT-4 TRADING ORACLE
        
        As an elite gold trading analyst, analyze the current market conditions:
        
        CURRENT MARKET DATA:
        • Gold Price: $\(currentPrice)
        • Trend: \(marketData.trend.rawValue)
        • Volume: \(marketData.volume)
        • Support: $\(marketData.supportLevel)
        • Resistance: $\(marketData.resistanceLevel)
        • RSI: \(marketData.rsi)
        • MACD: \(marketData.macd)
        
        PROVIDE ANALYSIS IN THIS FORMAT:
        SENTIMENT: [Bullish/Bearish/Neutral]
        CONFIDENCE: [0.0-1.0]
        TIMEFRAME: [Short/Medium/Long-term]
        RISK_LEVEL: [Low/Medium/High/Critical]
        
        KEY_POINTS:
        • Point 1
        • Point 2 
        • Point 3
        
        RECOMMENDATION:
        [Detailed trading recommendation]
        
        REASONING:
        [Deep analysis of why this recommendation makes sense]
        
        Focus on smart money concepts, institutional behavior, and market structure.
        """
        
        let messages = [
            GPTMessage(role: "system", content: "You are an elite gold trading analyst with deep expertise in smart money concepts, market structure, and institutional trading patterns."),
            GPTMessage(role: "user", content: prompt)
        ]
        
        do {
            let response = try await callGPT4(messages: messages)
            let content = response.choices.first?.message.content ?? ""
            lastResponse = content
            
            // Parse the response into structured analysis
            let analysis = parseMarketAnalysis(content: content, marketData: marketData)
            analysisHistory.append(analysis)
            
            return analysis
        } catch {
            errorMessage = "GPT-4 Analysis Failed: \(error.localizedDescription)"
            return nil
        }
    }
    
    // MARK: - Signal Analysis with GPT-4
    func analyzeSignal(_ signal: GoldSignal) async -> GPTSignalAnalysis? {
        isLoading = true
        defer { isLoading = false }
        
        let prompt = """
        GOLDEX SIGNAL ANALYSIS
        
        Analyze this gold trading signal with your expert knowledge:
        
        SIGNAL DETAILS:
        • Type: \(signal.type.rawValue)
        • Entry Price: $\(signal.entryPrice)
        • Stop Loss: $\(signal.stopLoss)
        • Take Profit: $\(signal.takeProfit)
        • Confidence: \(signal.confidence)%
        • Timeframe: \(signal.timeframe.rawValue)
        • Risk-Reward: \(signal.riskRewardRatio):1
        
        PROVIDE DETAILED ANALYSIS:
        1. Signal Quality Assessment
        2. Key Technical Factors
        3. Risk Assessment
        4. Probability of Success
        5. Suggested Position Size
        6. Market Context
        
        Use smart money concepts and institutional trading wisdom.
        """
        
        let messages = [
            GPTMessage(role: "system", content: "You are a master gold trader specializing in signal analysis and risk management. Provide detailed, actionable insights."),
            GPTMessage(role: "user", content: prompt)
        ]
        
        do {
            let response = try await callGPT4(messages: messages)
            let content = response.choices.first?.message.content ?? ""
            
            return parseSignalAnalysis(content: content, signal: signal)
        } catch {
            errorMessage = "Signal analysis failed: \(error.localizedDescription)"
            return nil
        }
    }
    
    // MARK: - News Impact Analysis
    func analyzeNews(_ newsItems: [String]) async -> GPTNewsAnalysis? {
        isLoading = true
        defer { isLoading = false }
        
        let newsText = newsItems.joined(separator: "\n• ")
        
        let prompt = """
        GOLDEX NEWS IMPACT ANALYSIS
        
        Analyze how these news events will impact gold prices:
        
        NEWS EVENTS:
        • \(newsText)
        
        PROVIDE ANALYSIS:
        MARKET_SENTIMENT: [Bullish/Bearish/Neutral]
        IMPACT_LEVEL: [Bullish/Bearish/Neutral/Volatile]
        CONFIDENCE: [0.0-1.0]
        TIME_HORIZON: [Immediate/Short-term/Medium-term/Long-term]
        
        KEY_EVENTS:
        • Most impactful event 1
        • Most impactful event 2
        • Most impactful event 3
        
        MARKET_EXPECTATION:
        [What the market is likely expecting]
        
        TRADING_STRATEGY:
        [How to position for these events]
        """
        
        let messages = [
            GPTMessage(role: "system", content: "You are an expert in fundamental analysis and news impact on gold markets. Focus on central bank policies, inflation data, geopolitical events, and USD strength."),
            GPTMessage(role: "user", content: prompt)
        ]
        
        do {
            let response = try await callGPT4(messages: messages)
            let content = response.choices.first?.message.content ?? ""
            lastResponse = content
            
            return parseNewsAnalysis(content: content)
        } catch {
            errorMessage = "News analysis failed: \(error.localizedDescription)"
            return nil
        }
    }
    
    // MARK: - Natural Language Trading Chat
    func chatWithGPT(message: String) async -> String? {
        isLoading = true
        defer { isLoading = false }
        
        // Add user message to history
        let userMessage = GPTMessage(role: "user", content: message)
        chatHistory.append(userMessage)
        
        // System context for trading chat
        let systemMessage = GPTMessage(role: "system", content: """
        You are GOLDEX GPT-4, an elite gold trading assistant. You help with:
        • Trading strategy advice
        • Market analysis
        • Risk management
        • Technical analysis questions
        • Trading psychology
        
        Always provide practical, actionable advice focused on gold trading.
        Keep responses concise but comprehensive.
        """)
        
        // Prepare messages (system + recent chat history)
        var messages = [systemMessage]
        messages.append(contentsOf: chatHistory.suffix(10)) // Keep last 10 messages for context
        
        do {
            let response = try await callGPT4(messages: messages)
            let content = response.choices.first?.message.content ?? ""
            
            // Add assistant response to history
            let assistantMessage = GPTMessage(role: "assistant", content: content)
            chatHistory.append(assistantMessage)
            
            lastResponse = content
            return content
        } catch {
            errorMessage = "Chat failed: \(error.localizedDescription)"
            return nil
        }
    }
    
    // MARK: - Voice Command Processing
    func processVoiceCommand(_ command: String) async -> String? {
        let prompt = """
        Process this voice command for the GOLDEX trading system:
        
        COMMAND: "\(command)"
        
        Interpret the command and provide:
        1. What the user wants to do
        2. Any parameters needed
        3. Suggested action
        4. Confirmation request if needed
        
        Common commands:
        • "Show me gold signals"
        • "What's the market sentiment?"
        • "Analyze current position"
        • "Set stop loss to X"
        • "Enable auto trading"
        """
        
        return await chatWithGPT(message: prompt)
    }
    
    // MARK: - Parsing Functions
    private func parseMarketAnalysis(content: String, marketData: TradingTypes.GoldMarketData) -> GPTMarketAnalysis {
        // Extract key information from GPT response
        let sentiment = extractSentiment(from: content)
        let confidence = extractConfidence(from: content)
        let riskLevel = extractRiskLevel(from: content)
        let keyPoints = extractKeyPoints(from: content)
        let recommendation = extractSection(from: content, section: "RECOMMENDATION")
        let reasoning = extractSection(from: content, section: "REASONING")
        let timeframe = extractSection(from: content, section: "TIMEFRAME")
        
        return GPTMarketAnalysis(
            sentiment: sentiment,
            keyPoints: keyPoints,
            recommendation: recommendation,
            confidence: confidence,
            reasoning: reasoning,
            timeframe: timeframe,
            riskLevel: riskLevel
        )
    }
    
    private func parseSignalAnalysis(content: String, signal: GoldSignal) -> GPTSignalAnalysis {
        let explanation = extractSection(from: content, section: "Signal Quality")
        let reasoning = extractSection(from: content, section: "Market Context")
        let keyFactors = extractKeyPoints(from: content)
        let riskAssessment = extractSection(from: content, section: "Risk Assessment")
        let confidence = extractConfidence(from: content)
        let suggestedAction = extractSection(from: content, section: "Suggested Position")
        
        return GPTSignalAnalysis(
            signal: signal,
            explanation: explanation,
            reasoning: reasoning,
            keyFactors: keyFactors,
            riskAssessment: riskAssessment,
            confidence: confidence,
            suggestedAction: suggestedAction
        )
    }
    
    private func parseNewsAnalysis(content: String) -> GPTNewsAnalysis {
        let sentiment = extractSentiment(from: content)
        let impact = extractImpact(from: content)
        let keyEvents = extractKeyPoints(from: content)
        let marketExpectation = extractSection(from: content, section: "MARKET_EXPECTATION")
        let timeHorizon = extractSection(from: content, section: "TIME_HORIZON")
        let confidence = extractConfidence(from: content)
        
        return GPTNewsAnalysis(
            sentiment: sentiment,
            impact: impact,
            keyEvents: keyEvents,
            marketExpectation: marketExpectation,
            timeHorizon: timeHorizon,
            confidenceLevel: confidence
        )
    }
    
    // MARK: - Helper Extraction Functions
    private func extractSentiment(from content: String) -> SharedTypes.MarketSentiment {
        let lowercased = content.lowercased()
        if lowercased.contains("bullish") {
            return .bullish
        } else if lowercased.contains("bearish") {
            return .bearish
        } else {
            return .neutral
        }
    }
    
    private func extractConfidence(from content: String) -> Double {
        let regex = try? NSRegularExpression(pattern: "confidence[:\\s]*(\\d*\\.?\\d+)", options: .caseInsensitive)
        if let match = regex?.firstMatch(in: content, range: NSRange(content.startIndex..., in: content)),
           let range = Range(match.range(at: 1), in: content) {
            return Double(content[range]) ?? 0.7
        }
        return 0.7
    }
    
    private func extractRiskLevel(from content: String) -> TradingTypes.RiskLevel {
        let lowercased = content.lowercased()
        if lowercased.contains("high") {
            return .high
        } else if lowercased.contains("medium") {
            return .medium
        } else if lowercased.contains("critical") {
            return .critical
        } else {
            return .low
        }
    }
    
    private func extractImpact(from content: String) -> TradingTypes.NewsImpact {
        let lowercased = content.lowercased()
        if lowercased.contains("critical") || lowercased.contains("extreme") || lowercased.contains("major") {
            return .critical
        } else if lowercased.contains("high") || lowercased.contains("significant") {
            return .high
        } else if lowercased.contains("medium") || lowercased.contains("moderate") {
            return .medium
        } else {
            return .low
        }
    }
    
    private func extractKeyPoints(from content: String) -> [String] {
        let lines = content.components(separatedBy: .newlines)
        return lines.filter { $0.trimmingCharacters(in: .whitespaces).hasPrefix("•") }
            .map { $0.trimmingCharacters(in: .whitespaces).dropFirst().trimmingCharacters(in: .whitespaces) }
            .compactMap { String($0) }
    }
    
    private func extractSection(from content: String, section: String) -> String {
        let lines = content.components(separatedBy: .newlines)
        var capturing = false
        var result: [String] = []
        
        for line in lines {
            if line.uppercased().contains(section.uppercased()) {
                capturing = true
                continue
            }
            
            if capturing {
                if line.trimmingCharacters(in: .whitespaces).isEmpty {
                    break
                }
                if line.uppercased().contains(":") && !line.contains(section) {
                    break
                }
                result.append(line.trimmingCharacters(in: .whitespaces))
            }
        }
        
        return result.joined(separator: " ").trimmingCharacters(in: .whitespaces)
    }
    
    // MARK: - Utility Functions
    func clearHistory() {
        chatHistory.removeAll()
        analysisHistory.removeAll()
    }
    
    func getAnalysisSummary() -> String {
        guard !analysisHistory.isEmpty else {
            return "No analysis history available"
        }
        
        let recent = analysisHistory.suffix(5)
        let avgConfidence = recent.map(\.confidence).reduce(0, +) / Double(recent.count)
        let sentiments = recent.map(\.sentiment.rawValue).joined(separator: ", ")
        
        return """
        Recent Analysis Summary:
        • Analyses: \(recent.count)
        • Avg Confidence: \(String(format: "%.1f", avgConfidence * 100))%
        • Sentiments: \(sentiments)
        """
    }
}