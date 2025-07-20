//
//  SocialTradingView.swift - The Ultimate Trading Community
//  GOLDEX AI - Where Legends Connect & Profit Together! 🌐💰
//
//  Created by AI Assistant on 7/18/25.
//

import SwiftUI

struct SocialTradingView: View {
    @StateObject private var socialEngine = SocialTradingEngine()
    @State private var selectedTab: SocialTab = .feed
    @State private var showingTraderProfile = false
    @State private var selectedTrader: LegendaryTrader?
    @State private var animateOnAppear = false
    @State private var showingCommunity = false
    @State private var selectedCommunity: TradingCommunity?
    
    enum SocialTab: String, CaseIterable {
        case feed = "FEED"
        case leaderboard = "LEADERS"
        case copy = "COPY TRADE"
        case communities = "COMMUNITIES"
        case mentors = "MENTORS"
        
        var icon: String {
            switch self {
            case .feed: return "newspaper.fill"
            case .leaderboard: return "trophy.fill"
            case .copy: return "doc.on.doc.fill"
            case .communities: return "person.3.fill"
            case .mentors: return "graduationcap.fill"
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Social Trading Background
                socialTradingBackground
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Legendary Header
                    socialTradingHeader
                    
                    // Global Stats Bar
                    globalStatsBar
                    
                    // Tab Navigation
                    socialTabNavigation
                    
                    // Main Content
                    TabView(selection: $selectedTab) {
                        // Social Feed
                        socialFeedTab
                            .tag(SocialTab.feed)
                        
                        // Leaderboard
                        leaderboardTab
                            .tag(SocialTab.leaderboard)
                        
                        // Copy Trading
                        copyTradingTab
                            .tag(SocialTab.copy)
                        
                        // Communities
                        communitiesTab
                            .tag(SocialTab.communities)
                        
                        // Mentors
                        mentorsTab
                            .tag(SocialTab.mentors)
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                }
            }
            .navigationBarHidden(true)
            .sheet(item: $selectedTrader) { trader in
                TraderProfileSheet(trader: trader, socialEngine: socialEngine)
            }
            .sheet(item: $selectedCommunity) { community in
                CommunityDetailSheet(community: community, socialEngine: socialEngine)
            }
            .onAppear {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1)) {
                    animateOnAppear = true
                }
            }
        }
    }
    
    // MARK: - Social Trading Background
    
    private var socialTradingBackground: some View {
        LinearGradient(
            stops: [
                .init(color: Color.black, location: 0.0),
                .init(color: Color.blue.opacity(0.2), location: 0.3),
                .init(color: Color.green.opacity(0.1), location: 0.6),
                .init(color: Color.black, location: 1.0)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    // MARK: - Header
    
    private var socialTradingHeader: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("🌐 SOCIAL TRADING")
                        .font(.system(size: 28, weight: .black, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [DesignSystem.primaryGold, .white],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                    
                    Text("WHERE LEGENDS CONNECT")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white.opacity(0.8))
                        .tracking(2)
                }
                
                Spacer()
                
                // User Profile Quick Access
                Button(action: {}) {
                    HStack(spacing: 8) {
                        Circle()
                            .fill(socialEngine.currentUser.tier.color)
                            .frame(width: 32, height: 32)
                            .overlay(
                                Text(String(socialEngine.currentUser.username.prefix(2).uppercased()))
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.white)
                            )
                        
                        VStack(alignment: .trailing, spacing: 2) {
                            Text(socialEngine.currentUser.displayName)
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("LVL \(socialEngine.currentUser.level)")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(socialEngine.currentUser.tier.color)
                        }
                    }
                }
            }
            
            // Live Status Indicators
            HStack(spacing: 16) {
                LiveStatusIndicator(
                    title: "ONLINE",
                    value: "\(socialEngine.globalStats.activeTraders.formatted())",
                    color: .green,
                    icon: "person.3.fill"
                )
                
                LiveStatusIndicator(
                    title: "SIGNALS",
                    value: "\(socialEngine.globalStats.liveSignals)",
                    color: .blue,
                    icon: "bolt.fill"
                )
                
                LiveStatusIndicator(
                    title: "VOLUME",
                    value: "$\(String(format: "%.1f", socialEngine.globalStats.totalVolume))M",
                    color: .purple,
                    icon: "chart.bar.fill"
                )
                
                LiveStatusIndicator(
                    title: "SENTIMENT",
                    value: socialEngine.globalStats.marketSentiment,
                    color: socialEngine.globalStats.marketSentiment == "BULLISH" ? .green : .red,
                    icon: "arrow.up.circle.fill"
                )
            }
        }
        .padding()
        .scaleEffect(animateOnAppear ? 1.0 : 0.8)
        .opacity(animateOnAppear ? 1.0 : 0.0)
    }
    
    // MARK: - Global Stats Bar
    
    private var globalStatsBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                GlobalStatCard(
                    title: "Top Performer Today",
                    value: socialEngine.leaderboard.first?.displayName ?? "Loading...",
                    subtitle: "+\(String(format: "%.1f", socialEngine.leaderboard.first?.monthlyReturn ?? 0))%",
                    color: .gold
                )
                
                GlobalStatCard(
                    title: "Most Copied Trade",
                    value: "XAUUSD LONG",
                    subtitle: "47 copies",
                    color: .blue
                )
                
                GlobalStatCard(
                    title: "Community Growth",
                    value: "+1,247",
                    subtitle: "new members today",
                    color: .green
                )
                
                GlobalStatCard(
                    title: "Active Challenges",
                    value: "\(socialEngine.challenges.count)",
                    subtitle: "join now!",
                    color: .orange
                )
            }
            .padding(.horizontal)
        }
        .scaleEffect(animateOnAppear ? 1.0 : 0.9)
        .opacity(animateOnAppear ? 1.0 : 0.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2), value: animateOnAppear)
    }
    
    // MARK: - Tab Navigation
    
    private var socialTabNavigation: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(SocialTab.allCases, id: \.self) { tab in
                    Button(action: {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                            selectedTab = tab
                        }
                    }) {
                        VStack(spacing: 6) {
                            Image(systemName: tab.icon)
                                .font(.system(size: 16, weight: .medium))
                            
                            Text(tab.rawValue)
                                .font(.system(size: 10, weight: .bold))
                        }
                        .foregroundStyle(selectedTab == tab ? DesignSystem.primaryGold : .white.opacity(0.6))
                        .frame(minWidth: 70)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(selectedTab == tab ? DesignSystem.primaryGold.opacity(0.2) : .clear)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(selectedTab == tab ? DesignSystem.primaryGold : .clear, lineWidth: 2)
                                )
                        )
                        .scaleEffect(selectedTab == tab ? 1.05 : 1.0)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 8)
    }
    
    // MARK: - Social Feed Tab
    
    private var socialFeedTab: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(socialEngine.socialFeed) { post in
                    SocialPostCard(post: post, socialEngine: socialEngine)
                }
            }
            .padding()
        }
    }
    
    // MARK: - Leaderboard Tab
    
    private var leaderboardTab: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Top 3 Podium
                topThreePodium
                
                // Full Leaderboard
                LazyVStack(spacing: 12) {
                    ForEach(Array(socialEngine.leaderboard.enumerated()), id: \.element.id) { index, trader in
                        LeaderboardTraderCard(
                            trader: trader,
                            rank: index + 1,
                            onTap: {
                                selectedTrader = trader
                                showingTraderProfile = true
                            }
                        )
                    }
                }
            }
            .padding()
        }
    }
    
    private var topThreePodium: some View {
        VStack(spacing: 16) {
            Text("🏆 HALL OF LEGENDS")
                .font(.system(size: 20, weight: .black))
                .foregroundColor(DesignSystem.primaryGold)
            
            if socialEngine.leaderboard.count >= 3 {
                HStack(alignment: .bottom, spacing: 12) {
                    // 2nd Place
                    PodiumCard(
                        trader: socialEngine.leaderboard[1],
                        rank: 2,
                        height: 80,
                        color: .gray
                    ) {
                        selectedTrader = socialEngine.leaderboard[1]
                    }
                    
                    // 1st Place
                    PodiumCard(
                        trader: socialEngine.leaderboard[0],
                        rank: 1,
                        height: 100,
                        color: .gold
                    ) {
                        selectedTrader = socialEngine.leaderboard[0]
                    }
                    
                    // 3rd Place
                    PodiumCard(
                        trader: socialEngine.leaderboard[2],
                        rank: 3,
                        height: 60,
                        color: .orange
                    ) {
                        selectedTrader = socialEngine.leaderboard[2]
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(DesignSystem.primaryGold.opacity(0.3), lineWidth: 2)
                )
        )
    }
    
    // MARK: - Copy Trading Tab
    
    private var copyTradingTab: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Copy Trading Stats
                copyTradingStats
                
                // Available Copy Traders
                availableCopyTraders
                
                // Active Copy Trades
                activeCopyTrades
            }
            .padding()
        }
    }
    
    private var copyTradingStats: some View {
        VStack(spacing: 16) {
            Text("📊 COPY TRADING PERFORMANCE")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(DesignSystem.primaryGold)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                CopyStatCard(
                    title: "Total Copied",
                    value: "\(socialEngine.copyTradingPerformance.totalCopiedTrades)",
                    color: .blue,
                    icon: "doc.on.doc.fill"
                )
                
                CopyStatCard(
                    title: "Total Profit",
                    value: "$\(String(format: "%.2f", socialEngine.copyTradingPerformance.totalProfit))",
                    color: .green,
                    icon: "dollarsign.circle.fill"
                )
                
                CopyStatCard(
                    title: "Win Rate",
                    value: "\(Int(socialEngine.copyTradingPerformance.winRate * 100))%",
                    color: .purple,
                    icon: "target"
                )
                
                CopyStatCard(
                    title: "Monthly Return",
                    value: "\(String(format: "%.1f", socialEngine.copyTradingPerformance.monthlyReturn))%",
                    color: .orange,
                    icon: "chart.line.uptrend.xyaxis"
                )
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
        )
    }
    
    private var availableCopyTraders: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("🤖 TOP COPY TRADERS")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(DesignSystem.primaryGold)
            
            LazyVStack(spacing: 12) {
                ForEach(socialEngine.leaderboard.prefix(5)) { trader in
                    CopyTraderCard(trader: trader, socialEngine: socialEngine)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
        )
    }
    
    private var activeCopyTrades: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("⚡ ACTIVE COPY TRADES")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(DesignSystem.primaryGold)
            
            if socialEngine.activeCopyTrades.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "doc.on.doc")
                        .font(.system(size: 32))
                        .foregroundColor(.white.opacity(0.3))
                    
                    Text("No active copy trades")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                    
                    Text("Start copying legendary traders!")
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.5))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
            } else {
                LazyVStack(spacing: 8) {
                    ForEach(socialEngine.activeCopyTrades) { copyTrade in
                        ActiveCopyTradeCard(copyTrade: copyTrade)
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
        )
    }
    
    // MARK: - Communities Tab
    
    private var communitiesTab: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Featured Communities
                featuredCommunities
                
                // All Communities
                allCommunities
            }
            .padding()
        }
    }
    
    private var featuredCommunities: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("⭐ FEATURED COMMUNITIES")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(DesignSystem.primaryGold)
            
            LazyVStack(spacing: 12) {
                ForEach(socialEngine.tradingCommunities.prefix(3)) { community in
                    FeaturedCommunityCard(community: community) {
                        selectedCommunity = community
                        showingCommunity = true
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
        )
    }
    
    private var allCommunities: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("🌐 ALL COMMUNITIES")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(DesignSystem.primaryGold)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                ForEach(socialEngine.tradingCommunities) { community in
                    CommunityCard(community: community) {
                        socialEngine.joinCommunity(community)
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
        )
    }
    
    // MARK: - Mentors Tab
    
    private var mentorsTab: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Mentorship Overview
                mentorshipOverview
                
                // Available Mentors
                availableMentors
            }
            .padding()
        }
    }
    
    private var mentorshipOverview: some View {
        VStack(spacing: 16) {
            Text("🎓 LEGENDARY MENTORSHIP")
                .font(.system(size: 20, weight: .black))
                .foregroundColor(DesignSystem.primaryGold)
            
            Text("Learn from the world's most successful traders")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
            
            HStack(spacing: 20) {
                MentorStatCard(title: "Active Mentors", value: "12", color: .blue)
                MentorStatCard(title: "Success Rate", value: "94%", color: .green)
                MentorStatCard(title: "Students", value: "2,847", color: .purple)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(DesignSystem.primaryGold.opacity(0.3), lineWidth: 2)
                )
        )
    }
    
    private var availableMentors: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("👨‍🏫 AVAILABLE PROGRAMS")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(DesignSystem.primaryGold)
            
            LazyVStack(spacing: 16) {
                ForEach(socialEngine.mentorPrograms) { program in
                    MentorProgramCard(program: program, socialEngine: socialEngine)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
        )
    }
}

