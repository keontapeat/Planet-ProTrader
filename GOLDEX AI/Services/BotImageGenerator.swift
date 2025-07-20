//
//  BotImageGenerator.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 7/18/25.
//

import SwiftUI
import Foundation

// MARK: - Bot Visual Characteristics

struct BotVisualCharacteristics {
    let id = UUID()
    let primaryColor: Color
    let secondaryColor: Color
    let accentColor: Color
    let eyeType: EyeType
    let bodyType: BodyType
    let accessory: AccessoryType
    let aura: AuraType
    let pose: PoseType
    let background: BackgroundType
    let rarity: BotRarity
    let tier: BotTier
    let specialEffects: [VisualEffect]
    
    enum EyeType: String, CaseIterable {
        case laser = "Laser Eyes"
        case digital = "Digital Matrix"
        case glowing = "Glowing Orbs"
        case scanner = "Scanner Beam"
        case hologram = "Hologram"
        case fire = "Fire Eyes"
        case diamond = "Diamond Shine"
        case galaxy = "Galaxy Swirl"
        
        var emoji: String {
            switch self {
            case .laser: return "👁️‍🗨️"
            case .digital: return "🔢"
            case .glowing: return "✨"
            case .scanner: return "📡"
            case .hologram: return "🌈"
            case .fire: return "🔥"
            case .diamond: return "💎"
            case .galaxy: return "🌌"
            }
        }
    }
    
    enum BodyType: String, CaseIterable {
        case sleek = "Sleek Humanoid"
        case mechanical = "Mechanical Beast"
        case ethereal = "Ethereal Being"
        case warrior = "Battle Warrior"
        case wizard = "Trading Wizard"
        case ninja = "Market Ninja"
        case cyborg = "Profit Cyborg"
        case alien = "Alien Intelligence"
        
        var description: String {
            switch self {
            case .sleek: return "Smooth, modern design with clean lines"
            case .mechanical: return "Heavy machinery with gears and pistons"
            case .ethereal: return "Semi-transparent with flowing energy"
            case .warrior: return "Armored battle-ready appearance"
            case .wizard: return "Mystical robes with magical elements"
            case .ninja: return "Stealthy, agile design"
            case .cyborg: return "Half-human, half-machine hybrid"
            case .alien: return "Otherworldly features and proportions"
            }
        }
    }
    
    enum AccessoryType: String, CaseIterable {
        case none = "None"
        case crown = "Golden Crown"
        case cape = "Profit Cape"
        case wings = "Money Wings"
        case armor = "Risk Armor"
        case halo = "Success Halo"
        case chains = "Gold Chains"
        case visor = "Data Visor"
        case helmet = "Trading Helmet"
        
        var rarity: BotRarity {
            switch self {
            case .none: return .common
            case .cape, .visor: return .uncommon
            case .armor, .helmet: return .rare
            case .wings, .chains: return .epic
            case .halo, .crown: return .legendary
            }
        }
    }
    
    enum AuraType: String, CaseIterable {
        case none = "No Aura"
        case green = "Profit Aura"
        case blue = "Wisdom Aura"
        case red = "Power Aura"
        case gold = "Legendary Aura"
        case rainbow = "Mythic Aura"
        case lightning = "Speed Aura"
        case fire = "Aggressive Aura"
        case ice = "Cold Calculation"
        
        var color: Color {
            switch self {
            case .none: return .clear
            case .green: return .green
            case .blue: return .blue
            case .red: return .red
            case .gold: return .gold
            case .rainbow: return .purple
            case .lightning: return .yellow
            case .fire: return .orange
            case .ice: return .cyan
            }
        }
    }
    
    enum PoseType: String, CaseIterable {
        case confident = "Confident Stance"
        case thinking = "Deep Thought"
        case celebrating = "Victory Pose"
        case analyzing = "Data Analysis"
        case meditating = "Zen Focus"
        case charging = "Power Charging"
        case flying = "Market Soaring"
        case commanding = "Leadership"
        
