//
//  UnifiedTypes.swift
//  Planet ProTrader
//
//  Created by AI Assistant - FIXING BILLION DOLLAR EMPIRE
//

import Foundation
import SwiftUI

// MARK: - 🚀 UNIFIED PLANET PROTRADER TYPES - BILLION DOLLAR FOUNDATION 🚀

// MARK: - Core Trading Types
enum TradeDirection: String, Codable, CaseIterable {
    case buy = "BUY"
    case sell = "SELL"
    
    var color: Color {
        switch self {
        case .buy: return .green
        case .sell: return .red
        }
    }
    
    var icon: String {
        switch self {
        case .buy: return "arrow.up.circle.fill"
        case .sell: return "arrow.down.circle.fill"
        }
    }
    
    var arrow: String {
        switch self {
        case .buy: return "↗"
        case .sell: return "↘"
        }
    }
}

enum TradeStatus: String, Codable, CaseIterable {
    case pending = "PENDING"
    case active = "ACTIVE"
    case closed = "CLOSED"
    case cancelled = "CANCELLED"
    
    var color: Color {
        switch self {
        case .pending: return .orange
        case .active: return .blue
        case .closed: return .green
        case .cancelled: return .red
        }
    }
}

enum TradeGrade: String, CaseIterable, Codable {
    case excellent = "A+"
    case good = "A"
    case average = "B"
    case poor = "C"
    case terrible = "F"
    case elite = "ELITE" // Added for legacy compatibility
    case all = "ALL"     // Added for legacy compatibility
    
    var color: Color {
        switch self {
        case .excellent, .elite: return .green
        case .good: return .blue
        case .average: return .orange
        case .poor: return .red
        case .terrible: return .purple
        case .all: return .gray
        }
    }
}

enum RiskLevel: String, CaseIterable, Codable {
    case low = "LOW"
    case medium = "MEDIUM"  
    case high = "HIGH"
    case extreme = "EXTREME"
    
    var color: Color {
        switch self {
        case .low: return .green
        case .medium: return .yellow
        case .high: return .orange
        case .extreme: return .red
        }
    }
}

// MARK: - Chart Types
enum ChartTimeframe: String, CaseIterable, Codable {
    case m1 = "M1"
    case m5 = "M5"
    case m15 = "M15"
    case m30 = "M30"
    case h1 = "H1"
    case h4 = "H4"
    case d1 = "D1"
    case w1 = "W1"
    case mn1 = "MN1"
    
    var displayName: String { rawValue }
    
    var color: Color {
        switch self {
        case .m1: return .red
        case .m5: return .orange
        case .m15: return .yellow
        case .m30: return .green
        case .h1: return .blue
        case .h4: return .indigo
        case .d1: return .purple
        case .w1: return .pink
        case .mn1: return .brown
        }
    }
}

enum ConnectionStatus: String, CaseIterable {
    case connected = "Connected"
    case connecting = "Connecting"
    case disconnected = "Disconnected"
    case error = "Error"
    
    var color: Color {
        switch self {
        case .connected: return .green
        case .connecting: return .orange
        case .disconnected: return .gray
        case .error: return .red
        }
    }
    
    var icon: String {
        switch self {
        case .connected: return "wifi"
        case .connecting: return "wifi.slash"
        case .disconnected: return "wifi.exclamationmark"
        case .error: return "exclamationmark.triangle"
        }
    }
}

// MARK: - Toast Types
enum ToastType: String, CaseIterable {
    case success = "SUCCESS"
    case error = "ERROR"
    case warning = "WARNING"
    case info = "INFO"
    case trading = "TRADING"
    
    var color: Color {
        switch self {
        case .success: return .green
        case .error: return .red
        case .warning: return .orange
        case .info: return .blue
        case .trading: return DesignSystem.primaryGold
        }
    }
    
    var icon: String {
        switch self {
        case .success: return "checkmark.circle.fill"
        case .error: return "xmark.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .info: return "info.circle.fill"
        case .trading: return "chart.line.uptrend.xyaxis"
        }
    }
}

// MARK: - Family Mode Types
enum FamilyMemberType: String, CaseIterable, Codable {
    case parent = "Parent"
    case teenager = "Teenager"
    case child = "Child"
    case grandparent = "Grandparent"
    
    var icon: String {
        switch self {
        case .parent: return "person.fill"
        case .teenager: return "person.crop.circle"
        case .child: return "person.crop.circle.fill"
        case .grandparent: return "person.crop.square"
        }
    }
    
    var color: Color {
        switch self {
        case .parent: return .blue
        case .teenager: return .green
        case .child: return .orange
        case .grandparent: return .purple
        }
    }
}

// MARK: - Bot Types
enum BotTier: String, CaseIterable, Codable {
    case novice = "Novice"
    case intermediate = "Intermediate"
    case advanced = "Advanced"
    case expert = "Expert"
    case master = "Master"
    case legendary = "Legendary"
    
