//
//  PlanetMarkDouglasView.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 7/18/25.
//

import SwiftUI

struct PlanetMarkDouglasView: View {
    @StateObject private var markDouglasEngine = PlanetMarkDouglasEngine()
    @State private var selectedTab = 0
    @State private var showingBotDetails = false
    @State private var selectedBot: BotPersonality?
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Cosmic background
                LinearGradient(
                    colors: [
                        Color.black,
                        Color.purple.opacity(0.3),
                        Color.blue.opacity(0.2),
                        Color.black
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header
                        planetHeader
                        
                        // Psychology Status
                        psychologyStatusCard
                        
                        // Tab Selection
                        tabSelector
                        
                        // Content based on selection
                        switch selectedTab {
                        case 0:
                            botArmyOverview
                        case 1:
                            markDouglasInsights
                        case 2:
                            realTimePsychology
                        default:
                            botArmyOverview
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                }
            }
            .navigationBarHidden(true)
            .sheet(item: $selectedBot) { bot in
                BotPersonalityDetailView(bot: bot)
            }
        }
    }
    
    // MARK: - Header
    
    private var planetHeader: some View {
        VStack(spacing: 16) {
            // Planet visualization
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                DesignSystem.primaryGold.opacity(0.8),
                                .purple.opacity(0.6),
                                .blue.opacity(0.4),
                                .black
                            ],
                            center: .center,
                            startRadius: 20,
                            endRadius: 80
                        )
                    )
                    .frame(width: 120, height: 120)
                    .overlay(
                        Circle()
                            .stroke(DesignSystem.primaryGold.opacity(0.5), lineWidth: 2)
                    )
                
                Image(systemName: "brain.head.profile")
                    .font(.system(size: 40, weight: .ultraLight))
                    .foregroundStyle(DesignSystem.primaryGold)
            }
            
            VStack(spacing: 8) {
                Text("PLANET MARK DOUGLAS")
                    .font(.system(size: 24, weight: .black, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [DesignSystem.primaryGold, .white],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                
                Text("Psychology Universe Command Center")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.white.opacity(0.8))
                
                Text("5,000+ Trading Minds Operating")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(.green)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.green.opacity(0.2))
                    )
            }
        }
    }
    
    // MARK: - Psychology Status
    
    private var psychologyStatusCard: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Current Psychology State")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.white)
                
                Spacer()
                
                Circle()
                    .fill(markDouglasEngine.currentEmotionalState.color)
                    .frame(width: 12, height: 12)
                    .overlay(
                        Circle()
                            .stroke(.white.opacity(0.3), lineWidth: 1)
                    )
                
                Text(markDouglasEngine.currentEmotionalState.rawValue)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(markDouglasEngine.currentEmotionalState.color)
            }
            
            // Psychology meters
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                PsychologyMeter(
                    title: "Confidence",
                    value: markDouglasEngine.confidenceLevel,
                    color: .blue,
                    icon: "brain.head.profile"
                )
                
                PsychologyMeter(
                    title: "Discipline",
                    value: markDouglasEngine.disciplineScore,
                    color: .green,
                    icon: "checkmark.seal.fill"
                )
                
                PsychologyMeter(
                    title: "Fear Level",
                    value: markDouglasEngine.fearLevel,
                    color: .red,
                    icon: "exclamationmark.triangle.fill"
                )
                
                PsychologyMeter(
                    title: "Probabilistic",
                    value: markDouglasEngine.probabilisticThinking,
                    color: DesignSystem.primaryGold,
                    icon: "percent"
                )
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.white.opacity(0.2), lineWidth: 1)
                )
        )
    }
    
    // MARK: - Tab Selector
    
    private var tabSelector: some View {
        HStack(spacing: 0) {
            ForEach(0..<3, id: \.self) { index in
                let titles = ["Bot Army", "Mark Douglas", "Live Psychology"]
                let icons = ["person.3.fill", "brain.head.profile", "waveform.path.ecg"]
                
                Button(action: { selectedTab = index }) {
                    VStack(spacing: 8) {
                        Image(systemName: icons[index])
                            .font(.system(size: 20, weight: .medium))
                        
                        Text(titles[index])
                            .font(.system(size: 12, weight: .semibold))
                    }
                    .foregroundStyle(selectedTab == index ? DesignSystem.primaryGold : .white.opacity(0.6))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(selectedTab == index ? DesignSystem.primaryGold.opacity(0.2) : .clear)
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(4)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
        )
    }
    
    // MARK: - Bot Army Overview
    
    private var botArmyOverview: some View {
        VStack(spacing: 20) {
            // Stats overview
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                StatCard(title: "Total Bots", value: "5,000+", icon: "person.3.fill", color: .blue)
                StatCard(title: "Active Now", value: "4,847", icon: "bolt.fill", color: .green)
                StatCard(title: "Learning", value: "2,156", icon: "brain.head.profile", color: .orange)
                StatCard(title: "Trading Live", value: "1,024", icon: "chart.line.uptrend.xyaxis", color: .purple)
            }
            
            // Top performing bots
            VStack(alignment: .leading, spacing: 12) {
                Text("🏆 Top Performing Bots")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.white)
                
                LazyVStack(spacing: 8) {
                    ForEach(markDouglasEngine.getTopPerformingBots(limit: 5)) { bot in
                        BotCard(bot: bot) {
                            selectedBot = bot
                            showingBotDetails = true
                        }
                    }
                }
            }
            
            // Master archetypes
            VStack(alignment: .leading, spacing: 12) {
                Text("🧠 Master Trader Archetypes")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.white)
                
                LazyVStack(spacing: 8) {
                    ForEach(markDouglasEngine.masterTraderArchetypes.indices, id: \.self) { index in
                        let archetype = markDouglasEngine.masterTraderArchetypes[index]
                        ArchetypeCard(archetype: archetype)
                    }
                }
            }
        }
    }
    
    // MARK: - Mark Douglas Insights
    
    private var markDouglasInsights: some View {
        VStack(spacing: 20) {
            // Daily report
            DailyReportCard(report: markDouglasEngine.dailyMindsetReport)
            
            // Recent psychology events
            VStack(alignment: .leading, spacing: 12) {
                Text("📝 Recent Psychology Events")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.white)
                
                LazyVStack(spacing: 8) {
                    ForEach(markDouglasEngine.recentPsychologyEvents.prefix(5)) { event in
                        PsychologyEventCard(event: event)
                    }
                }
            }
            
            // Mark Douglas principles
            VStack(alignment: .leading, spacing: 12) {
                Text("💡 Core Trading Principles")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.white)
                
                LazyVStack(spacing: 8) {
                    ForEach(getMarkDouglasPrinciples(), id: \.self) { principle in
                        PrincipleCard(principle: principle)
                    }
                }
            }
        }
    }
    
    // MARK: - Real-time Psychology
    
    private var realTimePsychology: some View {
        VStack(spacing: 20) {
            // Live psychology chart
            VStack(alignment: .leading, spacing: 12) {
                Text("📊 Live Psychology Metrics")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.white)
                
                // Simplified chart visualization
                HStack(spacing: 4) {
                    ForEach(0..<30, id: \.self) { index in
                        let height = CGFloat.random(in: 20...60)
                        let color: Color = index % 3 == 0 ? .red : (index % 2 == 0 ? .green : DesignSystem.primaryGold)
                        
                        Rectangle()
                            .fill(color.opacity(0.7))
                            .frame(width: 8, height: height)
                            .clipShape(RoundedRectangle(cornerRadius: 2))
                    }
                }
                .frame(height: 60)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.ultraThinMaterial)
                )
            }
            
            // Psychology breakdown by trading style
            VStack(alignment: .leading, spacing: 12) {
                Text("🎯 Psychology by Trading Style")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.white)
                
                LazyVStack(spacing: 8) {
                    ForEach(TradingStyleType.allCases, id: \.self) { style in
                        TradingStyleCard(
                            style: style,
                            botCount: markDouglasEngine.activeBotPersonalities.filter { $0.tradingStyle == style }.count
                        )
                    }
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func getMarkDouglasPrinciples() -> [String] {
        return [
            "Anything can happen",
            "You don't need to know what's going to happen next to make money",
            "There is a random distribution between wins and losses",
            "An edge is nothing more than an indication of a higher probability",
            "Every moment in the market is unique"
        ]
    }
}

