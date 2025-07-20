// 
//  ClaudeAIIntegration.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 7/13/25.
//

import Foundation
import Combine
import SwiftUI

// MARK: - Claude AI Models

struct ClaudeTradeSignal: Identifiable, Codable {
    let id: String
    let timestamp: Date
    let symbol: String
    let direction: SharedTypes.TradeDirection
    let entryPrice: Double
    let stopLoss: Double
    let takeProfit: Double
    let lotSize: Double
    let confidence: Double
    let reasoning: String
    let timeframe: String
    let mode: SharedTypes.TradingMode
    
    init(
        id: String = UUID().uuidString,
        timestamp: Date = Date(),
        symbol: String,
        direction: SharedTypes.TradeDirection,
        entryPrice: Double,
        stopLoss: Double,
        takeProfit: Double,
        lotSize: Double,
        confidence: Double,
        reasoning: String,
        timeframe: String = "1H",
        mode: SharedTypes.TradingMode = .auto
    ) {
        self.id = id
        self.timestamp = timestamp
        self.symbol = symbol
        self.direction = direction
        self.entryPrice = entryPrice
        self.stopLoss = stopLoss
        self.takeProfit = takeProfit
        self.lotSize = lotSize
        self.confidence = confidence
        self.reasoning = reasoning
        self.timeframe = timeframe
        self.mode = mode
    }
    
    var riskRewardRatio: Double {
        let risk = abs(entryPrice - stopLoss)
        let reward = abs(takeProfit - entryPrice)
        return risk > 0 ? reward / risk : 0
    }
    
    var formattedConfidence: String {
        String(format: "%.1f%%", confidence * 100)
    }
}

struct ClaudeTradeLearningData: Codable {
    let id: String
    let patterns: [String]
    let outcomes: [String]
    let accuracy: Double
    let totalTrades: Int
    let winningTrades: Int
    let recentLosses: Int
    let patternPerformance: [String: Double]
    let timePerformance: [String: Double]
    let timestamp: Date
    
    init(
        id: String = UUID().uuidString,
        patterns: [String],
        outcomes: [String],
        accuracy: Double,
        totalTrades: Int,
        winningTrades: Int,
        recentLosses: Int,
        patternPerformance: [String: Double],
        timePerformance: [String: Double],
        timestamp: Date = Date()
    ) {
        self.id = id
        self.patterns = patterns
        self.outcomes = outcomes
        self.accuracy = accuracy
        self.totalTrades = totalTrades
        self.winningTrades = winningTrades
        self.recentLosses = recentLosses
        self.patternPerformance = patternPerformance
        self.timePerformance = timePerformance
        self.timestamp = timestamp
    }
}

struct ClaudeTradeOutcome: Codable {
    let success: Bool
    let profit: Double
    let confidence: Double
    let timestamp: Date
    let tradeId: String
    
    init(
        success: Bool,
        profit: Double,
        confidence: Double,
        timestamp: Date = Date(),
        tradeId: String = UUID().uuidString
    ) {
        self.success = success
        self.profit = profit
        self.confidence = confidence
        self.timestamp = timestamp
        self.tradeId = tradeId
    }
}

enum ClaudeInsightPriority: String, Codable, CaseIterable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    case critical = "Critical"
    
    var color: Color {
        switch self {
        case .low: return .gray
        case .medium: return .blue
        case .high: return .orange
        case .critical: return .red
        }
    }
}

struct ClaudeActionItem: Codable {
    let id: String
    let title: String
    let description: String
    let priority: ClaudeInsightPriority
    let estimatedImpact: Double
    let timestamp: Date
    
    init(
        id: String = UUID().uuidString,
        title: String,
        description: String,
        priority: ClaudeInsightPriority,
        estimatedImpact: Double,
        timestamp: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.priority = priority
        self.estimatedImpact = estimatedImpact
        self.timestamp = timestamp
    }
}

struct ClaudeMarketInsight: Identifiable, Codable {
    let id: String
    let title: String
    let description: String
    let priority: SharedTypes.InsightPriority
    let actionItems: [String]
    let timestamp: Date
    
