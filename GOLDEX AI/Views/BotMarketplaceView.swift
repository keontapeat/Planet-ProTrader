//
//  BotMarketplaceView.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 1/25/25.
//

import SwiftUI

struct BotMarketplaceView: View {
    @StateObject private var marketplaceManager = BotMarketplaceManager()
    @State private var selectedBot: MarketplaceBot?
    @State private var showingBotDetail = false
    @State private var showingFilters = false
    @State private var showingHireBot = false
    @State private var selectedTab = 0
    @State private var animatingCards = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Market status header
                marketStatusHeader
                
                // Tab selector
                tabSelector
                
                // Content based on selected tab
                TabView(selection: $selectedTab) {
                    // Available Bots
                    availableBotsTab
                        .tag(0)
                    
                    // My Hired Bots
                    hiredBotsTab
                        .tag(1)
                    
                    // Top Performers
                    topPerformersTab
                        .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
            .navigationTitle("Elite Bot Marketplace")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button("Filter Bots", systemImage: "line.3.horizontal.decrease") {
                            showingFilters = true
                        }
                        
                        Menu("Sort By") {
                            ForEach(BotMarketplaceManager.SortOption.allCases, id: \.rawValue) { option in
                                Button(action: {
                                    marketplaceManager.sortOption = option
                                }) {
                                    HStack {
                                        Text(option.rawValue)
                                        Image(systemName: option.systemImage)
                                        if marketplaceManager.sortOption == option {
                                            Image(systemName: "checkmark")
                                        }
                                    }
                                }
                            }
                        }
                        
                        Button("Refresh Data", systemImage: "arrow.clockwise") {
                            // Refresh logic
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .foregroundColor(DesignSystem.primaryGold)
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Search") {
                        // Focus search
                    }
                    .foregroundColor(DesignSystem.primaryGold)
                }
            }
            .searchable(text: $marketplaceManager.searchQuery, prompt: "Search bots...")
        }
        .sheet(isPresented: $showingBotDetail) {
            if let bot = selectedBot {
                BotDetailView(bot: bot, marketplaceManager: marketplaceManager)
            }
        }
        .sheet(isPresented: $showingFilters) {
            BotFiltersView(filters: $marketplaceManager.selectedFilters)
        }
        .sheet(isPresented: $showingHireBot) {
            if let bot = selectedBot {
                HireBotView(bot: bot, marketplaceManager: marketplaceManager)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0)) {
                animatingCards = true
            }
        }
    }
    
    // MARK: - Market Status Header
    
    private var marketStatusHeader: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("💎 Available Bots")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("\(marketplaceManager.availableBots.count)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                }
                
                Spacer()
                
                VStack(alignment: .center, spacing: 4) {
                    Text("🔥 Top Earner Today")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("+$47,230")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("⚡ Hiring Now")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("\(marketplaceManager.hiredBots.count)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(DesignSystem.primaryGold)
                }
            }
            
            // Quick stats
            HStack(spacing: 16) {
                quickStat(title: "Avg. Win Rate", value: "87.3%", color: .green)
                quickStat(title: "Total Profits", value: "$12.4M", color: DesignSystem.primaryGold)
                quickStat(title: "Active Now", value: "142", color: .orange)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
    }
    
    private func quickStat(title: String, value: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(color)
            
            Text(title)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Tab Selector
    
    private var tabSelector: some View {
        HStack(spacing: 0) {
            ForEach(["Available", "My Bots", "Top Performers"], id: \.self) { title in
                let index = ["Available", "My Bots", "Top Performers"].firstIndex(of: title) ?? 0
                
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        selectedTab = index
                    }
                }) {
                    VStack(spacing: 6) {
                        Image(systemName: tabIcon(for: index))
                            .font(.title3)
                        
                        Text(title)
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                    .foregroundColor(selectedTab == index ? DesignSystem.primaryGold : .secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                }
            }
        }
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
        .padding(.bottom, 8)
    }
    
    private func tabIcon(for index: Int) -> String {
        switch index {
        case 0: return "robot.fill"
        case 1: return "person.crop.circle.badge.checkmark"
        case 2: return "crown.fill"
        default: return "circle"
        }
    }
    
    // MARK: - Available Bots Tab
    
    private var availableBotsTab: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                // Featured bot section
                if let featuredBot = marketplaceManager.filteredBots.first {
                    featuredBotCard(featuredBot)
                }
                
                // Regular bot cards
                ForEach(marketplaceManager.filteredBots.dropFirst()) { bot in
                    botMarketplaceCard(bot)
                        .scaleEffect(animatingCards ? 1.0 : 0.9)
                        .animation(.bouncy(duration: 0.8).delay(Double.random(in: 0...0.5)), value: animatingCards)
                }
            }
            .padding()
        }
    }
    
    private func featuredBotCard(_ bot: MarketplaceBot) -> some View {
        VStack(spacing: 0) {
            // Featured badge
            HStack {
                Text("⭐ FEATURED BOT")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(DesignSystem.primaryGold)
                    .cornerRadius(8)
                
                Spacer()
                
                Text(bot.popularityLevel.emoji)
                    .font(.title2)
            }
            .padding()
            .background(
                LinearGradient(
                    colors: [DesignSystem.primaryGold.opacity(0.1), .clear],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            
            // Bot info
            botMarketplaceCard(bot, isFeatured: true)
        }
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(color: DesignSystem.primaryGold.opacity(0.2), radius: 12, x: 0, y: 6)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(DesignSystem.primaryGold.opacity(0.3), lineWidth: 2)
        )
    }
    
    private func botMarketplaceCard(_ bot: MarketplaceBot, isFeatured: Bool = false) -> some View {
        Button(action: {
            selectedBot = bot
            showingBotDetail = true
            HapticFeedbackManager.shared.impact(.light)
        }) {
            VStack(spacing: 16) {
                // Header with avatar and basic info
                HStack(spacing: 12) {
                    // Bot avatar (would be AI generated)
                    ZStack {
                        Circle()
                            .fill(bot.gradeColor.opacity(0.2))
                            .frame(width: 60, height: 60)
                        
                        Text("🤖")
                            .font(.title)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(bot.name)
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            
                            Text(bot.performanceGrade)
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(bot.gradeColor)
                                .cornerRadius(4)
                        }
                        
                        Text(bot.nickname)
                            .font(.subheadline)
                            .foregroundColor(bot.gradeColor)
                            .fontWeight(.medium)
                        
                        HStack {
                            Text("by \(bot.ownerName)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            HStack(spacing: 2) {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                    .font(.caption2)
                                
                                Text(String(format: "%.1f", bot.averageRating))
                                    .font(.caption)
                                    .fontWeight(.medium)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text(bot.formattedEarnings)
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                        
                        Text("Total Earned")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        
                        if bot.isAvailable {
                            Text("AVAILABLE")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundColor(.green)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.green.opacity(0.1))
                                .cornerRadius(4)
                        } else {
                            Text("BUSY")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundColor(.orange)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.orange.opacity(0.1))
                                .cornerRadius(4)
                        }
                    }
                }
                
                // Performance stats
                HStack(spacing: 20) {
                    statItem(
                        title: "Win Rate",
                        value: "\(Int(bot.winRate))%",
                        icon: "target",
                        color: .blue
                    )
                    
                    statItem(
                        title: "Avg Return",
                        value: "\(String(format: "%.1f", bot.averageReturn))%",
                        icon: "chart.line.uptrend.xyaxis",
                        color: .green
                    )
                    
                    statItem(
                        title: "Risk Level",
                        value: bot.riskLevel.emoji,
                        icon: "exclamationmark.triangle",
                        color: bot.riskLevel.color
                    )
                    
                    statItem(
                        title: "Followers",
                        value: "\(bot.followerCount > 1000 ? "\(bot.followerCount/1000)K" : "\(bot.followerCount)")",
                        icon: "heart.fill",
                        color: .red
                    )
                }
                
                // Hiring info
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Hiring Fee: $\(Int(bot.hiringFee))")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        Text("$\(Int(bot.dailyRate))/day")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Button(bot.isAvailable ? "Hire Now" : "View Details") {
                        if bot.isAvailable {
                            selectedBot = bot