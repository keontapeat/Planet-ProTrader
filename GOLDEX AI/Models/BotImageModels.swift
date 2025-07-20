//
//  BotImageModels.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 1/27/25.
//  AI-Generated Bot Images & Pokemon-Style Stat Cards
//

import Foundation
import SwiftUI

// MARK: - Bot Image Models

struct BotImageModels {
    
    // MARK: - Bot Visual Profile
    
    struct BotVisualProfile: Identifiable, Codable {
        let id: UUID
        let botId: UUID
        let botName: String
        let visualStyle: VisualStyle
        let appearance: BotAppearance
        let statCard: BotStatCard
        let imageUrls: BotImageUrls
        let animations: [BotAnimation]
        let lastUpdated: Date
        
        // MARK: - Visual Style
        
        enum VisualStyle: String, CaseIterable, Codable {
            case cyberpunk = "CYBERPUNK"
            case professional = "PROFESSIONAL"  
            case beast_mode = "BEAST_MODE"
            case ninja = "NINJA"
            case robot = "ROBOT"
            case anime = "ANIME"
            case realistic = "REALISTIC"
            case abstract = "ABSTRACT"
            
            var description: String {
                switch self {
                case .cyberpunk: return "Futuristic cyber warrior with neon accents"
                case .professional: return "Sharp business suit with money symbols"
                case .beast_mode: return "Aggressive monster with hungry eyes"
                case .ninja: return "Stealthy trader in the shadows"
                case .robot: return "Mechanical precision machine"
                case .anime: return "Anime-style character with expressive features"
                case .realistic: return "Photorealistic human-like appearance"
                case .abstract: return "Geometric shapes and patterns"
                }
            }
            
            var colorScheme: [Color] {
                switch self {
                case .cyberpunk: return [.cyan, .purple, .pink, .black]
                case .professional: return [.black, .white, .gold, .gray]
                case .beast_mode: return [.red, .orange, .black, .yellow]
                case .ninja: return [.black, .gray, .blue, .white]
                case .robot: return [.silver, .blue, .white, .gray]
                case .anime: return [.pink, .blue, .white, .yellow]
                case .realistic: return [.brown, .tan, .black, .white]
                case .abstract: return [.purple, .green, .orange, .blue]
                }
            }
            
            var primaryColor: Color {
                colorScheme.first ?? .blue
            }
        }
        
        // MARK: - Bot Appearance
        
        struct BotAppearance: Codable {
            let bodyType: BodyType
            let eyeStyle: EyeStyle  
            let accessories: [Accessory]
            let aura: AuraType
            let pose: PoseType
            let expressions: [Expression]
            
            enum BodyType: String, CaseIterable, Codable {
                case humanoid = "HUMANOID"
                case mechanical = "MECHANICAL"
                case beast = "BEAST"
                case energy = "ENERGY"
                case hybrid = "HYBRID"
                
                var description: String {
                    switch self {
                    case .humanoid: return "Human-like form with enhanced features"
                    case .mechanical: return "Robotic body with visible tech components"
                    case .beast: return "Animal-inspired form with predatory features"
                    case .energy: return "Pure energy being with flowing particles"
                    case .hybrid: return "Combination of organic and mechanical parts"
                    }
                }
            }
            
            enum EyeStyle: String, CaseIterable, Codable {
                case laser_red = "LASER_RED"
                case money_green = "MONEY_GREEN"
                case cyber_blue = "CYBER_BLUE"
                case golden_glow = "GOLDEN_GLOW"
                case predator = "PREDATOR"
                case calculating = "CALCULATING"
                
                var color: Color {
                    switch self {
                    case .laser_red: return .red
                    case .money_green: return .green
                    case .cyber_blue: return .blue
                    case .golden_glow: return .gold
                    case .predator: return .orange
                    case .calculating: return .purple
                    }
                }
                
