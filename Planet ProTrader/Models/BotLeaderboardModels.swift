//
//  BotLeaderboardModels.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 1/25/25.
//

import SwiftUI
import Foundation

// MARK: - Bot Competition System

struct BotCompetition: Identifiable, Codable {
    let id = UUID()
    let name: String
    let description: String
    let startDate: Date
    let endDate: Date
    let prizePool: Double
    let entryFee: Double
    let maxParticipants: Int
    let currentParticipants: Int
    let competitionType: CompetitionType
    let status: CompetitionStatus
    let leaderboard: [BotCompetitionEntry]
    let rules: [String]
    
    enum CompetitionType: String, CaseIterable, Codable {
        case daily = "DAILY"
        case weekly = "WEEKLY"
        case monthly = "MONTHLY"
        case flash = "FLASH"
        case tournament = "TOURNAMENT"
        
        var displayName: String {
            switch self {
            case .daily: return "Daily Hustle"
            case .weekly: return "Weekly Grind"
            case .monthly: return "Monthly Massacre"
            case .flash: return "Flash Challenge"
            case .tournament: return "Bot Tournament"
            }
        }
        
        var emoji: String {
            switch self {
            case .daily: return "🌅"
            case .weekly: return "📅"
            case .monthly: return "🗓️"
            case .flash: return "⚡"
            case .tournament: return "🏆"
            }
        }
        
        var color: Color {
            switch self {
            case .daily: return .orange
            case .weekly: return .blue
            case .monthly: return .purple
            case .flash: return .yellow
            case .tournament: return DesignSystem.primaryGold
            }
        }
    }
    
    enum CompetitionStatus: String, Codable {
        case upcoming = "UPCOMING"
        case active = "ACTIVE"
        case finished = "FINISHED"
        case cancelled = "CANCELLED"
        
        var displayName: String {
            switch self {
            case .upcoming: return "Starting Soon"
            case .active: return "LIVE NOW"
            case .finished: return "Completed"
            case .cancelled: return "Cancelled"
            }
        }
        
        var color: Color {
            switch self {
            case .upcoming: return .blue
            case .active: return .green
            case .finished: return .gray
            case .cancelled: return .red
            }
        }
    }
    
    var timeRemaining: String {
        let now = Date()
        let targetDate = status == .upcoming ? startDate : endDate
        let timeInterval = targetDate.timeIntervalSince(now)
        
        if timeInterval <= 0 {
            return status == .upcoming ? "Starting Now!" : "Finished"
        }
        
        let hours = Int(timeInterval) / 3600
        let minutes = Int(timeInterval) % 3600 / 60
        
        if hours > 24 {
            let days = hours / 24
            return "\(days)d \(hours % 24)h"
        } else if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
}

struct BotCompetitionEntry: Identifiable, Codable {
    let id = UUID()
    let botId: UUID
    let botName: String
    let ownerName: String
    let currentRank: Int
    let profitLoss: Double
    let profitPercentage: Double
    let tradesExecuted: Int
    let winRate: Double
    let entryTime: Date
    let isDisqualified: Bool
    let disqualificationReason: String?
    
    var formattedProfitLoss: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: NSNumber(value: profitLoss)) ?? "$0.00"
    }
    
    var formattedProfitPercentage: String {
        return String(format: "%+.2f%%", profitPercentage)
    }
    
    var rankEmoji: String {
        switch currentRank {
        case 1: return "🥇"
        case 2: return "🥈"
        case 3: return "🥉"
        case 4...10: return "🔥"
        default: return "💎"
        }
    }
    
    var performanceColor: Color {
        if profitPercentage > 10 { return .green }
        if profitPercentage > 0 { return .blue }
        if profitPercentage > -5 { return .orange }
        return .red
    }
}

// MARK: - Bot Rankings

struct BotRanking: Identifiable, Codable {
    let id = UUID()
    let botId: UUID
    let botName: String
    let ownerName: String
    let overallRank: Int
    let categoryRanks: [String: Int] // e.g., ["daily": 1, "weekly": 3]
    let totalEarnings: Double
    let monthlyEarnings: Double
    let winRate: Double
    let averageReturn: Double
    let consistency: Double
    let riskScore: Double
    let followerCount: Int
    let achievements: [BotAchievement]
    let recentPerformance: [PerformanceData]
    let isHireable: Bool
    let hiringFee: Double
    
