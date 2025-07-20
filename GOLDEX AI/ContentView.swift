//
//  ContentView.swift
//  GOLDEX AI
//
//  Created by Keonta on 7/13/25.
//  Enhanced with latest SwiftUI best practices and modern design patterns
//

import SwiftUI

@MainActor
struct ContentView: View {
    // MARK: - State Management
    @StateObject private var tradingViewModel = TradingViewModel()
    @StateObject private var realTimeAccountManager = RealTimeAccountManager()
    @StateObject private var autoDebugSystem = AutoDebugSystem.shared
    @State private var selectedTab = 0
    @State private var isOnboardingComplete = true
    @State private var showSplashScreen = true
    @State private var tabBarOffset: CGFloat = 0
    @State private var lastScrollOffset: CGFloat = 0
    @State private var isTabBarVisible = true
    
    // MARK: - Computed Properties
    private var shouldShowTabBar: Bool {
        isTabBarVisible && !showSplashScreen && isOnboardingComplete
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                DesignSystem.backgroundGradient
                    .ignoresSafeArea()
                
                // Main Content
                Group {
                    if showSplashScreen {
                        EnhancedSplashScreenView()
                            .environmentObject(realTimeAccountManager)
                            .transition(.asymmetric(
                                insertion: .opacity,
                                removal: .scale.combined(with: .opacity)
                            ))
                            .onAppear {
                                startSplashSequence()
                                // Start Auto Debug System immediately
                                Task {
                                    await autoDebugSystem.startAutoDebugging()
                                    print(" Auto Debug System: Self-healing AI activated!")
                                }
                            }
                    } else if !isOnboardingComplete {
                        OnboardingView(isOnboardingComplete: $isOnboardingComplete)
                            .transition(.asymmetric(
                                insertion: .move(edge: .trailing).combined(with: .opacity),
                                removal: .move(edge: .leading).combined(with: .opacity)
                            ))
                    } else {
                        mainAppContent
                            .transition(.asymmetric(
                                insertion: .move(edge: .bottom).combined(with: .opacity),
                                removal: .scale.combined(with: .opacity)
                            ))
                    }
                }
                .animation(.spring(response: 0.8, dampingFraction: 0.8), value: showSplashScreen)
                .animation(.spring(response: 0.8, dampingFraction: 0.8), value: isOnboardingComplete)
                
                // Auto Debug Status Indicator (only visible in debug builds)
                #if DEBUG
                if autoDebugSystem.isActive {
                    VStack {
                        HStack {
                            Spacer()
                            
                            VStack(spacing: 4) {
                                HStack(spacing: 6) {
                                    Circle()
                                        .fill(.green)
                                        .frame(width: 8, height: 8)
                                        .opacity(autoDebugSystem.isActive ? 1 : 0.3)
                                    
                                    Text("AI Debug")
                                        .font(.system(size: 10, weight: .medium, design: .monospaced))
                                        .foregroundColor(.secondary)
                                }
                                
                                Text("\(autoDebugSystem.errorLogs.filter { !$0.isFixed }.count) active")
                                    .font(.system(size: 8, weight: .medium, design: .monospaced))
                                    .foregroundColor(autoDebugSystem.errorCount > 0 ? .red : .green)
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .onTapGesture {
                                // Quick debug report in console
                                Task {
                                    await debug_status()
                                }
                            }
                        }
                        .padding(.trailing, 16)
                        .padding(.top, 8)
                        
                        Spacer()
                    }
                    .allowsHitTesting(true)
                }
                #endif
            }
        }
        .withBackgroundSystems()
        .preferredColorScheme(.light)
        .tint(DesignSystem.primaryGold)
        .onAppear {
            // Ensure auto debug is always running
            if !autoDebugSystem.isActive {
                Task {
                    await autoDebugSystem.startAutoDebugging()
                    print(" Auto Debug System: Reactivated on app appear")
                }
            }
        }
        .task {
            // Background monitoring task
            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: 60_000_000_000) // 1 minute
                
