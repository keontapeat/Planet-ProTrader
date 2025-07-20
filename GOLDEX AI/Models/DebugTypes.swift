//
//  DebugTypes.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 7/19/25.
//  Comprehensive debug and error handling types for the elite AutoDebugSystem
//

import Foundation
import SwiftUI

// MARK: - Debug Severity

enum DebugSeverity: String, Codable, CaseIterable {
    case info = "Info"
    case warning = "Warning"
    case error = "Error"
    case critical = "Critical"
    case performance = "Performance"
    
    var color: Color {
        switch self {
        case .info: return .blue
        case .warning: return .orange
        case .error: return .red
        case .critical: return .purple
        case .performance: return .green
        }
    }
    
    var systemImage: String {
        switch self {
        case .info: return "info.circle"
        case .warning: return "exclamationmark.triangle"
        case .error: return "xmark.circle"
        case .critical: return "exclamationmark.octagon"
        case .performance: return "speedometer"
        }
    }
    
    var priority: Int {
        switch self {
        case .info: return 1
        case .warning: return 2
        case .performance: return 3
        case .error: return 4
        case .critical: return 5
        }
    }
}

// MARK: - Error Log

struct ErrorLog: Identifiable, Codable {
    let id: UUID
    let timestamp: Date
    let type: ErrorType
    let severity: DebugSeverity
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
        case memoryWarning = "Memory Warning"
        case performanceDegradation = "Performance"
        case networkIssue = "Network"
        case uiThread = "UI Thread"
        case thermalIssue = "Thermal"
        case thermalWarning = "Thermal Warning"
        case appleBestPractice = "Apple Best Practice"
        case codeQuality = "Code Quality"
        case security = "Security"
        case accessibility = "Accessibility"
        case dataIntegrity = "Data Integrity"
        case predictiveAnalysis = "Predictive Analysis"
        case performancePrediction = "Performance Prediction"
        case unknown = "Unknown"
    }
    
    init(
        id: UUID = UUID(),
        timestamp: Date = Date(),
        type: ErrorType,
        severity: DebugSeverity,
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
        self.id = id
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
}

// MARK: - Debug Session

struct DebugSession: Identifiable, Codable {
    let id: UUID
    let type: SessionType
    let startTime: Date
    var endTime: Date?
    var status: SessionStatus
    var findings: [DebugFinding]
    var autoFixesApplied: Int
    var errorsFound: Int
    var warningsFound: Int
    var performanceIssues: Int
    
    enum SessionType: String, Codable, CaseIterable {
        case healthCheck = "Health Check"
        case eliteHealthCheck = "Elite Health Check"
        case predictiveAnalysis = "Predictive Analysis"
        case emergencyFix = "Emergency Fix"
        case fullSystemScan = "Full System Scan"
        case performanceOptimization = "Performance Optimization"
        case securityAudit = "Security Audit"
    }
    
    enum SessionStatus: String, Codable, CaseIterable {
        case running = "Running"
        case completed = "Completed"
        case completedWithIssues = "Completed with Issues"
        case failed = "Failed"
        case cancelled = "Cancelled"
    }
    
    init(
        id: UUID = UUID(),
        type: SessionType,
        startTime: Date = Date(),
        endTime: Date? = nil,
        status: SessionStatus = .running,
        findings: [DebugFinding] = [],
        autoFixesApplied: Int = 0,
        errorsFound: Int = 0,
        warningsFound: Int = 0,
        performanceIssues: Int = 0
    ) {
        self.id = id
        self.type = type
        self.startTime = startTime
        self.endTime = endTime
        self.status = status
        self.findings = findings
        self.autoFixesApplied = autoFixesApplied
        self.errorsFound = errorsFound
        self.warningsFound = warningsFound
        self.performanceIssues = performanceIssues
    }
    
    var duration: TimeInterval {
        if let endTime = endTime {
            return endTime.timeIntervalSince(startTime)
        } else {
            return Date().timeIntervalSince(startTime)
        }
    }
    
