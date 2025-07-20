//
//  MissingTypes.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 7/19/25.
//  Missing types and structures for compilation fixes
//

import Foundation
import SwiftUI

// MARK: - VPS Instance

struct VPSInstance: Identifiable, Codable {
    let id: String
    let name: String
    let ipAddress: String
    let port: Int
    let username: String
    let password: String
    let isConnected: Bool
    let status: ConnectionStatus
    let accountsRunning: Int
    let maxAccounts: Int
    let lastPing: Date
    let region: String
    let provider: String
    let specs: VPSSpecs
    
    enum ConnectionStatus: String, Codable, CaseIterable {
        case connected = "Connected"
        case connecting = "Connecting"
        case disconnected = "Disconnected"
        case error = "Error"
        case maintenance = "Maintenance"
        
        var color: Color {
            switch self {
            case .connected: return .green
            case .connecting: return .orange
            case .disconnected: return .gray
            case .error: return .red
            case .maintenance: return .blue
            }
        }
        
        var systemImage: String {
            switch self {
            case .connected: return "checkmark.circle.fill"
            case .connecting: return "clock.circle.fill"
            case .disconnected: return "xmark.circle.fill"
            case .error: return "exclamationmark.triangle.fill"
            case .maintenance: return "wrench.circle.fill"
            }
        }
    }
    
    struct VPSSpecs: Codable {
        let cpu: String
        let ram: String
        let storage: String
        let bandwidth: String
        let os: String
        
        var displaySpecs: String {
            "\(cpu) • \(ram) • \(storage)"
        }
    }
    
    init(
        id: String = UUID().uuidString,
        name: String,
        ipAddress: String,
        port: Int = 22,
        username: String = "root",
        password: String = "",
        isConnected: Bool = false,
        status: ConnectionStatus = .disconnected,
        accountsRunning: Int = 0,
        maxAccounts: Int = 5,
        lastPing: Date = Date(),
        region: String = "Europe",
        provider: String = "Hetzner",
        specs: VPSSpecs = VPSSpecs(cpu: "2 vCPU", ram: "4GB", storage: "40GB SSD", bandwidth: "20TB", os: "Ubuntu 20.04")
    ) {
        self.id = id
        self.name = name
        self.ipAddress = ipAddress
        self.port = port
        self.username = username
        self.password = password
        self.isConnected = isConnected
        self.status = status
        self.accountsRunning = accountsRunning
        self.maxAccounts = maxAccounts
        self.lastPing = lastPing
        self.region = region
        self.provider = provider
        self.specs = specs
    }
    
    var utilizationPercentage: Double {
        guard maxAccounts > 0 else { return 0 }
        return Double(accountsRunning) / Double(maxAccounts)
    }
    
    var formattedUtilization: String {
        String(format: "%.0f%%", utilizationPercentage * 100)
    }
    
    var canAcceptNewAccount: Bool {
        accountsRunning < maxAccounts && isConnected
    }
    
    var statusText: String {
        status.rawValue
    }
    
    var statusColor: Color {
        status.color
    }
    
    var connectionDetails: String {
        "\(username)@\(ipAddress):\(port)"
    }
}

// MARK: - Realtime Insert Payload

struct RealtimeInsertPayload: Codable {
    let record: [String: Any]
    let table: String
    let timestamp: Date
    
    private enum CodingKeys: String, CodingKey {
        case record, table, timestamp
    }
    
    init(record: [String: Any], table: String, timestamp: Date = Date()) {
        self.record = record
        self.table = table
        self.timestamp = timestamp
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.table = try container.decode(String.self, forKey: .table)
        self.timestamp = try container.decode(Date.self, forKey: .timestamp)
        
        // For simplicity, we'll decode record as empty dictionary
        // In real implementation, this would properly decode JSON
        self.record = [:]
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(table, forKey: .table)
        try container.encode(timestamp, forKey: .timestamp)
        // Record encoding would be implemented based on actual data structure
    }
}

// MARK: - Trading Pattern

