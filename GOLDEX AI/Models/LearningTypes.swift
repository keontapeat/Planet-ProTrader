//
//  LearningTypes.swift
//  GOLDEX AI
//
//  Created by Goldex AI on 7/19/25.
//

import Foundation
import SwiftUI

// MARK: - Learning Types

struct LearningInsight {
    let id = UUID()
    let type: LearningEventType
    let title: String
    let description: String
    let confidence: Double
    let priority: InsightPriority
    let impact: InsightImpact
    let recommendation: String
    let timestamp: Date
    
    init(
        type: LearningEventType,
        title: String,
        description: String,
        impact: InsightImpact,
        recommendation: String,
        confidence: Double = 0.85,
        priority: InsightPriority = .medium,
        timestamp: Date = Date()
    ) {
        self.type = type
        self.title = title
        self.description = description
        self.confidence = confidence
        self.priority = priority
        self.impact = impact
        self.recommendation = recommendation
        self.timestamp = timestamp
    }
}

enum LearningEventType: String, CaseIterable, Codable {
    case pattern = "Pattern"
    case session = "Session"
    case model = "Model"
    case performance = "Performance"
    case risk = "Risk"
    case optimization = "Optimization"
    case regime = "Market Regime"
    case strategy = "Strategy"
    
    var color: Color {
        switch self {
        case .pattern: return .blue
        case .session: return .green
        case .model: return .purple
        case .performance: return .orange
        case .risk: return .red
        case .optimization: return .mint
        case .regime: return .indigo
        case .strategy: return .yellow
        }
    }
    
    var icon: String {
        switch self {
        case .pattern: return "waveform.path"
        case .session: return "clock.circle"
        case .model: return "brain.head.profile"
        case .performance: return "chart.bar"
        case .risk: return "exclamationmark.triangle"
        case .optimization: return "arrow.up.circle"
        case .regime: return "chart.xyaxis.line"
        case .strategy: return "target"
        }
    }
}

enum InsightPriority: String, CaseIterable, Codable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    case critical = "Critical"
    
    var color: Color {
        switch self {
        case .low: return .gray
        case .medium: return .blue
        case .high: return .orange
        case .critical: return .red
        }
    }
    
    var weight: Int {
        switch self {
        case .low: return 1
        case .medium: return 2
        case .high: return 3
        case .critical: return 4
        }
    }
}

enum InsightImpact: String, CaseIterable, Codable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    case critical = "Critical"
    
    var color: Color {
        switch self {
        case .low: return .green
        case .medium: return .yellow
        case .high: return .orange
        case .critical: return .red
        }
    }
    
    var description: String {
        switch self {
        case .low: return "Minimal impact on performance"
        case .medium: return "Moderate impact on performance"
        case .high: return "Significant impact on performance"
        case .critical: return "Critical impact on performance"
        }
    }
}

struct LearningEvent {
    let id = UUID()
    let timestamp: Date
    let type: LearningEventType
    let description: String
    let data: [String: Any]
    let confidence: Double
    let priority: InsightImpact
    let source: String
    
    init(
        timestamp: Date = Date(),
        type: LearningEventType,
        description: String,
        data: [String: Any] = [:],
        confidence: Double = 0.8,
        priority: InsightImpact = .medium,
        source: String = "System"
    ) {
        self.timestamp = timestamp
        self.type = type
        self.description = description
        self.data = data
        self.confidence = confidence
        self.priority = priority
        self.source = source
    }
}

typealias LearningPriority = InsightPriority