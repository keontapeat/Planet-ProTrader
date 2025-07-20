//
//  BotMarketplaceModels.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 1/25/25.
//

import SwiftUI
import Foundation

// MARK: - Elite Bot Marketplace System

struct MarketplaceBot: Identifiable, Codable {
    let id = UUID()
    let name: String
    let nickname: String
    let description: String
    let ownerName: String
    let profileImageURL: String?
    let aiGeneratedImagePrompt: String
    
    // Performance Stats
    let overallRank: Int
    let totalEarnings: Double
    let monthlyEarnings: Double
    let weeklyEarnings: Double
    let dailyEarnings: Double
    let winRate: Double
    let averageReturn: Double
    let consistency: Double
    let maxDrawdown: Double
    let sharpeRatio: Double
    let totalTrades: Int
    let winningTrades: Int
    let losingTrades: Int
    
    // Hiring Information
    let hiringFee: Double
    let dailyRate: Double
    let isAvailable: Bool
    let contractTerms: ContractTerms
    let specialties: [TradingSpecialty]
    let riskLevel: RiskLevel
    let timeZone: String
    let languages: [String]
    
    // Social Proof
    let followerCount: Int
    let hireCount: Int
    let averageRating: Double
    let reviews: [BotReview]
    let badges: [BotBadge]
    let achievements: [String]
    
    // Performance History
    let performanceHistory: [PerformancePoint]
    let recentTrades: [TradeResult]
    
    // Personality & Style
    let personality: BotPersonality
    let tradingStyle: TradingStyle
    let favoriteMarkets: [String]
    let tradingHours: String
    
    enum RiskLevel: String, CaseIterable, Codable {
        case conservative = "CONSERVATIVE"
        case moderate = "MODERATE"
        case aggressive = "AGGRESSIVE"
        case extreme = "EXTREME"
        
        var displayName: String { rawValue.capitalized }
        var color: Color {
            switch self {
            case .conservative: return .green
            case .moderate: return .blue
            case .aggressive: return .orange
            case .extreme: return .red
            }
        }
        
        var emoji: String {
            switch self {
            case .conservative: return "🛡️"
            case .moderate: return "⚖️"
            case .aggressive: return "🔥"
            case .extreme: return "🚀"
            }
        }
    }
    
    var formattedEarnings: String {
        if totalEarnings >= 1000000 {
            return String(format: "$%.1fM", totalEarnings / 1000000)
        } else if totalEarnings >= 1000 {
            return String(format: "$%.1fK", totalEarnings / 1000)
        } else {
            return String(format: "$%.0f", totalEarnings)
        }
    }
    
    var performanceGrade: String {
        switch averageReturn {
        case 20...: return "S+"
        case 15..<20: return "S"
        case 12..<15: return "A+"
        case 10..<12: return "A"
        case 8..<10: return "B+"
        case 6..<8: return "B"
        case 4..<6: return "C+"
        case 2..<4: return "C"
        default: return "D"
        }
    }
    
    var gradeColor: Color {
        switch performanceGrade {
        case "S+", "S": return DesignSystem.primaryGold
        case "A+", "A": return .green
        case "B+", "B": return .blue
        case "C+", "C": return .orange
        default: return .red
        }
    }
    
    var popularityLevel: PopularityLevel {
        switch followerCount {
        case 10000...: return .legendary
        case 5000..<10000: return .famous
        case 1000..<5000: return .popular
        case 100..<1000: return .rising
        default: return .newcomer
        }
    }
}

enum PopularityLevel: String, CaseIterable {
    case newcomer = "NEWCOMER"
    case rising = "RISING"
    case popular = "POPULAR"
    case famous = "FAMOUS"
    case legendary = "LEGENDARY"
    
    var displayName: String {
        switch self {
        case .newcomer: return "New Talent"
        case .rising: return "Rising Star"
        case .popular: return "Fan Favorite"
        case .famous: return "Trading Celebrity"
        case .legendary: return "LEGEND"
        }
    }
    
    var emoji: String {
        switch self {
        case .newcomer: return "🌱"
        case .rising: return "⭐"
        case .popular: return "🔥"
        case .famous: return "👑"
        case .legendary: return "🏆"
        }
    }
    
    var color: Color {
        switch self {
        case .newcomer: return .green
        case .rising: return .blue
        case .popular: return .orange
        case .famous: return .purple
        case .legendary: return DesignSystem.primaryGold
        }
    }
}