// MARK: - Supporting Views

struct PsychologyMeter: View {
    let title: String
    let value: Double
    let color: Color
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(color)
                
                Text(title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(.white.opacity(0.8))
                
                Spacer()
                
                Text("\(Int(value * 100))%")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(.white)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(.white.opacity(0.2))
                        .frame(height: 4)
                        .clipShape(RoundedRectangle(cornerRadius: 2))
                    
                    Rectangle()
                        .fill(color)
                        .frame(width: geometry.size.width * value, height: 4)
                        .clipShape(RoundedRectangle(cornerRadius: 2))
                }
            }
            .frame(height: 4)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(.ultraThinMaterial)
        )
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .medium))
                .foregroundStyle(color)
            
            Text(value)
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(.white)
            
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(.white.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

struct BotCard: View {
    let bot: BotPersonality
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                // Bot avatar
                Circle()
                    .fill(getTradingStyleColor(bot.tradingStyle))
                    .frame(width: 40, height: 40)
                    .overlay(
                        Text(String(bot.name.prefix(2)))
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(.white)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(bot.name)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.white)
                        .lineLimit(1)
                    
                    Text(bot.specialization)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(.white.opacity(0.7))
                    
                    Text("Confidence: \(Int(bot.currentConfidence * 100))%")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundStyle(.green)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Streak: \(bot.currentStreak)")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(bot.currentStreak >= 0 ? .green : .red)
                    
                    Text("\(bot.tradesExecuted) trades")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundStyle(.white.opacity(0.6))
                }
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(getTradingStyleColor(bot.tradingStyle).opacity(0.3), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func getTradingStyleColor(_ style: TradingStyleType) -> Color {
        switch style {
        case .probabilistic: return .blue
        case .institutional: return .purple
        case .momentum: return .orange
        case .contrarian: return .red
        case .scalping: return .green
        }
    }
}

struct ArchetypeCard: View {
    let archetype: MasterTraderArchetype
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(archetype.name)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
                
                Spacer()
                
                Text(archetype.tradingStyle.rawValue)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(.white.opacity(0.7))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .fill(.white.opacity(0.1))
                    )
            }
            
            Text("Expected Win Rate: \(Int(archetype.winRateExpectation * 100))%")
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(.green)
            
            Text("Risk Tolerance: \(String(format: "%.1f", archetype.riskTolerance * 100))%")
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(.orange)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.ultraThinMaterial)
        )
    }
}

