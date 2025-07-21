//
//  AutoTradingControlView.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 7/13/25.
//

import SwiftUI

struct AutoTradingControlView: View {
    @EnvironmentObject var autoTradingManager: AutoTradingManager
    @StateObject private var vpsManager = VPSManager()
    @StateObject private var aiHuntingEngine = AIHuntingEngine()
    
    @State private var selectedHuntingMode: HuntingMode = .patient
    @State private var selectedVPS: VPSServer? = nil
    @State private var showingVPSSetup = false
    @State private var showingBrokerSetup = false
    @State private var showingRiskSettings = false
    @State private var showingAdvancedAI = false
    @State private var showingTradeHistory = false
    @State private var animateHunting = false
    @State private var realTimeData: [LiveMarketData] = []
    @State private var selectedStrategy: AIStrategy = .neural
    @State private var activeTrades: [SharedTypes.AutoTrade] = []
    
    // Real-time refresh timer
    @State private var refreshTimer: Timer?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // MARK: - Epic AI Header
                epicAIHeader
                
                // MARK: - VPS Connection Matrix
                vpsConnectionMatrix
                
                // MARK: - AI Hunting Status
                aiHuntingStatus
                
                // MARK: - Real-Time Market Scanner
                realTimeMarketScanner
                
                // MARK: - Trading Performance Dashboard
                tradingPerformanceDashboard
                
                // MARK: - AI Strategy Control Center
                aiStrategyControlCenter
                
                // MARK: - Live Trade Monitoring
                liveTradeMonitoring
                
                // MARK: - Advanced Settings
                advancedSettings
                
