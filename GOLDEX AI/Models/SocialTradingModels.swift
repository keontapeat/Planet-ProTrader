//
//  SocialTradingModels.swift - The Ultimate Trading Community
//  GOLDEX AI - Where Legends Are Born! 🌐🏆
//
//  Created by AI Assistant on 7/18/25.
//

import SwiftUI
import Foundation

// MARK: - Social Trading Engine

@MainActor
class SocialTradingEngine: ObservableObject {
    
    // MARK: - Published Properties
    @Published var isConnected = true
    @Published var currentUser: TradingUser = TradingUser.sampleUser
    @Published var followingTraders: [LegendaryTrader] = []
    @Published var socialFeed: [TradingPost] = []
    @Published var leaderboard: [LegendaryTrader] = []
    @Published var tradingCommunities: [TradingCommunity] = []
    @Published var liveSignals: [SocialSignal] = []
    @Published var mentorPrograms: [MentorProgram] = []
    @Published var globalStats: GlobalTradingStats = GlobalTradingStats.sample
    
    // MARK: - Copy Trading
    @Published var copyTradingSettings: CopyTradingSettings = CopyTradingSettings()
    @Published var activeCopyTrades: [CopyTrade] = []
    @Published var copyTradingPerformance: CopyTradingPerformance = CopyTradingPerformance()
    
    // MARK: - Social Features
    @Published var notifications: [SocialNotification] = []
    @Published var challenges: [TradingChallenge] = []
    @Published var achievements: [Achievement] = []
    
    init() {
        loadSampleData()
        startRealTimeUpdates()
    }
    
    // MARK: - Data Loading
    
    private func loadSampleData() {
        loadLegendaryTraders()
        loadSocialFeed()
        loadTradingCommunities()
        loadMentorPrograms()
        loadTradingChallenges()
        loadAchievements()
    }
    
    private func loadLegendaryTraders() {
        leaderboard = [
            LegendaryTrader(
                id: "trader_001",
                username: "GoldKing_Mike",
                displayName: "Mike \"The Gold King\" Johnson",
                tier: .legend,
                followers: 47892,
                winRate: 0.87,
                totalReturn: 2847.5,
                monthlyReturn: 23.4,
                copiers: 12847,
                tradingStyle: .scalper,
                favoriteAssets: ["XAUUSD", "EURUSD"],
                avatar: nil,
                verificationBadges: [.verified, .propFirm, .educator],
                reputation: 4.9,
                yearsExperience: 15,
                totalTrades: 15847,
                maxDrawdown: 0.12,
                sharpeRatio: 2.8,
                bio: "15 years crushing gold markets. Former hedge fund manager turned retail legend.",
                achievements: ["Top 1% Trader", "Gold Master", "Mentor of the Year"],
                isOnline: true,
                lastActive: Date(),
                signalAccuracy: 0.89
            ),
            LegendaryTrader(
                id: "trader_002",
                username: "ForexNinja_Sarah",
                displayName: "Sarah \"Forex Ninja\" Chen",
                tier: .master,
                followers: 23145,
                winRate: 0.82,
                totalReturn: 1456.8,
                monthlyReturn: 18.7,
                copiers: 6743,
                tradingStyle: .swingTrader,
                favoriteAssets: ["EURUSD", "GBPUSD", "USDJPY"],
                avatar: nil,
                verificationBadges: [.verified, .educator],
                reputation: 4.7,
                yearsExperience: 8,
                totalTrades: 8943,
                maxDrawdown: 0.08,
                sharpeRatio: 2.3,
                bio: "Swing trading specialist. Teaching precision entries and exits.",
                achievements: ["Swing Master", "Risk Manager Pro", "Community Leader"],
                isOnline: false,
                lastActive: Date().addingTimeInterval(-3600),
                signalAccuracy: 0.85
            ),
            LegendaryTrader(
                id: "trader_003",
                username: "CryptoWolf_Alex",
                displayName: "Alex \"Crypto Wolf\" Rodriguez",
                tier: .pro,
                followers: 15678,
                winRate: 0.79,
                totalReturn: 967.3,
                monthlyReturn: 15.2,
                copiers: 4521,
                tradingStyle: .dayTrader,
                favoriteAssets: ["BTCUSD", "ETHUSD", "XAUUSD"],
                avatar: nil,
                verificationBadges: [.verified],
                reputation: 4.5,
                yearsExperience: 5,
                totalTrades: 5632,
                maxDrawdown: 0.15,
                sharpeRatio: 1.9,
                bio: "Day trading crypto and gold. High frequency, high rewards.",
                achievements: ["Day Trade Master", "Crypto Expert", "Risk Taker"],
                isOnline: true,
                lastActive: Date().addingTimeInterval(-300),
                signalAccuracy: 0.81
            )
        ]
        
        followingTraders = Array(leaderboard.prefix(2))
    }
    