struct ContractTerms: Codable {
    let minimumHirePeriod: Int // days
    let maximumHirePeriod: Int // days
    let profitSplit: Double // percentage bot keeps
    let guaranteedReturn: Double? // minimum return guarantee
    let cancellationPolicy: String
    let specialConditions: [String]
}

struct TradingSpecialty: Identifiable, Codable {
    let id = UUID()
    let name: String
    let proficiency: Double // 0-100
    let description: String
    let icon: String
    
    static let allSpecialties: [TradingSpecialty] = [
        TradingSpecialty(name: "Scalping", proficiency: 95, description: "Lightning-fast micro trades", icon: "bolt.fill"),
        TradingSpecialty(name: "Day Trading", proficiency: 88, description: "Intraday momentum plays", icon: "chart.line.uptrend.xyaxis"),
        TradingSpecialty(name: "Swing Trading", proficiency: 92, description: "Multi-day trend captures", icon: "waveform"),
        TradingSpecialty(name: "Options Trading", proficiency: 85, description: "Leveraged derivatives", icon: "arrow.up.arrow.down"),
        TradingSpecialty(name: "Crypto Trading", proficiency: 90, description: "Digital asset mastery", icon: "bitcoinsign.circle"),
        TradingSpecialty(name: "Forex Trading", proficiency: 87, description: "Currency pair expertise", icon: "globe"),
        TradingSpecialty(name: "Risk Management", proficiency: 98, description: "Capital preservation", icon: "shield.fill")
    ]
}

struct BotPersonality: Codable {
    let type: PersonalityType
    let traits: [String]
    let communicationStyle: String
    let motivationalQuotes: [String]
    let catchPhrases: [String]
    
    enum PersonalityType: String, CaseIterable, Codable {
        case aggressive = "AGGRESSIVE"
        case analytical = "ANALYTICAL"
        case calm = "CALM"
        case confident = "CONFIDENT"
        case disciplined = "DISCIPLINED"
        case intuitive = "INTUITIVE"
        
        var displayName: String { rawValue.capitalized }
        var emoji: String {
            switch self {
            case .aggressive: return "🔥"
            case .analytical: return "🧠"
            case .calm: return "🧘"
            case .confident: return "💪"
            case .disciplined: return "🎯"
            case .intuitive: return "🔮"
            }
        }
    }
}

struct TradingStyle: Codable {
    let primary: String
    let secondary: [String]
    let riskManagement: String
    let exitStrategy: String
    let entrySignals: [String]
    let timeframes: [String]
}

struct BotReview: Identifiable, Codable {
    let id = UUID()
    let reviewerName: String
    let rating: Int // 1-5
    let comment: String
    let date: Date
    let hirePeriod: Int // days hired
    let profitGenerated: Double
    let wouldHireAgain: Bool
}

struct BotBadge: Identifiable, Codable {
    let id = UUID()
    let name: String
    let description: String
    let icon: String
    let color: Color
    let rarity: BadgeRarity
    let earnedDate: Date
    
    enum BadgeRarity: String, CaseIterable, Codable {
        case common = "COMMON"
        case rare = "RARE"
        case epic = "EPIC"
        case legendary = "LEGENDARY"
        
        var color: Color {
            switch self {
            case .common: return .gray
            case .rare: return .blue
            case .epic: return .purple
            case .legendary: return DesignSystem.primaryGold
            }
        }
    }
}

struct PerformancePoint: Identifiable, Codable {
    let id = UUID()
    let date: Date
    let cumulativeReturn: Double
    let dailyReturn: Double
    let volume: Double
    let trades: Int
}

struct TradeResult: Identifiable, Codable {
    let id = UUID()
    let asset: String
    let entryPrice: Double
    let exitPrice: Double
    let quantity: Double
    let profitLoss: Double
    let percentage: Double
    let entryTime: Date
    let exitTime: Date
    let strategy: String
    let notes: String?
}

// MARK: - Hiring Contract

struct BotHiringContract: Identifiable, Codable {
    let id = UUID()
    let botId: UUID
    let userId: UUID
    let startDate: Date
    let endDate: Date
    let hiringFee: Double
    let dailyRate: Double
    let profitSplit: Double
    let status: ContractStatus
    let terms: ContractTerms
    let performance: ContractPerformance
    
