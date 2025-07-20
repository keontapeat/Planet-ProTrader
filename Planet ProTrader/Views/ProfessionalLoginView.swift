//
//  ProfessionalLoginView.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 7/13/25.
//

import SwiftUI

struct ProfessionalLoginView: View {
    @StateObject private var loginManager = ProfessionalLoginManager()
    @StateObject private var accountManager = MultiAccountManager()
    @State private var showingAddAccount = false
    @State private var selectedBroker: SharedTypes.BrokerType = .mt5
    @State private var showingAccountDetails = false
    @State private var selectedAccount: ProfessionalTradingAccount?
    @State private var refreshTimer: Timer?
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Premium background
                LinearGradient(
                    colors: [
                        Color(red: 0.05, green: 0.05, blue: 0.08),
                        Color(red: 0.08, green: 0.08, blue: 0.12),
                        Color(red: 0.12, green: 0.12, blue: 0.16)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 32) {
                        // Premium Header
                        premiumHeader
                        
                        // Portfolio Overview
                        portfolioOverview
                        
                        // Quick Actions
                        quickActions
                        
                        // Account Management
                        accountManagement
                        
                        // Performance Analytics
                        performanceAnalytics
                        
                        // Risk Management
                        riskManagement
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                startRealTimeUpdates()
            }
            .onDisappear {
                stopRealTimeUpdates()
            }
            .sheet(isPresented: $showingAddAccount) {
                AddAccountView(accountManager: accountManager)
            }
            .sheet(item: $selectedAccount) { account in
                AccountDetailView(account: account, accountManager: accountManager)
            }
        }
    }
    
    // MARK: - Premium Header
    
    private var premiumHeader: some View {
        VStack(spacing: 24) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("GOLDEX")
                        .font(.system(size: 32, weight: .black, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [DesignSystem.primaryGold, .orange, .yellow],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                    
                    Text("Professional Trading Terminal")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.white.opacity(0.8))
                }
                
                Spacer()
                
                Button(action: { showingAddAccount = true }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(DesignSystem.primaryGold)
                }
            }
            
            // Real-time status indicator
            HStack {
                Circle()
                    .fill(.green)
                    .frame(width: 8, height: 8)
                    .scaleEffect(1.2)
                    .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: true)
                
                Text("Real-time Data Active")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(.green)
                
                Spacer()
                
                Text("Last Updated: \(Date().formatted(date: .omitted, time: .shortened))")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(.white.opacity(0.6))
            }
        }
    }
    
    // MARK: - Portfolio Overview
    
    private var portfolioOverview: some View {
        ProfessionalCard {
            VStack(spacing: 20) {
                HStack {
                    Text("Portfolio Overview")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(.white)
                    
                    Spacer()
                    
                    Button(action: { accountManager.refreshAllAccounts() }) {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(DesignSystem.primaryGold)
                    }
                }
                
                // Total Balance Display
                VStack(spacing: 12) {
                    Text("Total Balance")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.white.opacity(0.8))
                    
                    Text("$\(String(format: "%.2f", accountManager.totalBalance))")
                        .font(.system(size: 48, weight: .black, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [DesignSystem.primaryGold, .orange],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    HStack(spacing: 24) {
                        VStack(spacing: 4) {
                            Text("Today's P&L")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundStyle(.white.opacity(0.7))
                            
                            Text("$\(String(format: "%.2f", accountManager.todaysPnL))")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundStyle(accountManager.todaysPnL >= 0 ? .green : .red)
                        }
                        
                        VStack(spacing: 4) {
                            Text("Total Equity")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundStyle(.white.opacity(0.7))
                            
                            Text("$\(String(format: "%.2f", accountManager.totalEquity))")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundStyle(.white)
                        }
                        
                        VStack(spacing: 4) {
                            Text("Max Drawdown")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundStyle(.white.opacity(0.7))
                            
                            Text("\(String(format: "%.1f", accountManager.maxDrawdown))%")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundStyle(accountManager.maxDrawdown > 10 ? .red : .orange)
                        }
                    }
                }
                
                // Portfolio Distribution
                VStack(alignment: .leading, spacing: 8) {
                    Text("Portfolio Distribution")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.9))
                    
                    HStack(spacing: 4) {
                        ForEach(accountManager.accounts.indices, id: \.self) { index in
                            let account = accountManager.accounts[index]
                            let percentage = account.balance / accountManager.totalBalance
                            
                            Rectangle()
                                .fill(getBrokerColor(account.brokerType))
                                .frame(height: 8)
                                .frame(maxWidth: .infinity)
                                .scaleEffect(x: percentage, anchor: .leading)
                                .clipShape(RoundedRectangle(cornerRadius: 4))
                        }
                    }
                    
                    HStack {
                        ForEach(Array(Set(accountManager.accounts.map(\.brokerType))), id: \.self) { brokerType in
                            HStack(spacing: 4) {
                                Circle()
                                    .fill(getBrokerColor(brokerType))
                                    .frame(width: 8, height: 8)
                                
                                Text(brokerType.rawValue)
                                    .font(.system(size: 10, weight: .medium))
                                    .foregroundStyle(.white.opacity(0.7))
                            }
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Quick Actions
    
    private var quickActions: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Quick Actions")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(.white)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                QuickActionCard(
                    title: "Add Account",
                    subtitle: "Connect new broker",
                    icon: "plus.circle.fill",
                    color: .blue
                ) {
                    showingAddAccount = true
                }
                
                QuickActionCard(
                    title: "Sync All",
                    subtitle: "Refresh balances",
                    icon: "arrow.triangle.2.circlepath",
                    color: .green
                ) {
                    accountManager.refreshAllAccounts()
                }
                
                QuickActionCard(
                    title: "Risk Analysis",
                    subtitle: "Portfolio health",
                    icon: "shield.checkerboard",
                    color: .orange
                ) {
                    // Risk analysis action
                }
                
                QuickActionCard(
                    title: "Export Data",
                    subtitle: "Download reports",
                    icon: "square.and.arrow.up",
                    color: .purple
                ) {
                    // Export action
                }
            }
        }
    }
    
    // MARK: - Account Management
    
    private var accountManagement: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Connected Accounts")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.white)
                
                Spacer()
                
                Text("\(accountManager.accounts.count) accounts")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.white.opacity(0.7))
            }
            
            if accountManager.accounts.isEmpty {
                EmptyAccountsCard {
                    showingAddAccount = true
                }
            } else {
                LazyVStack(spacing: 12) {
                    ForEach(accountManager.accounts) { account in
                        ProfessionalAccountCard(account: account) {
                            selectedAccount = account
                            showingAccountDetails = true
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Performance Analytics
    
    private var performanceAnalytics: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Performance Analytics")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(.white)
            
            ProfessionalCard {
                VStack(spacing: 16) {
                    HStack {
                        PerformanceMetric(
                            title: "Win Rate",
                            value: "\(Int(accountManager.overallWinRate * 100))%",
                            trend: accountManager.winRateTrend,
                            color: .green
                        )
                        
                        PerformanceMetric(
                            title: "Profit Factor",
                            value: String(format: "%.2f", accountManager.profitFactor),
                            trend: accountManager.profitFactorTrend,
                            color: .blue
                        )
                        
                        PerformanceMetric(
                            title: "Recovery Factor",
                            value: String(format: "%.2f", accountManager.recoveryFactor),
                            trend: accountManager.recoveryFactorTrend,
                            color: .orange
                        )
                    }
                    
                    // Performance chart placeholder
                    VStack(spacing: 8) {
                        HStack {
                            Text("30-Day Performance")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(.white.opacity(0.8))
                            
                            Spacer()
                            
                            Text("+\(String(format: "%.1f", accountManager.monthlyReturn))%")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundStyle(.green)
                        }
                        
                        // Mini chart
                        HStack(spacing: 2) {
                            ForEach(0..<30, id: \.self) { index in
                                let height = CGFloat.random(in: 10...40)
                                let color = index % 3 == 0 ? Color.red : (index % 2 == 0 ? Color.green : DesignSystem.primaryGold)
                                
                                Rectangle()
                                    .fill(color.opacity(0.7))
                                    .frame(width: 3, height: height)
                                    .clipShape(RoundedRectangle(cornerRadius: 1))
                            }
                        }
                        .frame(height: 40)
                    }
                }
            }
        }
    }
    
    // MARK: - Risk Management
    
    private var riskManagement: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Risk Management")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(.white)
            
            ProfessionalCard {
                VStack(spacing: 16) {
                    HStack {
                        RiskMetric(
                            title: "Portfolio Risk",
                            value: "\(String(format: "%.1f", accountManager.portfolioRisk))%",
                            status: accountManager.portfolioRisk > 20 ? .high : (accountManager.portfolioRisk > 10 ? .medium : .low),
                            icon: "exclamationmark.triangle.fill"
                        )
                        
                        RiskMetric(
                            title: "Max Exposure",
                            value: "\(String(format: "%.1f", accountManager.maxExposure))%",
                            status: accountManager.maxExposure > 30 ? .high : .medium,
                            icon: "chart.bar.fill"
                        )
                    }
                    
                    HStack {
                        RiskMetric(
                            title: "Correlation Risk",
                            value: "\(String(format: "%.1f", accountManager.correlationRisk))%",
                            status: accountManager.correlationRisk > 15 ? .high : .low,
                            icon: "link"
                        )
                        
                        RiskMetric(
                            title: "Margin Used",
                            value: "\(String(format: "%.1f", accountManager.marginUsed))%",
                            status: accountManager.marginUsed > 80 ? .high : (accountManager.marginUsed > 50 ? .medium : .low),
                            icon: "gauge"
                        )
                    }
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func getBrokerColor(_ brokerType: SharedTypes.BrokerType) -> Color {
        switch brokerType {
        case .mt5: return .blue
        case .mt4: return .cyan
        case .coinexx: return .orange
        case .tradeLocker: return .purple
        case .xtb: return .green
        case .hankotrade: return .red
        case .manual: return .gray
        case .forex: return .yellow
        }
    }
    
    private func startRealTimeUpdates() {
        refreshTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
            accountManager.updateRealTimeData()
        }
    }
    
    private func stopRealTimeUpdates() {
        refreshTimer?.invalidate()
        refreshTimer = nil
    }
}

// MARK: - Supporting Views


struct QuickActionCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(color)
                
                VStack(spacing: 4) {
                    Text(title)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(.white)
                    
                    Text(subtitle)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(.white.opacity(0.7))
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 100)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(color.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(color.opacity(0.3), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ProfessionalAccountCard: View {
    let account: ProfessionalTradingAccount
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                // Broker Icon
                VStack(spacing: 4) {
                    Image(systemName: account.brokerType.icon)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(getBrokerColor(account.brokerType))
                    
                    Text(account.brokerType.rawValue)
                        .font(.system(size: 10, weight: .medium))
                        .foregroundStyle(.white.opacity(0.7))
                }
                .frame(width: 60)
                
                // Account Info
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(account.accountName)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(.white)
                        
                        Spacer()
                        
                        ConnectionStatusIndicator(isConnected: account.isConnected)
                    }
                    
                    Text("Login: \(account.login)")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(.white.opacity(0.7))
                    
                    Text(account.server)
                        .font(.system(size: 10, weight: .medium))
                        .foregroundStyle(.white.opacity(0.5))
                }
                
                Spacer()
                
                // Balance & Performance
                VStack(alignment: .trailing, spacing: 4) {
                    Text("$\(String(format: "%.2f", account.balance))")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(.white)
                    
                    HStack(spacing: 8) {
                        Text("Equity: $\(String(format: "%.0f", account.equity))")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundStyle(.white.opacity(0.7))
                        
                        DrawdownIndicator(drawdown: account.drawdown)
                    }
                    
                    Text("P&L: $\(String(format: "%.2f", account.todaysPnL))")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(account.todaysPnL >= 0 ? .green : .red)
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(getBrokerColor(account.brokerType).opacity(0.3), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func getBrokerColor(_ brokerType: SharedTypes.BrokerType) -> Color {
        switch brokerType {
        case .mt5: return .blue
        case .mt4: return .cyan
        case .coinexx: return .orange
        case .tradeLocker: return .purple
        case .xtb: return .green
        case .hankotrade: return .red
        case .manual: return .gray
        case .forex: return .yellow
        }
    }
}

struct ConnectionStatusIndicator: View {
    let isConnected: Bool
    
    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(isConnected ? .green : .red)
                .frame(width: 6, height: 6)
                .scaleEffect(isConnected ? 1.2 : 1.0)
                .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: isConnected)
            
            Text(isConnected ? "Online" : "Offline")
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(isConnected ? .green : .red)
        }
    }
}

struct DrawdownIndicator: View {
    let drawdown: Double
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "arrow.down.circle.fill")
                .font(.system(size: 10))
                .foregroundStyle(getDrawdownColor())
            
            Text("\(String(format: "%.1f", drawdown))%")
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(getDrawdownColor())
        }
        .padding(.horizontal, 6)
        .padding(.vertical, 2)
        .background(getDrawdownColor().opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 4))
    }
    
    private func getDrawdownColor() -> Color {
        if drawdown > 20 { return .red }
        if drawdown > 10 { return .orange }
        return .green
    }
}