                var effect: String {
                    switch self {
                    case .laser_red: return "Intense red glow with scanning lines"
                    case .money_green: return "Dollar sign pupils with green aura"
                    case .cyber_blue: return "Digital matrix code flowing"
                    case .golden_glow: return "Warm golden light emanating"
                    case .predator: return "Cat-like slits with hunger"
                    case .calculating: return "Binary code scrolling in pupils"
                    }
                }
            }
            
            enum Accessory: String, CaseIterable, Codable {
                case money_chain = "MONEY_CHAIN"
                case cyber_visor = "CYBER_VISOR"
                case trading_badge = "TRADING_BADGE"
                case profit_crown = "PROFIT_CROWN"
                case data_gloves = "DATA_GLOVES"
                case energy_wings = "ENERGY_WINGS"
                case beast_claws = "BEAST_CLAWS"
                case hologram_display = "HOLOGRAM_DISPLAY"
                
                var description: String {
                    switch self {
                    case .money_chain: return "Gold chain with dollar sign pendant"
                    case .cyber_visor: return "High-tech visor displaying market data"
                    case .trading_badge: return "Elite trader certification badge"
                    case .profit_crown: return "Crown made of golden profit symbols"
                    case .data_gloves: return "Gloves that glow with data streams"
                    case .energy_wings: return "Wings made of pure trading energy"
                    case .beast_claws: return "Sharp claws for aggressive trading"
                    case .hologram_display: return "Floating holographic trading interface"
                    }
                }
            }
            
            enum AuraType: String, CaseIterable, Codable {
                case money_fire = "MONEY_FIRE"
                case cyber_matrix = "CYBER_MATRIX"
                case lightning_profits = "LIGHTNING_PROFITS"
                case golden_glow = "GOLDEN_GLOW"
                case data_stream = "DATA_STREAM"
                case predator_mist = "PREDATOR_MIST"
                
                var color: Color {
                    switch self {
                    case .money_fire: return .green
                    case .cyber_matrix: return .cyan
                    case .lightning_profits: return .yellow
                    case .golden_glow: return .gold
                    case .data_stream: return .blue
                    case .predator_mist: return .red
                    }
                }
                
                var effect: String {
                    switch self {
                    case .money_fire: return "Green flames with dollar symbols"
                    case .cyber_matrix: return "Matrix-style digital rain"
                    case .lightning_profits: return "Electric bolts of pure profit"
                    case .golden_glow: return "Warm golden radiance"
                    case .data_stream: return "Flowing streams of market data"
                    case .predator_mist: return "Ominous red mist of aggression"
                    }
                }
            }
            
            enum PoseType: String, CaseIterable, Codable {
                case confident_stance = "CONFIDENT_STANCE"
                case aggressive_lean = "AGGRESSIVE_LEAN"
                case calculating_cross_arms = "CALCULATING_CROSS_ARMS"
                case ready_to_pounce = "READY_TO_POUNCE"
                case meditation_balance = "MEDITATION_BALANCE"
                case victory_celebration = "VICTORY_CELEBRATION"
                
                var description: String {
                    switch self {
                    case .confident_stance: return "Standing tall with chest out, radiating confidence"
                    case .aggressive_lean: return "Leaning forward with intense focus"
                    case .calculating_cross_arms: return "Arms crossed, deep in strategic thought"
                    case .ready_to_pounce: return "Crouched and ready to strike at opportunities"
                    case .meditation_balance: return "Balanced pose showing inner calm and wisdom"
                    case .victory_celebration: return "Arms raised in triumphant victory pose"
                    }
                }
            }
            
            enum Expression: String, CaseIterable, Codable {
                case hungry_grin = "HUNGRY_GRIN"
                case focused_determination = "FOCUSED_DETERMINATION"
                case confident_smirk = "CONFIDENT_SMIRK"
                case calculating_stare = "CALCULATING_STARE"
                case victorious_smile = "VICTORIOUS_SMILE"
                case predatory_gaze = "PREDATORY_GAZE"
                
