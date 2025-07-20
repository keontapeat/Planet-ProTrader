//
//  QuantumRiskEngine.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 7/13/25.
//

import Foundation
import Combine
import SwiftUI

@MainActor
class QuantumRiskEngine: ObservableObject {
    @Published var riskScore: Double = 0.0
    @Published var maxDrawdown: Double = 0.0
    @Published var currentDrawdown: Double = 0.0
    @Published var riskLevel: RiskLevel = .medium
    @Published var emergencyShutdown: Bool = false
    @Published var positionSize: Double = 0.0
    @Published var dailyLossLimit: Double = 0.0
    @Published var psychologicalRiskTolerance: Double = 0.0
    @Published var marketRegime: MarketRegime = .neutral
    @Published var neverBlowMode: Bool = true
    @Published var compoundingFactor: Double = 1.0
    @Published var recoveryMode: Bool = false
    @Published var hedgeFundMetrics: HedgeFundMetrics = HedgeFundMetrics()
    
    private var cancellables = Set<AnyCancellable>()
    private let riskCalculator = RiskCalculator()
    
    struct QuantumTradingSignal {
        let entryPrice: Double
        let stopLoss: Double
        let takeProfit: Double
        let confidence: Double
        let timestamp: Date
        let reasoning: String
        
        init(entryPrice: Double, stopLoss: Double, takeProfit: Double, confidence: Double, reasoning: String = "") {
            self.entryPrice = entryPrice
            self.stopLoss = stopLoss
            self.takeProfit = takeProfit
            self.confidence = confidence
            self.timestamp = Date()
            self.reasoning = reasoning
        }
    }
    
    enum MarketRegime: String, CaseIterable {
        case riskOn = "Risk-On"
        case riskOff = "Risk-Off"
        case neutral = "Neutral"
        case crisis = "Crisis"
        case recovery = "Recovery"
        
        var multiplier: Double {
            switch self {
            case .riskOn: return 1.2
            case .riskOff: return 0.5
            case .neutral: return 1.0
            case .crisis: return 0.2
            case .recovery: return 0.8
            }
        }
    }
    
    enum RiskLevel: Double, CaseIterable {
        case veryLow = 0.05
        case low = 0.1
        case medium = 0.2
        case high = 0.3
        
        var weight: Double {
            switch self {
            case .veryLow:
                return 0.05
            case .low:
                return 0.1
            case .medium:
                return 0.2
            case .high:
                return 0.3
            }
        }
    }
    
    struct HedgeFundMetrics {
        var sharpeRatio: Double = 0.0
        var sortinoRatio: Double = 0.0
        var maxDrawdownRecovery: Double = 0.0
        var winRate: Double = 0.0
        var profitFactor: Double = 0.0
        var riskAdjustedReturn: Double = 0.0
        var volatilityIndex: Double = 0.0
        var kellyCriterion: Double = 0.0
    }
    
    init() {
        setupRiskMonitoring()
        calculateInitialRisk()
    }
    
    private func setupRiskMonitoring() {
        // Monitor drawdown changes
        $currentDrawdown
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .sink { [weak self] drawdown in
                self?.evaluateEmergencyShutdown(drawdown: drawdown)
                self?.adjustRiskLevel(drawdown: drawdown)
            }
            .store(in: &cancellables)
        
        // Monitor market regime changes
        $marketRegime
            .sink { [weak self] regime in
                self?.adjustForMarketRegime(regime)
            }
            .store(in: &cancellables)
    }
    
    private func calculateInitialRisk() {
        riskScore = riskCalculator.calculateRiskScore(
            drawdown: currentDrawdown,
            volatility: 0.2,
            marketRegime: marketRegime
        )
        
        dailyLossLimit = riskLevel.weight * 0.5 // 50% of max risk per day
        psychologicalRiskTolerance = calculatePsychologicalRisk()
    }
    
    // MARK: - Core Risk Management Functions
    
    func calculateOptimalPositionSize(
        accountBalance: Double,
        stopLoss: Double,
        entryPrice: Double,
        confidence: Double = 0.8
    ) -> Double {
        let riskAmount = accountBalance * riskLevel.weight
        let riskPerShare = abs(entryPrice - stopLoss)
        let basePositionSize = riskAmount / riskPerShare
        
        // Apply hedge fund adjustments
        let confidenceMultiplier = confidence
        let regimeMultiplier = marketRegime.multiplier
        let drawdownAdjustment = recoveryMode ? 0.5 : 1.0
        let psychologicalAdjustment = psychologicalRiskTolerance
        
        positionSize = basePositionSize * confidenceMultiplier * regimeMultiplier * drawdownAdjustment * psychologicalAdjustment
        
        // Never Blow Mode
        if neverBlowMode {
            positionSize = min(positionSize, accountBalance * 0.005) // Max 0.5% of account
        }
        
        return positionSize
    }
    
