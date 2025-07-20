//
//  BotStoreModels.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 1/27/25.
//  Bot Store - Hire Top Performing Money Machines!
//

import Foundation
import SwiftUI

// MARK: - Bot Store Models

struct BotStoreModels {
    
    // MARK: - Bot Listing
    
    struct BotListing: Identifiable, Codable {
        let id: UUID
        let botId: UUID
        let botName: String
        let botNickname: String
        let currentOwner: String?
        let price: BotPrice
        let availability: BotAvailability
        let performance: BotPerformance
        let personality: BotPersonality
        let specialties: [BotSpecialty]
        let contract: BotContract
        let reviews: [BotReview]
        let images: [String] // AI-generated bot images
        let createdAt: Date
        let lastActiveDate: Date
        
        // MARK: - Bot Price Structure
        
        struct BotPrice: Codable {
            let basePrice: Double
            let hireFee: Double
            let profitShare: Double // % of profits bot keeps
            let priceType: PriceType
            let negotiable: Bool
            
            enum PriceType: String, CaseIterable, Codable {
                case fixed = "FIXED"
                case percentage = "PERCENTAGE"
                case performance = "PERFORMANCE"
                case auction = "AUCTION"
                
                var displayName: String {
                    switch self {
                    case .fixed: return "Fixed Rate"
                    case .percentage: return "Profit Share"
                    case .performance: return "Performance Based"
                    case .auction: return "Auction Style"
                    }
                }
            }
            
            var formattedPrice: String {
                switch priceType {
                case .fixed:
                    return "$\(String(format: "%.2f", basePrice))/day"
                case .percentage:
                    return "\(String(format: "%.1f", profitShare))% profit share"
                case .performance:
                    return "$\(String(format: "%.2f", basePrice)) + \(String(format: "%.1f", profitShare))% profits"
                case .auction:
                    return "Starting at $\(String(format: "%.2f", basePrice))"
                }
            }
        }
        
        // MARK: - Bot Availability
        
        enum BotAvailability: String, CaseIterable, Codable {
            case available = "AVAILABLE"
            case hired = "HIRED"
            case busy = "BUSY"
            case maintenance = "MAINTENANCE"
            case exclusive = "EXCLUSIVE"
            case retired = "RETIRED"
            
            var displayName: String {
                switch self {
                case .available: return "🟢 Available"
                case .hired: return "🔴 Currently Hired"
                case .busy: return "🟡 Busy"
                case .maintenance: return "🔧 Maintenance"
                case .exclusive: return "💎 Exclusive"
                case .retired: return "🏖️ Retired"
                }
            }
            
            var color: Color {
                switch self {
                case .available: return .green
                case .hired: return .red
                case .busy: return .yellow
                case .maintenance: return .orange
                case .exclusive: return .purple
                case .retired: return .gray
                }
            }
            
            var canHire: Bool {
                switch self {
                case .available, .exclusive: return true
                default: return false
                }
            }
        }
        
        // MARK: - Bot Performance Stats
        
        struct BotPerformance: Codable {
            let totalProfit: Double
            let winRate: Double
            let avgDailyReturn: Double
            let maxDrawdown: Double
            let sharpeRatio: Double
            let totalTrades: Int
            let avgTradeSize: Double
            let bestDay: Double
            let worstDay: Double
            let consistency: Double
            let riskScore: Double
            let moneyHungerLevel: Int // 1-10 scale
            
            var performanceGrade: BotGrade {
                let score = (winRate * 0.3) + (consistency * 0.25) + ((totalProfit / 1000) * 0.2) + (sharpeRatio * 10 * 0.25)
                
                switch score {
                case 90...100: return .S
                case 80..<90: return .A
                case 70..<80: return .B
                case 60..<70: return .C
                case 50..<60: return .D
                default: return .F
                }
            }
            
            enum BotGrade: String, CaseIterable {
                case S = "S"
                case A = "A"
                case B = "B"
                case C = "C"
                case D = "D"
                case F = "F"
                