    init(
        id: String = UUID().uuidString,
        title: String,
        description: String,
        priority: SharedTypes.InsightPriority,
        actionItems: [String],
        timestamp: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.priority = priority
        self.actionItems = actionItems
        self.timestamp = timestamp
    }
}

struct ClaudePlaybookTrade: Codable {
    let id: String
    let symbol: String
    let direction: SharedTypes.TradeDirection
    let entryPrice: Double
    let exitPrice: Double
    let lotSize: Double
    let profit: Double
    let grade: SharedTypes.TradeGrade
    let reasoning: String
    let timestamp: Date
    let success: Bool
    
    init(
        id: String = UUID().uuidString,
        symbol: String,
        direction: SharedTypes.TradeDirection,
        entryPrice: Double,
        exitPrice: Double,
        lotSize: Double,
        profit: Double,
        grade: SharedTypes.TradeGrade,
        reasoning: String,
        timestamp: Date = Date(),
        success: Bool? = nil
    ) {
        self.id = id
        self.symbol = symbol
        self.direction = direction
        self.entryPrice = entryPrice
        self.exitPrice = exitPrice
        self.lotSize = lotSize
        self.profit = profit
        self.grade = grade
        self.reasoning = reasoning
        self.timestamp = timestamp
        self.success = success ?? (profit > 0)
    }
}

// MARK: - Flip Mode Support Types
struct FlipMarketConditions {
    let direction: SharedTypes.TradeDirection
    let entryPrice: Double
    let confidence: Double
    let reasoning: String
}

struct ClaudeFlipTradeLog {
    let id: String
    let flipId: String
    let accountId: String
    let signal: SharedTypes.AutoTradingSignal
    let tradeResult: SharedTypes.SharedTradeResult
    let timestamp: Date
}

// MARK: - Claude AI Integration Manager

@MainActor
class ClaudeAIIntegration: ObservableObject {
    @Published var signals: [ClaudeTradeSignal] = []
    @Published var learningData: ClaudeTradeLearningData?
    @Published var insights: [ClaudeMarketInsight] = []
    @Published var isAnalyzing: Bool = false
    @Published var lastAnalysis: Date?
    @Published var confidence: Double = 0.75
    @Published var tradeHistory: [SharedTypes.ClaudeTradeData] = []
    
    private let apiKey: String
    private let baseURL = "https://api.anthropic.com/v1"
    private var cancellables = Set<AnyCancellable>()
    
    init(apiKey: String = "your_claude_api_key") {
        self.apiKey = apiKey
        setupPeriodicAnalysis()
    }
    
    // MARK: - Market Analysis
    
    func analyzeMarketConditions() async throws -> [ClaudeTradeSignal] {
        isAnalyzing = true
        defer { isAnalyzing = false }
        
        // Simulated analysis for demo purposes
        try await Task.sleep(for: .seconds(2))
        
        let generatedSignals = generateMockSignals()
        
        DispatchQueue.main.async {
            self.signals = generatedSignals
            self.lastAnalysis = Date()
        }
        
        return generatedSignals
    }
    
    private func generateMockSignals() -> [ClaudeTradeSignal] {
        let symbols = ["XAUUSD", "EURUSD", "GBPUSD", "USDJPY", "AUDUSD"]
        let timeframes = ["5M", "15M", "1H", "4H"]
        
        return (0..<Int.random(in: 2...5)).map { _ in
            let symbol = symbols.randomElement()!
            let direction: SharedTypes.TradeDirection = Bool.random() ? .buy : .sell
            let basePrice = getMarketPrice(for: symbol)
            let confidence = Double.random(in: 0.65...0.95)
            
            return ClaudeTradeSignal(
                symbol: symbol,
                direction: direction,
                entryPrice: basePrice,
                stopLoss: direction == .buy ? basePrice - 5.0 : basePrice + 5.0,
                takeProfit: direction == .buy ? basePrice + 10.0 : basePrice - 10.0,
                lotSize: Double.random(in: 0.1...1.0),
                confidence: confidence,
                reasoning: generateTradeReasoning(symbol: symbol, direction: direction),
                timeframe: timeframes.randomElement()!,
                mode: .auto
            )
        }
    }
    