                Spacer(minLength: 100)
            }
            .padding(.top, 20)
        }
        .background(DesignSystem.backgroundGradient.ignoresSafeArea())
        .onAppear {
            startRealTimeUpdates()
            loadVPSServers()
        }
        .onDisappear {
            stopRealTimeUpdates()
        }
        .sheet(isPresented: $showingVPSSetup) {
            VPSSetupView(vpsManager: vpsManager)
        }
        .sheet(isPresented: $showingBrokerSetup) {
            BrokerSetupView()
        }
        .sheet(isPresented: $showingRiskSettings) {
            AutoTradingSettingsView()
        }
        .sheet(isPresented: $showingAdvancedAI) {
            AdvancedAISettingsView(aiEngine: aiHuntingEngine)
        }
        .sheet(isPresented: $showingTradeHistory) {
            AutoTradeHistoryView()
        }
    }
    
    // MARK: - Epic AI Header
    private var epicAIHeader: some View {
        UltraPremiumCard {
            VStack(spacing: 16) {
                HStack {
                    // AI Avatar
                    ZStack {
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [DesignSystem.primaryGold.opacity(0.3), .clear],
                                    center: .center,
                                    startRadius: 10,
                                    endRadius: 30
                                )
                            )
                            .frame(width: 60, height: 60)
                            .scaleEffect(animateHunting ? 1.2 : 1.0)
                            .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: animateHunting)
                        
                        Image(systemName: "brain.head.profile")
                            .font(.title)
                            .foregroundStyle(DesignSystem.primaryGold)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("GOLDEX AI HUNTER")
                            .font(.title2)
                            .fontWeight(.black)
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [DesignSystem.primaryGold, .orange],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                        
                        Text(aiHuntingEngine.currentStatus)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 8) {
                        Circle()
                            .fill(aiHuntingEngine.isHunting ? .green : .red)
                            .frame(width: 16, height: 16)
                            .scaleEffect(animateHunting ? 1.3 : 1.0)
                            .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: animateHunting)
                        
                        Text(aiHuntingEngine.isHunting ? "HUNTING" : "DORMANT")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundStyle(aiHuntingEngine.isHunting ? .green : .red)
                    }
                }
                
                // AI Power Level
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("AI Power Level")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundStyle(.secondary)
                        
                        Spacer()
                        
                        Text("\(Int(aiHuntingEngine.powerLevel * 100))%")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundStyle(DesignSystem.primaryGold)
                    }
                    
                    ProgressView(value: aiHuntingEngine.powerLevel)
                        .progressViewStyle(LinearProgressViewStyle(tint: DesignSystem.primaryGold))
                        .scaleEffect(y: 2)
                }
                
                // Quick Stats Row
                HStack(spacing: 16) {
                    QuickStat(title: "Win Rate", value: "\(Int(aiHuntingEngine.winRate * 100))%", color: .green)
                    QuickStat(title: "Hunts Today", value: "\(aiHuntingEngine.huntsToday)", color: .blue)
                    QuickStat(title: "Success Rate", value: "\(Int(aiHuntingEngine.successRate * 100))%", color: .orange)
                }
            }
        }
        .padding(.horizontal)
    }
    
    // MARK: - VPS Connection Matrix
    private var vpsConnectionMatrix: some View {
        UltraPremiumCard {
            VStack(spacing: 16) {
                HStack {
                    Text("VPS CONNECTION MATRIX")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)
                    
                    Spacer()
                    
                    Button(action: { showingVPSSetup = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                            .foregroundStyle(DesignSystem.primaryGold)
                    }
                }
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                    ForEach(vpsManager.vpsInstances, id: \.id) { vps in
                        VPSInstanceCard(vps: vps, isSelected: selectedVPS?.name == vps.name) {
                            selectedVPS = VPSServer(name: vps.name, location: "Remote", ping: 25, isConnected: vps.isConnected)
                            connectToVPS(vps)
                        }
                    }
                }
                
                if vpsManager.vpsInstances.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "server.rack")
                            .font(.title)
                            .foregroundStyle(.secondary)
                        
                        Text("No VPS Connected")
                            .font(.headline)
                            .fontWeight(.medium)
                            .foregroundStyle(.secondary)
                        
                        Text("Connect your VPS to unleash 24/7 AI trading")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                        
                        Button(action: { showingVPSSetup = true }) {
                            Text("Connect VPS")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 12)
                                .background(DesignSystem.primaryGold)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                    .padding(.vertical, 20)
                }
            }
        }
        .padding(.horizontal)
    }
    
    // MARK: - AI Hunting Status
    private var aiHuntingStatus: some View {
        UltraPremiumCard {
            VStack(spacing: 16) {
                HStack {
                    Text("AI HUNTING ENGINE")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)
                    
                    Spacer()
                    
                    Toggle("", isOn: $aiHuntingEngine.isHunting)
                        .toggleStyle(SwitchToggleStyle(tint: DesignSystem.primaryGold))
                        .onChange(of: aiHuntingEngine.isHunting) { _, newValue in
                            withAnimation(.spring()) {
                                animateHunting = newValue
                                if newValue {
                                    aiHuntingEngine.startHunting()
                                } else {
                                    aiHuntingEngine.stopHunting()
                                }
                            }
                        }
                }
                
                // Hunting Mode Selection
                VStack(spacing: 12) {
                    Text("Hunting Style")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)
                    
                    HStack(spacing: 8) {
                        ForEach(HuntingMode.allCases, id: \.self) { mode in
                            Button(action: {
                                selectedHuntingMode = mode
                            }) {
                                Text(mode.rawValue)
                                    .font(.caption)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(selectedHuntingMode == mode ? DesignSystem.primaryGold : Color.gray.opacity(0.2))
                                    .foregroundColor(selectedHuntingMode == mode ? .white : .primary)
                                    .cornerRadius(8)
                            }
                        }
                    }
                }
                
                // Current Hunt Status
                if aiHuntingEngine.isHunting {
                    VStack(spacing: 8) {
                        HStack {
                            Image(systemName: "target")
                                .font(.subheadline)
                                .foregroundStyle(DesignSystem.primaryGold)
                            
                            Text("Current Hunt:")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundStyle(.primary)
                            
                            Spacer()
                            
                            Text(aiHuntingEngine.currentTarget)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundStyle(DesignSystem.primaryGold)
                        }
                        
                        ProgressView(value: aiHuntingEngine.huntProgress)
                            .progressViewStyle(LinearProgressViewStyle(tint: DesignSystem.primaryGold))
                            .scaleEffect(y: 1.5)
                    }
                    .padding()
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                }
            }
        }
        .padding(.horizontal)
    }
    
    // MARK: - Real-Time Market Scanner
    private var realTimeMarketScanner: some View {
        UltraPremiumCard {
            VStack(spacing: 16) {
                HStack {
                    Text("LIVE MARKET SCANNER")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)
                    
                    Spacer()
                    
                    Text("Live")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(.red, in: RoundedRectangle(cornerRadius: 4))
                }
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                    ForEach(realTimeData, id: \.symbol) { data in
                        LiveDataCard(data: data)
                    }
                }
                
                // Market Sentiment Gauge
                VStack(spacing: 8) {
                    Text("Market Sentiment")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)
                    
                    HStack(spacing: 4) {
                        ForEach(0..<10, id: \.self) { index in
                            Rectangle()
                                .fill(index < Int(aiHuntingEngine.marketSentiment * 10) ? DesignSystem.primaryGold : Color.gray.opacity(0.3))
                                .frame(height: 8)
                                .clipShape(RoundedRectangle(cornerRadius: 2))
                        }
                    }
                    
                    Text(aiHuntingEngine.sentimentDescription)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundStyle(DesignSystem.primaryGold)
                }
            }
        }
        .padding(.horizontal)
    }
    
    // MARK: - Trading Performance Dashboard
    private var tradingPerformanceDashboard: some View {
        UltraPremiumCard {
            VStack(spacing: 16) {
                HStack {
                    Text("PERFORMANCE METRICS")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)
                    
                    Spacer()
                    
                    Button(action: { refreshPerformanceData() }) {
                        Image(systemName: "arrow.clockwise")
                            .font(.subheadline)
                            .foregroundStyle(DesignSystem.primaryGold)
                    }
                }
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                    PerformanceCard(
                        title: "Today's P&L",
                        value: formatCurrency(autoTradingManager.todaysProfit),
                        change: Double.random(in: -5...5),
                        icon: "dollarsign.circle.fill",
                        color: autoTradingManager.todaysProfit >= 0 ? .green : .red
                    )
                    
                    PerformanceCard(
                        title: "Win Rate",
                        value: "\(Int(autoTradingManager.todayWinRate * 100))%",
                        change: Double.random(in: -3...3),
                        icon: "chart.line.uptrend.xyaxis",
                        color: .green
                    )
                    
                    PerformanceCard(
                        title: "Total Trades",
                        value: "\(autoTradingManager.totalTradesToday)",
                        change: Double.random(in: -2...2),
                        icon: "arrow.left.arrow.right",
                        color: .blue
                    )
                    
                    PerformanceCard(
                        title: "AI Accuracy",
                        value: "\(Int(aiHuntingEngine.aiAccuracy * 100))%",
                        change: aiHuntingEngine.accuracyChange,
                        icon: "brain.head.profile",
                        color: .purple
                    )
                }
                
                // Balance Growth Chart
                VStack(spacing: 8) {
                    HStack {
                        Text("Balance Growth Today")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundStyle(.secondary)
                        
                        Spacer()
                        
                        Text(formatCurrency(autoTradingManager.todaysProfit + 5000.0))
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundStyle(.primary)
                    }
                    
                    // Mini chart visualization
                    HStack(spacing: 2) {
                        ForEach(0..<20, id: \.self) { index in
                            let height = CGFloat.random(in: 10...40)
                            Rectangle()
                                .fill(DesignSystem.primaryGold.opacity(0.7))
                                .frame(width: 3, height: height)
                                .clipShape(RoundedRectangle(cornerRadius: 1))
                        }
                    }
                    .frame(height: 40)
                }
            }
        }
        .padding(.horizontal)
    }
    
    // MARK: - AI Strategy Control Center
    private var aiStrategyControlCenter: some View {
        UltraPremiumCard {
            VStack(spacing: 16) {
                HStack {
                    Text("AI STRATEGY CENTER")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)
                    
                    Spacer()
                    
                    Button(action: { showingAdvancedAI = true }) {
                        Image(systemName: "gearshape.fill")
                            .font(.subheadline)
                            .foregroundStyle(DesignSystem.primaryGold)
                    }
                }
                
                // Strategy Selection
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(AIStrategy.allCases, id: \.self) { strategy in
                            StrategyCard(
                                strategy: strategy,
                                isSelected: selectedStrategy == strategy,
                                aiEngine: aiHuntingEngine
                            ) {
                                selectedStrategy = strategy
                                aiHuntingEngine.setStrategy(strategy)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                // AI Learning Progress
                VStack(spacing: 8) {
                    HStack {
                        Text("AI Learning Progress")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundStyle(.secondary)
                        
                        Spacer()
                        
                        Text("\(Int(aiHuntingEngine.learningProgress * 100))%")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundStyle(DesignSystem.primaryGold)
                    }
                    
                    ProgressView(value: aiHuntingEngine.learningProgress)
                        .progressViewStyle(LinearProgressViewStyle(tint: DesignSystem.primaryGold))
                        .scaleEffect(y: 1.5)
                    
                    Text("AI is getting smarter with every trade...")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.horizontal)
    }
    
    // MARK: - Live Trade Monitoring
    private var liveTradeMonitoring: some View {
        UltraPremiumCard {
            VStack(spacing: 16) {
                HStack {
                    Text("LIVE TRADES")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)
                    
                    Spacer()
                    
                    Button(action: { showingTradeHistory = true }) {
                        Text("View All")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundStyle(DesignSystem.primaryGold)
                    }
                }
                
                if activeTrades.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "chart.line.flattrend.xyaxis")
                            .font(.title)
                            .foregroundStyle(.secondary)
                        
                        Text("No Active Trades")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundStyle(.secondary)
                        
                        Text("AI is analyzing market conditions...")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 20)
                } else {
                    LazyVStack(spacing: 8) {
                        ForEach(activeTrades.prefix(3), id: \.id) { trade in
                            LiveTradeCard(trade: trade)
                        }
                    }
                }
            }
        }
        .padding(.horizontal)
    }
    
    // MARK: - Advanced Settings
    private var advancedSettings: some View {
        UltraPremiumCard {
            VStack(spacing: 16) {
                HStack {
                    Text("ADVANCED SETTINGS")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)
                    
                    Spacer()
                }
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                    ActionCard(
                        title: "VPS Setup",
                        icon: "server.rack",
                        color: .blue
                    ) {
                        showingVPSSetup = true
                    }
                    
                    ActionCard(
                        title: "Broker Link",
                        icon: "link",
                        color: .green
                    ) {
                        showingBrokerSetup = true
                    }
                    
                    ActionCard(
                        title: "Risk Settings",
                        icon: "shield.fill",
                        color: .orange
                    ) {
                        showingRiskSettings = true
                    }
                    
                    ActionCard(
                        title: "AI Advanced",
                        icon: "brain.head.profile",
                        color: .purple
                    ) {
                        showingAdvancedAI = true
                    }
                }
            }
        }
        .padding(.horizontal)
    }
    
    // MARK: - Helper Methods
    private func startRealTimeUpdates() {
        refreshTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
            updateRealTimeData()
            updateTradingData()
            aiHuntingEngine.updateStatus()
        }
        animateHunting = aiHuntingEngine.isHunting
    }
    
    private func stopRealTimeUpdates() {
        refreshTimer?.invalidate()
        refreshTimer = nil
    }
    
    private func updateRealTimeData() {
        // Simulate real-time market data updates
        realTimeData = [
            LiveMarketData(symbol: "XAUUSD", price: 2374.85 + Double.random(in: -10...10), change: Double.random(in: -2...2)),
            LiveMarketData(symbol: "EURUSD", price: 1.0892 + Double.random(in: -0.01...0.01), change: Double.random(in: -1...1)),
            LiveMarketData(symbol: "GBPUSD", price: 1.2756 + Double.random(in: -0.01...0.01), change: Double.random(in: -1...1)),
            LiveMarketData(symbol: "USDJPY", price: 149.23 + Double.random(in: -1...1), change: Double.random(in: -1...1))
        ]
    }
    
    private func updateTradingData() {
        // Update trading data from the manager
        // This replaces the removed updateData() method
        Task {
            // Simulate loading active trades
            activeTrades = []
        }
    }
    
    private func loadVPSServers() {
        Task {
            await vpsManager.initializeVPSManager()
        }
    }
    
    private func connectToVPS(_ vps: VPSInstance) {
        Task {
            // Convert VPSInstance to VPSConnection for the existing method
            let vpsConnection = SharedTypes.VPSConnection(
                id: vps.id,
                ipAddress: vps.host,
                status: vps.isConnected ? .connected : .disconnected,
                accountsRunning: vps.accountsRunning,
                maxAccounts: vps.maxAccounts
            )
            await vpsManager.connectToVPS(vpsConnection)
            if vps.isConnected {
                let server = VPSServer(name: vps.name, location: "Remote", ping: 25, isConnected: vps.isConnected)
                aiHuntingEngine.connectToVPS(server)
            }
        }
    }
    
    private func refreshPerformanceData() {
        withAnimation(.spring()) {
            // Refresh performance data
            // This replaces the removed refreshData() method
            Task {
                // Simulate data refresh
                updateTradingData()
                aiHuntingEngine.refreshStats()
            }
        }
    }
    
    private func formatCurrency(_ amount: Double) -> String {
        return String(format: "$%.2f", amount)
    }
}

