//
//  TrendIQEngine.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 7/13/25.
//

import Foundation
import Combine
import SwiftUI

@MainActor
class TrendIQEngine: ObservableObject {
    @Published var trendScore: Double = 0.0
    @Published var trendDirection: TrendDirection = .neutral
    @Published var trendStrength: TrendStrength = .moderate
    @Published var trendPhase: TrendPhase = .developing
    @Published var trendQuality: TrendQuality = .clean
    @Published var shouldTrade: Bool = true
    @Published var confidenceLevel: Double = 0.0
    @Published var smartMoneyFlow: SmartMoneyFlow = .neutral
    @Published var structureAnalysis: StructureAnalysis = StructureAnalysis()
    @Published var multiTimeframeAnalysis: MultiTimeframeAnalysis = MultiTimeframeAnalysis()
    @Published var volumeProfile: VolumeProfile = VolumeProfile()
    @Published var marketStructure: MarketStructure = MarketStructure()
    @Published var isAnalyzing: Bool = false
    @Published var lastAnalysisTime: Date = Date()
    @Published var tradingRecommendation: String = ""
    @Published var riskAssessment: String = ""
    
    private var cancellables = Set<AnyCancellable>()
    private let trendAnalyzer = TrendAnalyzer()
    private let smartMoneyAnalyzer = SmartMoneyAnalyzer()
    private let structureAnalyzer = StructureAnalyzer()
    
    enum TrendDirection: String, CaseIterable {
        case bullish = "Bullish"
        case bearish = "Bearish"
        case neutral = "Neutral"
        case choppy = "Choppy"
        
        var color: Color {
            switch self {
            case .bullish: return .green
            case .bearish: return .red
            case .neutral: return .blue
            case .choppy: return .orange
            }
        }
        
        var icon: String {
            switch self {
            case .bullish: return "arrow.up.right.circle.fill"
            case .bearish: return "arrow.down.right.circle.fill"
            case .neutral: return "minus.circle.fill"
            case .choppy: return "waveform.path.ecg"
            }
        }
    }
    
    enum TrendStrength: String, CaseIterable {
        case veryStrong = "Very Strong"
        case strong = "Strong"
        case moderate = "Moderate"
        case weak = "Weak"
        case veryWeak = "Very Weak"
        
        var color: Color {
            switch self {
            case .veryStrong: return .green
            case .strong: return .mint
            case .moderate: return .blue
            case .weak: return .yellow
            case .veryWeak: return .red
            }
        }
        
        var scoreRange: ClosedRange<Double> {
            switch self {
            case .veryStrong: return 80...100
            case .strong: return 60...79
            case .moderate: return 40...59
            case .weak: return 20...39
            case .veryWeak: return 0...19
            }
        }
    }
    
    enum TrendPhase: String, CaseIterable {
        case accumulation = "Accumulation"
        case developing = "Developing"
        case mature = "Mature"
        case distribution = "Distribution"
        case reversal = "Reversal"
        
        var color: Color {
            switch self {
            case .accumulation: return .blue
            case .developing: return .green
            case .mature: return .orange
            case .distribution: return .yellow
            case .reversal: return .red
            }
        }
        
        var description: String {
            switch self {
            case .accumulation: return "Smart money accumulating positions"
            case .developing: return "Trend gaining momentum"
            case .mature: return "Trend well established"
            case .distribution: return "Smart money distributing positions"
            case .reversal: return "Potential trend reversal"
            }
        }
    }
    
    enum TrendQuality: String, CaseIterable {
        case clean = "Clean"
        case noisy = "Noisy"
        case choppy = "Choppy"
        case sideways = "Sideways"
        
        var color: Color {
            switch self {
            case .clean: return .green
            case .noisy: return .yellow
            case .choppy: return .orange
            case .sideways: return .red
            }
        }
        
        var tradingAdvice: String {
            switch self {
            case .clean: return "Excellent for trend following"
            case .noisy: return "Use wider stops"
            case .choppy: return "Reduce position size"
            case .sideways: return "Avoid trend trades"
            }
        }
    }
    
    enum SmartMoneyFlow: String, CaseIterable {
        case strongBuying = "Strong Buying"
        case buying = "Buying"
        case neutral = "Neutral"
        case selling = "Selling"
        case strongSelling = "Strong Selling"
        
