//
//  AutoDebugDashboardView.swift
//  GOLDEX AI
//
//  Elite Auto Debug Dashboard - God Mode Visualization
//  Created by Keonta on 7/13/25.
//

import SwiftUI
import Charts

@MainActor
struct AutoDebugDashboardView: View {
    @StateObject private var autoDebugSystem = AutoDebugSystem.shared
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTab = 0
    @State private var showingDetailView = false
    @State private var selectedError: ErrorLogModel?
    @State private var animateCharts = false
    
    var body: some View {
        NavigationView {
            ZStack {
                DesignSystem.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    LazyVStack(spacing: 24) {
                        // Elite Status Header
                        EliteStatusHeaderView()
                            .environmentObject(autoDebugSystem)
                        
                        // Quick Actions
                        QuickActionsView()
                            .environmentObject(autoDebugSystem)
                        
                        // System Health Overview
                        SystemHealthOverviewView(animateCharts: $animateCharts)
                            .environmentObject(autoDebugSystem)
                        
                        // Real-time Metrics
                        RealTimeMetricsView()
                            .environmentObject(autoDebugSystem)
                        
                        // ML Predictions
                        MLPredictionsView()
                            .environmentObject(autoDebugSystem)
                        
                        // Recent Debug Sessions
                        RecentDebugSessionsView(selectedError: $selectedError, showingDetailView: $showingDetailView)
                            .environmentObject(autoDebugSystem)
                        
                        // Apple Docs Integration Status
                        AppleDocsIntegrationView()
                            .environmentObject(autoDebugSystem)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    .padding(.bottom, 100)
                }
            }
            .navigationTitle("Elite Auto Debug")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundStyle(DesignSystem.primaryGold)
                    .fontWeight(.semibold)
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0).delay(0.5)) {
                animateCharts = true
            }
        }
        .sheet(isPresented: $showingDetailView) {
            if let error = selectedError {
                ErrorDetailView(error: error)
            }
        }
    }
}

// MARK: - Elite Status Header
struct EliteStatusHeaderView: View {
    @EnvironmentObject private var autoDebugSystem: AutoDebugSystem
    @State private var pulseAnimation = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Main Status Indicator
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    DesignSystem.primaryGold.opacity(0.3),
                                    DesignSystem.primaryGold.opacity(0.1),
                                    Color.clear
                                ],
                                center: .center,
                                startRadius: 10,
                                endRadius: 40
                            )
                        )
                        .frame(width: 80, height: 80)
                        .scaleEffect(pulseAnimation ? 1.2 : 1.0)
                        .opacity(autoDebugSystem.isActive ? 1.0 : 0.5)
                        .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: pulseAnimation)
                    
                    Circle()
                        .stroke(DesignSystem.primaryGold, lineWidth: 3)
                        .frame(width: 60, height: 60)
                        .opacity(autoDebugSystem.isActive ? 1.0 : 0.3)
                    
                    Image(systemName: "brain.head.profile")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundStyle(autoDebugSystem.isActive ? DesignSystem.primaryGold : .secondary)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Elite AI Debug System")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)
                    
                    Text(autoDebugSystem.isActive ? "ONLINE - God Mode Active" : "OFFLINE")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(autoDebugSystem.isActive ? .green : .red)
                    
                    HStack(spacing: 12) {
                        Label("Health: \(String(format: "%.1f%%", autoDebugSystem.systemHealthScore * 100))", systemImage: "heart.fill")
                            .font(.caption)
                            .foregroundStyle(healthColor)
                        
                        Label("Auto-Fix: \(String(format: "%.1f%%", autoDebugSystem.autoFixSuccessRate * 100))", systemImage: "wrench.adjustable.fill")
                            .font(.caption)
                            .foregroundStyle(.green)
                    }
                }
                
                Spacer()
            }
            
            // Status Cards
            HStack(spacing: 16) {
                StatusCard(
                    title: "Active Errors",
                    value: "\(autoDebugSystem.errorCount)",
                    icon: "exclamationmark.triangle.fill",
                    color: autoDebugSystem.errorCount > 0 ? .red : .green
                )
                
                StatusCard(
                    title: "Warnings",
                    value: "\(autoDebugSystem.warningCount)",
                    icon: "exclamationmark.circle.fill",
                    color: .orange
                )
                
                StatusCard(
                    title: "Learned Patterns",
                    value: "\(autoDebugSystem.learnedPatterns.count)",
                    icon: "brain.head.profile",
                    color: DesignSystem.primaryGold
                )
            }
        }
        .padding(24)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: DesignSystem.cardShadow, radius: 12, x: 0, y: 6)
        .onAppear {
            pulseAnimation = true
        }
    }
    
    private var healthColor: Color {
        let score = autoDebugSystem.systemHealthScore
        if score >= 0.9 { return .green }
        else if score >= 0.7 { return .orange }
        else { return .red }
    }
}