                var description: String {
                    switch self {
                    case .hungry_grin: return "Wide grin showing appetite for profits"
                    case .focused_determination: return "Intense focus with unwavering determination"
                    case .confident_smirk: return "Subtle smirk showing quiet confidence"
                    case .calculating_stare: return "Cold, calculating expression while analyzing"
                    case .victorious_smile: return "Warm smile of recent victory"
                    case .predatory_gaze: return "Intense stare of a profit predator"
                    }
                }
            }
        }
        
        // MARK: - Pokemon-Style Stat Card
        
        struct BotStatCard: Codable {
            let cardStyle: CardStyle
            let stats: StatValues
            let abilities: [BotAbility]
            let weaknesses: [Weakness]
            let strengths: [Strength]
            let evolution: EvolutionInfo
            let rarity: CardRarity
            
            enum CardStyle: String, CaseIterable, Codable {
                case holographic = "HOLOGRAPHIC"
                case foil = "FOIL"
                case standard = "STANDARD"
                case special_edition = "SPECIAL_EDITION"
                case legendary = "LEGENDARY"
                
                var bgGradient: LinearGradient {
                    switch self {
                    case .holographic:
                        return LinearGradient(colors: [.purple, .blue, .cyan, .purple], startPoint: .topLeading, endPoint: .bottomTrailing)
                    case .foil:
                        return LinearGradient(colors: [.silver, .white, .silver], startPoint: .topLeading, endPoint: .bottomTrailing)
                    case .standard:
                        return LinearGradient(colors: [.white, .gray.opacity(0.3)], startPoint: .top, endPoint: .bottom)
                    case .special_edition:
                        return LinearGradient(colors: [.gold, .yellow, .orange], startPoint: .topLeading, endPoint: .bottomTrailing)
                    case .legendary:
                        return LinearGradient(colors: [.black, .red, .gold, .black], startPoint: .topLeading, endPoint: .bottomTrailing)
                    }
                }
            }
            
            struct StatValues: Codable {
                let attack: Int        // Aggressiveness in trading
                let defense: Int       // Risk management 
                let speed: Int         // Trade execution speed
                let accuracy: Int      // Win rate
                let intelligence: Int  // Strategy complexity
                let greed: Int        // Profit motivation
                let loyalty: Int      // Consistency
                let hunger: Int       // Money hunger level
                
                var total: Int {
                    attack + defense + speed + accuracy + intelligence + greed + loyalty + hunger
                }
                
                var maxStat: (name: String, value: Int) {
                    let stats = [
                        ("Attack", attack),
                        ("Defense", defense),
                        ("Speed", speed),
                        ("Accuracy", accuracy),
                        ("Intelligence", intelligence),
                        ("Greed", greed),
                        ("Loyalty", loyalty),
                        ("Hunger", hunger)
                    ]
                    return stats.max { $0.1 < $1.1 } ?? ("Attack", attack)
                }
                
                var statDistribution: [StatBar] {
                    return [
                        StatBar(name: "ATK", value: attack, color: .red),
                        StatBar(name: "DEF", value: defense, color: .blue),
                        StatBar(name: "SPD", value: speed, color: .green),
                        StatBar(name: "ACC", value: accuracy, color: .purple),
                        StatBar(name: "INT", value: intelligence, color: .indigo),
                        StatBar(name: "GRD", value: greed, color: .orange),
                        StatBar(name: "LOY", value: loyalty, color: .pink),
                        StatBar(name: "HUN", value: hunger, color: .yellow)
                    ]
                }
                
                struct StatBar {
                    let name: String
                    let value: Int
                    let color: Color
                    
                    var percentage: Double {
                        Double(value) / 100.0
                    }
                }
            }
            
            struct BotAbility: Identifiable, Codable {
                let id: UUID
                let name: String
                let description: String
                let type: AbilityType
                let power: Int
                let cost: String
                
                enum AbilityType: String, CaseIterable, Codable {
                    case passive = "PASSIVE"
                    case active = "ACTIVE" 
                    case ultimate = "ULTIMATE"
                    case legendary = "LEGENDARY"
                    