// MARK: - Supporting Views

struct LiveStatusIndicator: View {
    let title: String
    let value: String
    let color: Color
    let icon: String
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(color)
            
            Text(value)
                .font(.system(size: 12, weight: .black, design: .monospaced))
                .foregroundColor(.white)
            
            Text(title)
                .font(.system(size: 8, weight: .bold))
                .foregroundColor(.white.opacity(0.6))
                .tracking(0.5)
        }
    }
}

struct GlobalStatCard: View {
    let title: String
    let value: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 6) {
            Text(title)
                .font(.system(size: 10, weight: .semibold))
                .foregroundColor(.white.opacity(0.7))
            
            Text(value)
                .font(.system(size: 14, weight: .black))
                .foregroundColor(color)
            
            Text(subtitle)
                .font(.system(size: 8, weight: .medium))
                .foregroundColor(.white.opacity(0.5))
        }
        .frame(width: 120)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

struct SocialPostCard: View {
    let post: TradingPost
    let socialEngine: SocialTradingEngine
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Post Header
            HStack(spacing: 12) {
                // Trader Avatar
                Circle()
                    .fill(post.trader.tier.color)
                    .frame(width: 48, height: 48)
                    .overlay(
                        Text(String(post.trader.username.prefix(2).uppercased()))
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                    )
                    .overlay(
                        Circle()
                            .stroke(post.trader.tier.color, lineWidth: 2)
                            .frame(width: 52, height: 52)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 8) {
                        Text(post.trader.displayName)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                        
                        if post.trader.verificationBadges.contains(.verified) {
                            Image(systemName: "checkmark.seal.fill")
                                .font(.system(size: 12))
                                .foregroundColor(.blue)
                        }
                        
                        Text(post.trader.tier.rawValue)
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(post.trader.tier.color)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(post.trader.tier.color.opacity(0.2))
                            )
                    }
                    
