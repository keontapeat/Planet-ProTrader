//
//  AccountDetailView.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 7/13/25.
//

import SwiftUI

struct AccountDetailView: View {
    let account: ProfessionalTradingAccount
    @ObservedObject var accountManager: MultiAccountManager
    @Environment(\.dismiss) private var dismiss
    @State private var showingDeleteConfirmation = false
    @State private var refreshTimer: Timer?
    
    var body: some View {
        NavigationView {
            ZStack {
                // Premium background
                LinearGradient(
                    colors: [
                        Color(red: 0.05, green: 0.05, blue: 0.08),
                        Color(red: 0.08, green: 0.08, blue: 0.12)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 32) {
                        // Account Header
                        accountHeader
                        
                        // Real-time Balance
                        realTimeBalance
                        
                        // Performance Metrics
                        performanceMetrics
                        
                        // Risk Analysis
                        riskAnalysis
                        
                        // Trading Activity
                        tradingActivity
                        
                        // Account Management
                        accountManagement
                        
                        Spacer(minLength: 50)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                }
            }
            .navigationBarHidden(true)
            .overlay(
                VStack {
                    HStack {
                        Button("Done") {
                            dismiss()
                        }
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.white)
                        
                        Spacer()
                        
                        Text(account.accountName)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(.white)
                        
                        Spacer()
                        
                        Menu {
                            Button("Refresh Account") {
                                refreshAccount()
                            }
                            
                            Button("Export Data") {
                                exportAccountData()
                            }
                            
                            Button("Delete Account", role: .destructive) {
                                showingDeleteConfirmation = true
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                                .font(.system(size: 20))
                                .foregroundStyle(.white)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 60)
                    
                    Spacer()
                }
            )
            .onAppear {
                startRealTimeUpdates()
            }
            .onDisappear {
                stopRealTimeUpdates()
            }
            .confirmationDialog(
                "Delete Account",
                isPresented: $showingDeleteConfirmation,
                titleVisibility: .visible
            ) {
                Button("Delete Account", role: .destructive) {
                    accountManager.removeAccount(account)
                    dismiss()
                }
                
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Are you sure you want to remove this account from your portfolio? This action cannot be undone.")
            }
        }
    }
    
    // MARK: - Account Header
    
    private var accountHeader: some View {
        ProfessionalCard {
            VStack(spacing: 20) {
                HStack {
                    // Broker Icon
                    Image(systemName: account.brokerType.icon)
                        .font(.system(size: 32, weight: .bold))
                        .foregroundStyle(getBrokerColor(account.brokerType))
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(account.accountName)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(.white)
                        
                        Text(account.brokerType.rawValue)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(.white.opacity(0.7))
                    }
                    
                    Spacer()
                    
                    ConnectionStatusBadge(isConnected: account.isConnected)
                }
                
                // Account Details
                VStack(spacing: 12) {
                    HStack {
                        AccountDetailRow(title: "Login", value: account.login, icon: "person.circle", color: .blue)
                        Spacer()
                        AccountDetailRow(title: "Server", value: account.server, icon: "server.rack", color: .green)
                    }
                    
                    HStack {
                        AccountDetailRow(title: "Last Update", value: account.lastUpdate.formatted(date: .omitted, time: .shortened), icon: "clock", color: .orange)
                        Spacer()
                        AccountDetailRow(title: "Status", value: account.isConnected ? "Online" : "Offline", icon: "network", color: account.isConnected ? .green : .red)
                    }
                }
                .padding()
                .background(.white.opacity(0.05))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
    }
    
    // MARK: - Real-time Balance
    
    private var realTimeBalance: some View {
        ProfessionalCard {
            VStack(spacing: 20) {
                HStack {
                    Text("Account Balance")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(.white)
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Circle()
                            .fill(.green)
                            .frame(width: 8, height: 8)
                            .scaleEffect(1.2)
                            .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: account.isConnected)
                        
                        Text("Live")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(.green)
                    }
                }
                
                // Balance Display
                VStack(spacing: 16) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Balance")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(.white.opacity(0.7))
                            
                            Text("$\(String(format: "%.2f", account.balance))")
                                .font(.system(size: 32, weight: .black))
                                .foregroundStyle(.white)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            Text("Equity")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(.white.opacity(0.7))
                            
                            Text("$\(String(format: "%.2f", account.equity))")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundStyle(DesignSystem.primaryGold)
                        }
                    }
                    
                    // Today's P&L
                    VStack(spacing: 8) {
                        HStack {
                            Text("Today's P&L")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(.white.opacity(0.7))
                            
                            Spacer()
                            
                            Text("$\(String(format: "%.2f", account.todaysPnL))")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundStyle(account.todaysPnL >= 0 ? .green : .red)
                        }
                        
                        // P&L Progress Bar
                        GeometryReader { geometry in
                            HStack(spacing: 0) {
                                if account.todaysPnL < 0 {
                                    Rectangle()
                                        .fill(.red.opacity(0.7))
                                        .frame(width: geometry.size.width * min(abs(account.todaysPnL) / 500, 1.0))
                                }
                                
                                Spacer()
                                
                                if account.todaysPnL > 0 {
                                    Rectangle()
                                        .fill(.green.opacity(0.7))
                                        .frame(width: geometry.size.width * min(account.todaysPnL / 500, 1.0))
                                }
                            }
                        }
                        .frame(height: 6)
                        .background(.gray.opacity(0.3))
                        .clipShape(RoundedRectangle(cornerRadius: 3))
                    }
                }
            }
        }
    }
    
    // MARK: - Performance Metrics
    
    private var performanceMetrics: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Performance Metrics")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(.white)
            
            ProfessionalCard {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                    AccountMetricCard(
                        title: "Win Rate",
                        value: "78%",
                        change: "+2.1%",
                        changeColor: .green,
                        icon: "chart.line.uptrend.xyaxis"
                    )
                    
                    AccountMetricCard(
                        title: "Profit Factor",
                        value: "1.85",
                        change: "+0.15",
                        changeColor: .green,
                        icon: "arrow.up.right.circle"
                    )
                    
                    AccountMetricCard(
                        title: "Max Drawdown",
                        value: "\(String(format: "%.1f", account.drawdown))%",
                        change: account.drawdown > 10 ? "High" : "Normal",
                        changeColor: account.drawdown > 10 ? .red : .green,
                        icon: "arrow.down.right.circle"
                    )
                    
                    AccountMetricCard(
                        title: "Avg Trade",
                        value: "$25.80",
                        change: "+$3.20",
                        changeColor: .green,
                        icon: "dollarsign.circle"
                    )
                }
            }
        }
    }
    
    // MARK: - Risk Analysis
    
    private var riskAnalysis: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Risk Analysis")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(.white)
            
            ProfessionalCard {
                VStack(spacing: 16) {
                    RiskGauge(
                        title: "Overall Risk Level",
                        value: account.drawdown,
                        maxValue: 30,
                        color: getRiskColor(account.drawdown)
                    )
                    
                    HStack {
                        RiskIndicator(
                            title: "Position Size",
                            value: "2.5%",
                            status: .medium,
                            icon: "slider.horizontal.3"
                        )
                        
                        RiskIndicator(
                            title: "Correlation",
                            value: "Low",
                            status: .low,
                            icon: "link.circle"
                        )
                    }
                    
                    HStack {
                        RiskIndicator(
                            title: "Volatility",
                            value: "15.2%",
                            status: .medium,
                            icon: "waveform.path"
                        )
                        
                        RiskIndicator(
                            title: "Exposure",
                            value: "35%",
                            status: .high,
                            icon: "chart.bar.fill"
                        )
                    }
                }
            }
        }
    }
    
    // MARK: - Trading Activity
    
    private var tradingActivity: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Trading Activity")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(.white)
            
            ProfessionalCard {
                VStack(spacing: 16) {
                    HStack {
                        Text("Recent Trades")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.white)
                        
                        Spacer()
                        
                        Button("View All") {
                            // View all trades
                        }
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(DesignSystem.primaryGold)
                    }
                    
                    // Sample trades
                    VStack(spacing: 8) {
                        ForEach(0..<5) { index in
                            TradeRow(
                                symbol: "XAUUSD",
                                direction: index % 2 == 0 ? "BUY" : "SELL",
                                profit: Double.random(in: -50...100),
                                time: Date().addingTimeInterval(-Double(index * 3600))
                            )
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Account Management
    
    private var accountManagement: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Account Management")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(.white)
            
            ProfessionalCard {
                VStack(spacing: 16) {
                    ManagementButton(
                        title: "Refresh Account",
                        subtitle: "Update balance and data",
                        icon: "arrow.clockwise",
                        color: .blue
                    ) {
                        refreshAccount()
                    }
                    
                    ManagementButton(
                        title: "Export Data",
                        subtitle: "Download account report",
                        icon: "square.and.arrow.up",
                        color: .green
                    ) {
                        exportAccountData()
                    }
                    
                    ManagementButton(
                        title: "Risk Settings",
                        subtitle: "Configure risk parameters",
                        icon: "shield.checkerboard",
                        color: .orange
                    ) {
                        // Risk settings
                    }
                    
                    ManagementButton(
                        title: "Remove Account",
                        subtitle: "Delete from portfolio",
                        icon: "trash",
                        color: .red
                    ) {
                        showingDeleteConfirmation = true
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
    
    private func getRiskColor(_ risk: Double) -> Color {
        if risk > 20 { return .red }
        if risk > 10 { return .orange }
        return .green
    }
    
    private func startRealTimeUpdates() {
        refreshTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
            // Simulate real-time updates
        }
    }
    
    private func stopRealTimeUpdates() {
        refreshTimer?.invalidate()
        refreshTimer = nil
    }
    
    private func refreshAccount() {
        // Refresh account data
        accountManager.refreshAllAccounts()
    }
    
    private func exportAccountData() {
        // Export account data
        print("Exporting account data for \(account.accountName)")
    }
}

// MARK: - Supporting Views

struct ConnectionStatusBadge: View {
    let isConnected: Bool
    
    var body: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(isConnected ? .green : .red)
                .frame(width: 8, height: 8)
                .scaleEffect(isConnected ? 1.2 : 1.0)
                .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: isConnected)
            
            Text(isConnected ? "Online" : "Offline")
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(isConnected ? .green : .red)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background((isConnected ? Color.green : Color.red).opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}

struct AccountDetailRow: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 8))
                    .foregroundStyle(color)
                
                Text(title)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundStyle(.white.opacity(0.6))
            }
            
            Text(value)
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(.white)
        }
    }
}

