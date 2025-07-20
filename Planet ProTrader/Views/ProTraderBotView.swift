//
//  ProTraderBotView.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 1/25/25.
//

import SwiftUI

struct ProTraderBotView: View {
    @StateObject private var botManager = ProTraderBotManager()
    @State private var selectedBot: TradingBot?
    @State private var showingBotCreator = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header Stats
                    botStatsHeader
                    
                    // Active Bots Section
                    activeBotsSection
                    
                    // Performance Summary
                    performanceSummarySection
                    
                    // Bot Actions
                    botActionsSection
                    
                    Spacer(minLength: 100)
                }
                .padding()
            }
            .navigationTitle("ProTrader Bots")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add Bot") {
                        showingBotCreator = true
                    }
                    .fontWeight(.semibold)
                    .foregroundColor(DesignSystem.primaryGold)
                }
            }
            .sheet(isPresented: $showingBotCreator) {
                BotCreatorView()
            }
            .refreshable {
                await botManager.refreshBots()
            }
        }
    }
    
    private var botStatsHeader: some View {
        UltraPremiumCard {
            VStack(spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Active Bots")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Text("\(botManager.activeBots.count) of \(botManager.totalBots) running")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("$\(botManager.totalProfit.formatted(.number.precision(.fractionLength(2))))")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(botManager.totalProfit >= 0 ? .green : .red)
                        
                        Text("Total P&L")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                HStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("\(botManager.totalTrades)")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Text("Total Trades")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("\(botManager.overallWinRate.formatted(.number.precision(.fractionLength(1))))%")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(botManager.overallWinRate >= 60 ? .green : .orange)
                        
                        Text("Win Rate")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        Task {
                            await botManager.toggleAllBots()
                        }
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: botManager.areAllBotsActive ? "pause.circle.fill" : "play.circle.fill")
                                .font(.title3)
                            
                            Text(botManager.areAllBotsActive ? "Pause All" : "Start All")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(botManager.areAllBotsActive ? Color.orange : DesignSystem.primaryGold)
                        .cornerRadius(20)
                    }
                }
            }
        }
    }
    
    private var activeBotsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Active Trading Bots")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            if botManager.activeBots.isEmpty {
                EmptyBotStateView {
                    showingBotCreator = true
                }
            } else {
                LazyVStack(spacing: 12) {
                    ForEach(botManager.activeBots) { bot in
                        BotCard(bot: bot) {
                            selectedBot = bot
                        }
                    }
                }
            }
        }
    }
    
    private var performanceSummarySection: some View {
        UltraPremiumCard {
            VStack(alignment: .leading, spacing: 16) {
                Text("Performance Summary")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                    PerformanceMetric(
                        title: "Best Performer",
                        value: botManager.bestPerformingBot?.name ?? "N/A",
                        subtitle: botManager.bestPerformingBot != nil ? "+\(botManager.bestPerformingBot!.profitLoss.formatted(.number.precision(.fractionLength(2))))" : "",
                        color: .green
                    )
                    
                    PerformanceMetric(
                        title: "Most Active",
                        value: botManager.mostActiveBot?.name ?? "N/A",
                        subtitle: botManager.mostActiveBot != nil ? "\(botManager.mostActiveBot!.tradesCount) trades" : "",
                        color: .blue
                    )
                    
                    PerformanceMetric(
                        title: "Highest Win Rate",
                        value: botManager.highestWinRateBot?.name ?? "N/A",
                        subtitle: botManager.highestWinRateBot != nil ? "\(botManager.highestWinRateBot!.winRate.formatted(.number.precision(.fractionLength(1))))%" : "",
                        color: .purple
                    )
                    
                    PerformanceMetric(
                        title: "Total Volume",
                        value: "$\(botManager.totalTradingVolume.formatted(.number.precision(.fractionLength(0))))",
                        subtitle: "All bots",
                        color: .orange
                    )
                }
            }
        }
    }
    
    private var botActionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Quick Actions")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                ActionButton(
                    title: "Create New Bot",
                    icon: "plus.circle.fill",
                    color: .green
                ) {
                    showingBotCreator = true
                }
                
                ActionButton(
                    title: "Bot Analytics",
                    icon: "chart.bar.fill",
                    color: .blue
                ) {
                    // Navigate to analytics
                }
                
                ActionButton(
                    title: "Strategy Library",
                    icon: "book.fill",
                    color: .purple
                ) {
                    // Navigate to strategies
                }
                
                ActionButton(
                    title: "Risk Settings",
                    icon: "shield.fill",
                    color: .orange
                ) {
                    // Navigate to risk settings
                }
            }
        }
    }
}

