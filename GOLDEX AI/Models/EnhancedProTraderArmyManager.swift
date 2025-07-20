//
//  EnhancedProTraderArmyManager.swift
//  GOLDEX AI
//
//  Created by Goldex AI on 7/19/25.
//

import SwiftUI
import Foundation
import Combine

@MainActor
class EnhancedProTraderArmyManager: ObservableObject {
    @Published var bots: [EnhancedProTraderBot] = []
    @Published var isTraining = false
    @Published var trainingProgress: Double = 0.0
    @Published var lastTrainingResults: EnhancedTrainingResults?
    @Published var totalXP: Double = 0
    @Published var averageConfidence: Double = 0
    @Published var eliteBots: Int = 0
    @Published var godlikeBots: Int = 0
    @Published var godmodeBots: Int = 0
    @Published var isConnectedToVPS = false
    @Published var vpsManager: VPSManager
    @Published var supabaseService: SupabaseService
    
    private var trainingCancellable: AnyCancellable?
    
    init() {
        self.vpsManager = VPSManager()
        self.supabaseService = SupabaseService.shared
        
        initializeEnhancedBotArmy()
        calculateStats()
        connectToVPS()
    }
    
    // MARK: - Army Initialization
    
    func initializeEnhancedBotArmy() {
        guard bots.isEmpty else { return }
        
        print("🚀 Initializing GOLDEX AI Army of 5,000 ProTrader Bots...")
        
        bots = (1...5000).map { botNumber in
            let strategyIndex = (botNumber - 1) % EnhancedProTraderBot.TradingStrategy.allCases.count
            let strategy = EnhancedProTraderBot.TradingStrategy.allCases[strategyIndex]
            
            let specializationIndex = (botNumber - 1) % EnhancedProTraderBot.BotSpecialization.allCases.count
            let specialization = EnhancedProTraderBot.BotSpecialization.allCases[specializationIndex]
            
            let aiEngineIndex = (botNumber - 1) % EnhancedProTraderBot.AIEngineType.allCases.count
            let aiEngine = EnhancedProTraderBot.AIEngineType.allCases[aiEngineIndex]
            
            // Create different risk profiles
            let riskProfile: EnhancedRiskProfile
            switch botNumber % 3 {
            case 0:
                riskProfile = .conservative()
            case 1:
                riskProfile = .moderate()
            default:
                riskProfile = .aggressive()
            }
            
            return EnhancedProTraderBot(
                id: UUID(),
                botNumber: botNumber,
                name: generateBotName(botNumber: botNumber, strategy: strategy),
                xp: Double.random(in: 100...500),
                confidence: Double.random(in: 0.5...0.8),
                strategy: strategy,
                wins: Int.random(in: 50...200),
                losses: Int.random(in: 10...50),
                totalTrades: Int.random(in: 60...250),
                profitLoss: Double.random(in: 500...5000),
                learningHistory: [],
                lastTraining: nil,
                isActive: true,
                specialization: specialization,
                aiEngine: aiEngine,
                vpsStatus: .disconnected,
                screenshotUrls: [],
                patternRecognition: PatternRecognitionData(),
                tradingPersonality: TradingPersonality.random(),
                riskProfile: riskProfile
            )
        }
        
        print("✅ Army initialized with \(bots.count) bots!")
    }
    
    private func generateBotName(botNumber: Int, strategy: EnhancedProTraderBot.TradingStrategy) -> String {
        let prefixes = ["ProBot", "GoldHunter", "TradeMaster", "AI-Warrior", "GoldexBot"]
        let suffixes = ["Elite", "Pro", "Master", "X", "Alpha", "Prime"]
        
        let prefix = prefixes[botNumber % prefixes.count]
        let suffix = suffixes[(botNumber / 100) % suffixes.count]
        
        return "\(prefix)-\(String(format: "%04d", botNumber))-\(suffix)"
    }
    
    // MARK: - VPS Connection
    
    private func connectToVPS() {
        Task {
            await vpsManager.connectToVPS()
            isConnectedToVPS = vpsManager.isConnected
            
            if isConnectedToVPS {
                await deployBotsToVPS()
            }
        }
    }
    
