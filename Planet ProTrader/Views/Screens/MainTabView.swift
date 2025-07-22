//
//  MainTabView.swift
//  Planet ProTrader
//
//  ✅ MAIN TAB NAVIGATION - Professional tab bar with modern design
//  Latest SwiftUI patterns and performance optimization
//

import SwiftUI
import Foundation

struct MainTabView: View {
    @EnvironmentObject private var authManager: AuthenticationManager
    @EnvironmentObject private var tradingViewModel: TradingViewModel
    @EnvironmentObject private var realTimeAccountManager: RealTimeAccountManager
    @EnvironmentObject private var performanceMonitor: PerformanceMonitor
    @EnvironmentObject private var toastManager: ToastManager
    
    @StateObject private var opusManager = OpusAutodebugService()
    @State private var selectedTab = 0
    @State private var isLoading = false
    @State private var showingOpusInterface = false
    @Namespace private var tabAnimation
    
    var body: some View {
        ZStack {
            // Premium background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(.systemBackground),
                    DesignSystem.primaryGold.opacity(0.02),
                    Color(.systemBackground).opacity(0.98)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            TabView(selection: $selectedTab) {
                // Home Dashboard
                HomeDashboardView()
                    .tabItem {
                        TabItemView(
                            icon: selectedTab == 0 ? "house.fill" : "house",
                            title: "Home",
                            isSelected: selectedTab == 0
                        )
                    }
                    .tag(0)
                
                // Trading Terminal
                TradingTerminal()
                    .tabItem {
                        TabItemView(
                            icon: selectedTab == 1 ? "chart.line.uptrend.xyaxis.fill" : "chart.line.uptrend.xyaxis",
                            title: "Trading",
                            isSelected: selectedTab == 1
                        )
                    }
                    .tag(1)
                
                // Portfolio
                PortfolioView()
                    .tabItem {
                        TabItemView(
                            icon: selectedTab == 2 ? "briefcase.fill" : "briefcase",
                            title: "Portfolio",
                            isSelected: selectedTab == 2
                        )
                    }
                    .tag(2)
                
                // AI Bots
                BotManagementView()
                    .tabItem {
                        TabItemView(
                            icon: selectedTab == 3 ? "brain.head.profile.fill" : "brain.head.profile",
                            title: "AI Bots",
                            isSelected: selectedTab == 3
                        )
                    }
                    .tag(3)
                
                // Profile
                ProfileView()
                    .tabItem {
                        TabItemView(
                            icon: selectedTab == 4 ? "person.circle.fill" : "person.circle",
                            title: "Profile",
                            isSelected: selectedTab == 4
                        )
                    }
                    .tag(4)
            }
            .accentColor(DesignSystem.primaryGold)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: selectedTab)
            .onAppear {
                setupTabBarAppearance()
                performanceMonitor.startMonitoring()
                startOpusSystem()
            }
            .onDisappear {
                performanceMonitor.stopMonitoring()
            }
            
            // Floating OPUS AI Assistant
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    FloatingOpusButton(
                        isActive: opusManager.isActive,
                        showingInterface: $showingOpusInterface
                    )
                    .padding(.trailing, 20)
                    .padding(.bottom, 90)
                }
            }
            .animation(.spring(response: 0.6, dampingFraction: 0.8), value: showingOpusInterface)
        }
        .sheet(isPresented: $showingOpusInterface) {
            OpusAIInterfaceView()
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
        .overlay(alignment: .top) {
            // Toast notifications
            if toastManager.showToast {
                ToastView(
                    message: toastManager.toastMessage,
                    type: toastManager.toastType
                )
                .transition(.move(edge: .top).combined(with: .opacity))
                .padding(.top, 50)
                .animation(.spring(response: 0.5, dampingFraction: 0.8), value: toastManager.showToast)
            }
        }
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.95)
        
        // Enhanced tab styling
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(DesignSystem.primaryGold)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(DesignSystem.primaryGold),
            .font: UIFont.systemFont(ofSize: 10, weight: .semibold)
        ]
        
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor.secondaryLabel
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.secondaryLabel,
            .font: UIFont.systemFont(ofSize: 10, weight: .medium)
        ]
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    private func startOpusSystem() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                opusManager.unleashOpusPower()
            }
        }
    }
}

// MARK: - Supporting Components

struct TabItemView: View {
    let icon: String
    let title: String
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .medium))
                .scaleEffect(isSelected ? 1.1 : 1.0)
            
            Text(title)
                .font(.system(size: 10, weight: isSelected ? .semibold : .medium))
        }
        .foregroundColor(isSelected ? DesignSystem.primaryGold : Color.secondary)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

struct FloatingOpusButton: View {
    let isActive: Bool
    @Binding var showingInterface: Bool
    @State private var isAnimating = false
    
    var body: some View {
        Button(action: {
            HapticFeedbackManager.shared.selection()
            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                showingInterface.toggle()
            }
        }) {
            ZStack {
                // Pulsing ring when active
                if isActive {
                    Circle()
                        .stroke(DesignSystem.primaryGold.opacity(0.4), lineWidth: 2)
                        .scaleEffect(isAnimating ? 1.3 : 1.0)
                        .opacity(isAnimating ? 0.0 : 0.8)
                        .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: false), value: isAnimating)
                }
                
                // Main button
                Circle()
                    .fill(
                        LinearGradient(
                            colors: isActive 
                            ? [DesignSystem.primaryGold, DesignSystem.primaryGold.opacity(0.8)]
                            : [Color.gray, Color.gray.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 56, height: 56)
                    .shadow(
                        color: isActive ? DesignSystem.primaryGold.opacity(0.3) : .black.opacity(0.1), 
                        radius: 12, 
                        x: 0, 
                        y: 6
                    )
                
                // Icon
                Image(systemName: "brain.head.profile.fill")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(.white)
                    .scaleEffect(showingInterface ? 1.1 : 1.0)
                    .rotationEffect(.degrees(showingInterface ? 15 : 0))
            }
        }
        .buttonStyle(.plain)
        .onAppear {
            if isActive {
                isAnimating = true
            }
        }
        .onChange(of: isActive) { newValue in
            withAnimation(.easeInOut) {
                isAnimating = newValue
            }
        }
    }
}

struct ToastView: View {
    let message: String
    let type: ToastType
    
    enum ToastType {
        case success, error, info, warning
        
        var color: Color {
            switch self {
            case .success: return .green
            case .error: return .red
            case .info: return .blue
            case .warning: return .orange
            }
        }
        
        var icon: String {
            switch self {
            case .success: return "checkmark.circle.fill"
            case .error: return "xmark.circle.fill"
            case .info: return "info.circle.fill"
            case .warning: return "exclamationmark.triangle.fill"
            }
        }
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: type.icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(type.color)
            
            Text(message)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.primary)
                .multilineTextAlignment(.leading)
            
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(type.color.opacity(0.3), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        .padding(.horizontal, 20)
    }
}

#Preview {
    MainTabView()
        .environmentObject(AuthenticationManager())
        .environmentObject(TradingViewModel())
        .environmentObject(RealTimeAccountManager())
        .environmentObject(AutoTradingManager())
        .environmentObject(BrokerConnector())
        .environmentObject(RealDataManager())
        .environmentObject(TradingBotManager.shared)
        .environmentObject(ToastManager.shared)
        .environmentObject(PerformanceMonitor.shared)
        .preferredColorScheme(.light)
}