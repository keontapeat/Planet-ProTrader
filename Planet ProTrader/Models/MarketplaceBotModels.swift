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
        case .elite: return DesignSystem.primaryGold
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

// MARK: - ✅ UNIFIED Marketplace Bot Model (SINGLE SOURCE OF TRUTH)
struct MarketplaceBotModel: Identifiable, Codable, Hashable {
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
    
    // MARK: - Computed Properties for Backward Compatibility
    
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
    
    /// Legacy properties for SharedTypes compatibility
    var rating: Double { averageRating }
    var downloads: Int { stats.totalUsers }
    
    var formattedPrice: String {
        if price == 0 {
            return "FREE"
        } else if price >= 1000 {
            return String(format: "$%.0fK", price / 1000)
        } else {
            return String(format: "$%.0f", price)
        }
    }
    
    // MARK: - Hashable Conformance
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: MarketplaceBotModel, rhs: MarketplaceBotModel) -> Bool {
        lhs.id == rhs.id
    }
    
    enum CodingKeys: String, CodingKey {
        case name, tagline, creatorUsername, category, rarity, tier
        case availability, verificationStatus, stats, averageRating, totalReviews
        case price, isFreeTrial, createdAt, lastUpdated
        case description, features, supportedPairs
    }
    
    // MARK: - Sample Data Generation
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
                description: "Professional-grade scalping bot with advanced ML algorithms for gold trading. Uses proprietary pattern recognition to identify micro-movements in the market.",
                features: ["AI Pattern Recognition", "Risk Management", "Real-time Analysis", "Stop Loss Protection", "Multi-timeframe Support"],
                supportedPairs: ["XAUUSD", "XAUEUR", "XAUGBP"]
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
                description: "Reliable swing trading bot for medium-term positions. Specializes in trend following and momentum strategies with excellent risk-adjusted returns.",
                features: ["Trend Following", "Support/Resistance", "Position Management", "Dynamic Sizing", "Market Volatility Adjustment"],
                supportedPairs: ["XAUUSD", "EURUSD", "GBPUSD"]
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
                description: "Ultra-fast news reaction bot with millisecond execution. Monitors economic calendars and news feeds to capitalize on market-moving events instantly.",
                features: ["News Analysis", "Event Detection", "Speed Execution", "Calendar Integration", "Sentiment Analysis"],
                supportedPairs: ["XAUUSD", "GBPUSD", "USDJPY", "EURUSD"]
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
                description: "Safe and simple bot designed specifically for learning traders. Low risk approach with educational features to help understand market dynamics.",
                features: ["Low Risk", "Educational", "Simple Strategy", "Learning Mode", "Basic Indicators"],
                supportedPairs: ["XAUUSD"]
            ),
            
            MarketplaceBotModel(
                name: "Grid Master",
                tagline: "Automated grid trading system",
                creatorUsername: "GridExpert",
                category: .grid,
                rarity: .uncommon,
                tier: .silver,
                availability: .available,
                verificationStatus: .verified,
                stats: BotStats(
                    totalReturn: 89.5,
                    winRate: 71.3,
                    maxDrawdown: 9.2,
                    sharpeRatio: 1.6,
                    totalTrades: 2340,
                    totalUsers: 167,
                    averageDailyReturn: 0.8
                ),
                averageRating: 4.2,
                totalReviews: 95,
                price: 149,
                isFreeTrial: true,
                createdAt: Date().addingTimeInterval(-86400 * 45),
                lastUpdated: Date().addingTimeInterval(-10800),
                description: "Sophisticated grid trading system that places buy and sell orders at predetermined intervals. Excellent for ranging markets and consistent profits.",
                features: ["Grid Strategy", "Range Trading", "Automated Orders", "Profit Taking", "Risk Control"],
                supportedPairs: ["XAUUSD", "EURUSD"]
            ),
            
            MarketplaceBotModel(
                name: "Arbitrage Alpha",
                tagline: "Cross-market arbitrage specialist",
                creatorUsername: "ArbitrageKing",
                category: .arbitrage,
                rarity: .mythic,
                tier: .master,
                availability: .maintenance,
                verificationStatus: .elite,
                stats: BotStats(
                    totalReturn: 456.8,
                    winRate: 95.4,
                    maxDrawdown: 3.1,
                    sharpeRatio: 4.2,
                    totalTrades: 156,
                    totalUsers: 23,
                    averageDailyReturn: 5.7
                ),
                averageRating: 5.0,
                totalReviews: 21,
                price: 1299,
                isFreeTrial: false,
                createdAt: Date().addingTimeInterval(-86400 * 7),
                lastUpdated: Date().addingTimeInterval(-900),
                description: "Elite arbitrage bot that exploits price differences across multiple exchanges and brokers. Requires significant capital but offers exceptional risk-adjusted returns.",
                features: ["Cross-Exchange Analysis", "Latency Optimization", "Risk-Free Profits", "Multi-Broker Support", "Advanced Algorithms"],
                supportedPairs: ["XAUUSD", "XAUEUR", "XAUGBP", "XAUJPY"]
            )
        ]
    }
    
    // MARK: - Legacy sample for SharedTypes compatibility
    static let sample = MarketplaceBotModel(
        name: "Gold Master Pro",
        tagline: "Advanced gold trading algorithm with 90% win rate",
        creatorUsername: "ProTrader",
        category: .technical,
        rarity: .legendary,
        tier: .master,
        availability: .available,
        verificationStatus: .elite,
        stats: BotStats(
            totalReturn: 187.5,
            winRate: 89.7,
            maxDrawdown: 7.2,
            sharpeRatio: 2.1,
            totalTrades: 1250,
            totalUsers: 567,
            averageDailyReturn: 1.8
        ),
        averageRating: 4.8,
        totalReviews: 234,
        price: 99.99,
        isFreeTrial: true,
        createdAt: Date().addingTimeInterval(-86400 * 30),
        lastUpdated: Date().addingTimeInterval(-3600),
        description: "Advanced gold trading algorithm with 90% win rate and sophisticated risk management",
        features: ["Auto Trading", "Risk Management", "Real-time Signals"],
        supportedPairs: ["XAUUSD"]
    )
}