    private func getMarketPrice(for symbol: String) -> Double {
        switch symbol {
        case "XAUUSD": return Double.random(in: 1900...2100)
        case "EURUSD": return Double.random(in: 1.05...1.15)
        case "GBPUSD": return Double.random(in: 1.20...1.30)
        case "USDJPY": return Double.random(in: 140...155)
        case "AUDUSD": return Double.random(in: 0.65...0.75)
        default: return 1.0
        }
    }
    
    private func generateTradeReasoning(symbol: String, direction: SharedTypes.TradeDirection) -> String {
        let reasons = [
            "Strong technical breakout pattern detected with high volume confirmation",
            "Multiple timeframe confluence showing \(direction.displayName.lowercased()) momentum",
            "Key support/resistance level approached with price action confirmation",
            "RSI divergence indicating potential reversal opportunity",
            "Market structure shift favoring \(direction.displayName.lowercased()) positions",
            "Institutional order flow showing accumulation patterns",
            "Fibonacci retracement level holding with rejection candles"
        ]
        return reasons.randomElement()!
    }
    
    // MARK: - Learning System
    
    func updateLearningData(trades: [SharedTypes.ClaudeTradeData]) async {
        guard !trades.isEmpty else { return }
        
        let patterns = extractTradePatterns(from: trades)
        let outcomes = trades.map { $0.success ? "WIN" : "LOSS" }
        let accuracy = Double(trades.filter { $0.success }.count) / Double(trades.count)
        
        let patternPerformance = calculatePatternPerformance(trades: trades, patterns: patterns)
        let timePerformance = calculateTimePerformance(trades: trades)
        
        let learningData = ClaudeTradeLearningData(
            patterns: patterns,
            outcomes: outcomes,
            accuracy: accuracy,
            totalTrades: trades.count,
            winningTrades: trades.filter { $0.success }.count,
            recentLosses: trades.suffix(10).filter { !$0.success }.count,
            patternPerformance: patternPerformance,
            timePerformance: timePerformance
        )
        
        DispatchQueue.main.async {
            self.learningData = learningData
            self.confidence = min(0.95, max(0.5, accuracy))
        }
    }
    
    private func extractTradePatterns(from trades: [SharedTypes.ClaudeTradeData]) -> [String] {
        // Extract common patterns from trade data
        let patterns = [
            "Breakout Pattern",
            "Reversal Pattern",
            "Continuation Pattern",
            "Support/Resistance Test",
            "Momentum Trade",
            "Mean Reversion",
            "Trend Following"
        ]
        return Array(patterns.shuffled().prefix(Int.random(in: 3...5)))
    }
    
    private func calculatePatternPerformance(trades: [SharedTypes.ClaudeTradeData], patterns: [String]) -> [String: Double] {
        var performance: [String: Double] = [:]
        
        for pattern in patterns {
            let patternTrades = trades.filter { _ in Bool.random() } // Simulate pattern matching
            if !patternTrades.isEmpty {
                let winRate = Double(patternTrades.filter { $0.success }.count) / Double(patternTrades.count)
                performance[pattern] = winRate
            }
        }
        
        return performance
    }
    
    private func calculateTimePerformance(trades: [SharedTypes.ClaudeTradeData]) -> [String: Double] {
        var hourlyPerformance: [String: Double] = [:]
        
        // Initialize hourly buckets
        for hour in 0..<24 {
            let hourKey = String(format: "%02d:00", hour)
            hourlyPerformance[hourKey] = 0.0
        }
        
        // Aggregate performance by hour
        for trade in trades {
            let hour = Calendar.current.component(.hour, from: trade.timestamp)
            let hourKey = String(format: "%02d:00", hour)
            hourlyPerformance[hourKey]! += trade.profit
        }
        
        return hourlyPerformance
    }
    
    // MARK: - Advanced Analytics
    
    func generateAdvancedInsights(trades: [SharedTypes.ClaudeTradeData]) async -> [ClaudeMarketInsight] {
        guard !trades.isEmpty else { return [] }
        
        let patterns = await analyzeAdvancedPatterns(trades: trades)
        let recommendations = generateActionRecommendations(patterns: patterns)
        
        let insight = ClaudeMarketInsight(
            title: "Advanced Market Analysis",
            description: "AI-powered insights based on recent trading patterns and market behavior",
            priority: determinePriority(patterns),
            actionItems: recommendations.map { $0.title }
        )
        
        DispatchQueue.main.async {
            self.insights = [insight]
        }
        
        return [insight]
    }
    
