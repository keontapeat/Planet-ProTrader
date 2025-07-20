//
//  EnhancedTypes.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 7/19/25.
//  Enhanced types for GOLDEX AI trading system
//

import Foundation
import SwiftUI

// MARK: - Enhanced Trading Pattern

struct EnhancedTradingPattern: Identifiable, Codable {
    let id: UUID
    let name: String
    let type: PatternType
    let confidence: Double
    let timestamp: Date
    let frequency: Int
    let successRate: Double
    let averageProfit: Double
    let riskLevel: RiskLevel
    let description: String
    let conditions: [String]
    let triggers: [String]
    
    enum PatternType: String, Codable, CaseIterable {
        case bullish = "Bullish"
        case bearish = "Bearish"
        case reversal = "Reversal"
        case continuation = "Continuation"
        case breakout = "Breakout"
        case consolidation = "Consolidation"
        case divergence = "Divergence"
        case trendFollowing = "Trend Following"
        case meanReversion = "Mean Reversion"
        case volatilityExpansion = "Volatility Expansion"
        
        var color: Color {
            switch self {
            case .bullish: return .green
            case .bearish: return .red
            case .reversal: return .purple
            case .continuation: return .blue
            case .breakout: return .orange
            case .consolidation: return .gray
            case .divergence: return .mint
            case .trendFollowing: return .indigo
            case .meanReversion: return .cyan
            case .volatilityExpansion: return .yellow
            }
        }
        
        var systemImage: String {
            switch self {
            case .bullish: return "arrow.up.right.circle"
            case .bearish: return "arrow.down.right.circle"
            case .reversal: return "arrow.uturn.up.circle"
            case .continuation: return "arrow.right.circle"
            case .breakout: return "bolt.circle"
            case .consolidation: return "minus.circle"
            case .divergence: return "arrow.triangle.branch"
            case .trendFollowing: return "arrow.up.forward.circle"
            case .meanReversion: return "arrow.counterclockwise.circle"
            case .volatilityExpansion: return "waveform.circle"
            }
        }
    }
    
    enum RiskLevel: String, Codable, CaseIterable {
        case low = "Low"
        case medium = "Medium"
        case high = "High"
        case extreme = "Extreme"
        
        var color: Color {
            switch self {
            case .low: return .green
            case .medium: return .yellow
            case .high: return .orange
            case .extreme: return .red
            }
        }
    }
    
    init(
        id: UUID = UUID(),
        name: String,
        type: PatternType,
        confidence: Double,
        timestamp: Date = Date(),
        frequency: Int = 0,
        successRate: Double = 0.0,
        averageProfit: Double = 0.0,
        riskLevel: RiskLevel = .medium,
        description: String = "",
        conditions: [String] = [],
        triggers: [String] = []
    ) {
        self.id = id
        self.name = name
        self.type = type
        self.confidence = confidence
        self.timestamp = timestamp
        self.frequency = frequency
        self.successRate = successRate
        self.averageProfit = averageProfit
        self.riskLevel = riskLevel
        self.description = description
        self.conditions = conditions
        self.triggers = triggers
    }
    
    var formattedConfidence: String {
        String(format: "%.1f%%", confidence * 100)
    }
    
    var formattedSuccessRate: String {
        String(format: "%.1f%%", successRate * 100)
    }
    
    var formattedAverageProfit: String {
        let sign = averageProfit >= 0 ? "+" : ""
        return "\(sign)$\(String(format: "%.2f", averageProfit))"
    }
    
    var isReliable: Bool {
        confidence > 0.8 && successRate > 0.7 && frequency >= 5
    }
    
    var effectivenessScore: Double {
        (confidence + successRate) / 2.0
    }
    
    var grade: String {
        let score = effectivenessScore
        if score >= 0.9 {
            return "Elite"
        } else if score >= 0.8 {
            return "Excellent"
        } else if score >= 0.7 {
            return "Good"
        } else if score >= 0.6 {
            return "Average"
        } else {
            return "Poor"
        }
    }
    
    var gradeColor: Color {
        let score = effectivenessScore
        if score >= 0.9 {
            return .purple
        } else if score >= 0.8 {
            return .green
        } else if score >= 0.7 {
            return .mint
        } else if score >= 0.6 {
            return .yellow
        } else {
            return .red
        }
    }
}

// MARK: - Enhanced Code Analysis Result

struct EnhancedCodeAnalysisResult: Identifiable {
    let id: UUID
    let fileName: String
    let lineNumber: Int
    let columnNumber: Int
    let severity: AnalysisSeverity
    let category: AnalysisCategory
    let title: String
    let message: String
    let suggestion: String?
    let codeSnippet: String?
    let isAutoFixable: Bool
    let confidence: Double
    let timestamp: Date
    
