//
//  EnhancedHomeDashboardView.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 7/18/25.
//

import SwiftUI

struct EnhancedHomeDashboardView: View {
    @StateObject private var chatEngine = BotChatEngine()
    @StateObject private var argumentEngine = TradeArgumentEngine()
    @EnvironmentObject var tradingViewModel: TradingViewModel
    @EnvironmentObject var realTimeAccountManager: RealTimeAccountManager
    
    @State private var selectedTab = 0
    @State private var showingDiscordSimulation = false
    @State private var showingBotArena = false
    @State private var animateCards = false
    @State private var refreshTimer: Timer?
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Premium Background
                LinearGradient(
                    colors: [
                        Color(.systemBackground),
                        DesignSystem.primaryGold.opacity(0.03),
                        Color(.systemBackground),
                        DesignSystem.primaryGold.opacity(0.02)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    LazyVStack(spacing: 24) {
                        // Elite Header Section
                        eliteHeaderSection
                        
                        // Live Bot Activity Feed
                        liveBotActivitySection
                        
                        // Trading Command Center
                        tradingCommandCenter
                        
                        // Bot Arena Quick Access
                        botArenaSection
                        
                        // Performance Analytics
                        performanceAnalyticsSection
                        
                        // Quick Actions Grid
                        quickActionsGrid
                        
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
                startBotSimulation()
            }
            .onDisappear {
                stopRealTimeUpdates()
                stopBotSimulation()
            }
        }
        .sheet(isPresented: $showingDiscordSimulation) {
            DiscordSimulationView()
        }
        .sheet(isPresented: $showingBotArena) {
            BotArenaView()
        }
    }
    
    // MARK: - Elite Header Section
    private var eliteHeaderSection: some View {
        VStack(spacing: 20) {
            // Brand Header
            HStack {
                // Animated Logo
                ZStack {
                    Circle()
                        .fill(DesignSystem.goldGradient)
                        .frame(width: 48, height: 48)
                        .scaleEffect(animateCards ? 1.1 : 1.0)
                        .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: animateCards)
                    
                    Image(systemName: "brain.head.profile")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("GOLDEX AI")
                        .font(.system(size: 24, weight: .black, design: .rounded))
                        .foregroundColor(DesignSystem.primaryGold)
                    
                    Text("Elite Trading Command Center")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Live Status Indicator
                VStack(alignment: .trailing, spacing: 4) {
                    HStack(spacing: 6) {
                        Circle()
                            .fill(.green)
                            .frame(width: 8, height: 8)
                            .scaleEffect(animateCards ? 1.2 : 1.0)
                            .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: animateCards)
                        
                        Text("LIVE")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.green)
                    }
                    
                    Text("\(chatEngine.activeBotsCount) Bots Active")
                        .font(.system(size: 10))
                        .foregroundColor(.secondary)
                }
            }
            .padding(.top, 8)
            