// MARK: - Supporting Views

struct QuickStat: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundStyle(color)
            
            Text(title)
                .font(.caption2)
                .fontWeight(.medium)
                .foregroundStyle(.secondary)
        }
    }
}

struct VPSInstanceCard: View {
    let vps: VPSInstance
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                HStack {
                    Circle()
                        .fill(vps.isConnected ? .green : .red)
                        .frame(width: 8, height: 8)
                    
                    Text(vps.name)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundStyle(.primary)
                    
                    Spacer()
                }
                
                HStack {
                    Text(vps.host)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    Text("\(vps.accountsRunning)/\(vps.maxAccounts)")
                        .font(.caption2)
                        .fontWeight(.medium)
                        .foregroundStyle(vps.accountsRunning < vps.maxAccounts ? .green : .orange)
                }
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? DesignSystem.primaryGold.opacity(0.2) : .gray.opacity(0.1))
                    .stroke(isSelected ? DesignSystem.primaryGold : .clear, lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct LiveDataCard: View {
    let data: LiveMarketData
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(data.symbol)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                
                Spacer()
                
                Text(data.change >= 0 ? "+\(String(format: "%.2f", data.change))%" : "\(String(format: "%.2f", data.change))%")
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundStyle(data.change >= 0 ? .green : .red)
            }
            
            Text(String(format: "%.4f", data.price))
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundStyle(data.change >= 0 ? .green : .red)
        }
        .padding(8)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 6))
    }
}