    private func analyzeAdvancedPatterns(trades: [SharedTypes.ClaudeTradeData]) async -> [String] {
        // Simulate advanced pattern analysis
        try? await Task.sleep(for: .seconds(1))
        
        let scalpTrades = trades.filter { trade in
            abs(trade.profit) < 50
        }
        let swingTrades = trades.filter { trade in
            abs(trade.profit) >= 50
        }
        
        var patterns: [String] = []
        
        if scalpTrades.count > swingTrades.count {
            patterns.append("Scalping dominance detected")
        } else {
            patterns.append("Swing trading preference identified")
        }
        
        let winningTrades = trades.filter { $0.success }
        let losingTrades = trades.filter { !$0.success }
        
        if !winningTrades.isEmpty && !losingTrades.isEmpty {
            patterns.append("Mixed performance requiring strategy adjustment")
        }
        
        return patterns
    }
    
    private func extractConfluenceFactors(_ reasoning: String) -> [String] {
        let factors = [
            "Technical breakout",
            "Volume confirmation",
            "Support/resistance level",
            "Fibonacci level",
            "Moving average confluence",
            "RSI divergence",
            "Price action signal"
        ]
        
        return factors.filter { reasoning.lowercased().contains($0.lowercased().components(separatedBy: " ").first ?? "") }
    }
    
    private func generateActionRecommendations(patterns: [String]) -> [ClaudeActionItem] {
        let recommendations = [
            ClaudeActionItem(
                title: "Optimize Risk Management",
                description: "Implement dynamic position sizing based on market volatility",
                priority: .high,
                estimatedImpact: 0.85
            ),
            ClaudeActionItem(
                title: "Enhance Entry Timing",
                description: "Wait for additional confluence factors before trade execution",
                priority: .medium,
                estimatedImpact: 0.70
            ),
            ClaudeActionItem(
                title: "Diversify Trading Pairs",
                description: "Expand to correlated pairs for better risk distribution",
                priority: .medium,
                estimatedImpact: 0.60
            )
        ]
        
        return Array(recommendations.shuffled().prefix(Int.random(in: 2...3)))
    }
    
    private func determinePriority(_ patterns: [String]) -> SharedTypes.InsightPriority {
        if patterns.contains(where: { $0.lowercased().contains("loss") || $0.lowercased().contains("risk") }) {
            return .high
        } else if patterns.contains(where: { $0.lowercased().contains("optimize") || $0.lowercased().contains("improve") }) {
            return .medium
        } else {
            return .low
        }
    }
    
    // MARK: - Auto Trading Execution
    
    func executeAutoTrading() async {
        guard let recentSignals = signals.prefix(3) as? [ClaudeTradeSignal], !recentSignals.isEmpty else {
            return
        }
        
        for signal in recentSignals where signal.confidence > 0.8 {
            do {
                let result = await executeSignal(signal)
                await recordTradeExecution(signal: signal, result: result)
            } catch {
                print("Failed to execute signal \(signal.id): \(error)")
            }
        }
    }
    
    private func executeSignal(_ signal: ClaudeTradeSignal) async -> SharedTypes.SharedTradeResult {
        // Simulate trade execution
        try? await Task.sleep(for: .seconds(Double.random(in: 0.5...2.0)))
        
        let success = Double.random(in: 0...1) < signal.confidence
        let profit = success ? Double.random(in: 10...100) : -Double.random(in: 5...50)
        
        return SharedTypes.SharedTradeResult(
            success: success,
            tradeId: signal.id,
            profit: profit,
            message: success ? "Trade executed successfully" : "Trade closed at loss"
        )
    }
    