struct PerformanceMetric: View {
    let title: String
    let value: String
    let trend: TrendDirection
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(.white.opacity(0.7))
                
                Spacer()
                
                Image(systemName: trend.icon)
                    .font(.system(size: 10))
                    .foregroundStyle(trend.color)
            }
            
            Text(value)
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(color)
        }
        .frame(maxWidth: .infinity)
        .padding(12)
        .background(color.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct RiskMetric: View {
    let title: String
    let value: String
    let status: RiskStatus
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 12))
                    .foregroundStyle(status.color)
                
                Text(title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(.white.opacity(0.7))
                
                Spacer()
            }
            
            Text(value)
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(status.color)
        }
        .frame(maxWidth: .infinity)
        .padding(12)
        .background(status.color.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct EmptyAccountsCard: View {
    let action: () -> Void
    
    var body: some View {
        ProfessionalCard {
            VStack(spacing: 16) {
                Image(systemName: "plus.circle.dashed")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundStyle(DesignSystem.primaryGold)
                
                VStack(spacing: 8) {
                    Text("No Accounts Connected")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(.white)
                    
                    Text("Connect your trading accounts to start monitoring your portfolio")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                }
                
                Button("Add Your First Account") {
                    action()
                }
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.black)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(DesignSystem.primaryGold)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
    }
}

@MainActor
class ProfessionalLoginManager: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: String = ""
    @Published var securityLevel: String = "Professional"
    
    func authenticate(username: String, password: String) async -> Bool {
        // Professional authentication logic
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        isAuthenticated = true
        currentUser = username
        return true
    }
    
    func logout() {
        isAuthenticated = false
        currentUser = ""
    }
}

#Preview {
    ProfessionalLoginView()
}