struct PerformanceCard: View {
    let title: String
    let value: String
    let change: Double
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .font(.subheadline)
                    .foregroundStyle(color)
                
                Spacer()
                
                Text(change >= 0 ? "+\(String(format: "%.1f", change))%" : "\(String(format: "%.1f", change))%")
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundStyle(change >= 0 ? .green : .red)
            }
            
            Text(value)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundStyle(color)
            
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(.secondary)
        }
        .padding(12)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8))
    }
}

struct StrategyCard: View {
    let strategy: AIStrategy
    let isSelected: Bool
    let aiEngine: AIHuntingEngine
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: strategy.icon)
                    .font(.title2)
                    .foregroundStyle(isSelected ? .white : DesignSystem.primaryGold)
                
                Text(strategy.name)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(isSelected ? .white : .primary)
                
                Text(strategy.description)
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundStyle(isSelected ? .white.opacity(0.8) : .secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .frame(width: 120)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? DesignSystem.primaryGold : .gray.opacity(0.1))
                    .stroke(isSelected ? .clear : DesignSystem.primaryGold.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct LiveTradeCard: View {
    let trade: SharedTypes.AutoTrade
    
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(trade.direction == .buy ? .green : .red)
                .frame(width: 8, height: 8)
            
            VStack(alignment: .leading, spacing: 2) {
                Text("\(trade.mode.rawValue) \(trade.direction.rawValue)")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(.primary)
                
                Text("Entry: \(String(format: "%.2f", trade.entryPrice))")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                Text(trade.profitLoss != nil ? formatCurrency(trade.profitLoss!) : "-")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(trade.profitLoss ?? 0 >= 0 ? .green : .red)
                
                Text("\(Int(trade.confidence * 100))%")
                    .font(.caption2)
                    .foregroundStyle(DesignSystem.primaryGold)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8))
    }
    
    private func formatCurrency(_ amount: Double) -> String {
        return String(format: "$%.2f", amount)
    }
}

