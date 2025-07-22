//
//  DependencyContainer.swift
//  Planet ProTrader - Dependency Injection Container
//
//  Centralized Dependency Management System
//  Created by Elite Engineering Team
//

import SwiftUI
import Foundation
import Combine

// MARK: - Dependency Container

@MainActor
class DependencyContainer: ObservableObject {
    
    // MARK: - Singleton
    static let shared = DependencyContainer()
    
    // MARK: - Core Services
    let authService = AuthenticationManager()
    let realTimeAccountManager = RealTimeAccountManager()
    let autoTradingManager = AutoTradingManager()
    let brokerConnector = BrokerConnector()
    let realDataManager = RealDataManager()
    let botMarketplaceManager = BotMarketplaceManager()
    let toastManager = ToastManager()
    let hapticManager = HapticFeedbackManager.shared
    
    // MARK: - View Models
    let tradingViewModel = TradingViewModel()
    let homeDashboardViewModel = HomeDashboardViewModel()
    
    // MARK: - Utility Services
    let performanceMonitor = PerformanceMonitor.shared
    let errorHandler = ErrorHandler.shared
    let autoDebugSystem = AutoDebugSystem.shared
    
    private init() {
        setupDependencies()
        configureServices()
    }
    
    private func setupDependencies() {
        // Configure service relationships
        configureCombineBindings()
    }
    
    private func configureServices() {
        // Initialize services with default configurations
        Task {
            await realDataManager.loadHistoricalData(timeframe: "H1", count: 100)
            await botMarketplaceManager.loadFeaturedBots()
        }
    }
    
    private func configureCombineBindings() {
        // Connect services through Combine publishers
        authService.$isAuthenticated
            .sink { [weak self] isAuthenticated in
                if isAuthenticated {
                    Task {
                        await self?.realTimeAccountManager.refreshAccountData()
                        self?.realDataManager.startRealTimeStreaming()
                    }
                } else {
                    self?.realDataManager.stopRealTimeStreaming()
                }
            }
            .store(in: &cancellables)
        
        autoTradingManager.$isAutoTradingEnabled
            .sink { [weak self] isEnabled in
                if isEnabled {
                    self?.toastManager.show(
                        title: "Auto Trading Started",
                        message: "AI trading bots are now active",
                        type: .success
                    )
                } else {
                    self?.toastManager.show(
                        title: "Auto Trading Stopped",
                        message: "All trading bots have been paused",
                        type: .info
                    )
                }
            }
            .store(in: &cancellables)
    }
    
    func configureForPreview() {
        // Configure services for SwiftUI previews
        authService.isAuthenticated = true
        realTimeAccountManager.equity = 12500.0
        tradingViewModel.currentPrice = 2374.85
        autoTradingManager.activeBots = Array(SampleDataProvider.premiumBots.prefix(3))
    }
    
    // MARK: - Combine Storage
    private var cancellables = Set<AnyCancellable>()
}

// MARK: - Performance Monitor

@MainActor
class PerformanceMonitor: ObservableObject {
    static let shared = PerformanceMonitor()
    
    @Published var cpuUsage: Double = 0.0
    @Published var memoryUsage: Double = 0.0
    @Published var networkLatency: Double = 0.0
    @Published var frameRate: Double = 60.0
    @Published var lastUpdateTime = Date()
    
    private var monitoringTimer: Timer?
    private let processInfo = ProcessInfo.processInfo
    
    private init() {
        startMonitoring()
    }
    
    func startMonitoring() {
        monitoringTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
            self?.updateMetrics()
        }
    }
    
    func stopMonitoring() {
        monitoringTimer?.invalidate()
        monitoringTimer = nil
    }
    
    private func updateMetrics() {
        // Simulate performance metrics (in production, use actual system APIs)
        cpuUsage = Double.random(in: 15...45)
        memoryUsage = Double.random(in: 200...800)
        networkLatency = Double.random(in: 20...150)
        frameRate = Double.random(in: 58...62)
        lastUpdateTime = Date()
    }
    
    var performanceGrade: Grade {
        let avgScore = (
            (100 - cpuUsage) * 0.3 +
            (1000 - memoryUsage) / 10 * 0.2 +
            (200 - networkLatency) / 2 * 0.3 +
            frameRate * 0.2
        ) / 4
        
        switch avgScore {
        case 90...: return .excellent
        case 75..<90: return .good
        case 60..<75: return .fair
        default: return .poor
        }
    }
    
    enum Grade: String, CaseIterable {
        case excellent = "Excellent"
        case good = "Good"
        case fair = "Fair"
        case poor = "Poor"
        
        var color: Color {
            switch self {
            case .excellent: return .green
            case .good: return .blue
            case .fair: return .orange
            case .poor: return .red
            }
        }
        
        var icon: String {
            switch self {
            case .excellent: return "checkmark.circle.fill"
            case .good: return "checkmark.circle"
            case .fair: return "exclamationmark.circle"
            case .poor: return "xmark.circle.fill"
            }
        }
    }
}