                    var color: Color {
                        switch self {
                        case .passive: return .gray
                        case .active: return .blue
                        case .ultimate: return .purple
                        case .legendary: return .gold
                        }
                    }
                }
            }
            
            enum Weakness: String, CaseIterable, Codable {
                case volatility = "VOLATILITY"
                case news_events = "NEWS_EVENTS"
                case sideways_markets = "SIDEWAYS_MARKETS"
                case high_spread = "HIGH_SPREAD"
                case weekend_gaps = "WEEKEND_GAPS"
                
                var description: String {
                    switch self {
                    case .volatility: return "Struggles in extreme volatility"
                    case .news_events: return "Vulnerable during major news"
                    case .sideways_markets: return "Poor performance in ranging markets"
                    case .high_spread: return "Affected by wide spreads"
                    case .weekend_gaps: return "Vulnerable to weekend gaps"
                    }
                }
            }
            
            enum Strength: String, CaseIterable, Codable {
                case trend_following = "TREND_FOLLOWING"
                case breakout_detection = "BREAKOUT_DETECTION"
                case risk_management = "RISK_MANAGEMENT"
                case speed_execution = "SPEED_EXECUTION"
                case pattern_recognition = "PATTERN_RECOGNITION"
                
                var description: String {
                    switch self {
                    case .trend_following: return "Excellent at following trends"
                    case .breakout_detection: return "Spots breakouts before others"
                    case .risk_management: return "Superior risk control"
                    case .speed_execution: return "Lightning-fast execution"
                    case .pattern_recognition: return "Advanced pattern detection"
                    }
                }
            }
            
            struct EvolutionInfo: Codable {
                let currentStage: Int
                let maxStage: Int
                let nextEvolution: String?
                let evolutionRequirements: [String]
                
                var canEvolve: Bool {
                    currentStage < maxStage
                }
                
                var evolutionProgress: Double {
                    Double(currentStage) / Double(maxStage)
                }
            }
            
            enum CardRarity: String, CaseIterable, Codable {
                case common = "COMMON"
                case uncommon = "UNCOMMON"
                case rare = "RARE"
                case epic = "EPIC"
                case legendary = "LEGENDARY"
                case mythical = "MYTHICAL"
                
                var color: Color {
                    switch self {
                    case .common: return .gray
                    case .uncommon: return .green
                    case .rare: return .blue
                    case .epic: return .purple
                    case .legendary: return .gold
                    case .mythical: return .red
                    }
                }
                
                var starCount: Int {
                    switch self {
                    case .common: return 1
                    case .uncommon: return 2
                    case .rare: return 3
                    case .epic: return 4
                    case .legendary: return 5
                    case .mythical: return 6
                    }
                }
            }
        }
        
        // MARK: - Bot Image URLs
        
        struct BotImageUrls: Codable {
            let portrait: String
            let fullBody: String
            let actionShot: String
            let cardImage: String
            let thumbnail: String
            let animations: [String]
        }
        
        // MARK: - Bot Animation
        
        struct BotAnimation: Identifiable, Codable {
            let id: UUID
            let name: String
            let type: AnimationType
            let duration: Double
            let frames: [String]
            
            enum AnimationType: String, CaseIterable, Codable {
                case idle = "IDLE"
                case victory = "VICTORY"
                case attack = "ATTACK"
                case thinking = "THINKING"
                case angry = "ANGRY"
                case celebrating = "CELEBRATING"
            }
        }
    }
    
    // MARK: - AI Image Generator
    
    @MainActor
    class BotImageGenerator: ObservableObject {
        @Published var generatedImages: [String: String] = [:] // botId -> imageUrl
        @Published var isGenerating = false
        @Published var generationProgress: Double = 0.0
        
        // MARK: - Image Generation
        
