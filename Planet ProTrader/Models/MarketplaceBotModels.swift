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

// MARK: - Bot Store Enums for BotStoreView

enum BotRarity: String, CaseIterable, Codable {
    case common = "Common"
    case uncommon = "Uncommon"
    case rare = "Rare"
    case epic = "Epic"
    case legendary = "Legendary"
    case mythic = "Mythic"
    
    var color: Color {
        switch self {
        case .common: return .gray
        case .uncommon: return .green
        case .rare: return .blue
        case .epic: return .purple
        case .legendary: return .orange
        case .mythic: return .red
        }
    }
    
    var sparkleEffect: String {
        switch self {
        case .common: return "🤖"
        case .uncommon: return "✨"
        case .rare: return "💎"
        case .epic: return "🌟"
        case .legendary: return "👑"
        case .mythic: return "🔥"
        }
    }
}

enum BotTier: String, CaseIterable, Codable {
    case bronze = "Bronze"
    case silver = "Silver"
    case gold = "Gold"
    case platinum = "Platinum"
    case diamond = "Diamond"
    case master = "Master"
    
    var color: Color {
        switch self {
        case .bronze: return Color.orange.opacity(0.8)
        case .silver: return Color.gray
        case .gold: return Color.yellow
        case .platinum: return Color.cyan
        case .diamond: return Color.blue
        case .master: return Color.purple
        }
    }
    
    var icon: String {
        switch self {
        case .bronze: return "🥉"
        case .silver: return "🥈"
        case .gold: return "🥇"
        case .platinum: return "💿"
        case .diamond: return "💎"
        case .master: return "👑"
        }
    }
}

enum BotAvailability: String, CaseIterable, Codable {
    case available = "Available"
    case busy = "Busy"
    case offline = "Offline"
    case maintenance = "Maintenance"
    
    var color: Color {
        switch self {
        case .available: return .green
        case .busy: return .orange
        case .offline: return .gray
        case .maintenance: return .red
        }
    }
    
    var icon: String {
        switch self {
        case .available: return "checkmark.circle.fill"
        case .busy: return "clock.fill"
        case .offline: return "xmark.circle.fill"
        case .maintenance: return "wrench.fill"
        }
    }
}

enum BotVerificationStatus: String, CaseIterable, Codable {
    case unverified = "Unverified"
    case verified = "Verified"
    case premium = "Premium"
    case elite = "Elite"
    
    var color: Color {
        switch self {
        case .unverified: return .gray
        case .verified: return .blue
        case .premium: return .purple
        case .elite: return .gold
        }
    }
    
    var icon: String {
        switch self {
        case .unverified: return "questionmark.circle"
        case .verified: return "checkmark.seal.fill"
        case .premium: return "crown.fill"
        case .elite: return "star.fill"
        }
    }
}

// MARK: - Enhanced Marketplace Bot Model for Store
struct MarketplaceBotModel: Identifiable, Codable {
    let id = UUID()
    let name: String
    let tagline: String
    let creatorUsername: String
    let category: BotCategory
    let rarity: BotRarity
    let tier: BotTier
    let availability: BotAvailability
    let verificationStatus: BotVerificationStatus
    
    // Performance metrics
    let stats: BotStats
    let averageRating: Double
    let totalReviews: Int
    
    // Pricing
    let price: Double
    let isFreeTrial: Bool
    
    // Timestamps
    let createdAt: Date
    let lastUpdated: Date
    
    // Additional info
    let description: String
    let features: [String]
    let supportedPairs: [String]
    
    // MARK: - Computed Properties for Compatibility
    
    /// Alias for name property (backward compatibility)
    var nickname: String { name }
    
    /// Alias for creatorUsername property (backward compatibility)
    var ownerName: String { creatorUsername }
    
    /// Alias for price property (backward compatibility)  
    var hiringFee: Double { price }
    
    /// Computed availability boolean
    var isAvailable: Bool { availability == .available }
    
