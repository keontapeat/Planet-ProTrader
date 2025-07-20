import SwiftUI
import Foundation

// MARK: - Supporting Enums with Codable Conformance

enum BotCategory: String, CaseIterable, Codable {
    case scalper = "Scalper"
    case swing = "Swing Trader"
    case news = "News Trader"
    case technical = "Technical Trader"
    case dayTrader = "Day Trader"
    case arbitrage = "Arbitrage"
    case grid = "Grid Trader"
    
    var emoji: String {
        switch self {
        case .scalper: return "⚡"
        case .swing: return "🌊"
        case .news: return "📰"
        case .technical: return "📈"
        case .dayTrader: return "☀️"
        case .arbitrage: return "⚖️"
        case .grid: return "🕸️"
        }
    }
    
    var description: String {
        switch self {
        case .scalper: return "High-frequency micro-profit specialist"
        case .swing: return "Multi-day trend follower"
        case .news: return "Event-driven trading expert"
        case .technical: return "Chart pattern master"
        case .dayTrader: return "Intraday momentum trader"
        case .arbitrage: return "Price difference exploiter"
        case .grid: return "Automated grid system"
        }
    }
}

enum MarketplaceRiskLevel: String, CaseIterable, Codable {
    case low = "Low Risk"
    case medium = "Medium Risk"
    case high = "High Risk"
    case extreme = "Extreme Risk"
    
    var color: Color {
        switch self {
        case .low: return .green
        case .medium: return .yellow
        case .high: return .orange
        case .extreme: return .red
        }
    }
    
    var emoji: String {
        switch self {
        case .low: return "🛡️"
        case .medium: return "⚖️"
        case .high: return "⚔️"
        case .extreme: return "🔥"
        }
    }
}

enum MarketplacePopularityLevel: String, CaseIterable, Codable {
    case new = "New"
    case rising = "Rising"
    case popular = "Popular"
    case viral = "Viral"
    case legendary = "Legendary"
    
    var color: Color {
        switch self {
        case .new: return .gray
        case .rising: return .blue
        case .popular: return .green
        case .viral: return .orange
        case .legendary: return .purple
        }
    }
    
    var badge: String {
        switch self {
        case .new: return "🆕"
        case .rising: return "📈"
        case .popular: return "⭐"
        case .viral: return "🔥"
        case .legendary: return "👑"
        }
    }
}

// MARK: - Marketplace Bot Model
struct MarketplaceBotModel: Identifiable, Codable {
    let id = UUID()
    let name: String
    let nickname: String
    let ownerName: String
    let category: BotCategory
    let riskLevel: MarketplaceRiskLevel
    let popularityLevel: MarketplacePopularityLevel
    
    // Performance metrics
    let winRate: Double
    let totalEarnings: Double
    let averageReturn: Double
    let maxDrawdown: Double
    let sharpeRatio: Double
    let averageRating: Double
    let followerCount: Int
    let tradesExecuted: Int
    
    // Availability & Pricing
    let isAvailable: Bool
    let hiringFee: Double
    let dailyRate: Double
    let minimumHiringPeriod: Int // days
    
    // Timestamps
    let createdAt: Date
    let lastActiveAt: Date
    
    // Additional info
    let description: String
    let specialAbilities: [String]
    let tradingPairs: [String]
    let verified: Bool
    
    enum CodingKeys: String, CodingKey {
        case name, nickname, ownerName, category, riskLevel, popularityLevel
        case winRate, totalEarnings, averageReturn, maxDrawdown, sharpeRatio
        case averageRating, followerCount, tradesExecuted
        case isAvailable, hiringFee, dailyRate, minimumHiringPeriod
        case createdAt, lastActiveAt
        case description, specialAbilities, tradingPairs, verified
    }
}

