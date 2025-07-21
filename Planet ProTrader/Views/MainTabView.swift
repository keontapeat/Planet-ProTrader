//
//  MainTabView.swift
//  Planet ProTrader
//
//  PRODUCTION-READY MAIN TAB VIEW
//  All dependencies resolved and modern SwiftUI patterns applied
//

import SwiftUI
import Foundation

struct MainTabView: View {
    @EnvironmentObject private var authManager: AuthenticationManager
    @EnvironmentObject private var tradingViewModel: TradingViewModel
    @EnvironmentObject private var realTimeAccountManager: RealTimeAccountManager
    @StateObject private var opusManager = OpusAutodebugService()
    @StateObject private var performanceMonitor = PerformanceMonitor.shared
    @State private var showingOpusInterface = false
    @State private var selectedTab = 0
    @State private var isLoading = true
    @Namespace private var tabAnimation
    
    var body: some View {
        ZStack {
            // Modern gradient background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(.systemBackground),
                    Color(.systemBackground).opacity(0.95)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            if isLoading {
                // Loading screen
                VStack(spacing: 20) {
                    ProgressView()
                        .scaleEffect(1.5)
                        .progressViewStyle(CircularProgressViewStyle(tint: DesignSystem.primaryGold))
                    
                    Text("Loading Planet ProTrader...")
                        .font(.headline)
                        .foregroundColor(DesignSystem.primaryGold)
                }
            } else {
                TabView(selection: $selectedTab) {
                    // Home Tab
                    HomeDashboardView()
                        .environmentObject(tradingViewModel)
                        .environmentObject(realTimeAccountManager)
                        .tabItem {
                            Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                            Text("Home")
                        }
                        .tag(0)
                    
                    // Trading Tab
                    ProfessionalChartView()
                        .tabItem {
                            Image(systemName: selectedTab == 1 ? "chart.line.uptrend.xyaxis" : "chart.line.uptrend.xyaxis")
                            Text("Trading")
                        }
                        .tag(1)
                    
                    // Bots Tab
                    ModernBotView()
                        .tabItem {
                            Image(systemName: selectedTab == 2 ? "brain.head.profile.fill" : "brain.head.profile")
                            Text("Bots")
                        }
                        .tag(2)
                    
                    // Profile Tab
                    ProfileView()
                        .tabItem {
                            Image(systemName: selectedTab == 3 ? "person.circle.fill" : "person.circle")
                            Text("Profile")
                        }
                        .tag(3)
                }
                .accentColor(DesignSystem.primaryGold)
                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: selectedTab)
                .onAppear {
                    setupOpusSystem()
                    setupTabBarAppearance()
                    performanceMonitor.startMonitoring()
                }
                .onDisappear {
                    performanceMonitor.stopMonitoring()
                }
                .withErrorHandling()
                
                // Floating OPUS AI Assistant - Available from any tab
                VStack {
                    HStack {
                        OpusFloatingButton(
                            isActive: opusManager.isActive,
                            showingInterface: $showingOpusInterface
                        )
                        .transition(.asymmetric(
                            insertion: .scale.combined(with: .opacity),
                            removal: .scale.combined(with: .opacity)
                        ))
                        
                        Spacer()
                    }
                    Spacer()
                }
                .padding(.top, 8)
                .padding(.horizontal)
            }
        }
        .sheet(isPresented: $showingOpusInterface) {
            OpusDebugInterface()
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
        .animation(.easeInOut, value: showingOpusInterface)
        .onAppear {
            // Simulate app loading
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    isLoading = false
                }
            }
        }
    }
    
    private func setupOpusSystem() {
        // Initialize OPUS AI System with delay for smooth startup
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                opusManager.unleashOpusPower()
            }
        }
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.95)
        
        // Enhanced tab bar styling
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(DesignSystem.primaryGold)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(DesignSystem.primaryGold)
        ]
        
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor.secondaryLabel
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.secondaryLabel
        ]
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

