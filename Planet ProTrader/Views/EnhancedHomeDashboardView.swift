//
//  EnhancedHomeDashboardView.swift
//  Planet ProTrader
//
//  Created by AI Assistant on 1/25/25.
//

import SwiftUI

struct EnhancedHomeDashboardView: View {
    @StateObject private var viewModel = HomeDashboardViewModel()
    @State private var selectedTab: DashboardTab = .command
    @State private var showingProfile = false
    @State private var animateElements = false
    @State private var rotatingPlanet = false
    @State private var activeSheet: ActiveSheet?

    enum DashboardTab: String, CaseIterable {
        case command = "command"
        case arena = "arena"
        case microflip = "microflip"
        case voices = "voices"
        case wallet = "wallet"
        
        var title: String {
            switch self {
            case .command: return "Command Center"
            case .arena: return "Bot Arena"
            case .microflip: return "MicroFlip"
            case .voices: return "Bot Voices"
            case .wallet: return "Wallet"
            }
        }
        
        var icon: String {
            switch self {
            case .command: return "command"
            case .arena: return "brain.head.profile"
            case .microflip: return "gamecontroller.fill"
            case .voices: return "speaker.wave.2.fill"
            case .wallet: return "creditcard.fill"
            }
        }
        
        var emoji: String {
            switch self {
            case .command: return "🎯"
            case .arena: return "🏆"
            case .microflip: return "⚡"
            case .voices: return "🎙️"
            case .wallet: return "💰"
            }
        }
    }

    enum ActiveSheet: String, CaseIterable {
        case trading = "trading"
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Epic Header
                planetProTraderHeader
                
                // Main Content
                ScrollView {
                    LazyVStack(spacing: 20) {
                        // Quick Stats Banner
                        quickStatsBanner
                        
                        // Tab Content
                        tabContent
                    }
                    .padding(.horizontal)
                }
                
