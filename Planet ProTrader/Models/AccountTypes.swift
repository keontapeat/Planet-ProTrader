//
//  AccountTypes.swift
//  Planet ProTrader
//
//  Created by Goldex AI on 7/19/25.
//  Updated by AI Assistant on 1/25/25.
//

import SwiftUI
import Foundation

// MARK: - Account Types

struct ProfessionalTradingAccount: Identifiable, Codable {
    let id = UUID()
    let accountName: String
    let login: String
    let server: String
    let brokerType: SharedTypes.BrokerType
    let balance: Double
    let equity: Double
    let todaysPnL: Double
    let drawdown: Double
    let isConnected: Bool
    let lastUpdate: Date
    
    init(
        accountName: String,
        login: String,
        server: String,
        brokerType: SharedTypes.BrokerType,
        balance: Double,
        equity: Double,
        todaysPnL: Double,
        drawdown: Double,
        isConnected: Bool,
        lastUpdate: Date = Date()
    ) {
        self.accountName = accountName
        self.login = login
        self.server = server
        self.brokerType = brokerType
        self.balance = balance
        self.equity = equity
        self.todaysPnL = todaysPnL
        self.drawdown = drawdown
        self.isConnected = isConnected
        self.lastUpdate = lastUpdate
    }
}

// MARK: - Enums

enum RiskStatus: String, CaseIterable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    case critical = "Critical"
    
    var color: Color {
        switch self {
        case .low: return .green
        case .medium: return .yellow
        case .high: return .orange
        case .critical: return .red
        }
    }
    
    var description: String {
        switch self {
        case .low: return "Low Risk"
        case .medium: return "Medium Risk"
        case .high: return "High Risk"
        case .critical: return "Critical Risk"
        }
    }
}

// MARK: - Multi Account Manager

@MainActor
class MultiAccountManager: ObservableObject {
    @Published var accounts: [ProfessionalTradingAccount] = []
    @Published var isLoading = false
    
    // Portfolio metrics
    var totalBalance: Double {
        accounts.reduce(0) { $0 + $1.balance }
    }
    
    var totalEquity: Double {
        accounts.reduce(0) { $0 + $1.equity }
    }
    
    var todaysPnL: Double {
        accounts.reduce(0) { $0 + $1.todaysPnL }
    }
    
    var maxDrawdown: Double {
        accounts.map(\.drawdown).max() ?? 0.0
    }
    
    // Performance metrics
    var overallWinRate: Double = 0.85
    var winRateTrend: TrendDirection = .up
    var profitFactor: Double = 2.35
    var profitFactorTrend: TrendDirection = .up
    var recoveryFactor: Double = 1.85
    var recoveryFactorTrend: TrendDirection = .sideways
    var monthlyReturn: Double = 12.5
    
    // Risk metrics
    var portfolioRisk: Double = 15.2
    var maxExposure: Double = 25.8
    var correlationRisk: Double = 8.5
    var marginUsed: Double = 45.2
    
    init() {
        loadSampleAccounts()
    }
    
    private func loadSampleAccounts() {
        accounts = [
            ProfessionalTradingAccount(
                accountName: "Main Trading",
                login: "845514",
                server: "Coinexx-Demo",
                brokerType: .coinexx,
                balance: 1270.0,
                equity: 1285.50,
                todaysPnL: 85.50,
                drawdown: 5.2,
                isConnected: true
            ),
            ProfessionalTradingAccount(
                accountName: "Scalping Account",
                login: "123456",
                server: "MetaQuotes-Demo",
                brokerType: .mt5,
                balance: 5000.0,
                equity: 4850.25,
                todaysPnL: -149.75,
                drawdown: 12.8,
                isConnected: true
            ),
            ProfessionalTradingAccount(
                accountName: "Swing Trading",
                login: "789012",
                server: "TradeLocker-Live",
                brokerType: .tradeLocker,
                balance: 10000.0,
                equity: 10250.80,
                todaysPnL: 250.80,
                drawdown: 3.1,
                isConnected: false
            )
        ]
    }
    
    func refreshAllAccounts() {
        isLoading = true
        
        Task {
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            
            // Simulate real-time updates
            for index in accounts.indices {
                accounts[index] = ProfessionalTradingAccount(
                    accountName: accounts[index].accountName,
                    login: accounts[index].login,
                    server: accounts[index].server,
                    brokerType: accounts[index].brokerType,
                    balance: accounts[index].balance + Double.random(in: -50...50),
                    equity: accounts[index].equity + Double.random(in: -50...50),
                    todaysPnL: accounts[index].todaysPnL + Double.random(in: -20...20),
                    drawdown: max(0, accounts[index].drawdown + Double.random(in: -2...2)),
                    isConnected: accounts[index].isConnected
                )
            }
            
            isLoading = false
        }
    }
    
    func updateRealTimeData() {
        // Simulate real-time price updates
        for index in accounts.indices {
            let priceChange = Double.random(in: -5...5)
            accounts[index] = ProfessionalTradingAccount(
                accountName: accounts[index].accountName,
                login: accounts[index].login,
                server: accounts[index].server,
                brokerType: accounts[index].brokerType,
                balance: accounts[index].balance,
                equity: accounts[index].equity + priceChange,
                todaysPnL: accounts[index].todaysPnL + priceChange,
                drawdown: accounts[index].drawdown,
                isConnected: accounts[index].isConnected
            )
        }
    }
    
    func addAccount(_ account: ProfessionalTradingAccount) {
        accounts.append(account)
    }
    
    func removeAccount(_ account: ProfessionalTradingAccount) {
        accounts.removeAll { $0.id == account.id }
    }
}