struct ActionCard: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(color)
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Data Models

enum HuntingMode: String, CaseIterable {
    case patient = "Patient"
    case aggressive = "Aggressive"
    case stealth = "Stealth"
    case assassin = "Assassin"
    
    var icon: String {
        switch self {
        case .patient: return "clock.fill"
        case .aggressive: return "bolt.fill"
        case .stealth: return "eye.slash.fill"
        case .assassin: return "target"
        }
    }
}

enum AIStrategy: String, CaseIterable {
    case neural = "Neural"
    case quantum = "Quantum"
    case hybrid = "Hybrid"
    case adaptive = "Adaptive"
    
    var name: String { rawValue }
    
    var description: String {
        switch self {
        case .neural: return "Deep learning patterns"
        case .quantum: return "Quantum algorithms"
        case .hybrid: return "Multi-strategy AI"
        case .adaptive: return "Self-improving AI"
        }
    }
    
    var icon: String {
        switch self {
        case .neural: return "brain.head.profile"
        case .quantum: return "atom"
        case .hybrid: return "gearshape.2.fill"
        case .adaptive: return "arrow.triangle.2.circlepath"
        }
    }
}

struct LiveMarketData {
    let symbol: String
    let price: Double
    let change: Double
}

struct VPSServer: Identifiable {
    let id = UUID()
    let name: String
    let location: String
    let ping: Int
    let isConnected: Bool
}

