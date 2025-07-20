//
//  EnhancedFamilyModeModels.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 1/27/25.
//  EXPANDED Family Mode™ with MAMA MODE + UNCLE MODE
//

import Foundation
import SwiftUI

// MARK: - Enhanced Family Mode Models

extension FamilyModeModels {
    
    // MARK: - Enhanced Family Member Types (Added MAMA + UNCLE)
    
    enum EnhancedFamilyMemberType: String, CaseIterable, Codable {
        case sister = "SISTER"
        case cousin = "COUSIN"
        case granny = "GRANNY" 
        case auntie = "AUNTIE"
        case mama = "MAMA"        // NEW!
        case uncle = "UNCLE"      // NEW!
        case bro = "BRO"
        case papa = "PAPA"        // BONUS!
        
        var displayName: String {
            switch self {
            case .sister: return "Sister Mode 💅🏽"
            case .cousin: return "Cousin Mode 🎮"
            case .granny: return "Granny Mode 👵🏽"
            case .auntie: return "Auntie Mode 💼"
            case .mama: return "Mama Mode 👑"        // NEW!
            case .uncle: return "Uncle Mode 🧔🏽‍♂️"        // NEW!
            case .bro: return "Bro Mode 🤝"
            case .papa: return "Papa Mode 👨🏽‍💼"        // BONUS!
            }
        }
        
        var emoji: String {
            switch self {
            case .sister: return "💅🏽"
            case .cousin: return "🎮"
            case .granny: return "👵🏽"
            case .auntie: return "💼"
            case .mama: return "👑"        // NEW!
            case .uncle: return "🧔🏽‍♂️"        // NEW!
            case .bro: return "🤝"
            case .papa: return "👨🏽‍💼"        // BONUS!
            }
        }
        
        var primaryColor: Color {
            switch self {
            case .sister: return Color.pink
            case .cousin: return Color.purple
            case .granny: return Color.brown
            case .auntie: return Color.indigo
            case .mama: return Color.red        // NEW! - Queen energy
            case .uncle: return Color.green     // NEW! - Money wisdom
            case .bro: return Color.blue
            case .papa: return Color.black      // BONUS! - Authority
            }
        }
        
        var welcomeMessage: String {
            switch self {
            case .sister:
                return "Welcome to your personal Wall Street, sis! 💅🏽 These bots work for YOU while you handle your business."
            case .cousin:
                return "Yo cuz! 🎮 This is like having a team of money-making bots. Just feed them knowledge and watch them cook."
            case .granny:
                return "Welcome, baby! 👵🏽 This is your helper that trades for you. Think of it like having a smart grandson who never sleeps."
            case .auntie:
                return "Boss lady! 💼 You now have your own financial staff. They study, they trade, they make you money. You're the CEO."
            case .mama:
                return "My QUEEN! 👑 Welcome to your financial EMPIRE! These bots are your royal guard - they protect and multiply your family's wealth while you run the kingdom!" // NEW!
            case .uncle:
                return "Big Uncle! 🧔🏽‍♂️ Time to show these young folks how REAL money is made! Your bot army has that old-school wisdom with new-school technology. Let's build generational wealth!" // NEW!
            case .bro:
                return "What's good bro! 🤝 Your digital money crew is assembled. Let's get this paper!"
            case .papa:
                return "Welcome, King! 👨🏽‍💼 Your trading empire awaits. These bots work under YOUR authority to secure the family legacy!" // BONUS!
            }
        }
        
