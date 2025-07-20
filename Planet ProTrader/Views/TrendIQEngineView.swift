//
//  TrendIQEngineView.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 7/13/25.
//

import SwiftUI

struct TrendIQEngineView: View {
    @StateObject private var trendEngine = TrendIQEngine()
    @State private var selectedTimeframe: String = "H1"
    @State private var showingDetailedAnalysis = false
    @State private var showingSettings = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header with Score
                    TrendScoreHeaderView(
                        score: trendEngine.trendScore,
                        direction: trendEngine.trendDirection,
                        strength: trendEngine.trendStrength,
                        isAnalyzing: trendEngine.isAnalyzing
                    )
                    
                    // Quick Stats Cards
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        TrendQuickStatCard(
                            title: "Trend Quality",
                            value: trendEngine.trendQuality.rawValue,
                            color: trendEngine.trendQuality.color,
                            subtitle: trendEngine.trendQuality.tradingAdvice
                        )
                        
                        TrendQuickStatCard(
                            title: "Smart Money",
                            value: trendEngine.smartMoneyFlow.rawValue,
                            color: trendEngine.smartMoneyFlow.color,
                            subtitle: "Institutional flow"
                        )
                        
                        TrendQuickStatCard(
                            title: "Trend Phase",
                            value: trendEngine.trendPhase.rawValue,
                            color: trendEngine.trendPhase.color,
                            subtitle: trendEngine.trendPhase.description
                        )
                        
                        TrendQuickStatCard(
                            title: "Confidence",
                            value: "\(Int(trendEngine.confidenceLevel * 100))%",
                            color: trendEngine.confidenceLevel > 0.7 ? .green : trendEngine.confidenceLevel > 0.5 ? .orange : .red,
                            subtitle: "Analysis confidence"
                        )
                    }
                    
                    // Trading Recommendation
                    TradingRecommendationCard(
                        recommendation: trendEngine.tradingRecommendation,
                        riskAssessment: trendEngine.riskAssessment,
                        shouldTrade: trendEngine.shouldTrade
                    )
                    
                    // Multi-Timeframe Analysis
                    MultiTimeframeAnalysisView(
                        analysis: trendEngine.multiTimeframeAnalysis,
                        selectedTimeframe: $selectedTimeframe
                    )
                    
                    // Structure Analysis
                    StructureAnalysisView(
                        structure: trendEngine.structureAnalysis
                    )
                    
                    // Volume Profile
                    VolumeProfileView(
                        volumeProfile: trendEngine.volumeProfile
                    )
                    
                    // Market Structure
                    MarketStructureView(
                        marketStructure: trendEngine.marketStructure
                    )
                    
                    Spacer(minLength: 100)
                }
                .padding()
            }
            .navigationTitle("Trend IQ Engine™")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Button("Refresh") {
                            Task {
                                await trendEngine.refreshAnalysis()
                            }
                        }
                        .disabled(trendEngine.isAnalyzing)
                        
                        Button("Details") {
                            showingDetailedAnalysis = true
                        }
                        
                        Button("Settings") {
                            showingSettings = true
                        }
                    }
                }
            }
            .sheet(isPresented: $showingDetailedAnalysis) {
                DetailedTrendAnalysisView(trendEngine: trendEngine)
            }
            .sheet(isPresented: $showingSettings) {
                TrendIQSettingsView(trendEngine: trendEngine)
            }
        }
    }
}

// MARK: - Supporting Views

struct TrendScoreHeaderView: View {
    let score: Double
    let direction: TrendIQEngine.TrendDirection
    let strength: TrendIQEngine.TrendStrength
    let isAnalyzing: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Trend Score")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    HStack {
                        Text("\(Int(score))")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(direction.color)
                        
                        Text("/ 100")
                            .font(.title3)
                            .foregroundStyle(.secondary)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    HStack {
                        Image(systemName: direction.icon)
                            .foregroundStyle(direction.color)
                        Text(direction.rawValue)
                            .font(.headline)
                            .foregroundStyle(direction.color)
                    }
                    
