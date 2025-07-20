//
//  OptimizedContentView.swift
//  Planet ProTrader
//
//  Created by AI Assistant on 1/25/25.
//

import SwiftUI

// MARK: - Ultra-Modern ContentView with Performance Optimizations

struct OptimizedContentView: View {
    @State private var isLoading = true
    @State private var selectedTab = 0
    @State private var hasLaunched = false
    
    var body: some View {
        Group {
            if isLoading {
                // Modern splash screen
                ModernSplashView()
                    .task {
                        await performStartupTasks()
                    }
            } else {
                // Main app interface
                MainAppInterface(selectedTab: $selectedTab)
                    .preferredColorScheme(.light)
                    .onAppear {
                        if !hasLaunched {
                            hasLaunched = true
                            // Initialize background systems
                            initializeBackgroundSystems()
                        }
                    }
            }
        }
        .animation(.easeInOut(duration: 0.8), value: isLoading)
    }
    
    // MARK: - Startup Tasks
    
    private func performStartupTasks() async {
        // Simulate app initialization
        do {
            // Critical app startup tasks
            await initializeCoreServices()
            await preloadCriticalData()
            
            // Smooth transition delay
            try await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 seconds
            
            await MainActor.run {
                withAnimation(.spring(response: 0.8, dampingFraction: 0.8)) {
                    isLoading = false
                }
            }
        } catch {
            print("Startup error: \(error)")
            await MainActor.run {
                isLoading = false
            }
        }
    }
    
    private func initializeCoreServices() async {
        // Initialize Firebase, Supabase, etc.
        // This is where you'd initialize your services
    }
    
    private func preloadCriticalData() async {
        // Preload essential data
        // User settings, cached data, etc.
    }
    
    private func initializeBackgroundSystems() {
        // Initialize performance monitoring
        _ = PerformanceOptimizer.shared
        
        // Setup notifications
        NotificationCenter.default.post(name: .appDidLaunch, object: nil)
    }
}

// MARK: - Modern Splash Screen

struct ModernSplashView: View {
    @State private var logoScale: CGFloat = 0.8
    @State private var logoOpacity: Double = 0
    @State private var textOpacity: Double = 0
    @State private var progressValue: Double = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Modern gradient background
                LinearGradient(
                    colors: [
                        Color(red: 0.1, green: 0.1, blue: 0.2),
                        Color(red: 0.2, green: 0.1, blue: 0.3),
                        Color(red: 0.1, green: 0.2, blue: 0.4)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                // Animated particles
                ParticleEffectView()
                
                VStack(spacing: 32) {
                    Spacer()
                    
                    // Logo section
                    VStack(spacing: 24) {
                        // App logo/icon
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [.yellow, .orange, .red],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 120, height: 120)
                            
                            Image(systemName: "chart.line.uptrend.xyaxis")
                                .font(.system(size: 48, weight: .bold))
                                .foregroundStyle(.white)
                        }
                        .scaleEffect(logoScale)
                        .opacity(logoOpacity)
                        .shadow(color: .yellow.opacity(0.5), radius: 20, x: 0, y: 0)
                        
                        // App title
                        VStack(spacing: 8) {
                            Text("PLANET PROTRADER")
                                .font(.system(size: 28, weight: .heavy, design: .rounded))
                                .foregroundStyle(.white)
                                .opacity(textOpacity)
                            
                            Text("AI-Powered Trading Excellence")
                                .font(.subheadline)
                                .foregroundStyle(.white.opacity(0.8))
                                .opacity(textOpacity)
                        }
                    }
                    
                    Spacer()
                    
                    // Loading section
                    VStack(spacing: 16) {
                        // Progress bar
                        VStack(spacing: 8) {
                            ProgressView(value: progressValue, total: 1.0)
                                .progressViewStyle(ModernProgressStyle())
                                .frame(width: 200)
                            
                            Text("Initializing AI Systems...")
                                .font(.caption)
                                .foregroundStyle(.white.opacity(0.7))
                        }
                        .opacity(textOpacity)
                        
                        // Version info
                        Text("v2.0.0 • Powered by GPT-4 & Claude")
                            .font(.caption2)
                            .foregroundStyle(.white.opacity(0.5))
                            .opacity(textOpacity)
                    }
                    .padding(.bottom, 50)
                }
                .padding()
            }
        }
        .onAppear {
            startAnimations()
        }
    }
    
    private func startAnimations() {
        // Logo animation
        withAnimation(.spring(response: 1.0, dampingFraction: 0.6, blendDuration: 0)) {
            logoScale = 1.0
            logoOpacity = 1.0
        }
        
        // Text animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.easeInOut(duration: 0.8)) {
                textOpacity = 1.0
            }
        }
        
        // Progress animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation(.easeInOut(duration: 1.5)) {
                progressValue = 1.0
            }
        }
    }
}

