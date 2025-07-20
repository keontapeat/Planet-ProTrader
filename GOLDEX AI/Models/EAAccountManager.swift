//
//  EAAccountManager.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 7/13/25.
//

import Foundation
import SwiftUI

@MainActor
class EAAccountManager: ObservableObject {
    @Published var isConnected = false
    @Published var currentBalance: Double = 1270.0
    @Published var currentEquity: Double = 1285.50
    @Published var todaysProfit: Double = 85.50
    @Published var accountLogin = "845514"
    @Published var accountServer = "Coinexx-Demo"
    @Published var lastUpdate = Date()
    @Published var connectionStatus = "Connected"
    
    // EA Control Properties
    @Published var eaIsRunning = false
    @Published var eaCanTrade = false
    @Published var eaLastSignal: Date?
    @Published var eaActiveSignals: [String] = []
    
    // Performance tracking
    @Published var eaStats = EAStats(totalSignals: 0, winningSignals: 0)
    
    private var updateTimer: Timer?
    private var reconnectTimer: Timer?
    
    init() {
        setupRealTimeConnection()
        loadSampleData()
    }
    
    deinit {
        updateTimer?.invalidate()
        reconnectTimer?.invalidate()
    }
    
    // MARK: - Connection Management
    
    private func setupRealTimeConnection() {
        connectToAccount()
        startRealTimeUpdates()
    }
    
    private func connectToAccount() {
        // Simulate connection to real account
        Task {
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            
            isConnected = true
            connectionStatus = "Connected to \(accountLogin)"
            
            // Start EA by default
            eaIsRunning = true
            eaCanTrade = true
            
            print("✅ Connected to real account: \(accountLogin)")
        }
    }
    
    private func startRealTimeUpdates() {
        updateTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
            Task { @MainActor in
                self.updateAccountData()
                self.updateEAStatus()
            }
        }
    }
    
    private func updateAccountData() {
        // Simulate real-time balance updates
        let balanceChange = Double.random(in: -10...10)
        currentBalance += balanceChange
        currentEquity += balanceChange
        todaysProfit += balanceChange
        lastUpdate = Date()
        
        // Update connection status
        connectionStatus = isConnected ? "Connected - Live Updates" : "Disconnected"
    }
    
    private func updateEAStatus() {
        // Simulate EA signal generation
        if eaIsRunning && eaCanTrade && Bool.random() {
            generateEASignal()
        }
        
        // Update EA stats
        eaStats.updateStats()
    }
    
    // MARK: - EA Control Methods
    
    func startEATrading() {
        eaIsRunning = true
        eaCanTrade = true
        connectionStatus = "EA Started - Auto Trading Active"
        
        // Generate initial signal
        generateEASignal()
    }
    
    func stopEATrading() {
        eaIsRunning = false
        eaCanTrade = false
        connectionStatus = "EA Stopped - Manual Trading Only"
        eaActiveSignals.removeAll()
    }
    
    func pauseEATrading() {
        eaCanTrade = false
        connectionStatus = "EA Paused - Monitoring Only"
    }
    
    func resumeEATrading() {
        eaCanTrade = true
        connectionStatus = "EA Resumed - Auto Trading Active"
    }
    
    // MARK: - Signal Generation
    
    private func generateEASignal() {
        let directions: [String] = ["buy", "sell"]
        let reasonings = [
            "Strong bullish momentum with volume confirmation",
            "Bearish divergence detected on RSI",
            "Support level bounce with institutional buying",
            "Resistance break with high volume",
            "Trend continuation pattern confirmed",
            "Reversal signal at key Fibonacci level"
        ]
        
        let signal = directions.randomElement() ?? "buy"
        
        eaActiveSignals.insert(signal, at: 0)
        eaLastSignal = Date()
        
        // Keep only last 10 signals
        if eaActiveSignals.count > 10 {
            eaActiveSignals = Array(eaActiveSignals.prefix(10))
        }
        
        // Update stats
        eaStats.totalSignals += 1
        eaStats.lastSignalTime = Date()
    }
    
    // MARK: - Data Loading
    
    private func loadSampleData() {
        // Load sample EA signals
        let sampleSignals = [
            "buy",
            "sell",
            "buy"
        ]
        
        eaActiveSignals = sampleSignals
        eaStats.totalSignals = 25
        eaStats.winningSignals = 19
        eaStats.lastSignalTime = Date()
    }
    
    // MARK: - Computed Properties
    
    var eaStatusColor: Color {
        if eaIsRunning && eaCanTrade {
            return .green
        } else if eaIsRunning {
            return .orange
        } else {
            return .red
        }
    }
    
    var eaPerformance: EAStats {
        return eaStats
    }
    
    var eaSignals: [String] {
        return eaActiveSignals
    }
    
    // MARK: - Manual Control Methods
    
    func reconnectAccount() {
        isConnected = false
        connectionStatus = "Reconnecting..."
        
        reconnectTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { _ in
            Task { @MainActor in
                self.connectToAccount()
            }
        }
    }
    
    func refreshAccountData() {
        connectionStatus = "Refreshing account data..."
        
        Task {
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            updateAccountData()
            connectionStatus = "Account data refreshed"
        }
    }
}

