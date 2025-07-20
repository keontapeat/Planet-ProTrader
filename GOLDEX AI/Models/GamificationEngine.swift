//
//  GamificationEngine.swift - The Ultimate Trading RPG System
//  GOLDEX AI - Level Up Your Trading Like a Video Game! 🎮🏆
//
//  Created by AI Assistant on 7/18/25.
//

import SwiftUI
import Foundation
import Combine

@MainActor
class GamificationEngine: ObservableObject {
    
    // MARK: - Player Profile
    @Published var playerProfile: TradingPlayer = TradingPlayer.defaultPlayer
    @Published var currentSeason: TradingSeason = TradingSeason.current
    
    // MARK: - XP & Leveling System
    @Published var currentXP: Int = 0
    @Published var currentLevel: Int = 1
    @Published var xpToNextLevel: Int = 1000
    @Published var totalXPEarned: Int = 0
    @Published var levelUpAnimation = false
    
    // MARK: - Achievement System
    @Published var unlockedAchievements: [TradingAchievement] = []
    @Published var availableAchievements: [TradingAchievement] = []
    @Published var recentAchievements: [TradingAchievement] = []
    @Published var achievementProgress: [String: Double] = [:]
    
    // MARK: - Daily/Weekly Challenges
    @Published var dailyChallenges: [DailyChallenge] = []
    @Published var weeklyChallenges: [WeeklyChallenge] = []
    @Published var completedChallenges: [String] = []
    @Published var challengeStreak: Int = 0
    
    // MARK: - Boss Battles & Special Events
    @Published var activeBossBattle: BossBattle?
    @Published var specialEvents: [SpecialEvent] = []
    @Published var eventParticipation: [String: EventProgress] = [:]
    
    // MARK: - Rewards & Inventory
    @Published var inventory: TradingInventory = TradingInventory()
    @Published var availableRewards: [Reward] = []
    @Published var pendingRewards: [Reward] = []
    
    // MARK: - Leaderboards & Competition
    @Published var globalLeaderboard: [LeaderboardEntry] = []
    @Published var weeklyLeaderboard: [LeaderboardEntry] = []
    @Published var friendsLeaderboard: [LeaderboardEntry] = []
    @Published var playerRanking: PlayerRanking = PlayerRanking.defaultRanking
    
    // MARK: - Streaks & Consistency
    @Published var tradingStreaks: TradingStreaks = TradingStreaks()
    @Published var consistencyScore: Double = 0.75
    @Published var disciplineRating: Double = 0.82
    
    // MARK: - Guilds & Teams
    @Published var playerGuild: TradingGuild?
    @Published var guildContributions: GuildContributions = GuildContributions()
    @Published var guildEvents: [GuildEvent] = []
    
    private var updateTimer: Timer?
    
    init() {
        setupDefaultData()
        startRealTimeUpdates()
    }
    
    deinit {
        updateTimer?.invalidate()
    }
    
    // MARK: - Setup & Data Loading
    
    private func setupDefaultData() {
        loadPlayerProfile()
        loadAchievements()
        loadDailyChallenges()
        loadWeeklyChallenges()
        loadSpecialEvents()
        loadLeaderboards()
        loadGuildData()
    }
    
    private func loadPlayerProfile() {
        // Load from UserDefaults or create new player
        if let savedXP = UserDefaults.standard.object(forKey: "playerXP") as? Int {
            currentXP = savedXP
            totalXPEarned = UserDefaults.standard.integer(forKey: "totalXPEarned")
            currentLevel = calculateLevel(from: totalXPEarned)
            xpToNextLevel = calculateXPToNextLevel(currentLevel)
        }
        
        playerProfile = TradingPlayer(
            id: UUID().uuidString,
            username: "TradingLegend",
            displayName: "Future Trading Master",
            level: currentLevel,
            currentXP: currentXP,
            totalXP: totalXPEarned,
            prestige: 0,
            title: .rookie,
            avatar: nil,
            class: .balanced,
            specialization: .goldTrader,
            joinDate: Date(),
            lastActive: Date(),
            guildId: nil
        )
    }
    
    private func loadAchievements() {
        availableAchievements = [
            // Trading Achievements
            TradingAchievement(
                id: "first_trade",
                title: "First Blood",
                description: "Execute your first trade",
                category: .trading,
                rarity: .common,
                xpReward: 100,
                icon: "🎯",
                requirements: [.tradesExecuted: 1],
                isSecret: false,
                unlockedAt: nil
            ),
            TradingAchievement(
                id: "profit_streak_5",
                title: "Hot Streak",
                description: "Win 5 trades in a row",
                category: .performance,
                rarity: .rare,
                xpReward: 500,
                icon: "🔥",
                requirements: [.consecutiveWins: 5],
                isSecret: false,
                unlockedAt: nil
            ),
            TradingAchievement(
                id: "gold_master",
                title: "Gold Master",
                description: "Execute 100 profitable XAUUSD trades",
                category: .specialization,
                rarity: .epic,
                xpReward: 2000,
                icon: "👑",
                requirements: [.goldTradesWon: 100],
                isSecret: false,
                unlockedAt: nil
            ),
            TradingAchievement(
                id: "mark_douglas_disciple",
                title: "Mark Douglas Disciple",
                description: "Maintain 90% discipline score for 30 days",
                category: .psychology,
                rarity: .legendary,
                xpReward: 5000,
                icon: "🧠",
                requirements: [.disciplineStreak: 30],
                isSecret: false,
                unlockedAt: nil
            ),
            
            // Social Achievements
            TradingAchievement(
                id: "social_butterfly",
                title: "Social Butterfly",
                description: "Follow 50 traders and get 100 followers",
                category: .social,
                rarity: .rare,
                xpReward: 1000,
                icon: "🦋",
                requirements: [.followersCount: 100, .followingCount: 50],
                isSecret: false,
                unlockedAt: nil
            ),
            TradingAchievement(
                id: "mentor",
                title: "The Mentor",
                description: "Help 10 traders become profitable",
                category: .community,
                rarity: .epic,
                xpReward: 3000,
                icon: "🎓",
                requirements: [.studentsHelped: 10],
                isSecret: false,
                unlockedAt: nil
            ),
            
            // Special Secret Achievements
            TradingAchievement(
                id: "market_wizard",
                title: "Market Wizard",
                description: "Achieve 95% win rate with 1000+ trades",
                category: .mastery,
                rarity: .mythical,
                xpReward: 10000,
                icon: "🧙‍♂️",
                requirements: [.winRate: 0.95, .tradesExecuted: 1000],
                isSecret: true,
                unlockedAt: nil
            ),
            TradingAchievement(
                id: "the_legend",
                title: "THE LEGEND",
                description: "Reach #1 on global leaderboard",
                category: .mastery,
                rarity: .mythical,
                xpReward: 25000,
                icon: "⚡",
                requirements: [.globalRank: 1],
                isSecret: true,
                unlockedAt: nil
            )
        ]
        
        // Load unlocked achievements from storage
        if let savedAchievements = UserDefaults.standard.array(forKey: "unlockedAchievements") as? [String] {
            unlockedAchievements = availableAchievements.filter { savedAchievements.contains($0.id) }
        }
    }
    
