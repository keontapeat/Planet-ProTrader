//
//  AutoStrategyRebuilderEngine.swift
//  GOLDEX AI
//
//  Created by Keonta on 7/13/25.
//

import Foundation
import SwiftUI

// MARK: - AutoStrategy Rebuilder Engine™
class AutoStrategyRebuilderEngine: ObservableObject {
    
    // MARK: - Published Properties
    @Published var isActive = false
    @Published var isRebuilding = false
    @Published var currentStrategy: TradingStrategy?
    @Published var rebuildProgress: Double = 0.0
    @Published var rebuildTriggers: [RebuildTrigger] = []
    @Published var marketRegime: MarketRegime = .normal
    @Published var adaptationLevel: Double = 0.0
    @Published var lastRebuildTime = Date()
    @Published var rebuildHistory: [RebuildEvent] = []
    @Published var systemHealth: SystemHealth = SystemHealth()
    @Published var rebuildStatus: RebuildStatus = .stable
    @Published var nuclearResetCount: Int = 0
    
    // MARK: - Trading Strategy
    struct TradingStrategy {
        let id = UUID()
        let name: String
        let version: String
        let createdAt: Date
        let components: [StrategyComponent]
        let parameters: [String: Any]
        let performance: StrategyPerformance
        let adaptability: Double
        let robustness: Double
        let complexity: Double
        let marketRegimeCompatibility: [MarketRegime: Double]
        
        struct StrategyComponent {
            let id = UUID()
            let name: String
            let type: ComponentType
            let importance: Double
            let configuration: [String: Any]
            let performance: ComponentPerformance
            let isActive: Bool
            
            enum ComponentType {
                case entrySignal
                case exitSignal
                case riskManagement
                case positionSizing
                case marketFilter
                case timeFilter
                case correlationFilter
                case volatilityFilter
                
                var displayName: String {
                    switch self {
                    case .entrySignal: return "Entry Signal"
                    case .exitSignal: return "Exit Signal"
                    case .riskManagement: return "Risk Management"
                    case .positionSizing: return "Position Sizing"
                    case .marketFilter: return "Market Filter"
                    case .timeFilter: return "Time Filter"
                    case .correlationFilter: return "Correlation Filter"
                    case .volatilityFilter: return "Volatility Filter"
                    }
                }
            }
            
            struct ComponentPerformance {
                var winRate: Double
                var profitFactor: Double
                var reliability: Double
                var adaptability: Double
                var efficiency: Double
            }
        }
        
        struct StrategyPerformance {
            var winRate: Double
            var profitFactor: Double
            var sharpeRatio: Double
            var maxDrawdown: Double
            var totalReturn: Double
            var volatility: Double
            var consistency: Double
            var robustness: Double
            var adaptability: Double
            var overallScore: Double
        }
    }
    
    // MARK: - Rebuild Triggers
    struct RebuildTrigger {
        let id = UUID()
        let type: TriggerType
        let threshold: Double
        let currentValue: Double
        let severity: TriggerSeverity
        let description: String
        let isActive: Bool
        let lastTriggered: Date?
        
        enum TriggerType {
            case performanceDecline
            case marketRegimeChange
            case volatilityShift
            case correlationBreakdown
            case drawdownLimit
            case winRateDecline
            case systemOverload
            case dataQualityIssue
            
            var displayName: String {
                switch self {
                case .performanceDecline: return "Performance Decline"
                case .marketRegimeChange: return "Market Regime Change"
                case .volatilityShift: return "Volatility Shift"
                case .correlationBreakdown: return "Correlation Breakdown"
                case .drawdownLimit: return "Drawdown Limit"
                case .winRateDecline: return "Win Rate Decline"
                case .systemOverload: return "System Overload"
                case .dataQualityIssue: return "Data Quality Issue"
                }
            }
            