                    Text(strength.rawValue)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            
            // Progress Bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(.gray.opacity(0.3))
                        .frame(height: 8)
                    
                    Rectangle()
                        .fill(direction.color.gradient)
                        .frame(width: geometry.size.width * (score / 100), height: 8)
                        .animation(.easeInOut(duration: 0.5), value: score)
                }
                .clipShape(RoundedRectangle(cornerRadius: 4))
            }
            .frame(height: 8)
            
            if isAnalyzing {
                HStack {
                    ProgressView()
                        .scaleEffect(0.8)
                    Text("Analyzing trends...")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
}

struct TrendQuickStatCard: View {
    let title: String
    let value: String
    let color: Color
    let subtitle: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Text(value)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundStyle(color)
            
            Text(subtitle)
                .font(.caption2)
                .foregroundStyle(.secondary)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
}

struct TradingRecommendationCard: View {
    let recommendation: String
    let riskAssessment: String
    let shouldTrade: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: shouldTrade ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .foregroundStyle(shouldTrade ? .green : .red)
                Text("Trading Recommendation")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
            }
            
            Text(recommendation)
                .font(.subheadline)
                .fontWeight(.medium)
                .padding(.bottom, 4)
            
            Text(riskAssessment)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
}

struct MultiTimeframeAnalysisView: View {
    let analysis: TrendIQEngine.MultiTimeframeAnalysis
    @Binding var selectedTimeframe: String
    
    let timeframes = [
        ("M1", "1m"),
        ("M5", "5m"),
        ("M15", "15m"),
        ("H1", "1h"),
        ("H4", "4h"),
        ("D1", "1d"),
        ("W1", "1w"),
        ("MN", "1mo")
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .foregroundStyle(.blue)
                Text("Multi-Timeframe Analysis")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
                Text("\(Int(analysis.overallAlignment * 100))% Aligned")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 8) {
                ForEach(timeframes, id: \.0) { timeframe in
                    TimeframeCell(
                        timeframe: timeframe.0,
                        analysis: getTimeframeAnalysis(for: timeframe.0),
                        isSelected: selectedTimeframe == timeframe.0
                    ) {
                        selectedTimeframe = timeframe.0
                    }
                }
            }
            
            if !analysis.conflictingTimeframes.isEmpty {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundStyle(.orange)
                    Text("Conflicting: \(analysis.conflictingTimeframes.joined(separator: ", "))")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
    
    private func getTimeframeAnalysis(for timeframe: String) -> TrendIQEngine.MultiTimeframeAnalysis.TimeframeAnalysis {
        switch timeframe {
        case "M1": return analysis.m1
        case "M5": return analysis.m5
        case "M15": return analysis.m15
        case "H1": return analysis.h1
        case "H4": return analysis.h4
        case "D1": return analysis.daily
        case "W1": return analysis.weekly
        case "MN": return analysis.monthly
        default: return analysis.h1
        }
    }
}

struct TimeframeCell: View {
    let timeframe: String
    let analysis: TrendIQEngine.MultiTimeframeAnalysis.TimeframeAnalysis
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text(timeframe)
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundStyle(isSelected ? .white : .primary)
                
                Circle()
                    .fill(analysis.trend.color)
                    .frame(width: 12, height: 12)
                
                Text("\(Int(analysis.strength))")
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundStyle(isSelected ? .white : .secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? AnyShapeStyle(.blue.gradient) : AnyShapeStyle(.gray.opacity(0.1)))
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct StructureAnalysisView: View {
    let structure: TrendIQEngine.StructureAnalysis
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "chart.xyaxis.line")
                    .foregroundStyle(.purple)
                Text("Structure Analysis")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
            }
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                StructureIndicator(
                    title: "Higher Highs",
                    isActive: structure.higherHighs,
                    color: .green
                )
                
                StructureIndicator(
                    title: "Higher Lows",
                    isActive: structure.higherLows,
                    color: .green
                )
                
                StructureIndicator(
                    title: "Lower Highs",
                    isActive: structure.lowerHighs,
                    color: .red
                )
                
