//
//  BotStatCardView.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 7/18/25.
//

import SwiftUI

struct BotStatCardView: View {
    let bot: MarketplaceBotModel
    let isSelected: Bool
    let showHolographicEffect: Bool
    
    @State private var rotationAngle: Double = 0
    @State private var hologramOpacity: Double = 0.0
    @State private var sparkleAnimation = false
    @State private var glowPulse = false
    
    init(bot: MarketplaceBotModel, isSelected: Bool = false, showHolographicEffect: Bool = true) {
        self.bot = bot
        self.isSelected = isSelected
        self.showHolographicEffect = showHolographicEffect
    }
    
    var body: some View {
        ZStack {
            // Card base
            cardBase
            
            // Holographic overlay
            if showHolographicEffect && bot.rarity.rawValue != "Common" {
                holographicOverlay
            }
            
            // Card content
            cardContent
            
            // Selection glow
            if isSelected {
                selectionGlow
            }
        }
        .frame(width: 280, height: 400)
        .rotation3DEffect(
            .degrees(rotationAngle),
            axis: (x: 0, y: 1, z: 0),
            perspective: 0.5
        )
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.spring(response: 0.5, dampingFraction: 0.7), value: isSelected)
        .onAppear {
            startAnimations()
        }
    }
    
    // MARK: - Card Base
    
    private var cardBase: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(
                LinearGradient(
                    colors: cardBaseColors,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(
                        LinearGradient(
                            colors: [.white.opacity(0.3), bot.rarity.color.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 3
                    )
            )
            .shadow(
                color: bot.rarity.color.opacity(0.4),
                radius: isSelected ? 20 : 10,
                x: 0,
                y: isSelected ? 10 : 5
            )
    }
    
    private var cardBaseColors: [Color] {
        switch bot.rarity {
        case .common:
            return [Color(.systemGray3), Color(.systemGray4)]
        case .uncommon:
            return [Color.green.opacity(0.3), Color.green.opacity(0.1)]
        case .rare:
            return [Color.blue.opacity(0.4), Color.blue.opacity(0.2)]
        case .epic:
            return [Color.purple.opacity(0.4), Color.purple.opacity(0.2)]
        case .legendary:
            return [Color.orange.opacity(0.4), Color.orange.opacity(0.2)]
        case .mythic:
            return [Color.red.opacity(0.4), Color.red.opacity(0.2)]
        case .godTier:
            return [Color.gold.opacity(0.6), Color.gold.opacity(0.3)]
        }
    }
    
    // MARK: - Holographic Overlay
    
    private var holographicOverlay: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(
                AngularGradient(
                    colors: [
                        .clear, .white.opacity(0.3), .clear,
                        bot.rarity.color.opacity(0.4), .clear,
                        .white.opacity(0.2), .clear
                    ],
                    center: .center,
                    startAngle: .degrees(0),
                    endAngle: .degrees(360)
                )
            )
            .opacity(hologramOpacity)
            .rotationEffect(.degrees(rotationAngle * 2))
            .blendMode(.overlay)
    }
    
    // MARK: - Card Content
    
    private var cardContent: some View {
        VStack(spacing: 0) {
            // Header section
            cardHeader
            
            // Bot avatar section
            botAvatarSection
            
            // Stats section
            statsSection
            
            // Footer section
            cardFooter
        }
        .padding(16)
    }
    
    private var cardHeader: some View {
        VStack(spacing: 8) {
            HStack {
                // Rarity indicator
                HStack(spacing: 4) {
                    Text(bot.rarity.sparkleEffect)
                        .font(.caption)
                        .scaleEffect(sparkleAnimation ? 1.2 : 1.0)
                        .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: sparkleAnimation)
                    
                    Text(bot.rarity.rawValue.uppercased())
                        .font(.system(size: 10, weight: .black, design: .rounded))
                        .foregroundColor(bot.rarity.color)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(bot.rarity.color.opacity(0.2))
                        .cornerRadius(8)
                }
                
                Spacer()
                
                // Verification badge
                HStack(spacing: 2) {
                    Image(systemName: bot.verificationStatus.icon)
                        .font(.system(size: 10))
                        .foregroundColor(bot.verificationStatus.color)
                    
                    Text(bot.verificationStatus.rawValue)
                        .font(.system(size: 8, weight: .medium))
                        .foregroundColor(bot.verificationStatus.color)
                }
            }
            
            // Bot name
            Text(bot.name)
                .font(.system(size: 18, weight: .black, design: .rounded))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.8)
        }
    }
    
    private var botAvatarSection: some View {
        VStack(spacing: 12) {
            // Main bot avatar
            BotAvatarView(bot: bot, size: 120, showEffects: true)
            
            // Tier and trading style
            HStack(spacing: 8) {
                // Tier badge
                VStack(spacing: 2) {
                    Text(bot.tier.icon)
                        .font(.title2)
                    
                    Text(bot.tier.rawValue)
                        .font(.system(size: 8, weight: .bold))
                        .foregroundColor(bot.tier.color)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(bot.tier.color.opacity(0.1))
                .cornerRadius(8)
                
                Spacer()
                
                // Trading style
                VStack(spacing: 2) {
                    Image(systemName: "chart.xyaxis.line")
                        .font(.caption)
                        .foregroundColor(bot.tradingStyle.color)
                    
                    Text(bot.tradingStyle.displayName)
                        .font(.system(size: 8, weight: .medium))
                        .foregroundColor(bot.tradingStyle.color)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(bot.tradingStyle.color.opacity(0.1))
                .cornerRadius(8)
            }
        }
        .padding(.vertical, 8)
    }
    
    private var statsSection: some View {
        VStack(spacing: 8) {
            // Performance grade
            HStack {
                Text("PERFORMANCE GRADE")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text(bot.stats.performanceGrade)
                    .font(.system(size: 16, weight: .black))
                    .foregroundColor(performanceGradeColor)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(performanceGradeColor.opacity(0.2))
                    .cornerRadius(6)
            }
            
            // Stat bars
            VStack(spacing: 6) {
                statBar(
                    title: "WIN RATE",
                    value: bot.stats.winRate,
                    maxValue: 100,
                    color: .blue,
                    formatValue: { "\(Int($0))%" }
                )
                
                statBar(
                    title: "RETURN",
                    value: max(0, bot.stats.totalReturn + 100), // Normalize negative returns for bar
                    maxValue: 200,
                    color: bot.stats.totalReturn >= 0 ? .green : .red,
                    formatValue: { _ in bot.stats.formattedTotalReturn }
                )
                
                statBar(
                    title: "SHARPE",
                    value: bot.stats.sharpeRatio * 30, // Scale for visualization
                    maxValue: 100,
                    color: .purple,
                    formatValue: { _ in String(format: "%.2f", bot.stats.sharpeRatio) }
                )
                
                statBar(
                    title: "UNIVERSE RANK",
                    value: max(0, 1000 - Double(bot.stats.universeRank)), // Invert for bar
                    maxValue: 1000,
                    color: DesignSystem.primaryGold,
                    formatValue: { _ in "#\(bot.stats.universeRank)" }
                )
            }
        }
        .padding(.vertical, 8)
    }
    
    private func statBar(
        title: String,
        value: Double,
        maxValue: Double,
        color: Color,
        formatValue: (Double) -> String
    ) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(title)
                    .font(.system(size: 9, weight: .bold))
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text(formatValue(value))
                    .font(.system(size: 9, weight: .bold))
                    .foregroundColor(color)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(.systemGray5))
                        .frame(height: 6)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(
                            LinearGradient(
                                colors: [color.opacity(0.8), color],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(
                            width: geometry.size.width * min(value / maxValue, 1.0),
                            height: 6
                        )
                        .animation(.easeOut(duration: 1.5), value: value)
                    
                    // Glow effect for high values
                    if value / maxValue > 0.8 {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(color.opacity(0.4))
                            .frame(
                                width: geometry.size.width * min(value / maxValue, 1.0),
                                height: 6
                            )
                            .blur(radius: 2)
                            .scaleEffect(glowPulse ? 1.1 : 1.0)
                            .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: glowPulse)
                    }
                }
            }
            .frame(height: 6)
        }
    }
    
    private var performanceGradeColor: Color {
        switch bot.stats.performanceGrade {
        case "S+", "S": return .gold
        case "A+", "A": return .green
        case "B+", "B": return .blue
        default: return .orange
        }
    }
    
    private var cardFooter: some View {
        VStack(spacing: 8) {
            Divider()
                .background(bot.rarity.color.opacity(0.3))
            
            HStack {
                // Price
                VStack(alignment: .leading, spacing: 2) {
                    Text("PRICE")
                        .font(.system(size: 8, weight: .bold))
                        .foregroundColor(.secondary)
                    
                    Text(bot.formattedPrice)
                        .font(.system(size: 12, weight: .black))
                        .foregroundColor(DesignSystem.primaryGold)
                }
                
                Spacer()
                
                // Users count
                VStack(alignment: .trailing, spacing: 2) {
                    Text("USERS")
                        .font(.system(size: 8, weight: .bold))
                        .foregroundColor(.secondary)
                    
                    Text("\(bot.stats.totalUsers)")
                        .font(.system(size: 12, weight: .black))
                        .foregroundColor(.purple)
                }
            }
            
            // QR code placeholder
            HStack {
                Rectangle()
                    .fill(Color(.systemGray4))
                    .frame(width: 30, height: 30)
                    .cornerRadius(4)
                    .overlay(
                        Text("QR")
                            .font(.system(size: 8, weight: .bold))
                            .foregroundColor(.secondary)
                    )
                
                VStack(alignment: .leading, spacing: 1) {
                    Text("Scan to hire")
                        .font(.system(size: 7, weight: .medium))
                        .foregroundColor(.secondary)
                    
                    Text("goldexai.com/bot/\(bot.id.uuidString.prefix(8))")
                        .font(.system(size: 6, weight: .regular))
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                
                Spacer()
                
                // Star rating
                HStack(spacing: 1) {
                    ForEach(0..<5) { star in
                        Image(systemName: star < Int(bot.averageRating) ? "star.fill" : "star")
                            .font(.system(size: 8))
                            .foregroundColor(.yellow)
                    }
                }
            }
        }
    }
    
    // MARK: - Selection Glow
    
    private var selectionGlow: some View {
        RoundedRectangle(cornerRadius: 20)
            .stroke(
                LinearGradient(
                    colors: [
                        DesignSystem.primaryGold,
                        DesignSystem.primaryGold.opacity(0.5),
                        DesignSystem.primaryGold
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                lineWidth: 4
            )
            .shadow(color: DesignSystem.primaryGold.opacity(0.6), radius: 15)
            .scaleEffect(1.02)
    }
    
    // MARK: - Animation Methods
    
    private func startAnimations() {
        // Sparkle animation
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            sparkleAnimation = true
        }
        
        // Glow pulse for high performance bots
        if bot.stats.totalReturn > 50 || bot.stats.winRate > 80 {
            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                glowPulse = true
            }
        }
        
        // Holographic effect
        if showHolographicEffect && bot.rarity.rawValue != "Common" {
            withAnimation(.linear(duration: 4.0).repeatForever(autoreverses: false)) {
                rotationAngle += 360
            }
            
            withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true)) {
                hologramOpacity = bot.rarity == .godTier ? 0.8 : 0.4
            }
        }
    }
}

