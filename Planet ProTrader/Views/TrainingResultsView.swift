//
//  TrainingResultsView.swift
//  GOLDEX AI
//
//  Created by Goldex AI on 7/19/25.
//

import SwiftUI

struct TrainingResultsView: View {
    @ObservedObject var results: TrainingResults
    @Environment(\.dismiss) private var dismiss
    @State private var animateSuccess = false
    @State private var showDetails = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Success Header with Animation
                    successHeader
                    
                    // Key Metrics Grid
                    keyMetricsSection
                    
                    // Progress Charts with Animations
                    progressChartsSection
                    
                    // Detailed Breakdown
                    detailedBreakdownSection
                    
                    // Export Options
                    exportOptionsSection
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
            .background(DesignSystem.backgroundGradient)
            .navigationTitle("Training Complete")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(DesignSystem.primaryGold)
                    .font(.headline.weight(.semibold))
                }
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.2)) {
                animateSuccess = true
            }
            withAnimation(.easeInOut(duration: 0.5).delay(0.5)) {
                showDetails = true
            }
        }
    }
    
    // MARK: - Success Header
    private var successHeader: some View {
        VStack(spacing: 20) {
            // Animated Success Icon
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [DesignSystem.primaryGold.opacity(0.2), DesignSystem.accentOrange.opacity(0.2)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 120)
                    .scaleEffect(animateSuccess ? 1.0 : 0.8)
                    .opacity(animateSuccess ? 1.0 : 0.5)
                
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 50, weight: .bold))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [DesignSystem.primaryGold, DesignSystem.accentOrange],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .scaleEffect(animateSuccess ? 1.0 : 0.3)
                    .rotationEffect(.degrees(animateSuccess ? 0 : -180))
            }
            .shadow(color: DesignSystem.primaryGold.opacity(0.3), radius: 20, x: 0, y: 10)
            
            VStack(spacing: 12) {
                Text("🚀 TRAINING COMPLETE!")
                    .font(DesignSystem.typography.headlineLarge)
                    .foregroundColor(DesignSystem.primaryText)
                    .opacity(showDetails ? 1.0 : 0)
                
                Text("Your ProTrader army just evolved to the next level")
                    .font(DesignSystem.typography.bodyMedium)
                    .foregroundColor(DesignSystem.secondaryText)
                    .multilineTextAlignment(.center)
                    .opacity(showDetails ? 1.0 : 0)
                
                HStack {
                    Image(systemName: "clock.fill")
                        .foregroundColor(DesignSystem.primaryGold)
                    Text("Training Time: \(String(format: "%.2f", results.trainingTime))s")
                        .font(DesignSystem.typography.captionMedium)
                        .foregroundColor(DesignSystem.primaryGold)
                }
                .opacity(showDetails ? 1.0 : 0)
            }
        }
        .padding(.top, 20)
    }
    
    // MARK: - Key Metrics
    private var keyMetricsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "chart.bar.fill")
                    .foregroundColor(DesignSystem.primaryGold)
                Text("KEY METRICS")
                    .font(DesignSystem.typography.headlineMedium)
                    .foregroundColor(DesignSystem.primaryText)
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                ResultMetricCard(
                    icon: "robot.2.fill",
                    title: "Bots Trained",
                    value: "\(results.botsTrained)",
                    subtitle: "Total army size",
                    color: .blue
                )
                
                ResultMetricCard(
                    icon: "chart.line.uptrend.xyaxis",
                    title: "Data Points",
                    value: formatNumber(results.dataPointsProcessed),
                    subtitle: "Historical records",
                    color: .green
                )
                
                ResultMetricCard(
                    icon: "crown.fill",
                    title: "New Godlike",
                    value: "\(results.newGodlikeBots)",
                    subtitle: "95%+ confidence",
                    color: .orange
                )
                
                ResultMetricCard(
                    icon: "star.fill",
                    title: "New Elite",
                    value: "\(results.newEliteBots)",
                    subtitle: "85%+ confidence",
                    color: .purple
                )
            }
        }
        .opacity(showDetails ? 1.0 : 0)
        .animation(.easeInOut(duration: 0.6).delay(0.3), value: showDetails)
    }
    
    // MARK: - Progress Charts
    private var progressChartsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "chart.bar.xaxis.ascending")
                    .foregroundColor(DesignSystem.primaryGold)
                Text("PROGRESS VISUALIZATION")
                    .font(DesignSystem.typography.headlineMedium)
                    .foregroundColor(DesignSystem.primaryText)
            }
            
            VStack(spacing: 20) {
                // XP Gain Chart
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "star.circle.fill")
                            .foregroundColor(DesignSystem.primaryGold)
                        Text("Total XP Gained")
                            .font(DesignSystem.typography.bodyMedium)
                            .foregroundColor(DesignSystem.primaryText)
                    }
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(formatNumber(Int(results.totalXPGained)) + " XP")
                                .font(DesignSystem.typography.headlineLarge)
                                .foregroundColor(DesignSystem.primaryGold)
                            
                            Text("Avg: \(formatNumber(Int(results.totalXPGained / Double(max(results.botsTrained, 1))))) per bot")
                                .font(DesignSystem.typography.captionRegular)
                                .foregroundColor(DesignSystem.secondaryText)
                        }
                        
                        Spacer()
                        
                        CircularProgressView(
                            progress: min(results.totalXPGained / 1_000_000, 1.0),
                            color: DesignSystem.primaryGold
                        )
                    }
                }
                
                Divider()
                    .background(DesignSystem.secondaryText.opacity(0.3))
                
                // Confidence Boost Chart
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "brain.head.profile.fill")
                            .foregroundColor(.blue)
                        Text("Total Confidence Gained")
                            .font(DesignSystem.typography.bodyMedium)
                            .foregroundColor(DesignSystem.primaryText)
                    }
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(String(format: "%.2f%%", results.totalConfidenceGained))
                                .font(DesignSystem.typography.headlineLarge)
                                .foregroundColor(.blue)
                            
                            Text("Avg: \(String(format: "%.4f%%", results.totalConfidenceGained / Double(max(results.botsTrained, 1)))) per bot")
                                .font(DesignSystem.typography.captionRegular)
                                .foregroundColor(DesignSystem.secondaryText)
                        }
                        
                        Spacer()
                        
                        CircularProgressView(
                            progress: min(results.totalConfidenceGained / 100, 1.0),
                            color: .blue
                        )
                    }
                }
            }
            .padding(20)
            .background(.ultraThinMaterial)
            .cornerRadius(16)
            .shadow(color: DesignSystem.cardShadow, radius: 8, x: 0, y: 4)
        }
        .opacity(showDetails ? 1.0 : 0)
        .animation(.easeInOut(duration: 0.6).delay(0.4), value: showDetails)
    }
    
    // MARK: - Detailed Breakdown
    private var detailedBreakdownSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "magnifyingglass.circle.fill")
                    .foregroundColor(DesignSystem.primaryGold)
                Text("DETAILED BREAKDOWN")
                    .font(DesignSystem.typography.headlineMedium)
                    .foregroundColor(DesignSystem.primaryText)
            }
            
            VStack(spacing: 16) {
                DetailRow(
                    title: "Training Efficiency",
                    icon: "speedometer",
                    value: "\(formatNumber(Int(Double(results.botsTrained) / max(results.trainingTime, 1)))) bots/sec",
                    color: .green
                )
                
                DetailRow(
                    title: "Data Processing Rate",
                    icon: "cpu.fill",
                    value: "\(formatNumber(Int(Double(results.dataPointsProcessed) / max(results.trainingTime, 1)))) points/sec",
                    color: .blue
                )
                
                DetailRow(
                    title: "Godlike Conversion Rate",
                    icon: "trophy.fill",
                    value: "\(String(format: "%.2f%%", Double(results.newGodlikeBots) / Double(max(results.botsTrained, 1)) * 100))",
                    color: .orange
                )
                
                DetailRow(
                    title: "Elite Conversion Rate",
                    icon: "star.fill",
                    value: "\(String(format: "%.2f%%", Double(results.newEliteBots) / Double(max(results.botsTrained, 1)) * 100))",
                    color: .purple
                )
                
                if !results.errors.isEmpty {
                    Divider()
                        .background(DesignSystem.error.opacity(0.3))
                    
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(DesignSystem.error)
                            Text("Errors (\(results.errors.count))")
                                .font(DesignSystem.typography.bodyMedium)
                                .foregroundColor(DesignSystem.error)
                        }
                        
                        ForEach(Array(results.errors.enumerated()), id: \.offset) { index, error in
                            HStack(alignment: .top, spacing: 8) {
                                Text("•")
                                    .foregroundColor(DesignSystem.error)
                                Text(error)
                                    .font(DesignSystem.typography.captionRegular)
                                    .foregroundColor(DesignSystem.secondaryText)
                            }
                        }
                    }
                }
            }
            .padding(20)
            .background(.ultraThinMaterial)
            .cornerRadius(16)
            .shadow(color: DesignSystem.cardShadow, radius: 8, x: 0, y: 4)
        }
        .opacity(showDetails ? 1.0 : 0)
        .animation(.easeInOut(duration: 0.6).delay(0.5), value: showDetails)
    }
    
    // MARK: - Export Options
    private var exportOptionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "square.and.arrow.up.fill")
                    .foregroundColor(DesignSystem.primaryGold)
                Text("EXPORT & SHARE")
                    .font(DesignSystem.typography.headlineMedium)
                    .foregroundColor(DesignSystem.primaryText)
            }
            
            VStack(spacing: 12) {
                ExportButton(
                    icon: "doc.text.fill",
                    title: "Export Report",
                    subtitle: "Save training summary as PDF",
                    action: { exportReport() }
                )
                
                ExportButton(
                    icon: "chart.bar.doc.horizontal.fill",
                    title: "Generate Charts",
                    subtitle: "Create visual performance charts",
                    action: { generateCharts() }
                )
                
                ExportButton(
                    icon: "square.and.arrow.up.circle.fill",
                    title: "Share Results",
                    subtitle: "Share with your team via message",
                    action: { shareResults() }
                )
            }
        }
        .opacity(showDetails ? 1.0 : 0)
        .animation(.easeInOut(duration: 0.6).delay(0.6), value: showDetails)
    }
    
    // MARK: - Helper Functions
    private func formatNumber(_ number: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: number)) ?? "\(number)"
    }
    
    private func exportReport() {
        // Implementation for exporting report
        print("Exporting training report...")
    }
    
    private func generateCharts() {
        // Implementation for generating charts
        print("Generating performance charts...")
    }
    
    private func shareResults() {
        // Implementation for sharing results
        print("Sharing training results...")
    }
}