                if autoDebugSystem.isActive {
                    // Silent health check every minute
                    await autoDebugSystem.performEnhancedSystemHealthCheck()
                    
                    // Auto-fix any errors found
                    let activeErrors = autoDebugSystem.errorLogs.filter { !$0.isFixed }.count
                    if activeErrors > 0 && autoDebugSystem.selfHealingEnabled {
                        await autoDebugSystem.fixErrorsNow()
                        print(" Auto Debug: Fixed \(activeErrors) errors automatically")
                    }
                }
            }
        }
    }
    
    // MARK: - Main App Content
    private var mainAppContent: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                // Home Dashboard
                NavigationStack {
                    HomeDashboardView()
                        .environmentObject(tradingViewModel)
                        .environmentObject(realTimeAccountManager)
                }
                .tabItem {
                    TabItemView(
                        icon: "house.fill",
                        title: "Home",
                        isSelected: selectedTab == 0
                    )
                }
                .tag(0)
                
                // Playbook
                NavigationStack {
                    PlaybookView()
                        .environmentObject(tradingViewModel)
                        .environmentObject(realTimeAccountManager)
                }
                .tabItem {
                    TabItemView(
                        icon: "book.pages",
                        title: "Playbook",
                        isSelected: selectedTab == 1
                    )
                }
                .tag(1)
                
                // Flip Mode
                NavigationStack {
                    FlipSetupView()
                        .environmentObject(tradingViewModel)
                        .environmentObject(realTimeAccountManager)
                }
                .tabItem {
                    TabItemView(
                        icon: "arrow.triangle.2.circlepath",
                        title: "Flip",
                        isSelected: selectedTab == 2
                    )
                }
                .tag(2)
                
                // Auto Trading
                NavigationStack {
                    AutoTradingControlView()
                        .environmentObject(tradingViewModel)
                        .environmentObject(realTimeAccountManager)
                }
                .tabItem {
                    TabItemView(
                        icon: "brain.fill",
                        title: "Auto Trade",
                        isSelected: selectedTab == 3
                    )
                }
                .tag(3)
                
                // More Menu
                NavigationStack {
                    MoreMenuView()
                        .environmentObject(tradingViewModel)
                        .environmentObject(realTimeAccountManager)
                }
                .tabItem {
                    TabItemView(
                        icon: "ellipsis",
                        title: "More",
                        isSelected: selectedTab == 4
                    )
                }
                .tag(4)
            }
            .environmentObject(tradingViewModel)
            .environmentObject(realTimeAccountManager)
            .accentColor(DesignSystem.primaryGold)
            .tabViewStyle(.automatic)
            .animation(.spring(response: 0.5, dampingFraction: 0.8), value: selectedTab)
        }
    }
    
    // MARK: - Methods
    private func startSplashSequence() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
            withAnimation(.spring(response: 1.0, dampingFraction: 0.8)) {
                showSplashScreen = false
            }
        }
    }
}

// MARK: - Enhanced Tab Item View
struct TabItemView: View {
    let icon: String
    let title: String
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: isSelected ? 24 : 20, weight: isSelected ? .semibold : .medium))
                .foregroundStyle(isSelected ? DesignSystem.primaryGold : .secondary)
                .scaleEffect(isSelected ? 1.1 : 1.0)
                .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isSelected)
            
            Text(title)
                .font(.system(size: 10, weight: isSelected ? .semibold : .medium))
                .foregroundStyle(isSelected ? DesignSystem.primaryGold : .secondary)
        }
    }
}

// MARK: - More Menu View
struct MoreMenuView: View {
    @EnvironmentObject private var tradingViewModel: TradingViewModel
    @EnvironmentObject private var realTimeAccountManager: RealTimeAccountManager
    @StateObject private var autoDebugSystem = AutoDebugSystem.shared
    @State private var showingAccountDetails = false
    @State private var showingSettings = false
    @State private var showingAutoDebug = false
    