// MARK: - Managers

@MainActor
class AIHuntingEngine: ObservableObject {
    @Published var isHunting = false
    @Published var currentStatus = "AI is dormant - Ready to hunt"
    @Published var powerLevel: Double = 0.75
    @Published var winRate: Double = 0.87
    @Published var huntsToday = 24
    @Published var successRate: Double = 0.92
    @Published var currentTarget = "Analyzing patterns..."
    @Published var huntProgress: Double = 0.0
    @Published var marketSentiment: Double = 0.7
    @Published var sentimentDescription = "Bullish Momentum"
    @Published var aiAccuracy: Double = 0.94
    @Published var accuracyChange: Double = 2.3
    @Published var learningProgress: Double = 0.85
    
    func startHunting() {
        isHunting = true
        currentStatus = "AI is actively hunting for high-probability trades"
        currentTarget = "XAUUSD Bull Pattern"
        
        // Start hunting progress simulation
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            Task { @MainActor in
                if self.huntProgress < 1.0 {
                    self.huntProgress += 0.01
                } else {
                    self.huntProgress = 0.0
                    self.currentTarget = self.getNextTarget()
                }
            }
        }
    }
    
    func stopHunting() {
        isHunting = false
        currentStatus = "AI is dormant - Ready to hunt"
        huntProgress = 0.0
    }
    
    func setHuntingMode(_ mode: HuntingMode) {
        currentStatus = "AI switched to \(mode.rawValue) mode"
    }
    
    func setStrategy(_ strategy: AIStrategy) {
        currentStatus = "AI deployed \(strategy.name) strategy"
    }
    
    func connectToVPS(_ server: VPSServer) {
        currentStatus = "AI connected to \(server.name) - Full power activated"
        powerLevel = 1.0
    }
    
    func updateStatus() {
        // Simulate real-time updates
        if isHunting {
            huntsToday += Int.random(in: 0...1)
            winRate += Double.random(in: -0.01...0.01)
            winRate = max(0.0, min(1.0, winRate))
        }
    }
    
    func refreshStats() {
        // Simulate data refresh
        aiAccuracy += Double.random(in: -0.02...0.02)
        aiAccuracy = max(0.0, min(1.0, aiAccuracy))
        accuracyChange = Double.random(in: -3...3)
        learningProgress += 0.01
        if learningProgress > 1.0 { learningProgress = 0.85 }
    }
    
    private func getNextTarget() -> String {
        let targets = [
            "XAUUSD Bull Breakout",
            "EURUSD Support Zone",
            "GBPUSD Reversal Pattern",
            "Gold Institutional Level",
            "Major Support Break"
        ]
        return targets.randomElement() ?? "Scanning..."
    }
}

