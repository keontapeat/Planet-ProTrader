//
//  WalletDashboardView.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 7/18/25.
//

import SwiftUI

struct WalletDashboardView: View {
    @StateObject private var walletManager = EnhancedWalletManager()
    @State private var selectedWallet: WalletType = .trading
    @State private var showingTransferSheet = false
    @State private var showingFundingSheet = false
    @State private var showingWithdrawalSheet = false
    @State private var animateCards = false
    
    enum WalletType: String, CaseIterable {
        case trading = "trading"
        case botEarnings = "bot_earnings"
        
        var displayName: String {
            switch self {
            case .trading: return "Trading Fuel"
            case .botEarnings: return "Bot Earnings"
            }
        }
        
        var icon: String {
            switch self {
            case .trading: return "fuelpump.fill"
            case .botEarnings: return "brain.head.profile"
            }
        }
        
        var color: Color {
            switch self {
            case .trading: return .blue
            case .botEarnings: return DesignSystem.primaryGold
            }
        }
        
        var description: String {
            switch self {
            case .trading: return "Funds available for trading operations"
            case .botEarnings: return "Profits earned by your trading bots"
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Premium Background
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
                    VStack(spacing: 24) {
                        // Header Section
                        headerSection
                        
                        // Wallet Selector
                        walletSelector
                        
                        // Main Wallet Display
                        mainWalletSection
                        
                        // Quick Actions
                        quickActionsSection
                        
                        // Wallet Overview
                        walletOverviewSection
                        
                        // Recent Transactions
                        recentTransactionsSection
                        
                        // Security Features
                        securityFeaturesSection
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                }
                .refreshable {
                    await refreshWalletData()
                }
            }
            .navigationTitle("")
            .navigationBarHidden(true)
            .onAppear {
                startAnimations()
                walletManager.loadWalletData()
            }
        }
        .sheet(isPresented: $showingTransferSheet) {
            WalletTransferView()
        }
        .sheet(isPresented: $showingFundingSheet) {
            CardPaymentView()
        }
        .sheet(isPresented: $showingWithdrawalSheet) {
            WithdrawalView()
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("GOLDEX WALLET")
                        .font(.system(size: 24, weight: .black, design: .rounded))
                        .foregroundColor(DesignSystem.primaryGold)
                    
                    Text("Your Trading Treasury")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Total Portfolio Value
                VStack(alignment: .trailing, spacing: 4) {
                    Text("TOTAL VALUE")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.secondary)
                    
                    Text(walletManager.formattedTotalBalance)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.primary)
                }
            }
            .padding(.top, 8)
        }
        .scaleEffect(animateCards ? 1.0 : 0.95)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1), value: animateCards)
    }
    
    // MARK: - Wallet Selector
    private var walletSelector: some View {
        HStack(spacing: 0) {
            ForEach(WalletType.allCases, id: \.self) { walletType in
                Button(action: {
                    withAnimation(.spring()) {
                        selectedWallet = walletType
                    }
                }) {
                    VStack(spacing: 8) {
                        HStack(spacing: 8) {
                            Image(systemName: walletType.icon)
                                .font(.system(size: 16, weight: .semibold))
                            Text(walletType.displayName)
                                .font(.system(size: 14, weight: .semibold))
                        }
                        .foregroundColor(selectedWallet == walletType ? .white : .secondary)
                        
                        Rectangle()
                            .fill(selectedWallet == walletType ? .white : Color.clear)
                            .frame(height: 2)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    selectedWallet == walletType ? 
                    walletType.color : 
                    Color.clear
                )
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .scaleEffect(animateCards ? 1.0 : 0.95)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2), value: animateCards)
    }
    
    // MARK: - Main Wallet Section
    private var mainWalletSection: some View {
        UltraPremiumCard {
            VStack(spacing: 20) {
                // Wallet Header
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack(spacing: 8) {
                            Image(systemName: selectedWallet.icon)
                                .font(.system(size: 20))
                                .foregroundColor(selectedWallet.color)
                            
                            Text(selectedWallet.displayName)
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.primary)
                        }
                        
                        Text(selectedWallet.description)
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    // Wallet Status
                    VStack(alignment: .trailing, spacing: 4) {
                        HStack(spacing: 4) {
                            Circle()
                                .fill(.green)
                                .frame(width: 6, height: 6)
                            
                            Text("ACTIVE")
                                .font(.system(size: 9, weight: .bold))
                                .foregroundColor(.green)
                        }
                        
                        Text("Protected")
                            .font(.system(size: 9))
                            .foregroundColor(.secondary)
                    }
                }
                
                // Balance Display
                VStack(spacing: 12) {
                    HStack {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("AVAILABLE BALANCE")
                                .font(.system(size: 11, weight: .black))
                                .foregroundColor(.secondary)
                            
                            Text(getWalletBalance())
                                .font(.system(size: 32, weight: .black, design: .rounded))
                                .foregroundColor(selectedWallet.color)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 6) {
                            Text("TODAY'S CHANGE")
                                .font(.system(size: 11, weight: .black))
                                .foregroundColor(.secondary)
                            
                            HStack(spacing: 4) {
                                Image(systemName: getTodaysChange() >= 0 ? "arrow.up.right" : "arrow.down.right")
                                    .font(.system(size: 12, weight: .bold))
                                Text(String(format: "%+.2f", getTodaysChange()))
                                    .font(.system(size: 16, weight: .bold))
                            }
                            .foregroundColor(getTodaysChange() >= 0 ? .green : .red)
                        }
                    }
                    
                    // Wallet-specific metrics
                    walletSpecificMetrics
                }
                
                Divider()
                
                // Auto-Transfer Settings (for Bot Earnings)
                if selectedWallet == .botEarnings {
                    autoTransferSection
                }
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.95)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3), value: animateCards)
    }
    
    // MARK: - Wallet-Specific Metrics
    private var walletSpecificMetrics: some View {
        HStack(spacing: 20) {
            if selectedWallet == .trading {
                WalletMetric(title: "Fuel Level", value: "\(walletManager.fuelLevel)%", color: .blue)
                WalletMetric(title: "Active Trades", value: "\(walletManager.activeTrades)", color: .orange)
                WalletMetric(title: "Avg Trade", value: "$127", color: .green)
                WalletMetric(title: "Success Rate", value: "87%", color: .purple)
            } else {
                WalletMetric(title: "Total Earned", value: walletManager.formattedTotalEarned, color: DesignSystem.primaryGold)
                WalletMetric(title: "This Week", value: walletManager.formattedWeeklyEarnings, color: .green)
                WalletMetric(title: "Best Bot", value: "SwingMaster", color: .blue)
                WalletMetric(title: "Win Rate", value: "94%", color: .purple)
            }
        }
    }
    
    // MARK: - Auto-Transfer Section
    private var autoTransferSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("🔒 Auto-Transfer Protection")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.primary)
                
                Spacer()
                
                Toggle("", isOn: .constant(true))
                    .scaleEffect(0.8)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("When bot profits exceed $1,000:")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                
                HStack(spacing: 16) {
                    HStack(spacing: 4) {
                        Image(systemName: "shield.checkered")
                            .font(.system(size: 10))
                            .foregroundColor(.green)
                        Text("75% → Bot Earnings (Protected)")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(.green)
                    }
                    
                    HStack(spacing: 4) {
                        Image(systemName: "fuelpump.fill")
                            .font(.system(size: 10))
                            .foregroundColor(.blue)
                        Text("25% → Trading Fuel")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(.blue)
                    }
                }
            }
            .padding()
            .background(.green.opacity(0.05))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
    
    // MARK: - Quick Actions Section
    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("⚡ Quick Actions")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
            
            HStack(spacing: 12) {
                if selectedWallet == .trading {
                    WalletActionButton(
                        icon: "plus.circle.fill",
                        title: "Add Fuel",
                        subtitle: "Fund trading",
                        color: .green
                    ) {
                        showingFundingSheet = true
                    }
                    
                    WalletActionButton(
                        icon: "arrow.left.arrow.right",
                        title: "Transfer",
                        subtitle: "Move funds",
                        color: .blue
                    ) {
                        showingTransferSheet = true
                    }
                } else {
                    WalletActionButton(
                        icon: "arrow.down.circle.fill",
                        title: "Withdraw",
                        subtitle: "Cash out",
                        color: .green
                    ) {
                        showingWithdrawalSheet = true
                    }
                    
                    WalletActionButton(
                        icon: "arrow.left.arrow.right",
                        title: "Transfer",
                        subtitle: "Move to fuel",
                        color: .blue
                    ) {
                        showingTransferSheet = true
                    }
                }
                
                WalletActionButton(
                    icon: "doc.text.fill",
                    title: "History",
                    subtitle: "View all",
                    color: .purple
                ) {
                    // History action
                }
                
                WalletActionButton(
                    icon: "gearshape.fill",
                    title: "Settings",
                    subtitle: "Configure",
                    color: .gray
                ) {
                    // Settings action
                }
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.95)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.4), value: animateCards)
    }
    
    // MARK: - Wallet Overview Section
    private var walletOverviewSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("📊 Wallet Overview")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
            
            HStack(spacing: 12) {
                // Trading Fuel Card
                UltraPremiumCard {
                    WalletOverviewCard(
                        walletType: .trading,
                        balance: walletManager.tradingBalance,
                        change: walletManager.tradingBalanceChange,
                        isSelected: selectedWallet == .trading
                    ) {
                        withAnimation(.spring()) {
                            selectedWallet = .trading
                        }
                    }
                }
                
                // Bot Earnings Card
                UltraPremiumCard {
                    WalletOverviewCard(
                        walletType: .botEarnings,
                        balance: walletManager.botEarningsBalance,
                        change: walletManager.botEarningsChange,
                        isSelected: selectedWallet == .botEarnings
                    ) {
                        withAnimation(.spring()) {
                            selectedWallet = .botEarnings
                        }
                    }
                }
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.95)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.5), value: animateCards)
    }
    
    // MARK: - Recent Transactions Section
    private var recentTransactionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("📋 Recent Activity")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                
                Spacer()
                
                Button("View All") {
                    // View all transactions
                }
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(DesignSystem.primaryGold)
            }
            
            LazyVStack(spacing: 8) {
                ForEach(getFilteredTransactions().prefix(5)) { transaction in
                    TransactionRowView(transaction: transaction)
                }
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.95)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.6), value: animateCards)
    }
    
    // MARK: - Security Features Section
    private var securityFeaturesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("🔒 Security Features")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                SecurityFeatureCard(
                    icon: "shield.lefthalf.filled",
                    title: "Multi-Signature",
                    description: "Enhanced security",
                    color: .green
                )
                
                SecurityFeatureCard(
                    icon: "lock.rotation",
                    title: "Auto-Rotation",
                    description: "Keys rotate daily",
                    color: .blue
                )
                
                SecurityFeatureCard(
                    icon: "eye.slash.fill",
                    title: "Private Keys",
                    description: "Never stored",
                    color: .orange
                )
                
                SecurityFeatureCard(
                    icon: "checkmark.seal.fill",
                    title: "Insured",
                    description: "Up to $500K",
                    color: DesignSystem.primaryGold
                )
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.95)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.7), value: animateCards)
    }
    
    // MARK: - Helper Methods
    private func startAnimations() {
        withAnimation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.2)) {
            animateCards = true
        }
    }
    
    private func refreshWalletData() async {
        await walletManager.refreshWalletData()
    }
    
    private func getWalletBalance() -> String {
        switch selectedWallet {
        case .trading:
            return walletManager.formattedTradingBalance
        case .botEarnings:
            return walletManager.formattedBotEarningsBalance
        }
    }
    
    private func getTodaysChange() -> Double {
        switch selectedWallet {
        case .trading:
            return walletManager.tradingBalanceChange
        case .botEarnings:
            return walletManager.botEarningsChange
        }
    }
    
    private func getFilteredTransactions() -> [WalletTransaction] {
        return walletManager.recentTransactions
    }
}