struct BotCard: View {
    let bot: TradingBot
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            UltraPremiumCard {
                VStack(spacing: 12) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(bot.name)
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            
                            Text(bot.strategy)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            StatusIndicator(status: bot.status)
                            
                            Text("$\(bot.profitLoss.formatted(.number.precision(.fractionLength(2))))")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(bot.profitLoss >= 0 ? .green : .red)
                        }
                    }
                    
                    HStack {
                        MetricPill(
                            title: "Win Rate",
                            value: "\(bot.winRate.formatted(.number.precision(.fractionLength(1))))%",
                            color: bot.winRate >= 60 ? .green : .orange
                        )
                        
                        MetricPill(
                            title: "Trades",
                            value: "\(bot.tradesCount)",
                            color: .blue
                        )
                        
                        Spacer()
                        
                        Text("Last trade: \(bot.lastTradeTime.formatted(.relative(presentation: .named)))")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct EmptyBotStateView: View {
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "robot")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            VStack(spacing: 8) {
                Text("No Active Bots")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("Create your first trading bot to start automated trading")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: action) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                        .font(.title3)
                    
                    Text("Create First Bot")
                        .font(.headline)
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .padding()
                .background(DesignSystem.goldGradient)
                .cornerRadius(12)
                .shadow(color: DesignSystem.primaryGold.opacity(0.4), radius: 8, x: 0, y: 4)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(16)
    }
}

struct StatusIndicator: View {
    let status: BotStatus
    
    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(status.color)
                .frame(width: 8, height: 8)
            
            Text(status.rawValue)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(status.color)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(status.color.opacity(0.1))
        .cornerRadius(12)
    }
}

struct MetricPill: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 2) {
            Text(title)
                .font(.caption2)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(color)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(color.opacity(0.1))
        .cornerRadius(8)
    }
}

struct PerformanceMetric: View {
    let title: String
    let value: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
            
            Text(subtitle)
                .font(.caption)
                .foregroundColor(color)
        }
        .padding()
        .background(color.opacity(0.05))
        .cornerRadius(12)
    }
}

struct ActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct BotCreatorView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var botName = ""
    @State private var selectedStrategy = "Scalping"
    @State private var riskLevel = 0.02
    
    let strategies = ["Scalping", "Swing Trading", "Trend Following", "Mean Reversion"]
    
    var body: some View {
        NavigationView {
            Form {
                Section("Bot Configuration") {
                    TextField("Bot Name", text: $botName)
                    
                    Picker("Strategy", selection: $selectedStrategy) {
                        ForEach(strategies, id: \.self) { strategy in
                            Text(strategy).tag(strategy)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Risk Level: \(riskLevel.formatted(.percent.precision(.fractionLength(2))))")
                            .font(.subheadline)
                        
                        Slider(value: $riskLevel, in: 0.01...0.05, step: 0.001) {
                            Text("Risk Level")
                        } minimumValueLabel: {
                            Text("1%")
                                .font(.caption)
                        } maximumValueLabel: {
                            Text("5%")
                                .font(.caption)
                        }
                    }
                }
            }
            .navigationTitle("Create Bot")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Create") {
                        createBot()
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .disabled(botName.isEmpty)
                }
            }
        }
    }
    
    private func createBot() {
        // Implementation for creating bot
        print("Creating bot: \(botName) with strategy: \(selectedStrategy)")
    }
}

#Preview {
    NavigationView {
        ProTraderBotView()
    }
}