    private func recordTradeExecution(signal: ClaudeTradeSignal, result: SharedTypes.SharedTradeResult) async {
        let tradeData = SharedTypes.ClaudeTradeData(
            id: signal.id,
            symbol: signal.symbol,
            direction: signal.direction,
            entryPrice: signal.entryPrice,
            exitPrice: result.success ? signal.takeProfit : signal.stopLoss,
            lotSize: signal.lotSize,
            profit: result.profit,
            timestamp: Date(),
            success: result.success
        )
        
        DispatchQueue.main.async {
            self.tradeHistory.append(tradeData)
        }
        
        // Update learning data with new trade
        await updateLearningData(trades: tradeHistory)
    }
    
    // MARK: - Continuous Learning
    
    func implementContinuousLearning() async {
        for actionItem in getAllActionItems() {
            await implementActionItem(actionItem.title)
        }
    }
    
    private func getAllActionItems() -> [ClaudeActionItem] {
        return insights.flatMap { insight in
            insight.actionItems.map { actionTitle in
                ClaudeActionItem(
                    title: actionTitle,
                    description: "Implementation of \(actionTitle)",
                    priority: .medium,
                    estimatedImpact: 0.7
                )
            }
        }
    }
    
    private func implementActionItem(_ actionItem: String) async {
        // Simulate action item implementation
        try? await Task.sleep(for: .seconds(1))
        
        // Update system parameters based on action item
        switch actionItem.lowercased() {
        case let item where item.contains("risk"):
            confidence = min(0.95, confidence + 0.05)
        case let item where item.contains("timing"):
            confidence = min(0.95, confidence + 0.03)
        case let item where item.contains("diversify"):
            confidence = min(0.95, confidence + 0.02)
        default:
            confidence = min(0.95, confidence + 0.01)
        }
    }
    
    // MARK: - Performance Analysis
    
    func analyzePerformance() async -> SharedTypes.PerformanceMetrics {
        guard !tradeHistory.isEmpty else {
            return SharedTypes.PerformanceMetrics(
                totalTrades: 0,
                winRate: 0,
                totalProfit: 0,
                averageWin: 0,
                averageLoss: 0,
                profitFactor: 1.0
            )
        }
        
        let totalTrades = tradeHistory.count
        let winningTrades = tradeHistory.filter { $0.success }
        let losingTrades = tradeHistory.filter { !$0.success }
        
        let winRate = Double(winningTrades.count) / Double(totalTrades)
        let totalProfit = tradeHistory.map { $0.profit }.reduce(0, +)
        let averageWin = winningTrades.isEmpty ? 0.0 : winningTrades.map { $0.profit }.reduce(0, +) / Double(winningTrades.count)
        let averageLoss = losingTrades.isEmpty ? 0.0 : abs(losingTrades.map { $0.profit }.reduce(0, +)) / Double(losingTrades.count)
        
        let grossProfit = winningTrades.map { $0.profit }.reduce(0, +)
        let grossLoss = abs(losingTrades.map { $0.profit }.reduce(0, +))
        let profitFactor = grossLoss > 0 ? grossProfit / grossLoss : (grossProfit > 0 ? 999.0 : 1.0)
        
        return SharedTypes.PerformanceMetrics(
            totalTrades: totalTrades,
            winRate: winRate,
            totalProfit: totalProfit,
            averageWin: averageWin,
            averageLoss: averageLoss,
            profitFactor: profitFactor
        )
    }
    
    // MARK: - Adaptive Strategy
    
    func adaptTradingStrategy(based outcome: ClaudeTradeOutcome) async {
        // Adjust strategy based on recent outcomes
        if outcome.success && outcome.profit > 100 {
            // Successful large trade - maintain current approach
            confidence = min(0.95, confidence + 0.02)
        } else if !outcome.success && outcome.profit < -75 {
            // Significant loss - reduce confidence and adjust
            confidence = max(0.5, confidence - 0.05)
            
            // Implement more conservative approach
            await implementConservativeStrategy()
        }
        
        // Update learning data with new outcome
        let newTradeData = SharedTypes.ClaudeTradeData(
            id: outcome.tradeId,
            symbol: "XAUUSD", // Default for outcome tracking
            direction: .buy, // Default
            entryPrice: 2000.0, // Placeholder
            exitPrice: outcome.success ? 2010.0 : 1995.0,
            lotSize: 1.0,
            profit: outcome.profit,
            timestamp: outcome.timestamp,
            success: outcome.success
        )
        
        DispatchQueue.main.async {
            self.tradeHistory.append(newTradeData)
        }
        
        await updateLearningData(trades: tradeHistory)
    }
    