        var personality: EnhancedFamilyPersonality {
            switch self {
            case .sister:
                return EnhancedFamilyPersonality(
                    tone: "Empowered & Confident",
                    explanationStyle: "Stylish and straight to the point",
                    riskTolerance: .medium,
                    preferredFeatures: ["Beauty", "Simplicity", "Quick Results"],
                    tradingPhilosophy: "Money should work as hard as you do",
                    motivationalQuotes: [
                        "Your money should work as hard as you do! 💅🏽",
                        "Building wealth while building yourself! ✨",
                        "Independent and financially free! 👑"
                    ],
                    defaultBotBehavior: "Stylish and efficient trading",
                    successMilestones: ["First $100 profit", "Consistent daily gains", "$1K total earnings"]
                )
            case .cousin:
                return EnhancedFamilyPersonality(
                    tone: "Chill & Hustle-Ready",
                    explanationStyle: "Gaming analogies and casual vibes",
                    riskTolerance: .high,
                    preferredFeatures: ["Competition", "Levels", "Achievements"],
                    tradingPhilosophy: "Level up your money game",
                    motivationalQuotes: [
                        "Level up that bag, cuz! 🎮",
                        "This the cheat code to the money game! 🕹️",
                        "We grinding different now! 💪"
                    ],
                    defaultBotBehavior: "Aggressive and competitive",
                    successMilestones: ["Beat last week's profit", "Top 10 leaderboard", "$5K portfolio"]
                )
            case .granny:
                return EnhancedFamilyPersonality(
                    tone: "Gentle & Secure",
                    explanationStyle: "Simple, caring, and protective",
                    riskTolerance: .low,
                    preferredFeatures: ["Safety", "Simplicity", "Family Focus"],
                    tradingPhilosophy: "Slow and steady wins the race",
                    motivationalQuotes: [
                        "Slow and steady wins, baby! 🐢",
                        "Building for the grandkids! 👶",
                        "Wisdom pays dividends! 📚"
                    ],
                    defaultBotBehavior: "Conservative and protective",
                    successMilestones: ["Consistent small gains", "No major losses", "$500 safety fund"]
                )
            case .auntie:
                return EnhancedFamilyPersonality(
                    tone: "Bossed-Up & Strategic",
                    explanationStyle: "Executive briefings and power moves",
                    riskTolerance: .high,
                    preferredFeatures: ["Control", "Analytics", "Growth"],
                    tradingPhilosophy: "Think like a CEO, trade like a boss",
                    motivationalQuotes: [
                        "CEOs make moves, not excuses! 💼",
                        "Your financial empire awaits! 👑",
                        "Boss up or get bossed around! 💪"
                    ],
                    defaultBotBehavior: "Strategic and analytical",
                    successMilestones: ["$10K portfolio", "Multiple income streams", "Financial independence"]
                )
            case .mama:  // NEW MAMA MODE!
                return EnhancedFamilyPersonality(
                    tone: "Royal & Protective Matriarch",
                    explanationStyle: "Queenly wisdom with family protection focus",
                    riskTolerance: .medium,
                    preferredFeatures: ["Family Security", "Legacy Building", "Wealth Protection"],
                    tradingPhilosophy: "A queen protects her kingdom and multiplies her resources",
                    motivationalQuotes: [
                        "Queens don't just make money, they make LEGACIES! 👑",
                        "Every trade protects the family throne! 💎",
                        "Mama's money works harder than anybody! 💪👑",
                        "Building an empire for my bloodline! 🏰"
                    ],
                    defaultBotBehavior: "Protective but powerful - like a lioness",
                    successMilestones: ["Family emergency fund", "$25K legacy account", "Passive income for kids"]
                )
            case .uncle:  // NEW UNCLE MODE!
                return EnhancedFamilyPersonality(
                    tone: "Wise OG with Street Smarts",
                    explanationStyle: "Old-school wisdom meets new-school technology",
                    riskTolerance: .medium,
                    preferredFeatures: ["Wisdom Sharing", "Mentorship", "Long-term Growth"],
                    tradingPhilosophy: "Experience is the best teacher, but smart money is the best student",
                    motivationalQuotes: [
                        "Uncle been knowing about money since before these kids were born! 🧔🏽‍♂️",
                        "Old school wisdom, new school gains! 💰",
                        "Teaching the young ones how REAL wealth is built! 🏗️",
                        "Been stacking paper before apps existed, now we digital! 📱💎"
                    ],
                    defaultBotBehavior: "Steady, experienced, teaches other bots",
                    successMilestones: ["Mentor family members", "$50K retirement fund", "Pass down trading wisdom"]
                )
            case .bro:
                return EnhancedFamilyPersonality(
                    tone: "Supportive & Loyal",
                    explanationStyle: "Brotherhood and mutual success",
                    riskTolerance: .high,
                    preferredFeatures: ["Team Work", "Competition", "Growth"],
                    tradingPhilosophy: "We all eat when we all win",
                    motivationalQuotes: [
                        "Brothers building empires together! 🤝",
                        "Loyalty and profits! 💯",
                        "We all eating at this table! 🍽️"
                    ],
                    defaultBotBehavior: "Supportive team player",
                    successMilestones: ["Help others succeed", "$2K group profit", "Team leaderboard"]
                )
            case .papa:  // BONUS PAPA MODE!
                return EnhancedFamilyPersonality(
                    tone: "Authoritative Patriarch & Provider",
                    explanationStyle: "Commanding presence with family responsibility",
                    riskTolerance: .high,
                    preferredFeatures: ["Authority", "Provision", "Legacy"],
                    tradingPhilosophy: "A king provides, protects, and prospers",
                    motivationalQuotes: [
                        "Papa's empire grows for the family! 👨🏽‍💼",
                        "Kings don't ask, they command wealth! 👑",
                        "Providing for generations, not just today! 🏰"
                    ],
                    defaultBotBehavior: "Commanding and protective",
                    successMilestones: ["Family provider", "$100K empire", "Multi-generational wealth"]
                )
            }
        }
    }
    
    // MARK: - Enhanced Family Personality
    