// MARK: - Quick Actions
struct QuickActionsView: View {
    @EnvironmentObject private var autoDebugSystem: AutoDebugSystem
    @State private var isRunningHealthCheck = false
    @State private var isFixingErrors = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Quick Actions")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                DebugActionButton(
                    title: "Health Check",
                    subtitle: "Run full system scan",
                    icon: "stethoscope",
                    color: .blue,
                    isLoading: isRunningHealthCheck,
                    action: {
                    Task {
                        isRunningHealthCheck = true
                        await autoDebugSystem.performEnhancedSystemHealthCheck()
                        try? await Task.sleep(nanoseconds: 2_000_000_000)
                        isRunningHealthCheck = false
                    }
                    }
                )
                
                DebugActionButton(
                    title: "Auto Fix",
                    subtitle: "Fix all errors now",
                    icon: "wrench.adjustable.fill",
                    color: .green,
                    isLoading: isFixingErrors,
                    action: {
                    Task {
                        isFixingErrors = true
                        await autoDebugSystem.fixErrorsNow()
                        try? await Task.sleep(nanoseconds: 1_500_000_000)
                        isFixingErrors = false
                    }
                    }
                )
                
                DebugActionButton(
                    title: "ML Analysis",
                    subtitle: "Run AI predictions",
                    icon: "brain.head.profile",
                    color: DesignSystem.primaryGold,
                    isLoading: false,
                    action: {
                        // Trigger ML analysis
                    }
                )
                
                DebugActionButton(
                    title: "Performance",
                    subtitle: "Optimize system",
                    icon: "speedometer",
                    color: .purple,
                    isLoading: false,
                    action: {
                        // Trigger performance optimization
                    }
                )
            }
        }
        .padding(20)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: DesignSystem.cardShadow, radius: 8, x: 0, y: 4)
    }
}

// MARK: - System Health Overview
struct SystemHealthOverviewView: View {
    @EnvironmentObject private var autoDebugSystem: AutoDebugSystem
    @Binding var animateCharts: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("System Health Overview")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
            
            // Health Score Visualization
            VStack(spacing: 12) {
                HStack {
                    Text("Overall Health Score")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    Text("\(String(format: "%.1f%%", autoDebugSystem.systemHealthScore * 100))")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(healthScoreColor)
                }
                
                // Progress Ring
                ZStack {
                    Circle()
                        .stroke(.tertiary, lineWidth: 8)
                        .frame(width: 120, height: 120)
                    
                    Circle()
                        .trim(from: 0, to: animateCharts ? autoDebugSystem.systemHealthScore : 0)
                        .stroke(
                            LinearGradient(
                                colors: [healthScoreColor, healthScoreColor.opacity(0.6)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 8, lineCap: .round)
                        )
                        .frame(width: 120, height: 120)
                        .rotationEffect(.degrees(-90))
                        .animation(.easeInOut(duration: 2.0), value: animateCharts)
                    
                    VStack(spacing: 2) {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 20))
                            .foregroundStyle(healthScoreColor)
                        
                        Text("Health")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                
                // Health Indicators
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 12) {
                    HealthIndicator(title: "Memory", value: 0.75, color: .blue)
                    HealthIndicator(title: "CPU", value: 0.45, color: .green)
                    HealthIndicator(title: "Network", value: 0.90, color: .orange)
                    HealthIndicator(title: "Battery", value: 0.85, color: .yellow)
                    HealthIndicator(title: "Thermal", value: 0.95, color: .purple)
                    HealthIndicator(title: "Quality", value: autoDebugSystem.codeQualityScore, color: DesignSystem.primaryGold)
                }
            }
        }
        .padding(20)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: DesignSystem.cardShadow, radius: 8, x: 0, y: 4)
    }
    
    private var healthScoreColor: Color {
        let score = autoDebugSystem.systemHealthScore
        if score >= 0.9 { return .green }
        else if score >= 0.7 { return .orange }
        else { return .red }
    }
}

// MARK: - Real-time Metrics
struct RealTimeMetricsView: View {
    @EnvironmentObject private var autoDebugSystem: AutoDebugSystem
    @State private var currentTime = Date()
    @State private var timer: Timer?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Real-time Metrics")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                
                Spacer()
                
