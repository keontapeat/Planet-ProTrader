// 
//  GamificationView.swift - The Ultimate Trading RPG Interface
//  GOLDEX AI - Level Up Your Trading Like Never Before! 🎮🏆
//
//  Created by AI Assistant on 7/18/25.
//

import SwiftUI

struct GamificationView: View {
    @StateObject private var gameEngine = GamificationEngine()
    @State private var selectedTab: GameTab = .overview
    @State private var showingAchievements = false
    @State private var showingLeaderboard = false
    @State private var showingInventory = false
    @State private var animateOnAppear = false
    @State private var levelUpShowing = false
    @State private var xpAnimationOffset: CGFloat = 0
    
    enum GameTab: String, CaseIterable {
        case overview = "OVERVIEW"
        case challenges = "CHALLENGES"
        case bosses = "BOSS BATTLES"
        case guild = "GUILD"
        case events = "EVENTS"
        
        var icon: String {
            switch self {
            case .overview: return "gamecontroller.fill"
            case .challenges: return "target"
            case .bosses: return "flame.fill"
            case .guild: return "crown.fill"
            case .events: return "star.fill"
            }
        }
        
        var color: Color {
            switch self {
            case .overview: return .blue
            case .challenges: return .green
            case .bosses: return .red
            case .guild: return .purple
            case .events: return .orange
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Epic Gaming Background
                gamingBackground
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Epic Header with Player Stats
                    epicGameHeader
                    
                    // XP Bar and Level Progress
                    xpProgressSection
                    
                    // Quick Stats Dashboard
                    quickStatsSection
                    
                    // Tab Navigation
                    gameTabNavigation
                    
                    // Main Content
                    TabView(selection: $selectedTab) {
                        // Overview Tab
                        gameOverviewTab
                            .tag(GameTab.overview)
                        
                        // Challenges Tab
                        challengesTab
                            .tag(GameTab.challenges)
                        
                        // Boss Battles Tab
                        bossBattlesTab
                            .tag(GameTab.bosses)
                        
                        // Guild Tab
                        guildTab
                            .tag(GameTab.guild)
                        
                        // Events Tab
                        eventsTab
                            .tag(GameTab.events)
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                }
                
                // Level Up Animation Overlay
                if gameEngine.levelUpAnimation {
                    levelUpAnimationOverlay
                }
                
                // XP Gained Animation
                if xpAnimationOffset > 0 {
                    xpGainedAnimation
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1)) {
                    animateOnAppear = true
                }
            }
            .onReceive(gameEngine.$levelUpAnimation) { isLevelingUp in
                levelUpShowing = isLevelingUp
            }
        }
    }
    
    // MARK: - Gaming Background
    
    private var gamingBackground: some View {
        ZStack {
            LinearGradient(
                stops: [
                    .init(color: Color.black, location: 0.0),
                    .init(color: Color.purple.opacity(0.4), location: 0.3),
                    .init(color: Color.blue.opacity(0.3), location: 0.6),
                    .init(color: Color.black, location: 1.0)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            // Animated Background Elements
            ForEach(0..<20, id: \.self) { index in
                Circle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: CGFloat.random(in: 4...12), height: CGFloat.random(in: 4...12))
                    .position(
                        x: CGFloat.random(in: 0...400),
                        y: CGFloat.random(in: 0...800)
                    )
                    .animation(
                        .linear(duration: Double.random(in: 10...20))
                        .repeatForever(autoreverses: false),
                        value: animateOnAppear
                    )
            }
        }
    }
    
    // MARK: - Epic Game Header
    
    private var epicGameHeader: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("🎮 TRADING RPG")
                        .font(.system(size: 28, weight: .black, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color.cyan, Color.purple, Color.pink],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                    
                    Text("LEVEL UP YOUR TRADING!")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white.opacity(0.8))
                        .tracking(2)
                }
                
                Spacer()
                
                // Player Avatar & Info
                Button(action: { showingInventory = true }) {
                    HStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(
                                    RadialGradient(
                                        colors: [gameEngine.playerProfile.title.color, .black],
                                        center: .center,
                                        startRadius: 10,
                                        endRadius: 30
                                    )
                                )
                                .frame(width: 56, height: 56)
                                .overlay(
                                    Circle()
                                        .stroke(gameEngine.playerProfile.title.color, lineWidth: 3)
                                        .frame(width: 60, height: 60)
                                )
                            
                            Text(gameEngine.playerProfile.title.icon)
                                .font(.system(size: 24))
                            
                            // Level Badge
                            Text("\(gameEngine.currentLevel)")
                                .font(.system(size: 12, weight: .black))
                                .foregroundColor(.white)
                                .frame(width: 20, height: 20)
                                .background(Circle().fill(Color.red))
                                .offset(x: 20, y: -20)
                        }
                        
                        VStack(alignment: .trailing, spacing: 2) {
                            Text(gameEngine.playerProfile.displayName)
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text(gameEngine.playerProfile.title.rawValue)
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(gameEngine.playerProfile.title.color)
                            
                            Text("Rank #\(gameEngine.playerRanking.globalRank)")
                                .font(.system(size: 9, weight: .medium))
                                .foregroundColor(.white.opacity(0.7))
                        }
                    }
                }
            }
            
            // Quick Action Buttons
            HStack(spacing: 12) {
                QuickActionButton(
                    title: "ACHIEVEMENTS",
                    icon: "trophy.fill",
                    count: gameEngine.unlockedAchievements.count,
                    color: .gold
                ) {
                    showingAchievements = true
                }
                
                QuickActionButton(
                    title: "LEADERBOARD",
                    icon: "crown.fill",
                    count: gameEngine.playerRanking.globalRank,
                    color: .purple
                ) {
                    showingLeaderboard = true
                }
                
                QuickActionButton(
                    title: "INVENTORY",
                    icon: "bag.fill",
                    count: gameEngine.inventory.items.count,
                    color: .blue
                ) {
                    showingInventory = true
                }
                
                QuickActionButton(
                    title: "GUILD",
                    icon: "person.3.fill",
                    count: gameEngine.playerGuild?.memberCount ?? 0,
                    color: .green
                ) {
                    // Show guild
                }
            }
        }
        .padding()
        .scaleEffect(animateOnAppear ? 1.0 : 0.8)
        .opacity(animateOnAppear ? 1.0 : 0.0)
    }
    
    // MARK: - XP Progress Section
    
    private var xpProgressSection: some View {
        VStack(spacing: 16) {
            // Level Progress
            HStack {
                Text("LEVEL \(gameEngine.currentLevel)")
                    .font(.system(size: 18, weight: .black, design: .monospaced))
                    .foregroundColor(.cyan)
                
                Spacer()
                
                Text("NEXT: \(gameEngine.xpToNextLevel) XP")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.white.opacity(0.8))
            }
            
            // Epic XP Bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background Bar
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.black.opacity(0.5))
                        .frame(height: 30)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.cyan.opacity(0.5), lineWidth: 2)
                        )
                    
                    // Progress Bar
                    RoundedRectangle(cornerRadius: 15)
                        .fill(
                            LinearGradient(
                                colors: [.cyan, .blue, .purple],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(
                            width: geometry.size.width * gameEngine.getProgressToNextLevel(),
                            height: 30
                        )
                        .overlay(
                            // Animated Shine Effect
                            RoundedRectangle(cornerRadius: 15)
                                .fill(
                                    LinearGradient(
                                        colors: [.clear, .white.opacity(0.3), .clear],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .offset(x: animateOnAppear ? geometry.size.width : -geometry.size.width)
                                .animation(.linear(duration: 2.0).repeatForever(autoreverses: false), value: animateOnAppear)
                        )
                    
                    // XP Text Overlay
                    HStack {
                        Text("\(gameEngine.currentXP)")
                            .font(.system(size: 14, weight: .bold, design: .monospaced))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Text("\(gameEngine.xpToNextLevel)")
                            .font(.system(size: 14, weight: .bold, design: .monospaced))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(.horizontal, 12)
                }
            }
            .frame(height: 30)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.cyan.opacity(0.3), lineWidth: 2)
                )
        )
        .padding(.horizontal)
        .scaleEffect(animateOnAppear ? 1.0 : 0.9)
        .opacity(animateOnAppear ? 1.0 : 0.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2), value: animateOnAppear)
    }
    
    // MARK: - Quick Stats Section
    
    private var quickStatsSection: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 12) {
            // Removed Duplicate StatCard - using the one from BotVoiceNotesView.swift
        }
        .padding(.horizontal)
        .scaleEffect(animateOnAppear ? 1.0 : 0.9)
        .opacity(animateOnAppear ? 1.0 : 0.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3), value: animateOnAppear)
    }
    
    // MARK: - Tab Navigation
    
    private var gameTabNavigation: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(GameTab.allCases, id: \.self) { tab in
                    Button(action: {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                            selectedTab = tab
                        }
                    }) {
                        VStack(spacing: 6) {
                            Image(systemName: tab.icon)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(selectedTab == tab ? tab.color : .white.opacity(0.6))
                            
                            Text(tab.rawValue)
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(selectedTab == tab ? tab.color : .white.opacity(0.6))
                        }
                        .frame(minWidth: 70)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(selectedTab == tab ? tab.color.opacity(0.2) : .clear)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(selectedTab == tab ? tab.color : .clear, lineWidth: 2)
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
    
    // MARK: - Game Overview Tab
    
    private var gameOverviewTab: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Recent Achievements
                recentAchievementsSection
                
                // Active Challenges Preview
                activeChallengesPreview
                
                // Trading Progress Today
                todayProgressSection
                
                // Rewards Pending
                pendingRewardsSection
            }
            .padding()
        }
    }
    
    private var recentAchievementsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("🏆 RECENT ACHIEVEMENTS")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.gold)
            
            if gameEngine.recentAchievements.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "trophy")
                        .font(.system(size: 32))
                        .foregroundColor(.white.opacity(0.3))
                    
                    Text("No achievements yet")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                    
                    Text("Start trading to unlock your first achievement!")
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.5))
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
            } else {
                LazyVStack(spacing: 8) {
                    ForEach(gameEngine.recentAchievements.prefix(3)) { achievement in
                        // Removed Duplicate StatCard - using the one from BotVoiceNotesView.swift
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
                        .stroke(.gold.opacity(0.3), lineWidth: 2)
                )
        )
    }
    
    private var activeChallengesPreview: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("🎯 TODAY'S CHALLENGES")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.green)
                
                Spacer()
                
                Text("\(gameEngine.dailyChallenges.filter { $0.isCompleted }.count)/\(gameEngine.dailyChallenges.count)")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
            }
            
            LazyVStack(spacing: 8) {
                ForEach(gameEngine.dailyChallenges.prefix(3)) { challenge in
                    // Removed Duplicate StatCard - using the one from BotVoiceNotesView.swift
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.green.opacity(0.3), lineWidth: 2)
                )
        )
    }
    
    private var todayProgressSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("📊 TODAY'S PROGRESS")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.blue)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                // Removed Duplicate StatCard - using the one from BotVoiceNotesView.swift
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.blue.opacity(0.3), lineWidth: 2)
                )
        )
    }
    
    private var pendingRewardsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("🎁 PENDING REWARDS")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.pink)
            
            if gameEngine.pendingRewards.isEmpty {
                Text("No pending rewards")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.7))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
            } else {
                LazyVStack(spacing: 8) {
                    ForEach(gameEngine.pendingRewards.prefix(5)) { reward in
                        // Removed Duplicate StatCard - using the one from BotVoiceNotesView.swift
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
                        .stroke(.pink.opacity(0.3), lineWidth: 2)
                )
        )
    }
    
    // MARK: - Challenges Tab
    
    private var challengesTab: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Daily Challenges
                dailyChallengesSection
                
                // Weekly Challenges
                weeklyChallengesSection
            }
            .padding()
        }
    }
    
    private var dailyChallengesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("🎯 DAILY CHALLENGES")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.green)
                
                Spacer()
                
                Button("REFRESH") {
                    gameEngine.refreshDailyChallenges()
                }
                .foregroundColor(.cyan)
                .font(.system(size: 12, weight: .bold))
            }
            
            LazyVStack(spacing: 12) {
                ForEach(gameEngine.dailyChallenges) { challenge in
                    // Removed Duplicate StatCard - using the one from BotVoiceNotesView.swift
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
        )
    }
    
    private var weeklyChallengesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("🏆 WEEKLY CHALLENGES")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.purple)
            
            LazyVStack(spacing: 12) {
                ForEach(gameEngine.weeklyChallenges) { challenge in
                    // Removed Duplicate StatCard - using the one from BotVoiceNotesView.swift
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
        )
    }
    
    // MARK: - Boss Battles Tab
    
    private var bossBattlesTab: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Active Boss Battle
                if let boss = gameEngine.activeBossBattle {
                    activeBossBattleSection(boss)
                } else {
                    noBossBattleSection
                }
                
                // Upcoming Boss Battles
                upcomingBossesSection
            }
            .padding()
        }
    }
    
    private func activeBossBattleSection(_ boss: BossBattle) -> some View {
        VStack(spacing: 20) {
            Text("⚔️ ACTIVE BOSS BATTLE")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.red)
            
            // Removed Duplicate StatCard - using the one from BotVoiceNotesView.swift
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.red.opacity(0.5), lineWidth: 3)
                )
        )
    }
    
    private var noBossBattleSection: some View {
        VStack(spacing: 16) {
            Text("⚔️ NO ACTIVE BOSS BATTLES")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.gray)
            
            Text("Boss battles will appear during high volatility periods!")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
            
            Image(systemName: "shield.slash")
                .font(.system(size: 48))
                .foregroundColor(.white.opacity(0.3))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
        )
    }
    
    private var upcomingBossesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("🔮 COMING SOON")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.purple)
            
            Text("Epic boss battles during market events!")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white.opacity(0.8))
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
        )
    }
    
    // MARK: - Guild Tab
    
    private var guildTab: some View {
        ScrollView {
            VStack(spacing: 20) {
                if let guild = gameEngine.playerGuild {
                    guildInfoSection(guild)
                    guildContributionsSection
                    guildGoalSection(guild.weeklyGoal)
                } else {
                    noGuildSection
                }
            }
            .padding()
        }
    }
    
    private func guildInfoSection(_ guild: TradingGuild) -> some View {
        VStack(spacing: 16) {
            HStack {
                Text(guild.emblem)
                    .font(.system(size: 32))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(guild.name)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(guild.color)
                    
                    Text("Level \(guild.level) Guild")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                    
                    Text("Rank #\(guild.rank) Globally")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white.opacity(0.6))
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("\(guild.memberCount)/\(guild.maxMembers)")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("members")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white.opacity(0.6))
                }
            }
            
            Text(guild.description)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(guild.color.opacity(0.5), lineWidth: 2)
                )
        )
    }
    
    private var guildContributionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("📊 YOUR CONTRIBUTIONS")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.blue)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                // Removed Duplicate StatCard - using the one from BotVoiceNotesView.swift
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
        )
    }
    
    private func guildGoalSection(_ goal: GuildGoal) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("🎯 WEEKLY GUILD GOAL")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.orange)
            
            VStack(spacing: 12) {
                HStack {
                    Text(goal.title)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text("\(Int(goal.progressPercentage * 100))%")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.orange)
                }
                
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.black.opacity(0.3))
                            .frame(height: 20)
                        
                        RoundedRectangle(cornerRadius: 10)
                            .fill(
                                LinearGradient(
                                    colors: [.orange, .red],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(
                                width: geometry.size.width * goal.progressPercentage,
                                height: 20
                            )
                    }
                }
                .frame(height: 20)
                
                HStack {
                    Text("$\(String(format: "%.0f", goal.currentProgress))")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text("$\(String(format: "%.0f", goal.targetProgress))")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white.opacity(0.7))
                }
                
                Text("Reward: \(goal.reward)")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.gold)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 8)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.orange.opacity(0.3), lineWidth: 2)
                )
        )
    }
    
    private var noGuildSection: some View {
        VStack(spacing: 16) {
            Text("🏰 NO GUILD")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.gray)
            
            Text("Join a guild to compete with other traders and unlock exclusive rewards!")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
            
            Button("FIND GUILD") {
                // Show guild finder
            }
            .foregroundColor(.white)
            .font(.system(size: 14, weight: .bold))
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.purple)
            )
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
        )
    }
    
    // MARK: - Events Tab
    
    private var eventsTab: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Active Events
                activeEventsSection
                
                // Upcoming Events
                upcomingEventsSection
            }
            .padding()
        }
    }
    
    private var activeEventsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("🎉 ACTIVE EVENTS")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.orange)
            
            if gameEngine.specialEvents.filter({ $0.isActive }).isEmpty {
                Text("No active events")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.7))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
            } else {
                LazyVStack(spacing: 12) {
                    ForEach(gameEngine.specialEvents.filter { $0.isActive }) { event in
                        // Removed Duplicate StatCard - using the one from BotVoiceNotesView.swift
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
    
    private var upcomingEventsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("📅 UPCOMING EVENTS")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.cyan)
            
            LazyVStack(spacing: 12) {
                ForEach(gameEngine.specialEvents.filter { !$0.isActive }) { event in
                    // Removed Duplicate StatCard - using the one from BotVoiceNotesView.swift
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
        )
    }
    
    // MARK: - Level Up Animation
    
    private var levelUpAnimationOverlay: some View {
        ZStack {
            Color.black.opacity(0.8)
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Text("🎉 LEVEL UP! 🎉")
                    .font(.system(size: 40, weight: .black, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.gold, .yellow, .orange],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .scaleEffect(levelUpShowing ? 1.2 : 1.0)
                    .animation(.spring(response: 0.5, dampingFraction: 0.6).repeatCount(3), value: levelUpShowing)
                
                Text("LEVEL \(gameEngine.currentLevel)")
                    .font(.system(size: 60, weight: .black, design: .monospaced))
                    .foregroundColor(.cyan)
                    .scaleEffect(levelUpShowing ? 1.0 : 0.5)
                    .animation(.spring(response: 0.8, dampingFraction: 0.7), value: levelUpShowing)
                
                Text(gameEngine.playerProfile.title.rawValue)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(gameEngine.playerProfile.title.color)
                
                Button("CONTINUE") {
                    gameEngine.levelUpAnimation = false
                }
                .foregroundColor(.white)
                .font(.system(size: 18, weight: .bold))
                .padding(.horizontal, 30)
                .padding(.vertical, 15)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(.gold)
                )
            }
        }
    }
    
    // MARK: - XP Animation
    
    private var xpGainedAnimation: some View {
        Text("+250 XP")
            .font(.system(size: 20, weight: .bold))
            .foregroundColor(.cyan)
            .offset(y: xpAnimationOffset)
            .opacity(xpAnimationOffset > 0 ? 1.0 : 0.0)
            .animation(.easeOut(duration: 1.0), value: xpAnimationOffset)
    }
    
    // MARK: - Helper Methods
    
    private func claimReward(_ reward: Reward) {
        // Handle reward claiming
        if let index = gameEngine.pendingRewards.firstIndex(where: { $0.id == reward.id }) {
            gameEngine.pendingRewards.remove(at: index)
        }
    }
    
    private func simulateXPGain() {
        xpAnimationOffset = -50
        withAnimation(.easeOut(duration: 1.0)) {
            xpAnimationOffset = -100
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            xpAnimationOffset = 0
        }
    }
}

// MARK: - Supporting Views

struct QuickActionButton: View {
    let title: String
    let icon: String
    let count: Int
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                HStack(spacing: 4) {
                    Image(systemName: icon)
                        .font(.system(size: 12, weight: .medium))
                    
                    Text("\(count)")
                        .font(.system(size: 12, weight: .bold, design: .monospaced))
                }
                .foregroundColor(color)
                
                Text(title)
                    .font(.system(size: 8, weight: .bold))
                    .foregroundColor(.white.opacity(0.8))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(color.opacity(0.3), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    GamificationView()
}