//
//  BotStoreView.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 1/27/25.
//  PlayStation Network-Style Bot Store - Hire Elite Trading Machines!
//

import SwiftUI

struct BotStoreView: View {
    // MARK: - State Management
    @StateObject private var storeManager = BotStoreModels.BotStoreManager()
    @StateObject private var imageGenerator = BotImageModels.BotImageGenerator()
    @State private var selectedBot: BotStoreModels.BotListing?
    @State private var showingBotDetail = false
    @State private var showingHireConfirmation = false
    @State private var showingFilters = false
    @State private var animateCards = false
    @State private var selectedCategory: BotStoreCategory = .featured
    
    // MARK: - Bot Store Categories
    enum BotStoreCategory: String, CaseIterable {
        case featured = "FEATURED"
        case available = "AVAILABLE"
        case trending = "TRENDING"
        case moneyHungry = "MONEY_HUNGRY"
        case elite = "ELITE"
        case budget = "BUDGET"
        case specialists = "SPECIALISTS"
        
        var displayName: String {
            switch self {
            case .featured: return "🔥 Featured"
            case .available: return "🟢 Available Now"
            case .trending: return "📈 Trending"
            case .moneyHungry: return "🤑 Money Hungry"
            case .elite: return "👑 Elite Tier"
            case .budget: return "💰 Budget Friendly"
            case .specialists: return "🎯 Specialists"
            }
        }
        
        var icon: String {
            switch self {
            case .featured: return "star.fill"
            case .available: return "checkmark.circle.fill"
            case .trending: return "chart.line.uptrend.xyaxis"
            case .moneyHungry: return "mouth.fill"
            case .elite: return "crown.fill"
            case .budget: return "dollarsign.circle"
            case .specialists: return "target"
            }
        }
        
        var color: Color {
            switch self {
            case .featured: return .gold
            case .available: return .green
            case .trending: return .orange
            case .moneyHungry: return .red
            case .elite: return .purple
            case .budget: return .blue
            case .specialists: return .indigo
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // PlayStation-style background
                psNetworkBackground
                
                ScrollView {
                    LazyVStack(spacing: 0) {
                        // Header Section
                        storeHeader
                        
                        // Category Navigation
                        categoryNavigation
                        
                        // Featured Carousel
                        if selectedCategory == .featured {
                            featuredBotsCarousel
                        }
                        
                        // Bot Grid
                        botGrid
                        
                        Spacer(minLength: 100)
                    }
                }
                .refreshable {
                    await refreshStore()
                }
                
                // Loading Overlay
                if storeManager.isLoading {
                    psLoadingOverlay
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                startAnimations()
            }
        }
        .sheet(isPresented: $showingBotDetail) {
            if let bot = selectedBot {
                BotDetailView(bot: bot, onHire: { hireBot($0) })
            }
        }
        .sheet(isPresented: $showingFilters) {
            BotStoreFiltersView(storeManager: storeManager)
        }
    }
    
    // MARK: - PlayStation Network Background
    private var psNetworkBackground: some View {
        ZStack {
            // Base gradient
            LinearGradient(
                colors: [
                    Color.black,
                    Color(red: 0.1, green: 0.15, blue: 0.3),
                    Color.black
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Animated particles
            ForEach(0..<50, id: \.self) { index in
                PSParticleView(index: index, isAnimating: animateCards)
            }
            
            // PlayStation-style grid overlay
            PSGridOverlay()
        }
    }
    
    // MARK: - Store Header
    private var storeHeader: some View {
        VStack(spacing: 20) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "brain.head.profile")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.cyan)
                        
                        Text("BOT STORE")
                            .font(.system(size: 32, weight: .black, design: .monospaced))
                            .foregroundColor(.white)
                    }
                    
