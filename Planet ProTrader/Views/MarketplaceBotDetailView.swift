//
//  MarketplaceBotDetailView.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 7/18/25.
//

import SwiftUI

struct MarketplaceBotDetailView: View {
    let bot: MarketplaceBotModel
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTab = 0
    @State private var showingHireFlow = false
    @State private var isLiked = false
    @State private var pulseAnimation = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Bot header with hero image
                botHeroSection
                
                // Tab navigation
                tabNavigation
                
                // Content based on selected tab
                TabView(selection: $selectedTab) {
                    // Overview tab
                    overviewTab
                        .tag(0)
                    
                    // Performance tab
                    performanceTab
                        .tag(1)
                    
                    // Reviews tab
                    reviewsTab
                        .tag(2)
                    
                    // Abilities tab
                    abilitiesTab
                        .tag(3)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                // Bottom hire button
                hireButtonSection
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(.primary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isLiked.toggle()
                    }) {
                        Image(systemName: isLiked ? "heart.fill" : "heart")
                            .foregroundColor(isLiked ? .red : .primary)
                            .scaleEffect(isLiked ? 1.2 : 1.0)
                            .animation(.spring(response: 0.3, dampingFraction: 0.5), value: isLiked)
                    }
                }
            }
        }
        .sheet(isPresented: $showingHireFlow) {
            BotHireFlowView(bot: bot)
        }
        .onAppear {
            startAnimations()
        }
    }
    
    // MARK: - Bot Hero Section
    
    private var botHeroSection: some View {
        VStack(spacing: 16) {
            // Rarity background with sparkles
            ZStack {
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [bot.rarity.color.opacity(0.8), bot.rarity.color.opacity(0.3)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: 200)
                
                VStack(spacing: 12) {
                    // Rarity sparkles
                    Text(bot.rarity.sparkleEffect)
                        .font(.system(size: 48))
                        .scaleEffect(pulseAnimation ? 1.1 : 1.0)
                        .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: pulseAnimation)
                    
                    // Bot tier icon
                    Text(bot.tier.icon)
                        .font(.system(size: 64))
                    
                    // Verification badge
                    HStack(spacing: 4) {
                        Image(systemName: bot.verificationStatus.icon)
                            .font(.caption)
                            .foregroundColor(bot.verificationStatus.color)
                        
                        Text(bot.verificationStatus.rawValue)
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.black.opacity(0.3))
                    .cornerRadius(12)
                }
            }
            
            // Bot info
            VStack(spacing: 8) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(bot.name)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Text("by \(bot.creatorUsername)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text(bot.formattedPrice)
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(DesignSystem.primaryGold)
                        
                        Text(bot.price.pricingModel.rawValue)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Text(bot.tagline)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .italic()
                
                // Quick stats
                HStack(spacing: 24) {
                    quickStat(title: "Return", value: bot.stats.formattedTotalReturn, color: bot.stats.totalReturn >= 0 ? .green : .red)
                    quickStat(title: "Win Rate", value: "\(String(format: "%.0f", bot.stats.winRate))%", color: .blue)
                    quickStat(title: "Users", value: "\(bot.stats.totalUsers)", color: .purple)
                    quickStat(title: "Rating", value: String(format: "%.1f", bot.averageRating), color: .yellow)
                }
            }
            .padding(.horizontal)
        }
    }
    
    private func quickStat(title: String, value: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(color)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
    
    // MARK: - Tab Navigation
    
    private var tabNavigation: some View {
        HStack(spacing: 0) {
            ForEach(["Overview", "Performance", "Reviews", "Abilities"], id: \.self) { title in
                let index = ["Overview", "Performance", "Reviews", "Abilities"].firstIndex(of: title) ?? 0
                
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        selectedTab = index
                    }
                }) {
                    VStack(spacing: 8) {
                        Image(systemName: tabIcon(for: index))
                            .font(.title2)
                        
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
        .padding(.vertical, 8)
    }
    
    private func tabIcon(for index: Int) -> String {
        switch index {
        case 0: return "info.circle.fill"
        case 1: return "chart.xyaxis.line"
        case 2: return "star.fill"
        case 3: return "wand.and.rays"
        default: return "circle"
        }
    }
    
    // MARK: - Overview Tab
    
    private var overviewTab: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Description
                descriptionSection
                
                // Trading style and specialization
                tradingInfoSection
                
                // Contract terms
                contractTermsSection
                
                // Personality
                personalitySection
            }
            .padding()
        }
    }
    
    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("📝 Description")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text(bot.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineSpacing(4)
            
            if !bot.personality.backstory.isEmpty {
                Text("📚 Backstory")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .padding(.top, 8)
                
                Text(bot.personality.backstory)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineSpacing(4)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private var tradingInfoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("⚡ Trading Information")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            VStack(spacing: 8) {
                infoRow(title: "Strategy", value: bot.tradingStyle.displayName, color: bot.tradingStyle.color)
                infoRow(title: "Risk Appetite", value: bot.personality.riskAppetite.rawValue, color: .orange)
                infoRow(title: "Communication", value: bot.personality.communicationStyle.rawValue, color: .blue)
                infoRow(title: "Trading Hours", value: bot.contractTerms.tradingHours.rawValue, color: .green)
                infoRow(title: "Support Level", value: bot.contractTerms.supportLevel.rawValue, color: .purple)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private func infoRow(title: String, value: String, color: Color) -> some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.primary)
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(color)
        }
    }
    
    private var contractTermsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("📋 Contract Terms")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            VStack(spacing: 8) {
                contractRow(title: "Minimum Contract", value: "\(bot.contractTerms.minimumContract) days")
                
                if let maxContract = bot.contractTerms.maximumContract {
                    contractRow(title: "Maximum Contract", value: "\(maxContract) days")
                }
                
                contractRow(title: "Cancellation Policy", value: bot.contractTerms.cancellationPolicy.rawValue)
                
                if bot.contractTerms.moneyBackGuarantee, let guaranteePeriod = bot.contractTerms.guaranteePeriod {
                    contractRow(title: "Money-Back Guarantee", value: "\(guaranteePeriod) days")
                }
                
                if let maxUsers = bot.contractTerms.maxUsers {
                    contractRow(title: "Max Users", value: "\(maxUsers) spots")
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private func contractRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .font(.caption)
                .foregroundColor(.primary)
            
            Spacer()
            
            Text(value)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
        }
    }
    
    private var personalitySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("🧠 Personality & Traits")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            VStack(spacing: 12) {
                // Catchphrase
                Text("\"\(bot.personality.catchphrase)\"")
                    .font(.subheadline)
                    .italic()
                    .foregroundColor(DesignSystem.primaryGold)
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(DesignSystem.primaryGold.opacity(0.1))
                    .cornerRadius(8)
                
                // Personality traits
                ForEach(bot.personality.traits, id: \.name) { trait in
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(trait.name)
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            Text(String(format: "%.0f%%", trait.strength * 100))
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(DesignSystem.primaryGold)
                        }
                        
                        ProgressView(value: trait.strength, total: 1.0)
                            .progressViewStyle(LinearProgressViewStyle(tint: DesignSystem.primaryGold))
                            .scaleEffect(y: 0.8)
                        
                        Text(trait.description)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    // MARK: - Performance Tab
    
    private var performanceTab: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Key metrics
                keyMetricsSection
                
                // Trading history
                tradingHistorySection
                
                // Monthly performance
                monthlyPerformanceSection
            }
            .padding()
        }
    }
    
    private var keyMetricsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("📊 Key Performance Metrics")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                performanceMetric(title: "Total Return", value: bot.stats.formattedTotalReturn, color: bot.stats.totalReturn >= 0 ? .green : .red)
                performanceMetric(title: "Monthly Return", value: "+\(String(format: "%.1f", bot.stats.monthlyReturn))%", color: .blue)
                performanceMetric(title: "Win Rate", value: "\(String(format: "%.1f", bot.stats.winRate))%", color: .purple)
                performanceMetric(title: "Sharpe Ratio", value: String(format: "%.2f", bot.stats.sharpeRatio), color: .orange)
                performanceMetric(title: "Max Drawdown", value: "-\(String(format: "%.1f", bot.stats.maxDrawdown))%", color: .red)
                performanceMetric(title: "Profit Factor", value: String(format: "%.2f", bot.stats.profitFactor), color: .green)
                performanceMetric(title: "Total Trades", value: "\(bot.stats.totalTrades)", color: .gray)
                performanceMetric(title: "Universe Rank", value: "#\(bot.stats.universeRank)", color: DesignSystem.primaryGold)
            }
        }
    }
    
    private func performanceMetric(title: String, value: String, color: Color) -> some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(color)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private var tradingHistorySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("📈 Trading History Highlights")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            VStack(spacing: 8) {
                tradeHighlight(title: "Best Trade", trade: bot.tradingHistory.bestTrade, isProfit: true)
                tradeHighlight(title: "Worst Trade", trade: bot.tradingHistory.worstTrade, isProfit: false)
            }
            
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Trading Pairs")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    Text(bot.tradingHistory.tradingPairs.prefix(3).joined(separator: ", "))
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Avg Hold Time")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    Text("\(Int(bot.tradingHistory.averageHoldTime)) min")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private func tradeHighlight(title: String, trade: BotTradingHistory.TradeRecord, isProfit: Bool) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.primary)
            
            HStack {
                Text("\(trade.pair): \(trade.formattedPnL) (\(String(format: "%.2f", trade.percentage))%)")
                    .font(.caption2)
                    .foregroundColor(isProfit ? .green : .red)
                
                Spacer()
                
                Text("\(Int(trade.duration))min")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private var monthlyPerformanceSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("📅 Monthly Performance")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            if bot.tradingHistory.monthlyPerformance.isEmpty {
                Text("Performance data coming soon...")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding()
            } else {
                // Monthly performance chart would go here
                Text("Monthly performance chart placeholder")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding()
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    // MARK: - Reviews Tab
    
    private var reviewsTab: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Review summary
                reviewSummarySection
                
                // Individual reviews
                if bot.reviews.isEmpty {
                    Text("No reviews yet")
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .padding(.top, 50)
                } else {
                    ForEach(bot.reviews) { review in
                        reviewCard(review: review)
                    }
                }
            }
            .padding()
        }
    }
    
    private var reviewSummarySection: some View {
        VStack(spacing: 12) {
            Text("⭐ User Reviews")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            HStack(spacing: 20) {
                VStack(spacing: 4) {
                    Text(String(format: "%.1f", bot.averageRating))
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(DesignSystem.primaryGold)
                    
                    HStack(spacing: 2) {
                        ForEach(0..<5) { star in
                            Image(systemName: star < Int(bot.averageRating) ? "star.fill" : "star")
                                .font(.caption)
                                .foregroundColor(.yellow)
                        }
                    }
                    
                    Text("\(bot.reviews.count) reviews")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Verified Users")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    Text("\(bot.reviews.filter { $0.verified }.count)")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                    
                    Text("Total Profits Made")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    let totalProfits = bot.reviews.compactMap { $0.profitMade }.reduce(0, +)
                    Text("$\(String(format: "%.0f", totalProfits))")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(DesignSystem.primaryGold)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private func reviewCard(review: BotReview) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 8) {
                        Text(review.username)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                        
                        if review.verified {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.caption)
                                .foregroundColor(.green)
                        }
                    }
                    
                    HStack(spacing: 2) {
                        ForEach(0..<5) { star in
                            Image(systemName: star < Int(review.rating) ? "star.fill" : "star")
                                .font(.caption2)
                                .foregroundColor(.yellow)
                        }
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(review.createdDate.formatted(.relative(presentation: .named)))
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    if let profit = review.formattedProfit {
                        Text(profit)
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(review.profitMade ?? 0 >= 0 ? .green : .red)
                    }
                }
            }
            
            Text(review.title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            Text(review.comment)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineSpacing(2)
            
            Text("Contract length: \(review.contractLength) days")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    // MARK: - Abilities Tab
    
    private var abilitiesTab: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(bot.specialAbilities) { ability in
                    abilityCard(ability: ability)
                }
                
                if bot.specialAbilities.isEmpty {
                    Text("No special abilities listed")
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .padding(.top, 50)
                }
            }
            .padding()
        }
    }
    
    private func abilityCard(ability: BotSpecialAbility) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(ability.icon)
                    .font(.title)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(ability.name)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text(ability.rarity.rawValue.uppercased())
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(ability.rarity.color)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(ability.rarity.color.opacity(0.2))
                        .cornerRadius(4)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Effectiveness")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("\(Int(ability.effectiveness * 100))%")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(DesignSystem.primaryGold)
                    
                    if let cooldown = ability.cooldown {
                        Text("\(cooldown)min cooldown")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            Text(ability.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineSpacing(2)
            
            ProgressView(value: ability.effectiveness, total: 1.0)
                .progressViewStyle(LinearProgressViewStyle(tint: ability.rarity.color))
                .scaleEffect(y: 0.8)
        }
        .padding()
        .background(
            LinearGradient(
                colors: [ability.rarity.color.opacity(0.05), Color.clear],
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(ability.rarity.color.opacity(0.3), lineWidth: 1)
        )
    }
    
    // MARK: - Hire Button Section
    
    private var hireButtonSection: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text(bot.formattedPrice)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(DesignSystem.primaryGold)
                
                Text(bot.price.pricingModel.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button("Hire This Bot") {
                showingHireFlow = true
            }
            .buttonStyle(PrimaryButtonStyle())
            .disabled(bot.availability == .soldOut)
        }
        .padding()
        .background(Color(.systemBackground))
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: -5)
    }
    
    // MARK: - Helper Methods
    
    private func startAnimations() {
        pulseAnimation = true
    }
}