    var rankChangeFromLastWeek: Int = 0 // +3 = moved up 3 ranks
    var trendEmoji: String {
        if rankChangeFromLastWeek > 0 { return "📈" }
        if rankChangeFromLastWeek < 0 { return "📉" }
        return "➡️"
    }
    
    var performanceGrade: String {
        switch averageReturn {
        case 15...: return "S+"
        case 10..<15: return "S"
        case 8..<10: return "A+"
        case 6..<8: return "A"
        case 4..<6: return "B+"
        case 2..<4: return "B"
        case 0..<2: return "C"
        default: return "D"
        }
    }
    
    var gradeColor: Color {
        switch performanceGrade {
        case "S+", "S": return DesignSystem.primaryGold
        case "A+", "A": return .green
        case "B+", "B": return .blue
        case "C": return .orange
        default: return .red
        }
    }
}

struct PerformanceData: Identifiable, Codable {
    let id = UUID()
    let date: Date
    let profitLoss: Double
    let percentage: Double
    let volume: Double
}

// MARK: - Bot Achievements

struct BotAchievement: Identifiable, Codable {
    let id = UUID()
    let title: String
    let description: String
    let icon: String
    let color: Color
    let rarity: AchievementRarity
    let unlockedDate: Date
    let requirements: String
    
    enum AchievementRarity: String, CaseIterable, Codable {
        case common = "COMMON"
        case rare = "RARE"
        case epic = "EPIC"
        case legendary = "LEGENDARY"
        case mythic = "MYTHIC"
        
        var displayName: String {
            switch self {
            case .common: return "Common"
            case .rare: return "Rare"
            case .epic: return "Epic"
            case .legendary: return "Legendary"
            case .mythic: return "Mythic"
            }
        }
        
        var color: Color {
            switch self {
            case .common: return .gray
            case .rare: return .blue
            case .epic: return .purple
            case .legendary: return DesignSystem.primaryGold
            case .mythic: return .red
            }
        }
        
        var frameColor: Color {
            switch self {
            case .common: return .gray
            case .rare: return .blue
            case .epic: return .purple
            case .legendary: return DesignSystem.primaryGold
            case .mythic: return .red
            }
        }
    }
}

// MARK: - Competition Alerts

struct CompetitionAlert: Identifiable, Codable {
    let id = UUID()
    let title: String
    let message: String
    let alertType: AlertType
    let timestamp: Date
    let isRead: Bool
    let relatedBotId: UUID?
    let relatedCompetitionId: UUID?
    
    enum AlertType: String, CaseIterable, Codable {
        case botMoved = "BOT_MOVED"
        case competitionStarted = "COMPETITION_STARTED"
        case competitionEnding = "COMPETITION_ENDING"
        case botWon = "BOT_WON"
        case botLost = "BOT_LOST"
        case newRecord = "NEW_RECORD"
        case botHired = "BOT_HIRED"
        
        var icon: String {
            switch self {
            case .botMoved: return "arrow.up.arrow.down"
            case .competitionStarted: return "flag.fill"
            case .competitionEnding: return "clock.fill"
            case .botWon: return "trophy.fill"
            case .botLost: return "xmark.circle.fill"
            case .newRecord: return "star.fill"
            case .botHired: return "person.badge.plus"
            }
        }
        
        var color: Color {
            switch self {
            case .botMoved: return .blue
            case .competitionStarted: return .green
            case .competitionEnding: return .orange
            case .botWon: return DesignSystem.primaryGold
            case .botLost: return .red
            case .newRecord: return .purple
            case .botHired: return .cyan
            }
        }
    }
}

// MARK: - Leaderboard Manager

class BotLeaderboardManager: ObservableObject {
    @Published var competitions: [BotCompetition] = []
    @Published var globalRankings: [BotRanking] = []
    @Published var userBotRankings: [BotRanking] = []
    @Published var alerts: [CompetitionAlert] = []
    @Published var isLoading = false
    
    init() {
        loadSampleData()
        startRealTimeUpdates()
    }
    