struct TradingPattern: Identifiable, Codable {
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

// MARK: - Code Analysis Result

struct CodeAnalysisResult: Identifiable {
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

// MARK: - Real Time Trade (Enhanced)

struct RealTimeTrade: Identifiable, Codable {
    let id: UUID
    let ticket: String
    let symbol: String
    let direction: TradeDirection
    let openPrice: Double
    let currentPrice: Double
    let lotSize: Double
    let floatingPnL: Double
    let openTime: Date
    let stopLoss: Double?
    let takeProfit: Double?
    let comment: String
    let magic: Int
    let swap: Double
    let commission: Double
    
    enum TradeDirection: String, Codable, CaseIterable {
        case buy = "BUY"
        case sell = "SELL"
        
        var color: Color {
            switch self {
            case .buy: return .green
            case .sell: return .red
            }
        }
        
        var systemImage: String {
            switch self {
            case .buy: return "arrow.up.circle.fill"
            case .sell: return "arrow.down.circle.fill"
            }
        }
    }
    
    init(
        id: UUID = UUID(),
        ticket: String,
        symbol: String,
        direction: TradeDirection,
        openPrice: Double,
        currentPrice: Double,
        lotSize: Double,
        floatingPnL: Double,
        openTime: Date = Date(),
        stopLoss: Double? = nil,
        takeProfit: Double? = nil,
        comment: String = "",
        magic: Int = 0,
        swap: Double = 0.0,
        commission: Double = 0.0
    ) {
        self.id = id
        self.ticket = ticket
        self.symbol = symbol
        self.direction = direction
        self.openPrice = openPrice
        self.currentPrice = currentPrice
        self.lotSize = lotSize
        self.floatingPnL = floatingPnL
        self.openTime = openTime
        self.stopLoss = stopLoss
        self.takeProfit = takeProfit
        self.comment = comment
        self.magic = magic
        self.swap = swap
        self.commission = commission
    }
    
    var formattedPnL: String {
        let sign = floatingPnL >= 0 ? "+" : ""
        return "\(sign)$\(String(format: "%.2f", floatingPnL))"
    }
    
    var pnlColor: Color {
        floatingPnL >= 0 ? .green : .red
    }
    
    var formattedLotSize: String {
        String(format: "%.2f", lotSize)
    }
    
    var duration: TimeInterval {
        Date().timeIntervalSince(openTime)
    }
    
    var formattedDuration: String {
        let hours = Int(duration) / 3600
        let minutes = Int(duration) % 3600 / 60
        return "\(hours)h \(minutes)m"
    }
    
    var priceDifference: Double {
        return currentPrice - openPrice
    }
    
    var pips: Double {
        return abs(priceDifference) * (symbol.contains("JPY") ? 100 : 10000)
    }
    
    var formattedPips: String {
        let sign = priceDifference >= 0 ? "+" : ""
        return "\(sign)\(String(format: "%.1f", pips)) pips"
    }
    
    var totalPnL: Double {
        return floatingPnL + swap + commission
    }
}

// MARK: - EA Signal

struct EASignal: Identifiable, Codable {
    let id: UUID
    let timestamp: Date
    let symbol: String
    let direction: SignalDirection
    let confidence: Double
    let reasoning: String
    let entryPrice: Double?
    let stopLoss: Double?
    let takeProfit: Double?
    let timeframe: String
    let priority: SignalPriority
    let isExecuted: Bool
    let magic: Int
    let lotSize: Double
    
    enum SignalDirection: String, Codable, CaseIterable {
        case buy = "BUY"
        case sell = "SELL"
        case hold = "HOLD"
        case close = "CLOSE"
        
        var color: Color {
            switch self {
            case .buy: return .green
            case .sell: return .red
            case .hold: return .orange
            case .close: return .gray
            }
        }
        
        var systemImage: String {
            switch self {
            case .buy: return "arrow.up.circle.fill"
            case .sell: return "arrow.down.circle.fill"
            case .hold: return "pause.circle.fill"
            case .close: return "xmark.circle.fill"
            }
        }
    }
    
    enum SignalPriority: String, Codable, CaseIterable {
        case low = "Low"
        case medium = "Medium"
        case high = "High"
        case urgent = "Urgent"
        