                    Text("Hire Elite Trading Machines")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.cyan)
                }
                
                Spacer()
                
                // User wallet info
                VStack(alignment: .trailing, spacing: 4) {
                    Text("WALLET BALANCE")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.gray)
                    
                    Text("$2,485.75")
                        .font(.system(size: 18, weight: .bold, design: .monospaced))
                        .foregroundColor(.green)
                    
                    Button(action: { /* Add funds */ }) {
                        HStack(spacing: 4) {
                            Image(systemName: "plus.circle")
                            Text("ADD FUNDS")
                        }
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.cyan)
                    }
                }
            }
            
            // Store stats
            HStack(spacing: 30) {
                StoreStatView(
                    title: "AVAILABLE",
                    value: "\(storeManager.totalAvailableBots)",
                    icon: "checkmark.circle.fill",
                    color: .green
                )
                
                StoreStatView(
                    title: "HIRED",
                    value: "\(storeManager.totalHiredBots)",
                    icon: "person.crop.circle.badge.checkmark",
                    color: .blue
                )
                
                StoreStatView(
                    title: "TOTAL SPENT",
                    value: storeManager.formattedTotalSpent,
                    icon: "dollarsign.circle.fill",
                    color: .orange
                )
                
                StoreStatView(
                    title: "ONLINE",
                    value: "24/7",
                    icon: "wifi",
                    color: .cyan
                )
            }
        }
        .padding(20)
        .background(.ultraThinMaterial.opacity(0.3))
        .scaleEffect(animateCards ? 1.0 : 0.95)
        .opacity(animateCards ? 1.0 : 0.0)
    }
    
    // MARK: - Category Navigation
    private var categoryNavigation: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(BotStoreCategory.allCases, id: \.self) { category in
                    CategoryButton(
                        category: category,
                        isSelected: selectedCategory == category
                    ) {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                            selectedCategory = category
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 15)
    }
    
    // MARK: - Featured Bots Carousel
    private var featuredBotsCarousel: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("🔥 FEATURED MONEY MACHINES")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Text("HANDPICKED BY AI")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.gold)
            }
            .padding(.horizontal, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(featuredBots) { bot in
                        FeaturedBotCard(bot: bot) {
                            selectedBot = bot
                            showingBotDetail = true
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.9)
        .opacity(animateCards ? 1.0 : 0.0)
    }
    
    // MARK: - Bot Grid
    private var botGrid: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(selectedCategory.displayName)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: { showingFilters = true }) {
                    HStack(spacing: 8) {
                        Image(systemName: "line.3.horizontal.decrease")
                        Text("FILTERS")
                    }
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.cyan)
                }
            }
            .padding(.horizontal, 20)
            
            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2),
                spacing: 20
            ) {
                ForEach(filteredBots) { bot in
                    BotStoreCard(bot: bot) {
                        selectedBot = bot
                        showingBotDetail = true
                    }
                    .scaleEffect(animateCards ? 1.0 : 0.8)
                    .opacity(animateCards ? 1.0 : 0.0)
                    .animation(
                        .spring(response: 0.6, dampingFraction: 0.8)
                            .delay(Double(filteredBots.firstIndex(of: bot) ?? 0) * 0.1),
                        value: animateCards
                    )
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
    // MARK: - PlayStation Loading Overlay
    private var psLoadingOverlay: some View {
        ZStack {
            Color.black.opacity(0.8)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // PlayStation-style loading animation
                ZStack {
                    ForEach(0..<4) { index in
                        Circle()
                            .fill(Color.cyan)
                            .frame(width: 12, height: 12)
                            .offset(x: 40)
                            .rotationEffect(.degrees(Double(index) * 90))
                            .opacity(0.8)
                    }
                }
                .rotationEffect(.degrees(storeManager.isLoading ? 360 : 0))
                .animation(.linear(duration: 1.0).repeatForever(autoreverses: false), value: storeManager.isLoading)
                
                Text("LOADING BOT STORE...")
                    .font(.system(size: 16, weight: .bold, design: .monospaced))
                    .foregroundColor(.cyan)
                
                Text("CONNECTING TO TRADING NETWORK")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.gray)
            }
            .padding(40)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
    
    // MARK: - Computed Properties
    private var featuredBots: [BotStoreModels.BotListing] {
        storeManager.filteredBots().filter { 
            $0.isPopular || $0.isTrending 
        }.prefix(5).map { $0 }
    }
    
    private var filteredBots: [BotStoreModels.BotListing] {
        let filtered = storeManager.filteredBots()
        
        switch selectedCategory {
        case .featured:
            return Array(filtered.prefix(10))
        case .available:
            return filtered.filter { $0.availability.canHire }
        case .trending:
            return filtered.filter { $0.isTrending }
        case .moneyHungry:
            return filtered.filter { $0.personality.greed >= 8 }
        case .elite:
            return filtered.filter { $0.performance.performanceGrade == .S || $0.performance.performanceGrade == .A }
        case .budget:
            return filtered.filter { $0.affordabilityLevel == .budget }
        case .specialists:
            return filtered.filter { !$0.specialties.isEmpty }
        }
    }
    
    // MARK: - Helper Methods
    private func startAnimations() {
        withAnimation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.2)) {
            animateCards = true
        }
    }
    
    private func refreshStore() async {
        storeManager.loadBotListings()
    }
    
    private func hireBot(_ bot: BotStoreModels.BotListing) {
        Task {
            await storeManager.hireBot(bot, duration: .weekly)
        }
    }
}