    private var menuItems: [MenuSection] {
        [
            MenuSection(
                title: "Trading",
                items: [
                    MenuItem(icon: "chart.xyaxis.line", title: "MT5 Setup", destination: .mt5Setup),
                    MenuItem(icon: "chart.line.uptrend.xyaxis", title: "Training", destination: .training),
                    MenuItem(icon: "chart.pie.fill", title: "Portfolio", destination: .portfolio),
                    MenuItem(icon: "brain", title: "AI Insights", destination: .aiInsights)
                ]
            ),
            MenuSection(
                title: "Analysis",
                items: [
                    MenuItem(icon: "bolt.fill", title: "Signals", destination: .signals),
                    MenuItem(icon: "brain.head.profile", title: "ProTrader Army", destination: .proTrader),
                    MenuItem(icon: "chart.bar.xaxis", title: "Performance", destination: .performance)
                ]
            ),
            MenuSection(
                title: "System",
                items: [
                    MenuItem(icon: "wrench.and.screwdriver.fill", title: "Auto Debug", destination: .autoDebug),
                    MenuItem(icon: "person.crop.circle.fill", title: "Account Details", destination: .accountDetails),
                    MenuItem(icon: "gear", title: "Settings", destination: .settings),
                    MenuItem(icon: "questionmark.circle.fill", title: "Support", destination: .support)
                ]
            )
        ]
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                DesignSystem.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    LazyVStack(spacing: 24) {
                        // Account Summary Card
                        AccountSummaryCard()
                            .environmentObject(realTimeAccountManager)
                        
                        // Auto Debug Status Card
                        AutoDebugStatusCard()
                            .environmentObject(autoDebugSystem)
                        
                        // Menu Sections
                        ForEach(menuItems, id: \.title) { section in
                            MenuSectionView(section: section)
                        }
                        
                        // App Info
                        AppInfoSection()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    .padding(.bottom, 100)
                }
            }
            .navigationTitle("More")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(DesignSystem.surfacePrimary, for: .navigationBar)
        }
        .sheet(isPresented: $showingAutoDebug) {
            AutoDebugDashboardView()
        }
    }
}

// MARK: - Account Summary Card
struct AccountSummaryCard: View {
    @EnvironmentObject private var accountManager: RealTimeAccountManager
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Account Balance")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    Text("$\(String(format: "%.2f", accountManager.balance))")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundStyle(DesignSystem.primaryGold)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Status")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    HStack(spacing: 6) {
                        Circle()
                            .fill(.green)
                            .frame(width: 8, height: 8)
                        
                        Text("Live")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.green)
                    }
                }
            }
            
            Divider()
                .background(.tertiary)
            
            HStack(spacing: 32) {
                VStack(spacing: 4) {
                    Text("Today's P&L")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Text("+$142.50")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.green)
                }
                
                VStack(spacing: 4) {
                    Text("Open Trades")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Text("3")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)
                }
                
                VStack(spacing: 4) {
                    Text("Success Rate")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Text("87.5%")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.green)
                }
            }
        }
        .padding(20)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: DesignSystem.cornerRadius.lg))
        .shadow(color: DesignSystem.cardShadow, radius: 8, x: 0, y: 4)
    }
}

// MARK: - Menu Section View
struct MenuSectionView: View {
    let section: MenuSection
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(section.title)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
                .padding(.horizontal, 4)
            
            VStack(spacing: 8) {
                ForEach(section.items, id: \.title) { item in
                    MenuItemRow(item: item)
                }
            }
            .padding(16)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: DesignSystem.cornerRadius.md))
            .shadow(color: DesignSystem.cardShadow, radius: 4, x: 0, y: 2)
        }
    }
}

// MARK: - Menu Item Row
struct MenuItemRow: View {
    let item: MenuItem
    
    var body: some View {
        NavigationLink(destination: destinationView) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(DesignSystem.primaryGold.opacity(0.1))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: item.icon)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(DesignSystem.primaryGold)
                }
                
                Text(item.title)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundStyle(.primary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.tertiary)
            }
            .padding(.vertical, 8)
        }
        .buttonStyle(.plain)
    }
    
    @ViewBuilder
    private var destinationView: some View {
        switch item.destination {
        case .mt5Setup:
            ContentViewStubView(title: "MT5 Setup")
        case .training:
            ContentViewStubView(title: "Training")
        case .portfolio:
            ContentViewStubView(title: "Portfolio")
        case .aiInsights:
            ContentViewStubView(title: "AI Insights")
        case .signals:
            ContentViewStubView(title: "Signals")
        case .proTrader:
            ContentViewStubView(title: "ProTrader Army")
        case .performance:
            ContentViewStubView(title: "Performance")
        case .accountDetails:
            ContentViewStubView(title: "Account Details")
        case .settings:
            ContentViewStubView(title: "Settings")
        case .support:
            ContentViewSupportView()
        case .autoDebug:
            ContentViewStubView(title: "Auto Debug")
        }
    }
}

// MARK: - App Info Section
struct AppInfoSection: View {
    var body: some View {
        VStack(spacing: 16) {
            VStack(spacing: 8) {
                Image(systemName: "brain.head.profile")
                    .font(.system(size: 32, weight: .light))
                    .foregroundStyle(DesignSystem.primaryGold)
                
                Text("GOLDEX AI")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                
                Text("Elite Gold Trading Intelligence")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            VStack(spacing: 4) {
                Text("Version 3.0 Enhanced")
                    .font(.footnote)
                    .foregroundStyle(.tertiary)
                
                Text(" 2025 GOLDEX AI. All rights reserved.")
                    .font(.footnote)
                    .foregroundStyle(.tertiary)
            }
        }
        .padding(20)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: DesignSystem.cornerRadius.md))
    }
}

