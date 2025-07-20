//
//  TradeCompassEngine.swift
//  GOLDEX AI
//
//  Created by Keonta on 7/13/25.
//

import Foundation
import SwiftUI

// MARK: - Trade Compass Engine™
class TradeCompassEngine: ObservableObject {
    
    // MARK: - Published Properties
    @Published var isActive = false
    @Published var isCalibrating = false
    @Published var currentBias: TradeBias = .neutral
    @Published var compassDirection: Double = 0.0 // 0-360 degrees
    @Published var biasStrength: Double = 0.0
    @Published var timeframeBias: [TimeframeBias] = []
    @Published var biasLock: BiasLock = BiasLock()
    @Published var alignmentScore: Double = 0.0
    @Published var lastCalibrationTime = Date()
    @Published var compassData: CompassData = CompassData()
    @Published var trendConfirmation: TrendConfirmation = TrendConfirmation()
    
    // MARK: - Trade Bias
    enum TradeBias: CaseIterable {
        case strongBullish    // 315-45 degrees
        case bullish          // 45-135 degrees
        case neutral          // 135-225 degrees
        case bearish          // 225-315 degrees
        case strongBearish    // 315-45 degrees (opposite)
        
        var displayName: String {
            switch self {
            case .strongBullish: return "Strong Bullish"
            case .bullish: return "Bullish"
            case .neutral: return "Neutral"
            case .bearish: return "Bearish"
            case .strongBearish: return "Strong Bearish"
            }
        }
        
        var color: Color {
            switch self {
            case .strongBullish: return .green
            case .bullish: return .mint
            case .neutral: return .gray
            case .bearish: return .orange
            case .strongBearish: return .red
            }
        }
        
        var icon: String {
            switch self {
            case .strongBullish: return "arrow.up.circle.fill"
            case .bullish: return "arrow.up.right.circle"
            case .neutral: return "minus.circle"
            case .bearish: return "arrow.down.right.circle"
            case .strongBearish: return "arrow.down.circle.fill"
            }
        }
        
        var angle: Double {
            switch self {
            case .strongBullish: return 0
            case .bullish: return 45
            case .neutral: return 90
            case .bearish: return 225
            case .strongBearish: return 270
            }
        }
    }
    
    // MARK: - Timeframe Bias
    struct TimeframeBias: Identifiable {
        let id = UUID()
        let timeframe: String
        let bias: TradeBias
        let strength: Double
        let reliability: Double
        let lastUpdate: Date
        let supportLevel: Double
        let resistanceLevel: Double
        let trendDuration: Double
        
        static let timeframes = ["M15", "H1", "H4", "D1", "W1", "MN"]
        
        static func generateBias(for timeframe: String) -> TimeframeBias {
            return TimeframeBias(
                timeframe: timeframe,
                bias: TradeBias.allCases.randomElement() ?? .neutral,
                strength: Double.random(in: 0.5...0.95),
                reliability: Double.random(in: 0.7...0.98),
                lastUpdate: Date(),
                supportLevel: Double.random(in: 1900...2000),
                resistanceLevel: Double.random(in: 2000...2100),
                trendDuration: Double.random(in: 1...30)
            )
        }
    }
    
    // MARK: - Bias Lock
    struct BiasLock {
        var isLocked: Bool = false
        var lockedBias: TradeBias = .neutral
        var lockStrength: Double = 0.0
        var lockDuration: Double = 0.0
        var lockReason: String = ""
        var lockTime: Date = Date()
        var autoUnlockAt: Date?
        
        mutating func lock(bias: TradeBias, strength: Double, reason: String, duration: Double = 0) {
            isLocked = true
            lockedBias = bias
            lockStrength = strength
            lockDuration = duration
            lockReason = reason
            lockTime = Date()
            
            if duration > 0 {
                autoUnlockAt = Date().addingTimeInterval(duration * 3600) // Convert hours to seconds
            }
        }
        
        mutating func unlock() {
            isLocked = false
            lockedBias = .neutral
            lockStrength = 0.0
            lockDuration = 0.0
            lockReason = ""
            autoUnlockAt = nil
        }
        
        var shouldAutoUnlock: Bool {
            guard let unlockTime = autoUnlockAt else { return false }
            return Date() > unlockTime
        }
    }
    
    // MARK: - Compass Data
    struct CompassData {
        var magneticDeclination: Double = 0.0
        var trueNorth: Double = 0.0
        var magneticNorth: Double = 0.0
        var compassAccuracy: Double = 0.0
        var calibrationStatus: CalibrationStatus = .uncalibrated
        var environmentalFactors: EnvironmentalFactors = EnvironmentalFactors()
        
        enum CalibrationStatus {
            case uncalibrated
            case calibrating
            case calibrated
            case needsRecalibration
            
