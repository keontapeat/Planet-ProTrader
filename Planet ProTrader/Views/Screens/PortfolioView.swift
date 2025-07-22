//
//  PortfolioView.swift
//  Planet ProTrader
//
//  ✅ PORTFOLIO SCREEN - Professional portfolio management with analytics
//  Modern SwiftUI design with real-time updates
//

import SwiftUI
import Charts

struct PortfolioView: View {
    @EnvironmentObject var realTimeAccountManager: RealTimeAccountManager
    @EnvironmentObject var tradingViewModel: TradingViewModel
    @EnvironmentObject var tradingBotManager: TradingBotManager
    
    @State private var selectedTimeframe: PortfolioTimeframe = .week
    @State private var showingPositions = true
    @State private var showingHistory = false
    @State private var selectedTab = 0
    @State private var animateCards = false
    
    enum PortfolioTimeframe: String, CaseIterable {
        case day = "1D"
        case week = "1W" 
        case month = "1M"
        case year = "1Y"
        case all = "ALL"
        
        var displayName: String { rawValue }
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    // Background
                    LinearGradient(
                        colors: [
                            Color(.systemBackground),
                            DesignSystem.primaryGold.opacity(0.02),
                            Color(.systemBackground).opacity(0.98)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .ignoresSafeArea()
                    
                    ScrollView {
                        LazyVStack(spacing: 24) {
                            // Header Section
                            portfolioHeader
                            
                            // Performance Chart
                            performanceChartSection
                            
                            // Quick Stats
                            quickStatsSection
                            
                            // Segmented Control
                            segmentedControlSection
                            
                            // Content based on selection
                            if selectedTab == 0 {
                                openPositionsSection
                            } else if selectedTab == 1 {
                                tradingHistorySection
                            } else {
                                analyticsSection
                            }
                            
                            Spacer(minLength: 100)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                    }
                }
            }
            .navigationTitle("Portfolio")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                startAnimations()
            }
        }
    }
    
    // MARK: - Header Section
    private var portfolioHeader: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Total Portfolio Value")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text(realTimeAccountManager.formattedEquity)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(DesignSystem.goldGradient)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 6) {
                    HStack(spacing: 4) {
                        Image(systemName: realTimeAccountManager.todaysProfit >= 0 ? "arrow.up.right" : "arrow.down.right")
                            .font(.caption)
                        Text(realTimeAccountManager.formattedTodaysProfit)
                            .font(.headline)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(realTimeAccountManager.todaysProfitColor)
                    
                    Text("Today's P&L")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            // Timeframe selector
            timeframeSelector
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
        .scaleEffect(animateCards ? 1.0 : 0.95)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.8, dampingFraction: 0.8), value: animateCards)
    }
    
    private var timeframeSelector: some View {
        HStack(spacing: 8) {
            ForEach(PortfolioTimeframe.allCases, id: \.self) { timeframe in
                Button(timeframe.displayName) {
                    HapticFeedbackManager.shared.selection()
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedTimeframe = timeframe
                    }
                }
                .font(.caption)
                .fontWeight(.medium)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(selectedTimeframe == timeframe ? DesignSystem.primaryGold : Color.clear)
                )
                .foregroundColor(selectedTimeframe == timeframe ? .white : .primary)
            }
        }
    }
    
    // MARK: - Performance Chart Section
    private var performanceChartSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Performance Chart")
                .font(.title2)
                .fontWeight(.bold)
            
            // Placeholder for actual chart
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
                .frame(height: 200)
                .overlay(
                    VStack {
                        Image(systemName: "chart.line.uptrend.xyaxis")
                            .font(.largeTitle)
                            .foregroundColor(DesignSystem.primaryGold)
                        Text("Performance Chart")
                            .font(.headline)
                            .fontWeight(.semibold)
                        Text("Coming Soon")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                )
        }
        .scaleEffect(animateCards ? 1.0 : 0.95)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.1), value: animateCards)
    }
    
    // MARK: - Quick Stats Section
    private var quickStatsSection: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
            StatCard(
                title: "Win Rate",
                value: realTimeAccountManager.formattedWinRate,
                change: "+2.3%",
                isPositive: true,
                icon: "target"
            )
            
            StatCard(
                title: "Total Trades",
                value: "\(realTimeAccountManager.totalTrades)",
                change: "+15",
                isPositive: true,
                icon: "chart.bar"
            )
            
            StatCard(
                title: "Free Margin",
                value: realTimeAccountManager.formattedFreeMargin,
                change: "-$125",
                isPositive: false,
                icon: "banknote"
            )
            
            StatCard(
                title: "Active Bots",
                value: "\(tradingBotManager.activeBots.count)",
                change: "+1",
                isPositive: true,
                icon: "brain.head.profile"
            )
        }
        .scaleEffect(animateCards ? 1.0 : 0.95)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.2), value: animateCards)
    }
    
    // MARK: - Segmented Control Section
    private var segmentedControlSection: some View {
        HStack(spacing: 0) {
            segmentButton(title: "Positions", index: 0, isSelected: selectedTab == 0)
            segmentButton(title: "History", index: 1, isSelected: selectedTab == 1)
            segmentButton(title: "Analytics", index: 2, isSelected: selectedTab == 2)
        }
        .padding(4)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
        .scaleEffect(animateCards ? 1.0 : 0.95)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.3), value: animateCards)
    }
    
    private func segmentButton(title: String, index: Int, isSelected: Bool) -> some View {
        Button(action: {
            HapticFeedbackManager.shared.selection()
            withAnimation(.easeInOut(duration: 0.2)) {
                selectedTab = index
            }
        }) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(isSelected ? .white : .primary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(isSelected ? DesignSystem.primaryGold : Color.clear)
                )
        }
    }
    
    // MARK: - Open Positions Section
    private var openPositionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Open Positions")
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Text("3 Active")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            LazyVStack(spacing: 12) {
                ForEach(samplePositions, id: \.id) { position in
                    PositionCard(position: position)
                }
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.95)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.4), value: animateCards)
    }
    
    // MARK: - Trading History Section
    private var tradingHistorySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Trading History")
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Text("Last 30 days")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            LazyVStack(spacing: 12) {
                ForEach(sampleTradeHistory, id: \.id) { trade in
                    TradeHistoryCard(trade: trade)
                }
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.95)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.4), value: animateCards)
    }
    
    // MARK: - Analytics Section
    private var analyticsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Portfolio Analytics")
                .font(.title3)
                .fontWeight(.semibold)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                AnalyticsCard(title: "Profit Factor", value: "2.43", icon: "multiply.circle.fill", color: DesignSystem.primaryGold)
                AnalyticsCard(title: "Sharpe Ratio", value: "1.87", icon: "chart.line.uptrend.xyaxis", color: .blue)
                AnalyticsCard(title: "Max Drawdown", value: "3.2%", icon: "arrow.down.circle.fill", color: .red)
                AnalyticsCard(title: "Recovery Factor", value: "4.1", icon: "arrow.clockwise.circle.fill", color: .green)
                AnalyticsCard(title: "Avg Hold Time", value: "2.3h", icon: "clock.circle.fill", color: .orange)
                AnalyticsCard(title: "Best Month", value: "12.4%", icon: "star.circle.fill", color: .purple)
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.95)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.4), value: animateCards)
    }
    
    // MARK: - Helper Methods
    private func startAnimations() {
        withAnimation(.spring(response: 1.0, dampingFraction: 0.8).delay(0.2)) {
            animateCards = true
        }
    }
    
    // MARK: - Sample Data
    private var samplePositions: [Position] {
        [
            Position(id: UUID(), symbol: "XAUUSD", type: .buy, size: 0.1, entryPrice: 2374.50, currentPrice: 2378.25, pnl: 37.50),
            Position(id: UUID(), symbol: "EURUSD", type: .sell, size: 0.2, entryPrice: 1.0845, currentPrice: 1.0823, pnl: 44.00),
            Position(id: UUID(), symbol: "GBPUSD", type: .buy, size: 0.15, entryPrice: 1.2634, currentPrice: 1.2628, pnl: -9.00)
        ]
    }
    
    private var sampleTradeHistory: [TradeHistory] {
        [
            TradeHistory(id: UUID(), symbol: "XAUUSD", type: .buy, size: 0.1, entryPrice: 2365.00, exitPrice: 2378.50, pnl: 135.00, date: Date().addingTimeInterval(-3600)),
            TradeHistory(id: UUID(), symbol: "EURUSD", type: .sell, size: 0.2, entryPrice: 1.0865, exitPrice: 1.0845, pnl: 40.00, date: Date().addingTimeInterval(-7200)),
            TradeHistory(id: UUID(), symbol: "GBPUSD", type: .buy, size: 0.15, entryPrice: 1.2615, exitPrice: 1.2598, pnl: -25.50, date: Date().addingTimeInterval(-10800))
        ]
    }
}