                    HStack {
                        Text(timeAgo(post.timestamp))
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white.opacity(0.6))
                        
                        if post.isLive {
                            HStack(spacing: 4) {
                                Circle()
                                    .fill(.green)
                                    .frame(width: 8, height: 8)
                                
                                Text("LIVE")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundColor(.green)
                            }
                        }
                    }
                }
                
                Spacer()
                
                Button(action: {
                    socialEngine.followTrader(post.trader)
                }) {
                    Text(socialEngine.followingTraders.contains(post.trader) ? "FOLLOWING" : "FOLLOW")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(socialEngine.followingTraders.contains(post.trader) ? .white : .black)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(socialEngine.followingTraders.contains(post.trader) ? .gray : DesignSystem.primaryGold)
                        )
                }
            }
            
            // Post Content
            Text(post.content)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.white)
                .lineLimit(nil)
            
            // Trade Details (if applicable)
            if let tradeDetails = post.tradeDetails {
                tradeDetailsSection(tradeDetails, performance: post.performance)
            }
            
            // Post Tags
            if !post.tags.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(post.tags, id: \.self) { tag in
                            Text(tag)
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(.blue)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(.blue.opacity(0.2))
                                )
                        }
                    }
                    .padding(.horizontal, 1)
                }
            }
            
            // Post Actions
            HStack(spacing: 24) {
                PostActionButton(
                    icon: "heart.fill",
                    count: post.likes,
                    color: .red
                ) {
                    socialEngine.likePost(post)
                }
                
                PostActionButton(
                    icon: "message.fill",
                    count: post.comments,
                    color: .blue
                ) {
                    // Handle comment action
                }
                
                PostActionButton(
                    icon: "square.and.arrow.up.fill",
                    count: post.shares,
                    color: .green
                ) {
                    // Handle share action
                }
                
                if post.tradeDetails != nil {
                    Spacer()
                    
                    Button(action: {
                        socialEngine.copyTrade(post)
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: "doc.on.doc.fill")
                                .font(.system(size: 12, weight: .medium))
                            
                            Text("COPY (\(post.copiers))")
                                .font(.system(size: 12, weight: .bold))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(DesignSystem.primaryGold)
                        )
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.white.opacity(0.1), lineWidth: 1)
                )
        )
    }
    
    private func tradeDetailsSection(_ tradeDetails: TradeDetails, performance: TradePerformance?) -> some View {
        VStack(spacing: 12) {
            HStack {
                Text(tradeDetails.symbol)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                
                Text(tradeDetails.direction.rawValue)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .fill(tradeDetails.direction.color)
                    )
                
                Spacer()
                
                Text("Confidence: \(Int(tradeDetails.confidence * 100))%")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.green)
            }
            
            HStack(spacing: 20) {
                TradeDetailItem(title: "Entry", value: String(format: "%.2f", tradeDetails.entryPrice))
                TradeDetailItem(title: "SL", value: String(format: "%.2f", tradeDetails.stopLoss))
                TradeDetailItem(title: "TP", value: String(format: "%.2f", tradeDetails.takeProfit))
                TradeDetailItem(title: "Size", value: String(format: "%.2f", tradeDetails.lotSize))
            }
            
            if let performance = performance {
                HStack {
                    Text("Current P&L:")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                    
                    Spacer()
                    
                    Text("$\(String(format: "%.2f", performance.currentPnL))")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(performance.currentPnL >= 0 ? .green : .red)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill((performance.currentPnL >= 0 ? Color.green : Color.red).opacity(0.1))
                )
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.black.opacity(0.3))
        )
    }
    
    private func timeAgo(_ date: Date) -> String {
        let interval = Date().timeIntervalSince(date)
        
        if interval < 60 {
            return "Now"
        } else if interval < 3600 {
            return "\(Int(interval / 60))m ago"
        } else if interval < 86400 {
            return "\(Int(interval / 3600))h ago"
        } else {
            let days = Int(interval / 86400)
            return "\(days)d ago"
        }
    }
}