        var color: Color {
            switch self {
            case .low: return .gray
            case .medium: return .blue
            case .high: return .orange
            case .urgent: return .red
            }
        }
        
        var weight: Double {
            switch self {
            case .low: return 0.25
            case .medium: return 0.5
            case .high: return 0.75
            case .urgent: return 1.0
            }
        }
    }
    
    init(
        id: UUID = UUID(),
        timestamp: Date = Date(),
        symbol: String = "XAUUSD",
        direction: SignalDirection,
        confidence: Double,
        reasoning: String,
        entryPrice: Double? = nil,
        stopLoss: Double? = nil,
        takeProfit: Double? = nil,
        timeframe: String = "1H",
        priority: SignalPriority = .medium,
        isExecuted: Bool = false,
        magic: Int = 12345,
        lotSize: Double = 0.01
    ) {
        self.id = id
        self.timestamp = timestamp
        self.symbol = symbol
        self.direction = direction
        self.confidence = confidence
        self.reasoning = reasoning
        self.entryPrice = entryPrice
        self.stopLoss = stopLoss
        self.takeProfit = takeProfit
        self.timeframe = timeframe
        self.priority = priority
        self.isExecuted = isExecuted
        self.magic = magic
        self.lotSize = lotSize
    }
    
    var formattedConfidence: String {
        String(format: "%.1f%%", confidence * 100)
    }
    
    var formattedEntryPrice: String? {
        guard let price = entryPrice else { return nil }
        return String(format: "%.2f", price)
    }
    
    var riskRewardRatio: Double? {
        guard let entry = entryPrice,
              let sl = stopLoss,
              let tp = takeProfit else { return nil }
        
        let risk = abs(entry - sl)
        let reward = abs(tp - entry)
        
        return risk > 0 ? reward / risk : 0
    }
    
    var formattedRiskReward: String? {
        guard let ratio = riskRewardRatio else { return nil }
        return String(format: "1:%.1f", ratio)
    }
    
    var statusText: String {
        isExecuted ? "Executed" : "Pending"
    }
    
    var statusColor: Color {
        isExecuted ? .green : .orange
    }
    
    var age: TimeInterval {
        Date().timeIntervalSince(timestamp)
    }
    
    var formattedAge: String {
        let minutes = Int(age) / 60
        let hours = minutes / 60
        
        if hours > 0 {
            return "\(hours)h \(minutes % 60)m ago"
        } else {
            return "\(minutes)m ago"
        }
    }
    