// MARK: - Bot Card Collection View

struct BotCardCollectionView: View {
    @StateObject private var storeService = BotStoreService.shared
    @State private var selectedCard: UUID?
    @State private var showingCardDetail = false
    @State private var animateCollection = false
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Collection stats
                    collectionStatsSection
                    
                    // Card grid
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(storeService.marketplaceBots) { bot in
                            Button(action: {
                                selectedCard = bot.id
                                showingCardDetail = true
                            }) {
                                BotStatCardView(
                                    bot: bot,
                                    isSelected: selectedCard == bot.id,
                                    showHolographicEffect: true
                                )
                                .scaleEffect(0.7) // Scale down for grid view
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("🃏 Bot Card Collection")
            .navigationBarTitleDisplayMode(.large)
        }
        .sheet(isPresented: $showingCardDetail) {
            if let selectedBot = storeService.marketplaceBots.first(where: { $0.id == selectedCard }) {
                BotCardDetailView(bot: selectedBot)
            }
        }
        .onAppear {
            animateCollection = true
        }
    }
    
    private var collectionStatsSection: some View {
        VStack(spacing: 16) {
            Text("🏆 YOUR COLLECTION")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(DesignSystem.primaryGold)
            
            HStack(spacing: 24) {
                collectionStat(title: "Total Cards", value: "\(storeService.marketplaceBots.count)", color: .blue)
                collectionStat(title: "Rare+", value: "\(storeService.marketplaceBots.filter { $0.rarity.rawValue != "Common" && $0.rarity.rawValue != "Uncommon" }.count)", color: .purple)
                collectionStat(title: "Legendary", value: "\(storeService.marketplaceBots.filter { $0.rarity == .legendary || $0.rarity == .mythic || $0.rarity == .godTier }.count)", color: .gold)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
    
    private func collectionStat(title: String, value: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Bot Card Detail View

struct BotCardDetailView: View {
    let bot: MarketplaceBotModel
    @Environment(\.dismiss) private var dismiss
    @State private var cardRotation: Double = 0
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [bot.rarity.color.opacity(0.1), Color(.systemBackground)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 30) {
                        // Large card display
                        BotStatCardView(
                            bot: bot,
                            isSelected: true,
                            showHolographicEffect: true
                        )
                        .scaleEffect(1.1)
                        .rotation3DEffect(
                            .degrees(cardRotation),
                            axis: (x: 0, y: 1, z: 0),
                            perspective: 0.8
                        )
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    cardRotation = value.translation.x * 0.5
                                }
                                .onEnded { _ in
                                    withAnimation(.spring()) {
                                        cardRotation = 0
                                    }
                                }
                        )
                        
                        // Card details
                        cardDetailsSection
                        
                        // Action buttons
                        actionButtonsSection
                    }
                    .padding()
                }
            }
            .navigationTitle("Card Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(DesignSystem.primaryGold)
                }
            }
        }
    }
    
    private var cardDetailsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("📊 Card Statistics")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            VStack(spacing: 12) {
                detailRow(title: "Rarity", value: bot.rarity.rawValue, color: bot.rarity.color)
                detailRow(title: "Tier", value: bot.tier.rawValue, color: bot.tier.color)
                detailRow(title: "Drop Rate", value: "\(String(format: "%.2f", bot.rarity.dropRate))%", color: .orange)
                detailRow(title: "Market Value", value: bot.formattedPrice, color: DesignSystem.primaryGold)
                detailRow(title: "Collection #", value: "#\(String(bot.id.uuidString.prefix(8)))", color: .secondary)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
    
    private func detailRow(title: String, value: String, color: Color) -> some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.primary)
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(color)
        }
    }
    
    private var actionButtonsSection: some View {
        VStack(spacing: 12) {
            Button("View Full Bot Profile") {
                // Action to view full bot profile
            }
            .buttonStyle(PrimaryButtonStyle())
            
            HStack(spacing: 12) {
                Button("Share Card") {
                    // Share card action
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(.systemGray5))
                .foregroundColor(.primary)
                .cornerRadius(12)
                
                Button("Add to Favorites") {
                    // Add to favorites action
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(.systemGray5))
                .foregroundColor(.primary)
                .cornerRadius(12)
            }
        }
    }
}

// MARK: - Preview

#Preview("Single Card") {
    BotStatCardView(bot: BotStoreService.shared.marketplaceBots.first!)
}

#Preview("Card Collection") {
    BotCardCollectionView()
}