struct WalletMetric: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(color)
            
            Text(title)
                .font(.system(size: 9, weight: .medium))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

struct WalletActionButton: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(color)
                
                VStack(spacing: 2) {
                    Text(title)
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.primary)
                    
                    Text(subtitle)
                        .font(.system(size: 9))
                        .foregroundColor(.secondary)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Enhanced Wallet Manager
@MainActor
class EnhancedWalletManager: ObservableObject {
    @Published var tradingBalance: Double = 2547.83
    @Published var botEarningsBalance: Double = 8247.93
    @Published var tradingBalanceChange: Double = 127.45
    @Published var botEarningsChange: Double = 892.17
    @Published var fuelLevel: Int = 87
    @Published var activeTrades: Int = 12
    @Published var recentTransactions: [WalletTransaction] = []
    @Published var isLoading = false
    
    var formattedTradingBalance: String {
        return String(format: "$%.2f", tradingBalance)
    }
    
    var formattedBotEarningsBalance: String {
        return String(format: "$%.2f", botEarningsBalance)
    }
    
    var formattedTotalBalance: String {
        return String(format: "$%.2f", tradingBalance + botEarningsBalance)
    }
    
    var formattedTotalEarned: String {
        return String(format: "$%.0fK", botEarningsBalance / 1000)
    }
    
