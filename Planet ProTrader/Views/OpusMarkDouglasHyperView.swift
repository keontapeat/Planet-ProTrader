//
//  OpusMarkDouglasHyperView.swift
//  Planet ProTrader
//
//  Created by Senior iOS Engineer on 1/25/25.
//

import SwiftUI

struct OpusMarkDouglasHyperView: View {
    @StateObject private var hyperEngine = OpusMarkDouglasHyperEngine()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header Section
                    headerSection
                    
                    // Performance Metrics
                    performanceMetricsSection
                    
                    // Psychology Status
                    psychologySection
                    
                    // Speed Controls
                    controlsSection
                    
                    // Insights
                    insightsSection
                }
                .padding()
            }
            .navigationTitle("Hyper Engine")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            if !hyperEngine.isActive {
                hyperEngine.activateMaximumSpeed()
            }
        }
        .onDisappear {
            hyperEngine.stopHyperMode()
        }
    }
    
    private var headerSection: some View {
        UltraPremiumCard {
            VStack(spacing: 16) {
                HStack {
                    Image(systemName: "bolt.fill")
                        .font(.system(size: 40))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.orange, .red],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("OPUS HYPER ENGINE")
                            .font(.title2.bold())
                            .foregroundColor(.primary)
                        
                        Text("Mark Douglas Psychology Integration")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("\(String(format: "%.1f", hyperEngine.speedMultiplier))x")
                            .font(.largeTitle.bold())
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.orange, .red],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                        
                        Text("SPEED MULTIPLIER")
                            .font(.caption2.bold())
                            .foregroundColor(.secondary)
                    }
                }
                
                // Status Indicator
                HStack {
                    Circle()
                        .fill(hyperEngine.isActive ? .green : .red)
                        .frame(width: 12, height: 12)
                        .scaleEffect(hyperEngine.isActive ? 1.2 : 1.0)
                        .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: hyperEngine.isActive)
                    
                    Text(hyperEngine.isActive ? "HYPER MODE ACTIVE" : "HYPER MODE INACTIVE")
                        .font(.headline.bold())
                        .foregroundColor(hyperEngine.isActive ? .green : .red)
                    
                    Spacer()
                }
            }
        }
    }
    
    private var performanceMetricsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("🚀 Performance Metrics")
                .font(.title2.bold())
                .foregroundColor(.primary)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                MetricCard(
                    title: "SwiftUI Mastery",
                    value: hyperEngine.performanceMetrics.swiftuiMastery,
                    color: .blue,
                    icon: "swift"
                )
                
                MetricCard(
                    title: "Algorithm Optimization",
                    value: hyperEngine.performanceMetrics.algorithmOptimization,
                    color: .purple,
                    icon: "gearshape.2.fill"
                )
                
                MetricCard(
                    title: "Performance Tuning",
                    value: hyperEngine.performanceMetrics.performanceTuning,
                    color: .green,
                    icon: "speedometer"
                )
                
                MetricCard(
                    title: "Total Optimizations",
                    value: Double(hyperEngine.performanceMetrics.totalOptimizations) / 1000.0,
                    color: .orange,
                    icon: "wrench.and.screwdriver.fill",
                    isCount: true
                )
            }
        }
    }
    
    private var psychologySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("🧠 Mark Douglas Psychology")
                .font(.title2.bold())
                .foregroundColor(.primary)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                MetricCard(
                    title: "Mark Douglas Alignment",
                    value: hyperEngine.performanceMetrics.markDouglasAlignment,
                    color: .purple,
                    icon: "brain.head.profile"
                )
                
                MetricCard(
                    title: "Probabilistic Thinking",
                    value: hyperEngine.performanceMetrics.probabilisticThinking,
                    color: .blue,
                    icon: "chart.bar.fill"
                )
                
                MetricCard(
                    title: "Unattached Execution",
                    value: hyperEngine.performanceMetrics.unattachedExecution,
                    color: .mint,
                    icon: "target"
                )
                
                MetricCard(
                    title: "Flow State Level",
                    value: hyperEngine.performanceMetrics.flowStateLevel,
                    color: .cyan,
                    icon: "water.waves"
                )
            }
        }
    }
    
    private var controlsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("⚡ Engine Controls")
                .font(.title2.bold())
                .foregroundColor(.primary)
            
            HStack(spacing: 16) {
                Button(action: {
                    if hyperEngine.isActive {
                        hyperEngine.stopHyperMode()
                    } else {
                        hyperEngine.activateMaximumSpeed()
                    }
                }) {
                    HStack {
                        Image(systemName: hyperEngine.isActive ? "stop.fill" : "play.fill")
                            .font(.title2)
                        
                        Text(hyperEngine.isActive ? "Stop Hyper Mode" : "Start Hyper Mode")
                            .font(.headline.bold())
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        LinearGradient(
                            colors: hyperEngine.isActive ? [.red, .orange] : [.green, .mint],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(color: (hyperEngine.isActive ? .red : .green).opacity(0.3), radius: 4)
                }
                .buttonStyle(.plain)
                
                Button(action: {
                    hyperEngine.optimizeBeliefSystem()
                }) {
                    HStack {
                        Image(systemName: "brain.fill")
                            .font(.title2)
                        
                        Text("Optimize Psychology")
                            .font(.headline.bold())
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        LinearGradient(
                            colors: [.purple, .pink],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(color: .purple.opacity(0.3), radius: 4)
                }
                .buttonStyle(.plain)
            }
        }
    }
    
    private var insightsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("💡 Psychology Insights")
                .font(.title2.bold())
                .foregroundColor(.primary)
            
            UltraPremiumCard {
                VStack(alignment: .leading, spacing: 12) {
                    let psychologyState = hyperEngine.applyTradingPsychology()
                    
                    Text(psychologyState.overallState)
                        .font(.headline.bold())
                        .foregroundColor(.primary)
                    
                    Text(psychologyState.recommendation)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                    
                    Divider()
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Mental Clarity")
                                .font(.caption.bold())
                                .foregroundColor(.secondary)
                            
                            Text("\(Int(psychologyState.clarity * 100))%")
                                .font(.title3.bold())
                                .foregroundColor(.purple)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Confidence")
                                .font(.caption.bold())
                                .foregroundColor(.secondary)
                            
                            Text("\(Int(psychologyState.confidence * 100))%")
                                .font(.title3.bold())
                                .foregroundColor(.blue)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Flow State")
                                .font(.caption.bold())
                                .foregroundColor(.secondary)
                            
                            Text("\(Int(psychologyState.flow * 100))%")
                                .font(.title3.bold())
                                .foregroundColor(.cyan)
                        }
                    }
                }
            }
        }
    }
}

struct MetricCard: View {
    let title: String
    let value: Double
    let color: Color
    let icon: String
    let isCount: Bool
    
    init(title: String, value: Double, color: Color, icon: String, isCount: Bool = false) {
        self.title = title
        self.value = value
        self.color = color
        self.icon = icon
        self.isCount = isCount
    }
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                
                Spacer()
                
                Text(formattedValue)
                    .font(.title2.bold())
                    .foregroundColor(color)
            }
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
            
            if !isCount {
                ProgressView(value: value)
                    .progressViewStyle(LinearProgressViewStyle(tint: color))
                    .scaleEffect(y: 2)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: color.opacity(0.2), radius: 4, x: 0, y: 2)
    }
    
    private var formattedValue: String {
        if isCount {
            return "\(Int(value * 1000))"
        } else {
            return "\(Int(value * 100))%"
        }
    }
}

#Preview {
    OpusMarkDouglasHyperView()
}