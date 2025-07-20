//
//  SettingsView.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 7/13/25.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var tradingViewModel: TradingViewModel
    @StateObject private var settingsManager = SettingsManager()
    @State private var showingAccountSettings = false
    @State private var showingNotificationSettings = false
    @State private var showingRiskSettings = false
    @State private var showingBrokerSettings = false
    @State private var showingAdvancedSettings = false
    @State private var showingAbout = false
    @State private var showingSupport = false
    @State private var animateCards = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                DesignSystem.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Header
                        headerSection
                        
                        // Quick Stats
                        quickStatsSection
                        
                        // Settings Sections
                        LazyVStack(spacing: 16) {
                            // Account Settings
                            accountSettingsSection
                            
                            // Trading Settings
                            tradingSettingsSection
                            
                            // Broker Settings
                            brokerSettingsSection
                            
                            // Risk Management
                            riskManagementSection
                            
                            // Notifications
                            notificationsSection
                            
                            // Advanced Settings
                            advancedSettingsSection
                            
                            // Support & About
                            supportAboutSection
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2)) {
                    animateCards = true
                }
            }
            .sheet(isPresented: $showingAccountSettings) {
                AccountSettingsView()
                    .environmentObject(settingsManager)
            }
            .sheet(isPresented: $showingNotificationSettings) {
                NotificationSettingsView()
                    .environmentObject(settingsManager)
            }
            .sheet(isPresented: $showingRiskSettings) {
                RiskSettingsView()
                    .environmentObject(settingsManager)
            }
            .sheet(isPresented: $showingBrokerSettings) {
                BrokerSettingsView()
                    .environmentObject(settingsManager)
            }
            .sheet(isPresented: $showingAdvancedSettings) {
                AdvancedSettingsView()
                    .environmentObject(settingsManager)
            }
            .sheet(isPresented: $showingAbout) {
                AboutView()
            }
            .sheet(isPresented: $showingSupport) {
                SupportView()
            }
        }
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        UltraPremiumCard {
            VStack(spacing: 16) {
                HStack {
                    Image(systemName: "gear")
                        .font(.title)
                        .foregroundStyle(DesignSystem.primaryGold)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Elite Settings")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(.primary)
                        
                        Text("Configure your trading environment")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 2) {
                        Circle()
                            .fill(.green)
                            .frame(width: 8, height: 8)
                        
                        Text("Online")
                            .font(.caption)
                            .foregroundStyle(.green)
                    }
                }
                
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Account Status")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        Text(settingsManager.isPremium ? "Premium" : "Free")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(settingsManager.isPremium ? .green : .orange)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Version")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        Text("2.0.1")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.primary)
                    }
                }
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.9)
        .opacity(animateCards ? 1.0 : 0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: animateCards)
    }
    
    // MARK: - Quick Stats Section
    
    private var quickStatsSection: some View {
        UltraPremiumCard {
            VStack(alignment: .leading, spacing: 16) {
                Text("Quick Stats")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                
                HStack(spacing: 12) {
                    SettingsStatCard(
                        title: "Win Rate",
                        value: tradingViewModel.formattedWinRate,
                        color: .green,
                        icon: "chart.line.uptrend.xyaxis"
                    )
                    
                    SettingsStatCard(
                        title: "Balance",
                        value: tradingViewModel.formattedBalance,
                        color: .blue,
                        icon: "banknote"
                    )
                    
                    SettingsStatCard(
                        title: "Trades",
                        value: "\(tradingViewModel.totalTrades)",
                        color: .purple,
                        icon: "arrow.up.arrow.down"
                    )
                }
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.9)
        .opacity(animateCards ? 1.0 : 0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1), value: animateCards)
    }
    
    // MARK: - Account Settings Section
    
    private var accountSettingsSection: some View {
        UltraPremiumCard {
            VStack(alignment: .leading, spacing: 16) {
                Text("Account Settings")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                
                VStack(spacing: 12) {
                    SettingsRow(
                        title: "Profile & Preferences",
                        subtitle: "Edit profile, trading preferences",
                        icon: "person.circle",
                        iconColor: .blue,
                        showChevron: true
                    ) {
                        showingAccountSettings = true
                    }
                    
                    SettingsRow(
                        title: "Subscription",
                        subtitle: settingsManager.isPremium ? "Premium Active" : "Upgrade to Premium",
                        icon: "star.circle",
                        iconColor: .orange,
                        showChevron: true
                    ) {
                        // Handle subscription
                    }
                    
                    SettingsRow(
                        title: "Data & Privacy",
                        subtitle: "Manage your data and privacy settings",
                        icon: "lock.circle",
                        iconColor: .green,
                        showChevron: true
                    ) {
                        // Handle privacy
                    }
                }
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.9)
        .opacity(animateCards ? 1.0 : 0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2), value: animateCards)
    }
    
    // MARK: - Trading Settings Section
    
    private var tradingSettingsSection: some View {
        UltraPremiumCard {
            VStack(alignment: .leading, spacing: 16) {
                Text("Trading Settings")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                
                VStack(spacing: 12) {
                    SettingsToggleRow(
                        title: "Auto Trading",
                        subtitle: "Enable automated trading",
                        icon: "brain.head.profile",
                        iconColor: DesignSystem.primaryGold,
                        isOn: $tradingViewModel.isAutoTradingEnabled
                    )
                    
                    SettingsRow(
                        title: "Trading Mode",
                        subtitle: tradingViewModel.autoTradingMode.rawValue,
                        icon: "chart.xyaxis.line",
                        iconColor: .purple,
                        showChevron: true
                    ) {
                        // Handle trading mode
                    }
                    
                    SettingsRow(
                        title: "Signal Filters",
                        subtitle: "Configure signal filtering",
                        icon: "line.3.horizontal.decrease.circle",
                        iconColor: .cyan,
                        showChevron: true
                    ) {
                        // Handle signal filters
                    }
                }
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.9)
        .opacity(animateCards ? 1.0 : 0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3), value: animateCards)
    }
    
    // MARK: - Broker Settings Section
    
    private var brokerSettingsSection: some View {
        UltraPremiumCard {
            VStack(alignment: .leading, spacing: 16) {
                Text("Broker Settings")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                
                VStack(spacing: 12) {
                    SettingsRow(
                        title: "Connected Brokers",
                        subtitle: "\(tradingViewModel.connectedAccounts.count) accounts connected",
                        icon: "building.columns",
                        iconColor: .blue,
                        showChevron: true
                    ) {
                        showingBrokerSettings = true
                    }
                    
                    SettingsRow(
                        title: "VPS Settings",
                        subtitle: "Configure VPS connections",
                        icon: "server.rack",
                        iconColor: .purple,
                        showChevron: true
                    ) {
                        // Handle VPS settings
                    }
                    
                    SettingsRow(
                        title: "API Keys",
                        subtitle: "Manage broker API keys",
                        icon: "key",
                        iconColor: .orange,
                        showChevron: true
                    ) {
                        // Handle API keys
                    }
                }
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.9)
        .opacity(animateCards ? 1.0 : 0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.4), value: animateCards)
    }
    
    // MARK: - Risk Management Section
    
    private var riskManagementSection: some View {
        UltraPremiumCard {
            VStack(alignment: .leading, spacing: 16) {
                Text("Risk Management")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                
                VStack(spacing: 12) {
                    SettingsRow(
                        title: "Risk Settings",
                        subtitle: "Configure risk parameters",
                        icon: "shield.checkered",
                        iconColor: .red,
                        showChevron: true
                    ) {
                        showingRiskSettings = true
                    }
                    
                    SettingsRow(
                        title: "Position Sizing",
                        subtitle: "Automatic position sizing rules",
                        icon: "scalemass",
                        iconColor: .green,
                        showChevron: true
                    ) {
                        // Handle position sizing
                    }
                    
                    SettingsRow(
                        title: "Stop Loss Rules",
                        subtitle: "Configure stop loss automation",
                        icon: "stop.circle",
                        iconColor: .red,
                        showChevron: true
                    ) {
                        // Handle stop loss
                    }
                }
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.9)
        .opacity(animateCards ? 1.0 : 0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.5), value: animateCards)
    }
    
    // MARK: - Notifications Section
    
    private var notificationsSection: some View {
        UltraPremiumCard {
            VStack(alignment: .leading, spacing: 16) {
                Text("Notifications")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                
                VStack(spacing: 12) {
                    SettingsToggleRow(
                        title: "Push Notifications",
                        subtitle: "Receive trading alerts",
                        icon: "bell.circle",
                        iconColor: .blue,
                        isOn: $settingsManager.pushNotificationsEnabled
                    )
                    
                    SettingsToggleRow(
                        title: "Signal Alerts",
                        subtitle: "Get notified of new signals",
                        icon: "bolt.circle",
                        iconColor: .yellow,
                        isOn: $settingsManager.signalAlertsEnabled
                    )
                    
                    SettingsRow(
                        title: "Notification Settings",
                        subtitle: "Configure alert preferences",
                        icon: "slider.horizontal.3",
                        iconColor: .purple,
                        showChevron: true
                    ) {
                        showingNotificationSettings = true
                    }
                }
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.9)
        .opacity(animateCards ? 1.0 : 0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.6), value: animateCards)
    }
    
    // MARK: - Advanced Settings Section
    
    private var advancedSettingsSection: some View {
        UltraPremiumCard {
            VStack(alignment: .leading, spacing: 16) {
                Text("Advanced Settings")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                
                VStack(spacing: 12) {
                    SettingsRow(
                        title: "AI Configuration",
                        subtitle: "Configure AI parameters",
                        icon: "brain",
                        iconColor: DesignSystem.primaryGold,
                        showChevron: true
                    ) {
                        showingAdvancedSettings = true
                    }
                    
                    SettingsRow(
                        title: "Debug Mode",
                        subtitle: "Enable debug logging",
                        icon: "ant.circle",
                        iconColor: .red,
                        showChevron: true
                    ) {
                        // Handle debug mode
                    }
                    
                    SettingsRow(
                        title: "Data Export",
                        subtitle: "Export trading data",
                        icon: "square.and.arrow.up",
                        iconColor: .green,
                        showChevron: true
                    ) {
                        // Handle data export
                    }
                }
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.9)
        .opacity(animateCards ? 1.0 : 0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.7), value: animateCards)
    }
    
    // MARK: - Support & About Section
    
    private var supportAboutSection: some View {
        UltraPremiumCard {
            VStack(alignment: .leading, spacing: 16) {
                Text("Support & About")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                
                VStack(spacing: 12) {
                    SettingsRow(
                        title: "Help & Support",
                        subtitle: "Get help with GOLDEX AI",
                        icon: "questionmark.circle",
                        iconColor: .blue,
                        showChevron: true
                    ) {
                        showingSupport = true
                    }
                    
                    SettingsRow(
                        title: "About GOLDEX AI",
                        subtitle: "App information and credits",
                        icon: "info.circle",
                        iconColor: .purple,
                        showChevron: true
                    ) {
                        showingAbout = true
                    }
                    
                    SettingsRow(
                        title: "Rate App",
                        subtitle: "Rate GOLDEX AI on the App Store",
                        icon: "star.circle",
                        iconColor: .orange,
                        showChevron: true
                    ) {
                        // Handle rate app
                    }
                }
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.9)
        .opacity(animateCards ? 1.0 : 0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.8), value: animateCards)
    }
}

