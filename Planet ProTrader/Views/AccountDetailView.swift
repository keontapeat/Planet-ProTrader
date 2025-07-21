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
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 24) {
                        // Account Header Card
                        accountHeaderCard
                        
                        // Quick Stats Grid
                        quickStatsGrid
                        
                        // Performance Chart Section
                        performanceSection
                        
                        // Recent Activity
                        recentActivitySection
                        
                        // Management Controls
                        managementSection
                        
                        Spacer(minLength: 40)
                    }
                    .padding()
                }
            }
            .navigationTitle(account.accountName)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(DesignSystem.primaryGold)
                            .font(.title2)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 16) {
                        Button(action: {
                            // Refresh action
                            refreshAccountData()
                        }) {
                            Image(systemName: "arrow.clockwise")
                                .foregroundColor(DesignSystem.primaryGold)
                                .font(.title3)
                        }
                        
                        Button(action: {
                            showingDeleteConfirmation = true
                        }) {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                                .font(.title3)
                        }
                    }
                }
            }
        }
        .onAppear {
            startRealTimeUpdates()
        }
        .onDisappear {
            refreshTimer?.invalidate()
        }
        .alert("Remove Account", isPresented: $showingDeleteConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Remove", role: .destructive) {
                accountManager.removeAccount(account)
                dismiss()
            }
        } message: {
            Text("This will permanently remove \(account.accountName) from your portfolio. This action cannot be undone.")
        }
    }
    
    // MARK: - Account Header Card
    
    private var accountHeaderCard: some View {
        UltraPremiumCard {
            VStack(spacing: 20) {
                // Top Row
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 12) {
                            // Connection Status
                            Circle()
                                .fill(account.isConnected ? .green : .red)
                                .frame(width: 12, height: 12)
                                .scaleEffect(account.isConnected ? 1.2 : 1.0)
                                .animation(
                                    .easeInOut(duration: 1.0)
                                    .repeatForever(autoreverses: true),
                                    value: account.isConnected
                                )
                            
                            Text(account.isConnected ? "CONNECTED" : "DISCONNECTED")
                                .font(.caption.bold())
                                .foregroundColor(account.isConnected ? .green : .red)
                        }
                        
                        Text(account.accountName)
                            .font(.title2.bold())
                            .foregroundColor(.white)
                        
                        Text("Login: \(account.login)")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 8) {
                        // Broker Badge
                        HStack(spacing: 6) {
                            Circle()
                                .fill(getBrokerColor(account.brokerType))
                                .frame(width: 8, height: 8)
                            
                            Text(account.brokerType.rawValue)
                                .font(.caption.bold())
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(getBrokerColor(account.brokerType).opacity(0.2))
                                .overlay(
                                    Capsule()
                                        .stroke(getBrokerColor(account.brokerType), lineWidth: 1)
                                )
                        )
                        
                        Text(account.server)
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                    }
                }
                
                // Balance Section
                HStack(spacing: 0) {
                    // Balance
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Balance")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                        
                        Text("$\(String(format: "%.2f", account.balance))")
                            .font(.title.bold())
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Equity
                    VStack(alignment: .center, spacing: 4) {
                        Text("Equity")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                        
                        Text("$\(String(format: "%.2f", account.equity))")
                            .font(.title2.bold())
                            .foregroundColor(DesignSystem.primaryGold)
                    }
                    .frame(maxWidth: .infinity)
                    
                    // Today's P&L
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Today's P&L")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                        
                        HStack(spacing: 4) {
                            Image(systemName: account.todaysPnL >= 0 ? "arrow.up.right" : "arrow.down.right")
                                .font(.caption)
                                .foregroundColor(account.todaysPnL >= 0 ? .green : .red)
                            
                            Text("\(account.todaysPnL >= 0 ? "+" : "")\(String(format: "%.2f", account.todaysPnL))")
                                .font(.headline.bold())
                                .foregroundColor(account.todaysPnL >= 0 ? .green : .red)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
            .padding(24)
        }
    }
    
    // MARK: - Quick Stats Grid
    
    private var quickStatsGrid: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 16) {
            
            // Drawdown Stat
            quickStatCard(
                title: "Max Drawdown",
                value: "\(String(format: "%.1f", account.drawdown))%",
                icon: "chart.line.downtrend.xyaxis",
                color: getRiskColor(account.drawdown)
            )
            
            // Free Margin
            quickStatCard(
                title: "Free Margin",
                value: "$\(String(format: "%.0f", account.equity * 0.7))",
                icon: "dollarsign.circle",
                color: .blue
            )
            
            // Margin Level
            quickStatCard(
                title: "Margin Level",
                value: "\(Int.random(in: 150...300))%",
                icon: "speedometer",
                color: .orange
            )
            
            // Leverage
            quickStatCard(
                title: "Leverage",
                value: "1:500",
                icon: "arrow.up.and.down.text.horizontal",
                color: .purple
            )
        }
    }
    
    private func quickStatCard(title: String, value: String, icon: String, color: Color) -> some View {
        UltraPremiumCard {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundColor(color)
                    
                    Spacer()
                    
                    Text(title)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }
                
                Text(value)
                    .font(.title2.bold())
                    .foregroundColor(.white)
            }
            .padding(16)
        }
    }
    
    // MARK: - Performance Section
    
    private var performanceSection: some View {
        UltraPremiumCard {
            VStack(alignment: .leading, spacing: 16) {
                Text("Performance Overview")
                    .font(.headline.bold())
                    .foregroundColor(.white)
                
                HStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("This Week")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                        
                        Text("+$\(Int.random(in: 50...500))")
                            .font(.title3.bold())
                            .foregroundColor(.green)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("This Month")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                        
                        Text("+$\(Int.random(in: 200...1500))")
                            .font(.title3.bold())
                            .foregroundColor(.green)
                    }
                    
                    Spacer()
                }
                
                // Mini Performance Chart Placeholder
                RoundedRectangle(cornerRadius: 12)
                    .fill(.ultraThinMaterial)
                    .frame(height: 80)
                    .overlay(
                        Text(" Performance Chart")
                            .foregroundColor(.white.opacity(0.6))
                    )
            }
            .padding(20)
        }
    }
    
    // MARK: - Recent Activity Section
    
    private var recentActivitySection: some View {
        UltraPremiumCard {
            VStack(alignment: .leading, spacing: 16) {
                Text("Recent Activity")
                    .font(.headline.bold())
                    .foregroundColor(.white)
                
                VStack(spacing: 12) {
                    ForEach(0..<3, id: \.self) { _ in
                        activityRow(
                            icon: ["arrow.up.circle.fill", "arrow.down.circle.fill", "gearshape.fill"].randomElement()!,
                            title: ["Trade Opened", "Trade Closed", "Settings Updated"].randomElement()!,
                            subtitle: "XAUUSD • \(Int.random(in: 10...60)) mins ago",
                            color: [.green, .red, .blue].randomElement()!
                        )
                    }
                }
            }
            .padding(20)
        }
    }
    
    private func activityRow(icon: String, title: String, subtitle: String, color: Color) -> some View {
        HStack(spacing: 12) {
            Circle()
                .fill(color.opacity(0.2))
                .frame(width: 36, height: 36)
                .overlay(
                    Image(systemName: icon)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(color)
                )
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline.bold())
                    .foregroundColor(.white)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.6))
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
    
    // MARK: - Management Section
    
    private var managementSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Account Management")
                .font(.headline.bold())
                .foregroundColor(.white)
                .padding(.horizontal)
            
            VStack(spacing: 12) {
                ManagementButton(
                    title: "Trading Settings",
                    subtitle: "Configure EA & risk parameters",
                    icon: "gearshape.2",
                    color: .blue
                ) {
                    // Trading settings
                }
                
                ManagementButton(
                    title: "Risk Management",
                    subtitle: "Adjust position sizing & limits",
                    icon: "shield",
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
            // In real app, this would fetch from broker API
        }
    }
    
    private func refreshAccountData() {
        // Refresh account data
        withAnimation(.spring()) {
            // Update UI with fresh data
        }
    }
}

// MARK: - Management Button Component

struct ManagementButton: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 44, height: 44)
                    .overlay(
                        Image(systemName: icon)
                            .font(.system(size: 18, weight: .medium))
                            .foregroundStyle(color)
                    )
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
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

// MARK: - Preview

#Preview {
    AccountDetailView(
        account: ProfessionalTradingAccount(
            accountName: "Main Trading",
            login: "845514",
            server: "Coinexx-Demo",
            brokerType: SharedTypes.BrokerType.coinexx,
            balance: 1270.0,
            equity: 1285.50,
            todaysPnL: 85.50,
            drawdown: 5.2,
            isConnected: true
        ),
        accountManager: MultiAccountManager()
    )
}