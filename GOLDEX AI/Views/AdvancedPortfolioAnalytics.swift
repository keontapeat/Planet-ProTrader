//
//  AdvancedPortfolioAnalytics.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 1/21/25.
//

import SwiftUI
import Charts

struct AdvancedPortfolioAnalytics: View {
    @StateObject private var analyticsManager = PortfolioAnalyticsManager()
    @State private var selectedPeriod: AnalyticsPeriod = .thisMonth
    @State private var selectedMetric: PerformanceMetric = .totalReturn
    @State private var showingDetailedBreakdown = false
    @State private var animateCharts = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Performance Overview Cards
                    performanceOverview
                    
                    // Main Performance Chart
                    performanceChart
                    
                    // Bot Performance Leaderboard
                    botPerformanceSection
                    
                    // Risk Analytics
                    riskAnalyticsSection
                    
                    // Trading Statistics
                    tradingStatsSection
                    
                    // Correlation Matrix
                    correlationMatrixSection
                    
                    // Performance Attribution
                    performanceAttributionSection
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
            .background(Color(.systemBackground))
            .navigationTitle("📊 Portfolio Analytics")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Export") {
                        // Export analytics report
                        ToastManager.shared.showSuccess("Analytics report exported!")
                    }
                    .foregroundColor(DesignSystem.primaryGold)
                }
            }
        }
        .onAppear {
            analyticsManager.loadAnalytics()
            withAnimation(.easeInOut(duration: 1.5)) {
                animateCharts = true
            }
        }
    }
    
    // MARK: - Performance Overview
    
    private var performanceOverview: some View {
        VStack(spacing: 16) {
            // Period selector
            periodSelector
            
            // Key metrics cards
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                metricCard(
                    title: "Total Return",
                    value: analyticsManager.totalReturn,
                    change: analyticsManager.totalReturnChange,
                    icon: "chart.line.uptrend.xyaxis",
                    color: .green
                )
                
                metricCard(
                    title: "Sharpe Ratio",
                    value: String(format: "%.2f", analyticsManager.sharpeRatio),
                    change: analyticsManager.sharpeRatioChange,
                    icon: "target",
                    color: .blue
                )
                
                metricCard(
                    title: "Max Drawdown",
                    value: analyticsManager.maxDrawdown,
                    change: analyticsManager.maxDrawdownChange,
                    icon: "arrow.down.circle",
                    color: .red
                )
                
                metricCard(
                    title: "Win Rate",
                    value: "\(Int(analyticsManager.winRate * 100))%",
                    change: analyticsManager.winRateChange,
                    icon: "target",
                    color: .purple
                )
            }
        }
    }
    
    private var periodSelector: some View {
        Picker("Period", selection: $selectedPeriod) {
            ForEach(AnalyticsPeriod.allCases, id: \.self) { period in
                Text(period.displayName).tag(period)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .onChange(of: selectedPeriod) { _ in
            analyticsManager.updatePeriod(selectedPeriod)
        }
    }
    
    private func metricCard(title: String, value: String, change: String, icon: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(color)
                
                Spacer()
                
                Text(change)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(change.hasPrefix("+") ? .green : .red)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background((change.hasPrefix("+") ? Color.green : Color.red).opacity(0.1))
                    .cornerRadius(4)
            }
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .contentTransition(.numericText())
                .animation(.easeInOut(duration: 1.0), value: value)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(16)
        .background(Color(.systemGray6).opacity(0.5))
        .cornerRadius(12)
    }
    
    // MARK: - Performance Chart
    
    private var performanceChart: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("📈 Performance Chart")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Picker("Metric", selection: $selectedMetric) {
                    ForEach(PerformanceMetric.allCases, id: \.self) { metric in
                        Text(metric.displayName).tag(metric)
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }
            
            Chart(analyticsManager.performanceData) { data in
                LineMark(
                    x: .value("Date", data.date),
                    y: .value("Value", data.value)
                )
                .foregroundStyle(
                    LinearGradient(
                        colors: [.green, DesignSystem.primaryGold],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .lineStyle(StrokeStyle(lineWidth: 3))
                
                AreaMark(
                    x: .value("Date", data.date),
                    y: .value("Value", data.value)
                )
                .foregroundStyle(
                    LinearGradient(
                        colors: [.green.opacity(0.3), DesignSystem.primaryGold.opacity(0.1)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            }
            .frame(height: 200)
            .chartXAxis {
                AxisMarks(values: .automatic) { value in
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel {
                        if let date = value.as(Date.self) {
                            Text(date.formatted(.dateTime.month().day()))
                                .font(.caption)
                        }
                    }
                }
            }
            .chartYAxis {
                AxisMarks(values: .automatic) { value in
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel {
                        if let amount = value.as(Double.self) {
                            Text(amount.formatted(.currency(code: "USD")))
                                .font(.caption)
                        }
                    }
                }
            }
            .padding()
            .background(Color(.systemGray6).opacity(0.3))
            .cornerRadius(12)
        }
    }
    
    // MARK: - Bot Performance Section
    
    private var botPerformanceSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("🏆 Bot Performance Leaderboard")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Button("View All") {
                    showingDetailedBreakdown = true
                }
                .font(.caption)
                .foregroundColor(DesignSystem.primaryGold)
            }
            
            LazyVStack(spacing: 8) {
                ForEach(Array(analyticsManager.botPerformances.enumerated()), id: \.element.id) { index, bot in
                    botPerformanceRow(bot: bot, rank: index + 1)
                }
            }
        }
    }
    
    private func botPerformanceRow(bot: BotPerformance, rank: Int) -> some View {
        HStack(spacing: 12) {
            // Rank badge
            ZStack {
                Circle()
                    .fill(rankColor(rank))
                    .frame(width: 32, height: 32)
                
                Text("\(rank)")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            
            // Bot info
            VStack(alignment: .leading, spacing: 2) {
                Text(bot.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text("Win Rate: \(Int(bot.winRate * 100))% • \(bot.totalTrades) trades")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Performance metrics
            VStack(alignment: .trailing, spacing: 2) {
                Text(bot.profitLoss.formatted(.currency(code: "USD")))
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(bot.profitLoss >= 0 ? .green : .red)
                
                Text("\(bot.returnPercentage, format: .percent)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(12)
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(rankColor(rank).opacity(0.3), lineWidth: 1)
            )
    }
    
    private func rankColor(_ rank: Int) -> Color {
        switch rank {
        case 1: return DesignSystem.primaryGold
        case 2: return .gray
        case 3: return .brown
        default: return .blue
        }
    }
    
    // MARK: - Risk Analytics Section
    
    private var riskAnalyticsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("⚠️ Risk Analytics")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                riskMetricCard(
                    title: "Value at Risk",
                    value: analyticsManager.valueAtRisk,
                    subtitle: "95% Confidence",
                    color: .orange
                )
                
                riskMetricCard(
                    title: "Portfolio Beta",
                    value: String(format: "%.2f", analyticsManager.portfolioBeta),
                    subtitle: "vs Market",
                    color: .blue
                )
                
                riskMetricCard(
                    title: "Correlation",
                    value: String(format: "%.2f", analyticsManager.avgCorrelation),
                    subtitle: "Average",
                    color: .purple
                )
                
                riskMetricCard(
                    title: "Volatility",
                    value: "\(Int(analyticsManager.portfolioVolatility * 100))%",
                    subtitle: "Annualized",
                    color: .red
                )
            }
        }
    }
    
    private func riskMetricCard(title: String, value: String, subtitle: String, color: Color) -> some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(color)
            
            VStack(spacing: 2) {
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                Text(subtitle)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color(.systemGray6).opacity(0.5))
        .cornerRadius(10)
    }
    
    // MARK: - Trading Statistics
    
    private var tradingStatsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("📊 Trading Statistics")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            VStack(spacing: 12) {
                statRow(label: "Total Trades", value: "\(analyticsManager.totalTrades)")
                statRow(label: "Winning Trades", value: "\(analyticsManager.winningTrades)")
                statRow(label: "Losing Trades", value: "\(analyticsManager.losingTrades)")
                statRow(label: "Average Trade", value: analyticsManager.averageTradeReturn.formatted(.currency(code: "USD")))
                statRow(label: "Best Trade", value: analyticsManager.bestTrade.formatted(.currency(code: "USD")))
                statRow(label: "Worst Trade", value: analyticsManager.worstTrade.formatted(.currency(code: "USD")))
                statRow(label: "Profit Factor", value: String(format: "%.2f", analyticsManager.profitFactor))
            }
            .padding(16)
            .background(Color(.systemGray6).opacity(0.3))
            .cornerRadius(12)
        }
    }
    
    private func statRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.primary)
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
        }
    }
    
    // MARK: - Correlation Matrix
    
    private var correlationMatrixSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("🔗 Asset Correlation Matrix")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 8) {
                ForEach(analyticsManager.correlationMatrix, id: \.pair) { correlation in
                    correlationCell(correlation: correlation)
                }
            }
            .padding()
            .background(Color(.systemGray6).opacity(0.3))
            .cornerRadius(12)
        }
    }
    
    private func correlationCell(correlation: AssetCorrelation) -> some View {
        VStack(spacing: 4) {
            Text(correlation.pair)
                .font(.caption2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text(String(format: "%.2f", correlation.value))
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(correlationColor(correlation.value))
                .cornerRadius(4)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(Color(.systemBackground))
        .cornerRadius(8)
    }
    
    private func correlationColor(_ value: Double) -> Color {
        if value > 0.7 {
            return .green
        } else if value > 0.3 {
            return .blue
        } else if value > -0.3 {
            return .gray
        } else if value > -0.7 {
            return .orange
        } else {
            return .red
        }
    }
    
    // MARK: - Performance Attribution
    
    private var performanceAttributionSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("🎯 Performance Attribution")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Chart(analyticsManager.attributionData) { data in
                BarMark(
                    x: .value("Contribution", data.contribution),
                    y: .value("Source", data.source)
                )
                .foregroundStyle(data.contribution >= 0 ? .green : .red)
            }
            .frame(height: 200)
            .chartXAxis {
                AxisMarks { value in
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel {
                        if let contribution = value.as(Double.self) {
                            Text(contribution.formatted(.percent))
                                .font(.caption)
                        }
                    }
                }
            }
            .padding()
            .background(Color(.systemGray6).opacity(0.3))
            .cornerRadius(12)
        }
    }
}