        var color: Color {
            switch self {
            case .strongBuying: return .green
            case .buying: return .mint
            case .neutral: return .blue
            case .selling: return .orange
            case .strongSelling: return .red
            }
        }
        
        var icon: String {
            switch self {
            case .strongBuying: return "arrow.up.circle.fill"
            case .buying: return "arrow.up.circle"
            case .neutral: return "minus.circle"
            case .selling: return "arrow.down.circle"
            case .strongSelling: return "arrow.down.circle.fill"
            }
        }
    }
    
    struct StructureAnalysis {
        var higherHighs: Bool = false
        var higherLows: Bool = false
        var lowerHighs: Bool = false
        var lowerLows: Bool = false
        var keyLevels: [Double] = []
        var supportResistance: [SupportResistanceLevel] = []
        var structureBreaks: [StructureBreak] = []
        var orderBlocks: [OrderBlock] = []
        var fairValueGaps: [FairValueGap] = []
        var liquidityPools: [LiquidityPool] = []
        
        struct SupportResistanceLevel {
            let price: Double
            let strength: Double
            let type: LevelType
            let touches: Int
            let lastTest: Date
            
            enum LevelType {
                case support
                case resistance
                case pivot
            }
        }
        
        struct StructureBreak {
            let price: Double
            let direction: TrendDirection
            let strength: Double
            let volume: Double
            let timestamp: Date
        }
        
        struct OrderBlock {
            let highPrice: Double
            let lowPrice: Double
            let type: OrderBlockType
            let strength: Double
            let timeframe: String
            
            enum OrderBlockType {
                case bullish
                case bearish
            }
        }
        
        struct FairValueGap {
            let highPrice: Double
            let lowPrice: Double
            let direction: TrendDirection
            let strength: Double
            let filled: Bool
        }
        
        struct LiquidityPool {
            let price: Double
            let volume: Double
            let type: LiquidityType
            let strength: Double
            
            enum LiquidityType {
                case buyLiquidity
                case sellLiquidity
                case equalLows
                case equalHighs
            }
        }
    }
    
    struct MultiTimeframeAnalysis {
        var monthly: TimeframeAnalysis = TimeframeAnalysis()
        var weekly: TimeframeAnalysis = TimeframeAnalysis()
        var daily: TimeframeAnalysis = TimeframeAnalysis()
        var h4: TimeframeAnalysis = TimeframeAnalysis()
        var h1: TimeframeAnalysis = TimeframeAnalysis()
        var m15: TimeframeAnalysis = TimeframeAnalysis()
        var m5: TimeframeAnalysis = TimeframeAnalysis()
        var m1: TimeframeAnalysis = TimeframeAnalysis()
        var overallAlignment: Double = 0.0
        var conflictingTimeframes: [String] = []
        
        struct TimeframeAnalysis {
            var trend: TrendDirection = .neutral
            var strength: Double = 0.0
            var ema8: Double = 0.0
            var ema21: Double = 0.0
            var ema50: Double = 0.0
            var ema200: Double = 0.0
            var volume: Double = 0.0
            var volatility: Double = 0.0
            var momentum: Double = 0.0
        }
    }
    
    struct VolumeProfile {
        var totalVolume: Double = 0.0
        var buyVolume: Double = 0.0
        var sellVolume: Double = 0.0
        var volumeRatio: Double = 0.0
        var volumeTrend: VolumeProfileTrend = .neutral
        var volumeSpikes: [VolumeSpike] = []
        var volumeByPrice: [VolumeByPrice] = []
        var valueAreaHigh: Double = 0.0
        var valueAreaLow: Double = 0.0
        var pointOfControl: Double = 0.0
        
        enum VolumeProfileTrend {
            case increasing
            case decreasing
            case neutral
        }
        
        struct VolumeSpike {
            let price: Double
            let volume: Double
            let timestamp: Date
            let type: SpikeType
            
            enum SpikeType {
                case buying
                case selling
                case absorption
            }
        }
        
        struct VolumeByPrice {
            let price: Double
            let volume: Double
            let buyVolume: Double
            let sellVolume: Double
        }
    }
    
