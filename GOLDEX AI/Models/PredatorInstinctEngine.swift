//
//  PredatorInstinctEngine.swift
//  GOLDEX AI
//
//  Created by Keonta on 7/13/25.
//

import Foundation
import SwiftUI

// MARK: - Predator Instinct Engine™
class PredatorInstinctEngine: ObservableObject {
    
    // MARK: - Published Properties
    @Published var isActive = false
    @Published var huntingMode: HuntingMode = .stalking
    @Published var preyDetected: [MarketPrey] = []
    @Published var stealthLevel: Double = 1.0
    @Published var instinctStrength: Double = 0.0
    @Published var lastHuntTime = Date()
    @Published var isHunting = false
    @Published var sensoryData: SensoryData = SensoryData()
    @Published var predatorStats: PredatorStats = PredatorStats()
    
    // MARK: - Hunting Modes
    enum HuntingMode: CaseIterable {
        case stalking
        case tracking
        case ambush
        case pursuit
        case strike
        case feeding
        
        var displayName: String {
            switch self {
            case .stalking: return "Stealth Stalking"
            case .tracking: return "Prey Tracking"
            case .ambush: return "Ambush Position"
            case .pursuit: return "Active Pursuit"
            case .strike: return "Strike Mode"
            case .feeding: return "Feeding"
            }
        }
        
        var icon: String {
            switch self {
            case .stalking: return "eye.slash"
            case .tracking: return "location.magnifyingglass"
            case .ambush: return "target"
            case .pursuit: return "arrow.forward.circle"
            case .strike: return "bolt.fill"
            case .feeding: return "chart.line.uptrend.xyaxis"
            }
        }
        
        var color: Color {
            switch self {
            case .stalking: return .gray
            case .tracking: return .blue
            case .ambush: return .orange
            case .pursuit: return .yellow
            case .strike: return .red
            case .feeding: return .green
            }
        }
    }
    
    // MARK: - Market Prey Structure
    struct MarketPrey: Identifiable {
        let id = UUID()
        let type: PreyType
        let strength: Double
        let vulnerability: Double
        let distance: Double
        let reward: Double
        let riskLevel: Double
        let timeframe: String
        let description: String
        let isStalkable: Bool
        
        enum PreyType {
            case weakLiquidity
            case overextendedPrice
            case falseBreakout
            case stopHunt
            case liquidityGrab
            case manipulationZone
            
            var displayName: String {
                switch self {
                case .weakLiquidity: return "Weak Liquidity"
                case .overextendedPrice: return "Overextended Price"
                case .falseBreakout: return "False Breakout"
                case .stopHunt: return "Stop Hunt"
                case .liquidityGrab: return "Liquidity Grab"
                case .manipulationZone: return "Manipulation Zone"
                }
            }
            
            var icon: String {
                switch self {
                case .weakLiquidity: return "drop.circle"
                case .overextendedPrice: return "arrow.up.arrow.down"
                case .falseBreakout: return "exclamationmark.triangle"
                case .stopHunt: return "target"
                case .liquidityGrab: return "hand.raised"
                case .manipulationZone: return "questionmark.circle"
                }
            }
        }
    }
    
    // MARK: - Sensory Data
    struct SensoryData {
        var liquidityMovements: Double = 0.0
        var momentumSurges: Double = 0.0
        var volumeIntensity: Double = 0.0
        var priceVelocity: Double = 0.0
        var marketTension: Double = 0.0
        var environmentalFactors: Double = 0.0
        
        mutating func updateSensors() {
            liquidityMovements = Double.random(in: 0.1...1.0)
            momentumSurges = Double.random(in: 0.2...0.9)
            volumeIntensity = Double.random(in: 0.3...0.8)
            priceVelocity = Double.random(in: 0.1...0.7)
            marketTension = Double.random(in: 0.2...0.85)
            environmentalFactors = Double.random(in: 0.4...0.9)
        }
    }
    
    // MARK: - Predator Statistics
    struct PredatorStats {
        var successfulHunts: Int = 0
        var failedHunts: Int = 0
        var totalReward: Double = 0.0
        var averageStalkTime: Double = 0.0
        var huntingEfficiency: Double = 0.0
        var predatorRank: String = "Alpha"
        
