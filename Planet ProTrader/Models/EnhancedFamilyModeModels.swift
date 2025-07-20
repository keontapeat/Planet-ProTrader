//
//  EnhancedFamilyModeModels.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 1/25/25.
//

import SwiftUI
import Foundation

// MARK: - Family Member Types

enum FamilyMemberType: String, CaseIterable, Codable {
    case sister = "SISTER"
    case cousin = "COUSIN" 
    case granny = "GRANNY"
    case auntie = "AUNTIE"
    case mama = "MAMA"
    case uncle = "UNCLE"
    case daddy = "DADDY"
    case bigBro = "BIG_BRO"
}

struct FamilyPersonality {
    let greetings: [String]
    let encouragements: [String]
    let warnings: [String]
    let celebrations: [String]
    let tradingStyle: String
    let riskLevel: Double 
    let voiceCharacteristics: String
    
    func randomGreeting() -> String {
        greetings.randomElement() ?? "Hello!"
    }
    
    func randomEncouragement() -> String {
        encouragements.randomElement() ?? "You got this!"
    }
    
    func randomWarning() -> String {
        warnings.randomElement() ?? "Be careful!"
    }
    
    func randomCelebration() -> String {
        celebrations.randomElement() ?? "Great job!"
    }
}

// MARK: - Family Mode Manager

class FamilyModeManager: ObservableObject {
    @Published var selectedFamilyMember: FamilyMemberType = .sister
    @Published var familyMembers: [SharedTypes.FamilyMemberProfile] = []
    @Published var unlockedMembers: Set<FamilyMemberType> = [.sister, .cousin]
    @Published var currentStreak: Int = 0
    @Published var familyBonds: [FamilyMemberType: Double] = [:]
    
    init() {
        setupFamilyMembers()
        loadUserProgress()
    }
    