// MARK: - Supporting Views

struct ResultMetricCard: View {
    let icon: String
    let title: String
    let value: String
    let subtitle: String
    let color: Color
    @State private var animateValue = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.system(size: 22, weight: .semibold))
                    .scaleEffect(animateValue ? 1.0 : 0.8)
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(value)
                    .font(DesignSystem.typography.headlineLarge)
                    .foregroundColor(DesignSystem.primaryText)
                    .scaleEffect(animateValue ? 1.0 : 0.5)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(DesignSystem.typography.bodyMedium)
                        .foregroundColor(DesignSystem.primaryText)
                    
                    Text(subtitle)
                        .font(DesignSystem.typography.captionRegular)
                        .foregroundColor(DesignSystem.secondaryText)
                }
                .opacity(animateValue ? 1.0 : 0.7)
            }
        }
        .padding(16)
        .background(.ultraThinMaterial)
        .cornerRadius(16)
        .shadow(color: color.opacity(0.2), radius: 8, x: 0, y: 4)
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6).delay(Double.random(in: 0.1...0.5))) {
                animateValue = true
            }
        }
    }
}

struct DetailRow: View {
    let title: String
    let icon: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.system(size: 16, weight: .medium))
                .frame(width: 20)
            
            Text(title)
                .font(DesignSystem.typography.bodyMedium)
                .foregroundColor(DesignSystem.primaryText)
            
            Spacer()
            
            Text(value)
                .font(DesignSystem.typography.bodyMedium)
                .fontWeight(.semibold)
                .foregroundColor(color)
        }
        .padding(.vertical, 4)
    }
}