    /// Additional computed properties for enhanced functionality
    var followerCount: Int { stats.totalUsers }
    var winRate: Double { stats.winRate }
    var totalEarnings: Double { stats.totalReturn }
    
    var formattedPrice: String {
        if price == 0 {
            return "FREE"
        } else if price >= 1000 {
            return String(format: "$%.0fK", price / 1000)
        } else {
            return String(format: "$%.0f", price)
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case name, tagline, creatorUsername, category, rarity, tier
        case availability, verificationStatus, stats, averageRating, totalReviews
        case price, isFreeTrial, createdAt, lastUpdated
        case description, features, supportedPairs
    }
    
    // MARK: - Sample Data
    static var sampleBots: [MarketplaceBotModel] {
        return [
            MarketplaceBotModel(
                name: "Gold Rush Pro",
                tagline: "Elite scalping bot for gold markets",
                creatorUsername: "TradingMaster",
                category: .scalper,
                rarity: .legendary,
                tier: .master,
                availability: .available,
                verificationStatus: .elite,
                stats: BotStats(
                    totalReturn: 245.7,
                    winRate: 89.2,
                    maxDrawdown: 8.3,
                    sharpeRatio: 2.4,
                    totalTrades: 1250,
                    totalUsers: 456,
                    averageDailyReturn: 2.1
                ),
                averageRating: 4.8,
                totalReviews: 234,
                price: 499,
                isFreeTrial: true,
                createdAt: Date().addingTimeInterval(-86400 * 30),
                lastUpdated: Date().addingTimeInterval(-3600),
                description: "Professional-grade scalping bot with advanced ML algorithms",
                features: ["AI Pattern Recognition", "Risk Management", "Real-time Analysis"],
                supportedPairs: ["XAUUSD", "XAUEUR"]
            ),
            
            MarketplaceBotModel(
                name: "Swing Master",
                tagline: "Consistent swing trading profits",
                creatorUsername: "SwingKing",
                category: .swing,
                rarity: .rare,
                tier: .gold,
                availability: .available,
                verificationStatus: .verified,
                stats: BotStats(
                    totalReturn: 156.3,
                    winRate: 76.8,
                    maxDrawdown: 12.1,
                    sharpeRatio: 1.8,
                    totalTrades: 890,
                    totalUsers: 234,
                    averageDailyReturn: 1.2
                ),
                averageRating: 4.5,
                totalReviews: 128,
                price: 199,
                isFreeTrial: false,
                createdAt: Date().addingTimeInterval(-86400 * 60),
                lastUpdated: Date().addingTimeInterval(-7200),
                description: "Reliable swing trading bot for medium-term positions",
                features: ["Trend Following", "Support/Resistance", "Position Management"],
                supportedPairs: ["XAUUSD", "EURUSD"]
            ),
            
            MarketplaceBotModel(
                name: "News Ninja",
                tagline: "Lightning-fast news trading",
                creatorUsername: "NewsTrader",
                category: .news,
                rarity: .epic,
                tier: .diamond,
                availability: .busy,
                verificationStatus: .premium,
                stats: BotStats(
                    totalReturn: 320.4,
                    winRate: 92.1,
                    maxDrawdown: 15.7,
                    sharpeRatio: 2.8,
                    totalTrades: 567,
                    totalUsers: 89,
                    averageDailyReturn: 3.2
                ),
                averageRating: 4.9,
                totalReviews: 67,
                price: 799,
                isFreeTrial: true,
                createdAt: Date().addingTimeInterval(-86400 * 15),
                lastUpdated: Date().addingTimeInterval(-1800),
                description: "Ultra-fast news reaction bot with millisecond execution",
                features: ["News Analysis", "Event Detection", "Speed Execution"],
                supportedPairs: ["XAUUSD", "GBPUSD", "USDJPY"]
            ),
            
            MarketplaceBotModel(
                name: "Beginner Bot",
                tagline: "Perfect for new traders",
                creatorUsername: "EasyTrader",
                category: .technical,
                rarity: .common,
                tier: .bronze,
                availability: .available,
                verificationStatus: .verified,
                stats: BotStats(
                    totalReturn: 45.2,
                    winRate: 68.5,
                    maxDrawdown: 5.1,
                    sharpeRatio: 1.2,
                    totalTrades: 345,
                    totalUsers: 1200,
                    averageDailyReturn: 0.5
                ),
                averageRating: 4.1,
                totalReviews: 890,
                price: 0,
                isFreeTrial: false,
                createdAt: Date().addingTimeInterval(-86400 * 90),
                lastUpdated: Date().addingTimeInterval(-86400),
                description: "Safe and simple bot for learning traders",
                features: ["Low Risk", "Educational", "Simple Strategy"],
                supportedPairs: ["XAUUSD"]
            )
        ]
    }
}

// MARK: - Bot Stats
struct BotStats: Codable {
    let totalReturn: Double
    let winRate: Double
    let maxDrawdown: Double
    let sharpeRatio: Double
    let totalTrades: Int
    let totalUsers: Int
    let averageDailyReturn: Double
    