struct TradeDetailItem: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.white.opacity(0.7))
            
            Text(value)
                .font(.system(size: 12, weight: .bold, design: .monospaced))
                .foregroundColor(.white)
        }
    }
}

struct PostActionButton: View {
    let icon: String
    let count: Int
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(color)
                
                Text("\(count)")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
            }
        }
    }
}

struct PodiumCard: View {
    let trader: LegendaryTrader
    let rank: Int
    let height: CGFloat
    let color: Color
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                Circle()
                    .fill(color)
                    .frame(width: 60, height: 60)
                    .overlay(
                        Text(String(trader.username.prefix(2).uppercased()))
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                    )
                    .overlay(
                        Text("\(rank)")
                            .font(.system(size: 12, weight: .black))
                            .foregroundColor(.white)
                            .frame(width: 20, height: 20)
                            .background(Circle().fill(.black.opacity(0.7)))
                            .offset(x: 20, y: -20)
                    )
                
                Text(trader.displayName)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.white)
                    .lineLimit(1)
                
                Text("+\(String(format: "%.1f", trader.monthlyReturn))%")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(color)
            }
            .frame(maxWidth: .infinity)
            .frame(height: height)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(color.opacity(0.5), lineWidth: 2)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// Additional supporting views would continue here...
// This is getting quite long, so I'll include key remaining views

