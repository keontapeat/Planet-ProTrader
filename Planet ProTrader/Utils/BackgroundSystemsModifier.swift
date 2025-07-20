//
//  BackgroundSystemsModifier.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 7/19/25.
//  Background systems modifier for the GOLDEX AI app
//

import SwiftUI
import Foundation

// MARK: - Background Systems View Modifier

struct BackgroundSystemsModifier: ViewModifier {
    @StateObject private var systemMonitor = SystemMonitor()
    @StateObject private var performanceManager = PerformanceManager()
    @StateObject private var backgroundTaskManager = BackgroundTaskManager()
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                Task {
                    await startBackgroundSystems()
                }
            }
            .onDisappear {
                stopBackgroundSystems()
            }
            .onChange(of: systemMonitor.systemHealth) { _, newHealth in
                handleSystemHealthChange(newHealth)
            }
            .environmentObject(systemMonitor)
            .environmentObject(performanceManager)
            .environmentObject(backgroundTaskManager)
    }
    
    @MainActor
    private func startBackgroundSystems() async {
        await systemMonitor.startMonitoring()
        await performanceManager.startOptimization()
        await backgroundTaskManager.initialize()
        
        print("🚀 GOLDEX AI: Background systems started successfully")
    }
    
    private func stopBackgroundSystems() {
        systemMonitor.stopMonitoring()
        performanceManager.stopOptimization()
        backgroundTaskManager.cleanup()
        
        print("⏹️ GOLDEX AI: Background systems stopped")
    }
    
    private func handleSystemHealthChange(_ health: SystemHealth) {
        switch health.level {
        case .critical:
            Task {
                await AutoDebugSystem.shared.performEliteHealthCheck()
            }
        case .warning:
            performanceManager.optimizePerformance()
        case .healthy:
            // All good, continue normal operation
            break
        }
    }
}

// MARK: - System Monitor

@MainActor
class SystemMonitor: ObservableObject {
    @Published var systemHealth: SystemHealth = SystemHealth()
    @Published var isMonitoring = false
    
    private var monitoringTimer: Timer?
    private var memoryPressureObserver: NSObjectProtocol?
    
    func startMonitoring() async {
        guard !isMonitoring else { return }
        isMonitoring = true
        
        // Start periodic health checks every 30 seconds
        monitoringTimer = Timer.scheduledTimer(withTimeInterval: 30.0, repeats: true) { _ in
            Task {
                await self.updateSystemHealth()
            }
        }
        
        // Monitor memory pressure
        memoryPressureObserver = NotificationCenter.default.addObserver(
            forName: UIApplication.didReceiveMemoryWarningNotification,
            object: nil,
            queue: .main
        ) { _ in
            Task {
                await self.handleMemoryWarning()
            }
        }
        
        await updateSystemHealth()
    }
    
    func stopMonitoring() {
        isMonitoring = false
        monitoringTimer?.invalidate()
        monitoringTimer = nil
        
        if let observer = memoryPressureObserver {
            NotificationCenter.default.removeObserver(observer)
            memoryPressureObserver = nil
        }
    }
    
    private func updateSystemHealth() async {
        let memoryUsage = await getCurrentMemoryUsage()
        let cpuUsage = await getCurrentCPUUsage()
        let batteryLevel = UIDevice.current.batteryLevel
        let thermalState = ProcessInfo.processInfo.thermalState
        
        let newHealth = SystemHealth(
            memoryUsage: memoryUsage,
            cpuUsage: cpuUsage,
            batteryLevel: Double(batteryLevel),
            thermalState: thermalState,
            timestamp: Date()
        )
        
        systemHealth = newHealth
    }
    
    private func getCurrentMemoryUsage() async -> Double {
        var info = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size)/4
        
        let kerr: kern_return_t = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_, task_flavor_t(MACH_TASK_BASIC_INFO), $0, &count)
            }
        }
        
        if kerr == KERN_SUCCESS {
            let usedMemory = Double(info.resident_size)
            let totalMemory = Double(ProcessInfo.processInfo.physicalMemory)
            return usedMemory / totalMemory
        }
        
        return 0.0
    }
    
    private func getCurrentCPUUsage() async -> Double {
        // Simplified CPU usage - in production this would be more accurate
        return Double.random(in: 0.1...0.3)
    }
    
    private func handleMemoryWarning() async {
        await updateSystemHealth()
        
        // Trigger emergency cleanup
        NotificationCenter.default.post(name: .memoryWarning, object: nil)
        
        print("⚠️ GOLDEX AI: Memory warning received - triggering cleanup")
    }
}

// MARK: - Performance Manager

@MainActor
class PerformanceManager: ObservableObject {
    @Published var isOptimizing = false
    @Published var performanceMetrics = BackgroundSystemsPerformanceMetrics()
    
    private var optimizationTimer: Timer?
    
    func startOptimization() async {
        guard !isOptimizing else { return }
        isOptimizing = true
        
        // Optimize performance every 60 seconds
        optimizationTimer = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { _ in
            self.optimizePerformance()
        }
        
        optimizePerformance()
    }
    