// MARK: - Computed Properties
extension MarketplaceBotModel {
    var formattedEarnings: String {
        if totalEarnings >= 1_000_000 {
            return String(format: "$%.1fM", totalEarnings / 1_000_000)
        } else if totalEarnings >= 1_000 {
            return String(format: "$%.1fK", totalEarnings / 1_000)
        } else {
            return String(format: "$%.0f", totalEarnings)
        }
    }
    
    var performanceGrade: String {
        let score = (winRate * 0.4) + (averageReturn * 0.3) + (sharpeRatio * 10 * 0.3)
        
        switch score {
        case 90...: return "S+"
        case 85..<90: return "S"
        case 80..<85: return "A+"
        case 75..<80: return "A"
        case 70..<75: return "B+"
        case 65..<70: return "B"
        case 60..<65: return "C+"
        case 55..<60: return "C"
        default: return "D"
        }
    }
    
    var gradeColor: Color {
        switch performanceGrade {
        case "S+", "S": return .purple
        case "A+", "A": return Color.yellow
        case "B+", "B": return .green
        case "C+", "C": return .orange
        default: return .red
        }
    }
    
    var statusEmoji: String {
        if !isAvailable {
            return "💼"
        }
        
        switch riskLevel {
        case .low: return "🛡️"
        case .medium: return "⚖️"
        case .high: return "⚔️"
        case .extreme: return "🔥"
        }
    }
    
    var experienceLevel: String {
        switch tradesExecuted {
        case 0..<100: return "Rookie"
        case 100..<500: return "Trader"
        case 500..<1000: return "Veteran"
        case 1000..<5000: return "Expert"
        case 5000..<10000: return "Master"
        default: return "Legend"
        }
    }
}