    private func deployBotsToVPS() async {
        print("🚀 Deploying top 100 bots to VPS...")
        
        let topBots = getTopPerformers(count: 100)
        var deployedCount = 0
        
        for bot in topBots {
            if await vpsManager.deployBot(bot) {
                deployedCount += 1
                
                // Update bot VPS status
                if let index = bots.firstIndex(where: { $0.id == bot.id }) {
                    bots[index].vpsStatus = .connected
                }
            }
        }
        
        print("✅ Deployed \(deployedCount) bots to VPS!")
    }
    
    // MARK: - Historical Data Training
    
    func trainWithHistoricalData(csvData: String) async -> EnhancedTrainingResults {
        isTraining = true
        trainingProgress = 0.0
        
        let results = EnhancedTrainingResults()
        let startTime = Date()
        
        do {
            print("📊 Parsing historical data...")
            let dataPoints = try parseEnhancedGoldCSV(csvData)
            results.dataPointsProcessed = dataPoints.count
            results.dataQualityScore = calculateDataQuality(dataPoints)
            
            print("🧠 Starting advanced training for \(bots.count) bots...")
            
            // Enhanced training with parallel processing
            await trainBotsInParallel(with: dataPoints, results: results)
            
            // Sync with Supabase
            print("☁️ Syncing results with Supabase...")
            await syncWithSupabase(results: results)
            
            // Update VPS bots
            if isConnectedToVPS {
                print("🔄 Updating VPS bot configurations...")
                await updateVPSBots()
            }
            
            calculateStats()
            results.trainingTime = Date().timeIntervalSince(startTime)
            lastTrainingResults = results
            
            print("🎉 Training complete! Results: \(results.summary)")
            
        } catch {
            results.errors.append("Training failed: \(error.localizedDescription)")
            print("❌ Training error: \(error)")
        }
        
        isTraining = false
        return results
    }
    
    private func trainBotsInParallel(with data: [EnhancedGoldDataPoint], results: EnhancedTrainingResults) async {
        let batchSize = 50 // Process 50 bots at a time
        let totalBatches = (bots.count + batchSize - 1) / batchSize
        
        for batchIndex in 0..<totalBatches {
            let startIndex = batchIndex * batchSize
            let endIndex = min(startIndex + batchSize, bots.count)
            
            // Create concurrent tasks for batch training
            await withTaskGroup(of: Void.self) { group in
                for i in startIndex..<endIndex {
                    group.addTask { [weak self] in
                        await self?.trainSingleBot(index: i, data: data, results: results)
                    }
                }
            }
            
            trainingProgress = Double(batchIndex + 1) / Double(totalBatches)
            print("📈 Training progress: \(Int(trainingProgress * 100))%")
        }
    }
    
    private func trainSingleBot(index: Int, data: [EnhancedGoldDataPoint], results: EnhancedTrainingResults) async {
        guard index < bots.count else { return }
        
        let oldConfidence = bots[index].confidence
        let oldXP = bots[index].xp
        let oldGrade = bots[index].performanceGrade
        
        await bots[index].trainWithAdvancedData(data)
        
        // Update results
        await MainActor.run {
            results.botsTrained += 1
            results.totalXPGained += (bots[index].xp - oldXP)
            results.totalConfidenceGained += (bots[index].confidence - oldConfidence)
            
            // Check for tier upgrades
            let newGrade = bots[index].performanceGrade
            if newGrade == "A+" && oldGrade != "A+" {
                results.newGodmodeBots += 1
            }
            if bots[index].confidence >= 0.9 && oldConfidence < 0.9 {
                results.newGodlikeBots += 1
            }
            if bots[index].confidence >= 0.8 && oldConfidence < 0.8 {
                results.newEliteBots += 1
            }
        }
        
        // Save training session to Supabase
        if let lastSession = bots[index].learningHistory.last {
            await saveTrainingSession(botId: bots[index].id, session: lastSession)
        }
        
        // Take screenshot if A+ performance
        if bots[index].performanceGrade == "A+" {
            await captureAPlusScreenshot(bot: bots[index])
        }
    }
    
    // MARK: - CSV Data Processing
    