// MARK: - Settings Manager

@MainActor
class SettingsManager: ObservableObject {
    @Published var isPremium: Bool = false
    @Published var pushNotificationsEnabled: Bool = true
    @Published var signalAlertsEnabled: Bool = true
    @Published var darkModeEnabled: Bool = false
    @Published var hapticFeedbackEnabled: Bool = true
    @Published var autoBackupEnabled: Bool = true
    @Published var riskPercentage: Double = 2.0
    @Published var maxDailyTrades: Int = 10
    @Published var preferredTimeframe: String = "4H/1H"
    @Published var minConfidenceLevel: Double = 0.75
    
    init() {
        loadSettings()
    }
    
    func loadSettings() {
        // Load from UserDefaults or Core Data
        isPremium = UserDefaults.standard.bool(forKey: "isPremium")
        pushNotificationsEnabled = UserDefaults.standard.bool(forKey: "pushNotificationsEnabled")
        signalAlertsEnabled = UserDefaults.standard.bool(forKey: "signalAlertsEnabled")
        riskPercentage = UserDefaults.standard.double(forKey: "riskPercentage")
        maxDailyTrades = UserDefaults.standard.integer(forKey: "maxDailyTrades")
        
        // Set defaults if not set
        if riskPercentage == 0 { riskPercentage = 2.0 }
        if maxDailyTrades == 0 { maxDailyTrades = 10 }
    }
    
