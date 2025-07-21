//
//  MarketplaceBotDetailView.swift
//  Planet ProTrader
//
//  Created by AI Assistant on 1/25/25.
//

import SwiftUI

struct MarketplaceBotDetailView: View {
    let bot: MarketplaceBotModel
    @Environment(\.dismiss) private var dismiss
    @State private var showingPurchase = false
    @State private var isAnimating = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header Section
                    headerSection
                    
                    // Performance Stats
                    performanceStatsSection
                    
                    // Description
                    descriptionSection
                    
                    // Features
                    featuresSection
                    
                    // Reviews Section
                    reviewsSection
                    
                    // Creator Info
                    creatorSection
                    
                    Spacer(minLength: 100)
                }
                .padding()
            }
            .navigationTitle(bot.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(DesignSystem.primaryGold)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Share") {
                        // Handle sharing
                    }
                    .foregroundColor(DesignSystem.primaryGold)
                }
            }
            .overlay(
                VStack {
                    Spacer()
                    purchaseButtonOverlay
                }
            )
        }
        .sheet(isPresented: $showingPurchase) {
            BotPurchaseView(bot: bot)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8)) {
                isAnimating = true
            }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            // Bot Avatar
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            colors: [bot.rarity.color.opacity(0.3), bot.rarity.color.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 120)
                
                VStack(spacing: 8) {
                    Text(bot.rarity.sparkleEffect)
                        .font(.system(size: 40))
                    
                    Text(bot.tier.icon)
                        .font(.system(size: 24))
                }
            }
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(bot.rarity.color, lineWidth: 3)
            )
            .scaleEffect(isAnimating ? 1.0 : 0.8)
            .animation(.spring(response: 0.6, dampingFraction: 0.8), value: isAnimating)
            
            // Bot Info
            VStack(spacing: 8) {
                Text(bot.name)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text(bot.tagline)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                // Status badges
                HStack(spacing: 12) {
                    StatusBadge(title: bot.rarity.rawValue, color: bot.rarity.color)
                    StatusBadge(title: bot.tier.rawValue, color: bot.tier.color)
                    StatusBadge(title: bot.availability.rawValue, color: bot.availability.color)
                }
            }
            
            // Rating and price
            HStack {
                // Rating
                HStack(spacing: 4) {
                    ForEach(0..<5) { star in
                        Image(systemName: star < Int(bot.averageRating) ? "star.fill" : "star")
                            .foregroundColor(.yellow)
                            .font(.caption)
                    }
                    Text("(\(bot.totalReviews))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Price
                Text(bot.formattedPrice)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(DesignSystem.primaryGold)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemGray6))
        )
    }
    
    private var performanceStatsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("📊 Performance Stats")
                .font(.headline)
                .fontWeight(.bold)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                // ✅ Fixed: Using proper StatCard initializers
                StatCard(
                    title: "Total Return",
                    value: bot.stats.formattedTotalReturn,
                    icon: "chart.line.uptrend.xyaxis",
                    color: bot.stats.totalReturn >= 0 ? .green : .red
                )
                
                StatCard(
                    title: "Win Rate",
                    value: "\(String(format: "%.1f", bot.stats.winRate))%",
                    icon: "target",
                    color: .blue
                )
                
                StatCard(
                    title: "Max Drawdown",
                    value: "\(String(format: "%.1f", bot.stats.maxDrawdown))%",
                    icon: "arrow.down.circle",
                    color: .orange
                )
                
                StatCard(
                    title: "Total Users",
                    value: "\(bot.stats.totalUsers)",
                    icon: "person.3.fill",
                    color: .purple
                )
                
                StatCard(
                    title: "Sharpe Ratio",
                    value: String(format: "%.1f", bot.stats.sharpeRatio),
                    icon: "chart.bar.fill",
                    color: .cyan
                )
                
                StatCard(
                    title: "Daily Return",
                    value: "\(String(format: "%.1f", bot.stats.averageDailyReturn))%",
                    icon: "calendar",
                    color: .mint
                )
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemGray6))
        )
    }
    
    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("📝 Description")
                .font(.headline)
                .fontWeight(.bold)
            
            Text(bot.description)
                .font(.body)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemGray6))
        )
    }
    
    private var featuresSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("⚡ Key Features")
                .font(.headline)
                .fontWeight(.bold)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 1), spacing: 8) {
                ForEach(bot.features, id: \.self) { feature in
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                            .font(.caption)
                        
                        Text(feature)
                            .font(.subheadline)
                            .foregroundColor(.primary)
                        
                        Spacer()
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemGray6))
        )
    }
    
    private var reviewsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("⭐ Reviews")
                    .font(.headline)
                    .fontWeight(.bold)
                
                Spacer()
                
                Text("\(bot.totalReviews) reviews")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            // Sample reviews (in a real app, these would come from a data source)
            VStack(spacing: 8) {
                ReviewRow(username: "ProTrader99", rating: 5, comment: "Amazing bot! Consistent profits daily.")
                ReviewRow(username: "GoldMiner", rating: 4, comment: "Great performance, easy to use.")
                ReviewRow(username: "TradingNinja", rating: 5, comment: "Best investment I've made this year!")
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemGray6))
        )
    }
    
    private var creatorSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("👨‍💻 Creator")
                .font(.headline)
                .fontWeight(.bold)
            
            HStack {
                Circle()
                    .fill(DesignSystem.primaryGold.opacity(0.3))
                    .frame(width: 50, height: 50)
                    .overlay(
                        Text(String(bot.creatorUsername.prefix(1)))
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(DesignSystem.primaryGold)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(bot.creatorUsername)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    
                    HStack {
                        Image(systemName: bot.verificationStatus.icon)
                            .foregroundColor(bot.verificationStatus.color)
                            .font(.caption)
                        
                        Text(bot.verificationStatus.rawValue)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                Button("Follow") {
                    // Handle follow
                }
                .font(.caption)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(DesignSystem.primaryGold)
                .foregroundColor(.black)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemGray6))
        )
    }
    
    private var purchaseButtonOverlay: some View {
        VStack(spacing: 12) {
            if bot.isFreeTrial {
                Button("Start Free Trial") {
                    showingPurchase = true
                }
                .font(.headline)
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .padding()
                .background(DesignSystem.primaryGold)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(radius: 8)
            }
            
            Button(bot.price == 0 ? "Get Bot Free" : "Purchase Bot") {
                showingPurchase = true
            }
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                LinearGradient(
                    colors: [bot.rarity.color, bot.rarity.color.opacity(0.8)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(radius: 8)
        }
        .padding()
        .background(
            .regularMaterial,
            in: RoundedRectangle(cornerRadius: 16)
        )
        .padding(.horizontal)
    }
}

// MARK: - Supporting Views

struct StatusBadge: View {
    let title: String
    let color: Color
    
    var body: some View {
        Text(title)
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}

struct ReviewRow: View {
    let username: String
    let rating: Int
    let comment: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Circle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 32, height: 32)
                .overlay(
                    Text(String(username.prefix(1)))
                        .font(.caption)
                        .fontWeight(.semibold)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(username)
                        .font(.caption)
                        .fontWeight(.semibold)
                    
                    HStack(spacing: 1) {
                        ForEach(0..<5) { star in
                            Image(systemName: star < rating ? "star.fill" : "star")
                                .foregroundColor(.yellow)
                                .font(.caption2)
                        }
                    }
                }
                
                Text(comment)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Bot Purchase View

struct BotPurchaseView: View {
    let bot: MarketplaceBotModel
    @Environment(\.dismiss) private var dismiss
    @State private var selectedPlan = 0
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 12) {
                        Text("Purchase \(bot.name)")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text(bot.tagline)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    // Purchase options
                    VStack(spacing: 16) {
                        if bot.isFreeTrial {
                            PurchaseOptionCard(
                                title: "7-Day Free Trial",
                                price: "FREE",
                                features: ["Full access", "7-day trial", "Cancel anytime"],
                                isSelected: selectedPlan == 0
                            ) {
                                selectedPlan = 0
                            }
                        }
                        
                        PurchaseOptionCard(
                            title: "Full License",
                            price: bot.formattedPrice,
                            features: ["Lifetime access", "All updates", "Priority support"],
                            isSelected: selectedPlan == 1
                        ) {
                            selectedPlan = 1
                        }
                    }
                    
                    // Purchase button
                    Button("Continue") {
                        // Handle purchase
                        dismiss()
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(DesignSystem.primaryGold)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding()
            }
            .navigationTitle("Purchase")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.secondary)
                }
            }
        }
    }
}

struct PurchaseOptionCard: View {
    let title: String
    let price: String
    let features: [String]
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(title)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        
                        Text(price)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(DesignSystem.primaryGold)
                    }
                    
                    Spacer()
                    
                    Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(isSelected ? DesignSystem.primaryGold : .gray)
                        .font(.title3)
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    ForEach(features, id: \.self) { feature in
                        HStack {
                            Image(systemName: "checkmark")
                                .foregroundColor(.green)
                                .font(.caption)
                            
                            Text(feature)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? DesignSystem.primaryGold : Color.clear, lineWidth: 2)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - ✅ FIXED PREVIEW

#Preview {
    MarketplaceBotDetailView(bot: MarketplaceBotModel.sampleBots[0])
}