// MARK: - Supporting Components

struct StatCard: View {
    let title: String
    let value: String
    let change: String
    let isPositive: Bool
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(DesignSystem.primaryGold)
                
                Spacer()
                
                Text(change)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(isPositive ? .green : .red)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
}

struct PositionCard: View {
    let position: Position
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(position.symbol)
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text(position.type.rawValue.uppercased())
                        .font(.caption)
                        .fontWeight(.bold)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(position.type == .buy ? Color.green.opacity(0.2) : Color.red.opacity(0.2))
                        .foregroundColor(position.type == .buy ? .green : .red)
                        .clipShape(Capsule())
                }
                
                Text("Size: \(String(format: "%.2f", position.size))")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text("Entry: \(String(format: "%.2f", position.entryPrice))")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(String(format: "%.2f", position.currentPrice))
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text(String(format: "$%.2f", position.pnl))
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(position.pnl >= 0 ? .green : .red)
            }
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
}

struct TradeHistoryCard: View {
    let trade: TradeHistory
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(trade.symbol)
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text(trade.type.rawValue.uppercased())
                        .font(.caption)
                        .fontWeight(.bold)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(trade.type == .buy ? Color.green.opacity(0.2) : Color.red.opacity(0.2))
                        .foregroundColor(trade.type == .buy ? .green : .red)
                        .clipShape(Capsule())
                }
                
                Text("Size: \(String(format: "%.2f", trade.size))")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(trade.date, style: .relative)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(String(format: "%.2f", trade.entryPrice)) → \(String(format: "%.2f", trade.exitPrice))")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(String(format: "$%.2f", trade.pnl))
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(trade.pnl >= 0 ? .green : .red)
            }
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
}

struct AnalyticsCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(color)
            
            VStack(spacing: 4) {
                Text(value)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Data Models

struct Position: Identifiable {
    let id: UUID
    let symbol: String
    let type: PositionType
    let size: Double
    let entryPrice: Double
    let currentPrice: Double
    let pnl: Double
}

struct TradeHistory: Identifiable {
    let id: UUID
    let symbol: String
    let type: PositionType
    let size: Double
    let entryPrice: Double
    let exitPrice: Double
    let pnl: Double
    let date: Date
}

enum PositionType: String {
    case buy = "buy"
    case sell = "sell"
}

#Preview {
    PortfolioView()
        .environmentObject(RealTimeAccountManager())
        .environmentObject(TradingViewModel())
        .environmentObject(TradingBotManager.shared)
        .preferredColorScheme(.light)
}