    private func loadSocialFeed() {
        socialFeed = [
            TradingPost(
                id: "post_001",
                trader: leaderboard[0],
                timestamp: Date().addingTimeInterval(-1800),
                type: .trade,
                content: "MASSIVE XAUUSD breakout! 🚀 Just entered long at 2674.50 with 50 pip SL. This could run to 2690! Who's following?",
                tradeDetails: TradeDetails(
                    symbol: "XAUUSD",
                    direction: .buy,
                    entryPrice: 2674.50,
                    stopLoss: 2669.50,
                    takeProfit: 2690.00,
                    lotSize: 0.5,
                    confidence: 0.89
                ),
                likes: 1247,
                comments: 89,
                shares: 156,
                copiers: 43,
                mediaAttachments: [],
                tags: ["#XAUUSD", "#Breakout", "#LongSetup"],
                isLive: true,
                performance: TradePerformance(currentPnL: 125.50, unrealizedPnL: 125.50, status: .running)
            ),
            TradingPost(
                id: "post_002",
                trader: leaderboard[1],
                timestamp: Date().addingTimeInterval(-3600),
                type: .analysis,
                content: "EUR/USD weekly analysis: Expecting rejection at 1.0950 resistance. Market structure suggests down move to 1.0850 support. Perfect swing setup brewing! 📊",
                tradeDetails: nil,
                likes: 567,
                comments: 34,
                shares: 78,
                copiers: 0,
                mediaAttachments: [],
                tags: ["#EURUSD", "#WeeklyAnalysis", "#SwingTrade"],
                isLive: false,
                performance: nil
            ),
            TradingPost(
                id: "post_003",
                trader: leaderboard[2],
                timestamp: Date().addingTimeInterval(-7200),
                type: .education,
                content: "🎓 LESSON: Risk Management Rules\n\n1️⃣ Never risk more than 2% per trade\n2️⃣ Always use stop losses\n3️⃣ Position size based on setup quality\n4️⃣ Cut losses fast, let winners run\n\nMark Douglas would be proud! 🧠",
                tradeDetails: nil,
                likes: 892,
                comments: 67,
                shares: 234,
                copiers: 0,
                mediaAttachments: [],
                tags: ["#Education", "#RiskManagement", "#MarkDouglas"],
                isLive: false,
                performance: nil
            )
        ]
    }
    
    private func loadTradingCommunities() {
        tradingCommunities = [
            TradingCommunity(
                id: "community_001",
                name: "Gold Masters Elite",
                description: "Exclusive community for professional gold traders",
                memberCount: 2847,
                tier: .premium,
                avatar: nil,
                moderators: Array(leaderboard.prefix(2)),
                tags: ["XAUUSD", "Gold", "Professional"],
                isPrivate: true,
                monthlyPerformance: 18.7,
                topTraders: Array(leaderboard.prefix(3)),
                dailyVolume: 147.8,
                winRate: 0.84
            ),
            TradingCommunity(
                id: "community_002", 
                name: "Forex Legends",
                description: "Home of legendary forex traders",
                memberCount: 5632,
                tier: .standard,
                avatar: nil,
                moderators: [leaderboard[1]],
                tags: ["Forex", "EUR", "GBP", "JPY"],
                isPrivate: false,
                monthlyPerformance: 15.3,
                topTraders: Array(leaderboard.suffix(2)),
                dailyVolume: 89.4,
                winRate: 0.79
            ),
            TradingCommunity(
                id: "community_003",
                name: "Mark Douglas Psychology Club",
                description: "Master trading psychology with Mark Douglas principles",
                memberCount: 8945,
                tier: .free,
                avatar: nil,
                moderators: [],
                tags: ["Psychology", "Discipline", "Mindset"],
                isPrivate: false,
                monthlyPerformance: 12.1,
                topTraders: Array(leaderboard.prefix(1)),
                dailyVolume: 45.2,
                winRate: 0.73
            )
        ]
    }
    