    struct MarketStructure {
        var primaryTrend: TrendDirection = .neutral
        var intermediaryTrend: TrendDirection = .neutral
        var minorTrend: TrendDirection = .neutral
        var structureScore: Double = 0.0
        var trendAlignment: Double = 0.0
        var momentumDivergence: Bool = false
        var volumeDivergence: Bool = false
        var structuralSupport: Double = 0.0
        var structuralResistance: Double = 0.0
        var nextKeyLevel: Double = 0.0
        var trendMaturity: TrendMaturity = .young
        
        enum TrendMaturity {
            case young
            case developing
            case mature
            case aging
            case exhausted
        }
    }
    
    init() {
        startRealTimeAnalysis()
        performInitialAnalysis()
    }
    
    private func startRealTimeAnalysis() {
        Timer.publish(every: 5.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                Task {
                    await self?.performTrendAnalysis()
                }
            }
            .store(in: &cancellables)
    }
    
    private func performInitialAnalysis() {
        Task {
            await performTrendAnalysis()
        }
    }
    
    // MARK: - Core Analysis Functions
    
    func performTrendAnalysis() async {
        isAnalyzing = true
        
        // Analyze market structure
        let structureResult = await structureAnalyzer.analyzeStructure()
        
        // Analyze multiple timeframes
        let mtfResult = await trendAnalyzer.analyzeMultipleTimeframes()
        
        // Analyze smart money flow
        let smartMoneyResult = await smartMoneyAnalyzer.analyzeSmartMoney()
        
        // Analyze volume profile
        let volumeResult = await analyzeVolumeProfile()
        
        // Calculate trend score
        let calculatedTrendScore = calculateTrendScore(
            structure: structureResult,
            mtf: mtfResult,
            smartMoney: smartMoneyResult,
            volume: volumeResult
        )
        
        // Determine trend characteristics
        let direction = determineTrendDirection(mtf: mtfResult)
        let strength = determineTrendStrength(score: calculatedTrendScore)
        let phase = determineTrendPhase(structure: structureResult, smartMoney: smartMoneyResult)
        let quality = determineTrendQuality(structure: structureResult, volume: volumeResult)
        
        // Generate trading recommendation
        let recommendation = generateTradingRecommendation(
            score: calculatedTrendScore,
            direction: direction,
            strength: strength,
            quality: quality
        )
        
        // Update published properties
        await MainActor.run {
            self.trendScore = calculatedTrendScore
            self.trendDirection = direction
            self.trendStrength = strength
            self.trendPhase = phase
            self.trendQuality = quality
            self.shouldTrade = calculatedTrendScore > 40 && quality != .sideways
            self.confidenceLevel = calculatedTrendScore / 100.0
            self.smartMoneyFlow = smartMoneyResult.flow
            self.structureAnalysis = structureResult
            self.multiTimeframeAnalysis = mtfResult
            self.volumeProfile = volumeResult
            self.marketStructure = calculateMarketStructure(
                structure: structureResult,
                mtf: mtfResult
            )
            self.tradingRecommendation = recommendation
            self.riskAssessment = generateRiskAssessment(quality: quality, strength: strength)
            self.isAnalyzing = false
            self.lastAnalysisTime = Date()
        }
    }
    
    private func calculateTrendScore(
        structure: StructureAnalysis,
        mtf: MultiTimeframeAnalysis,
        smartMoney: SmartMoneyResult,
        volume: VolumeProfile
    ) -> Double {
        var score: Double = 0.0
        
        // Structure score (30%)
        let structureScore = calculateStructureScore(structure: structure)
        score += structureScore * 0.30
        
        // Multi-timeframe alignment (40%)
        let mtfScore = mtf.overallAlignment * 100
        score += mtfScore * 0.40
        
        // Smart money flow (20%)
        let smartMoneyScore = calculateSmartMoneyScore(smartMoney: smartMoney)
        score += smartMoneyScore * 0.20
        
        // Volume confirmation (10%)
        let volumeScore = calculateVolumeScore(volume: volume)
        score += volumeScore * 0.10
        
        return min(100.0, max(0.0, score))
    }
    