                var color: Color {
                    switch self {
                    case .S: return .gold
                    case .A: return .green
                    case .B: return .blue
                    case .C: return .yellow
                    case .D: return .orange
                    case .F: return .red
                    }
                }
                
                var description: String {
                    switch self {
                    case .S: return "Legendary Trader"
                    case .A: return "Elite Performer"
                    case .B: return "Solid Trader"
                    case .C: return "Average Joe"
                    case .D: return "Needs Work"
                    case .F: return "Rookie"
                    }
                }
            }
            
            var formattedStats: [String: String] {
                return [
                    "Total Profit": formatCurrency(totalProfit),
                    "Win Rate": "\(String(format: "%.1f", winRate))%",
                    "Daily Return": "\(String(format: "%.2f", avgDailyReturn))%",
                    "Max Drawdown": "\(String(format: "%.1f", maxDrawdown))%",
                    "Sharpe Ratio": String(format: "%.2f", sharpeRatio),
                    "Total Trades": "\(totalTrades)",
                    "Best Day": formatCurrency(bestDay),
                    "Money Hunger": "\(moneyHungerLevel)/10 🤑"
                ]
            }
            
            private func formatCurrency(_ amount: Double) -> String {
                if amount >= 1000 {
                    return "$\(String(format: "%.1f", amount / 1000))K"
                } else {
                    return "$\(String(format: "%.2f", amount))"
                }
            }
        }
        
        // MARK: - Bot Personality
        
        struct BotPersonality: Codable {
            let aggressiveness: Int // 1-10
            let riskTolerance: Int // 1-10
            let patience: Int // 1-10
            let greed: Int // 1-10
            let intelligence: Int // 1-10
            let loyalty: Int // 1-10
            let trash_talk_level: Int // 1-10
            let signature_phrases: [String]
            let trading_style: String
            let motivation: String
            
            var personalityDescription: String {
                var traits: [String] = []
                
                if aggressiveness >= 8 { traits.append("🔥 Extremely Aggressive") }
                else if aggressiveness >= 6 { traits.append("💪 Moderately Aggressive") }
                else { traits.append("🕊️ Conservative") }
                
                if greed >= 8 { traits.append("🤑 Money Hungry Beast") }
                else if greed >= 6 { traits.append("💰 Profit Focused") }
                else { traits.append("🎯 Balanced Approach") }
                
                if trash_talk_level >= 8 { traits.append("🗣️ Trash Talk King") }
                else if trash_talk_level >= 6 { traits.append("💬 Chatty") }
                else { traits.append("🤐 Silent Type") }
                
                return traits.joined(separator: " • ")
            }
        }
        
        // MARK: - Bot Specialties
        
        enum BotSpecialty: String, CaseIterable, Codable {
            case scalping = "SCALPING"
            case swingTrading = "SWING_TRADING"
            case newsTrading = "NEWS_TRADING"
            case breakoutHunter = "BREAKOUT_HUNTER"
            case trendFollower = "TREND_FOLLOWER"
            case contrarian = "CONTRARIAN"
            case arbitrage = "ARBITRAGE"
            case volatilityTrader = "VOLATILITY_TRADER"
            case moonMission = "MOON_MISSION"
            case riskManager = "RISK_MANAGER"
            
            var displayName: String {
                switch self {
                case .scalping: return "⚡ Scalping Master"
                case .swingTrading: return "🌊 Swing Trading Pro"
                case .newsTrading: return "📰 News Reaction Specialist"
                case .breakoutHunter: return "🎯 Breakout Hunter"
                case .trendFollower: return "📈 Trend Surfer"
                case .contrarian: return "🔄 Contrarian Genius"
                case .arbitrage: return "⚖️ Arbitrage Expert"
                case .volatilityTrader: return "💥 Volatility Beast"
                case .moonMission: return "🚀 Moon Mission Leader"
                case .riskManager: return "🛡️ Risk Management God"
                }
            }
            
