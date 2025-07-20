//
//  MusicianRhythmEngine.swift
//  GOLDEX AI
//
//  Created by Keonta on 7/13/25.
//

import Foundation
import SwiftUI

// MARK: - Musician's Rhythm Engine™
class MusicianRhythmEngine: ObservableObject {
    
    // MARK: - Published Properties
    @Published var isActive = false
    @Published var isPlaying = false
    @Published var currentTempo: Tempo = .moderate
    @Published var marketRhythm: MarketRhythm = MarketRhythm()
    @Published var musicalElements: MusicalElements = MusicalElements()
    @Published var rhythmPatterns: [RhythmPattern] = []
    @Published var harmonyLevel: Double = 0.0
    @Published var dissonanceLevel: Double = 0.0
    @Published var flowState: FlowState = .inSync
    @Published var lastPerformanceTime = Date()
    @Published var compositionData: CompositionData = CompositionData()
    
    // MARK: - Tempo Types
    enum Tempo: CaseIterable {
        case largo      // Very slow
        case adagio     // Slow
        case andante    // Walking pace
        case moderate   // Moderate
        case allegro    // Fast
        case presto     // Very fast
        
        var displayName: String {
            switch self {
            case .largo: return "Largo (Very Slow)"
            case .adagio: return "Adagio (Slow)"
            case .andante: return "Andante (Walking)"
            case .moderate: return "Moderate"
            case .allegro: return "Allegro (Fast)"
            case .presto: return "Presto (Very Fast)"
            }
        }
        
        var bpm: Int {
            switch self {
            case .largo: return 45
            case .adagio: return 65
            case .andante: return 85
            case .moderate: return 105
            case .allegro: return 140
            case .presto: return 180
            }
        }
        
        var color: Color {
            switch self {
            case .largo: return .blue
            case .adagio: return .cyan
            case .andante: return .green
            case .moderate: return .yellow
            case .allegro: return .orange
            case .presto: return .red
            }
        }
        
        var marketCondition: String {
            switch self {
            case .largo: return "Slow Market"
            case .adagio: return "Quiet Trading"
            case .andante: return "Steady Movement"
            case .moderate: return "Normal Activity"
            case .allegro: return "High Volatility"
            case .presto: return "Extreme Movement"
            }
        }
    }
    
    // MARK: - Market Rhythm
    struct MarketRhythm {
        var beat: Beat = Beat()
        var pulse: Double = 0.0
        var swing: Double = 0.0
        var groove: Double = 0.0
        var syncopation: Double = 0.0
        var polyrhythm: Double = 0.0
        
        struct Beat {
            var strength: Double = 0.0
            var consistency: Double = 0.0
            var timing: Double = 0.0
            var subdivision: String = "4/4"
            var accentPattern: [Bool] = [true, false, true, false]
            
            mutating func updateBeat() {
                strength = Double.random(in: 0.4...0.9)
                consistency = Double.random(in: 0.5...0.95)
                timing = Double.random(in: 0.6...0.9)
                subdivision = ["4/4", "3/4", "6/8", "7/8", "5/4"].randomElement() ?? "4/4"
                accentPattern = (0..<8).map { _ in Bool.random() }
            }
        }
        
        mutating func updateRhythm() {
            beat.updateBeat()
            pulse = Double.random(in: 0.3...0.9)
            swing = Double.random(in: 0.2...0.8)
            groove = Double.random(in: 0.4...0.95)
            syncopation = Double.random(in: 0.1...0.7)
            polyrhythm = Double.random(in: 0.2...0.6)
        }
    }
    
    // MARK: - Musical Elements
    struct MusicalElements {
        var liquidity: LiquidityNote = .quarter
        var pullbacks: PullbackNote = .eighth
        var breakouts: BreakoutNote = .whole
        var stopHunts: StopHuntNote = .sixteenth
        var confluence: ConfluenceNote = .half
        var volume: VolumeNote = .quarter
        
        enum LiquidityNote: CaseIterable {
            case whole
            case half
            case quarter
            case eighth
            case sixteenth
            