    var formattedDuration: String {
        let duration = duration
        if duration < 60 {
            return String(format: "%.1fs", duration)
        } else {
            let minutes = Int(duration) / 60
            let seconds = Int(duration) % 60
            return "\(minutes)m \(seconds)s"
        }
    }
    
    var statusColor: Color {
        switch status {
        case .running: return .blue
        case .completed: return .green
        case .completedWithIssues: return .orange
        case .failed: return .red
        case .cancelled: return .gray
        }
    }
    
    var issueCount: Int {
        errorsFound + warningsFound + performanceIssues
    }
    
    var summary: String {
        if status == .running {
            return "Session in progress..."
        }
        
        if issueCount == 0 {
            return "No issues found - System healthy"
        } else {
            return "\(issueCount) issues found - \(autoFixesApplied) auto-fixed"
        }
    }
}

// MARK: - Debug Finding

struct DebugFinding: Identifiable, Codable {
    let id: UUID
    let type: FindingType
    let severity: DebugSeverity
    let message: String
    let suggestion: String
    let timestamp: Date
    var confidence: Double?
    var documentationURL: String?
    var codeExample: String?
    var isAutoFixable: Bool
    var isFixed: Bool
    var fixAppliedAt: Date?
    
    enum FindingType: String, Codable, CaseIterable {
        case memoryLeak = "Memory Leak"
        case memoryWarning = "Memory Warning"
        case performanceDegradation = "Performance Degradation"
        case networkIssue = "Network Issue"
        case uiThread = "UI Thread Violation"
        case appleBestPractice = "Apple Best Practice"
        case predictiveAnalysis = "Predictive Analysis"
        case performancePrediction = "Performance Prediction"
        case thermalIssue = "Thermal Issue"
        case thermalWarning = "Thermal Warning"
        case codeQuality = "Code Quality"
        case security = "Security Issue"
        case accessibility = "Accessibility Issue"
        case dataIntegrity = "Data Integrity"
        case compilation = "Compilation Error"
        case runtime = "Runtime Error"
    }
    
    init(
        id: UUID = UUID(),
        type: FindingType,
        severity: DebugSeverity,
        message: String,
        suggestion: String,
        timestamp: Date = Date(),
        confidence: Double? = nil,
        documentationURL: String? = nil,
        codeExample: String? = nil,
        isAutoFixable: Bool = false,
        isFixed: Bool = false,
        fixAppliedAt: Date? = nil
    ) {
        self.id = id
        self.type = type
        self.severity = severity
        self.message = message
        self.suggestion = suggestion
        self.timestamp = timestamp
        self.confidence = confidence
        self.documentationURL = documentationURL
        self.codeExample = codeExample
        self.isAutoFixable = isAutoFixable
        self.isFixed = isFixed
        self.fixAppliedAt = fixAppliedAt
    }
    
    var formattedConfidence: String? {
        guard let confidence = confidence else { return nil }
        return String(format: "%.1f%%", confidence * 100)
    }
    
    var statusText: String {
        isFixed ? "Fixed" : "Active"
    }
    
    var statusColor: Color {
        isFixed ? .green : severity.color
    }
    
    var priorityScore: Double {
        let severityWeight = Double(severity.priority) / 5.0
        let confidenceWeight = confidence ?? 0.5
        let typeWeight: Double = isAutoFixable ? 1.2 : 1.0
        
        return severityWeight * confidenceWeight * typeWeight
    }
}

// MARK: - Fix Suggestion

struct FixSuggestion: Identifiable, Codable {
    let id: UUID
    let errorId: UUID
    let type: SuggestionType
    let title: String
    let description: String
    let codeExample: String?
    let confidence: Double
    let isAutoApplicable: Bool
    let timestamp: Date
    var isApplied: Bool
    var appliedAt: Date?
    var applicationResult: String?
    
    enum SuggestionType: String, Codable, CaseIterable {
        case codeModification = "Code Modification"
        case configurationChange = "Configuration Change"
        case dependencyUpdate = "Dependency Update"
        case architectureChange = "Architecture Change"
        case performanceOptimization = "Performance Optimization"
        case securityFix = "Security Fix"
        case accessibilityImprovement = "Accessibility Improvement"
        case bestPracticeAdoption = "Best Practice Adoption"
    }
    