    private func loadDailyChallenges() {
        dailyChallenges = [
            DailyChallenge(
                id: "daily_trade",
                title: "Daily Trader",
                description: "Execute at least 1 trade today",
                category: .consistency,
                xpReward: 200,
                difficulty: .easy,
                progress: 0,
                maxProgress: 1,
                deadline: Calendar.current.date(byAdding: .day, value: 1, to: Calendar.current.startOfDay(for: Date()))!,
                requirements: [.tradesExecuted: 1],
                bonusMultiplier: 1.0,
                isCompleted: false
            ),
            DailyChallenge(
                id: "risk_management",
                title: "Risk Master",
                description: "Keep all trades under 2% risk today",
                category: .discipline,
                xpReward: 300,
                difficulty: .medium,
                progress: 0,
                maxProgress: 1,
                deadline: Calendar.current.date(byAdding: .day, value: 1, to: Calendar.current.startOfDay(for: Date()))!,
                requirements: [.maxRiskPerTrade: 0.02],
                bonusMultiplier: 1.5,
                isCompleted: false
            ),
            DailyChallenge(
                id: "profit_target",
                title: "Profit Hunter",
                description: "Achieve $500+ profit today",
                category: .performance,
                xpReward: 500,
                difficulty: .hard,
                progress: 0,
                maxProgress: 500,
                deadline: Calendar.current.date(byAdding: .day, value: 1, to: Calendar.current.startOfDay(for: Date()))!,
                requirements: [.dailyProfit: 500],
                bonusMultiplier: 2.0,
                isCompleted: false
            )
        ]
    }
    
    private func loadWeeklyChallenges() {
        weeklyChallenges = [
            WeeklyChallenge(
                id: "weekly_consistency",
                title: "Consistency Champion",
                description: "Trade every day this week",
                category: .consistency,
                xpReward: 2000,
                difficulty: .medium,
                progress: 0,
                maxProgress: 7,
                startDate: Calendar.current.dateInterval(of: .weekOfYear, for: Date())?.start ?? Date(),
                endDate: Calendar.current.dateInterval(of: .weekOfYear, for: Date())?.end ?? Date(),
                requirements: [.tradingDays: 7],
                milestones: [
                    ChallengeMilestone(progress: 3, reward: "Bronze Badge", xpBonus: 200),
                    ChallengeMilestone(progress: 5, reward: "Silver Badge", xpBonus: 500),
                    ChallengeMilestone(progress: 7, reward: "Gold Badge", xpBonus: 1000)
                ],
                isCompleted: false
            ),
            WeeklyChallenge(
                id: "weekly_profit",
                title: "Weekly Warrior",
                description: "Achieve 10% account growth this week",
                category: .performance,
                xpReward: 3000,
                difficulty: .hard,
                progress: 0,
                maxProgress: 10,
                startDate: Calendar.current.dateInterval(of: .weekOfYear, for: Date())?.start ?? Date(),
                endDate: Calendar.current.dateInterval(of: .weekOfYear, for: Date())?.end ?? Date(),
                requirements: [.weeklyReturn: 0.10],
                milestones: [
                    ChallengeMilestone(progress: 3, reward: "Momentum Badge", xpBonus: 300),
                    ChallengeMilestone(progress: 7, reward: "Growth Badge", xpBonus: 800),
                    ChallengeMilestone(progress: 10, reward: "Legend Badge", xpBonus: 1500)
                ],
                isCompleted: false
            )
        ]
    }
    