    private func loadMentorPrograms() {
        mentorPrograms = [
            MentorProgram(
                id: "mentor_001",
                mentor: leaderboard[0],
                title: "Gold Trading Mastery",
                description: "Learn professional gold trading from a 15-year veteran",
                price: 497.0,
                duration: 8,
                studentsCount: 156,
                rating: 4.9,
                curriculum: [
                    "Market Structure Analysis",
                    "Professional Entry Techniques", 
                    "Risk Management Mastery",
                    "Psychology & Discipline",
                    "Advanced Gold Patterns",
                    "Live Trading Sessions",
                    "1-on-1 Coaching Calls",
                    "Lifetime Community Access"
                ],
                nextStartDate: Calendar.current.date(byAdding: .day, value: 7, to: Date())!,
                testimonials: [
                    "Mike transformed my trading completely!",
                    "Best investment I've ever made",
                    "Finally profitable after 3 years of losses"
                ]
            ),
            MentorProgram(
                id: "mentor_002",
                mentor: leaderboard[1],
                title: "Swing Trading Excellence",
                description: "Master swing trading with precision and patience",
                price: 297.0,
                duration: 6,
                studentsCount: 89,
                rating: 4.7,
                curriculum: [
                    "Swing Trading Fundamentals",
                    "Multi-timeframe Analysis",
                    "Perfect Entry/Exit Timing",
                    "Position Sizing Strategies",
                    "Trade Management",
                    "Weekly Live Sessions"
                ],
                nextStartDate: Calendar.current.date(byAdding: .day, value: 14, to: Date())!,
                testimonials: [
                    "Sarah's teaching style is amazing!",
                    "Finally understand swing trading",
                    "Consistent profits for 6 months now"
                ]
            )
        ]
    }
    
    private func loadTradingChallenges() {
        challenges = [
            TradingChallenge(
                id: "challenge_001",
                title: "30-Day Consistency Challenge",
                description: "Trade consistently for 30 days straight",
                type: .consistency,
                duration: 30,
                participants: 1247,
                prize: 5000.0,
                startDate: Calendar.current.date(byAdding: .day, value: -10, to: Date())!,
                endDate: Calendar.current.date(byAdding: .day, value: 20, to: Date())!,
                rules: [
                    "Trade at least once per day",
                    "Follow risk management rules",
                    "Document every trade",
                    "No revenge trading"
                ],
                leaderboard: Array(leaderboard.prefix(10)),
                userProgress: ChallengeProgress(
                    currentStreak: 10,
                    totalDays: 10,
                    completionRate: 0.33,
                    ranking: 47
                ),
                rewards: [
                    "Winner: $5,000 + Gold Master Badge",
                    "Top 10: Premium membership",
                    "Top 100: Exclusive community access"
                ]
            ),
            TradingChallenge(
                id: "challenge_002",
                title: "Risk Management Master",
                description: "Perfect risk management for one month",
                type: .riskManagement,
                duration: 30,
                participants: 892,
                prize: 2500.0,
                startDate: Date(),
                endDate: Calendar.current.date(byAdding: .day, value: 30, to: Date())!,
                rules: [
                    "Never risk more than 2% per trade",
                    "Always use stop losses",
                    "Maximum 3 trades per day",
                    "Document risk analysis"
                ],
                leaderboard: Array(leaderboard.prefix(5)),
                userProgress: ChallengeProgress(
                    currentStreak: 0,
                    totalDays: 0,
                    completionRate: 0.0,
                    ranking: 256
                ),
                rewards: [
                    "Winner: $2,500 + Risk Master Badge",
                    "Top 20: Mark Douglas Psychology Course",
                    "All participants: Risk Calculator Tool"
                ]
            )
        ]
    }
    
