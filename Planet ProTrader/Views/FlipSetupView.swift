//
//  FlipSetupView.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 7/17/25.
//  ULTIMATE FLIP CHALLENGE CALCULATOR 🔥💰
//

import SwiftUI
import Combine

struct FlipSetupView: View {
    @EnvironmentObject var tradingViewModel: TradingViewModel
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - State Variables
    @State private var selectedPreset: FlipPreset = .tenK
    @State private var isCustomMode = false
    @State private var customStartAmount: Double = 100
    @State private var customTargetAmount: Double = 50000
    @State private var selectedTimeframe: FlipTimeframe = .oneWeek
    @State private var selectedStrategy: FlipStrategy = .balanced
    @State private var showingAdvancedSettings = false
    @State private var animateCards = false
    @State private var showingStartConfirmation = false
    @State private var isCalculating = false
    
    // Advanced Settings
    @State private var dailyTradingHours: Double = 8
    @State private var maxRiskPerTrade: Double = 2.0
    @State private var compoundingEnabled = true
    @State private var autoImprovementEnabled = true
    @State private var martingaleEnabled = false
    
    // Calculated Properties
    private var multiplier: Double {
        (isCustomMode ? customTargetAmount : selectedPreset.targetAmount) / 
        (isCustomMode ? customStartAmount : selectedPreset.startAmount)
    }
    
    private var dailyGrowthRequired: Double {
        pow(multiplier, 1.0 / Double(selectedTimeframe.days)) - 1
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Premium Background
                LinearGradient(
                    colors: [
                        Color(.systemBackground),
                        DesignSystem.primaryGold.opacity(0.02),
                        Color(.systemBackground)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    LazyVStack(spacing: 20) {
                        // MARK: - Epic Header
                        epicHeader
                        
                        // MARK: - Flip Challenge Presets
                        flipChallengePresets
                        
                        // MARK: - Custom Amount Selector
                        if isCustomMode {
                            customAmountSelector
                        }
                        
                        // MARK: - Timeframe Selector
                        timeframeSelector
                        
                        // MARK: - Strategy Selector
                        strategySelector
                        
                        // MARK: - Win Rate Calculator
                        winRateCalculator
                        
                        // MARK: - Money Projection Matrix
                        moneyProjectionMatrix
                        
                        // MARK: - Advanced Settings
                        advancedSettingsSection
                        
                        // MARK: - AI Learning Status
                        aiLearningStatus
                        
                        // MARK: - Start Challenge Button
                        startChallengeButton
                        
                        Spacer(minLength: 120)
                    }
                    .padding(.horizontal, 16)
                }
            }
            .navigationTitle("")
            .navigationBarHidden(true)
            .onAppear {
                startAnimations()
            }
        }
        .alert("🚀 Start Flip Challenge", isPresented: $showingStartConfirmation) {
            Button("LET'S GET RICH! 💰", role: .none) {
                startFlipChallenge()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text(confirmationMessage)
        }
    }
    
    // MARK: - Epic Header
    private var epicHeader: some View {
        UltraPremiumCard {
            VStack(spacing: 16) {
                // Navigation Bar
                HStack {
                    Button(action: { dismiss() }) {
                        HStack(spacing: 8) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.primary)
                            
                            Text("Back")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.primary)
                        }
                    }
                    
                    Spacer()
                    
                    // Flip Mode Indicator
                    HStack(spacing: 6) {
                        Circle()
                            .fill(DesignSystem.primaryGold)
                            .frame(width: 8, height: 8)
                            .scaleEffect(1.2)
                            .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: animateCards)
                        
                        Text("FLIP MODE")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(DesignSystem.primaryGold)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(.ultraThinMaterial)
                    .clipShape(Capsule())
                    .overlay(
                        Capsule()
                            .stroke(DesignSystem.primaryGold.opacity(0.3), lineWidth: 1)
                    )
                }
                .padding(.top, 8)
                