    var formattedWeeklyEarnings: String {
        return String(format: "+$%.0f", botEarningsChange * 7) // Approximate weekly
    }
    
    func loadWalletData() {
        // Generate sample transactions
        recentTransactions = WalletTransaction.sampleTransactions
    }
    
    func refreshWalletData() async {
        isLoading = true
        
        // Simulate API call
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        // Update balances with small random changes
        tradingBalance += Double.random(in: -50...100)
        botEarningsBalance += Double.random(in: 50...200)
        tradingBalanceChange = Double.random(in: -100...200)
        botEarningsChange = Double.random(in: 100...500)
        
        isLoading = false
    }
    
    func transferFunds(from: WalletDashboardView.WalletType, to: WalletDashboardView.WalletType, amount: Double) async {
        // Simulate transfer
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        if from == .trading && to == .botEarnings {
            tradingBalance -= amount
            botEarningsBalance += amount
        } else if from == .botEarnings && to == .trading {
            botEarningsBalance -= amount
            tradingBalance += amount
        }
        
        // Add transaction record using consolidated WalletTransaction
        let transaction = WalletTransaction(
            type: .deposit, // Use the consolidated enum
            amount: amount,
            description: "Transfer from \(from.displayName)",
            timestamp: Date(),
            status: .completed
        )
        
        recentTransactions.insert(transaction, at: 0)
    }
}

