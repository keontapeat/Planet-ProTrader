//
//  COTDataView.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 7/18/25.
//

import SwiftUI

struct COTDataView: View {
    @StateObject private var cotService = COTDataService()
    @State private var selectedInstrument = "EURUSD"
    @State private var selectedTimeframe: COTTimeframe = .weekly
    @State private var showingInstrumentSelector = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header with instrument selector
                cotHeader
                
                // Quick stats cards
                quickStatsSection
                
                // Main COT chart and data
                ScrollView {
                    VStack(spacing: 20) {
                        // Net positioning chart
                        netPositioningChart
                        
                        // Detailed breakdown
                        detailedBreakdown
                        
                        // Historical comparison
                        historicalComparison
                        
                        // Bot learning insights
                        botLearningInsights
                    }
                    .padding()
                }
            }
            .navigationTitle("📊 COT Data")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Settings") {
                        // COT settings
                    }
                    .foregroundColor(DesignSystem.primaryGold)
                }
            }
        }
        .sheet(isPresented: $showingInstrumentSelector) {
            InstrumentSelectorView(selectedInstrument: $selectedInstrument)
        }
        .onAppear {
            cotService.loadCOTData(for: selectedInstrument)
        }
    }
    
    // MARK: - COT Header
    
    private var cotHeader: some View {
        VStack(spacing: 12) {
            // Instrument and timeframe selector
            HStack {
                Button(action: {
                    showingInstrumentSelector = true
                }) {
                    HStack(spacing: 8) {
                        Text(selectedInstrument)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Image(systemName: "chevron.down")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .buttonStyle(PlainButtonStyle())
                
                Spacer()
                
                // Timeframe selector
                Picker("Timeframe", selection: $selectedTimeframe) {
                    ForEach(COTTimeframe.allCases, id: \.self) { timeframe in
                        Text(timeframe.rawValue).tag(timeframe)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: 200)
            }
            
            // Last update info
            HStack {
                HStack(spacing: 6) {
                    Circle()
                        .fill(cotService.isLoading ? .orange : .green)
                        .frame(width: 8, height: 8)
                    
                    Text(cotService.isLoading ? "Updating..." : "Updated")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Text("Report Date: \(cotService.lastReportDate.formatted(.dateTime.month().day()))")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemGray6))
    }
    
    // MARK: - Quick Stats Section
    
    private var quickStatsSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(cotService.quickStats, id: \.title) { stat in
                    quickStatCard(stat: stat)
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 12)
        .background(Color(.systemBackground))
    }
    
    private func quickStatCard(stat: COTQuickStat) -> some View {
        VStack(spacing: 8) {
            HStack(spacing: 4) {
                Text(stat.icon)
                    .font(.title2)
                
                Text(stat.title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
            }
            
            Text(stat.value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(stat.color)
            
            HStack(spacing: 4) {
                Image(systemName: stat.trend == .up ? "arrow.up" : stat.trend == .down ? "arrow.down" : "minus")
                    .font(.caption2)
                    .foregroundColor(stat.trend == .up ? .green : stat.trend == .down ? .red : .gray)
                
                Text(stat.change)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(
            LinearGradient(
                colors: [stat.color.opacity(0.1), stat.color.opacity(0.05)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(stat.color.opacity(0.3), lineWidth: 1)
        )
    }
    
    // MARK: - Net Positioning Chart
    
    private var netPositioningChart: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("🏛️ NET INSTITUTIONAL POSITIONING")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            VStack(spacing: 12) {
                // Chart visualization
                netPositioningVisualization
                
                // Position breakdown
                HStack(spacing: 20) {
                    positionBreakdownItem(
                        title: "Commercial",
                        subtitle: "Hedgers",
                        value: cotService.currentData.commercialNet,
                        color: .blue,
                        icon: "building.2"
                    )
                    
                    positionBreakdownItem(
                        title: "Large Spec",
                        subtitle: "Funds",
                        value: cotService.currentData.largeSpecNet,
                        color: .purple,
                        icon: "chart.line.uptrend.xyaxis"
                    )
                    
                    positionBreakdownItem(
                        title: "Small Spec",
                        subtitle: "Retail",
                        value: cotService.currentData.smallSpecNet,
                        color: .orange,
                        icon: "person.2"
                    )
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
    
    private var netPositioningVisualization: some View {
        GeometryReader { geometry in
            ZStack {
                // Background grid
                Path { path in
                    let width = geometry.size.width
                    let height = geometry.size.height
                    
                    // Horizontal lines
                    for i in 1..<5 {
                        let y = height * CGFloat(i) / 5
                        path.move(to: CGPoint(x: 0, y: y))
                        path.addLine(to: CGPoint(x: width, y: y))
                    }
                }
                .stroke(Color(.systemGray4), style: StrokeStyle(lineWidth: 0.5, dash: [2, 2]))
                
                // Zero line
                Path { path in
                    let y = geometry.size.height / 2
                    path.move(to: CGPoint(x: 0, y: y))
                    path.addLine(to: CGPoint(x: geometry.size.width, y: y))
                }
                .stroke(Color.primary.opacity(0.6), lineWidth: 2)
                
                // Net position lines
                cotNetPositionLines(geometry: geometry)
                
                // Current position indicators
                currentPositionIndicators(geometry: geometry)
            }
        }
        .frame(height: 200)
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
    
    private func cotNetPositionLines(geometry: GeometryProxy) -> some View {
        let width = geometry.size.width
        let height = geometry.size.height
        let dataPoints = cotService.historicalData
        
        return ZStack {
            // Commercial line
            Path { path in
                for (index, data) in dataPoints.enumerated() {
                    let x = width * CGFloat(index) / CGFloat(max(dataPoints.count - 1, 1))
                    let normalizedValue = (data.commercialNet + 100) / 200 // Normalize to 0-1
                    let y = height * (1 - CGFloat(normalizedValue))
                    
                    if index == 0 {
                        path.move(to: CGPoint(x: x, y: y))
                    } else {
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                }
            }
            .stroke(Color.blue, lineWidth: 3)
            
            // Large spec line
            Path { path in
                for (index, data) in dataPoints.enumerated() {
                    let x = width * CGFloat(index) / CGFloat(max(dataPoints.count - 1, 1))
                    let normalizedValue = (data.largeSpecNet + 100) / 200 // Normalize to 0-1
                    let y = height * (1 - CGFloat(normalizedValue))
                    
                    if index == 0 {
                        path.move(to: CGPoint(x: x, y: y))
                    } else {
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                }
            }
            .stroke(Color.purple, lineWidth: 3)
            
            // Small spec line
            Path { path in
                for (index, data) in dataPoints.enumerated() {
                    let x = width * CGFloat(index) / CGFloat(max(dataPoints.count - 1, 1))
                    let normalizedValue = (data.smallSpecNet + 100) / 200 // Normalize to 0-1
                    let y = height * (1 - CGFloat(normalizedValue))
                    
                    if index == 0 {
                        path.move(to: CGPoint(x: x, y: y))
                    } else {
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                }
            }
            .stroke(Color.orange, lineWidth: 3)
        }
    }
    
    private func currentPositionIndicators(geometry: GeometryProxy) -> some View {
        let width = geometry.size.width
        let height = geometry.size.height
        
        return ZStack {
            // Commercial indicator
            Circle()
                .fill(Color.blue)
                .frame(width: 12, height: 12)
                .position(
                    x: width * 0.95,
                    y: height * (1 - CGFloat((cotService.currentData.commercialNet + 100) / 200))
                )
            
            // Large spec indicator
            Circle()
                .fill(Color.purple)
                .frame(width: 12, height: 12)
                .position(
                    x: width * 0.95,
                    y: height * (1 - CGFloat((cotService.currentData.largeSpecNet + 100) / 200))
                )
            
            // Small spec indicator
            Circle()
                .fill(Color.orange)
                .frame(width: 12, height: 12)
                .position(
                    x: width * 0.95,
                    y: height * (1 - CGFloat((cotService.currentData.smallSpecNet + 100) / 200))
                )
        }
    }
    
    private func positionBreakdownItem(title: String, subtitle: String, value: Double, color: Color, icon: String) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(title)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text(subtitle)
                .font(.caption2)
                .foregroundColor(.secondary)
            
            Text(String(format: "%.1f%%", value))
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(value >= 0 ? .green : .red)
        }
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(12)
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Detailed Breakdown
    
    private var detailedBreakdown: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("📈 DETAILED POSITION BREAKDOWN")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            VStack(spacing: 12) {
                ForEach(cotService.detailedBreakdown, id: \.category) { breakdown in
                    detailBreakdownRow(breakdown: breakdown)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
    
    private func detailBreakdownRow(breakdown: COTDetailedBreakdown) -> some View {
        VStack(spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(breakdown.category)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    Text(breakdown.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(String(format: "%.1f%%", breakdown.netPercentage))
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(breakdown.netPercentage >= 0 ? .green : .red)
                    
                    Text("vs \(String(format: "%.1f%%", breakdown.previousWeek))")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            
            // Position bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color(.systemGray4))
                        .frame(height: 4)
                    
                    Rectangle()
                        .fill(breakdown.color)
                        .frame(
                            width: geometry.size.width * CGFloat(abs(breakdown.netPercentage) / 100),
                            height: 4
                        )
                }
            }
            .frame(height: 4)
        }
        .padding()
        .background(breakdown.color.opacity(0.05))
        .cornerRadius(8)
    }
    
    // MARK: - Historical Comparison
    
    private var historicalComparison: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("📊 HISTORICAL CONTEXT")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            VStack(spacing: 16) {
                // Percentile rankings
                VStack(alignment: .leading, spacing: 12) {
                    Text("Current Position Percentiles (1 Year)")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    VStack(spacing: 8) {
                        percentileRow(title: "Commercial", percentile: 75, color: .blue)
                        percentileRow(title: "Large Spec", percentile: 25, color: .purple)
                        percentileRow(title: "Small Spec", percentile: 60, color: .orange)
                    }
                }
                
                // Extreme readings
                extremeReadingsSection
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
    
    private func percentileRow(title: String, percentile: Int, color: Color) -> some View {
        VStack(spacing: 6) {
            HStack {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Text("\(percentile)th percentile")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(color)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color(.systemGray4))
                        .frame(height: 6)
                    
                    Rectangle()
                        .fill(color)
                        .frame(width: geometry.size.width * CGFloat(percentile) / 100, height: 6)
                }
            }
            .frame(height: 6)
        }
    }
    
    private var extremeReadingsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("⚠️ Extreme Readings")
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.primary)
            
            VStack(spacing: 6) {
                HStack {
                    Circle()
                        .fill(.red)
                        .frame(width: 8, height: 8)
                    
                    Text("Commercial positions at 75th percentile - typically contrarian bullish")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                }
                
                HStack {
                    Circle()
                        .fill(.orange)
                        .frame(width: 8, height: 8)
                    
                    Text("Large spec positions below average - potential for reversal")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                }
            }
        }
    }
    
    // MARK: - Bot Learning Insights
    
    private var botLearningInsights: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("🤖 BOT LEARNING INSIGHTS")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(DesignSystem.primaryGold)
            
            VStack(spacing: 12) {
                // Current bot analysis
                botInsightCard(
                    title: "Position Alignment",
                    insight: "Your bots are currently LONG biased, aligning with commercial positioning. This suggests institutional support for upward moves.",
                    confidence: 85,
                    action: "Continue monitoring for position changes"
                )
                
                botInsightCard(
                    title: "Contrarian Signal",
                    insight: "Large spec positions are at multi-week lows. Historically, this has preceded significant moves in the opposite direction.",
                    confidence: 72,
                    action: "Bots learning to fade extreme spec positions"
                )
                
                botInsightCard(
                    title: "Risk Management",
                    insight: "COT data suggests low volatility period ending. Bots are adjusting position sizing accordingly.",
                    confidence: 90,
                    action: "Implementing dynamic risk management"
                )
            }
        }
        .padding()
        .background(DesignSystem.primaryGold.opacity(0.05))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(DesignSystem.primaryGold.opacity(0.3), lineWidth: 2)
        )
    }
    
    private func botInsightCard(title: String, insight: String, confidence: Int, action: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Text("\(confidence)% Confidence")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(DesignSystem.primaryGold)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(DesignSystem.primaryGold.opacity(0.1))
                    .cornerRadius(4)
            }
            
            Text(insight)
                .font(.caption)
                .foregroundColor(.secondary)
                .lineSpacing(2)
            
            HStack {
                Image(systemName: "lightbulb.fill")
                    .font(.caption)
                    .foregroundColor(DesignSystem.primaryGold)
                
                Text("Action: \(action)")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(DesignSystem.primaryGold)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(8)
    }
}

// MARK: - COT Data Models & Service

enum COTTimeframe: String, CaseIterable {
    case weekly = "Weekly"
    case monthly = "Monthly"
}

struct COTQuickStat {
    let title: String
    let value: String
    let change: String
    let trend: Trend
    let color: Color
    let icon: String
    
    enum Trend {
        case up, down, neutral
    }
}

struct COTData {
    let date: Date
    let commercialLong: Double
    let commercialShort: Double
    let commercialNet: Double
    let largeSpecLong: Double
    let largeSpecShort: Double
    let largeSpecNet: Double
    let smallSpecLong: Double
    let smallSpecShort: Double
    let smallSpecNet: Double
}

struct COTDetailedBreakdown {
    let category: String
    let description: String
    let netPercentage: Double
    let previousWeek: Double
    let color: Color
}

class COTDataService: ObservableObject {
    @Published var isLoading = false
    @Published var currentData: COTData
    @Published var historicalData: [COTData] = []
    @Published var quickStats: [COTQuickStat] = []
    @Published var detailedBreakdown: [COTDetailedBreakdown] = []
    @Published var lastReportDate = Date()
    
    init() {
        // Initialize with sample data
        self.currentData = COTData(
            date: Date(),
            commercialLong: 45.2,
            commercialShort: 35.8,
            commercialNet: 9.4,
            largeSpecLong: 25.6,
            largeSpecShort: 30.1,
            largeSpecNet: -4.5,
            smallSpecLong: 29.2,
            smallSpecShort: 34.1,
            smallSpecNet: -4.9
        )
        
        loadSampleData()
    }
    
    func loadCOTData(for instrument: String) {
        isLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.loadSampleData()
            self.isLoading = false
        }
    }
    
    private func loadSampleData() {
        // Generate sample historical data
        historicalData = generateHistoricalData()
        
        // Generate quick stats
        quickStats = [
            COTQuickStat(
                title: "Commercial Net",
                value: "+9.4%",
                change: "+2.1%",
                trend: .up,
                color: .blue,
                icon: "🏛️"
            ),
            COTQuickStat(
                title: "Large Spec Net",
                value: "-4.5%",
                change: "-1.8%",
                trend: .down,
                color: .purple,
                icon: "📈"
            ),
            COTQuickStat(
                title: "Small Spec Net",
                value: "-4.9%",
                change: "-0.3%",
                trend: .down,
                color: .orange,
                icon: "👥"
            ),
            COTQuickStat(
                title: "Open Interest",
                value: "245K",
                change: "+5.2%",
                trend: .up,
                color: .green,
                icon: "📊"
            )
        ]
        
        // Generate detailed breakdown
        detailedBreakdown = [
            COTDetailedBreakdown(
                category: "Commercial Hedgers",
                description: "Large institutions hedging exposure",
                netPercentage: 9.4,
                previousWeek: 7.3,
                color: .blue
            ),
            COTDetailedBreakdown(
                category: "Large Speculators",
                description: "Hedge funds and large traders",
                netPercentage: -4.5,
                previousWeek: -2.7,
                color: .purple
            ),
            COTDetailedBreakdown(
                category: "Small Speculators",
                description: "Individual and small traders",
                netPercentage: -4.9,
                previousWeek: -4.6,
                color: .orange
            )
        ]
        
        lastReportDate = Date()
    }
    
    private func generateHistoricalData() -> [COTData] {
        var data: [COTData] = []
        
        for i in 0..<52 { // 52 weeks of data
            let date = Calendar.current.date(byAdding: .weekOfYear, value: -i, to: Date()) ?? Date()
            
            data.append(COTData(
                date: date,
                commercialLong: 45.2 + Double.random(in: -5...5),
                commercialShort: 35.8 + Double.random(in: -5...5),
                commercialNet: 9.4 + Double.random(in: -10...10),
                largeSpecLong: 25.6 + Double.random(in: -5...5),
                largeSpecShort: 30.1 + Double.random(in: -5...5),
                largeSpecNet: -4.5 + Double.random(in: -10...10),
                smallSpecLong: 29.2 + Double.random(in: -5...5),
                smallSpecShort: 34.1 + Double.random(in: -5...5),
                smallSpecNet: -4.9 + Double.random(in: -10...10)
            ))
        }
        
        return data.reversed()
    }
}

struct InstrumentSelectorView: View {
    @Binding var selectedInstrument: String
    @Environment(\.dismiss) private var dismiss
    
    private let instruments = [
        "EURUSD", "GBPUSD", "USDJPY", "AUDUSD", "USDCAD",
        "XAUUSD", "XAGUSD", "CRUDE OIL", "NATURAL GAS", 
        "SP500", "NASDAQ", "DOW JONES", "BITCOIN", "ETHEREUM"
    ]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(instruments, id: \.self) { instrument in
                    Button(action: {
                        selectedInstrument = instrument
                        dismiss()
                    }) {
                        HStack {
                            Text(instrument)
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            if selectedInstrument == instrument {
                                Image(systemName: "checkmark")
                                    .foregroundColor(DesignSystem.primaryGold)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Select Instrument")
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
    }
}

#Preview {
    COTDataView()
}