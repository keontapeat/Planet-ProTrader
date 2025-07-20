//
//  NotificationNames.swift
//  GOLDEX AI
//
//  Created by Alex on 1/15/25.
//

import Foundation
import SwiftUI

extension Notification.Name {
    // Account notifications
    static let accountBalanceUpdated = Notification.Name("accountBalanceUpdated")
    static let accountConnected = Notification.Name("accountConnected")
    static let accountDisconnected = Notification.Name("accountDisconnected")
    static let connectionStatusChanged = Notification.Name("connectionStatusChanged")
    
    // Trading notifications
    static let tradesUpdated = Notification.Name("tradesUpdated")
    static let tradeExecuted = Notification.Name("tradeExecuted")
    static let signalGenerated = Notification.Name("signalGenerated")
    static let performanceUpdated = Notification.Name("performanceUpdated")
    
    // EA and strategy notifications
    static let eaStatusChanged = Notification.Name("eaStatusChanged")
    static let strategyUpdated = Notification.Name("strategyUpdated")
    
    // Market data notifications
    static let marketDataUpdated = Notification.Name("marketDataUpdated")
    static let priceUpdated = Notification.Name("priceUpdated")
    
    // System and VPS notifications
    static let vpsConnectionChanged = Notification.Name("vpsConnectionChanged")
    static let memoryWarning = Notification.Name("memoryWarning")
    static let systemHealthCheck = Notification.Name("systemHealthCheck")
    static let backupCompleted = Notification.Name("backupCompleted")
    
    // Alert notifications
    static let alertTriggered = Notification.Name("alertTriggered")
    static let emergencyStop = Notification.Name("emergencyStop")
    static let riskLimitReached = Notification.Name("riskLimitReached")
    static let dailyTargetReached = Notification.Name("dailyTargetReached")
    
    // Feature-specific notifications
    static let flipCompleted = Notification.Name("flipCompleted")
    static let flipGoalUpdated = Notification.Name("flipGoalUpdated")
    static let aiInsightGenerated = Notification.Name("aiInsightGenerated")
}

#Preview("Notification Names") {
    VStack(spacing: 16) {
        Text("GOLDEX AI Notifications")
            .font(.title)
            .foregroundColor(.orange)
        
        VStack(alignment: .leading, spacing: 8) {
            Text("Account Notifications")
                .font(.headline)
            Text("• Account Balance Updated")
            Text("• Connection Status Changed")
            Text("• Account Connected/Disconnected")
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
        
        VStack(alignment: .leading, spacing: 8) {
            Text("Trading Notifications")
                .font(.headline)
            Text("• Trades Updated")
            Text("• Trade Executed")
            Text("• Signal Generated")
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
        
        VStack(alignment: .leading, spacing: 8) {
            Text("System Notifications")
                .font(.headline)
            Text("• EA Status Changed")
            Text("• Emergency Stop")
            Text("• Risk Limit Reached")
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
    .padding()
}