// MARK: - Additional Views

struct VPSSetupView: View {
    let vpsManager: VPSManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("VPS Setup View")
                    .font(.title)
                
                Button("Done") {
                    dismiss()
                }
                .padding()
                .background(DesignSystem.primaryGold)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .navigationTitle("VPS Setup")
        }
    }
}

struct AutoTradingSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var riskLevel: Double = 2.0
    @State private var maxDailyTrades: Double = 10.0
    @State private var enableNotifications = true
    @State private var enableStopLoss = true
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Risk Management
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Risk Management")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.primary)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Risk Level: \(Int(riskLevel))%")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.secondary)
                            
                            Slider(value: $riskLevel, in: 1...5, step: 0.5)
                                .accentColor(DesignSystem.primaryGold)
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Max Daily Trades: \(Int(maxDailyTrades))")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.secondary)
                            
                            Slider(value: $maxDailyTrades, in: 5...50, step: 1)
                                .accentColor(DesignSystem.primaryGold)
                        }
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.systemGray6))
                    )
                    
                    // Trading Options
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Trading Options")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.primary)
                        
                        Toggle("Enable Notifications", isOn: $enableNotifications)
                            .font(.system(size: 14, weight: .medium))
                            .toggleStyle(SwitchToggleStyle(tint: DesignSystem.primaryGold))
                        
                        Toggle("Enable Stop Loss", isOn: $enableStopLoss)
                            .font(.system(size: 14, weight: .medium))
                            .toggleStyle(SwitchToggleStyle(tint: DesignSystem.primaryGold))
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.systemGray6))
                    )
                    
                    // Save Button
                    Button(action: {
                        // Save settings
                        dismiss()
                    }) {
                        Text("Save Settings")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                LinearGradient(
                                    colors: [DesignSystem.primaryGold, DesignSystem.primaryGold.opacity(0.8)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .cornerRadius(12)
                            .shadow(color: DesignSystem.primaryGold.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                }
                .padding(.horizontal, 20)
            }
            .navigationTitle("Trading Settings")
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

struct AdvancedAISettingsView: View {
    let aiEngine: AIHuntingEngine
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Advanced AI Settings")
                    .font(.title)
                
                Button("Done") {
                    dismiss()
                }
                .padding()
                .background(DesignSystem.primaryGold)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .navigationTitle("AI Settings")
        }
    }
}

// MARK: - Preview
struct AutoTradingControlView_Previews: PreviewProvider {
    static var previews: some View {
        AutoTradingControlView()
            .environmentObject(TradingViewModel())
            .environmentObject(RealTimeAccountManager())
    }
}