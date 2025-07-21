//
//  AutoTradingManager.swift
//  Planet ProTrader
//
//  Created by Senior iOS Engineer on 1/25/25.
//

import SwiftUI
import Combine

@MainActor
class AutoTradingManager: ObservableObject {
    @Published var isEnabled = false
    @Published var isRunning = false
    @Published var currentStrategy = "Conservative"
    @Published var todaysTrades = 0
    @Published var successfulTrades = 0
    @Published var performance = 0.0
    @Published var totalProfit = 0.0
    @Published var averageWinRate = 0.0
    @Published var maxDrawdown = 0.0
    @Published var riskLevel: RiskLevel = .medium
    @Published var autoStopEnabled = true
    @Published var maxDailyLoss = 100.0
    @Published var maxDailyTrades = 20
    
    enum RiskLevel: String, CaseIterable {
        case low = "Conservative"
        case medium = "Moderate"
        case high = "Aggressive"
        
        var color: Color {
            switch self {
            case .low: return .green
            case .medium: return .orange
            case .high: return .red
            }
        }
    }
    
    enum AutoTradingStatus: String {
        case stopped = "Stopped"
        case running = "Running" 
        case paused = "Paused"
        case error = "Error"
    }
    
    @Published var status: AutoTradingStatus = .stopped
    @Published var lastTradeTime: Date?
    @Published var nextTradeEstimate: Date?
    
    init() {
        // Initialize with default values
        setupDefaults()
    }
    
    private func setupDefaults() {
        todaysTrades = Int.random(in: 8...15)
        successfulTrades = Int(Double(todaysTrades) * 0.85)
        averageWinRate = Double(successfulTrades) / Double(max(todaysTrades, 1)) * 100
        totalProfit = Double.random(in: 150...500)
        performance = averageWinRate / 100
        maxDrawdown = Double.random(in: 2...8)
    }
    
    func startAutoTrading() {
        isEnabled = true
        isRunning = true
        status = .running
        lastTradeTime = Date()
        nextTradeEstimate = Date().addingTimeInterval(Double.random(in: 300...1800)) // 5-30 minutes
    }
    
    func stopAutoTrading() {
        isEnabled = false
        isRunning = false
        status = .stopped
        nextTradeEstimate = nil
    }
    
    func pauseAutoTrading() {
        isRunning = false
        status = .paused
    }
    
    func resumeAutoTrading() {
        guard isEnabled else { return }
        isRunning = true
        status = .running
    }
    
    var statusColor: Color {
        switch status {
        case .stopped: return .gray
        case .running: return .green
        case .paused: return .orange
        case .error: return .red
        }
    }
    
    var formattedPerformance: String {
        String(format: "%.1f%%", performance * 100)
    }
    
    var formattedTotalProfit: String {
        String(format: "$%.2f", totalProfit)
    }
    
    var formattedWinRate: String {
        String(format: "%.1f%%", averageWinRate)
    }
    
    var tradingEfficiency: Double {
        guard todaysTrades > 0 else { return 0.0 }
        return Double(successfulTrades) / Double(todaysTrades)
    }
}

#Preview {
    VStack(spacing: 16) {
        Text("Auto Trading Manager")
            .font(.title)
            .fontWeight(.bold)
        
        VStack(alignment: .leading, spacing: 8) {
            Text("Status: Running")
                .foregroundColor(.green)
            Text("Today's Trades: 12")
            Text("Success Rate: 87.5%")
            Text("Total Profit: $347.50")
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
    .padding()
    .environmentObject(AutoTradingManager())
}