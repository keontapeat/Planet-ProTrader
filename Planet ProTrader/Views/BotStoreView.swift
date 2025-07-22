//
//  BotStoreView.swift
//  Planet ProTrader
//
//  Created by AI Assistant on 7/18/25.
//

import SwiftUI
import Foundation

struct BotStoreView: View {
    @StateObject private var storeService = BotStoreService.shared
    @State private var selectedBot: MarketplaceBotModel?
    @State private var showingBotDetail = false
    @State private var showingFilters = false
    @State private var animateCards = false
    @State private var selectedCard: UUID?
    
    let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Search and filters header
                searchAndFiltersHeader
                
                // Category selector
                categorySelector
                
                // Store content
                ScrollView {
                    if storeService.isLoading {
                        loadingView
                    } else if let errorMessage = storeService.errorMessage {
                        errorView(errorMessage)
                    } else {
                        mainContentView
                    }
                }
                .refreshable {
                    await storeService.refreshData()
                }
            }
            .navigationTitle("🛒 Bot Store")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Filters") {
                        showingFilters = true
                    }
                    .foregroundColor(DesignSystem.primaryGold)
                }
            }
            .onAppear {
                startAnimations()
            }
        }
        .sheet(isPresented: $showingBotDetail) {
            if let bot = selectedBot {
                MarketplaceBotDetailView(bot: bot)
            }
        }
        .sheet(isPresented: $showingFilters) {
            BotStoreFiltersView()
        }
    }
    
    // MARK: - Main Content Views
    
    private var mainContentView: some View {
        VStack(spacing: 20) {
            // Featured section (if showing all or featured)
            if storeService.selectedCategory == .all || storeService.selectedCategory == .featured {
                featuredBotsSection
            }
            
            // Main bot grid
            botGridSection
        }
        .padding()
    }
    
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)
            
            Text("Loading bots...")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.top, 100)
    }
    
    private func errorView(_ message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 48))
                .foregroundColor(.orange)
            
            Text("Error")
                .font(.headline)
                .foregroundColor(.primary)
            
            Text(message)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button("Try Again") {
                Task {
                    await storeService.refreshData()
                }
            }
            .foregroundColor(DesignSystem.primaryGold)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.top, 100)
    }
    
    // MARK: - Search and Filters Header
    
    private var searchAndFiltersHeader: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                
                TextField("Search bots...", text: $storeService.searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                
                if !storeService.searchText.isEmpty {
                    Button("Clear") {
                        storeService.searchText = ""
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            
            // Active filters
            if storeService.selectedRarity != nil || storeService.selectedTier != nil {
                activeFiltersView
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 8)
    }
    
    private var activeFiltersView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                if let rarity = storeService.selectedRarity {
                    filterChip(title: rarity.rawValue, color: rarity.color) {
                        storeService.selectedRarity = nil
                    }
                }
                
                if let tier = storeService.selectedTier {
                    filterChip(title: tier.rawValue, color: tier.color) {
                        storeService.selectedTier = nil
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    private func filterChip(title: String, color: Color, onRemove: @escaping () -> Void) -> some View {
        HStack(spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.white)
            
            Button(action: onRemove) {
                Image(systemName: "xmark.circle.fill")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(color)
        .cornerRadius(12)
    }
    
    // MARK: - Category Selector
    
    private var categorySelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(BotStoreService.BotStoreCategory.allCases, id: \.self) { category in
                    categoryButton(category: category)
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 8)
    }
    
    private func categoryButton(category: BotStoreService.BotStoreCategory) -> some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.3)) {
                storeService.selectedCategory = category
            }
        }) {
            VStack(spacing: 4) {
                Image(systemName: category.icon)
                    .font(.title2)
                    .foregroundColor(storeService.selectedCategory == category ? .white : DesignSystem.primaryGold)
                
                Text(category.rawValue)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(storeService.selectedCategory == category ? .white : .primary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                storeService.selectedCategory == category 
                ? DesignSystem.primaryGold 
                : DesignSystem.primaryGold.opacity(0.1)
            )
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // MARK: - Featured Bots Section
    
    private var featuredBotsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("⭐ FEATURED BOTS")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(DesignSystem.primaryGold)
                
                Spacer()
                
                Text("HOT 🔥")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.red)
                    .cornerRadius(8)
            }
            
            if storeService.featuredBots.isEmpty {
                Text("No featured bots available")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 20)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(storeService.featuredBots) { bot in
                            featuredBotCard(bot: bot)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
    
    private func featuredBotCard(bot: MarketplaceBotModel) -> some View {
        Button(action: {
            selectedBot = bot
            showingBotDetail = true
        }) {
            VStack(spacing: 12) {
                // Bot image/avatar placeholder
                ZStack {
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [bot.rarity.color.opacity(0.8), bot.rarity.color.opacity(0.4)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 200, height: 120)
                        .cornerRadius(12)
                    
                    VStack(spacing: 8) {
                        Text(bot.rarity.sparkleEffect)
                            .font(.title)
                        
                        Text(bot.tier.icon)
                            .font(.title2)
                        
                        Text(bot.rarity.rawValue)
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.black.opacity(0.3))
                            .cornerRadius(4)
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(bot.name)
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                    
                    Text(bot.tagline)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                    
                    HStack {
                        // Star rating
                        HStack(spacing: 2) {
                            ForEach(0..<5) { star in
                                Image(systemName: star < Int(bot.averageRating) ? "star.fill" : "star")
                                    .font(.caption2)
                                    .foregroundColor(.yellow)
                            }
                        }
                        
                        Spacer()
                        
                        Text(bot.formattedPrice)
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(DesignSystem.primaryGold)
                    }
                }
                .frame(width: 200)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(bot.rarity.color, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // MARK: - Bot Grid Section
    
    private var botGridSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("🤖 ALL BOTS")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Text("\(storeService.filteredBots().count) bots")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            if storeService.filteredBots().isEmpty {
                emptyStateView
            } else {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(storeService.filteredBots()) { bot in
                        botCard(bot: bot)
                            .scaleEffect(selectedCard == bot.id ? 1.05 : 1.0)
                            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: selectedCard)
                    }
                }
            }
        }
    }
    
    private func botCard(bot: MarketplaceBotModel) -> some View {
        Button(action: {
            selectedCard = bot.id
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                selectedCard = nil
                selectedBot = bot
                showingBotDetail = true
            }
        }) {
            VStack(spacing: 12) {
                // Header with rarity and verification
                HStack {
                    Text(bot.rarity.sparkleEffect)
                        .font(.title2)
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Image(systemName: bot.verificationStatus.icon)
                            .font(.caption)
                            .foregroundColor(bot.verificationStatus.color)
                        
                        Text(bot.availability.rawValue)
                            .font(.caption2)
                            .foregroundColor(bot.availability.color)
                    }
                }
                
                // Bot avatar
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(
                            LinearGradient(
                                colors: [bot.rarity.color.opacity(0.3), bot.rarity.color.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(height: 60)
                    
                    Text(bot.tier.icon)
                        .font(.title)
                }
                
                // Bot info
                VStack(alignment: .leading, spacing: 6) {
                    Text(bot.name)
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                    
                    Text("by \(bot.creatorUsername)")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    
                    // Stats
                    VStack(spacing: 4) {
                        HStack {
                            Text("Return:")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            Text(bot.stats.formattedTotalReturn)
                                .font(.caption2)
                                .fontWeight(.medium)
                                .foregroundColor(bot.stats.totalReturn >= 0 ? .green : .red)
                        }
                        
                        HStack {
                            Text("Win Rate:")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            Text(String(format: "%.0f%%", bot.stats.winRate))
                                .font(.caption2)
                                .fontWeight(.medium)
                                .foregroundColor(.blue)
                        }
                        
                        HStack {
                            Text("Users:")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            Text("\(bot.stats.totalUsers)")
                                .font(.caption2)
                                .fontWeight(.medium)
                                .foregroundColor(.purple)
                        }
                    }
                    
                    // Price
                    HStack {
                        Text(bot.formattedPrice)
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(DesignSystem.primaryGold)
                        
                        Spacer()
                        
                        // Star rating
                        HStack(spacing: 1) {
                            ForEach(0..<5) { star in
                                Image(systemName: star < Int(bot.averageRating) ? "star.fill" : "star")
                                    .font(.caption2)
                                    .foregroundColor(.yellow)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(bot.rarity.color.opacity(0.5), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "robot")
                .font(.system(size: 48))
                .foregroundColor(.secondary)
            
            Text("No bots found")
                .font(.headline)
                .foregroundColor(.secondary)
            
            Text("Try adjusting your filters or search terms")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button("Clear Filters") {
                storeService.clearFilters()
            }
            .foregroundColor(DesignSystem.primaryGold)
        }
        .padding(.top, 50)
    }
    
    // MARK: - Helper Methods
    
    private func startAnimations() {
        withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
            animateCards = true
        }
    }
}

// MARK: - Bot Store Filters View

struct BotStoreFiltersView: View {
    @StateObject private var storeService = BotStoreService.shared
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Rarity filter
                    rarityFilterSection
                    
                    // Tier filter
                    tierFilterSection
                    
                    // Price range filter
                    priceRangeSection
                    
                    // Availability filter
                    availabilitySection
                }
                .padding()
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Reset") {
                        resetFilters()
                    }
                    .foregroundColor(.secondary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(DesignSystem.primaryGold)
                }
            }
        }
    }
    
    private var rarityFilterSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Bot Rarity")
                .font(.headline)
                .fontWeight(.bold)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                ForEach(BotRarity.allCases, id: \.self) { rarity in
                    Button(action: {
                        storeService.selectedRarity = storeService.selectedRarity == rarity ? nil : rarity
                    }) {
                        VStack(spacing: 8) {
                            Text(rarity.sparkleEffect)
                                .font(.title2)
                            
                            Text(rarity.rawValue)
                                .font(.caption)
                                .fontWeight(.medium)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            storeService.selectedRarity == rarity 
                            ? rarity.color.opacity(0.3) 
                            : Color(.systemGray6)
                        )
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(
                                    storeService.selectedRarity == rarity ? rarity.color : Color.clear, 
                                    lineWidth: 2
                                )
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
    
    private var tierFilterSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Bot Tier")
                .font(.headline)
                .fontWeight(.bold)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                ForEach(BotTier.allCases, id: \.self) { tier in
                    Button(action: {
                        storeService.selectedTier = storeService.selectedTier == tier ? nil : tier
                    }) {
                        VStack(spacing: 8) {
                            Text(tier.icon)
                                .font(.title2)
                            
                            Text(tier.rawValue)
                                .font(.caption)
                                .fontWeight(.medium)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            storeService.selectedTier == tier 
                            ? tier.color.opacity(0.3) 
                            : Color(.systemGray6)
                        )
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(
                                    storeService.selectedTier == tier ? tier.color : Color.clear, 
                                    lineWidth: 2
                                )
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
    
    private var priceRangeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Price Range")
                .font(.headline)
                .fontWeight(.bold)
            
            VStack(spacing: 8) {
                priceRangeButton(title: "Free", range: nil)
                priceRangeButton(title: "$1 - $50", range: 1...50)
                priceRangeButton(title: "$51 - $200", range: 51...200)
                priceRangeButton(title: "$201 - $500", range: 201...500)
                priceRangeButton(title: "$500+", range: 500...999999)
            }
        }
    }
    
    private func priceRangeButton(title: String, range: ClosedRange<Double>?) -> some View {
        Button(action: {
            // Handle price range selection - implement if needed
        }) {
            HStack {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(8)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var availabilitySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Availability")
                .font(.headline)
                .fontWeight(.bold)
            
            VStack(spacing: 8) {
                ForEach(BotAvailability.allCases, id: \.self) { availability in
                    availabilityButton(availability: availability)
                }
            }
        }
    }
    
    private func availabilityButton(availability: BotAvailability) -> some View {
        Button(action: {
            // Handle availability selection - implement if needed
        }) {
            HStack(spacing: 12) {
                Image(systemName: availability.icon)
                    .foregroundColor(availability.color)
                
                Text(availability.rawValue)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                
                Spacer()
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(8)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func resetFilters() {
        storeService.clearFilters()
    }
}

// MARK: - ✅ FIXED PREVIEW

#Preview {
    BotStoreView()
}