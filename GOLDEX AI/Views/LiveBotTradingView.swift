//
//  LiveBotTradingView.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 1/25/25.
//

import SwiftUI

struct LiveBotTradingView: View {
    @StateObject private var liveTrading = LiveTradingManager()
    @State private var selectedBot: LiveBot?
    @State private var showingBotDetail = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Live trading header
                    liveTradingHeader
                    
                    // Active bots grid
                    activeBotsTradingGrid
                    
                    // Market overview
                    marketOverviewSection
                }
                .padding()
            }
            .navigationTitle("Live Trading")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button("Start All Bots", systemImage: "play.fill") {
                            liveTrading.startAllBots()
                        }
                        Button("Emergency Stop", systemImage: "stop.fill") {
                            liveTrading.emergencyStopAll()
                        }
                        Button("Bot Performance", systemImage: "chart.bar") {
                            // Show performance
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .foregroundColor(DesignSystem.primaryGold)
                    }
                }
            }
            .refreshable {
                await liveTrading.refreshLiveData()
            }
        }
        .sheet(isPresented: $showingBotDetail) {
            if let bot = selectedBot {
                LiveBotDetailView(bot: bot)
            }
        }
        .onAppear {
            liveTrading.startLiveTracking()
        }
    }
    
    // MARK: - Live Trading Header
    
    private var liveTradingHeader: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("🔴 LIVE TRADING")
                        .font(.caption)
                        .foregroundColor(.red)
                        .fontWeight(.bold)
                    
                    Text("$\(Int(liveTrading.totalProfitToday))")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                }
                
                Spacer()
                
                VStack(alignment: .center, spacing: 4) {
                    Text("Active Bots")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("\(liveTrading.activeBots.count)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Win Rate")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("\(Int(liveTrading.averageWinRate))%")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(DesignSystem.primaryGold)
                }
            }
            
            // Real-time profit ticker
            HStack {
                Text("Real-time P&L:")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text(liveTrading.formatProfitChange(liveTrading.realTimePL))
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(liveTrading.realTimePL >= 0 ? .green : .red)
                    .animation(.easeInOut(duration: 0.3), value: liveTrading.realTimePL)
            }
            
            ProgressView(value: liveTrading.totalProfitToday, total: 100000) // $100K goal
                .progressViewStyle(LinearProgressViewStyle(tint: DesignSystem.primaryGold))
                .overlay(
                    HStack {
                        Text("Goal: $100K")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Text("\(Int((liveTrading.totalProfitToday / 100000) * 100))%")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundColor(DesignSystem.primaryGold)
                    }
                    .padding(.top, 4)
                )
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .green.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }
    
    // MARK: - Active Bots Trading Grid
    
    private var activeBotsTradingGrid: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("🤖 Live Trading Bots")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(DesignSystem.primaryGold)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                ForEach(liveTrading.activeBots) { bot in
                    liveBotCard(bot)
                }
            }
        }
    }
    
    private func liveBotCard(_ bot: LiveBot) -> some View {
        Button(action: {
            selectedBot = bot
            showingBotDetail = true
            HapticFeedbackManager.shared.impact(.light)
        }) {
            VStack(spacing: 12) {
                // Bot header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Circle()
                                .fill(bot.isTrading ? Color.green : Color.red)
                                .frame(width: 8, height: 8)
                                .scaleEffect(bot.isTrading ? 1.2 : 1.0)
                                .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: bot.isTrading)
                            
                            Text(bot.name)
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                        }
                        
                        Text(bot.strategy)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Text("🤖")
                        .font(.title3)
                }
                
                // Performance metrics
                VStack(spacing: 6) {
                    HStack {
                        Text("Today P&L:")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Text(liveTrading.formatProfitChange(bot.dailyPL))
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(bot.dailyPL >= 0 ? .green : .red)
                    }
                    
                    HStack {
                        Text("Win Rate:")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Text("\(Int(bot.winRate))%")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.blue)
                    }
                    
                    HStack {
                        Text("Trades:")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Text("\(bot.tradesCount)")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.orange)
                    }
                }
                
                // Current status
                if bot.isTrading {
                    HStack {
                        Text("📈 \(bot.currentPosition)")
                            .font(.caption2)
                            .foregroundColor(.green)
                        
                        Spacer()
                        
                        Text("\(bot.formatPrice(bot.currentPrice))")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(6)
                } else {
                    Text("🔍 Scanning markets...")
                        .font(.caption2)
                        .foregroundColor(.blue)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(6)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(bot.isTrading ? Color.green : Color.clear, lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // MARK: - Market Overview
    
    private var marketOverviewSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("📊 Market Overview")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.blue)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 12) {
                marketStat(title: "SPY", value: "$428.50", change: "+0.5%", color: .green)
                marketStat(title: "QQQ", value: "$365.20", change: "-0.2%", color: .red)
                marketStat(title: "BTC", value: "$43,250", change: "+2.1%", color: .green)
                marketStat(title: "ETH", value: "$2,580", change: "+1.8%", color: .green)
                marketStat(title: "VIX", value: "18.5", change: "-5.2%", color: .green)
                marketStat(title: "DXY", value: "102.4", change: "+0.3%", color: .green)
            }
        }
    }
    
    private func marketStat(title: String, value: String, change: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text(change)
                .font(.caption2)
                .fontWeight(.medium)
                .foregroundColor(color)
        }
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(.systemGray6))
        )
    }
}

