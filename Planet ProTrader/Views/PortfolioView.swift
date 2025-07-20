//
//  PortfolioView.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 7/13/25.
//

import SwiftUI

struct PortfolioView: View {
    @EnvironmentObject var tradingViewModel: TradingViewModel
    @StateObject private var portfolioManager = PortfolioManager()
    @State private var selectedTimeframe: PortfolioTimeframe = .month
    @State private var showingDetailedAnalysis = false
    @State private var showingTradeHistory = false
    @State private var showingPerformanceAnalysis = false
    @State private var animateCards = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                DesignSystem.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Header
                        headerSection
                        
                        // Portfolio Overview
                        portfolioOverviewSection
                        
                        // Account Performance
                        accountPerformanceSection
                        
                        // Asset Allocation
                        assetAllocationSection
                        
                        // Recent Trades
                        recentTradesSection
                        
                        // Performance Analytics
                        performanceAnalyticsSection
                        
                        // Risk Analysis
                        riskAnalysisSection
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .navigationTitle("Portfolio")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button("Trade History") {
                            showingTradeHistory = true
                        }
                        
                        Button("Performance Analysis") {
                            showingPerformanceAnalysis = true
                        }
                        
                        Button("Detailed Analysis") {
                            showingDetailedAnalysis = true
                        }
                        
                        Divider()
                        
