//
//  NotificationExtensions.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 7/19/25.
//  Essential notification extensions for the GOLDEX AI system
//

import Foundation
import SwiftUI

// MARK: - Notification Helpers

struct GoldexNotificationCenter {
    
    // MARK: - Post Notifications
    
    static func postAccountBalanceUpdate(balance: Double, account: String) {
        NotificationCenter.default.post(
            name: .accountBalanceUpdated,
            object: nil,
            userInfo: [
                "balance": balance,
                "account": account,
                "timestamp": Date()
            ]
        )
    }
    
    static func postTradeExecuted(trade: Any, profit: Double) {
        NotificationCenter.default.post(
            name: .tradeExecuted,
            object: trade,
            userInfo: [
                "profit": profit,
                "timestamp": Date()
            ]
        )
    }
    
    static func postSignalGenerated(signal: Any, confidence: Double) {
        NotificationCenter.default.post(
            name: .signalGenerated,
            object: signal,
            userInfo: [
                "confidence": confidence,
                "timestamp": Date()
            ]
        )
    }
    
    static func postEAStatusChanged(isRunning: Bool, canTrade: Bool) {
        NotificationCenter.default.post(
            name: .eaStatusChanged,
            object: nil,
            userInfo: [
                "isRunning": isRunning,
                "canTrade": canTrade,
                "timestamp": Date()
            ]
        )
    }
    
    static func postFlipGoalCompleted(goalId: String, finalBalance: Double) {
        NotificationCenter.default.post(
            name: .flipGoalCompleted,
            object: nil,
            userInfo: [
                "goalId": goalId,
                "finalBalance": finalBalance,
                "timestamp": Date()
            ]
        )
    }
    
    static func postDebugSessionCompleted(sessionId: String, issuesFound: Int, fixesApplied: Int) {
        NotificationCenter.default.post(
            name: .debugSessionCompleted,
            object: nil,
            userInfo: [
                "sessionId": sessionId,
                "issuesFound": issuesFound,
                "fixesApplied": fixesApplied,
                "timestamp": Date()
            ]
        )
    }
    
    static func postPriceUpdate(symbol: String, price: Double, change: Double) {
        NotificationCenter.default.post(
            name: .priceUpdated,
            object: nil,
            userInfo: [
                "symbol": symbol,
                "price": price,
                "change": change,
                "timestamp": Date()
            ]
        )
    }
    
    static func postSystemHealthChanged(score: Double, status: String) {
        NotificationCenter.default.post(
            name: .systemHealthChanged,
            object: nil,
            userInfo: [
                "healthScore": score,
                "status": status,
                "timestamp": Date()
            ]
        )
    }
}

// MARK: - Additional Notification Names

extension Notification.Name {
    // Account Management
    static let accountConnectionChanged = Notification.Name("accountConnectionChanged")
    static let accountSwitched = Notification.Name("accountSwitched")
    
    // EA Status
    static let eaTradeExecuted = Notification.Name("eaTradeExecuted")
    static let eaSignalGenerated = Notification.Name("eaSignalGenerated")
    
    // Trading
    static let tradeClosed = Notification.Name("tradeClosed")
    
    // Flip Mode
    static let flipGoalCompleted = Notification.Name("flipGoalCompleted")
    static let flipModeStarted = Notification.Name("flipModeStarted")
    static let flipModeStopped = Notification.Name("flipModeStopped")
    
    // Auto Debug System
    static let debugSessionStarted = Notification.Name("debugSessionStarted")
    static let debugSessionCompleted = Notification.Name("debugSessionCompleted")
    static let errorDetected = Notification.Name("errorDetected")
    static let errorFixed = Notification.Name("errorFixed")
    static let systemHealthChanged = Notification.Name("systemHealthChanged")
    
    // Market Data
    static let marketSessionChanged = Notification.Name("marketSessionChanged")
    
    // VPS & Connection
    static let vpsDeploymentCompleted = Notification.Name("vpsDeploymentCompleted")
    static let vpsBotStatusChanged = Notification.Name("vpsBotStatusChanged")
    
    // AI Learning
    static let learningSessionCompleted = Notification.Name("learningSessionCompleted")
    static let patternLearned = Notification.Name("patternLearned")
    static let aiModelUpdated = Notification.Name("aiModelUpdated")
    
