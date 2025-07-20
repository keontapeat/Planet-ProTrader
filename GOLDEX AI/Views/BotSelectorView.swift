//
//  BotSelectorView.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 1/21/25.
//

import SwiftUI

struct BotSelectorView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedBot: TradingBotProfile?
    @StateObject private var botManager = TradingBotManager.shared
    @State private var animateCards = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    headerSection
                    
                    // Premium Bots Section
                    premiumBotsSection
                    
                    // Standard Bots Section
                    standardBotsSection
                    
                    // Coming Soon Bots
                    comingSoonSection
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
            .background(Color(.systemBackground))
            .navigationTitle("🤖 Select Your Bot")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .foregroundColor(DesignSystem.primaryGold)
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0)) {
                animateCards = true
            }
        }
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            Text("Choose Your Trading Genius")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text("Each bot has unique strategies and personalities trained on different market conditions")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            // Quick stats
            HStack(spacing: 20) {
                statBadge(title: "Active Bots", value: "\(botManager.activeBots.count)", color: .green)
                statBadge(title: "Total Profit", value: "$12,450", color: DesignSystem.primaryGold)
                statBadge(title: "Win Rate", value: "73%", color: .blue)
            }
            .padding()
            .background(Color(.systemGray6).opacity(0.5))
            .cornerRadius(16)
        }
    }
    
    private func statBadge(title: String, value: String, color: Color) -> some View {
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
    
    // MARK: - Premium Bots Section
    
    private var premiumBotsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("👑 PREMIUM LEGENDS")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Text("JIM ROHN TRAINED")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(DesignSystem.primaryGold)
                    .cornerRadius(6)
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 1), spacing: 16) {
                ForEach(botManager.premiumBots) { bot in
                    premiumBotCard(bot: bot)
                        .scaleEffect(animateCards ? 1.0 : 0.8)
                        .opacity(animateCards ? 1.0 : 0)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1), value: animateCards)
                }
            }
        }
    }
    
    private func premiumBotCard(bot: AdvancedTradingBot) -> some View {
        Button(action: {
            // Convert to TradingBotProfile for compatibility
            selectedBot = TradingBotProfile(
                name: bot.name,
                icon: bot.icon,
                primaryColor: bot.primaryColor,
                secondaryColor: bot.secondaryColor,
                status: bot.status,
                isActive: bot.isActive,
                winRate: bot.winRate
            )
            dismiss()
        }) {
            VStack(spacing: 0) {
                // Top section with gradient
                ZStack {
                    LinearGradient(
                        colors: [bot.primaryColor, bot.secondaryColor],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .frame(height: 120)
                    
                    VStack(spacing: 12) {
                        // Bot avatar with glow effect
                        ZStack {
                            Circle()
                                .fill(Color.white.opacity(0.2))
                                .frame(width: 60, height: 60)
                                .blur(radius: 10)
                            
                            Circle()
                                .fill(Color.white)
                                .frame(width: 50, height: 50)
                            
                            Image(systemName: bot.icon)
                                .font(.title2)
                                .foregroundColor(bot.primaryColor)
                                .fontWeight(.bold)
                            
                            // Premium crown
                            Image(systemName: "crown.fill")
                                .font(.caption)
                                .foregroundColor(DesignSystem.primaryGold)
                                .offset(x: 20, y: -20)
                        }
                        
                        Text(bot.name)
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                }
                
                // Bottom section with stats
                VStack(spacing: 12) {
                    // Jim Rohn Training Badge
                    HStack {
                        Image(systemName: "brain.head.profile")
                            .font(.caption)
                            .foregroundColor(DesignSystem.primaryGold)
                        
                        Text("JIM ROHN WISDOM TRAINED")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundColor(DesignSystem.primaryGold)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(DesignSystem.primaryGold.opacity(0.1))
                    .cornerRadius(6)
                    
                    // Key stats
                    HStack(spacing: 16) {
                        statColumn(title: "Win Rate", value: "\(Int(bot.winRate * 100))%", color: .green)
                        statColumn(title: "Profit", value: bot.totalProfit, color: .blue)
                        statColumn(title: "Level", value: "\(bot.intelligenceLevel)", color: .purple)
                    }
                    
                    // Special abilities
                    VStack(alignment: .leading, spacing: 4) {
                        Text("🧠 SPECIAL ABILITIES:")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        ForEach(bot.specialAbilities.prefix(2), id: \.self) { ability in
                            Text("• \(ability)")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Action button
                    Text(selectedBot?.name == bot.name ? "✅ SELECTED" : "🚀 SELECT")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(selectedBot?.name == bot.name ? .green : bot.primaryColor)
                        .cornerRadius(8)
                }
                .padding(16)
                .background(Color(.systemBackground))
            }
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        LinearGradient(
                            colors: [bot.primaryColor, bot.secondaryColor],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 2
                    )
            )
            .shadow(color: bot.primaryColor.opacity(0.3), radius: 10, x: 0, y: 5)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // MARK: - Standard Bots Section
    
    private var standardBotsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("⚙️ STANDARD BOTS")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                ForEach(botManager.standardBots) { bot in
                    standardBotCard(bot: bot)
                        .scaleEffect(animateCards ? 1.0 : 0.8)
                        .opacity(animateCards ? 1.0 : 0)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2), value: animateCards)
                }
            }
        }
    }
    
    private func standardBotCard(bot: AdvancedTradingBot) -> some View {
        Button(action: {
            selectedBot = TradingBotProfile(
                name: bot.name,
                icon: bot.icon,
                primaryColor: bot.primaryColor,
                secondaryColor: bot.secondaryColor,
                status: bot.status,
                isActive: bot.isActive,
                winRate: bot.winRate
            )
            dismiss()
        }) {
            VStack(spacing: 12) {
                // Bot avatar
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [bot.primaryColor, bot.secondaryColor],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: bot.icon)
                        .font(.title3)
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                }
                
                VStack(spacing: 4) {
                    Text(bot.name)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    
                    Text(bot.status)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                // Mini stats
                HStack(spacing: 8) {
                    miniStat(value: "\(Int(bot.winRate * 100))%", color: .green)
                    miniStat(value: "Lv.\(bot.intelligenceLevel)", color: .purple)
                }
            }
            .padding(12)
            .background(Color(.systemGray6).opacity(0.5))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(selectedBot?.name == bot.name ? bot.primaryColor : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // MARK: - Coming Soon Section
    
    private var comingSoonSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("🚀 COMING SOON")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                comingSoonCard(
                    name: "Warren Buffett AI",
                    icon: "chart.pie.fill",
                    description: "Value investing genius",
                    color: .green
                )
                
                comingSoonCard(
                    name: "Elon Musk Bot",
                    icon: "bolt.fill",
                    description: "Innovation trader",
                    color: .blue
                )
                
                comingSoonCard(
                    name: "Tony Robbins AI",
                    icon: "flame.fill",
                    description: "Peak performance",
                    color: .orange
                )
                
                comingSoonCard(
                    name: "Einstein Quant",
                    icon: "atom",
                    description: "Physics-based trading",
                    color: .purple
                )
            }
        }
    }
    
    private func comingSoonCard(name: String, icon: String, description: String, color: Color) -> some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(color)
                    .fontWeight(.bold)
                
                // Coming soon overlay
                Text("SOON")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 4)
                    .padding(.vertical, 2)
                    .background(Color.red)
                    .cornerRadius(4)
                    .offset(x: 20, y: -20)
            }
            
            VStack(spacing: 4) {
                Text(name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(12)
        .background(Color(.systemGray6).opacity(0.3))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(color.opacity(0.3), lineWidth: 1)
        )
        .grayscale(0.5)
    }
    
    // MARK: - Helper Views
    
    private func statColumn(title: String, value: String, color: Color) -> some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(color)
            
            Text(title)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
    }
    
    private func miniStat(value: String, color: Color) -> some View {
        Text(value)
            .font(.caption2)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(color)
            .cornerRadius(4)
    }
}

#Preview {
    BotSelectorView(selectedBot: .constant(nil))
}