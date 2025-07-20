//
//  FamilyModeModels.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 1/27/25.
//  PEAT Family Mode™ - Making trading accessible for your whole family
//

import Foundation
import SwiftUI

// MARK: - Family Mode Models

struct FamilyModeModels {
    
    // MARK: - Family Member Types
    
    enum FamilyMemberType: String, CaseIterable, Codable {
        case sister = "SISTER"
        case cousin = "COUSIN"
        case granny = "GRANNY" 
        case auntie = "AUNTIE"
        case mama = "MAMA"
        case uncle = "UNCLE"
        case bro = "BRO"
        
        var displayName: String {
            switch self {
            case .sister: return "Sister Mode 💅🏽"
            case .cousin: return "Cousin Mode 🎮"
            case .granny: return "Granny Mode 👵🏽"
            case .auntie: return "Auntie Mode 💼"
            case .mama: return "Mama Mode 💖"
            case .uncle: return "Uncle Mode 🧔🏽"
            case .bro: return "Bro Mode 🤝"
            }
        }
        
        var emoji: String {
            switch self {
            case .sister: return "💅🏽"
            case .cousin: return "🎮"
            case .granny: return "👵🏽"
            case .auntie: return "💼"
            case .mama: return "💖"
            case .uncle: return "🧔🏽"
            case .bro: return "🤝"
            }
        }
        
        var primaryColor: Color {
            switch self {
            case .sister: return Color.pink
            case .cousin: return Color.purple
            case .granny: return Color.brown
            case .auntie: return Color.indigo
            case .mama: return Color.red
            case .uncle: return Color.orange
            case .bro: return Color.blue
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
                return "My queen! 💖 Your trading army is ready. Feed them wisdom, they'll feed your family wealth."
            case .uncle:
                return "Big uncle! 🧔🏽 Time to level up that portfolio. These bots got your back 24/7."
            case .bro:
                return "What's good bro! 🤝 Your digital money crew is assembled. Let's get this paper!"
            }
        }
        
        var personality: FamilyPersonality {
            switch self {
            case .sister:
                return FamilyPersonality(
                    tone: "Empowered & Confident",
                    explanationStyle: "Stylish and straight to the point",
                    riskTolerance: .medium,
                    preferredFeatures: ["Beauty", "Simplicity", "Quick Results"],
                    motivationalQuotes: [
                        "Your money should work as hard as you do! 💅🏽",
                        "Building wealth while building yourself! ✨",
                        "Independent and financially free! 👑"
                    ]
                )
            case .cousin:
                return FamilyPersonality(
                    tone: "Chill & Hustle-Ready",
                    explanationStyle: "Gaming analogies and casual vibes",
                    riskTolerance: .high,
                    preferredFeatures: ["Competition", "Levels", "Achievements"],
                    motivationalQuotes: [
                        "Level up that bag, cuz! 🎮",
                        "This the cheat code to the money game! 🕹️",
                        "We grinding different now! 💪"
                    ]
                )
            case .granny:
                return FamilyPersonality(
                    tone: "Gentle & Secure",
                    explanationStyle: "Simple, caring, and protective",
                    riskTolerance: .low,
                    preferredFeatures: ["Safety", "Simplicity", "Family Focus"],
                    motivationalQuotes: [
                        "Slow and steady wins, baby! 🐢",
                        "Building for the grandkids! 👶",
                        "Wisdom pays dividends! 📚"
                    ]
                )
            case .auntie:
                return FamilyPersonality(
                    tone: "Bossed-Up & Strategic",
                    explanationStyle: "Executive briefings and power moves",
                    riskTolerance: .high,
                    preferredFeatures: ["Control", "Analytics", "Growth"],
                    motivationalQuotes: [
                        "CEOs make moves, not excuses! 💼",
                        "Your financial empire awaits! 👑",
                        "Boss up or get bossed around! 💪"
                    ]
                )
            case .mama:
                return FamilyPersonality(
                    tone: "Nurturing & Protective",
                    explanationStyle: "Family-focused and caring",
                    riskTolerance: .medium,
                    preferredFeatures: ["Family Security", "Growth", "Legacy"],
                    motivationalQuotes: [
                        "Building generational wealth! 💖",
                        "Mama's money working overtime! 🏠",
                        "Securing the family future! 👨‍👩‍👧‍👦"
                    ]
                )
            case .uncle:
                return FamilyPersonality(
                    tone: "Wise & Experienced",
                    explanationStyle: "Life lessons and practical wisdom",
                    riskTolerance: .medium,
                    preferredFeatures: ["Stability", "Knowledge", "Teaching"],
                    motivationalQuotes: [
                        "Uncle knowledge pays dividends! 🧔🏽",
                        "Teaching the next generation! 🎓",
                        "Old school meets new money! 💰"
                    ]
                )
            case .bro:
                return FamilyPersonality(
                    tone: "Supportive & Loyal",
                    explanationStyle: "Brotherhood and mutual success",
                    riskTolerance: .high,
                    preferredFeatures: ["Team Work", "Competition", "Growth"],
                    motivationalQuotes: [
                        "Brothers building empires together! 🤝",
                        "Loyalty and profits! 💯",
                        "We all eating at this table! 🍽️"
                    ]
                )
            }
        }
        