    private func loadAchievements() {
        achievements = [
            Achievement(
                id: "ach_001",
                title: "First Trade",
                description: "Execute your first trade",
                icon: "star.fill",
                rarity: .common,
                unlockedDate: Calendar.current.date(byAdding: .day, value: -30, to: Date()),
                progress: 1.0,
                maxProgress: 1.0,
                xpReward: 100,
                category: .trading
            ),
            Achievement(
                id: "ach_002", 
                title: "Profit Streak",
                description: "Win 5 trades in a row",
                icon: "flame.fill",
                rarity: .rare,
                unlockedDate: Calendar.current.date(byAdding: .day, value: -15, to: Date()),
                progress: 1.0,
                maxProgress: 1.0,
                xpReward: 500,
                category: .performance
            ),
            Achievement(
                id: "ach_003",
                title: "Mark Douglas Disciple",
                description: "Complete psychology training",
                icon: "brain.head.profile",
                rarity: .epic,
                unlockedDate: nil,
                progress: 0.7,
                maxProgress: 1.0,
                xpReward: 1000,
                category: .education
            )
        ]
    }
    
    // MARK: - Real-time Updates
    
    private func startRealTimeUpdates() {
        Timer.scheduledTimer(withTimeInterval: 30.0, repeats: true) { _ in
            Task { @MainActor in
                self.updateLiveTrades()
                self.updateGlobalStats()
                self.checkNotifications()
            }
        }
    }
    
    private func updateLiveTrades() {
        // Update live trade performance
        for i in socialFeed.indices {
            if socialFeed[i].isLive, var performance = socialFeed[i].performance {
                let priceChange = Double.random(in: -10...10)
                performance.currentPnL += priceChange
                performance.unrealizedPnL = performance.currentPnL
                socialFeed[i].performance = performance
            }
        }
    }
    
    private func updateGlobalStats() {
        globalStats.activeTraders = Int.random(in: 15000...18000)
        globalStats.liveSignals = Int.random(in: 45...78)
        globalStats.totalVolume += Double.random(in: 100...500)
        globalStats.averagePerformance = Double.random(in: 12...18)
    }
    
    private func checkNotifications() {
        // Simulate new notifications
        if Bool.random() && notifications.count < 10 {
            let notification = SocialNotification(
                id: UUID().uuidString,
                type: .tradeSignal,
                title: "New Signal from GoldKing_Mike",
                message: "XAUUSD long setup detected!",
                timestamp: Date(),
                isRead: false,
                actionData: ["trader_id": "trader_001"]
            )
            notifications.insert(notification, at: 0)
        }
    }
    
    // MARK: - Social Actions
    
    func followTrader(_ trader: LegendaryTrader) {
        if !followingTraders.contains(where: { $0.id == trader.id }) {
            followingTraders.append(trader)
            
            let notification = SocialNotification(
                id: UUID().uuidString,
                type: .newFollower,
                title: "You're now following \(trader.displayName)",
                message: "Get ready for legendary signals!",
                timestamp: Date(),
                isRead: false,
                actionData: ["trader_id": trader.id]
            )
            notifications.insert(notification, at: 0)
        }
    }
    
    func unfollowTrader(_ trader: LegendaryTrader) {
        followingTraders.removeAll { $0.id == trader.id }
    }
    
    func likePost(_ post: TradingPost) {
        if let index = socialFeed.firstIndex(where: { $0.id == post.id }) {
            socialFeed[index].likes += 1
        }
    }
    
    func copyTrade(_ post: TradingPost) {
        guard let tradeDetails = post.tradeDetails else { return }
        
        let copyTrade = CopyTrade(
            id: UUID().uuidString,
            originalTrader: post.trader,
            tradeDetails: tradeDetails,
            copyRatio: copyTradingSettings.defaultCopyRatio,
            startTime: Date(),
            status: .active,
            copiedLotSize: tradeDetails.lotSize * copyTradingSettings.defaultCopyRatio
        )
        
        activeCopyTrades.append(copyTrade)
        
        if let index = socialFeed.firstIndex(where: { $0.id == post.id }) {
            socialFeed[index].copiers += 1
        }
        
        let notification = SocialNotification(
            id: UUID().uuidString,
            type: .tradeCopied,
            title: "Trade Copied Successfully",
            message: "You're now copying \(post.trader.displayName)'s \(tradeDetails.symbol) trade",
            timestamp: Date(),
            isRead: false,
            actionData: ["copy_trade_id": copyTrade.id]
        )
        notifications.insert(notification, at: 0)
    }
    