    private func calculateStructureScore(structure: StructureAnalysis) -> Double {
        var score: Double = 0.0
        
        // Higher highs and higher lows (bullish structure)
        if structure.higherHighs && structure.higherLows {
            score += 80.0
        } else if structure.lowerHighs && structure.lowerLows {
            score += 80.0
        } else if structure.higherHighs || structure.higherLows || structure.lowerHighs || structure.lowerLows {
            score += 40.0
        }
        
        // Structure breaks
        score += Double(structure.structureBreaks.count) * 10.0
        
        // Order blocks
        score += Double(structure.orderBlocks.count) * 5.0
        
        // Fair value gaps
        score += Double(structure.fairValueGaps.count) * 3.0
        
        return min(100.0, score)
    }
    
    private func calculateSmartMoneyScore(smartMoney: SmartMoneyResult) -> Double {
        switch smartMoney.flow {
        case .strongBuying, .strongSelling: return 90.0
        case .buying, .selling: return 70.0
        case .neutral: return 50.0
        }
    }
    
    private func calculateVolumeScore(volume: VolumeProfile) -> Double {
        let ratio = volume.volumeRatio
        if ratio > 1.5 || ratio < 0.67 {
            return 80.0
        } else if ratio > 1.2 || ratio < 0.83 {
            return 60.0
        } else {
            return 40.0
        }
    }
    
    private func determineTrendDirection(mtf: MultiTimeframeAnalysis) -> TrendDirection {
        let bullishCount = [mtf.monthly.trend, mtf.weekly.trend, mtf.daily.trend, mtf.h4.trend, mtf.h1.trend]
            .filter { $0 == .bullish }.count
        
        let bearishCount = [mtf.monthly.trend, mtf.weekly.trend, mtf.daily.trend, mtf.h4.trend, mtf.h1.trend]
            .filter { $0 == .bearish }.count
        
        if bullishCount >= 3 {
            return .bullish
        } else if bearishCount >= 3 {
            return .bearish
        } else if mtf.conflictingTimeframes.count > 2 {
            return .choppy
        } else {
            return .neutral
        }
    }
    
    private func determineTrendStrength(score: Double) -> TrendStrength {
        switch score {
        case 80...100: return .veryStrong
        case 60...79: return .strong
        case 40...59: return .moderate
        case 20...39: return .weak
        default: return .veryWeak
        }
    }
    
    private func determineTrendPhase(structure: StructureAnalysis, smartMoney: SmartMoneyResult) -> TrendPhase {
        if smartMoney.accumulation {
            return .accumulation
        } else if smartMoney.distribution {
            return .distribution
        } else if structure.structureBreaks.count > 2 {
            return .reversal
        } else if trendScore > 70 {
            return .mature
        } else {
            return .developing
        }
    }
    
    private func determineTrendQuality(structure: StructureAnalysis, volume: VolumeProfile) -> TrendQuality {
        let structureBreaks = structure.structureBreaks.count
        let volumeSpikes = volume.volumeSpikes.count
        
        if structureBreaks < 2 && volumeSpikes < 3 {
            return .clean
        } else if structureBreaks < 4 && volumeSpikes < 6 {
            return .noisy
        } else if structureBreaks >= 4 {
            return .choppy
        } else {
            return .sideways
        }
    }
    
    private func generateTradingRecommendation(
        score: Double,
        direction: TrendDirection,
        strength: TrendStrength,
        quality: TrendQuality
    ) -> String {
        switch (score, direction, strength, quality) {
        case (80...100, .bullish, .veryStrong, .clean):
            return "🟢 STRONG BUY - Excellent trend conditions. Full position recommended."
        case (80...100, .bearish, .veryStrong, .clean):
            return "🔴 STRONG SELL - Excellent trend conditions. Full position recommended."
        case (60...79, .bullish, .strong, .clean), (60...79, .bullish, .strong, .noisy):
            return "🟡 BUY - Good trend conditions. Standard position size."
        case (60...79, .bearish, .strong, .clean), (60...79, .bearish, .strong, .noisy):
            return "🟡 SELL - Good trend conditions. Standard position size."
        case (40...59, _, .moderate, .clean):
            return "🟠 CAUTION - Moderate trend. Reduce position size."
        case (_, .choppy, _, _):
            return "❌ NO TRADE - Choppy market conditions. Wait for clarity."
        case (_, _, _, .sideways):
            return "❌ NO TRADE - Sideways market. Avoid trend trades."
        case (0...39, _, _, _):
            return "❌ NO TRADE - Weak trend conditions. Wait for better setup."
        default:
            return "⏳ ANALYZING - Trend analysis in progress."
        }
    }
    
