//
//  HomeDashboardView.swift
//  Planet ProTrader
//
//  ✅ HOME DASHBOARD - Ultra Premium Design with Real-Time Data
//  Award-winning UI/UX with cutting-edge architecture
//

import SwiftUI
import Combine

struct HomeDashboardView: View {
    // MARK: - Environment Objects
    @EnvironmentObject var tradingViewModel: TradingViewModel
    @EnvironmentObject var realTimeAccountManager: RealTimeAccountManager
    @EnvironmentObject var autoTradingManager: AutoTradingManager
    @EnvironmentObject var tradingBotManager: TradingBotManager
    @EnvironmentObject var toastManager: ToastManager
    
    // MARK: - State Management
    @State private var selectedAccountIndex = 0
    @State private var showingAccountSwitcher = false
    @State private var showingAddAccount = false
    @State private var selectedBot: CoreTypes.TradingBot?
    @State private var showBotDetails = false
    @State private var animateCards = false
    @State private var pulseEffect = false
    @State private var scrollOffset: CGFloat = 0
    @State private var headerOpacity: Double = 1.0
    @State private var refreshTimer: Timer?
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // MARK: - Premium Background
                backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 0) {
                        // MARK: - Hero Header
                        heroHeaderSection(geometry: geometry)
                        
                        // MARK: - Trading Bots Showcase
                        tradingBotsSection
                            .padding(.top, 20)
                        
                        // MARK: - Live Trading Metrics
                        tradingMetricsSection
                            .padding(.top, 25)
                        
                        // MARK: - Market Intelligence
                        marketIntelligenceSection
                            .padding(.top, 25)
                        
                        // MARK: - Quick Actions
                        quickActionsSection
                            .padding(.top, 25)
                        
                        // MARK: - Performance Analytics
                        performanceAnalyticsSection
                            .padding(.top, 25)
                        
                        Spacer(minLength: 100)
                    }
                    .background(
                        GeometryReader { scrollGeo in
                            Color.clear
                                .preference(key: ScrollOffsetKey.self, value: scrollGeo.frame(in: .named("scroll")).origin.y)
                        }
                    )
                }
                .coordinateSpace(name: "scroll")
                .onPreferenceChange(ScrollOffsetKey.self) { value in
                    scrollOffset = value
                    headerOpacity = max(0, min(1, 1 + (value / 100)))
                }
                .refreshable {
                    await refreshAllData()
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            startAnimations()
            startRealTimeUpdates()
        }
        .onDisappear {
            stopRealTimeUpdates()
        }
        .sheet(isPresented: $showingAccountSwitcher) {
            AccountSwitcherView()
                .environmentObject(realTimeAccountManager)
        }
        .sheet(isPresented: $showingAddAccount) {
            AddAccountView()
        }
        .sheet(isPresented: $showBotDetails) {
            if let bot = selectedBot {
                BotDetailView(bot: bot)
            }
        }
    }
    
    // MARK: - Background Gradient
    private var backgroundGradient: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(.systemBackground),
                    DesignSystem.primaryGold.opacity(0.03),
                    Color(.systemBackground).opacity(0.95),
                    DesignSystem.primaryGold.opacity(0.02)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            // Animated orbs
            ForEach(0..<5, id: \.self) { index in
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                DesignSystem.primaryGold.opacity(0.08),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: 80
                        )
                    )
                    .frame(width: CGFloat.random(in: 60...120))
                    .offset(
                        x: CGFloat.random(in: -150...150),
                        y: CGFloat.random(in: -200...200)
                    )
                    .blur(radius: 15)
                    .animation(
                        .easeInOut(duration: Double.random(in: 8...15))
                        .repeatForever(autoreverses: true)
                        .delay(Double(index) * 0.8),
                        value: animateCards
                    )
            }
        }
    }
    
    // MARK: - Hero Header Section
    private func heroHeaderSection(geometry: GeometryProxy) -> some View {
        VStack(spacing: 0) {
            // Status bar spacer
            Rectangle()
                .fill(Color.clear)
                .frame(height: geometry.safeAreaInsets.top)
            
            // Header content
            VStack(spacing: 20) {
                // Navigation bar
                headerNavigationBar
                
                // Main balance display
                mainBalanceCard
                    .padding(.horizontal, 20)
            }
        }
        .opacity(headerOpacity)
    }
    
    private var headerNavigationBar: some View {
        HStack {
            // Brand logo
            brandLogo
            
            Spacer()
            
            // Account switcher
            accountSwitcherButton
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    private var brandLogo: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(DesignSystem.goldGradient)
                    .frame(width: 44, height: 44)
                    .scaleEffect(pulseEffect ? 1.1 : 1.0)
                    .shadow(color: DesignSystem.primaryGold.opacity(0.3), radius: 8, x: 0, y: 4)
                
                Image(systemName: "brain.head.profile")
                    .font(.system(size: 20, weight: .black))
                    .foregroundColor(.white)
            }
            .onAppear {
                withAnimation(.easeInOut(duration: 2).repeatForever()) {
                    pulseEffect = true
                }
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text("PLANET PROTRADER")
                    .font(.system(size: 18, weight: .black, design: .rounded))
                    .foregroundStyle(DesignSystem.goldGradient)
                
                Text("Elite Trading System")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private var accountSwitcherButton: some View {
        Button(action: { showingAccountSwitcher = true }) {
            HStack(spacing: 10) {
                // Live indicator
                HStack(spacing: 6) {
                    Circle()
                        .fill(currentAccount.isLive ? Color.green : Color.orange)
                        .frame(width: 10, height: 10)
                        .overlay(
                            Circle()
                                .stroke(Color.white.opacity(0.3), lineWidth: 2)
                        )
                        .scaleEffect(currentAccount.isLive ? (pulseEffect ? 1.2 : 1.0) : 1.0)
                    
                    Text(currentAccount.isLive ? "LIVE" : "DEMO")
                        .font(.system(size: 9, weight: .black))
                        .foregroundColor(currentAccount.isLive ? .green : .orange)
                }
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text(currentAccount.displayName)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    Text(currentAccount.formattedBalance)
                        .font(.system(size: 16, weight: .black, design: .monospaced))
                        .foregroundStyle(DesignSystem.goldGradient)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(DesignSystem.primaryGold.opacity(0.2), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
        }
    }
    
    private var mainBalanceCard: some View {
        PremiumGlassCard {
            VStack(spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("TOTAL EQUITY")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.secondary)
                            .tracking(1.2)
                        
                        Text(realTimeAccountManager.formattedEquity)
                            .font(.system(size: 36, weight: .black, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [DesignSystem.primaryGold, DesignSystem.primaryGold.opacity(0.8)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .shadow(color: DesignSystem.primaryGold.opacity(0.3), radius: 4, x: 0, y: 2)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 6) {
                        HStack(spacing: 6) {
                            Image(systemName: realTimeAccountManager.todaysProfit >= 0 ? "arrow.up.right.circle.fill" : "arrow.down.right.circle.fill")
                                .font(.system(size: 16, weight: .bold))
                            Text(realTimeAccountManager.formattedTodaysProfit)
                                .font(.system(size: 18, weight: .bold, design: .monospaced))
                        }
                        .foregroundColor(realTimeAccountManager.todaysProfitColor)
                        
                        Text("Today")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(.secondary)
                            .tracking(0.5)
                    }
                }
                
                // Metrics row
                HStack(spacing: 24) {
                    MetricCard(
                        title: "Balance",
                        value: realTimeAccountManager.formattedBalance,
                        color: .primary,
                        icon: "dollarsign.circle.fill"
                    )
                    MetricCard(
                        title: "Open P&L",
                        value: realTimeAccountManager.formattedOpenPL,
                        color: realTimeAccountManager.openPLColor,
                        icon: "chart.line.uptrend.xyaxis"
                    )
                    MetricCard(
                        title: "Win Rate",
                        value: realTimeAccountManager.formattedWinRate,
                        color: .green,
                        icon: "target"
                    )
                }
            }
        }
    }
    
    // MARK: - Trading Bots Section
    private var tradingBotsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader(
                title: "🤖 AI Trading Bots",
                subtitle: "Your Trading Army",
                actionTitle: "Manage All"
            ) {
                // Navigate to bot management
            }
            
            // Bot cards carousel
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 16) {
                    ForEach(tradingBotManager.allBots.prefix(5), id: \.id) { bot in
                        BotCard(bot: bot) {
                            selectedBot = bot
                            showBotDetails = true
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 4)
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.95)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.2), value: animateCards)
    }
    
    // MARK: - Trading Metrics Section
    private var tradingMetricsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader(
                title: "⚡ AI Control Center",
                subtitle: "Real-time Trading Status",
                actionTitle: nil
            ) { }
            
            PremiumGlassCard {
                VStack(spacing: 20) {
                    HStack {
                        aiStatusIndicator
                        Spacer()
                        tradingStatsGrid
                    }
                    
                    // Control buttons
                    HStack(spacing: 12) {
                        ControlButton(
                            title: "START AI",
                            icon: "play.fill",
                            color: .green,
                            isEnabled: !tradingViewModel.isAutoTradingEnabled
                        ) {
                            HapticFeedbackManager.shared.success()
                            tradingViewModel.startAutoTrading()
                            toastManager.show("AI Trading Started", type: .success)
                        }
                        
                        ControlButton(
                            title: "STOP AI",
                            icon: "stop.fill",
                            color: .red,
                            isEnabled: tradingViewModel.isAutoTradingEnabled
                        ) {
                            HapticFeedbackManager.shared.warning()
                            tradingViewModel.stopAutoTrading()
                            toastManager.show("AI Trading Stopped", type: .warning)
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .scaleEffect(animateCards ? 1.0 : 0.95)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.3), value: animateCards)
    }
    
    private var aiStatusIndicator: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("AI CONFIDENCE")
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(.secondary)
                .tracking(1)
            
            HStack(spacing: 8) {
                Text("94.7%")
                    .font(.system(size: 24, weight: .black, design: .rounded))
                    .foregroundStyle(DesignSystem.goldGradient)
                
                Image(systemName: "brain.head.profile.fill")
                    .font(.system(size: 16))
                    .foregroundStyle(DesignSystem.goldGradient)
            }
        }
    }
    
    private var tradingStatsGrid: some View {
        VStack(alignment: .trailing, spacing: 8) {
            Text("ACTIVE TRADES")
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(.secondary)
                .tracking(1)
            
            Text("7")
                .font(.system(size: 24, weight: .black))
                .foregroundColor(.blue)
        }
    }
    
    // MARK: - Market Intelligence Section
    private var marketIntelligenceSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader(
                title: "📈 Market Intelligence",
                subtitle: "Live XAUUSD Analysis",
                actionTitle: "Details"
            ) {
                // Navigate to detailed analysis
            }
            
            PremiumGlassCard {
                VStack(spacing: 20) {
                    HStack {
                        priceDisplay
                        Spacer()
                        priceChangeDisplay
                    }
                    
                    // Market metrics
                    HStack(spacing: 20) {
                        MetricCard(title: "High", value: "$2,387.25", color: .green, icon: "arrow.up.circle.fill")
                        MetricCard(title: "Low", value: "$2,364.80", color: .red, icon: "arrow.down.circle.fill")
                        MetricCard(title: "Volume", value: "Heavy", color: .orange, icon: "chart.bar.fill")
                        MetricCard(title: "Trend", value: "Bullish", color: .blue, icon: "chart.line.uptrend.xyaxis")
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .scaleEffect(animateCards ? 1.0 : 0.95)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.4), value: animateCards)
    }
    
    private var priceDisplay: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("LIVE PRICE")
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(.secondary)
                .tracking(1.2)
            
            Text(tradingViewModel.formattedCurrentPrice)
                .font(.system(size: 32, weight: .black, design: .monospaced))
                .foregroundColor(.primary)
        }
    }
    
    private var priceChangeDisplay: some View {
        VStack(alignment: .trailing, spacing: 6) {
            HStack(spacing: 6) {
                Image(systemName: tradingViewModel.priceChange >= 0 ? "arrow.up.right.circle.fill" : "arrow.down.right.circle.fill")
                    .font(.system(size: 14, weight: .bold))
                Text(tradingViewModel.formattedPriceChange)
                    .font(.system(size: 16, weight: .bold, design: .monospaced))
            }
            .foregroundColor(tradingViewModel.priceColor)
            
            Text("Last Hour")
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(.secondary)
        }
    }
    
    // MARK: - Quick Actions Section
    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader(
                title: "⚡ Quick Actions",
                subtitle: "Essential Tools",
                actionTitle: nil
            ) { }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                quickActionItems
            }
            .padding(.horizontal, 20)
        }
        .scaleEffect(animateCards ? 1.0 : 0.95)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.5), value: animateCards)
    }
    
    @ViewBuilder
    private var quickActionItems: some View {
        QuickActionCard(icon: "chart.xyaxis.line", title: "Live Charts", subtitle: "Technical Analysis", color: .blue) {
            // Navigate to charts
        }
        
        QuickActionCard(icon: "gamecontroller.fill", title: "MicroFlip", subtitle: "Trade Gaming", color: DesignSystem.primaryGold) {
            // Navigate to MicroFlip
        }
        
        QuickActionCard(icon: "brain.head.profile.fill", title: "Bot Factory", subtitle: "AI Management", color: .purple) {
            // Navigate to bot factory
        }
        
        QuickActionCard(icon: "doc.text.fill", title: "Journal", subtitle: "Trade Analysis", color: .green) {
            // Navigate to journal
        }
        
        QuickActionCard(icon: "plus.circle.fill", title: "Add Account", subtitle: "Connect Broker", color: .orange) {
            showingAddAccount = true
        }
        
        QuickActionCard(icon: "gearshape.fill", title: "Settings", subtitle: "Preferences", color: .gray) {
            // Navigate to settings
        }
    }
    
    // MARK: - Performance Analytics Section
    private var performanceAnalyticsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader(
                title: "📊 Performance Analytics",
                subtitle: "Trading Statistics",
                actionTitle: "Full Report"
            ) {
                // Navigate to full analytics
            }
            
            PremiumGlassCard {
                VStack(spacing: 20) {
                    HStack {
                        performanceMetrics
                        Spacer()
                        tradingStatistics
                    }
                    
                    HStack(spacing: 16) {
                        MetricCard(title: "Profit Factor", value: "2.43", color: DesignSystem.primaryGold, icon: "multiply.circle.fill")
                        MetricCard(title: "Max DD", value: "3.2%", color: .red, icon: "arrow.down.circle.fill")
                        MetricCard(title: "Avg Trade", value: "$47.8", color: .green, icon: "dollarsign.circle.fill")
                        MetricCard(title: "Streak", value: "12W", color: .purple, icon: "flame.fill")
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .scaleEffect(animateCards ? 1.0 : 0.95)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.6), value: animateCards)
    }
    
    private var performanceMetrics: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("WIN RATE")
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(.secondary)
                .tracking(1)
            
            HStack(spacing: 8) {
                Text("87.5%")
                    .font(.system(size: 28, weight: .black))
                    .foregroundColor(.green)
                
                Image(systemName: "target")
                    .font(.system(size: 18))
                    .foregroundColor(.green)
            }
        }
    }
    
    private var tradingStatistics: some View {
        VStack(alignment: .trailing, spacing: 6) {
            Text("TOTAL TRADES")
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(.secondary)
                .tracking(1)
            
            HStack(spacing: 8) {
                Text("342")
                    .font(.system(size: 28, weight: .black))
                    .foregroundColor(.blue)
                
                Image(systemName: "chart.bar.fill")
                    .font(.system(size: 18))
                    .foregroundColor(.blue)
            }
        }
    }
    
    // MARK: - Helper Methods
    private func sectionHeader(title: String, subtitle: String? = nil, actionTitle: String?, action: @escaping () -> Void) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 20, weight: .black, design: .rounded))
                    .foregroundColor(.primary)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            if let actionTitle = actionTitle {
                Button(actionTitle, action: action)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(DesignSystem.goldGradient)
            }
        }
        .padding(.horizontal, 20)
    }
    
    private func startAnimations() {
        withAnimation(.spring(response: 1.0, dampingFraction: 0.8).delay(0.3)) {
            animateCards = true
        }
    }
    
    private func startRealTimeUpdates() {
        refreshTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
            Task { @MainActor in
                tradingViewModel.refreshAllData()
                await realTimeAccountManager.refreshAccountData()
            }
        }
    }
    
    private func stopRealTimeUpdates() {
        refreshTimer?.invalidate()
        refreshTimer = nil
    }
    
    private func refreshAllData() async {
        await realTimeAccountManager.refreshAccountData()
        tradingViewModel.refreshAllData()
    }
    
    // MARK: - Computed Properties
    private var currentAccount: (displayName: String, formattedBalance: String, isLive: Bool) {
        if realTimeAccountManager.activeAccounts.indices.contains(selectedAccountIndex) {
            let account = realTimeAccountManager.activeAccounts[selectedAccountIndex]
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

// MARK: - Supporting Components

struct PremiumGlassCard<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(24)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.ultraThinMaterial)
                    
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.2),
                                    Color.clear,
                                    DesignSystem.primaryGold.opacity(0.1)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                }
            )
            .shadow(color: .black.opacity(0.05), radius: 20, x: 0, y: 10)
    }
}