    func saveSettings() {
        UserDefaults.standard.set(isPremium, forKey: "isPremium")
        UserDefaults.standard.set(pushNotificationsEnabled, forKey: "pushNotificationsEnabled")
        UserDefaults.standard.set(signalAlertsEnabled, forKey: "signalAlertsEnabled")
        UserDefaults.standard.set(riskPercentage, forKey: "riskPercentage")
        UserDefaults.standard.set(maxDailyTrades, forKey: "maxDailyTrades")
    }
}

// MARK: - Settings Components

struct SettingsRow: View {
    let title: String
    let subtitle: String
    let icon: String
    let iconColor: Color
    let showChevron: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(iconColor)
                    .frame(width: 24)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(.primary)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                if showChevron {
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct SettingsToggleRow: View {
    let title: String
    let subtitle: String
    let icon: String
    let iconColor: Color
    @Binding var isOn: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(iconColor)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(.primary)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(DesignSystem.primaryGold)
        }
        .padding(.vertical, 4)
    }
}

struct SettingsStatCard: View {
    let title: String
    let value: String
    let color: Color
    let icon: String
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundStyle(color)
            
            Text(value)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(color)
            
            Text(title)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(color.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

// MARK: - Detail Views

struct AccountSettingsView: View {
    @EnvironmentObject var settingsManager: SettingsManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section("Profile") {
                    HStack {
                        Image(systemName: "person.crop.circle")
                            .font(.title2)
                            .foregroundStyle(DesignSystem.primaryGold)
                        
                        VStack(alignment: .leading) {
                            Text("Elite Trader")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            
                            Text("Premium Member")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                        
                        Button("Edit") {
                            // Handle edit profile
                        }
                        .font(.caption)
                        .foregroundStyle(DesignSystem.primaryGold)
                    }
                }
                
                Section("Trading Preferences") {
                    Picker("Preferred Timeframe", selection: $settingsManager.preferredTimeframe) {
                        Text("1M/5M").tag("1M/5M")
                        Text("5M/15M").tag("5M/15M")
                        Text("15M/1H").tag("15M/1H")
                        Text("1H/4H").tag("1H/4H")
                        Text("4H/1D").tag("4H/1D")
                    }
                    
                    HStack {
                        Text("Min Confidence Level")
                        Spacer()
                        Text("\(Int(settingsManager.minConfidenceLevel * 100))%")
                            .foregroundStyle(.secondary)
                    }
                    
                    Slider(value: $settingsManager.minConfidenceLevel, in: 0.5...0.95, step: 0.05)
                        .tint(DesignSystem.primaryGold)
                }
            }
            .navigationTitle("Account Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        settingsManager.saveSettings()
                        dismiss()
                    }
                }
            }
        }
    }
}