// MARK: - Supporting Views

struct PSParticleView: View {
    let index: Int
    let isAnimating: Bool
    
    @State private var position = CGPoint.zero
    @State private var opacity: Double = 0
    
    var body: some View {
        Circle()
            .fill(
                LinearGradient(
                    colors: [.cyan, .blue, .purple].randomElement() ?? .cyan,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(width: CGFloat.random(in: 2...6), height: CGFloat.random(in: 2...6))
            .position(position)
            .opacity(opacity)
            .onAppear {
                startFloating()
            }
    }
    
    private func startFloating() {
        position = CGPoint(
            x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
            y: UIScreen.main.bounds.height + 50
        )
        
        withAnimation(
            .linear(duration: Double.random(in: 15...25))
                .repeatForever(autoreverses: false)
                .delay(Double(index) * 0.5)
        ) {
            position = CGPoint(
                x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                y: -50
            )
        }
        
        withAnimation(.easeInOut(duration: 2.0).delay(Double(index) * 0.5)) {
            opacity = Double.random(in: 0.3...0.8)
        }
    }
}

struct PSGridOverlay: View {
    var body: some View {
        ZStack {
            // Vertical lines
            ForEach(0..<20) { index in
                Rectangle()
                    .fill(Color.cyan.opacity(0.1))
                    .frame(width: 1)
                    .offset(x: CGFloat(index * 40) - UIScreen.main.bounds.width/2)
            }
            
            // Horizontal lines  
            ForEach(0..<30) { index in
                Rectangle()
                    .fill(Color.cyan.opacity(0.1))
                    .frame(height: 1)
                    .offset(y: CGFloat(index * 40) - UIScreen.main.bounds.height/2)
            }
        }
        .ignoresSafeArea()
    }
}

struct StoreStatView: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(color)
            
            Text(value)
                .font(.system(size: 14, weight: .bold, design: .monospaced))
                .foregroundColor(.white)
            
            Text(title)
                .font(.system(size: 8, weight: .medium))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
    }
}

struct CategoryButton: View {
    let category: BotStoreView.BotStoreCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: category.icon)
                    .font(.system(size: 14, weight: .bold))
                
                Text(category.displayName)
                    .font(.system(size: 12, weight: .bold))
            }
            .foregroundColor(isSelected ? .black : category.color)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(isSelected ? category.color : Color.clear)
                    .stroke(category.color, lineWidth: 2)
            )
        }
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