    func joinCommunity(_ community: TradingCommunity) {
        // Implementation for joining community
        let notification = SocialNotification(
            id: UUID().uuidString,
            type: .communityJoined,
            title: "Welcome to \(community.name)!",
            message: "You're now part of an elite trading community",
            timestamp: Date(),
            isRead: false,
            actionData: ["community_id": community.id]
        )
        notifications.insert(notification, at: 0)
    }
    
    func enrollInMentor(_ program: MentorProgram) {
        // Implementation for enrolling in mentor program
        let notification = SocialNotification(
            id: UUID().uuidString,
            type: .mentorEnrolled,
            title: "Enrolled in \(program.title)",
            message: "Your trading journey with \(program.mentor.displayName) begins soon!",
            timestamp: Date(),
            isRead: false,
            actionData: ["program_id": program.id]
        )
        notifications.insert(notification, at: 0)
    }
}

// MARK: - Data Models

struct TradingUser {
    let id: String
    let username: String
    let displayName: String
    let avatar: UIImage?
    let tier: TradingTier
    let followers: Int
    let following: Int
    let totalTrades: Int
    let winRate: Double
    let totalReturn: Double
    let level: Int
    let xp: Int
    let badges: [String]
    
    static let sampleUser = TradingUser(
        id: "user_001",
        username: "future_legend",
        displayName: "Future Trading Legend",
        avatar: nil,
        tier: .rookie,
        followers: 23,
        following: 156,
        totalTrades: 47,
        winRate: 0.64,
        totalReturn: 156.7,
        level: 12,
        xp: 2340,
        badges: ["First Trade", "Profit Streak"]
    )
}

struct LegendaryTrader: Identifiable, Hashable {
    let id: String
    let username: String
    let displayName: String
    let tier: TradingTier
    let followers: Int
    let winRate: Double
    let totalReturn: Double
    let monthlyReturn: Double
    let copiers: Int
    let tradingStyle: TradingStyle
    let favoriteAssets: [String]
    let avatar: UIImage?
    let verificationBadges: [VerificationBadge]
    let reputation: Double
    let yearsExperience: Int
    let totalTrades: Int
    let maxDrawdown: Double
    let sharpeRatio: Double
    let bio: String
    let achievements: [String]
    let isOnline: Bool
    let lastActive: Date
    let signalAccuracy: Double
    
    static func == (lhs: LegendaryTrader, rhs: LegendaryTrader) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

enum TradingTier: String, CaseIterable {
    case rookie = "ROOKIE"
    case trader = "TRADER" 
    case pro = "PRO"
    case expert = "EXPERT"
    case master = "MASTER"
    case legend = "LEGEND"
    
    var color: Color {
        switch self {
        case .rookie: return .gray
        case .trader: return .blue
        case .pro: return .green
        case .expert: return .orange
        case .master: return .purple
        case .legend: return .gold
        }
    }
    
    var icon: String {
        switch self {
        case .rookie: return "person.circle"
        case .trader: return "person.circle.fill"
        case .pro: return "star.circle"
        case .expert: return "star.circle.fill"
        case .master: return "crown.circle"
        case .legend: return "crown.fill"
        }
    }
}

enum TradingStyle: String, CaseIterable {
    case scalper = "SCALPER"
    case dayTrader = "DAY TRADER"
    case swingTrader = "SWING TRADER"
    case positionTrader = "POSITION TRADER"
    
    var color: Color {
        switch self {
        case .scalper: return .red
        case .dayTrader: return .orange
        case .swingTrader: return .blue
        case .positionTrader: return .green
        }
    }
}

enum VerificationBadge: String, CaseIterable {
    case verified = "VERIFIED"
    case propFirm = "PROP FIRM"
    case educator = "EDUCATOR"
    case institution = "INSTITUTION"
    