                Text("Live")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.red)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(.red.opacity(0.1))
                    .clipShape(Capsule())
            }
            
            // Metrics Grid
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                DebugMetricCard(
                    title: "Debug Sessions",
                    value: "\(autoDebugSystem.debugSessions.count)",
                    subtitle: "Total sessions",
                    icon: "chart.line.uptrend.xyaxis",
                    color: .blue
                )
                
                DebugMetricCard(
                    title: "Auto Fixes",
                    value: "\(autoDebugSystem.errorLogs.filter { $0.isFixed }.count)",
                    subtitle: "Successfully fixed",
                    icon: "wrench.adjustable.fill",
                    color: .green
                )
                
                DebugMetricCard(
                    title: "Predictions",
                    value: "15",
                    subtitle: "ML predictions made",
                    icon: "brain.head.profile",
                    color: DesignSystem.primaryGold
                )
                
                DebugMetricCard(
                    title: "Uptime",
                    value: "24h",
                    subtitle: "System uptime",
                    icon: "clock.fill",
                    color: .purple
                )
            }
        }
        .padding(20)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: DesignSystem.cardShadow, radius: 8, x: 0, y: 4)
        .onAppear {
            startTimer()
        }
        .onDisappear {
            timer?.invalidate()
        }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            currentTime = Date()
        }
    }
}

// MARK: - ML Predictions View
struct MLPredictionsView: View {
    @EnvironmentObject private var autoDebugSystem: AutoDebugSystem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("AI Predictions")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                
                Spacer()
                
                Image(systemName: "brain.head.profile")
                    .font(.title2)
                    .foregroundStyle(DesignSystem.primaryGold)
            }
            
            VStack(spacing: 12) {
                PredictionRow(
                    type: "Memory Warning",
                    probability: 0.85,
                    timeframe: "Next 30 min",
                    severity: .warning
                )
                
                PredictionRow(
                    type: "Network Timeout",
                    probability: 0.72,
                    timeframe: "Next hour",
                    severity: .error
                )
                
                PredictionRow(
                    type: "UI Thread Block",
                    probability: 0.45,
                    timeframe: "Low risk",
                    severity: .info
                )
            }
        }
        .padding(20)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: DesignSystem.cardShadow, radius: 8, x: 0, y: 4)
    }
}

// MARK: - Recent Debug Sessions
struct RecentDebugSessionsView: View {
    @EnvironmentObject private var autoDebugSystem: AutoDebugSystem
    @Binding var selectedError: ErrorLog?
    @Binding var showingDetailView: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent Debug Sessions")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
            
            if autoDebugSystem.debugSessions.isEmpty {
                DebugEmptyStateView(
                    icon: "magnifyingglass",
                    title: "No Debug Sessions",
                    message: "Debug sessions will appear here once the system starts monitoring."
                )
            } else {
                LazyVStack(spacing: 8) {
                    ForEach(autoDebugSystem.debugSessions.prefix(5), id: \.id) { session in
                        DebugSessionRow(session: session)
                    }
                }
            }
        }
        .padding(20)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: DesignSystem.cardShadow, radius: 8, x: 0, y: 4)
    }
}

// MARK: - Apple Docs Integration
struct AppleDocsIntegrationView: View {
    @EnvironmentObject private var autoDebugSystem: AutoDebugSystem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Apple Documentation Integration")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                
                Spacer()
                
                Image(systemName: "doc.text.fill")
                    .font(.title2)
                    .foregroundStyle(.blue)
            }
            
            VStack(spacing: 12) {
                IntegrationStatusRow(
                    title: "SwiftUI Patterns",
                    count: "25+ solutions",
                    status: .active
                )
                
                IntegrationStatusRow(
                    title: "Layout Guidelines",
                    count: "15+ patterns",
                    status: .active
                )
                
                IntegrationStatusRow(
                    title: "Performance Best Practices",
                    count: "30+ optimizations",
                    status: .active
                )
                
                IntegrationStatusRow(
                    title: "Network & Data",
                    count: "20+ solutions",
                    status: .active
                )
            }
            
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.green)
                
                Text("All Apple documentation patterns loaded and ready")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(20)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: DesignSystem.cardShadow, radius: 8, x: 0, y: 4)
    }
}