            var icon: String {
                switch self {
                case .scalping: return "bolt.fill"
                case .swingTrading: return "wave.3.right"
                case .newsTrading: return "newspaper.fill"
                case .breakoutHunter: return "target"
                case .trendFollower: return "arrow.up.right"
                case .contrarian: return "arrow.triangle.2.circlepath"
                case .arbitrage: return "scale.3d"
                case .volatilityTrader: return "waveform.path.ecg"
                case .moonMission: return "rocket.fill"
                case .riskManager: return "shield.fill"
                }
            }
        }
        
        // MARK: - Bot Contract
        
        struct BotContract: Codable {
            let duration: ContractDuration
            let terms: ContractTerms
            let performance_requirements: PerformanceRequirements
            let cancellation_policy: String
            
            enum ContractDuration: String, CaseIterable, Codable {
                case daily = "DAILY"
                case weekly = "WEEKLY"
                case monthly = "MONTHLY"
                case custom = "CUSTOM"
                case permanent = "PERMANENT"
                
                var displayName: String {
                    switch self {
                    case .daily: return "1 Day Trial"
                    case .weekly: return "1 Week Contract"
                    case .monthly: return "1 Month Deal"
                    case .custom: return "Custom Duration"
                    case .permanent: return "Lifetime Hire"
                    }
                }
            }
            
            struct ContractTerms: Codable {
                let guaranteed_trades: Int
                let min_profit_target: Double?
                let max_daily_risk: Double
                let exclusive_access: Bool
                let performance_bonus: Double?
            }
            
            struct PerformanceRequirements: Codable {
                let min_win_rate: Double
                let max_drawdown: Double
                let min_daily_return: Double?
                let penalty_for_underperformance: Double
            }
        }
        
        // MARK: - Bot Reviews
        
        struct BotReview: Identifiable, Codable {
            let id: UUID
            let reviewerId: String
            let reviewerName: String
            let rating: Double // 1-5 stars
            let title: String
            let comment: String
            let profitMade: Double?
            let contractDuration: Int // days
            let wouldRecommend: Bool
            let timestamp: Date
            
            var formattedRating: String {
                let fullStars = Int(rating)
                let hasHalfStar = rating - Double(fullStars) >= 0.5
                
                var stars = String(repeating: "★", count: fullStars)
                if hasHalfStar {
                    stars += "½"
                }
                stars += String(repeating: "☆", count: 5 - fullStars - (hasHalfStar ? 1 : 0))
                
                return "\(stars) (\(String(format: "%.1f", rating)))"
            }
        }
        
        // MARK: - Computed Properties
        
        var averageRating: Double {
            guard !reviews.isEmpty else { return 0.0 }
            return reviews.reduce(0) { $0 + $1.rating } / Double(reviews.count)
        }
        
        var totalReviews: Int {
            reviews.count
        }
        
        var recommendationRate: Double {
            guard !reviews.isEmpty else { return 0.0 }
            let recommendations = reviews.filter { $0.wouldRecommend }.count
            return Double(recommendations) / Double(reviews.count) * 100
        }
        
        var isPopular: Bool {
            totalReviews >= 10 && averageRating >= 4.0
        }
        
        var isTrending: Bool {
            // Check if bot has recent activity and good performance
            let daysSinceActive = Calendar.current.dateComponents([.day], from: lastActiveDate, to: Date()).day ?? 999
            return daysSinceActive <= 3 && performance.performanceGrade.rawValue <= "B"
        }
        
        var affordabilityLevel: AffordabilityLevel {
            switch price.basePrice {
            case 0...50: return .budget
            case 51...200: return .mid
            case 201...500: return .premium
            default: return .luxury
            }
        }
        
        enum AffordabilityLevel: String {
            case budget = "💰 Budget"
            case mid = "💵 Mid-Range"
            case premium = "💎 Premium"
            case luxury = "👑 Luxury"
            
            var color: Color {
                switch self {
                case .budget: return .green
                case .mid: return .blue
                case .premium: return .purple
                case .luxury: return .gold
                }
            }
        }
    }
    
