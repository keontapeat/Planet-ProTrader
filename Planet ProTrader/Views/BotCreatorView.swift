//
//  BotCreatorView.swift
//  Planet ProTrader
//
//  Created by AI Assistant on 1/25/25.
//

import SwiftUI

struct BotCreatorView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var botName = ""
    @State private var selectedStrategy = BotStrategy.scalping
    @State private var riskLevel = 0.5
    @State private var initialCapital = 1000.0
    @State private var maxDrawdown = 0.1
    @State private var targetProfit = 0.2
    @State private var isCreating = false
    
    private let strategies = BotStrategy.allCases
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    headerSection
                    
                    // Bot Configuration
                    configurationSection
                    
                    // Risk Management
                    riskManagementSection
                    
                    // Strategy Selection
                    strategySection
                    
                    // Create Button
                    createButtonSection
                    
                    Spacer(minLength: 100)
                }
                .padding()
            }
            .navigationTitle("Create AI Bot")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private var headerSection: some View {
        UltraPremiumCard {
            VStack(spacing: 16) {
                Image(systemName: "robot.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(DesignSystem.goldGradient)
                
                VStack(spacing: 8) {
                    Text("Create Your AI Trading Bot")
                        .font(.title2.bold())
                        .foregroundColor(.primary)
                    
                    Text("Configure your personalized trading assistant with advanced AI capabilities")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
        }
    }
    
    private var configurationSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Bot Configuration")
                .font(.headline.bold())
                .foregroundColor(.primary)
            
            UltraPremiumCard {
                VStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Bot Name")
                            .font(.subheadline.bold())
                        
                        TextField("Enter bot name", text: $botName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Initial Capital")
                            .font(.subheadline.bold())
                        
                        HStack {
                            Text("$")
                                .foregroundColor(.secondary)
                            
                            TextField("1000", value: $initialCapital, format: .number)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                    }
                }
            }
        }
    }
    
    private var riskManagementSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Risk Management")
                .font(.headline.bold())
                .foregroundColor(.primary)
            
            UltraPremiumCard {
                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Risk Level")
                                .font(.subheadline.bold())
                            
                            Spacer()
                            
                            Text(riskLevelText)
                                .font(.caption.bold())
                                .foregroundColor(riskLevelColor)
                        }
                        
                        Slider(value: $riskLevel, in: 0...1)
                            .tint(DesignSystem.primaryGold)
                    }
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Max Drawdown")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Text("\(Int(maxDrawdown * 100))%")
                                .font(.subheadline.bold())
                                .foregroundColor(.red)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            Text("Target Profit")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Text("\(Int(targetProfit * 100))%")
                                .font(.subheadline.bold())
                                .foregroundColor(.green)
                        }
                    }
                    
                    VStack(spacing: 8) {
                        HStack {
                            Text("Max Drawdown")
                                .font(.caption)
                            Spacer()
                            Text("\(Int(maxDrawdown * 100))%")
                                .font(.caption.bold())
                        }
                        
                        Slider(value: $maxDrawdown, in: 0.05...0.5)
                            .tint(.red)
                    }
                    
                    VStack(spacing: 8) {
                        HStack {
                            Text("Target Profit")
                                .font(.caption)
                            Spacer()
                            Text("\(Int(targetProfit * 100))%")
                                .font(.caption.bold())
                        }
                        
                        Slider(value: $targetProfit, in: 0.1...1.0)
                            .tint(.green)
                    }
                }
            }
        }
    }
    
    private var strategySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Trading Strategy")
                .font(.headline.bold())
                .foregroundColor(.primary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                ForEach(strategies, id: \.self) { strategy in
                    StrategyCard(
                        strategy: strategy,
                        isSelected: selectedStrategy == strategy
                    ) {
                        selectedStrategy = strategy
                    }
                }
            }
        }
    }
    
    private var createButtonSection: some View {
        VStack(spacing: 12) {
            Button(action: {
                createBot()
            }) {
                HStack {
                    if isCreating {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(0.8)
                    } else {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(isCreating ? "Creating Bot..." : "Create AI Bot")
                            .font(.headline.bold())
                        
                        Text(isCreating ? "Initializing AI systems" : "Deploy your trading assistant")
                            .font(.caption)
                            .opacity(0.8)
                    }
                    
                    Spacer()
                    
                    if !isCreating {
                        Image(systemName: "chevron.right")
                            .font(.title3)
                    }
                }
                .foregroundColor(.white)
                .padding()
                .background(
                    LinearGradient(
                        colors: [DesignSystem.primaryGold, DesignSystem.primaryGold.opacity(0.8)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(12)
            }
            .disabled(botName.isEmpty || isCreating)
            
            Text("Your bot will start trading automatically once created")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
    }
    
    // MARK: - Helper Properties
    
    private var riskLevelText: String {
        switch riskLevel {
        case 0..<0.3: return "Conservative"
        case 0.3..<0.7: return "Moderate"
        default: return "Aggressive"
        }
    }
    
    private var riskLevelColor: Color {
        switch riskLevel {
        case 0..<0.3: return .green
        case 0.3..<0.7: return .orange
        default: return .red
        }
    }
    
    // MARK: - Actions
    
    private func createBot() {
        isCreating = true
        
        // Simulate bot creation
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            isCreating = false
            dismiss()
        }
    }
}

// MARK: - Bot Strategy Enum

enum BotStrategy: String, CaseIterable {
    case scalping = "Scalping"
    case dayTrading = "Day Trading"
    case swing = "Swing Trading"
    case grid = "Grid Trading"
    case martingale = "Martingale"
    case arbitrage = "Arbitrage"
    
    var description: String {
        switch self {
        case .scalping: return "Quick trades for small profits"
        case .dayTrading: return "Trades within market hours"
        case .swing: return "Hold positions for days/weeks"
        case .grid: return "Buy/sell at predetermined intervals"
        case .martingale: return "Double position after losses"
        case .arbitrage: return "Exploit price differences"
        }
    }
    
    var icon: String {
        switch self {
        case .scalping: return "bolt.fill"
        case .dayTrading: return "clock.fill"
        case .swing: return "chart.line.uptrend.xyaxis"
        case .grid: return "grid"
        case .martingale: return "arrow.clockwise"
        case .arbitrage: return "arrow.left.arrow.right"
        }
    }
    
    var color: Color {
        switch self {
        case .scalping: return .orange
        case .dayTrading: return .blue
        case .swing: return .green
        case .grid: return .purple
        case .martingale: return .red
        case .arbitrage: return .teal
        }
    }
}

// MARK: - Strategy Card

struct StrategyCard: View {
    let strategy: BotStrategy
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(strategy.color.opacity(0.1))
                        .frame(width: 48, height: 48)
                    
                    Image(systemName: strategy.icon)
                        .font(.title2)
                        .foregroundColor(strategy.color)
                }
                
                VStack(spacing: 4) {
                    Text(strategy.rawValue)
                        .font(.subheadline.bold())
                        .foregroundColor(.primary)
                    
                    Text(strategy.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? strategy.color : Color.clear, lineWidth: 2)
                    )
            )
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    BotCreatorView()
}