    var formattedTotalReturn: String {
        let sign = totalReturn >= 0 ? "+" : ""
        return "\(sign)\(String(format: "%.1f", totalReturn))%"
    }
}

// MARK: - Bot Store Service Enhanced
class BotStoreService: ObservableObject {
    static let shared = BotStoreService()
    
    enum BotStoreCategory: String, CaseIterable {
        case all = "All Bots"
        case featured = "Featured"
        case scalping = "Scalping"
        case swing = "Swing"
        case news = "News"
        case technical = "Technical"
        case grid = "Grid"
        
        var icon: String {
            switch self {
            case .all: return "square.grid.2x2"
            case .featured: return "star.fill"
            case .scalping: return "bolt.fill"
            case .swing: return "wave.3.right"
            case .news: return "newspaper"
            case .technical: return "chart.xyaxis.line"
            case .grid: return "grid"
            }
        }
    }
    
    @Published var allBots: [MarketplaceBotModel] = []
    @Published var featuredBots: [MarketplaceBotModel] = []
    @Published var selectedCategory: BotStoreCategory = .all
    @Published var searchText: String = ""
    @Published var selectedRarity: BotRarity?
    @Published var selectedTier: BotTier?
    @Published var isLoading: Bool = false
    
    private init() {
        loadSampleData()
    }
    
    func filteredBots() -> [MarketplaceBotModel] {
        var filtered = allBots
        
        // Filter by category
        if selectedCategory != .all && selectedCategory != .featured {
            filtered = filtered.filter { bot in
                switch selectedCategory {
                case .scalping: return bot.category == .scalper
                case .swing: return bot.category == .swing
                case .news: return bot.category == .news
                case .technical: return bot.category == .technical
                case .grid: return bot.category == .grid
                default: return true
                }
            }
        }
        
        // Filter by search text
        if !searchText.isEmpty {
            filtered = filtered.filter { bot in
                bot.name.localizedCaseInsensitiveContains(searchText) ||
                bot.tagline.localizedCaseInsensitiveContains(searchText) ||
                bot.creatorUsername.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        // Filter by rarity
        if let rarity = selectedRarity {
            filtered = filtered.filter { $0.rarity == rarity }
        }
        
        // Filter by tier
        if let tier = selectedTier {
            filtered = filtered.filter { $0.tier == tier }
        }
        
        return filtered.sorted { $0.averageRating > $1.averageRating }
    }
    
    func refreshData() {
        isLoading = true
        // Simulate network call
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.loadSampleData()
            self.isLoading = false
        }
    }
    
    func clearFilters() {
        selectedRarity = nil
        selectedTier = nil
        searchText = ""
        selectedCategory = .all
    }
    
    private func loadSampleData() {
        allBots = MarketplaceBotModel.sampleBots
        featuredBots = Array(allBots.filter { $0.rarity == .legendary || $0.rarity == .epic }.prefix(3))
    }
}