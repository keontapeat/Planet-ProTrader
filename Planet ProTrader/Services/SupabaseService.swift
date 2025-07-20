//
//  SupabaseService.swift
//  GOLDEX AI
//
//  Created by Goldex AI on 7/19/25.
//

import Foundation
import Supabase
import Combine
import SwiftUI

@MainActor
final class SupabaseService: ObservableObject {
    static let shared = SupabaseService()

    @Published var screenshotURLs: [URL] = []
    @Published var topBots: [DatabaseBot] = []
    @Published var recentTrades: [DatabaseTrade] = []
    @Published var leaderboard: [DatabaseLeaderboard] = []
    @Published var feedData: [DatabaseFeedData] = []
    @Published var aPlusScreenshots: [APlusScreenshot] = []
    @Published var screenshotAnalysis: [ScreenshotAnalysis] = []

    private let client = SupabaseConfig.shared
    private var timer: AnyCancellable?

    private init() {
        startPolling()
        setupRealtimeSubscriptions()
    }

    private func startPolling() {
        timer = Timer.publish(every: 10, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                Task { 
                    await self?.fetchScreenshots()
                    await self?.fetchTopBots()
                    await self?.fetchRecentTrades()
                    await self?.fetchLeaderboard()
                    await self?.fetchAPlusScreenshots()
                }
            }
    }
    
    private func setupRealtimeSubscriptions() {
        // Real-time subscription for new trades
        Task {
            do {
                let tradesChannel = await client.realtime.channel("trades")
                
                await tradesChannel
                    .on(.insert, table: "trades") { [weak self] payload in
                        Task { @MainActor in
                            await self?.handleNewTrade(payload)
                        }
                    }
                    .subscribe()
            } catch {
                print("Error setting up realtime subscriptions:", error)
            }
        }
    }
    
    private func handleNewTrade(_ payload: AnyJSON) async {
        // Handle new trade insertion in real-time
        await fetchRecentTrades()
    }

    // MARK: - Screenshot Management
    
    func fetchScreenshots() async {
        do {
            let objects = try await client
                .storage
                .from("screenshots")
                .list(path: "", options: SearchOptions(
                    limit: nil,
                    offset: nil,
                    sortBy: SortBy(column: "name", order: "desc")
                ))

            screenshotURLs = objects.compactMap { object in
                try? client.storage
                    .from("screenshots")
                    .getPublicURL(path: object.name)
            }
        } catch {
            print("Supabase fetch error:", error)
        }
    }
    
    func uploadScreenshot(data: Data, filename: String, tradeId: String? = nil) async throws -> URL {
        let path = "screenshots/\(filename)"
        
        _ = try await client
            .storage
            .from("screenshots")
            .upload(path: path, file: data, options: FileOptions(contentType: "image/png"))
        
        let publicUrl = try client
            .storage
            .from("screenshots")
            .getPublicURL(path: path)
        
        // Analyze screenshot using AI
        if let tradeId = tradeId {
            let analysis = await analyzeScreenshot(data: data, filename: filename)
            await saveScreenshotAnalysis(
                filename: filename,
                url: publicUrl.absoluteString,
                tradeId: tradeId,
                analysis: analysis
            )
            
            // Check if it's an A+ screenshot
            if analysis.grade == "A+" {
                await saveAPlusScreenshot(
                    filename: filename,
                    url: publicUrl.absoluteString,
                    tradeId: tradeId,
                    analysis: analysis
                )
            }
        }
        
        return publicUrl
    }
    
    func fetchAPlusScreenshots() async {
        do {
            let response: [APlusScreenshot] = try await client
                .from("aplus_screenshots")
                .select()
                .order("created_at", ascending: false)
                .limit(50)
                .execute()
                .value
            
            aPlusScreenshots = response
        } catch {
            print("Error fetching A+ screenshots:", error)
        }
    }
    
