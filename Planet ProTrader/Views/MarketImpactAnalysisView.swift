//
//  MarketImpactAnalysisView.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 1/21/25.
//

import SwiftUI
import Charts

struct MarketImpactAnalysisView: View {
    @Environment(\.dismiss) private var dismiss
    let article: NewsArticleModel
    @StateObject private var impactAnalyzer = MarketImpactAnalyzer()
    @State private var selectedTimeframe: AnalysisTimeframe = .oneHour
    @State private var showingPredictions = true
    @State private var animateCharts = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header with real-time impact score
                    impactScoreHeader
                    
                    // Volatility prediction chart
                    volatilityChart
                    
                    // Currency strength analysis
                    currencyStrengthSection
                    
                    // Market correlation heatmap
                    correlationHeatmap
                    
                    // AI predictions and scenarios
                    aiPredictionsSection
                    
                    // Historical similar events
                    historicalEventsSection
                    
                    // Risk assessment
                    riskAssessmentSection
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
            .background(Color(.systemBackground))
            .navigationTitle("📊 Impact Analysis")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .foregroundColor(DesignSystem.primaryGold)
                }
            }
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
        .onAppear {
            Task {
                await impactAnalyzer.analyzeMarketImpact(for: article)
                withAnimation(.easeInOut(duration: 1.5)) {
                    animateCharts = true
                }
            }
        }
    }
    
    // MARK: - Impact Score Header
    
    private var impactScoreHeader: some View {
        VStack(spacing: 16) {
            // Main impact score
            ZStack {
                Circle()
                    .stroke(Color(.systemGray5), lineWidth: 8)
                    .frame(width: 120, height: 120)
                
                Circle()
                    .trim(from: 0, to: animateCharts ? impactAnalyzer.impactScore / 100 : 0)
                    .stroke(
                        LinearGradient(
                            colors: [.green, .yellow, .orange, .red],
                            startPoint: .bottomTrailing,
                            endPoint: .topLeading
                        ),
                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                    )
                    .frame(width: 120, height: 120)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 2.0), value: animateCharts)
                
                VStack(spacing: 4) {
                    Text("\(Int(impactAnalyzer.impactScore))")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                        .contentTransition(.numericText())
                        .animation(.easeInOut(duration: 1.0), value: impactAnalyzer.impactScore)
                    
                    Text("Impact Score")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                }
            }
            
            // Impact details
            HStack(spacing: 20) {
                impactDetail(
                    title: "Volatility",
                    value: impactAnalyzer.volatilityIncrease,
                    color: .orange,
                    icon: "waveform.path"
                )
                
                impactDetail(
                    title: "Duration",
                    value: impactAnalyzer.estimatedDuration,
                    color: .blue,
                    icon: "clock.fill"
                )
                
                impactDetail(
                    title: "Certainty",
                    value: "\(Int(impactAnalyzer.certaintyLevel))%",
                    color: .green,
                    icon: "checkmark.seal.fill"
                )
            }
            .padding()
            .background(Color(.systemGray6).opacity(0.5))
            .cornerRadius(16)
        }
    }
    
    private func impactDetail(title: String, value: String, color: Color, icon: String) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
            
            Text(value)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
    
    // MARK: - Volatility Chart
    
    private var volatilityChart: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("📈 Volatility Prediction")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Spacer()
                
                // Timeframe selector
                Picker("Timeframe", selection: $selectedTimeframe) {
                    ForEach(AnalysisTimeframe.allCases, id: \.self) { timeframe in
                        Text(timeframe.displayName).tag(timeframe)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: 180)
            }
            
            // Chart
            Chart(impactAnalyzer.volatilityData) { data in
                LineMark(
                    x: .value("Time", data.time),
                    y: .value("Volatility", data.volatility)
                )
                .foregroundStyle(
                    LinearGradient(
                        colors: [.green, .orange, .red],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .lineStyle(StrokeStyle(lineWidth: 3))
                
                AreaMark(
                    x: .value("Time", data.time),
                    y: .value("Volatility", data.volatility)
                )
                .foregroundStyle(
                    LinearGradient(
                        colors: [.green.opacity(0.3), .orange.opacity(0.2), .red.opacity(0.1)],
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
                            Text(date.formatted(.dateTime.hour().minute()))
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
                        if let volatility = value.as(Double.self) {
                            Text("\(Int(volatility))%")
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
    
    // MARK: - Currency Strength Section
    
    private var currencyStrengthSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("💪 Currency Strength Impact")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                ForEach(impactAnalyzer.currencyImpacts, id: \.currency) { impact in
                    currencyStrengthCard(impact: impact)
                }
            }
        }
    }
    
    private func currencyStrengthCard(impact: CurrencyImpact) -> some View {
        VStack(spacing: 10) {
            // Currency header
            HStack {
                Text(impact.currency)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(currencyColor(impact.currency))
                    .clipShape(Circle())
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text(impact.expectedChange)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(impact.changeColor)
                    
                    Text("Expected")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            
            // Strength meter
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color(.systemGray5))
                        .frame(height: 6)
                        .cornerRadius(3)
                    
                    Rectangle()
                        .fill(impact.changeColor)
                        .frame(width: geometry.size.width * CGFloat(abs(impact.strengthPercentage) / 100), height: 6)
                        .cornerRadius(3)
                        .animation(.easeInOut(duration: 1.5).delay(0.3), value: animateCharts)
                }
            }
            .frame(height: 6)
            
            // Impact description
            Text(impact.description)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .padding(16)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(impact.changeColor.opacity(0.3), lineWidth: 1)
        )
    }
    
    // MARK: - Correlation Heatmap
    
    private var correlationHeatmap: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("🔥 Market Correlation Heatmap")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 8) {
                ForEach(impactAnalyzer.correlationData, id: \.pair) { correlation in
                    correlationCell(correlation: correlation)
                }
            }
            .padding()
            .background(Color(.systemGray6).opacity(0.3))
            .cornerRadius(12)
        }
    }
    
    private func correlationCell(correlation: CorrelationData) -> some View {
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
        if value > 0.5 {
            return .green
        } else if value < -0.5 {
            return .red
        } else {
            return .gray
        }
    }
    
    // MARK: - AI Predictions Section
    
    private var aiPredictionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("🤖 AI Market Predictions")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Toggle("Show Predictions", isOn: $showingPredictions)
                    .toggleStyle(SwitchToggleStyle(tint: DesignSystem.primaryGold))
            }
            
            if showingPredictions {
                LazyVStack(spacing: 12) {
                    ForEach(impactAnalyzer.aiPredictions, id: \.id) { prediction in
                        predictionCard(prediction: prediction)
                    }
                }
            }
        }
    }
    
    private func predictionCard(prediction: AIPrediction) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: "brain.head.profile")
                    .font(.title3)
                    .foregroundColor(DesignSystem.primaryGold)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(prediction.title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text("Confidence: \(Int(prediction.confidence * 100))%")
                        .font(.caption)
                        .foregroundColor(prediction.confidence > 0.7 ? .green : .orange)
                }
                
                Spacer()
                
                Text(prediction.timeframe)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color(.systemGray6))
                    .cornerRadius(4)
            }
            
            Text(prediction.description)
                .font(.subheadline)
                .foregroundColor(.primary)
                .lineLimit(nil)
            
            // Probability meter
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color(.systemGray5))
                        .frame(height: 4)
                        .cornerRadius(2)
                    
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [.red, .orange, .green],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * CGFloat(prediction.confidence), height: 4)
                        .cornerRadius(2)
                        .animation(.easeInOut(duration: 1.0).delay(0.5), value: animateCharts)
                }
            }
            .frame(height: 4)
        }
        .padding(16)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(DesignSystem.primaryGold.opacity(0.3), lineWidth: 1)
        )
    }
    
    // MARK: - Historical Events Section
    
    private var historicalEventsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("📚 Similar Historical Events")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            LazyVStack(spacing: 8) {
                ForEach(impactAnalyzer.historicalEvents, id: \.id) { event in
                    historicalEventRow(event: event)
                }
            }
        }
    }
    
    private func historicalEventRow(event: HistoricalEvent) -> some View {
        HStack(spacing: 12) {
            VStack {
                Text(event.date.formatted(.dateTime.month().day()))
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                
                Text(event.date.formatted(.dateTime.year()))
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(event.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                
                Text("Market moved \(event.marketMove)% • Similarity: \(Int(event.similarity * 100))%")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack {
                Text(event.marketMove > 0 ? "📈" : "📉")
                    .font(.title3)
                
                Text(String(format: "%.1f%%", abs(event.marketMove)))
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(event.marketMove > 0 ? .green : .red)
            }
        }
        .padding(12)
        .background(Color(.systemGray6).opacity(0.5))
        .cornerRadius(10)
    }
    
    // MARK: - Risk Assessment Section
    
    private var riskAssessmentSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("⚠️ Risk Assessment")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                riskCard(
                    title: "Volatility Risk",
                    level: impactAnalyzer.volatilityRisk,
                    color: .orange,
                    icon: "waveform.path"
                )
                
                riskCard(
                    title: "Liquidity Risk",
                    level: impactAnalyzer.liquidityRisk,
                    color: .blue,
                    icon: "drop.fill"
                )
                
                riskCard(
                    title: "Correlation Risk",
                    level: impactAnalyzer.correlationRisk,
                    color: .purple,
                    icon: "link"
                )
                
                riskCard(
                    title: "Overnight Risk",
                    level: impactAnalyzer.overnightRisk,
                    color: .red,
                    icon: "moon.fill"
                )
            }
        }
    }
    
    private func riskCard(title: String, level: RiskLevel, color: Color, icon: String) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
            
            Text(level.displayName)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 3)
                .background(level.color)
                .cornerRadius(6)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(level.color.opacity(0.3), lineWidth: 1)
        )
    }
    
    // MARK: - Helper Methods
    
    private func currencyColor(_ currency: String) -> Color {
        switch currency {
        case "USD": return .blue
        case "EUR": return .purple
        case "GBP": return .green
        case "JPY": return .red
        case "CHF": return .orange
        case "CAD": return .pink
        case "AUD": return .cyan
        case "NZD": return .mint
        default: return .gray
        }
    }
}