        var successRate: Double {
            let total = successfulHunts + failedHunts
            return total > 0 ? Double(successfulHunts) / Double(total) : 0.0
        }
        
        mutating func recordHunt(success: Bool, reward: Double, stalkTime: Double) {
            if success {
                successfulHunts += 1
                totalReward += reward
            } else {
                failedHunts += 1
            }
            
            averageStalkTime = (averageStalkTime + stalkTime) / 2.0
            huntingEfficiency = successRate * 100
            
            // Update rank based on performance
            switch huntingEfficiency {
            case 0..<30:
                predatorRank = "Novice"
            case 30..<50:
                predatorRank = "Hunter"
            case 50..<70:
                predatorRank = "Skilled"
            case 70..<85:
                predatorRank = "Expert"
            case 85..<95:
                predatorRank = "Master"
            default:
                predatorRank = "Alpha"
            }
        }
    }
    
    // MARK: - Hunting Methods
    func startHunting() {
        isHunting = true
        lastHuntTime = Date()
        huntingMode = .stalking
        
        // Update sensory data
        sensoryData.updateSensors()
        
        // Scan for prey
        scanForPrey()
        
        // Calculate instinct strength
        calculateInstinctStrength()
        
        // Simulate hunting sequence
        simulateHuntingSequence()
    }
    
    private func scanForPrey() {
        var detectedPrey: [MarketPrey] = []
        
        let preyTypes: [MarketPrey.PreyType] = [
            .weakLiquidity, .overextendedPrice, .falseBreakout,
            .stopHunt, .liquidityGrab, .manipulationZone
        ]
        
        for type in preyTypes {
            if Double.random(in: 0...1) > 0.6 { // 40% chance to detect each type
                let prey = MarketPrey(
                    type: type,
                    strength: Double.random(in: 0.3...0.8),
                    vulnerability: Double.random(in: 0.4...0.9),
                    distance: Double.random(in: 10...100),
                    reward: Double.random(in: 25...75),
                    riskLevel: Double.random(in: 0.1...0.6),
                    timeframe: "M15",
                    description: "Detected \(type.displayName) - High probability target",
                    isStalkable: true
                )
                detectedPrey.append(prey)
            }
        }
        
        preyDetected = detectedPrey
    }
    
    private func calculateInstinctStrength() {
        let sensorAverage = (sensoryData.liquidityMovements + 
                           sensoryData.momentumSurges + 
                           sensoryData.volumeIntensity + 
                           sensoryData.priceVelocity + 
                           sensoryData.marketTension + 
                           sensoryData.environmentalFactors) / 6.0
        
        instinctStrength = sensorAverage * stealthLevel
    }
    
    private func simulateHuntingSequence() {
        let huntingSequence: [HuntingMode] = [.stalking, .tracking, .ambush, .pursuit, .strike, .feeding]
        
        for (index, mode) in huntingSequence.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.8) {
                self.huntingMode = mode
                self.adjustStealthLevel(for: mode)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.completeHunt()
        }
    }
    
    private func adjustStealthLevel(for mode: HuntingMode) {
        switch mode {
        case .stalking:
            stealthLevel = 1.0
        case .tracking:
            stealthLevel = 0.9
        case .ambush:
            stealthLevel = 0.95
        case .pursuit:
            stealthLevel = 0.7
        case .strike:
            stealthLevel = 0.3
        case .feeding:
            stealthLevel = 0.8
        }
    }
    
    private func completeHunt() {
        let huntSuccess = instinctStrength > 0.6
        let reward = huntSuccess ? Double.random(in: 30...80) : 0.0
        let stalkTime = 5.0
        
        predatorStats.recordHunt(success: huntSuccess, reward: reward, stalkTime: stalkTime)
        
        isHunting = false
        huntingMode = .stalking
        stealthLevel = 1.0
    }
    
    func activateEngine() {
        isActive = true
        startHunting()
    }
    
    func deactivateEngine() {
        isActive = false
        isHunting = false
        preyDetected.removeAll()
        huntingMode = .stalking
        stealthLevel = 1.0
        instinctStrength = 0.0
    }
}

#Preview {
    VStack {
        Text("Predator Instinct Engine")
            .font(.title)
            .padding()
    }
}