struct ExportButton: View {
    let icon: String
    let title: String
    let subtitle: String
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.1)) {
                    isPressed = false
                }
                action()
            }
        }) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(DesignSystem.primaryGold)
                    .frame(width: 28)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(DesignSystem.typography.bodyMedium)
                        .foregroundColor(DesignSystem.primaryText)
                    
                    Text(subtitle)
                        .font(DesignSystem.typography.captionRegular)
                        .foregroundColor(DesignSystem.secondaryText)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(DesignSystem.secondaryText)
                    .font(.system(size: 14, weight: .medium))
            }
            .padding(18)
            .background(.ultraThinMaterial)
            .cornerRadius(16)
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .shadow(color: DesignSystem.cardShadow, radius: 8, x: 0, y: 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct CircularProgressView: View {
    let progress: Double
    let color: Color
    @State private var animateProgress = false
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(color.opacity(0.2), lineWidth: 4)
                .frame(width: 60, height: 60)
            
            Circle()
                .trim(from: 0, to: animateProgress ? progress : 0)
                .stroke(color, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .frame(width: 60, height: 60)
                .rotationEffect(.degrees(-90))
            
            Text("\(Int(progress * 100))%")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(color)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0).delay(0.5)) {
                animateProgress = true
            }
        }
    }
}

#Preview {
    let sampleResults = TrainingResults()
    sampleResults.botsTrained = 5000
    sampleResults.dataPointsProcessed = 2500000
    sampleResults.totalXPGained = 750000
    sampleResults.totalConfidenceGained = 25.5
    sampleResults.newEliteBots = 245
    sampleResults.newGodlikeBots = 89
    sampleResults.trainingTime = 45.67
    
    return TrainingResultsView(results: sampleResults)
        .preferredColorScheme(.light)
}