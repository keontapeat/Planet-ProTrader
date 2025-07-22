//
//  BotManagementView.swift
//  Planet ProTrader
//
//  ✅ BOT MANAGEMENT - AI trading bot management interface
//

import SwiftUI

struct BotManagementView: View {
    @StateObject private var botManager = TradingBotManager.shared
    @State private var showingBotCreation = false
    @State private var selectedBot: CoreTypes.TradingBot?
    @State private var animateCards = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 20) {
                    // Header stats
                    statsHeader
                    
                    // Bot list
                    if botManager.allBots.isEmpty {
                        emptyState
                    } else {
                        botList
                    }
                }
                .padding()
            }
            .navigationTitle("AI Bots")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingBotCreation = true }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(DesignSystem.primaryGold)
                            .font(.title2)
                    }
                }
            }
            .onAppear {
                startAnimations()
            }
        }
        .sheet(isPresented: $showingBotCreation) {
            BotCreationView()
        }
        .sheet(item: $selectedBot) { bot in
            BotDetailView(bot: bot)
        }
    }
    
    private var statsHeader: some View {
        VStack(spacing: 16) {
            Text("Bot Army Status")
                .font(.title2)
                .fontWeight(.bold)
            
            HStack(spacing: 20) {
                StatCard(
                    title: "Active Bots",
                    value: "\(botManager.activeBots.count)",
                    color: .green
                )
                
                StatCard(
                    title: "Total Profit",
                    value: "$2,847.92",
                    color: DesignSystem.primaryGold
                )
                
                StatCard(
                    title: "Win Rate",
                    value: "84.3%",
                    color: .blue
                )
            }
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
        .scaleEffect(animateCards ? 1.0 : 0.95)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.8, dampingFraction: 0.8), value: animateCards)
    }
    
    private var botList: some View {
        LazyVStack(spacing: 12) {
            ForEach(botManager.allBots, id: \.id) { bot in
                BotRowCard(bot: bot) {
                    selectedBot = bot
                }
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.95)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.1), value: animateCards)
    }
    
    private var emptyState: some View {
        VStack(spacing: 20) {
            Image(systemName: "brain.head.profile")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            Text("No Bots Yet")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Create your first AI trading bot to get started")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button("Create Bot") {
                showingBotCreation = true
            }
            .buttonStyle(.borderedProminent)
            .tint(DesignSystem.primaryGold)
        }
        .padding(40)
        .scaleEffect(animateCards ? 1.0 : 0.95)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.1), value: animateCards)
    }
    
    private func startAnimations() {
        withAnimation(.spring(response: 1.0, dampingFraction: 0.8).delay(0.2)) {
            animateCards = true
        }
    }
}

struct BotRowCard: View {
    let bot: CoreTypes.TradingBot
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                // Bot avatar
                Circle()
                    .fill(Color(hex: bot.primaryColor) ?? DesignSystem.primaryGold)
                    .frame(width: 50, height: 50)
                    .overlay(
                        Image(systemName: bot.icon)
                            .font(.title2)
                            .foregroundColor(.white)
                    )
                
                // Bot info
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(bot.name)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Text(bot.isActive ? "ACTIVE" : "STOPPED")
                            .font(.caption)
                            .fontWeight(.bold)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(bot.isActive ? Color.green : Color.gray)
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                    }
                    
                    Text(bot.strategy.displayName)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    HStack(spacing: 16) {
                        Text("P&L: \(bot.formattedProfit)")
                            .font(.caption)
                            .foregroundColor(bot.profit >= 0 ? .green : .red)
                        
                        Text("Trades: \(bot.totalTrades)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text("Win Rate: \(Int(bot.winRate * 100))%")
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                }
            }
            .padding()
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(.plain)
    }
}

struct BotCreationView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 40) {
                Image(systemName: "brain.head.profile")
                    .font(.system(size: 80))
                    .foregroundColor(DesignSystem.primaryGold)
                
                VStack(spacing: 16) {
                    Text("Create Trading Bot")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Bot creation interface coming soon...")
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("New Bot")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}

struct BotDetailView: View {
    let bot: CoreTypes.TradingBot
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Bot header
                    VStack(spacing: 16) {
                        Circle()
                            .fill(Color(hex: bot.primaryColor) ?? DesignSystem.primaryGold)
                            .frame(width: 80, height: 80)
                            .overlay(
                                Image(systemName: bot.icon)
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundColor(.white)
                            )
                        
                        VStack(spacing: 8) {
                            Text(bot.name)
                                .font(.title)
                                .fontWeight(.bold)
                            
                            Text(bot.strategy.displayName)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            HStack(spacing: 4) {
                                Circle()
                                    .fill(bot.status.color)
                                    .frame(width: 8, height: 8)
                                
                                Text(bot.status.rawValue)
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundColor(bot.status.color)
                            }
                        }
                    }
                    
                    // Performance metrics
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                        MetricCard(title: "Performance", value: "+\(String(format: "%.1f", bot.performance))%", color: .green, icon: "chart.line.uptrend.xyaxis")
                        MetricCard(title: "Total Trades", value: "\(bot.totalTrades)", color: .blue, icon: "chart.bar.fill")
                        MetricCard(title: "Win Rate", value: "\(Int(bot.winRate * 100))%", color: .green, icon: "target")
                        MetricCard(title: "Profit", value: bot.formattedProfit, color: DesignSystem.primaryGold, icon: "dollarsign.circle.fill")
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Bot Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    BotManagementView()
}