//
//  BotDetailView.swift
//  GOLDEX AI
//
//  Created by Goldex AI on 7/19/25.
//

import SwiftUI

struct BotDetailView: View {
    let bot: ProTraderBot
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Bot Header
                    botHeaderSection
                    
                    // Performance Metrics
                    performanceMetricsSection
                    
                    // Strategy Details
                    strategyDetailsSection
                    
                    // Learning History
                    learningHistorySection
                    
                    // Trade Statistics
                    tradeStatisticsSection
                }
                .padding(.horizontal, 20)
            }
            .background(DesignSystem.backgroundGradient)
            .navigationTitle(bot.name)
            .navigationBarTitleDisplayMode(.large)
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
    
    // MARK: - Bot Header
    private var botHeaderSection: some View {
        VStack(spacing: 16) {
            // Bot Avatar/Icon
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                confidenceColor(bot.confidence).opacity(0.2),
                                confidenceColor(bot.confidence).opacity(0.1)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)
                
                Image(systemName: "robot")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(confidenceColor(bot.confidence))
            }
            
            VStack(spacing: 8) {
                Text(bot.name)
                    .font(DesignSystem.typography.headlineLarge)
                    .foregroundColor(DesignSystem.primaryText)
                
                Text(bot.confidenceLevel)
                    .font(DesignSystem.typography.bodyMedium)
                    .foregroundColor(confidenceColor(bot.confidence))
                
                Text("Bot #\(bot.botNumber)")
                    .font(DesignSystem.typography.captionMedium)
                    .foregroundColor(DesignSystem.secondaryText)
            }
        }
        .padding(.top, 20)
    }
    
    // MARK: - Performance Metrics
    private var performanceMetricsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("📊 PERFORMANCE METRICS")
                .font(DesignSystem.typography.headlineMedium)
                .foregroundColor(DesignSystem.primaryText)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                BotMetricCard(
                    title: "Confidence",
                    value: String(format: "%.1f%%", bot.confidence * 100),
                    icon: "brain.head.profile",
                    color: confidenceColor(bot.confidence)
                )
                
                BotMetricCard(
                    title: "Experience",
                    value: String(format: "%.0f XP", bot.xp),
                    icon: "star.fill",
                    color: .yellow
                )
                
                BotMetricCard(
                    title: "Win Rate",
                    value: String(format: "%.1f%%", bot.winRate),
                    icon: "target",
                    color: bot.winRate >= 60 ? .green : .red
                )
                
                BotMetricCard(
                    title: "P&L",
                    value: String(format: "$%.0f", bot.profitLoss),
                    icon: "dollarsign.circle",
                    color: bot.profitLoss >= 0 ? .green : .red
                )
            }
        }
    }
    
    // MARK: - Strategy Details
    private var strategyDetailsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("⚡ STRATEGY & SPECIALIZATION")
                .font(DesignSystem.typography.headlineMedium)
                .foregroundColor(DesignSystem.primaryText)
            
            VStack(spacing: 12) {
                InfoRow(
                    label: "Trading Strategy",
                    value: bot.strategy.rawValue,
                    icon: "chart.xyaxis.line"
                )
                
                InfoRow(
                    label: "Specialization",
                    value: bot.specialization.rawValue,
                    icon: "target"
                )
                
                InfoRow(
                    label: "Status",
                    value: bot.isActive ? "Active" : "Inactive",
                    icon: bot.isActive ? "checkmark.circle.fill" : "pause.circle.fill"
                )
                
                if let lastTraining = bot.lastTraining {
                    InfoRow(
                        label: "Last Training",
                        value: formatDate(lastTraining),
                        icon: "clock"
                    )
                }
            }
            .padding(16)
            .background(DesignSystem.cardBackground)
            .cornerRadius(16)
        }
    }
    
    // MARK: - Learning History
    private var learningHistorySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("🧠 LEARNING HISTORY")
                .font(DesignSystem.typography.headlineMedium)
                .foregroundColor(DesignSystem.primaryText)
            
            if bot.learningHistory.isEmpty {
                Text("No training sessions yet")
                    .font(DesignSystem.typography.bodyMedium)
                    .foregroundColor(DesignSystem.secondaryText)
                    .padding(16)
                    .background(DesignSystem.cardBackground)
                    .cornerRadius(16)
            } else {
                VStack(spacing: 8) {
                    Text("Recent Training Sessions (\(bot.learningHistory.count))")
                        .font(DesignSystem.typography.bodyMedium)
                        .foregroundColor(DesignSystem.primaryText)
                    
                    LazyVStack(spacing: 8) {
                        ForEach(Array(bot.learningHistory.suffix(5).enumerated()), id: \.offset) { index, session in
                            LearningSessionRow(session: session)
                        }
                    }
                }
                .padding(16)
                .background(DesignSystem.cardBackground)
                .cornerRadius(16)
            }
        }
    }
    
    // MARK: - Trade Statistics
    private var tradeStatisticsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("📈 TRADE STATISTICS")
                .font(DesignSystem.typography.headlineMedium)
                .foregroundColor(DesignSystem.primaryText)
            
            VStack(spacing: 12) {
                StatRow(label: "Total Trades", value: "\(bot.totalTrades)")
                StatRow(label: "Winning Trades", value: "\(bot.wins)")
                StatRow(label: "Losing Trades", value: "\(bot.losses)")
                StatRow(label: "Win Rate", value: String(format: "%.1f%%", bot.winRate))
                StatRow(label: "Profit Factor", value: calculateProfitFactor())
                StatRow(label: "Risk Score", value: calculateRiskScore())
            }
            .padding(16)
            .background(DesignSystem.cardBackground)
            .cornerRadius(16)
        }
    }
    
    // MARK: - Helper Functions
    private func confidenceColor(_ confidence: Double) -> Color {
        switch confidence {
        case 0.9...: return .orange
        case 0.8..<0.9: return .purple
        case 0.7..<0.8: return .blue
        case 0.6..<0.7: return .green
        default: return DesignSystem.secondaryText
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    private func calculateProfitFactor() -> String {
        guard bot.losses > 0 else { return "∞" }
        let factor = Double(bot.wins) / Double(bot.losses)
        return String(format: "%.2f", factor)
    }
    
    private func calculateRiskScore() -> String {
        let riskScore = 100 - Int(bot.confidence * 100)
        return "\(riskScore)%"
    }
}

// MARK: - Supporting Views
struct BotMetricCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(color)
            
            Text(value)
                .font(DesignSystem.typography.headlineMedium)
                .foregroundColor(DesignSystem.primaryText)
            
            Text(title)
                .font(DesignSystem.typography.captionMedium)
                .foregroundColor(DesignSystem.secondaryText)
        }
        .padding(16)
        .background(DesignSystem.cardBackground)
        .cornerRadius(12)
    }
}