            var displayName: String {
                switch self {
                case .whole: return "Whole Note (Strong)"
                case .half: return "Half Note (Medium)"
                case .quarter: return "Quarter Note (Normal)"
                case .eighth: return "Eighth Note (Quick)"
                case .sixteenth: return "Sixteenth Note (Rapid)"
                }
            }
            
            var duration: Double {
                switch self {
                case .whole: return 4.0
                case .half: return 2.0
                case .quarter: return 1.0
                case .eighth: return 0.5
                case .sixteenth: return 0.25
                }
            }
        }
        
        enum PullbackNote: CaseIterable {
            case whole, half, quarter, eighth, sixteenth
            
            var displayName: String {
                switch self {
                case .whole: return "Deep Pullback"
                case .half: return "Medium Pullback"
                case .quarter: return "Quick Pullback"
                case .eighth: return "Minor Pullback"
                case .sixteenth: return "Micro Pullback"
                }
            }
        }
        
        enum BreakoutNote: CaseIterable {
            case whole, half, quarter, eighth, sixteenth
            
            var displayName: String {
                switch self {
                case .whole: return "Major Breakout"
                case .half: return "Strong Breakout"
                case .quarter: return "Standard Breakout"
                case .eighth: return "Quick Breakout"
                case .sixteenth: return "Micro Breakout"
                }
            }
        }
        
        enum StopHuntNote: CaseIterable {
            case whole, half, quarter, eighth, sixteenth
            
            var displayName: String {
                switch self {
                case .whole: return "Major Stop Hunt"
                case .half: return "Strong Stop Hunt"
                case .quarter: return "Standard Stop Hunt"
                case .eighth: return "Quick Stop Hunt"
                case .sixteenth: return "Micro Stop Hunt"
                }
            }
        }
        
        enum ConfluenceNote: CaseIterable {
            case whole, half, quarter, eighth, sixteenth
            
            var displayName: String {
                switch self {
                case .whole: return "Perfect Harmony"
                case .half: return "Strong Harmony"
                case .quarter: return "Good Harmony"
                case .eighth: return "Mild Harmony"
                case .sixteenth: return "Weak Harmony"
                }
            }
        }
        
        enum VolumeNote: CaseIterable {
            case whole, half, quarter, eighth, sixteenth
            
            var displayName: String {
                switch self {
                case .whole: return "Fortissimo (Very Loud)"
                case .half: return "Forte (Loud)"
                case .quarter: return "Mezzo-forte (Medium)"
                case .eighth: return "Piano (Soft)"
                case .sixteenth: return "Pianissimo (Very Soft)"
                }
            }
        }
        
        mutating func updateElements() {
            liquidity = LiquidityNote.allCases.randomElement() ?? .quarter
            pullbacks = PullbackNote.allCases.randomElement() ?? .eighth
            breakouts = BreakoutNote.allCases.randomElement() ?? .whole
            stopHunts = StopHuntNote.allCases.randomElement() ?? .sixteenth
            confluence = ConfluenceNote.allCases.randomElement() ?? .half
            volume = VolumeNote.allCases.randomElement() ?? .quarter
        }
    }
    
    // MARK: - Rhythm Patterns
    struct RhythmPattern: Identifiable {
        let id = UUID()
        let name: String
        let pattern: String
        let timeSignature: String
        let complexity: Double
        let harmony: Double
        let dissonance: Double
        let tradingAccuracy: Double
        let description: String
        
