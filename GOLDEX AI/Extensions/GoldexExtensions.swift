//
//  GoldexExtensions.swift
//  GOLDEX AI
//
//  Essential Extensions for GOLDEX AI
//

import SwiftUI
import Foundation

// MARK: - Essential Color Extensions
extension Color {
    static let goldexGreen = Color.green
    static let goldexRed = Color.red
    static let goldexBlue = Color.blue
    static let goldexOrange = Color.orange
}

// MARK: - Essential Trading Direction Extensions  
extension SharedTypes.TradeDirection {
    var goldexDisplayName: String {
        switch self {
        case .buy, .long: return "BUY"
        case .sell, .short: return "SELL"
        }
    }
    
    var goldexColor: Color {
        switch self {
        case .buy, .long: return .goldexGreen
        case .sell, .short: return .goldexRed
        }
    }
    
    var goldexSystemImage: String {
        switch self {
        case .buy, .long: return "arrow.up.circle.fill"
        case .sell, .short: return "arrow.down.circle.fill"
        }
    }
}

// MARK: - Essential Trading Mode Extensions
extension SharedTypes.TradingMode {
    var goldexIcon: String {
        switch self {
        case .manual: return "hand.point.up.braille"
        case .auto: return "gearshape.2"
        case .scalp: return "bolt.fill"
        case .swing: return "waveform.path"
        case .position: return "chart.line.uptrend.xyaxis"
        case .backtest: return "clock.arrow.circlepath"
        }
    }
    
    var goldexIconName: String {
        return goldexIcon
    }
}