    private func loadSpecialEvents() {
        specialEvents = [
            SpecialEvent(
                id: "market_mayhem",
                title: "Market Mayhem Weekend",
                description: "Double XP and special rewards during high volatility!",
                type: .doubleXP,
                startDate: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
                endDate: Calendar.current.date(byAdding: .day, value: 3, to: Date())!,
                participants: 15647,
                maxParticipants: 50000,
                rewards: [
                    EventReward(rank: 1, title: "Market Mayhem Champion", xp: 10000, item: "Golden Chart Crown"),
                    EventReward(rank: 2, title: "Volatility Master", xp: 7500, item: "Silver Candle Sword"),
                    EventReward(rank: 3, title: "Chaos Controller", xp: 5000, item: "Bronze Trend Shield")
                ],
                requirements: [.eventTrades: 10, .eventProfit: 1000],
                isActive: false,
                bonusMultiplier: 2.0
            ),
            SpecialEvent(
                id: "gold_rush",
                title: "Gold Rush Championship",
                description: "Compete in the ultimate XAUUSD trading competition!",
                type: .competition,
                startDate: Calendar.current.date(byAdding: .day, value: 7, to: Date())!,
                endDate: Calendar.current.date(byAdding: .day, value: 14, to: Date())!,
                participants: 8934,
                maxParticipants: 25000,
                rewards: [
                    EventReward(rank: 1, title: "Gold Rush King", xp: 25000, item: "Midas Touch Aura"),
                    EventReward(rank: 2, title: "Gold Digger Pro", xp: 15000, item: "Golden Pickaxe"),
                    EventReward(rank: 3, title: "Nugget Hunter", xp: 10000, item: "Gold Detector")
                ],
                requirements: [.goldTrades: 50, .goldProfit: 5000],
                isActive: false,
                bonusMultiplier: 1.5
            )
        ]
    }
    
    private func loadLeaderboards() {
        globalLeaderboard = [
            LeaderboardEntry(
                rank: 1,
                playerId: "player_001",
                username: "GoldKing_Mike",
                displayName: "Mike \"The Gold King\"",
                level: 87,
                totalXP: 2847563,
                weeklyXP: 45789,
                avatar: nil,
                title: .legend,
                specialBadge: "🏆 Global Champion",
                guildName: "Elite Traders",
                performance: LeaderboardPerformance(
                    totalTrades: 15847,
                    winRate: 0.89,
                    totalProfit: 284756.89,
                    monthlyReturn: 23.4
                )
            ),
            LeaderboardEntry(
                rank: 2,
                playerId: "player_002",
                username: "ForexNinja_Sarah",
                displayName: "Sarah \"Forex Ninja\"",
                level: 76,
                totalXP: 1967432,
                weeklyXP: 38945,
                avatar: nil,
                title: .master,
                specialBadge: "🥈 Vice Champion",
                guildName: "Forex Warriors",
                performance: LeaderboardPerformance(
                    totalTrades: 12456,
                    winRate: 0.85,
                    totalProfit: 196743.67,
                    monthlyReturn: 18.7
                )
            )
        ]
        
        // Player ranking
        playerRanking = PlayerRanking(
            globalRank: 1847,
            weeklyRank: 567,
            guildRank: 23,
            countryRank: 89,
            categoryRank: ["Gold Trading": 156, "Risk Management": 78],
            percentile: 0.08, // Top 8%
            trend: .rising
        )
    }
    
    private func loadGuildData() {
        playerGuild = TradingGuild(
            id: "guild_legendary",
            name: "The Legendaries",
            description: "Elite traders destined for greatness",
            memberCount: 47,
            maxMembers: 50,
            level: 15,
            xp: 567890,
            rank: 12,
            emblem: "⚡",
            color: .gold,
            foundedDate: Calendar.current.date(byAdding: .month, value: -6, to: Date())!,
            leader: LeaderboardEntry.sample,
            officers: [],
            perks: [
                GuildPerk(name: "XP Boost", description: "+10% XP from all activities", isActive: true),
                GuildPerk(name: "Risk Shield", description: "-5% drawdown protection", isActive: true),
                GuildPerk(name: "Mentor Access", description: "Free access to guild mentors", isActive: false)
            ],
            requirements: GuildRequirements(
                minLevel: 25,
                minWinRate: 0.65,
                minTrades: 500,
                applicationRequired: true
            ),
            weeklyGoal: GuildGoal(
                title: "Weekly Profit Challenge",
                description: "Achieve 50,000 combined profit",
                currentProgress: 34567.89,
                targetProgress: 50000.0,
                reward: "Guild XP Boost Weekend",
                deadline: Calendar.current.date(byAdding: .weekOfYear, value: 1, to: Date())!
            )
        )
        
        guildContributions = GuildContributions(
            weeklyXP: 5670,
            weeklyTrades: 47,
            weeklyProfit: 2345.67,
            rank: 8,
            contributionScore: 0.76
        )
    }
    
    // MARK: - Real-time Updates
    
    private func startRealTimeUpdates() {
        updateTimer = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { _ in
            Task { @MainActor in
                self.updateChallengeProgress()
                self.checkForNewAchievements()
                self.updateStreaks()
                self.refreshLeaderboards()
            }
        }
    }
    
    private func updateChallengeProgress() {
        // Simulate challenge progress updates
        for i in dailyChallenges.indices {
            if !dailyChallenges[i].isCompleted {
                dailyChallenges[i].progress += Double.random(in: 0...0.1)
                if dailyChallenges[i].progress >= dailyChallenges[i].maxProgress {
                    dailyChallenges[i].progress = dailyChallenges[i].maxProgress
                    dailyChallenges[i].isCompleted = true
                    completeChallenge(dailyChallenges[i])
                }
            }
        }
    }
    
    private func checkForNewAchievements() {
        // Check achievement progress and unlock new ones
        for i in availableAchievements.indices {
            if availableAchievements[i].unlockedAt == nil {
                if checkAchievementRequirements(availableAchievements[i]) {
                    unlockAchievement(availableAchievements[i])
                }
            }
        }
    }
    
    private func updateStreaks() {
        // Update various streak counters
        tradingStreaks.updateDaily()
    }
    
    private func refreshLeaderboards() {
        // Simulate leaderboard position changes
        if Bool.random() {
            playerRanking.globalRank += Int.random(in: -10...10)
            playerRanking.weeklyRank += Int.random(in: -25...25)
            playerRanking.trend = playerRanking.globalRank < 1847 ? .rising : .falling
        }
    }
    