// MARK: - ContentView Support View
struct ContentViewSupportView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Image(systemName: "headphones")
                    .font(.system(size: 64, weight: .light))
                    .foregroundStyle(DesignSystem.primaryGold)
                
                VStack(spacing: 8) {
                    Text("24/7 Premium Support")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Our expert team is here to help you maximize your trading potential")
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                
                VStack(spacing: 12) {
                    Button(action: {}) {
                        Label("Live Chat", systemImage: "message.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .goldexButtonStyle()
                    
                    Button(action: {}) {
                        Label("Email Support", systemImage: "envelope.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .goldexSecondaryButtonStyle()
                }
                
                Spacer()
            }
            .padding(20)
            .background(DesignSystem.backgroundGradient)
            .navigationTitle("Support")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

// MARK: - Enhanced Splash Screen
struct EnhancedSplashScreenView: View {
    @EnvironmentObject private var accountManager: RealTimeAccountManager
    @State private var logoScale: CGFloat = 0.1
    @State private var logoRotation: Double = -180
    @State private var logoOpacity: Double = 0
    @State private var showTitle = false
    @State private var showSubtitle = false
    @State private var showLoadingAnimation = false
    @State private var backgroundGradient = false
    @State private var particleAnimation = false
    @State private var connectionStatus = "Initializing GOLDEX AI..."
    @State private var showBalance = false
    @State private var progressValue: Double = 0
    @State private var pulseAnimation = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Animated Background
                ContentViewAnimatedBackground(isAnimating: backgroundGradient)
                    .ignoresSafeArea()
                
                // Particle System
                if particleAnimation {
                    ContentViewParticleSystemView(geometry: geometry)
                }
                
                // Main Content
                VStack(spacing: 40) {
                    Spacer()
                    
                    // Logo Section
                    ZStack {
                        Circle()
                            .stroke(
                                AngularGradient(
                                    colors: [
                                        DesignSystem.primaryGold.opacity(0.8),
                                        DesignSystem.primaryGold.opacity(0.3),
                                        DesignSystem.primaryGold.opacity(0.8)
                                    ],
                                    center: .center,
                                    startAngle: .degrees(0),
                                    endAngle: .degrees(360)
                                ),
                                lineWidth: 3
                            )
                            .frame(width: 160, height: 160)
                            .rotationEffect(.degrees(logoRotation))
                            .opacity(showTitle ? 1 : 0)
                            .scaleEffect(showTitle ? 1.0 : 0.8)
                        
                        Circle()
                            .stroke(
                                RadialGradient(
                                    colors: [
                                        DesignSystem.primaryGold.opacity(0.3),
                                        DesignSystem.primaryGold.opacity(0.1),
                                        Color.clear
                                    ],
                                    center: .center,
                                    startRadius: 20,
                                    endRadius: 80
                                ),
                                lineWidth: 2
                            )
                            .frame(width: 120, height: 120)
                            .rotationEffect(.degrees(-logoRotation * 1.5))
                            .opacity(showTitle ? 0.8 : 0)
                        
                        ZStack {
                            Circle()
                                .fill(RadialGradient(
                                    colors: [
                                        DesignSystem.primaryGold.opacity(0.2),
                                        DesignSystem.primaryGold.opacity(0.05),
                                        Color.clear
                                    ],
                                    center: .center,
                                    startRadius: 10,
                                    endRadius: 50
                                ))
                                .frame(width: 100, height: 100)
                                .scaleEffect(pulseAnimation ? 1.2 : 1.0)
                                .opacity(showTitle ? 1 : 0)
                            
                            Image(systemName: "brain.head.profile")
                                .font(.system(size: 48, weight: .ultraLight))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [
                                            DesignSystem.primaryGold,
                                            DesignSystem.secondaryGold
                                        ],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .scaleEffect(logoScale)
                                .opacity(logoOpacity)
                                .rotationEffect(.degrees(logoRotation * 0.3))
                        }
                    }
                    
                    VStack(spacing: 16) {
                        Text("GOLDEX AI")
                            .font(.system(size: 42, weight: .black, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [
                                        DesignSystem.primaryGold,
                                        DesignSystem.darkGold
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .opacity(showTitle ? 1 : 0)
                            .scaleEffect(showTitle ? 1 : 0.9)
                            .offset(y: showTitle ? 0 : 20)
                        
                        Text("Elite Gold Trading Intelligence")
                            .font(.system(size: 18, weight: .medium, design: .rounded))
                            .foregroundStyle(.secondary)
                            .opacity(showSubtitle ? 1 : 0)
                            .scaleEffect(showSubtitle ? 1 : 0.95)
                            .offset(y: showSubtitle ? 0 : 15)
                        
                        if showBalance {
                            VStack(spacing: 6) {
                                Text("Connected to Coinexx Account")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundStyle(.secondary)
                                
                                HStack(spacing: 8) {
                                    Circle()
                                        .fill(.green)
                                        .frame(width: 8, height: 8)
                                    
                                    Text("$\(String(format: "%.2f", accountManager.balance))")
                                        .font(.system(size: 24, weight: .bold, design: .rounded))
                                        .foregroundStyle(DesignSystem.primaryGold)
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 12)
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                            .scaleEffect(showBalance ? 1 : 0.9)
                            .opacity(showBalance ? 1 : 0)
                        }
                        
                        Text("Version 3.0 Enhanced")
                            .font(.system(size: 12, weight: .light))
                            .foregroundStyle(.tertiary)
                            .opacity(showSubtitle ? 0.8 : 0)
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 20) {
                        VStack(spacing: 8) {
                            ProgressView(value: progressValue, total: 1.0)
                                .progressViewStyle(LinearProgressViewStyle(tint: DesignSystem.primaryGold))
                                .scaleEffect(y: 2)
                                .frame(width: 200)
                                .opacity(showLoadingAnimation ? 1 : 0)
                            
                            Text("\(Int(progressValue * 100))%")
                                .font(.system(size: 14, weight: .medium, design: .monospaced))
                                .foregroundStyle(DesignSystem.primaryGold)
                                .opacity(showLoadingAnimation ? 1 : 0)
                        }
                        
                        Text(connectionStatus)
                            .font(.system(size: 15, weight: .medium))
                            .foregroundStyle(.secondary)
                            .opacity(showLoadingAnimation ? 1 : 0)
                            .animation(.easeInOut(duration: 0.3), value: connectionStatus)
                    }
                    .padding(.bottom, 60)
                }
                .padding(.horizontal, 30)
            }
        }
        .onAppear {
            startSplashAnimations()
        }
    }
    
    private func startSplashAnimations() {
        withAnimation(.spring(response: 1.2, dampingFraction: 0.6).delay(0.2)) {
            logoScale = 1.0
            logoOpacity = 1.0
            logoRotation = 0
        }
        
        withAnimation(.easeInOut(duration: 2.5).delay(0.3)) {
            backgroundGradient = true
        }
        
        withAnimation(.easeInOut(duration: 0.8).delay(0.5)) {
            particleAnimation = true
        }
        
        withAnimation(.linear(duration: 10.0).repeatForever(autoreverses: false).delay(1.0)) {
            logoRotation = 360
        }
        
        withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true).delay(1.0)) {
            pulseAnimation = true
        }
        
        withAnimation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.9)) {
            showTitle = true
        }
        
        withAnimation(.easeInOut(duration: 0.6).delay(1.3)) {
            showSubtitle = true
        }
        
        withAnimation(.easeInOut(duration: 0.5).delay(1.8)) {
            showLoadingAnimation = true
        }
        
        startProgressAnimation()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
            connectionStatus = "Connecting to Coinexx Account 845060..."
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.8) {
            connectionStatus = "Loading real-time account data..."
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.2) {
            connectionStatus = "Synchronizing with EA..."
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3)) {
                showBalance = true
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
            connectionStatus = "Ready! Live trading active..."
        }
    }
    
    private func startProgressAnimation() {
        let timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
            withAnimation(.linear(duration: 0.05)) {
                progressValue += 0.02
            }
            
            if progressValue >= 1.0 {
                progressValue = 1.0
                timer.invalidate()
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            timer.fire()
        }
    }
}