struct NotificationSettingsView: View {
    @EnvironmentObject var settingsManager: SettingsManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section("Alert Types") {
                    Toggle("Signal Alerts", isOn: $settingsManager.signalAlertsEnabled)
                        .tint(DesignSystem.primaryGold)
                    
                    Toggle("Trade Execution", isOn: .constant(true))
                        .tint(DesignSystem.primaryGold)
                    
                    Toggle("Risk Alerts", isOn: .constant(true))
                        .tint(DesignSystem.primaryGold)
                    
                    Toggle("Market Events", isOn: .constant(false))
                        .tint(DesignSystem.primaryGold)
                }
                
                Section("Delivery") {
                    Toggle("Push Notifications", isOn: $settingsManager.pushNotificationsEnabled)
                        .tint(DesignSystem.primaryGold)
                    
                    Toggle("Email Notifications", isOn: .constant(false))
                        .tint(DesignSystem.primaryGold)
                    
                    Toggle("SMS Notifications", isOn: .constant(false))
                        .tint(DesignSystem.primaryGold)
                }
                
                Section("Quiet Hours") {
                    Toggle("Enable Quiet Hours", isOn: .constant(false))
                        .tint(DesignSystem.primaryGold)
                    
                    HStack {
                        Text("From")
                        Spacer()
                        Text("10:00 PM")
                            .foregroundStyle(.secondary)
                    }
                    
                    HStack {
                        Text("To")
                        Spacer()
                        Text("7:00 AM")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Notifications")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        settingsManager.saveSettings()
                        dismiss()
                    }
                }
            }
        }
    }
}