    init(
        id: UUID = UUID(),
        errorId: UUID,
        type: SuggestionType,
        title: String,
        description: String,
        codeExample: String? = nil,
        confidence: Double,
        isAutoApplicable: Bool = false,
        timestamp: Date = Date(),
        isApplied: Bool = false,
        appliedAt: Date? = nil,
        applicationResult: String? = nil
    ) {
        self.id = id
        self.errorId = errorId
        self.type = type
        self.title = title
        self.description = description
        self.codeExample = codeExample
        self.confidence = confidence
        self.isAutoApplicable = isAutoApplicable
        self.timestamp = timestamp
        self.isApplied = isApplied
        self.appliedAt = appliedAt
        self.applicationResult = applicationResult
    }
    
    var formattedConfidence: String {
        String(format: "%.1f%%", confidence * 100)
    }
    
    var confidenceColor: Color {
        if confidence >= 0.9 {
            return .green
        } else if confidence >= 0.7 {
            return .orange
        } else {
            return .red
        }
    }
    
    var statusText: String {
        isApplied ? "Applied" : (isAutoApplicable ? "Auto-Applicable" : "Manual Review Required")
    }
    
    var statusColor: Color {
        isApplied ? .green : (isAutoApplicable ? .blue : .orange)
    }
}

// MARK: - Learned Pattern

struct LearnedPattern: Identifiable, Codable {
    let id: UUID
    let patternType: String
    let signature: String
    let occurrences: Int
    let lastSeen: Date
    let confidence: Double
    let suggestedFix: String
    let preventionStrategy: String
    var successRate: Double
    var timesApplied: Int
    var effectiveness: Double
    
    init(
        id: UUID = UUID(),
        patternType: String,
        signature: String,
        occurrences: Int,
        lastSeen: Date = Date(),
        confidence: Double,
        suggestedFix: String,
        preventionStrategy: String,
        successRate: Double = 0.0,
        timesApplied: Int = 0,
        effectiveness: Double = 0.0
    ) {
        self.id = id
        self.patternType = patternType
        self.signature = signature
        self.occurrences = occurrences
        self.lastSeen = lastSeen
        self.confidence = confidence
        self.suggestedFix = suggestedFix
        self.preventionStrategy = preventionStrategy
        self.successRate = successRate
        self.timesApplied = timesApplied
        self.effectiveness = effectiveness
    }
    
    var formattedConfidence: String {
        String(format: "%.1f%%", confidence * 100)
    }
    
    var formattedSuccessRate: String {
        String(format: "%.1f%%", successRate * 100)
    }
    
    var effectivenessGrade: String {
        if effectiveness >= 0.9 {
            return "Excellent"
        } else if effectiveness >= 0.7 {
            return "Good"
        } else if effectiveness >= 0.5 {
            return "Average"
        } else {
            return "Poor"
        }
    }
    
    var effectivenessColor: Color {
        if effectiveness >= 0.9 {
            return .green
        } else if effectiveness >= 0.7 {
            return .mint
        } else if effectiveness >= 0.5 {
            return .yellow
        } else {
            return .red
        }
    }
    
    var isReliable: Bool {
        confidence > 0.8 && successRate > 0.7 && timesApplied >= 3
    }
}

// MARK: - Auto Debug Performance Metrics

struct AutoDebugPerformanceMetrics: Codable {
    let timestamp: Date
    let sessionsCompleted: Int
    let errorsDetected: Int
    let errorsFixed: Int
    let warningsDetected: Int
    let performanceIssuesDetected: Int
    let averageDetectionTime: TimeInterval
    let averageFixTime: TimeInterval
    let systemHealthScore: Double
    let autoFixSuccessRate: Double
    let falsePositiveRate: Double
    let cpuUsage: Double
    let memoryUsage: Double
    let networkLatency: TimeInterval
    let batteryImpact: Double
    
