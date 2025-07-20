//
//  AutoDebugCLI.swift
//  GOLDEX AI
//
//  Created by Goldex AI on 7/19/25.
//

import Foundation
import SwiftUI

// MARK: - CLI Integration for Auto Debug System
@MainActor
class AutoDebugCLI {
    static let shared = AutoDebugCLI()
    private let debugSystem = AutoDebugSystem.shared
    
    private init() {}
    
    // MARK: - CLI Commands
    
    /// Fix all errors immediately via CLI
    /// Usage: AutoDebugCLI.shared.fixErrorsNow()
    func fixErrorsNow() async {
        print("🔧 [CLI] Starting manual error fixing process...")
        await debugSystem.fixErrorsNow()
        
        let fixedCount = debugSystem.errorLogs.filter { $0.isFixed }.count
        let totalCount = debugSystem.errorLogs.count
        
        print("✅ [CLI] Fixed \(fixedCount)/\(totalCount) errors")
        print("📊 [CLI] Current success rate: \(Int(debugSystem.autoFixSuccessRate * 100))%")
    }
    
    /// Get system health status via CLI
    func getHealthStatus() async {
        print("🏥 [CLI] System Health Check")
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        
        await debugSystem.performEnhancedSystemHealthCheck()
        
        let activeErrors = debugSystem.errorLogs.filter { !$0.isFixed }.count
        let learnedPatterns = debugSystem.learnedPatterns.count
        
        print("🚨 Active Errors: \(activeErrors)")
        print("⚠️  Warnings: \(debugSystem.warningCount)")
        print("🧠 Learned Patterns: \(learnedPatterns)")
        print("📊 Code Quality Score: \(String(format: "%.1f%%", debugSystem.codeQualityScore * 100))")
        print("🎯 Auto-Fix Success Rate: \(String(format: "%.1f%%", debugSystem.autoFixSuccessRate * 100))")
        print("🛡️ Self-Healing: \(debugSystem.selfHealingEnabled ? "ENABLED" : "DISABLED")")
        print("🤖 AI Learning: \(debugSystem.aiLearningMode ? "ACTIVE" : "INACTIVE")")
    }
    