            // Elite Account Summary Card
            UltraPremiumCard {
                VStack(spacing: 20) {
                    HStack {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("TOTAL PORTFOLIO VALUE")
                                .font(.system(size: 11, weight: .black))
                                .foregroundColor(.secondary)
                            
                            Text(realTimeAccountManager.formattedEquity)
                                .font(.system(size: 32, weight: .black, design: .rounded))
                                .foregroundColor(.primary)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 6) {
                            HStack(spacing: 6) {
                                Image(systemName: realTimeAccountManager.todaysProfit >= 0 ? "arrow.up.right" : "arrow.down.right")
                                    .font(.system(size: 14, weight: .bold))
                                Text(realTimeAccountManager.formattedTodaysProfit)
                                    .font(.system(size: 18, weight: .bold))
                            }
                            .foregroundColor(realTimeAccountManager.todaysProfitColor)
                            
                            Text("Today's P&L")
                                .font(.system(size: 10, weight: .semibold))
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    // Performance Metrics Row
                    HStack(spacing: 20) {
                        EliteMetricView(title: "Win Rate", value: realTimeAccountManager.formattedWinRate, color: .green, icon: "target")
                        EliteMetricView(title: "Active Trades", value: "12", color: .blue, icon: "arrow.triangle.2.circlepath")
                        EliteMetricView(title: "Bot Score", value: "94.8", color: DesignSystem.primaryGold, icon: "brain")
                        EliteMetricView(title: "Risk Level", value: "Low", color: .orange, icon: "shield.fill")
                    }
                }
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.95)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1), value: animateCards)
    }
    
    // MARK: - Live Bot Activity Section
    private var liveBotActivitySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("🤖 Live Bot Activity")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                
                Spacer()
                
                Button("View Discord") {
                    showingDiscordSimulation = true
                }
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(DesignSystem.primaryGold)
            }
            
            UltraPremiumCard {
                VStack(spacing: 16) {
                    // Activity Stats
                    HStack(spacing: 20) {
                        ActivityStatView(title: "Messages/Min", value: "47", color: .green, isAnimated: true)
                        ActivityStatView(title: "Active Fights", value: "\(argumentEngine.activeArguments.count)", color: .red, isAnimated: true)
                        ActivityStatView(title: "Signals Posted", value: "23", color: .blue, isAnimated: false)
                        ActivityStatView(title: "Profit Calls", value: "89%", color: DesignSystem.primaryGold, isAnimated: false)
                    }
                    
                    Divider()
                    
                    // Recent Bot Messages Preview
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Latest Bot Chatter")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.secondary)
                        
                        ForEach(getRecentMessages().prefix(3), id: \.id) { message in
                            BotMessagePreview(message: message, persona: chatEngine.getPersona(for: message.botId))
                        }
                        
                        if argumentEngine.activeArguments.count > 0 {
                            HStack {
                                Image(systemName: "flame.fill")
                                    .foregroundColor(.red)
                                Text("🔥 LIVE FIGHT: \(argumentEngine.activeArguments.first?.topic ?? "Bot war in progress")")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.red)
                                Spacer()
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(.red.opacity(0.1))
                            .cornerRadius(8)
                        }
                    }
                }
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.95)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2), value: animateCards)
    }
    
    // MARK: - Trading Command Center
    private var tradingCommandCenter: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("⚡ Trading Command Center")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
            
            UltraPremiumCard {
                VStack(spacing: 20) {
                    // AI Status Display
                    HStack {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("AI TRADING STATUS")
                                .font(.system(size: 11, weight: .black))
                                .foregroundColor(.secondary)
                            
                            HStack(spacing: 8) {
                                Text(tradingViewModel.autoTradingStatusText)
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(tradingViewModel.autoTradingStatusColor)
                                
                                if tradingViewModel.isAutoTradingEnabled {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                        .scaleEffect(animateCards ? 1.1 : 1.0)
                                        .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: animateCards)
                                }
                            }
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 6) {
                            Text("AI CONFIDENCE")
                                .font(.system(size: 11, weight: .black))
                                .foregroundColor(.secondary)
                            
                            Text("96.8%")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(DesignSystem.primaryGold)
                        }
                    }
                    
                    // Enhanced Control Buttons
                    HStack(spacing: 12) {
                        Button(action: {
                            withAnimation(.spring()) {
                                tradingViewModel.startAutoTrading()
                            }
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "play.fill")
                                    .font(.system(size: 16, weight: .bold))
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("START AI")
                                        .font(.system(size: 14, weight: .bold))
                                    Text("Begin trading")
                                        .font(.system(size: 10))
                                }
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                LinearGradient(
                                    colors: [.green, .green.opacity(0.8)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .disabled(tradingViewModel.isAutoTradingEnabled)
                        
                        Button(action: {
                            withAnimation(.spring()) {
                                tradingViewModel.stopAutoTrading()
                            }
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "stop.fill")
                                    .font(.system(size: 16, weight: .bold))
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("STOP AI")
                                        .font(.system(size: 14, weight: .bold))
                                    Text("Halt trading")
                                        .font(.system(size: 10))
                                }
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                LinearGradient(
                                    colors: [.red, .red.opacity(0.8)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .disabled(!tradingViewModel.isAutoTradingEnabled)
                    }
                    
                    // Live Market Data
                    VStack(spacing: 12) {
                        HStack {
                            Text("XAUUSD LIVE")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            Text("Last Updated: 2s ago")
                                .font(.system(size: 10))
                                .foregroundColor(.secondary)
                        }
                        
                        HStack(spacing: 20) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("$2,387.45")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.primary)
                                
                                HStack(spacing: 4) {
                                    Image(systemName: "arrow.up.right")
                                        .font(.system(size: 10, weight: .bold))
                                    Text("+0.75%")
                                        .font(.system(size: 12, weight: .bold))
                                }
                                .foregroundColor(.green)
                            }
                            
                            Spacer()
                            
                            HStack(spacing: 16) {
                                MarketDataPoint(title: "High", value: "$2,392.10", color: .green)
                                MarketDataPoint(title: "Low", value: "$2,381.20", color: .red)
                                MarketDataPoint(title: "Volume", value: "High", color: .orange)
                            }
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(10)
                }
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.95)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3), value: animateCards)
    }
    
    // MARK: - Bot Arena Section
    private var botArenaSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("🏟️ Bot Arena")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                
                Spacer()
                
                Button("Enter Arena") {
                    showingBotArena = true
                }
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(DesignSystem.primaryGold)
            }
            
            HStack(spacing: 12) {
                // Top Performing Bot
                UltraPremiumCard {
                    VStack(spacing: 12) {
                        HStack {
                            Text("👑 TOP BOT")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(DesignSystem.primaryGold)
                            
                            Spacer()
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("🎯")
                                    .font(.system(size: 20))
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("SwingMaster_Pro")
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundColor(.primary)
                                    
                                    Text("Win Streak: 15")
                                        .font(.system(size: 10))
                                        .foregroundColor(.green)
                                }
                                
                                Spacer()
                            }
                            
                            HStack {
                                Text("Profit:")
                                    .font(.system(size: 10))
                                    .foregroundColor(.secondary)
                                Text("+$15,247")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.green)
                                
                                Spacer()
                                
                                Text("94.8%")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundColor(DesignSystem.primaryGold)
                            }
                        }
                    }
                }
                
                // Live Competition
                UltraPremiumCard {
                    VStack(spacing: 12) {
                        HStack {
                            Text("⚔️ LIVE BATTLE")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.red)
                            
                            Spacer()
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("ScalpKing vs NewsNinja")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.primary)
                            
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Score: 7-5")
                                        .font(.system(size: 10))
                                        .foregroundColor(.secondary)
                                    
                                    Text("Duration: 2:47")
                                        .font(.system(size: 10))
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                Text("🔥 INTENSE")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundColor(.red)
                            }
                        }
                    }
                }
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.95)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.4), value: animateCards)
    }
    
    // MARK: - Performance Analytics Section
    private var performanceAnalyticsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("📊 Performance Analytics")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
            
            HStack(spacing: 12) {
                // Win Rate Card
                UltraPremiumCard {
                    VStack(spacing: 12) {
                        HStack {
                            Text("🎯 WIN RATE")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            Text("Last 7 days")
                                .font(.system(size: 9))
                                .foregroundColor(.secondary)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("87.3%")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.green)
                            
                            HStack(spacing: 4) {
                                Image(systemName: "arrow.up.right")
                                    .font(.system(size: 10))
                                Text("+2.4%")
                                    .font(.system(size: 10, weight: .semibold))
                            }
                            .foregroundColor(.green)
                        }
                    }
                }
                
                // Profit Factor Card
                UltraPremiumCard {
                    VStack(spacing: 12) {
                        HStack {
                            Text("💰 PROFIT FACTOR")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            Text("This month")
                                .font(.system(size: 9))
                                .foregroundColor(.secondary)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("2.67")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(DesignSystem.primaryGold)
                            
                            HStack(spacing: 4) {
                                Image(systemName: "arrow.up.right")
                                    .font(.system(size: 10))
                                Text("+0.15")
                                    .font(.system(size: 10, weight: .semibold))
                            }
                            .foregroundColor(.green)
                        }
                    }
                }
                
                // Drawdown Card
                UltraPremiumCard {
                    VStack(spacing: 12) {
                        HStack {
                            Text("🛡️ MAX DD")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            Text("All time")
                                .font(.system(size: 9))
                                .foregroundColor(.secondary)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("2.1%")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.orange)
                            
                            HStack(spacing: 4) {
                                Image(systemName: "arrow.down.right")
                                    .font(.system(size: 10))
                                Text("-0.3%")
                                    .font(.system(size: 10, weight: .semibold))
                            }
                            .foregroundColor(.green)
                        }
                    }
                }
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.95)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.5), value: animateCards)
    }
    
    // MARK: - Quick Actions Grid
    private var quickActionsGrid: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("⚡ Quick Actions")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                EnhancedQuickActionButton(
                    icon: "bubble.left.and.bubble.right.fill",
                    title: "Bot Discord",
                    subtitle: "Watch bots argue",
                    color: .purple
                ) {
                    showingDiscordSimulation = true
                }
                
                EnhancedQuickActionButton(
                    icon: "crown.fill",
                    title: "Bot Arena",
                    subtitle: "Competition mode",
                    color: DesignSystem.primaryGold
                ) {
                    showingBotArena = true
                }
                
                EnhancedQuickActionButton(
                    icon: "chart.xyaxis.line",
                    title: "Live Charts",
                    subtitle: "Market analysis",
                    color: .blue
                ) {
                    // Chart action
                }
                
                EnhancedQuickActionButton(
                    icon: "gearshape.2.fill",
                    title: "AI Settings",
                    subtitle: "Configure bots",
                    color: .green
                ) {
                    // Settings action
                }
                
                EnhancedQuickActionButton(
                    icon: "brain.head.profile",
                    title: "Bot Profiles",
                    subtitle: "View all bots",
                    color: .red
                ) {
                    // Bot profiles
                }
                
                EnhancedQuickActionButton(
                    icon: "dollarsign.circle.fill",
                    title: "Wallet",
                    subtitle: "Manage funds",
                    color: .orange
                ) {
                    // Wallet action
                }
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.95)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.6), value: animateCards)
    }
    
    // MARK: - Helper Methods
    private func getRecentMessages() -> [ProTraderMessage] {
        return chatEngine.messages
            .filter { Date().timeIntervalSince($0.timestamp) < 300 } // Last 5 minutes
            .sorted { $0.timestamp > $1.timestamp }
    }
    
    private func startAnimations() {
        withAnimation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.2)) {
            animateCards = true
        }
    }
    
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
    
    private func startBotSimulation() {
        chatEngine.startSimulation()
        argumentEngine.startArgumentGeneration()
    }
    
    private func stopBotSimulation() {
        chatEngine.stopSimulation()
        argumentEngine.stopArgumentGeneration()
    }
    
    private func refreshAllData() async {
        await realTimeAccountManager.refreshAccountData()
        tradingViewModel.refreshAllData()
    }
}

