//
//  AthleteFlowEngine.swift
//  GOLDEX AI
//
//  Created by Keonta on 7/13/25.
//

import Foundation
import SwiftUI

// MARK: - Athlete Flow Engine™
class AthleteFlowEngine: ObservableObject {
    
    // MARK: - Published Properties
    @Published var isActive = false
    @Published var flowState: FlowState = .warmup
    @Published var performanceMetrics: PerformanceMetrics = PerformanceMetrics()
    @Published var trainingData: TrainingData = TrainingData()
    @Published var mentalState: MentalState = .calm
    @Published var isInZone = false
    @Published var currentSession: TrainingSession?
    @Published var recoveryStatus: RecoveryStatus = .recovered
    @Published var lastWorkoutTime = Date()
    
    // MARK: - Flow States
    enum FlowState: CaseIterable {
        case warmup
        case training
        case competing
        case zone
        case recovery
        case cooldown
        
        var displayName: String {
            switch self {
            case .warmup: return "Warm-up"
            case .training: return "Training"
            case .competing: return "Competing"
            case .zone: return "In The Zone"
            case .recovery: return "Recovery"
            case .cooldown: return "Cool-down"
            }
        }
        
        var icon: String {
            switch self {
            case .warmup: return "flame"
            case .training: return "dumbbell"
            case .competing: return "sportscourt"
            case .zone: return "target"
            case .recovery: return "bed.double"
            case .cooldown: return "wind"
            }
        }
        
        var color: Color {
            switch self {
            case .warmup: return .orange
            case .training: return .blue
            case .competing: return .red
            case .zone: return .purple
            case .recovery: return .green
            case .cooldown: return .cyan
            }
        }
    }
    
    // MARK: - Mental States
    enum MentalState: CaseIterable {
        case calm
        case focused
        case intense
        case confident
        case resilient
        case peak
        
        var displayName: String {
            switch self {
            case .calm: return "Calm"
            case .focused: return "Focused"
            case .intense: return "Intense"
            case .confident: return "Confident"
            case .resilient: return "Resilient"
            case .peak: return "Peak Performance"
            }
        }
        
        var color: Color {
            switch self {
            case .calm: return .mint
            case .focused: return .blue
            case .intense: return .red
            case .confident: return .yellow
            case .resilient: return .green
            case .peak: return .purple
            }
        }
    }
    
    // MARK: - Recovery Status
    enum RecoveryStatus: CaseIterable {
        case fatigued
        case recovering
        case rested
        case recovered
        case peaked
        
        var displayName: String {
            switch self {
            case .fatigued: return "Fatigued"
            case .recovering: return "Recovering"
            case .rested: return "Rested"
            case .recovered: return "Recovered"
            case .peaked: return "Peaked"
            }
        }
        
        var color: Color {
            switch self {
            case .fatigued: return .red
            case .recovering: return .orange
            case .rested: return .yellow
            case .recovered: return .green
            case .peaked: return .purple
            }
        }
        
        var percentage: Double {
            switch self {
            case .fatigued: return 0.2
            case .recovering: return 0.4
            case .rested: return 0.6
            case .recovered: return 0.8
            case .peaked: return 1.0
            }
        }
    }
    
    // MARK: - Performance Metrics
    struct PerformanceMetrics {
        var precision: Double = 0.0
        var consistency: Double = 0.0
        var executionSpeed: Double = 0.0
        var mentalToughness: Double = 0.0
        var adaptability: Double = 0.0
        var winRate: Double = 0.0
        var streakLength: Int = 0
        var personalBest: Double = 0.0
        
        var overallScore: Double {
            (precision + consistency + executionSpeed + mentalToughness + adaptability + winRate) / 6.0
        }
        
        mutating func updateMetrics() {
            precision = Double.random(in: 0.6...0.95)
            consistency = Double.random(in: 0.5...0.9)
            executionSpeed = Double.random(in: 0.7...0.95)
            mentalToughness = Double.random(in: 0.6...0.9)
            adaptability = Double.random(in: 0.5...0.85)
            winRate = Double.random(in: 0.6...0.92)
            streakLength = Int.random(in: 1...15)
            personalBest = max(personalBest, overallScore)
        }
    }
    
    // MARK: - Training Data
    struct TrainingData {
        var dailyTrainingHours: Double = 0.0
        var weeklyProgress: Double = 0.0
        var skillLevel: SkillLevel = .beginner
        var trainingIntensity: Double = 0.0
        var recoveryTime: Double = 0.0
        var improvementRate: Double = 0.0
        
        enum SkillLevel: CaseIterable {
            case beginner
            case intermediate
            case advanced
            case expert
            case elite
            case worldClass
            