    private func implementConservativeStrategy() async {
        // Reduce position sizes and increase confirmation requirements
        try? await Task.sleep(for: .seconds(0.5))
        
        // This would adjust internal parameters for more conservative trading
        confidence = max(0.6, confidence)
    }
    
    // MARK: - Playbook Integration
    
    func generatePlaybookTrades() async -> [ClaudePlaybookTrade] {
        let trades = Array(tradeHistory.suffix(20)) // Get recent trades
        
        let winningTrades = trades.filter { $0.success }
        
        return winningTrades.prefix(10).map { trade in
            ClaudePlaybookTrade(
                symbol: trade.symbol,
                direction: trade.direction,
                entryPrice: trade.entryPrice,
                exitPrice: trade.exitPrice,
                lotSize: trade.lotSize,
                profit: trade.profit,
                grade: determineTradeGrade(profit: trade.profit),
                reasoning: generatePlaybookReasoning(trade: trade)
            )
        }
    }
    
    private func determineTradeGrade(profit: Double) -> SharedTypes.TradeGrade {
        switch profit {
        case 100...: return .elite
        case 50..<100: return .good
        case 25..<50: return .average
        default: return .poor
        }
    }
    
    private func generatePlaybookReasoning(trade: SharedTypes.ClaudeTradeData) -> String {
        let reasoningTemplates = [
            "Perfect execution of \(trade.direction.displayName.lowercased()) setup with optimal entry timing",
            "Strong technical confluence led to high-probability \(trade.direction.displayName.lowercased()) opportunity",
            "Market structure supported \(trade.direction.displayName.lowercased()) momentum with clear risk management",
            "Multiple timeframe alignment confirmed \(trade.direction.displayName.lowercased()) bias execution"
        ]
        return reasoningTemplates.randomElement()!
    }
    
    // MARK: - Periodic Analysis
    
