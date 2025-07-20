//
//  ProTraderDashboardView.swift
//  GOLDEX AI
//
//  Created by Goldex AI on 7/19/25.
//

import SwiftUI

struct ProTraderDashboardView: View {
    @StateObject private var armyManager = EnhancedProTraderArmyManager()
    @StateObject private var csvImporter = CSVImporter()
    @State private var selectedTimeframe = "1H"
    @State private var showingTrainingResults = false
    @State private var showingBotDetails = false
    @State private var selectedBot: EnhancedProTraderBot?
    @State private var showingImporter = false
    @State private var showingGPTChat = false
    @State private var animateElements = false
    @State private var showingVPSStatus = false
    @State private var showingScreenshotGallery = false
    
    private let timeframes = ["1M", "5M", "15M", "1H", "4H", "1D"]
    
    var body: some View {
        NavigationStack {
            SwiftUI.ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 24) {
                    // Enhanced Header Stats
                    enhancedHeaderStatsSection
                    
                    // Army Overview Cards
                    enhancedArmyOverviewSection
                    
                    // VPS Status Section
                    vpsStatusSection
                    
                    // Training Section
                    enhancedTrainingSection
                    
                    // Performance Charts
                    enhancedPerformanceChartsSection
                    
                    // Top Performers
                    enhancedTopPerformersSection
                    
                    // A+ Screenshots Gallery
                    aPlusScreenshotsSection
                    
                    // Footer spacing
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
            }
            .background(
                LinearGradient(
                    colors: [
                        Color(red: 0.02, green: 0.05, blue: 0.15),
                        Color(red: 0.05, green: 0.08, blue: 0.20),
                        Color(red: 0.08, green: 0.12, blue: 0.25)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
            )
            .navigationTitle("GOLDEX AI Army")
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.dark)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 12) {
                        // VPS Status Button
                        Button(action: { showingVPSStatus = true }) {
                            HStack(spacing: 4) {
                                Circle()
                                    .fill(armyManager.isConnectedToVPS ? .green : .red)
                                    .frame(width: 8, height: 8)
                                Text("VPS")
                                    .font(.caption.bold())
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(.ultraThinMaterial, in: Capsule())
                        }
                        
                        // Auto-Trading Toggle
                        Menu {
                            Button("Start Auto-Trading") {
                                Task {
                                    await armyManager.startAutoTrading()
                                }
                            }
                            Button("Stop Auto-Trading") {
                                Task {
                                    await armyManager.stopAutoTrading()
                                }
                            }
                        } label: {
                            Image(systemName: "robot")
                                .font(.title2)
                                .foregroundStyle(.white)
                        }
                    }
                }
            }
        }
        .overlay {
            if armyManager.isTraining {
                enhancedTrainingOverlay
            }
        }
        .sheet(isPresented: $showingImporter) {
            AdvancedCSVImporterView(armyManager: armyManager)
        }
        .sheet(isPresented: $showingTrainingResults) {
            if let results = armyManager.lastTrainingResults {
                EnhancedTrainingResultsView(results: results)
            }
        }
        .sheet(isPresented: $showingBotDetails) {
            if let bot = selectedBot {
                EnhancedBotDetailView(bot: bot)
            }
        }
        .sheet(isPresented: $showingVPSStatus) {
            VPSStatusView(vpsManager: armyManager.vpsManager)
        }
        .sheet(isPresented: $showingScreenshotGallery) {
            ScreenshotGalleryView()
        }
        .sheet(isPresented: $showingGPTChat) {
            ProTraderGPTChatView()
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.2)) {
                animateElements = true
            }
            armyManager.startContinuousLearning()
        }
    }
    
    // MARK: - Enhanced Header Stats Section
    private var enhancedHeaderStatsSection: some View {
        VStack(spacing: 20) {
            // Enhanced Army Status Banner
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 8) {
                        Text("🚀")
                            .font(.title)
                        
                        Text("GOLDEX AI ARMY STATUS")
                            .font(.system(size: 22, weight: .black, design: .rounded))
                            .foregroundStyle(.white)
                    }
                    
                    Text("5,000 ProTrader Bots • \(armyManager.getArmyStats().connectedToVPS) VPS Active")
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundStyle(.white.opacity(0.8))
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 6) {
                    HStack(spacing: 6) {
                        Circle()
                            .fill(armyManager.isConnectedToVPS ? .green : .red)
                            .frame(width: 8, height: 8)
                        Text(armyManager.isConnectedToVPS ? "VPS CONNECTED" : "VPS OFFLINE")
                            .font(.system(size: 12, weight: .bold, design: .rounded))
                            .foregroundStyle(armyManager.isConnectedToVPS ? .green : .red)
                    }
                    
                    Text("24/7 AI Learning Active")
                        .font(.system(size: 11, weight: .medium, design: .rounded))
                        .foregroundStyle(.white.opacity(0.7))
                }
            }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.orange.opacity(0.2),
                                Color.red.opacity(0.1),
                                Color.purple.opacity(0.05)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(
                                LinearGradient(
                                    colors: [Color.orange.opacity(0.5), Color.red.opacity(0.3)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
            )
            .scaleEffect(animateElements ? 1.0 : 0.9)
            .opacity(animateElements ? 1.0 : 0.0)
            .animation(.spring(response: 0.6, dampingFraction: 0.8), value: animateElements)
            
            // Enhanced Key Metrics Grid
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                EnhancedProTraderMetricCard(
                    icon: "brain.head.profile",
                    title: "Avg Confidence",
                    value: String(format: "%.1f%%", armyManager.averageConfidence * 100),
                    subtitle: "Target: 90%+",
                    color: confidenceColor(armyManager.averageConfidence),
                    trend: .up
                )
                
                EnhancedProTraderMetricCard(
                    icon: "chart.xyaxis.line",
                    title: "Total XP",
                    value: formatNumber(armyManager.totalXP),
                    subtitle: "Growing Daily",
                    color: .blue,
                    trend: .up
                )
                
                EnhancedProTraderMetricCard(
                    icon: "crown.fill",
                    title: "GODMODE Bots",
                    value: "\(armyManager.godmodeBots)",
                    subtitle: "95%+ Confidence",
                    color: .orange,
                    trend: .up
                )
                
                EnhancedProTraderMetricCard(
                    icon: "diamond.fill",
                    title: "Elite Bots",
                    value: "\(armyManager.eliteBots)",
                    subtitle: "80%+ Confidence",
                    color: .purple,
                    trend: .stable
                )
            }
        }
    }
    
    // MARK: - Enhanced Army Overview Section
    private var enhancedArmyOverviewSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("🏛️")
                    .font(.title2)
                
                Text("ARMY OVERVIEW")
                    .font(.system(size: 18, weight: .black, design: .rounded))
                    .foregroundStyle(.white)
            }
            
            let stats = armyManager.getArmyStats()
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3), spacing: 12) {
                EnhancedArmyStatCard(
                    title: "Active Bots",
                    value: "\(stats.activeBots)",
                    icon: "robot",
                    color: .green,
                    subtitle: "Online Now"
                )
                
                EnhancedArmyStatCard(
                    title: "Win Rate",
                    value: String(format: "%.1f%%", stats.overallWinRate),
                    icon: "target",
                    color: .blue,
                    subtitle: "Overall"
                )
                
                EnhancedArmyStatCard(
                    title: "Total P&L",
                    value: formatCurrency(stats.totalProfitLoss),
                    icon: "dollarsign.circle",
                    color: stats.totalProfitLoss >= 0 ? .green : .red,
                    subtitle: "All Time"
                )
            }
        }
    }
    
    // MARK: - VPS Status Section
    private var vpsStatusSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("🖥️")
                    .font(.title2)
                
                Text("VPS STATUS")
                    .font(.system(size: 18, weight: .black, design: .rounded))
                    .foregroundStyle(.white)
                
                Spacer()
                
                Button("View Details") {
                    showingVPSStatus = true
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.small)
            }
            
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 8) {
                        Circle()
                            .fill(armyManager.isConnectedToVPS ? .green : .red)
                            .frame(width: 12, height: 12)
                        
                        Text(armyManager.vpsManager.connectionStatus.rawValue)
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                            .foregroundStyle(.white)
                    }
                    
                    Text("IP: 172.234.201.231")
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundStyle(.white.opacity(0.7))
                    
                    if armyManager.vpsManager.lastPing > 0 {
                        Text("Ping: \(String(format: "%.0f", armyManager.vpsManager.lastPing))ms")
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                            .foregroundStyle(.white.opacity(0.7))
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("\(armyManager.getArmyStats().connectedToVPS)")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundStyle(.green)
                    
                    Text("Bots Deployed")
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundStyle(.white.opacity(0.7))
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.white.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(.white.opacity(0.1), lineWidth: 1)
                    )
            )
        }
    }
    
    // MARK: - Enhanced Training Section
    private var enhancedTrainingSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                HStack(spacing: 8) {
                    Text("🎯")
                        .font(.title2)
                    
                    Text("AI TRAINING CENTER")
                        .font(.system(size: 18, weight: .black, design: .rounded))
                        .foregroundStyle(.white)
                }
                
                Spacer()
                
                Button("Import Data") {
                    showingImporter = true
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.regular)
                .tint(.blue)
            }
            
            VStack(spacing: 16) {
                // Enhanced Training Progress
                if armyManager.isTraining {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("🧠 Advanced AI Training in Progress...")
                                .font(.system(size: 14, weight: .medium, design: .rounded))
                                .foregroundStyle(.white)
                            
                            Spacer()
                            
                            Text("\(Int(armyManager.trainingProgress * 100))%")
                                .font(.system(size: 14, weight: .bold, design: .rounded))
                                .foregroundStyle(.orange)
                        }
                        
                        ProgressView(value: armyManager.trainingProgress)
                            .tint(.orange)
                            .background(.white.opacity(0.2))
                            .clipShape(Capsule())
                        
                        Text("Training 5,000 bots with machine learning algorithms...")
                            .font(.system(size: 12, weight: .regular, design: .rounded))
                            .foregroundStyle(.white.opacity(0.7))
                    }
                }
                
                // Enhanced Last Training Results
                if let results = armyManager.lastTrainingResults {
                    Button(action: { showingTrainingResults = true }) {
                        HStack(spacing: 16) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.title2)
                                .foregroundStyle(.green)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Last Training Session")
                                    .font(.system(size: 14, weight: .medium, design: .rounded))
                                    .foregroundStyle(.white)
                                
                                HStack(spacing: 8) {
                                    Text("Trained: \(results.botsTrained)")
                                    Text("•")
                                    Text("GODMODE: +\(results.newGodmodeBots)")
                                    Text("•")
                                    Text("A+: \(results.screenshotsCaptured)")
                                }
                                .font(.system(size: 12, weight: .regular, design: .rounded))
                                .foregroundStyle(.white.opacity(0.7))
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundStyle(.white.opacity(0.5))
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.white.opacity(0.08))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(.white.opacity(0.1), lineWidth: 1)
                                )
                        )
                    }
                }
                
                // Enhanced Quick Actions
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                    EnhancedQuickActionButton(
                        icon: "chart.bar.fill",
                        title: "Historical Data",
                        subtitle: "Import year's worth",
                        action: { showingImporter = true }
                    )
                    
                    EnhancedQuickActionButton(
                        icon: "cloud.fill",
                        title: "VPS Sync",
                        subtitle: "Sync with server",
                        action: { 
                            Task {
                                await armyManager.vpsManager.connectToVPS()
                            }
                        }
                    )
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.white.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.white.opacity(0.1), lineWidth: 1)
                    )
            )
        }
    }
    
    // MARK: - Enhanced Performance Charts Section
    private var enhancedPerformanceChartsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                HStack(spacing: 8) {
                    Text("📊")
                        .font(.title2)
                    
                    Text("PERFORMANCE ANALYTICS")
                        .font(.system(size: 18, weight: .black, design: .rounded))
                        .foregroundStyle(.white)
                }
                
                Spacer()
                
                Picker("Timeframe", selection: $selectedTimeframe) {
                    ForEach(timeframes, id: \.self) { timeframe in
                        Text(timeframe).tag(timeframe)
                    }
                }
                .pickerStyle(.segmented)
                .frame(width: 200)
            }
            
            // Enhanced Confidence Distribution Chart
            VStack(alignment: .leading, spacing: 12) {
                Text("AI Confidence Distribution")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundStyle(.white)
                
                EnhancedConfidenceChartView(bots: armyManager.bots)
                    .frame(height: 220)
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.white.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.white.opacity(0.1), lineWidth: 1)
                    )
            )
        }
    }
    
    // MARK: - Enhanced Top Performers Section
    private var enhancedTopPerformersSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 8) {
                Text("🏆")
                    .font(.title2)
                
                Text("TOP PERFORMERS")
                    .font(.system(size: 18, weight: .black, design: .rounded))
                    .foregroundStyle(.white)
            }
            
            LazyVStack(spacing: 12) {
                ForEach(Array(armyManager.getTopPerformers(count: 10).enumerated()), id: \.offset) { index, bot in
                    EnhancedTopPerformerRow(
                        rank: index + 1,
                        bot: bot,
                        onTap: {
                            selectedBot = bot
                            showingBotDetails = true
                        }
                    )
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.white.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.white.opacity(0.1), lineWidth: 1)
                    )
            )
        }
    }
    
    // MARK: - A+ Screenshots Section
    private var aPlusScreenshotsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                HStack(spacing: 8) {
                    Text("📸")
                        .font(.title2)
                    
                    Text("A+ SCREENSHOTS")
                        .font(.system(size: 18, weight: .black, design: .rounded))
                        .foregroundStyle(.white)
                }
                
                Spacer()
                
                Button("View Gallery") {
                    showingScreenshotGallery = true
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.small)
            }
            
            VStack(spacing: 12) {
                HStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(armyManager.getArmyStats().totalScreenshots)")
                            .font(.system(size: 24, weight: .black, design: .rounded))
                            .foregroundStyle(.orange)
                        
                        Text("Total Screenshots")
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                            .foregroundStyle(.white.opacity(0.7))
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        HStack(spacing: 4) {
                            Text("A+")
                                .font(.system(size: 16, weight: .black, design: .rounded))
                                .foregroundStyle(.orange)
                            
                            Text("Grade")
                                .font(.system(size: 12, weight: .medium, design: .rounded))
                                .foregroundStyle(.white.opacity(0.7))
                        }
                        
                        Text("AI Analyzed")
                            .font(.system(size: 10, weight: .regular, design: .rounded))
                            .foregroundStyle(.white.opacity(0.5))
                    }
                }
                
                Text("Screenshots automatically captured and analyzed by AI for A+ trading opportunities")
                    .font(.system(size: 12, weight: .regular, design: .rounded))
                    .foregroundStyle(.white.opacity(0.7))
                    .multilineTextAlignment(.leading)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.white.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(.white.opacity(0.1), lineWidth: 1)
                    )
            )
        }
    }
    
    // MARK: - Enhanced Training Overlay
    private var enhancedTrainingOverlay: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()
            
            VStack(spacing: 28) {
                // Enhanced animated brain icon
                ZStack {
                    // Outer glow
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [.orange.opacity(0.4), .orange.opacity(0.2), .clear],
                                center: .center,
                                startRadius: 30,
                                endRadius: 100
                            )
                        )
                        .frame(width: 160, height: 160)
                        .scaleEffect(animateElements ? 1.2 : 0.8)
                        .animation(.easeInOut(duration: 3).repeatForever(autoreverses: true), value: animateElements)
                    
                    // Main icon
                    Image(systemName: "brain.head.profile")
                        .font(.system(size: 52, weight: .bold))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.orange, .red, .purple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .scaleEffect(animateElements ? 1.15 : 0.9)
                        .animation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true), value: animateElements)
                }
                
                VStack(spacing: 16) {
                    Text("🚀 TRAINING 5,000 AI BOTS")
                        .font(.system(size: 26, weight: .black, design: .rounded))
                        .foregroundStyle(.white)
                    
                    Text("Advanced machine learning algorithms processing your historical data...")
                        .font(.system(size: 15, weight: .medium, design: .rounded))
                        .foregroundStyle(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }
                
                VStack(spacing: 16) {
                    ProgressView(value: armyManager.trainingProgress)
                        .frame(width: 280)
                        .tint(.orange)
                        .background(.white.opacity(0.2))
                        .clipShape(Capsule())
                    
                    HStack(spacing: 20) {
                        VStack(spacing: 4) {
                            Text("\(Int(armyManager.trainingProgress * 100))%")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundStyle(.orange)
                            
                            Text("Complete")
                                .font(.system(size: 12, weight: .medium, design: .rounded))
                                .foregroundStyle(.white.opacity(0.7))
                        }
                        
                        VStack(spacing: 4) {
                            Text("\(armyManager.lastTrainingResults?.botsTrained ?? 0)")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundStyle(.green)
                            
                            Text("Bots Trained")
                                .font(.system(size: 12, weight: .medium, design: .rounded))
                                .foregroundStyle(.white.opacity(0.7))
                        }
                        
                        VStack(spacing: 4) {
                            Text("\(armyManager.lastTrainingResults?.newGodmodeBots ?? 0)")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundStyle(.purple)
                            
                            Text("GODMODE")
                                .font(.system(size: 12, weight: .medium, design: .rounded))
                                .foregroundStyle(.white.opacity(0.7))
                        }
                    }
                }
            }
            .padding(44)
            .background(
                RoundedRectangle(cornerRadius: 28)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 28)
                            .stroke(
                                LinearGradient(
                                    colors: [.orange.opacity(0.6), .purple.opacity(0.4)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 2
                            )
                    )
            )
            .padding(.horizontal, 32)
        }
    }
    
    // MARK: - Helper Functions
    private func confidenceColor(_ confidence: Double) -> Color {
        switch confidence {
        case 0.95...: return .orange
        case 0.9..<0.95: return .red
        case 0.8..<0.9: return .purple
        case 0.7..<0.8: return .blue
        case 0.6..<0.7: return .green
        default: return .gray
        }
    }
    
    private func formatNumber(_ number: Double) -> String {
        if number >= 1_000_000 {
            return String(format: "%.1fM", number / 1_000_000)
        } else if number >= 1_000 {
            return String(format: "%.1fK", number / 1_000)
        } else {
            return String(format: "%.0f", number)
        }
    }
    
    private func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: amount)) ?? "$0"
    }
}

