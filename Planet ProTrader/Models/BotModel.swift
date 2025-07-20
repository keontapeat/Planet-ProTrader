//
//  BotModel.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 7/18/25.
//

import Foundation
import SwiftUI

// MARK: - Bot Model

struct BotModel: Identifiable, Codable {
    let id: UUID
    let name: String
    let strategyType: BotStrategy
    let trainingScore: Double
    let winRate: Double
    let avgFlipSpeed: Double
    let totalTrades: Int
    let totalProfit: Double
    let maxDrawdown: Double
    let confidenceLevel: Double
    let riskLevel: TradingTypes.RiskLevel
    let botVersion: String
    let generationLevel: Int
    let dnaPattern: BotDNA
    let activeSessions: Int
    let lastTradeTime: Date?
    let createdAt: Date
    let updatedAt: Date
    
    // MARK: - Supporting Enums
    
    enum BotStrategy: String, Codable, CaseIterable {
        case scalping = "SCALPING"
        case swing = "SWING"
        case breakout = "BREAKOUT"
        case trendFollowing = "TREND_FOLLOWING"
        case arbitrage = "ARBITRAGE"
        case gridTrading = "GRID_TRADING"
        case martingale = "MARTINGALE"
        case ict = "ICT"
        
        var displayName: String {
            switch self {
            case .scalping: return "Scalping"
            case .swing: return "Swing Trading"
            case .breakout: return "Breakout"
            case .trendFollowing: return "Trend Following"
            case .arbitrage: return "Arbitrage"
            case .gridTrading: return "Grid Trading"
            case .martingale: return "Martingale"
            case .ict: return "ICT Strategy"
            }
        }
        
        var description: String {
            switch self {
            case .scalping: return "Quick scalping trades with high frequency"
            case .swing: return "Medium-term swing trading positions"
            case .breakout: return "Trades breakouts from key levels"
            case .trendFollowing: return "Follows major market trends"
            case .arbitrage: return "Exploits price differences across markets"
            case .gridTrading: return "Places orders in a grid pattern"
            case .martingale: return "Doubles position size after losses"
            case .ict: return "Inner Circle Trader methodology"
            }
        }
        
        var color: Color {
            switch self {
            case .scalping: return .red
            case .swing: return .blue
            case .breakout: return .orange
            case .trendFollowing: return .green
            case .arbitrage: return .purple
            case .gridTrading: return .indigo
            case .martingale: return .pink
            case .ict: return .gold
            }
        }
        
        var systemImage: String {
            switch self {
            case .scalping: return "timer"
            case .swing: return "wave.3.right"
            case .breakout: return "arrow.up.right.circle"
            case .trendFollowing: return "arrow.up.forward"
            case .arbitrage: return "arrow.triangle.2.circlepath"
            case .gridTrading: return "grid"
            case .martingale: return "arrow.up.arrow.down"
            case .ict: return "brain.head.profile"
            }
        }
        
        var defaultTimeframes: [String] {
            switch self {
            case .scalping: return ["1M", "5M", "15M"]
            case .swing: return ["4H", "1D", "1W"]
            case .breakout: return ["15M", "1H", "4H"]
            case .trendFollowing: return ["1H", "4H", "1D"]
            case .arbitrage: return ["1M", "5M"]
            case .gridTrading: return ["15M", "1H"]
            case .martingale: return ["5M", "15M"]
            case .ict: return ["1M", "5M", "15M", "1H"]
            }
        }
        
        var riskPerTrade: Double {
            switch self {
            case .scalping: return 1.0
            case .swing: return 2.0
            case .breakout: return 1.5
            case .trendFollowing: return 2.5
            case .arbitrage: return 0.5
            case .gridTrading: return 1.0
            case .martingale: return 5.0
            case .ict: return 1.5
            }
        }
    }
    
    enum BotStatus: String, Codable, CaseIterable {
        case active = "ACTIVE"
        case inactive = "INACTIVE"
        case training = "TRAINING"
        case testing = "TESTING"
        case paused = "PAUSED"
        case error = "ERROR"
        
        var displayName: String {
            switch self {
            case .active: return "Active"
            case .inactive: return "Inactive"
            case .training: return "Training"
            case .testing: return "Testing"
            case .paused: return "Paused"
            case .error: return "Error"
            }
        }
        
        var color: Color {
            switch self {
            case .active: return .green
            case .inactive: return .gray
            case .training: return .blue
            case .testing: return .orange
            case .paused: return .yellow
            case .error: return .red
            }
        }
        
        var systemImage: String {
            switch self {
            case .active: return "play.circle.fill"
            case .inactive: return "pause.circle.fill"
            case .training: return "graduationcap.fill"
            case .testing: return "flask.fill"
            case .paused: return "pause.fill"
            case .error: return "exclamationmark.triangle.fill"
            }
        }
    }
    