        func generateBotImages(for bot: BotModel) async -> BotVisualProfile? {
            isGenerating = true
            generationProgress = 0.0
            
            // Simulate AI image generation process
            let visualStyle = determineVisualStyle(from: bot)
            let appearance = createAppearance(for: bot, style: visualStyle)
            let statCard = createStatCard(from: bot)
            
            // Simulate generation delay
            for i in 0...100 {
                generationProgress = Double(i) / 100.0
                try? await Task.sleep(nanoseconds: 50_000_000) // 50ms per step
            }
            
            let imageUrls = BotVisualProfile.BotImageUrls(
                portrait: "generated_portrait_\(bot.id)",
                fullBody: "generated_fullbody_\(bot.id)",
                actionShot: "generated_action_\(bot.id)",
                cardImage: "generated_card_\(bot.id)",
                thumbnail: "generated_thumb_\(bot.id)",
                animations: ["anim_idle_\(bot.id)", "anim_victory_\(bot.id)"]
            )
            
            let animations = createAnimations(for: bot)
            
            isGenerating = false
            
            return BotVisualProfile(
                id: UUID(),
                botId: bot.id,
                botName: bot.name,
                visualStyle: visualStyle,
                appearance: appearance,
                statCard: statCard,
                imageUrls: imageUrls,
                animations: animations,
                lastUpdated: Date()
            )
        }
        
        private func determineVisualStyle(from bot: BotModel) -> BotVisualProfile.VisualStyle {
            // Determine style based on bot characteristics
            switch bot.strategyType {
            case .scalping:
                return .ninja
            case .breakout:
                return .beast_mode
            case .trendFollowing:
                return .cyberpunk
            case .swing:
                return .professional
            case .arbitrage:
                return .robot
            default:
                return .anime
            }
        }
        
        private func createAppearance(for bot: BotModel, style: BotVisualProfile.VisualStyle) -> BotVisualProfile.BotAppearance {
            // Create appearance based on bot personality and performance
            let aggressiveness = Int(bot.totalProfit / 100) // More profit = more aggressive look
            let bodyType: BotVisualProfile.BotAppearance.BodyType = aggressiveness > 50 ? .beast : .humanoid
            
            let eyeStyle: BotVisualProfile.BotAppearance.EyeStyle = bot.winRate > 80 ? .golden_glow : .cyber_blue
            
            var accessories: [BotVisualProfile.BotAppearance.Accessory] = [.data_gloves]
            if bot.totalProfit > 5000 {
                accessories.append(.money_chain)
            }
            if bot.winRate > 90 {
                accessories.append(.profit_crown)
            }
            
            let aura: BotVisualProfile.BotAppearance.AuraType = bot.totalProfit > 10000 ? .money_fire : .data_stream
            
            return BotVisualProfile.BotAppearance(
                bodyType: bodyType,
                eyeStyle: eyeStyle,
                accessories: accessories,
                aura: aura,
                pose: .confident_stance,
                expressions: [.hungry_grin, .focused_determination]
            )
        }
        
        private func createStatCard(from bot: BotModel) -> BotVisualProfile.BotStatCard {
            // Convert bot performance to Pokemon-style stats
            let attack = Int(min(100, bot.totalProfit / 100)) // Aggressiveness
            let defense = Int(min(100, (100 - bot.maxDrawdown) * 10)) // Risk management
            let speed = Int(min(100, bot.avgFlipSpeed)) // Execution speed
            let accuracy = Int(min(100, bot.winRate)) // Win rate
            let intelligence = Int(min(100, bot.trainingScore)) // Strategy complexity
            let greed = Int(min(100, bot.totalProfit / 50)) // Profit motivation
            let loyalty = Int(min(100, bot.confidenceLevel)) // Consistency
            let hunger = 10 // Money hunger (max for all bots!)
            
            let stats = BotVisualProfile.BotStatCard.StatValues(
                attack: attack,
                defense: defense,
                speed: speed,
                accuracy: accuracy,
                intelligence: intelligence,
                greed: greed,
                loyalty: loyalty,
                hunger: hunger
            )
            
            // Determine rarity based on performance
            let rarity: BotVisualProfile.BotStatCard.CardRarity
            if bot.universeScore >= 95 {
                rarity = .mythical
            } else if bot.universeScore >= 90 {
                rarity = .legendary
            } else if bot.universeScore >= 80 {
                rarity = .epic
            } else if bot.universeScore >= 70 {
                rarity = .rare
            } else if bot.universeScore >= 60 {
                rarity = .uncommon
            } else {
                rarity = .common
            }
            
            let abilities = createBotAbilities(for: bot)
            let weaknesses = determineWeaknesses(for: bot)
            let strengths = determineStrengths(for: bot)
            let evolution = createEvolutionInfo(for: bot)
            
            return BotVisualProfile.BotStatCard(
                cardStyle: rarity == .legendary || rarity == .mythical ? .legendary : .holographic,
                stats: stats,
                abilities: abilities,
                weaknesses: weaknesses,
                strengths: strengths,
                evolution: evolution,
                rarity: rarity
            )
        }
        