// MARK: - Enhanced Supporting Views

struct EnhancedProTraderMetricCard: View {
    let icon: String
    let title: String
    let value: String
    let subtitle: String
    let color: Color
    let trend: TrendDirection
    
    enum TrendDirection {
        case up, down, stable
        
        var icon: String {
            switch self {
            case .up: return "arrow.up.right"
            case .down: return "arrow.down.right"
            case .stable: return "minus"
            }
        }
        
        var color: Color {
            switch self {
            case .up: return .green
            case .down: return .red
            case .stable: return .orange
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(color)
                
                Spacer()
                
                Image(systemName: trend.icon)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(trend.color)
            }
            
            Text(value)
                .font(.system(size: 20, weight: .black, design: .rounded))
                .foregroundStyle(.white)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundStyle(.white)
                
                Text(subtitle)
                    .font(.system(size: 10, weight: .regular, design: .rounded))
                    .foregroundStyle(.white.opacity(0.6))
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.white.opacity(0.08))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.white.opacity(0.1), lineWidth: 1)
                )
        )
    }
}

struct EnhancedArmyStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    let subtitle: String
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(color)
            
            Text(value)
                .font(.system(size: 14, weight: .black, design: .rounded))
                .foregroundStyle(.white)
            
            VStack(spacing: 2) {
                Text(title)
                    .font(.system(size: 10, weight: .medium, design: .rounded))
                    .foregroundStyle(.white.opacity(0.8))
                
                Text(subtitle)
                    .font(.system(size: 8, weight: .regular, design: .rounded))
                    .foregroundStyle(.white.opacity(0.5))
            }
            .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.white.opacity(0.08))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.white.opacity(0.1), lineWidth: 1)
                )
        )
    }
}