    // MARK: - XP & Leveling System
    
    func awardXP(_ amount: Int, reason: String) {
        let oldLevel = currentLevel
        
        currentXP += amount
        totalXPEarned += amount
        
        // Check for level up
        while currentXP >= xpToNextLevel {
            levelUp()
        }
        
        // Check for achievements
        if currentLevel > oldLevel {
            checkLevelAchievements()
        }
        
        // Save progress
        saveProgress()
        
        // Show XP notification
        showXPNotification(amount, reason: reason)
    }
    
    private func levelUp() {
        currentXP -= xpToNextLevel
        currentLevel += 1
        xpToNextLevel = calculateXPToNextLevel(currentLevel)
        
        levelUpAnimation = true
        
        // Award level up rewards
        awardLevelUpRewards()
        
        // Update player title if applicable
        updatePlayerTitle()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.levelUpAnimation = false
        }
    }
    
    private func calculateLevel(from totalXP: Int) -> Int {
        // Exponential leveling curve
        return Int(sqrt(Double(totalXP) / 1000.0)) + 1
    }
    
    private func calculateXPToNextLevel(_ level: Int) -> Int {
        // XP required increases exponentially
        return (level * level * 1000) - totalXPEarned
    }
    
    private func awardLevelUpRewards() {
        let rewards = getLevelRewards(currentLevel)
        pendingRewards.append(contentsOf: rewards)
        
        // Special milestone rewards
        if currentLevel % 10 == 0 {
            let milestoneReward = Reward(
                id: "milestone_\(currentLevel)",
                title: "Level \(currentLevel) Milestone",
                description: "Congratulations on reaching level \(currentLevel)!",
                type: .special,
                rarity: .epic,
                value: "Prestige Point",
                icon: "🏆",
                category: .milestone
            )
            pendingRewards.append(milestoneReward)
        }
    }
    
    private func getLevelRewards(_ level: Int) -> [Reward] {
        var rewards: [Reward] = []
        
        // Standard level rewards
        rewards.append(Reward(
            id: "level_\(level)_coins",
            title: "Level \(level) Bonus",
            description: "Congratulations on leveling up!",
            type: .currency,
            rarity: .common,
            value: "\(level * 100) Coins",
            icon: "💰",
            category: .levelUp
        ))
        
        // Special rewards at certain levels
        switch level {
        case 5:
            rewards.append(Reward(
                id: "first_milestone",
                title: "Trading Novice",
                description: "You're getting the hang of this!",
                type: .title,
                rarity: .rare,
                value: "Novice Trader",
                icon: "🎯",
                category: .title
            ))
        case 10:
            rewards.append(Reward(
                id: "advanced_charts",
                title: "Advanced Charts",
                description: "Unlock professional chart tools",
                type: .feature,
                rarity: .rare,
                value: "Chart Tools Pro",
                icon: "📊",
                category: .feature
            ))
        case 25:
            rewards.append(Reward(
                id: "pro_trader_title",
                title: "Professional Trader",
                description: "You're now a certified professional!",
                type: .title,
                rarity: .epic,
                value: "Pro Trader",
                icon: "🏆",
                category: .title
            ))
        default:
            break
        }
        
        return rewards
    }
    
    private func updatePlayerTitle() {
        let newTitle: PlayerTitle
        
        switch currentLevel {
        case 1..<5: newTitle = .rookie
        case 5..<15: newTitle = .novice
        case 15..<30: newTitle = .intermediate
        case 30..<50: newTitle = .advanced
        case 50..<75: newTitle = .expert
        case 75..<100: newTitle = .master
        default: newTitle = .legend
        }
        
        if newTitle != playerProfile.title {
            playerProfile.title = newTitle
        }
    }
    
    // MARK: - Achievement System
    
    private func unlockAchievement(_ achievement: TradingAchievement) {
        var updatedAchievement = achievement
        updatedAchievement.unlockedAt = Date()
        
        unlockedAchievements.append(updatedAchievement)
        recentAchievements.insert(updatedAchievement, at: 0)
        
        // Keep only recent 10 achievements
        if recentAchievements.count > 10 {
            recentAchievements.removeLast()
        }
        
        // Award XP
        awardXP(achievement.xpReward, reason: "Achievement: \(achievement.title)")
        
        // Show achievement notification
        showAchievementNotification(updatedAchievement)
        
        // Save to storage
        let achievementIds = unlockedAchievements.map { $0.id }
        UserDefaults.standard.set(achievementIds, forKey: "unlockedAchievements")
    }
    
    private func checkAchievementRequirements(_ achievement: TradingAchievement) -> Bool {
        // This would check against actual player stats
        // For now, simulate random unlocks
        return Bool.random() && Double.random(in: 0...1) < 0.001 // Very rare
    }
    
    private func checkLevelAchievements() {
        let levelAchievements = availableAchievements.filter { achievement in
            achievement.requirements.keys.contains(.level) &&
            achievement.requirements[.level] == Double(currentLevel) &&
            achievement.unlockedAt == nil
        }
        
        for achievement in levelAchievements {
            unlockAchievement(achievement)
        }
    }
    
    // MARK: - Challenge System
    
    private func completeChallenge(_ challenge: DailyChallenge) {
        let xpAmount = Int(Double(challenge.xpReward) * challenge.bonusMultiplier)
        awardXP(xpAmount, reason: "Challenge: \(challenge.title)")
        
        challengeStreak += 1
        
        // Award completion rewards
        let reward = Reward(
            id: "challenge_\(challenge.id)",
            title: "\(challenge.title) Complete!",
            description: "You completed the daily challenge!",
            type: .xp,
            rarity: .common,
            value: "\(xpAmount) XP",
            icon: "⭐",
            category: .challenge
        )
        pendingRewards.append(reward)
        
        showChallengeCompleteNotification(challenge)
    }
    
    func refreshDailyChallenges() {
        // Generate new daily challenges
        dailyChallenges = []
        loadDailyChallenges()
    }
    
    // MARK: - Boss Battle System
    
    func startBossBattle(_ boss: BossBattle) {
        activeBossBattle = boss
        
        showBossBattleNotification(boss)
    }
    
    func dealDamageToBoss(_ damage: Int) {
        guard var boss = activeBossBattle else { return }
        
        boss.currentHP = max(0, boss.currentHP - damage)
        activeBossBattle = boss
        
        if boss.currentHP <= 0 {
            defeatBoss(boss)
        }
    }
    
    private func defeatBoss(_ boss: BossBattle) {
        // Award massive rewards for defeating boss
        awardXP(boss.xpReward, reason: "Boss Defeated: \(boss.name)")
        
        let bossReward = Reward(
            id: "boss_\(boss.id)",
            title: "Boss Defeated!",
            description: "You defeated \(boss.name)!",
            type: .legendary,
            rarity: .legendary,
            value: boss.rewards.first ?? "Legendary Item",
            icon: "👑",
            category: .boss
        )
        pendingRewards.append(bossReward)
        
        activeBossBattle = nil
        
        showBossDefeatNotification(boss)
    }
    
    // MARK: - Guild System
    
    func contributeToGuild(xp: Int, profit: Double) {
        guildContributions.weeklyXP += xp
        guildContributions.weeklyProfit += profit
        guildContributions.weeklyTrades += 1
        
        // Update guild progress
        playerGuild?.xp += xp
        
        // Check guild goal progress
        if let goal = playerGuild?.weeklyGoal {
            playerGuild?.weeklyGoal.currentProgress += profit
        }
        
        // Award guild contribution XP bonus
        let bonusXP = Int(Double(xp) * 0.1) // 10% bonus
        if bonusXP > 0 {
            awardXP(bonusXP, reason: "Guild Contribution Bonus")
        }
    }
    
    // MARK: - Notification System
    
    private func showXPNotification(_ amount: Int, reason: String) {
        // Trigger XP gained animation/notification
        print("🎉 +\(amount) XP - \(reason)")
    }
    
    private func showAchievementNotification(_ achievement: TradingAchievement) {
        // Trigger achievement unlocked animation
        print("🏆 Achievement Unlocked: \(achievement.title)")
    }
    
    private func showChallengeCompleteNotification(_ challenge: DailyChallenge) {
        // Trigger challenge complete animation
        print("⭐ Challenge Complete: \(challenge.title)")
    }
    
    private func showBossBattleNotification(_ boss: BossBattle) {
        // Trigger boss battle start animation
        print("⚔️ Boss Battle: \(boss.name) appears!")
    }
    
    private func showBossDefeatNotification(_ boss: BossBattle) {
        // Trigger boss defeat celebration
        print("👑 VICTORY! You defeated \(boss.name)!")
    }
    
    // MARK: - Save/Load System
    
    private func saveProgress() {
        UserDefaults.standard.set(currentXP, forKey: "playerXP")
        UserDefaults.standard.set(totalXPEarned, forKey: "totalXPEarned")
        UserDefaults.standard.set(challengeStreak, forKey: "challengeStreak")
    }
    
    // MARK: - Public Interface Methods
    
    func getPlayerStats() -> PlayerStats {
        return PlayerStats(
            level: currentLevel,
            xp: currentXP,
            totalXP: totalXPEarned,
            achievementsUnlocked: unlockedAchievements.count,
            totalAchievements: availableAchievements.count,
            challengeStreak: challengeStreak,
            globalRank: playerRanking.globalRank,
            guildName: playerGuild?.name,
            title: playerProfile.title.rawValue
        )
    }
    
    func getProgressToNextLevel() -> Double {
        let totalXPForCurrentLevel = (currentLevel - 1) * (currentLevel - 1) * 1000
        let totalXPForNextLevel = currentLevel * currentLevel * 1000
        let progressInCurrentLevel = totalXPEarned - totalXPForCurrentLevel
        let xpNeededForLevel = totalXPForNextLevel - totalXPForCurrentLevel
        
        return Double(progressInCurrentLevel) / Double(xpNeededForLevel)
    }
    
    func simulateTradeAction(profit: Double, isWin: Bool) {
        // Award XP based on trade outcome
        let baseXP = isWin ? 50 : 10
        let profitBonus = max(0, Int(profit / 10)) // Extra XP for profit
        let totalXP = baseXP + profitBonus
        
        awardXP(totalXP, reason: isWin ? "Profitable Trade" : "Learning Experience")
        
        // Update guild contributions
        contributeToGuild(xp: totalXP, profit: profit)
        
        // Check for boss battle damage
        if let boss = activeBossBattle, isWin {
            let damage = Int(profit / 50) // Convert profit to damage
            dealDamageToBoss(damage)
        }
        
        // Update challenge progress
        updateChallengeProgressForTrade(profit: profit, isWin: isWin)
    }
    
    private func updateChallengeProgressForTrade(profit: Double, isWin: Bool) {
        for i in dailyChallenges.indices {
            let challenge = dailyChallenges[i]
            
            switch challenge.id {
            case "daily_trade":
                dailyChallenges[i].progress = min(1, dailyChallenges[i].progress + 1)
            case "profit_target":
                if profit > 0 {
                    dailyChallenges[i].progress = min(challenge.maxProgress, dailyChallenges[i].progress + profit)
                }
            default:
                break
            }
            
            if dailyChallenges[i].progress >= challenge.maxProgress && !challenge.isCompleted {
                dailyChallenges[i].isCompleted = true
                completeChallenge(challenge)
            }
        }
    }
}

