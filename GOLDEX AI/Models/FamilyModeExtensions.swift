//
//  FamilyModeExtensions.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 7/18/25.
//

import SwiftUI
import Foundation

// MARK: - Extended Family Member Types

extension FamilyMemberType {
    static let mama = FamilyMemberType(
        id: UUID(),
        name: "MAMA",
        displayName: "Mama Bear 🐻",
        personality: "Protective but fierce - 'Baby, you better make this money work for the FAMILY!'",
        voiceStyle: .nurturing,
        tradingStyle: .conservative,
        catchphrase: "Don't you dare lose my grandbaby's college fund!",
        motivationStyle: .protective,
        successCelebration: "THAT'S MY BABY! Making Mama PROUD! 🤱💰",
        failureResponse: "Baby, what did Mama tell you about being careful? Let's try again, sweetie.",
        backgroundStory: "Mama worked 3 jobs to support her family. She knows the value of every dollar and will make sure you don't waste a single penny!",
        specialAbilities: [
            "Risk Management Master - Mama never lets you risk more than you can afford",
            "Guilt Trip Trading - Makes you feel bad for losing money (in a loving way)",
            "Family Fund Protector - Special alerts for family-related financial goals",
            "Mama's Intuition - Mysterious ability to sense bad trades"
        ]
    )
    
    static let uncle = FamilyMemberType(
        id: UUID(),
        name: "UNCLE",
        displayName: "Uncle Money 💸",
        personality: "Cool but ambitious - 'Listen up kiddo, Uncle's gonna show you how the REAL money is made!'",
        voiceStyle: .confident,
        tradingStyle: .aggressive,
        catchphrase: "Back in MY day, we turned $50 into $50K with PURE HUSTLE!",
        motivationStyle: .competitive,
        successCelebration: "NOW THAT'S WHAT I'M TALKING ABOUT! Uncle taught you well! 🤑🚀",
        failureResponse: "Kid, you're thinking like a amateur. Let Uncle show you the REAL way to trade.",
        backgroundStory: "Uncle made his first million in the dot-com boom and lost it all in 2008. Now he's back with VENGEANCE and wants to teach you everything he learned!",
        specialAbilities: [
            "Old School Wisdom - Stories from the trading floors of the 90s",
            "Risk Tolerance Booster - Encourages bigger positions (carefully)",
            "War Stories Mode - Shares legendary trading tales for inspiration",
            "Uncle's Connections - Access to 'insider' market wisdom (legally!)"
        ]
    )
}

// MARK: - Family Member Voice Styles

extension FamilyMemberVoiceStyle {
    static let nurturing = FamilyMemberVoiceStyle(
        tone: .gentle,
        enthusiasm: .moderate,
        directness: .caring,
        humorLevel: .wholesome,
        vocabularyStyle: .motherly
    )
}

// MARK: - Extended Trading Styles

extension FamilyMemberTradingStyle {
    static let protective = FamilyMemberTradingStyle(
        riskTolerance: .veryLow,
        positionSizing: .conservative,
        holdingPeriod: .longTerm,
        analysisDepth: .thorough,
        emotionalResponse: .steady
    )
}

// MARK: - Family Member Interaction Patterns

struct FamilyMemberInteraction {
    let memberId: UUID
    let interactionType: InteractionType
    let message: String
    let timestamp: Date
    let contextData: [String: Any]
    
    enum InteractionType: String, CaseIterable {
        case dailyCheckIn = "daily_check_in"
        case tradeAdvice = "trade_advice"
        case celebration = "celebration"
        case concern = "concern"
        case motivationalSpeech = "motivational_speech"
        case storyTime = "story_time"
        case riskWarning = "risk_warning"
        case profitCelebration = "profit_celebration"
    }
}

// MARK: - Advanced Family Dynamics

class FamilyDynamicsEngine: ObservableObject {
    @Published var activeFamilyMember: FamilyMemberType
    @Published var familyMood: FamilyMood = .supportive
    @Published var recentInteractions: [FamilyMemberInteraction] = []
    @Published var familyGoals: [FamilyGoal] = []
    
    init(familyMember: FamilyMemberType = .mama) {
        self.activeFamilyMember = familyMember
    }
    