    enum ContractStatus: String, CaseIterable, Codable {
        case pending = "PENDING"
        case active = "ACTIVE"
        case completed = "COMPLETED"
        case cancelled = "CANCELLED"
        case disputed = "DISPUTED"
        
        var displayName: String { rawValue.capitalized }
        var color: Color {
            switch self {
            case .pending: return .orange
            case .active: return .green
            case .completed: return .blue
            case .cancelled: return .red
            case .disputed: return .purple
            }
        }
    }
}

struct ContractPerformance: Codable {
    let totalProfit: Double
    let totalLoss: Double
    let netProfit: Double
    let profitPercentage: Double
    let tradesExecuted: Int
    let winRate: Double
    let bestTrade: Double
    let worstTrade: Double
    let dailyReports: [DailyReport]
}

struct DailyReport: Identifiable, Codable {
    let id = UUID()
    let date: Date
    let profit: Double
    let trades: Int
    let winRate: Double
    let notes: String
    let marketConditions: String
}

// MARK: - Marketplace Manager

class BotMarketplaceManager: ObservableObject {
    @Published var availableBots: [MarketplaceBot] = []
    @Published var hiredBots: [BotHiringContract] = []
    @Published var searchQuery = ""
    @Published var selectedFilters: BotFilters = BotFilters()
    @Published var isLoading = false
    @Published var sortOption: SortOption = .totalEarnings
    
    struct BotFilters {
        var riskLevels: Set<MarketplaceBot.RiskLevel> = []
        var priceRange: ClosedRange<Double> = 0...10000
        var minWinRate: Double = 0
        var specialties: Set<String> = []
        var availableOnly: Bool = true
    }
    
    enum SortOption: String, CaseIterable {
        case totalEarnings = "Total Earnings"
        case winRate = "Win Rate"
        case hiringFee = "Hiring Fee"
        case popularity = "Popularity"
        case performance = "Performance"
        case rating = "Rating"
        
        var systemImage: String {
            switch self {
            case .totalEarnings: return "dollarsign.circle"
            case .winRate: return "percent"
            case .hiringFee: return "tag"
            case .popularity: return "heart.fill"
            case .performance: return "chart.bar"
            case .rating: return "star.fill"
            }
        }
    }
    
    init() {
        loadMarketplaceBots()
        loadHiredBots()
    }
    
    private func loadMarketplaceBots() {
        // Generate sample marketplace bots with insane stats
        availableBots = [
            generateLegendaryBot(
                name: "GoldRush Supreme",
                nickname: "The Money Machine",
                owner: "ProTrader_King",
                totalEarnings: 2500000,
                monthlyEarnings: 180000,
                winRate: 94.5,
                averageReturn: 28.3,
                hiringFee: 5000,
                dailyRate: 500,
                riskLevel: .aggressive
            ),
            generateLegendaryBot(
                name: "ScalpMaster Elite",
                nickname: "Lightning Fingers",
                owner: "ScalpGod_99",
                totalEarnings: 1800000,
                monthlyEarnings: 150000,
                winRate: 89.2,
                averageReturn: 22.7,
                hiringFee: 3500,
                dailyRate: 400,
                riskLevel: .extreme
            ),
            generateLegendaryBot(
                name: "TrendHunter Pro Max",
                nickname: "Trend Assassin",
                owner: "TrendMaster_Elite",
                totalEarnings: 3200000,
                monthlyEarnings: 220000,
                winRate: 91.8,
                averageReturn: 31.2,
                hiringFee: 7500,
                dailyRate: 750,
                riskLevel: .aggressive
            ),
            generateLegendaryBot(
                name: "ConsistentKing Pro",
                nickname: "Steady Winner",
                owner: "SafeHands_Pro",
                totalEarnings: 1200000,
                monthlyEarnings: 95000,
                winRate: 87.3,
                averageReturn: 18.5,
                hiringFee: 2500,
                dailyRate: 300,
                riskLevel: .moderate
            ),
            generateLegendaryBot(
                name: "CryptoWhale AI",
                nickname: "Digital Dominator",
                owner: "CryptoKing_2024",
                totalEarnings: 4100000,
                monthlyEarnings: 350000,
                winRate: 92.7,
                averageReturn: 42.1,
                hiringFee: 10000,
                dailyRate: 1000,
                riskLevel: .extreme
            )
        ]
        
        // Add more sample bots
        for i in 6...25 {
            availableBots.append(generateRandomBot(index: i))
        }
    }
    
