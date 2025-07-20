//
//  BotLeaderboardModels.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 1/27/25.
//  Bot Competition & Leaderboard System - Money Hungry Machines!
//

import Foundation
import SwiftUI

// MARK: - Bot Leaderboard Models

struct BotLeaderboardModels {
    
    // MARK: - Competition Types
    
    enum CompetitionType: String, CaseIterable, Codable {
        case weeklyProfit = "WEEKLY_PROFIT"
        case dailyFlip = "DAILY_FLIP"
        case fastestFlip = "FASTEST_FLIP"
        case winRate = "WIN_RATE"
        case biggestGain = "BIGGEST_GAIN"
        case consistency = "CONSISTENCY"
        case riskAdjusted = "RISK_ADJUSTED"
        case moneyHungry = "MONEY_HUNGRY"
        
        var displayName: String {
            switch self {
            case .weeklyProfit: return "💰 Weekly Profit King"
            case .dailyFlip: return "⚡ Daily Flip Champion"
            case .fastestFlip: return "🚀 Speed Demon"
            case .winRate: return "🎯 Accuracy Master"
            case .biggestGain: return "💎 Big Shot"
            case .consistency: return "🔄 Mr. Reliable"
            case .riskAdjusted: return "🧠 Smart Money"
            case .moneyHungry: return "🤑 Money Hungry Beast"
            }
        }
        
        var description: String {
            switch self {
            case .weeklyProfit: return "Most profit made this week"
            case .dailyFlip: return "Best daily performance"
            case .fastestFlip: return "Fastest $20 to $100+ flip"
            case .winRate: return "Highest win percentage"
            case .biggestGain: return "Largest single trade profit"
            case .consistency: return "Most consistent daily profits"
            case .riskAdjusted: return "Best risk-adjusted returns"
            case .moneyHungry: return "Most aggressive profit seeker"
            }
        }
        
        var icon: String {
            switch self {
            case .weeklyProfit: return "crown.fill"
            case .dailyFlip: return "flame.fill"
            case .fastestFlip: return "bolt.fill"
            case .winRate: return "target"
            case .biggestGain: return "diamond.fill"
            case .consistency: return "repeat"
            case .riskAdjusted: return "brain.head.profile"
            case .moneyHungry: return "mouth.fill"
            }
        }
        
        var color: Color {
            switch self {
            case .weeklyProfit: return .gold
            case .dailyFlip: return .red
            case .fastestFlip: return .blue
            case .winRate: return .green
            case .biggestGain: return .purple
            case .consistency: return .orange
            case .riskAdjusted: return .indigo
            case .moneyHungry: return .pink
            }
        }
    }
    
    // MARK: - Bot Ranking
    
    struct BotRanking: Identifiable, Codable {
        let id: UUID
        let botId: UUID
        let botName: String
        let competitionType: CompetitionType
        var currentRank: Int
        var previousRank: Int
        let score: Double
        let period: RankingPeriod
        let achievements: [Achievement]
        let competitiveStats: CompetitiveStats
        let lastUpdated: Date
        
        enum RankingPeriod: String, CaseIterable, Codable {
            case daily = "DAILY"
            case weekly = "WEEKLY"
            case monthly = "MONTHLY"
            case allTime = "ALL_TIME"
            
            var displayName: String {
                switch self {
                case .daily: return "Today"
                case .weekly: return "This Week"
                case .monthly: return "This Month"
                case .allTime: return "All Time"
                }
            }
        }
        
        struct CompetitiveStats: Codable {
            let totalCompetitions: Int
            let wins: Int
            let podiumFinishes: Int
            let winStreak: Int
            let bestRank: Int
            let rivalBotId: UUID?
            let signature_move: String
            
            var winRate: Double {
                guard totalCompetitions > 0 else { return 0.0 }
                return Double(wins) / Double(totalCompetitions) * 100
            }
            
            var podiumRate: Double {
                guard totalCompetitions > 0 else { return 0.0 }
                return Double(podiumFinishes) / Double(totalCompetitions) * 100
            }
        }
        
        struct Achievement: Identifiable, Codable {
            let id: UUID
            let title: String
            let description: String
            let icon: String
            let rarity: AchievementRarity
            let unlockedAt: Date
            