// MARK: - Error Handler

@MainActor
class ErrorHandler: ObservableObject {
    static let shared = ErrorHandler()
    
    @Published var currentError: AppError?
    @Published var errorHistory: [AppError] = []
    @Published var isShowingError = false
    
    struct AppError: Identifiable, Error {
        let id = UUID()
        let title: String
        let message: String
        let severity: Severity
        let timestamp: Date
        let context: [String: Any]?
        
        enum Severity: String, CaseIterable {
            case low = "Low"
            case medium = "Medium"
            case high = "High"
            case critical = "Critical"
            
            var color: Color {
                switch self {
                case .low: return .blue
                case .medium: return .orange
                case .high: return .red
                case .critical: return .purple
                }
            }
            
            var icon: String {
                switch self {
                case .low: return "info.circle"
                case .medium: return "exclamationmark.circle"
                case .high: return "exclamationmark.triangle"
                case .critical: return "exclamationmark.octagon.fill"
                }
            }
        }
        
        init(
            title: String,
            message: String,
            severity: Severity = .medium,
            context: [String: Any]? = nil
        ) {
            self.title = title
            self.message = message
            self.severity = severity
            self.timestamp = Date()
            self.context = context
        }
    }
    
    private init() {}
    
    func handle(error: Error, context: [String: Any]? = nil) {
        let appError = AppError(
            title: "System Error",
            message: error.localizedDescription,
            severity: .high,
            context: context
        )
        
        handle(appError: appError)
    }
    
    func handle(appError: AppError) {
        currentError = appError
        errorHistory.insert(appError, at: 0)
        isShowingError = true
        
        // Log error for debugging
        print("🚨 Error: \(appError.title) - \(appError.message)")
        
        // Limit error history to prevent memory issues
        if errorHistory.count > 50 {
            errorHistory.removeLast()
        }
        
        // Auto-dismiss after 5 seconds for non-critical errors
        if appError.severity != .critical {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                if self.currentError?.id == appError.id {
                    self.clearCurrentError()
                }
            }
        }
    }
    
    func clearCurrentError() {
        currentError = nil
        isShowingError = false
    }
    
    func reportError(title: String, message: String, severity: AppError.Severity = .medium) {
        let error = AppError(title: title, message: message, severity: severity)
        handle(appError: error)
    }
    
    var criticalErrorsCount: Int {
        errorHistory.filter { $0.severity == .critical }.count
    }
    
    var recentErrorsCount: Int {
        let oneHourAgo = Date().addingTimeInterval(-3600)
        return errorHistory.filter { $0.timestamp >= oneHourAgo }.count
    }
}

// MARK: - Auto Debug System

@MainActor
class AutoDebugSystem: ObservableObject {
    static let shared = AutoDebugSystem()
    
    @Published var isDebugging = false
    @Published var debugLogs: [DebugLog] = []
    @Published var autoFixCount = 0
    @Published var systemHealth: SystemHealth = .healthy
    
    struct DebugLog: Identifiable {
        let id = UUID()
        let timestamp: Date
        let level: Level
        let message: String
        let component: String
        
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
    
    enum SystemHealth: String, CaseIterable {
        case healthy = "Healthy"
        case warning = "Warning"
        case critical = "Critical"
        case recovering = "Recovering"
        
        var color: Color {
            switch self {
            case .healthy: return .green
            case .warning: return .orange
            case .critical: return .red
            case .recovering: return .blue
            }
        }
        
        var icon: String {
            switch self {
            case .healthy: return "checkmark.circle.fill"
            case .warning: return "exclamationmark.triangle"
            case .critical: return "exclamationmark.octagon.fill"
            case .recovering: return "arrow.clockwise.circle"
            }
        }
    }
    
    private var debugTimer: Timer?
    
    private init() {}
    
    func startAutoDebugging() async {
        isDebugging = true
        log(.info, "Auto-debugging system started", component: "AutoDebug")
        
        debugTimer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { [weak self] _ in
            Task {
                await self?.runDiagnostics()
            }
        }
        
        await runInitialDiagnostics()
    }
    