// MARK: - Bot Store Service Enhanced
@MainActor
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
        case arbitrage = "Arbitrage"
        
        var icon: String {
            switch self {
            case .all: return "square.grid.2x2"
            case .featured: return "star.fill"
            case .scalping: return "bolt.fill"
            case .swing: return "wave.3.right"
            case .news: return "newspaper"
            case .technical: return "chart.xyaxis.line"
            case .grid: return "grid"
            case .arbitrage: return "arrow.triangle.swap"
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
    @Published var errorMessage: String?
    
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
                case .arbitrage: return bot.category == .arbitrage
                default: return true
                }
            }
        }
        
        // Filter by search text
        if !searchText.isEmpty {
            filtered = filtered.filter { bot in
                bot.name.localizedCaseInsensitiveContains(searchText) ||
                bot.tagline.localizedCaseInsensitiveContains(searchText) ||
                bot.creatorUsername.localizedCaseInsensitiveContains(searchText) ||
                bot.description.localizedCaseInsensitiveContains(searchText)
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
    
    func refreshData() async {
        isLoading = true
        errorMessage = nil
        
        do {
            // Simulate network call with error handling
            try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
            loadSampleData()
        } catch {
            errorMessage = "Failed to load bots: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    func clearFilters() {
        selectedRarity = nil
        selectedTier = nil
        searchText = ""
        selectedCategory = .all
    }
    
    private func loadSampleData() {
        allBots = MarketplaceBotModel.sampleBots
        featuredBots = Array(allBots.filter { 
            $0.rarity == .legendary || $0.rarity == .epic || $0.rarity == .mythic 
        }.prefix(4))
    }
}