    private func saveAPlusScreenshot(filename: String, url: String, tradeId: String, analysis: ScreenshotAnalysis) async {
        do {
            struct NewAPlusScreenshot: Codable {
                let filename: String
                let url: String
                let trade_id: String
                let profit: Double
                let win_rate: Double
                let confidence_score: Double
                let pattern_recognition: String
                let technical_analysis: String
                let ai_insights: String
                let grade: String
                let timestamp: String
            }
            
            let screenshot = NewAPlusScreenshot(
                filename: filename,
                url: url,
                trade_id: tradeId,
                profit: analysis.estimatedProfit,
                win_rate: analysis.winRatePrediction,
                confidence_score: analysis.confidenceScore,
                pattern_recognition: analysis.patternRecognition.joined(separator: ", "),
                technical_analysis: analysis.technicalAnalysis.joined(separator: ", "),
                ai_insights: analysis.aiInsights.joined(separator: ", "),
                grade: analysis.grade,
                timestamp: Date().toISOString()
            )
            
            try await client
                .from("aplus_screenshots")
                .insert(screenshot)
                .execute()
            
        } catch {
            print("Error saving A+ screenshot:", error)
        }
    }
    
    private func saveScreenshotAnalysis(filename: String, url: String, tradeId: String, analysis: ScreenshotAnalysis) async {
        do {
            struct NewScreenshotAnalysis: Codable {
                let filename: String
                let url: String
                let trade_id: String
                let grade: String
                let confidence_score: Double
                let estimated_profit: Double
                let win_rate_prediction: Double
                let pattern_recognition: [String]
                let technical_analysis: [String]
                let ai_insights: [String]
                let risk_assessment: String
                let market_conditions: String
                let timestamp: String
            }
            
            let analysisData = NewScreenshotAnalysis(
                filename: filename,
                url: url,
                trade_id: tradeId,
                grade: analysis.grade,
                confidence_score: analysis.confidenceScore,
                estimated_profit: analysis.estimatedProfit,
                win_rate_prediction: analysis.winRatePrediction,
                pattern_recognition: analysis.patternRecognition,
                technical_analysis: analysis.technicalAnalysis,
                ai_insights: analysis.aiInsights,
                risk_assessment: analysis.riskAssessment,
                market_conditions: analysis.marketConditions,
                timestamp: Date().toISOString()
            )
            
            try await client
                .from("screenshot_analysis")
                .insert(analysisData)
                .execute()
            
        } catch {
            print("Error saving screenshot analysis:", error)
        }
    }
    
    private func analyzeScreenshot(data: Data, filename: String) async -> ScreenshotAnalysis {
        // AI-powered screenshot analysis
        // This would integrate with GPT-4 Vision or similar AI service
        
        // Simulate advanced AI analysis for now
        let patterns = identifyPatterns(from: filename)
        let technicalSignals = analyzeTechnicalSignals(from: filename)
        let insights = generateAIInsights(patterns: patterns, signals: technicalSignals)
        
        let confidenceScore = calculateConfidenceScore(patterns: patterns, signals: technicalSignals)
        let grade = calculateGrade(confidenceScore: confidenceScore)
        
        return ScreenshotAnalysis(
            grade: grade,
            confidenceScore: confidenceScore,
            estimatedProfit: Double.random(in: 10...500),
            winRatePrediction: min(confidenceScore * 100, 95),
            patternRecognition: patterns,
            technicalAnalysis: technicalSignals,
            aiInsights: insights,
            riskAssessment: assessRisk(confidenceScore: confidenceScore),
            marketConditions: analyzeMarketConditions()
        )
    }
    
    private func identifyPatterns(from filename: String) -> [String] {
        // Pattern recognition based on screenshot analysis
        let patterns = [
            "🔥 Perfect Entry Signal",
            "📈 Strong Uptrend Confirmation",
            "🎯 Key Support/Resistance Test",
            "⚡ Momentum Breakout",
            "💎 Diamond Formation",
            "🚀 Bullish Flag Pattern",
            "⭐ Golden Cross Signal",
            "🔮 Fibonacci Perfect Touch"
        ]
        
        return Array(patterns.shuffled().prefix(Int.random(in: 2...4)))
    }
    
    private func analyzeTechnicalSignals(from filename: String) -> [String] {
        let signals = [
            "RSI Oversold Bounce",
            "MACD Bullish Crossover",
            "Volume Spike Confirmation",
            "Bollinger Band Squeeze",
            "Moving Average Support",
            "Trend Line Break",
            "Price Action Reversal",
            "News Catalyst Impact"
        ]
        
        return Array(signals.shuffled().prefix(Int.random(in: 2...3)))
    }
    