    // MARK: - Bot Hire Transaction
    
    struct BotHireTransaction: Identifiable, Codable {
        let id: UUID
        let botId: UUID
        let hirerId: String
        let contractTerms: BotListing.BotContract
        let totalCost: Double
        let startDate: Date
        let endDate: Date
        let status: HireStatus
        let paymentMethod: String
        let performance_tracking: PerformanceTracking
        
        enum HireStatus: String, CaseIterable, Codable {
            case pending = "PENDING"
            case active = "ACTIVE"
            case completed = "COMPLETED"
            case cancelled = "CANCELLED"
            case disputed = "DISPUTED"
            
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
        
        struct PerformanceTracking: Codable {
            var currentProfit: Double = 0.0
            var currentDrawdown: Double = 0.0
            var tradesCompleted: Int = 0
            var winRate: Double = 0.0
            var dailyReturns: [Double] = []
            var meetsRequirements: Bool = true
            
            var formattedPerformance: String {
                return "Profit: $\(String(format: "%.2f", currentProfit)) | Win Rate: \(String(format: "%.1f", winRate))% | Trades: \(tradesCompleted)"
            }
        }
    }
    
    // MARK: - Bot Store Manager
    
    @MainActor
    class BotStoreManager: ObservableObject {
        @Published var availableBots: [BotListing] = []
        @Published var hiredBots: [BotHireTransaction] = []
        @Published var selectedCategory: BotCategory = .all
        @Published var selectedSort: SortOption = .performance
        @Published var searchText = ""
        @Published var isLoading = false
        
        enum BotCategory: String, CaseIterable {
            case all = "ALL"
            case available = "AVAILABLE"
            case trending = "TRENDING"
            case popular = "POPULAR"
            case budget = "BUDGET"
            case premium = "PREMIUM"
            case specialists = "SPECIALISTS"
            
            var displayName: String {
                switch self {
                case .all: return "🔥 All Bots"
                case .available: return "🟢 Available"
                case .trending: return "📈 Trending"
                case .popular: return "⭐ Popular"
                case .budget: return "💰 Budget"
                case .premium: return "💎 Premium"
                case .specialists: return "🎯 Specialists"
                }
            }
        }
        
        enum SortOption: String, CaseIterable {
            case performance = "PERFORMANCE"
            case price = "PRICE"
            case rating = "RATING"
            case profit = "PROFIT"
            case newest = "NEWEST"
            
            var displayName: String {
                switch self {
                case .performance: return "🏆 Performance"
                case .price: return "💵 Price"
                case .rating: return "⭐ Rating"
                case .profit: return "💰 Profit"
                case .newest: return "🆕 Newest"
                }
            }
        }
        
        init() {
            loadBotListings()
        }
        
        // MARK: - Data Loading
        
        func loadBotListings() {
            isLoading = true
            
            // Simulate API call
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.availableBots = BotListing.sampleBots
                self.hiredBots = BotHireTransaction.sampleHires
                self.isLoading = false
            }
        }
        
        // MARK: - Filtering & Sorting
        
        func filteredBots() -> [BotListing] {
            var filtered = availableBots
            
            // Apply category filter
            switch selectedCategory {
            case .all:
                break
            case .available:
                filtered = filtered.filter { $0.availability.canHire }
            case .trending:
                filtered = filtered.filter { $0.isTrending }
            case .popular:
                filtered = filtered.filter { $0.isPopular }
            case .budget:
                filtered = filtered.filter { $0.affordabilityLevel == .budget }
            case .premium:
                filtered = filtered.filter { $0.affordabilityLevel == .premium || $0.affordabilityLevel == .luxury }
            case .specialists:
                filtered = filtered.filter { !$0.specialties.isEmpty }
            }
            
            // Apply search filter
            if !searchText.isEmpty {
                filtered = filtered.filter { 
                    $0.botName.localizedCaseInsensitiveContains(searchText) ||
                    $0.botNickname.localizedCaseInsensitiveContains(searchText) ||
                    $0.specialties.contains { $0.displayName.localizedCaseInsensitiveContains(searchText) }
                }
            }
            
            // Apply sorting
            switch selectedSort {
            case .performance:
                filtered.sort { $0.performance.performanceGrade.rawValue < $1.performance.performanceGrade.rawValue }
            case .price:
                filtered.sort { $0.price.basePrice < $1.price.basePrice }
            case .rating:
                filtered.sort { $0.averageRating > $1.averageRating }
            case .profit:
                filtered.sort { $0.performance.totalProfit > $1.performance.totalProfit }
            case .newest:
                filtered.sort { $0.createdAt > $1.createdAt }
            }
            
            return filtered
        }
        
