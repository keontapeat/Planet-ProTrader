//
//  ReplayEngineView.swift
//  GOLDEX AI - World's Most Advanced Backtesting Engine
//
//  Created by AI Assistant on 7/18/25.
//

import SwiftUI
import Charts

struct ReplayEngineView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var backtestEngine = WorldClassBacktestEngine()
    @StateObject private var markDouglasEngine = PlanetMarkDouglasEngine()
    
    // MARK: - State Management
    @State private var selectedTab = 0
    @State private var isReplaying = false
    @State private var replaySpeed: Double = 1.0
    @State private var selectedTimeframe = TimeFrame.h1
    @State private var selectedPair = "XAUUSD"
    @State private var selectedDate = Date()
    @State private var showingSettings = false
    @State private var animateOnAppear = false
    
    // MARK: - Streak System
    @State private var backtestStreak = UserDefaults.standard.integer(forKey: "backtestStreak")
    @State private var lastBacktestDate = UserDefaults.standard.object(forKey: "lastBacktestDate") as? Date
    @State private var totalBacktestHours = UserDefaults.standard.double(forKey: "totalBacktestHours")
    @State private var bestStreak = UserDefaults.standard.integer(forKey: "bestBacktestStreak")
    
    enum TimeFrame: String, CaseIterable {
        case m1 = "M1"
        case m5 = "M5"
        case m15 = "M15"
        case m30 = "M30"
        case h1 = "H1"
        case h4 = "H4"
        case d1 = "D1"
        
        var minutes: Int {
            switch self {
            case .m1: return 1
            case .m5: return 5
            case .m15: return 15
            case .m30: return 30
            case .h1: return 60
            case .h4: return 240
            case .d1: return 1440
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Premium cosmic background
                BacktestingGradientBackground()
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 0) {
                        // LEGENDARY Header
                        legendaryHeader
                        
                        // Streak Counter System
                        streakCounterSection
                        
                        // Tab Navigation
                        premiumTabNavigation
                        
                        // Content Sections
                        TabView(selection: $selectedTab) {
                            // Live Chart Replay
                            liveChartReplayTab
                                .tag(0)
                            
                            // Strategy Tester
                            strategyTesterTab
                                .tag(1)
                            
                            // Performance Analytics
                            performanceAnalyticsTab
                                .tag(2)
                            
                            // Mark Douglas Psychology
                            psychologyAnalysisTab
                                .tag(3)
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                        .frame(height: 600)
                        
                        Spacer(minLength: 100)
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingSettings) {
                BacktestSettingsView(engine: backtestEngine)
            }
            .onAppear {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1)) {
                    animateOnAppear = true
                }
                updateStreakSystem()
            }
            .onDisappear {
                saveStreakData()
            }
        }
    }
    
    // MARK: - Legendary Header
    
    private var legendaryHeader: some View {
        VStack(spacing: 16) {
            HStack {
                Button("Back") {
                    dismiss()
                }
                .foregroundColor(DesignSystem.primaryGold)
                
                Spacer()
                
                VStack(spacing: 4) {
                    Text("GOLDEX REPLAY PRO™")
                        .font(.system(size: 24, weight: .black, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [DesignSystem.primaryGold, .white, DesignSystem.primaryGold],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                    
                    Text("WORLD'S MOST ADVANCED BACKTESTING")
                        .font(.system(size: 10, weight: .bold, design: .rounded))
                        .foregroundColor(.white.opacity(0.8))
                        .tracking(2)
                }
                
                Spacer()
                
                Button(action: { showingSettings = true }) {
                    Image(systemName: "gearshape.fill")
                        .font(.title2)
                        .foregroundColor(DesignSystem.primaryGold)
                }
            }
            
            // Live Status Indicators
            HStack(spacing: 20) {
                StatusIndicator(
                    title: "ENGINE",
                    status: backtestEngine.isActive ? "ACTIVE" : "STANDBY",
                    color: backtestEngine.isActive ? .green : .orange
                )
                
                StatusIndicator(
                    title: "DATA",
                    status: "LIVE",
                    color: .blue
                )
                
                StatusIndicator(
                    title: "PSYCHOLOGY",
                    status: markDouglasEngine.currentEmotionalState.rawValue,
                    color: markDouglasEngine.currentEmotionalState.color
                )
                
                StatusIndicator(
                    title: "MODE",
                    status: isReplaying ? "REPLAYING" : "READY",
                    color: isReplaying ? .green : .gray
                )
            }
        }
        .padding()
        .scaleEffect(animateOnAppear ? 1.0 : 0.8)
        .opacity(animateOnAppear ? 1.0 : 0.0)
    }
    
    // MARK: - Streak Counter System
    
    private var streakCounterSection: some View {
        VStack(spacing: 16) {
            Text("🔥 BACKTESTING MASTERY STREAK")
                .font(.system(size: 16, weight: .black, design: .rounded))
                .foregroundColor(DesignSystem.primaryGold)
                .tracking(1)
            
            HStack(spacing: 20) {
                StreakCard(
                    title: "Current Streak",
                    value: "\(backtestStreak)",
                    subtitle: "Days",
                    color: .orange,
                    icon: "flame.fill"
                )
                
                StreakCard(
                    title: "Best Streak",
                    value: "\(bestStreak)",
                    subtitle: "Days",
                    color: .purple,
                    icon: "crown.fill"
                )
                
                StreakCard(
                    title: "Total Hours",
                    value: String(format: "%.1f", totalBacktestHours),
                    subtitle: "Hours",
                    color: .blue,
                    icon: "clock.fill"
                )
                
                StreakCard(
                    title: "Mark Douglas",
                    value: "\(Int(markDouglasEngine.probabilisticThinking * 100))%",
                    subtitle: "Mindset",
                    color: .green,
                    icon: "brain.head.profile"
                )
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(DesignSystem.primaryGold.opacity(0.3), lineWidth: 2)
                )
        )
        .padding(.horizontal)
        .scaleEffect(animateOnAppear ? 1.0 : 0.9)
        .opacity(animateOnAppear ? 1.0 : 0.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2), value: animateOnAppear)
    }
    
    // MARK: - Premium Tab Navigation
    
    private var premiumTabNavigation: some View {
        HStack(spacing: 0) {
            ForEach(0..<4, id: \.self) { index in
                let titles = ["Live Replay", "Strategy Test", "Analytics", "Psychology"]
                let icons = ["play.circle.fill", "target", "chart.bar.fill", "brain.head.profile"]
                
                Button(action: {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                        selectedTab = index
                    }
                }) {
                    VStack(spacing: 8) {
                        Image(systemName: icons[index])
                            .font(.system(size: 20, weight: .medium))
                        
                        Text(titles[index])
                            .font(.system(size: 12, weight: .semibold))
                    }
                    .foregroundStyle(selectedTab == index ? DesignSystem.primaryGold : .white.opacity(0.6))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(selectedTab == index ? DesignSystem.primaryGold.opacity(0.2) : .clear)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(selectedTab == index ? DesignSystem.primaryGold : .clear, lineWidth: 2)
                            )
                    )
                    .scaleEffect(selectedTab == index ? 1.05 : 1.0)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(6)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
        )
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
    
    // MARK: - Live Chart Replay Tab
    
    private var liveChartReplayTab: some View {
        VStack(spacing: 20) {
            // Chart Controls
            chartControlsSection
            
            // Live Chart Display
            liveChartDisplay
            
            // Replay Controls
            replayControlsSection
        }
        .padding()
    }
    
    private var chartControlsSection: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Trading Pair")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.white.opacity(0.8))
                    
                    Picker("Pair", selection: $selectedPair) {
                        Text("XAUUSD").tag("XAUUSD")
                        Text("EURUSD").tag("EURUSD")
                        Text("GBPUSD").tag("GBPUSD")
                        Text("USDJPY").tag("USDJPY")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .colorScheme(.dark)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 8) {
                    Text("Timeframe")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.white.opacity(0.8))
                    
                    Picker("Timeframe", selection: $selectedTimeframe) {
                        ForEach(TimeFrame.allCases, id: \.self) { tf in
                            Text(tf.rawValue).tag(tf)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .colorScheme(.dark)
                }
            }
            
            DatePicker("Replay Date", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(.compact)
                .colorScheme(.dark)
                .accentColor(DesignSystem.primaryGold)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.white.opacity(0.2), lineWidth: 1)
                )
        )
    }
    
    private var liveChartDisplay: some View {
        VStack(spacing: 12) {
            HStack {
                Text("\(selectedPair) - \(selectedTimeframe.rawValue)")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                HStack(spacing: 12) {
                    Text("2674.50")
                        .font(.system(size: 16, weight: .bold, design: .monospaced))
                        .foregroundColor(.green)
                    
                    Text("+12.75 (+0.47%)")
                        .font(.system(size: 12, weight: .medium, design: .monospaced))
                        .foregroundColor(.green)
                }
            }
            
            // Chart visualization (simplified for now)
            ZStack {
                Rectangle()
                    .fill(.black.opacity(0.8))
                    .frame(height: 300)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                
                // Candlestick chart simulation
                HStack(spacing: 2) {
                    ForEach(0..<50, id: \.self) { index in
                        let isGreen = Bool.random()
                        let height = CGFloat.random(in: 20...80)
                        
                        RoundedRectangle(cornerRadius: 1)
                            .fill(isGreen ? .green : .red)
                            .frame(width: 6, height: height)
                            .opacity(0.8)
                    }
                }
                .padding()
                
                VStack {
                    Spacer()
                    
                    if isReplaying {
                        HStack {
                            Text("⚡ REPLAYING")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(DesignSystem.primaryGold)
                            
                            Spacer()
                            
                            Text("Speed: \(String(format: "%.1f", replaySpeed))x")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(.black.opacity(0.7))
                        )
                    }
                }
                .padding()
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
        )
    }
    
    private var replayControlsSection: some View {
        VStack(spacing: 16) {
            // Speed Control
            HStack {
                Text("Replay Speed")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Slider(value: $replaySpeed, in: 0.1...10.0, step: 0.1) {
                    Text("Speed")
                } minimumValueLabel: {
                    Text("0.1x")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.6))
                } maximumValueLabel: {
                    Text("10x")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.6))
                }
                .accentColor(DesignSystem.primaryGold)
                .frame(maxWidth: 200)
            }
            
            // Control Buttons
            HStack(spacing: 16) {
                Button(action: startReplay) {
                    HStack(spacing: 8) {
                        Image(systemName: isReplaying ? "pause.fill" : "play.fill")
                            .font(.system(size: 16, weight: .semibold))
                        
                        Text(isReplaying ? "PAUSE" : "START REPLAY")
                            .font(.system(size: 14, weight: .bold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(isReplaying ? .orange : .green)
                    )
                }
                
                Button(action: stopReplay) {
                    HStack(spacing: 8) {
                        Image(systemName: "stop.fill")
                            .font(.system(size: 16, weight: .semibold))
                        
                        Text("STOP")
                            .font(.system(size: 14, weight: .bold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.red)
                    )
                }
                .disabled(!isReplaying)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
        )
    }
    
    // MARK: - Strategy Tester Tab
    
    private var strategyTesterTab: some View {
        VStack(spacing: 20) {
            Text("🎯 STRATEGY TESTER")
                .font(.system(size: 20, weight: .black))
                .foregroundColor(DesignSystem.primaryGold)
            
            StrategyTestingInterface(engine: backtestEngine)
        }
        .padding()
    }
    
    // MARK: - Performance Analytics Tab
    
    private var performanceAnalyticsTab: some View {
        VStack(spacing: 20) {
            Text("📊 PERFORMANCE ANALYTICS")
                .font(.system(size: 20, weight: .black))
                .foregroundColor(DesignSystem.primaryGold)
            
            PerformanceAnalyticsView(engine: backtestEngine)
        }
        .padding()
    }
    
    // MARK: - Psychology Analysis Tab
    
    private var psychologyAnalysisTab: some View {
        VStack(spacing: 20) {
            Text("🧠 MARK DOUGLAS PSYCHOLOGY")
                .font(.system(size: 20, weight: .black))
                .foregroundColor(DesignSystem.primaryGold)
            
            PsychologyAnalysisView(markDouglasEngine: markDouglasEngine)
        }
        .padding()
    }
    
    // MARK: - Helper Methods
    
    private func updateStreakSystem() {
        let today = Calendar.current.startOfDay(for: Date())
        
        if let lastDate = lastBacktestDate {
            let lastBacktestDay = Calendar.current.startOfDay(for: lastDate)
            let daysDifference = Calendar.current.dateComponents([.day], from: lastBacktestDay, to: today).day ?? 0
            
            if daysDifference == 1 {
                // Consecutive day - maintain streak
                return
            } else if daysDifference > 1 {
                // Streak broken
                backtestStreak = 0
            }
        }
    }
    
    private func incrementStreak() {
        let today = Calendar.current.startOfDay(for: Date())
        
        if let lastDate = lastBacktestDate {
            let lastBacktestDay = Calendar.current.startOfDay(for: lastDate)
            if !Calendar.current.isDate(lastDate, inSameDayAs: Date()) {
                backtestStreak += 1
                lastBacktestDate = Date()
                
                if backtestStreak > bestStreak {
                    bestStreak = backtestStreak
                }
            }
        } else {
            backtestStreak = 1
            lastBacktestDate = Date()
            bestStreak = max(bestStreak, backtestStreak)
        }
        
        saveStreakData()
    }
    
    private func saveStreakData() {
        UserDefaults.standard.set(backtestStreak, forKey: "backtestStreak")
        UserDefaults.standard.set(lastBacktestDate, forKey: "lastBacktestDate")
        UserDefaults.standard.set(totalBacktestHours, forKey: "totalBacktestHours")
        UserDefaults.standard.set(bestStreak, forKey: "bestBacktestStreak")
    }
    
    private func startReplay() {
        isReplaying.toggle()
        if isReplaying {
            backtestEngine.startBacktest()
            incrementStreak()
            totalBacktestHours += 0.1 // Add time for session
        }
    }
    
    private func stopReplay() {
        isReplaying = false
        backtestEngine.stopBacktest()
    }
}

// MARK: - World Class Backtest Engine

@MainActor
class WorldClassBacktestEngine: ObservableObject {
    @Published var isActive = false
    @Published var currentBacktest: BacktestSession?
    @Published var results: [BacktestResult] = []
    @Published var progress: Double = 0.0
    
    func startBacktest() {
        isActive = true
        currentBacktest = BacktestSession(
            id: UUID().uuidString,
            startTime: Date(),
            pair: "XAUUSD",
            timeframe: "H1",
            strategy: "Mark Douglas Probabilistic"
        )
    }
    
    func stopBacktest() {
        isActive = false
        currentBacktest = nil
        progress = 0.0
    }
    
    struct BacktestSession {
        let id: String
        let startTime: Date
        let pair: String
        let timeframe: String
        let strategy: String
    }
    
    struct BacktestResult {
        let id: String
        let winRate: Double
        let profitFactor: Double
        let maxDrawdown: Double
        let totalReturn: Double
    }
}

// MARK: - Supporting Views

struct BacktestingGradientBackground: View {
    var body: some View {
        LinearGradient(
            stops: [
                .init(color: .black, location: 0.0),
                .init(color: .purple.opacity(0.3), location: 0.3),
                .init(color: .blue.opacity(0.2), location: 0.6),
                .init(color: .black, location: 1.0)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

struct StreakCard: View {
    let title: String
    let value: String
    let subtitle: String
    let color: Color
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(color)
            
            Text(value)
                .font(.system(size: 18, weight: .black, design: .monospaced))
                .foregroundColor(.white)
            
            VStack(spacing: 2) {
                Text(title)
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(.white.opacity(0.8))
                
                Text(subtitle)
                    .font(.system(size: 8, weight: .medium))
                    .foregroundColor(.white.opacity(0.6))
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(color.opacity(0.4), lineWidth: 2)
                )
        )
    }
}

struct StatusIndicator: View {
    let title: String
    let status: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(.white.opacity(0.6))
                .tracking(1)
            
            Text(status)
                .font(.system(size: 12, weight: .black))
                .foregroundColor(color)
            
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)
                .opacity(0.8)
        }
    }
}

struct StrategyTestingInterface: View {
    let engine: WorldClassBacktestEngine
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Select your strategy to test against historical data")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
            
            Text("Coming Soon: Advanced Strategy Builder")
                .font(.caption)
                .foregroundColor(.green)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
        )
    }
}

struct PerformanceAnalyticsView: View {
    let engine: WorldClassBacktestEngine
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Comprehensive performance metrics and analytics")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
            
            Text("Coming Soon: Real-time Performance Dashboard")
                .font(.caption)
                .foregroundColor(.green)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
        )
    }
}

struct PsychologyAnalysisView: View {
    let markDouglasEngine: PlanetMarkDouglasEngine
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Real-time psychology analysis based on Mark Douglas principles")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
            
            HStack {
                Text("Current State:")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.6))
                
                Text(markDouglasEngine.currentEmotionalState.rawValue)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(markDouglasEngine.currentEmotionalState.color)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
        )
    }
}

struct BacktestSettingsView: View {
    let engine: WorldClassBacktestEngine
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Backtest Settings")
                    .font(.title)
                    .padding()
                
                Text("Advanced settings coming soon...")
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ReplayEngineView()
}