    func evaluateTradeRisk(
        signal: QuantumTradingSignal,
        accountBalance: Double,
        openPositions: [TradePosition]
    ) -> TradeRiskAssessment {
        
        let correlationRisk = calculateCorrelationRisk(openPositions: openPositions)
        let concentrationRisk = calculateConcentrationRisk(openPositions: openPositions)
        let volatilityRisk = calculateVolatilityRisk(signal: signal)
        
        let totalRisk = (correlationRisk + concentrationRisk + volatilityRisk) / 3.0
        
        return TradeRiskAssessment(
            totalRisk: totalRisk,
            correlationRisk: correlationRisk,
            concentrationRisk: concentrationRisk,
            volatilityRisk: volatilityRisk,
            recommendation: getRiskRecommendation(totalRisk: totalRisk),
            positionSize: calculateOptimalPositionSize(
                accountBalance: accountBalance,
                stopLoss: signal.stopLoss,
                entryPrice: signal.entryPrice,
                confidence: signal.confidence
            )
        )
    }
    
    func updateDrawdown(currentBalance: Double, peakBalance: Double) {
        let drawdown = (peakBalance - currentBalance) / peakBalance
        currentDrawdown = max(0, drawdown)
        maxDrawdown = max(maxDrawdown, currentDrawdown)
        
        // Trigger recovery mode if significant drawdown
        if currentDrawdown > 0.10 { // 10% drawdown
            recoveryMode = true
        } else if currentDrawdown < 0.05 { // 5% drawdown
            recoveryMode = false
        }
        
        updateHedgeFundMetrics()
    }
    
    private func evaluateEmergencyShutdown(drawdown: Double) {
        // Emergency shutdown triggers
        let maxAllowedDrawdown = riskLevel == .veryLow ? 0.15 : 0.25
        let dailyLossExceeded = drawdown > dailyLossLimit
        let psychologicalBreakpoint = drawdown > psychologicalRiskTolerance * 2
        
        emergencyShutdown = drawdown > maxAllowedDrawdown || dailyLossExceeded || psychologicalBreakpoint
        
        if emergencyShutdown {
            NotificationCenter.default.post(name: .emergencyShutdownTriggered, object: nil)
        }
    }
    
    private func adjustRiskLevel(drawdown: Double) {
        if drawdown > 0.20 && riskLevel != .veryLow {
            riskLevel = .low
        } else if drawdown > 0.15 && riskLevel == .high {
            riskLevel = .medium
        } else if drawdown < 0.05 && recoveryMode == false {
            // Gradually increase risk after recovery
            if riskLevel == .low {
                riskLevel = .medium
            }
        }
    }
    
    private func adjustForMarketRegime(_ regime: MarketRegime) {
        switch regime {
        case .crisis:
            if !neverBlowMode {
                riskLevel = .veryLow
            }
        case .riskOff:
            if riskLevel == .high {
                riskLevel = .medium
            }
        case .riskOn:
            if riskLevel == .low && currentDrawdown < 0.05 {
                riskLevel = .medium
            }
        case .neutral, .recovery:
            // Maintain current risk level
            break
        }
    }
    
    // MARK: - Hedge Fund Calculations
    
    private func calculatePsychologicalRisk() -> Double {
        // Based on trading psychology research from Mark Douglas and Van Tharp
        let baseRisk = 0.8
        let drawdownAdjustment = max(0.3, 1.0 - (currentDrawdown * 2))
        let regimeAdjustment = marketRegime.multiplier
        
        return baseRisk * drawdownAdjustment * regimeAdjustment
    }
    
    private func calculateConcentrationRisk(openPositions: [TradePosition]) -> Double {
        if openPositions.isEmpty { return 0.0 }
        
        let totalValue = openPositions.reduce(0) { $0 + abs($1.notionalValue) }
        let maxPositionValue = openPositions.map { abs($0.notionalValue) }.max() ?? 0
        
        return maxPositionValue / totalValue
    }
    
    private func calculateCorrelationRisk(openPositions: [TradePosition]) -> Double {
        if openPositions.isEmpty { return 0.0 }
        
        // Calculate correlation between positions
        let goldPositions = openPositions.filter { $0.symbol.contains("XAU") }
        let correlatedPositions = openPositions.filter { 
            $0.symbol.contains("USD") || $0.symbol.contains("EUR") || $0.symbol.contains("GBP")
        }
        
        let correlationFactor = Double(correlatedPositions.count) / Double(openPositions.count)
        return min(1.0, correlationFactor * 1.5)
    }
    