// MARK: - Sample Data
extension MarketplaceBotModel {
    static let sampleBots: [MarketplaceBotModel] = [
        MarketplaceBotModel(
            name: "GoldRush Alpha",
            nickname: "The Midas Touch",
            ownerName: "TradingKing_2024",
            category: .scalper,
            riskLevel: .medium,
            popularityLevel: .viral,
            winRate: 92.5,
            totalEarnings: 2_847_230,
            averageReturn: 15.8,
            maxDrawdown: 8.2,
            sharpeRatio: 2.3,
            averageRating: 4.8,
            followerCount: 12_450,
            tradesExecuted: 3_847,
            isAvailable: true,
            hiringFee: 5_000,
            dailyRate: 750,
            minimumHiringPeriod: 7,
            createdAt: Date().addingTimeInterval(-86400 * 120),
            lastActiveAt: Date().addingTimeInterval(-300),
            description: "Elite scalping bot specialized in gold market micro-movements. Uses advanced ML algorithms to predict price action with 92.5% accuracy.",
            specialAbilities: ["News-Based Trading", "Risk Management", "Sentiment Analysis"],
            tradingPairs: ["XAUUSD", "XAUEUR", "Gold Futures"],
            verified: true
        ),
        
        MarketplaceBotModel(
            name: "Zeus Thunder",
            nickname: "Lightning Strike",
            ownerName: "ProTrader_Elite",
            category: .news,
            riskLevel: .high,
            popularityLevel: .legendary,
            winRate: 89.3,
            totalEarnings: 4_127_890,
            averageReturn: 28.4,
            maxDrawdown: 12.7,
            sharpeRatio: 2.1,
            averageRating: 4.9,
            followerCount: 28_750,
            tradesExecuted: 2_156,
            isAvailable: false,
            hiringFee: 12_500,
            dailyRate: 1_200,
            minimumHiringPeriod: 14,
            createdAt: Date().addingTimeInterval(-86400 * 200),
            lastActiveAt: Date().addingTimeInterval(-120),
            description: "Legendary news-driven trading bot that capitalizes on market-moving events. Fastest reaction times in the marketplace.",
            specialAbilities: ["News Lightning", "Event Prediction", "Volatility Trading"],
            tradingPairs: ["XAUUSD", "EURUSD", "GBPUSD"],
            verified: true
        ),
        
        MarketplaceBotModel(
            name: "Steady Eddie",
            nickname: "The Rock",
            ownerName: "SafeTrader_99",
            category: .swing,
            riskLevel: .low,
            popularityLevel: .popular,
            winRate: 78.9,
            totalEarnings: 892_340,
            averageReturn: 8.2,
            maxDrawdown: 3.1,
            sharpeRatio: 1.8,
            averageRating: 4.6,
            followerCount: 8_230,
            tradesExecuted: 1_234,
            isAvailable: true,
            hiringFee: 2_500,
            dailyRate: 300,
            minimumHiringPeriod: 5,
            createdAt: Date().addingTimeInterval(-86400 * 90),
            lastActiveAt: Date().addingTimeInterval(-600),
            description: "Conservative swing trading bot focused on consistent, low-risk profits. Perfect for beginners.",
            specialAbilities: ["Risk Control", "Steady Growth", "Low Drawdown"],
            tradingPairs: ["XAUUSD"],
            verified: true
        ),
        
        MarketplaceBotModel(
            name: "Quantum Leap",
            nickname: "The Future",
            ownerName: "QuantTrader_AI",
            category: .technical,
            riskLevel: .extreme,
            popularityLevel: .rising,
            winRate: 95.2,
            totalEarnings: 6_789_012,
            averageReturn: 42.7,
            maxDrawdown: 18.9,
            sharpeRatio: 2.8,
            averageRating: 4.7,
            followerCount: 5_670,
            tradesExecuted: 892,
            isAvailable: true,
            hiringFee: 25_000,
            dailyRate: 2_500,
            minimumHiringPeriod: 30,
            createdAt: Date().addingTimeInterval(-86400 * 45),
            lastActiveAt: Date().addingTimeInterval(-60),
            description: "Experimental quantum computing-enhanced trading bot. Highest returns but extreme risk. Only for advanced traders.",
            specialAbilities: ["Quantum Analysis", "Pattern Recognition", "Future Prediction"],
            tradingPairs: ["XAUUSD", "BTCUSD", "ETHUSD"],
            verified: false
        ),
        
        MarketplaceBotModel(
            name: "Day Warrior",
            nickname: "Battle Tested",
            ownerName: "DayTrader_Pro",
            category: .dayTrader,
            riskLevel: .medium,
            popularityLevel: .popular,
            winRate: 85.7,
            totalEarnings: 1_456_780,
            averageReturn: 18.3,
            maxDrawdown: 7.4,
            sharpeRatio: 2.0,
            averageRating: 4.5,
            followerCount: 11_890,
            tradesExecuted: 2_678,
            isAvailable: true,
            hiringFee: 3_750,
            dailyRate: 500,
            minimumHiringPeriod: 3,
            createdAt: Date().addingTimeInterval(-86400 * 75),
            lastActiveAt: Date().addingTimeInterval(-180),
            description: "Battle-tested day trading bot with consistent performance across all market conditions.",
            specialAbilities: ["Intraday Mastery", "Scalp & Hold", "Market Timing"],
            tradingPairs: ["XAUUSD", "XAGUSD"],
            verified: true
        )
    ]
}

// MARK: - Bot Store Service (Singleton)
class BotStoreService: ObservableObject {
    static let shared = BotStoreService()
    
    @Published var marketplaceBots: [MarketplaceBotModel] = MarketplaceBotModel.sampleBots
    @Published var featuredBots: [MarketplaceBotModel] = []
    
    private init() {
        featuredBots = Array(marketplaceBots.prefix(2))
    }
    
    func getBot(by id: UUID) -> MarketplaceBotModel? {
        return marketplaceBots.first { $0.id == id }
    }
    
    func getFeaturedBots() -> [MarketplaceBotModel] {
        return featuredBots
    }
    
    func getTopPerformers(limit: Int = 5) -> [MarketplaceBotModel] {
        return marketplaceBots
            .sorted { $0.winRate > $1.winRate }
            .prefix(limit)
            .map { $0 }
    }
}