// MARK: - Particle Effect

struct ParticleEffectView: View {
    @State private var particles: [Particle] = []
    
    var body: some View {
        TimelineView(.animation) { context in
            Canvas { context, size in
                for particle in particles {
                    context.fill(
                        Path(ellipseIn: CGRect(
                            x: particle.x,
                            y: particle.y,
                            width: particle.size,
                            height: particle.size
                        )),
                        with: .color(.white.opacity(particle.opacity))
                    )
                }
            }
        }
        .onAppear {
            generateParticles()
        }
    }
    
    private func generateParticles() {
        particles = (0..<50).map { _ in
            Particle(
                x: Double.random(in: 0...400),
                y: Double.random(in: 0...800),
                size: Double.random(in: 1...3),
                opacity: Double.random(in: 0.1...0.3)
            )
        }
    }
}

struct Particle {
    var x: Double
    var y: Double
    var size: Double
    var opacity: Double
}

// MARK: - Modern Progress Style

struct ModernProgressStyle: ProgressViewStyle {
    func makeBody(configuration: Configuration) -> some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 8)
                .fill(.white.opacity(0.2))
                .frame(height: 6)
            
            RoundedRectangle(cornerRadius: 8)
                .fill(
                    LinearGradient(
                        colors: [.blue, .purple, .pink],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(width: 200 * (configuration.fractionCompleted ?? 0), height: 6)
                .animation(.easeInOut(duration: 0.3), value: configuration.fractionCompleted)
        }
    }
}

// MARK: - Main App Interface

struct MainAppInterface: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Home Dashboard
            NavigationStack {
                DashboardHomeView()
            }
            .tabItem {
                Label("Dashboard", systemImage: "house.fill")
            }
            .tag(0)
            
            // Trading
            NavigationStack {
                TradingMainView()
            }
            .tabItem {
                Label("Trading", systemImage: "chart.line.uptrend.xyaxis")
            }
            .tag(1)
            
            // AI Bots
            NavigationStack {
                AIBotsMainView()
            }
            .tabItem {
                Label("AI Bots", systemImage: "brain.head.profile")
            }
            .tag(2)
            
            // Portfolio
            NavigationStack {
                PortfolioMainView()
            }
            .tabItem {
                Label("Portfolio", systemImage: "briefcase.fill")
            }
            .tag(3)
            
            // Settings
            NavigationStack {
                SettingsMainView()
            }
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
            .tag(4)
        }
        .tint(.blue)
    }
}

// MARK: - Placeholder Main Views (These will be replaced with actual views)

struct DashboardHomeView: View {
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                Text("🚀 Welcome to Planet ProTrader")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                
                ProfessionalMetricCard(
                    title: "Total Portfolio",
                    value: "$125,450.00",
                    change: "+12.4%",
                    color: .green,
                    icon: "dollarsign.circle.fill"
                )
                .padding(.horizontal)
                
                ProfessionalMetricCard(
                    title: "AI Success Rate",
                    value: "87.5%",
                    change: "+2.1%",
                    color: .blue,
                    icon: "brain.head.profile"
                )
                .padding(.horizontal)
            }
        }
        .navigationTitle("Dashboard")
        .optimizedNavigation()
    }
}

struct TradingMainView: View {
    var body: some View {
        VStack {
            SmartLoadingView()
            Text("Advanced Trading Interface")
                .font(.headline)
            Text("Coming from existing views...")
                .foregroundStyle(.secondary)
        }
        .navigationTitle("Trading")
        .optimizedNavigation()
    }
}

struct AIBotsMainView: View {
    var body: some View {
        VStack {
            SmartLoadingView()
            Text("AI Trading Bots")
                .font(.headline)
            Text("Integration with existing bot system...")
                .foregroundStyle(.secondary)
        }
        .navigationTitle("AI Bots")
        .optimizedNavigation()
    }
}

struct PortfolioMainView: View {
    var body: some View {
        VStack {
            SmartLoadingView()
            Text("Portfolio Analytics")
                .font(.headline)
            Text("Advanced portfolio management...")
                .foregroundStyle(.secondary)
        }
        .navigationTitle("Portfolio")
        .optimizedNavigation()
    }
}

struct SettingsMainView: View {
    var body: some View {
        VStack {
            SmartLoadingView()
            Text("App Settings")
                .font(.headline)
            Text("Configuration and preferences...")
                .foregroundStyle(.secondary)
        }
        .navigationTitle("Settings")
        .optimizedNavigation()
    }
}

// MARK: - Notification Extensions

extension Notification.Name {
    static let appDidLaunch = Notification.Name("appDidLaunch")
}

#Preview {
    OptimizedContentView()
}