            var icon: String {
                switch self {
                case .performanceDecline: return "chart.line.downtrend.xyaxis"
                case .marketRegimeChange: return "arrow.triangle.2.circlepath"
                case .volatilityShift: return "waveform.path.ecg"
                case .correlationBreakdown: return "link.badge.plus"
                case .drawdownLimit: return "exclamationmark.triangle"
                case .winRateDecline: return "percent"
                case .systemOverload: return "cpu"
                case .dataQualityIssue: return "questionmark.circle"
                }
            }
        }
        
        enum TriggerSeverity {
            case low
            case medium
            case high
            case critical
            case nuclear
            
            var color: Color {
                switch self {
                case .low: return .green
                case .medium: return .yellow
                case .high: return .orange
                case .critical: return .red
                case .nuclear: return .purple
                }
            }
            
            var displayName: String {
                switch self {
                case .low: return "Low"
                case .medium: return "Medium"
                case .high: return "High"
                case .critical: return "Critical"
                case .nuclear: return "Nuclear"
                }
            }
        }
    }
    
    // MARK: - Market Regime
    enum MarketRegime: CaseIterable {
        case normal
        case volatile
        case trending
        case ranging
        case crisis
        case recovery
        case bubble
        case crash
        
        var displayName: String {
            switch self {
            case .normal: return "Normal"
            case .volatile: return "Volatile"
            case .trending: return "Trending"
            case .ranging: return "Ranging"
            case .crisis: return "Crisis"
            case .recovery: return "Recovery"
            case .bubble: return "Bubble"
            case .crash: return "Crash"
            }
        }
        
        var color: Color {
            switch self {
            case .normal: return .green
            case .volatile: return .orange
            case .trending: return .blue
            case .ranging: return .gray
            case .crisis: return .red
            case .recovery: return .mint
            case .bubble: return .purple
            case .crash: return .black
            }
        }
        
        var strategyRequirements: [String] {
            switch self {
            case .normal: return ["Balanced approach", "Standard risk management"]
            case .volatile: return ["Dynamic position sizing", "Enhanced risk controls"]
            case .trending: return ["Trend following", "Momentum indicators"]
            case .ranging: return ["Mean reversion", "Support/resistance"]
            case .crisis: return ["Capital preservation", "Defensive positioning"]
            case .recovery: return ["Opportunity capture", "Increased exposure"]
            case .bubble: return ["Bubble detection", "Early exit signals"]
            case .crash: return ["Emergency protocols", "Immediate liquidation"]
            }
        }
    }
    
    // MARK: - Rebuild Status
    enum RebuildStatus: CaseIterable {
        case stable
        case monitoring
        case analyzing
        case rebuilding
        case testing
        case deploying
        case emergency
        
        var displayName: String {
            switch self {
            case .stable: return "Stable"
            case .monitoring: return "Monitoring"
            case .analyzing: return "Analyzing"
            case .rebuilding: return "Rebuilding"
            case .testing: return "Testing"
            case .deploying: return "Deploying"
            case .emergency: return "Emergency"
            }
        }
        
        var color: Color {
            switch self {
            case .stable: return .green
            case .monitoring: return .blue
            case .analyzing: return .yellow
            case .rebuilding: return .orange
            case .testing: return .purple
            case .deploying: return .mint
            case .emergency: return .red
            }
        }
    }
    
    // MARK: - System Health
    struct SystemHealth {
        var overallHealth: Double = 1.0
        var performanceHealth: Double = 1.0
        var stabilityHealth: Double = 1.0
        var adaptabilityHealth: Double = 1.0
        var robustnessHealth: Double = 1.0
        var efficiencyHealth: Double = 1.0
        var lastHealthCheck: Date = Date()
        var healthHistory: [HealthSnapshot] = []
        var criticalIssues: [HealthIssue] = []
        var warnings: [HealthWarning] = []
        
        struct HealthSnapshot {
            let timestamp: Date
            let overallHealth: Double
            let components: [String: Double]
            let issues: [String]
        }
        