// MARK: - Supporting Views

struct WalletOverviewCard: View {
    let walletType: WalletDashboardView.WalletType
    let balance: Double
    let change: Double
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 12) {
                HStack {
                    Image(systemName: walletType.icon)
                        .font(.system(size: 16))
                        .foregroundColor(walletType.color)
                    
                    Spacer()
                    
                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.green)
                    }
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(walletType.displayName)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    Text(String(format: "$%.2f", balance))
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(walletType.color)
                    
                    HStack(spacing: 4) {
                        Image(systemName: change >= 0 ? "arrow.up.right" : "arrow.down.right")
                            .font(.system(size: 8))
                        Text(String(format: "%+.2f", change))
                            .font(.system(size: 10, weight: .semibold))
                    }
                    .foregroundColor(change >= 0 ? .green : .red)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
        }
        .buttonStyle(PlainButtonStyle())
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? walletType.color : Color.clear, lineWidth: 2)
        )
    }
}

struct TransactionRowView: View {
    let transaction: WalletTransaction
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(transaction.type.color.opacity(0.1))
                    .frame(width: 32, height: 32)
                
                Image(systemName: transaction.type.emoji)
                    .font(.system(size: 14))
                    .foregroundColor(transaction.type.color)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(transaction.description)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.primary)
                
                Text(transaction.timestamp, style: .time)
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                Text(String(format: "$%.2f", transaction.amount))
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(transaction.amount >= 0 ? .green : .red)
                
                Text(transaction.status.rawValue)
                    .font(.system(size: 9, weight: .medium))
                    .foregroundColor(transaction.status.color)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct SecurityFeatureCard: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        UltraPremiumCard {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(color)
                
                Text(title)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.primary)
                
                Text(description)
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.vertical, 8)
        }
    }
}

#Preview {
    WalletDashboardView()
}