// MARK: - Portfolio Analytics Manager

class PortfolioAnalyticsManager: ObservableObject {
    @Published var totalReturn: String = "$0.00"
    @Published var totalReturnChange: String = "+0.0%"
    @Published var sharpeRatio: Double = 0.0
    @Published var sharpeRatioChange: String = "+0.0%"
    @Published var maxDrawdown: String = "0.0%"
    @Published var maxDrawdownChange: String = "+0.0%"
    @Published var winRate: Double = 0.0
    @Published var winRateChange: String = "+0.0%"
    
    @Published var performanceData: [PerformanceDataPoint] = []
    @Published var botPerformances: [BotPerformance] = []
    @Published var correlationMatrix: [AssetCorrelation] = []
    @Published var attributionData: [AttributionData] = []
    
    // Risk metrics
    @Published var valueAtRisk: String = "$0.00"
    @Published var portfolioBeta: Double = 0.0
    @Published var avgCorrelation: Double = 0.0
    @Published var portfolioVolatility: Double = 0.0
    
    // Trading stats
    @Published var totalTrades: Int = 0
    @Published var winningTrades: Int = 0
    @Published var losingTrades: Int = 0
    @Published var averageTradeReturn: Double = 0.0
    @Published var bestTrade: Double = 0.0
    @Published var worstTrade: Double = 0.0
    @Published var profitFactor: Double = 0.0
    