    // Performance
    static let performanceMetricsUpdated = Notification.Name("performanceMetricsUpdated")
    static let thermalStateChanged = Notification.Name("thermalStateChanged")
    
    // Firebase/Cloud
    static let cloudDataSynced = Notification.Name("cloudDataSynced")
    static let cloudConnectionChanged = Notification.Name("cloudConnectionChanged")
    static let dataBackupCompleted = Notification.Name("dataBackupCompleted")
    
    // UI/UX
    static let themeChanged = Notification.Name("themeChanged")
    static let settingsUpdated = Notification.Name("settingsUpdated")
    static let appBecameActive = Notification.Name("appBecameActive")
    static let appWentBackground = Notification.Name("appWentBackground")
}

// MARK: - Notification User Info Keys

struct NotificationUserInfoKey {
    // Account Keys
    static let balance = "balance"
    static let account = "account"
    static let accountId = "accountId"
    static let equity = "equity"
    static let margin = "margin"
    
    // Trading Keys
    static let tradeId = "tradeId"
    static let symbol = "symbol"
    static let direction = "direction"
    static let profit = "profit"
    static let lotSize = "lotSize"
    static let price = "price"
    static let change = "change"
    
    // Signal Keys
    static let signalId = "signalId"
    static let confidence = "confidence"
    static let reasoning = "reasoning"
    static let entryPrice = "entryPrice"
    static let stopLoss = "stopLoss"
    static let takeProfit = "takeProfit"
    
    // EA Keys
    static let isRunning = "isRunning"
    static let canTrade = "canTrade"
    static let eaVersion = "eaVersion"
    static let magic = "magic"
    
    // Debug Keys
    static let sessionId = "sessionId"
    static let errorId = "errorId"
    static let issuesFound = "issuesFound"
    static let fixesApplied = "fixesApplied"
    static let healthScore = "healthScore"
    static let status = "status"
    
    // Flip Mode Keys
    static let goalId = "goalId"
    static let startBalance = "startBalance"
    static let targetBalance = "targetBalance"
    static let finalBalance = "finalBalance"
    static let progress = "progress"
    
    // VPS Keys
    static let vpsId = "vpsId"
    static let connectionStatus = "connectionStatus"
    static let botCount = "botCount"
    static let deploymentId = "deploymentId"
    
    // System Keys
    static let timestamp = "timestamp"
    static let source = "source"
    static let userId = "userId"
    static let version = "version"
}

// MARK: - Preview

#if DEBUG

struct NotificationExtensionsPreview: View {
    @State private var notifications: [String] = []
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Notification System")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.orange)
                
                VStack(spacing: 12) {
                    Button("Post Account Balance Update") {
                        GoldexNotificationCenter.postAccountBalanceUpdate(balance: 1270.85, account: "Demo-845060")
                        notifications.append("Account balance updated: $1270.85")
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.orange)
                    .cornerRadius(8)
                    
                    Button("Post Trade Executed") {
                        GoldexNotificationCenter.postTradeExecuted(trade: "XAUUSD Buy", profit: 45.50)
                        notifications.append("Trade executed: +$45.50 profit")
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.orange)
                    .cornerRadius(8)
                    
                    Button("Post Signal Generated") {
                        GoldexNotificationCenter.postSignalGenerated(signal: "XAUUSD Signal", confidence: 0.89)
                        notifications.append("Signal generated: 89% confidence")
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.orange)
                    .cornerRadius(8)
                    
                    Button("Post EA Status Change") {
                        GoldexNotificationCenter.postEAStatusChanged(isRunning: true, canTrade: true)
                        notifications.append("EA Status: Running and trading enabled")
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.orange)
                    .cornerRadius(8)
                }
                
                if !notifications.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Recent Notifications:")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        ScrollView {
                            LazyVStack(alignment: .leading, spacing: 6) {
                                ForEach(notifications.reversed(), id: \.self) { notification in
                                    HStack {
                                        Image(systemName: "bell.fill")
                                            .foregroundColor(.orange)
                                            .font(.caption)
                                        
                                        Text(notification)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                        
                                        Spacer()
                                    }
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(.ultraThinMaterial)
                                    .cornerRadius(8)
                                }
                            }
                        }
                        .frame(maxHeight: 200)
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Notifications")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct NotificationExtensions_Previews: PreviewProvider {
    static var previews: some View {
        NotificationExtensionsPreview()
            .preferredColorScheme(.light)
    }
}
#endif