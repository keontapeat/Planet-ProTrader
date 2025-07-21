//
//  HomeDashboardView.swift
//  Planet ProTrader - Ultra Premium Dashboard
//
//  Award-winning $50K+ Design
//  Created by Elite UI/UX Team
//

import SwiftUI
import Combine

struct HomeDashboardView: View {
    // MARK: - Environment Objects
    @EnvironmentObject var tradingViewModel: TradingViewModel
    @EnvironmentObject var realTimeAccountManager: RealTimeAccountManager
    @EnvironmentObject var autoTradingManager: AutoTradingManager
    @EnvironmentObject var brokerConnector: BrokerConnector
    @EnvironmentObject var realDataManager: RealDataManager
    
    // MARK: - State Management
    @State private var selectedAccount = 0
    @State private var showingAccountSwitcher = false
    @State private var showingAddAccount = false
    @State private var animateCards = false
    @State private var refreshTimer: Timer?
    @State private var selectedBot: TradingBot?
    @State private var showBotDetails = false
    @State private var pulseEffect = false
    @State private var scrollOffset: CGFloat = 0
    @State private var headerOpacity: Double = 1.0
    
    // MARK: - Sample Bot Data (Replace with real data)
    @State private var topBots: [TradingBot] = [
        TradingBot(name: "Gold Hunter AI", status: .trading, strategy: "Scalping", performance: 127.8, totalTrades: 342, winRate: 0.89, profit: 15420.50, icon: "crown.fill", primaryColor: "#FFD700", secondaryColor: "#FFA500"),
        TradingBot(name: "Momentum Master", status: .analyzing, strategy: "Swing Trading", performance: 98.5, totalTrades: 156, winRate: 0.76, profit: 8750.25, icon: "bolt.fill", primaryColor: "#00CED1", secondaryColor: "#4682B4"),
        TradingBot(name: "Risk Sentinel", status: .active, strategy: "Risk Management", performance: 84.3, totalTrades: 89, winRate: 0.82, profit: 3950.75, icon: "shield.fill", primaryColor: "#32CD32", secondaryColor: "#228B22"),
        TradingBot(name: "News Reactor", status: .learning, strategy: "News Trading", performance: 156.7, totalTrades: 203, winRate: 0.91, profit: 12340.88, icon: "newspaper.fill", primaryColor: "#FF6347", secondaryColor: "#DC143C"),
        TradingBot(name: "Pattern Prophet", status: .trading, strategy: "Pattern Recognition", performance: 203.2, totalTrades: 445, winRate: 0.85, profit: 18750.60, icon: "eye.fill", primaryColor: "#9370DB", secondaryColor: "#8A2BE2")
    ]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // MARK: - Premium Background
                premiumBackground
                
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 0) {
                        // MARK: - Hero Header
                        heroHeaderSection(geometry: geometry)
                        
                        // MARK: - ProTrader Bot Reel (Feature Highlight)
                        proTraderBotReel
                            .padding(.top, 20)
                        
                        // MARK: - Live Trading Metrics
                        liveTradingMetrics
                            .padding(.top, 30)
                        
                        // MARK: - Market Intelligence
                        marketIntelligenceSection
                            .padding(.top, 25)
                        
                        // MARK: - Quick Actions Grid
                        quickActionsGrid
                            .padding(.top, 25)
                        
                        // MARK: - Performance Analytics
                        performanceAnalytics
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
                
                // MARK: - Floating Action Button
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        FloatingActionButton {
                            // Quick trade action
                        }
                        .padding(.trailing, 20)
                        .padding(.bottom, 100)
                    }
                }
            }
        }
        .ignoresSafeArea(edges: .top)
        .onAppear {
            startRealTimeUpdates()
            startAnimations()
        }
        .onDisappear {
            stopRealTimeUpdates()
        }
        .sheet(isPresented: $showingAccountSwitcher) {
            UltraPremiumAccountSwitcher()
        }
        .sheet(isPresented: $showingAddAccount) {
            UltraPremiumAddAccountView()
        }
        .sheet(isPresented: $showBotDetails) {
            if let bot = selectedBot {
                BotDetailModal(bot: bot)
            }
        }
    }
    
    // MARK: - Premium Background
    private var premiumBackground: some View {
        ZStack {
            // Base gradient
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
            ForEach(0..<6, id: \.self) { index in
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                DesignSystem.primaryGold.opacity(0.1),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: 100
                        )
                    )
                    .frame(width: CGFloat.random(in: 80...150))
                    .offset(
                        x: CGFloat.random(in: -200...200),
                        y: CGFloat.random(in: -300...300)
                    )
                    .blur(radius: 20)
                    .animation(
                        .easeInOut(duration: Double.random(in: 6...12))
                        .repeatForever(autoreverses: true)
                        .delay(Double(index) * 0.5),
                        value: animateCards
                    )
            }
        }
        .ignoresSafeArea()
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
                HStack {
                    // Brand
                    HStack(spacing: 12) {
                        // Animated logo
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
                            Text("GOLDEX AI")
                                .font(.system(size: 22, weight: .black, design: .rounded))
                                .foregroundStyle(DesignSystem.goldGradient)
                            
                            Text("Elite Trading System")
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Spacer()
                    
                    // Account switcher with premium styling
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
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                // Main balance display with glassmorphism
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
                            PremiumMetric(title: "Balance", value: realTimeAccountManager.formattedBalance, color: .primary, icon: "dollarsign.circle.fill")
                            PremiumMetric(title: "Open P&L", value: realTimeAccountManager.formattedOpenPL, color: realTimeAccountManager.openPLColor, icon: "chart.line.uptrend.xyaxis")
                            PremiumMetric(title: "Win Rate", value: realTimeAccountManager.formattedWinRate, color: .green, icon: "target")
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
        }
        .opacity(headerOpacity)
    }
    
    // MARK: - ProTrader Bot Reel (Premium Feature)
    private var proTraderBotReel: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                HStack(spacing: 8) {
                    ZStack {
                        Circle()
                            .fill(DesignSystem.goldGradient)
                            .frame(width: 28, height: 28)
                        
                        Image(systemName: "brain.head.profile.fill")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                    }
                    
                    Text("ProTrader Bot Army")
                        .font(.system(size: 20, weight: .black, design: .rounded))
                        .foregroundColor(.primary)
                }
                
                Spacer()
                
                Button("View All") {
                    // Navigate to full bot list
                }
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(DesignSystem.goldGradient)
            }
            .padding(.horizontal, 20)
            
            // Bot cards reel
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 16) {
                    ForEach(topBots, id: \.id) { bot in
                        BotReelCard(bot: bot) {
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
    
    // MARK: - Live Trading Metrics
    private var liveTradingMetrics: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("🚀 AI Trading Control")
                    .font(.system(size: 20, weight: .black, design: .rounded))
                    .foregroundColor(.primary)
                
                Spacer()
                
                // AI Status indicator
                HStack(spacing: 8) {
                    Circle()
                        .fill(tradingViewModel.isAutoTradingEnabled ? Color.green : Color.red)
                        .frame(width: 10, height: 10)
                        .overlay(
                            Circle()
                                .stroke(Color.white.opacity(0.3), lineWidth: 2)
                        )
                        .scaleEffect(tradingViewModel.isAutoTradingEnabled ? (pulseEffect ? 1.3 : 1.0) : 1.0)
                    
                    Text(tradingViewModel.isAutoTradingEnabled ? "AI ACTIVE" : "AI INACTIVE")
                        .font(.system(size: 11, weight: .black))
                        .foregroundColor(tradingViewModel.isAutoTradingEnabled ? .green : .red)
                        .tracking(0.8)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(.ultraThinMaterial)
                .clipShape(Capsule())
            }
            .padding(.horizontal, 20)
            
            PremiumGlassCard {
                VStack(spacing: 20) {
                    HStack {
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
                        
                        Spacer()
                        
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
                    
                    // Control buttons with premium styling
                    HStack(spacing: 12) {
                        PremiumButton(
                            title: "START AI",
                            icon: "play.fill",
                            color: .green,
                            isEnabled: !tradingViewModel.isAutoTradingEnabled
                        ) {
                            tradingViewModel.startAutoTrading()
                        }
                        
                        PremiumButton(
                            title: "STOP AI",
                            icon: "stop.fill",
                            color: .red,
                            isEnabled: tradingViewModel.isAutoTradingEnabled
                        ) {
                            tradingViewModel.stopAutoTrading()
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
    
    // MARK: - Market Intelligence Section
    private var marketIntelligenceSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("📈 Market Intelligence")
                    .font(.system(size: 20, weight: .black, design: .rounded))
                    .foregroundColor(.primary)
                
                Spacer()
                
                Text("XAUUSD")
                    .font(.system(size: 12, weight: .black))
                    .foregroundStyle(DesignSystem.goldGradient)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(DesignSystem.primaryGold.opacity(0.1))
                    .clipShape(Capsule())
            }
            .padding(.horizontal, 20)
            
            PremiumGlassCard {
                VStack(spacing: 20) {
                    HStack {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("LIVE PRICE")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(.secondary)
                                .tracking(1.2)
                            
                            Text(tradingViewModel.formattedCurrentPrice)
                                .font(.system(size: 32, weight: .black, design: .monospaced))
                                .foregroundColor(.primary)
                        }
                        
                        Spacer()
                        
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
                    
                    // Market metrics
                    HStack(spacing: 20) {
                        PremiumMetric(title: "High", value: "$2,387.25", color: .green, icon: "arrow.up.circle.fill")
                        PremiumMetric(title: "Low", value: "$2,364.80", color: .red, icon: "arrow.down.circle.fill")
                        PremiumMetric(title: "Volume", value: "Heavy", color: .orange, icon: "chart.bar.fill")
                        PremiumMetric(title: "Trend", value: "Bullish", color: .blue, icon: "chart.line.uptrend.xyaxis")
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .scaleEffect(animateCards ? 1.0 : 0.95)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.4), value: animateCards)
    }
    
    // MARK: - Quick Actions Grid
    private var quickActionsGrid: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("⚡ Quick Actions")
                    .font(.system(size: 20, weight: .black, design: .rounded))
                    .foregroundColor(.primary)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                QuickActionCard(icon: "chart.xyaxis.line", title: "Live Charts", subtitle: "Technical Analysis", color: .blue) {
                    // Chart action
                }
                
                QuickActionCard(icon: "gamecontroller.fill", title: "MicroFlip", subtitle: "Trade Gaming", color: DesignSystem.primaryGold) {
                    // Navigate to MicroFlip
                }
                
                QuickActionCard(icon: "brain.head.profile.fill", title: "Bot Factory", subtitle: "AI Management", color: .purple) {
                    // Bot factory
                }
                
                QuickActionCard(icon: "doc.text.fill", title: "Journal", subtitle: "Trade Analysis", color: .green) {
                    // Trade journal
                }
                
                QuickActionCard(icon: "plus.circle.fill", title: "Add Account", subtitle: "Connect Broker", color: .orange) {
                    showingAddAccount = true
                }
                
                QuickActionCard(icon: "gearshape.fill", title: "Settings", subtitle: "Preferences", color: .gray) {
                    // Settings
                }
            }
            .padding(.horizontal, 20)
        }
        .scaleEffect(animateCards ? 1.0 : 0.95)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.5), value: animateCards)
    }
    
    // MARK: - Performance Analytics
    private var performanceAnalytics: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("📊 Performance Analytics")
                .font(.system(size: 20, weight: .black, design: .rounded))
                .foregroundColor(.primary)
                .padding(.horizontal, 20)
            
            PremiumGlassCard {
                VStack(spacing: 20) {
                    HStack {
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
                        
                        Spacer()
                        
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
                    
                    HStack(spacing: 16) {
                        PremiumMetric(title: "Profit Factor", value: "2.43", color: DesignSystem.primaryGold, icon: "multiply.circle.fill")
                        PremiumMetric(title: "Max DD", value: "3.2%", color: .red, icon: "arrow.down.circle.fill")
                        PremiumMetric(title: "Avg Trade", value: "$47.8", color: .green, icon: "dollarsign.circle.fill")
                        PremiumMetric(title: "Streak", value: "12W", color: .purple, icon: "flame.fill")
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .scaleEffect(animateCards ? 1.0 : 0.95)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.6), value: animateCards)
    }
    
    // MARK: - Helper Methods
    private func startRealTimeUpdates() {
        refreshTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
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
        withAnimation(.spring(response: 1.0, dampingFraction: 0.8).delay(0.3)) {
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

// MARK: - Premium Components

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
                    // Glass effect
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.ultraThinMaterial)
                    
                    // Border
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

struct BotReelCard: View {
    let bot: TradingBot
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

struct PremiumMetric: View {
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

struct PremiumButton: View {
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

struct FloatingActionButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(DesignSystem.goldGradient)
                    .frame(width: 56, height: 56)
                    .shadow(color: DesignSystem.primaryGold.opacity(0.4), radius: 12, x: 0, y: 6)
                
                Image(systemName: "bolt.fill")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Supporting Modal Views

struct BotDetailModal: View {
    let bot: TradingBot
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Bot header
                    VStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(Color(hex: bot.primaryColor) ?? DesignSystem.primaryGold)
                                .frame(width: 80, height: 80)
                            
                            Image(systemName: bot.icon)
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.white)
                        }
                        
                        VStack(spacing: 8) {
                            Text(bot.name)
                                .font(.title.bold())
                            
                            Text(bot.strategy)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    // Performance metrics
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                        StatCard(title: "Performance", value: "+\(String(format: "%.1f", bot.performance))%", color: .green)
                        StatCard(title: "Total Trades", value: "\(bot.totalTrades)", color: .blue)
                        StatCard(title: "Win Rate", value: "\(Int(bot.winRate * 100))%", color: .green)
                        StatCard(title: "Profit", value: "$\(String(format: "%.2f", bot.profit))", color: DesignSystem.primaryGold)
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Bot Details")
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

struct UltraPremiumAccountSwitcher: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var realTimeAccountManager: RealTimeAccountManager
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(realTimeAccountManager.activeAccounts.indices, id: \.self) { index in
                        let account = realTimeAccountManager.activeAccounts[index]
                        
                        Button(action: {
                            realTimeAccountManager.switchToAccount(at: index)
                            dismiss()
                        }) {
                            PremiumAccountRow(
                                account: account, 
                                isSelected: index == realTimeAccountManager.selectedAccountIndex
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding()
            }
            .navigationTitle("Select Account")
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

struct PremiumAccountRow: View {
    let account: RealTimeAccountManager.TradingAccount
    let isSelected: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            // Account type indicator
            ZStack {
                Circle()
                    .fill(account.isDemo ? Color.orange : Color.green)
                    .frame(width: 40, height: 40)
                
                Image(systemName: account.isDemo ? "play.circle.fill" : "bolt.circle.fill")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(account.name)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.primary)
                    
                    Text(account.isDemo ? "DEMO" : "LIVE")
                        .font(.system(size: 10, weight: .black))
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(account.isDemo ? Color.orange : Color.green)
                        .clipShape(Capsule())
                }
                
                Text(account.formattedBalance)
                    .font(.system(size: 18, weight: .black, design: .monospaced))
                    .foregroundStyle(DesignSystem.goldGradient)
                
                Text("Server: \(account.server)")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.green)
            }
        }
        .padding(20)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(.ultraThinMaterial)
                
                if isSelected {
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(DesignSystem.goldGradient, lineWidth: 2)
                }
            }
        )
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

struct UltraPremiumAddAccountView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var login = ""
    @State private var password = ""
    @State private var server = ""
    @State private var accountType: AccountType = .demo
    
    enum AccountType {
        case demo, live
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(DesignSystem.goldGradient)
                                .frame(width: 80, height: 80)
                            
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.white)
                        }
                        
                        Text("Add Trading Account")
                            .font(.title2.bold())
                    }
                    .padding(.top)
                    
                    // Form
                    VStack(spacing: 20) {
                        PremiumTextField(title: "Login", text: $login, icon: "person.circle.fill")
                        PremiumSecureField(title: "Password", text: $password, icon: "lock.circle.fill")
                        PremiumTextField(title: "Server", text: $server, icon: "server.rack")
                        
                        // Account type picker
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Account Type")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.primary)
                            
                            HStack(spacing: 12) {
                                Button(action: { accountType = .demo }) {
                                    HStack {
                                        Image(systemName: "play.circle.fill")
                                        Text("Demo")
                                            .font(.system(size: 14, weight: .semibold))
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(accountType == .demo ? Color.orange : Color.gray.opacity(0.2))
                                    .foregroundColor(accountType == .demo ? .white : .primary)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                }
                                
                                Button(action: { accountType = .live }) {
                                    HStack {
                                        Image(systemName: "bolt.circle.fill")
                                        Text("Live")
                                            .font(.system(size: 14, weight: .semibold))
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(accountType == .live ? Color.green : Color.gray.opacity(0.2))
                                    .foregroundColor(accountType == .live ? .white : .primary)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                }
                            }
                        }
                    }
                    
                    Spacer()
                    
                    // Actions
                    VStack(spacing: 16) {
                        PremiumButton(
                            title: "CONNECT ACCOUNT",
                            icon: "link.circle.fill",
                            color: DesignSystem.primaryGold,
                            isEnabled: !login.isEmpty && !password.isEmpty && !server.isEmpty
                        ) {
                            // Connect account logic
                            dismiss()
                        }
                        
                        Button("Cancel") {
                            dismiss()
                        }
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.secondary)
                    }
                }
                .padding()
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

struct PremiumTextField: View {
    let title: String
    @Binding var text: String
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.secondary)
                
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.primary)
            }
            
            TextField("Enter \(title.lowercased())", text: $text)
                .padding(16)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
        }
    }
}

struct PremiumSecureField: View {
    let title: String
    @Binding var text: String
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.secondary)
                
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.primary)
            }
            
            SecureField("Enter \(title.lowercased())", text: $text)
                .padding(16)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
        }
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

// MARK: - Previews

#Preview("Light Mode") {
    HomeDashboardView()
        .environmentObject(TradingViewModel())
        .environmentObject(RealTimeAccountManager())
        .environmentObject(AutoTradingManager())
        .environmentObject(BrokerConnector())
        .environmentObject(RealDataManager())
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    HomeDashboardView()
        .environmentObject(TradingViewModel())
        .environmentObject(RealTimeAccountManager())
        .environmentObject(AutoTradingManager())
        .environmentObject(BrokerConnector())
        .environmentObject(RealDataManager())
        .preferredColorScheme(.dark)
}