struct EnhancedQuickActionButton: View {
    let icon: String
    let title: String
    let subtitle: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.blue)
                    .frame(width: 28)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundStyle(.white)
                    
                    Text(subtitle)
                        .font(.system(size: 10, weight: .regular, design: .rounded))
                        .foregroundStyle(.white.opacity(0.6))
                }
                
                Spacer()
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(.white.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.white.opacity(0.1), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(.plain)
    }
}

struct EnhancedTopPerformerRow: View {
    let rank: Int
    let bot: EnhancedProTraderBot
    let onTap: () -> Void
    
    var rankColor: Color {
        switch rank {
        case 1: return .orange
        case 2: return .gray
        case 3: return Color(red: 0.8, green: 0.5, blue: 0.2)
        default: return .blue
        }
    }
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Enhanced Rank with medal
                ZStack {
                    Circle()
                        .fill(rankColor.opacity(0.2))
                        .frame(width: 36, height: 36)
                    
                    if rank <= 3 {
                        Image(systemName: "crown.fill")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(rankColor)
                    } else {
                        Text("\(rank)")
                            .font(.system(size: 12, weight: .bold, design: .rounded))
                            .foregroundStyle(rankColor)
                    }
                }
                
                // Enhanced Bot info
                VStack(alignment: .leading, spacing: 4) {
                    Text(bot.name)
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .foregroundStyle(.white)
                    
                    HStack(spacing: 8) {
                        Text(bot.strategy.rawValue)
                            .font(.system(size: 10, weight: .regular, design: .rounded))
                            .foregroundStyle(.white.opacity(0.6))
                        
                        Text("•")
                            .foregroundStyle(.white.opacity(0.3))
                        
                        Text(bot.aiEngine.rawValue)
                            .font(.system(size: 10, weight: .medium, design: .rounded))
                            .foregroundStyle(.blue.opacity(0.8))
                    }
                }
                
