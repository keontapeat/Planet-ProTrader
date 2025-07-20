import SwiftUI
import Foundation

struct MainTabView: View {
    @EnvironmentObject private var authManager: AuthenticationManager
    @StateObject private var opusManager = OpusAutodebugService()
    @State private var showingOpusInterface = false
    @State private var selectedTab = 0
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
            
            TabView(selection: $selectedTab) {
                // Home Tab
                HomeDashboardView()
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }
                    .tag(0)
                
                // Trading Tab
                ProfessionalChartView()
                    .tabItem {
                        Image(systemName: "chart.line.uptrend.xyaxis")
                        Text("Trading")
                    }
                    .tag(1)
                
                // Bots Tab
                ModernBotView()
                    .tabItem {
                        Image(systemName: "brain.head.profile")
                        Text("Bots")
                    }
                    .tag(2)
                
                // Claude Integration Tab (NEW!)
                ClaudeIntegrationDashboard()
                    .tabItem {
                        Image(systemName: "cpu")
                        Text("Claude AI")
                    }
                    .tag(3)
                
                // Profile Tab
                ProfileView()
                    .tabItem {
                        Image(systemName: "person.circle.fill")
                        Text("Profile")
                    }
                    .tag(4)
            }
            .accentColor(DesignSystem.primaryGold)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: selectedTab)
            .onAppear {
                setupOpusSystem()
                setupTabBarAppearance()
            }
            
            // Floating OPUS Status Indicator
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
        .sheet(isPresented: $showingOpusInterface) {
            OpusDebugInterface()
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
        .animation(.easeInOut, value: showingOpusInterface)
    }
    
    private func setupOpusSystem() {
        // Initialize OPUS AI System with delay
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
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

// MARK: - Modern OPUS Floating Button Component
struct OpusFloatingButton: View {
    let isActive: Bool
    @Binding var showingInterface: Bool
    
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
                
                if isActive {
                    Circle()
                        .fill(
                            LinearGradient(colors: [.green, .mint], startPoint: .top, endPoint: .bottom)
                        )
                        .frame(width: 6, height: 6)
                        .scaleEffect(1.3)
                        .animation(
                            .easeInOut(duration: 1.2)
                            .repeatForever(autoreverses: true),
                            value: isActive
                        )
                }
                
                Text("OPUS AI")
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(.ultraThinMaterial)
                    .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(
                                LinearGradient(
                                    colors: isActive ? [.orange.opacity(0.3), .yellow.opacity(0.3)] : [.clear],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
            )
        }
        .buttonStyle(.plain)
        .scaleEffect(showingInterface ? 0.95 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: showingInterface)
    }
}

// MARK: - Modern Bot View (Replacing SimpleBotView)
struct ModernBotView: View {
    @State private var selectedBotCategory = 0
    private let botCategories = ["Active", "Learning", "Archived"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header Statistics
                    ModernStatsCard()
                    
                    // Category Picker
                    BotCategoryPicker(selection: $selectedBotCategory, categories: botCategories)
                    
                    // Bot Grid
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 16),
                        GridItem(.flexible(), spacing: 16)
                    ], spacing: 16) {
                        ForEach(0..<6, id: \.self) { index in
                            ModernBotCard(
                                botName: "AI Trader \(index + 1)",
                                strategy: ["Scalping", "Swing", "DCA", "Grid"][index % 4],
                                profit: Double.random(in: 150...2500),
                                isActive: index < 4,
                                winRate: Int.random(in: 65...95)
                            )
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
        }
    }
}

// MARK: - Modern Stats Card Component
struct ModernStatsCard: View {
    var body: some View {
        UltraPremiumCard {
            VStack(spacing: 20) {
                HStack {
                    Text("Portfolio Overview")
                        .font(.title2.bold())
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .font(.title2)
                        .foregroundStyle(.green)
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
    }
}

// MARK: - Stat Item Component
struct StatItem: View {
    let value: String
    let label: String
    let color: Color
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(color)
            
            Text(value)
                .font(.title2.bold())
                .foregroundColor(color)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Bot Category Picker
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
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(selection == index ? DesignSystem.primaryGold : Color.clear)
                        )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(4)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color(.tertiarySystemGroupedBackground))
        )
    }
}

// MARK: - Modern Bot Card
struct ModernBotCard: View {
    let botName: String
    let strategy: String
    let profit: Double
    let isActive: Bool
    let winRate: Int
    
    var body: some View {
        UltraPremiumCard {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(botName)
                            .font(.headline.bold())
                            .foregroundColor(.primary)
                        
                        Text(strategy)
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
                            .fill(isActive ? .green : .gray)
                            .frame(width: 8, height: 8)
                        
                        Text(isActive ? "LIVE" : "OFF")
                            .font(.system(size: 8, weight: .bold))
                            .foregroundColor(isActive ? .green : .gray)
                    }
                }
                
                Divider()
                
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Profit")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        
                        Text("$\(Int(profit))")
                            .font(.subheadline.bold())
                            .foregroundColor(profit > 0 ? .green : .red)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("Win Rate")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        
                        Text("\(winRate)%")
                            .font(.subheadline.bold())
                            .foregroundColor(.blue)
                    }
                }
            }
            .padding(16)
        }
    }
}

// MARK: - Preview
#Preview {
    MainTabView()
}

#Preview("Modern Bot View") {
    ModernBotView()
}

#Preview("OPUS Floating Button") {
    VStack {
        OpusFloatingButton(isActive: true, showingInterface: .constant(false))
        OpusFloatingButton(isActive: false, showingInterface: .constant(false))
    }
    .padding()
}