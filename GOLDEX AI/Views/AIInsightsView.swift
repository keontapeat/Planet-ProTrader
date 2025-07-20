//
//  AIInsightsView.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 7/13/25.
//

import SwiftUI

struct AIInsightsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var animateCards = false
    @State private var selectedInsightType: InsightType = .market
    @State private var refreshing = false
    
    // Sample insights data
    @State private var insights: [AIInsight] = [
        AIInsight(
            id: "1",
            type: InsightType.market,
            title: "Gold Price Momentum",
            description: "Strong bullish momentum detected in gold prices with RSI showing oversold conditions",
            confidence: 0.87,
            impact: ImpactLevel.high,
            timestamp: Date().addingTimeInterval(-300)
        ),
        AIInsight(
            id: "2",
            type: InsightType.performance,
            title: "Optimal Entry Point",
            description: "Current price level presents excellent entry opportunity based on historical patterns",
            confidence: 0.92,
            impact: ImpactLevel.high,
            timestamp: Date().addingTimeInterval(-600)
        ),
        AIInsight(
            id: "3",
            type: InsightType.risk,
            title: "Risk Management Alert",
            description: "Consider reducing position size due to increased market volatility",
            confidence: 0.78,
            impact: ImpactLevel.medium,
            timestamp: Date().addingTimeInterval(-900)
        )
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                DesignSystem.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header Section
                        headerSection
                        
                        // Insight Type Selection
                        insightTypeSelectionSection
                        
                        // AI Confidence Score
                        aiConfidenceSection
                        
                        // Insights List
                        insightsListSection
                        
                        // Market Sentiment
                        marketSentimentSection
                        
                        // Recommendations
                        recommendationsSection
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                }
                .refreshable {
                    await refreshInsights()
                }
            }
            .navigationTitle("AI Insights")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(DesignSystem.primaryGold)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Refresh") {
                        Task {
                            await refreshInsights()
                        }
                    }
                    .foregroundColor(DesignSystem.primaryGold)
                }
            })
            .onAppear {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2)) {
                    animateCards = true
                }
            }
        }
    }
    
    private var headerSection: some View {
        UltraPremiumCard {
            VStack(spacing: 16) {
                HStack {
                    Image(systemName: "brain.head.profile")
                        .font(.system(size: 40))
                        .foregroundColor(DesignSystem.primaryGold)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("AI Insights")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Text("Real-time AI analysis and market predictions")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                }
                
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Active Insights")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text("\(insights.count)")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .center, spacing: 4) {
                        Text("Avg Confidence")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text("\(Int(averageConfidence * 100))%")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.green)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Last Update")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text("2m ago")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                    }
                }
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.9)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: animateCards)
    }
    
    private var insightTypeSelectionSection: some View {
        UltraPremiumCard {
            VStack(alignment: .leading, spacing: 16) {
                Text("Insight Categories")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                HStack(spacing: 8) {
                    ForEach(InsightType.allCases, id: \.self) { type in
                        Button(action: {
                            selectedInsightType = type
                        }) {
                            HStack {
                                Image(systemName: type.icon)
                                    .font(.system(size: 12))
                                Text(type.rawValue.capitalized)
                                    .font(.system(size: 12, weight: .semibold))
                            }
                            .foregroundColor(selectedInsightType == type ? .white : DesignSystem.primaryGold)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(selectedInsightType == type ? DesignSystem.primaryGold : Color.clear)
                            .cornerRadius(6)
                            .overlay(
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(DesignSystem.primaryGold, lineWidth: 1)
                            )
                        }
                    }
                }
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.9)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1), value: animateCards)
    }
    
    private var aiConfidenceSection: some View {
        UltraPremiumCard {
            VStack(spacing: 16) {
                HStack {
                    Text("AI Confidence Score")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Text("\(Int(averageConfidence * 100))%")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(DesignSystem.primaryGold)
                }
                
                ProgressView(value: averageConfidence)
                    .progressViewStyle(LinearProgressViewStyle(tint: DesignSystem.primaryGold))
                    .scaleEffect(y: 2.0)
                
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Model Accuracy")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text("94.7%")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.green)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Data Points")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text("1,247")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.blue)
                    }
                }
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.9)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2), value: animateCards)
    }
    
    private var insightsListSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent Insights")
                .font(.headline)
                .foregroundColor(.primary)
            
            LazyVStack(spacing: 12) {
                ForEach(filteredInsights) { insight in
                    AIInsightCard(insight: insight)
                }
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.9)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3), value: animateCards)
    }
    
    private var marketSentimentSection: some View {
        UltraPremiumCard {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("Market Sentiment")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Text("BULLISH")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(4)
                }
                
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Bulls")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text("68%")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.green)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .center, spacing: 4) {
                        Text("Neutral")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text("18%")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.orange)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Bears")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text("14%")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.red)
                    }
                }
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.9)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.4), value: animateCards)
    }
    
    private var recommendationsSection: some View {
        UltraPremiumCard {
            VStack(alignment: .leading, spacing: 16) {
                Text("AI Recommendations")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                VStack(spacing: 12) {
                    RecommendationRow(
                        title: "Increase Position Size",
                        description: "Market conditions favor larger positions",
                        confidence: 0.89,
                        priority: ImpactLevel.high
                    )
                    
                    RecommendationRow(
                        title: "Set Stop Loss at 2,650",
                        description: "Protect against downside risk",
                        confidence: 0.95,
                        priority: ImpactLevel.high
                    )
                    
                    RecommendationRow(
                        title: "Monitor USD Index",
                        description: "Key correlation indicator",
                        confidence: 0.72,
                        priority: ImpactLevel.medium
                    )
                }
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.9)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.5), value: animateCards)
    }
    
    private var filteredInsights: [AIInsight] {
        insights.filter { insight in
            selectedInsightType == .all || insight.type == selectedInsightType
        }
    }
    
    private var averageConfidence: Double {
        guard !insights.isEmpty else { return 0.0 }
        return insights.reduce(0.0) { $0 + $1.confidence } / Double(insights.count)
    }
    
    private func refreshInsights() async {
        refreshing = true
        
        // Simulate API call
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        refreshing = false
    }
}