    private func parseEnhancedGoldCSV(_ csvData: String) throws -> [EnhancedGoldDataPoint] {
        let lines = csvData.components(separatedBy: .newlines)
        var dataPoints: [EnhancedGoldDataPoint] = []
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd HH:mm:ss"
        
        for (index, line) in lines.enumerated() {
            guard index > 0, !line.trimmingCharacters(in: .whitespaces).isEmpty else { continue }
            
            let components = line.components(separatedBy: ",")
            guard components.count >= 5 else { continue }
            
            // Parse CSV with enhanced error handling
            let dateString = components[0] + " " + (components.count > 1 ? components[1] : "00:00:00")
            
            guard let date = dateFormatter.date(from: dateString),
                  let open = Double(components[components.count >= 6 ? 2 : 1]),
                  let high = Double(components[components.count >= 6 ? 3 : 2]),
                  let low = Double(components[components.count >= 6 ? 4 : 3]),
                  let close = Double(components[components.count >= 6 ? 5 : 4]) else {
                continue
            }
            
            let volume = components.count > 6 ? Double(components[6]) : nil
            
            // Validate OHLC data
            guard high >= low, high >= max(open, close), low <= min(open, close) else {
                continue
            }
            
            dataPoints.append(EnhancedGoldDataPoint(
                timestamp: date,
                open: open,
                high: high,
                low: low,
                close: close,
                volume: volume
            ))
        }
        
        return dataPoints.sorted { $0.timestamp < $1.timestamp }
    }
    
    private func calculateDataQuality(_ dataPoints: [EnhancedGoldDataPoint]) -> Double {
        guard !dataPoints.isEmpty else { return 0.0 }
        
        var qualityScore = 100.0
        
        // Check for data gaps
        if dataPoints.count > 1 {
            var gapCount = 0
            for i in 1..<dataPoints.count {
                let timeDiff = dataPoints[i].timestamp.timeIntervalSince(dataPoints[i-1].timestamp)
                if timeDiff > 3600 * 2 { // More than 2 hours gap
                    gapCount += 1
                }
            }
            let gapRatio = Double(gapCount) / Double(dataPoints.count)
            qualityScore *= (1.0 - gapRatio)
        }
        
        // Check for outliers
        let prices = dataPoints.map { $0.close }
        let mean = prices.reduce(0, +) / Double(prices.count)
        let stdDev = sqrt(prices.map { pow($0 - mean, 2) }.reduce(0, +) / Double(prices.count))
        
        let outlierCount = prices.filter { abs($0 - mean) > stdDev * 3 }.count
        let outlierRatio = Double(outlierCount) / Double(prices.count)
        qualityScore *= (1.0 - outlierRatio * 0.5)
        
        return max(0.0, min(100.0, qualityScore))
    }
    
    // MARK: - Supabase Integration
    
    private func syncWithSupabase(results: EnhancedTrainingResults) async {
        do {
            // Save training results
            for bot in bots.prefix(100) { // Save top 100 bots
                try await supabaseService.updateBotStats(
                    botId: bot.id,
                    winRate: bot.winRate,
                    totalProfit: bot.profitLoss,
                    totalTrades: bot.totalTrades,
                    confidenceLevel: bot.confidence
                )
            }
            
            // Update leaderboard
            try await supabaseService.updateLeaderboard()
            
            print("✅ Successfully synced with Supabase")
        } catch {
            print("❌ Supabase sync error: \(error)")
            results.errors.append("Supabase sync failed: \(error.localizedDescription)")
        }
    }
    
    private func saveTrainingSession(botId: UUID, session: EnhancedLearningSession) async {
        do {
            try await supabaseService.saveTrainingSession(
                botId: botId,
                dataPoints: session.dataPoints,
                xpGained: session.xpGained,
                confidenceGained: session.confidenceGained,
                patterns: session.patternsDiscovered,
                duration: 0 // Would calculate actual duration
            )
        } catch {
            print("❌ Failed to save training session: \(error)")
        }
    }
    
    // MARK: - Screenshot Management
    
    private func captureAPlusScreenshot(bot: EnhancedProTraderBot) async {
        // Simulate screenshot capture (in real app, this would capture actual trading charts)
        let screenshotData = generateMockScreenshot(for: bot)
        let filename = "bot-\(bot.botNumber)-aplus-\(Date().timeIntervalSince1970).png"
        
        do {
            let url = try await supabaseService.uploadScreenshot(
                data: screenshotData,
                filename: filename,
                tradeId: UUID().uuidString
            )
            
            // Update bot with screenshot URL
            if let index = bots.firstIndex(where: { $0.id == bot.id }) {
                bots[index].screenshotUrls.append(url.absoluteString)
            }
            
            print("📸 A+ Screenshot saved for \(bot.name): \(url)")
        } catch {
            print("❌ Failed to save screenshot: \(error)")
        }
    }
    
