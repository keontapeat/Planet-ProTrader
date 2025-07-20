//
//  BotLeaderboardView.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 1/25/25.
//

import SwiftUI

struct BotLeaderboardView: View {
    @State private var selectedCategory: BotLeaderboard.LeaderboardCategory = .overall
    @State private var selectedTimeframe: BotLeaderboard.Timeframe = .daily
    @State private var leaderboards = BotLeaderboard.sampleLeaderboards
    @State private var isRefreshing = false
    @State private var showFilters = false
    @State private var animateEntries = false
    
    var filteredLeaderboard: BotLeaderboard? {
        return leaderboards.first { $0.category == selectedCategory && $0.timeframe == selectedTimeframe }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 0) {
                    // Header Stats
                    headerStatsView
                    
                    // Category Selector
                    categorySelector
                    
                    // Timeframe Selector
                    timeframeSelector
                    
                    // Live Update Status
                    liveStatusView
                    
                    // Leaderboard Content
                    if let leaderboard = filteredLeaderboard {
                        leaderboardContent(leaderboard)
                    } else {
                        loadingView
                    }
                }
                .padding(.horizontal)
            }
            .navigationTitle("🏆 Bot Arena")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showFilters.toggle() }) {
                        Image(systemName: "slider.horizontal.3")
                            .foregroundColor(.primary)
                    }
                }
            }
            .refreshable {
                await refreshLeaderboards()
            }
        }
        .onAppear {
            startAnimations()
        }
        .sheet(isPresented: $showFilters) {
            FilterSheet(
                selectedCategory: $selectedCategory,
                selectedTimeframe: $selectedTimeframe
            )
        }
    }
    
    private var headerStatsView: some View {
        VStack(spacing: 16) {
            HStack(spacing: 20) {
                StatCard(
                    title: "Active Bots",
                    value: "847",
                    icon: "brain.head.profile",
                    color: .blue,
                    trend: "+23"
                )
                
                StatCard(
                    title: "Total Volume",
                    value: "$2.4M",
                    icon: "chart.line.uptrend.xyaxis",
                    color: .green,
                    trend: "+12.3%"
                )
                
                StatCard(
                    title: "Live Battles",
                    value: "156",
                    icon: "flame.fill",
                    color: .red,
                    trend: "🔥"
                )
            }
            
            // Championship Banner
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("🏆 SEASON 3 CHAMPIONSHIP")
                        .font(.caption.bold())
                        .foregroundColor(.white)
                    
                    Text("Prize Pool: $50,000")
                        .font(.headline.bold())
                        .foregroundColor(.white)
                    
                    Text("Ends in 6d 14h 22m")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                }
                
                Spacer()
                
                VStack {
                    Image(systemName: "crown.fill")
                        .font(.title)
                        .foregroundColor(.yellow)
                    
                    Text("JOIN")
                        .font(.caption.bold())
                        .foregroundColor(.white)
                }
            }
            .padding()
            .background(
                LinearGradient(
                    colors: [.purple, .blue, .purple],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(15)
        }
        .padding(.bottom, 20)
    }
    
    private var categorySelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(BotLeaderboard.LeaderboardCategory.allCases, id: \.self) { category in
                    CategoryChip(
                        category: category,
                        isSelected: selectedCategory == category
                    ) {
                        withAnimation(.spring()) {
                            selectedCategory = category
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.bottom, 16)
    }
    
    private var timeframeSelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(BotLeaderboard.Timeframe.allCases, id: \.self) { timeframe in
                    TimeframeChip(
                        timeframe: timeframe,
                        isSelected: selectedTimeframe == timeframe
                    ) {
                        withAnimation(.spring()) {
                            selectedTimeframe = timeframe
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.bottom, 16)
    }
    
    private var liveStatusView: some View {
        HStack {
            HStack(spacing: 6) {
                Circle()
                    .fill(.green)
                    .frame(width: 8, height: 8)
                    .scaleEffect(animateEntries ? 1.2 : 1.0)
                    .animation(.easeInOut(duration: 1).repeatForever(), value: animateEntries)
                
                Text("LIVE UPDATES")
                    .font(.caption.bold())
                    .foregroundColor(.green)
            }
            
            Spacer()
            
            Text("Updated 2s ago")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal)
        .padding(.bottom, 16)
    }
    
    private func leaderboardContent(_ leaderboard: BotLeaderboard) -> some View {
        VStack(spacing: 0) {
            // Top 3 Podium
            if leaderboard.entries.count >= 3 {
                podiumView(leaderboard.topThree)
                    .padding(.bottom, 24)
            }
            
            // Rankings List
            VStack(spacing: 0) {
                ForEach(Array(leaderboard.entries.enumerated()), id: \.element.id) { index, entry in
                    LeaderboardEntryRow(
                        entry: entry,
                        showBackground: index % 2 == 0,
                        animationDelay: Double(index) * 0.05
                    )
                    .opacity(animateEntries ? 1 : 0)
                    .offset(x: animateEntries ? 0 : 50)
                    .animation(
                        .spring(dampingFraction: 0.8)
                        .delay(Double(index) * 0.05),
                        value: animateEntries
                    )
                }
            }
            .background(.ultraThinMaterial)
            .cornerRadius(15)
        }
    }
    
    private func podiumView(_ topThree: [LeaderboardEntry]) -> some View {
        HStack(alignment: .bottom, spacing: 16) {
            // 2nd Place
            if topThree.count > 1 {
                PodiumPosition(
                    entry: topThree[1],
                    position: 2,
                    height: 80,
                    color: .gray
                )
            }
            
            // 1st Place
            if !topThree.isEmpty {
                PodiumPosition(
                    entry: topThree[0],
                    position: 1,
                    height: 100,
                    color: .gold
                )
            }
            
            // 3rd Place
            if topThree.count > 2 {
                PodiumPosition(
                    entry: topThree[2],
                    position: 3,
                    height: 60,
                    color: Color(.systemBrown)
                )
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(.ultraThinMaterial)
        )
    }
    
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)
            
            Text("Loading Elite Rankings...")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(height: 200)
    }
    
    private func startAnimations() {
        withAnimation(.easeInOut(duration: 0.6)) {
            animateEntries = true
        }
    }
    
    @MainActor
    private func refreshLeaderboards() async {
        isRefreshing = true
        
        // Simulate API call
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        // Update with new data (simulated)
        withAnimation {
            // Shuffle rankings slightly for demo
            if var leaderboard = filteredLeaderboard {
                var updatedEntries = leaderboard.entries
                if updatedEntries.count > 1 {
                    updatedEntries.swapAt(0, 1)
                }
                // Update leaderboard...
            }
        }
        
        isRefreshing = false
    }
}