                        Button("Export Report") {
                            // Handle export
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .font(.title3)
                            .foregroundStyle(DesignSystem.primaryGold)
                    }
                }
            }
            .onAppear {
                portfolioManager.startUpdates()
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2)) {
                    animateCards = true
                }
            }
            .onDisappear {
                portfolioManager.stopUpdates()
            }
            .sheet(isPresented: $showingDetailedAnalysis) {
                DetailedPortfolioAnalysisView()
                    .environmentObject(portfolioManager)
            }
            .sheet(isPresented: $showingTradeHistory) {
                TradeHistoryView()
                    .environmentObject(portfolioManager)
            }
            .sheet(isPresented: $showingPerformanceAnalysis) {
                PerformanceAnalysisView()
                    .environmentObject(portfolioManager)
            }
        }
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        UltraPremiumCard {
            VStack(spacing: 16) {
                HStack {
                    Image(systemName: "chart.pie.fill")
                        .font(.title)
                        .foregroundStyle(DesignSystem.primaryGold)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Trading Portfolio")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(.primary)
                        
                        Text("Track your trading performance")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 2) {
                        Text(portfolioManager.formattedTotalValue)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(.green)
                        
                        Text("Total Value")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                
                // Timeframe Selector
                Picker("Timeframe", selection: $selectedTimeframe) {
                    ForEach(PortfolioTimeframe.allCases, id: \.self) { timeframe in
                        Text(timeframe.rawValue).tag(timeframe)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.9)
        .opacity(animateCards ? 1.0 : 0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: animateCards)
    }
    
    // MARK: - Portfolio Overview Section
    
    private var portfolioOverviewSection: some View {
        UltraPremiumCard {
            VStack(alignment: .leading, spacing: 16) {
                Text("Portfolio Overview")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                
                HStack(spacing: 12) {
                    PortfolioStatCard(
                        title: "Total Balance",
                        value: portfolioManager.formattedTotalBalance,
                        change: portfolioManager.totalBalanceChange,
                        color: .green
                    )
                    
                    PortfolioStatCard(
                        title: "Today's P&L",
                        value: portfolioManager.formattedTodaysPnL,
                        change: portfolioManager.todaysPnLChange,
                        color: portfolioManager.todaysPnL >= 0 ? .green : .red
                    )
                }
                
                HStack(spacing: 12) {
                    PortfolioStatCard(
                        title: "Win Rate",
                        value: portfolioManager.formattedWinRate,
                        change: portfolioManager.winRateChange,
                        color: .blue
                    )
                    
                    PortfolioStatCard(
                        title: "ROI",
                        value: portfolioManager.formattedROI,
                        change: portfolioManager.roiChange,
                        color: .purple
                    )
                }
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.9)
        .opacity(animateCards ? 1.0 : 0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1), value: animateCards)
    }
    
    // MARK: - Account Performance Section
    
    private var accountPerformanceSection: some View {
        UltraPremiumCard {
            VStack(alignment: .leading, spacing: 16) {
                Text("Account Performance")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                
                VStack(spacing: 12) {
                    ForEach(portfolioManager.accounts, id: \.id) { account in
                        AccountPerformanceRow(account: account)
                    }
                }
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.9)
        .opacity(animateCards ? 1.0 : 0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2), value: animateCards)
    }
    
    // MARK: - Asset Allocation Section
    
    private var assetAllocationSection: some View {
        UltraPremiumCard {
            VStack(alignment: .leading, spacing: 16) {
                Text("Asset Allocation")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                
                VStack(spacing: 12) {
                    ForEach(portfolioManager.assetAllocations, id: \.asset) { allocation in
                        AssetAllocationRow(allocation: allocation)
                    }
                }
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.9)
        .opacity(animateCards ? 1.0 : 0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3), value: animateCards)
    }
    
    // MARK: - Recent Trades Section
    
    private var recentTradesSection: some View {
        UltraPremiumCard {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("Recent Trades")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)
                    
                    Spacer()
                    
                    Button("View All") {
                        showingTradeHistory = true
                    }
                    .font(.caption)
                    .foregroundStyle(DesignSystem.primaryGold)
                }
                
                VStack(spacing: 8) {
                    ForEach(Array(portfolioManager.recentTrades.prefix(5)), id: \.id) { trade in
                        RecentTradeRow(trade: trade)
                    }
                }
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.9)
        .opacity(animateCards ? 1.0 : 0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.4), value: animateCards)
    }
    
    // MARK: - Performance Analytics Section
    
    private var performanceAnalyticsSection: some View {
        UltraPremiumCard {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("Performance Analytics")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)
                    
                    Spacer()
                    
                    Button("View Details") {
                        showingPerformanceAnalysis = true
                    }
                    .font(.caption)
                    .foregroundStyle(DesignSystem.primaryGold)
                }
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                    PerformanceMetricCard(
                        title: "Best Trade",
                        value: portfolioManager.formattedBestTrade,
                        color: .green
                    )
                    
                    PerformanceMetricCard(
                        title: "Worst Trade",
                        value: portfolioManager.formattedWorstTrade,
                        color: .red
                    )
                    
                    PerformanceMetricCard(
                        title: "Avg. Trade",
                        value: portfolioManager.formattedAverageTrade,
                        color: .blue
                    )
                    
                    PerformanceMetricCard(
                        title: "Profit Factor",
                        value: portfolioManager.formattedProfitFactor,
                        color: .purple
                    )
                }
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.9)
        .opacity(animateCards ? 1.0 : 0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.5), value: animateCards)
    }
    
    // MARK: - Risk Analysis Section
    
    private var riskAnalysisSection: some View {
        UltraPremiumCard {
            VStack(alignment: .leading, spacing: 16) {
                Text("Risk Analysis")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                
                VStack(spacing: 12) {
                    RiskMetricRow(
                        title: "Maximum Drawdown",
                        value: portfolioManager.formattedMaxDrawdown,
                        color: .red
                    )
                    
                    RiskMetricRow(
                        title: "Sharpe Ratio",
                        value: portfolioManager.formattedSharpeRatio,
                        color: .blue
                    )
                    
                    RiskMetricRow(
                        title: "Risk per Trade",
                        value: portfolioManager.formattedRiskPerTrade,
                        color: .orange
                    )
                    
                    RiskMetricRow(
                        title: "VAR (95%)",
                        value: portfolioManager.formattedVAR,
                        color: .purple
                    )
                }
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.9)
        .opacity(animateCards ? 1.0 : 0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.6), value: animateCards)
    }
}

// MARK: - Portfolio Manager

@MainActor
class PortfolioManager: ObservableObject {
    @Published var totalBalance: Double = 125000.0
    @Published var todaysPnL: Double = 2847.50
    @Published var totalValue: Double = 127847.50
    @Published var winRate: Double = 0.847
    @Published var roi: Double = 0.234
    @Published var bestTrade: Double = 4250.00
    @Published var worstTrade: Double = -1850.00
    @Published var averageTrade: Double = 156.80
    @Published var profitFactor: Double = 2.34
    @Published var maxDrawdown: Double = 0.085
    @Published var sharpeRatio: Double = 1.68
    @Published var riskPerTrade: Double = 0.025
    @Published var var95: Double = 0.035
    
    // Changes
    @Published var totalBalanceChange: Double = 0.056
    @Published var todaysPnLChange: Double = 0.234
    @Published var winRateChange: Double = 0.023
    @Published var roiChange: Double = 0.045
    
    // Data
    @Published var accounts: [TradingAccount] = []
    @Published var assetAllocations: [AssetAllocation] = []
    @Published var recentTrades: [PortfolioTrade] = []
    
    private var updateTimer: Timer?
    
    init() {
        loadInitialData()
    }
    
