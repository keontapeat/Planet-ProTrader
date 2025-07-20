//
//  MissingTypes.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 1/27/25.
//  Missing type definitions to fix compilation
//

import Foundation
import SwiftUI

// MARK: - VPS Types
struct VPSInstance: Identifiable, Codable {
    let id: UUID
    let name: String
    let ipAddress: String
    let status: VPSStatus
    let accountsRunning: Int
    let maxAccounts: Int
    let location: String
    let performance: Double
    
    init(id: UUID = UUID(), name: String, ipAddress: String, status: VPSStatus = .disconnected, accountsRunning: Int = 0, maxAccounts: Int = 5, location: String = "Unknown", performance: Double = 0.0) {
        self.id = id
        self.name = name
        self.ipAddress = ipAddress
        self.status = status
        self.accountsRunning = accountsRunning
        self.maxAccounts = maxAccounts
        self.location = location
        self.performance = performance
    }
    
    enum VPSStatus: String, CaseIterable, Codable {
        case connected = "Connected"
        case disconnected = "Disconnected"
        case connecting = "Connecting"
        case error = "Error"
        
        var color: Color {
            switch self {
            case .connected: return .green
            case .disconnected: return .gray
            case .connecting: return .orange
            case .error: return .red
            }
        }
    }
}

// MARK: - Bot Store Types
enum BotAvailability: String, CaseIterable, Codable {
    case available = "Available"
    case comingSoon = "Coming Soon"
    case exclusive = "Exclusive"
    case soldOut = "Sold Out"
    
    var displayName: String { rawValue }
    
    var color: Color {
        switch self {
        case .available: return .green
        case .comingSoon: return .blue
        case .exclusive: return .purple
        case .soldOut: return .gray
        }
    }
}

// MARK: - Bot Trading History
struct BotTradingHistory: Codable {
    let botId: String
    let trades: [TradeRecord]
    let totalProfit: Double
    let winRate: Double
    
    struct TradeRecord: Identifiable, Codable {
        let id: UUID
        let symbol: String
        let direction: SharedTypes.TradeDirection
        let entryPrice: Double
        let exitPrice: Double
        let profit: Double
        let timestamp: Date
        let lotSize: Double
        
        init(id: UUID = UUID(), symbol: String, direction: SharedTypes.TradeDirection, entryPrice: Double, exitPrice: Double, profit: Double, timestamp: Date = Date(), lotSize: Double = 0.01) {
            self.id = id
            self.symbol = symbol
            self.direction = direction
            self.entryPrice = entryPrice
            self.exitPrice = exitPrice
            self.profit = profit
            self.timestamp = timestamp
            self.lotSize = lotSize
        }
        
        var formattedProfit: String {
            let sign = profit >= 0 ? "+" : ""
            return "\(sign)$\(String(format: "%.2f", profit))"
        }
        
        var profitColor: Color {
            profit >= 0 ? .green : .red
        }
    }
}

// MARK: - Bot Review
struct BotReview: Identifiable, Codable {
    let id: UUID
    let userId: String
    let botId: String
    let rating: Int
    let title: String
    let comment: String
    let date: Date
    let verified: Bool
    
    init(id: UUID = UUID(), userId: String, botId: String, rating: Int, title: String, comment: String, date: Date = Date(), verified: Bool = false) {
        self.id = id
        self.userId = userId
        self.botId = botId
        self.rating = max(1, min(5, rating))
        self.title = title
        self.comment = comment
        self.date = date
        self.verified = verified
    }
    
    var formattedRating: String {
        String(repeating: "⭐", count: rating) + String(repeating: "☆", count: 5 - rating)
    }
}

// MARK: - Bot Special Abilities
struct BotSpecialAbility: Identifiable, Codable {
    let id: UUID
    let name: String
    let description: String
    let type: AbilityType
    let rarity: Rarity
    let effectiveness: Double
    let energyCost: Int
    
    init(id: UUID = UUID(), name: String, description: String, type: AbilityType, rarity: Rarity = .common, effectiveness: Double = 0.5, energyCost: Int = 10) {
        self.id = id
        self.name = name
        self.description = description
        self.type = type
        self.rarity = rarity
        self.effectiveness = effectiveness
        self.energyCost = energyCost
    }
    