    var icon: String {
        switch self {
        case .novice: return "🤖"
        case .intermediate: return "🎯"
        case .advanced: return "⚡"
        case .expert: return "🔥"
        case .master: return "💎"
        case .legendary: return "👑"
        }
    }
    
    var color: Color {
        switch self {
        case .novice: return .gray
        case .intermediate: return .blue
        case .advanced: return .green
        case .expert: return .orange
        case .master: return .purple
        case .legendary: return DesignSystem.primaryGold
        }
    }
}

enum BotRarity: String, CaseIterable, Codable {
    case common = "Common"
    case uncommon = "Uncommon" 
    case rare = "Rare"
    case epic = "Epic"
    case legendary = "Legendary"
    case mythic = "Mythic"
    
    var sparkleEffect: String {
        switch self {
        case .common: return "⭐"
        case .uncommon: return "⭐⭐"
        case .rare: return "✨⭐⭐✨"
        case .epic: return "🌟✨⭐⭐✨🌟"
        case .legendary: return "💫🌟✨⭐⭐✨🌟💫"
        case .mythic: return "🔥💫🌟✨⭐⭐✨🌟💫🔥"
        }
    }
    
    var color: Color {
        switch self {
        case .common: return .gray
        case .uncommon: return .green
        case .rare: return .blue
        case .epic: return .purple
        case .legendary: return DesignSystem.primaryGold
        case .mythic: return .red
        }
    }
}

enum BotAvailability: String, CaseIterable, Codable {
    case available = "Available"
    case busy = "Busy"
    case offline = "Offline"
    case maintenance = "Maintenance"
    
    var color: Color {
        switch self {
        case .available: return .green
        case .busy: return .orange
        case .offline: return .gray
        case .maintenance: return .red
        }
    }
    
    var icon: String {
        switch self {
        case .available: return "checkmark.circle"
        case .busy: return "clock.circle"
        case .offline: return "xmark.circle"
        case .maintenance: return "wrench.and.screwdriver"
        }
    }
}

enum BotVerificationStatus: String, CaseIterable, Codable {
    case verified = "Verified"
    case pending = "Pending"
    case unverified = "Unverified"
    
    var color: Color {
        switch self {
        case .verified: return .green
        case .pending: return .orange
        case .unverified: return .gray
        }
    }
    
    var icon: String {
        switch self {
        case .verified: return "checkmark.seal.fill"
        case .pending: return "clock.badge.checkmark"
        case .unverified: return "questionmark.circle"
        }
    }
}

// MARK: - Error Handling Types
enum ErrorSeverity: String, CaseIterable, Codable {
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
    
    var systemImage: String {
        switch self {
        case .low: return "info.circle"
        case .medium: return "exclamationmark.circle"
        case .high: return "exclamationmark.triangle"
        case .critical: return "xmark.octagon"
        }
    }
}

// MARK: - Common Structs
struct ChartSettings: Codable {
    var showGrid: Bool = true
    var showVolume: Bool = true
    var showOrderLines: Bool = true
    var showBotSignals: Bool = true
    var showCrosshair: Bool = true
    var selectedIndicators: Set<TechnicalIndicator> = []
    var colorScheme: ChartColorScheme = .dark
    var selectedTimeframe: ChartTimeframe = .m15
    
    enum TechnicalIndicator: String, CaseIterable, Codable {
        case sma = "SMA"
        case ema = "EMA"
        case rsi = "RSI"
        case macd = "MACD"
        case bollinger = "Bollinger Bands"
    }
    
    struct ChartColorScheme: Codable {
        let backgroundColor: Color
        let gridColor: Color
        let bullCandleColor: Color
        let bearCandleColor: Color
        
        static let dark = ChartColorScheme(
            backgroundColor: .black,
            gridColor: .gray,
            bullCandleColor: .green,
            bearCandleColor: .red
        )
        
        static let light = ChartColorScheme(
            backgroundColor: .white,
            gridColor: .gray,
            bullCandleColor: .green,
            bearCandleColor: .red
        )
        
        enum CodingKeys: String, CodingKey {
            case backgroundColor, gridColor, bullCandleColor, bearCandleColor
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            backgroundColor = .black
            gridColor = .gray
            bullCandleColor = .green
            bearCandleColor = .red
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
        }
        
        init(backgroundColor: Color, gridColor: Color, bullCandleColor: Color, bearCandleColor: Color) {
            self.backgroundColor = backgroundColor
            self.gridColor = gridColor
            self.bullCandleColor = bullCandleColor
            self.bearCandleColor = bearCandleColor
        }
    }
}

// MARK: - Additional Legacy Types for Compatibility
enum TradingMode: String, CaseIterable, Codable {
    case manual = "Manual"
    case semi = "Semi-Automatic"  
    case auto = "Automatic"
    case disabled = "Disabled"
    
    var color: Color {
        switch self {
        case .manual: return .blue
        case .semi: return .orange
        case .auto: return .green
        case .disabled: return .gray
        }
    }
}