        private func createBotAbilities(for bot: BotModel) -> [BotVisualProfile.BotStatCard.BotAbility] {
            var abilities: [BotVisualProfile.BotStatCard.BotAbility] = []
            
            // Passive ability based on strategy
            switch bot.strategyType {
            case .scalping:
                abilities.append(BotVisualProfile.BotStatCard.BotAbility(
                    id: UUID(),
                    name: "Lightning Strike",
                    description: "Execute trades 50% faster than normal bots",
                    type: .passive,
                    power: 75,
                    cost: "Always Active"
                ))
            case .breakout:
                abilities.append(BotVisualProfile.BotStatCard.BotAbility(
                    id: UUID(),
                    name: "Breakout Detection",
                    description: "Spot breakouts 30 seconds before other bots",
                    type: .passive,
                    power: 85,
                    cost: "Always Active"
                ))
            default:
                abilities.append(BotVisualProfile.BotStatCard.BotAbility(
                    id: UUID(),
                    name: "Profit Hunter",
                    description: "Increased profit detection by 25%",
                    type: .passive,
                    power: 60,
                    cost: "Always Active"
                ))
            }
            
            // Ultimate ability for high performers
            if bot.totalProfit > 10000 {
                abilities.append(BotVisualProfile.BotStatCard.BotAbility(
                    id: UUID(),
                    name: "Money Tsunami",
                    description: "Triple profit potential for next 5 trades",
                    type: .ultimate,
                    power: 100,
                    cost: "Once per day"
                ))
            }
            
            return abilities
        }
        
        private func determineWeaknesses(for bot: BotModel) -> [BotVisualProfile.BotStatCard.Weakness] {
            var weaknesses: [BotVisualProfile.BotStatCard.Weakness] = []
            
            if bot.maxDrawdown > 5 {
                weaknesses.append(.volatility)
            }
            if bot.strategyType == .scalping {
                weaknesses.append(.high_spread)
            }
            if bot.winRate < 70 {
                weaknesses.append(.sideways_markets)
            }
            
            return weaknesses
        }
        
        private func determineStrengths(for bot: BotModel) -> [BotVisualProfile.BotStatCard.Strength] {
            var strengths: [BotVisualProfile.BotStatCard.Strength] = []
            
            if bot.winRate > 80 {
                strengths.append(.pattern_recognition)
            }
            if bot.maxDrawdown < 3 {
                strengths.append(.risk_management)
            }
            if bot.avgFlipSpeed > 60 {
                strengths.append(.speed_execution)
            }
            if bot.strategyType == .breakout {
                strengths.append(.breakout_detection)
            }
            
            return strengths
        }
        
        private func createEvolutionInfo(for bot: BotModel) -> BotVisualProfile.BotStatCard.EvolutionInfo {
            return BotVisualProfile.BotStatCard.EvolutionInfo(
                currentStage: bot.generationLevel,
                maxStage: 5,
                nextEvolution: bot.generationLevel < 5 ? "\(bot.name) Ultra" : nil,
                evolutionRequirements: [
                    "Win 100 consecutive trades",
                    "Achieve $50K total profit",
                    "Maintain 95%+ win rate for 30 days"
                ]
            )
        }
        