    private func setupFamilyMembers() {
        familyMembers = [
            SharedTypes.FamilyMemberProfile(
                name: "Sophia",
                age: 25,
                role: .child,
                experienceLevel: .intermediate,
                goals: ["Learn trading", "Build wealth"],
                progress: 0.5,
                avatar: "avatar1",
                permissions: [.viewPortfolio, .makeTrades],
                tradingExperience: .intermediate,
                preferences: SharedTypes.FamilyMemberProfile.TradingPreferences(from: SharedTypes.TradingPreferences(riskTolerance: 0.5, favoriteStrategies: ["Moving Average Crossovers", "Breakout Trading"], preferredMarkets: ["Stocks", "Forex"])),
                achievements: ["Beginner Trader"],
                joinDate: Date(),
                isActive: true
            ),
            SharedTypes.FamilyMemberProfile(
                name: "Marcus",
                age: 30,
                role: .parent,
                experienceLevel: .advanced,
                goals: ["Advanced trading", "Portfolio management"],
                progress: 0.8,
                avatar: "avatar2",
                permissions: [.viewPortfolio, .makeTrades, .manageSettings],
                tradingExperience: .advanced,
                preferences: SharedTypes.FamilyMemberProfile.TradingPreferences(from: SharedTypes.TradingPreferences(riskTolerance: 0.8, favoriteStrategies: ["Swing Trading", "News Trading"], preferredMarkets: ["Stocks", "Crypto"])),
                achievements: ["Intermediate Trader", "Beginner Investor"],
                joinDate: Date(),
                isActive: true
            ),
            SharedTypes.FamilyMemberProfile(
                name: "Eleanor",
                age: 60,
                role: .parent,
                experienceLevel: .expert,
                goals: ["Conservative growth", "Risk management"],
                progress: 0.9,
                avatar: "avatar3",
                permissions: [.viewPortfolio, .manageSettings],
                tradingExperience: .expert,
                preferences: SharedTypes.FamilyMemberProfile.TradingPreferences(from: SharedTypes.TradingPreferences(riskTolerance: 0.2, favoriteStrategies: ["Buy & Hold", "Dividend Growth"], preferredMarkets: ["Stocks", "Bonds"])),
                achievements: ["Advanced Trader", "Expert Investor"],
                joinDate: Date(),
                isActive: true
            ),
            SharedTypes.FamilyMemberProfile(
                name: "Keisha",
                age: 35,
                role: .parent,
                experienceLevel: .advanced,
                goals: ["Day trading", "Bot creation"],
                progress: 0.6,
                avatar: "avatar4",
                permissions: [.viewPortfolio, .makeTrades, .createBots],
                tradingExperience: .advanced,
                preferences: SharedTypes.FamilyMemberProfile.TradingPreferences(from: SharedTypes.TradingPreferences(riskTolerance: 0.6, favoriteStrategies: ["Day Trading", "Scalping"], preferredMarkets: ["Forex", "Crypto"])),
                achievements: ["Intermediate Trader", "Beginner Bot Creator"],
                joinDate: Date(),
                isActive: true
            ),
            SharedTypes.FamilyMemberProfile(
                name: "Victoria",
                age: 40,
                role: .parent,
                experienceLevel: .expert,
                goals: ["Portfolio growth", "Risk optimization"],
                progress: 0.7,
                avatar: "avatar5",
                permissions: [.viewPortfolio, .manageSettings, .viewReports],
                tradingExperience: .expert,
                preferences: SharedTypes.FamilyMemberProfile.TradingPreferences(from: SharedTypes.TradingPreferences(riskTolerance: 0.4, favoriteStrategies: ["Conservative Growth", "Index Investing"], preferredMarkets: ["Stocks", "Bonds"])),
                achievements: ["Advanced Trader", "Expert Investor"],
                joinDate: Date(),
                isActive: true
            ),
            SharedTypes.FamilyMemberProfile(
                name: "Jerome",
                age: 50,
                role: .parent,
                experienceLevel: .expert,
                goals: ["High-risk trading", "Bot mastery"],
                progress: 0.9,
                avatar: "avatar6",
                permissions: [.viewPortfolio, .makeTrades, .createBots],
                tradingExperience: .expert,
                preferences: SharedTypes.FamilyMemberProfile.TradingPreferences(from: SharedTypes.TradingPreferences(riskTolerance: 0.9, favoriteStrategies: ["Momentum Trading", "Penny Stocks"], preferredMarkets: ["Stocks", "Crypto"])),
                achievements: ["Advanced Trader", "Expert Bot Creator"],
                joinDate: Date(),
                isActive: true
            ),
            SharedTypes.FamilyMemberProfile(
                name: "Robert",
                age: 45,
                role: .parent,
                experienceLevel: .expert,
                goals: ["Systematic trading", "Portfolio optimization"],
                progress: 0.8,
                avatar: "avatar7",
                permissions: [.viewPortfolio, .manageSettings, .viewReports],
                tradingExperience: .expert,
                preferences: SharedTypes.FamilyMemberProfile.TradingPreferences(from: SharedTypes.TradingPreferences(riskTolerance: 0.5, favoriteStrategies: ["Systematic Trading", "Portfolio Allocation"], preferredMarkets: ["Stocks", "Bonds"])),
                achievements: ["Advanced Trader", "Expert Investor"],
                joinDate: Date(),
                isActive: true
            ),
            SharedTypes.FamilyMemberProfile(
                name: "Anthony",
                age: 28,
                role: .parent,
                experienceLevel: .advanced,
                goals: ["Growth investing", "Market analysis"],
                progress: 0.7,
                avatar: "avatar8",
                permissions: [.viewPortfolio, .makeTrades, .createBots],
                tradingExperience: .advanced,
                preferences: SharedTypes.FamilyMemberProfile.TradingPreferences(from: SharedTypes.TradingPreferences(riskTolerance: 0.7, favoriteStrategies: ["Growth Stocks", "Momentum Plays"], preferredMarkets: ["Stocks", "Forex"])),
                achievements: ["Intermediate Trader", "Beginner Bot Creator"],
                joinDate: Date(),
                isActive: true
            )
        ]
        
        // Initialize bonds properly
        var initialBonds: [FamilyMemberType: Double] = [:]
        for member in FamilyMemberType.allCases {
            initialBonds[member] = 0.0
        }
        familyBonds = initialBonds
    }
    