struct BotCard: View {
    let bot: CoreTypes.TradingBot
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 16) {
                // Header
                HStack {
                    ZStack {
                        Circle()
                            .fill(Color(hex: bot.primaryColor) ?? DesignSystem.primaryGold)
                            .frame(width: 32, height: 32)
                        
                        Image(systemName: bot.icon)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(bot.name)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.primary)
                            .lineLimit(1)
                        
                        HStack(spacing: 4) {
                            Circle()
                                .fill(bot.status.color)
                                .frame(width: 6, height: 6)
                            
                            Text(bot.status.rawValue)
                                .font(.system(size: 10, weight: .semibold))
                                .foregroundColor(bot.status.color)
                        }
                    }
                    
                    Spacer()
                }
                
                // Performance
                VStack(spacing: 8) {
                    HStack {
                        Text("PERFORMANCE")
                            .font(.system(size: 9, weight: .bold))
                            .foregroundColor(.secondary)
                            .tracking(0.5)
                        
                        Spacer()
                        
                        Text("+\(String(format: "%.1f", bot.performance))%")
                            .font(.system(size: 16, weight: .black))
                            .foregroundColor(.green)
                    }
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Trades")
                                .font(.system(size: 8, weight: .medium))
                                .foregroundColor(.secondary)
                            
                            Text("\(bot.totalTrades)")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.primary)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 2) {
                            Text("Win Rate")
                                .font(.system(size: 8, weight: .medium))
                                .foregroundColor(.secondary)
                            
                            Text("\(Int(bot.winRate * 100))%")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.blue)
                        }
                    }
                    
                    HStack {
                        Text("Profit")
                            .font(.system(size: 8, weight: .medium))
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Text("$\(String(format: "%.0f", bot.profit))")
                            .font(.system(size: 14, weight: .black, design: .monospaced))
                            .foregroundStyle(DesignSystem.goldGradient)
                    }
                }
            }
            .padding(16)
            .frame(width: 180, height: 160)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.ultraThinMaterial)
                    
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color(hex: bot.primaryColor)?.opacity(0.3) ?? DesignSystem.primaryGold.opacity(0.3),
                                    Color.clear,
                                    Color(hex: bot.secondaryColor)?.opacity(0.2) ?? DesignSystem.primaryGold.opacity(0.2)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                }
            )
            .shadow(color: .black.opacity(0.05), radius: 12, x: 0, y: 6)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct MetricCard: View {
    let title: String
    let value: String
    let color: Color
    let icon: String
    
    var body: some View {
        VStack(spacing: 6) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(color)
                
                Text(title.uppercased())
                    .font(.system(size: 9, weight: .bold))
                    .foregroundColor(.secondary)
                    .tracking(0.5)
            }
            
            Text(value)
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity)
    }
}

struct ControlButton: View {
    let title: String
    let icon: String
    let color: Color
    let isEnabled: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .bold))
                
                Text(title)
                    .font(.system(size: 14, weight: .bold))
                    .tracking(0.5)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                ZStack {
                    if isEnabled {
                        LinearGradient(
                            colors: [color, color.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    } else {
                        Color.gray.opacity(0.3)
                    }
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: isEnabled ? color.opacity(0.3) : .clear, radius: 8, x: 0, y: 4)
        }
        .disabled(!isEnabled)
    }
}

struct QuickActionCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: 48, height: 48)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(color)
                }
                
                VStack(spacing: 4) {
                    Text(title)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.primary)
                    
                    Text(subtitle)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.secondary)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(color.opacity(0.2), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.03), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Extensions

struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

extension Color {
    init?(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            return nil
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

#Preview {
    HomeDashboardView()
        .environmentObject(TradingViewModel())
        .environmentObject(RealTimeAccountManager())
        .environmentObject(AutoTradingManager())
        .environmentObject(TradingBotManager.shared)
        .environmentObject(ToastManager.shared)
        .preferredColorScheme(.light)
}