        var description: String {
            switch self {
            case .confident: return "Standing tall with arms crossed"
            case .thinking: return "Hand on chin, contemplating"
            case .celebrating: return "Arms raised in victory"
            case .analyzing: return "Studying charts and data"
            case .meditating: return "Peaceful meditation pose"
            case .charging: return "Energy building up"
            case .flying: return "Soaring through clouds"
            case .commanding: return "Pointing forward decisively"
            }
        }
    }
    
    enum BackgroundType: String, CaseIterable {
        case cityscape = "Financial District"
        case space = "Cosmic Void"
        case matrix = "Digital Matrix"
        case charts = "Trading Charts"
        case mountains = "Success Summit"
        case ocean = "Profit Waves"
        case volcano = "Risk Volcano"
        case temple = "Wisdom Temple"
        
        var gradient: [Color] {
            switch self {
            case .cityscape: return [.blue, .purple, .black]
            case .space: return [.black, .purple, .blue]
            case .matrix: return [.green, .black, .green]
            case .charts: return [.orange, .red, .yellow]
            case .mountains: return [.white, .blue, .gray]
            case .ocean: return [.blue, .cyan, .teal]
            case .volcano: return [.red, .orange, .black]
            case .temple: return [.gold, .yellow, .orange]
            }
        }
    }
    
    struct VisualEffect {
        let name: String
        let description: String
        let rarity: BotRarity
        let animationType: AnimationType
        
        enum AnimationType: String, CaseIterable {
            case pulse = "Pulse"
            case glow = "Glow"
            case sparkle = "Sparkle"
            case float = "Float"
            case rotate = "Rotate"
            case wave = "Wave"
            case lightning = "Lightning"
            case fire = "Fire"
            
            var duration: Double {
                switch self {
                case .pulse: return 1.5
                case .glow: return 2.0
                case .sparkle: return 0.5
                case .float: return 3.0
                case .rotate: return 4.0
                case .wave: return 2.5
                case .lightning: return 0.3
                case .fire: return 1.0
                }
            }
        }
        
        static let legendaryEffects: [VisualEffect] = [
            VisualEffect(name: "Money Rain", description: "Dollar bills falling around bot", rarity: .legendary, animationType: .float),
            VisualEffect(name: "Golden Glow", description: "Intense golden aura", rarity: .legendary, animationType: .glow),
            VisualEffect(name: "Lightning Strike", description: "Electric energy bolts", rarity: .mythic, animationType: .lightning),
            VisualEffect(name: "Profit Explosion", description: "Green energy burst", rarity: .epic, animationType: .pulse),
            VisualEffect(name: "Star Field", description: "Twinkling stars around bot", rarity: .rare, animationType: .sparkle),
            VisualEffect(name: "Data Stream", description: "Flowing code matrix", rarity: .uncommon, animationType: .wave)
        ]
    }
}

// MARK: - Bot Image Generator Service

class BotImageGenerator: ObservableObject {
    @Published var generatedImages: [UUID: String] = [:]
    @Published var isGenerating = false
    
    static let shared = BotImageGenerator()
    
    private init() {}
    
    // Generate visual characteristics based on bot properties
    func generateVisualCharacteristics(for bot: MarketplaceBotModel) -> BotVisualCharacteristics {
        let characteristics = BotVisualCharacteristics(
            primaryColor: getPrimaryColor(for: bot),
            secondaryColor: getSecondaryColor(for: bot),
            accentColor: getAccentColor(for: bot),
            eyeType: getEyeType(for: bot),
            bodyType: getBodyType(for: bot),
            accessory: getAccessory(for: bot),
            aura: getAura(for: bot),
            pose: getPose(for: bot),
            background: getBackground(for: bot),
            rarity: bot.rarity,
            tier: bot.tier,
            specialEffects: getSpecialEffects(for: bot)
        )
        
        return characteristics
    }
    
