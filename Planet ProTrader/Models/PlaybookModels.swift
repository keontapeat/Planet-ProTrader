//
//  PlaybookModels.swift
//  Planet ProTrader
//
//  Created by AI Assistant
//

import SwiftUI
import Foundation

// MARK: - Core Data Models

struct PlaybookTrade: Identifiable, Codable {
    let id: String
    let symbol: String
    let direction: TradeDirection
    let entryPrice: Double
    var exitPrice: Double?
    let stopLoss: Double
    let takeProfit: Double
    let lotSize: Double
    var pnl: Double
    var rMultiple: Double
    var result: TradeResult
    var grade: TradeGrade
    let setupDescription: String
    let emotionalState: String
    let timestamp: Date
    let emotionalRating: Int // 1-5 scale
    
    enum TradeResult: String, CaseIterable, Codable {
        case win = "WIN"
        case loss = "LOSS"
        case breakeven = "BREAKEVEN"
        case running = "RUNNING"
        
        var color: Color {
            switch self {
            case .win: return .green
            case .loss: return .red
            case .breakeven: return .orange
            case .running: return .blue
            }
        }
    }
}

enum TradeDirection: String, CaseIterable, Codable {
    case buy = "BUY"
    case sell = "SELL"
    
    var color: Color {
        switch self {
        case .buy: return .green
        case .sell: return .red
        }
    }
}

enum TradeGrade: String, CaseIterable, Codable {
    case all = "ALL"
    case elite = "A+ ELITE"
    case good = "A GOOD"
    case average = "B AVERAGE"
    case poor = "C POOR"
    
    var color: Color {
        switch self {
        case .all: return .gray
        case .elite: return .purple
        case .good: return .green
        case .average: return .orange
        case .poor: return .red
        }
    }
    
    var description: String {
        switch self {
        case .all: return "All trades"
        case .elite: return "Perfect execution, Mark Douglas would be proud"
        case .good: return "Solid trade with minor improvements possible"
        case .average: return "Acceptable but needs refinement"
        case .poor: return "Learning opportunity, review psychology"
        }
    }
}

struct JournalEntry: Identifiable, Codable {
    let id: String
    let timestamp: Date
    let type: EntryType
    let title: String
    let content: String
    let emotionalRating: Int
    let markDouglasLesson: String
    
    enum EntryType: String, CaseIterable, Codable {
        case tradeAnalysis = "TRADE ANALYSIS"
        case dailyReview = "DAILY REVIEW"
        case psychologyNote = "PSYCHOLOGY NOTE"
        case marketObservation = "MARKET OBSERVATION"
        case improvement = "IMPROVEMENT PLAN"
        
        var icon: String {
            switch self {
            case .tradeAnalysis: return "chart.line.uptrend.xyaxis"
            case .dailyReview: return "calendar"
            case .psychologyNote: return "brain.head.profile"
            case .marketObservation: return "eye"
            case .improvement: return "arrow.up.circle"
            }
        }
    }
}

// MARK: - Psychology Engine Models

enum EmotionalState: String, CaseIterable {
    case calm = "CALM"
    case confident = "CONFIDENT"
    case anxious = "ANXIOUS"
    case frustrated = "FRUSTRATED"
    case euphoric = "EUPHORIC"
    case fearful = "FEARFUL"
    
    var color: Color {
        switch self {
        case .calm, .confident: return .green
        case .anxious, .fearful: return .orange
        case .frustrated: return .red
        case .euphoric: return .purple
        }
    }
}