struct LeaderboardTraderCard: View {
    let trader: LegendaryTrader
    let rank: Int
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                Text("#\(rank)")
                    .font(.system(size: 18, weight: .black, design: .monospaced))
                    .foregroundColor(rank <= 3 ? .gold : .white.opacity(0.7))
                    .frame(width: 40)
                
                Circle()
                    .fill(trader.tier.color)
                    .frame(width: 40, height: 40)
                    .overlay(
                        Text(String(trader.username.prefix(2).uppercased()))
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(trader.displayName)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("\(trader.followers.formatted()) followers")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.white.opacity(0.6))
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("+\(String(format: "%.1f", trader.monthlyReturn))%")
                        .font(.system(size: 16, weight: .black))
                        .foregroundColor(.green)
                    
                    Text("Win: \(Int(trader.winRate * 100))%")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(rank <= 3 ? Color.gold.opacity(0.5) : Color.clear, lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// Placeholder views for the remaining components
struct CopyStatCard: View {
    let title: String
    let value: String
    let color: Color
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(color)
            
            Text(value)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
            
            Text(title)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.white.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
        .padding()
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

struct CopyTraderCard: View {
    let trader: LegendaryTrader
    let socialEngine: SocialTradingEngine
    
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(trader.tier.color)
                .frame(width: 48, height: 48)
                .overlay(
                    Text(String(trader.username.prefix(2).uppercased()))
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(trader.displayName)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                
                Text("Win Rate: \(Int(trader.winRate * 100))%")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.green)
                
                Text("\(trader.copiers.formatted()) copiers")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.white.opacity(0.6))
            }
            
            Spacer()
            
            Button("COPY") {
                // Handle copy trader
            }
            .foregroundColor(.white)
            .font(.system(size: 12, weight: .bold))
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(DesignSystem.primaryGold)
            )
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
        )
    }
}

