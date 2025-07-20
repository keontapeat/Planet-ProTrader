//
//  CleanTypes.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 1/25/25.
//

import SwiftUI
import Foundation

// MARK: - Clean Type Definitions (No Duplicates)

// Fix ambiguous LeaderboardEntry
struct GameLeaderboardEntry: Identifiable, Codable {
    let id = UUID()
    let rank: Int
    let playerName: String
    let score: Double
    let avatar: String
    let level: Int
    
    static let sampleEntries: [GameLeaderboardEntry] = [
        GameLeaderboardEntry(rank: 1, playerName: "TradeMaster", score: 15420.50, avatar: "🏆", level: 25),
        GameLeaderboardEntry(rank: 2, playerName: "BotKing", score: 12350.75, avatar: "👑", level: 23),
        GameLeaderboardEntry(rank: 3, playerName: "GoldRush", score: 9875.25, avatar: "💎", level: 20)
    ]
}

// Fix ambiguous Achievement
struct GameAchievement: Identifiable, Codable {
    let id = UUID()
    let title: String
    let description: String
    let icon: String
    let points: Int
    let unlockedDate: Date?
    let rarity: AchievementRarity
    
    enum AchievementRarity: String, CaseIterable, Codable {
        case common = "COMMON"
        case rare = "RARE"
        case epic = "EPIC"
        case legendary = "LEGENDARY"
    }
}

// Fix ambiguous BotPersonality
struct CleanBotPersonality: Codable {
    let type: PersonalityType
    let traits: [String]
    let riskAppetite: RiskLevel
    let communicationStyle: CommunicationStyle
    
    enum PersonalityType: String, CaseIterable, Codable {
        case aggressive = "AGGRESSIVE"
        case analytical = "ANALYTICAL"
        case calm = "CALM"
        case confident = "CONFIDENT"
    }
    
    enum RiskLevel: String, CaseIterable, Codable {
        case conservative = "CONSERVATIVE"
        case moderate = "MODERATE"
        case aggressive = "AGGRESSIVE"
        case extreme = "EXTREME"
    }
    
    enum CommunicationStyle: String, CaseIterable, Codable {
        case technical = "TECHNICAL"
        case casual = "CASUAL"
        case professional = "PROFESSIONAL"
    }
}

// Fix ambiguous NewsImpact
enum CleanNewsImpact: String, CaseIterable, Codable {
    case low = "LOW"
    case medium = "MEDIUM"
    case high = "HIGH"
    case extreme = "EXTREME"
    
    var color: Color {
        switch self {
        case .low: return .green
        case .medium: return .yellow
        case .high: return .orange
        case .extreme: return .red
        }
    }
}

// Fix keyword issues
struct PlayerProfile: Codable {
    let id = UUID()
    let playerClass: String  // Changed from 'class' keyword
    let level: Int
    let experience: Double
}

struct InvestmentReturn: Codable {  // Changed from 'return' keyword
    let id = UUID()
    let percentage: Double
    let period: String
    let risk: String
}

// Fix session stats
struct SessionStats: Codable {
    let volume: Double
    let high: Double
    let low: Double
    let change: Double
}

struct TradingSession: Codable {
    let newYorkOpen: SessionStats
    let londonOpen: SessionStats  
    let tokyoOpen: SessionStats
}

// Extension to fix font ambiguity
extension Font {
    static let customHeadline = Font.headline
    static let customCaption = Font.caption
}

// Extension to fix Color ambiguity  
extension Color {
    static let customGold = Color(red: 1.0, green: 0.84, blue: 0.0)
}