    private func calculateVolatilityRisk(signal: QuantumTradingSignal) -> Double {
        let range = abs(signal.entryPrice - signal.stopLoss)
        let volatility = range / signal.entryPrice
        return min(1.0, volatility * 10) // Normalize to 0-1 scale
    }
    
    private func getRiskRecommendation(totalRisk: Double) -> String {
        switch totalRisk {
        case 0.0..<0.3:
            return "Low Risk - Full Position Recommended"
        case 0.3..<0.6:
            return "Moderate Risk - Reduce Position by 25%"
        case 0.6..<0.8:
            return "High Risk - Reduce Position by 50%"
        default:
            return "Extreme Risk - Skip This Trade"
        }
    }
    
    private func updateHedgeFundMetrics() {
        hedgeFundMetrics.sharpeRatio = calculateSharpeRatio()
        hedgeFundMetrics.sortinoRatio = calculateSortinoRatio()
        hedgeFundMetrics.maxDrawdownRecovery = calculateRecoveryTime()
        hedgeFundMetrics.kellyCriterion = calculateKellyCriterion()
    }
    
    private func calculateSharpeRatio() -> Double {
        // Simplified Sharpe ratio calculation
        let riskFreeRate = 0.02 // 2% risk-free rate
        let returns = 0.15 // Assumed 15% return
        let volatility = 0.20 // Assumed 20% volatility
        
        return (returns - riskFreeRate) / volatility
    }
    
    private func calculateSortinoRatio() -> Double {
        // Simplified Sortino ratio (focuses on downside deviation)
        let returns = 0.15
        let downsideDeviation = 0.12
        
        return returns / downsideDeviation
    }
    
    private func calculateRecoveryTime() -> Double {
        // Estimated recovery time based on current drawdown
        if currentDrawdown == 0 { return 0 }
        
        let recoveryFactor = 1.0 / (1.0 - currentDrawdown)
        return recoveryFactor * 30 // Days to recover
    }
    
    private func calculateKellyCriterion() -> Double {
        // Kelly criterion for optimal position sizing
        let winRate = 0.65 // 65% win rate
        let avgWin = 1.5 // Average win is 1.5x
        let avgLoss = 1.0 // Average loss is 1x
        
        return (winRate * avgWin - (1 - winRate) * avgLoss) / avgWin
    }
    
    // MARK: - Public Interface
    
    func setRiskLevel(_ level: RiskLevel) {
        riskLevel = level
        calculateInitialRisk()
    }
    
    func setMarketRegime(_ regime: MarketRegime) {
        marketRegime = regime
    }
    
    func toggleNeverBlowMode() {
        neverBlowMode.toggle()
        if neverBlowMode {
            riskLevel = .veryLow
        }
    }
    
    func resetEmergencyShutdown() {
        emergencyShutdown = false
    }
    
    func getRecoveryPlan() -> RecoveryPlan {
        return RecoveryPlan(
            currentDrawdown: currentDrawdown,
            targetRecoveryTime: hedgeFundMetrics.maxDrawdownRecovery,
            recommendedRiskLevel: .low,
            positionSizeMultiplier: 0.5,
            tradingFrequency: .reduced
        )
    }
    
    // MARK: - Convenience Functions
    
    func createSignal(entryPrice: Double, stopLoss: Double, takeProfit: Double, confidence: Double) -> QuantumTradingSignal {
        return QuantumTradingSignal(
            entryPrice: entryPrice,
            stopLoss: stopLoss,
            takeProfit: takeProfit,
            confidence: confidence
        )
    }
}

// MARK: - Supporting Types

struct TradeRiskAssessment {
    let totalRisk: Double
    let correlationRisk: Double
    let concentrationRisk: Double
    let volatilityRisk: Double
    let recommendation: String
    let positionSize: Double
}

struct RecoveryPlan {
    let currentDrawdown: Double
    let targetRecoveryTime: Double
    let recommendedRiskLevel: QuantumRiskEngine.RiskLevel
    let positionSizeMultiplier: Double
    let tradingFrequency: TradingFrequency
    
    enum TradingFrequency {
        case normal
        case reduced
        case minimal
    }
}

struct TradePosition {
    let symbol: String
    let notionalValue: Double
    let entryPrice: Double
    let currentPrice: Double
    let quantity: Double
}

class RiskCalculator {
    func calculateRiskScore(drawdown: Double, volatility: Double, marketRegime: QuantumRiskEngine.MarketRegime) -> Double {
        let drawdownScore = drawdown * 0.4
        let volatilityScore = volatility * 0.3
        let regimeScore = (1.0 - marketRegime.multiplier) * 0.3
        
        return min(1.0, drawdownScore + volatilityScore + regimeScore)
    }
}

extension Notification.Name {
    static let emergencyShutdownTriggered = Notification.Name("emergencyShutdownTriggered")
}