    private func loadSampleData() {
        // Sample competitions
        competitions = [
            BotCompetition(
                name: "Monday Money Massacre",
                description: "Who can make the most money on Monday?",
                startDate: Calendar.current.date(byAdding: .hour, value: -2, to: Date()) ?? Date(),
                endDate: Calendar.current.date(byAdding: .hour, value: 10, to: Date()) ?? Date(),
                prizePool: 5000.0,
                entryFee: 100.0,
                maxParticipants: 50,
                currentParticipants: 37,
                competitionType: .daily,
                status: .active,
                leaderboard: generateSampleLeaderboard(),
                rules: [
                    "Only scalp trades allowed",
                    "Max 5% risk per trade", 
                    "No holding overnight",
                    "Must complete at least 3 trades"
                ]
            ),
            BotCompetition(
                name: "Flash Challenge: $100 to $1K",
                description: "Turn $100 into $1,000 in 24 hours!",
                startDate: Calendar.current.date(byAdding: .hour, value: 6, to: Date()) ?? Date(),
                endDate: Calendar.current.date(byAdding: .hour, value: 30, to: Date()) ?? Date(),
                prizePool: 10000.0,
                entryFee: 50.0,
                maxParticipants: 100,
                currentParticipants: 23,
                competitionType: .flash,
                status: .upcoming,
                leaderboard: [],
                rules: [
                    "Starting capital: $100",
                    "Target: $1,000+",
                    "All strategies allowed",
                    "Winner takes 50% of prize pool"
                ]
            )
        ]
        
        // Sample global rankings
        globalRankings = generateSampleRankings()
        
        // Sample alerts
        alerts = [
            CompetitionAlert(
                title: "🔥 Bot Moving Up!",
                message: "TrendHunter Pro just moved from #15 to #8 in Monday Money Massacre!",
                alertType: .botMoved,
                timestamp: Date(),
                isRead: false,
                relatedBotId: UUID(),
                relatedCompetitionId: competitions.first?.id
            ),
            CompetitionAlert(
                title: "🚀 New Record!",
                message: "ScalpMaster just hit 95% win rate - new weekly record!",
                alertType: .newRecord,
                timestamp: Calendar.current.date(byAdding: .minute, value: -15, to: Date()) ?? Date(),
                isRead: false,
                relatedBotId: UUID(),
                relatedCompetitionId: nil
            )
        ]
    }
    
    private func generateSampleLeaderboard() -> [BotCompetitionEntry] {
        let botNames = ["TrendHunter Pro", "ScalpMaster", "GoldDigger AI", "RiskTaker", "ConsistentWinner"]
        let ownerNames = ["ProTrader_Mike", "Sarah_Scalps", "GoldFever99", "RiskyBusiness", "SteadyEddie"]
        
        return Array(0..<25).map { index in
            BotCompetitionEntry(
                botId: UUID(),
                botName: botNames.randomElement() ?? "Bot \(index + 1)",
                ownerName: ownerNames.randomElement() ?? "User\(index + 1)",
                currentRank: index + 1,
                profitLoss: Double.random(in: -500...2000),
                profitPercentage: Double.random(in: -20...50),
                tradesExecuted: Int.random(in: 5...25),
                winRate: Double.random(in: 40...95),
                entryTime: Calendar.current.date(byAdding: .hour, value: -Int.random(in: 1...10), to: Date()) ?? Date(),
                isDisqualified: false,
                disqualificationReason: nil
            )
        }.sorted { $0.profitLoss > $1.profitLoss }
    }
    
    private func generateSampleRankings() -> [BotRanking] {
        let botNames = ["TrendMaster Pro", "ScalpLord", "GoldRush AI", "ConsistentKing", "MomentumBeast"]
        
        return Array(0..<50).map { index in
            BotRanking(
                botId: UUID(),
                botName: botNames.randomElement() ?? "Bot \(index + 1)",
                ownerName: "Trader\(index + 1)",
                overallRank: index + 1,
                categoryRanks: ["daily": Int.random(in: 1...10), "weekly": Int.random(in: 1...20)],
                totalEarnings: Double.random(in: 1000...100000),
                monthlyEarnings: Double.random(in: 500...10000),
                winRate: Double.random(in: 60...95),
                averageReturn: Double.random(in: 2...20),
                consistency: Double.random(in: 70...98),
                riskScore: Double.random(in: 1...10),
                followerCount: Int.random(in: 10...5000),
                achievements: [],
                recentPerformance: [],
                isHireable: Bool.random(),
                hiringFee: Double.random(in: 100...1000)
            )
        }
    }
    