    func stopAutoDebugging() {
        isDebugging = false
        debugTimer?.invalidate()
        debugTimer = nil
        log(.info, "Auto-debugging system stopped", component: "AutoDebug")
    }
    
    private func runInitialDiagnostics() async {
        log(.info, "Running initial system diagnostics...", component: "Diagnostics")
        
        // Simulate diagnostic checks
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        log(.info, "✅ All systems operational", component: "Diagnostics")
        systemHealth = .healthy
    }
    
    private func runDiagnostics() async {
        // Simulate periodic health checks
        let issues = Int.random(in: 0...10)
        
        if issues > 8 {
            systemHealth = .critical
            log(.error, "Critical system issues detected", component: "Health")
            await attemptAutoFix()
        } else if issues > 5 {
            systemHealth = .warning
            log(.warning, "System performance degraded", component: "Health")
        } else {
            systemHealth = .healthy
            log(.debug, "System running optimally", component: "Health")
        }
    }
    
    private func attemptAutoFix() async {
        systemHealth = .recovering
        log(.info, "Attempting automatic system recovery...", component: "AutoFix")
        
        // Simulate fix attempt
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        
        autoFixCount += 1
        systemHealth = .healthy
        log(.info, "✅ System recovery completed", component: "AutoFix")
    }
    
    func log(_ level: DebugLog.Level, _ message: String, component: String) {
        let log = DebugLog(
            timestamp: Date(),
            level: level,
            message: message,
            component: component
        )
        
        debugLogs.insert(log, at: 0)
        
        // Limit logs to prevent memory issues
        if debugLogs.count > 100 {
            debugLogs.removeLast()
        }
        
        // Print to console for development
        print("[\(level.rawValue)] \(component): \(message)")
    }
    
    func clearLogs() {
        debugLogs.removeAll()
        log(.info, "Debug logs cleared", component: "System")
    }
}

// MARK: - Design System

struct DesignSystem {
    // MARK: - Colors
    static let primaryGold = Color(hex: "#FFD700") ?? .yellow
    static let secondaryGold = Color(hex: "#FFA500") ?? .orange
    
    static let goldGradient = LinearGradient(
        colors: [primaryGold, secondaryGold],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    // MARK: - Typography
    static let titleFont = Font.system(size: 28, weight: .black, design: .rounded)
    static let subtitleFont = Font.system(size: 18, weight: .semibold)
    static let bodyFont = Font.system(size: 16, weight: .regular)
    static let captionFont = Font.system(size: 12, weight: .medium)
    
    // MARK: - Spacing
    static let spacing: (xs: CGFloat, sm: CGFloat, md: CGFloat, lg: CGFloat, xl: CGFloat) = (4, 8, 16, 24, 32)
    
    // MARK: - Corner Radius
    static let cornerRadius: (small: CGFloat, medium: CGFloat, large: CGFloat) = (8, 16, 24)
}

// MARK: - Haptic Feedback Manager

class HapticFeedbackManager {
    static let shared = HapticFeedbackManager()
    
    private init() {}
    
    func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
    
    func notification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    
    func selection() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
    
    // Convenience methods for common trading actions
    func tradeExecuted() {
        notification(.success)
    }
    
    func tradeFailed() {
        notification(.error)
    }
    
    func priceAlert() {
        notification(.warning)
    }
    
    func buttonTap() {
        impact(.light)
    }
    
    func swipeAction() {
        impact(.medium)
    }
    
    func majorAction() {
        impact(.heavy)
    }
}

// MARK: - Previews

#Preview("Dependency Container") {
    VStack(spacing: 24) {
        Text("Planet ProTrader")
            .font(DesignSystem.titleFont)
            .foregroundStyle(DesignSystem.goldGradient)
        
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                StatCard(title: "CPU", value: "23%", color: .green, icon: "cpu")
                StatCard(title: "Memory", value: "445MB", color: .blue, icon: "memorychip")
            }
            
            HStack(spacing: 16) {
                StatCard(title: "Network", value: "45ms", color: .orange, icon: "network")
                StatCard(title: "FPS", value: "60", color: DesignSystem.primaryGold, icon: "speedometer")
            }
        }
        
        Text("✅ All Services Initialized")
            .font(.headline)
            .foregroundColor(.green)
    }
    .padding()
    .background(.premiumBackground)
    .preferredColorScheme(.light)
}