                Spacer()
                
                // Enhanced Performance indicators
                VStack(alignment: .trailing, spacing: 4) {
                    HStack(spacing: 6) {
                        Text(bot.performanceGrade)
                            .font(.system(size: 12, weight: .bold, design: .rounded))
                            .foregroundStyle(bot.performanceGrade == "A+" ? .orange : .white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(
                                Capsule()
                                    .fill(bot.performanceGrade == "A+" ? .orange.opacity(0.2) : .white.opacity(0.1))
                            )
                        
                        Circle()
                            .fill(confidenceColor(bot.confidence))
                            .frame(width: 8, height: 8)
                    }
                    
                    Text(String(format: "%.1f%%", bot.confidence * 100))
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                        .foregroundStyle(.white.opacity(0.8))
                }
            }
            .padding(.vertical, 8)
        }
        .buttonStyle(.plain)
    }
    
    private func confidenceColor(_ confidence: Double) -> Color {
        switch confidence {
        case 0.95...: return .orange
        case 0.9..<0.95: return .red
        case 0.8..<0.9: return .purple
        case 0.7..<0.8: return .blue
        case 0.6..<0.7: return .green
        default: return .gray
        }
    }
}

struct EnhancedConfidenceChartView: View {
    let bots: [EnhancedProTraderBot]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Enhanced Chart placeholder - would implement actual chart with Charts framework
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.white.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(.white.opacity(0.1), lineWidth: 1)
                    )
                
                VStack(spacing: 12) {
                    Image(systemName: "chart.bar.fill")
                        .font(.system(size: 32))
                        .foregroundStyle(.blue.opacity(0.6))
                    
                    Text("Advanced Confidence Distribution")
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundStyle(.white.opacity(0.6))
                        .multilineTextAlignment(.center)
                    
                    // Simple confidence breakdown
                    HStack(spacing: 16) {
                        let stats = calculateConfidenceStats()
                        
                        VStack(spacing: 2) {
                            Text("\(stats.godmode)")
                                .font(.system(size: 14, weight: .bold, design: .rounded))
                                .foregroundStyle(.orange)
                            Text("GODMODE")
                                .font(.system(size: 8, weight: .medium, design: .rounded))
                                .foregroundStyle(.white.opacity(0.6))
                        }
                        
                        VStack(spacing: 2) {
                            Text("\(stats.elite)")
                                .font(.system(size: 14, weight: .bold, design: .rounded))
                                .foregroundStyle(.purple)
                            Text("ELITE")
                                .font(.system(size: 8, weight: .medium, design: .rounded))
                                .foregroundStyle(.white.opacity(0.6))
                        }
                        
                        VStack(spacing: 2) {
                            Text("\(stats.learning)")
                                .font(.system(size: 14, weight: .bold, design: .rounded))
                                .foregroundStyle(.blue)
                            Text("LEARNING")
                                .font(.system(size: 8, weight: .medium, design: .rounded))
                                .foregroundStyle(.white.opacity(0.6))
                        }
                    }
                }
            }
        }
    }
    
    private func calculateConfidenceStats() -> (godmode: Int, elite: Int, learning: Int) {
        let godmode = bots.filter { $0.confidence >= 0.95 }.count
        let elite = bots.filter { $0.confidence >= 0.8 && $0.confidence < 0.95 }.count
        let learning = bots.filter { $0.confidence < 0.8 }.count
        
        return (godmode, elite, learning)
    }
}