        struct HealthIssue {
            let id = UUID()
            let type: IssueType
            let severity: IssueSeverity
            let description: String
            let detectedAt: Date
            let resolvedAt: Date?
            let impact: Double
            
            enum IssueType {
                case performance
                case stability
                case memory
                case processing
                case data
                case network
                
                var displayName: String {
                    switch self {
                    case .performance: return "Performance"
                    case .stability: return "Stability"
                    case .memory: return "Memory"
                    case .processing: return "Processing"
                    case .data: return "Data"
                    case .network: return "Network"
                    }
                }
            }
            
            enum IssueSeverity {
                case minor
                case moderate
                case major
                case critical
                case catastrophic
                
                var color: Color {
                    switch self {
                    case .minor: return .green
                    case .moderate: return .yellow
                    case .major: return .orange
                    case .critical: return .red
                    case .catastrophic: return .purple
                    }
                }
            }
        }
        
        struct HealthWarning {
            let id = UUID()
            let message: String
            let type: WarningType
            let timestamp: Date
            let acknowledged: Bool
            
            enum WarningType {
                case degradation
                case threshold
                case anomaly
                case prediction
                
                var displayName: String {
                    switch self {
                    case .degradation: return "Degradation"
                    case .threshold: return "Threshold"
                    case .anomaly: return "Anomaly"
                    case .prediction: return "Prediction"
                    }
                }
            }
        }
        
        mutating func updateHealth() {
            performanceHealth = Double.random(in: 0.7...1.0)
            stabilityHealth = Double.random(in: 0.6...1.0)
            adaptabilityHealth = Double.random(in: 0.8...1.0)
            robustnessHealth = Double.random(in: 0.7...1.0)
            efficiencyHealth = Double.random(in: 0.75...1.0)
            
            overallHealth = (performanceHealth + stabilityHealth + adaptabilityHealth + robustnessHealth + efficiencyHealth) / 5.0
            lastHealthCheck = Date()
            
            // Add health snapshot
            let snapshot = HealthSnapshot(
                timestamp: Date(),
                overallHealth: overallHealth,
                components: [
                    "Performance": performanceHealth,
                    "Stability": stabilityHealth,
                    "Adaptability": adaptabilityHealth,
                    "Robustness": robustnessHealth,
                    "Efficiency": efficiencyHealth
                ],
                issues: criticalIssues.map { $0.description }
            )
            healthHistory.append(snapshot)
            
            // Keep only last 24 hours of history
            let cutoff = Date().addingTimeInterval(-86400)
            healthHistory = healthHistory.filter { $0.timestamp > cutoff }
        }
    }
    
    // MARK: - Rebuild Event
    struct RebuildEvent {
        let id = UUID()
        let timestamp: Date
        let type: RebuildType
        let trigger: RebuildTrigger.TriggerType
        let oldStrategy: String
        let newStrategy: String
        let duration: TimeInterval
        let success: Bool
        let improvements: [String]
        let issues: [String]
        let performanceImpact: Double
        
        enum RebuildType {
            case minor
            case major
            case complete
            case nuclear
            
            var displayName: String {
                switch self {
                case .minor: return "Minor Rebuild"
                case .major: return "Major Rebuild"
                case .complete: return "Complete Rebuild"
                case .nuclear: return "Nuclear Reset"
                }
            }
            
            var color: Color {
                switch self {
                case .minor: return .green
                case .major: return .orange
                case .complete: return .red
                case .nuclear: return .purple
                }
            }
        }
    }
    
    // MARK: - Initialization
    init() {
        setupRebuildTriggers()
        initializeCurrentStrategy()
        startMonitoring()
    }
    