// MARK: - Market Impact Analyzer

class MarketImpactAnalyzer: ObservableObject {
    @Published var impactScore: Double = 0
    @Published var volatilityIncrease: String = "Loading..."
    @Published var estimatedDuration: String = "Loading..."
    @Published var certaintyLevel: Double = 0
    
    @Published var volatilityData: [VolatilityData] = []
    @Published var currencyImpacts: [CurrencyImpact] = []
    @Published var correlationData: [CorrelationData] = []
    @Published var aiPredictions: [AIPrediction] = []
    @Published var historicalEvents: [HistoricalEvent] = []
    
    @Published var volatilityRisk: RiskLevel = .medium
    @Published var liquidityRisk: RiskLevel = .low
    @Published var correlationRisk: RiskLevel = .high
    @Published var overnightRisk: RiskLevel = .medium
    
    func analyzeMarketImpact(for article: NewsArticleModel) async {
        // Simulate AI analysis
        try? await Task.sleep(nanoseconds: 1_500_000_000)
        
        DispatchQueue.main.async {
            self.performAnalysis(for: article)
        }
    }
    
    private func performAnalysis(for article: NewsArticleModel) {
        // Calculate impact score
        impactScore = calculateImpactScore(for: article)
        volatilityIncrease = "+\(Int.random(in: 15...45))%"
        estimatedDuration = "\(Int.random(in: 2...8)) hours"
        certaintyLevel = Double.random(in: 75...95)
        
        // Generate volatility data
        generateVolatilityData()
        
        // Generate currency impacts
        generateCurrencyImpacts()
        
        // Generate correlation data
        generateCorrelationData()
        
        // Generate AI predictions
        generateAIPredictions(for: article)
        
        // Generate historical events
        generateHistoricalEvents()
        
        // Set risk levels
        setRiskLevels(for: article)
    }
    