    init(
        timestamp: Date = Date(),
        sessionsCompleted: Int = 0,
        errorsDetected: Int = 0,
        errorsFixed: Int = 0,
        warningsDetected: Int = 0,
        performanceIssuesDetected: Int = 0,
        averageDetectionTime: TimeInterval = 0,
        averageFixTime: TimeInterval = 0,
        systemHealthScore: Double = 1.0,
        autoFixSuccessRate: Double = 0.0,
        falsePositiveRate: Double = 0.0,
        cpuUsage: Double = 0.0,
        memoryUsage: Double = 0.0,
        networkLatency: TimeInterval = 0,
        batteryImpact: Double = 0.0
    ) {
        self.timestamp = timestamp
        self.sessionsCompleted = sessionsCompleted
        self.errorsDetected = errorsDetected
        self.errorsFixed = errorsFixed
        self.warningsDetected = warningsDetected
        self.performanceIssuesDetected = performanceIssuesDetected
        self.averageDetectionTime = averageDetectionTime
        self.averageFixTime = averageFixTime
        self.systemHealthScore = systemHealthScore
        self.autoFixSuccessRate = autoFixSuccessRate
        self.falsePositiveRate = falsePositiveRate
        self.cpuUsage = cpuUsage
        self.memoryUsage = memoryUsage
        self.networkLatency = networkLatency
        self.batteryImpact = batteryImpact
    }
    
    var totalIssuesDetected: Int {
        errorsDetected + warningsDetected + performanceIssuesDetected
    }
    
    var detectionEfficiency: Double {
        guard totalIssuesDetected > 0 else { return 0 }
        return Double(errorsFixed) / Double(totalIssuesDetected)
    }
    
    var formattedDetectionEfficiency: String {
        String(format: "%.1f%%", detectionEfficiency * 100)
    }
    
    var formattedSystemHealthScore: String {
        String(format: "%.1f%%", systemHealthScore * 100)
    }
    
    var formattedAutoFixSuccessRate: String {
        String(format: "%.1f%%", autoFixSuccessRate * 100)
    }
    
    var formattedFalsePositiveRate: String {
        String(format: "%.2f%%", falsePositiveRate * 100)
    }
    
    var overallGrade: String {
        let avgScore = (systemHealthScore + autoFixSuccessRate + detectionEfficiency) / 3.0
        
        if avgScore >= 0.9 {
            return "Elite"
        } else if avgScore >= 0.8 {
            return "Excellent"
        } else if avgScore >= 0.7 {
            return "Good"
        } else if avgScore >= 0.6 {
            return "Average"
        } else {
            return "Needs Improvement"
        }
    }
    
    var overallGradeColor: Color {
        let avgScore = (systemHealthScore + autoFixSuccessRate + detectionEfficiency) / 3.0
        
        if avgScore >= 0.9 {
            return .purple
        } else if avgScore >= 0.8 {
            return .green
        } else if avgScore >= 0.7 {
            return .mint
        } else if avgScore >= 0.6 {
            return .yellow
        } else {
            return .red
        }
    }
}

// MARK: - Sample Data Extensions

extension ErrorLog {
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
            type: .performanceDegradation,
            severity: .warning,
            message: "UI thread blocked for 120ms during data processing",
            fileName: "DataProcessor.swift",
            lineNumber: 156,
            functionName: "processLargeDataSet(_:)",
            fixMethod: "Moved processing to background queue"
        ),
        ErrorLog(
            type: .appleBestPractice,
            severity: .warning,
            message: "State update on background thread detected",
            fileName: "TradingViewModel.swift",
            lineNumber: 89,
            functionName: "updatePrice(_:)",
            isFixed: true,
            fixMethod: "Added @MainActor annotation"
        )
    ]
}