        var onboardingSteps: [OnboardingStep] {
            let baseSteps: [OnboardingStep] = [
                OnboardingStep(
                    id: 1,
                    title: "Welcome to PEAT ProTrader",
                    content: welcomeMessage,
                    animation: "welcome",
                    actionButton: "Let's Start!"
                ),
                OnboardingStep(
                    id: 2,
                    title: "What Is a Bot?",
                    content: getBotExplanation(),
                    animation: "bot_intro",
                    actionButton: "Got it!"
                ),
                OnboardingStep(
                    id: 3,
                    title: "How You Make Money",
                    content: getMoneyExplanation(),
                    animation: "money_flow",
                    actionButton: "Show me more!"
                ),
                OnboardingStep(
                    id: 4,
                    title: "Teach Your Bots",
                    content: getTeachingExplanation(),
                    animation: "teaching",
                    actionButton: "I'm ready!"
                ),
                OnboardingStep(
                    id: 5,
                    title: "Earn While You Sleep",
                    content: getPassiveIncomeExplanation(),
                    animation: "passive_income",
                    actionButton: "Let's Trade!"
                ),
                OnboardingStep(
                    id: 6,
                    title: "Fund Your Account",
                    content: getFundingExplanation(),
                    animation: "funding",
                    actionButton: "Add Money Now!"
                )
            ]
            
            return baseSteps
        }
        
        private func getBotExplanation() -> String {
            switch self {
            case .sister:
                return "Think of each bot as your personal trading assistant! 💅🏽 They study charts, learn patterns, and trade while you focus on your goals. No manual work required!"
            case .cousin:
                return "Bro, each bot is like an AI player that never stops grinding! 🎮 They level up by learning from screenshots, books, and successful trades. Set and forget!"
            case .granny:
                return "Baby, think of bots as your smart helpers! 👵🏽 They watch the market 24/7 so you don't have to. They're trained to be careful with your money."
            case .auntie:
                return "Each bot is like having a trained analyst on your team! 💼 They execute your strategy while you focus on bigger business moves. Professional-grade AI working for YOU."
            case .mama:
                return "Honey, these bots are like having family members watching over your money! 💖 They learn from the best traders and protect our family's wealth."
            case .uncle:
                return "Think of bots as your wise apprentices! 🧔🏽 You teach them what you know, they apply it 24/7. Old wisdom meets new technology."
            case .bro:
                return "These bots are your trading squad! 🤝 They watch your back in the markets while you handle other business. Real recognize real!"
            }
        }
        
        private func getMoneyExplanation() -> String {
            switch self {
            case .sister:
                return "Once your bots prove they're accurate, you pick the best one to grow your real money! 💅🏽 They find profitable trades while you live your life. Your money works while you work!"
            case .cousin:
                return "Once bots hit their target win rate, you can deploy them with real cash! 🎮 It's like having a money-making game running 24/7. Level up your bank account!"
            case .granny:
                return "When a bot shows it can win consistently, you let it trade with your real money! 👵🏽 It's safe because they practice first. Your nest egg grows while you rest!"
            case .auntie:
                return "After bots demonstrate profitability in testing, you allocate capital to the top performers! 💼 Scale your wealth without scaling your time investment!"
            case .mama:
                return "Once bots prove they can protect and grow money, you trust them with real funds! 💖 Building wealth for our family's future, one smart trade at a time!"
            case .uncle:
                return "After bots master the craft through practice, you give them real capital to multiply! 🧔🏽 Teaching them right means they'll provide for generations!"
            case .bro:
                return "When bots prove their worth in demo mode, you level them up to real money! 🤝 We all eat when the bots are eating! Shared success!"
            }
        }
        