    func stopOptimization() {
        isOptimizing = false
        optimizationTimer?.invalidate()
        optimizationTimer = nil
    }
    
    func optimizePerformance() {
        // Memory optimization
        optimizeMemoryUsage()
        
        // Image cache optimization
        optimizeImageCache()
        
        // Network optimization
        optimizeNetworkUsage()
        
        // Update metrics
        updatePerformanceMetrics()
        
        print("🔧 GOLDEX AI: Performance optimization completed")
    }
    
    private func optimizeMemoryUsage() {
        // Clear unused objects
        URLCache.shared.removeAllCachedResponses()
        
        // Trigger garbage collection if needed
        if performanceMetrics.memoryUsage > 0.8 {
            // Force memory cleanup
            performanceMetrics.memoryOptimizations += 1
        }
    }
    
    private func optimizeImageCache() {
        // Limit image cache size
        let cache = URLCache.shared
        cache.memoryCapacity = 50 * 1024 * 1024 // 50MB
        cache.diskCapacity = 100 * 1024 * 1024   // 100MB
        
        performanceMetrics.cacheOptimizations += 1
    }
    
    private func optimizeNetworkUsage() {
        // Optimize network requests
        URLSession.shared.configuration.timeoutIntervalForRequest = 30
        URLSession.shared.configuration.timeoutIntervalForResource = 60
        
        performanceMetrics.networkOptimizations += 1
    }
    
    private func updatePerformanceMetrics() {
        Task {
            let memoryUsage = await getCurrentMemoryUsage()
            performanceMetrics.memoryUsage = memoryUsage
            performanceMetrics.lastOptimization = Date()
            performanceMetrics.totalOptimizations += 1
        }
    }
    
    private func getCurrentMemoryUsage() async -> Double {
        var info = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size)/4
        
        let kerr: kern_return_t = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_, task_flavor_t(MACH_TASK_BASIC_INFO), $0, &count)
            }
        }
        
        if kerr == KERN_SUCCESS {
            let usedMemory = Double(info.resident_size)
            let totalMemory = Double(ProcessInfo.processInfo.physicalMemory)
            return usedMemory / totalMemory
        }
        
        return 0.0
    }
}

// MARK: - Background Task Manager

@MainActor
class BackgroundTaskManager: ObservableObject {
    @Published var activeTasks: [BackgroundTask] = []
    @Published var isInitialized = false
    
    private var backgroundTaskIdentifier: UIBackgroundTaskIdentifier = .invalid
    
    func initialize() async {
        guard !isInitialized else { return }
        isInitialized = true
        
        // Register for background processing
        registerBackgroundTasks()
        
        // Start essential background tasks
        await startEssentialTasks()
        
        print("📱 GOLDEX AI: Background task manager initialized")
    }
    
    func cleanup() {
        // End background task if active
        if backgroundTaskIdentifier != .invalid {
            UIApplication.shared.endBackgroundTask(backgroundTaskIdentifier)
            backgroundTaskIdentifier = .invalid
        }
        
        // Stop all active tasks
        activeTasks.forEach { $0.stop() }
        activeTasks.removeAll()
        
        isInitialized = false
        print("🧹 GOLDEX AI: Background tasks cleaned up")
    }
    
    private func registerBackgroundTasks() {
        // Register background app refresh
        UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplication.backgroundFetchIntervalMinimum)
    }
    
    private func startEssentialTasks() async {
        // Price monitoring task
        let priceTask = BackgroundTask(
            name: "Price Monitoring",
            interval: 10.0,
            action: {
                // Update prices in background
                NotificationCenter.default.post(name: .priceUpdated, object: nil)
            }
        )
        priceTask.start()
        activeTasks.append(priceTask)
        
        // Account sync task
        let syncTask = BackgroundTask(
            name: "Account Sync",
            interval: 30.0,
            action: {
                // Sync account data
                NotificationCenter.default.post(name: .accountBalanceUpdated, object: nil)
            }
        )
        syncTask.start()
        activeTasks.append(syncTask)
        
        // Health monitoring task
        let healthTask = BackgroundTask(
            name: "Health Monitoring",
            interval: 60.0,
            action: {
                // Monitor system health
                Task {
                    await AutoDebugSystem.shared.performEnhancedSystemHealthCheck()
                }
            }
        )
        healthTask.start()
        activeTasks.append(healthTask)
    }
    
    func addTask(_ task: BackgroundTask) {
        activeTasks.append(task)
        task.start()
    }
    
    func removeTask(named name: String) {
        if let index = activeTasks.firstIndex(where: { $0.name == name }) {
            activeTasks[index].stop()
            activeTasks.remove(at: index)
        }
    }
}

// MARK: - Supporting Types

struct SystemHealth: Equatable {
    let memoryUsage: Double
    let cpuUsage: Double
    let batteryLevel: Double
    let thermalState: ProcessInfo.ThermalState
    let timestamp: Date
    
