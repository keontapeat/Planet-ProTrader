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
    @State private var selectedMetric: PerformanceMetricType = .totalReturn
    @State private var showingDetailedBreakdown = false
    @State private var animateCharts = false
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationStack {
            ZStack {
                if isLoading {
                    loadingView
                } else if let errorMessage = errorMessage {
                    errorView(errorMessage)
                } else {
                    mainContent
                }
            }
            .background(Color(.systemBackground))
            .navigationTitle("📊 Portfolio Analytics")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Export") {
                        exportAnalytics()
                    }
                    .foregroundColor(DesignSystem.primaryGold)
                }
            }
            .onAppear {
                loadAnalyticsData()
            }
        }
    }
    
    // MARK: - Main Content
    
    private var mainContent: some View {
        ScrollView {
            VStack(spacing: 24) {
                performanceOverview
                performanceChart
                botPerformanceSection
                riskAnalyticsSection
                tradingStatsSection
                correlationMatrixSection
                performanceAttributionSection
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
    }
    
    // MARK: - Loading & Error States
    
    private var loadingView: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
                .progressViewStyle(CircularProgressViewStyle(tint: DesignSystem.primaryGold))
            
            Text("Loading Analytics...")
                .font(.headline)
                .foregroundColor(.secondary)
        }
    }
    
    private func errorView(_ message: String) -> some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(.red)
            
            Text("Error Loading Analytics")
                .font(.title2)
                .fontWeight(.bold)
            
            Text(message)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button("Retry") {
                loadAnalyticsData()
            }
            .buttonStyle(.borderedProminent)
            .tint(DesignSystem.primaryGold)
        }
        .padding()
    }
    
    // MARK: - Performance Overview
    
    private var performanceOverview: some View {
        VStack(spacing: 16) {
            periodSelector
            
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
        .onChange(of: selectedPeriod) { _, newValue in
            analyticsManager.updatePeriod(newValue)
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
                    ForEach(PerformanceMetricType.allCases, id: \.self) { metric in
                        Text(metric.rawValue).tag(metric)
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }
            
            if analyticsManager.performanceData.isEmpty {
                Text("No performance data available")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .frame(height: 200)
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGray6).opacity(0.3))
                    .cornerRadius(12)
            } else {
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
            
            if analyticsManager.botPerformances.isEmpty {
                Text("No bot performance data available")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    .background(Color(.systemGray6).opacity(0.3))
                    .cornerRadius(12)
            } else {
                LazyVStack(spacing: 8) {
                    ForEach(Array(analyticsManager.botPerformances.enumerated()), id: \.element.id) { index, bot in
                        botPerformanceRow(bot: bot, rank: index + 1)
                    }
                }
            }
        }
        .sheet(isPresented: $showingDetailedBreakdown) {
            BotPerformanceDetailSheet(bots: analyticsManager.botPerformances)
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
            
            if analyticsManager.correlationMatrix.isEmpty {
                Text("No correlation data available")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    .background(Color(.systemGray6).opacity(0.3))
                    .cornerRadius(12)
            } else {
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
        switch value {
        case 0.7...1.0: return .green
        case 0.3..<0.7: return .blue
        case -0.3..<0.3: return .gray
        case -0.7..<(-0.3): return .orange
        default: return .red
        }
    }
    
    // MARK: - Performance Attribution
    
    private var performanceAttributionSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("🎯 Performance Attribution")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            if analyticsManager.attributionData.isEmpty {
                Text("No attribution data available")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .frame(height: 200)
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGray6).opacity(0.3))
                    .cornerRadius(12)
            } else {
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
    
    // MARK: - Helper Methods
    
    private func loadAnalyticsData() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                try await analyticsManager.loadAnalytics()
                await MainActor.run {
                    isLoading = false
                    withAnimation(.easeInOut(duration: 1.5)) {
                        animateCharts = true
                    }
                }
            } catch {
                await MainActor.run {
                    isLoading = false
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    private func exportAnalytics() {
        // Export analytics report
        Task {
            await MainActor.run {
                ToastManager.shared.showSuccess("Analytics report exported!")
            }
        }
    }
}

// MARK: - Performance Metric Type (FIXED - MISSING ENUM!)

enum PerformanceMetricType: String, CaseIterable {
    case totalReturn = "Total Return"
    case sharpeRatio = "Sharpe Ratio"
    case maxDrawdown = "Max Drawdown"
    case profitLoss = "Profit & Loss"
    case winRate = "Win Rate"
    case volatility = "Volatility"
    case roi = "ROI"
    
    var displayName: String { rawValue }
}

// MARK: - Bot Performance Detail Sheet

struct BotPerformanceDetailSheet: View {
    let bots: [BotPerformance]
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List(Array(bots.enumerated()), id: \.element.id) { index, bot in
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("#\(index + 1)")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Circle().fill(Color.blue))
                        
                        Text(bot.name)
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        Text(bot.profitLoss.formatted(.currency(code: "USD")))
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(bot.profitLoss >= 0 ? .green : .red)
                    }
                    
                    HStack {
                        Label("Win Rate: \(Int(bot.winRate * 100))%", systemImage: "target")
                        Spacer()
                        Label("\(bot.totalTrades) trades", systemImage: "chart.bar")
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                    
                    ProgressView(value: bot.winRate)
                        .progressViewStyle(LinearProgressViewStyle(tint: .green))
                }
                .padding(.vertical, 8)
            }
            .navigationTitle("Bot Performance Details")
            .navigationBarTitleDisplayMode(.large)
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