    var qualityScore: Double {
        let confidenceWeight = confidence
        let priorityWeight = priority.weight
        let freshnessWeight = max(0, 1.0 - (age / 3600)) // Decay over 1 hour
        
        return (confidenceWeight + priorityWeight + freshnessWeight) / 3.0
    }
}

// MARK: - Sample Data Extensions

extension VPSInstance {
    static let sampleInstances: [VPSInstance] = [
        VPSInstance(
            name: "Hetzner-EU-01",
            ipAddress: "78.46.123.45",
            status: .connected,
            accountsRunning: 3,
            region: "Germany",
            provider: "Hetzner"
        ),
        VPSInstance(
            name: "Hetzner-EU-02",
            ipAddress: "144.76.87.21",
            status: .connecting,
            accountsRunning: 1,
            region: "Finland",
            provider: "Hetzner"
        ),
        VPSInstance(
            name: "DigitalOcean-US",
            ipAddress: "167.172.45.98",
            status: .disconnected,
            accountsRunning: 0,
            region: "New York",
            provider: "DigitalOcean",
            specs: VPSInstance.VPSSpecs(cpu: "1 vCPU", ram: "2GB", storage: "25GB SSD", bandwidth: "1TB", os: "Ubuntu 20.04")
        )
    ]
}

extension TradingPattern {
    static let samplePatterns: [TradingPattern] = [
        TradingPattern(
            name: "London Breakout",
            type: .breakout,
            confidence: 0.87,
            frequency: 25,
            successRate: 0.82,
            averageProfit: 45.30,
            riskLevel: .medium,
            description: "Gold breakout pattern during London session open",
            conditions: ["Price above 20 EMA", "Volume spike", "London session active"],
            triggers: ["Breakout of previous day high", "Strong institutional volume"]
        ),
        TradingPattern(
            name: "NY Reversal",
            type: .reversal,
            confidence: 0.91,
            frequency: 18,
            successRate: 0.89,
            averageProfit: 67.80,
            riskLevel: .low,
            description: "Mean reversion pattern during NY session",
            conditions: ["RSI > 70 or < 30", "MACD divergence", "Key level rejection"],
            triggers: ["Double top/bottom formation", "Volume confirmation"]
        )
    ]
}

extension CodeAnalysisResult {
    static let sampleResults: [CodeAnalysisResult] = [
        CodeAnalysisResult(
            fileName: "TradingViewModel.swift",
            lineNumber: 89,
            severity: .warning,
            category: .bestPractice,
            title: "UI Thread Violation",
            message: "State update on background thread",
            suggestion: "Add @MainActor or use DispatchQueue.main.async",
            isAutoFixable: true,
            confidence: 0.95
        ),
        CodeAnalysisResult(
            fileName: "ImageCache.swift",
            lineNumber: 245,
            severity: .error,
            category: .memory,
            title: "Memory Leak",
            message: "Strong reference cycle detected",
            suggestion: "Use weak references in closure",
            isAutoFixable: false,
            confidence: 0.88
        )
    ]
}

extension RealTimeTrade {
    static let sampleTrades: [RealTimeTrade] = [
        RealTimeTrade(
            ticket: "123456789",
            symbol: "XAUUSD",
            direction: .buy,
            openPrice: 2674.50,
            currentPrice: 2678.20,
            lotSize: 0.01,
            floatingPnL: 37.00,
            stopLoss: 2650.00,
            takeProfit: 2700.00,
            comment: "GOLDEX AI Signal",
            magic: 12345
        ),
        RealTimeTrade(
            ticket: "987654321",
            symbol: "XAUUSD",
            direction: .sell,
            openPrice: 2680.10,
            currentPrice: 2675.80,
            lotSize: 0.02,
            floatingPnL: 86.00,
            stopLoss: 2690.00,
            takeProfit: 2660.00,
            comment: "Auto Trade",
            magic: 12345
        )
    ]
}

extension EASignal {
    static let sampleSignals: [EASignal] = [
        EASignal(
            direction: .buy,
            confidence: 0.89,
            reasoning: "Strong bullish momentum with institutional volume",
            entryPrice: 2675.50,
            stopLoss: 2650.00,
            takeProfit: 2700.00,
            priority: .high
        ),
        EASignal(
            direction: .sell,
            confidence: 0.76,
            reasoning: "Resistance level rejection with bearish divergence",
            entryPrice: 2680.20,
            stopLoss: 2690.00,
            takeProfit: 2660.00,
            priority: .medium,
            isExecuted: true
        ),
        EASignal(
            direction: .hold,
            confidence: 0.45,
            reasoning: "Mixed signals, waiting for clearer direction",
            priority: .low
        )
    ]
}

// MARK: - Preview

#if DEBUG
struct MissingTypesPreview: View {
    let sampleVPS = VPSInstance.sampleInstances[0]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // VPS Instance Preview
                    VStack(alignment: .leading, spacing: 8) {
                        Text("VPS Instance")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        HStack {
                            Image(systemName: sampleVPS.status.systemImage)
                                .foregroundColor(sampleVPS.statusColor)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(sampleVPS.name)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                
                                Text(sampleVPS.connectionDetails)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                
                                Text("Accounts: \(sampleVPS.accountsRunning)/\(sampleVPS.maxAccounts)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing, spacing: 4) {
                                Text(sampleVPS.statusText)
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .foregroundColor(sampleVPS.statusColor)
                                
                                Text(sampleVPS.formattedUtilization)
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
            .navigationTitle("Missing Types")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct MissingTypes_Previews: PreviewProvider {
    static var previews: some View {
        MissingTypesPreview()
            .preferredColorScheme(.light)
    }
}
#endif