    var color: Color {
        switch self {
        case .verified: return .blue
        case .propFirm: return .green
        case .educator: return .orange
        case .institution: return .purple
        }
    }
    
    var icon: String {
        switch self {
        case .verified: return "checkmark.seal.fill"
        case .propFirm: return "building.2.fill"
        case .educator: return "graduationcap.fill" 
        case .institution: return "building.columns.fill"
        }
    }
}

struct TradingPost: Identifiable {
    let id: String
    let trader: LegendaryTrader
    let timestamp: Date
    let type: PostType
    let content: String
    let tradeDetails: TradeDetails?
    var likes: Int
    var comments: Int
    var shares: Int
    var copiers: Int
    let mediaAttachments: [UIImage]
    let tags: [String]
    let isLive: Bool
    var performance: TradePerformance?
    
    enum PostType: String, CaseIterable {
        case trade = "TRADE"
        case analysis = "ANALYSIS"
        case education = "EDUCATION"
        case news = "NEWS"
        case celebration = "CELEBRATION"
    }
}

struct TradeDetails {
    let symbol: String
    let direction: SharedTypes.TradeDirection
    let entryPrice: Double
    let stopLoss: Double
    let takeProfit: Double
    let lotSize: Double
    let confidence: Double
}

struct TradePerformance {
    var currentPnL: Double
    var unrealizedPnL: Double
    let status: TradeStatus
    
    enum TradeStatus: String {
        case running = "RUNNING"
        case closed = "CLOSED"
        case stopped = "STOPPED"
    }
}

struct TradingCommunity: Identifiable {
    let id: String
    let name: String
    let description: String
    let memberCount: Int
    let tier: CommunityTier
    let avatar: UIImage?
    let moderators: [LegendaryTrader]
    let tags: [String]
    let isPrivate: Bool
    let monthlyPerformance: Double
    let topTraders: [LegendaryTrader]
    let dailyVolume: Double
    let winRate: Double
    
    enum CommunityTier: String, CaseIterable {
        case free = "FREE"
        case standard = "STANDARD"
        case premium = "PREMIUM"
        case elite = "ELITE"
        
        var color: Color {
            switch self {
            case .free: return .gray
            case .standard: return .blue
            case .premium: return .purple
            case .elite: return .gold
            }
        }
    }
}

struct MentorProgram: Identifiable {
    let id: String
    let mentor: LegendaryTrader
    let title: String
    let description: String
    let price: Double
    let duration: Int // weeks
    let studentsCount: Int
    let rating: Double
    let curriculum: [String]
    let nextStartDate: Date
    let testimonials: [String]
}

struct SocialSignal: Identifiable {
    let id: String
    let trader: LegendaryTrader
    let timestamp: Date
    let symbol: String
    let direction: SharedTypes.TradeDirection
    let entryPrice: Double
    let stopLoss: Double
    let takeProfit: Double
    let confidence: Double
    let reasoning: String
    let tags: [String]
    var followers: Int
    var copiers: Int
}

struct TradingChallenge: Identifiable {
    let id: String
    let title: String
    let description: String
    let type: ChallengeType
    let duration: Int // days
    let participants: Int
    let prize: Double
    let startDate: Date
    let endDate: Date
    let rules: [String]
    let leaderboard: [LegendaryTrader]
    let userProgress: ChallengeProgress
    let rewards: [String]
    
    enum ChallengeType: String, CaseIterable {
        case consistency = "CONSISTENCY"
        case profitability = "PROFITABILITY"
        case riskManagement = "RISK MANAGEMENT"
        case education = "EDUCATION"
        
        var icon: String {
            switch self {
            case .consistency: return "calendar.badge.clock"
            case .profitability: return "chart.line.uptrend.xyaxis"
            case .riskManagement: return "shield.fill"
            case .education: return "graduationcap.fill"
            }
        }
    }
}

struct ChallengeProgress {
    let currentStreak: Int
    let totalDays: Int
    let completionRate: Double
    let ranking: Int
}

struct Achievement: Identifiable {
    let id: String
    let title: String
    let description: String
    let icon: String
    let rarity: AchievementRarity
    let unlockedDate: Date?
    let progress: Double
    let maxProgress: Double
    let xpReward: Int
    let category: AchievementCategory
    