        static let jazzPatterns: [RhythmPattern] = [
            RhythmPattern(
                name: "Swing Trading Pattern",
                pattern: "♪ ♫ ♪ ♫ ♪ ♫ ♪ ♫",
                timeSignature: "4/4",
                complexity: 0.7,
                harmony: 0.8,
                dissonance: 0.2,
                tradingAccuracy: 0.82,
                description: "Smooth swing rhythm for trend following"
            ),
            RhythmPattern(
                name: "Bebop Breakout",
                pattern: "♬ ♪ ♬ ♪ ♬ ♪ ♬ ♪",
                timeSignature: "4/4",
                complexity: 0.9,
                harmony: 0.6,
                dissonance: 0.4,
                tradingAccuracy: 0.75,
                description: "Fast-paced pattern for quick breakouts"
            ),
            RhythmPattern(
                name: "Blues Consolidation",
                pattern: "♫ ♪ ♫ ♪ ♫ ♪ ♫ ♪",
                timeSignature: "12/8",
                complexity: 0.5,
                harmony: 0.9,
                dissonance: 0.1,
                tradingAccuracy: 0.88,
                description: "Slow, steady pattern for ranging markets"
            ),
            RhythmPattern(
                name: "Latin Momentum",
                pattern: "♪ ♬ ♪ ♬ ♪ ♬ ♪ ♬",
                timeSignature: "3/4",
                complexity: 0.8,
                harmony: 0.7,
                dissonance: 0.3,
                tradingAccuracy: 0.79,
                description: "Energetic pattern for momentum trading"
            ),
            RhythmPattern(
                name: "Classical Precision",
                pattern: "♪ ♪ ♪ ♪ ♪ ♪ ♪ ♪",
                timeSignature: "4/4",
                complexity: 0.6,
                harmony: 0.95,
                dissonance: 0.05,
                tradingAccuracy: 0.91,
                description: "Perfect timing for precise entries"
            )
        ]
    }
    
    // MARK: - Flow States
    enum FlowState: CaseIterable {
        case outOfSync
        case finding
        case inSync
        case flowing
        case masterpiece
        
        var displayName: String {
            switch self {
            case .outOfSync: return "Out of Sync"
            case .finding: return "Finding Rhythm"
            case .inSync: return "In Sync"
            case .flowing: return "Flowing"
            case .masterpiece: return "Masterpiece"
            }
        }
        
        var color: Color {
            switch self {
            case .outOfSync: return .red
            case .finding: return .orange
            case .inSync: return .yellow
            case .flowing: return .green
            case .masterpiece: return .purple
            }
        }
        
        var multiplier: Double {
            switch self {
            case .outOfSync: return 0.5
            case .finding: return 0.7
            case .inSync: return 1.0
            case .flowing: return 1.3
            case .masterpiece: return 1.5
            }
        }
    }
    
    // MARK: - Composition Data
    struct CompositionData {
        var currentKey: MusicalKey = .cMajor
        var chord: Chord = .major
        var scale: Scale = .major
        var improvisation: Double = 0.0
        var expression: Double = 0.0
        var dynamics: Dynamic = .mf
        
        enum MusicalKey: CaseIterable {
            case cMajor
            case gMajor
            case dMajor
            case aMajor
            case eMajor
            case fMajor
            case bbMajor
            
            var displayName: String {
                switch self {
                case .cMajor: return "C Major"
                case .gMajor: return "G Major"
                case .dMajor: return "D Major"
                case .aMajor: return "A Major"
                case .eMajor: return "E Major"
                case .fMajor: return "F Major"
                case .bbMajor: return "Bb Major"
                }
            }
        }
        
        enum Chord: CaseIterable {
            case major
            case minor
            case diminished
            case augmented
            case seventh
            case ninth
            
            var displayName: String {
                switch self {
                case .major: return "Major"
                case .minor: return "Minor"
                case .diminished: return "Diminished"
                case .augmented: return "Augmented"
                case .seventh: return "Seventh"
                case .ninth: return "Ninth"
                }
            }
        }
        
        enum Scale: CaseIterable {
            case major
            case minor
            case dorian
            case phrygian
            case lydian
            case mixolydian
            
            var displayName: String {
                switch self {
                case .major: return "Major"
                case .minor: return "Minor"
                case .dorian: return "Dorian"
                case .phrygian: return "Phrygian"
                case .lydian: return "Lydian"
                case .mixolydian: return "Mixolydian"
                }
            }
        }
        
        enum Dynamic: CaseIterable {
            case pp  // Pianissimo
            case p   // Piano
            case mp  // Mezzo-piano
            case mf  // Mezzo-forte
            case f   // Forte
            case ff  // Fortissimo
            