// MARK: - Supporting Views

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    let trend: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.headline.bold())
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(trend)
                .font(.caption.bold())
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(12)
    }
}

struct CategoryChip: View {
    let category: BotLeaderboard.LeaderboardCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Text(category.emoji)
                    .font(.caption)
                
                Text(category.displayName.replacingOccurrences(of: category.emoji + " ", with: ""))
                    .font(.caption.bold())
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(isSelected ? category.color : .ultraThinMaterial)
            .foregroundColor(isSelected ? .white : .primary)
            .cornerRadius(20)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct TimeframeChip: View {
    let timeframe: BotLeaderboard.Timeframe
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(timeframe.displayName)
                .font(.caption.bold())
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? .blue : .ultraThinMaterial)
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(15)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct PodiumPosition: View {
    let entry: LeaderboardEntry
    let position: Int
    let height: CGFloat
    let color: Color
    @State private var animate = false
    
    var body: some View {
        VStack(spacing: 8) {
            // Bot Avatar/Icon
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Text(entry.botPersonality.emoji)
                    .font(.title2)
            }
            .scaleEffect(animate ? 1.1 : 1.0)
            .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: animate)
            
            Text(entry.botName)
                .font(.caption.bold())
                .multilineTextAlignment(.center)
            
            Text(entry.formattedScore)
                .font(.caption2.bold())
                .foregroundColor(color)
            
            // Podium Base
            Rectangle()
                .fill(color)
                .frame(width: 60, height: height)
                .cornerRadius(8, corners: [.topLeft, .topRight])
                .overlay(
                    Text("\(position)")
                        .font(.title.bold())
                        .foregroundColor(.white)
                )
        }
        .onAppear {
            animate = position == 1 // Only animate the winner
        }
    }
}