            var displayName: String {
                switch self {
                case .beginner: return "Beginner"
                case .intermediate: return "Intermediate"
                case .advanced: return "Advanced"
                case .expert: return "Expert"
                case .elite: return "Elite"
                case .worldClass: return "World Class"
                }
            }
            
            var color: Color {
                switch self {
                case .beginner: return .gray
                case .intermediate: return .blue
                case .advanced: return .green
                case .expert: return .orange
                case .elite: return .red
                case .worldClass: return .purple
                }
            }
        }
        
        mutating func updateTrainingData() {
            dailyTrainingHours = Double.random(in: 2...8)
            weeklyProgress = Double.random(in: 0.05...0.25)
            trainingIntensity = Double.random(in: 0.5...0.95)
            recoveryTime = Double.random(in: 0.5...4.0)
            improvementRate = Double.random(in: 0.02...0.15)
            
            // Update skill level based on performance
            let skillLevels: [SkillLevel] = [.beginner, .intermediate, .advanced, .expert, .elite, .worldClass]
            skillLevel = skillLevels.randomElement() ?? .intermediate
        }
    }
    
    // MARK: - Training Session
    struct TrainingSession: Identifiable {
        let id = UUID()
        let startTime: Date
        var endTime: Date?
        let type: SessionType
        var intensity: Double
        var focus: String
        var results: [TrainingResult] = []
        
        enum SessionType {
            case warmup
            case skillDevelopment
            case competition
            case recovery
            case mentalTraining
            
            var displayName: String {
                switch self {
                case .warmup: return "Warm-up Session"
                case .skillDevelopment: return "Skill Development"
                case .competition: return "Competition Mode"
                case .recovery: return "Recovery Session"
                case .mentalTraining: return "Mental Training"
                }
            }
        }
        
        struct TrainingResult {
            let metric: String
            let value: Double
            let improvement: Double
        }
    }
    
    // MARK: - Training Methods
    func startTraining() {
        flowState = .warmup
        isInZone = false
        lastWorkoutTime = Date()
        
        // Create new training session
        currentSession = TrainingSession(
            startTime: Date(),
            type: .skillDevelopment,
            intensity: Double.random(in: 0.6...0.9),
            focus: "Precision Trading Execution"
        )
        
        // Update training data
        trainingData.updateTrainingData()
        
        // Start training sequence
        simulateTrainingSequence()
    }
    
    private func simulateTrainingSequence() {
        let trainingSequence: [FlowState] = [.warmup, .training, .competing, .zone, .recovery, .cooldown]
        
        for (index, state) in trainingSequence.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 1.0) {
                self.flowState = state
                self.updateMentalState(for: state)
                self.updatePerformanceMetrics(for: state)
                
                if state == .zone {
                    self.isInZone = true
                }
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) {
            self.completeTraining()
        }
    }
    
    private func updateMentalState(for flowState: FlowState) {
        switch flowState {
        case .warmup:
            mentalState = .calm
        case .training:
            mentalState = .focused
        case .competing:
            mentalState = .intense
        case .zone:
            mentalState = .peak
        case .recovery:
            mentalState = .resilient
        case .cooldown:
            mentalState = .calm
        }
    }
    
    private func updatePerformanceMetrics(for flowState: FlowState) {
        performanceMetrics.updateMetrics()
        
        // Bonus for being in the zone
        if flowState == .zone {
            performanceMetrics.precision *= 1.2
            performanceMetrics.consistency *= 1.15
            performanceMetrics.executionSpeed *= 1.1
        }
    }
    
    private func completeTraining() {
        currentSession?.endTime = Date()
        flowState = .cooldown
        isInZone = false
        
        // Update recovery status based on performance
        updateRecoveryStatus()
    }
    
    private func updateRecoveryStatus() {
        let performanceScore = performanceMetrics.overallScore
        
        switch performanceScore {
        case 0.0..<0.3:
            recoveryStatus = .fatigued
        case 0.3..<0.5:
            recoveryStatus = .recovering
        case 0.5..<0.7:
            recoveryStatus = .rested
        case 0.7..<0.9:
            recoveryStatus = .recovered
        default:
            recoveryStatus = .peaked
        }
    }
    
    func recoverFromLoss() {
        mentalState = .resilient
        recoveryStatus = .recovering
        
        // Simulate recovery process
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.mentalState = .confident
            self.recoveryStatus = .recovered
        }
    }
    
    func activateEngine() {
        isActive = true
        startTraining()
    }
    
    func deactivateEngine() {
        isActive = false
        flowState = .warmup
        isInZone = false
        mentalState = .calm
        recoveryStatus = .recovered
        currentSession = nil
    }
}

#Preview {
    VStack {
        Text("Athlete Flow Engine")
            .font(.title)
            .padding()
    }
}