    enum AbilityType: String, CaseIterable, Codable {
        case trading = "Trading"
        case analysis = "Analysis"
        case riskManagement = "Risk Management"
        case prediction = "Prediction"
        case optimization = "Optimization"
        
        var icon: String {
            switch self {
            case .trading: return "chart.xyaxis.line"
            case .analysis: return "magnifyingglass"
            case .riskManagement: return "shield.checkered"
            case .prediction: return "crystal.ball"
            case .optimization: return "speedometer"
            }
        }
    }
    
    enum Rarity: String, CaseIterable, Codable {
        case common = "Common"
        case uncommon = "Uncommon"
        case rare = "Rare"
        case epic = "Epic"
        case legendary = "Legendary"
        
        var color: Color {
            switch self {
            case .common: return .gray
            case .uncommon: return .green
            case .rare: return .blue
            case .epic: return .purple
            case .legendary: return .orange
            }
        }
    }
}

// MARK: - Debug Types (if they don't exist elsewhere)
struct DebugSession: Identifiable, Codable {
    let id: UUID
    let type: SharedTypes.SessionType
    let startTime: Date
    var endTime: Date?
    var status: SessionStatus
    var findings: [DebugFinding]
    
    init(id: UUID = UUID(), type: SharedTypes.SessionType, startTime: Date = Date(), endTime: Date? = nil, status: SessionStatus = .running, findings: [DebugFinding] = []) {
        self.id = id
        self.type = type
        self.startTime = startTime
        self.endTime = endTime
        self.status = status
        self.findings = findings
    }
    
    enum SessionStatus: String, Codable {
        case running = "Running"
        case completed = "Completed"
        case completedWithIssues = "Completed with Issues"
        case failed = "Failed"
    }
}

struct DebugFinding: Identifiable, Codable {
    let id: UUID
    let type: SharedTypes.FindingType
    let severity: DebugSeverity
    let message: String
    let suggestion: String?
    let timestamp: Date
    let confidence: Double?
    let documentationURL: String?
    let codeExample: String?
    
    init(id: UUID = UUID(), type: SharedTypes.FindingType, severity: DebugSeverity, message: String, suggestion: String? = nil, timestamp: Date = Date(), confidence: Double? = nil, documentationURL: String? = nil, codeExample: String? = nil) {
        self.id = id
        self.type = type
        self.severity = severity
        self.message = message
        self.suggestion = suggestion
        self.timestamp = timestamp
        self.confidence = confidence
        self.documentationURL = documentationURL
        self.codeExample = codeExample
    }
}

enum DebugSeverity: String, CaseIterable, Codable {
    case info = "Info"
    case warning = "Warning"
    case error = "Error"
    case critical = "Critical"
    case performance = "Performance"
    
    var color: Color {
        switch self {
        case .info: return .blue
        case .warning: return .yellow
        case .error: return .red
        case .critical: return .purple
        case .performance: return .orange
        }
    }
}

// MARK: - Additional Error Types
struct ErrorLog: Identifiable, Codable {
    let id: UUID
    let type: ErrorType
    let timestamp: Date
    let fileName: String
    let functionName: String
    let lineNumber: Int
    let errorDomain: String
    let errorCode: Int
    let errorMessage: String
    let context: String
    let stackTrace: String?
    let deviceInfo: String
    var occurrenceCount: Int
    var isFixed: Bool
    var fixAppliedAt: Date?
    var fixMethod: String?
    
    init(id: UUID = UUID(), type: ErrorType, timestamp: Date = Date(), fileName: String, functionName: String, lineNumber: Int, errorDomain: String, errorCode: Int, errorMessage: String, context: String = "", stackTrace: String? = nil, deviceInfo: String = "", occurrenceCount: Int = 1, isFixed: Bool = false, fixAppliedAt: Date? = nil, fixMethod: String? = nil) {
        self.id = id
        self.type = type
        self.timestamp = timestamp
        self.fileName = fileName
        self.functionName = functionName
        self.lineNumber = lineNumber
        self.errorDomain = errorDomain
        self.errorCode = errorCode
        self.errorMessage = errorMessage
        self.context = context
        self.stackTrace = stackTrace
        self.deviceInfo = deviceInfo
        self.occurrenceCount = occurrenceCount
        self.isFixed = isFixed
        self.fixAppliedAt = fixAppliedAt
        self.fixMethod = fixMethod
    }
    