    func startUpdates() {
        updateTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
            self.updateMetrics()
        }
    }
    
    func stopUpdates() {
        updateTimer?.invalidate()
        updateTimer = nil
    }
    
    private func loadInitialData() {
        accounts = [
            TradingAccount(
                id: UUID(),
                name: "Coinexx Demo #1",
                balance: 50000.0,
                equity: 52847.50,
                pnl: 2847.50,
                winRate: 0.82,
                brokerType: .coinexx,
                isLive: false
            ),
            TradingAccount(
                id: UUID(),
                name: "MT5 Live Account",
                balance: 25000.0,
                equity: 25000.0,
                pnl: 0.0,
                winRate: 0.89,
                brokerType: .mt5,
                isLive: true
            ),
            TradingAccount(
                id: UUID(),
                name: "TradeLocker Demo",
                balance: 50000.0,
                equity: 50000.0,
                pnl: 0.0,
                winRate: 0.85,
                brokerType: .tradeLocker,
                isLive: false
            )
        ]
        
        assetAllocations = [
            AssetAllocation(asset: "XAUUSD", percentage: 0.85, value: 108770.38, change: 0.045),
            AssetAllocation(asset: "XAGUSD", percentage: 0.10, value: 12784.75, change: -0.023),
            AssetAllocation(asset: "USDCAD", percentage: 0.05, value: 6392.37, change: 0.012)
        ]
        
        recentTrades = [
            PortfolioTrade(
                id: UUID(),
                symbol: "XAUUSD",
                direction: .long,
                entryPrice: 2374.50,
                exitPrice: 2394.20,
                quantity: 2.0,
                pnl: 394.00,
                timestamp: Date(),
                duration: 1847,
                broker: "Coinexx"
            ),
            PortfolioTrade(
                id: UUID(),
                symbol: "XAUUSD",
                direction: .short,
                entryPrice: 2381.20,
                exitPrice: 2371.80,
                quantity: 1.5,
                pnl: 141.00,
                timestamp: Date().addingTimeInterval(-3600),
                duration: 2456,
                broker: "MT5"
            ),
            PortfolioTrade(
                id: UUID(),
                symbol: "XAGUSD",
                direction: .long,
                entryPrice: 28.45,
                exitPrice: 28.72,
                quantity: 10.0,
                pnl: 270.00,
                timestamp: Date().addingTimeInterval(-7200),
                duration: 3421,
                broker: "TradeLocker"
            )
        ]
    }
    
    private func updateMetrics() {
        // Simulate real-time updates
        todaysPnL += Double.random(in: -50...100)
        totalValue = totalBalance + todaysPnL
        
        // Update some metrics with small random changes
        winRate = max(0.7, min(0.95, winRate + Double.random(in: -0.01...0.01)))
        roi = max(0.0, roi + Double.random(in: -0.01...0.01))
        
        // Update account balances
        for index in accounts.indices {
            accounts[index].pnl += Double.random(in: -25...50)
            accounts[index].equity = accounts[index].balance + accounts[index].pnl
        }
    }
    
    // MARK: - Formatted Properties
    
    var formattedTotalBalance: String {
        formatCurrency(totalBalance)
    }
    
    var formattedTotalValue: String {
        formatCurrency(totalValue)
    }
    
    var formattedTodaysPnL: String {
        formatCurrency(todaysPnL)
    }
    
    var formattedWinRate: String {
        "\(String(format: "%.1f", winRate * 100))%"
    }
    
    var formattedROI: String {
        "\(String(format: "%.1f", roi * 100))%"
    }
    
    var formattedBestTrade: String {
        formatCurrency(bestTrade)
    }
    
    var formattedWorstTrade: String {
        formatCurrency(worstTrade)
    }
    
    var formattedAverageTrade: String {
        formatCurrency(averageTrade)
    }
    
    var formattedProfitFactor: String {
        String(format: "%.2f", profitFactor)
    }
    
    var formattedMaxDrawdown: String {
        "\(String(format: "%.1f", maxDrawdown * 100))%"
    }
    
    var formattedSharpeRatio: String {
        String(format: "%.2f", sharpeRatio)
    }
    
    var formattedRiskPerTrade: String {
        "\(String(format: "%.1f", riskPerTrade * 100))%"
    }
    
    var formattedVAR: String {
        "\(String(format: "%.1f", var95 * 100))%"
    }
    
    private func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: amount)) ?? "$0"
    }
}

// MARK: - Supporting Types

enum PortfolioTimeframe: String, CaseIterable {
    case week = "Week"
    case month = "Month"
    case quarter = "Quarter"
    case year = "Year"
    case all = "All"
}

