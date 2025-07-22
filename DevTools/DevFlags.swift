//
//  DevFlags.swift
//  Planet ProTrader - Development Flags
//
//  MARK: - Development Configuration
//  Created by Claude Doctor™
//

import SwiftUI
import Foundation

// MARK: - Development Flags

struct DevFlags {
    
    // MARK: - General Development
    static let enableMockData = true
    static let simulateNetworkDelay = false
    static let enableDebugUI = true
    static let enableDetailedLogging = true
    static let bypassAuthentication = false
    
    // MARK: - UI Development
    static let showViewBorders = false
    static let enableSlowAnimations = false
    static let showPerformanceOverlay = false
    static let enableAccessibilityOutlines = false
    static let showNavigationDebug = false
    
    // MARK: - Trading Development
    static let enablePaperTrading = true
    static let simulateRandomPriceMovements = true
    static let enableInstantExecution = false
    static let mockTradingErrors = false
    static let enableUnlimitedDemo = true
    
    // MARK: - Bot Development
    static let enableAllBots = true
    static let simulateBotPerformance = true
    static let enableBotDebugMode = false
    static let mockBotCommunication = true
    
    // MARK: - Data & API
    static let useMockAPIResponses = true
    static let enableOfflineMode = false
    static let simulateAPIErrors = false
    static let enableDataValidation = true
    static let logAllNetworkRequests = false
    
    // MARK: - Feature Flags
    static let enableExperimentalCharts = false
    static let enableAdvancedAnalytics = true
    static let enableSocialFeatures = false
    static let enableVoiceCommands = false
    static let enableARFeatures = false
    
    // MARK: - Performance Testing
    static let enableMemoryTracking = true
    static let enableCPUMonitoring = true
    static let enableFPSCounter = false
    static let enableNetworkLatencyDisplay = false
    static let stressTestMode = false
    
    // MARK: - Claude Integration
    static let enableClaudeDebugging = true
    static let logClaudeInteractions = true
    static let enableAutoErrorReporting = true
    static let enableSmartSuggestions = true
}

// MARK: - Development Environment

class DevelopmentEnvironment: ObservableObject {
    @Published var showDebugPanel = false
    @Published var selectedDebugMode: DebugMode = .normal
    @Published var enableRealTimeLogging = false
    @Published var debugLogs: [DebugLog] = []
    
    enum DebugMode: String, CaseIterable {
        case normal = "Normal"
        case verbose = "Verbose"
        case minimal = "Minimal"
        case performance = "Performance"
        case testing = "Testing"
        
        var icon: String {
            switch self {
            case .normal: return "play.circle"
            case .verbose: return "text.bubble"
            case .minimal: return "minus.circle"
            case .performance: return "speedometer"
            case .testing: return "testtube.2"
            }
        }
        
        var color: Color {
            switch self {
            case .normal: return .blue
            case .verbose: return .green
            case .minimal: return .gray
            case .performance: return .orange
            case .testing: return .purple
            }
        }
    }
    
    struct DebugLog: Identifiable {
        let id = UUID()
        let timestamp: Date
        let level: Level
        let message: String
        let file: String
        let line: Int
        
        enum Level: String, CaseIterable {
            case debug = "DEBUG"
            case info = "INFO"
            case warning = "WARNING"
            case error = "ERROR"
            
            var color: Color {
                switch self {
                case .debug: return .gray
                case .info: return .blue
                case .warning: return .orange
                case .error: return .red
                }
            }
        }
    }
    
    func log(_ level: DebugLog.Level, _ message: String, file: String = #file, line: Int = #line) {
        let log = DebugLog(
            timestamp: Date(),
            level: level,
            message: message,
            file: URL(fileURLWithPath: file).lastPathComponent,
            line: line
        )
        
        debugLogs.insert(log, at: 0)
        
        // Limit logs to prevent memory issues
        if debugLogs.count > 100 {
            debugLogs.removeLast()
        }
        
        // Print to console if enabled
        if DevFlags.enableDetailedLogging {
            print("[\(level.rawValue)] \(log.file):\(log.line) - \(message)")
        }
    }
    
    func clearLogs() {
        debugLogs.removeAll()
    }
    
    func exportLogs() -> String {
        let logs = debugLogs.map { log in
            "[\(log.timestamp)] [\(log.level.rawValue)] \(log.file):\(log.line) - \(log.message)"
        }
        return logs.joined(separator: "\n")
    }
}

// MARK: - Debug Panel View