// MARK: - Supporting Views
struct StatusCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundStyle(color)
            
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(.primary)
            
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(color.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

private struct DebugActionButton: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let isLoading: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                if isLoading {
                    ProgressView()
                        .scaleEffect(0.8)
                } else {
                    Image(systemName: icon)
                        .font(.system(size: 20))
                        .foregroundStyle(color)
                }
                
                VStack(spacing: 2) {
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
        .disabled(isLoading)
    }
}

struct HealthIndicator: View {
    let title: String
    let value: Double
    let color: Color
    
    var body: some View {
        VStack(spacing: 6) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            
            ZStack {
                Circle()
                    .stroke(.tertiary, lineWidth: 3)
                    .frame(width: 40, height: 40)
                
                Circle()
                    .trim(from: 0, to: value)
                    .stroke(color, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                    .frame(width: 40, height: 40)
                    .rotationEffect(.degrees(-90))
                
                Text("\(Int(value * 100))")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundStyle(.primary)
            }
        }
    }
}

private struct DebugMetricCard: View {
    let title: String
    let value: String
    let subtitle: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundStyle(color)
                
                Spacer()
            }
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.primary)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(.primary)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(16)
        .background(color.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct PredictionRow: View {
    let type: String
    let probability: Double
    let timeframe: String
    let severity: PredictionSeverity
    
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(severityColor)
                .frame(width: 8, height: 8)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(type)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(.primary)
                
                Text(timeframe)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Text("\(Int(probability * 100))%")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(severityColor)
        }
        .padding(.vertical, 8)
    }
    
    private var severityColor: Color {
        switch severity {
        case .info: return .blue
        case .warning: return .orange
        case .error: return .red
        }
    }
}

struct DebugSessionRow: View {
    let session: DebugSession
    
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(statusColor)
                .frame(width: 8, height: 8)
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Health Check")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(.primary)
                
                Text(session.startTime, style: .time)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Text("\(session.findings.count) findings")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 8)
    }
    
    private var statusColor: Color {
        switch session.status {
        case .running: return .blue
        case .completed: return .green
        case .completedWithIssues: return .orange
        case .failed: return .red
        }
    }
}

struct IntegrationStatusRow: View {
    let title: String
    let count: String
    let status: IntegrationStatus
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: statusIcon)
                .font(.system(size: 14))
                .foregroundStyle(statusColor)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(.primary)
                
                Text(count)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Text(status.rawValue.capitalized)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(statusColor)
        }
        .padding(.vertical, 6)
    }
    
    private var statusColor: Color {
        switch status {
        case .active: return .green
        case .loading: return .orange
        case .inactive: return .red
        }
    }
    
    private var statusIcon: String {
        switch status {
        case .active: return "checkmark.circle.fill"
        case .loading: return "clock.fill"
        case .inactive: return "xmark.circle.fill"
        }
    }
}

private struct DebugEmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 48, weight: .light))
                .foregroundStyle(.tertiary)
            
            VStack(spacing: 4) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                
                Text(message)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.vertical, 32)
    }
}

// MARK: - Error Detail View
struct ErrorDetailView: View {
    let error: ErrorLog
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Error Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text(error.message)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(.primary)
                        
                        Label(error.type.rawValue, systemImage: "exclamationmark.triangle.fill")
                            .font(.subheadline)
                            .foregroundStyle(.red)
                    }
                    
                    // Error Details
                    if let stackTrace = error.stackTrace {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Stack Trace")
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            Text(stackTrace)
                                .font(.system(.caption, design: .monospaced))
                                .foregroundStyle(.secondary)
                                .padding(12)
                                .background(.ultraThinMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                    
                    // Fix Information
                    if error.isFixed {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Fix Applied")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundStyle(.green)
                            
                            if let fixMethod = error.fixMethod {
                                Text(fixMethod)
                                    .font(.body)
                                    .foregroundStyle(.secondary)
                            }
                            
                            if let fixDate = error.fixAppliedAt {
                                Text("Fixed: \(fixDate.formatted())")
                                    .font(.caption)
                                    .foregroundStyle(.tertiary)
                            }
                        }
                        .padding(16)
                        .background(.green.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
                .padding(20)
            }
            .navigationTitle("Error Details")
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

// MARK: - Supporting Types
enum PredictionSeverity {
    case info, warning, error
}

enum IntegrationStatus: String {
    case active, loading, inactive
}

// MARK: - Preview Provider
struct AutoDebugDashboardView_Previews: PreviewProvider {
    static var previews: some View {
        AutoDebugDashboardView()
            .environmentObject(AutoDebugSystem.shared)
            .preferredColorScheme(.light)
    }
}