    private func generateRiskAssessment(quality: TrendQuality, strength: TrendStrength) -> String {
        switch (quality, strength) {
        case (.clean, .veryStrong), (.clean, .strong):
            return "🟢 LOW RISK - Clean trend with strong momentum"
        case (.noisy, .strong), (.clean, .moderate):
            return "🟡 MODERATE RISK - Some noise but manageable"
        case (.choppy, _), (.sideways, _):
            return "🔴 HIGH RISK - Challenging market conditions"
        case (.noisy, .weak), (.noisy, .veryWeak):
            return "🔴 HIGH RISK - Weak trend with significant noise"
        default:
            return "🟠 MEDIUM RISK - Standard risk management required"
        }
    }
    
    private func analyzeVolumeProfile() async -> VolumeProfile {
        var profile = VolumeProfile()
        
        // Simulate volume analysis
        profile.totalVolume = Double.random(in: 50000...200000)
        profile.buyVolume = profile.totalVolume * Double.random(in: 0.45...0.65)
        profile.sellVolume = profile.totalVolume - profile.buyVolume
        profile.volumeRatio = profile.buyVolume / profile.sellVolume
        
        if profile.volumeRatio > 1.2 {
            profile.volumeTrend = .increasing
        } else if profile.volumeRatio < 0.8 {
            profile.volumeTrend = .decreasing
        } else {
            profile.volumeTrend = .neutral
        }
        
        return profile
    }
    
    private func calculateMarketStructure(
        structure: StructureAnalysis,
        mtf: MultiTimeframeAnalysis
    ) -> MarketStructure {
        var marketStructure = MarketStructure()
        
        marketStructure.primaryTrend = mtf.weekly.trend
        marketStructure.intermediaryTrend = mtf.daily.trend
        marketStructure.minorTrend = mtf.h1.trend
        marketStructure.structureScore = trendScore
        marketStructure.trendAlignment = mtf.overallAlignment
        
        // Determine trend maturity
        if trendScore > 85 {
            marketStructure.trendMaturity = .mature
        } else if trendScore > 70 {
            marketStructure.trendMaturity = .developing
        } else if trendScore > 50 {
            marketStructure.trendMaturity = .young
        } else if trendScore > 30 {
            marketStructure.trendMaturity = .aging
        } else {
            marketStructure.trendMaturity = .exhausted
        }
        
        return marketStructure
    }
    
    // MARK: - Public Interface
    
    func getTrendSummary() -> TrendSummary {
        return TrendSummary(
            score: trendScore,
            direction: trendDirection,
            strength: trendStrength,
            phase: trendPhase,
            quality: trendQuality,
            shouldTrade: shouldTrade,
            confidence: confidenceLevel,
            recommendation: tradingRecommendation,
            riskAssessment: riskAssessment,
            lastUpdate: lastAnalysisTime
        )
    }
    
    func refreshAnalysis() async {
        await performTrendAnalysis()
    }
    
    func getDetailedAnalysis() -> DetailedTrendAnalysis {
        return DetailedTrendAnalysis(
            trendScore: trendScore,
            structureAnalysis: structureAnalysis,
            multiTimeframeAnalysis: multiTimeframeAnalysis,
            volumeProfile: volumeProfile,
            marketStructure: marketStructure,
            smartMoneyFlow: smartMoneyFlow,
            processingTime: Date().timeIntervalSince(lastAnalysisTime)
        )
    }
}

// MARK: - Supporting Types

struct TrendSummary {
    let score: Double
    let direction: TrendIQEngine.TrendDirection
    let strength: TrendIQEngine.TrendStrength
    let phase: TrendIQEngine.TrendPhase
    let quality: TrendIQEngine.TrendQuality
    let shouldTrade: Bool
    let confidence: Double
    let recommendation: String
    let riskAssessment: String
    let lastUpdate: Date
}

struct DetailedTrendAnalysis {
    let trendScore: Double
    let structureAnalysis: TrendIQEngine.StructureAnalysis
    let multiTimeframeAnalysis: TrendIQEngine.MultiTimeframeAnalysis
    let volumeProfile: TrendIQEngine.VolumeProfile
    let marketStructure: TrendIQEngine.MarketStructure
    let smartMoneyFlow: TrendIQEngine.SmartMoneyFlow
    let processingTime: TimeInterval
}

