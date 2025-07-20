//
//  BotMarketplaceView.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 1/25/25.
//

import SwiftUI

struct BotMarketplaceView: View {
    @StateObject private var marketplaceManager = BotMarketplaceManager()
    @State private var selectedBot: MarketplaceBotModel?
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
            .navigationTitle("MarketX")
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
                            marketplaceManager.refreshData()
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .foregroundColor(DesignSystem.primaryGold)
                    }
                }
            }
            .searchable(text: $marketplaceManager.searchQuery, prompt: "Search bots...")
        }
        .sheet(isPresented: $showingBotDetail) {
            if let bot = selectedBot {
                MarketplaceBotDetailView(bot: bot)
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
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
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
    
    // MARK: - Tab Views
    private var availableBotsTab: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(marketplaceManager.filteredBots) { bot in
                    botCard(bot)
                        .scaleEffect(animatingCards ? 1.0 : 0.9)
                        .animation(.bouncy(duration: 0.8).delay(Double.random(in: 0...0.5)), value: animatingCards)
                }
            }
            .padding()
        }
    }
    
    private var hiredBotsTab: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(marketplaceManager.hiredBots) { bot in
                    botCard(bot)
                }
            }
            .padding()
        }
    }
    
    private var topPerformersTab: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(marketplaceManager.topPerformers) { bot in
                    botCard(bot)
                }
            }
            .padding()
        }
    }
    
    private func botCard(_ bot: MarketplaceBotModel) -> some View {
        Button(action: {
            selectedBot = bot
            showingBotDetail = true
        }) {
            VStack(spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(bot.name)
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Text(bot.nickname)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text(bot.formattedEarnings)
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                        
                        Text("Win Rate: \(Int(bot.winRate))%")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Placeholder Views
struct BotFiltersView: View {
    @Binding var filters: BotMarketplaceManager.FilterOptions
    
    var body: some View {
        Text("Filters View")
    }
}

struct HireBotView: View {
    let bot: MarketplaceBotModel
    let marketplaceManager: BotMarketplaceManager
    
    var body: some View {
        Text("Hire Bot View")
    }
}

// MARK: - Preview
struct BotMarketplaceView_Previews: PreviewProvider {
    static var previews: some View {
        BotMarketplaceView()
    }
}