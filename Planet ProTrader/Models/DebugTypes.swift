//
//  DebugTypes.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 7/19/25.
//  Comprehensive debug and error handling types for the elite AutoDebugSystem
//

import Foundation
import SwiftUI

// MARK: - Debug-specific types (not duplicating SharedTypes.ErrorLogModel)

struct DebugSession: Identifiable, Codable {
    let id = UUID()
    let startTime: Date
    let endTime: Date?
    let totalErrors: Int
    let errorsFixed: Int
    let performanceMetrics: PerformanceMetrics
    let autoFixSuccess: Bool
    
    struct PerformanceMetrics: Codable {
        let cpuUsage: Double
        let memoryUsage: Double
        let thermalState: String
        let batteryLevel: Double?
    }
    
    var successRate: Double {
        guard totalErrors > 0 else { return 1.0 }
        return Double(errorsFixed) / Double(totalErrors)
    }
    
    var duration: TimeInterval {
        let end = endTime ?? Date()
        return end.timeIntervalSince(startTime)
    }
}

struct DebugConfiguration: Codable {
    let autoFixEnabled: Bool
    let maxAutoFixAttempts: Int
    let logLevel: LogLevel
    let enablePerformanceMonitoring: Bool
    let enableMemoryLeakDetection: Bool
    let enableThermalMonitoring: Bool
    
    enum LogLevel: String, CaseIterable, Codable {
        case debug = "Debug"
        case info = "Info" 
        case warning = "Warning"
        case error = "Error"
        case critical = "Critical"
        
        var color: Color {
            switch self {
            case .debug: return .gray
            case .info: return .blue
            case .warning: return .orange
            case .error: return .red
            case .critical: return .purple
            }
        }
    }
    
    static let `default` = DebugConfiguration(
        autoFixEnabled: true,
        maxAutoFixAttempts: 3,
        logLevel: .info,
        enablePerformanceMonitoring: true,
        enableMemoryLeakDetection: true,
        enableThermalMonitoring: true
    )
}

struct AutoFixResult: Identifiable, Codable {
    let id = UUID()
    let errorId: UUID
    let fixAttempt: Int
    let fixMethod: String
    let success: Bool
    let executionTime: TimeInterval
    let codeChanged: [String] // List of files modified
    let timestamp: Date
    
    init(errorId: UUID, fixAttempt: Int, fixMethod: String, success: Bool, executionTime: TimeInterval, codeChanged: [String]) {
        self.errorId = errorId
        self.fixAttempt = fixAttempt
        self.fixMethod = fixMethod
        self.success = success
        self.executionTime = executionTime
        self.codeChanged = codeChanged
        self.timestamp = Date()
    }
}

// MARK: - Debug Analytics

struct DebugAnalytics: Codable {
    let totalErrorsDetected: Int
    let totalErrorsFixed: Int
    let averageFixTime: TimeInterval
    let mostCommonErrorType: String
    let topFixMethods: [String: Int]
    let performanceTrends: [Date: Double]
    let memoryUsageTrends: [Date: Double]
    let thermalStateTrends: [Date: String]
    
    var overallHealth: DebugHealth {
        let fixRate = Double(totalErrorsFixed) / max(Double(totalErrorsDetected), 1.0)
        
        switch fixRate {
        case 0.9...1.0: return .excellent
        case 0.7..<0.9: return .good
        case 0.5..<0.7: return .fair
        default: return .poor
        }
    }
    
    enum DebugHealth: String, CaseIterable {
        case excellent = "Excellent"
        case good = "Good" 
        case fair = "Fair"
        case poor = "Poor"
        
        var color: Color {
            switch self {
            case .excellent: return .green
            case .good: return .mint
            case .fair: return .orange
            case .poor: return .red
            }
        }
        
        var icon: String {
            switch self {
            case .excellent: return "checkmark.circle.fill"
            case .good: return "checkmark.circle"
            case .fair: return "exclamationmark.triangle"
            case .poor: return "xmark.circle.fill"
            }
        }
    }
}

// MARK: - Sample Data for Preview

extension DebugSession {
    static let sampleSessions: [DebugSession] = [
        DebugSession(
            startTime: Date().addingTimeInterval(-3600),
            endTime: Date(),
            totalErrors: 15,
            errorsFixed: 13,
            performanceMetrics: PerformanceMetrics(
                cpuUsage: 45.2,
                memoryUsage: 67.8,
                thermalState: "Normal",
                batteryLevel: 85.0
            ),
            autoFixSuccess: true
        ),
        DebugSession(
            startTime: Date().addingTimeInterval(-7200),
            endTime: Date().addingTimeInterval(-3600),
            totalErrors: 8,
            errorsFixed: 8,
            performanceMetrics: PerformanceMetrics(
                cpuUsage: 32.1,
                memoryUsage: 54.3,
                thermalState: "Normal",
                batteryLevel: 92.0
            ),
            autoFixSuccess: true
        )
    ]
}

// MARK: - Preview
#Preview("Debug Types Preview") {
    NavigationView {
        VStack(spacing: 16) {
            Text("Debug Types Definitions")
                .font(.title.bold())
            
            VStack(alignment: .leading, spacing: 8) {
                Text("✅ DebugSession")
                Text("✅ DebugConfiguration")  
                Text("✅ AutoFixResult")
                Text("✅ DebugAnalytics")
                Text("✅ All conflicts resolved")
            }
            .font(.system(.body, design: .monospaced))
            
            Spacer()
        }
        .padding()
        .navigationTitle("Debug Types")
    }
}