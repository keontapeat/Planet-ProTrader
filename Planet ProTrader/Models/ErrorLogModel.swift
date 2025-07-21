//
//  ErrorLogModel.swift  
//  Planet ProTrader
//
//  Error Log Model - Fixes AutoDebugSystem compilation errors
//  Created by Alex AI Assistant
//

import Foundation
import SwiftUI

// MARK: - Error Types

enum ErrorType: String, Codable, CaseIterable {
    case runtime = "Runtime"
    case network = "Network"
    case memory = "Memory"
    case memoryLeak = "Memory Leak"
    case ui = "UI"
    case data = "Data"
    case validation = "Validation"
    case api = "API"
    case parsing = "Parsing"
    case authentication = "Authentication"
    case permission = "Permission"
    case file = "File"
    case database = "Database"
    case configuration = "Configuration"
    
    var color: Color {
        switch self {
        case .runtime, .memory, .memoryLeak: return .red
        case .network, .api: return .orange
        case .ui, .data: return .blue
        case .validation, .parsing: return .yellow
        case .authentication, .permission: return .purple
        case .file, .database: return .green
        case .configuration: return .gray
        }
    }
}

// MARK: - Error Log Model

struct ErrorLogModel: Identifiable, Codable {
    let id: UUID
    let timestamp: Date
    let type: ErrorType
    let severity: DebugSeverity
    let errorMessage: String
    let stackTrace: String?
    let fileName: String?
    let lineNumber: Int?
    let functionName: String?
    let errorDomain: String
    let errorCode: Int
    let context: String?
    var isFixed: Bool
    var fixAppliedAt: Date?
    var fixMethod: String?
    var autoFixAttempts: Int
    let deviceInfo: String
    let occurrenceCount: Int
    
    init(
        id: UUID = UUID(),
        timestamp: Date = Date(),
        type: ErrorType,
        severity: DebugSeverity = .error,
        errorMessage: String,
        stackTrace: String? = nil,
        fileName: String? = nil,
        lineNumber: Int? = nil,
        functionName: String? = nil,
        errorDomain: String,
        errorCode: Int,
        context: String? = nil,
        isFixed: Bool = false,
        fixAppliedAt: Date? = nil,
        fixMethod: String? = nil,
        autoFixAttempts: Int = 0,
        deviceInfo: String = UIDevice.current.model,
        occurrenceCount: Int = 1
    ) {
        self.id = id
        self.timestamp = timestamp
        self.type = type
        self.severity = severity
        self.errorMessage = errorMessage
        self.stackTrace = stackTrace
        self.fileName = fileName
        self.lineNumber = lineNumber
        self.functionName = functionName
        self.errorDomain = errorDomain
        self.errorCode = errorCode
        self.context = context
        self.isFixed = isFixed
        self.fixAppliedAt = fixAppliedAt
        self.fixMethod = fixMethod
        self.autoFixAttempts = autoFixAttempts
        self.deviceInfo = deviceInfo
        self.occurrenceCount = occurrenceCount
    }
    
    var message: String {
        return errorMessage
    }
    
    var formattedTimestamp: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: timestamp)
    }
    
    var severityColor: Color {
        return severity.color
    }
    
    var isRecent: Bool {
        return timestamp.timeIntervalSinceNow > -3600 // Within last hour
    }
}

// MARK: - Debug Severity

enum DebugSeverity: String, CaseIterable, Codable {
    case info = "Info"
    case warning = "Warning"
    case error = "Error"
    case critical = "Critical"
    
    var color: Color {
        switch self {
        case .info: return .blue
        case .warning: return .yellow
        case .error: return .orange
        case .critical: return .red
        }
    }
    
    var priority: Int {
        switch self {
        case .info: return 1
        case .warning: return 2
        case .error: return 3
        case .critical: return 4
        }
    }
    
    var systemImage: String {
        switch self {
        case .info: return "info.circle"
        case .warning: return "exclamationmark.triangle"
        case .error: return "xmark.circle"
        case .critical: return "exclamationmark.octagon"
        }
    }
}

// MARK: - Debug Session

struct DebugSession: Identifiable, Codable {
    let id: UUID
    let type: SessionType
    let startTime: Date
    var endTime: Date?
    var status: SessionStatus
    var findings: [String]
    
    enum SessionType: String, Codable {
        case healthCheck = "Health Check"
        case eliteHealthCheck = "Elite Health Check"
        case predictiveAnalysis = "Predictive Analysis"
        case emergencyFix = "Emergency Fix"
    }
    
    enum SessionStatus: String, Codable {
        case running = "Running"
        case completed = "Completed"
        case completedWithIssues = "Completed with Issues"
        case failed = "Failed"
        
        var color: Color {
            switch self {
            case .running: return .blue
            case .completed: return .green
            case .completedWithIssues: return .orange
            case .failed: return .red
            }
        }
    }
    
    init(
        id: UUID = UUID(),
        type: SessionType = .healthCheck,
        startTime: Date = Date(),
        endTime: Date? = nil,
        status: SessionStatus = .running,
        findings: [String] = []
    ) {
        self.id = id
        self.type = type
        self.startTime = startTime
        self.endTime = endTime
        self.status = status
        self.findings = findings
    }
    
    var duration: TimeInterval {
        let end = endTime ?? Date()
        return end.timeIntervalSince(startTime)
    }
    
    var formattedDuration: String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

// MARK: - Sample Data

extension ErrorLogModel {
    static var samples: [ErrorLogModel] {
        return [
            ErrorLogModel(
                type: .memory,
                severity: .warning,
                errorMessage: "High memory usage detected",
                errorDomain: "com.planetprotrader.memory",
                errorCode: 1001,
                context: "Chart data loading"
            ),
            ErrorLogModel(
                type: .network,
                severity: .error,
                errorMessage: "Failed to connect to trading server",
                errorDomain: "com.planetprotrader.network",
                errorCode: 2001,
                context: "Live trading connection"
            ),
            ErrorLogModel(
                type: .ui,
                severity: .warning,
                errorMessage: "View update on background thread",
                errorDomain: "com.planetprotrader.ui",
                errorCode: 3001,
                context: "Real-time price updates"
            )
        ]
    }
}

extension DebugSession {
    static var sample: DebugSession {
        return DebugSession(
            type: .eliteHealthCheck,
            startTime: Date().addingTimeInterval(-300),
            endTime: Date(),
            status: .completed,
            findings: ["Memory usage optimized", "Network latency improved", "UI performance enhanced"]
        )
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 16) {
        Text("🚨 Error Log Model")
            .font(.title.bold())
            .foregroundColor(.red)
        
        Text("Error tracking and debugging support")
            .font(.subheadline)
            .foregroundColor(.secondary)
        
        ForEach(ErrorLogModel.samples) { error in
            HStack {
                Image(systemName: error.severity.systemImage)
                    .foregroundColor(error.severityColor)
                
                VStack(alignment: .leading) {
                    Text(error.type.rawValue)
                        .font(.caption.bold())
                    Text(error.errorMessage)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Text(error.formattedTimestamp)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)
        }
    }
    .padding()
    .background(Color(.systemGroupedBackground))
    .cornerRadius(12)
}