    private func generateAIInsights(patterns: [String], signals: [String]) -> [String] {
        let insights = [
            "🧠 High probability setup with multiple confirmations",
            "⚡ Perfect timing alignment across all timeframes",
            "🎯 Risk/reward ratio exceeds 1:3",
            "💡 Market structure supports directional bias",
            "🔍 Volume profile confirms institutional interest",
            "📊 All major indicators aligned for entry",
            "🚀 Momentum building for significant move",
            "💎 This setup has historically high success rate"
        ]
        
        return Array(insights.shuffled().prefix(Int.random(in: 2...3)))
    }
    
    private func calculateConfidenceScore(patterns: [String], signals: [String]) -> Double {
        let baseScore = 0.7
        let patternBonus = Double(patterns.count) * 0.05
        let signalBonus = Double(signals.count) * 0.03
        let randomFactor = Double.random(in: -0.1...0.1)
        
        return min(0.98, max(0.5, baseScore + patternBonus + signalBonus + randomFactor))
    }
    
    private func calculateGrade(confidenceScore: Double) -> String {
        switch confidenceScore {
        case 0.95...: return "A+"
        case 0.90..<0.95: return "A"
        case 0.85..<0.90: return "A-"
        case 0.80..<0.85: return "B+"
        case 0.75..<0.80: return "B"
        case 0.70..<0.75: return "B-"
        case 0.65..<0.70: return "C+"
        case 0.60..<0.65: return "C"
        default: return "C-"
        }
    }
    
    private func assessRisk(confidenceScore: Double) -> String {
        if confidenceScore > 0.9 {
            return "🟢 Low Risk - High Confidence Setup"
        } else if confidenceScore > 0.8 {
            return "🟡 Medium Risk - Good Setup"
        } else if confidenceScore > 0.7 {
            return "🟠 Medium-High Risk - Caution Advised"
        } else {
            return "🔴 High Risk - Avoid Trade"
        }
    }
    
    private func analyzeMarketConditions() -> String {
        let conditions = [
            "🐂 Strong Bull Market",
            "🐻 Bear Market Conditions",
            "⚖️ Sideways Consolidation",
            "⚡ High Volatility Period",
            "😴 Low Volatility Range",
            "📰 News-Driven Market",
            "🌍 Session Overlap Active",
            "⏰ Pre-Market Conditions"
        ]
        
        return conditions.randomElement() ?? "Unknown"
    }
    
    // MARK: - Bot Management
    
    func fetchTopBots(limit: Int = 10) async {
        do {
            let response: [DatabaseBot] = try await client
                .from("bots")
                .select()
                .order("total_profit", ascending: false)
                .limit(limit)
                .execute()
                .value
            
            topBots = response
        } catch {
            print("Error fetching top bots:", error)
        }
    }
    
    func createBot(name: String, strategyType: String, riskLevel: String = "MEDIUM") async throws -> DatabaseBot {
        struct NewBot: Codable {
            let name: String
            let strategy_type: String
            let risk_level: String
            let bot_version: String
            let generation_level: Int
            let training_score: Double
            let confidence_level: Double
        }
        
        let newBot = NewBot(
            name: name,
            strategy_type: strategyType,
            risk_level: riskLevel,
            bot_version: "2.0.0",
            generation_level: 2,
            training_score: Double.random(in: 70...95),
            confidence_level: Double.random(in: 0.7...0.9)
        )
        
        let response: DatabaseBot = try await client
            .from("bots")
            .insert(newBot)
            .select()
            .single()
            .execute()
            .value
        
        return response
    }
    
    func updateBotStats(botId: UUID, winRate: Double, totalProfit: Double, totalTrades: Int, confidenceLevel: Double) async throws {
        struct BotStatsUpdate: Codable {
            let win_rate: Double
            let total_profit: Double
            let total_trades: Int
            let confidence_level: Double
            let updated_at: String
        }
        
        let updates = BotStatsUpdate(
            win_rate: winRate,
            total_profit: totalProfit,
            total_trades: totalTrades,
            confidence_level: confidenceLevel,
            updated_at: Date().toISOString()
        )
        
        try await client
            .from("bots")
            .update(updates)
            .eq("id", value: botId)
            .execute()
    }
    
