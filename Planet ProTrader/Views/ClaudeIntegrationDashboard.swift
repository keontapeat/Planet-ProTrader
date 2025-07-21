//
//  ClaudeIntegrationDashboard.swift
//  Planet ProTrader
//
//  Created by AI Assistant on 1/25/25.
//

import SwiftUI

struct ClaudeIntegrationDashboard: View {
    @StateObject private var opusService = OpusAutodebugService()
    @State private var selectedTab = 0
    @State private var showingFullInterface = false
    
    private let tabs = ["Overview", "Analysis", "Optimization", "Trading AI"]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    claudeHeaderView
                    
                    // Tab Picker
                    claudeTabPicker
                    
                    // Tab Content
                    Group {
                        switch selectedTab {
                        case 0: overviewContent
                        case 1: analysisContent
                        case 2: optimizationContent
                        case 3: tradingAIContent
                        default: overviewContent
                        }
                    }
                    
                    // Action Buttons
                    actionButtonsView
                    
                    Spacer(minLength: 100)
                }
                .padding()
            }
            .navigationTitle("Claude AI Integration")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showingFullInterface) {
                OpusDebugInterface()
            }
        }
    }
    
    private var claudeHeaderView: some View {
        UltraPremiumCard {
            VStack(spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Image(systemName: "brain.head.profile.fill")
                                .font(.title)
                                .foregroundColor(DesignSystem.primaryGold)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Claude AI")
                                    .font(.title2.bold())
                                    .foregroundColor(.primary)
                                
                                Text("Opus-3 Integration")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        HStack {
                            Circle()
                                .fill(opusService.isActive ? .green : .orange)
                                .frame(width: 8, height: 8)
                            
                            Text(opusService.isActive ? "Active" : "Initializing")
                                .font(.caption)
                                .foregroundColor(opusService.isActive ? .green : .orange)
                        }
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Performance")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text("+\(Int(opusService.performanceGains))%")
                            .font(.title2.bold())
                            .foregroundColor(.green)
                    }
                }
                
                Divider()
                
                HStack {
                    statItem("Fixes Applied", value: "\(opusService.errorsFixed)", color: .blue)
                    statItem("Speed Boost", value: "\(String(format: "%.1fx", opusService.debuggingSpeed + 1))", color: .orange)
                    statItem("AI Status", value: "Optimal", color: .green)
                }
            }
        }
    }
    
    private var claudeTabPicker: some View {
        HStack(spacing: 0) {
            ForEach(Array(tabs.enumerated()), id: \.offset) { index, tab in
                Button(action: {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        selectedTab = index
                    }
                }) {
                    Text(tab)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(selectedTab == index ? .white : .primary)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(selectedTab == index ? DesignSystem.primaryGold : Color.clear)
                        )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(4)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color(.tertiarySystemGroupedBackground))
        )
    }
    
    private var overviewContent: some View {
        VStack(spacing: 16) {
            UltraPremiumCard {
                VStack(alignment: .leading, spacing: 12) {
                    Text("AI Capabilities")
                        .font(.headline.bold())
                        .foregroundColor(.primary)
                    
                    capabilityRow("Real-time Code Analysis", "Opus continuously scans and optimizes code", "checkmark.circle.fill", .green)
                    capabilityRow("Performance Enhancement", "Automatic speed optimizations and memory management", "speedometer", .blue)
                    capabilityRow("Trading Intelligence", "AI-powered trading strategies and risk management", "brain.head.profile", .purple)
                    capabilityRow("Error Prevention", "Proactive bug detection and instant fixes", "shield.checkered", .orange)
                }
            }
            
            UltraPremiumCard {
                VStack(alignment: .leading, spacing: 12) {
                    Text("System Metrics")
                        .font(.headline.bold())
                        .foregroundColor(.primary)
                    
                    HStack {
                        metricCard("CPU Usage", "12%", .green)
                        metricCard("Memory", "480MB", .blue)
                        metricCard("Network", "Fast", .orange)
                    }
                }
            }
        }
    }
    
    private var analysisContent: some View {
        VStack(spacing: 16) {
            UltraPremiumCard {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Code Analysis")
                        .font(.headline.bold())
                        .foregroundColor(.primary)
                    
                    analysisRow("SwiftUI Performance", "Optimal", .green, "95%")
                    analysisRow("Memory Management", "Excellent", .green, "98%")
                    analysisRow("Network Efficiency", "Good", .orange, "87%")
                    analysisRow("Threading", "Perfect", .green, "100%")
                    analysisRow("Architecture", "Clean", .blue, "92%")
                }
            }
            
            UltraPremiumCard {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Recent Analysis")
                        .font(.headline.bold())
                        .foregroundColor(.primary)
                    
                    ForEach(opusService.recentFixes.prefix(3), id: \.id) { fix in
                        analysisItemRow(fix)
                    }
                }
            }
        }
    }
    
    private var optimizationContent: some View {
        VStack(spacing: 16) {
            UltraPremiumCard {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Optimization Queue")
                        .font(.headline.bold())
                        .foregroundColor(.primary)
                    
                    optimizationRow("View Rendering", "In Progress", 67, .blue)
                    optimizationRow("Database Queries", "Completed", 100, .green)
                    optimizationRow("Animation Performance", "Queued", 0, .orange)
                    optimizationRow("Memory Allocation", "In Progress", 45, .purple)
                }
            }
            
            UltraPremiumCard {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Performance Gains")
                        .font(.headline.bold())
                        .foregroundColor(.primary)
                    
                    HStack {
                        performanceGainCard("App Launch", "+45%", .green)
                        performanceGainCard("UI Response", "+67%", .blue)
                        performanceGainCard("Data Load", "+89%", .orange)
                    }
                }
            }
        }
    }
    
    private var tradingAIContent: some View {
        VStack(spacing: 16) {
            UltraPremiumCard {
                VStack(alignment: .leading, spacing: 12) {
                    Text("AI Trading Systems")
                        .font(.headline.bold())
                        .foregroundColor(.primary)
                    
                    tradingSystemRow("Alpha Trader", "Active", 94.5, .green)
                    tradingSystemRow("Risk Manager", "Active", 98.2, .blue)
                    tradingSystemRow("Pattern Detector", "Learning", 87.3, .orange)
                    tradingSystemRow("Sentiment Analyzer", "Active", 91.8, .purple)
                }
            }
            
            UltraPremiumCard {
                VStack(alignment: .leading, spacing: 12) {
                    Text("AI Insights")
                        .font(.headline.bold())
                        .foregroundColor(.primary)
                    
                    insightRow("Market Trend", "Strong bullish momentum detected", "chart.line.uptrend.xyaxis", .green)
                    insightRow("Risk Level", "Low risk environment", "shield.checkered", .blue)
                    insightRow("Opportunity", "Gold breakout pattern forming", "target", .orange)
                }
            }
        }
    }
    
    private var actionButtonsView: some View {
        VStack(spacing: 12) {
            Button(action: {
                if !opusService.isActive {
                    opusService.unleashOpusPower()
                }
                showingFullInterface = true
            }) {
                HStack {
                    Image(systemName: "bolt.fill")
                        .font(.title2)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Launch Full Interface")
                            .font(.headline.bold())
                        
                        Text("Advanced AI controls and monitoring")
                            .font(.caption)
                            .opacity(0.8)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.title3)
                }
                .foregroundColor(.white)
                .padding()
                .background(DesignSystem.goldGradient)
                .cornerRadius(12)
            }
        }
    }
    
    // MARK: - Helper Views
    
    private func statItem(_ title: String, value: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.headline.bold())
                .foregroundColor(color)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }
    
    private func capabilityRow(_ title: String, _ description: String, _ icon: String, _ color: Color) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline.bold())
                    .foregroundColor(.primary)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
    
    private func metricCard(_ title: String, _ value: String, _ color: Color) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.headline.bold())
                .foregroundColor(color)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(8)
    }
    
    private func analysisRow(_ item: String, _ status: String, _ color: Color, _ score: String) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(item)
                    .font(.subheadline.bold())
                
                Text(status)
                    .font(.caption)
                    .foregroundColor(color)
            }
            
            Spacer()
            
            Text(score)
                .font(.subheadline.bold())
                .foregroundColor(color)
        }
        .padding(.vertical, 4)
    }
    
    private func analysisItemRow(_ fix: OpusAutodebugService.OpusFix) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(fix.file)
                    .font(.caption.bold())
                    .foregroundColor(.primary)
                
                Text(fix.improvement)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            Spacer()
            
            Text("+\(Int(fix.speedGain))%")
                .font(.caption.bold())
                .foregroundColor(.green)
        }
        .padding(.vertical, 2)
    }
    
    private func optimizationRow(_ task: String, _ status: String, _ progress: Int, _ color: Color) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(task)
                    .font(.subheadline.bold())
                
                Spacer()
                
                Text(status)
                    .font(.caption)
                    .foregroundColor(color)
            }
            
            ProgressView(value: Double(progress), total: 100)
                .progressViewStyle(LinearProgressViewStyle(tint: color))
        }
        .padding(.vertical, 4)
    }
    
    private func performanceGainCard(_ title: String, _ gain: String, _ color: Color) -> some View {
        VStack(spacing: 4) {
            Text(gain)
                .font(.title2.bold())
                .foregroundColor(color)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(8)
    }
    
    private func tradingSystemRow(_ name: String, _ status: String, _ performance: Double, _ color: Color) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .font(.subheadline.bold())
                
                Text(status)
                    .font(.caption)
                    .foregroundColor(color)
            }
            
            Spacer()
            
            Text("\(String(format: "%.1f", performance))%")
                .font(.subheadline.bold())
                .foregroundColor(color)
        }
        .padding(.vertical, 4)
    }
    
    private func insightRow(_ category: String, _ insight: String, _ icon: String, _ color: Color) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(category)
                    .font(.caption.bold())
                    .foregroundColor(color)
                
                Text(insight)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .lineLimit(2)
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    ClaudeIntegrationDashboard()
}