    /// Export error logs to JSON file
    func exportLogs(to fileName: String = "goldex_error_logs.json") async {
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            encoder.outputFormatting = .prettyPrinted
            
            let data = try encoder.encode(debugSystem.errorLogs)
            
            let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsPath.appendingPathComponent(fileName)
            
            try data.write(to: fileURL)
            
            print("📁 [CLI] Error logs exported to: \(fileURL.path)")
            print("📊 [CLI] Exported \(debugSystem.errorLogs.count) error logs")
            
        } catch {
            print("❌ [CLI] Failed to export logs: \(error)")
        }
    }
    
    /// Generate comprehensive debug report
    func generateReport() async {
        print("📋 [CLI] Generating Auto Debug Report")
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        print("🕐 Report Generated: \(formatter.string(from: now))")
        print("")
        
        // System Status
        print("🏥 SYSTEM STATUS")
        print("   Status: \(debugSystem.isActive ? "🟢 ACTIVE" : "🔴 INACTIVE")")
        print("   Self-Healing: \(debugSystem.selfHealingEnabled ? "🟢 ENABLED" : "🟠 DISABLED")")
        print("   AI Learning: \(debugSystem.aiLearningMode ? "🟢 ACTIVE" : "🟠 INACTIVE")")
        print("")
        
        // Error Statistics
        let totalErrors = debugSystem.errorLogs.count
        let fixedErrors = debugSystem.errorLogs.filter { $0.isFixed }.count
        let activeErrors = totalErrors - fixedErrors
        
        print("🚨 ERROR STATISTICS")
        print("   Total Errors: \(totalErrors)")
        print("   Fixed Errors: \(fixedErrors)")
        print("   Active Errors: \(activeErrors)")
        print("   Warnings: \(debugSystem.warningCount)")
        print("   Fix Success Rate: \(String(format: "%.1f%%", debugSystem.autoFixSuccessRate * 100))")
        print("")
        
        // Learning Progress
        print("🧠 AI LEARNING PROGRESS")
        print("   Learned Patterns: \(debugSystem.learnedPatterns.count)")
        print("   Code Quality Score: \(String(format: "%.1f%%", debugSystem.codeQualityScore * 100))")
        print("")
        
        // Top Error Patterns
        if !debugSystem.errorLogs.isEmpty {
            print("🔍 TOP ERROR PATTERNS")
            let errorPatterns = Dictionary(grouping: debugSystem.errorLogs) { error in
                error.fileName
            }
            
            let topPatterns = errorPatterns
                .sorted { $0.value.count > $1.value.count }
                .prefix(5)
            
            for (index, (fileName, errors)) in topPatterns.enumerated() {
                let fixedCount = errors.filter { $0.isFixed }.count
                print("   \(index + 1). \(fileName): \(errors.count) errors (\(fixedCount) fixed)")
            }
            print("")
        }
        
        // Recent Activities
        print("📈 RECENT ACTIVITIES")
        let recentErrors = debugSystem.errorLogs
            .sorted { $0.timestamp > $1.timestamp }
            .prefix(5)
        
        for error in recentErrors {
            let timeAgo = timeAgoSince(error.timestamp)
            let status = error.isFixed ? "✅" : "🚨"
            print("   \(status) \(timeAgo): \(error.errorMessage.prefix(60))...")
        }
        print("")
        
        // Recommendations
        print("💡 RECOMMENDATIONS")
        if activeErrors > 10 {
            print("   • Consider enabling more aggressive auto-fixing")
        }
        if debugSystem.codeQualityScore < 0.8 {
            print("   • Focus on improving code quality patterns")
        }
        if debugSystem.autoFixSuccessRate < 0.7 {
            print("   • AI models may need retraining with more data")
        }
        if debugSystem.learnedPatterns.count < 5 {
            print("   • Allow more time for AI pattern learning")
        }
        
        print("")
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        print("🎯 [CLI] Report generation complete!")
    }
    
    /// Monitor system continuously (for background tasks)
    func startMonitoring() async {
        print("👁️ [CLI] Starting continuous monitoring...")
        
        await debugSystem.startAutoDebugging()
        
        // Create a monitoring loop
        while debugSystem.isActive {
            try? await Task.sleep(nanoseconds: 30_000_000_000) // 30 seconds
            
            let timestamp = DateFormatter.timestamp.string(from: Date())
            let activeErrors = debugSystem.errorLogs.filter { !$0.isFixed }.count
            
            if activeErrors > 0 {
                print("⚠️  [\(timestamp)] \(activeErrors) active errors detected")
                
                if debugSystem.selfHealingEnabled {
                    print("🔧 [\(timestamp)] Auto-healing in progress...")
                }
            }
        }
    }
    
    /// Reset all learning data (use with caution)
    func resetLearning() {
        print("⚠️  [CLI] Resetting AI learning data...")
        
        debugSystem.learnedPatterns = []
        debugSystem.fixSuggestions = []
        
        // Reset success rate to baseline
        debugSystem.objectWillChange.send()
        
        print("🧠 [CLI] AI learning data has been reset")
        print("📚 [CLI] System will start learning from scratch")
    }
    
    /// Show detailed error information
    func showErrorDetails(errorId: String) {
        guard let uuid = UUID(uuidString: errorId),
              let error = debugSystem.errorLogs.first(where: { $0.id == uuid }) else {
            print("❌ [CLI] Error not found: \(errorId)")
            return
        }
        
        print("🔍 [CLI] Error Details")
        print("━━━━━━━━━━━━━━━━━━━━━━")
        print("ID: \(error.id)")
        print("Status: \(error.isFixed ? "✅ FIXED" : "🚨 ACTIVE")")
        print("Timestamp: \(error.timestamp)")
        print("File: \(error.fileName)")
        print("Function: \(error.functionName)")
        print("Line: \(error.lineNumber)")
        print("Domain: \(error.errorDomain)")
        print("Code: \(error.errorCode)")
        print("Message: \(error.errorMessage)")
        print("Context: \(error.context)")
        print("Occurrences: \(error.occurrenceCount)")
        print("")
        print("Stack Trace:")
        print(error.stackTrace)
        print("")
        print("Device Info:")
        print(error.deviceInfo)
    }
    
    /// List all available CLI commands
    func help() {
        print("🔧 GOLDEX AI Auto Debug CLI")
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        print("")
        print("Available Commands:")
        print("  fixErrorsNow()           - Fix all errors immediately")
        print("  getHealthStatus()        - Show current system health")
        print("  exportLogs(fileName)     - Export error logs to JSON")
        print("  generateReport()         - Generate comprehensive report")
        print("  startMonitoring()        - Start continuous monitoring")
        print("  resetLearning()          - Reset AI learning data")
        print("  showErrorDetails(id)     - Show detailed error info")
        print("  help()                   - Show this help message")
        print("")
        print("Usage Example:")
        print("  await AutoDebugCLI.shared.fixErrorsNow()")
        print("  await AutoDebugCLI.shared.getHealthStatus()")
        print("  await AutoDebugCLI.shared.generateReport()")
    }
    
    // MARK: - Helper Functions
    private func timeAgoSince(_ date: Date) -> String {
        let now = Date()
        let interval = now.timeIntervalSince(date)
        
        if interval < 60 {
            return "\(Int(interval))s ago"
        } else if interval < 3600 {
            return "\(Int(interval / 60))m ago"
        } else if interval < 86400 {
            return "\(Int(interval / 3600))h ago"
        } else {
            return "\(Int(interval / 86400))d ago"
        }
    }
}