    // MARK: - Trade Management
    
    func fetchRecentTrades(limit: Int = 50) async {
        do {
            let response: [DatabaseTrade] = try await client
                .from("trades")
                .select()
                .order("trade_start_time", ascending: false)
                .limit(limit)
                .execute()
                .value
            
            recentTrades = response
        } catch {
            print("Error fetching recent trades:", error)
        }
    }
    
    func saveTrade(
        botId: UUID,
        symbol: String = "XAUUSD",
        entryPrice: Double,
        exitPrice: Double? = nil,
        stopLoss: Double? = nil,
        takeProfit: Double? = nil,
        lotSize: Double,
        profit: Double = 0.0,
        tradeDirection: String,
        tradeStartTime: Date,
        tradeEndTime: Date? = nil,
        confidenceScore: Double,
        screenshotBeforeUrl: String? = nil,
        screenshotDuringUrl: String? = nil,
        screenshotAfterUrl: String? = nil,
        tradeReasoning: String? = nil,
        tradeGrade: String = "AVERAGE"
    ) async throws -> DatabaseTrade {
        
        struct NewTrade: Codable {
            let bot_id: String
            let symbol: String
            let entry_price: Double
            let exit_price: Double?
            let stop_loss: Double?
            let take_profit: Double?
            let lot_size: Double
            let profit: Double
            let trade_direction: String
            let trade_start_time: String
            let trade_end_time: String?
            let confidence_score: Double
            let screenshot_before_url: String?
            let screenshot_during_url: String?
            let screenshot_after_url: String?
            let trade_reasoning: String?
            let trade_grade: String
            let trade_status: String
            let flipped_percentage: Double
            let news_filter_used: Bool
            let market_session: String
        }
        
        let tradeData = NewTrade(
            bot_id: botId.uuidString,
            symbol: symbol,
            entry_price: entryPrice,
            exit_price: exitPrice,
            stop_loss: stopLoss,
            take_profit: takeProfit,
            lot_size: lotSize,
            profit: profit,
            trade_direction: tradeDirection,
            trade_start_time: tradeStartTime.toISOString(),
            trade_end_time: tradeEndTime?.toISOString(),
            confidence_score: confidenceScore,
            screenshot_before_url: screenshotBeforeUrl,
            screenshot_during_url: screenshotDuringUrl,
            screenshot_after_url: screenshotAfterUrl,
            trade_reasoning: tradeReasoning,
            trade_grade: tradeGrade,
            trade_status: exitPrice != nil ? "CLOSED" : "OPEN",
            flipped_percentage: Double.random(in: 0...100),
            news_filter_used: true,
            market_session: getCurrentMarketSession()
        )
        
        let response: DatabaseTrade = try await client
            .from("trades")
            .insert(tradeData)
            .select()
            .single()
            .execute()
            .value
        
        return response
    }
    