// MARK: - ContentView Animated Background
struct ContentViewAnimatedBackground: View {
    let isAnimating: Bool
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: isAnimating ? [
                    Color.white,
                    DesignSystem.primaryGold.opacity(0.08),
                    DesignSystem.secondaryGold.opacity(0.05),
                    Color.white.opacity(0.98)
                ] : [
                    Color.white,
                    Color.white.opacity(0.95),
                    Color.white
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            if isAnimating {
                ForEach(0..<3, id: \.self) { index in
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
                        .frame(width: 200, height: 200)
                        .offset(
                            x: CGFloat.random(in: -100...100),
                            y: CGFloat.random(in: -200...200)
                        )
                        .animation(
                            .easeInOut(duration: Double.random(in: 8...12))
                                .repeatForever(autoreverses: false)
                                .delay(Double(index) * 2),
                            value: isAnimating
                        )
                }
            }
        }
        .animation(.easeInOut(duration: 2.0), value: isAnimating)
    }
}

// MARK: - ContentView Particle System
struct ContentViewParticleSystemView: View {
    let geometry: GeometryProxy
    
    var body: some View {
        ForEach(0..<15, id: \.self) { index in
            ContentViewParticleView(
                geometry: geometry,
                delay: Double(index) * 0.3
            )
        }
    }
}