    enum ErrorType: String, CaseIterable, Codable {
        case runtime = "Runtime"
        case logic = "Logic"
        case network = "Network"
        case ui = "UI"
        case data = "Data"
        case memory = "Memory"
        case memoryLeak = "Memory Leak"
        case performance = "Performance"
    }
}

struct FixSuggestion: Identifiable, Codable {
    let id: UUID
    let errorId: UUID
    let type: FixType
    let title: String
    let description: String
    let codeExample: String?
    let confidence: Double
    let isAutoApplicable: Bool
    let timestamp: Date
    
    init(id: UUID = UUID(), errorId: UUID, type: FixType, title: String, description: String, codeExample: String? = nil, confidence: Double, isAutoApplicable: Bool = false, timestamp: Date = Date()) {
        self.id = id
        self.errorId = errorId
        self.type = type
        self.title = title
        self.description = description
        self.codeExample = codeExample
        self.confidence = confidence
        self.isAutoApplicable = isAutoApplicable
        self.timestamp = timestamp
    }
    
    enum FixType: String, CaseIterable, Codable {
        case codeModification = "Code Modification"
        case configuration = "Configuration"
        case dependency = "Dependency"
        case architecture = "Architecture"
        case performance = "Performance"
    }
}

struct LearnedPattern: Identifiable, Codable {
    let id: UUID
    let patternType: String
    let signature: String
    let occurrences: Int
    let lastSeen: Date
    let confidence: Double
    let suggestedFix: String
    let preventionStrategy: String
    
    init(id: UUID = UUID(), patternType: String, signature: String, occurrences: Int, lastSeen: Date = Date(), confidence: Double, suggestedFix: String, preventionStrategy: String) {
        self.id = id
        self.patternType = patternType
        self.signature = signature
        self.occurrences = occurrences
        self.lastSeen = lastSeen
        self.confidence = confidence
        self.suggestedFix = suggestedFix
        self.preventionStrategy = preventionStrategy
    }
}

struct AutoDebugPerformanceMetrics: Codable {
    let cpuUsage: Double
    let memoryUsage: Double
    let networkLatency: Double
    let diskUsage: Double
    let batteryLevel: Double
    let thermalState: String
    let timestamp: Date
    
    init(cpuUsage: Double = 0.0, memoryUsage: Double = 0.0, networkLatency: Double = 0.0, diskUsage: Double = 0.0, batteryLevel: Double = 1.0, thermalState: String = "Nominal", timestamp: Date = Date()) {
        self.cpuUsage = cpuUsage
        self.memoryUsage = memoryUsage
        self.networkLatency = networkLatency
        self.diskUsage = diskUsage
        self.batteryLevel = batteryLevel
        self.thermalState = thermalState
        self.timestamp = timestamp
    }
}

// MARK: - Date Formatter Extension
extension DateFormatter {
    static let timestamp: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter
    }()
}

// MARK: - Additional missing methods for AutoDebugSystem
extension AutoDebugSystem {
    func logAppError(_ error: Error, file: String, line: Int, function: String, context: String = "") async {
        let errorLog = ErrorLog(
            type: .runtime,
            fileName: (file as NSString).lastPathComponent,
            functionName: function,
            lineNumber: line,
            errorDomain: (error as NSError).domain,
            errorCode: (error as NSError).code,
            errorMessage: error.localizedDescription,
            context: context,
            stackTrace: Thread.callStackSymbols.joined(separator: "\n"),
            deviceInfo: "\(UIDevice.current.model) - \(UIDevice.current.systemVersion)"
        )
        
        errorLogs.append(errorLog)
    }
}

#Preview("Missing Types Preview") {
    VStack(spacing: 16) {
        Text("Missing Types Definitions")
            .font(.title.bold())
        
        VStack(alignment: .leading, spacing: 8) {
            Text("✅ VPSInstance")
            Text("✅ BotAvailability")  
            Text("✅ BotTradingHistory")
            Text("✅ BotReview")
            Text("✅ BotSpecialAbility")
            Text("✅ DebugSession")
            Text("✅ DebugFinding")
            Text("✅ ErrorLog")
        }
        .font(.system(.body, design: .monospaced))
        
        Spacer()
    }
    .padding()
}