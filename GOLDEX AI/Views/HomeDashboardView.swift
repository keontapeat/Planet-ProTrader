//
//  HomeDashboardView.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 7/17/25.
//

import SwiftUI
import Combine

struct HomeDashboardView: View {
    // MARK: - Environment Objects
    @EnvironmentObject var tradingViewModel: TradingViewModel
    @EnvironmentObject var realTimeAccountManager: RealTimeAccountManager
    
    // MARK: - State Objects
    @StateObject private var autoTradingManager = AutoTradingManager()
    @StateObject private var brokerConnector = BrokerConnector()
    @StateObject private var realDataManager = RealDataManager()
    
    // MARK: - UI State
    @State private var selectedAccount = 0
    @State private var showingAccountSwitcher = false
    @State private var showingAddAccount = false
    @State private var animateCards = false
    @State private var refreshTimer: Timer?
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                LinearGradient(
                    colors: [
                        Color(.systemBackground),
                        DesignSystem.primaryGold.opacity(0.02),
                        Color(.systemBackground)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    LazyVStack(spacing: 20) {
                        // Account Header
                        accountHeader
                        
                        // Trading Control
                        tradingControlSection
                        
                        // Market Overview
                        marketOverviewSection
                        
                        // Performance Section
                        performanceSection
                        
                        // Quick Actions
                        quickActionsSection
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 16)
                }
                .refreshable {
                    await refreshAllData()
                }
            }
            .navigationTitle("")
            .navigationBarHidden(true)
            .onAppear {
                startRealTimeUpdates()
                startAnimations()
            }
            .onDisappear {
                stopRealTimeUpdates()
            }
        }
        .sheet(isPresented: $showingAccountSwitcher) {
            AccountSwitcherView()
        }
        .sheet(isPresented: $showingAddAccount) {
            AddNewAccountView()
        }
    }
    
    // MARK: - Account Header
    private var accountHeader: some View {
        VStack(spacing: 16) {
            // Top Navigation
            HStack {
                // Logo
                HStack(spacing: 8) {
                    ZStack {
                        Circle()
                            .fill(DesignSystem.goldGradient)
                            .frame(width: 32, height: 32)
                        
                        Image(systemName: "brain.head.profile")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("GOLDEX AI")
                            .font(.system(size: 18, weight: .black, design: .rounded))
                            .foregroundColor(DesignSystem.primaryGold)
                        
                        Text("Elite Trading System")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                // Account Switcher
                Button(action: { showingAccountSwitcher = true }) {
                    HStack(spacing: 8) {
                        Circle()
                            .fill(currentAccount.isLive ? Color.green : Color.orange)
                            .frame(width: 8, height: 8)
                        
                        VStack(alignment: .trailing, spacing: 2) {
                            Text(currentAccount.displayName)
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.primary)
                            
                            Text(currentAccount.formattedBalance)
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(DesignSystem.primaryGold)
                        }
                        
                        Image(systemName: "chevron.down.circle.fill")
                            .font(.system(size: 20))
                            .foregroundColor(DesignSystem.primaryGold)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            .padding(.top, 8)
            
            // Account Summary
            UltraPremiumCard {
                VStack(spacing: 16) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("TOTAL EQUITY")
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundColor(.secondary)
                            
                            Text(realTimeAccountManager.formattedEquity)
                                .font(.system(size: 28, weight: .black, design: .rounded))
                                .foregroundColor(.primary)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            HStack(spacing: 4) {
                                Image(systemName: realTimeAccountManager.todaysProfit >= 0 ? "arrow.up.right" : "arrow.down.right")
                                    .font(.system(size: 12, weight: .bold))
                                Text(realTimeAccountManager.formattedTodaysProfit)
                                    .font(.system(size: 16, weight: .bold))
                            }
                            .foregroundColor(realTimeAccountManager.todaysProfitColor)
                            
                            Text("Today")
                                .font(.system(size: 11, weight: .medium))
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    HStack(spacing: 20) {
                        MetricView(title: "Balance", value: realTimeAccountManager.formattedBalance, color: .primary)
                        MetricView(title: "Open P&L", value: realTimeAccountManager.formattedOpenPL, color: realTimeAccountManager.openPLColor)
                        MetricView(title: "Win Rate", value: realTimeAccountManager.formattedWinRate, color: .green)
                    }
                }
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.95)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1), value: animateCards)
    }
    
    // MARK: - Trading Control Section
    private var tradingControlSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("🤖 AI Trading Control")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                
                Spacer()
                
                // Status indicator
                HStack(spacing: 6) {
                    Circle()
                        .fill(tradingViewModel.isAutoTradingEnabled ? Color.green : Color.red)
                        .frame(width: 8, height: 8)
                    
                    Text(tradingViewModel.isAutoTradingEnabled ? "AI ACTIVE" : "AI INACTIVE")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(tradingViewModel.isAutoTradingEnabled ? .green : .red)
                }
            }
            
            UltraPremiumCard {
                VStack(spacing: 20) {
                    // Status Display
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("AI STATUS")
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundColor(.secondary)
                            
                            Text(tradingViewModel.autoTradingStatusText)
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(tradingViewModel.autoTradingStatusColor)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            Text("CONFIDENCE")
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundColor(.secondary)
                            
                            Text("92%")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(DesignSystem.primaryGold)
                        }
                    }
                    
                    // Control Buttons
                    HStack(spacing: 12) {
                        Button(action: {
                            tradingViewModel.startAutoTrading()
                        }) {
                            HStack {
                                Image(systemName: "play.fill")
                                    .font(.system(size: 14, weight: .bold))
                                Text("START AI")
                                    .font(.system(size: 14, weight: .bold))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(
                                LinearGradient(
                                    colors: [Color.green, Color.green.opacity(0.8)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .disabled(tradingViewModel.isAutoTradingEnabled)
                        
                        Button(action: {
                            tradingViewModel.stopAutoTrading()
                        }) {
                            HStack {
                                Image(systemName: "stop.fill")
                                    .font(.system(size: 14, weight: .bold))
                                Text("STOP AI")
                                    .font(.system(size: 14, weight: .bold))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(
                                LinearGradient(
                                    colors: [Color.red, Color.red.opacity(0.8)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .disabled(!tradingViewModel.isAutoTradingEnabled)
                    }
                }
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.95)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2), value: animateCards)
    }
    
    // MARK: - Market Overview Section
    private var marketOverviewSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("📈 Live Gold Market")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                
                Spacer()
                
                Text("XAUUSD")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(DesignSystem.primaryGold)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(DesignSystem.primaryGold.opacity(0.1))
                    .clipShape(Capsule())
            }
            
            UltraPremiumCard {
                VStack(spacing: 16) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("CURRENT PRICE")
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundColor(.secondary)
                            
                            Text(tradingViewModel.formattedCurrentPrice)
                                .font(.system(size: 32, weight: .black, design: .rounded))
                                .foregroundColor(.primary)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            HStack(spacing: 4) {
                                Image(systemName: tradingViewModel.priceChange >= 0 ? "arrow.up.right" : "arrow.down.right")
                                    .font(.system(size: 12, weight: .bold))
                                Text(tradingViewModel.formattedPriceChange)
                                    .font(.system(size: 16, weight: .bold))
                            }
                            .foregroundColor(tradingViewModel.priceColor)
                            
                            Text("Last 1H")
                                .font(.system(size: 11, weight: .medium))
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    HStack(spacing: 20) {
                        MetricView(title: "High", value: "$2,380.50", color: .green)
                        MetricView(title: "Low", value: "$2,365.20", color: .red)
                        MetricView(title: "Volume", value: "High", color: .orange)
                    }
                }
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.95)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3), value: animateCards)
    }
    
    // MARK: - Performance Section
    private var performanceSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("📊 Performance Analytics")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
            
            UltraPremiumCard {
                VStack(spacing: 20) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("WIN RATE")
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundColor(.secondary)
                            
                            Text("87.5%")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.green)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            Text("TOTAL TRADES")
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundColor(.secondary)
                            
                            Text("156")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.blue)
                        }
                    }
                    
                    HStack(spacing: 20) {
                        MetricView(title: "Profit Factor", value: "2.43", color: DesignSystem.primaryGold)
                        MetricView(title: "Max Drawdown", value: "3.2%", color: .red)
                        MetricView(title: "Avg Trade", value: "$24.5", color: .green)
                    }
                }
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.95)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.4), value: animateCards)
    }
    
    // MARK: - Quick Actions Section
    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("⚡ Quick Actions")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                HomeQuickActionButton(icon: "chart.xyaxis.line", title: "View Charts", color: Color.blue) {
                    // Chart action
                }
                
                HomeQuickActionButton(icon: "gearshape.fill", title: "AI Settings", color: DesignSystem.primaryGold) {
                    // Settings action
                }
                
                HomeQuickActionButton(icon: "plus.circle.fill", title: "Add Account", color: Color.green) {
                    showingAddAccount = true
                }
                
                HomeQuickActionButton(icon: "doc.text.fill", title: "Trade Journal", color: Color.purple) {
                    // Journal action
                }
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.95)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.5), value: animateCards)
    }
    
    // MARK: - Helper Methods
    private func startRealTimeUpdates() {
        refreshTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
            Task { @MainActor in
                tradingViewModel.refreshAllData()
                realTimeAccountManager.refreshAccountData()
            }
        }
    }
    
    private func stopRealTimeUpdates() {
        refreshTimer?.invalidate()
        refreshTimer = nil
    }
    
    private func startAnimations() {
        withAnimation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.2)) {
            animateCards = true
        }
    }
    
    private func refreshAllData() async {
        await realTimeAccountManager.refreshAccountData()
        tradingViewModel.refreshAllData()
    }
    
    // MARK: - Computed Properties
    private var currentAccount: (displayName: String, formattedBalance: String, isLive: Bool) {
        if realTimeAccountManager.activeAccounts.indices.contains(selectedAccount) {
            let account = realTimeAccountManager.activeAccounts[selectedAccount]
            return (
                displayName: account.name,
                formattedBalance: account.formattedBalance,
                isLive: !account.isDemo
            )
        }
        return (
            displayName: "Demo Account",
            formattedBalance: realTimeAccountManager.formattedBalance,
            isLive: false
        )
    }
}