// MARK: - Supporting Data Structures

struct TradingPlayer {
    let id: String
    var username: String
    var displayName: String
    var level: Int
    var currentXP: Int
    var totalXP: Int
    var prestige: Int
    var title: PlayerTitle
    var avatar: UIImage?
    var class: PlayerClass
    var specialization: PlayerSpecialization
    let joinDate: Date
    var lastActive: Date
    var guildId: String?
    
    static let defaultPlayer = TradingPlayer(
        id: UUID().uuidString,
        username: "NewTrader",
        displayName: "Trading Rookie",
        level: 1,
        currentXP: 0,
        totalXP: 0,
        prestige: 0,
        title: .rookie,
        avatar: nil,
        class: .balanced,
        specialization: .generalist,
        joinDate: Date(),
        lastActive: Date(),
        guildId: nil
    )
}

enum PlayerTitle: String, CaseIterable {
    case rookie = "Rookie Trader"
    case novice = "Novice Trader"
    case intermediate = "Intermediate Trader"
    case advanced = "Advanced Trader"
    case expert = "Expert Trader"
    case master = "Master Trader"
    case legend = "Trading Legend"
    
    var color: Color {
        switch self {
        case .rookie: return .gray
        case .novice: return .blue
        case .intermediate: return .green
        case .advanced: return .orange
        case .expert: return .purple
        case .master: return .red
        case .legend: return .gold
        }
    }
    