            var displayName: String {
                switch self {
                case .uncalibrated: return "Uncalibrated"
                case .calibrating: return "Calibrating..."
                case .calibrated: return "Calibrated"
                case .needsRecalibration: return "Needs Recalibration"
                }
            }
            
            var color: Color {
                switch self {
                case .uncalibrated: return .red
                case .calibrating: return .orange
                case .calibrated: return .green
                case .needsRecalibration: return .yellow
                }
            }
        }
        
        struct EnvironmentalFactors {
            var volatility: Double = 0.0
            var volume: Double = 0.0
            var liquidity: Double = 0.0
            var newsImpact: Double = 0.0
            var marketHours: Double = 0.0
            var seasonality: Double = 0.0
            
            mutating func updateFactors() {
                volatility = Double.random(in: 0.2...0.9)
                volume = Double.random(in: 0.3...0.8)
                liquidity = Double.random(in: 0.4...0.95)
                newsImpact = Double.random(in: 0.1...0.7)
                marketHours = Double.random(in: 0.5...1.0)
                seasonality = Double.random(in: 0.3...0.8)
            }
        }
        
        mutating func updateCompassData() {
            magneticDeclination = Double.random(in: -15...15)
            trueNorth = 0.0
            magneticNorth = magneticDeclination
            compassAccuracy = Double.random(in: 0.8...0.99)
            calibrationStatus = .calibrated
            environmentalFactors.updateFactors()
        }
    }
    
    // MARK: - Trend Confirmation
    struct TrendConfirmation {
        var confirmationScore: Double = 0.0
        var confirmationSignals: [ConfirmationSignal] = []
        var divergenceWarnings: [DivergenceWarning] = []
        var trendAge: Double = 0.0
        var trendVelocity: Double = 0.0
        var trendAcceleration: Double = 0.0
        
        struct ConfirmationSignal {
            let type: SignalType
            let strength: Double
            let timeframe: String
            let description: String
            
            enum SignalType {
                case priceAction
                case volume
                case momentum
                case support
                case resistance
                case pattern
                
                var displayName: String {
                    switch self {
                    case .priceAction: return "Price Action"
                    case .volume: return "Volume"
                    case .momentum: return "Momentum"
                    case .support: return "Support"
                    case .resistance: return "Resistance"
                    case .pattern: return "Pattern"
                    }
                }
            }
        }
        
        struct DivergenceWarning {
            let type: DivergenceType
            let severity: Double
            let timeframe: String
            let description: String
            
            enum DivergenceType {
                case priceVolume
                case momentumPrice
                case timeframeConflict
                case strengthWeakening
                
                var displayName: String {
                    switch self {
                    case .priceVolume: return "Price-Volume Divergence"
                    case .momentumPrice: return "Momentum-Price Divergence"
                    case .timeframeConflict: return "Timeframe Conflict"
                    case .strengthWeakening: return "Strength Weakening"
                    }
                }
            }
        }
        
        mutating func updateConfirmation() {
            confirmationScore = Double.random(in: 0.4...0.95)
            
            confirmationSignals = [
                ConfirmationSignal(type: .priceAction, strength: Double.random(in: 0.6...0.9), timeframe: "H4", description: "Strong bullish price action"),
                ConfirmationSignal(type: .volume, strength: Double.random(in: 0.5...0.8), timeframe: "H1", description: "Volume confirming trend"),
                ConfirmationSignal(type: .momentum, strength: Double.random(in: 0.7...0.95), timeframe: "D1", description: "Momentum aligned with bias")
            ]
            
            if Double.random(in: 0...1) > 0.7 {
                divergenceWarnings = [
                    DivergenceWarning(type: .momentumPrice, severity: Double.random(in: 0.3...0.7), timeframe: "H1", description: "Momentum showing signs of weakness")
                ]
            }
            
            trendAge = Double.random(in: 0.5...15.0)
            trendVelocity = Double.random(in: 0.2...0.9)
            trendAcceleration = Double.random(in: -0.3...0.5)
        }
    }
    
    // MARK: - Calibration Methods
    func startCalibration() {
        isCalibrating = true
        lastCalibrationTime = Date()
        compassData.calibrationStatus = .calibrating
        
        // Generate timeframe bias data
        generateTimeframeBias()
        
        // Update compass data
        compassData.updateCompassData()
        
        // Update trend confirmation
        trendConfirmation.updateConfirmation()
        
        // Simulate calibration process
        simulateCalibration()
    }
    
    private func generateTimeframeBias() {
        timeframeBias = TimeframeBias.timeframes.map { timeframe in
            TimeframeBias.generateBias(for: timeframe)
        }
    }
    
    private func simulateCalibration() {
        let calibrationSteps = 5
        
        for step in 0..<calibrationSteps {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(step) * 0.8) {
                self.updateCalibrationStep(step)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            self.completeCalibration()
        }
    }
    