struct InfoRow: View {
    let label: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(DesignSystem.primaryGold)
                .frame(width: 20)
            
            Text(label)
                .font(DesignSystem.typography.bodyMedium)
                .foregroundColor(DesignSystem.primaryText)
            
            Spacer()
            
            Text(value)
                .font(DesignSystem.typography.bodyMedium)
                .foregroundColor(DesignSystem.secondaryText)
        }
    }
}

struct LearningSessionRow: View {
    let session: LearningSession
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(formatSessionDate(session.timestamp))
                    .font(DesignSystem.typography.captionMedium)
                    .foregroundColor(DesignSystem.primaryText)
                
                Spacer()
                
                Text("+\(String(format: "%.0f", session.xpGained)) XP")
                    .font(DesignSystem.typography.captionMedium)
                    .foregroundColor(DesignSystem.primaryGold)
            }
            
            Text("\(session.dataPoints) data points • +\(String(format: "%.3f", session.confidenceGained)) confidence")
                .font(DesignSystem.typography.captionRegular)
                .foregroundColor(DesignSystem.secondaryText)
            
            if !session.patterns.isEmpty {
                Text("Patterns: \(session.patterns.prefix(2).joined(separator: ", "))")
                    .font(DesignSystem.typography.captionRegular)
                    .foregroundColor(DesignSystem.secondaryText)
                    .lineLimit(1)
            }
        }
        .padding(.vertical, 4)
    }
    
    private func formatSessionDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, HH:mm"
        return formatter.string(from: date)
    }
}

struct StatRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(DesignSystem.typography.bodyMedium)
                .foregroundColor(DesignSystem.primaryText)
            
            Spacer()
            
            Text(value)
                .font(DesignSystem.typography.bodyMedium)
                .foregroundColor(DesignSystem.primaryGold)
        }
    }
}

#Preview {
    let sampleBot = ProTraderBot(
        botNumber: 1,
        name: "ProBot-0001",
        xp: 1500,
        confidence: 0.85,
        strategy: .scalping,
        wins: 45,
        losses: 15,
        totalTrades: 60,
        profitLoss: 2500,
        learningHistory: [],
        lastTraining: Date(),
        isActive: true,
        specialization: .technical
    )
    
    return BotDetailView(bot: sampleBot)
}