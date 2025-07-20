//
//  ProTraderBotManager.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 1/25/25.
//

import SwiftUI
import Foundation

@MainActor
class ProTraderBotManager: ObservableObject {
    @Published var activeBots: [TradingBot] = []
    @Published var totalBots: Int = 0
    @Published var totalProfit: Double = 0.0
    @Published var totalTrades: Int = 0
    @Published var overallWinRate: Double = 0.0
    @Published var totalTradingVolume: Double = 0.0
    @Published var areAllBotsActive = false
    
    var bestPerformingBot: TradingBot? {
        activeBots.max(by: { $0.profitLoss < $1.profitLoss })
    }
    
    var mostActiveBot: TradingBot? {
        activeBots.max(by: { $0.tradesCount < $1.tradesCount })
    }
    
    var highestWinRateBot: TradingBot? {
        activeBots.max(by: { $0.winRate < $1.winRate })
    }
    
    init() {
        generateSampleBots()
        updateStatistics()
    }
    
    func refreshBots() async {
        try? await Task.sleep(for: .seconds(1))
        updateStatistics()
    }
    
    func toggleAllBots() async {
        areAllBotsActive.toggle()
        
        for i in 0..<activeBots.count {
            activeBots[i].status = areAllBotsActive ? .active : .paused
        }
    }
    
    private func generateSampleBots() {
        activeBots = [
            TradingBot(
                id: "1",
                name: "Gold Scalper Pro",
                strategy: "Scalping",
                status: .active,
                profitLoss: 1250.75,
                winRate: 78.5,
                tradesCount: 145,
                lastTradeTime: Date().addingTimeInterval(-300)
            ),
            TradingBot(
                id: "2",
                name: "Trend Master",
                strategy: "Trend Following",
                status: .active,
                profitLoss: 890.25,
                winRate: 65.2,
                tradesCount: 89,
                lastTradeTime: Date().addingTimeInterval(-600)
            ),
            TradingBot(
                id: "3",
                name: "Swing Trader Elite",
                strategy: "Swing Trading",
                status: .paused,
                profitLoss: 456.80,
                winRate: 72.3,
                tradesCount: 67,
                lastTradeTime: Date().addingTimeInterval(-1800)
            )
        ]
        
        totalBots = activeBots.count
    }
    
    private func updateStatistics() {
        totalProfit = activeBots.reduce(0) { $0 + $1.profitLoss }
        totalTrades = activeBots.reduce(0) { $0 + $1.tradesCount }
        
        if !activeBots.isEmpty {
            overallWinRate = activeBots.reduce(0) { $0 + $1.winRate } / Double(activeBots.count)
        }
        
        totalTradingVolume = Double.random(in: 50000...100000)
        areAllBotsActive = activeBots.allSatisfy { $0.status == .active }
    }
}

struct TradingBot: Identifiable, Codable {
    let id: String
    let name: String
    let strategy: String
    var status: BotStatus
    let profitLoss: Double
    let winRate: Double
    let tradesCount: Int
    let lastTradeTime: Date
}

enum BotStatus: String, CaseIterable, Codable {
    case active = "Active"
    case paused = "Paused"
    case stopped = "Stopped"
    case error = "Error"
    
    var color: Color {
        switch self {
        case .active:
            return .green
        case .paused:
            return .orange
        case .stopped:
            return .gray
        case .error:
            return .red
        }
    }
}