    private func calculateImpactScore(for article: NewsArticleModel) -> Double {
        var score = 50.0
        
        switch article.impact {
        case .low: score += 10
        case .medium: score += 25
        case .high: score += 40
        case .critical: score += 60
        }
        
        // Add some randomness for demo
        score += Double.random(in: 0...20)
        
        return min(100, max(0, score))
    }
    
    private func generateVolatilityData() {
        let now = Date()
        volatilityData = (0...24).map { hour in
            let time = now.addingTimeInterval(TimeInterval(hour * 3600))
            let baseVolatility = 20.0
            let impactVolatility = Double.random(in: 10...60)
            let volatility = baseVolatility + (impactVolatility * (1.0 - Double(hour) / 24.0))
            
            return VolatilityData(time: time, volatility: volatility)
        }
    }
    
    private func generateCurrencyImpacts() {
        // Generate sample currency impacts
        let currencies = ["USD", "EUR", "GBP", "JPY"]
        currencyImpacts = currencies.map { currency in
            let change = Double.random(in: -2.5...2.5)
            let strength = abs(change) * 20
            
            return CurrencyImpact(
                currency: currency,
                expectedChange: change > 0 ? "+\(String(format: "%.1f", change))%" : "\(String(format: "%.1f", change))%",
                changeColor: change > 0 ? .green : .red,
                strengthPercentage: strength,
                description: generateCurrencyDescription(currency: currency, change: change)
            )
        }
    }
    