extension DebugSession {
    static let sampleSessions: [DebugSession] = [
        DebugSession(
            type: .eliteHealthCheck,
            startTime: Date().addingTimeInterval(-300),
            endTime: Date(),
            status: .completed,
            findings: [],
            errorsFound: 0,
            warningsFound: 2,
            performanceIssues: 1
        ),
        DebugSession(
            type: .emergencyFix,
            startTime: Date().addingTimeInterval(-600),
            endTime: Date().addingTimeInterval(-540),
            status: .completedWithIssues,
            findings: [],
            autoFixesApplied: 3,
            errorsFound: 2,
            warningsFound: 0,
            performanceIssues: 0
        )
    ]
}

extension FixSuggestion {
    static let sampleSuggestions: [FixSuggestion] = [
        FixSuggestion(
            errorId: UUID(),
            type: .codeModification,
            title: "Add @MainActor to UI Updates",
            description: "UI state updates should be performed on the main actor",
            codeExample: "@MainActor\nfunc updateUI() {\n    // UI updates here\n}",
            confidence: 0.95,
            isAutoApplicable: true
        ),
        FixSuggestion(
            errorId: UUID(),
            type: .performanceOptimization,
            title: "Implement Image Cache Size Limit",
            description: "Add memory pressure handling to image cache",
            codeExample: "imageCache.countLimit = 100\nimageCache.totalCostLimit = 50 * 1024 * 1024",
            confidence: 0.88,
            isAutoApplicable: false
        )
    ]
}

extension LearnedPattern {
    static let samplePatterns: [LearnedPattern] = [
        LearnedPattern(
            patternType: "State Update Pattern",
            signature: "background_thread_ui_update",
            occurrences: 15,
            confidence: 0.92,
            suggestedFix: "Add @MainActor or DispatchQueue.main.async",
            preventionStrategy: "Use @MainActor for view models",
            successRate: 0.94,
            timesApplied: 12,
            effectiveness: 0.96
        ),
        LearnedPattern(
            patternType: "Memory Leak Pattern",
            signature: "strong_reference_cycle",
            occurrences: 8,
            confidence: 0.87,
            suggestedFix: "Use weak references in closures",
            preventionStrategy: "Always use [weak self] in closures",
            successRate: 0.89,
            timesApplied: 6,
            effectiveness: 0.91
        )
    ]
}

// MARK: - Preview Provider

#if DEBUG
struct DebugTypesPreview: View {
    let sampleError = ErrorLog.sampleErrors[0]
    let sampleSession = DebugSession.sampleSessions[0]
    let sampleSuggestion = FixSuggestion.sampleSuggestions[0]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Error Log Preview
                VStack(alignment: .leading, spacing: 8) {
                    Text("Sample Error Log")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    HStack {
                        Image(systemName: sampleError.severity.systemImage)
                            .foregroundColor(sampleError.severity.color)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(sampleError.type.rawValue)
                                .font(.subheadline)
                                .fontWeight(.medium)
                            
                            Text(sampleError.message)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Text(sampleError.statusText)
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(sampleError.statusColor)
                    }
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(12)
                
                // Debug Session Preview
                VStack(alignment: .leading, spacing: 8) {
                    Text("Sample Debug Session")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(sampleSession.type.rawValue)
                                .font(.subheadline)
                                .fontWeight(.medium)
                            
                            Text("Duration: \(sampleSession.formattedDuration)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Text(sampleSession.summary)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Text(sampleSession.status.rawValue)
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(sampleSession.statusColor)
                    }
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(12)
                
                // Fix Suggestion Preview
                VStack(alignment: .leading, spacing: 8) {
                    Text("Sample Fix Suggestion")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text(sampleSuggestion.title)
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        Text(sampleSuggestion.description)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        HStack {
                            Text("Confidence: \(sampleSuggestion.formattedConfidence)")
                                .font(.caption)
                                .foregroundColor(sampleSuggestion.confidenceColor)
                            
                            Spacer()
                            
                            Text(sampleSuggestion.statusText)
                                .font(.caption)
                                .foregroundColor(sampleSuggestion.statusColor)
                        }
                    }
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(12)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Debug Types")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct DebugTypes_Previews: PreviewProvider {
    static var previews: some View {
        DebugTypesPreview()
            .preferredColorScheme(.light)
    }
}
#endif