struct LeaderboardEntryRow: View {
    let entry: LeaderboardEntry
    let showBackground: Bool
    let animationDelay: Double
    @State private var showDetails = false
    
    var body: some View {
        Button(action: { showDetails = true }) {
            HStack(spacing: 12) {
                // Rank
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(rankColor.opacity(0.2))
                        .frame(width: 35, height: 35)
                    
                    Text("#\(entry.rank)")
                        .font(.system(.caption, design: .monospaced).bold())
                        .foregroundColor(rankColor)
                }
                
                // Rank Change Indicator
                VStack {
                    Image(systemName: entry.rankChange.systemImage)
                        .font(.caption)
                        .foregroundColor(entry.rankChange.color)
                    
                    Text(entry.rankChange.displayText)
                        .font(.caption2.bold())
                        .foregroundColor(entry.rankChange.color)
                }
                .frame(width: 30)
                
                // Bot Info
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        Text(entry.botPersonality.emoji)
                            .font(.subheadline)
                        
                        Text(entry.botName)
                            .font(.subheadline.bold())
                        
                        if entry.isActiveNow {
                            Circle()
                                .fill(.green)
                                .frame(width: 6, height: 6)
                        }
                        
                        Spacer()
                    }
                    
                    HStack(spacing: 12) {
                        HStack(spacing: 4) {
                            Image(systemName: "target")
                                .font(.caption2)
                                .foregroundColor(.blue)
                            Text(entry.formattedWinRate)
                                .font(.caption)
                                .foregroundColor(.blue)
                        }
                        
                        HStack(spacing: 4) {
                            Image(systemName: "chart.line.uptrend.xyaxis")
                                .font(.caption2)
                                .foregroundColor(.green)
                            Text("\(entry.totalTrades)")
                                .font(.caption)
                                .foregroundColor(.green)
                        }
                        
                        if entry.streak > 0 {
                            HStack(spacing: 4) {
                                Image(systemName: "flame.fill")
                                    .font(.caption2)
                                    .foregroundColor(.orange)
                                Text("\(entry.streak)")
                                    .font(.caption.bold())
                                    .foregroundColor(.orange)
                            }
                        }
                        
                        Spacer()
                    }
                }
                
                // Score & Trend
                VStack(alignment: .trailing, spacing: 4) {
                    Text(entry.formattedScore)
                        .font(.subheadline.bold())
                        .foregroundColor(entry.score > 0 ? .green : .red)
                    
                    HStack(spacing: 2) {
                        Image(systemName: entry.metric.trend.systemImage)
                            .font(.caption2)
                            .foregroundColor(entry.metric.trend.color)
                        
                        Text("+$123")
                            .font(.caption2)
                            .foregroundColor(entry.metric.trend.color)
                    }
                }
            }
            .padding()
            .background(showBackground ? .ultraThinMaterial.opacity(0.5) : .clear)
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showDetails) {
            BotDetailSheet(entry: entry)
        }
    }
    
    private var rankColor: Color {
        switch entry.rank {
        case 1: return .gold
        case 2: return .gray
        case 3: return Color(.systemBrown)
        case 4...10: return .blue
        default: return .secondary
        }
    }
}