// MARK: - Global CLI Functions (for easier access)

/// Quick access function for fixing all errors
@MainActor
func fix_errors_now() async {
    await AutoDebugCLI.shared.fixErrorsNow()
}

/// Quick access function for health status
@MainActor
func debug_status() async {
    await AutoDebugCLI.shared.getHealthStatus()
}

/// Quick access function for generating report
@MainActor
func debug_report() async {
    await AutoDebugCLI.shared.generateReport()
}

/// Quick access function for help
@MainActor
func debug_help() {
    AutoDebugCLI.shared.help()
}

// MARK: - Extension for easy error logging
extension AutoDebugSystem {
    /// Easy-to-use error logging function
    static func logError(
        _ error: Error,
        file: String = #file,
        line: Int = #line,
        function: String = #function
    ) {
        Task { @MainActor in
            await AutoDebugSystem.shared.logAppError(
                error,
                file: file,
                line: line,
                function: function
            )
        }
    }
    
    /// Easy-to-use custom error logging
    static func logCustomError(
        message: String,
        context: String = "",
        file: String = #file,
        line: Int = #line,
        function: String = #function
    ) {
        let customError = NSError(
            domain: "GoldexAI.CustomError",
            code: -1,
            userInfo: [NSLocalizedDescriptionKey: message]
        )
        
        Task { @MainActor in
            await AutoDebugSystem.shared.logAppError(
                customError,
                file: file,
                line: line,
                function: function,
                context: context
            )
        }
    }
}

#Preview("CLI Help") {
    VStack(alignment: .leading) {
        Text("Auto Debug CLI")
            .font(.title.bold())
        
        Text("Use these commands in your code:")
            .font(.headline)
            .padding(.top)
        
        VStack(alignment: .leading, spacing: 8) {
            Text("await fix_errors_now()")
            Text("await debug_status()")
            Text("await debug_report()")
            Text("debug_help()")
        }
        .font(.system(.body, design: .monospaced))
        .padding()
        .background(.quaternary.opacity(0.5))
        .cornerRadius(8)
        
        Spacer()
    }
    .padding()
}