    var icon: String {
        switch self {
        case .rookie: return "🌱"
        case .novice: return "📈"
        case .intermediate: return "🎯"
        case .advanced: return "⚡"
        case .expert: return "🏆"
        case .master: return "👑"
        case .legend: return "🌟"
        }
    }
}

enum PlayerClass: String, CaseIterable {
    case aggressive = "AGGRESSIVE"
    case conservative = "CONSERVATIVE"
    case balanced = "BALANCED"
    case scalper = "SCALPER"
    
    var description: String {
        switch self {
        case .aggressive: return "High risk, high reward playstyle"
        case .conservative: return "Low risk, steady growth playstyle"
        case .balanced: return "Balanced risk-reward approach"
        case .scalper: return "Quick trades, fast profits"
        }
    }
    
    var color: Color {
        switch self {
        case .aggressive: return .red
        case .conservative: return .blue
        case .balanced: return .green
        case .scalper: return .orange
        }
    }
}

enum PlayerSpecialization: String, CaseIterable {
    case goldTrader = "GOLD TRADER"
    case forexMaster = "FOREX MASTER"
    case cryptoKing = "CRYPTO KING"
    case stocksExpert = "STOCKS EXPERT"
    case generalist = "GENERALIST"
    
    var icon: String {
        switch self {
        case .goldTrader: return "🥇"
        case .forexMaster: return "💱"
        case .cryptoKing: return "₿"
        case .stocksExpert: return "📊"
        case .generalist: return "🎯"
        }
    }
}

struct TradingAchievement: Identifiable {
    let id: String
    let title: String
    let description: String
    let category: AchievementCategory
    let rarity: AchievementRarity
    let xpReward: Int
    let icon: String
    let requirements: [AchievementRequirement: Double]
    let isSecret: Bool
    var unlockedAt: Date?
    
    var isUnlocked: Bool { unlockedAt != nil }
    
    enum AchievementCategory: String, CaseIterable {
        case trading = "TRADING"
        case performance = "PERFORMANCE"
        case social = "SOCIAL"
        case community = "COMMUNITY"
        case psychology = "PSYCHOLOGY"
        case specialization = "SPECIALIZATION"
        case mastery = "MASTERY"
        
        var color: Color {
            switch self {
            case .trading: return .blue
            case .performance: return .green
            case .social: return .purple
            case .community: return .orange
            case .psychology: return .pink
            case .specialization: return .cyan
            case .mastery: return .gold
            }
        }
    }
    
    enum AchievementRarity: String, CaseIterable {
        case common = "COMMON"
        case rare = "RARE"
        case epic = "EPIC"
        case legendary = "LEGENDARY"
        case mythical = "MYTHICAL"
        
        var color: Color {
            switch self {
            case .common: return .gray
            case .rare: return .blue
            case .epic: return .purple
            case .legendary: return .orange
            case .mythical: return .gold
            }
        }
        
        var glow: Bool {
            switch self {
            case .legendary, .mythical: return true
            default: return false
            }
        }
    }
    
    enum AchievementRequirement: String {
        case tradesExecuted = "trades_executed"
        case consecutiveWins = "consecutive_wins"
        case goldTradesWon = "gold_trades_won"
        case disciplineStreak = "discipline_streak"
        case followersCount = "followers_count"
        case followingCount = "following_count"
        case studentsHelped = "students_helped"
        case winRate = "win_rate"
        case globalRank = "global_rank"
        case level = "level"
    }
}

struct DailyChallenge: Identifiable {
    let id: String
    let title: String
    let description: String
    let category: ChallengeCategory
    let xpReward: Int
    let difficulty: ChallengeDifficulty
    var progress: Double
    let maxProgress: Double
    let deadline: Date
    let requirements: [AchievementRequirement: Double]
    let bonusMultiplier: Double
    var isCompleted: Bool
    
    var progressPercentage: Double {
        return min(1.0, progress / maxProgress)
    }
    
    enum ChallengeCategory: String, CaseIterable {
        case consistency = "CONSISTENCY"
        case discipline = "DISCIPLINE"
        case performance = "PERFORMANCE"
        case social = "SOCIAL"
        case learning = "LEARNING"
        