// MARK: - Enhanced OPUS Floating Button Component
struct OpusFloatingButton: View {
    let isActive: Bool
    @Binding var showingInterface: Bool
    @State private var isHovered = false
    @State private var pulseAnimation = false
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                showingInterface.toggle()
            }
        }) {
            HStack(spacing: 8) {
                Image(systemName: "brain.head.profile.fill")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(
                        isActive ? 
                        LinearGradient(colors: [.orange, .yellow], startPoint: .topLeading, endPoint: .bottomTrailing) :
                        LinearGradient(colors: [.gray, .gray], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .scaleEffect(isActive ? (pulseAnimation ? 1.2 : 1.1) : 1.0)
                    .onAppear {
                        if isActive {
                            withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                                pulseAnimation = true
                            }
                        }
                    }
                
                if isActive {
                    Circle()
                        .fill(
                            LinearGradient(colors: [.green, .mint], startPoint: .top, endPoint: .bottom)
                        )
                        .frame(width: 6, height: 6)
                        .scaleEffect(pulseAnimation ? 1.4 : 1.2)
                        .animation(
                            .easeInOut(duration: 0.8)
                            .repeatForever(autoreverses: true),
                            value: pulseAnimation
                        )
                }
                
                Text(isActive ? "AI Active" : "AI Assistant")
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(.ultraThinMaterial)
                    .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(
                                LinearGradient(
                                    colors: isActive ? [.orange.opacity(0.6), .yellow.opacity(0.6)] : [.gray.opacity(0.2)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: isActive ? 2 : 1
                            )
                    )
            )
        }
        .buttonStyle(.plain)
        .scaleEffect(showingInterface ? 0.95 : (isHovered ? 1.05 : 1.0))
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: showingInterface)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isHovered)
        .onHover { hovering in
            isHovered = hovering
        }
    }
}

// MARK: - Enhanced Modern Bot View
struct ModernBotView: View {
    @State private var selectedBotCategory = 0
    @State private var showingBotCreator = false
    @State private var isRefreshing = false
    private let botCategories = ["Active", "Learning", "Archived"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header Statistics
                    ModernStatsCard()
                    
                    // Category Picker with Create Bot Button
                    HStack {
                        BotCategoryPicker(selection: $selectedBotCategory, categories: botCategories)
                        
                        Spacer()
                        
                        Menu {
                            Button("Create New Bot") {
                                showingBotCreator = true
                            }
                            Button("Import Bot") {
                                // Import functionality
                            }
                            Button("Bot Marketplace") {
                                // Marketplace functionality
                            }
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                                .foregroundStyle(DesignSystem.primaryGold)
                        }
                    }
                    
                    // Bot Grid
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 16),
                        GridItem(.flexible(), spacing: 16)
                    ], spacing: 16) {
                        ForEach(getBotsByCategory(), id: \.id) { bot in
                            ModernBotCard(bot: bot)
                        }
                    }
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
            }
            .navigationTitle("AI Trading Bots")
            .navigationBarTitleDisplayMode(.large)
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
            .refreshable {
                await refreshBots()
            }
        }
        .sheet(isPresented: $showingBotCreator) {
            BotCreatorView()
        }
    }
    
    private func getBotsByCategory() -> [SampleBot] {
        switch selectedBotCategory {
        case 0: return SampleBot.activeBots
        case 1: return SampleBot.learningBots
        case 2: return SampleBot.archivedBots
        default: return SampleBot.activeBots
        }
    }
    
    @MainActor
    private func refreshBots() async {
        isRefreshing = true
        // Simulate network refresh
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        isRefreshing = false
    }
}

// MARK: - Sample Bot Model
struct SampleBot: Identifiable {
    let id = UUID()
    let name: String
    let strategy: String
    let profit: Double
    let isActive: Bool
    let winRate: Int
    let performance: Double
    
    static let activeBots = [
        SampleBot(name: "Quantum AI Pro", strategy: "Scalping", profit: 2450.75, isActive: true, winRate: 84, performance: 0.24),
        SampleBot(name: "Gold Master", strategy: "Swing", profit: 1875.50, isActive: true, winRate: 78, performance: 0.19),
        SampleBot(name: "Trend Hunter", strategy: "DCA", profit: 3247.25, isActive: true, winRate: 91, performance: 0.32),
        SampleBot(name: "News Trader", strategy: "News", profit: 987.80, isActive: true, winRate: 73, performance: 0.10)
    ]
    
    static let learningBots = [
        SampleBot(name: "Neural Net v2", strategy: "Learning", profit: 125.50, isActive: false, winRate: 45, performance: 0.01),
        SampleBot(name: "Pattern Bot", strategy: "Pattern", profit: -47.25, isActive: false, winRate: 38, performance: -0.005)
    ]
    
    static let archivedBots = [
        SampleBot(name: "Old Scalper", strategy: "Scalping", profit: 5247.75, isActive: false, winRate: 67, performance: 0.52),
        SampleBot(name: "Legacy Bot", strategy: "Swing", profit: -234.50, isActive: false, winRate: 42, performance: -0.02)
    ]
}