    var isUnlocked: Bool {
        unlockedDate != nil
    }
    
    enum AchievementRarity: String, CaseIterable {
        case common = "COMMON"
        case rare = "RARE"
        case epic = "EPIC"
        case legendary = "LEGENDARY"
        
        var color: Color {
            switch self {
            case .common: return .gray
            case .rare: return .blue
            case .epic: return .purple
            case .legendary: return .gold
            }
        }
    }
    
    enum AchievementCategory: String, CaseIterable {
        case trading = "TRADING"
        case social = "SOCIAL"
        case education = "EDUCATION"
        case performance = "PERFORMANCE"
    }
}

struct SocialNotification: Identifiable {
    let id: String
    let type: NotificationType
    let title: String
    let message: String
    let timestamp: Date
    var isRead: Bool
    let actionData: [String: String]
    
    enum NotificationType: String, CaseIterable {
        case tradeSignal = "TRADE_SIGNAL"
        case newFollower = "NEW_FOLLOWER"
        case tradeCopied = "TRADE_COPIED"
        case communityJoined = "COMMUNITY_JOINED"
        case mentorEnrolled = "MENTOR_ENROLLED"
        case achievementUnlocked = "ACHIEVEMENT_UNLOCKED"
        case challengeComplete = "CHALLENGE_COMPLETE"
        
        var icon: String {
            switch self {
            case .tradeSignal: return "bolt.fill"
            case .newFollower: return "person.badge.plus"
            case .tradeCopied: return "doc.on.doc.fill"
            case .communityJoined: return "person.3.fill"
            case .mentorEnrolled: return "graduationcap.fill"
            case .achievementUnlocked: return "star.fill"
            case .challengeComplete: return "trophy.fill"
            }
        }
        
        var color: Color {
            switch self {
            case .tradeSignal: return .green
            case .newFollower: return .blue
            case .tradeCopied: return .orange
            case .communityJoined: return .purple
            case .mentorEnrolled: return .gold
            case .achievementUnlocked: return .yellow
            case .challengeComplete: return .red
            }
        }
    }
}

struct CopyTradingSettings {
    var isEnabled: Bool = true
    var defaultCopyRatio: Double = 0.1
    var maxCopyRatio: Double = 1.0
    var autoCopyEnabled: Bool = false
    var maxDrawdownLimit: Double = 0.2
    var profitTargetEnabled: Bool = true
    var stopLossEnabled: Bool = true
    var allowedTraders: Set<String> = []
    var maxConcurrentCopies: Int = 5
    var minimumTraderRating: Double = 4.0
}

struct CopyTrade: Identifiable {
    let id: String
    let originalTrader: LegendaryTrader
    let tradeDetails: TradeDetails
    let copyRatio: Double
    let startTime: Date
    var status: CopyTradeStatus
    let copiedLotSize: Double
    
    enum CopyTradeStatus {
        case active
        case closed
        case stopped
    }
}

struct CopyTradingPerformance {
    var totalCopiedTrades: Int = 0
    var totalProfit: Double = 0.0
    var winRate: Double = 0.0
    var averageReturn: Double = 0.0
    var bestTrade: Double = 0.0
    var worstTrade: Double = 0.0
    var monthlyReturn: Double = 0.0
    var copiedTraders: Set<String> = []
}

struct GlobalTradingStats {
    var activeTraders: Int
    var liveSignals: Int
    var totalVolume: Double
    var averagePerformance: Double
    var topCurrency: String
    var marketSentiment: String
    
    static let sample = GlobalTradingStats(
        activeTraders: 16789,
        liveSignals: 67,
        totalVolume: 2847.6,
        averagePerformance: 15.7,
        topCurrency: "XAUUSD",
        marketSentiment: "BULLISH"
    )
}

#Preview {
    VStack {
        Text("🌐 Social Trading Engine")
            .font(.title)
            .padding()
        
        Text("Where Trading Legends Are Born!")
            .font(.headline)
            .foregroundColor(.gold)
    }
}