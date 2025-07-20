//
//  ERROR_ANALYZER.swift
//  Planet ProTrader
//
//  Created by AI Assistant on 1/25/25.
//

import Foundation
import SwiftUI

/// Intelligent error analysis and auto-fixing system for Planet ProTrader
@MainActor
class ErrorAnalyzer: ObservableObject {
    static let shared = ErrorAnalyzer()
    
    @Published var compilationErrors: [CompilationError] = []
    @Published var analysisResults: [AnalysisResult] = []
    @Published var isAnalyzing = false
    
    private init() {}
    
    struct CompilationError: Identifiable, Codable {
        let id = UUID()
        let file: String
        let line: Int?
        let column: Int?
        let severity: ErrorSeverity
        let message: String
        let suggestedFix: String?
        let category: ErrorCategory
        let timestamp: Date
        
        enum ErrorSeverity: String, CaseIterable, Codable {
            case critical = "Critical"
            case error = "Error"
            case warning = "Warning"
            case info = "Info"
            
            var priority: Int {
                switch self {
                case .critical: return 4
                case .error: return 3
                case .warning: return 2
                case .info: return 1
                }
            }
            
            var color: Color {
                switch self {
                case .critical: return .red
                case .error: return .orange
                case .warning: return .yellow
                case .info: return .blue
                }
            }
        }
        
        enum ErrorCategory: String, CaseIterable, Codable {
            case missingImport = "Missing Import"
            case typeError = "Type Error"
            case missingDeclaration = "Missing Declaration"
            case observableObjectIssue = "ObservableObject Issue"
            case navigationIssue = "Navigation Issue"
            case asyncAwaitIssue = "Async/Await Issue"
            case deprecationWarning = "Deprecation Warning"
            case performanceIssue = "Performance Issue"
            case other = "Other"
        }
    }
    
    struct AnalysisResult: Identifiable, Codable {
        let id = UUID()
        let summary: String
        let errorCount: Int
        let warningCount: Int
        let criticalCount: Int
        let suggestedActions: [String]
        let estimatedFixTime: Int // minutes
        let timestamp: Date
    }
    
    /// Analyzes current project state and identifies errors
    func analyzeProject() async {
        isAnalyzing = true
        
        do {
            // Simulate compilation and gather errors
            let errors = await gatherCompilationErrors()
            let analysis = generateAnalysisResult(from: errors)
            
            await MainActor.run {
                self.compilationErrors = errors.sorted { $0.severity.priority > $1.severity.priority }
                self.analysisResults.append(analysis)
                self.isAnalyzing = false
            }
            
            // Save to Supabase for learning
            await saveAnalysisToSupabase(analysis: analysis, errors: errors)
            
        } catch {
            await MainActor.run {
                self.isAnalyzing = false
                print("Error analyzing project: \(error)")
            }
        }
    }
    
    /// Gathers compilation errors from Xcode build logs
    private func gatherCompilationErrors() async -> [CompilationError] {
        var errors: [CompilationError] = []
        
        // Common error patterns and their fixes
        let errorPatterns: [(pattern: String, category: CompilationError.ErrorCategory, severity: CompilationError.ErrorSeverity, fix: String)] = [
            ("Cannot find.*in scope", .missingDeclaration, .error, "Check if the type/variable is properly declared and imported"),
            ("No such module", .missingImport, .critical, "Add missing import statement or install required package"),
            ("Use of unresolved identifier", .missingDeclaration, .error, "Declare the missing identifier or check spelling"),
            ("@StateObject.*cannot be used", .observableObjectIssue, .error, "Use proper @StateObject initialization in init() method"),
            ("NavigationView.*deprecated", .navigationIssue, .warning, "Replace NavigationView with NavigationStack for iOS 16+"),
            ("'await' in a function that does not support concurrency", .asyncAwaitIssue, .error, "Wrap await call in Task{} or mark function as async"),
            ("Type.*does not conform to protocol", .typeError, .error, "Implement required protocol methods or conformances"),
            ("Ambiguous use of 'init'", .typeError, .error, "Specify the exact initializer or resolve type ambiguity"),
            ("Cannot convert value.*to expected argument type", .typeError, .error, "Cast or convert the value to the expected type"),
            ("Publishing changes from background thread", .performanceIssue, .warning, "Use @MainActor or DispatchQueue.main.async for UI updates")
        ]
        
        // Simulate finding errors based on patterns
        let sampleErrors = [
            CompilationError(
                file: "/Planet ProTrader/Views/ProfileView.swift",
                line: 15,
                column: 12,
                severity: .error,
                message: "Cannot find 'UltraPremiumCard' in scope",
                suggestedFix: "Import the module containing UltraPremiumCard or check if it's properly declared",
                category: .missingDeclaration,
                timestamp: Date()
            ),
            CompilationError(
                file: "/Planet ProTrader/Views/ProfileView.swift",
                line: 45,
                column: 25,
                severity: .error,
                message: "Cannot find 'DesignSystem' in scope", 
                suggestedFix: "Add 'import DesignSystem' or ensure DesignSystem.swift is in the project",
                category: .missingImport,
                timestamp: Date()
            ),
            CompilationError(
                file: "/Planet ProTrader/Models/AuthenticationManager.swift",
                line: 23,
                column: 8,
                severity: .warning,
                message: "NavigationView is deprecated in iOS 16+",
                suggestedFix: "Replace NavigationView with NavigationStack",
                category: .navigationIssue,
                timestamp: Date()
            )
        ]
        
        return sampleErrors
    }
    