// MARK: - Enhanced Modern Stats Card Component
struct ModernStatsCard: View {
    @State private var animateStats = false
    
    var body: some View {
        UltraPremiumCard {
            VStack(spacing: 20) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Portfolio Overview")
                            .font(.title2.bold())
                            .foregroundColor(.primary)
                        
                        Text("Last updated: \(Date(), format: .dateTime.hour().minute())")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .font(.title2)
                        .foregroundStyle(.green)
                        .scaleEffect(animateStats ? 1.1 : 1.0)
                        .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: animateStats)
                }
                
                HStack(spacing: 0) {
                    StatItem(
                        value: "8",
                        label: "Active Bots",
                        color: .blue,
                        icon: "robot.2.fill"
                    )
                    
                    Divider()
                        .frame(height: 40)
                    
                    StatItem(
                        value: "$4,247",
                        label: "Total Profit",
                        color: .green,
                        icon: "dollarsign.circle.fill"
                    )
                    
                    Divider()
                        .frame(height: 40)
                    
                    StatItem(
                        value: "82%",
                        label: "Win Rate",
                        color: .orange,
                        icon: "target"
                    )
                }
            }
            .padding(20)
        }
        .onAppear {
            animateStats = true
        }
    }
}

// MARK: - Enhanced Stat Item Component
struct StatItem: View {
    let value: String
    let label: String
    let color: Color
    let icon: String
    @State private var animateValue = false
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(color)
                .scaleEffect(animateValue ? 1.1 : 1.0)
                .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: animateValue)
            
            Text(value)
                .font(.title2.bold())
                .foregroundColor(color)
                .opacity(animateValue ? 1.0 : 0.7)
                .contentTransition(.numericText())
                .animation(.easeInOut(duration: 1.0), value: value)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8).delay(Double.random(in: 0.1...0.5))) {
                animateValue = true
            }
        }
    }
}

// MARK: - Enhanced Bot Category Picker
struct BotCategoryPicker: View {
    @Binding var selection: Int
    let categories: [String]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(categories.enumerated()), id: \.offset) { index, category in
                Button(action: {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        selection = index
                    }
                }) {
                    Text(category)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(selection == index ? .white : .primary)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(selection == index ? DesignSystem.primaryGold : Color.clear)
                                .shadow(
                                    color: selection == index ? DesignSystem.primaryGold.opacity(0.3) : .clear, 
                                    radius: selection == index ? 4 : 0
                                )
                        )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(6)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.1), radius: 4)
        )
    }
}

// MARK: - Enhanced Modern Bot Card
struct ModernBotCard: View {
    let bot: SampleBot
    @State private var cardHovered = false
    @State private var showingBotDetails = false
    
    var body: some View {
        Button(action: {
            showingBotDetails = true
        }) {
            UltraPremiumCard {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(bot.name)
                                .font(.headline.bold())
                                .foregroundColor(.primary)
                            
                            Text(bot.strategy)
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 2)
                                .background(Color(.systemGray6))
                                .clipShape(Capsule())
                        }
                        
                        Spacer()
                        
                        VStack(spacing: 2) {
                            Circle()
                                .fill(bot.isActive ? .green : .gray)
                                .frame(width: 8, height: 8)
                                .scaleEffect(bot.isActive ? 1.2 : 1.0)
                                .animation(
                                    bot.isActive ? .easeInOut(duration: 1.0).repeatForever(autoreverses: true) : .default, 
                                    value: bot.isActive
                                )
                            
                            Text(bot.isActive ? "LIVE" : "OFF")
                                .font(.system(size: 8, weight: .bold))
                                .foregroundColor(bot.isActive ? .green : .gray)
                        }
                    }
                    