        var color: Color {
            switch self {
            case .consistency: return .blue
            case .discipline: return .green
            case .performance: return .red
            case .social: return .purple
            case .learning: return .orange
            }
        }
        
        var icon: String {
            switch self {
            case .consistency: return "calendar"
            case .discipline: return "shield"
            case .performance: return "chart.line.uptrend.xyaxis"
            case .social: return "person.3"
            case .learning: return "book"
            }
        }
    }
    
    enum ChallengeDifficulty: String, CaseIterable {
        case easy = "EASY"
        case medium = "MEDIUM"
        case hard = "HARD"
        case extreme = "EXTREME"
        
        var color: Color {
            switch self {
            case .easy: return .green
            case .medium: return .yellow
            case .hard: return .orange
            case .extreme: return .red
            }
        }
        
        var multiplier: Double {
            switch self {
            case .easy: return 1.0
            case .medium: return 1.5
            case .hard: return 2.0
            case .extreme: return 3.0
            }
        }
    }
}

struct WeeklyChallenge: Identifiable {
    let id: String
    let title: String
    let description: String
    let category: DailyChallenge.ChallengeCategory
    let xpReward: Int
    let difficulty: DailyChallenge.ChallengeDifficulty
    var progress: Double
    let maxProgress: Double
    let startDate: Date
    let endDate: Date
    let requirements: [AchievementRequirement: Double]
    let milestones: [ChallengeMilestone]
    var isCompleted: Bool
    
    var progressPercentage: Double {
        return min(1.0, progress / maxProgress)
    }
}

struct ChallengeMilestone {
    let progress: Double
    let reward: String
    let xpBonus: Int
}

struct BossBattle: Identifiable {
    let id: String
    let name: String
    let description: String
    let type: BossType
    let maxHP: Int
    var currentHP: Int
    let difficulty: BossDifficulty
    let xpReward: Int
    let rewards: [String]
    let requirements: [String]
    let duration: TimeInterval
    let startDate: Date
    var participants: Int
    let maxParticipants: Int
    
    enum BossType: String, CaseIterable {
        case market = "MARKET BOSS"
        case volatility = "VOLATILITY DEMON"
        case bear = "BEAR MARKET"
        case bull = "BULL RAMPAGE"
        case news = "NEWS MONSTER"
        
        var icon: String {
            switch self {
            case .market: return "📈"
            case .volatility: return "⚡"
            case .bear: return "🐻"
            case .bull: return "🐂"
            case .news: return "📰"
            }
        }
    }
    
    enum BossDifficulty: String, CaseIterable {
        case normal = "NORMAL"
        case hard = "HARD"
        case nightmare = "NIGHTMARE"
        case legendary = "LEGENDARY"
        
        var color: Color {
            switch self {
            case .normal: return .green
            case .hard: return .orange
            case .nightmare: return .red
            case .legendary: return .purple
            }
        }
    }
}

struct SpecialEvent: Identifiable {
    let id: String
    let title: String
    let description: String
    let type: EventType
    let startDate: Date
    let endDate: Date
    var participants: Int
    let maxParticipants: Int
    let rewards: [EventReward]
    let requirements: [AchievementRequirement: Double]
    let isActive: Bool
    let bonusMultiplier: Double
    
    enum EventType: String, CaseIterable {
        case doubleXP = "DOUBLE XP"
        case competition = "COMPETITION"
        case seasonal = "SEASONAL"
        case special = "SPECIAL"
        
        var color: Color {
            switch self {
            case .doubleXP: return .blue
            case .competition: return .red
            case .seasonal: return .green
            case .special: return .purple
            }
        }
    }
}

struct EventReward {
    let rank: Int
    let title: String
    let xp: Int
    let item: String
}

struct EventProgress {
    var progress: Double
    var rank: Int
    var isEligible: Bool
}

struct Reward: Identifiable {
    let id: String
    let title: String
    let description: String
    let type: RewardType
    let rarity: AchievementRarity
    let value: String
    let icon: String
    let category: RewardCategory
    
    enum RewardType: String, CaseIterable {
        case xp = "XP"
        case currency = "CURRENCY"
        case item = "ITEM"
        case title = "TITLE"
        case feature = "FEATURE"
        case cosmetic = "COSMETIC"
        case special = "SPECIAL"
        case legendary = "LEGENDARY"
        
        var color: Color {
            switch self {
            case .xp: return .blue
            case .currency: return .yellow
            case .item: return .green
            case .title: return .purple
            case .feature: return .orange
            case .cosmetic: return .pink
            case .special: return .red
            case .legendary: return .gold
            }
        }
    }
    
    enum RewardCategory: String, CaseIterable {
        case levelUp = "LEVEL_UP"
        case achievement = "ACHIEVEMENT"
        case challenge = "CHALLENGE"
        case boss = "BOSS"
        case event = "EVENT"
        case milestone = "MILESTONE"
        case title = "TITLE"
        case feature = "FEATURE"
    }
}

struct TradingInventory {
    var coins: Int = 0
    var gems: Int = 0
    var items: [InventoryItem] = []
    var cosmetics: [CosmeticItem] = []
    var titles: [String] = []
    var features: [String] = []
}

struct InventoryItem: Identifiable {
    let id: String
    let name: String
    let description: String
    let rarity: AchievementRarity
    let category: String
    let icon: String
    var quantity: Int
}

struct CosmeticItem: Identifiable {
    let id: String
    let name: String
    let description: String
    let type: CosmeticType
    let rarity: AchievementRarity
    let icon: String
    let isEquipped: Bool
    