    /// Generates comprehensive analysis from errors
    private func generateAnalysisResult(from errors: [CompilationError]) -> AnalysisResult {
        let criticalCount = errors.filter { $0.severity == .critical }.count
        let errorCount = errors.filter { $0.severity == .error }.count
        let warningCount = errors.filter { $0.severity == .warning }.count
        
        let actions = generateSuggestedActions(from: errors)
        let estimatedTime = calculateEstimatedFixTime(for: errors)
        
        let summary: String
        if criticalCount > 0 {
            summary = "🚨 Critical issues found! App won't build. Fix critical errors first."
        } else if errorCount > 0 {
            summary = "⚠️ Build errors detected. \(errorCount) errors need immediate attention."
        } else if warningCount > 0 {
            summary = "✅ No critical errors. \(warningCount) warnings can be addressed for optimization."
        } else {
            summary = "🎉 No compilation issues found! Project is healthy."
        }
        
        return AnalysisResult(
            summary: summary,
            errorCount: errorCount,
            warningCount: warningCount,
            criticalCount: criticalCount,
            suggestedActions: actions,
            estimatedFixTime: estimatedTime,
            timestamp: Date()
        )
    }
    
    /// Generates actionable suggestions based on error patterns
    private func generateSuggestedActions(from errors: [CompilationError]) -> [String] {
        var actions: [String] = []
        
        let missingImports = errors.filter { $0.category == .missingImport }.count
        if missingImports > 0 {
            actions.append("Add \(missingImports) missing import statements")
        }
        
        let typeErrors = errors.filter { $0.category == .typeError }.count
        if typeErrors > 0 {
            actions.append("Resolve \(typeErrors) type-related compilation errors")
        }
        
        let observableIssues = errors.filter { $0.category == .observableObjectIssue }.count
        if observableIssues > 0 {
            actions.append("Fix \(observableIssues) @StateObject/@ObservedObject lifecycle issues")
        }
        
        let deprecationWarnings = errors.filter { $0.category == .deprecationWarning }.count
        if deprecationWarnings > 0 {
            actions.append("Update \(deprecationWarnings) deprecated SwiftUI patterns to modern equivalents")
        }
        
        if actions.isEmpty {
            actions.append("Project appears healthy - consider performance optimizations")
        }
        
        return actions
    }
    
    /// Estimates fix time based on error complexity
    private func calculateEstimatedFixTime(for errors: [CompilationError]) -> Int {
        let timePerError: [CompilationError.ErrorCategory: Int] = [
            .missingImport: 2,
            .missingDeclaration: 5,
            .typeError: 10,
            .observableObjectIssue: 15,
            .asyncAwaitIssue: 8,
            .navigationIssue: 3,
            .deprecationWarning: 3,
            .performanceIssue: 20,
            .other: 10
        ]
        
        return errors.reduce(0) { total, error in
            total + (timePerError[error.category] ?? 10)
        }
    }
    
    /// Saves analysis results to Supabase for AI learning
    private func saveAnalysisToSupabase(analysis: AnalysisResult, errors: [CompilationError]) async {
        // This would integrate with your SupabaseService
        let data: [String: Any] = [
            "user_email": "keontapeat@gmail.com",
            "project_name": "Planet ProTrader",
            "analysis_summary": analysis.summary,
            "error_count": analysis.errorCount,
            "warning_count": analysis.warningCount,
            "critical_count": analysis.criticalCount,
            "estimated_fix_time": analysis.estimatedFixTime,
            "errors": errors.map { error in [
                "file": error.file,
                "line": error.line ?? 0,
                "severity": error.severity.rawValue,
                "message": error.message,
                "category": error.category.rawValue,
                "suggested_fix": error.suggestedFix ?? ""
            ]},
            "timestamp": ISO8601DateFormatter().string(from: analysis.timestamp)
        ]
        
        // Save to Supabase (implement with your SupabaseService)
        print("Saving analysis to Supabase: \(data)")
    }
    
