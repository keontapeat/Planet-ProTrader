//
//  HomeDashboardViewModel.swift
//  Planet ProTrader - Dashboard Logic
//
//  Advanced Dashboard Management System
//  Created by Elite Engineering Team
//

import SwiftUI
import Foundation
import Combine

// MARK: - Home Dashboard View Model

@MainActor
class HomeDashboardViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var isLoading = false
    @Published var selectedTimeframe: Timeframe = .hour
    @Published var showingBotDetails = false
    @Published var selectedBot: TradingBot?
    @Published var refreshTimestamp = Date()
    @Published var dashboardMetrics = DashboardMetrics()
    
    // MARK: - Dashboard Data
    @Published var featuredBots: [TradingBot] = []
    @Published var topPerformers: [TradingBot] = []
    @Published var recentSignals: [GoldSignal] = []
    @Published var marketOverview = MarketOverview()
    @Published var portfolioSummary = PortfolioSummary()
    
    // MARK: - UI State
    @Published var animationTrigger = false
    @Published var cardAnimationDelay: Double = 0
    @Published var showAllBots = false
    @Published var expandedSections: Set<DashboardSection> = []
    
    enum Timeframe: String, CaseIterable {
        case minute = "1M"
        case fiveMinute = "5M"
        case fifteenMinute = "15M"
        case hour = "1H"
        case fourHour = "4H"
        case day = "1D"
        
        var displayName: String {
            switch self {
            case .minute: return "1 Minute"
            case .fiveMinute: return "5 Minutes"
            case .fifteenMinute: return "15 Minutes"
            case .hour: return "1 Hour"
            case .fourHour: return "4 Hours"
            case .day: return "Daily"
            }
        }
    }
    
    enum DashboardSection: String, CaseIterable {
        case bots = "bots"
        case portfolio = "portfolio"
        case signals = "signals"
        case market = "market"
        case performance = "performance"
    }
    
    // MARK: - Data Structures
    
    struct DashboardMetrics {
        var totalEquity: Double = 11247.85
        var dailyPnL: Double = 247.85
        var weeklyPnL: Double = 1456.23
        var monthlyPnL: Double = 4789.67
        var totalTrades: Int = 2847
        var winningTrades: Int = 2494
        var activeBots: Int = 7
        var aiConfidence: Double = 0.947
        
        var winRate: Double {
            totalTrades > 0 ? Double(winningTrades) / Double(totalTrades) : 0
        }
        
        var formattedEquity: String {
            formatCurrency(totalEquity)
        }
        
        var formattedDailyPnL: String {
            formatCurrency(dailyPnL, showSign: true)
        }
        
        var formattedWeeklyPnL: String {
            formatCurrency(weeklyPnL, showSign: true)
        }
        
        var formattedMonthlyPnL: String {
            formatCurrency(monthlyPnL, showSign: true)
        }
        
        var formattedWinRate: String {
            String(format: "%.1f%%", winRate * 100)
        }
        
        var formattedAIConfidence: String {
            String(format: "%.1f%%", aiConfidence * 100)
        }
        
        private func formatCurrency(_ value: Double, showSign: Bool = false) -> String {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.currencyCode = "USD"
            if showSign && value > 0 {
                formatter.positivePrefix = "+"
            }
            return formatter.string(from: NSNumber(value: value)) ?? "$0.00"
        }
    }
    
    struct MarketOverview {
        var goldPrice: Double = 2374.85
        var priceChange: Double = 12.45
        var priceChangePercent: Double = 0.53
        var high24h: Double = 2387.25
        var low24h: Double = 2364.80
        var volume: Double = 125487
        var marketSentiment: MarketSentiment = .bullish
        var volatility: Volatility = .medium
        
        enum MarketSentiment: String, CaseIterable {
            case veryBullish = "Very Bullish"
            case bullish = "Bullish"
            case neutral = "Neutral"
            case bearish = "Bearish"
            case veryBearish = "Very Bearish"
            
            var color: Color {
                switch self {
                case .veryBullish: return .green
                case .bullish: return .mint
                case .neutral: return .gray
                case .bearish: return .orange
                case .veryBearish: return .red
                }
            }
            
            var icon: String {
                switch self {
                case .veryBullish: return "arrow.up.circle.fill"
                case .bullish: return "arrow.up.circle"
                case .neutral: return "minus.circle"
                case .bearish: return "arrow.down.circle"
                case .veryBearish: return "arrow.down.circle.fill"
                }
            }
        }
        
        enum Volatility: String, CaseIterable {
            case veryLow = "Very Low"
            case low = "Low"
            case medium = "Medium"
            case high = "High"
            case extreme = "Extreme"
            
            var color: Color {
                switch self {
                case .veryLow: return .green
                case .low: return .blue
                case .medium: return .orange
                case .high: return .red
                case .extreme: return .purple
                }
            }
        }
        
        var formattedPrice: String {
            String(format: "$%.2f", goldPrice)
        }
        
        var formattedChange: String {
            let sign = priceChange >= 0 ? "+" : ""
            return "\(sign)$\(String(format: "%.2f", priceChange))"
        }
        
        var formattedChangePercent: String {
            let sign = priceChangePercent >= 0 ? "+" : ""
            return "\(sign)\(String(format: "%.2f", priceChangePercent))%"
        }
        
        var changeColor: Color {
            priceChange >= 0 ? .bullishGreen : .bearishRed
        }
    }
    
    struct PortfolioSummary {
        var totalValue: Double = 11247.85
        var dayChange: Double = 247.85
        var weekChange: Double = 1456.23
        var monthChange: Double = 4789.67
        var ytdChange: Double = 8934.56
        var allocations: [AssetAllocation] = []
        var riskScore: Double = 0.65
        var diversificationScore: Double = 0.78
        
        struct AssetAllocation: Identifiable {
            let id = UUID()
            let name: String
            let percentage: Double
            let value: Double
            let color: Color
        }
        
        init() {
            self.allocations = [
                AssetAllocation(name: "Gold", percentage: 0.45, value: 5061.53, color: .premiumGold),
                AssetAllocation(name: "Forex", percentage: 0.30, value: 3374.36, color: .blue),
                AssetAllocation(name: "Crypto", percentage: 0.15, value: 1687.18, color: .orange),
                AssetAllocation(name: "Indices", percentage: 0.10, value: 1124.79, color: .purple)
            ]
        }
        
        var formattedTotalValue: String {
            formatCurrency(totalValue)
        }
        
        var formattedDayChange: String {
            formatCurrency(dayChange, showSign: true)
        }
        
        var formattedRiskScore: String {
            String(format: "%.0f/100", riskScore * 100)
        }
        
        var riskLevel: String {
            switch riskScore {
            case 0..<0.3: return "Conservative"
            case 0.3..<0.7: return "Moderate"
            default: return "Aggressive"
            }
        }
        
        private func formatCurrency(_ value: Double, showSign: Bool = false) -> String {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.currencyCode = "USD"
            if showSign && value > 0 {
                formatter.positivePrefix = "+"
            }
            return formatter.string(from: NSNumber(value: value)) ?? "$0.00"
        }
    }
    
    // MARK: - Combine Storage
    private var cancellables = Set<AnyCancellable>()
    private var refreshTimer: Timer?
    
    // MARK: - Initialization
    
    init() {
        setupInitialData()
        startAutoRefresh()
        setupAnimations()
    }
    
    deinit {
        stopAutoRefresh()
    }
    
    // MARK: - Public Methods
    
    func refreshAllData() async {
        isLoading = true
        
        async let botsUpdate = updateFeaturedBots()
        async let signalsUpdate = updateRecentSignals()
        async let marketUpdate = updateMarketOverview()
        async let metricsUpdate = updateDashboardMetrics()
        
        // Wait for all updates to complete
        _ = await (botsUpdate, signalsUpdate, marketUpdate, metricsUpdate)
        
        refreshTimestamp = Date()
        isLoading = false
        
        triggerCardAnimations()
    }
    
    func selectBot(_ bot: TradingBot) {
        selectedBot = bot
        showingBotDetails = true
        HapticFeedbackManager.shared.selection()
    }
    
    func toggleSection(_ section: DashboardSection) {
        if expandedSections.contains(section) {
            expandedSections.remove(section)
        } else {
            expandedSections.insert(section)
        }
        HapticFeedbackManager.shared.impact(.light)
    }
    
    func changeTimeframe(_ timeframe: Timeframe) {
        selectedTimeframe = timeframe
        Task {
            await refreshMarketData()
        }
    }
    
    // MARK: - Private Methods
    
    private func setupInitialData() {
        featuredBots = Array(SampleDataProvider.premiumBots.prefix(6))
        topPerformers = SampleDataProvider.premiumBots.sorted { $0.performance > $1.performance }.prefix(3).map { $0 }
        recentSignals = Array(SampleDataProvider.goldSignals.prefix(5))
        dashboardMetrics = DashboardMetrics()
        marketOverview = MarketOverview()
        portfolioSummary = PortfolioSummary()
    }
    
    private func startAutoRefresh() {
        refreshTimer = Timer.scheduledTimer(withTimeInterval: 30.0, repeats: true) { [weak self] _ in
            Task {
                await self?.updateRealTimeData()
            }
        }
    }
    
    private func stopAutoRefresh() {
        refreshTimer?.invalidate()
        refreshTimer = nil
    }
    
    private func setupAnimations() {
        // Trigger initial animations after a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.triggerCardAnimations()
        }
    }
    
    private func triggerCardAnimations() {
        withAnimation(.spring(response: 0.8, dampingFraction: 0.8)) {
            animationTrigger.toggle()
        }
    }
    
    private func updateRealTimeData() async {
        // Update only critical real-time data
        await updateMarketOverview()
        await updateDashboardMetrics()
        
        refreshTimestamp = Date()
    }
    
    private func updateFeaturedBots() async {
        // Simulate API call delay
        try? await Task.sleep(nanoseconds: 300_000_000)
        
        // Update bot performance with small random changes
        for i in featuredBots.indices {
            let performanceChange = Double.random(in: -0.5...1.2)
            let newTrades = Int.random(in: 0...3)
            
            featuredBots[i] = TradingBot(
                id: featuredBots[i].id,
                name: featuredBots[i].name,
                strategy: featuredBots[i].strategy,
                riskLevel: featuredBots[i].riskLevel,
                isActive: featuredBots[i].isActive,
                winRate: min(0.95, max(0.6, featuredBots[i].winRate + Double.random(in: -0.005...0.01))),
                totalTrades: featuredBots[i].totalTrades + newTrades,
                profitLoss: featuredBots[i].profitLoss + (performanceChange * 10),
                performance: featuredBots[i].performance + performanceChange,
                lastUpdate: Date(),
                status: featuredBots[i].status,
                profit: featuredBots[i].profit + (performanceChange * 10),
                icon: featuredBots[i].icon,
                primaryColor: featuredBots[i].primaryColor,
                secondaryColor: featuredBots[i].secondaryColor
            )
        }
        
        // Update top performers
        topPerformers = featuredBots.sorted { $0.performance > $1.performance }.prefix(3).map { $0 }
    }
    
    private func updateRecentSignals() async {
        try? await Task.sleep(nanoseconds: 200_000_000)
        
        // Randomly update signal statuses
        for i in recentSignals.indices {
            if Double.random(in: 0...1) > 0.7 {
                let newStatus: GoldSignal.SignalStatus = [.active, .filled, .cancelled, .pending].randomElement() ?? .active
                recentSignals[i] = GoldSignal(
                    id: recentSignals[i].id,
                    timestamp: recentSignals[i].timestamp,
                    type: recentSignals[i].type,
                    entryPrice: recentSignals[i].entryPrice,
                    stopLoss: recentSignals[i].stopLoss,
                    takeProfit: recentSignals[i].takeProfit,
                    confidence: recentSignals[i].confidence,
                    reasoning: recentSignals