struct AccountMetricCard: View {
    let title: String
    let value: String
    let change: String
    let changeColor: Color
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundStyle(.white.opacity(0.7))
                
                Text(title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(.white.opacity(0.7))
                
                Spacer()
            }
            
            HStack {
                Text(value)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.white)
                
                Spacer()
                
                Text(change)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundStyle(changeColor)
            }
        }
        .padding()
        .background(.white.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct RiskGauge: View {
    let title: String
    let value: Double
    let maxValue: Double
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.white.opacity(0.8))
                
                Spacer()
                
                Text("\(String(format: "%.1f", value))%")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(color)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(.gray.opacity(0.3))
                        .frame(height: 8)
                    
                    Rectangle()
                        .fill(color)
                        .frame(width: geometry.size.width * (value / maxValue), height: 8)
                }
            }
            .frame(height: 8)
            .clipShape(RoundedRectangle(cornerRadius: 4))
        }
    }
}

struct RiskIndicator: View {
    let title: String
    let value: String
    let status: RiskStatus
    let icon: String
    
    var body: some View {
        VStack(spacing: 6) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 12))
                    .foregroundStyle(status.color)
                
                Text(title)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundStyle(.white.opacity(0.7))
                
                Spacer()
            }
            
            Text(value)
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(status.color)
        }
        .frame(maxWidth: .infinity)
        .padding(8)
        .background(status.color.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}

struct TradeRow: View {
    let symbol: String
    let direction: String
    let profit: Double
    let time: Date
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(symbol)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(.white)
                
                Text(direction)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundStyle(direction == "BUY" ? .green : .red)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                Text("$\(String(format: "%.2f", profit))")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(profit >= 0 ? .green : .red)
                
                Text(time.formatted(date: .omitted, time: .shortened))
                    .font(.system(size: 10, weight: .medium))
                    .foregroundStyle(.white.opacity(0.6))
            }
        }
        .padding(.vertical, 4)
    }
}

struct ManagementButton: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(color)
                    .frame(width: 24)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.white)
                    
                    Text(subtitle)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(.white.opacity(0.7))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12))
                    .foregroundStyle(.white.opacity(0.5))
            }
            .padding()
            .background(color.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    AccountDetailView(
        account: ProfessionalTradingAccount(
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
        accountManager: MultiAccountManager()
    )
}