    // Generate AI image prompt
    func generateImagePrompt(for bot: MarketplaceBotModel) -> String {
        let characteristics = generateVisualCharacteristics(for: bot)
        
        var prompt = """
        Create a professional trading bot avatar in a Pokemon card art style. 
        
        Bot Name: \(bot.name)
        Rarity: \(bot.rarity.rawValue) 
        Tier: \(bot.tier.rawValue)
        
        Visual Elements:
        - Body Type: \(characteristics.bodyType.description)
        - Eyes: \(characteristics.eyeType.rawValue) with \(characteristics.eyeType.emoji)
        - Pose: \(characteristics.pose.description)
        - Background: \(characteristics.background.rawValue)
        - Accessory: \(characteristics.accessory.rawValue)
        - Aura: \(characteristics.aura.rawValue) in \(characteristics.aura.color) tones
        
        Style: High-quality digital art, professional, sleek, modern, trading/financial theme.
        Colors: Primarily \(getPrimaryColorName(characteristics.primaryColor)) with \(getSecondaryColorName(characteristics.secondaryColor)) accents.
        Lighting: Dramatic lighting with \(characteristics.aura.rawValue.lowercased()) glow effects.
        Composition: Portrait orientation, centered, detailed, sharp focus.
        
        Special Requirements:
        - Include subtle trading/financial symbols (charts, graphs, currency symbols)
        - Make it look powerful and intelligent
        - Add \(bot.rarity.sparkleEffect) magical effects for rarity
        - Professional quality suitable for a trading card game
        """
        
        // Add special effects descriptions
        if !characteristics.specialEffects.isEmpty {
            prompt += "\n\nSpecial Effects:"
            for effect in characteristics.specialEffects {
                prompt += "\n- \(effect.name): \(effect.description)"
            }
        }
        
        return prompt
    }
    
    // Generate Pokemon-style stat card prompt
    func generateStatCardPrompt(for bot: MarketplaceBotModel) -> String {
        let characteristics = generateVisualCharacteristics(for: bot)
        
        return """
        Create a Pokemon-style trading card for a trading bot with holographic effects.
        
        Card Layout:
        - Top: Bot name "\(bot.name)" in bold, stylized font
        - Center: Bot avatar (already described above)
        - Bottom: Stat bars and numbers
        - Rarity: \(bot.rarity.rawValue) with \(bot.rarity.sparkleEffect) effects
        - Border: \(characteristics.primaryColor) with \(bot.tier.icon) tier symbols
        
        Stats to Display:
        - Win Rate: \(String(format: "%.0f", bot.stats.winRate))%
        - Total Return: \(bot.stats.formattedTotalReturn)
        - Sharpe Ratio: \(String(format: "%.2f", bot.stats.sharpeRatio))
        - Universe Rank: #\(bot.stats.universeRank)
        - Total Users: \(bot.stats.totalUsers)
        
        Visual Style:
        - Holographic foil effects for \(bot.rarity.rawValue) rarity
        - Trading/financial theme with charts and graphs in background
        - Professional card game aesthetic
        - High contrast, vibrant colors
        - Glossy finish appearance
        - \(bot.rarity.sparkleEffect) sparkle effects around the border
        
        Special Features:
        - QR code in corner linking to bot profile
        - Verification badge: \(bot.verificationStatus.rawValue)
        - Price: \(bot.formattedPrice) in corner
        - Trading style icon: \(bot.tradingStyle.displayName)
        """
    }
    
    // MARK: - Helper Methods
    
    private func getPrimaryColor(for bot: MarketplaceBotModel) -> Color {
        switch bot.rarity {
        case .common: return .gray
        case .uncommon: return .green
        case .rare: return .blue
        case .epic: return .purple
        case .legendary: return .orange
        case .mythic: return .red
        case .godTier: return .gold
        }
    }
    