    func loadAnalytics() {
        // Simulate loading analytics data
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.updateAnalytics()
        }
    }
    
    func updatePeriod(_ period: AnalyticsPeriod) {
        // Update analytics based on selected period
        updateAnalytics()
    }
    
    private func updateAnalytics() {
        // Update key metrics
        totalReturn = "$12,450.75"
        totalReturnChange = "+23.4%"
        sharpeRatio = 1.85
        sharpeRatioChange = "+12.3%"
        maxDrawdown = "-8.2%"
        maxDrawdownChange = "-2.1%"
        winRate = 0.73
        winRateChange = "+5.2%"
        
        // Risk metrics
        valueAtRisk = "$2,150.00"
        portfolioBeta = 0.87
        avgCorrelation = 0.34
        portfolioVolatility = 0.18
        
        // Trading stats
        totalTrades = 247
        winningTrades = 180
        losingTrades = 67
        averageTradeReturn = 127.50
        bestTrade = 850.25
        worstTrade = -245.75
        profitFactor = 2.68
        
        // Generate performance data
        generatePerformanceData()
        generateBotPerformances()
        generateCorrelationMatrix()
        generateAttributionData()
    }
    
    private func generatePerformanceData() {
        let calendar = Calendar.current
        let today = Date()
        
        performanceData = (0...30).map { day in
            let date = calendar.date(byAdding: .day, value: -day, to: today) ?? today
            let baseValue = 10000.0
            let growth = Double(30 - day) * 50 + Double.random(in: -200...400)
            
            return PerformanceDataPoint(date: date, value: baseValue + growth)
        }.reversed()
    }
    
    private func generateBotPerformances() {
        botPerformances = [
            BotPerformance(
                name: "Quantum AI Pro",
                profitLoss: 3250.75,
                returnPercentage: 0.325,
                winRate: 0.78,
                totalTrades: 89
            ),
            BotPerformance(
                name: "Gold Scalper Elite",
                profitLoss: 2180.50,
                returnPercentage: 0.218,
                winRate: 0.72,
                totalTrades: 156
            ),
            BotPerformance(
                name: "Trend Master 3000",
                profitLoss: 1875.25,
                returnPercentage: 0.188,
                winRate: 0.81,
                totalTrades: 45
            ),
            BotPerformance(
                name: "Scalping Beast",
                profitLoss: 945.80,
                returnPercentage: 0.095,
                winRate: 0.68,
                totalTrades: 203
            )
        ]
    }
    
    private func generateCorrelationMatrix() {
        let pairs = ["EUR/USD", "GBP/USD", "USD/JPY", "USD/CHF", "AUD/USD", "USD/CAD", "NZD/USD", "XAU/USD"]
        
        correlationMatrix = pairs.map { pair in
            AssetCorrelation(pair: pair, value: Double.random(in: -1.0...1.0))
        }
    }
    
    private func generateAttributionData() {
        attributionData = [
            AttributionData(source: "Trend Following", contribution: 0.15),
            AttributionData(source: "Scalping", contribution: 0.08),
            AttributionData(source: "News Trading", contribution: 0.12),
            AttributionData(source: "Carry Trade", contribution: -0.03),
            AttributionData(source: "Arbitrage", contribution: 0.05)
        ]
    }
}

// MARK: - Supporting Models

enum AnalyticsPeriod: String, CaseIterable {
    case thisWeek = "This Week"
    case thisMonth = "This Month"
    case threeMonths = "3 Months"
    case sixMonths = "6 Months"
    case thisYear = "This Year"
    
    var displayName: String { rawValue }
}

enum PerformanceMetric: String, CaseIterable {
    case totalReturn = "Total Return"
    case sharpeRatio = "Sharpe Ratio"
    case maxDrawdown = "Max Drawdown"
    case winRate = "Win Rate"
    
    var displayName: String { rawValue }
}

struct PerformanceDataPoint: Identifiable {
    let id = UUID()
    let date: Date
    let value: Double
}

struct BotPerformance: Identifiable {
    let id = UUID()
    let name: String
    let profitLoss: Double
    let returnPercentage: Double
    let winRate: Double
    let totalTrades: Int
}

struct AssetCorrelation: Identifiable {
    let id = UUID()
    let pair: String
    let value: Double
}

struct AttributionData: Identifiable {
    let id = UUID()
    let source: String
    let contribution: Double
}

#Preview {
    AdvancedPortfolioAnalytics()
}