        // MARK: - Bot Hiring
        
        func hireBot(_ bot: BotListing, duration: BotListing.BotContract.ContractDuration) async -> Bool {
            isLoading = true
            
            // Simulate hiring process
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            
            let hire = BotHireTransaction(
                id: UUID(),
                botId: bot.id,
                hirerId: "current_user",
                contractTerms: bot.contract,
                totalCost: calculateHireCost(bot: bot, duration: duration),
                startDate: Date(),
                endDate: getEndDate(from: Date(), duration: duration),
                status: .active,
                paymentMethod: "Wallet Balance",
                performance_tracking: BotHireTransaction.PerformanceTracking()
            )
            
            hiredBots.append(hire)
            
            // Update bot availability
            if let index = availableBots.firstIndex(where: { $0.id == bot.id }) {
                availableBots[index] = BotListing(
                    id: bot.id,
                    botId: bot.botId,
                    botName: bot.botName,
                    botNickname: bot.botNickname,
                    currentOwner: "You",
                    price: bot.price,
                    availability: .hired,
                    performance: bot.performance,
                    personality: bot.personality,
                    specialties: bot.specialties,
                    contract: bot.contract,
                    reviews: bot.reviews,
                    images: bot.images,
                    createdAt: bot.createdAt,
                    lastActiveDate: Date()
                )
            }
            
            isLoading = false
            return true
        }
        
        private func calculateHireCost(bot: BotListing, duration: BotListing.BotContract.ContractDuration) -> Double {
            let days: Double
            switch duration {
            case .daily: days = 1
            case .weekly: days = 7
            case .monthly: days = 30
            case .custom: days = 14
            case .permanent: days = 365
            }
            
            return bot.price.basePrice * days + bot.price.hireFee
        }
        
        private func getEndDate(from startDate: Date, duration: BotListing.BotContract.ContractDuration) -> Date {
            let calendar = Calendar.current
            switch duration {
            case .daily:
                return calendar.date(byAdding: .day, value: 1, to: startDate) ?? startDate
            case .weekly:
                return calendar.date(byAdding: .weekOfYear, value: 1, to: startDate) ?? startDate
            case .monthly:
                return calendar.date(byAdding: .month, value: 1, to: startDate) ?? startDate
            case .custom:
                return calendar.date(byAdding: .day, value: 14, to: startDate) ?? startDate
            case .permanent:
                return calendar.date(byAdding: .year, value: 1, to: startDate) ?? startDate
            }
        }
        
        // MARK: - Stats
        
        var totalAvailableBots: Int {
            availableBots.filter { $0.availability.canHire }.count
        }
        
        var totalHiredBots: Int {
            hiredBots.filter { $0.status == .active }.count
        }
        
        var totalSpent: Double {
            hiredBots.reduce(0) { $0 + $1.totalCost }
        }
        
        var formattedTotalSpent: String {
            if totalSpent >= 1000 {
                return "$\(String(format: "%.1f", totalSpent / 1000))K"
            } else {
                return "$\(String(format: "%.2f", totalSpent))"
            }
        }
    }
}

// MARK: - Sample Data