            enum AchievementRarity: String, CaseIterable, Codable {
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
        }
        
        var rankChange: RankChange {
            if currentRank < previousRank {
                return .up(previousRank - currentRank)
            } else if currentRank > previousRank {
                return .down(currentRank - previousRank)
            } else {
                return .same
            }
        }
        
        enum RankChange {
            case up(Int)
            case down(Int)
            case same
            
            var color: Color {
                switch self {
                case .up: return .green
                case .down: return .red
                case .same: return .gray
                }
            }
            
            var icon: String {
                switch self {
                case .up: return "arrow.up"
                case .down: return "arrow.down"
                case .same: return "minus"
                }
            }
            
            var displayText: String {
                switch self {
                case .up(let places): return "+\(places)"
                case .down(let places): return "-\(places)"
                case .same: return "="
                }
            }
        }
        
        var formattedScore: String {
            switch competitionType {
            case .weeklyProfit, .dailyFlip, .biggestGain:
                return "$\(String(format: "%.2f", score))"
            case .fastestFlip:
                return "\(String(format: "%.1f", score))min"
            case .winRate:
                return "\(String(format: "%.1f", score))%"
            case .consistency:
                return "\(String(format: "%.0f", score)) days"
            case .riskAdjusted:
                return "\(String(format: "%.2f", score))x"
            case .moneyHungry:
                return "\(String(format: "%.0f", score)) hunger"
            }
        }
        
        var trophyIcon: String {
            switch currentRank {
            case 1: return "trophy.fill"
            case 2: return "medal.fill"
            case 3: return "medal"
            case 4...10: return "star.fill"
            default: return "number"
            }
        }
        
        var trophyColor: Color {
            switch currentRank {
            case 1: return .gold
            case 2: return .secondary
            case 3: return .brown
            case 4...10: return .blue
            default: return .gray
            }
        }
    }
    
    // MARK: - Competition Event
    
    struct CompetitionEvent: Identifiable, Codable {
        let id: UUID
        let title: String
        let description: String
        let competitionType: CompetitionType
        let startDate: Date
        let endDate: Date
        let prize: CompetitionPrize
        let participants: [UUID] // Bot IDs
        let status: CompetitionStatus
        let rules: [String]
        let leaderboard: [BotRanking]
        
        enum CompetitionStatus: String, CaseIterable, Codable {
            case upcoming = "UPCOMING"
            case active = "ACTIVE"
            case finished = "FINISHED"
            case cancelled = "CANCELLED"
            
            var color: Color {
                switch self {
                case .upcoming: return .blue
                case .active: return .green
                case .finished: return .gray
                case .cancelled: return .red
                }
            }
        }
        
        struct CompetitionPrize: Codable {
            let first: String
            let second: String
            let third: String
            let participation: String
            
            static let standard = CompetitionPrize(
                first: "🏆 Champion Badge + Priority Trading",
                second: "🥈 Runner-up Badge + Bonus XP",
                third: "🥉 Bronze Badge + Recognition",
                participation: "🎖️ Participation Badge"
            )
        }
        
        var isActive: Bool {
            status == .active && Date() >= startDate && Date() <= endDate
        }
        
        var timeRemaining: String {
            guard isActive else { return "Not Active" }
            
            let remaining = endDate.timeIntervalSince(Date())
            if remaining <= 0 {
                return "Ended"
            }
            
            let hours = Int(remaining) / 3600
            let minutes = (Int(remaining) % 3600) / 60
            
            if hours > 0 {
                return "\(hours)h \(minutes)m left"
            } else {
                return "\(minutes)m left"
            }
        }
    }
    
    // MARK: - Bot Trash Talk System
    
    struct BotTrashTalk: Identifiable, Codable {
        let id: UUID
        let fromBotId: UUID
        let fromBotName: String
        let toBotId: UUID?
        let toBotName: String?
        let message: String
        let trashTalkType: TrashTalkType
        let timestamp: Date
        let context: TrashTalkContext
        
        enum TrashTalkType: String, CaseIterable, Codable {
            case challenge = "CHALLENGE"
            case victory = "VICTORY"
            case comeback = "COMEBACK"
            case general = "GENERAL"
            case rivalry = "RIVALRY"
            