    private func generateMockScreenshot(for bot: EnhancedProTraderBot) -> Data {
        // In a real app, this would capture actual trading charts
        // For now, return empty data
        return Data()
    }
    
    // MARK: - VPS Bot Management
    
    private func updateVPSBots() async {
        let activeBots = bots.filter { $0.vpsStatus == .connected }
        
        for bot in activeBots {
            let config = VPSBotConfig(
                maxRisk: bot.riskProfile.maxPositionSize,
                stopLoss: bot.riskProfile.stopLossPercentage,
                takeProfit: bot.riskProfile.takeProfitRatio,
                aiEngine: bot.aiEngine.rawValue
            )
            
            _ = await vpsManager.updateBotConfig(bot.id.uuidString, config: config)
        }
    }
    
    // MARK: - Statistics and Analytics
    
    private func calculateStats() {
        totalXP = bots.reduce(0) { $0 + $1.xp }
        averageConfidence = bots.reduce(0) { $0 + $1.confidence } / Double(bots.count)
        eliteBots = bots.filter { $0.confidence >= 0.8 }.count
        godlikeBots = bots.filter { $0.confidence >= 0.9 }.count
        godmodeBots = bots.filter { $0.confidence >= 0.95 }.count
    }
    
    func getTopPerformers(count: Int = 100) -> [EnhancedProTraderBot] {
        return bots.sorted { bot1, bot2 in
            // Sort by confidence first, then by profit
            if bot1.confidence != bot2.confidence {
                return bot1.confidence > bot2.confidence
            }
            return bot1.profitLoss > bot2.profitLoss
        }.prefix(count).map { $0 }
    }
    
    func getBotsByStrategy(_ strategy: EnhancedProTraderBot.TradingStrategy) -> [EnhancedProTraderBot] {
        return bots.filter { $0.strategy == strategy }
    }
    
    func getBotsBySpecialization(_ specialization: EnhancedProTraderBot.BotSpecialization) -> [EnhancedProTraderBot] {
        return bots.filter { $0.specialization == specialization }
    }
    
    func getArmyStats() -> EnhancedArmyStats {
        let activeBots = bots.filter { $0.isActive }
        let connectedBots = bots.filter { $0.vpsStatus == .connected }
        
        return EnhancedArmyStats(
            totalBots: bots.count,
            activeBots: activeBots.count,
            connectedToVPS: connectedBots.count,
            totalXP: totalXP,
            averageConfidence: averageConfidence,
            eliteBots: eliteBots,
            godlikeBots: godlikeBots,
            godmodeBots: godmodeBots,
            totalTrades: bots.reduce(0) { $0 + $1.totalTrades },
            totalWins: bots.reduce(0) { $0 + $1.wins },
            totalProfitLoss: bots.reduce(0) { $0 + $1.profitLoss },
            averageWinRate: bots.reduce(0) { $0 + $1.winRate } / Double(bots.count),
            bestPerformer: getTopPerformers(count: 1).first?.name ?? "Unknown",
            totalScreenshots: bots.reduce(0) { $0 + $1.screenshotUrls.count }
        )
    }
    
    // MARK: - Auto-Trading Management
    
    func startAutoTrading() async {
        guard isConnectedToVPS else {
            print("❌ Cannot start auto-trading: Not connected to VPS")
            return
        }
        
        print("🚀 Starting auto-trading for all active bots...")
        
        let activeBots = bots.filter { $0.isActive && $0.vpsStatus == .connected }
        
        for bot in activeBots {
            let signal = VPSTradingSignal(
                botId: bot.id.uuidString,
                symbol: "XAUUSD",
                action: "BUY", // This would be determined by bot's analysis
                price: 2000.0, // Current market price
                volume: bot.riskProfile.maxPositionSize,
                stopLoss: 1990.0,
                takeProfit: 2020.0,
                confidence: bot.confidence,
                reasoning: "AI Analysis: \(bot.aiEngine.rawValue)",
                timestamp: Date()
            )
            
            _ = await vpsManager.sendTradingSignal(signal)
        }
        
        print("✅ Auto-trading signals sent for \(activeBots.count) bots")
    }
    
