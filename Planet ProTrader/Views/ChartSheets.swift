//
//  ChartSheets.swift
//  Planet ProTrader
//
//  Created by AI Assistant
//

import SwiftUI

// MARK: - Indicator Selection View

struct IndicatorSelectionView: View {
    @Binding var settings: ChartSettings
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                Section("Technical Indicators") {
                    ForEach(TechnicalIndicator.allCases) { indicator in
                        HStack {
                            Circle()
                                .fill(indicator.color)
                                .frame(width: 12, height: 12)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(indicator.rawValue)
                                    .font(.headline)
                                
                                Text(indicator.displayName)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Toggle("", isOn: Binding(
                                get: { settings.selectedIndicators.contains(indicator) },
                                set: { isSelected in
                                    if isSelected {
                                        settings.selectedIndicators.insert(indicator)
                                    } else {
                                        settings.selectedIndicators.remove(indicator)
                                    }
                                }
                            ))
                            .toggleStyle(SwitchToggleStyle(tint: indicator.color))
                        }
                        .padding(.vertical, 4)
                    }
                }
                
                Section("Display Settings") {
                    HStack {
                        Text("Max Visible Candles")
                        Spacer()
                        Stepper(
                            "\(settings.maxVisibleCandles)",
                            value: $settings.maxVisibleCandles,
                            in: 50...200,
                            step: 25
                        )
                    }
                    
                    HStack {
                        Text("Candle Width")
                        Spacer()
                        Slider(
                            value: $settings.candleWidth,
                            in: 4...16,
                            step: 1
                        )
                        Text("\(Int(settings.candleWidth))px")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .frame(width: 30)
                    }
                }
            }
            .navigationTitle("Chart Indicators")
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

// MARK: - Chart Settings View

struct ChartSettingsView: View {
    @Binding var settings: ChartSettings
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Chart Appearance") {
                    Toggle("Show Grid", isOn: $settings.showGrid)
                    Toggle("Show Volume", isOn: $settings.showVolume)
                    Toggle("Show Order Lines", isOn: $settings.showOrderLines)
                    Toggle("Show Crosshair", isOn: $settings.showCrosshair)
                }
                
                Section("Auto-Trading Display") {
                    Toggle("Show Bot Signals", isOn: $settings.showBotSignals)
                }
                
                Section("Color Scheme") {
                    HStack {
                        Text("Background")
                        Spacer()
                        ColorPicker("", selection: .constant(Color.black))
                    }
                    
                    HStack {
                        Text("Bull Candles")
                        Spacer()
                        ColorPicker("", selection: .constant(Color.green))
                    }
                    
                    HStack {
                        Text("Bear Candles")
                        Spacer()
                        ColorPicker("", selection: .constant(Color.red))
                    }
                }
                
                Section("Performance") {
                    HStack {
                        Text("Optimize for")
                        Spacer()
                        Picker("Performance", selection: .constant("Balanced")) {
                            Text("Speed").tag("Speed")
                            Text("Balanced").tag("Balanced")
                            Text("Quality").tag("Quality")
                        }
                        .pickerStyle(.menu)
                    }
                }
            }
            .navigationTitle("Chart Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Reset") {
                        resetToDefaults()
                    }
                    .foregroundColor(.red)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(DesignSystem.primaryGold)
                }
            }
        }
    }
    
    private func resetToDefaults() {
        settings = ChartSettings()
    }
}

// MARK: - Chart Tools View