    private func setupRebuildTriggers() {
        rebuildTriggers = [
            RebuildTrigger(
                type: .performanceDecline,
                threshold: 0.15,
                currentValue: 0.05,
                severity: .medium,
                description: "Strategy performance declined by 15%",
                isActive: true,
                lastTriggered: nil
            ),
            RebuildTrigger(
                type: .marketRegimeChange,
                threshold: 0.8,
                currentValue: 0.3,
                severity: .high,
                description: "Market regime change detected",
                isActive: true,
                lastTriggered: nil
            ),
            RebuildTrigger(
                type: .volatilityShift,
                threshold: 0.5,
                currentValue: 0.2,
                severity: .medium,
                description: "Significant volatility shift detected",
                isActive: true,
                lastTriggered: nil
            ),
            RebuildTrigger(
                type: .drawdownLimit,
                threshold: 0.2,
                currentValue: 0.08,
                severity: .critical,
                description: "Maximum drawdown limit approached",
                isActive: true,
                lastTriggered: nil
            ),
            RebuildTrigger(
                type: .winRateDecline,
                threshold: 0.4,
                currentValue: 0.65,
                severity: .high,
                description: "Win rate dropped below acceptable level",
                isActive: true,
                lastTriggered: nil
            )
        ]
    }
    
    private func initializeCurrentStrategy() {
        currentStrategy = generateDefaultStrategy()
    }
    
    private func generateDefaultStrategy() -> TradingStrategy {
        let components = [
            TradingStrategy.StrategyComponent(
                name: "Multi-timeframe Entry",
                type: .entrySignal,
                importance: 0.9,
                configuration: [:],
                performance: TradingStrategy.StrategyComponent.ComponentPerformance(
                    winRate: 0.72,
                    profitFactor: 1.8,
                    reliability: 0.85,
                    adaptability: 0.7,
                    efficiency: 0.8
                ),
                isActive: true
            ),
            TradingStrategy.StrategyComponent(
                name: "Dynamic Stop Loss",
                type: .exitSignal,
                importance: 0.8,
                configuration: [:],
                performance: TradingStrategy.StrategyComponent.ComponentPerformance(
                    winRate: 0.68,
                    profitFactor: 1.6,
                    reliability: 0.9,
                    adaptability: 0.8,
                    efficiency: 0.85
                ),
                isActive: true
            ),
            TradingStrategy.StrategyComponent(
                name: "Adaptive Position Sizing",
                type: .positionSizing,
                importance: 0.95,
                configuration: [:],
                performance: TradingStrategy.StrategyComponent.ComponentPerformance(
                    winRate: 0.75,
                    profitFactor: 2.1,
                    reliability: 0.95,
                    adaptability: 0.9,
                    efficiency: 0.9
                ),
                isActive: true
            )
        ]
        
        let performance = TradingStrategy.StrategyPerformance(
            winRate: 0.71,
            profitFactor: 1.85,
            sharpeRatio: 1.45,
            maxDrawdown: 0.08,
            totalReturn: 0.28,
            volatility: 0.15,
            consistency: 0.82,
            robustness: 0.78,
            adaptability: 0.75,
            overallScore: 0.83
        )
        
        return TradingStrategy(
            name: "GOLDEX AI Elite Strategy",
            version: "1.0.0",
            createdAt: Date(),
            components: components,
            parameters: [:],
            performance: performance,
            adaptability: 0.75,
            robustness: 0.78,
            complexity: 0.6,
            marketRegimeCompatibility: [
                .normal: 0.9,
                .volatile: 0.7,
                .trending: 0.85,
                .ranging: 0.8,
                .crisis: 0.6,
                .recovery: 0.8,
                .bubble: 0.5,
                .crash: 0.4
            ]
        )
    }
    
    private func startMonitoring() {
        Timer.scheduledTimer(withTimeInterval: 30.0, repeats: true) { _ in
            self.monitorTriggers()
            self.updateSystemHealth()
            self.assessRebuildNeed()
        }
    }
    