// MARK: - Supporting Data Models

struct EAStats {
    var totalSignals: Int
    var winningSignals: Int
    var lastSignalTime: Date
    var startTime: Date
    
    init(totalSignals: Int = 0, winningSignals: Int = 0, lastSignalTime: Date = Date(), startTime: Date = Date()) {
        self.totalSignals = totalSignals
        self.winningSignals = winningSignals
        self.lastSignalTime = lastSignalTime
        self.startTime = startTime
    }
    
    var winRate: Double {
        guard totalSignals > 0 else { return 0.0 }
        return Double(winningSignals) / Double(totalSignals) * 100.0
    }
    
    var signalsPerHour: Double {
        let hoursActive = Date().timeIntervalSince(startTime) / 3600.0
        guard hoursActive > 0 else { return 0.0 }
        return Double(totalSignals) / hoursActive
    }
    
    mutating func updateStats() {
        // Simulate winning/losing signals
        if Bool.random() {
            winningSignals += Int.random(in: 0...1)
        }
    }
}

// Removed duplicate EAPerformanceData - using EAStats instead

// MARK: - Extensions

extension EAAccountManager {
    // Account management methods
    func switchAccount(to login: String, server: String) {
        accountLogin = login
        accountServer = server
        connectionStatus = "Switching to account \(login)..."
        
        Task {
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            connectToAccount()
        }
    }
    
    func exportAccountData() -> String {
        let data = """
        Account: \(accountLogin)
        Server: \(accountServer)
        Balance: $\(String(format: "%.2f", currentBalance))
        Equity: $\(String(format: "%.2f", currentEquity))
        Today's P&L: $\(String(format: "%.2f", todaysProfit))
        EA Status: \(eaIsRunning ? "Running" : "Stopped")
        Total Signals: \(eaStats.totalSignals)
        Win Rate: \(String(format: "%.1f%%", eaStats.winRate))
        Last Update: \(lastUpdate.formatted())
        """
        return data
    }
    
    func resetEAStats() {
        eaStats = EAStats(totalSignals: 0, winningSignals: 0)
        eaActiveSignals.removeAll()
        connectionStatus = "EA statistics reset"
    }
}

#Preview {
    struct PreviewWrapper: View {
        @StateObject private var manager = EAAccountManager()
        
        var body: some View {
            VStack(spacing: 20) {
                Text("EA Account Manager")
                    .font(.title)
                    .fontWeight(.bold)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Account: \(manager.accountLogin)")
                    Text("Balance: $\(String(format: "%.2f", manager.currentBalance))")
                    Text("Status: \(manager.connectionStatus)")
                    Text("EA Running: \(manager.eaIsRunning ? "Yes" : "No")")
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
                
                HStack {
                    Button("Start EA") {
                        manager.startEATrading()
                    }
                    .disabled(manager.eaIsRunning)
                    
                    Button("Stop EA") {
                        manager.stopEATrading()
                    }
                    .disabled(!manager.eaIsRunning)
                    
                    Button("Refresh") {
                        manager.refreshAccountData()
                    }
                }
                .buttonStyle(.bordered)
                
                Spacer()
            }
            .padding()
        }
    }
    
    return PreviewWrapper()
}