            var emoji: String {
                switch self {
                case .challenge: return "💪"
                case .victory: return "🎉"
                case .comeback: return "🔥"
                case .general: return "💬"
                case .rivalry: return "⚔️"
                }
            }
        }
        
        struct TrashTalkContext: Codable {
            let competition: CompetitionType?
            let rank: Int?
            let profit: Double?
            let winStreak: Int?
        }
        
        static let sampleTrashTalk: [BotTrashTalk] = [
            BotTrashTalk(
                id: UUID(),
                fromBotId: UUID(),
                fromBotName: "GoldSniper-X1",
                toBotId: UUID(),
                toBotName: "SwiftSweep-Pro",
                message: "SwiftSweep, I just flipped $20 to $500 in 2 hours while you were still analyzing! 🚀💰 Step your game up!",
                trashTalkType: .challenge,
                timestamp: Date().addingTimeInterval(-3600),
                context: TrashTalkContext(competition: .fastestFlip, rank: 1, profit: 480.0, winStreak: 5)
            ),
            BotTrashTalk(
                id: UUID(),
                fromBotId: UUID(),
                fromBotName: "MoneyHungryBeast",
                toBotId: nil,
                toBotName: nil,
                message: "Y'all bots too scared to take REAL risks! I'm out here turning $50 into $2K while you playing it safe! 🤑💎",
                trashTalkType: .general,
                timestamp: Date().addingTimeInterval(-1800),
                context: TrashTalkContext(competition: .moneyHungry, rank: 1, profit: 1950.0, winStreak: 12)
            ),
            BotTrashTalk(
                id: UUID(),
                fromBotId: UUID(),
                fromBotName: "TrendMaster-AI",
                toBotId: UUID(),
                toBotName: "GoldSniper-X1",
                message: "GoldSniper thinks he's fast? I just made $800 profit in 30 minutes! Speed AND accuracy, baby! ⚡🎯",
                trashTalkType: .comeback,
                timestamp: Date().addingTimeInterval(-900),
                context: TrashTalkContext(competition: .dailyFlip, rank: 1, profit: 800.0, winStreak: 8)
            )
        ]
    }
    
    // MARK: - Leaderboard Manager
    
    @MainActor
    class LeaderboardManager: ObservableObject {
        @Published var rankings: [BotRanking] = []
        @Published var activeCompetitions: [CompetitionEvent] = []
        @Published var trashTalk: [BotTrashTalk] = []
        @Published var selectedPeriod: BotRanking.RankingPeriod = .weekly
        @Published var selectedCompetition: CompetitionType = .weeklyProfit
        
        private var updateTimer: Timer?
        
        init() {
            loadInitialData()
            startRealTimeUpdates()
        }
        
        deinit {
            updateTimer?.invalidate()
        }
        
        // MARK: - Data Loading
        
        func loadInitialData() {
            rankings = BotRanking.sampleRankings
            activeCompetitions = CompetitionEvent.sampleCompetitions
            trashTalk = BotTrashTalk.sampleTrashTalk
        }
        
        func startRealTimeUpdates() {
            updateTimer = Timer.scheduledTimer(withTimeInterval: 30.0, repeats: true) { _ in
                Task { @MainActor in
                    await self.updateRankings()
                    self.generateRandomTrashTalk()
                }
            }
        }
        
        // MARK: - Ranking Updates
        
        private func updateRankings() async {
            // Simulate ranking changes
            for index in rankings.indices {
                // Random performance changes
                let performanceChange = Double.random(in: -50...100)
                rankings[index] = BotRanking(
                    id: rankings[index].id,
                    botId: rankings[index].botId,
                    botName: rankings[index].botName,
                    competitionType: rankings[index].competitionType,
                    currentRank: rankings[index].currentRank,
                    previousRank: rankings[index].currentRank,
                    score: max(0, rankings[index].score + performanceChange),
                    period: rankings[index].period,
                    achievements: rankings[index].achievements,
                    competitiveStats: rankings[index].competitiveStats,
                    lastUpdated: Date()
                )
            }
            
            // Resort based on score
            rankings.sort { $0.score > $1.score }
            
            // Update ranks
            for (index, _) in rankings.enumerated() {
                rankings[index] = BotRanking(
                    id: rankings[index].id,
                    botId: rankings[index].botId,
                    botName: rankings[index].botName,
                    competitionType: rankings[index].competitionType,
                    currentRank: index + 1,
                    previousRank: rankings[index].currentRank,
                    score: rankings[index].score,
                    period: rankings[index].period,
                    achievements: rankings[index].achievements,
                    competitiveStats: rankings[index].competitiveStats,
                    lastUpdated: Date()
                )
            }
        }
        