        private func getTeachingExplanation() -> String {
            switch self {
            case .sister:
                return "Your job is simple: feed your bots knowledge! 💅🏽 Upload trading books, screenshot patterns, share winning strategies. The more you teach, the smarter they become!"
            case .cousin:
                return "You level up bots by feeding them data! 🎮 Trading books, chart screenshots, YouTube videos - anything that makes them smarter. It's like training your squad!"
            case .granny:
                return "Just share what you learn with your bots, baby! 👵🏽 Take pictures of trading patterns, upload helpful books. They learn from your wisdom!"
            case .auntie:
                return "Knowledge management is key! 💼 Curate educational content - books, market analysis, winning strategies. Your bots become as smart as you make them!"
            case .mama:
                return "Share your learning journey with your bots! 💖 Upload trading wisdom, screenshot good setups. You're teaching them to provide for the family!"
            case .uncle:
                return "Pass down your trading knowledge! 🧔🏽 Share books, chart patterns, life lessons. The wisdom you share multiplies through your bots!"
            case .bro:
                return "Keep your bots sharp with fresh knowledge! 🤝 Share trading resources, winning patterns, market insights. We grow together!"
            }
        }
        
        private func getPassiveIncomeExplanation() -> String {
            switch self {
            case .sister:
                return "Once trained, your bot trades 24/7 on your MT5 accounts! 💅🏽 Sleep, work, travel - your money grows automatically. True financial freedom!"
            case .cousin:
                return "Set it and forget it! 🎮 Your bot grinds while you sleep, work, or chill. Passive income on autopilot - that's the dream!"
            case .granny:
                return "Your bot works while you rest, baby! 👵🏽 Day and night, weekends too. Your money grows even when you're sleeping soundly!"
            case .auntie:
                return "Scalable income without time investment! 💼 Your bot executes trades around the clock. Build wealth while you build your empire!"
            case .mama:
                return "24/7 family income! 💖 Your bot protects and grows our money while you take care of everything else. True work-life balance!"
            case .uncle:
                return "Generational wealth building! 🧔🏽 Your bot works tirelessly so future generations benefit. Your legacy grows automatically!"
            case .bro:
                return "Passive hustle! 🤝 Your bot keeps grinding when you can't. Real support system for building wealth!"
            }
        }
        
        private func getFundingExplanation() -> String {
            switch self {
            case .sister:
                return "Fund your account using CashApp Bitcoin or your debit card! 💅🏽 Coinexx needs minimum 0.001 BTC (~$10) to start. Quick, safe, and secure!"
            case .cousin:
                return "Load up with CashApp Bitcoin or card! 🎮 Just $10 minimum to start trading. Fast deposits, faster profits!"
            case .granny:
                return "Add money safely with CashApp or your bank card, baby! 👵🏽 Only $10 needed to begin. We keep it simple and secure!"
            case .auntie:
                return "Professional funding options! 💼 CashApp Bitcoin or direct card payments. $10 minimum investment for maximum potential!"
            case .mama:
                return "Secure family funding! 💖 Use CashApp Bitcoin or trusted card payments. Start small, dream big - $10 opens the door!"
            case .uncle:
                return "Wise investment starts here! 🧔🏽 CashApp Bitcoin or card funding. $10 minimum to begin building legacy!"
            case .bro:
                return "Easy funding, bro! 🤝 CashApp Bitcoin or your card. $10 gets you started on the wealth journey!"
            }
        }
    }
    
    // MARK: - Family Personality
    
    struct FamilyPersonality {
        let tone: String
        let explanationStyle: String
        let riskTolerance: TradingTypes.RiskLevel
        let preferredFeatures: [String]
        let motivationalQuotes: [String]
    }
    
    // MARK: - Onboarding Step
    
    struct OnboardingStep: Identifiable {
        let id: Int
        let title: String
        let content: String
        let animation: String
        let actionButton: String
        
        var isComplete: Bool = false
    }
    
    // MARK: - Family Member Profile
    
    struct FamilyMemberProfile: Identifiable, Codable {
        let id: UUID
        let name: String
        let memberType: FamilyMemberType
        let onboardingComplete: Bool
        let currentStep: Int
        let createdAt: Date
        let preferences: FamilyPreferences
        let stats: FamilyStats
        
        struct FamilyPreferences: Codable {
            var enableVoiceover: Bool = false
            var autoTradeEnabled: Bool = false
            var riskLevel: TradingTypes.RiskLevel = .low
            var maxDailyRisk: Double = 50.0
            var preferredTradeSize: Double = 0.01
            var enableNotifications: Bool = true
            var beginnerMode: Bool = true
            var requireConfirmation: Bool = true
        }
        