    private func generateCurrencyDescription(currency: String, change: Double) -> String {
        let direction = change > 0 ? "strengthen" : "weaken"
        return "\(currency) expected to \(direction) based on news impact"
    }
    
    private func generateCorrelationData() {
        let pairs = ["EUR/USD", "GBP/USD", "USD/JPY", "USD/CHF", "AUD/USD", "USD/CAD", "NZD/USD", "XAU/USD"]
        
        correlationData = pairs.map { pair in
            CorrelationData(
                pair: pair,
                value: Double.random(in: -1.0...1.0)
            )
        }
    }
    
    private func generateAIPredictions(for article: NewsArticleModel) {
        aiPredictions = [
            AIPrediction(
                title: "Short-term Volatility Spike Expected",
                description: "AI models predict increased volatility in the next 2-4 hours with 85% confidence based on similar historical patterns.",
                confidence: 0.85,
                timeframe: "2-4 hours"
            ),
            AIPrediction(
                title: "Correlation Breakdown Likely",
                description: "Traditional currency correlations may temporarily break down as markets react to this news event.",
                confidence: 0.72,
                timeframe: "1-2 sessions"
            ),
            AIPrediction(
                title: "Risk-Off Sentiment to Emerge",
                description: "Safe haven assets likely to benefit as risk sentiment deteriorates following this announcement.",
                confidence: 0.68,
                timeframe: "4-8 hours"
            )
        ]
    }
    
    private func generateHistoricalEvents() {
        historicalEvents = [
            HistoricalEvent(
                title: "Similar Fed announcement in March 2023",
                date: Calendar.current.date(byAdding: .month, value: -10, to: Date()) ?? Date(),
                marketMove: 1.8,
                similarity: 0.87
            ),
            HistoricalEvent(
                title: "ECB policy shift September 2022",
                date: Calendar.current.date(byAdding: .month, value: -16, to: Date()) ?? Date(),
                marketMove: -2.3,
                similarity: 0.74
            ),
            HistoricalEvent(
                title: "BOE intervention October 2022",
                date: Calendar.current.date(byAdding: .month, value: -15, to: Date()) ?? Date(),
                marketMove: 3.1,
                similarity: 0.69
            )
        ]
    }
    
    private func setRiskLevels(for article: NewsArticleModel) {
        volatilityRisk = article.impact == .high || article.impact == .critical ? .high : .medium
        liquidityRisk = .low  // simplified for demo
        correlationRisk = .high
        overnightRisk = .medium
    }
}

// MARK: - Supporting Data Models

struct VolatilityData: Identifiable {
    let id = UUID()
    let time: Date
    let volatility: Double
}

struct CurrencyImpact {
    let currency: String
    let expectedChange: String
    let changeColor: Color
    let strengthPercentage: Double
    let description: String
}

struct CorrelationData {
    let pair: String
    let value: Double
}

struct AIPrediction: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let confidence: Double
    let timeframe: String
}

struct HistoricalEvent: Identifiable {
    let id = UUID()
    let title: String
    let date: Date
    let marketMove: Double // Percentage
    let similarity: Double // 0-1 scale
}

enum AnalysisTimeframe: String, CaseIterable {
    case oneHour = "1H"
    case fourHours = "4H"
    case daily = "1D"
    
    var displayName: String {
        return self.rawValue
    }
}

enum RiskLevel: String, CaseIterable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    
    var displayName: String {
        return self.rawValue
    }
    
    var color: Color {
        switch self {
        case .low: return .green
        case .medium: return .orange
        case .high: return .red
        }
    }
}

// ... existing code up to RiskLevel ...


#Preview {
    MarketImpactAnalysisView(article: NewsArticleModel(
        title: "Fed Chair Powell Signals Potential Rate Pause Ahead",
        summary: "Federal Reserve Chairman Jerome Powell hints at a potential pause in interest rate hikes.",
        content: "Full article content...",
        impact: .high,
        publishedAt: Date().addingTimeInterval(-300),
        source: "Reuters",
        category: "Central Banking",
        tags: ["Fed", "Interest Rates"]
    ))
}