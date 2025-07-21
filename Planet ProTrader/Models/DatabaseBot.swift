//
//  DatabaseBot.swift
//  Planet ProTrader
//
//  Created by AI Assistant on 1/25/25.
//

import Foundation
import SwiftUI

// MARK: - Database Bot Model

struct DatabaseBot: Identifiable, Codable {
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
    let learningData: [String: Any]?
    let activeSessions: Int
    let lastTradeTime: Date?
    let createdAt: Date
    let updatedAt: Date
    
    // MARK: - Computed Properties
    
    var formattedProfit: String {
        if totalProfit >= 1000 {
            return String(format: "$%.1fK", totalProfit / 1000)
        } else {
            return String(format: "$%.2f", totalProfit)
        }
    }
    
    var formattedWinRate: String {
        return String(format: "%.1f%%", winRate)
    }
    
    var statusColor: Color {
        if let lastTrade = lastTradeTime {
            let timeSinceLastTrade = Date().timeIntervalSince(lastTrade)
            if timeSinceLastTrade < 3600 { // Less than 1 hour
                return .green
            } else if timeSinceLastTrade < 86400 { // Less than 24 hours
                return .orange
            } else {
                return .red
            }
        }
        return .gray
    }
    
    var statusText: String {
        if let lastTrade = lastTradeTime {
            let timeSinceLastTrade = Date().timeIntervalSince(lastTrade)
            if timeSinceLastTrade < 3600 {
                return "Active"
            } else if timeSinceLastTrade < 86400 {
                return "Recently Active"
            } else {
                return "Inactive"
            }
        }
        return "Never Traded"
    }
    
    // MARK: - Initializer
    
    init(
        id: UUID = UUID(),
        name: String,
        strategyType: String,
        trainingScore: Double = 0.0,
        winRate: Double = 0.0,
        avgFlipSpeed: Double = 0.0,
        totalTrades: Int = 0,
        totalProfit: Double = 0.0,
        maxDrawdown: Double = 0.0,
        confidenceLevel: Double = 0.0,
        riskLevel: String = "medium",
        botVersion: String = "1.0.0",
        generationLevel: Int = 1,
        dnaPattern: String? = nil,
        learningData: [String: Any]? = nil,
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
        self.learningData = learningData
        self.activeSessions = activeSessions
        self.lastTradeTime = lastTradeTime
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

// MARK: - Sample Data

extension DatabaseBot {
    static let sampleBots: [DatabaseBot] = [
        DatabaseBot(
            name: "GoldSniper-X1",
            strategyType: "scalping",
            trainingScore: 92.5,
            winRate: 87.5,
            totalTrades: 1250,
            totalProfit: 12450.75,
            maxDrawdown: 3.2,
            confidenceLevel: 91.0,
            generationLevel: 3,
            lastTradeTime: Date().addingTimeInterval(-1800)
        ),
        DatabaseBot(
            name: "SwiftSweep-Pro",
            strategyType: "breakout",
            trainingScore: 88.0,
            winRate: 76.2,
            totalTrades: 892,
            totalProfit: 8750.50,
            maxDrawdown: 5.8,
            confidenceLevel: 84.5,
            generationLevel: 2,
            lastTradeTime: Date().addingTimeInterval(-3600)
        ),
        DatabaseBot(
            name: "TrendMaster-AI",
            strategyType: "trend_following",
            trainingScore: 95.0,
            winRate: 82.1,
            totalTrades: 654,
            totalProfit: 15200.75,
            maxDrawdown: 4.1,
            confidenceLevel: 96.2,
            generationLevel: 4,
            lastTradeTime: Date().addingTimeInterval(-900)
        )
    ]
}

#Preview {
    VStack(spacing: 16) {
        ForEach(DatabaseBot.sampleBots) { bot in
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(bot.name)
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Text(bot.formattedProfit)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                }
                
                HStack {
                    Text("Win Rate: \(bot.formattedWinRate)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text(bot.statusText)
                        .font(.caption)
                        .foregroundColor(bot.statusColor)
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
    }
    .padding()
}