// MARK: - Supporting Views
struct MetricView: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title.uppercased())
                .font(.system(size: 9, weight: .semibold))
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(color)
        }
    }
}

struct HomeQuickActionButton: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            UltraPremiumCard {
                VStack(spacing: 8) {
                    Image(systemName: icon)
                        .font(.system(size: 24))
                        .foregroundColor(color)
                    
                    Text(title)
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                }
                .padding(.vertical, 4)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Account Switcher View
struct AccountSwitcherView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var realTimeAccountManager: RealTimeAccountManager
    @State private var showingAddAccount = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Select Trading Account")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top)
                
                LazyVStack(spacing: 12) {
                    ForEach(realTimeAccountManager.activeAccounts.indices, id: \.self) { index in
                        let account = realTimeAccountManager.activeAccounts[index]
                        
                        Button(action: {
                            realTimeAccountManager.switchToAccount(at: index)
                            dismiss()
                        }) {
                            AccountRow(account: account, isSelected: index == realTimeAccountManager.selectedAccountIndex)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                Button(action: {
                    showingAddAccount = true
                    dismiss()
                }) {
                    Text("Add New Account")
                }
                .goldexButtonStyle()
                .padding(.horizontal)
                
                Button(action: {
                    dismiss()
                }) {
                    Text("Cancel")
                }
                .goldexSecondaryButtonStyle()
                .padding(.horizontal)
            }
            .navigationTitle("Accounts")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct AccountRow: View {
    let account: SharedTypes.TradingAccountDetails
    let isSelected: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(account.name)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    Text(account.accountTypeText)
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(account.accountTypeColor)
                        .clipShape(Capsule())
                }
                
                Text(account.formattedBalance)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(DesignSystem.primaryGold)
                
                Text(account.server)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.green)
            }
        }
        .padding()
        .background(isSelected ? DesignSystem.primaryGold.opacity(0.1) : .clear)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? DesignSystem.primaryGold : Color.clear, lineWidth: 2)
        )
    }
}

// MARK: - Add Account View
struct AddNewAccountView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var login = ""
    @State private var password = ""
    @State private var server = ""
    @State private var accountType: SharedTypes.TradingAccountDetails.AccountType = .demo
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Text("Add Trading Account")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top)
                
                VStack(spacing: 16) {
                    TextField("Login", text: $login)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextField("Server", text: $server)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Picker("Account Type", selection: $accountType) {
                        Text("Demo").tag(SharedTypes.TradingAccountDetails.AccountType.demo)
                        Text("Live").tag(SharedTypes.TradingAccountDetails.AccountType.live)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                .padding(.horizontal)
                
                Spacer()
                
                VStack(spacing: 12) {
                    Button("Connect Account") {
                        // Connect account logic
                        dismiss()
                    }
                    .goldexButtonStyle()
                    .disabled(login.isEmpty || password.isEmpty || server.isEmpty)
                    
                    Button("Cancel") {
                        dismiss()
                    }
                    .goldexSecondaryButtonStyle()
                }
                .padding(.horizontal)
            }
            .navigationTitle("Add Account")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    HomeDashboardView()
        .environmentObject(TradingViewModel())
        .environmentObject(RealTimeAccountManager())
}