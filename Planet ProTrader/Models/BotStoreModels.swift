//
//  BotStoreModels.swift
//  Planet ProTrader
//
//  ✅ FIXED: Complete Bot Store Models and Types
//  Created by AI Assistant on 1/25/25.
//

import SwiftUI
import Foundation

// MARK: - Bot Rarity System
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
        case .common: return "⚪"
        case .uncommon: return "🟢"
        case .rare: return "🔵"
        case .epic: return "🟣"
        case .legendary: return "🟠"
        case .mythic: return "✨"
        }
    }
}

// MARK: - Bot Tier System
enum BotTier: String, CaseIterable, Codable {
    case bronze = "Bronze"
    case silver = "Silver"
    case gold = "Gold"
    case platinum = "Platinum"
    case diamond = "Diamond"
    case master = "Master"
    
    var color: Color {
        switch self {
        case .bronze: return .brown
        case .silver: return .gray
        case .gold: return .yellow
        case .platinum: return .blue
        case .diamond: return .cyan
        case .master: return .purple
        }
    }
    
    var icon: String {
        switch self {
        case .bronze: return "🥉"
        case .silver: return "🥈"
        case .gold: return "🥇"
        case .platinum: return "💎"
        case .diamond: return "💠"
        case .master: return "👑"
        }
    }
}

// MARK: - Bot Availability
enum BotAvailability: String, CaseIterable, Codable {
    case available = "Available"
    case limited = "Limited Edition"
    case soldOut = "Sold Out"
    case comingSoon = "Coming Soon"
    case exclusive = "Exclusive"
    
    var color: Color {
        switch self {
        case .available: return .green
        case .limited: return .orange
        case .soldOut: return .red
        case .comingSoon: return .blue
        case .exclusive: return .purple
        }
    }
    
    var icon: String {
        switch self {
        case .available: return "checkmark.circle.fill"
        case .limited: return "clock.fill"
        case .soldOut: return "xmark.circle.fill"
        case .comingSoon: return "calendar.badge.plus"
        case .exclusive: return "crown.fill"
        }
    }
}

// MARK: - Bot Verification Status
enum BotVerificationStatus: String, CaseIterable, Codable {
    case verified = "Verified"
    case unverified = "Unverified"
    case pending = "Pending"
    case rejected = "Rejected"
    
    var color: Color {
        switch self {
        case .verified: return .blue
        case .unverified: return .gray
        case .pending: return .orange
        case .rejected: return .red
        }
    }
    
    var icon: String {
        switch self {
        case .verified: return "checkmark.seal.fill"
        case .unverified: return "questionmark.circle"
        case .pending: return "clock.circle"
        case .rejected: return "xmark.seal.fill"
        }
    }
}

// MARK: - Marketplace Bot Model
struct MarketplaceBotModel: Identifiable, Codable {
    let id = UUID()
    let name: String
    let tagline: String
    let description: String
    let creatorUsername: String
    let creatorId: String
    let price: Double
    let currency: String
    let rarity: BotRarity
    let tier: BotTier
    let availability: BotAvailability
    let verificationStatus: BotVerificationStatus
    let averageRating: Double
    let totalRatings: Int
    let stats: BotStats
    let features: [String]
    let compatibleBrokers: [String]
    let createdAt: Date
    let updatedAt: Date
    
    struct BotStats: Codable {
        let totalReturn: Double
        let winRate: Double
        let totalTrades: Int
        let totalUsers: Int
        let averageDrawdown: Double
        let profitFactor: Double
        let sharpeRatio: Double
        
        var formattedTotalReturn: String {
            let sign = totalReturn >= 0 ? "+" : ""
            return "\(sign)\(String(format: "%.1f", totalReturn))%"
        }
        
        var formattedWinRate: String {
            return "\(String(format: "%.1f", winRate))%"
        }
    }
    
    init(
        name: String,
        tagline: String,
        description: String,
        creatorUsername: String,
        creatorId: String = UUID().uuidString,
        price: Double,
        currency: String = "USD",
        rarity: BotRarity = .common,
        tier: BotTier = .bronze,
        availability: BotAvailability = .available,
        verificationStatus: BotVerificationStatus = .unverified,
        averageRating: Double = 4.0,
        totalRatings: Int = 0,
        stats: BotStats,
        features: [String] = [],
        compatibleBrokers: [String] = [],
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.name = name
        self.tagline = tagline
        self.description = description
        self.creatorUsername = creatorUsername
        self.creatorId = creatorId
        self.price = price
        self.currency = currency
        self.rarity = rarity
        self.tier = tier
        self.availability = availability
        self.verificationStatus = verificationStatus
        self.averageRating = averageRating
        self.totalRatings = totalRatings
        self.stats = stats
        self.features = features
        self.compatibleBrokers = compatibleBrokers
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    var formattedPrice: String {
        if price == 0 {
            return "FREE"
        } else {
            return "$\(String(format: "%.0f", price))"
        }
    }
    
    var isFree: Bool {
        return price == 0
    }
}

// MARK: - Sample Data
extension MarketplaceBotModel {
    static let sampleBots: [MarketplaceBotModel] = [
        MarketplaceBotModel(
            name: "GoldHunter Supreme",
            tagline: "Elite gold trading with AI precision",
            description: "Advanced neural network bot specialized in XAUUSD trading with proprietary market structure analysis.",
            creatorUsername: "ProTraderAI",
            price: 299.99,
            rarity: .legendary,
            tier: .master,
            averageRating: 4.9,
            totalRatings: 1247,
            stats: BotStats(
                totalReturn: 284.7,
                winRate: 87.3,
                totalTrades: 3456,
                totalUsers: 892,
                averageDrawdown: 5.2,
                profitFactor: 2.8,
                sharpeRatio: 1.9
            ),
            features: ["AI Neural Network", "Risk Management", "24/7 Trading"],
            compatibleBrokers: ["MT5", "MT4", "Coinexx"]
        ),
        
        MarketplaceBotModel(
            name: "ScalpMaster Pro",
            tagline: "Lightning-fast scalping profits",
            description: "High-frequency trading bot optimized for quick profits in volatile markets.",
            creatorUsername: "ScalpKing",
            price: 199.99,
            rarity: .epic,
            tier: .platinum,
            averageRating: 4.6,
            totalRatings: 834,
            stats: BotStats(
                totalReturn: 156.4,
                winRate: 82.1,
                totalTrades: 5623,
                totalUsers: 567,
                averageDrawdown: 8.7,
                profitFactor: 2.1,
                sharpeRatio: 1.4
            ),
            features: ["Scalping Strategy", "Low Latency", "Multi-Pair"],
            compatibleBrokers: ["MT5", "Coinexx"]
        ),
        
        MarketplaceBotModel(
            name: "Trend Rider Basic",
            tagline: "Simple trend following for beginners",
            description: "Easy-to-use trend following bot perfect for new traders learning the market.",
            creatorUsername: "TrendMaster",
            price: 0,
            rarity: .common,
            tier: .bronze,
            averageRating: 4.1,
            totalRatings: 2341,
            stats: BotStats(
                totalReturn: 67.2,
                winRate: 68.5,
                totalTrades: 1234,
                totalUsers: 1856,
                averageDrawdown: 12.3,
                profitFactor: 1.6,
                sharpeRatio: 0.8
            ),
            features: ["Trend Following", "Beginner Friendly", "Educational"],
            compatibleBrokers: ["MT4", "MT5"]
        )
    ]
}

// MARK: - Color Extension for BotTier
extension Color {
    static let brown = Color(red: 0.6, green: 0.4, blue: 0.2)
}