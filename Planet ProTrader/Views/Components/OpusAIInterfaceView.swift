//
//  OpusAIInterfaceView.swift
//  Planet ProTrader
//
//  ✅ OPUS AI INTERFACE - Advanced AI assistant interface
//

import SwiftUI

struct OpusAIInterfaceView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var opusService = OpusAutodebugService()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Header
                    headerSection
                    
                    // Status metrics
                    statusMetrics
                    
                    // Debug console
                    debugConsole
                    
                    // AI insights
                    aiInsights
                    
                    Spacer()
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("OPUS AI")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
    
    private var headerSection: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(DesignSystem.goldGradient)
                    .frame(width: 60, height: 60)
                
                Image(systemName: "brain.head.profile")
                    .font(.title)
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("OPUS AI Assistant")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Advanced Trading Intelligence")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                HStack(spacing: 4) {
                    Circle()
                        .fill(.green)
                        .frame(width: 8, height: 8)
                    
                    Text("Online")
                        .font(.caption)
                        .foregroundColor(.green)
                }
            }
            
            Spacer()
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
    
    private var statusMetrics: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
            StatusMetric(title: "System Health", value: String(format: "%.1f%%", opusService.systemHealth * 100), color: .green)
            StatusMetric(title: "Active Processes", value: "\(opusService.processesRunning)", color: DesignSystem.primaryGold)
            StatusMetric(title: "Accuracy", value: String(format: "%.1f%%", opusService.accuracy), color: .blue)
            StatusMetric(title: "Uptime", value: String(format: "%.1f%%", opusService.uptime), color: .purple)
        }
    }
    
    private var debugConsole: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Debug Console")
                .font(.headline)
                .fontWeight(.semibold)
            
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 4) {
                    ForEach(opusService.debugLogs.reversed().indices, id: \.self) { index in
                        let log = opusService.debugLogs.reversed()[index]
                        HStack(alignment: .top, spacing: 8) {
                            Text(">")
                                .font(.system(.caption, design: .monospaced))
                                .foregroundColor(.green)
                            
                            Text(log)
                                .font(.system(.caption, design: .monospaced))
                                .foregroundColor(.primary)
                            
                            Spacer()
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(height: 200)
            .padding()
            .background(Color.black)
            .cornerRadius(12)
        }
    }
    
    private var aiInsights: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("AI Insights")
                .font(.headline)
                .fontWeight(.semibold)
            
            VStack(spacing: 12) {
                InsightCard(
                    icon: "chart.line.uptrend.xyaxis",
                    title: "Market Analysis",
                    subtitle: "Bullish momentum detected on XAUUSD",
                    color: .green
                )
                
                InsightCard(
                    icon: "brain.head.profile",
                    title: "Bot Optimization",
                    subtitle: "3 bots ready for parameter tuning",
                    color: .blue
                )
                
                InsightCard(
                    icon: "shield.checkerboard",
                    title: "Risk Management",
                    subtitle: "Portfolio risk within optimal range",
                    color: .orange
                )
            }
        }
    }
}

struct StatusMetric: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
}

struct InsightCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 40, height: 40)
                .background(color.opacity(0.2))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    OpusAIInterfaceView()
}