struct RiskSettingsView: View {
    @EnvironmentObject var settingsManager: SettingsManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section("Risk Parameters") {
                    HStack {
                        Text("Risk Per Trade")
                        Spacer()
                        Text("\(String(format: "%.1f", settingsManager.riskPercentage))%")
                            .foregroundStyle(.secondary)
                    }
                    
                    Slider(value: $settingsManager.riskPercentage, in: 0.5...5.0, step: 0.1)
                        .tint(DesignSystem.primaryGold)
                    
                    HStack {
                        Text("Max Daily Trades")
                        Spacer()
                        Text("\(settingsManager.maxDailyTrades)")
                            .foregroundStyle(.secondary)
                    }
                    
                    Stepper("", value: $settingsManager.maxDailyTrades, in: 1...50)
                        .labelsHidden()
                }
                
                Section("Safety Features") {
                    Toggle("Auto Stop Loss", isOn: .constant(true))
                        .tint(DesignSystem.primaryGold)
                    
                    Toggle("Daily Loss Limit", isOn: .constant(true))
                        .tint(DesignSystem.primaryGold)
                    
                    Toggle("Drawdown Protection", isOn: .constant(true))
                        .tint(DesignSystem.primaryGold)
                }
                
                Section("Risk Alerts") {
                    Toggle("High Risk Warnings", isOn: .constant(true))
                        .tint(DesignSystem.primaryGold)
                    
                    Toggle("Margin Alerts", isOn: .constant(true))
                        .tint(DesignSystem.primaryGold)
                    
                    Toggle("Position Size Alerts", isOn: .constant(true))
                        .tint(DesignSystem.primaryGold)
                }
            }
            .navigationTitle("Risk Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        settingsManager.saveSettings()
                        dismiss()
                    }
                }
            }
        }
    }
}

struct BrokerSettingsView: View {
    @EnvironmentObject var settingsManager: SettingsManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section("Connected Brokers") {
                    ForEach(0..<2) { index in
                        HStack {
                            Image(systemName: "building.columns")
                                .foregroundStyle(.blue)
                            
                            VStack(alignment: .leading) {
                                Text("Coinexx Demo #\(index + 1)")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                
                                Text("Connected")
                                    .font(.caption)
                                    .foregroundStyle(.green)
                            }
                            
                            Spacer()
                            
                            Button("Manage") {
                                // Handle broker management
                            }
                            .font(.caption)
                            .foregroundStyle(DesignSystem.primaryGold)
                        }
                    }
                }
                