// MARK: - Live Trading Manager

class LiveTradingManager: ObservableObject {
    @Published var activeBots: [LiveBot] = []
    @Published var totalProfitToday: Double = 0
    @Published var realTimePL: Double = 0
    @Published var averageWinRate: Double = 0
    @Published var isLiveTrading = false
    
    private var updateTimer: Timer?
    
    init() {
        setupLiveBots()
    }
    
    private func setupLiveBots() {
        activeBots = [
            LiveBot(
                name: "ScalpMaster Pro",
                strategy: "1min Scalping",
                dailyPL: 2340.50,
                winRate: 89.5,
                tradesCount: 47,
                isTrading: true,
                currentPosition: "Long AAPL",
                currentPrice: 185.67
            ),
            LiveBot(
                name: "TrendHunter AI",
                strategy: "Trend Following",
                dailyPL: 1820.75,
                winRate: 84.2,
                tradesCount: 23,
                isTrading: true,
                currentPosition: "Long TSLA",
                currentPrice: 248.90
            ),
            LiveBot(
                name: "GoldRush Elite",
                strategy: "Momentum",
                dailyPL: 3150.25,
                winRate: 91.3,
                tradesCount: 31,
                isTrading: false,
                currentPosition: "",
                currentPrice: 0
            ),
            LiveBot(
                name: "RiskMaster",
                strategy: "Options",
                dailyPL: 875.40,
                winRate: 78.5,
                tradesCount: 15,
                isTrading: true,
                currentPosition: "SPY Calls",
                currentPrice: 428.50
            )
        ]
        
        updateTotalProfit()
        calculateAverageWinRate()
    }
    
    func startLiveTracking() {
        isLiveTrading = true
        
        // Update every second for real-time feeling
        updateTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.updateLiveData()
        }
    }
    
    func stopLiveTracking() {
        isLiveTrading = false
        updateTimer?.invalidate()
        updateTimer = nil
    }
    
    private func updateLiveData() {
        // Simulate real-time updates
        for i in activeBots.indices {
            if activeBots[i].isTrading {
                // Simulate price movements
                let change = Double.random(in: -5...10)
                activeBots[i].dailyPL += change
                activeBots[i].currentPrice += Double.random(in: -1...1)
                
                // Simulate occasional trades
                if Int.random(in: 1...30) == 1 {
                    activeBots[i].tradesCount += 1
                }
            }
        }
        
        updateTotalProfit()
        updateRealTimePL()
    }
    
    private func updateTotalProfit() {
        totalProfitToday = activeBots.reduce(0) { $0 + $1.dailyPL }
    }
    
    private func updateRealTimePL() {
        let change = Double.random(in: -50...100)
        realTimePL += change
    }
    
    private func calculateAverageWinRate() {
        averageWinRate = activeBots.reduce(0) { $0 + $1.winRate } / Double(activeBots.count)
    }
    
    func startAllBots() {
        for i in activeBots.indices {
            activeBots[i].isTrading = true
        }
    }
    
    func emergencyStopAll() {
        for i in activeBots.indices {
            activeBots[i].isTrading = false
            activeBots[i].currentPosition = ""
        }
    }
    
    func refreshLiveData() async {
        // Simulate API refresh
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        updateLiveData()
    }
    
    func formatProfitChange(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        
        let prefix = amount >= 0 ? "+" : ""
        return "\(prefix)\(formatter.string(from: NSNumber(value: amount)) ?? "$0.00")"
    }
}

// MARK: - Live Bot Model

struct LiveBot: Identifiable, Codable {
    let id = UUID()
    var name: String
    var strategy: String
    var dailyPL: Double
    var winRate: Double
    var tradesCount: Int
    var isTrading: Bool
    var currentPosition: String
    var currentPrice: Double
    
    func formatPrice(_ price: Double) -> String {
        return String(format: "$%.2f", price)
    }
}

// MARK: - Live Bot Detail View

struct LiveBotDetailView: View {
    let bot: LiveBot
    @Environment(\.dismiss) private var dismiss
    @StateObject private var chartData = BotChartData()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Bot header
                    botHeaderSection
                    
                    // Live performance chart
                    livePerformanceChart
                    
                    // Recent trades
                    recentTradesSection
                    