struct TradingAccount: Identifiable {
    let id: UUID
    let name: String
    let balance: Double
    var equity: Double
    var pnl: Double
    let winRate: Double
    let brokerType: SharedTypes.BrokerType
    let isLive: Bool
}

struct AssetAllocation: Identifiable {
    let id = UUID()
    let asset: String
    let percentage: Double
    let value: Double
    let change: Double
}

struct PortfolioTrade: Identifiable {
    let id: UUID
    let symbol: String
    let direction: SharedTypes.TradeDirection
    let entryPrice: Double
    let exitPrice: Double
    let quantity: Double
    let pnl: Double
    let timestamp: Date
    let duration: TimeInterval
    let broker: String
}

// MARK: - Supporting Views

struct PortfolioStatCard: View {
    let title: String
    let value: String
    let change: Double
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(color)
            
            HStack {
                Image(systemName: change >= 0 ? "arrow.up" : "arrow.down")
                    .font(.caption)
                    .foregroundStyle(change >= 0 ? .green : .red)
                
                Text("\(String(format: "%.1f", abs(change * 100)))%")
                    .font(.caption)
                    .foregroundStyle(change >= 0 ? .green : .red)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct AccountPerformanceRow: View {
    let account: TradingAccount
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(account.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(.primary)
                
                HStack {
                    Text(account.brokerType.rawValue)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Text("•")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Text(account.isLive ? "Live" : "Demo")
                        .font(.caption)
                        .foregroundStyle(account.isLive ? .green : .orange)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(formatCurrency(account.equity))
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(.primary)
                
                Text(formatCurrency(account.pnl))
                    .font(.caption)
                    .foregroundStyle(account.pnl >= 0 ? .green : .red)
            }
        }
        .padding(.vertical, 4)
    }
    
    private func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: amount)) ?? "$0"
    }
}

struct AssetAllocationRow: View {
    let allocation: AssetAllocation
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(allocation.asset)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(.primary)
                
                Text("\(String(format: "%.1f", allocation.percentage * 100))%")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(formatCurrency(allocation.value))
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(.primary)
                
                HStack {
                    Image(systemName: allocation.change >= 0 ? "arrow.up" : "arrow.down")
                        .font(.caption)
                        .foregroundStyle(allocation.change >= 0 ? .green : .red)
                    
                    Text("\(String(format: "%.1f", abs(allocation.change * 100)))%")
                        .font(.caption)
                        .foregroundStyle(allocation.change >= 0 ? .green : .red)
                }
            }
        }
        .padding(.vertical, 4)
    }
    
    private func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: amount)) ?? "$0"
    }
}

struct RecentTradeRow: View {
    let trade: PortfolioTrade
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(trade.symbol)
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    Text(trade.direction.rawValue)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(trade.direction.color)
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                }
                
                Text(formatDuration(trade.duration))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(formatCurrency(trade.pnl))
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundStyle(trade.pnl >= 0 ? .green : .red)
                
                Text(trade.timestamp.formatted(date: .omitted, time: .shortened))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
    
    private func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: amount)) ?? "$0"
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let hours = Int(duration) / 3600
        let minutes = (Int(duration) % 3600) / 60
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
}

struct PerformanceMetricCard: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(color)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(color.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct RiskMetricRow: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(color)
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Detail Views

struct DetailedPortfolioAnalysisView: View {
    @EnvironmentObject var portfolioManager: PortfolioManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    Text("Detailed Portfolio Analysis")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)
                    
                    Text("Comprehensive portfolio performance analysis and insights")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding()
            }
            .navigationTitle("Portfolio Analysis")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct TradeHistoryView: View {
    @EnvironmentObject var portfolioManager: PortfolioManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List {
                ForEach(portfolioManager.recentTrades) { trade in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(trade.symbol)
                                .font(.subheadline)
                                .fontWeight(.medium)
                            
                            Text(trade.direction.rawValue)
                                .font(.caption)
                                .foregroundStyle(trade.direction.color)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            Text(formatCurrency(trade.pnl))
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundStyle(trade.pnl >= 0 ? .green : .red)
                            
                            Text(trade.timestamp.formatted(date: .abbreviated, time: .shortened))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Trade History")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: amount)) ?? "$0"
    }
}

struct PerformanceAnalysisView: View {
    @EnvironmentObject var portfolioManager: PortfolioManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    Text("Performance Analysis")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)
                    
                    Text("Advanced trading performance metrics and analysis")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding()
            }
            .navigationTitle("Performance Analysis")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    PortfolioView()
        .environmentObject(TradingViewModel())
}