    // MARK: - Bot DNA Structure
    
    struct BotDNA: Codable {
        let entryRules: [String]
        let exitRules: [String]
        let riskManagement: RiskManagement
        let timeframes: [String]
        let indicators: [String]
        let sessionPreferences: [String]
        let adaptabilityScore: Double
        let evolutionHistory: [String]
        
        struct RiskManagement: Codable {
            let maxRiskPerTrade: Double
            let maxDailyDrawdown: Double
            let positionSizing: String
            let stopLossType: String
            let takeProfitType: String
        }
        
        static let `default` = BotDNA(
            entryRules: ["breakout_confirmation", "volume_spike", "trend_alignment"],
            exitRules: ["take_profit_hit", "stop_loss_hit", "time_based_exit"],
            riskManagement: RiskManagement(
                maxRiskPerTrade: 1.0,
                maxDailyDrawdown: 5.0,
                positionSizing: "fixed",
                stopLossType: "fixed",
                takeProfitType: "fixed"
            ),
            timeframes: ["15M", "1H"],
            indicators: ["RSI", "MACD", "EMA"],
            sessionPreferences: ["LONDON", "NEWYORK"],
            adaptabilityScore: 75.0,
            evolutionHistory: ["Generation 1: Basic setup"]
        )
    }
    
    // MARK: - Computed Properties
    
    var currentStatus: BotStatus {
        if lastTradeTime == nil {
            return .inactive
        } else if let lastTrade = lastTradeTime {
            let timeSinceLastTrade = Date().timeIntervalSince(lastTrade)
            if timeSinceLastTrade < 3600 { // Less than 1 hour
                return .active
            } else if timeSinceLastTrade < 86400 { // Less than 24 hours
                return .paused
            } else {
                return .inactive
            }
        } else {
            return .inactive
        }
    }
    
    var profitability: String {
        if totalProfit > 10000 {
            return "Highly Profitable"
        } else if totalProfit > 5000 {
            return "Profitable"
        } else if totalProfit > 1000 {
            return "Moderately Profitable"
        } else if totalProfit > 0 {
            return "Slightly Profitable"
        } else {
            return "Unprofitable"
        }
    }
    
    var experienceLevel: String {
        if totalTrades > 1000 {
            return "Expert"
        } else if totalTrades > 500 {
            return "Advanced"
        } else if totalTrades > 100 {
            return "Intermediate"
        } else if totalTrades > 10 {
            return "Beginner"
        } else {
            return "Novice"
        }
    }
    
    var universeScore: Double {
        let profitScore = min(totalProfit / 1000, 100) * 0.3
        let winRateScore = winRate * 0.25
        let trainingScore = self.trainingScore * 0.2
        let confidenceScore = confidenceLevel * 0.15
        let drawdownPenalty = maxDrawdown * 0.1
        
        return max(0, profitScore + winRateScore + trainingScore + confidenceScore - drawdownPenalty)
    }
    
    var formattedUniverseScore: String {
        String(format: "%.1f", universeScore)
    }
    
    var formattedWinRate: String {
        String(format: "%.1f%%", winRate)
    }
    
    var formattedProfit: String {
        if totalProfit >= 1000 {
            return String(format: "$%.1fK", totalProfit / 1000)
        } else {
            return String(format: "$%.2f", totalProfit)
        }
    }
    
    var formattedDrawdown: String {
        String(format: "%.1f%%", maxDrawdown)
    }
    
    var formattedTrainingScore: String {
        String(format: "%.1f", trainingScore)
    }
    
    var formattedConfidence: String {
        String(format: "%.1f%%", confidenceLevel)
    }
    
    var averageTradeValue: Double {
        guard totalTrades > 0 else { return 0.0 }
        return totalProfit / Double(totalTrades)
    }
    
    var formattedAvgTrade: String {
        String(format: "$%.2f", averageTradeValue)
    }
    
    var generationTitle: String {
        switch generationLevel {
        case 1: return "Genesis"
        case 2: return "Evolved"
        case 3: return "Advanced"
        case 4: return "Elite"
        case 5: return "Master"
        default: return "Legendary"
        }
    }
    
    var rankTitle: String {
        if universeScore >= 95 {
            return "Universe Master"
        } else if universeScore >= 90 {
            return "Galactic Elite"
        } else if universeScore >= 85 {
            return "Stellar Pro"
        } else if universeScore >= 80 {
            return "Advanced Trader"
        } else if universeScore >= 70 {
            return "Skilled Trader"
        } else if universeScore >= 60 {
            return "Intermediate"
        } else if universeScore >= 50 {
            return "Developing"
        } else {
            return "Novice"
        }
    }
    
    // MARK: - Initializers
    