    // MARK: - Monitoring Methods
    private func monitorTriggers() {
        for i in 0..<rebuildTriggers.count {
            // Update current values (simulate real monitoring)
            rebuildTriggers[i] = RebuildTrigger(
                type: rebuildTriggers[i].type,
                threshold: rebuildTriggers[i].threshold,
                currentValue: updateTriggerValue(rebuildTriggers[i]),
                severity: rebuildTriggers[i].severity,
                description: rebuildTriggers[i].description,
                isActive: rebuildTriggers[i].isActive,
                lastTriggered: rebuildTriggers[i].lastTriggered
            )
        }
    }
    
    private func updateTriggerValue(_ trigger: RebuildTrigger) -> Double {
        switch trigger.type {
        case .performanceDecline:
            return Double.random(in: 0.0...0.2)
        case .marketRegimeChange:
            return Double.random(in: 0.0...1.0)
        case .volatilityShift:
            return Double.random(in: 0.0...0.8)
        case .drawdownLimit:
            return Double.random(in: 0.0...0.25)
        case .winRateDecline:
            return Double.random(in: 0.3...0.8)
        default:
            return Double.random(in: 0.0...1.0)
        }
    }
    
    private func updateSystemHealth() {
        systemHealth.updateHealth()
        
        // Add issues if health is poor
        if systemHealth.overallHealth < 0.7 {
            let issue = SystemHealth.HealthIssue(
                type: .performance,
                severity: .moderate,
                description: "System performance degraded",
                detectedAt: Date(),
                resolvedAt: nil,
                impact: 1.0 - systemHealth.overallHealth
            )
            systemHealth.criticalIssues.append(issue)
        }
    }
    
    private func assessRebuildNeed() {
        let triggeredCount = rebuildTriggers.filter { $0.currentValue > $0.threshold }.count
        
        if triggeredCount >= 3 {
            rebuildStatus = .emergency
            initiateNuclearReset()
        } else if triggeredCount >= 2 {
            rebuildStatus = .analyzing
            initiateCompleteRebuild()
        } else if triggeredCount >= 1 {
            rebuildStatus = .monitoring
            initiateMajorRebuild()
        } else {
            rebuildStatus = .stable
        }
    }
    
    // MARK: - Rebuild Methods
    func initiateMinorRebuild() {
        guard !isRebuilding else { return }
        
        isRebuilding = true
        rebuildStatus = .rebuilding
        rebuildProgress = 0.0
        
        // Simulate minor rebuild
        performRebuild(type: .minor, duration: 30.0)
    }
    
    func initiateMajorRebuild() {
        guard !isRebuilding else { return }
        
        isRebuilding = true
        rebuildStatus = .rebuilding
        rebuildProgress = 0.0
        
        // Simulate major rebuild
        performRebuild(type: .major, duration: 120.0)
    }
    
    func initiateCompleteRebuild() {
        guard !isRebuilding else { return }
        
        isRebuilding = true
        rebuildStatus = .rebuilding
        rebuildProgress = 0.0
        
        // Simulate complete rebuild
        performRebuild(type: .complete, duration: 300.0)
    }
    
    func initiateNuclearReset() {
        guard !isRebuilding else { return }
        
        isRebuilding = true
        rebuildStatus = .emergency
        rebuildProgress = 0.0
        nuclearResetCount += 1
        
        // Nuclear reset - complete system rebuild
        performRebuild(type: .nuclear, duration: 600.0)
    }
    
    private func performRebuild(type: RebuildEvent.RebuildType, duration: TimeInterval) {
        let startTime = Date()
        let oldStrategy = currentStrategy?.name ?? "Unknown"
        
        // Simulate rebuild progress
        let progressSteps = 10
        let stepDuration = duration / Double(progressSteps)
        
        for step in 0..<progressSteps {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(step) * stepDuration) {
                self.rebuildProgress = Double(step + 1) / Double(progressSteps)
                self.updateRebuildStatus(step: step, total: progressSteps)
            }
        }
        