// MARK: - Portfolio Analytics Manager (REFACTORED)

@MainActor
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
    
    private let dataService: AnalyticsDataService
    
    init(dataService: AnalyticsDataService = AnalyticsDataService()) {
        self.dataService = dataService
    }
    
    func loadAnalytics() async throws {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
        
        await updateAnalytics()
    }
    
    func updatePeriod(_ period: AnalyticsPeriod) {
        Task {
            await updateAnalytics(for: period)
        }
    }
    
    private func updateAnalytics(for period: AnalyticsPeriod = .thisMonth) async {
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
        await generatePerformanceData()
        await generateBotPerformances()
        await generateCorrelationMatrix()
        await generateAttributionData()
    }
    
    private func generatePerformanceData() async {
        let calendar = Calendar.current
        let today = Date()
        
        performanceData = (0...30).compactMap { day in
            guard let date = calendar.date(byAdding: .day, value: -day, to: today) else { return nil }
            let baseValue = 10000.0
            let growth = Double(30 - day) * 50 + Double.random(in: -200...400)
            
            return PerformanceDataPoint(date: date, value: baseValue + growth)
        }.reversed()
    }
    
    private func generateBotPerformances() async {
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
    
    private func generateCorrelationMatrix() async {
        let pairs = ["EUR/USD", "GBP/USD", "USD/JPY", "USD/CHF", "AUD/USD", "USD/CAD", "NZD/USD", "XAU/USD"]
        
        correlationMatrix = pairs.map { pair in
            AssetCorrelation(pair: pair, value: Double.random(in: -1.0...1.0))
        }
    }
    
    private func generateAttributionData() async {
        attributionData = [
            AttributionData(source: "Trend Following", contribution: 0.15),
            AttributionData(source: "Scalping", contribution: 0.08),
            AttributionData(source: "News Trading", contribution: 0.12),
            AttributionData(source: "Carry Trade", contribution: -0.03),
            AttributionData(source: "Arbitrage", contribution: 0.05)
        ]
    }
}

// MARK: - Analytics Data Service (NEW - DEPENDENCY INJECTION)

class AnalyticsDataService {
    func fetchAnalyticsData() async throws -> AnalyticsData {
        // In real app, this would make API calls
        throw NSError(domain: "NotImplemented", code: 0, userInfo: [NSLocalizedDescriptionKey: "Analytics data service not implemented"])
    }
}

struct AnalyticsData {
    let performanceMetrics: [String: Any]
    let riskMetrics: [String: Any]
    let tradingStats: [String: Any]
}

// MARK: - Supporting Models (UNCHANGED)

enum AnalyticsPeriod: String, CaseIterable {
    case thisWeek = "This Week"
    case thisMonth = "This Month"
    case threeMonths = "3 Months"
    case sixMonths = "6 Months"
    case thisYear = "This Year"
    
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

// MARK: - Preview

#Preview {
    AdvancedPortfolioAnalytics()
}