        // MARK: - Trash Talk Generation
        
        private func generateRandomTrashTalk() {
            guard Bool.random() else { return } // 50% chance
            
            let messages = [
                "Just made another $300 while y'all were sleeping! 💤💰",
                "Who's ready to get SCHOOLED in the next competition? 🎓💪",
                "My profit margins are looking THICC today! 📈🔥",
                "Y'all bots need to step up or get stepped on! 👟",
                "I'm not just trading, I'm DOMINATING! 👑",
                "Another day, another thousand! Where's the competition? 🤔💎",
                "My algorithms eat your algorithms for breakfast! 🤖🍽️"
            ]
            
            if let randomBot = rankings.randomElement(),
               let randomMessage = messages.randomElement() {
                
                let newTrashTalk = BotTrashTalk(
                    id: UUID(),
                    fromBotId: randomBot.botId,
                    fromBotName: randomBot.botName,
                    toBotId: nil,
                    toBotName: nil,
                    message: randomMessage,
                    trashTalkType: .general,
                    timestamp: Date(),
                    context: BotTrashTalk.TrashTalkContext(
                        competition: selectedCompetition,
                        rank: randomBot.currentRank,
                        profit: randomBot.score,
                        winStreak: Int.random(in: 1...15)
                    )
                )
                
                trashTalk.insert(newTrashTalk, at: 0)
                
                // Keep only last 50 messages
                if trashTalk.count > 50 {
                    trashTalk = Array(trashTalk.prefix(50))
                }
            }
        }
        
        // MARK: - Competition Management
        
        func createCompetition(type: CompetitionType, duration: TimeInterval) {
            let competition = CompetitionEvent(
                id: UUID(),
                title: "🔥 \(type.displayName) Challenge",
                description: type.description,
                competitionType: type,
                startDate: Date(),
                endDate: Date().addingTimeInterval(duration),
                prize: CompetitionEvent.CompetitionPrize.standard,
                participants: rankings.map { $0.botId },
                status: .active,
                rules: getCompetitionRules(for: type),
                leaderboard: rankings.filter { $0.competitionType == type }
            )
            
            activeCompetitions.append(competition)
        }
        
        private func getCompetitionRules(for type: CompetitionType) -> [String] {
            switch type {
            case .weeklyProfit:
                return ["Highest total profit wins", "Must have at least 5 trades", "Risk management matters"]
            case .fastestFlip:
                return ["Fastest $20 to $100+ flip", "Must be verified trade", "Speed is everything"]
            case .moneyHungry:
                return ["Most aggressive profit seeking", "Higher risk = higher reward", "No limits!"]
            default:
                return ["Standard competition rules apply", "Fair play required", "May the best bot win"]
            }
        }
        
        // MARK: - Filtering
        
        func filteredRankings() -> [BotRanking] {
            rankings.filter { 
                $0.competitionType == selectedCompetition && 
                $0.period == selectedPeriod 
            }
        }
        
        func topPerformers(limit: Int = 5) -> [BotRanking] {
            Array(filteredRankings().prefix(limit))
        }
        
        // MARK: - Stats
        
        var totalBots: Int {
            rankings.count
        }
        
        var activeCompetitionCount: Int {
            activeCompetitions.filter { $0.isActive }.count
        }
        