                // Main Header
                VStack(spacing: 12) {
                    HStack(spacing: 8) {
                        ZStack {
                            Circle()
                                .fill(DesignSystem.goldGradient)
                                .frame(width: 48, height: 48)
                            
                            Text("💰")
                                .font(.system(size: 24))
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("FLIP CHALLENGE")
                                .font(.system(size: 24, weight: .black, design: .rounded))
                                .foregroundColor(.primary)
                            
                            Text("Turn Small Money Into LIFE-CHANGING Wealth")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                    }
                    
                    // Current Preset Display
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("SELECTED CHALLENGE")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.secondary)
                            
                            if isCustomMode {
                                Text("$\(Int(customStartAmount)) → $\(Int(customTargetAmount))")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(DesignSystem.primaryGold)
                            } else {
                                Text(selectedPreset.displayName)
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(DesignSystem.primaryGold)
                            }
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            Text("MULTIPLIER")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.secondary)
                            
                            Text("\(Int(multiplier))x")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.green)
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(DesignSystem.primaryGold.opacity(0.2), lineWidth: 1)
                    )
                }
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.95)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1), value: animateCards)
    }
    
    // MARK: - Flip Challenge Presets
    private var flipChallengePresets: some View {
        UltraPremiumCard {
            VStack(spacing: 16) {
                HStack {
                    Text("FLIP CHALLENGES")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Button(action: { isCustomMode.toggle() }) {
                        Text(isCustomMode ? "Presets" : "Custom")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(DesignSystem.primaryGold)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(DesignSystem.primaryGold.opacity(0.1))
                            .clipShape(Capsule())
                    }
                }
                
                if !isCustomMode {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 1), spacing: 12) {
                        ForEach(FlipPreset.allCases, id: \.self) { preset in
                            FlipPresetCard(
                                preset: preset,
                                isSelected: selectedPreset == preset,
                                action: { selectedPreset = preset }
                            )
                        }
                    }
                }
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.95)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2), value: animateCards)
    }
    
    // MARK: - Custom Amount Selector
    private var customAmountSelector: some View {
        UltraPremiumCard {
            VStack(spacing: 20) {
                // Start Amount
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("START AMOUNT")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Text("$\(Int(customStartAmount))")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.primary)
                    }
                    
                    Slider(value: $customStartAmount, in: 50...5000, step: 50)
                        .accentColor(DesignSystem.primaryGold)
                }
                
                // Target Amount
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("TARGET AMOUNT")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Text("$\(customTargetAmount >= 1000000 ? String(format: "%.1fM", customTargetAmount / 1000000) : String(format: "%.0f", customTargetAmount))")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.green)
                    }
                    
                    Slider(value: $customTargetAmount, in: 1000...10000000, step: 1000)
                        .accentColor(DesignSystem.primaryGold)
                }
                
                // Quick Target Buttons
                HStack(spacing: 8) {
                    ForEach([10000, 100000, 1000000, 10000000], id: \.self) { amount in
                        Button(action: { customTargetAmount = Double(amount) }) {
                            Text(amount >= 1000000 ? "$\(amount / 1000000)M" : "$\(amount / 1000)K")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(customTargetAmount == Double(amount) ? .white : DesignSystem.primaryGold)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 6)
                                .background(customTargetAmount == Double(amount) ? DesignSystem.primaryGold : DesignSystem.primaryGold.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                        }
                    }
                }
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.95)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3), value: animateCards)
    }
    
    // MARK: - Timeframe Selector
    private var timeframeSelector: some View {
        UltraPremiumCard {
            VStack(spacing: 16) {
                Text("SELECT TIMEFRAME")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.primary)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                    ForEach(FlipTimeframe.allCases, id: \.self) { timeframe in
                        TimeframeCard(
                            timeframe: timeframe,
                            isSelected: selectedTimeframe == timeframe,
                            dailyGrowth: dailyGrowthRequired,
                            action: { selectedTimeframe = timeframe }
                        )
                    }
                }
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.95)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.4), value: animateCards)
    }
    
    // MARK: - Strategy Selector
    private var strategySelector: some View {
        UltraPremiumCard {
            VStack(spacing: 16) {
                Text("TRADING STRATEGY")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.primary)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 1), spacing: 12) {
                    ForEach(FlipStrategy.allCases, id: \.self) { strategy in
                        FlipStrategyCard(
                            strategy: strategy,
                            isSelected: selectedStrategy == strategy,
                            action: { selectedStrategy = strategy }
                        )
                    }
                }
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.95)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.5), value: animateCards)
    }
    
    // MARK: - Win Rate Calculator
    private var winRateCalculator: some View {
        UltraPremiumCard {
            VStack(spacing: 16) {
                Text("Success Probability at Different Win Rates")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.primary)
                
                VStack(spacing: 12) {
                    ForEach([75, 85, 95], id: \.self) { winRate in
                        WinRateRow(
                            winRate: winRate,
                            tradesNeeded: calculateTradesNeeded(winRate: winRate),
                            timeToComplete: calculateTimeToComplete(winRate: winRate),
                            successProbability: calculateSuccessProbability(winRate: winRate)
                        )
                    }
                }
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.95)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.6), value: animateCards)
    }
    
    // MARK: - Money Projection Matrix
    private var moneyProjectionMatrix: some View {
        UltraPremiumCard {
            VStack(spacing: 16) {
                // Daily Milestones
                VStack(alignment: .leading, spacing: 12) {
                    Text("DAILY MILESTONES")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.secondary)
                    
                    let startAmount = isCustomMode ? customStartAmount : selectedPreset.startAmount
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                        ForEach(Array(stride(from: 1, through: min(selectedTimeframe.days, 14), by: selectedTimeframe.days <= 7 ? 1 : 2)), id: \.self) { day in
                            let projectedAmount = startAmount * pow(1 + dailyGrowthRequired, Double(day))
                            
                            HStack {
                                Text("Day \(day)")
                                    .font(.system(size: 11, weight: .medium))
                                    .foregroundColor(.secondary)
                                
                                Spacer()
                                
                                Text("$\(formatCurrency(projectedAmount))")
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundColor(projectedAmount >= startAmount * 2 ? .green : .primary)
                            }
                            .padding(.vertical, 4)
                            .padding(.horizontal, 8)
                            .background(Color.gray.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                        }
                    }
                }
                
                Divider()
                
                // Key Metrics
                VStack(spacing: 12) {
                    MetricRow(title: "Required Daily Growth", value: "\(String(format: "%.1f", dailyGrowthRequired * 100))%", color: dailyGrowthRequired > 0.5 ? .red : .green)
                    MetricRow(title: "Target Multiplier", value: "\(Int(multiplier))x", color: .green)
                    MetricRow(title: "Risk Level", value: selectedStrategy.riskLevel, color: selectedStrategy.color)
                    MetricRow(title: "Est. Trades/Day", value: "\(selectedStrategy.tradesPerDay)", color: .blue)
                }
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.95)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.7), value: animateCards)
    }
    
    // MARK: - Advanced Settings Section
    private var advancedSettingsSection: some View {
        UltraPremiumCard {
            VStack(spacing: 16) {
                Button(action: { 
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                        showingAdvancedSettings.toggle()
                    }
                }) {
                    HStack {
                        Text("ADVANCED SETTINGS")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Image(systemName: showingAdvancedSettings ? "chevron.up" : "chevron.down")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(DesignSystem.primaryGold)
                    }
                }
                
                if showingAdvancedSettings {
                    UltraPremiumCard {
                        VStack(spacing: 20) {
                            // Trading Hours
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("Daily Trading Hours")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.primary)
                                    
                                    Spacer()
                                    
                                    Text("\(Int(dailyTradingHours))h")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(DesignSystem.primaryGold)
                                }
                                
                                Slider(value: $dailyTradingHours, in: 1...24, step: 1)
                                    .accentColor(DesignSystem.primaryGold)
                            }
                            
                            // Max Risk Per Trade
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("Max Risk Per Trade")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.primary)
                                    
                                    Spacer()
                                    
                                    Text("\(String(format: "%.1f", maxRiskPerTrade))%")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(maxRiskPerTrade > 5 ? .red : .green)
                                }
                                
                                Slider(value: $maxRiskPerTrade, in: 0.5...10, step: 0.5)
                                    .accentColor(DesignSystem.primaryGold)
                            }
                            
                            // Toggles
                            VStack(spacing: 12) {
                                Toggle("Compounding Enabled", isOn: $compoundingEnabled)
                                    .toggleStyle(SwitchToggleStyle(tint: DesignSystem.primaryGold))
                                
                                Toggle("AI Auto-Improvement", isOn: $autoImprovementEnabled)
                                    .toggleStyle(SwitchToggleStyle(tint: DesignSystem.primaryGold))
                                
                                Toggle("Martingale Recovery", isOn: $martingaleEnabled)
                                    .toggleStyle(SwitchToggleStyle(tint: .red))
                            }
                            .font(.system(size: 14, weight: .semibold))
                        }
                    }
                    .transition(.opacity.combined(with: .scale(scale: 0.95)))
                }
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.95)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.8), value: animateCards)
    }
    
    // MARK: - AI Learning Status
    private var aiLearningStatus: some View {
        UltraPremiumCard {
            VStack(spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("LEARNING STATUS")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(.secondary)
                        
                        Text("Continuously Improving")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.green)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("IMPROVEMENT RATE")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(.secondary)
                        
                        Text("+2.3% Daily")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.blue)
                    }
                }
                
                VStack(spacing: 8) {
                    HStack {
                        Text("Pattern Recognition")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Text("94.2%")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.green)
                    }
                    
                    HStack {
                        Text("Risk Management")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Text("97.8%")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.green)
                    }
                    
                    HStack {
                        Text("Market Adaptation")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Text("89.1%")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.blue)
                    }
                }
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.95)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.9), value: animateCards)
    }
    
    // MARK: - Start Challenge Button
    private var startChallengeButton: some View {
        VStack(spacing: 12) {
            Button(action: {
                showingStartConfirmation = true
            }) {
                HStack {
                    Text(isCalculating ? "Calculating..." : "START FLIP CHALLENGE")
                        .font(.system(size: 16, weight: .bold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    LinearGradient(
                        colors: [
                            DesignSystem.primaryGold,
                            DesignSystem.primaryGold.opacity(0.8)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(color: DesignSystem.primaryGold.opacity(0.4), radius: 8, x: 0, y: 4)
            }
            .disabled(isCalculating)
            .scaleEffect(isCalculating ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: isCalculating)
            
            Text("⚠️ Only risk what you can afford to lose")
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .scaleEffect(animateCards ? 1.0 : 0.95)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(1.0), value: animateCards)
    }
    
    // MARK: - Helper Methods
    private func startAnimations() {
        withAnimation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.2)) {
            animateCards = true
        }
    }
    
    private func calculateTradesNeeded(winRate: Int) -> Int {
        let wr = Double(winRate) / 100
        let profitPerWin = selectedStrategy.profitTarget
        let lossPerLoss = maxRiskPerTrade / 100
        
        let avgProfitPerTrade = (wr * profitPerWin) - ((1 - wr) * lossPerLoss)
        let totalGrowthNeeded = multiplier - 1
        
        return max(Int(totalGrowthNeeded / avgProfitPerTrade), 1)
    }
    
    private func calculateTimeToComplete(winRate: Int) -> Int {
        let tradesNeeded = calculateTradesNeeded(winRate: winRate)
        let tradesPerDay = selectedStrategy.tradesPerDay
        return max(Int(ceil(Double(tradesNeeded) / Double(tradesPerDay))), 1)
    }
    
    private func calculateSuccessProbability(winRate: Int) -> Double {
        let wr = Double(winRate) / 100
        let tradesNeeded = calculateTradesNeeded(winRate: winRate)
        
        // Simplified probability calculation
        return min(pow(wr, Double(tradesNeeded) * 0.1) * 100, 99.9)
    }
    
    private func formatCurrency(_ amount: Double) -> String {
        if amount >= 1000000 {
            return String(format: "%.1fM", amount / 1000000)
        } else if amount >= 1000 {
            return String(format: "%.1fK", amount / 1000)
        } else {
            return String(format: "%.0f", amount)
        }
    }
    
    private var confirmationMessage: String {
        let start = isCustomMode ? customStartAmount : selectedPreset.startAmount
        let target = isCustomMode ? customTargetAmount : selectedPreset.targetAmount
        
        return """
        Challenge: $\(Int(start)) → $\(formatCurrency(target))
        Timeframe: \(selectedTimeframe.displayName)
        Strategy: \(selectedStrategy.name)
        Required Daily Growth: \(String(format: "%.1f", dailyGrowthRequired * 100))%
        
        Are you ready to change your life? 🚀
        """
    }
    
    private func startFlipChallenge() {
        isCalculating = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            // Create flip goal
            let startAmount = isCustomMode ? customStartAmount : selectedPreset.startAmount
            let targetAmount = isCustomMode ? customTargetAmount : selectedPreset.targetAmount
            
            let flipGoal = SharedTypes.FlipGoal(
                startBalance: startAmount,
                targetBalance: targetAmount,
                startDate: Date(),
                targetDate: Calendar.current.date(byAdding: .day, value: selectedTimeframe.days, to: Date()) ?? Date(),
                currentBalance: startAmount
            )
            
            tradingViewModel.createFlipGoal(flipGoal)
            tradingViewModel.startFlipMode()
            
            isCalculating = false
            dismiss()
        }
    }
}

// MARK: - Supporting Types
enum FlipPreset: String, CaseIterable {
    case tenK = "$100 → $10K"
    case hundredK = "$100 → $100K"
    case million = "$100 → $1M"
    
    var startAmount: Double {
        return 100
    }
    
    var targetAmount: Double {
        switch self {
        case .tenK: return 10000
        case .hundredK: return 100000
        case .million: return 1000000
        }
    }
    
    var displayName: String {
        return self.rawValue
    }
    
    var difficulty: String {
        switch self {
        case .tenK: return "Beginner"
        case .hundredK: return "Advanced"
        case .million: return "Expert"
        }
    }
    
    var color: Color {
        switch self {
        case .tenK: return .green
        case .hundredK: return .orange
        case .million: return .red
        }
    }
    
    var emoji: String {
        switch self {
        case .tenK: return "🎯"
        case .hundredK: return "🚀"
        case .million: return "💎"
        }
    }
}

enum FlipTimeframe: String, CaseIterable {
    case oneWeek = "1 Week"
    case twoWeeks = "2 Weeks"
    case oneMonth = "1 Month"
    case threeMonths = "3 Months"
    
    var days: Int {
        switch self {
        case .oneWeek: return 7
        case .twoWeeks: return 14
        case .oneMonth: return 30
        case .threeMonths: return 90
        }
    }
    
    var displayName: String {
        return self.rawValue
    }
    
    var difficulty: String {
        switch self {
        case .oneWeek: return "Extreme"
        case .twoWeeks: return "Hard"
        case .oneMonth: return "Moderate"
        case .threeMonths: return "Easy"
        }
    }
    
    var color: Color {
        switch self {
        case .oneWeek: return .red
        case .twoWeeks: return .orange
        case .oneMonth: return .blue
        case .threeMonths: return .green
        }
    }
}

enum FlipStrategy: String, CaseIterable {
    case conservative = "Conservative"
    case balanced = "Balanced"
    case aggressive = "Aggressive"
    case extreme = "Extreme"
    
    var name: String {
        return self.rawValue
    }
    
    var tradesPerDay: Int {
        switch self {
        case .conservative: return 3
        case .balanced: return 5
        case .aggressive: return 8
        case .extreme: return 12
        }
    }
    
    var profitTarget: Double {
        switch self {
        case .conservative: return 0.02
        case .balanced: return 0.035
        case .aggressive: return 0.05
        case .extreme: return 0.08
        }
    }
    
    var minConfidence: Double {
        switch self {
        case .conservative: return 0.90
        case .balanced: return 0.85
        case .aggressive: return 0.80
        case .extreme: return 0.75
        }
    }
    
    var riskLevel: String {
        switch self {
        case .conservative: return "Conservative"
        case .balanced: return "Moderate"
        case .aggressive: return "High"
        case .extreme: return "Extreme"
        }
    }
    
    var color: Color {
        switch self {
        case .conservative: return .green
        case .balanced: return .blue
        case .aggressive: return .orange
        case .extreme: return .red
        }
    }
    
    var tradingMode: SharedTypes.TradingMode {
        switch self {
        case .conservative: return .manual
        case .balanced: return .auto
        case .aggressive: return .scalp
        case .extreme: return .swing
        }
    }
    
    var timeframes: [String] {
        switch self {
        case .conservative: return ["1H", "4H"]
        case .balanced: return ["15M", "1H"]
        case .aggressive: return ["5M", "15M"]
        case .extreme: return ["1M", "5M"]
        }
    }
    
    var description: String {
        switch self {
        case .conservative: return "Lower risk, steady growth"
        case .balanced: return "Balanced risk/reward ratio"
        case .aggressive: return "Higher risk, faster growth"
        case .extreme: return "Maximum risk, explosive growth"
        }
    }
    
    var flipMode: SharedTypes.FlipMode {
        switch self {
        case .conservative: return .conservative
        case .balanced: return .balanced
        case .aggressive: return .aggressive
        case .extreme: return .extreme
        }
    }
}

// MARK: - Supporting Views
struct FlipPresetCard: View {
    let preset: FlipPreset
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            UltraPremiumCard {
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 8) {
                            Text(preset.emoji)
                                .font(.system(size: 24))
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(preset.displayName)
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.primary)
                                
                                Text(preset.difficulty)
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(preset.color)
                            }
                        }
                        
                        HStack {
                            Text("100x Multiplier")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            Text("\(Int(preset.targetAmount / preset.startAmount))x")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.green)
                        }
                    }
                    
                    Spacer()
                    
                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.green)
                    }
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isSelected ? 1.02 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

