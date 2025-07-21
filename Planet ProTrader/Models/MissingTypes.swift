//
//  MissingTypes.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 1/21/25.
//

import Foundation
import SwiftUI

// MARK: - Error Log Model (Keep only unique types not in ConsolidatedSharedTypes)

struct ErrorLog: Identifiable, Codable {
    let id = UUID()
    let timestamp: Date
    let type: ErrorType
    let severity: Severity
    let message: String
    let stackTrace: String?
    let fileName: String?
    let lineNumber: Int?
    let functionName: String?
    var isFixed: Bool
    var fixAppliedAt: Date?
    var fixMethod: String?
    var autoFixAttempts: Int
    
    enum ErrorType: String, Codable, CaseIterable {
        case compilation = "Compilation"
        case runtime = "Runtime"
        case memoryLeak = "Memory Leak"
        case performanceIssue = "Performance Issue"
        case networkError = "Network Error"
        case uiThread = "UI Thread"
        case security = "Security"
        case accessibility = "Accessibility"
        case dataIntegrity = "Data Integrity"
        case unknown = "Unknown"
        
        var color: Color {
            switch self {
            case .compilation, .runtime: return .red
            case .memoryLeak: return .orange
            case .performanceIssue: return .yellow
            case .networkError: return .blue
            case .uiThread: return .purple
            case .security: return .red
            case .accessibility: return .blue
            case .dataIntegrity: return .orange
            case .unknown: return .gray
            }
        }
    }
    
    enum Severity: String, Codable, CaseIterable {
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
    }
    
    init(
        timestamp: Date = Date(),
        type: ErrorType,
        severity: Severity,
        message: String,
        stackTrace: String? = nil,
        fileName: String? = nil,
        lineNumber: Int? = nil,
        functionName: String? = nil,
        isFixed: Bool = false,
        fixAppliedAt: Date? = nil,
        fixMethod: String? = nil,
        autoFixAttempts: Int = 0
    ) {
        self.timestamp = timestamp
        self.type = type
        self.severity = severity
        self.message = message
        self.stackTrace = stackTrace
        self.fileName = fileName
        self.lineNumber = lineNumber
        self.functionName = functionName
        self.isFixed = isFixed
        self.fixAppliedAt = fixAppliedAt
        self.fixMethod = fixMethod
        self.autoFixAttempts = autoFixAttempts
    }
    
    var formattedTimestamp: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter.string(from: timestamp)
    }
    
    var statusText: String {
        isFixed ? "Fixed" : "Active"
    }
    
    var statusColor: Color {
        isFixed ? .green : severity.color
    }
    
    var location: String {
        if let fileName = fileName, let lineNumber = lineNumber {
            return "\(fileName):\(lineNumber)"
        } else if let fileName = fileName {
            return fileName
        } else {
            return "Unknown Location"
        }
    }
    
    var canAutoFix: Bool {
        autoFixAttempts < 3 && !isFixed
    }
    
    static let sampleErrors: [ErrorLog] = [
        ErrorLog(
            type: .memoryLeak,
            severity: .critical,
            message: "Memory leak detected in image cache - 45MB unreleased",
            stackTrace: "ImageCache.swift:245\nCacheManager.swift:89",
            fileName: "ImageCache.swift",
            lineNumber: 245,
            functionName: "loadImage(_:)"
        ),
        ErrorLog(
            type: .performanceIssue,
            severity: .warning,
            message: "UI thread blocked for 120ms during data processing",
            fileName: "DataProcessor.swift",
            lineNumber: 156,
            functionName: "processLargeDataSet(_:)",
            fixMethod: "Moved processing to background queue"
        )
    ]
}

#Preview {
    VStack {
        Text("Missing Types Preview")
            .font(.title)
        
        Text("ErrorLog only - all others moved to ConsolidatedSharedTypes")
            .font(.caption)
    }
    .padding()
}