struct FeaturedBotCard: View {
    let bot: BotStoreModels.BotListing
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                // Card background with PlayStation styling
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.black.opacity(0.8),
                                Color.purple.opacity(0.3),
                                Color.black.opacity(0.8)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 280, height: 200)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(
                                LinearGradient(
                                    colors: [.cyan, .purple, .cyan],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 2
                            )
                    )
                
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        // Bot Avatar
                        ZStack {
                            Circle()
                                .fill(bot.performance.performanceGrade.color)
                                .frame(width: 50, height: 50)
                            
                            Text(bot.botName.prefix(2))
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(bot.botName)
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                                .lineLimit(1)
                            
                            Text(bot.botNickname)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.cyan)
                                .lineLimit(1)
                        }
                        
                        Spacer()
                        
                        // Performance grade
                        Text(bot.performance.performanceGrade.rawValue)
                            .font(.system(size: 20, weight: .black))
                            .foregroundColor(bot.performance.performanceGrade.color)
                    }
                    
                    // Stats
                    HStack {
                        StatBadge(title: "Win Rate", value: bot.performance.formattedStats["Win Rate"] ?? "0%", color: .green)
                        StatBadge(title: "Profit", value: bot.performance.formattedStats["Total Profit"] ?? "$0", color: .gold)
                        StatBadge(title: "Hunger", value: "\(bot.personality.greed)/10", color: .red)
                    }
                    
                    // Price and hire button
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("HIRE FOR")
                                .font(.system(size: 8, weight: .bold))
                                .foregroundColor(.gray)
                            
                            Text(bot.price.formattedPrice)
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        Text(bot.availability.displayName)
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(bot.availability.color)
                    }
                }
                .padding(16)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct BotStoreCard: View {
    let bot: BotStoreModels.BotListing
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                // Bot image placeholder with PlayStation styling
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(
                            LinearGradient(
                                colors: [
                                    bot.performance.performanceGrade.color.opacity(0.3),
                                    Color.black.opacity(0.8)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(height: 120)
                    
                    VStack {
                        // Bot avatar
                        ZStack {
                            Circle()
                                .fill(bot.performance.performanceGrade.color)
                                .frame(width: 50, height: 50)
                            
                            Text(bot.botName.prefix(2))
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                        }
                        
                        // Performance grade
                        Text(bot.performance.performanceGrade.rawValue)
                            .font(.system(size: 16, weight: .black))
                            .foregroundColor(bot.performance.performanceGrade.color)
                    }
                    
                    // Availability indicator
                    VStack {
                        HStack {
                            Spacer()
                            
                            Circle()
                                .fill(bot.availability.color)
                                .frame(width: 12, height: 12)
                                .overlay(
                                    Circle()
                                        .stroke(Color.white, lineWidth: 2)
                                )
                        }
                        
                        Spacer()
                    }
                    .padding(8)
                }
                
                // Bot info
                VStack(alignment: .leading, spacing: 6) {
                    Text(bot.botName)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                        .lineLimit(1)
                    
                    Text(bot.botNickname)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.cyan)
                        .lineLimit(2)
                    
                    // Quick stats
                    HStack {
                        MiniStatView(icon: "target", value: bot.performance.formattedStats["Win Rate"] ?? "0%")
                        MiniStatView(icon: "dollarsign.circle", value: bot.performance.formattedStats["Total Profit"] ?? "$0")
                    }
                    
                    // Price
                    HStack {
                        Text(bot.price.formattedPrice)
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.green)
                        
                        Spacer()
                        
                        if bot.availability.canHire {
                            Text("HIRE NOW")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.cyan)
                        } else {
                            Text("UNAVAILABLE")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.red)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.ultraThinMaterial.opacity(0.3))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(bot.performance.performanceGrade.color.opacity(0.5), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct StatBadge: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 2) {
            Text(title)
                .font(.system(size: 8, weight: .medium))
                .foregroundColor(.gray)
            
            Text(value)
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(color)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(.ultraThinMaterial.opacity(0.3))
        .clipShape(Capsule())
    }
}

struct MiniStatView: View {
    let icon: String
    let value: String
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 10))
                .foregroundColor(.cyan)
            
            Text(value)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.white)
        }
    }
}

// MARK: - Preview

#Preview("Bot Store") {
    BotStoreView()
        .preferredColorScheme(.dark)
}