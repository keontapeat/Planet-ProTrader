//
//  HomeDashboardViewModel.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 7/13/25.
//

import SwiftUI
import Combine

@MainActor
class HomeDashboardViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var isLiveTrading = false
    @Published var activeFlips: [SharedTypes.ActiveFlip] = []
    @Published var recentFlipCompletions: [SharedTypes.FlipCompletion] = []
    @Published var autoTradingStatus: SharedTypes.AutoTradingStatus = SharedTypes.AutoTradingStatus.sample
    @Published var connectedAccounts: [SharedTypes.ConnectedAccount] = []
    @Published var performanceMetrics: SharedTypes.PerformanceMetrics = SharedTypes.PerformanceMetrics.sample
    @Published var tradingSessions: [SharedTypes.TradingSession] = []
    @Published var todaysAIInsight: SharedTypes.AIInsight = SharedTypes.AIInsight.sample
    @Published var recentActivities: [SharedTypes.RecentActivity] = []
    
    // MARK: - Private Properties
    
    private var cancellables = Set<AnyCancellable>()
    private var updateTimer: Timer?
    
    // MARK: - Initialization
    
    init() {
        loadInitialData()
    }
    
    // MARK: - Public Methods
    
    func startLiveUpdates() {
        updateTimer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { _ in
            Task { @MainActor in
                await self.refreshData()
            }
        }
    }
    
    func stopLiveUpdates() {
        updateTimer?.invalidate()
        updateTimer = nil
    }
    
    func refreshData() async {
        // Simulate API calls with delays
        try? await Task.sleep(for: .seconds(0.5))
        
        // Update trading status
        isLiveTrading = Bool.random()
        
        // Update auto trading status
        autoTradingStatus = SharedTypes.AutoTradingStatus(
            isActive: Bool.random(),
            mode: .auto,
            confidence: Double.random(in: 0.75...0.95),
            tradesThisSession: Int.random(in: 5...15),
            profit: Double.random(in: 100...500)
        )
        
        // Update performance metrics
        performanceMetrics = SharedTypes.PerformanceMetrics(
            totalTrades: Int.random(in: 50...200),
            winRate: Double.random(in: 0.75...0.90),
            totalProfit: Double.random(in: 1000...5000),
            averageWin: Double.random(in: 50...100),
            averageLoss: Double.random(in: 30...60),
            profitFactor: Double.random(in: 1.2...2.5)
        )
        
        // Update AI insight
        updateAIInsight()
        
        // Update recent activities
        updateRecentActivities()
    }
    
    // MARK: - Private Methods
    
    private func loadInitialData() {
        // Load active flips
        activeFlips = []
        
        // Load recent flip completions
        recentFlipCompletions = []
        
        // Load connected accounts
        connectedAccounts = []
        
        // Load trading sessions
        tradingSessions = []
        
        // Load recent activities
        recentActivities = []
    }
    
    private func updateAIInsight() {
        let insights = [
            "London session showing exceptional momentum with 87.2% win rate. Strong institutional flow detected at current levels.",
            "Smart money accumulation pattern identified at 2,374.50 support. High probability reversal setup forming.",
            "Multi-timeframe alignment confirms bullish continuation. 4H structure remains intact with strong volume.",
            "Risk-off sentiment creating opportunities in safe-haven assets. Gold positioning favors long-term bulls.",
            "Algorithmic trading patterns suggest major move incoming. Confluence of technical factors aligning perfectly."
        ]
        
        todaysAIInsight = SharedTypes.AIInsight(
            id: UUID().uuidString,
            title: "Daily AI Insight",
            description: insights.randomElement() ?? insights[0],
            priority: .high,
            timestamp: Date()
        )
    }
    
    private func updateRecentActivities() {
        let activities = [
            SharedTypes.RecentActivity(
                id: UUID().uuidString,
                description: "LONG XAUUSD at 2,374.50",
                type: .signal,
                timestamp: Date().addingTimeInterval(-120) // 2 minutes ago
            ),
            SharedTypes.RecentActivity(
                id: UUID().uuidString,
                description: "+$1,247.80 profit",
                type: .trade,
                timestamp: Date().addingTimeInterval(-900) // 15 minutes ago
            ),
            SharedTypes.RecentActivity(
                id: UUID().uuidString,
                description: "Demo_001: $2,847 (+184%)",
                type: .analysis,
                timestamp: Date().addingTimeInterval(-1320) // 22 minutes ago
            ),
            SharedTypes.RecentActivity(
                id: UUID().uuidString,
                description: "Server #3 online",
                type: .analysis,
                timestamp: Date().addingTimeInterval(-3600) // 1 hour ago
            ),
            SharedTypes.RecentActivity(
                id: UUID().uuidString,
                description: "Drawdown limit reached",
                type: .alert,
                timestamp: Date().addingTimeInterval(-7200) // 2 hours ago
            )
        ]
        
        recentActivities = activities.shuffled()
    }
}