    init(
        id: UUID = UUID(),
        name: String,
        strategyType: BotStrategy,
        trainingScore: Double = 0.0,
        winRate: Double = 0.0,
        avgFlipSpeed: Double = 0.0,
        totalTrades: Int = 0,
        totalProfit: Double = 0.0,
        maxDrawdown: Double = 0.0,
        confidenceLevel: Double = 0.0,
        riskLevel: TradingTypes.RiskLevel = .medium,
        botVersion: String = "1.0.0",
        generationLevel: Int = 1,
        dnaPattern: BotDNA = BotDNA.default,
        activeSessions: Int = 0,
        lastTradeTime: Date? = nil,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.strategyType = strategyType
        self.trainingScore = trainingScore
        self.winRate = winRate
        self.avgFlipSpeed = avgFlipSpeed
        self.totalTrades = totalTrades
        self.totalProfit = totalProfit
        self.maxDrawdown = maxDrawdown
        self.confidenceLevel = confidenceLevel
        self.riskLevel = riskLevel
        self.botVersion = botVersion
        self.generationLevel = generationLevel
        self.dnaPattern = dnaPattern
        self.activeSessions = activeSessions
        self.lastTradeTime = lastTradeTime
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    // MARK: - Helper Methods
    
    func updateStats(
        winRate: Double,
        totalProfit: Double,
        totalTrades: Int,
        maxDrawdown: Double? = nil
    ) -> BotModel {
        BotModel(
            id: self.id,
            name: self.name,
            strategyType: self.strategyType,
            trainingScore: self.trainingScore,
            winRate: winRate,
            avgFlipSpeed: self.avgFlipSpeed,
            totalTrades: totalTrades,
            totalProfit: totalProfit,
            maxDrawdown: maxDrawdown ?? self.maxDrawdown,
            confidenceLevel: self.confidenceLevel,
            riskLevel: self.riskLevel,
            botVersion: self.botVersion,
            generationLevel: self.generationLevel,
            dnaPattern: self.dnaPattern,
            activeSessions: self.activeSessions,
            lastTradeTime: Date(),
            createdAt: self.createdAt,
            updatedAt: Date()
        )
    }
    
    func evolveToNextGeneration() -> BotModel {
        let newDNA = BotDNA(
            entryRules: dnaPattern.entryRules + ["enhanced_pattern_recognition"],
            exitRules: dnaPattern.exitRules + ["dynamic_exit_strategy"],
            riskManagement: dnaPattern.riskManagement,
            timeframes: dnaPattern.timeframes,
            indicators: dnaPattern.indicators + ["Custom_Indicator_\(generationLevel + 1)"],
            sessionPreferences: dnaPattern.sessionPreferences,
            adaptabilityScore: min(100.0, dnaPattern.adaptabilityScore + 5.0),
            evolutionHistory: dnaPattern.evolutionHistory + ["Generation \(generationLevel + 1): Enhanced capabilities"]
        )
        
        return BotModel(
            id: self.id,
            name: self.name,
            strategyType: self.strategyType,
            trainingScore: min(100.0, self.trainingScore + 2.0),
            winRate: self.winRate,
            avgFlipSpeed: self.avgFlipSpeed,
            totalTrades: self.totalTrades,
            totalProfit: self.totalProfit,
            maxDrawdown: self.maxDrawdown,
            confidenceLevel: min(100.0, self.confidenceLevel + 1.0),
            riskLevel: self.riskLevel,
            botVersion: self.botVersion,
            generationLevel: self.generationLevel + 1,
            dnaPattern: newDNA,
            activeSessions: self.activeSessions,
            lastTradeTime: self.lastTradeTime,
            createdAt: self.createdAt,
            updatedAt: Date()
        )
    }
    
    // MARK: - Conversion Methods
    
    func toDatabaseBot() -> DatabaseBot {
        let dnaString = try? String(data: JSONEncoder().encode(dnaPattern), encoding: .utf8)
        
        return DatabaseBot(
            id: id,
            name: name,
            strategyType: strategyType.rawValue,
            trainingScore: trainingScore,
            winRate: winRate,
            avgFlipSpeed: avgFlipSpeed,
            totalTrades: totalTrades,
            totalProfit: totalProfit,
            maxDrawdown: maxDrawdown,
            confidenceLevel: confidenceLevel,
            riskLevel: riskLevel.rawValue,
            botVersion: botVersion,
            generationLevel: generationLevel,
            dnaPattern: dnaString,
            learningData: nil,
            activeSessions: activeSessions,
            lastTradeTime: lastTradeTime,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
    
    static func fromDatabaseBot(_ dbBot: DatabaseBot) -> BotModel {
        var dnaPattern = BotDNA.default
        
        if let dnaDict = dbBot.dnaPattern,
           let dnaData = try? JSONSerialization.data(withJSONObject: dnaDict, options: []),
           let decodedDNA = try? JSONDecoder().decode(BotDNA.self, from: dnaData) {
            dnaPattern = decodedDNA
        }
        
        return BotModel(
            id: dbBot.id,
            name: dbBot.name,
            strategyType: BotStrategy(rawValue: dbBot.strategyType) ?? .scalping,
            trainingScore: dbBot.trainingScore,
            winRate: dbBot.winRate,
            avgFlipSpeed: dbBot.avgFlipSpeed,
            totalTrades: dbBot.totalTrades,
            totalProfit: dbBot.totalProfit,
            maxDrawdown: dbBot.maxDrawdown,
            confidenceLevel: dbBot.confidenceLevel,
            riskLevel: TradingTypes.RiskLevel(rawValue: dbBot.riskLevel) ?? .medium,
            botVersion: dbBot.botVersion,
            generationLevel: dbBot.generationLevel,
            dnaPattern: dnaPattern,
            activeSessions: dbBot.activeSessions,
            lastTradeTime: dbBot.lastTradeTime,
            createdAt: dbBot.createdAt,
            updatedAt: dbBot.updatedAt
        )
    }
}

// MARK: - Sample Data

extension BotModel {
    static let sampleBots: [BotModel] = [
        BotModel(
            name: "GoldSniper-X1",
            strategyType: .scalping,
            trainingScore: 92.5,
            winRate: 87.5,
            avgFlipSpeed: 45.0,
            totalTrades: 1250,
            totalProfit: 12450.75,
            maxDrawdown: 3.2,
            confidenceLevel: 91.0,
            riskLevel: .medium,
            generationLevel: 3,
            lastTradeTime: Date().addingTimeInterval(-1800)
        ),
        BotModel(
            name: "SwiftSweep-Pro",
            strategyType: .breakout,
            trainingScore: 88.0,
            winRate: 76.2,
            avgFlipSpeed: 120.0,
            totalTrades: 892,
            totalProfit: 8750.50,
            maxDrawdown: 5.8,
            confidenceLevel: 84.5,
            riskLevel: .high,
            generationLevel: 2,
            lastTradeTime: Date().addingTimeInterval(-3600)
        ),
        BotModel(
            name: "TrendMaster-AI",
            strategyType: .trendFollowing,
            trainingScore: 95.0,
            winRate: 82.1,
            avgFlipSpeed: 180.0,
            totalTrades: 654,
            totalProfit: 15200.75,
            maxDrawdown: 4.1,
            confidenceLevel: 96.2,
            riskLevel: .medium,
            generationLevel: 4,
            lastTradeTime: Date().addingTimeInterval(-900)
        ),
        BotModel(
            name: "PrecisionBot-V2",
            strategyType: .swing,
            trainingScore: 89.5,
            winRate: 79.8,
            avgFlipSpeed: 240.0,
            totalTrades: 445,
            totalProfit: 9100.25,
            maxDrawdown: 2.9,
            confidenceLevel: 87.8,
            riskLevel: .low,
            generationLevel: 2,
            lastTradeTime: Date().addingTimeInterval(-7200)
        ),
        BotModel(
            name: "Lightning-Scalper",
            strategyType: .scalping,
            trainingScore: 91.0,
            winRate: 85.0,
            avgFlipSpeed: 30.0,
            totalTrades: 2150,
            totalProfit: 8950.00,
            maxDrawdown: 4.5,
            confidenceLevel: 89.5,
            riskLevel: .medium,
            generationLevel: 3,
            lastTradeTime: Date().addingTimeInterval(-600)
        )
    ]
}

// MARK: - Preview

#Preview {
    VStack(spacing: 20) {
        ForEach(BotModel.sampleBots.prefix(3)) { bot in
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(bot.name)
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        Text(bot.strategyType.displayName)
                            .font(.subheadline)
                            .foregroundColor(bot.strategyType.color)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text(bot.formattedProfit)
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                        
                        Text("Universe Score: \(bot.formattedUniverseScore)")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                }
                
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Win Rate: \(bot.formattedWinRate)")
                            .font(.footnote)

                        Text("Trades: \(bot.totalTrades)")
                            .font(.footnote)

                        Text("Drawdown: \(bot.formattedDrawdown)")
                            .font(.footnote)

                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 2) {
                        Label(bot.currentStatus.displayName, systemImage: bot.currentStatus.systemImage)
                            .font(.footnote)
                            .foregroundColor(bot.currentStatus.color)
                        
                        Text("\(bot.generationTitle) Gen \(bot.generationLevel)")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                        
                        Text(bot.rankTitle)
                            .font(.footnote)
                            .foregroundColor(.gold)
                    }
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
    }
    .padding()
    .background(DesignSystem.backgroundGradient)
}