    private func setupPeriodicAnalysis() {
        Timer.publish(every: 300, on: .main, in: .common) // Every 5 minutes
            .autoconnect()
            .sink { [weak self] _ in
                Task { @MainActor in
                    try? await self?.analyzeMarketConditions()
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Demo Data Generation
    
    func loadDemoData() {
        let demoSignals = generateMockSignals()
        let demoTrades = generateDemoTrades()
        
        DispatchQueue.main.async {
            self.signals = demoSignals
            self.tradeHistory = demoTrades
            self.confidence = 0.82
            self.lastAnalysis = Date()
        }
        
        Task {
            await updateLearningData(trades: demoTrades)
            let _ = await generateAdvancedInsights(trades: demoTrades)
        }
    }
    
    private func generateDemoTrades() -> [SharedTypes.ClaudeTradeData] {
        let symbols = ["XAUUSD", "EURUSD", "GBPUSD", "USDJPY"]
        let directions: [SharedTypes.TradeDirection] = [.buy, .sell]
        
        return (0..<50).map { i in
            let symbol = symbols.randomElement()!
            let direction = directions.randomElement()!
            let entryPrice = getMarketPrice(for: symbol)
            let success = Double.random(in: 0...1) < 0.7 // 70% win rate for demo
            let profit = success ? Double.random(in: 15...150) : -Double.random(in: 10...80)
            let exitPrice = entryPrice + (profit / 100.0) // Simplified calculation
            
            return SharedTypes.ClaudeTradeData(
                id: "demo_\(i)",
                symbol: symbol,
                direction: direction,
                entryPrice: entryPrice,
                exitPrice: exitPrice,
                lotSize: Double.random(in: 0.1...2.0),
                profit: profit,
                timestamp: Date().addingTimeInterval(-Double(i * 3600)), // Hourly intervals
                success: success
            )
        }
    }
    
    // MARK: - Flip Mode Integration
    
    func analyzeMarketForFlip(timeframes: [String], riskLevel: Double, accountBalance: Double) async -> FlipMarketConditions {
        // Simulate market analysis for flip trading
        try? await Task.sleep(for: .seconds(Double.random(in: 0.5...2.0)))
        
        let direction: SharedTypes.TradeDirection = Bool.random() ? .buy : .sell
        let basePrice = getMarketPrice(for: "XAUUSD")
        let confidence = Double.random(in: 0.75...0.95)
        
        return FlipMarketConditions(
            direction: direction,
            entryPrice: basePrice,
            confidence: confidence,
            reasoning: "Flip mode analysis for \(timeframes.first ?? "15M") timeframe"
        )
    }
    
    func learnFromFlipTrade(_ tradeLog: ClaudeFlipTradeLog) async {
        // Learn from flip trade execution
        let tradeData = SharedTypes.ClaudeTradeData(
            id: tradeLog.id,
            symbol: "XAUUSD",
            direction: tradeLog.signal.direction,
            entryPrice: tradeLog.signal.entryPrice,
            exitPrice: tradeLog.signal.takeProfit,
            lotSize: tradeLog.signal.lotSize,
            profit: tradeLog.tradeResult.profit,
            timestamp: tradeLog.timestamp,
            success: tradeLog.tradeResult.success
        )
        
        DispatchQueue.main.async {
            self.tradeHistory.append(tradeData)
        }
        
        await updateLearningData(trades: tradeHistory)
        print("Claude AI learned from flip trade: \(tradeData.success ? "WIN" : "LOSS") (\(tradeData.profit))")
    }
}

// MARK: - Preview Provider

struct ClaudeAIPreview: View {
    @StateObject private var claudeAI = ClaudeAIIntegration()
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 16) {
                    // Signals Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("AI Trading Signals")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        if claudeAI.signals.isEmpty {
                            Text("No signals available")
                                .foregroundColor(.secondary)
                        } else {
                            ForEach(claudeAI.signals.prefix(3)) { signal in
                                SignalCard(signal: signal)
                            }
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    
                    // Learning Data Section
                    if let learningData = claudeAI.learningData {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Learning Analytics")
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("Accuracy:")
                                        .fontWeight(.medium)
                                    Spacer()
                                    Text(String(format: "%.1f%%", learningData.accuracy * 100))
                                        .foregroundColor(.green)
                                }
                                
                                HStack {
                                    Text("Total Trades:")
                                        .fontWeight(.medium)
                                    Spacer()
                                    Text("\(learningData.totalTrades)")
                                }
                                
                                HStack {
                                    Text("Win Rate:")
                                        .fontWeight(.medium)
                                    Spacer()
                                    Text(String(format: "%.1f%%", Double(learningData.winningTrades) / Double(learningData.totalTrades) * 100))
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                    }
                    
                    // Confidence Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("AI Confidence")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        VStack(spacing: 8) {
                            HStack {
                                Text("Current Confidence")
                                Spacer()
                                Text(String(format: "%.1f%%", claudeAI.confidence * 100))
                                    .fontWeight(.medium)
                                    .foregroundColor(.blue)
                            }
                            
                            ProgressView(value: claudeAI.confidence)
                                .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                }
                .padding()
            }
            .navigationTitle("Claude AI Integration")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                claudeAI.loadDemoData()
            }
        }
    }
    
    struct SignalCard: View {
        let signal: ClaudeTradeSignal
        
        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(signal.symbol)
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Label(signal.direction.displayName, systemImage: signal.direction.systemImage)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(signal.direction.color.opacity(0.2))
                        .foregroundColor(signal.direction.color)
                        .cornerRadius(8)
                }
                
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Entry: \(String(format: "%.4f", signal.entryPrice))")
                            .font(.caption)
                        Text("Stop: \(String(format: "%.4f", signal.stopLoss))")
                            .font(.caption)
                            .foregroundColor(.red)
                        Text("Target: \(String(format: "%.4f", signal.takeProfit))")
                            .font(.caption)
                            .foregroundColor(.green)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Confidence")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        Text(signal.formattedConfidence)
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.blue)
                        Text("R:R \(String(format: "%.1f", signal.riskRewardRatio))")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
                
                Text(signal.reasoning)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            .padding(12)
            .background(.regularMaterial)
            .cornerRadius(8)
        }
    }
}

// MARK: - Preview
struct ClaudeAIPreview_Previews: PreviewProvider {
    static var previews: some View {
        ClaudeAIPreview()
    }
}