                Section("Add New Broker") {
                    Button("Add Broker Account") {
                        // Handle add broker
                    }
                    .foregroundStyle(DesignSystem.primaryGold)
                }
            }
            .navigationTitle("Broker Settings")
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

struct AdvancedSettingsView: View {
    @EnvironmentObject var settingsManager: SettingsManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section("AI Configuration") {
                    Toggle("Enhanced AI Mode", isOn: .constant(true))
                        .tint(DesignSystem.primaryGold)
                    
                    Toggle("Neural Network Learning", isOn: .constant(true))
                        .tint(DesignSystem.primaryGold)
                    
                    Toggle("Pattern Recognition", isOn: .constant(true))
                        .tint(DesignSystem.primaryGold)
                }
                
                Section("Performance") {
                    Toggle("High Performance Mode", isOn: .constant(false))
                        .tint(DesignSystem.primaryGold)
                    
                    Toggle("Background Processing", isOn: .constant(true))
                        .tint(DesignSystem.primaryGold)
                    
                    Toggle("Cache Optimization", isOn: .constant(true))
                        .tint(DesignSystem.primaryGold)
                }
                
                Section("Developer") {
                    Toggle("Debug Mode", isOn: .constant(false))
                        .tint(DesignSystem.primaryGold)
                    
                    Toggle("Verbose Logging", isOn: .constant(false))
                        .tint(DesignSystem.primaryGold)
                    
                    Button("Reset All Settings") {
                        // Handle reset
                    }
                    .foregroundStyle(.red)
                }
            }
            .navigationTitle("Advanced Settings")
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

struct AboutView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    Image(systemName: "brain.head.profile")
                        .font(.system(size: 80))
                        .foregroundStyle(DesignSystem.primaryGold)
                    
                    VStack(spacing: 8) {
                        Text("GOLDEX AI")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("Version 2.0.1")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    
                    Text("Elite Gold Trading Intelligence")
                        .font(.headline)
                        .foregroundStyle(DesignSystem.primaryGold)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("GOLDEX AI is the world's most advanced AI-powered gold trading system, designed to help traders achieve consistent profitability through cutting-edge machine learning and smart money concepts.")
                            .font(.subheadline)
                            .multilineTextAlignment(.leading)
                        
                        Text("Features:")
                            .font(.headline)
                            .foregroundStyle(.primary)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("• Advanced AI Signal Generation")
                            Text("• Real-time Market Analysis")
                            Text("• Automated Trading Capabilities")
                            Text("• Risk Management Tools")
                            Text("• Performance Analytics")
                        }
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    }
                    
                    Text("© 2024 GOLDEX AI. All rights reserved.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding(.top, 20)
                }
                .padding()
            }
            .navigationTitle("About")
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

struct SupportView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section("Get Help") {
                    Button("FAQ") {
                        // Handle FAQ
                    }
                    
                    Button("Contact Support") {
                        // Handle contact support
                    }
                    
                    Button("Video Tutorials") {
                        // Handle tutorials
                    }
                }
                
                Section("Community") {
                    Button("Discord Community") {
                        // Handle Discord
                    }
                    
                    Button("Telegram Channel") {
                        // Handle Telegram
                    }
                    
                    Button("Trading Forums") {
                        // Handle forums
                    }
                }
                
                Section("Feedback") {
                    Button("Report a Bug") {
                        // Handle bug report
                    }
                    
                    Button("Feature Request") {
                        // Handle feature request
                    }
                    
                    Button("Rate App") {
                        // Handle app rating
                    }
                }
            }
            .navigationTitle("Support")
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

#Preview {
    SettingsView()
        .environmentObject(TradingViewModel())
}