    private func getSecondaryColor(for bot: MarketplaceBotModel) -> Color {
        switch bot.tier {
        case .rookie: return .green
        case .amateur: return .blue
        case .pro: return .purple
        case .expert: return .orange
        case .master: return .red
        case .grandmaster: return .gold
        case .legend: return .pink
        }
    }
    
    private func getAccentColor(for bot: MarketplaceBotModel) -> Color {
        return bot.tradingStyle.color
    }
    
    private func getEyeType(for bot: MarketplaceBotModel) -> BotVisualCharacteristics.EyeType {
        switch bot.tradingStyle {
        case .scalping: return .laser
        case .dayTrading: return .scanner
        case .swingTrading: return .glowing
        case .longTerm: return .diamond
        case .arbitrage: return .digital
        case .technical: return .hologram
        case .fundamental: return .galaxy
        case .momentum: return .fire
        }
    }
    
    private func getBodyType(for bot: MarketplaceBotModel) -> BotVisualCharacteristics.BodyType {
        switch bot.personality.riskAppetite {
        case .conservative: return .wizard
        case .balanced: return .sleek
        case .aggressive: return .warrior
        case .extreme: return .cyborg
        }
    }
    
    private func getAccessory(for bot: MarketplaceBotModel) -> BotVisualCharacteristics.AccessoryType {
        switch bot.rarity {
        case .common: return .none
        case .uncommon: return .visor
        case .rare: return .helmet
        case .epic: return .wings
        case .legendary: return .crown
        case .mythic: return .halo
        case .godTier: return .crown
        }
    }
    
    private func getAura(for bot: MarketplaceBotModel) -> BotVisualCharacteristics.AuraType {
        if bot.stats.totalReturn > 100 { return .gold }
        else if bot.stats.totalReturn > 50 { return .green }
        else if bot.stats.winRate > 80 { return .blue }
        else if bot.personality.riskAppetite == .extreme { return .fire }
        else if bot.personality.riskAppetite == .conservative { return .ice }
        else { return .lightning }
    }
    
    private func getPose(for bot: MarketplaceBotModel) -> BotVisualCharacteristics.PoseType {
        if bot.stats.currentStreak > 10 { return .celebrating }
        else if bot.stats.universeRank <= 10 { return .commanding }
        else if bot.personality.communicationStyle == .technical { return .analyzing }
        else if bot.stats.sharpeRatio > 2.0 { return .confident }
        else { return .thinking }
    }
    
    private func getBackground(for bot: MarketplaceBotModel) -> BotVisualCharacteristics.BackgroundType {
        switch bot.tradingStyle {
        case .scalping: return .cityscape
        case .dayTrading: return .charts
        case .swingTrading: return .mountains
        case .longTerm: return .temple
        case .arbitrage: return .matrix
        case .technical: return .space
        case .fundamental: return .ocean
        case .momentum: return .volcano
        }
    }
    
    private func getSpecialEffects(for bot: MarketplaceBotModel) -> [BotVisualCharacteristics.VisualEffect] {
        var effects: [BotVisualCharacteristics.VisualEffect] = []
        
        // Add effects based on rarity
        switch bot.rarity {
        case .legendary, .mythic, .godTier:
            effects.append(contentsOf: BotVisualCharacteristics.VisualEffect.legendaryEffects.filter { $0.rarity == bot.rarity })
        case .epic:
            effects.append(BotVisualCharacteristics.VisualEffect.legendaryEffects.first { $0.name == "Profit Explosion" }!)
        case .rare:
            effects.append(BotVisualCharacteristics.VisualEffect.legendaryEffects.first { $0.name == "Star Field" }!)
        default:
            break
        }
        
        // Add performance-based effects
        if bot.stats.totalReturn > 100 {
            effects.append(BotVisualCharacteristics.VisualEffect.legendaryEffects.first { $0.name == "Money Rain" }!)
        }
        
        return effects.prefix(3).map { $0 }
    }
    