// MARK: - Supporting Views

struct AIInsightCard: View {
    let insight: AIInsight
    
    var body: some View {
        UltraPremiumCard {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: insight.type.icon)
                        .font(.system(size: 16))
                        .foregroundColor(insight.type.color)
                    
                    Text(insight.title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Text("\(Int(insight.confidence * 100))%")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(DesignSystem.primaryGold)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(DesignSystem.primaryGold.opacity(0.1))
                        .cornerRadius(4)
                }
                
                Text(insight.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
                
                HStack {
                    Text(insight.impact.rawValue.uppercased())
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(insight.impact.color)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(insight.impact.color.opacity(0.1))
                        .cornerRadius(4)
                    
                    Spacer()
                    
                    Text(insight.timestamp.formatted(date: .omitted, time: .shortened))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}

struct RecommendationRow: View {
    let title: String
    let description: String
    let confidence: Double
    let priority: ImpactLevel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(Int(confidence * 100))%")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(DesignSystem.primaryGold)
                
                Text(priority.rawValue.uppercased())
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(priority.color)
            }
        }
    }
}

// MARK: - Data Models

struct AIInsight: Identifiable {
    let id: String
    let type: InsightType
    let title: String
    let description: String
    let confidence: Double
    let impact: ImpactLevel
    let timestamp: Date
}

enum InsightType: String, CaseIterable {
    case all = "all"
    case market = "market"
    case risk = "risk"
    case performance = "performance"
    
    var icon: String {
        switch self {
        case .all: return "rectangle.grid.2x2"
        case .market: return "chart.line.uptrend.xyaxis"
        case .risk: return "exclamationmark.triangle"
        case .performance: return "speedometer"
        }
    }
    
    var color: Color {
        switch self {
        case .all: return .primary
        case .market: return .blue
        case .risk: return .red
        case .performance: return .orange
        }
    }
}

enum ImpactLevel: String, CaseIterable {
    case low = "low"
    case medium = "medium"
    case high = "high"
    case critical = "critical"
    
    var color: Color {
        switch self {
        case .low: return .gray
        case .medium: return .orange
        case .high: return .red
        case .critical: return .purple
        }
    }
    
    var priority: Int {
        switch self {
        case .low: return 1
        case .medium: return 2
        case .high: return 3
        case .critical: return 4
        }
    }
}

// MARK: - Preview Provider

#Preview {
    AIInsightsView()
        .preferredColorScheme(.light)
}