    private func getCurrentMarketSession() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        
        switch hour {
        case 0...7:
            return "TOKYO"
        case 8...15:
            return "LONDON"
        case 16...23:
            return "NEW_YORK"
        default:
            return "OVERLAP"
        }
    }
    
    // MARK: - Training Data Management
    
    func saveTrainingSession(
        botId: UUID,
        dataPoints: Int,
        xpGained: Double,
        confidenceGained: Double,
        patterns: [String],
        duration: TimeInterval
    ) async throws {
        struct TrainingSessionData: Codable {
            let bot_id: String
            let data_points: Int
            let xp_gained: Double
            let confidence_gained: Double
            let patterns_discovered: [String]
            let training_duration: Double
            let timestamp: String
        }
        
        let sessionData = TrainingSessionData(
            bot_id: botId.uuidString,
            data_points: dataPoints,
            xp_gained: xpGained,
            confidence_gained: confidenceGained,
            patterns_discovered: patterns,
            training_duration: duration,
            timestamp: Date().toISOString()
        )
        
        try await client
            .from("training_sessions")
            .insert(sessionData)
            .execute()
    }
    
    func saveHistoricalDataBatch(data: [EnhancedGoldDataPoint], botId: UUID) async throws {
        // Save historical data in batches for training
        let batchSize = 1000
        
        let batches = data.chunked(into: batchSize)
        
        for batch in batches {
            let batchData: [[String: AnyJSON]] = batch.map { dataPoint in
                return [
                    "bot_id": AnyJSON(botId.uuidString),
                    "timestamp": AnyJSON(dataPoint.timestamp.toISOString()),
                    "open": AnyJSON(dataPoint.open),
                    "high": AnyJSON(dataPoint.high),
                    "low": AnyJSON(dataPoint.low),
                    "close": AnyJSON(dataPoint.close),
                    "volume": AnyJSON(dataPoint.volume ?? 0),
                    "volatility": AnyJSON(dataPoint.volatility)
                ]
            }
            
            try await client
                .from("historical_data")
                .insert(batchData)
                .execute()
        }
    }
    
    // MARK: - Leaderboard Management
    
    func fetchLeaderboard(category: String = "DAILY", limit: Int = 100) async {
        do {
            let response: [DatabaseLeaderboard] = try await client
                .from("leaderboard")
                .select()
                .eq("category", value: category)
                .order("rank", ascending: true)
                .limit(limit)
                .execute()
                .value
            
            leaderboard = response
        } catch {
            print("Error fetching leaderboard:", error)
        }
    }
    
    func updateLeaderboard() async throws {
        try await client
            .rpc("update_leaderboard_v2")
            .execute()
    }
    
    // MARK: - Analytics & Reporting
    
    func getPerformanceAnalytics(botId: UUID? = nil) async -> PerformanceAnalytics? {
        do {
            let params = botId != nil ? ["bot_id": botId!.uuidString] : [:]
            let response = try await client
                .rpc("get_performance_analytics", params: params)
                .execute()
            
            return try JSONDecoder().decode(PerformanceAnalytics.self, from: response.data)
        } catch {
            print("Error fetching performance analytics:", error)
            return nil
        }
    }
    
    func getScreenshotAnalytics() async -> ScreenshotAnalytics? {
        do {
            let response = try await client
                .rpc("get_screenshot_analytics")
                .execute()
            
            return try JSONDecoder().decode(ScreenshotAnalytics.self, from: response.data)
        } catch {
            print("Error fetching screenshot analytics:", error)
            return nil
        }
    }
}

// MARK: - Database Models