struct ContentViewParticleView: View {
    let geometry: GeometryProxy
    let delay: Double
    
    @State private var position = CGPoint.zero
    @State private var opacity: Double = 0
    @State private var scale: CGFloat = 0.5
    
    var body: some View {
        Circle()
            .fill(
                LinearGradient(
                    colors: [
                        DesignSystem.primaryGold.opacity(0.6),
                        DesignSystem.secondaryGold.opacity(0.3)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(width: CGFloat.random(in: 3...8), height: CGFloat.random(in: 3...8))
            .position(position)
            .opacity(opacity)
            .scaleEffect(scale)
            .onAppear {
                startAnimation()
            }
    }
    
    private func startAnimation() {
        position = CGPoint(
            x: CGFloat.random(in: 0...geometry.size.width),
            y: geometry.size.height + 50
        )
        
        withAnimation(
            .linear(duration: Double.random(in: 6...12))
                .repeatForever(autoreverses: false)
                .delay(delay)
        ) {
            position = CGPoint(
                x: CGFloat.random(in: 0...geometry.size.width),
                y: -50
            )
        }
        
        withAnimation(
            .easeInOut(duration: 2.0)
                .delay(delay)
        ) {
            opacity = 1.0
            scale = 1.0
        }
        
        withAnimation(
            .easeInOut(duration: 2.0)
                .delay(delay + Double.random(in: 4...8))
        ) {
            opacity = 0
            scale = 0.5
        }
    }
}

// MARK: - Stub View for Non-Conflicting Names
struct ContentViewStubView: View {
    let title: String
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "brain.head.profile")
                .font(.system(size: 64, weight: .light))
                .foregroundStyle(DesignSystem.primaryGold)
            
            Text(title)
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Coming soon with enhanced AI capabilities")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.large)
        .background(DesignSystem.backgroundGradient)
    }
}

// MARK: - Data Models
struct MenuSection {
    let title: String
    let items: [MenuItem]
}

struct MenuItem {
    let icon: String
    let title: String
    let destination: MenuDestination
}

enum MenuDestination {
    case mt5Setup, training, portfolio, aiInsights
    case signals, proTrader, performance
    case accountDetails, settings, support, autoDebug
}

// MARK: - Auto Debug Status Card
struct AutoDebugStatusCard: View {
    @EnvironmentObject private var autoDebugSystem: AutoDebugSystem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "wrench.and.screwdriver.fill")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.primary)
                Text("Auto Debug")
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundStyle(.primary)
            }
            
            Text("Auto debug system: \(autoDebugSystem.errorCount) error(s) found")
                .font(.footnote)
                .foregroundStyle(autoDebugSystem.errorCount > 0 ? .red : .green)
            
            if autoDebugSystem.selfHealingEnabled {
                Text("Self-healing: Enabled")
                    .font(.footnote)
                    .foregroundStyle(.green)
            } else {
                Text("Self-healing: Disabled")
                    .font(.footnote)
                    .foregroundStyle(.red)
            }
        }
        .padding(12)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: DesignSystem.cardShadow, radius: 8, x: 0, y: 4)
    }
}

// MARK: - Preview Provider
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.light)
    }
}

struct MenuPreview: PreviewProvider {
    static var previews: some View {
        MoreMenuView()
            .environmentObject(TradingViewModel())
            .environmentObject(RealTimeAccountManager())
            .preferredColorScheme(.light)
    }
}