                StructureIndicator(
                    title: "Lower Lows",
                    isActive: structure.lowerLows,
                    color: .red
                )
            }
            
            if !structure.structureBreaks.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Recent Structure Breaks")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    ForEach(structure.structureBreaks.prefix(3).indices, id: \.self) { index in
                        let structureBreak = structure.structureBreaks[index]
                        HStack {
                            Image(systemName: structureBreak.direction.icon)
                                .foregroundStyle(structureBreak.direction.color)
                            Text("\(structureBreak.price, specifier: "%.2f")")
                                .font(.caption)
                                .fontWeight(.medium)
                            Spacer()
                            Text("Strength: \(Int(structureBreak.strength * 100))%")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
}

struct StructureIndicator: View {
    let title: String
    let isActive: Bool
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: isActive ? "checkmark.circle.fill" : "circle")
                .foregroundStyle(isActive ? color : .gray)
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(isActive ? .primary : .secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 4)
    }
}

struct VolumeProfileView: View {
    let volumeProfile: TrendIQEngine.VolumeProfile
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "chart.bar.fill")
                    .foregroundStyle(.orange)
                Text("Volume Profile")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
                Text("Ratio: \(volumeProfile.volumeRatio, specifier: "%.2f")")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Buy Volume")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("\(Int(volumeProfile.buyVolume))")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.green)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Sell Volume")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("\(Int(volumeProfile.sellVolume))")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.red)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Trend")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(volumeProfile.volumeTrend == .increasing ? "↗️ Rising" : 
                         volumeProfile.volumeTrend == .decreasing ? "↘️ Falling" : "➡️ Neutral")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
            }
            
            // Volume visualization
            GeometryReader { geometry in
                HStack(spacing: 2) {
                    Rectangle()
                        .fill(.green.gradient)
                        .frame(width: geometry.size.width * (volumeProfile.buyVolume / volumeProfile.totalVolume))
                    
                    Rectangle()
                        .fill(.red.gradient)
                        .frame(width: geometry.size.width * (volumeProfile.sellVolume / volumeProfile.totalVolume))
                }
                .frame(height: 20)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .frame(height: 20)
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
}

struct MarketStructureView: View {
    let marketStructure: TrendIQEngine.MarketStructure
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "building.columns")
                    .foregroundStyle(.indigo)
                Text("Market Structure")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
            }
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                TrendPillView(
                    title: "Primary",
                    trend: marketStructure.primaryTrend
                )
                
                TrendPillView(
                    title: "Intermediate",
                    trend: marketStructure.intermediaryTrend
                )
                
                TrendPillView(
                    title: "Minor",
                    trend: marketStructure.minorTrend
                )
            }
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Alignment")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("\(Int(marketStructure.trendAlignment * 100))%")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Maturity")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(marketStructure.trendMaturity == .young ? "Young" :
                         marketStructure.trendMaturity == .developing ? "Developing" :
                         marketStructure.trendMaturity == .mature ? "Mature" :
                         marketStructure.trendMaturity == .aging ? "Aging" : "Exhausted")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
}

struct TrendPillView: View {
    let title: String
    let trend: TrendIQEngine.TrendDirection
    
    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.caption2)
                .foregroundStyle(.secondary)
            
            HStack {
                Image(systemName: trend.icon)
                    .font(.caption)
                Text(trend.rawValue)
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .foregroundStyle(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(trend.color.gradient, in: RoundedRectangle(cornerRadius: 8))
        }
    }
}

struct DetailedTrendAnalysisView: View {
    let trendEngine: TrendIQEngine
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Detailed Analysis")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    
                    // Add detailed analysis content here
                    
                    Spacer()
                }
                .padding()
            }
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

struct TrendIQSettingsView: View {
    let trendEngine: TrendIQEngine
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List {
                Section("Analysis Settings") {
                    Text("Settings content coming soon...")
                }
            }
            .navigationTitle("Trend IQ Settings")
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

#Preview("Trend IQ Engine") {
    TrendIQEngineView()
}

#Preview("Trend IQ Engine Light") {
    TrendIQEngineView()
        .preferredColorScheme(.light)
}