    func unlockFamilyMember(_ type: FamilyMemberType) {
        unlockedMembers.insert(type)
    }
    
    func increaseFamilyBond(_ type: FamilyMemberType, by amount: Double = 1.0) {
        familyBonds[type, default: 0.0] += amount
        if familyBonds[type]! >= 100.0 {
            familyBonds[type] = 100.0
        }
    }
    
    func getFamilyMember(_ type: FamilyMemberType) -> SharedTypes.FamilyMemberProfile? {
        return familyMembers.first { $0.name.lowercased().contains(type.rawValue.lowercased()) }
    }
    
    private func loadUserProgress() {
        if let data = UserDefaults.standard.data(forKey: "familyModeProgress") {
            let decoder = JSONDecoder()
            // Use String keys for decoding since UserDefaults can't handle enum keys directly
            if let bondsData = try? decoder.decode([String: Double].self, from: data) {
                var convertedBonds: [FamilyMemberType: Double] = [:]
                for (key, value) in bondsData {
                    if let memberType = FamilyMemberType(rawValue: key) {
                        convertedBonds[memberType] = value
                    }
                }
                familyBonds = convertedBonds
            }
        }
    }
    
    func saveProgress() {
        let encoder = JSONEncoder()
        // Convert to String keys for encoding
        let bondsForEncoding = familyBonds.reduce(into: [String: Double]()) { result, pair in
            result[pair.key.rawValue] = pair.value
        }
        
        if let data = try? encoder.encode(bondsForEncoding) {
            UserDefaults.standard.set(data, forKey: "familyModeProgress")
        }
    }
}

// MARK: - Family Achievement System

struct FamilyAchievement: Identifiable, Codable {
    let id = UUID()
    let title: String
    let description: String
    let category: AchievementCategory
    let difficulty: AchievementDifficulty
    let points: Int
    let icon: String
    let earnedBy: [String] 
    let unlockedAt: Date?
    let requirements: [String]
    let rewards: [String]
    
    enum AchievementCategory: String, CaseIterable, Codable {
        case trading = "Trading"
        case learning = "Learning"
        case teamwork = "Teamwork"
        case milestone = "Milestone"
        
        var color: Color {
            switch self {
            case .trading: return .green
            case .learning: return .blue
            case .teamwork: return .purple
            case .milestone: return Color("primaryGold")
            }
        }
    }
    
    enum AchievementDifficulty: String, CaseIterable, Codable {
        case easy = "Easy"
        case medium = "Medium"
        case hard = "Hard"
        case legendary = "Legendary"
        
        var color: Color {
            switch self {
            case .easy: return .green
            case .medium: return .yellow
            case .hard: return .orange
            case .legendary: return .purple
            }
        }
    }
}

// MARK: - Family Statistics

struct FamilyStatistics: Codable {
    let totalMembers: Int
    let activeSessions: Int
    let combinedPortfolioValue: Double
    let monthlyProfitLoss: Double
    let tradesCompleted: Int
    let achievementsUnlocked: Int
    let averageRiskLevel: Double
    let topPerformer: String?
    let weeklyGoalProgress: Double
    let lastActivity: Date
    
    var formattedPortfolioValue: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: NSNumber(value: combinedPortfolioValue)) ?? "$0.00"
    }
    
    var formattedMonthlyPL: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        let sign = monthlyProfitLoss >= 0 ? "+" : ""
        let value = formatter.string(from: NSNumber(value: monthlyProfitLoss)) ?? "$0.00"
        return "\(sign)\(value)"
    }
}

#Preview {
    Text("Enhanced Family Mode Models")
}