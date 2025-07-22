//
//  TradingBotManager.swift
//  Planet ProTrader
//
//  ✅ TRADING BOT MANAGER - Complete bot management system
//

import SwiftUI

@MainActor
class TradingBotManager: ObservableObject {
    static let shared = TradingBotManager()
    
    @Published var allBots: [CoreTypes.TradingBot] = []
    @Published var isLoading = false
    @Published var lastUpdate = Date()
    
    private init() {
        loadInitialBots()
        startRealTimeUpdates()
    }
    
    var activeBots: [CoreTypes.TradingBot] {
        allBots.filter { $0.isActive }
    }
    
    var inactiveBots: [CoreTypes.TradingBot] {
        allBots.filter { !$0.isActive }
    }
    
    private func loadInitialBots() {
        allBots = SampleData.sampleBots
        lastUpdate = Date()
    }
    
    private func startRealTimeUpdates() {
        Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
            Task { @MainActor in
                self.updateBotPerformance()
            }
        }
    }
    
    private func updateBotPerformance() {
        for i in allBots.indices {
            // Simulate performance updates
            let performanceChange = Double.random(in: -0.5...1.0)
            allBots[i] = CoreTypes.TradingBot(
                id: allBots[i].id,
                name: allBots[i].name,
                strategy: allBots[i].strategy,
                riskLevel: allBots[i].riskLevel,
                isActive: allBots[i].isActive,
                winRate: allBots[i].winRate,
                totalTrades: allBots[i].totalTrades,
                profitLoss: allBots[i].profitLoss,
                performance: max(0, allBots[i].performance + performanceChange),
                lastUpdate: Date(),
                status: allBots[i].status,
                profit: allBots[i].profit + performanceChange * 10,
                icon: allBots[i].icon,
                primaryColor: allBots[i].primaryColor,
                secondaryColor: allBots[i].secondaryColor
            )
        }
        
        lastUpdate = Date()
    }
    
    func addBot(_ bot: CoreTypes.TradingBot) {
        allBots.append(bot)
    }
    
    func removeBot(_ bot: CoreTypes.TradingBot) {
        allBots.removeAll { $0.id == bot.id }
    }
    
    func toggleBot(_ bot: CoreTypes.TradingBot) {
        if let index = allBots.firstIndex(where: { $0.id == bot.id }) {
            allBots[index] = CoreTypes.TradingBot(
                id: bot.id,
                name: bot.name,
                strategy: bot.strategy,
                riskLevel: bot.riskLevel,
                isActive: !bot.isActive,
                winRate: bot.winRate,
                totalTrades: bot.totalTrades,
                profitLoss: bot.profitLoss,
                performance: bot.performance,
                lastUpdate: Date(),
                status: !bot.isActive ? .trading : .inactive,
                profit: bot.profit,
                icon: bot.icon,
                primaryColor: bot.primaryColor,
                secondaryColor: bot.secondaryColor
            )
        }
    }
    
    func refreshBots() async {
        isLoading = true
        // Simulate API call
        try? await Task.sleep(for: .seconds(1))
        updateBotPerformance()
        isLoading = false
    }
}