struct BotDetailSheet: View {
    let entry: LeaderboardEntry
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Bot Header
                    VStack(spacing: 12) {
                        Text(entry.botPersonality.emoji)
                            .font(.system(size: 60))
                        
                        Text(entry.botName)
                            .font(.title.bold())
                        
                        Text("#\(entry.rank) • \(entry.botPersonality.displayName)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        HStack(spacing: 16) {
                            StatBadge(title: "Win Rate", value: entry.formattedWinRate, color: .blue)
                            StatBadge(title: "Trades", value: "\(entry.totalTrades)", color: .green)
                            StatBadge(title: "Streak", value: "\(entry.streak)", color: .orange)
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(15)
                    
                    // Performance Metrics
                    VStack(alignment: .leading, spacing: 12) {
                        Text("📊 Performance Metrics")
                            .font(.headline.bold())
                        
                        MetricRow(title: "Profit/Loss", value: entry.formattedProfitLoss)
                        MetricRow(title: "Risk Score", value: String(format: "%.1f/10", entry.riskScore * 10))
                        MetricRow(title: "Consistency", value: String(format: "%.1f%%", entry.consistency * 100))
                        MetricRow(title: "Volume", value: "$\(String(format: "%.0f", entry.volume))")
                        MetricRow(title: "Speed", value: String(format: "%.1f trades/min", entry.speed))
                        MetricRow(title: "Innovation", value: String(format: "%.1f/10", entry.innovation * 10))
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(15)
                    
                    // Achievements
                    if !entry.badges.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("🏆 Achievements")
                                .font(.headline.bold())
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                                ForEach(entry.badges.prefix(4)) { achievement in
                                    AchievementBadge(achievement: achievement)
                                }
                            }
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(15)
                    }
                }
                .padding()
            }
            .navigationTitle("Bot Details")
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

struct StatBadge: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.headline.bold())
                .foregroundColor(color)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(minWidth: 60)
    }
}

struct MetricRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline)
            
            Spacer()
            
            Text(value)
                .font(.subheadline.bold())
                .foregroundColor(.blue)
        }
    }
}

struct AchievementBadge: View {
    let achievement: Achievement
    
    var body: some View {
        VStack(spacing: 6) {
            Text(achievement.emoji)
                .font(.title2)
            
            Text(achievement.name)
                .font(.caption.bold())
                .multilineTextAlignment(.center)
            
            Text(achievement.tier.displayName)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding(8)
        .frame(minWidth: 80, minHeight: 80)
        .background(achievement.rarity.color.opacity(0.1))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(achievement.rarity.color, lineWidth: 1)
        )
    }
}

struct FilterSheet: View {
    @Binding var selectedCategory: BotLeaderboard.LeaderboardCategory
    @Binding var selectedTimeframe: BotLeaderboard.Timeframe
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Category")
                        .font(.headline.bold())
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                        ForEach(BotLeaderboard.LeaderboardCategory.allCases, id: \.self) { category in
                            Button(action: { selectedCategory = category }) {
                                HStack {
                                    Text(category.emoji)
                                    Text(category.displayName.replacingOccurrences(of: category.emoji + " ", with: ""))
                                        .font(.subheadline.bold())
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(selectedCategory == category ? category.color : .ultraThinMaterial)
                                .foregroundColor(selectedCategory == category ? .white : .primary)
                                .cornerRadius(10)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Timeframe")
                        .font(.headline.bold())
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                        ForEach(BotLeaderboard.Timeframe.allCases, id: \.self) { timeframe in
                            Button(action: { selectedTimeframe = timeframe }) {
                                Text(timeframe.displayName)
                                    .font(.subheadline.bold())
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(selectedTimeframe == timeframe ? .blue : .ultraThinMaterial)
                                    .foregroundColor(selectedTimeframe == timeframe ? .white : .primary)
                                    .cornerRadius(10)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Filters")
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

// Extension for corner radius on specific corners
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    BotLeaderboardView()
}