// MARK: - Bot Hire Flow View

struct BotHireFlowView: View {
    let bot: MarketplaceBotModel
    @Environment(\.dismiss) private var dismiss
    @State private var selectedPlan = 0
    @State private var acceptedTerms = false
    @State private var isProcessing = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 16) {
                    Text(bot.tier.icon)
                        .font(.system(size: 64))
                    
                    Text("Hire \(bot.name)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("Join \(bot.stats.totalUsers) other successful traders")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                // Pricing options
                VStack(alignment: .leading, spacing: 16) {
                    Text("Choose Your Plan")
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    VStack(spacing: 12) {
                        pricingOption(
                            title: "Monthly",
                            price: bot.formattedPrice,
                            description: "Cancel anytime • 30-day guarantee",
                            isSelected: selectedPlan == 0
                        ) {
                            selectedPlan = 0
                        }
                        
                        if bot.price.pricingModel != .profitShare {
                            pricingOption(
                                title: "3 Months",
                                price: "$\(String(format: "%.0f", bot.price.amount * 2.5))",
                                description: "Save 17% • Best value",
                                isSelected: selectedPlan == 1,
                                isRecommended: true
                            ) {
                                selectedPlan = 1
                            }
                            
                            pricingOption(
                                title: "Lifetime",
                                price: "$\(String(format: "%.0f", bot.price.amount * 8))",
                                description: "One-time payment • Unlimited access",
                                isSelected: selectedPlan == 2
                            ) {
                                selectedPlan = 2
                            }
                        }
                    }
                }
                
                Spacer()
                
                // Terms and conditions
                HStack(spacing: 8) {
                    Button(action: {
                        acceptedTerms.toggle()
                    }) {
                        Image(systemName: acceptedTerms ? "checkmark.square.fill" : "square")
                            .foregroundColor(acceptedTerms ? DesignSystem.primaryGold : .secondary)
                    }
                    
                    Text("I agree to the terms and conditions")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                }
                
                // Hire button
                Button(action: {
                    hireBot()
                }) {
                    HStack {
                        if isProcessing {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(0.8)
                        } else {
                            Text("Complete Hire")
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(acceptedTerms ? DesignSystem.primaryGold : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .disabled(!acceptedTerms || isProcessing)
            }
            .padding()
            .navigationTitle("Hire Bot")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.primary)
                }
            }
        }
    }
    
    private func pricingOption(
        title: String,
        price: String,
        description: String,
        isSelected: Bool,
        isRecommended: Bool = false,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(title)
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            
                            if isRecommended {
                                Text("RECOMMENDED")
                                    .font(.caption2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(Color.green)
                                    .cornerRadius(4)
                            }
                        }
                        
                        Text(description)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Text(price)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(DesignSystem.primaryGold)
                }
                
                if isSelected {
                    Text("✓ Selected")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.green)
                }
            }
            .padding()
            .background(
                isSelected 
                ? DesignSystem.primaryGold.opacity(0.1) 
                : Color(.systemGray6)
            )
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        isSelected ? DesignSystem.primaryGold : Color.clear, 
                        lineWidth: 2
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func hireBot() {
        isProcessing = true
        
        // Simulate hiring process
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            isProcessing = false
            dismiss()
        }
    }
}

// MARK: - Preview

#Preview {
    let sampleBot = BotStoreService.shared.marketplaceBots.first!
    return MarketplaceBotDetailView(bot: sampleBot)
}