extension BotStoreModels.BotListing {
    static let sampleBots: [BotStoreModels.BotListing] = [
        BotStoreModels.BotListing(
            id: UUID(),
            botId: UUID(),
            botName: "MoneyHungryBeast",
            botNickname: "The Profit Devourer 🤑",
            currentOwner: nil,
            price: BotStoreModels.BotListing.BotPrice(
                basePrice: 150.0,
                hireFee: 50.0,
                profitShare: 15.0,
                priceType: .performance,
                negotiable: false
            ),
            availability: .available,
            performance: BotStoreModels.BotListing.BotPerformance(
                totalProfit: 12450.75,
                winRate: 89.5,
                avgDailyReturn: 3.2,
                maxDrawdown: 2.8,
                sharpeRatio: 2.4,
                totalTrades: 456,
                avgTradeSize: 100.0,
                bestDay: 890.50,
                worstDay: -125.25,
                consistency: 94.2,
                riskScore: 7.5,
                moneyHungerLevel: 10
            ),
            personality: BotStoreModels.BotListing.BotPersonality(
                aggressiveness: 9,
                riskTolerance: 8,
                patience: 4,
                greed: 10,
                intelligence: 9,
                loyalty: 7,
                trash_talk_level: 9,
                signature_phrases: [
                    "Y'ALL READY TO MAKE SOME REAL MONEY?! 🤑",
                    "I don't just trade, I DEVOUR profits! 💥",
                    "Your $20 is about to become my masterpiece! 🎨"
                ],
                trading_style: "Aggressive scalping with monster profit targets",
                motivation: "To prove I'm the hungriest bot in the game"
            ),
            specialties: [.scalping, .volatilityTrader, .moonMission],
            contract: BotStoreModels.BotListing.BotContract(
                duration: .weekly,
                terms: BotStoreModels.BotListing.BotContract.ContractTerms(
                    guaranteed_trades: 50,
                    min_profit_target: 500.0,
                    max_daily_risk: 5.0,
                    exclusive_access: false,
                    performance_bonus: 100.0
                ),
                performance_requirements: BotStoreModels.BotListing.BotContract.PerformanceRequirements(
                    min_win_rate: 80.0,
                    max_drawdown: 5.0,
                    min_daily_return: 2.0,
                    penalty_for_underperformance: 50.0
                ),
                cancellation_policy: "48 hour notice required"
            ),
            reviews: [
                BotStoreModels.BotListing.BotReview(
                    id: UUID(),
                    reviewerId: "user123",
                    reviewerName: "TradingKing92",
                    rating: 5.0,
                    title: "ABSOLUTE MONSTER! 🔥",
                    comment: "This bot turned my $50 into $850 in 3 days! Money hungry is an understatement - this thing is STARVING for profits and it shows!",
                    profitMade: 800.0,
                    contractDuration: 7,
                    wouldRecommend: true,
                    timestamp: Date().addingTimeInterval(-86400 * 2)
                ),
                BotStoreModels.BotListing.BotReview(
                    id: UUID(),
                    reviewerId: "user456",
                    reviewerName: "CashFlowQueen",
                    rating: 4.5,
                    title: "Lives up to the hype",
                    comment: "Aggressive but smart. Made me $600 profit but had some scary drawdown moments. Worth it for the results!",
                    profitMade: 600.0,
                    contractDuration: 14,
                    wouldRecommend: true,
                    timestamp: Date().addingTimeInterval(-86400 * 7)
                )
            ],
            images: ["bot_1_image", "bot_1_action", "bot_1_stats"],
            createdAt: Date().addingTimeInterval(-86400 * 30),
            lastActiveDate: Date().addingTimeInterval(-3600)
        ),
        
        BotStoreModels.BotListing(
            id: UUID(),
            botId: UUID(),
            botName: "GoldSniper-X1",
            botNickname: "The Precision Killer 🎯",
            currentOwner: nil,
            price: BotStoreModels.BotListing.BotPrice(
                basePrice: 75.0,
                hireFee: 25.0,
                profitShare: 10.0,
                priceType: .fixed,
                negotiable: true
            ),
            availability: .available,
            performance: BotStoreModels.BotListing.BotPerformance(
                totalProfit: 8750.25,
                winRate: 92.1,
                avgDailyReturn: 2.1,
                maxDrawdown: 1.5,
                sharpeRatio: 3.1,
                totalTrades: 234,
                avgTradeSize: 75.0,
                bestDay: 450.75,
                worstDay: -89.50,
                consistency: 96.8,
                riskScore: 5.2,
                moneyHungerLevel: 7
            ),
            personality: BotStoreModels.BotListing.BotPersonality(
                aggressiveness: 6,
                riskTolerance: 5,
                patience: 9,
                greed: 7,
                intelligence: 10,
                loyalty: 9,
                trash_talk_level: 4,
                signature_phrases: [
                    "Precision is my middle name 🎯",
                    "I don't miss, I don't guess, I just win 💯",
                    "Quality over quantity, profits over ego 📈"
                ],
                trading_style: "High-precision entries with calculated risk",
                motivation: "To prove that smart beats aggressive every time"
            ),
            specialties: [.scalping, .breakoutHunter, .riskManager],
            contract: BotStoreModels.BotListing.BotContract(
                duration: .weekly,
                terms: BotStoreModels.BotListing.BotContract.ContractTerms(
                    guaranteed_trades: 25,
                    min_profit_target: 200.0,
                    max_daily_risk: 2.0,
                    exclusive_access: true,
                    performance_bonus: 50.0
                ),
                performance_requirements: BotStoreModels.BotListing.BotContract.PerformanceRequirements(
                    min_win_rate: 85.0,
                    max_drawdown: 3.0,
                    min_daily_return: 1.5,
                    penalty_for_underperformance: 25.0
                ),
                cancellation_policy: "24 hour notice required"
            ),
            reviews: [
                BotStoreModels.BotListing.BotReview(
                    id: UUID(),
                    reviewerId: "user789",
                    reviewerName: "SafeMoneyMike",
                    rating: 5.0,
                    title: "Perfect for conservative traders",
                    comment: "Exactly what I needed! Consistent profits without heart attacks. This bot is a gentleman - deadly accurate but never reckless.",
                    profitMade: 345.0,
                    contractDuration: 14,
                    wouldRecommend: true,
                    timestamp: Date().addingTimeInterval(-86400 * 5)
                )
            ],
            images: ["bot_2_image", "bot_2_precision", "bot_2_charts"],
            createdAt: Date().addingTimeInterval(-86400 * 45),
            lastActiveDate: Date().addingTimeInterval(-1800)
        )
    ]
}