                    // Controls
                    botControlsSection
                }
                .padding()
            }
            .navigationTitle(bot.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(DesignSystem.primaryGold)
                }
            }
        }
        .onAppear {
            chartData.startLiveUpdates(for: bot.id)
        }
        .onDisappear {
            chartData.stopLiveUpdates()
        }
    }
    
    private var botHeaderSection: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Circle()
                            .fill(bot.isTrading ? Color.green : Color.red)
                            .frame(width: 12, height: 12)
                        
                        Text(bot.isTrading ? "TRADING LIVE" : "IDLE")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(bot.isTrading ? .green : .red)
                    }
                    
                    Text(bot.strategy)
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    if bot.isTrading && !bot.currentPosition.isEmpty {
                        Text("Current: \(bot.currentPosition)")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                }
                
                Spacer()
                
                Text("🤖")
                    .font(.system(size: 60))
            }
            
            // Performance metrics
            HStack(spacing: 20) {
                metricItem(title: "Today P&L", value: LiveTradingManager().formatProfitChange(bot.dailyPL), color: bot.dailyPL >= 0 ? .green : .red)
                metricItem(title: "Win Rate", value: "\(Int(bot.winRate))%", color: .blue)
                metricItem(title: "Trades", value: "\(bot.tradesCount)", color: .orange)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemGray6))
        )
    }
    
    private func metricItem(title: String, value: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(color)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
    
    private var livePerformanceChart: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("📈 Live Performance")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(DesignSystem.primaryGold)
            
            // Placeholder for chart - would use Charts framework
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
                .frame(height: 200)
                .overlay(
                    VStack {
                        Text("Live P&L Chart")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        Text("Real-time updates every second")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                )
        }
    }
    
    private var recentTradesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("📋 Recent Trades")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.blue)
            
            VStack(spacing: 8) {
                ForEach(chartData.recentTrades) { trade in
                    tradeRow(trade)
                }
            }
        }
    }
    
    private func tradeRow(_ trade: RecentTrade) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(trade.symbol)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(trade.timestamp.formatted(.dateTime.hour().minute()))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(trade.type)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(trade.type == "BUY" ? .green : .red)
                
                Text(LiveTradingManager().formatProfitChange(trade.pnl))
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(trade.pnl >= 0 ? .green : .red)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(.systemGray6))
        )
    }
    
    private var botControlsSection: some View {
        VStack(spacing: 12) {
            HStack(spacing: 16) {
                Button(bot.isTrading ? "Pause Bot" : "Start Bot") {
                    // Control bot
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(bot.isTrading ? Color.orange : Color.green)
                .cornerRadius(12)
                
                Button("Settings") {
                    // Bot settings
                }
                .foregroundColor(DesignSystem.primaryGold)
                .frame(maxWidth: .infinity)
                .padding()
                .background(DesignSystem.primaryGold.opacity(0.1))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(DesignSystem.primaryGold, lineWidth: 1)
                )
            }
            
            Button("Emergency Stop") {
                // Emergency stop
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.red)
            .cornerRadius(12)
        }
    }
}

// MARK: - Bot Chart Data

class BotChartData: ObservableObject {
    @Published var recentTrades: [RecentTrade] = []
    private var updateTimer: Timer?
    
    func startLiveUpdates(for botId: UUID) {
        generateSampleTrades()
        
        updateTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
            self.addRandomTrade()
        }
    }
    
    func stopLiveUpdates() {
        updateTimer?.invalidate()
        updateTimer = nil
    }
    
    private func generateSampleTrades() {
        recentTrades = [
            RecentTrade(symbol: "AAPL", type: "BUY", pnl: 125.50, timestamp: Date().addingTimeInterval(-300)),
            RecentTrade(symbol: "TSLA", type: "SELL", pnl: 89.25, timestamp: Date().addingTimeInterval(-250)),
            RecentTrade(symbol: "SPY", type: "BUY", pnl: -25.75, timestamp: Date().addingTimeInterval(-180)),
            RecentTrade(symbol: "QQQ", type: "SELL", pnl: 156.80, timestamp: Date().addingTimeInterval(-120))
        ]
    }
    
    private func addRandomTrade() {
        let symbols = ["AAPL", "TSLA", "SPY", "QQQ", "NVDA", "MSFT"]
        let types = ["BUY", "SELL"]
        
        let newTrade = RecentTrade(
            symbol: symbols.randomElement()!,
            type: types.randomElement()!,
            pnl: Double.random(in: -50...200),
            timestamp: Date()
        )
        
        recentTrades.insert(newTrade, at: 0)
        if recentTrades.count > 20 {
            recentTrades.removeLast()
        }
    }
}

struct RecentTrade: Identifiable, Codable {
    let id = UUID()
    let symbol: String
    let type: String
    let pnl: Double
    let timestamp: Date
}

#Preview {
    LiveBotTradingView()
}