struct DailyReportCard: View {
    let report: DailyMindsetReport
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("📊 Daily Mindset Report")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
                
                Spacer()
                
                Text("Score: \(Int(report.overallScore * 100))%")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(.green)
            }
            
            Text("💭 \"\(report.markDouglasQuote)\"")
                .font(.system(size: 14, weight: .medium, design: .serif))
                .foregroundStyle(.white.opacity(0.9))
                .italic()
                .padding(.vertical, 8)
            
            if !report.keyInsights.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text("✅ Key Insights:")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(.green)
                    
                    ForEach(report.keyInsights, id: \.self) { insight in
                        Text("• \(insight)")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(.white.opacity(0.8))
                    }
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(DesignSystem.primaryGold.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

struct PsychologyEventCard: View {
    let event: PsychologyEvent
    
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(getEventColor(event.eventType))
                .frame(width: 8, height: 8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(event.eventType.rawValue)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.white)
                
                Text(event.description)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(.white.opacity(0.7))
                    .lineLimit(2)
            }
            
            Spacer()
            
            Text(formatTime(event.timestamp))
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(.white.opacity(0.5))
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(.ultraThinMaterial)
        )
    }
    
    private func getEventColor(_ type: PsychologyEventType) -> Color {
        switch type {
        case .successfulTrade: return .green
        case .unsuccessfulTrade: return .red
        case .disciplineBreak: return .orange
        case .emotionalDecision: return .purple
        case .learningMoment: return .blue
        }
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct PrincipleCard: View {
    let principle: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "quote.bubble.fill")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(DesignSystem.primaryGold)
            
            Text(principle)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.white)
            
            Spacer()
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(DesignSystem.primaryGold.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

struct TradingStyleCard: View {
    let style: TradingStyleType
    let botCount: Int
    
    var body: some View {
        HStack {
            Text(style.rawValue)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.white)
            
            Spacer()
            
            Text("\(botCount) bots")
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(.white.opacity(0.7))
            
            Circle()
                .fill(getStyleColor(style))
                .frame(width: 8, height: 8)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(.ultraThinMaterial)
        )
    }
    
    private func getStyleColor(_ style: TradingStyleType) -> Color {
        switch style {
        case .probabilistic: return .blue
        case .institutional: return .purple
        case .momentum: return .orange
        case .contrarian: return .red
        case .scalping: return .green
        }
    }
}

struct BotPersonalityDetailView: View {
    let bot: BotPersonality
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Bot header
                    VStack(spacing: 12) {
                        Circle()
                            .fill(.blue.opacity(0.3))
                            .frame(width: 80, height: 80)
                            .overlay(
                                Text(String(bot.name.prefix(2)))
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundStyle(.white)
                            )
                        
                        Text(bot.name)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(.primary)
                        
                        Text(bot.specialization)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top)
                    
                    // Stats
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                        DetailStatCard(title: "Confidence", value: "\(Int(bot.currentConfidence * 100))%", color: .blue)
                        DetailStatCard(title: "Win Rate", value: "\(Int(bot.winRateExpectation * 100))%", color: .green)
                        DetailStatCard(title: "Risk Tolerance", value: "\(String(format: "%.1f", bot.riskTolerance * 100))%", color: .orange)
                        DetailStatCard(title: "Current Streak", value: "\(bot.currentStreak)", color: bot.currentStreak >= 0 ? .green : .red)
                    }
                    
                    // Core beliefs
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Core Beliefs")
                            .font(.headline)
                            .foregroundStyle(.primary)
                        
                        ForEach(bot.coreBeliefs, id: \.self) { belief in
                            HStack(alignment: .top, spacing: 8) {
                                Text("•")
                                    .foregroundStyle(.blue)
                                Text(belief)
                                    .font(.system(size: 14))
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    
                    // Psychology strengths
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Psychology Strengths")
                            .font(.headline)
                            .foregroundStyle(.primary)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                            ForEach(bot.psychologyStrengths, id: \.self) { strength in
                                Text(strength)
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(.blue.opacity(0.3))
                                    )
                            }
                        }
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Bot Details")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct DetailStatCard: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(color)
            
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(color.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

#Preview {
    PlanetMarkDouglasView()
}