        struct FamilyStats: Codable {
            var totalProfit: Double = 0.0
            var totalTrades: Int = 0
            var winRate: Double = 0.0
            var daysActive: Int = 0
            var botsAssigned: Int = 0
            var learningProgress: Double = 0.0
        }
        
        var formattedProfit: String {
            String(format: "$%.2f", stats.totalProfit)
        }
        
        var formattedWinRate: String {
            String(format: "%.1f%%", stats.winRate)
        }
    }
    
    // MARK: - Family Dashboard Stats
    
    struct FamilyDashboardStats {
        let totalMembers: Int
        let activeMembers: Int
        let totalFamilyProfit: Double
        let bestPerformer: FamilyMemberProfile?
        let recentActivity: [FamilyActivity]
        
        var formattedTotalProfit: String {
            if totalFamilyProfit >= 1000 {
                return String(format: "$%.1fK", totalFamilyProfit / 1000)
            } else {
                return String(format: "$%.2f", totalFamilyProfit)
            }
        }
    }
    
    // MARK: - Family Activity
    
    struct FamilyActivity: Identifiable {
        let id: UUID = UUID()
        let memberName: String
        let memberType: FamilyMemberType
        let activityType: ActivityType
        let description: String
        let timestamp: Date
        let profit: Double?
        
        enum ActivityType: String {
            case trade = "Trade"
            case learning = "Learning"
            case milestone = "Milestone"
            case funding = "Funding"
        }
        
        var activityIcon: String {
            switch activityType {
            case .trade: return "chart.line.uptrend.xyaxis"
            case .learning: return "brain.head.profile"
            case .milestone: return "star.fill"
            case .funding: return "dollarsign.circle.fill"
            }
        }
        
        var activityColor: Color {
            switch activityType {
            case .trade: return profit ?? 0 > 0 ? .green : .red
            case .learning: return .blue
            case .milestone: return .gold
            case .funding: return .orange
            }
        }
    }
    
    // MARK: - Sample Data
    
    static let sampleFamilyMembers: [FamilyMemberProfile] = [
        FamilyMemberProfile(
            id: UUID(),
            name: "Ashley (Sister)",
            memberType: .sister,
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
        FamilyMemberProfile(
            id: UUID(),
            name: "Marcus (Cousin)",
            memberType: .cousin,
            onboardingComplete: true,
            currentStep: 6,
            createdAt: Date().addingTimeInterval(-86400 * 3),
            preferences: FamilyMemberProfile.FamilyPreferences(
                autoTradeEnabled: true,
                riskLevel: .high,
                maxDailyRisk: 150.0,
                beginnerMode: false
            ),
            stats: FamilyMemberProfile.FamilyStats(
                totalProfit: 467.75,
                totalTrades: 78,
                winRate: 76.9,
                daysActive: 3,
                botsAssigned: 3,
                learningProgress: 45.0
            )
        ),
        FamilyMemberProfile(
            id: UUID(),
            name: "Grandma Rose",
            memberType: .granny,
            onboardingComplete: false,
            currentStep: 3,
            createdAt: Date().addingTimeInterval(-86400 * 1),
            preferences: FamilyMemberProfile.FamilyPreferences(),
            stats: FamilyMemberProfile.FamilyStats(
                totalProfit: 0.0,
                totalTrades: 0,
                winRate: 0.0,
                daysActive: 1,
                botsAssigned: 0,
                learningProgress: 15.0
            )
        )
    ]
    
    static let sampleFamilyActivity: [FamilyActivity] = [
        FamilyActivity(
            memberName: "Ashley",
            memberType: .sister,
            activityType: .trade,
            description: "Profitable XAUUSD trade",
            timestamp: Date().addingTimeInterval(-1800),
            profit: 45.50
        ),
        FamilyActivity(
            memberName: "Marcus",
            memberType: .cousin,
            activityType: .learning,
            description: "Uploaded 'Smart Money Concepts' PDF",
            timestamp: Date().addingTimeInterval(-3600),
            profit: nil
        ),
        FamilyActivity(
            memberName: "Grandma Rose",
            memberType: .granny,
            activityType: .milestone,
            description: "Completed Bot Training basics",
            timestamp: Date().addingTimeInterval(-7200),
            profit: nil
        )
    ]
}