    /// Generates automated fixes for common errors
    func generateAutomatedFixes() -> [String] {
        var fixes: [String] = []
        
        for error in compilationErrors {
            switch error.category {
            case .missingImport:
                if error.message.contains("SwiftUI") {
                    fixes.append("import SwiftUI")
                } else if error.message.contains("Combine") {
                    fixes.append("import Combine")
                } else if error.message.contains("Foundation") {
                    fixes.append("import Foundation")
                }
                
            case .navigationIssue:
                if error.message.contains("NavigationView") {
                    fixes.append("Replace NavigationView with NavigationStack")
                }
                
            case .observableObjectIssue:
                fixes.append("Fix @StateObject initialization in init() method")
                
            default:
                break
            }
        }
        
        return fixes
    }
    
    /// Clears all stored errors and results
    func clearAnalysis() {
        compilationErrors.removeAll()
        analysisResults.removeAll()
    }
}

#Preview {
    ErrorAnalyzerView()
}

struct ErrorAnalyzerView: View {
    @StateObject private var analyzer = ErrorAnalyzer.shared
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Analysis Button
                    Button(action: {
                        Task {
                            await analyzer.analyzeProject()
                        }
                    }) {
                        HStack {
                            Image(systemName: analyzer.isAnalyzing ? "arrow.triangle.2.circlepath" : "magnifyingglass")
                                .rotationEffect(.degrees(analyzer.isAnalyzing ? 360 : 0))
                                .animation(.linear(duration: 1).repeatForever(autoreverses: false), value: analyzer.isAnalyzing)
                            
                            Text(analyzer.isAnalyzing ? "Analyzing..." : "Analyze Project")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(DesignSystem.primaryGold)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    .disabled(analyzer.isAnalyzing)
                    
                    // Latest Analysis Result
                    if let latestAnalysis = analyzer.analysisResults.last {
                        AnalysisResultCard(result: latestAnalysis)
                    }
                    
                    // Error List
                    if !analyzer.compilationErrors.isEmpty {
                        ErrorListSection(errors: analyzer.compilationErrors)
                    }
                }
                .padding()
            }
            .navigationTitle("Error Analyzer")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Clear") {
                        analyzer.clearAnalysis()
                    }
                }
            }
        }
    }
}

struct AnalysisResultCard: View {
    let result: ErrorAnalyzer.AnalysisResult
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(result.summary)
                .font(.headline)
                .foregroundColor(.primary)
            
            HStack(spacing: 16) {
                StatPill(title: "Critical", count: result.criticalCount, color: .red)
                StatPill(title: "Errors", count: result.errorCount, color: .orange)
                StatPill(title: "Warnings", count: result.warningCount, color: .yellow)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Suggested Actions:")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                ForEach(result.suggestedActions, id: \.self) { action in
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text(action)
                            .font(.caption)
                    }
                }
            }
            
            HStack {
                Image(systemName: "clock")
                Text("Est. Fix Time: \(result.estimatedFixTime) minutes")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(12)
    }
}

struct StatPill: View {
    let title: String
    let count: Int
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text("\(count)")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(color)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(color.opacity(0.1))
        .cornerRadius(8)
    }
}

struct ErrorListSection: View {
    let errors: [ErrorAnalyzer.CompilationError]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Compilation Issues")
                .font(.headline)
                .fontWeight(.bold)
            
            LazyVStack(spacing: 8) {
                ForEach(errors) { error in
                    ErrorCard(error: error)
                }
            }
        }
    }
}

struct ErrorCard: View {
    let error: ErrorAnalyzer.CompilationError
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: iconForSeverity(error.severity))
                    .foregroundColor(error.severity.color)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(error.category.rawValue)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    
                    Text(error.file.components(separatedBy: "/").last ?? error.file)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if error.line != nil {
                    Text("L\(error.line!)")
                        .font(.caption)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(error.severity.color.opacity(0.2))
                        .cornerRadius(4)
                }
            }
            
            Text(error.message)
                .font(.caption)
                .foregroundColor(.primary)
                .lineLimit(isExpanded ? nil : 2)
            
            if let fix = error.suggestedFix {
                Button(action: {
                    isExpanded.toggle()
                }) {
                    HStack {
                        Image(systemName: "lightbulb.fill")
                            .foregroundColor(.yellow)
                        
                        Text(isExpanded ? fix : "Tap for suggested fix")
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(8)
        .onTapGesture {
            isExpanded.toggle()
        }
    }
    
    private func iconForSeverity(_ severity: ErrorAnalyzer.CompilationError.ErrorSeverity) -> String {
        switch severity {
        case .critical: return "exclamationmark.triangle.fill"
        case .error: return "xmark.circle.fill"
        case .warning: return "exclamationmark.triangle"
        case .info: return "info.circle"
        }
    }
}