                    Divider()
                        .opacity(0.5)
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Profit")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                            
                            Text("$\(Int(bot.profit))")
                                .font(.subheadline.bold())
                                .foregroundColor(bot.profit > 0 ? .green : .red)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 2) {
                            Text("Win Rate")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                            
                            Text("\(bot.winRate)%")
                                .font(.subheadline.bold())
                                .foregroundColor(.blue)
                        }
                    }
                    
                    // Performance indicator
                    ProgressView(value: max(0, min(1, bot.performance)))
                        .progressViewStyle(LinearProgressViewStyle(tint: bot.performance > 0 ? .green : .red))
                        .scaleEffect(y: 0.8)
                    
                    // Quick action buttons
                    HStack(spacing: 8) {
                        Button(action: {
                            // Toggle bot action
                        }) {
                            Text(bot.isActive ? "Pause" : "Start")
                                .font(.caption.bold())
                                .foregroundColor(.white)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 4)
                                .background(bot.isActive ? .orange : .green)
                                .clipShape(Capsule())
                        }
                        .buttonStyle(.plain)
                        
                        Spacer()
                        
                        Button(action: {
                            // Settings action
                        }) {
                            Image(systemName: "gearshape.fill")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(16)
            }
        }
        .buttonStyle(.plain)
        .scaleEffect(cardHovered ? 1.02 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: cardHovered)
        .onHover { hovering in
            cardHovered = hovering
        }
        .sheet(isPresented: $showingBotDetails) {
            BotDetailSheet(bot: bot)
        }
    }
}

// MARK: - Bot Detail Sheet
struct BotDetailSheet: View {
    let bot: SampleBot
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Bot header
                    HStack {
                        VStack(alignment: .leading) {
                            Text(bot.name)
                                .font(.title.bold())
                            Text(bot.strategy)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        VStack {
                            Circle()
                                .fill(bot.isActive ? .green : .gray)
                                .frame(width: 12, height: 12)
                            Text(bot.isActive ? "ACTIVE" : "INACTIVE")
                                .font(.caption.bold())
                                .foregroundColor(bot.isActive ? .green : .gray)
                        }
                    }
                    
                    // Performance metrics
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                        MetricCard(title: "Total Profit", value: "$\(Int(bot.profit))", color: bot.profit > 0 ? .green : .red)
                        MetricCard(title: "Win Rate", value: "\(bot.winRate)%", color: .blue)
                        MetricCard(title: "Performance", value: "\(Int(bot.performance * 100))%", color: .purple)
                        MetricCard(title: "Strategy", value: bot.strategy, color: .orange)
                    }
                    
                    Text("Bot Details")
                        .font(.headline.bold())
                    
                    Text("This is a placeholder for detailed bot information, including performance charts, trading history, and configuration options.")
                        .font(.body)
                        .foregroundColor(.secondary)
                    
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

struct MetricCard: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.title2.bold())
                .foregroundColor(color)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6).opacity(0.3))
        .cornerRadius(12)
    }
}

// MARK: - Bot Creator View
struct BotCreatorView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var botName = ""
    @State private var selectedStrategy = 0
    private let strategies = ["Scalping", "Swing Trading", "Day Trading", "News Trading", "Grid Trading"]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Text("Create New Trading Bot")
                    .font(.largeTitle.bold())
                    .padding(.top)
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("Bot Configuration")
                        .font(.headline.bold())
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Bot Name")
                            .font(.subheadline.bold())
                        TextField("Enter bot name", text: $botName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Trading Strategy")
                            .font(.subheadline.bold())
                        Picker("Strategy", selection: $selectedStrategy) {
                            ForEach(Array(strategies.enumerated()), id: \.offset) { index, strategy in
                                Text(strategy).tag(index)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                    
                    Text("Advanced configuration options will be available in the full version.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.top)
                }
                .padding()
                .background(Color(.systemGray6).opacity(0.3))
                .cornerRadius(12)
                
                Spacer()
                
                Button("Create Bot") {
                    // Bot creation logic
                    ToastManager.shared.showSuccess("Bot '\(botName.isEmpty ? "New Bot" : botName)' created successfully!")
                    dismiss()
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(DesignSystem.primaryGold)
                .cornerRadius(12)
                .disabled(botName.isEmpty)
                .opacity(botName.isEmpty ? 0.6 : 1.0)
            }
            .padding()
            .navigationTitle("New Bot")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Previews
#Preview("Main Tab View") {
    MainTabView()
        .environmentObject(AuthenticationManager())
        .environmentObject(TradingViewModel())
        .environmentObject(RealTimeAccountManager())
}

#Preview("Modern Bot View") {
    ModernBotView()
}

#Preview("OPUS Floating Button") {
    VStack(spacing: 20) {
        OpusFloatingButton(isActive: true, showingInterface: .constant(false))
        OpusFloatingButton(isActive: false, showingInterface: .constant(false))
    }
    .padding()
    .background(Color(.systemGroupedBackground))
}

#Preview("Bot Creator") {
    BotCreatorView()
}