            var displayName: String {
                switch self {
                case .pp: return "Pianissimo (Very Soft)"
                case .p: return "Piano (Soft)"
                case .mp: return "Mezzo-piano (Medium Soft)"
                case .mf: return "Mezzo-forte (Medium Loud)"
                case .f: return "Forte (Loud)"
                case .ff: return "Fortissimo (Very Loud)"
                }
            }
        }
        
        mutating func updateComposition() {
            currentKey = MusicalKey.allCases.randomElement() ?? .cMajor
            chord = Chord.allCases.randomElement() ?? .major
            scale = Scale.allCases.randomElement() ?? .major
            improvisation = Double.random(in: 0.3...0.9)
            expression = Double.random(in: 0.4...0.95)
            dynamics = Dynamic.allCases.randomElement() ?? .mf
        }
    }
    
    // MARK: - Performance Methods
    func startPerformance() {
        isPlaying = true
        lastPerformanceTime = Date()
        flowState = .finding
        
        // Update all musical elements
        updateMusicalElements()
        
        // Start rhythm sequence
        performRhythmSequence()
    }
    
    private func updateMusicalElements() {
        marketRhythm.updateRhythm()
        musicalElements.updateElements()
        compositionData.updateComposition()
        
        // Load rhythm patterns
        rhythmPatterns = RhythmPattern.jazzPatterns
        
        // Calculate harmony and dissonance
        calculateHarmonyAndDissonance()
    }
    
    private func calculateHarmonyAndDissonance() {
        let rhythmHarmony = marketRhythm.groove * marketRhythm.pulse
        let elementHarmony = Double.random(in: 0.4...0.9)
        
        harmonyLevel = (rhythmHarmony + elementHarmony) / 2.0
        dissonanceLevel = 1.0 - harmonyLevel
        
        // Update flow state based on harmony
        updateFlowState()
    }
    
    private func updateFlowState() {
        switch harmonyLevel {
        case 0.0..<0.3:
            flowState = .outOfSync
        case 0.3..<0.5:
            flowState = .finding
        case 0.5..<0.7:
            flowState = .inSync
        case 0.7..<0.9:
            flowState = .flowing
        default:
            flowState = .masterpiece
        }
    }
    
    private func performRhythmSequence() {
        let tempos: [Tempo] = [.adagio, .andante, .moderate, .allegro, .presto]
        
        for (index, tempo) in tempos.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 1.2) {
                self.currentTempo = tempo
                self.adaptToTempo(tempo)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) {
            self.completePerformance()
        }
    }
    
    private func adaptToTempo(_ tempo: Tempo) {
        // Adjust musical elements based on tempo
        switch tempo {
        case .largo, .adagio:
            musicalElements.liquidity = .whole
            musicalElements.pullbacks = .half
        case .andante, .moderate:
            musicalElements.liquidity = .quarter
            musicalElements.pullbacks = .eighth
        case .allegro, .presto:
            musicalElements.liquidity = .eighth
            musicalElements.pullbacks = .sixteenth
        }
        
        // Recalculate harmony based on tempo
        calculateHarmonyAndDissonance()
    }
    
    private func completePerformance() {
        isPlaying = false
        flowState = .masterpiece
        currentTempo = .moderate
    }
    
    func improvise() {
        // Jazz improvisation mode
        compositionData.improvisation = min(compositionData.improvisation + 0.1, 1.0)
        musicalElements.updateElements()
        calculateHarmonyAndDissonance()
    }
    
    func activateEngine() {
        isActive = true
        startPerformance()
    }
    
    func deactivateEngine() {
        isActive = false
        isPlaying = false
        flowState = .inSync
        currentTempo = .moderate
        harmonyLevel = 0.0
        dissonanceLevel = 0.0
        rhythmPatterns.removeAll()
    }
}

#Preview {
    VStack {
        Text("Musician's Rhythm Engine")
            .font(.title)
            .padding()
    }
}