    struct EnhancedFamilyPersonality {
        let tone: String
        let explanationStyle: String
        let riskTolerance: TradingTypes.RiskLevel
        let preferredFeatures: [String]
        let tradingPhilosophy: String
        let motivationalQuotes: [String]
        let defaultBotBehavior: String
        let successMilestones: [String]
    }
    
    // MARK: - Family Relationship System
    
    struct FamilyRelationship {
        let memberType: EnhancedFamilyMemberType
        let relatedMembers: [FamilyConnection]
        let specialInteractions: [String]
        
        struct FamilyConnection {
            let memberType: EnhancedFamilyMemberType
            let relationship: String
            let interactionBonus: Double // Bonus when they trade together
        }
    }
    
    // MARK: - Family Trading Dynamics
    
    static let familyRelationships: [EnhancedFamilyMemberType: FamilyRelationship] = [
        .mama: FamilyRelationship(
            memberType: .mama,
            relatedMembers: [
                FamilyRelationship.FamilyConnection(memberType: .papa, relationship: "Power Couple", interactionBonus: 1.5),
                FamilyRelationship.FamilyConnection(memberType: .granny, relationship: "Mother-in-law Wisdom", interactionBonus: 1.2),
                FamilyRelationship.FamilyConnection(memberType: .uncle, relationship: "Family Support", interactionBonus: 1.3)
            ],
            specialInteractions: [
                "Mama's bots get protective when family members lose money",
                "Queen mode activated when family portfolio is threatened",
                "Shares profits with family members automatically"
            ]
        ),
        .uncle: FamilyRelationship(
            memberType: .uncle,
            relatedMembers: [
                FamilyRelationship.FamilyConnection(memberType: .cousin, relationship: "Mentor Student", interactionBonus: 1.4),
                FamilyRelationship.FamilyConnection(memberType: .bro, relationship: "Brothers", interactionBonus: 1.3),
                FamilyRelationship.FamilyConnection(memberType: .mama, relationship: "Family Support", interactionBonus: 1.2)
            ],
            specialInteractions: [
                "Uncle's bots teach strategies to younger family members",
                "Activates 'OG Mode' when market gets volatile",
                "Shares old-school trading wisdom with bot network"
            ]
        )
    ]
}

// MARK: - Enhanced Sample Data

extension FamilyModeModels {
    static let enhancedSampleFamilyMembers: [FamilyMemberProfile] = [
        // Existing members...
        FamilyMemberProfile(
            id: UUID(),
            name: "Ashley (Sister)",
            memberType: FamilyMemberType(rawValue: "SISTER") ?? .sister,
            onboardingComplete: true,
            currentStep: 6,
            createdAt: Date().addingTimeInterval(-86400 * 7),
            preferences: FamilyMemberProfile.FamilyPreferences(
                autoTradeEnabled: true,
                riskLevel: .medium,
                maxDailyRisk: 75.0,
                beginnerMode: false
            ),
            stats: FamilyMemberProfile.FamilyStats(
                totalProfit: 234.50,
                totalTrades: 45,
                winRate: 82.2,
                daysActive: 7,
                botsAssigned: 2,
                learningProgress: 65.0
            )
        ),
        
        // NEW MAMA MODE MEMBER!
        FamilyMemberProfile(
            id: UUID(),
            name: "Queen Mama 👑",
            memberType: FamilyMemberType(rawValue: "MAMA") ?? .sister,
            onboardingComplete: true,
            currentStep: 6,
            createdAt: Date().addingTimeInterval(-86400 * 14),
            preferences: FamilyMemberProfile.FamilyPreferences(
                autoTradeEnabled: true,
                riskLevel: .medium,
                maxDailyRisk: 200.0,
                beginnerMode: false,
                requireConfirmation: false // Queens move fast
            ),
            stats: FamilyMemberProfile.FamilyStats(
                totalProfit: 1247.85,
                totalTrades: 156,
                winRate: 87.5,
                daysActive: 14,
                botsAssigned: 5,
                learningProgress: 95.0
            )
        ),
        
        // NEW UNCLE MODE MEMBER!
        FamilyMemberProfile(
            id: UUID(),
            name: "Big Uncle Mike 🧔🏽‍♂️",
            memberType: FamilyMemberType(rawValue: "UNCLE") ?? .sister,
            onboardingComplete: true,
            currentStep: 6,
            createdAt: Date().addingTimeInterval(-86400 * 21),
            preferences: FamilyMemberProfile.FamilyPreferences(
                autoTradeEnabled: true,
                riskLevel: .medium,
                maxDailyRisk: 150.0,
                beginnerMode: false
            ),
            stats: FamilyMemberProfile.FamilyStats(
                totalProfit: 892.40,
                totalTrades: 203,
                winRate: 79.8,
                daysActive: 21,
                botsAssigned: 4,
                learningProgress: 88.0
            )
        )
    ]
}