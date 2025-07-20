//
//  TradingFuelModels.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 1/27/25.
//  Smart Trading Fuel System™ - Account monitoring & auto-reload
//

import Foundation
import SwiftUI
import UserNotifications

// MARK: - Trading Fuel Models

struct TradingFuelModels {
    
    // MARK: - Fuel Status
    
    enum FuelStatus: String, CaseIterable, Codable {
        case full = "FULL"
        case good = "GOOD" 
        case low = "LOW"
        case critical = "CRITICAL"
        case empty = "EMPTY"
        
        var displayName: String {
            switch self {
            case .full: return "Full Tank"
            case .good: return "Good Level"
            case .low: return "Low Fuel"
            case .critical: return "Critical"
            case .empty: return "Empty Tank"
            }
        }
        
        var emoji: String {
            switch self {
            case .full: return "⛽"
            case .good: return "🟢"
            case .low: return "🟡"
            case .critical: return "🟠"
            case .empty: return "🔴"
            }
        }
        
        var color: Color {
            switch self {
            case .full: return .green
            case .good: return .blue
            case .low: return .yellow
            case .critical: return .orange
            case .empty: return .red
            }
        }
        
        var gradient: LinearGradient {
            LinearGradient(
                colors: [color, color.opacity(0.7)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
        
        var actionMessage: String {
            switch self {
            case .full: return "Your bots are fully fueled! 🚀"
            case .good: return "Bots running smoothly! 💪"
            case .low: return "Time to fuel up your bots! ⚡"
            case .critical: return "Your bots need fuel ASAP! ⚠️"
            case .empty: return "Bots are paused - no fuel! 🛑"
            }
        }
        
        var urgencyLevel: Int {
            switch self {
            case .full: return 0
            case .good: return 1
            case .low: return 2
            case .critical: return 3
            case .empty: return 4
            }
        }
    }
    
    // MARK: - Fuel Tank Model
    
    struct FuelTank: Identifiable, Codable {
        let id: UUID
        let accountId: String
        let brokerName: String
        var currentBalance: Double
        var fuelThresholds: FuelThresholds
        var autoReloadSettings: AutoReloadSettings
        var lastRefuelTime: Date?
        var lastWarningTime: Date?
        let createdAt: Date
        var updatedAt: Date
        
        struct FuelThresholds: Codable {
            var fullLevel: Double = 1000.0      // $1000+
            var goodLevel: Double = 500.0       // $500-$1000
            var lowLevel: Double = 100.0        // $100-$500
            var criticalLevel: Double = 50.0    // $50-$100
            var emptyLevel: Double = 10.0       // Below $10
        }
        
        struct AutoReloadSettings: Codable {
            var enabled: Bool = false
            var reloadAmount: Double = 200.0
            var triggerThreshold: Double = 50.0
            var maxDailyReloads: Int = 3
            var paymentMethod: PaymentMethod = .cashapp
            var reloadsToday: Int = 0
            var lastReloadDate: Date?
            
            enum PaymentMethod: String, CaseIterable, Codable {
                case cashapp = "CASHAPP"
                case debitCard = "DEBIT_CARD"
                case bitcoin = "BITCOIN"
                
                var displayName: String {
                    switch self {
                    case .cashapp: return "CashApp Bitcoin"
                    case .debitCard: return "Debit Card"
                    case .bitcoin: return "Bitcoin Wallet"
                    }
                }
                
                var icon: String {
                    switch self {
                    case .cashapp: return "bitcoinsign.circle.fill"
                    case .debitCard: return "creditcard.fill"
                    case .bitcoin: return "b.circle.fill"
                    }
                }
            }
        }
        
        init(
            id: UUID = UUID(),
            accountId: String,
            brokerName: String,
            currentBalance: Double = 0.0
        ) {
            self.id = id
            self.accountId = accountId
            self.brokerName = brokerName
            self.currentBalance = currentBalance
            self.fuelThresholds = FuelThresholds()
            self.autoReloadSettings = AutoReloadSettings()
            self.createdAt = Date()
            self.updatedAt = Date()
        }
        
        var fuelStatus: FuelStatus {
            if currentBalance >= fuelThresholds.fullLevel {
                return .full
            } else if currentBalance >= fuelThresholds.goodLevel {
                return .good
            } else if currentBalance >= fuelThresholds.lowLevel {
                return .low
            } else if currentBalance >= fuelThresholds.criticalLevel {
                return .critical
            } else {
                return .empty
            }
        }
        
        var fuelPercentage: Double {
            let maxFuel = fuelThresholds.fullLevel
            return min(100, (currentBalance / maxFuel) * 100)
        }
        
        var formattedBalance: String {
            if currentBalance >= 1000 {
                return String(format: "$%.1fK", currentBalance / 1000)
            } else {
                return String(format: "$%.2f", currentBalance)
            }
        }
        
        var needsRefuel: Bool {
            fuelStatus.urgencyLevel >= 2 // Low or worse
        }
        
        var botsActive: Bool {
            currentBalance >= fuelThresholds.emptyLevel
        }
        
        var estimatedTradingDays: Int {
            let dailyBurn = 20.0 // Estimate $20/day usage
            return Int(currentBalance / dailyBurn)
        }
        
        var canAutoReload: Bool {
            guard autoReloadSettings.enabled else { return false }
            
            // Check if we've hit daily limit
            let today = Calendar.current.startOfDay(for: Date())
            if let lastReload = autoReloadSettings.lastReloadDate {
                let lastReloadDay = Calendar.current.startOfDay(for: lastReload)
                if lastReloadDay == today && autoReloadSettings.reloadsToday >= autoReloadSettings.maxDailyReloads {
                    return false
                }
            }
            
            return currentBalance <= autoReloadSettings.triggerThreshold
        }
    }
    
    // MARK: - Fuel Alert
    
    struct FuelAlert: Identifiable, Codable {
        let id: UUID
        let fuelTankId: UUID
        let alertType: AlertType
        let message: String
        let actionRequired: Bool
        let timestamp: Date
        var acknowledged: Bool
        
        enum AlertType: String, CaseIterable, Codable {
            case lowFuel = "LOW_FUEL"
            case criticalFuel = "CRITICAL_FUEL"
            case emptyTank = "EMPTY_TANK"
            case autoReloadSuccess = "AUTO_RELOAD_SUCCESS"
            case autoReloadFailed = "AUTO_RELOAD_FAILED"
            case botsDeactivated = "BOTS_DEACTIVATED"
            case botsReactivated = "BOTS_REACTIVATED"
            
            var title: String {
                switch self {
                case .lowFuel: return "Low Trading Fuel ⚡"
                case .criticalFuel: return "Critical Fuel Level ⚠️"
                case .emptyTank: return "Empty Fuel Tank 🛑"
                case .autoReloadSuccess: return "Auto-Reload Complete ✅"
                case .autoReloadFailed: return "Auto-Reload Failed ❌"
                case .botsDeactivated: return "Bots Deactivated 💤"
                case .botsReactivated: return "Bots Reactivated 🚀"
                }
            }
            
            var priority: AlertPriority {
                switch self {
                case .emptyTank, .botsDeactivated, .autoReloadFailed: return .high
                case .criticalFuel: return .medium
                case .lowFuel: return .low
                case .autoReloadSuccess, .botsReactivated: return .info
                }
            }
        }
        
        enum AlertPriority: String, CaseIterable {
            case high = "HIGH"
            case medium = "MEDIUM"
            case low = "LOW"
            case info = "INFO"
            
            var color: Color {
                switch self {
                case .high: return .red
                case .medium: return .orange
                case .low: return .yellow
                case .info: return .green
                }
            }
        }
        
        init(
            id: UUID = UUID(),
            fuelTankId: UUID,
            alertType: AlertType,
            message: String,
            actionRequired: Bool = false
        ) {
            self.id = id
            self.fuelTankId = fuelTankId
            self.alertType = alertType
            self.message = message
            self.actionRequired = actionRequired
            self.timestamp = Date()
            self.acknowledged = false
        }
    }
    
    // MARK: - Fuel Manager
    
    @MainActor
    class FuelManager: ObservableObject {
        @Published var fuelTanks: [FuelTank] = []
        @Published var fuelAlerts: [FuelAlert] = []
        @Published var isMonitoring = false
        @Published var notificationsEnabled = true
        
        private var monitoringTimer: Timer?
        private let checkInterval: TimeInterval = 300 // 5 minutes
        
        init() {
            loadFuelTanks()
            requestNotificationPermissions()
            startMonitoring()
        }
        
        deinit {
            stopMonitoring()
        }
        
        // MARK: - Tank Management
        
        func loadFuelTanks() {
            // In real app, load from database
            fuelTanks = FuelTank.sampleTanks
        }
        
        func addFuelTank(accountId: String, brokerName: String, initialBalance: Double = 0.0) {
            let newTank = FuelTank(
                accountId: accountId,
                brokerName: brokerName,
                currentBalance: initialBalance
            )
            fuelTanks.append(newTank)
        }
        
        func updateBalance(tankId: UUID, newBalance: Double) {
            if let index = fuelTanks.firstIndex(where: { $0.id == tankId }) {
                let oldStatus = fuelTanks[index].fuelStatus
                fuelTanks[index].currentBalance = newBalance
                fuelTanks[index].updatedAt = Date()
                
                let newStatus = fuelTanks[index].fuelStatus
                
                // Check if status changed and create alerts
                if oldStatus != newStatus {
                    handleStatusChange(tank: fuelTanks[index], oldStatus: oldStatus, newStatus: newStatus)
                }
                
                // Check for auto-reload
                checkAutoReload(tank: fuelTanks[index])
            }
        }
        
        // MARK: - Monitoring
        
        func startMonitoring() {
            guard !isMonitoring else { return }
            
            isMonitoring = true
            monitoringTimer = Timer.scheduledTimer(withTimeInterval: checkInterval, repeats: true) { _ in
                Task { @MainActor in
                    await self.checkAllTanks()
                }
            }
        }
        
        func stopMonitoring() {
            isMonitoring = false
            monitoringTimer?.invalidate()
            monitoringTimer = nil
        }
        
        private func checkAllTanks() async {
            for tank in fuelTanks {
                // In real app, fetch current balance from broker API
                // For demo, simulate balance changes
                if Bool.random() && tank.currentBalance > 0 {
                    let change = Double.random(in: -10...5) // Simulate trading activity
                    let newBalance = max(0, tank.currentBalance + change)
                    updateBalance(tankId: tank.id, newBalance: newBalance)
                }
            }
        }
        
        // MARK: - Status Change Handling
        
        private func handleStatusChange(tank: FuelTank, oldStatus: FuelStatus, newStatus: FuelStatus) {
            switch newStatus {
            case .low:
                if oldStatus.urgencyLevel < 2 {
                    createAlert(
                        for: tank,
                        type: .lowFuel,
                        message: "Your \(tank.brokerName) account is running low on fuel! Consider adding more funds to keep your bots active.",
                        actionRequired: true
                    )
                }
            case .critical:
                if oldStatus.urgencyLevel < 3 {
                    createAlert(
                        for: tank,
                        type: .criticalFuel,
                        message: "CRITICAL: Your \(tank.brokerName) account has very low fuel! Add funds immediately to avoid bot shutdown.",
                        actionRequired: true
                    )
                }
            case .empty:
                createAlert(
                    for: tank,
                    type: .emptyTank,
                    message: "Your \(tank.brokerName) account is empty! Bots have been deactivated until you refuel.",
                    actionRequired: true
                )
                
                createAlert(
                    for: tank,
                    type: .botsDeactivated,
                    message: "All bots on \(tank.brokerName) have been deactivated due to insufficient funds.",
                    actionRequired: false
                )
            case .good, .full:
                if oldStatus == .empty {
                    createAlert(
                        for: tank,
                        type: .botsReactivated,
                        message: "Great! Your \(tank.brokerName) bots are now reactivated and ready to trade.",
                        actionRequired: false
                    )
                }
            }
        }
        
        // MARK: - Alert Management
        
        private func createAlert(for tank: FuelTank, type: FuelAlert.AlertType, message: String, actionRequired: Bool) {
            let alert = FuelAlert(
                fuelTankId: tank.id,
                alertType: type,
                message: message,
                actionRequired: actionRequired
            )
            
            fuelAlerts.insert(alert, at: 0)
            
            // Send push notification if enabled
            if notificationsEnabled {
                sendPushNotification(alert: alert, tank: tank)
            }
        }
        
        func acknowledgeAlert(_ alertId: UUID) {
            if let index = fuelAlerts.firstIndex(where: { $0.id == alertId }) {
                fuelAlerts[index].acknowledged = true
            }
        }
        
        func clearAlert(_ alertId: UUID) {
            fuelAlerts.removeAll { $0.id == alertId }
        }
        
        // MARK: - Auto-Reload
        
        private func checkAutoReload(tank: FuelTank) {
            guard tank.canAutoReload else { return }
            
            Task {
                await performAutoReload(for: tank)
            }
        }
        
        private func performAutoReload(for tank: FuelTank) async {
            guard let index = fuelTanks.firstIndex(where: { $0.id == tank.id }) else { return }
            
            // Update reload tracking
            let today = Calendar.current.startOfDay(for: Date())
            if let lastReloadDate = fuelTanks[index].autoReloadSettings.lastReloadDate {
                let lastReloadDay = Calendar.current.startOfDay(for: lastReloadDate)
                if lastReloadDay != today {
                    fuelTanks[index].autoReloadSettings.reloadsToday = 0
                }
            }
            
            fuelTanks[index].autoReloadSettings.reloadsToday += 1
            fuelTanks[index].autoReloadSettings.lastReloadDate = Date()
            
            // Simulate auto-reload process
            let reloadAmount = fuelTanks[index].autoReloadSettings.reloadAmount
            let success = Bool.random() ? true : Double.random() > 0.1 // 90% success rate
            
            if success {
                fuelTanks[index].currentBalance += reloadAmount
                fuelTanks[index].lastRefuelTime = Date()
                fuelTanks[index].updatedAt = Date()
                
                createAlert(
                    for: fuelTanks[index],
                    type: .autoReloadSuccess,
                    message: "Successfully auto-reloaded $\(String(format: "%.2f", reloadAmount)) to your \(tank.brokerName) account!",
                    actionRequired: false
                )
            } else {
                createAlert(
                    for: fuelTanks[index],
                    type: .autoReloadFailed,
                    message: "Auto-reload failed for your \(tank.brokerName) account. Please check your payment method and try manually.",
                    actionRequired: true
                )
            }
        }
        
        // MARK: - Manual Refuel
        
        func manualRefuel(tankId: UUID, amount: Double, paymentMethod: String) async -> Bool {
            guard let index = fuelTanks.firstIndex(where: { $0.id == tankId }) else { return false }
            
            // Simulate payment processing
            try? await Task.sleep(nanoseconds: 2_000_000_000) // 2 second delay
            
            let success = Double.random() > 0.05 // 95% success rate
            
            if success {
                fuelTanks[index].currentBalance += amount
                fuelTanks[index].lastRefuelTime = Date()
                fuelTanks[index].updatedAt = Date()
                
                createAlert(
                    for: fuelTanks[index],
                    type: .autoReloadSuccess,
                    message: "Successfully added $\(String(format: "%.2f", amount)) to your \(fuelTanks[index].brokerName) account via \(paymentMethod)!",
                    actionRequired: false
                )
                return true
            } else {
                createAlert(
                    for: fuelTanks[index],
                    type: .autoReloadFailed,
                    message: "Failed to add funds to your \(fuelTanks[index].brokerName) account. Please try again or contact support.",
                    actionRequired: true
                )
                return false
            }
        }
        
        // MARK: - Computed Properties
        
        var totalFuel: Double {
            fuelTanks.reduce(0) { $0 + $1.currentBalance }
        }
        
        var formattedTotalFuel: String {
            if totalFuel >= 1000 {
                return String(format: "$%.1fK", totalFuel / 1000)
            } else {
                return String(format: "$%.2f", totalFuel)
            }
        }
        
        var overallFuelStatus: FuelStatus {
            let averageBalance = totalFuel / Double(max(1, fuelTanks.count))
            let dummyTank = FuelTank(accountId: "", brokerName: "", currentBalance: averageBalance)
            return dummyTank.fuelStatus
        }
        
        var activeAlerts: [FuelAlert] {
            fuelAlerts.filter { !$0.acknowledged }
        }
        
        var activeTanks: [FuelTank] {
            fuelTanks.filter { $0.botsActive }
        }
        
        // MARK: - Notifications
        
        private func requestNotificationPermissions() {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                DispatchQueue.main.async {
                    self.notificationsEnabled = granted
                }
            }
        }
        
        private func sendPushNotification(alert: FuelAlert, tank: FuelTank) {
            let content = UNMutableNotificationContent()
            content.title = alert.alertType.title
            content.body = alert.message
            content.sound = alert.alertType.priority == .high ? .critical : .default
            content.badge = NSNumber(value: activeAlerts.count)
            
            let request = UNNotificationRequest(
                identifier: alert.id.uuidString,
                content: content,
                trigger: UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            )
            
            UNUserNotificationCenter.current().add(request)
        }
    }
}

// MARK: - Sample Data

extension TradingFuelModels.FuelTank {
    static let sampleTanks: [TradingFuelModels.FuelTank] = [
        TradingFuelModels.FuelTank(
            accountId: "845060",
            brokerName: "Coinexx",
            currentBalance: 245.75
        ),
        TradingFuelModels.FuelTank(
            accountId: "987654",
            brokerName: "Hankotrade",
            currentBalance: 89.20
        ),
        TradingFuelModels.FuelTank(
            accountId: "123456",
            brokerName: "FTMO Challenge",
            currentBalance: 1250.00
        )
    ]
}

#Preview("Trading Fuel Models") {
    Text("Trading Fuel System Preview")
        .font(.title)
        .padding()
}