struct SmartMoneyResult {
    let flow: TrendIQEngine.SmartMoneyFlow
    let accumulation: Bool
    let distribution: Bool
    let institutionalActivity: Double
}

class TrendAnalyzer {
    func analyzeMultipleTimeframes() async -> TrendIQEngine.MultiTimeframeAnalysis {
        var analysis = TrendIQEngine.MultiTimeframeAnalysis()
        
        // Simulate multi-timeframe analysis
        let timeframes = [
            ("monthly", \TrendIQEngine.MultiTimeframeAnalysis.monthly),
            ("weekly", \TrendIQEngine.MultiTimeframeAnalysis.weekly),
            ("daily", \TrendIQEngine.MultiTimeframeAnalysis.daily),
            ("h4", \TrendIQEngine.MultiTimeframeAnalysis.h4),
            ("h1", \TrendIQEngine.MultiTimeframeAnalysis.h1),
            ("m15", \TrendIQEngine.MultiTimeframeAnalysis.m15),
            ("m5", \TrendIQEngine.MultiTimeframeAnalysis.m5),
            ("m1", \TrendIQEngine.MultiTimeframeAnalysis.m1)
        ]
        
        var bullishCount = 0
        var bearishCount = 0
        
        for (_, keyPath) in timeframes {
            let trend = TrendIQEngine.TrendDirection.allCases.randomElement() ?? .neutral
            let strength = Double.random(in: 0...100)
            
            analysis[keyPath: keyPath].trend = trend
            analysis[keyPath: keyPath].strength = strength
            analysis[keyPath: keyPath].ema8 = Double.random(in: 1900...2100)
            analysis[keyPath: keyPath].ema21 = Double.random(in: 1900...2100)
            analysis[keyPath: keyPath].ema50 = Double.random(in: 1900...2100)
            analysis[keyPath: keyPath].ema200 = Double.random(in: 1900...2100)
            analysis[keyPath: keyPath].volume = Double.random(in: 10000...100000)
            analysis[keyPath: keyPath].volatility = Double.random(in: 0.1...0.5)
            analysis[keyPath: keyPath].momentum = Double.random(in: -1...1)
            
            if trend == .bullish { bullishCount += 1 }
            if trend == .bearish { bearishCount += 1 }
        }
        
        analysis.overallAlignment = Double(max(bullishCount, bearishCount)) / Double(timeframes.count)
        
        return analysis
    }
}

class SmartMoneyAnalyzer {
    func analyzeSmartMoney() async -> SmartMoneyResult {
        let flows = TrendIQEngine.SmartMoneyFlow.allCases
        let randomFlow = flows.randomElement() ?? .neutral
        
        return SmartMoneyResult(
            flow: randomFlow,
            accumulation: Bool.random(),
            distribution: Bool.random(),
            institutionalActivity: Double.random(in: 0...1)
        )
    }
}

class StructureAnalyzer {
    func analyzeStructure() async -> TrendIQEngine.StructureAnalysis {
        var analysis = TrendIQEngine.StructureAnalysis()
        
        analysis.higherHighs = Bool.random()
        analysis.higherLows = Bool.random()
        analysis.lowerHighs = Bool.random()
        analysis.lowerLows = Bool.random()
        
        // Generate random structure breaks
        for _ in 0..<Int.random(in: 0...5) {
            let structureBreak = TrendIQEngine.StructureAnalysis.StructureBreak(
                price: Double.random(in: 1900...2100),
                direction: TrendIQEngine.TrendDirection.allCases.randomElement() ?? .neutral,
                strength: Double.random(in: 0...1),
                volume: Double.random(in: 10000...100000),
                timestamp: Date()
            )
            analysis.structureBreaks.append(structureBreak)
        }
        
        // Generate random order blocks
        for _ in 0..<Int.random(in: 0...3) {
            let orderBlock = TrendIQEngine.StructureAnalysis.OrderBlock(
                highPrice: Double.random(in: 1950...2050),
                lowPrice: Double.random(in: 1900...2000),
                type: Bool.random() ? .bullish : .bearish,
                strength: Double.random(in: 0...1),
                timeframe: ["M15", "H1", "H4", "D1"].randomElement() ?? "H1"
            )
            analysis.orderBlocks.append(orderBlock)
        }
        
        return analysis
    }
}