    enum AnalysisSeverity: String, CaseIterable {
        case info = "Info"
        case warning = "Warning"
        case error = "Error"
        case critical = "Critical"
        
        var color: Color {
            switch self {
            case .info: return .blue
            case .warning: return .orange
            case .error: return .red
            case .critical: return .purple
            }
        }
    }
    
    enum AnalysisCategory: String, CaseIterable {
        case syntax = "Syntax"
        case logic = "Logic"
        case performance = "Performance"
        case memory = "Memory"
        case security = "Security"
        case style = "Style"
        case bestPractice = "Best Practice"
        
        var systemImage: String {
            switch self {
            case .syntax: return "text.book.closed"
            case .logic: return "brain"
            case .performance: return "speedometer"
            case .memory: return "memorychip"
            case .security: return "lock.shield"
            case .style: return "paintbrush"
            case .bestPractice: return "star"
            }
        }
    }
    
    init(
        id: UUID = UUID(),
        fileName: String,
        lineNumber: Int,
        columnNumber: Int = 0,
        severity: AnalysisSeverity,
        category: AnalysisCategory,
        title: String,
        message: String,
        suggestion: String? = nil,
        codeSnippet: String? = nil,
        isAutoFixable: Bool = false,
        confidence: Double = 1.0,
        timestamp: Date = Date()
    ) {
        self.id = id
        self.fileName = fileName
        self.lineNumber = lineNumber
        self.columnNumber = columnNumber
        self.severity = severity
        self.category = category
        self.title = title
        self.message = message
        self.suggestion = suggestion
        self.codeSnippet = codeSnippet
        self.isAutoFixable = isAutoFixable
        self.confidence = confidence
        self.timestamp = timestamp
    }
    
    var location: String {
        "\(fileName):\(lineNumber):\(columnNumber)"
    }
    
    var formattedConfidence: String {
        String(format: "%.1f%%", confidence * 100)
    }
    
    var priorityScore: Int {
        switch severity {
        case .info: return 1
        case .warning: return 2
        case .error: return 3
        case .critical: return 4
        }
    }
}

// MARK: - Enhanced Learning Session

struct EnhancedLearningSession: Identifiable, Codable {
    let id: UUID
    let timestamp: Date
    let dataPoints: Int
    let xpGained: Double
    let confidenceGained: Double
    let patterns: [String]
    let duration: TimeInterval
    let aiEngineUsed: String
    let marketConditions: String
    let tradingOpportunities: Int
    let riskAssessment: String
    
    init(
        id: UUID = UUID(),
        timestamp: Date = Date(),
        dataPoints: Int,
        xpGained: Double,
        confidenceGained: Double,
        patterns: [String] = [],
        duration: TimeInterval = 0,
        aiEngineUsed: String = "GOLDEX Neural Network",
        marketConditions: String = "Normal",
        tradingOpportunities: Int = 0,
        riskAssessment: String = "Moderate"
    ) {
        self.id = id
        self.timestamp = timestamp
        self.dataPoints = dataPoints
        self.xpGained = xpGained
        self.confidenceGained = confidenceGained
        self.patterns = patterns
        self.duration = duration
        self.aiEngineUsed = aiEngineUsed
        self.marketConditions = marketConditions
        self.tradingOpportunities = tradingOpportunities
        self.riskAssessment = riskAssessment
    }
    
    var formattedDuration: String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return "\(minutes)m \(seconds)s"
    }
    
    var formattedXP: String {
        String(format: "%.1f XP", xpGained)
    }
    
    var formattedConfidence: String {
        String(format: "%.2f%%", confidenceGained * 100)
    }
    
    var efficiency: Double {
        duration > 0 ? Double(dataPoints) / duration : 0
    }
    
    var formattedEfficiency: String {
        String(format: "%.1f points/sec", efficiency)
    }
}

// MARK: - Enhanced Gold Data Point

struct EnhancedGoldDataPoint: Identifiable, Codable {
    let id: UUID
    let timestamp: Date
    let open: Double
    let high: Double
    let low: Double
    let close: Double
    let volume: Double?
    let source: DataSource
    let reliability: Double
    let marketSession: String
    let volatility: Double
    
    enum DataSource: String, Codable, CaseIterable {
        case mt5 = "MT5"
        case bloomberg = "Bloomberg"
        case yahoo = "Yahoo Finance"
        case alphavantage = "Alpha Vantage"
        case goldapi = "GoldAPI"
        case synthetic = "Synthetic"
        
