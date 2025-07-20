//
//  BotLeaderboardView.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 1/25/25.
//

import SwiftUI

struct BotLeaderboardView: View {
    @StateObject private var leaderboardManager = BotLeaderboardManager()
    @State private var selectedTab = 0
    @State private var selectedCompetition: BotCompetition?
    @State private var showingCompetitionDetail = false
    @State private var showingJoinCompetition = false
    @State private var animatingNumbers = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Live status indicator
                liveStatusIndicator
                
                // Tab selector
                tabSelector
                
                // Content based on selected tab
                TabView(selection: $selectedTab) {
                    // Live Competitions
                    liveCompetitionsTab
                        .tag(0)
                    
                    // Global Rankings
                    globalRankingsTab
                        .tag(1)
                    
                    // Alerts
                    alertsTab
                        .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
            .navigationTitle("Bot Arena")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button("Refresh Data", systemImage: "arrow.clockwise") {
                            refreshData()
                        }
                        Button("Competition Rules", systemImage: "list.bullet") {
                            // Show rules
                        }
                        Button("Bot Performance", systemImage: "chart.bar") {
                            // Show bot stats
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .foregroundColor(DesignSystem.primaryGold)
                    }
                }
            }
        }
        .sheet(isPresented: $showingCompetitionDetail) {
            if let competition = selectedCompetition {
                CompetitionDetailView(
                    competition: competition,
                    leaderboardManager: leaderboardManager
                )
            }
        }
        .sheet(isPresented: $showingJoinCompetition) {
            JoinCompetitionView(
                competitions: leaderboardManager.competitions.filter { $0.status == .upcoming || $0.status == .active },
                leaderboardManager: leaderboardManager
            )
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0)) {
                animatingNumbers = true
            }
        }
    }
    
    // MARK: - Live Status Indicator
    
    private var liveStatusIndicator: some View {
        HStack(spacing: 12) {
            // Live indicator
            HStack(spacing: 6) {
                Circle()
                    .fill(Color.red)
                    .frame(width: 8, height: 8)
                    .scaleEffect(animatingNumbers ? 1.2 : 1.0)
                    .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: animatingNumbers)
                
                Text("LIVE")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.red)
            }
            
            Text("3 Active Competitions")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Spacer()
            
            // Total prize pool
            VStack(alignment: .trailing, spacing: 2) {
                Text("Prize Pool")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                
                Text("$25,000")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(DesignSystem.primaryGold)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
    }
    
    // MARK: - Tab Selector
    
    private var tabSelector: some View {
        HStack(spacing: 0) {
            ForEach(["Live", "Rankings", "Alerts"], id: \.self) { title in
                let index = ["Live", "Rankings", "Alerts"].firstIndex(of: title) ?? 0
                
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        selectedTab = index
                    }
                }) {
                    VStack(spacing: 6) {
                        HStack(spacing: 4) {
                            Image(systemName: tabIcon(for: index))
                                .font(.title3)
                            
                            if index == 2 && !leaderboardManager.alerts.filter({ !$0.isRead }).isEmpty {
                                Circle()
                                    .fill(Color.red)
                                    .frame(width: 8, height: 8)
                            }
                        }
                        
                        Text(title)
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                    .foregroundColor(selectedTab == index ? DesignSystem.primaryGold : .secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                }
            }
        }
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
        .padding(.bottom, 8)
    }
    
    private func tabIcon(for index: Int) -> String {
        switch index {
        case 0: return "flame.fill"
        case 1: return "trophy.fill"
        case 2: return "bell.fill"
        default: return "circle"
        }
    }
    
    // MARK: - Live Competitions Tab
    
    private var liveCompetitionsTab: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Join competition button
                joinCompetitionButton
                
                // Active competitions
                activeCompetitionsSection
                
                // Upcoming competitions
                upcomingCompetitionsSection
                
                // Recent winners
                recentWinnersSection
            }
            .padding()
        }
    }
    
    private var joinCompetitionButton: some View {
        Button(action: {
            showingJoinCompetition = true
            HapticFeedbackManager.shared.impact(.medium)
        }) {
            HStack {
                Image(systemName: "plus.circle.fill")
                    .font(.title2)
                
                Text("Join Competition")
                    .fontWeight(.bold)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                LinearGradient(
                    colors: [DesignSystem.primaryGold, DesignSystem.primaryGold.opacity(0.8)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(16)
        }
        .buttonStyle(ScaleButtonStyle())
    }
    
    private var activeCompetitionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("🔥 Active Competitions")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(DesignSystem.primaryGold)
            
            ForEach(leaderboardManager.competitions.filter { $0.status == .active }) { competition in
                competitionCard(competition, isActive: true)
            }
        }
    }
    
    private var upcomingCompetitionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("⏰ Starting Soon")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.blue)
            
            ForEach(leaderboardManager.competitions.filter { $0.status == .upcoming }) { competition in
                competitionCard(competition, isActive: false)
            }
        }
    }
    
    private func competitionCard(_ competition: BotCompetition, isActive: Bool) -> some View {
        Button(action: {
            selectedCompetition = competition
            showingCompetitionDetail = true
            HapticFeedbackManager.shared.impact(.light)
        }) {
            VStack(spacing: 16) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(competition.competitionType.emoji)
                                .font(.title2)
                            
                            Text(competition.name)
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                        }
                        
                        Text(competition.description)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .lineLimit(2)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text(competition.status.displayName)
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(competition.status.color)
                            .cornerRadius(8)
                        
                        Text(competition.timeRemaining)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
                
                // Stats row
                HStack(spacing: 20) {
                    statItem(
                        icon: "dollarsign.circle.fill",
                        title: "Prize Pool",
                        value: "$\(Int(competition.prizePool))",
                        color: DesignSystem.primaryGold
                    )
                    
                    statItem(
                        icon: "person.3.fill",
                        title: "Participants",
                        value: "\(competition.currentParticipants)/\(competition.maxParticipants)",
                        color: .blue
                    )
                    
                    statItem(
                        icon: "creditcard.fill",
                        title: "Entry Fee",
                        value: "$\(Int(competition.entryFee))",
                        color: .green
                    )
                }
                
                // Top 3 preview (for active competitions)
                if isActive && !competition.leaderboard.isEmpty {
                    topThreePreview(competition.leaderboard.prefix(3).map { $0 })
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemBackground))
                    .shadow(color: competition.competitionType.color.opacity(0.1), radius: 8, x: 0, y: 4)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(competition.competitionType.color.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func statItem(icon: String, title: String, value: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.title3)
            
            Text(value)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text(title)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
    
    private func topThreePreview(_ topThree: [BotCompetitionEntry]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("🏆 Current Leaders")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
            
            VStack(spacing: 6) {
                ForEach(Array(topThree.enumerated()), id: \.element.id) { index, entry in
                    HStack {
                        Text(entry.rankEmoji)
                            .font(.caption)
                        
                        Text(entry.botName)
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Text(entry.formattedProfitPercentage)
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(entry.performanceColor)
                    }
                }
            }
        }
        .padding(.top, 8)
    }
    
    private var recentWinnersSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("🎉 Recent Champions")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.purple)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                winnerCard(botName: "TrendMaster Pro", competition: "Daily Grind", prize: "$2,500", percentage: "+47.3%")
                winnerCard(botName: "ScalpLord", competition: "Flash Challenge", prize: "$5,000", percentage: "+123.7%")
                winnerCard(botName: "GoldRush AI", competition: "Weekly Warriors", prize: "$10,000", percentage: "+89.2%")
                winnerCard(botName: "ConsistentKing", competition: "Monthly Masters", prize: "$25,000", percentage: "+156.4%")
            }
        }
    }
    
    private func winnerCard(botName: String, competition: String, prize: String, percentage: String) -> some View {
        VStack(spacing: 8) {
            Text("🏆")
                .font(.title2)
            
            Text(botName)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
            
            Text(competition)
                .font(.caption2)
                .foregroundColor(.secondary)
            
            VStack(spacing: 2) {
                Text(prize)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(DesignSystem.primaryGold)
                
                Text(percentage)
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundColor(.green)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
    }
    
    // MARK: - Global Rankings Tab
    
    private var globalRankingsTab: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Rankings header
                rankingsHeader
                
                // Top 10 special section
                topTenSection
                
                // Full rankings list
                fullRankingsSection
            }
            .padding()
        }
    }
    
    private var rankingsHeader: some View {
        VStack(spacing: 12) {
            Text("🌍 Global Bot Rankings")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(DesignSystem.primaryGold)
            
            Text("Real-time performance rankings updated every 30 seconds")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        )
    }
    
    private var topTenSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("👑 Elite Ten")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.purple)
            
            VStack(spacing: 8) {
                ForEach(Array(leaderboardManager.globalRankings.prefix(10).enumerated()), id: \.element.id) { index, ranking in
                    topRankingCard(ranking, index: index)
                }
            }
        }
    }
    
    private func topRankingCard(_ ranking: BotRanking, index: Int) -> some View {
        HStack(spacing: 12) {
            // Rank indicator
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(rankColor(for: index + 1).opacity(0.2))
                    .frame(width: 40, height: 40)
                
                Text("#\(ranking.overallRank)")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(rankColor(for: index + 1))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(ranking.botName)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    Text(ranking.trendEmoji)
                        .font(.caption)
                    
                    Spacer()
                    
                    Text(ranking.performanceGrade)
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(ranking.gradeColor)
                        .cornerRadius(4)
                }
                
                HStack {
                    Text("by \(ranking.ownerName)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text("$\(Int(ranking.monthlyEarnings))")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.green)
                    
                    Text("•")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    
                    Text("\(Int(ranking.winRate))% WR")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.blue)
                }
            }
            
            if ranking.isHireable {
                VStack(spacing: 4) {
                    Image(systemName: "person.badge.plus")
                        .font(.caption)
                        .foregroundColor(.green)
                    
                    Text("$\(Int(ranking.hiringFee))")
                        .font(.caption2)
                        .foregroundColor(.green)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(index < 3 ? rankColor(for: index + 1).opacity(0.3) : Color.clear, lineWidth: 1)
                )
        )
        .scaleEffect(animatingNumbers ? 1.0 : 0.95)
        .animation(.bouncy(duration: 0.6).delay(Double(index) * 0.1), value: animatingNumbers)
    }
    
    private func rankColor(for rank: Int) -> Color {
        switch rank {
        case 1: return DesignSystem.primaryGold
        case 2: return .gray
        case 3: return .orange
        case 4...10: return .purple
        default: return .blue
        }
    }
    
    private var fullRankingsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("📊 Full Rankings")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.blue)
            
            VStack(spacing: 6) {
                ForEach(Array(leaderboardManager.globalRankings.dropFirst(10).enumerated()), id: \.element.id) { index, ranking in
                    compactRankingRow(ranking)
                }
            }
        }
    }
    
    private func compactRankingRow(_ ranking: BotRanking) -> some View {
        HStack {
            Text("#\(ranking.overallRank)")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
                .frame(width: 30, alignment: .leading)
            
            Text(ranking.botName)
                .font(.caption)
                .foregroundColor(.primary)
            
            Spacer()
            
            Text(ranking.performanceGrade)
                .font(.caption2)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.horizontal, 4)
                .padding(.vertical, 1)
                .background(ranking.gradeColor)
                .cornerRadius(3)
            
            Text("$\(Int(ranking.monthlyEarnings))")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.green)
                .frame(width: 60, alignment: .trailing)
        }
        .padding(.horizontal)
    }
    
    // MARK: - Alerts Tab
    
    private var alertsTab: some View {
        ScrollView {
            VStack(spacing: 16) {
                if leaderboardManager.alerts.isEmpty {
                    alertsEmptyState
                } else {
                    alertsList
                }
            }
            .padding()
        }
    }
    
    private var alertsEmptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "bell.slash")
                .font(.system(size: 48))
                .foregroundColor(.secondary)
            
            Text("No Alerts")
                .font(.headline)
                .foregroundColor(.secondary)
            
            Text("You'll see competition updates and bot notifications here!")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 50)
    }
    
    private var alertsList: some View {
        VStack(spacing: 12) {
            ForEach(leaderboardManager.alerts.sorted { $0.timestamp > $1.timestamp }) { alert in
                alertCard(alert)
            }
        }
    }
    
    private func alertCard(_ alert: CompetitionAlert) -> some View {
        Button(action: {
            leaderboardManager.markAlertAsRead(alert.id)
            HapticFeedbackManager.shared.impact(.light)
        }) {
            HStack(spacing: 12) {
                // Alert icon
                ZStack {
                    Circle()
                        .fill(alert.alertType.color.opacity(0.2))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: alert.alertType.icon)
                        .foregroundColor(alert.alertType.color)
                        .font(.system(size: 16, weight: .medium))
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(alert.title)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        if !alert.isRead {
                            Circle()
                                .fill(Color.red)
                                .frame(width: 8, height: 8)
                        }
                    }
                    
                    Text(alert.message)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                    
                    Text(alert.timestamp.formatted(.relative(presentation: .named)))
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(alert.isRead ? Color(.systemGray6) : Color(.systemBackground))
                    .shadow(color: alert.isRead ? .clear : .black.opacity(0.05), radius: 4, x: 0, y: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // MARK: - Helper Methods
    
    private func refreshData() {
        HapticFeedbackManager.shared.impact(.medium)
        // Refresh logic here
        withAnimation(.easeInOut(duration: 0.5)) {
            // Simulate refresh
        }
    }
}

// MARK: - Preview

#Preview {
    BotLeaderboardView()
}