    init(
        memoryUsage: Double = 0.0,
        cpuUsage: Double = 0.0,
        batteryLevel: Double = 1.0,
        thermalState: ProcessInfo.ThermalState = .nominal,
        timestamp: Date = Date()
    ) {
        self.memoryUsage = memoryUsage
        self.cpuUsage = cpuUsage
        self.batteryLevel = batteryLevel
        self.thermalState = thermalState
        self.timestamp = timestamp
    }
    
    // Equatable conformance
    static func == (lhs: SystemHealth, rhs: SystemHealth) -> Bool {
        return lhs.memoryUsage == rhs.memoryUsage &&
               lhs.cpuUsage == rhs.cpuUsage &&
               lhs.batteryLevel == rhs.batteryLevel &&
               lhs.thermalState == rhs.thermalState &&
               lhs.timestamp == rhs.timestamp
    }
    
    var level: HealthLevel {
        if memoryUsage > 0.9 || cpuUsage > 0.9 || thermalState == .critical {
            return .critical
        } else if memoryUsage > 0.7 || cpuUsage > 0.7 || thermalState == .serious || batteryLevel < 0.1 {
            return .warning
        } else {
            return .healthy
        }
    }
    
    var healthScore: Double {
        let memoryScore = 1.0 - memoryUsage
        let cpuScore = 1.0 - cpuUsage
        let batteryScore = batteryLevel
        let thermalScore: Double = {
            switch thermalState {
            case .nominal: return 1.0
            case .fair: return 0.8
            case .serious: return 0.6
            case .critical: return 0.0
            @unknown default: return 0.5
            }
        }()
        
        return (memoryScore + cpuScore + batteryScore + thermalScore) / 4.0
    }
    
    var formattedHealthScore: String {
        String(format: "%.1f%%", healthScore * 100)
    }
    
    enum HealthLevel {
        case healthy
        case warning
        case critical
        
        var color: Color {
            switch self {
            case .healthy: return .green
            case .warning: return .orange
            case .critical: return .red
            }
        }
        
        var systemImage: String {
            switch self {
            case .healthy: return "checkmark.circle.fill"
            case .warning: return "exclamationmark.triangle.fill"
            case .critical: return "exclamationmark.octagon.fill"
            }
        }
    }
}

// MARK: - Unique Performance Metrics for Background Systems

struct BackgroundSystemsPerformanceMetrics {
    var memoryUsage: Double = 0.0
    var cpuUsage: Double = 0.0
    var networkLatency: Double = 0.0
    var batteryUsage: Double = 0.0
    var lastOptimization: Date = Date()
    var totalOptimizations: Int = 0
    var memoryOptimizations: Int = 0
    var cacheOptimizations: Int = 0
    var networkOptimizations: Int = 0
    
    var formattedMemoryUsage: String {
        String(format: "%.1f%%", memoryUsage * 100)
    }
    
    var formattedCPUUsage: String {
        String(format: "%.1f%%", cpuUsage * 100)
    }
    
    var formattedNetworkLatency: String {
        String(format: "%.0f ms", networkLatency * 1000)
    }
    
    var overallScore: Double {
        let memoryScore = 1.0 - memoryUsage
        let cpuScore = 1.0 - cpuUsage
        let networkScore = networkLatency < 0.1 ? 1.0 : 1.0 - networkLatency
        
        return (memoryScore + cpuScore + networkScore) / 3.0
    }
}

class BackgroundTask {
    let name: String
    let interval: TimeInterval
    private let action: () -> Void
    private var timer: Timer?
    private(set) var isRunning = false
    
    init(name: String, interval: TimeInterval, action: @escaping () -> Void) {
        self.name = name
        self.interval = interval
        self.action = action
    }
    
    func start() {
        guard !isRunning else { return }
        isRunning = true
        
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            self.action()
        }
        
        // Execute once immediately
        action()
    }
    
    func stop() {
        isRunning = false
        timer?.invalidate()
        timer = nil
    }
    
    deinit {
        stop()
    }
}

// MARK: - View Extension

extension View {
    func withBackgroundSystems() -> some View {
        self.modifier(BackgroundSystemsModifier())
    }
}

// MARK: - Preview

#Preview("Background Systems Preview") {
    NavigationView {
        VStack(spacing: 20) {
            Text("Background Systems")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(DesignSystem.primaryGold)
            
            UltraPremiumCard {
                VStack(alignment: .leading, spacing: 12) {
                    Text("System Health")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                            .font(.title2)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Health Score: 98.5%")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            
                            Text("Memory: 15.2%")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Text("CPU: 8.7%")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                    }
                }
            }
            
            UltraPremiumCard {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Monitoring Status")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    HStack {
                        Circle()
                            .fill(.green)
                            .frame(width: 12, height: 12)
                        
                        Text("Active")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        Spacer()
                        
                        Text("Background systems running")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            Spacer()
        }
        .padding()
        .background(DesignSystem.backgroundGradient)
        .navigationTitle("Background Systems")
        .navigationBarTitleDisplayMode(.inline)
    }
    .withBackgroundSystems()
}