        // Complete rebuild
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            self.completeRebuild(type: type, startTime: startTime, oldStrategy: oldStrategy)
        }
    }
    
    private func updateRebuildStatus(step: Int, total: Int) {
        let statusMessages = [
            "Analyzing current strategy...",
            "Identifying weak components...",
            "Designing new architecture...",
            "Implementing improvements...",
            "Optimizing parameters...",
            "Testing new strategy...",
            "Validating performance...",
            "Deploying changes...",
            "Monitoring stability...",
            "Rebuild complete!"
        ]
        
        if step < statusMessages.count {
            rebuildStatus = step < total - 1 ? .rebuilding : .deploying
        }
    }
    
    private func completeRebuild(type: RebuildEvent.RebuildType, startTime: Date, oldStrategy: String) {
        let duration = Date().timeIntervalSince(startTime)
        
        // Generate new strategy
        let newStrategy = generateImprovedStrategy(type: type)
        currentStrategy = newStrategy
        
        // Create rebuild event
        let rebuildEvent = RebuildEvent(
            timestamp: startTime,
            type: type,
            trigger: .performanceDecline,
            oldStrategy: oldStrategy,
            newStrategy: newStrategy.name,
            duration: duration,
            success: true,
            improvements: generateImprovements(type: type),
            issues: [],
            performanceImpact: Double.random(in: 0.1...0.3)
        )
        
        rebuildHistory.append(rebuildEvent)
        
        // Update system state
        isRebuilding = false
        rebuildStatus = .stable
        rebuildProgress = 1.0
        lastRebuildTime = Date()
        adaptationLevel = min(1.0, adaptationLevel + 0.1)
        
        // Reset triggers
        resetTriggers()
        
        // Update system health
        systemHealth.updateHealth()
    }
    
    private func generateImprovedStrategy(type: RebuildEvent.RebuildType) -> TradingStrategy {
        let baseStrategy = currentStrategy ?? generateDefaultStrategy()
        
        // Improve performance based on rebuild type
        let improvementFactor = getImprovementFactor(type: type)
        
        let improvedPerformance = TradingStrategy.StrategyPerformance(
            winRate: min(0.95, baseStrategy.performance.winRate * improvementFactor),
            profitFactor: min(3.0, baseStrategy.performance.profitFactor * improvementFactor),
            sharpeRatio: min(3.0, baseStrategy.performance.sharpeRatio * improvementFactor),
            maxDrawdown: max(0.02, baseStrategy.performance.maxDrawdown * (2.0 - improvementFactor)),
            totalReturn: baseStrategy.performance.totalReturn * improvementFactor,
            volatility: baseStrategy.performance.volatility * (2.0 - improvementFactor),
            consistency: min(1.0, baseStrategy.performance.consistency * improvementFactor),
            robustness: min(1.0, baseStrategy.performance.robustness * improvementFactor),
            adaptability: min(1.0, baseStrategy.performance.adaptability * improvementFactor),
            overallScore: min(1.0, baseStrategy.performance.overallScore * improvementFactor)
        )
        
        return TradingStrategy(
            name: "GOLDEX AI Elite Strategy",
            version: getNextVersion(type: type),
            createdAt: Date(),
            components: baseStrategy.components,
            parameters: baseStrategy.parameters,
            performance: improvedPerformance,
            adaptability: min(1.0, baseStrategy.adaptability * improvementFactor),
            robustness: min(1.0, baseStrategy.robustness * improvementFactor),
            complexity: baseStrategy.complexity,
            marketRegimeCompatibility: baseStrategy.marketRegimeCompatibility
        )
    }
    
    private func getImprovementFactor(type: RebuildEvent.RebuildType) -> Double {
        switch type {
        case .minor: return 1.05
        case .major: return 1.15
        case .complete: return 1.25
        case .nuclear: return 1.40
        }
    }
    
    private func getNextVersion(type: RebuildEvent.RebuildType) -> String {
        guard let current = currentStrategy else { return "2.0.0" }
        
        let components = current.version.components(separatedBy: ".")
        guard components.count == 3,
              let major = Int(components[0]),
              let minor = Int(components[1]),
              let patch = Int(components[2]) else { return "2.0.0" }
        
        switch type {
        case .minor:
            return "\(major).\(minor).\(patch + 1)"
        case .major:
            return "\(major).\(minor + 1).0"
        case .complete:
            return "\(major + 1).0.0"
        case .nuclear:
            return "\(major + 1).0.0"
        }
    }
    
    private func generateImprovements(type: RebuildEvent.RebuildType) -> [String] {
        switch type {
        case .minor:
            return ["Parameter optimization", "Minor bug fixes", "Performance tuning"]
        case .major:
            return ["Algorithm improvements", "New components added", "Enhanced risk management"]
        case .complete:
            return ["Complete architecture redesign", "Advanced ML integration", "Multi-regime adaptation"]
        case .nuclear:
            return ["Complete system reconstruction", "Revolutionary new approach", "Quantum-level optimization"]
        }
    }
    
    private func resetTriggers() {
        for i in 0..<rebuildTriggers.count {
            rebuildTriggers[i] = RebuildTrigger(
                type: rebuildTriggers[i].type,
                threshold: rebuildTriggers[i].threshold,
                currentValue: 0.0,
                severity: rebuildTriggers[i].severity,
                description: rebuildTriggers[i].description,
                isActive: rebuildTriggers[i].isActive,
                lastTriggered: nil
            )
        }
    }
    
    // MARK: - Engine Control
    func activateEngine() {
        isActive = true
        startMonitoring()
    }
    
    func deactivateEngine() {
        isActive = false
        isRebuilding = false
        rebuildStatus = .stable
        rebuildProgress = 0.0
    }
    
    // MARK: - Utility Methods
    func forceRebuild() {
        initiateCompleteRebuild()
    }
    
    func emergencyStop() {
        if isRebuilding {
            isRebuilding = false
            rebuildStatus = .stable
            rebuildProgress = 0.0
        }
    }
    
    func getSystemStatus() -> SystemStatus {
        return SystemStatus(
            isActive: isActive,
            isRebuilding: isRebuilding,
            rebuildStatus: rebuildStatus,
            systemHealth: systemHealth.overallHealth,
            adaptationLevel: adaptationLevel,
            lastRebuild: lastRebuildTime,
            nuclearResetCount: nuclearResetCount,
            activeTriggers: rebuildTriggers.filter { $0.currentValue > $0.threshold }.count
        )
    }
    
    func getRebuildHistory() -> [RebuildEvent] {
        return rebuildHistory.sorted { $0.timestamp > $1.timestamp }
    }
    
    func getActiveWarnings() -> [SystemHealth.HealthWarning] {
        return systemHealth.warnings.filter { !$0.acknowledged }
    }
    
    func acknowledgeWarning(warningId: UUID) {
        if let index = systemHealth.warnings.firstIndex(where: { $0.id == warningId }) {
            systemHealth.warnings[index] = SystemHealth.HealthWarning(
                message: systemHealth.warnings[index].message,
                type: systemHealth.warnings[index].type,
                timestamp: systemHealth.warnings[index].timestamp,
                acknowledged: true
            )
        }
    }
}

// MARK: - Supporting Types
struct SystemStatus {
    let isActive: Bool
    let isRebuilding: Bool
    let rebuildStatus: AutoStrategyRebuilderEngine.RebuildStatus
    let systemHealth: Double
    let adaptationLevel: Double
    let lastRebuild: Date
    let nuclearResetCount: Int
    let activeTriggers: Int
}

#Preview {
    VStack {
        Text("AutoStrategy Rebuilder Engine")
            .font(.title)
            .padding()
    }
}