    private func startRealTimeUpdates() {
        // Simulate real-time updates
        Timer.scheduledTimer(withTimeInterval: 30.0, repeats: true) { _ in
            self.updateCompetitionData()
        }
    }
    
    private func updateCompetitionData() {
        // Simulate leaderboard changes
        for i in competitions.indices {
            if competitions[i].status == .active {
                competitions[i] = BotCompetition(
                    id: competitions[i].id,
                    name: competitions[i].name,
                    description: competitions[i].description,
                    startDate: competitions[i].startDate,
                    endDate: competitions[i].endDate,
                    prizePool: competitions[i].prizePool,
                    entryFee: competitions[i].entryFee,
                    maxParticipants: competitions[i].maxParticipants,
                    currentParticipants: competitions[i].currentParticipants,
                    competitionType: competitions[i].competitionType,
                    status: competitions[i].status,
                    leaderboard: updateLeaderboard(competitions[i].leaderboard),
                    rules: competitions[i].rules
                )
            }
        }
    }
    
    private func updateLeaderboard(_ currentLeaderboard: [BotCompetitionEntry]) -> [BotCompetitionEntry] {
        return currentLeaderboard.map { entry in
            var updatedEntry = entry
            // Simulate profit/loss changes
            let change = Double.random(in: -100...200)
            updatedEntry = BotCompetitionEntry(
                id: entry.id,
                botId: entry.botId,
                botName: entry.botName,
                ownerName: entry.ownerName,
                currentRank: entry.currentRank,
                profitLoss: entry.profitLoss + change,
                profitPercentage: entry.profitPercentage + (change / 1000 * 100),
                tradesExecuted: entry.tradesExecuted + Int.random(in: 0...2),
                winRate: max(40, min(95, entry.winRate + Double.random(in: -2...2))),
                entryTime: entry.entryTime,
                isDisqualified: entry.isDisqualified,
                disqualificationReason: entry.disqualificationReason
            )
            return updatedEntry
        }.sorted { $0.profitLoss > $1.profitLoss }
        .enumerated().map { index, entry in
            BotCompetitionEntry(
                id: entry.id,
                botId: entry.botId,
                botName: entry.botName,
                ownerName: entry.ownerName,
                currentRank: index + 1,
                profitLoss: entry.profitLoss,
                profitPercentage: entry.profitPercentage,
                tradesExecuted: entry.tradesExecuted,
                winRate: entry.winRate,
                entryTime: entry.entryTime,
                isDisqualified: entry.isDisqualified,
                disqualificationReason: entry.disqualificationReason
            )
        }
    }
    
    func joinCompetition(_ competitionId: UUID, botId: UUID) {
        // Join competition logic
        if let index = competitions.firstIndex(where: { $0.id == competitionId }) {
            var competition = competitions[index]
            if competition.currentParticipants < competition.maxParticipants {
                competition = BotCompetition(
                    id: competition.id,
                    name: competition.name,
                    description: competition.description,
                    startDate: competition.startDate,
                    endDate: competition.endDate,
                    prizePool: competition.prizePool,
                    entryFee: competition.entryFee,
                    maxParticipants: competition.maxParticipants,
                    currentParticipants: competition.currentParticipants + 1,
                    competitionType: competition.competitionType,
                    status: competition.status,
                    leaderboard: competition.leaderboard,
                    rules: competition.rules
                )
                competitions[index] = competition
            }
        }
    }
    
    func markAlertAsRead(_ alertId: UUID) {
        if let index = alerts.firstIndex(where: { $0.id == alertId }) {
            alerts[index] = CompetitionAlert(
                id: alerts[index].id,
                title: alerts[index].title,
                message: alerts[index].message,
                alertType: alerts[index].alertType,
                timestamp: alerts[index].timestamp,
                isRead: true,
                relatedBotId: alerts[index].relatedBotId,
                relatedCompetitionId: alerts[index].relatedCompetitionId
            )
        }
    }
}