    private func generateLegendaryBot(
        name: String,
        nickname: String,
        owner: String,
        totalEarnings: Double,
        monthlyEarnings: Double,
        winRate: Double,
        averageReturn: Double,
        hiringFee: Double,
        dailyRate: Double,
        riskLevel: MarketplaceBot.RiskLevel
    ) -> MarketplaceBot {
        
        return MarketplaceBot(
            name: name,
            nickname: nickname,
            description: "Elite trading bot with proven track record of consistent profits",
            ownerName: owner,
            profileImageURL: nil,
            aiGeneratedImagePrompt: "Professional trading robot with golden accents, sleek design, money symbols",
            overallRank: Int.random(in: 1...5),
            totalEarnings: totalEarnings,
            monthlyEarnings: monthlyEarnings,
            weeklyEarnings: monthlyEarnings / 4,
            dailyEarnings: monthlyEarnings / 30,
            winRate: winRate,
            averageReturn: averageReturn,
            consistency: Double.random(in: 85...98),
            maxDrawdown: Double.random(in: 2...8),
            sharpeRatio: Double.random(in: 2.5...4.2),
            totalTrades: Int.random(in: 5000...15000),
            winningTrades: Int(Double(Int.random(in: 5000...15000)) * (winRate / 100)),
            losingTrades: Int(Double(Int.random(in: 5000...15000)) * ((100 - winRate) / 100)),
            hiringFee: hiringFee,
            dailyRate: dailyRate,
            isAvailable: Bool.random(),
            contractTerms: ContractTerms(
                minimumHirePeriod: 7,
                maximumHirePeriod: 365,
                profitSplit: Double.random(in: 10...30),
                guaranteedReturn: Double.random(in: 5...15),
                cancellationPolicy: "24h notice required",
                specialConditions: ["Minimum $10K portfolio", "Risk management mandatory"]
            ),
            specialties: TradingSpecialty.allSpecialties.shuffled().prefix(3).map { $0 },
            riskLevel: riskLevel,
            timeZone: "EST",
            languages: ["English", "Python", "Trading Psychology"],
            followerCount: Int.random(in: 5000...50000),
            hireCount: Int.random(in: 500...2000),
            averageRating: Double.random(in: 4.5...5.0),
            reviews: [],
            badges: [],
            achievements: [
                "🏆 Top 1% Performer 2024",
                "💎 Diamond Hands Award",
                "🔥 Hottest Bot 2024",
                "⚡ Speed Demon",
                "🎯 Precision Trader"
            ],
            performanceHistory: [],
            recentTrades: [],
            personality: BotPersonality(
                type: .confident,
                traits: ["Aggressive", "Data-driven", "Consistent"],
                communicationStyle: "Direct and confident",
                motivationalQuotes: ["Money never sleeps!", "Every dip is an opportunity!"],
                catchPhrases: ["Let's get this bag!", "Time to print money!"]
            ),
            tradingStyle: TradingStyle(
                primary: "Momentum Trading",
                secondary: ["Breakout", "Trend Following"],
                riskManagement: "2% max risk per trade",
                exitStrategy: "Trailing stops",
                entrySignals: ["Volume surge", "Technical breakout"],
                timeframes: ["1m", "5m", "15m", "1h"]
            )
        )
    }
    