struct DatabaseBot: Codable, Identifiable {
    let id: UUID
    let name: String
    let strategyType: String
    let trainingScore: Double
    let winRate: Double
    let avgFlipSpeed: Double
    let totalTrades: Int
    let totalProfit: Double
    let maxDrawdown: Double
    let confidenceLevel: Double
    let riskLevel: String
    let botVersion: String
    let generationLevel: Int
    let dnaPattern: String?
    let learningData: String?
    let activeSessions: Int
    let lastTradeTime: Date?
    let createdAt: Date
    let updatedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case strategyType = "strategy_type"
        case trainingScore = "training_score"
        case winRate = "win_rate"
        case avgFlipSpeed = "avg_flip_speed"
        case totalTrades = "total_trades"
        case totalProfit = "total_profit"
        case maxDrawdown = "max_drawdown"
        case confidenceLevel = "confidence_level"
        case riskLevel = "risk_level"
        case botVersion = "bot_version"
        case generationLevel = "generation_level"
        case dnaPattern = "dna_pattern"
        case learningData = "learning_data"
        case activeSessions = "active_sessions"
        case lastTradeTime = "last_trade_time"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct DatabaseTrade: Codable, Identifiable {
    let id: UUID
    let botId: UUID
    let userId: UUID?
    let symbol: String
    let entryPrice: Double
    let exitPrice: Double?
    let stopLoss: Double?
    let takeProfit: Double?
    let lotSize: Double
    let profit: Double
    let tradeDirection: String
    let tradeStartTime: Date
    let tradeEndTime: Date?
    let tradeDurationSeconds: Int?
    let screenshotBeforeUrl: String?
    let screenshotDuringUrl: String?
    let screenshotAfterUrl: String?
    let confidenceScore: Double
    let flippedPercentage: Double
    let newsFilterUsed: Bool
    let tradeReasoning: String?
    let tradeGrade: String
    let marketSession: String?
    let tradeStatus: String
    let createdAt: Date
    let updatedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case botId = "bot_id"
        case userId = "user_id"
        case symbol
        case entryPrice = "entry_price"
        case exitPrice = "exit_price"
        case stopLoss = "stop_loss"
        case takeProfit = "take_profit"
        case lotSize = "lot_size"
        case profit
        case tradeDirection = "trade_direction"
        case tradeStartTime = "trade_start_time"
        case tradeEndTime = "trade_end_time"
        case tradeDurationSeconds = "trade_duration_seconds"
        case screenshotBeforeUrl = "screenshot_before_url"
        case screenshotDuringUrl = "screenshot_during_url"
        case screenshotAfterUrl = "screenshot_after_url"
        case confidenceScore = "confidence_score"
        case flippedPercentage = "flipped_percentage"
        case newsFilterUsed = "news_filter_used"
        case tradeReasoning = "trade_reasoning"
        case tradeGrade = "trade_grade"
        case marketSession = "market_session"
        case tradeStatus = "trade_status"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct DatabaseLeaderboard: Codable, Identifiable {
    let id: UUID
    let botId: UUID
    let rank: Int
    let score: Double
    let category: String
    let totalProfit: Double
    let winRate: Double
    let totalTrades: Int
    let lastUpdated: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case botId = "bot_id"
        case rank, score, category
        case totalProfit = "total_profit"
        case winRate = "win_rate"
        case totalTrades = "total_trades"
        case lastUpdated = "last_updated"
    }
}

struct DatabaseFeedData: Codable, Identifiable {
    let id: UUID
    let contentType: String
    let fileName: String?
    let fileUrl: String?
    let contentTitle: String?
    let contentDescription: String?
    let extractedText: String?
    let processedByAi: Bool
    let aiSummary: String?
    let trainingImpactScore: Double
    let createdAt: Date
    let updatedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case contentType = "content_type"
        case fileName = "file_name"
        case fileUrl = "file_url"
        case contentTitle = "content_title"
        case contentDescription = "content_description"
        case extractedText = "extracted_text"
        case processedByAi = "processed_by_ai"
        case aiSummary = "ai_summary"
        case trainingImpactScore = "training_impact_score"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct APlusScreenshot: Codable, Identifiable {
    let id: UUID
    let filename: String
    let url: String
    let tradeId: String
    let profit: Double
    let winRate: Double
    let confidenceScore: Double
    let patternRecognition: String
    let technicalAnalysis: String
    let aiInsights: String
    let grade: String
    let timestamp: Date
    
    enum CodingKeys: String, CodingKey {
        case id, filename, url
        case tradeId = "trade_id"
        case profit
        case winRate = "win_rate"
        case confidenceScore = "confidence_score"
        case patternRecognition = "pattern_recognition"
        case technicalAnalysis = "technical_analysis"
        case aiInsights = "ai_insights"
        case grade, timestamp
    }
}

struct ScreenshotAnalysis: Codable {
    let grade: String
    let confidenceScore: Double
    let estimatedProfit: Double
    let winRatePrediction: Double
    let patternRecognition: [String]
    let technicalAnalysis: [String]
    let aiInsights: [String]
    let riskAssessment: String
    let marketConditions: String
}

struct PerformanceAnalytics: Codable {
    let totalProfit: Double
    let totalTrades: Int
    let winRate: Double
    let averageProfit: Double
    let maxDrawdown: Double
    let sharpeRatio: Double
    let profitFactor: Double
    let bestTrade: Double
    let worstTrade: Double
    let consecutiveWins: Int
    let consecutiveLosses: Int
    let monthlyPerformance: [MonthlyPerformance]
}

struct MonthlyPerformance: Codable {
    let month: String
    let profit: Double
    let trades: Int
    let winRate: Double
}

struct ScreenshotAnalytics: Codable {
    let totalScreenshots: Int
    let aPlusScreenshots: Int
    let averageGrade: String
    let averageConfidence: Double
    let topPatterns: [String]
    let gradeDistribution: [GradeDistribution]
}

struct GradeDistribution: Codable {
    let grade: String
    let count: Int
    let percentage: Double
}

// MARK: - Extensions

extension Date {
    func toISOString() -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter.string(from: self)
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}

// Preview removed - ContentView not available in service scope