    private func getPrimaryColorName(_ color: Color) -> String {
        if color == .gray { return "silver" }
        else if color == .green { return "emerald green" }
        else if color == .blue { return "sapphire blue" }
        else if color == .purple { return "royal purple" }
        else if color == .orange { return "golden orange" }
        else if color == .red { return "crimson red" }
        else if color == .gold { return "radiant gold" }
        else { return "neutral" }
    }
    
    private func getSecondaryColorName(_ color: Color) -> String {
        if color == .green { return "mint green" }
        else if color == .blue { return "electric blue" }
        else if color == .purple { return "deep purple" }
        else if color == .orange { return "bright orange" }
        else if color == .red { return "ruby red" }
        else if color == .gold { return "bright gold" }
        else if color == .pink { return "hot pink" }
        else { return "white" }
    }
}

// MARK: - Bot Avatar View Component

struct BotAvatarView: View {
    let bot: MarketplaceBotModel
    let size: CGFloat
    let showEffects: Bool
    
    @StateObject private var imageGenerator = BotImageGenerator.shared
    @State private var animateEffects = false
    
    init(bot: MarketplaceBotModel, size: CGFloat = 100, showEffects: Bool = true) {
        self.bot = bot
        self.size = size
        self.showEffects = showEffects
    }
    
    var body: some View {
        ZStack {
            // Background aura
            if showEffects {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                bot.rarity.color.opacity(0.3),
                                bot.rarity.color.opacity(0.1),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: size * 0.3,
                            endRadius: size * 0.6
                        )
                    )
                    .frame(width: size * 1.2, height: size * 1.2)
                    .scaleEffect(animateEffects ? 1.1 : 1.0)
                    .opacity(animateEffects ? 0.8 : 0.6)
                    .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: animateEffects)
            }
            
            // Main avatar circle
            Circle()
                .fill(
                    LinearGradient(
                        colors: [
                            bot.rarity.color.opacity(0.8),
                            bot.rarity.color.opacity(0.4),
                            bot.tier.color.opacity(0.6)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: size, height: size)
                .overlay(
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [.white.opacity(0.4), .clear],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2
                        )
                )
            
            // Bot tier icon
            Text(bot.tier.icon)
                .font(.system(size: size * 0.4))
                .scaleEffect(animateEffects ? 1.1 : 1.0)
                .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: animateEffects)
            
            // Rarity sparkles
            if showEffects && !bot.rarity.sparkleEffect.isEmpty {
                VStack {
                    HStack {
                        Text(bot.rarity.sparkleEffect)
                            .font(.system(size: size * 0.15))
                            .offset(x: -size * 0.4, y: -size * 0.3)
                        
                        Spacer()
                        
                        Text(bot.rarity.sparkleEffect)
                            .font(.system(size: size * 0.12))
                            .offset(x: size * 0.4, y: -size * 0.4)
                    }
                    
                    Spacer()
                    
                    HStack {
                        Text(bot.rarity.sparkleEffect)
                            .font(.system(size: size * 0.13))
                            .offset(x: -size * 0.3, y: size * 0.3)
                        
                        Spacer()
                        
                        Text(bot.rarity.sparkleEffect)
                            .font(.system(size: size * 0.14))
                            .offset(x: size * 0.35, y: size * 0.25)
                    }
                }
                .frame(width: size, height: size)
                .rotationEffect(.degrees(animateEffects ? 360 : 0))
                .animation(.linear(duration: 20).repeatForever(autoreverses: false), value: animateEffects)
            }
            
            // Performance indicator
            if showEffects {
                VStack {
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        Text(bot.stats.performanceGrade)
                            .font(.system(size: size * 0.12, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, size * 0.08)
                            .padding(.vertical, size * 0.04)
                            .background(bot.stats.totalReturn >= 0 ? Color.green : Color.red)
                            .cornerRadius(size * 0.06)
                            .offset(x: size * 0.15, y: -size * 0.15)
                    }
                }
                .frame(width: size, height: size)
            }
        }
        .onAppear {
            if showEffects {
                animateEffects = true
            }
        }
    }
}