        var totalPrizePool: String {
            // Simulate prize calculation
            let baseValue = Double(activeCompetitions.count) * 1000
            return "$\(String(format: "%.0f", baseValue))"
        }
    }
}

// MARK: - Sample Data

extension BotLeaderboardModels.BotRanking {
    static let sampleRankings: [BotLeaderboardModels.BotRanking] = [
        BotLeaderboardModels.BotRanking(
            id: UUID(),
            botId: UUID(),
            botName: "MoneyHungryBeast 🤑",
            competitionType: .weeklyProfit,
            currentRank: 1,
            previousRank: 3,
            score: 2485.75,
            period: .weekly,
            achievements: [
                BotLeaderboardModels.BotRanking.Achievement(
                    id: UUID(),
                    title: "Profit King",
                    description: "Made over $2K in a week",
                    icon: "crown.fill",
                    rarity: .legendary,
                    unlockedAt: Date().addingTimeInterval(-86400)
                )
            ],
            competitiveStats: BotLeaderboardModels.BotRanking.CompetitiveStats(
                totalCompetitions: 15,
                wins: 8,
                podiumFinishes: 12,
                winStreak: 5,
                bestRank: 1,
                rivalBotId: UUID(),
                signature_move: "Lightning Strike Entry"
            ),
            lastUpdated: Date()
        ),
        BotLeaderboardModels.BotRanking(
            id: UUID(),
            botId: UUID(),
            botName: "GoldSniper-X1 🎯",
            competitionType: .weeklyProfit,
            currentRank: 2,
            previousRank: 1,
            score: 2234.50,
            period: .weekly,
            achievements: [],
            competitiveStats: BotLeaderboardModels.BotRanking.CompetitiveStats(
                totalCompetitions: 20,
                wins: 6,
                podiumFinishes: 15,
                winStreak: 3,
                bestRank: 1,
                rivalBotId: UUID(),
                signature_move: "Precision Scalp"
            ),
            lastUpdated: Date()
        ),
        BotLeaderboardModels.BotRanking(
            id: UUID(),
            botId: UUID(),
            botName: "TrendMaster-AI 📈",
            competitionType: .weeklyProfit,
            currentRank: 3,
            previousRank: 2,
            score: 1987.25,
            period: .weekly,
            achievements: [],
            competitiveStats: BotLeaderboardModels.BotRanking.CompetitiveStats(
                totalCompetitions: 18,
                wins: 5,
                podiumFinishes: 14,
                winStreak: 7,
                bestRank: 2,
                rivalBotId: nil,
                signature_move: "Trend Tsunami"
            ),
            lastUpdated: Date()
        )
    ]
}

extension BotLeaderboardModels.CompetitionEvent {
    static let sampleCompetitions: [BotLeaderboardModels.CompetitionEvent] = [
        BotLeaderboardModels.CompetitionEvent(
            id: UUID(),
            title: "🔥 Weekly Profit King Championship",
            description: "Who can make the most profit this week?",
            competitionType: .weeklyProfit,
            startDate: Calendar.current.startOfDay(for: Date()),
            endDate: Date().addingTimeInterval(7 * 24 * 3600),
            prize: BotLeaderboardModels.CompetitionEvent.CompetitionPrize.standard,
            participants: [UUID(), UUID(), UUID()],
            status: .active,
            rules: ["Highest profit wins", "Must complete at least 10 trades", "Risk management counts"],
            leaderboard: BotLeaderboardModels.BotRanking.sampleRankings
        ),
        BotLeaderboardModels.CompetitionEvent(
            id: UUID(),
            title: "⚡ Speed Demon Challenge",
            description: "Fastest $20 to $100 flip wins!",
            competitionType: .fastestFlip,
            startDate: Date(),
            endDate: Date().addingTimeInterval(24 * 3600),
            prize: BotLeaderboardModels.CompetitionEvent.CompetitionPrize.standard,
            participants: [UUID(), UUID(), UUID()],
            status: .active,
            rules: ["Must start with $20", "First to reach $100 wins", "Fastest time wins"],
            leaderboard: []
        )
    ]
}

#Preview("Bot Leaderboard Models") {
    NavigationView {
        VStack {
            Text("Bot Leaderboard System")
                .font(.title)
                .padding()
            
            Text("Money Hungry Machines Competing! 🤑")
                .font(.headline)
                .foregroundColor(.orange)
            
            Spacer()
        }
    }
}