// MARK: - Placeholder Views (these would be implemented separately)

struct AdvancedCSVImporterView: View {
    let armyManager: EnhancedProTraderArmyManager
    
    var body: some View {
        Text("Advanced CSV Importer")
            .font(.title)
            .padding()
    }
}

struct CSVImporterView: View {
    let armyManager: EnhancedProTraderArmyManager
    
    var body: some View {
        Text("CSV Importer")
            .font(.title)
            .padding()
    }
}

struct EnhancedTrainingResultsView: View {
    let results: EnhancedTrainingResults
    
    var body: some View {
        Text("Enhanced Training Results")
            .font(.title)
            .padding()
    }
}

struct EnhancedBotDetailView: View {
    let bot: EnhancedProTraderBot
    
    var body: some View {
        Text("Enhanced Bot Detail")
            .font(.title)
            .padding()
    }
}

struct VPSStatusView: View {
    let vpsManager: VPSManager
    
    var body: some View {
        Text("VPS Status")
            .font(.title)
            .padding()
    }
}

struct ScreenshotGalleryView: View {
    var body: some View {
        Text("Screenshot Gallery")
            .font(.title)
            .padding()
    }
}

struct ProTraderGPTChatView: View {
    var body: some View {
        Text("GPT Chat View")
            .font(.title)
            .padding()
    }
}

#Preview {
    ProTraderDashboardView()
        .preferredColorScheme(.dark)
}