struct ChartToolsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTool: ChartTool = .none
    
    enum ChartTool: String, CaseIterable {
        case none = "None"
        case trendLine = "Trend Line"
        case horizontalLine = "Horizontal Line"
        case verticalLine = "Vertical Line"
        case rectangle = "Rectangle"
        case fibonacciRetracement = "Fibonacci Retracement"
        case fibonacciExtension = "Fibonacci Extension"
        case pitchfork = "Andrews Pitchfork"
        case gannFan = "Gann Fan"
        case ellipse = "Ellipse"
        case arrow = "Arrow"
        case text = "Text Label"
        
        var icon: String {
            switch self {
            case .none: return "hand.point.up"
            case .trendLine: return "line.diagonal"
            case .horizontalLine: return "minus"
            case .verticalLine: return "line.vertical"
            case .rectangle: return "rectangle"
            case .fibonacciRetracement: return "chart.line.downtrend.xyaxis"
            case .fibonacciExtension: return "chart.line.uptrend.xyaxis"
            case .pitchfork: return "tuningfork"
            case .gannFan: return "fan"
            case .ellipse: return "oval"
            case .arrow: return "arrow.right"
            case .text: return "textformat"
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Tool selection grid
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 16) {
                    ForEach(ChartTool.allCases, id: \.self) { tool in
                        toolButton(tool: tool)
                    }
                }
                .padding()
                
                if selectedTool != .none {
                    // Tool options
                    toolOptions
                        .transition(.opacity.combined(with: .scale))
                }
                
                Spacer()
                
                // Action buttons
                HStack(spacing: 16) {
                    Button("Clear All") {
                        // Clear all drawings
                        ToastManager.shared.showInfo("All drawings cleared")
                    }
                    .foregroundColor(.red)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.red, lineWidth: 1)
                    )
                    
                    Button("Save Template") {
                        // Save current tool setup
                        ToastManager.shared.showSuccess("Template saved")
                    }
                    .foregroundColor(DesignSystem.primaryGold)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(DesignSystem.primaryGold.opacity(0.1))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(DesignSystem.primaryGold, lineWidth: 1)
                            )
                    )
                }
                .padding(.bottom, 20)
            }
            .navigationTitle("Chart Tools")
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
    
    private func toolButton(tool: ChartTool) -> some View {
        Button(action: {
            withAnimation(.spring()) {
                selectedTool = selectedTool == tool ? .none : tool
            }
        }) {
            VStack(spacing: 8) {
                Image(systemName: tool.icon)
                    .font(.title2)
                    .foregroundColor(selectedTool == tool ? .white : DesignSystem.primaryGold)
                
                Text(tool.rawValue)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(selectedTool == tool ? .white : .primary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(selectedTool == tool ? DesignSystem.primaryGold : Color(.systemGray6))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(DesignSystem.primaryGold.opacity(selectedTool == tool ? 0 : 0.3), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(.plain)
    }
    
    private var toolOptions: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Tool Options")
                .font(.headline)
                .foregroundColor(.primary)
            
            HStack {
                Text("Color")
                Spacer()
                ColorPicker("", selection: .constant(DesignSystem.primaryGold))
            }
            
            HStack {
                Text("Line Width")
                Spacer()
                Stepper("2px", value: .constant(2), in: 1...5)
            }
            
            HStack {
                Text("Style")
                Spacer()
                Picker("Style", selection: .constant("Solid")) {
                    Text("Solid").tag("Solid")
                    Text("Dashed").tag("Dashed")
                    Text("Dotted").tag("Dotted")
                }
                .pickerStyle(.menu)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
        .padding(.horizontal)
    }
}

// MARK: - Market News View

struct MarketNewsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedFilter: NewsFilter = .all
    
    enum NewsFilter: String, CaseIterable {
        case all = "All"
        case highImpact = "High Impact"
        case mediumImpact = "Medium Impact"
        case lowImpact = "Low Impact"
        
        var color: Color {
            switch self {
            case .all: return .blue
            case .highImpact: return .red
            case .mediumImpact: return .orange
            case .lowImpact: return .green
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Filter tabs
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(NewsFilter.allCases, id: \.self) { filter in
                            filterButton(filter: filter)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 8)
                .background(Color(.systemGray6))
                
                // News list
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(sampleNews, id: \.id) { news in
                            NewsCard(news: news)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Market News")
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
    
    private func filterButton(filter: NewsFilter) -> some View {
        Button(action: {
            selectedFilter = filter
        }) {
            Text(filter.rawValue)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(selectedFilter == filter ? .white : filter.color)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    selectedFilter == filter 
                    ? filter.color 
                    : filter.color.opacity(0.1)
                )
                .cornerRadius(6)
        }
        .buttonStyle(.plain)
    }
    
    private var sampleNews: [MarketNews] {
        [
            MarketNews(
                id: UUID(),
                title: "Federal Reserve Interest Rate Decision",
                description: "FOMC meeting concludes with rate decision announcement expected at 2:00 PM EST",
                impact: .highImpact,
                currency: "USD",
                timestamp: Date().addingTimeInterval(1800),
                isUpcoming: true
            ),
            MarketNews(
                id: UUID(),
                title: "ECB President Lagarde Speech",
                description: "European Central Bank President Christine Lagarde to speak about monetary policy",
                impact: .mediumImpact,
                currency: "EUR",
                timestamp: Date().addingTimeInterval(-3600),
                isUpcoming: false
            ),
            MarketNews(
                id: UUID(),
                title: "US Non-Farm Payrolls",
                description: "Monthly employment report showing job creation and unemployment rate",
                impact: .highImpact,
                currency: "USD",
                timestamp: Date().addingTimeInterval(86400),
                isUpcoming: true
            )
        ]
    }
}

struct MarketNews: Identifiable {
    let id: UUID
    let title: String
    let description: String
    let impact: MarketNewsView.NewsFilter
    let currency: String
    let timestamp: Date
    let isUpcoming: Bool
}

struct NewsCard: View {
    let news: MarketNews
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                // Impact indicator
                HStack(spacing: 6) {
                    Circle()
                        .fill(news.impact.color)
                        .frame(width: 8, height: 8)
                    
                    Text(news.impact.rawValue.uppercased())
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(news.impact.color)
                }
                
                Spacer()
                
                // Currency
                Text(news.currency)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .fill(DesignSystem.primaryGold)
                    )
                
                // Time
                Text(news.isUpcoming ? "Upcoming" : "Past")
                    .font(.caption2)
                    .foregroundColor(news.isUpcoming ? .orange : .secondary)
            }
            
            Text(news.title)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            Text(news.description)
                .font(.body)
                .foregroundColor(.secondary)
                .lineLimit(3)
            
            HStack {
                Text(news.timestamp, style: .time)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                if news.isUpcoming {
                    Text("in \(timeUntil(news.timestamp))")
                        .font(.caption)
                        .foregroundColor(.orange)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(
                            RoundedRectangle(cornerRadius: 4)
                                .fill(.orange.opacity(0.1))
                        )
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(news.impact.color.opacity(0.3), lineWidth: 1)
                )
        )
    }
    
    private func timeUntil(_ date: Date) -> String {
        let interval = date.timeIntervalSinceNow
        
        if interval < 3600 {
            return "\(Int(interval / 60))m"
        } else if interval < 86400 {
            return "\(Int(interval / 3600))h"
        } else {
            return "\(Int(interval / 86400))d"
        }
    }
}

#Preview {
    IndicatorSelectionView(settings: .constant(ChartSettings()))
}