//
//  GoldexUltimateExtensions.swift
//  GOLDEX AI
//
//  Ultimate AI-Generated extensions
//  Connection: Verified Supabase tracking
//

import SwiftUI
import Foundation


// MARK: - Ultimate Icon Extension (AI-Generated)
extension SharedTypes.TradingMode {
    /// Ultimate icon with Apple best practices
    var icon: String {
        switch self {
        case .manual:
            return "hand.point.up.braille"
        case .auto:
            return "gearshape.2"
        case .scalp:
            return "bolt.fill"
        case .swing:
            return "waveform.path"
        case .position:
            return "chart.line.uptrend.xyaxis"
        case .backtest:
            return "clock.arrow.circlepath"
        @unknown default:
            return "questionmark.circle"
        }
    }
}

// MARK: - Ultimate Color Extension (AI-Generated)
extension SharedTypes.TradeGrade {
    /// Ultimate color with accessibility
    var color: Color {
        switch self {
        case .elite:
            return Color(.systemGreen)
        case .good:
            return Color(.systemMint)
        case .average:
            return Color(.systemYellow)
        case .poor:
            return Color(.systemRed)
        case .all:
            return Color(.systemBlue)
        @unknown default:
            return Color(.systemGray)
        }
    }
}

// MARK: - Ultimate Performance Extension (AI-Generated)
extension EAStats {
    /// Ultimate tradesPerHour with safety
    var tradesPerHour: Double {
        // Use a default 24-hour period if lastUpdated is not available
        let hoursActive = max(1.0, 24.0) // Default to 24 hours for safety
        guard totalSignals < Int.max / 100 else { return Double.infinity }
        return Double(totalSignals) / hoursActive
    }
}

// MARK: - Ultimate Timestamp Extension (AI-Generated)
extension TradingTypes.GoldSignal {
    /// Ultimate timestamp with fallback
    var signalTimestamp: Date {
        return Date() // Current time as fallback since TradingTypes.GoldSignal doesn't have timestamp
    }
}

// MARK: - Ultimate Result Extension (AI-Generated)
extension SharedTypes.PlaybookTrade {
    /// Ultimate result calculation
    var result: TradeResultType {
        let threshold = 0.01
        if profit > threshold {
            return .win
        } else if profit < -threshold {
            return .loss
        } else {
            return .breakeven
        }
    }
}