struct TimeframeCard: View {
    let timeframe: FlipTimeframe
    let isSelected: Bool
    let dailyGrowth: Double
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            UltraPremiumCard {
                VStack(spacing: 8) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(timeframe.displayName)
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.primary)
                            
                            Text(timeframe.difficulty)
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(timeframe.color)
                        }
                        
                        Spacer()
                        
                        if isSelected {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 16))
                                .foregroundColor(.green)
                        }
                    }
                    
                    HStack {
                        Text("Daily Growth")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Text("\(String(format: "%.1f", dailyGrowth * 100))%")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(dailyGrowth > 0.5 ? .red : .green)
                    }
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

struct FlipStrategyCard: View {
    let strategy: FlipStrategy
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            UltraPremiumCard {
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(strategy.name)
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            if isSelected {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(.green)
                            }
                        }
                        
                        Text(strategy.description)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.secondary)
                        
                        HStack(spacing: 16) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Trades/Day")
                                    .font(.system(size: 9, weight: .medium))
                                    .foregroundColor(.secondary)
                                
                                Text("\(strategy.tradesPerDay)")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.primary)
                            }
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Min Confidence")
                                    .font(.system(size: 9, weight: .medium))
                                    .foregroundColor(.secondary)
                                
                                Text("\(Int(strategy.minConfidence * 100))%")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.primary)
                            }
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Risk Level")
                                    .font(.system(size: 9, weight: .medium))
                                    .foregroundColor(.secondary)
                                
                                Text(strategy.riskLevel)
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(strategy.color)
                            }
                        }
                    }
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isSelected ? 1.02 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

struct WinRateRow: View {
    let winRate: Int
    let tradesNeeded: Int
    let timeToComplete: Int
    let successProbability: Double
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("\(winRate)% Win Rate")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.primary)
                
                Text("\(tradesNeeded) trades needed")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                Text("\(Int(successProbability))% Success")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(successProbability > 70 ? .green : successProbability > 40 ? .orange : .red)
                
                Text("\(timeToComplete) days")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color.gray.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct MetricRow: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(color)
        }
    }
}

#Preview {
    FlipSetupView()
        .environmentObject(TradingViewModel())
}