        var reliability: Double {
            switch self {
            case .mt5, .bloomberg: return 0.99
            case .alphavantage: return 0.95
            case .yahoo: return 0.90
            case .goldapi: return 0.85
            case .synthetic: return 0.70
            }
        }
    }
    
    init(
        id: UUID = UUID(),
        timestamp: Date,
        open: Double,
        high: Double,
        low: Double,
        close: Double,
        volume: Double? = nil,
        source: DataSource = .mt5,
        marketSession: String = "London",
        volatility: Double = 0.0
    ) {
        self.id = id
        self.timestamp = timestamp
        self.open = open
        self.high = high
        self.low = low
        self.close = close
        self.volume = volume
        self.source = source
        self.reliability = source.reliability
        self.marketSession = marketSession
        self.volatility = volatility
    }
    
    var isBullish: Bool {
        close > open
    }
    
    var bodySize: Double {
        abs(close - open)
    }
    
    var range: Double {
        high - low
    }
    
    var upperWick: Double {
        high - max(open, close)
    }
    
    var lowerWick: Double {
        min(open, close) - low
    }
    
    var formattedPrice: String {
        String(format: "%.2f", close)
    }
    
    var candleType: String {
        if bodySize < range * 0.1 {
            return "Doji"
        } else if bodySize > range * 0.8 {
            return isBullish ? "Strong Bull" : "Strong Bear"
        } else {
            return isBullish ? "Bullish" : "Bearish"
        }
    }
    
    var color: Color {
        isBullish ? .green : .red
    }
}

// MARK: - Enhanced Training Results

struct EnhancedTrainingResults: Codable {
    var botsProcessed: Int = 0
    var xpGained: Double = 0.0
    var avgConfidence: Double = 0.0
    var godmodeBots: Int = 0
    var eliteBots: Int = 0
    var trainingTime: Double = 0.0
    var patterns: [String] = []
    var errors: [String] = []
    var insights: [String] = []
    var recommendations: [String] = []
    
    var summary: String {
        """
        🚀 Enhanced Training Complete!
        
        📊 Bots Processed: \(botsProcessed)
        ⭐ Total XP Gained: \(Int(xpGained))
        🧠 Avg Confidence: \(String(format: "%.2f%%", avgConfidence))
        👑 Godmode Bots: \(godmodeBots)
        💎 Elite Bots: \(eliteBots)
        ⏱️ Training Time: \(String(format: "%.2f", trainingTime))s
        🎯 Patterns Found: \(patterns.count)
        
        Your AI army has evolved to the next level!
        """
    }
    
    var efficiency: Double {
        trainingTime > 0 ? Double(botsProcessed) / trainingTime : 0
    }
    
    var formattedEfficiency: String {
        String(format: "%.1f bots/sec", efficiency)
    }
    
    var qualityScore: Double {
        let godmodeWeight = 0.4
        let eliteWeight = 0.3
        let confidenceWeight = 0.2
        let efficiencyWeight = 0.1
        
        let godmodeScore = botsProcessed > 0 ? Double(godmodeBots) / Double(botsProcessed) : 0
        let eliteScore = botsProcessed > 0 ? Double(eliteBots) / Double(botsProcessed) : 0
        let normalizedEfficiency = min(efficiency / 10.0, 1.0)
        
        return (godmodeScore * godmodeWeight) +
               (eliteScore * eliteWeight) +
               (avgConfidence * confidenceWeight) +
               (normalizedEfficiency * efficiencyWeight)
    }
    
    var grade: String {
        let score = qualityScore
        if score >= 0.9 {
            return "S+ Legendary"
        } else if score >= 0.8 {
            return "S Elite"
        } else if score >= 0.7 {
            return "A Excellent"
        } else if score >= 0.6 {
            return "B Good"
        } else if score >= 0.5 {
            return "C Average"
        } else {
            return "D Needs Improvement"
        }
    }
    
    var gradeColor: Color {
        let score = qualityScore
        if score >= 0.9 {
            return .purple
        } else if score >= 0.8 {
            return .green
        } else if score >= 0.7 {
            return .mint
        } else if score >= 0.6 {
            return .blue
        } else if score >= 0.5 {
            return .yellow
        } else {
            return .red
        }
    }
}

// MARK: - Sample Data Extensions