enum FlipMode: String, CaseIterable, Codable {
    case conservative = "Conservative"
    case balanced = "Balanced"
    case aggressive = "Aggressive"
}

enum BrokerType: String, CaseIterable, Codable {
    case icmarkets = "IC Markets"
    case pepperstone = "Pepperstone"
    case oanda = "OANDA"
    case coinexx = "Coinexx"
    
    var displayName: String { rawValue }
}

// MARK: - Advanced Types
struct AutoTrade: Identifiable, Codable {
    let id: UUID = UUID()
    let symbol: String
    let direction: TradeDirection
    let lotSize: Double
    let stopLoss: Double?
    let takeProfit: Double?
    let status: TradeStatus = .pending
    
    init(symbol: String, direction: TradeDirection, lotSize: Double, stopLoss: Double? = nil, takeProfit: Double? = nil) {
        self.symbol = symbol
        self.direction = direction
        self.lotSize = lotSize
        self.stopLoss = stopLoss
        self.takeProfit = takeProfit
    }
}

struct PlaybookTrade: Identifiable, Codable {
    let id: UUID = UUID()
    let symbol: String
    let direction: TradeDirection
    let entryPrice: Double
    let exitPrice: Double?
    let grade: TradeGrade
    let notes: String
    let timestamp: Date
    
    init(symbol: String, direction: TradeDirection, entryPrice: Double, exitPrice: Double? = nil, grade: TradeGrade, notes: String, timestamp: Date = Date()) {
        self.symbol = symbol
        self.direction = direction
        self.entryPrice = entryPrice
        self.exitPrice = exitPrice
        self.grade = grade
        self.notes = notes
        self.timestamp = timestamp
    }
}

struct ErrorLogModel: Identifiable, Codable {
    let id: UUID = UUID()
    let message: String
    let severity: ErrorSeverity
    let timestamp: Date
    let category: String
    
    var severityColor: Color { severity.color }
    
    static let samples: [ErrorLogModel] = [
        ErrorLogModel(message: "Sample error 1", severity: .low, timestamp: Date(), category: "Trading"),
        ErrorLogModel(message: "Sample error 2", severity: .medium, timestamp: Date(), category: "Connection"),
        ErrorLogModel(message: "Sample error 3", severity: .high, timestamp: Date(), category: "Data")
    ]
    
    init(message: String, severity: ErrorSeverity, timestamp: Date, category: String) {
        self.message = message
        self.severity = severity
        self.timestamp = timestamp
        self.category = category
    }
}

// MARK: - Sample Data Extensions
extension TradeDirection {
    static var sample: TradeDirection { .buy }
}

extension TradeStatus {
    static var sample: TradeStatus { .active }
}

extension ChartTimeframe {
    static var sample: ChartTimeframe { .m15 }
}

extension ToastType {
    static var sample: ToastType { .trading }
}

// MARK: - Color Extensions 
extension Color {
    static let planetGold = Color.yellow
    static let planetBrown = Color(red: 0.6, green: 0.4, blue: 0.2)
}

// MARK: - Compatibility Aliases for Legacy Code
typealias SharedTypes = UnifiedTypes

struct UnifiedTypes {
    typealias TradeDirection = Planet_ProTrader.TradeDirection
    typealias TradeStatus = Planet_ProTrader.TradeStatus
    typealias TradeGrade = Planet_ProTrader.TradeGrade
    typealias RiskLevel = Planet_ProTrader.RiskLevel
    typealias ChartTimeframe = Planet_ProTrader.ChartTimeframe
    typealias ConnectionStatus = Planet_ProTrader.ConnectionStatus
    typealias ToastType = Planet_ProTrader.ToastType
    typealias FamilyMemberType = Planet_ProTrader.FamilyMemberType
    typealias BotTier = Planet_ProTrader.BotTier
    typealias BotRarity = Planet_ProTrader.BotRarity
    typealias BotAvailability = Planet_ProTrader.BotAvailability
    typealias ErrorSeverity = Planet_ProTrader.ErrorSeverity
    typealias TradingMode = Planet_ProTrader.TradingMode
    typealias FlipMode = Planet_ProTrader.FlipMode
    typealias BrokerType = Planet_ProTrader.BrokerType
    typealias AutoTrade = Planet_ProTrader.AutoTrade
    typealias PlaybookTrade = Planet_ProTrader.PlaybookTrade
    typealias ErrorLogModel = Planet_ProTrader.ErrorLogModel
}

// MARK: - Missing Classes for Compatibility
class EAAccountManager: ObservableObject {
    static let shared = EAAccountManager()
    @Published var isConnected = false
    @Published var balance = 10000.0
    private init() {}
}

struct MT5Account {
    let id: String
    let name: String
    let balance: Double
}

struct MT5Trade {
    let id: String
    let symbol: String
    let direction: TradeDirection
    let volume: Double
    let profit: Double
}