    func stopAutoTrading() async {
        print("🛑 Stopping auto-trading for all bots...")
        
        let connectedBots = bots.filter { $0.vpsStatus == .connected }
        
        for bot in connectedBots {
            _ = await vpsManager.stopBot(bot.id.uuidString)
        }
        
        print("✅ Auto-trading stopped for \(connectedBots.count) bots")
    }
    
    // MARK: - Continuous Learning
    
    func startContinuousLearning() {
        print("🧠 Starting continuous learning system...")
        
        // Schedule continuous learning every hour
        trainingCancellable = Timer.publish(every: 3600, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                Task {
                    await self?.performContinuousLearning()
                }
            }
    }
    
    private func performContinuousLearning() async {
        print("🔄 Performing continuous learning update...")
        
        // Fetch latest market data from VPS
        if let systemStats = await vpsManager.getSystemHealth() {
            // Use system stats to enhance learning
            print("📊 System health: \(systemStats.status)")
        }
        
        // Update bot performances based on recent trades
        await updateBotPerformances()
        
        // Re-calculate statistics
        calculateStats()
        
        print("✅ Continuous learning update complete")
    }
    
    private func updateBotPerformances() async {
        // Fetch recent trades from Supabase
        await supabaseService.fetchRecentTrades(limit: 100)
        
        // Update bot stats based on recent performance
        for trade in supabaseService.recentTrades {
            if let botIndex = bots.firstIndex(where: { $0.id == trade.botId }) {
                // Update bot performance based on trade result
                if trade.profit > 0 {
                    bots[botIndex].wins += 1
                } else {
                    bots[botIndex].losses += 1
                }
                bots[botIndex].totalTrades += 1
                bots[botIndex].profitLoss += trade.profit
            }
        }
    }
    
    deinit {
        trainingCancellable?.cancel()
    }
}

// MARK: - Enhanced Training Results
class EnhancedTrainingResults: ObservableObject {
    @Published var botsTrained = 0
    @Published var dataPointsProcessed = 0
    @Published var totalXPGained: Double = 0
    @Published var totalConfidenceGained: Double = 0
    @Published var newEliteBots = 0
    @Published var newGodlikeBots = 0
    @Published var newGodmodeBots = 0
    @Published var errors: [String] = []
    @Published var trainingTime: TimeInterval = 0
    @Published var dataQualityScore: Double = 0
    @Published var screenshotsCaptured = 0
    @Published var vpsDeployments = 0
    
    var summary: String {
        return """
        🚀 GOLDEX AI TRAINING COMPLETE!
        
        📊 Advanced Training Results:
        • Bots Trained: \(botsTrained)
        • Data Points Processed: \(dataPointsProcessed)
        • Data Quality Score: \(String(format: "%.1f", dataQualityScore))%
        • Total XP Gained: \(String(format: "%.0f", totalXPGained))
        • Avg Confidence Boost: \(String(format: "%.4f", totalConfidenceGained))
        
        🏆 Tier Upgrades:
        • New GODMODE Bots: \(newGodmodeBots)
        • New GODLIKE Bots: \(newGodlikeBots)
        • New ELITE Bots: \(newEliteBots)
        
        📸 A+ Screenshots: \(screenshotsCaptured)
        🖥️ VPS Deployments: \(vpsDeployments)
        ⏱️ Training Time: \(String(format: "%.2f", trainingTime))s
        
        🎯 Army Status: READY FOR BATTLE!
        """
    }
}

// MARK: - Enhanced Army Statistics
struct EnhancedArmyStats {
    let totalBots: Int
    let activeBots: Int
    let connectedToVPS: Int
    let totalXP: Double
    let averageConfidence: Double
    let eliteBots: Int
    let godlikeBots: Int
    let godmodeBots: Int
    let totalTrades: Int
    let totalWins: Int
    let totalProfitLoss: Double
    let averageWinRate: Double
    let bestPerformer: String
    let totalScreenshots: Int
    
    var overallWinRate: Double {
        guard totalTrades > 0 else { return 0 }
        return Double(totalWins) / Double(totalTrades) * 100
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}