    enum FamilyMood: String, CaseIterable {
        case supportive = "Everyone's cheering you on!"
        case concerned = "Family is worried about your trades..."
        case proud = "The whole family is PROUD of your success!"
        case disappointed = "Family dinner is gonna be awkward..."
        case excited = "Everyone's talking about your trading wins!"
    }
    
    struct FamilyGoal {
        let id = UUID()
        let title: String
        let description: String
        let targetAmount: Double
        let currentProgress: Double
        let familyMemberOwner: FamilyMemberType
        let deadline: Date
        let category: GoalCategory
        
        enum GoalCategory: String, CaseIterable {
            case education = "Education Fund"
            case house = "House Down Payment"
            case vacation = "Family Vacation"
            case emergency = "Emergency Fund"
            case retirement = "Retirement Savings"
            case business = "Family Business"
        }
        
        var progressPercentage: Double {
            return min(currentProgress / targetAmount * 100, 100)
        }
    }
    
    func generateDailyMessage(for member: FamilyMemberType, tradingPerformance: TradingPerformance) -> String {
        switch member.name {
        case "MAMA":
            return generateMamaMessage(performance: tradingPerformance)
        case "UNCLE":
            return generateUncleMessage(performance: tradingPerformance)
        default:
            return "Keep up the good work, family!"
        }
    }
    
    private func generateMamaMessage(performance: TradingPerformance) -> String {
        if performance.dailyPnL > 0 {
            return "Good morning baby! Mama saw you made some money yesterday - $\(String(format: "%.2f", performance.dailyPnL))! Remember to save some for a rainy day. Love you! 🤱💕"
        } else if performance.dailyPnL < -100 {
            return "Sweetheart, Mama's a little worried. You lost $\(String(format: "%.2f", abs(performance.dailyPnL))) yesterday. Maybe take a break and have some soup? We'll figure this out together. 🍲💙"
        } else {
            return "Morning my little trader! Whatever happens today, Mama believes in you. Just be careful out there! 🤗"
        }
    }
    
    private func generateUncleMessage(performance: TradingPerformance) -> String {
        if performance.dailyPnL > 500 {
            return "KID! Uncle just saw your P&L - $\(String(format: "%.2f", performance.dailyPnL))! That's what I'm TALKING about! You're starting to trade like family! 🤑🚀"
        } else if performance.dailyPnL < -200 {
            return "Listen kiddo, Uncle's been there. Lost $\(String(format: "%.2f", abs(performance.dailyPnL)))? That's tuition money for the school of hard knocks. Time to BOUNCE BACK! 💪"
        } else {
            return "Another day at the office, kid. Remember what Uncle taught you - RISK MANAGEMENT and DISCIPLINE. Now go make some money! 💸"
        }
    }
}

struct TradingPerformance {
    let dailyPnL: Double
    let weeklyPnL: Double
    let monthlyPnL: Double
    let winRate: Double
    let totalTrades: Int
    let avgWin: Double
    let avgLoss: Double
}

// MARK: - Family Member Specializations

extension FamilyMemberType {
    var specializedAdvice: [String] {
        switch name {
        case "MAMA":
            return [
                "Never risk money you can't afford to lose - that's food money!",
                "Diversification is like having backup plans for backup plans",
                "If a trade feels too good to be true, it probably is sweetie",
                "Mama's rule: Take profits when you're happy, cut losses when you're scared",
                "Remember: Slow and steady wins the race, not get-rich-quick schemes"
            ]
        case "UNCLE":
            return [
                "Kid, position sizing is EVERYTHING. Uncle learned this the hard way in '08",
                "Never chase a trade - there's always another bus coming",
                "Back in my day, we read charts like gospel. Still do!",
                "Risk 1% per trade max. Uncle's golden rule since 1995",
                "Market makers are sharks - be the bigger shark!"
            ]
        default:
            return ["Trade smart, trade safe!"]
        }
    }
    
    var morningRoutine: String {
        switch name {
        case "MAMA":
            return "Good morning my precious trader! Mama made you virtual coffee ☕ and wants you to check those risk levels before you start trading!"
        case "UNCLE":
            return "RISE AND GRIND kiddo! Uncle's already been up since 4 AM checking pre-market. Time to HUNT for opportunities! 🦈"
        default:
            return "Good morning, trader!"
        }
    }
}