    enum CosmeticType: String, CaseIterable {
        case avatar = "AVATAR"
        case frame = "FRAME"
        case effect = "EFFECT"
        case badge = "BADGE"
    }
}

struct LeaderboardEntry: Identifiable {
    let id = UUID()
    let rank: Int
    let playerId: String
    let username: String
    let displayName: String
    let level: Int
    let totalXP: Int
    let weeklyXP: Int
    let avatar: UIImage?
    let title: PlayerTitle
    let specialBadge: String
    let guildName: String?
    let performance: LeaderboardPerformance
    
    static let sample = LeaderboardEntry(
        rank: 1,
        playerId: "sample",
        username: "sample",
        displayName: "Sample Player",
        level: 50,
        totalXP: 100000,
        weeklyXP: 5000,
        avatar: nil,
        title: .master,
        specialBadge: "🏆",
        guildName: "Sample Guild",
        performance: LeaderboardPerformance(
            totalTrades: 1000,
            winRate: 0.85,
            totalProfit: 50000,
            monthlyReturn: 20.5
        )
    )
}

struct LeaderboardPerformance {
    let totalTrades: Int
    let winRate: Double
    let totalProfit: Double
    let monthlyReturn: Double
}

struct PlayerRanking {
    var globalRank: Int
    var weeklyRank: Int
    var guildRank: Int
    var countryRank: Int
    var categoryRank: [String: Int]
    var percentile: Double // e.g., 0.05 = top 5%
    var trend: RankingTrend
    
    enum RankingTrend {
        case rising
        case falling
        case stable
        
        var color: Color {
            switch self {
            case .rising: return .green
            case .falling: return .red
            case .stable: return .gray
            }
        }
        
        var icon: String {
            switch self {
            case .rising: return "arrow.up"
            case .falling: return "arrow.down"
            case .stable: return "minus"
            }
        }
    }
    
    static let defaultRanking = PlayerRanking(
        globalRank: 99999,
        weeklyRank: 99999,
        guildRank: 50,
        countryRank: 9999,
        categoryRank: [:],
        percentile: 0.95,
        trend: .stable
    )
}

struct TradingStreaks {
    var dailyTradingStreak: Int = 0
    var profitStreak: Int = 0
    var disciplineStreak: Int = 0
    var learningStreak: Int = 0
    var socialStreak: Int = 0
    
    mutating func updateDaily() {
        // This would be called daily to update streaks
        // Implementation would check actual trading activity
    }
}

struct TradingGuild: Identifiable {
    let id: String
    let name: String
    let description: String
    var memberCount: Int
    let maxMembers: Int
    var level: Int
    var xp: Int
    var rank: Int
    let emblem: String
    let color: Color
    let foundedDate: Date
    let leader: LeaderboardEntry
    let officers: [LeaderboardEntry]
    let perks: [GuildPerk]
    let requirements: GuildRequirements
    var weeklyGoal: GuildGoal
}

struct GuildPerk {
    let name: String
    let description: String
    let isActive: Bool
}

struct GuildRequirements {
    let minLevel: Int
    let minWinRate: Double
    let minTrades: Int
    let applicationRequired: Bool
}

struct GuildGoal {
    let title: String
    let description: String
    var currentProgress: Double
    let targetProgress: Double
    let reward: String
    let deadline: Date
    
    var progressPercentage: Double {
        return min(1.0, currentProgress / targetProgress)
    }
}

struct GuildContributions {
    var weeklyXP: Int = 0
    var weeklyTrades: Int = 0
    var weeklyProfit: Double = 0.0
    var rank: Int = 0
    var contributionScore: Double = 0.0
}

struct GuildEvent: Identifiable {
    let id: String
    let title: String
    let description: String
    let type: EventType
    let startDate: Date
    let endDate: Date
    let requirements: [String]
    let rewards: [String]
    var participants: Int
    let maxParticipants: Int
    
    enum EventType: String, CaseIterable {
        case raid = "RAID"
        case tournament = "TOURNAMENT"
        case challenge = "CHALLENGE"
        case social = "SOCIAL"
    }
}

struct TradingSeason: Identifiable {
    let id: String
    let name: String
    let number: Int
    let startDate: Date
    let endDate: Date
    let theme: String
    let rewards: [SeasonReward]
    let battlePass: BattlePass?
    
    static let current = TradingSeason(
        id: "season_1",
        name: "The Golden Beginning",
        number: 1,
        startDate: Calendar.current.date(byAdding: .month, value: -1, to: Date())!,
        endDate: Calendar.current.date(byAdding: .month, value: 2, to: Date())!,
        theme: "Gold Rush",
        rewards: [],
        battlePass: nil
    )
}

struct SeasonReward {
    let rank: Int
    let title: String
    let description: String
    let rarity: AchievementRarity
    let icon: String
}

struct BattlePass {
    let tiers: [BattlePassTier]
    var currentTier: Int
    var isPremium: Bool
}

struct BattlePassTier {
    let tier: Int
    let xpRequired: Int
    let freeReward: Reward?
    let premiumReward: Reward?
}

struct PlayerStats {
    let level: Int
    let xp: Int
    let totalXP: Int
    let achievementsUnlocked: Int
    let totalAchievements: Int
    let challengeStreak: Int
    let globalRank: Int
    let guildName: String?
    let title: String
}

#Preview {
    VStack(spacing: 20) {
        Text("🎮 GAMIFICATION ENGINE")
            .font(.title)
            .fontWeight(.bold)
        
        Text("Level Up Your Trading!")
            .font(.headline)
            .foregroundColor(.gold)
        
        Text("XP • Achievements • Challenges • Boss Battles")
            .font(.caption)
            .foregroundColor(.secondary)
    }
    .padding()
}