struct DebugPanelView: View {
    @StateObject private var devEnv = DevelopmentEnvironment()
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationView {
            TabView(selection: $selectedTab) {
                // MARK: - Flags Tab
                flagsTab
                    .tabItem {
                        Label("Flags", systemImage: "flag.fill")
                    }
                    .tag(0)
                
                // MARK: - Logs Tab
                logsTab
                    .tabItem {
                        Label("Logs", systemImage: "doc.text.fill")
                    }
                    .tag(1)
                
                // MARK: - Performance Tab
                performanceTab
                    .tabItem {
                        Label("Performance", systemImage: "speedometer")
                    }
                    .tag(2)
            }
            .navigationTitle("Debug Panel")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    // MARK: - Flags Tab
    private var flagsTab: some View {
        List {
            Section("General Development") {
                DebugToggle("Mock Data", isOn: .constant(DevFlags.enableMockData))
                DebugToggle("Network Delay", isOn: .constant(DevFlags.simulateNetworkDelay))
                DebugToggle("Debug UI", isOn: .constant(DevFlags.enableDebugUI))
                DebugToggle("Detailed Logging", isOn: .constant(DevFlags.enableDetailedLogging))
            }
            
            Section("Trading") {
                DebugToggle("Paper Trading", isOn: .constant(DevFlags.enablePaperTrading))
                DebugToggle("Random Price Movements", isOn: .constant(DevFlags.simulateRandomPriceMovements))
                DebugToggle("Instant Execution", isOn: .constant(DevFlags.enableInstantExecution))
            }
            
            Section("Bots") {
                DebugToggle("Enable All Bots", isOn: .constant(DevFlags.enableAllBots))
                DebugToggle("Simulate Performance", isOn: .constant(DevFlags.simulateBotPerformance))
                DebugToggle("Bot Debug Mode", isOn: .constant(DevFlags.enableBotDebugMode))
            }
            
            Section("Features") {
                DebugToggle("Experimental Charts", isOn: .constant(DevFlags.enableExperimentalCharts))
                DebugToggle("Advanced Analytics", isOn: .constant(DevFlags.enableAdvancedAnalytics))
                DebugToggle("Social Features", isOn: .constant(DevFlags.enableSocialFeatures))
            }
        }
    }
    
    // MARK: - Logs Tab
    private var logsTab: some View {
        VStack {
            HStack {
                Picker("Debug Mode", selection: $devEnv.selectedDebugMode) {
                    ForEach(DevelopmentEnvironment.DebugMode.allCases, id: \.self) { mode in
                        Label(mode.rawValue, systemImage: mode.icon)
                            .tag(mode)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                
                Spacer()
                
                Button("Clear") {
                    devEnv.clearLogs()
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            
            List(devEnv.debugLogs) { log in
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(log.level.rawValue)
                            .font(.caption.bold())
                            .foregroundColor(log.level.color)
                        
                        Text(log.file)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Text(log.timestamp.formatted(date: .omitted, time: .standard))
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    
                    Text(log.message)
                        .font(.system(.caption, design: .monospaced))
                        .foregroundColor(.primary)
                }
                .padding(.vertical, 2)
            }
        }
    }
    
    // MARK: - Performance Tab
    private var performanceTab: some View {
        List {
            Section("Performance Monitoring") {
                HStack {
                    Label("CPU Usage", systemImage: "cpu")
                    Spacer()
                    Text("23.4%")
                        .foregroundColor(.green)
                }
                
                HStack {
                    Label("Memory Usage", systemImage: "memorychip")
                    Spacer()
                    Text("445 MB")
                        .foregroundColor(.blue)
                }
                
                HStack {
                    Label("Network Latency", systemImage: "network")
                    Spacer()
                    Text("67 ms")
                        .foregroundColor(.orange)
                }
                
                HStack {
                    Label("Frame Rate", systemImage: "speedometer")
                    Spacer()
                    Text("60 FPS")
                        .foregroundColor(.green)
                }
            }
            
            Section("Performance Flags") {
                DebugToggle("Memory Tracking", isOn: .constant(DevFlags.enableMemoryTracking))
                DebugToggle("CPU Monitoring", isOn: .constant(DevFlags.enableCPUMonitoring))
                DebugToggle("FPS Counter", isOn: .constant(DevFlags.enableFPSCounter))
                DebugToggle("Network Latency Display", isOn: .constant(DevFlags.enableNetworkLatencyDisplay))
            }
        }
    }
}

struct DebugToggle: View {
    let title: String
    @Binding var isOn: Bool
    
    init(_ title: String, isOn: Binding<Bool>) {
        self.title = title
        self._isOn = isOn
    }
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Toggle("", isOn: $isOn)
        }
    }
}

// MARK: - Debug Modifiers

extension View {
    func debugBorder(_ color: Color = .red) -> some View {
        if DevFlags.showViewBorders {
            return AnyView(self.border(color, width: 1))
        } else {
            return AnyView(self)
        }
    }
    
    func debugBackground(_ color: Color = .yellow.opacity(0.3)) -> some View {
        if DevFlags.showViewBorders {
            return AnyView(self.background(color))
        } else {
            return AnyView(self)
        }
    }
    
    func slowAnimations() -> some View {
        if DevFlags.enableSlowAnimations {
            return AnyView(self.animation(.easeInOut(duration: 2.0), value: UUID()))
        } else {
            return AnyView(self)
        }
    }
}

// MARK: - Previews

#Preview("Debug Panel") {
    DebugPanelView()
        .preferredColorScheme(.light)
}

#Preview("Development Flags") {
    VStack(spacing: 16) {
        Text("🛠 Development Configuration")
            .font(.title.bold())
            .foregroundStyle(DesignSystem.goldGradient)
        
        VStack(alignment: .leading, spacing: 8) {
            Group {
                HStack {
                    Text("Mock Data:")
                    Spacer()
                    Text(DevFlags.enableMockData ? "✅ Enabled" : "❌ Disabled")
                        .foregroundColor(DevFlags.enableMockData ? .green : .red)
                }
                
                HStack {
                    Text("Debug UI:")
                    Spacer()
                    Text(DevFlags.enableDebugUI ? "✅ Enabled" : "❌ Disabled")
                        .foregroundColor(DevFlags.enableDebugUI ? .green : .red)
                }
                
                HStack {
                    Text("Paper Trading:")
                    Spacer()
                    Text(DevFlags.enablePaperTrading ? "✅ Enabled" : "❌ Disabled")
                        .foregroundColor(DevFlags.enablePaperTrading ? .green : .red)
                }
                
                HStack {
                    Text("All Bots:")
                    Spacer()
                    Text(DevFlags.enableAllBots ? "✅ Enabled" : "❌ Disabled")
                        .foregroundColor(DevFlags.enableAllBots ? .green : .red)
                }
            }
            .font(.system(.body, design: .monospaced))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        
        Text("🚀 Ready for Development")
            .font(.headline)
            .foregroundColor(.green)
    }
    .padding()
    .preferredColorScheme(.light)
}