    private func updateCalibrationStep(_ step: Int) {
        let progress = Double(step) / 5.0
        alignmentScore = progress
        
        // Update compass direction based on dominant bias
        let dominantBias = findDominantBias()
        compassDirection = dominantBias.angle
        currentBias = dominantBias
        biasStrength = progress
    }
    
    private func findDominantBias() -> TradeBias {
        // Weight higher timeframes more heavily
        let weights: [String: Double] = [
            "MN": 5.0,
            "W1": 4.0,
            "D1": 3.0,
            "H4": 2.0,
            "H1": 1.5,
            "M15": 1.0
        ]
        
        var biasScores: [TradeBias: Double] = [:]
        
        for timeframeBias in timeframeBias {
            let weight = weights[timeframeBias.timeframe] ?? 1.0
            let score = timeframeBias.strength * timeframeBias.reliability * weight
            biasScores[timeframeBias.bias, default: 0] += score
        }
        
        return biasScores.max(by: { $0.value < $1.value })?.key ?? .neutral
    }
    
    private func completeCalibration() {
        isCalibrating = false
        compassData.calibrationStatus = .calibrated
        alignmentScore = calculateAlignmentScore()
        
        // Auto-lock bias if strong enough
        if biasStrength > 0.8 {
            biasLock.lock(
                bias: currentBias,
                strength: biasStrength,
                reason: "Strong multi-timeframe alignment",
                duration: 4.0
            )
        }
    }
    
    private func calculateAlignmentScore() -> Double {
        let consistencyScore = calculateConsistencyScore()
        let strengthScore = timeframeBias.reduce(0) { $0 + $1.strength } / Double(timeframeBias.count)
        let reliabilityScore = timeframeBias.reduce(0) { $0 + $1.reliability } / Double(timeframeBias.count)
        
        return (consistencyScore + strengthScore + reliabilityScore) / 3.0
    }
    
    private func calculateConsistencyScore() -> Double {
        guard !timeframeBias.isEmpty else { return 0.0 }
        
        let biasCount = Dictionary(grouping: timeframeBias) { $0.bias }
        let dominantBiasCount = biasCount.values.map { $0.count }.max() ?? 0
        
        return Double(dominantBiasCount) / Double(timeframeBias.count)
    }
    
    // MARK: - Bias Management
    func lockBias(reason: String) {
        biasLock.lock(
            bias: currentBias,
            strength: biasStrength,
            reason: reason,
            duration: 2.0
        )
    }
    
    func unlockBias() {
        biasLock.unlock()
    }
    
    func checkForBiasChanges() {
        let newBias = findDominantBias()
        
        if newBias != currentBias && !biasLock.isLocked {
            currentBias = newBias
            compassDirection = newBias.angle
            biasStrength = calculateBiasStrength()
        }
        
        // Check for auto-unlock
        if biasLock.shouldAutoUnlock {
            biasLock.unlock()
        }
    }
    
    private func calculateBiasStrength() -> Double {
        let alignedBias = timeframeBias.filter { $0.bias == currentBias }
        let totalWeight = alignedBias.reduce(0) { $0 + $1.strength * $1.reliability }
        return min(totalWeight / Double(timeframeBias.count), 1.0)
    }
    
    // MARK: - Engine Control
    func activateEngine() {
        isActive = true
        startCalibration()
    }
    
    func deactivateEngine() {
        isActive = false
        isCalibrating = false
        currentBias = .neutral
        compassDirection = 0.0
        biasStrength = 0.0
        alignmentScore = 0.0
        timeframeBias.removeAll()
        biasLock.unlock()
    }
    
    // MARK: - Trade Filtering
    func shouldAllowTrade(direction: TradeBias) -> Bool {
        guard isActive else { return true }
        
        if biasLock.isLocked {
            return direction == biasLock.lockedBias || biasLock.lockedBias == .neutral
        }
        
        return direction == currentBias || currentBias == .neutral || biasStrength < 0.6
    }
    
    func getTradeRecommendation() -> String {
        if !isActive {
            return "Compass inactive - no bias filtering"
        }
        
        if biasLock.isLocked {
            return "BIAS LOCKED: Only trade \(biasLock.lockedBias.displayName) - \(biasLock.lockReason)"
        }
        
        if biasStrength > 0.8 {
            return "STRONG BIAS: Focus on \(currentBias.displayName) trades"
        } else if biasStrength > 0.6 {
            return "MEDIUM BIAS: Prefer \(currentBias.displayName) trades"
        } else {
            return "NEUTRAL BIAS: All directions acceptable"
        }
    }
}

#Preview {
    VStack {
        Text("Trade Compass Engine")
            .font(.title)
            .padding()
    }
}