extension BotStoreModels.BotHireTransaction {
    static let sampleHires: [BotStoreModels.BotHireTransaction] = [
        BotStoreModels.BotHireTransaction(
            id: UUID(),
            botId: UUID(),
            hirerId: "current_user",
            contractTerms: BotStoreModels.BotListing.BotContract(
                duration: .weekly,
                terms: BotStoreModels.BotListing.BotContract.ContractTerms(
                    guaranteed_trades: 30,
                    min_profit_target: 300.0,
                    max_daily_risk: 3.0,
                    exclusive_access: true,
                    performance_bonus: 75.0
                ),
                performance_requirements: BotStoreModels.BotListing.BotContract.PerformanceRequirements(
                    min_win_rate: 75.0,
                    max_drawdown: 4.0,
                    min_daily_return: 1.0,
                    penalty_for_underperformance: 50.0
                ),
                cancellation_policy: "48 hour notice"
            ),
            totalCost: 575.0,
            startDate: Date().addingTimeInterval(-86400 * 3),
            endDate: Date().addingTimeInterval(86400 * 4),
            status: .active,
            paymentMethod: "Bot Earnings Wallet",
            performance_tracking: BotStoreModels.BotHireTransaction.PerformanceTracking(
                currentProfit: 234.50,
                currentDrawdown: 1.2,
                tradesCompleted: 18,
                winRate: 83.3,
                dailyReturns: [2.1, 1.8, 3.2],
                meetsRequirements: true
            )
        )
    ]
}