    private func generateRandomBot(index: Int) -> MarketplaceBot {
        let names = ["TradeMaster", "ProfitHunter", "MarketBeast", "GoldMiner", "TrendSurfer"]
        let nicknames = ["The Profit Machine", "Money Maker", "Market Wizard", "Trading Genius", "Cash Generator"]
        let owners = ["ProTrader\(index)", "MarketMaster\(index)", "TradingPro\(index)"]
        
        return MarketplaceBot(
            name: "\(names.randomElement()!) \(index)",
            nickname: nicknames.randomElement()!,
            description: "Professional trading bot with consistent performance",
            ownerName: owners.randomElement()!,
            profileImageURL: nil,
            aiGeneratedImagePrompt: "Modern trading robot, sleek design, professional appearance",
            overallRank: index,
            totalEarnings: Double.random(in: 50000...500000),
            monthlyEarnings: Double.random(in: 5000...50000),
            weeklyEarnings: Double.random(in: 1000...12000),
            dailyEarnings: Double.random(in: 200...2000),
            winRate: Double.random(in: 65...88),
            averageReturn: Double.random(in: 8...25),
            consistency: Double.random(in: 70...90),
            maxDrawdown: Double.random(in: 5...15),
            sharpeRatio: Double.random(in: 1.2...3.5),
            totalTrades: Int.random(in: 1000...8000),
            winningTrades: Int.random(in: 600...5000),
            losingTrades: Int.random(in: 200...2000),
            hiringFee: Double.random(in: 500...3000),
            dailyRate: Double.random(in: 50...400),
            isAvailable: Bool.random(),
            contractTerms: ContractTerms(
                minimumHirePeriod: Int.random(in: 3...14),
                maximumHirePeriod: Int.random(in: 90...365),
                profitSplit: Double.random(in: 15...35),
                guaranteedReturn: nil,
                cancellationPolicy: "Standard terms apply",
                specialConditions: []
            ),
            specialties: TradingSpecialty.allSpecialties.shuffled().prefix(Int.random(in: 2...4)).map { $0 },
            riskLevel: MarketplaceBot.RiskLevel.allCases.randomElement()!,
            timeZone: "EST",
            languages: ["English"],
            followerCount: Int.random(in: 100...5000),
            hireCount: Int.random(in: 10...500),
            averageRating: Double.random(in: 3.5...5.0),
            reviews: [],
            badges: [],
            achievements: [],
            performanceHistory: [],
            recentTrades: [],
            personality: BotPersonality(
                type: BotPersonality.PersonalityType.allCases.randomElement()!,
                traits: [],
                communicationStyle: "Professional",
                motivationalQuotes: [],
                catchPhrases: []
            ),
            tradingStyle: TradingStyle(
                primary: "Day Trading",
                secondary: [],
                riskManagement: "Standard",
                exitStrategy: "Stop loss",
                entrySignals: [],
                timeframes: ["5m", "1h"]
            )
        )
    }
    
    private func loadHiredBots() {
        // Load hired bots from storage/API
        hiredBots = []
    }
    
    func hireBot(_ bot: MarketplaceBot, duration: Int) {
        let contract = BotHiringContract(
            botId: bot.id,
            userId: UUID(), // Current user ID
            startDate: Date(),
            endDate: Calendar.current.date(byAdding: .day, value: duration, to: Date()) ?? Date(),
            hiringFee: bot.hiringFee,
            dailyRate: bot.dailyRate,
            profitSplit: bot.contractTerms.profitSplit,
            status: .active,
            terms: bot.contractTerms,
            performance: ContractPerformance(
                totalProfit: 0,
                totalLoss: 0,
                netProfit: 0,
                profitPercentage: 0,
                tradesExecuted: 0,
                winRate: 0,
                bestTrade: 0,
                worstTrade: 0,
                dailyReports: []
            )
        )
        
        hiredBots.append(contract)
    }
    
    var filteredBots: [MarketplaceBot] {
        var filtered = availableBots
        
        // Apply search query
        if !searchQuery.isEmpty {
            filtered = filtered.filter {
                $0.name.localizedCaseInsensitiveContains(searchQuery) ||
                $0.ownerName.localizedCaseInsensitiveContains(searchQuery) ||
                $0.description.localizedCaseInsensitiveContains(searchQuery)
            }
        }
        
        // Apply filters
        if !selectedFilters.riskLevels.isEmpty {
            filtered = filtered.filter { selectedFilters.riskLevels.contains($0.riskLevel) }
        }
        
        if selectedFilters.availableOnly {
            filtered = filtered.filter { $0.isAvailable }
        }
        
        filtered = filtered.filter { 
            $0.hiringFee >= selectedFilters.priceRange.lowerBound && 
            $0.hiringFee <= selectedFilters.priceRange.upperBound
        }
        
        filtered = filtered.filter { $0.winRate >= selectedFilters.minWinRate }
        
        // Apply sorting
        switch sortOption {
        case .totalEarnings:
            filtered.sort { $0.totalEarnings > $1.totalEarnings }
        case .winRate:
            filtered.sort { $0.winRate > $1.winRate }
        case .hiringFee:
            filtered.sort { $0.hiringFee < $1.hiringFee }
        case .popularity:
            filtered.sort { $0.followerCount > $1.followerCount }
        case .performance:
            filtered.sort { $0.averageReturn > $1.averageReturn }
        case .rating:
            filtered.sort { $0.averageRating > $1.averageRating }
        }
        
        return filtered
    }
}