// Additional placeholder views for communities, mentors, etc.
struct FeaturedCommunityCard: View {
    let community: TradingCommunity
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(community.name)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text(community.tier.rawValue)
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(community.tier.color)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(community.tier.color.opacity(0.2))
                        )
                }
                
                Text(community.description)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
                    .lineLimit(2)
                
                HStack {
                    Text("\(community.memberCount.formatted()) members")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.white.opacity(0.6))
                    
                    Spacer()
                    
                    Text("+\(String(format: "%.1f", community.monthlyPerformance))%")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.green)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(community.tier.color.opacity(0.3), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// More placeholder views...
struct CommunityCard: View {
    let community: TradingCommunity
    let onJoin: () -> Void
    
    var body: some View {
        VStack(spacing: 8) {
            Text(community.name)
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.white)
                .lineLimit(2)
                .multilineTextAlignment(.center)
            
            Text("\(community.memberCount.formatted())")
                .font(.system(size: 16, weight: .black))
                .foregroundColor(community.tier.color)
            
            Text("members")
                .font(.system(size: 8, weight: .medium))
                .foregroundColor(.white.opacity(0.6))
            
            Button("JOIN") {
                onJoin()
            }
            .foregroundColor(.white)
            .font(.system(size: 10, weight: .bold))
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(community.tier.color)
            )
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
        )
    }
}

struct MentorStatCard: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(color)
            
            Text(title)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.white.opacity(0.7))
        }
    }
}

struct MentorProgramCard: View {
    let program: MentorProgram
    let socialEngine: SocialTradingEngine
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Circle()
                    .fill(program.mentor.tier.color)
                    .frame(width: 48, height: 48)
                    .overlay(
                        Text(String(program.mentor.username.prefix(2).uppercased()))
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(program.title)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("by \(program.mentor.displayName)")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("$\(String(format: "%.0f", program.price))")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(DesignSystem.primaryGold)
                    
                    HStack(spacing: 4) {
                        ForEach(0..<5, id: \.self) { index in
                            Image(systemName: index < Int(program.rating) ? "star.fill" : "star")
                                .font(.system(size: 10))
                                .foregroundColor(.yellow)
                        }
                    }
                }
            }
            
            Text(program.description)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.white.opacity(0.8))
                .lineLimit(2)
            
            HStack {
                Text("\(program.duration) weeks")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.white.opacity(0.6))
                
                Text("•")
                    .foregroundColor(.white.opacity(0.4))
                
                Text("\(program.studentsCount) students")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.white.opacity(0.6))
                
                Spacer()
                
                Button("ENROLL NOW") {
                    socialEngine.enrollInMentor(program)
                }
                .foregroundColor(.white)
                .font(.system(size: 12, weight: .bold))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(DesignSystem.primaryGold)
                )
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(DesignSystem.primaryGold.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

struct ActiveCopyTradeCard: View {
    let copyTrade: CopyTrade
    
    var body: some View {
        HStack(spacing: 12) {
            Text(copyTrade.tradeDetails.symbol)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white)
            
            Text(copyTrade.tradeDetails.direction.rawValue)
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(.white)
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .fill(copyTrade.tradeDetails.direction.color)
                )
            
            Spacer()
            
            Text("Size: \(String(format: "%.2f", copyTrade.copiedLotSize))")
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.white.opacity(0.7))
            
            Text("RUNNING")
                .font(.system(size: 8, weight: .bold))
                .foregroundColor(.green)
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(.ultraThinMaterial)
        )
    }
}

struct TraderProfileSheet: View {
    let trader: LegendaryTrader
    let socialEngine: SocialTradingEngine
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Trader Profile")
                        .font(.title)
                        .padding()
                    
                    Text("Full trader profile coming soon...")
                        .foregroundColor(.secondary)
                    
                    Spacer()
                }
            }
            .navigationTitle(trader.displayName)
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

struct CommunityDetailSheet: View {
    let community: TradingCommunity
    let socialEngine: SocialTradingEngine
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Community Details")
                        .font(.title)
                        .padding()
                    
                    Text("Full community details coming soon...")
                        .foregroundColor(.secondary)
                    
                    Spacer()
                }
            }
            .navigationTitle(community.name)
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

#Preview {
    SocialTradingView()
}