                // Bottom Tab Bar
                bottomTabBar
            }
            .background(planetBackground)
        }
        .onAppear {
            startAnimations()
        }
        .sheet(isPresented: .init(get: { activeSheet == .trading }, set: { activeSheet = $0 ? .trading : nil })) {
            Text("Trading View")
        }
    }
    
    private var planetProTraderHeader: some View {
        VStack(spacing: 12) {
            HStack {
                // Planet ProTrader Logo
                Button(action: { showingProfile = true }) {
                    HStack(spacing: 8) {
                        Text("🌍")
                            .font(.title2)
                            .rotationEffect(.degrees(rotatingPlanet ? 360 : 0))
                            .animation(.linear(duration: 20).repeatForever(autoreverses: false), value: rotatingPlanet)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Planet ProTrader")
                                .font(.system(size: 18, weight: .black, design: .rounded))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.blue, .purple, .green],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                            
                            Text("Where trading is a game")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }
                }
                .buttonStyle(PlainButtonStyle())
                
                Spacer()
                
                // User Profile
                Button(action: { showingProfile = true }) {
                    HStack(spacing: 8) {
                        VStack(alignment: .trailing, spacing: 2) {
                            Text("Elite Trader")
                                .font(.caption.bold())
                                .foregroundColor(.gold)
                            
                            Text("Level 47")
                                .font(.caption2)
                                .foregroundColor(.white.opacity(0.7))
                        }
                        
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [.blue, .purple],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 40, height: 40)
                            
                            Text("🚀")
                                .font(.title3)
                        }
                    }
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            // Hero Slogan Banner
            HStack {
                Spacer()
                
                Text("\"Where Poverty Doesn't Exist!\"")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.green, .gold, .green],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .shadow(color: .green.opacity(0.3), radius: 5, x: 0, y: 0)
                    .opacity(animateElements ? 1 : 0)
                    .scaleEffect(animateElements ? 1 : 0.9)
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(.ultraThinMaterial.opacity(0.3))
            .cornerRadius(15)
        }
        .padding()
        .background(
            LinearGradient(
                colors: [.black, .purple.opacity(0.3), .black],
                startPoint: .leading,
                endPoint: .trailing
            )
        )
    }
    
    private var quickStatsBanner: some View {
        HStack(spacing: 16) {
            PlanetStatCard(
                title: "Planet Balance",
                value: "$47,329.50",
                change: "+$2,847.30",
                emoji: "🌍",
                color: .blue
            )
            
            PlanetStatCard(
                title: "Active Bots",
                value: "23",
                change: "🔥 Blazing",
                emoji: "🤖",
                color: .purple
            )
            
            PlanetStatCard(
                title: "Win Rate",
                value: "94.7%",
                change: "+12.3%",
                emoji: "🎯",
                color: .green
            )
        }
        .opacity(animateElements ? 1 : 0)
        .offset(y: animateElements ? 0 : 30)
        .animation(.spring(dampingFraction: 0.8).delay(0.3), value: animateElements)
    }
    
    private var tabContent: some View {
        Group {
            switch selectedTab {
            case .command:
                commandCenterView
            case .arena:
                botArenaPreview
            case .microflip:
                microFlipPreview
            case .voices:
                botVoicesPreview
            case .wallet:
                walletPreview
            }
        }
        .opacity(animateElements ? 1 : 0)
        .offset(x: animateElements ? 0 : 50)
        .animation(.spring(dampingFraction: 0.7).delay(0.5), value: animateElements)
    }
    
    private var commandCenterView: some View {
        VStack(spacing: 16) {
            // Live Trading Status
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("🎯 Command Center")
                        .font(.title2.bold())
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Circle()
                            .fill(.green)
                            .frame(width: 8, height: 8)
                            .scaleEffect(animateElements ? 1.2 : 1.0)
                            .animation(.easeInOut(duration: 1).repeatForever(), value: animateElements)
                        
                        Text("LIVE")
                            .font(.caption.bold())
                            .foregroundColor(.green)
                    }
                }
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                    CommandCard(
                        title: "ProTrader Army",
                        subtitle: "23 bots trading",
                        emoji: "🤖",
                        color: .blue
                    )
                    
                    CommandCard(
                        title: "Discord Wars",
                        subtitle: "Live bot battles",
                        emoji: "⚔️",
                        color: .red
                    )
                    
                    CommandCard(
                        title: "Planet Fuel",
                        subtitle: "$12,847 loaded",
                        emoji: "⛽",
                        color: .orange
                    )
                    
                    CommandCard(
                        title: "Profit Engine",
                        subtitle: "+$2,847 today",
                        emoji: "💰",
                        color: .green
                    )
                }
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(15)
            
            // Quick Actions
            VStack(alignment: .leading, spacing: 12) {
                Text("⚡ Quick Actions")
                    .font(.title3.bold())
                
                HStack(spacing: 12) {
                    QuickActionButton(
                        title: "Start MicroFlip",
                        emoji: "⚡",
                        color: .blue
                    )
                    
                    QuickActionButton(
                        title: "Add Fuel",
                        emoji: "⛽",
                        color: .orange
                    )
                    
                    QuickActionButton(
                        title: "Trade Gold",
                        icon: "bolt.fill",
                        count: 5,
                        action: { activeSheet = .trading }
                    )
                    
                    QuickActionButton(
                        title: "Check Voices",
                        emoji: "🎙️",
                        color: .purple
                    )
                }
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(15)
        }
    }
    
    private var botArenaPreview: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("🏆 Bot Arena Preview")
                .font(.title2.bold())
            
            Text("Top 3 Champions")
                .font(.headline)
                .foregroundColor(.secondary)
            
            VStack(spacing: 8) {
                ArenaPreviewRow(
                    rank: 1,
                    name: "Alpha Wolf",
                    emoji: "🐺",
                    profit: "+$2,847.30",
                    badge: "🥇"
                )
                
                ArenaPreviewRow(
                    rank: 2,
                    name: "Quantum Beast",
                    emoji: "🤖",
                    profit: "+$2,543.80",
                    badge: "🥈"
                )
                
                ArenaPreviewRow(
                    rank: 3,
                    name: "Speed Demon",
                    emoji: "⚡",
                    profit: "+$2,156.70",
                    badge: "🥉"
                )
            }
            
            NavigationLink(destination: BotLeaderboardView()) {
                Text("View Full Arena 🏟️")
                    .font(.headline.bold())
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(15)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(15)
    }
    
    private var microFlipPreview: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("⚡ MicroFlip Games")
                .font(.title2.bold())
            
            Text("Quick $20-$50 Trading Games")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                MicroFlipCard(
                    type: "Quick Flip",
                    duration: "5 min",
                    entry: "$25",
                    target: "$50",
                    emoji: "⚡"
                )
                
                MicroFlipCard(
                    type: "Speed Run",
                    duration: "3 min",
                    entry: "$50",
                    target: "$100",
                    emoji: "🏃"
                )
            }
            
            NavigationLink(destination: MicroFlipGameView()) {
                Text("Enter MicroFlip Arena 🎮")
                    .font(.headline.bold())
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.green)
                    .foregroundColor(.white)
                    .cornerRadius(15)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(15)
    }
    
    private var botVoicesPreview: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("🎙️ Bot Voice Notes")
                .font(.title2.bold())
            
            Text("Latest AI Feedback")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            VStack(spacing: 8) {
                VoicePreviewRow(
                    botName: "Alpha Wolf",
                    emoji: "🐺",
                    message: "Yo! That trade was FIRE! 🔥",
                    time: "2m ago"
                )
                
                VoicePreviewRow(
                    botName: "Quantum Beast",
                    emoji: "🤖",
                    message: "Market analysis complete. 73.2% win probability.",
                    time: "5m ago"
                )
                
                VoicePreviewRow(
                    botName: "Speed Demon",
                    emoji: "⚡",
                    message: "SPEED UP! Market's moving fast! ⚡",
                    time: "8m ago"
                )
            }
            
            NavigationLink(destination: BotVoiceNotesView()) {
                Text("Listen to All Voices 🎧")
                    .font(.headline.bold())
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.purple)
                    .foregroundColor(.white)
                    .cornerRadius(15)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(15)
    }
    
    private var walletPreview: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("💰 Planet Wallet")
                .font(.title2.bold())
            
            VStack(spacing: 12) {
                WalletPreviewCard(
                    title: "Trading Fuel",
                    balance: "$12,847.50",
                    change: "Ready to trade",
                    color: .orange
                )
                
                WalletPreviewCard(
                    title: "Bot Earnings",
                    balance: "$34,481.70",
                    change: "+$2,847.30 today",
                    color: .green
                )
            }
            
            NavigationLink(destination: WalletDashboardView()) {
                Text("Manage Wallet 💳")
                    .font(.headline.bold())
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.gold)
                    .foregroundColor(.black)
                    .cornerRadius(15)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(15)
    }
    
    private var bottomTabBar: some View {
        HStack(spacing: 0) {
            ForEach(DashboardTab.allCases, id: \.self) { tab in
                Button(action: {
                    withAnimation(.spring(dampingFraction: 0.8)) {
                        selectedTab = tab
                    }
                }) {
                    VStack(spacing: 4) {
                        Text(tab.emoji)
                            .font(.title3)
                            .scaleEffect(selectedTab == tab ? 1.2 : 1.0)
                        
                        Text(tab.title)
                            .font(.caption2.bold())
                            .foregroundColor(selectedTab == tab ? .blue : .secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(.ultraThinMaterial)
    }
    
    private var planetBackground: some View {
        ZStack {
            LinearGradient(
                colors: [.black, .purple.opacity(0.3), .blue.opacity(0.2), .black],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Floating money symbols
            ForEach(0..<15, id: \.self) { i in
                Text(["💰", "💎", "🚀", "⚡", "🔥", "💯"].randomElement() ?? "💰")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.1))
                    .position(
                        x: CGFloat.random(in: 0...400),
                        y: CGFloat.random(in: 0...900)
                    )
                    .opacity(animateElements ? 0.3 : 0.1)
                    .animation(
                        .easeInOut(duration: Double.random(in: 3...6))
                        .delay(Double.random(in: 0...3))
                        .repeatForever(autoreverses: true),
                        value: animateElements
                    )
            }
        }
    }
    
    private func startAnimations() {
        withAnimation(.easeInOut(duration: 0.8)) {
            animateElements = true
        }
        
        withAnimation(.linear(duration: 20).repeatForever(autoreverses: false)) {
            rotatingPlanet = true
        }
    }
}

// MARK: - Supporting Views

struct PlanetStatCard: View {
    let title: String
    let value: String
    let change: String
    let emoji: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(emoji)
                .font(.title2)
            
            Text(value)
                .font(.headline.bold())
                .foregroundColor(color)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(change)
                .font(.caption.bold())
                .foregroundColor(.green)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.ultraThinMaterial.opacity(0.7))
        .cornerRadius(15)
    }
}

struct CommandCard: View {
    let title: String
    let subtitle: String
    let emoji: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(emoji)
                .font(.title)
            
            Text(title)
                .font(.subheadline.bold())
                .multilineTextAlignment(.center)
            
            Text(subtitle)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(color.opacity(0.3), lineWidth: 1)
        )
    }
}