extension EnhancedTradingPattern {
    static let samplePatterns: [EnhancedTradingPattern] = [
        EnhancedTradingPattern(
            name: "London Breakout Elite",
            type: .breakout,
            confidence: 0.94,
            frequency: 28,
            successRate: 0.87,
            averageProfit: 52.30,
            riskLevel: .medium,
            description: "Advanced gold breakout pattern during London session with institutional flow confirmation",
            conditions: ["Price above 20 EMA", "Volume spike > 150%", "London session active", "Smart money flow positive"],
            triggers: ["Break of previous day high", "Strong institutional volume", "RSI > 60", "MACD bullish crossover"]
        ),
        EnhancedTradingPattern(
            name: "NY Reversal Pro",
            type: .reversal,
            confidence: 0.91,
            frequency: 22,
            successRate: 0.89,
            averageProfit: 71.80,
            riskLevel: .low,
            description: "Professional mean reversion pattern during NY session with sentiment confirmation",
            conditions: ["RSI extreme levels", "MACD divergence", "Key level rejection", "Sentiment extreme"],
            triggers: ["Double top/bottom formation", "Volume confirmation", "Divergence confirmation", "Level test"]
        )
    ]
}

extension EnhancedCodeAnalysisResult {
    static let sampleResults: [EnhancedCodeAnalysisResult] = [
        EnhancedCodeAnalysisResult(
            fileName: "TradingViewModel.swift",
            lineNumber: 89,
            severity: .warning,
            category: .bestPractice,
            title: "UI Thread Violation",
            message: "State update on background thread detected",
            suggestion: "Add @MainActor or use DispatchQueue.main.async",
            isAutoFixable: true,
            confidence: 0.95
        ),
        EnhancedCodeAnalysisResult(
            fileName: "ImageCache.swift",
            lineNumber: 245,
            severity: .error,
            category: .memory,
            title: "Memory Leak",
            message: "Strong reference cycle detected in closure",
            suggestion: "Use [weak self] in closure to break reference cycle",
            isAutoFixable: false,
            confidence: 0.88
        )
    ]
}

extension EnhancedGoldDataPoint {
    static let sampleData: [EnhancedGoldDataPoint] = [
        EnhancedGoldDataPoint(
            timestamp: Date().addingTimeInterval(-3600),
            open: 2674.50,
            high: 2678.90,
            low: 2672.10,
            close: 2676.80,
            volume: 1250.0,
            source: .mt5,
            marketSession: "London",
            volatility: 0.25
        ),
        EnhancedGoldDataPoint(
            timestamp: Date().addingTimeInterval(-1800),
            open: 2676.80,
            high: 2680.20,
            low: 2674.30,
            close: 2678.50,
            volume: 1890.0,
            source: .bloomberg,
            marketSession: "NY",
            volatility: 0.30
        ),
        EnhancedGoldDataPoint(
            timestamp: Date(),
            open: 2678.50,
            high: 2682.10,
            low: 2676.90,
            close: 2680.30,
            volume: 2150.0,
            source: .mt5,
            marketSession: "NY",
            volatility: 0.35
        )
    ]
}

// MARK: - Preview

#if DEBUG
struct EnhancedTypesPreview: View {
    let samplePattern = EnhancedTradingPattern.samplePatterns[0]
    let sampleData = EnhancedGoldDataPoint.sampleData[0]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Enhanced Trading Pattern Preview
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Enhanced Trading Pattern")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        HStack {
                            Image(systemName: samplePattern.type.systemImage)
                                .foregroundColor(samplePattern.type.color)
                                .font(.title2)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(samplePattern.name)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                
                                Text(samplePattern.type.rawValue)
                                    .font(.caption)
                                    .foregroundColor(samplePattern.type.color)
                                
                                Text("Success: \(samplePattern.formattedSuccessRate)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                
                                Text("Profit: \(samplePattern.formattedAverageProfit)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing, spacing: 4) {
                                Text(samplePattern.grade)
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .foregroundColor(samplePattern.gradeColor)
                                
                                Text(samplePattern.formattedConfidence)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                
                                Text("Freq: \(samplePattern.frequency)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        Text(samplePattern.description)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.leading)
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    
                    // Enhanced Gold Data Point Preview
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Enhanced Gold Data")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        HStack {
                            Rectangle()
                                .fill(sampleData.color)
                                .frame(width: 4, height: 40)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(sampleData.formattedPrice)
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundColor(sampleData.color)
                                
                                Text(sampleData.candleType)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                
                                Text("\(sampleData.source.rawValue) • \(sampleData.marketSession)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing, spacing: 4) {
                                Text("H: \(String(format: "%.2f", sampleData.high))")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                
                                Text("L: \(String(format: "%.2f", sampleData.low))")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                
                                Text("Vol: \(String(format: "%.0f", sampleData.volume ?? 0))")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                }
                .padding()
            }
            .navigationTitle("Enhanced Types")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct EnhancedTypes_Previews: PreviewProvider {
    static var previews: some View {
        EnhancedTypesPreview()
            .preferredColorScheme(.light)
    }
}
#endif