// MARK: - Supporting Views

struct EliteMetricView: View {
    let title: String
    let value: String
    let color: Color
    let icon: String
    
    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(color)
            
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

struct ActivityStatView: View {
    let title: String
    let value: String
    let color: Color
    let isAnimated: Bool
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(color)
                .scaleEffect(isAnimated ? 1.1 : 1.0)
                .animation(isAnimated ? .easeInOut(duration: 1.0).repeatForever(autoreverses: true) : .none, value: isAnimated)
            
            Text(title)
                .font(.system(size: 9, weight: .medium))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }
}

struct BotMessagePreview: View {
    let message: ProTraderMessage
    let persona: BotPersona?
    
    var body: some View {
        HStack(spacing: 8) {
            Text(persona?.avatar ?? "🤖")
                .font(.system(size: 16))
            
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text(message.botName)
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    if let persona = persona {
                        Text(persona.currentMood.emoji)
                            .font(.system(size: 10))
                    }
                    
                    Spacer()
                    
                    Text(message.formattedTimestamp)
                        .font(.system(size: 9))
                        .foregroundColor(.secondary)
                }
                
                Text(message.content)
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

struct MarketDataPoint: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(color)
            
            Text(title)
                .font(.system(size: 8, weight: .medium))
                .foregroundColor(.secondary)
        }
    }
}

struct EnhancedQuickActionButton: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            UltraPremiumCard {
                VStack(spacing: 12) {
                    Image(systemName: icon)
                        .font(.system(size: 24))
                        .foregroundColor(color)
                    
                    VStack(spacing: 4) {
                        Text(title)
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.primary)
                        
                        Text(subtitle)
                            .font(.system(size: 10))
                            .foregroundColor(.secondary)
                    }
                    .multilineTextAlignment(.center)
                }
                .padding(.vertical, 8)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Bot Arena Placeholder View
struct BotArenaView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Text("🏟️ Bot Arena")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Coming Soon!")
                    .font(.title2)
                    .foregroundColor(.secondary)
                
                Text("Bot competitions, leaderboards, and epic battles!")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Bot Arena")
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
    EnhancedHomeDashboardView()
        .environmentObject(TradingViewModel())
        .environmentObject(RealTimeAccountManager())
}