struct QuickActionButton: View {
    let title: String
    let emoji: String
    let color: Color
    
    var body: some View {
        Button(action: {}) {
            VStack(spacing: 6) {
                Text(emoji)
                    .font(.title2)
                
                Text(title)
                    .font(.caption.bold())
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(color.opacity(0.8))
            .foregroundColor(.white)
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    init(title: String, emoji: String, color: Color) {
        self.title = title
        self.emoji = emoji
        self.color = color
    }
    
    init(title: String, icon: String, count: Int, action: @escaping () -> Void) {
        self.title = title
        self.emoji = icon
        self.color = .blue
        
        DispatchQueue.main.async {
            action()
        }
    }
}

struct ArenaPreviewRow: View {
    let rank: Int
    let name: String
    let emoji: String
    let profit: String
    let badge: String
    
    var body: some View {
        HStack {
            Text(badge)
                .font(.title3)
            
            Text(emoji)
                .font(.title3)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .font(.subheadline.bold())
                
                Text("Rank #\(rank)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(profit)
                .font(.subheadline.bold())
                .foregroundColor(.green)
        }
        .padding(.vertical, 4)
    }
}

struct MicroFlipCard: View {
    let type: String
    let duration: String
    let entry: String
    let target: String
    let emoji: String
    
    var body: some View {
        VStack(spacing: 8) {
            Text(emoji)
                .font(.title)
            
            Text(type)
                .font(.caption.bold())
            
            VStack(spacing: 4) {
                Text("\(entry) → \(target)")
                    .font(.caption2.bold())
                    .foregroundColor(.blue)
                
                Text(duration)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.blue.opacity(0.1))
        .cornerRadius(12)
    }
}

struct VoicePreviewRow: View {
    let botName: String
    let emoji: String
    let message: String
    let time: String
    
    var body: some View {
        HStack {
            Text(emoji)
                .font(.title3)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(botName)
                    .font(.caption.bold())
                
                Text(message)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            
            Spacer()
            
            Text(time)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 2)
    }
}

struct WalletPreviewCard: View {
    let title: String
    let balance: String
    let change: String
    let color: Color
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline.bold())
                
                Text(change)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(balance)
                .font(.headline.bold())
                .foregroundColor(color)
        }
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
}

extension Color {
    static let gold = Color(red: 1.0, green: 0.84, blue: 0.0)
}

#Preview {
    EnhancedHomeDashboardView()
        .background(Color.black)
}