        private func createAnimations(for bot: BotModel) -> [BotVisualProfile.BotAnimation] {
            return [
                BotVisualProfile.BotAnimation(
                    id: UUID(),
                    name: "Idle Animation",
                    type: .idle,
                    duration: 2.0,
                    frames: ["idle_1", "idle_2", "idle_3"]
                ),
                BotVisualProfile.BotAnimation(
                    id: UUID(),
                    name: "Victory Dance",
                    type: .victory,
                    duration: 3.0,
                    frames: ["victory_1", "victory_2", "victory_3", "victory_4"]
                )
            ]
        }
        
        // MARK: - Prompt Generation for AI APIs
        
        func generateImagePrompt(for profile: BotVisualProfile) -> String {
            let style = profile.visualStyle
            let appearance = profile.appearance
            
            var prompt = "Create a \(style.description) trading bot character named '\(profile.botName)'. "
            prompt += "Body type: \(appearance.bodyType.description). "
            prompt += "Eyes: \(appearance.eyeStyle.effect). "
            prompt += "Pose: \(appearance.pose.description). "
            prompt += "Aura effect: \(appearance.aura.effect). "
            
            for accessory in appearance.accessories {
                prompt += "Wearing: \(accessory.description). "
            }
            
            prompt += "Style should be: professional, high-quality, detailed, trading-themed, money symbols, "
            prompt += "futuristic, digital art style, 4K resolution, dramatic lighting."
            
            return prompt
        }
    }
}

// MARK: - Sample Data

extension BotImageModels.BotVisualProfile {
    static let sampleProfile = BotImageModels.BotVisualProfile(
        id: UUID(),
        botId: UUID(),
        botName: "MoneyHungryBeast",
        visualStyle: .beast_mode,
        appearance: BotImageModels.BotVisualProfile.BotAppearance(
            bodyType: .beast,
            eyeStyle: .money_green,
            accessories: [.money_chain, .profit_crown, .beast_claws],
            aura: .money_fire,
            pose: .ready_to_pounce,
            expressions: [.hungry_grin, .predatory_gaze]
        ),
        statCard: BotImageModels.BotVisualProfile.BotStatCard(
            cardStyle: .legendary,
            stats: BotImageModels.BotVisualProfile.BotStatCard.StatValues(
                attack: 95,
                defense: 70,
                speed: 85,
                accuracy: 89,
                intelligence: 92,
                greed: 100,
                loyalty: 75,
                hunger: 100
            ),
            abilities: [
                BotImageModels.BotVisualProfile.BotStatCard.BotAbility(
                    id: UUID(),
                    name: "Profit Devourer",
                    description: "Consumes market opportunities with 90% success rate",
                    type: .legendary,
                    power: 95,
                    cost: "High Risk Energy"
                )
            ],
            weaknesses: [.volatility],
            strengths: [.breakout_detection, .speed_execution],
            evolution: BotImageModels.BotVisualProfile.BotStatCard.EvolutionInfo(
                currentStage: 4,
                maxStage: 5,
                nextEvolution: "MoneyHungryBeast ULTRA",
                evolutionRequirements: ["Achieve $100K profit", "Win 500 consecutive trades"]
            ),
            rarity: .legendary
        ),
        imageUrls: BotImageModels.BotVisualProfile.BotImageUrls(
            portrait: "beast_portrait_001",
            fullBody: "beast_fullbody_001", 
            actionShot: "beast_action_001",
            cardImage: "beast_card_001",
            thumbnail: "beast_thumb_001",
            animations: ["beast_idle_001", "beast_victory_001"]
        ),
        animations: [],
        lastUpdated: Date()
    )
}

#Preview("Bot Image Models") {
    VStack {
        Text("AI-Generated Bot Images")
            .font(.title)
            .padding()
        
        Text("Pokemon-Style Stat Cards! 🎴")
            .font(.headline)
            .foregroundColor(.purple)
            
        Spacer()
    }
}