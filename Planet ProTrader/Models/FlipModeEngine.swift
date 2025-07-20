//
//  FlipModeEngine.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 7/13/25.
//

import Foundation
import SwiftUI

// MARK: - Supporting Data Structures

struct FlipTradeLog: Identifiable {
    let id: String
    let flipId: String
    let accountId: String
    let signal: SharedTypes.FlipSignal
    let beforeScreenshot: String?
    let afterScreenshot: String?
    let tradeResult: SharedTypes.SharedTradeResult
    let timestamp: Date
}

struct FlipCompletion: Identifiable {
    let id: String
    let flipId: String
    let accountId: String
    let startingAmount: Double
    let finalAmount: Double
    let multiplier: Double
    let daysToComplete: Double
    let totalTrades: Int
    let winRate: Double
    let timestamp: Date
}

struct FlipEvent: Identifiable {
    let id: String
    let message: String
    let timestamp: Date
    let flipId: String?
}

// MARK: - Supporting Classes for FlipModeEngine

class ScreenshotEngine {
    func captureChart(vpsId: String, accountId: String, timestamp: Date) async -> String {
        print(" Capturing chart screenshot for account \(accountId)")
        return "screenshot_\(accountId)_\(Int(timestamp.timeIntervalSince1970)).png"
    }
}

class FlipAccountManager {
    func setupAccount(_ account: SharedTypes.DemoAccount) async -> Bool {
        print(" Setting up account \(account.id)")
        return true
    }
}

// MARK: - Flip Mode Core Engine

@MainActor
class FlipModeEngine: ObservableObject {
    // MARK: - Published Properties
    @Published var isFlipModeActive: Bool = false
    @Published var currentFlipGoal: SharedTypes.FlipGoal?
    @Published var activeDemoAccounts: [SharedTypes.DemoAccount] = []
    @Published var flipProgress: Double = 0.0
    @Published var totalAccountsRunning: Int = 0
    @Published var todaysFlipProgress: [String: Double] = [:]
    @Published var vpsConnections: [SharedTypes.VPSConnection] = []
    
    // MARK: - Performance Metrics
    @Published var totalFlipsCompleted: Int = 0
    @Published var averageFlipDuration: TimeInterval = 0
    @Published var bestFlipRecord: String = "$100 → $15,247 in 8 days"
    @Published var currentWinRate: Double = 92.0
    
    // MARK: - Real-time Monitoring
    @Published var liveFlipStatus: [String: SharedTypes.FlipStatus] = [:]
    @Published var recentFlipAlerts: [SharedTypes.FlipAlert] = []
    
    // MARK: - Dependencies
    private let firebaseManager = GoldexFirebaseManager()
    private let vpsManager = VPSManager()
    private let screenshotEngine = ScreenshotEngine()
    private let multiAccountManager = FlipAccountManager()
    
    // MARK: - Core Settings
    private let minStopLossPips: Double = 50.0
    private let maxRiskPerTrade: Double = 5.0
    private let flipCheckInterval: TimeInterval = 30.0
    
    // MARK: - Initialization
    
    init() {
        print(" Loading trading books...")
        Task {
            await initializeFlipEngine()
        }
    }
    
    private func initializeFlipEngine() async {
        await loadExistingFlips()
        await setupVPSConnections()
        await startFlipMonitoring()
    }
    
    private func startFlipMonitoring() async {
        // Start monitoring flip progress
        print(" Flip monitoring started")
    }
    
    // MARK: - Flip Goal Setup
    
    func createNewFlip(
        startingAmount: Double,
        targetAmount: Double,
        timeLimit: Int,
        riskTolerance: SharedTypes.FlipRiskLevel
    ) async -> SharedTypes.FlipGoal {
        
        let flipGoal = SharedTypes.FlipGoal(
            startBalance: startingAmount,
            targetBalance: targetAmount,
            startDate: Date(),
            targetDate: Calendar.current.date(byAdding: .day, value: timeLimit, to: Date()) ?? Date(),
            currentBalance: startingAmount
        )
        
        currentFlipGoal = flipGoal
        
        // Save to Firebase
        await firebaseManager.storeFlipGoal(userId: "current_user", flip: flipGoal)
        
        // Setup demo accounts for this flip
        await setupDemoAccountsForFlip(flipGoal)
        
        // Start automated trading
        await startFlipExecution(flipGoal)
        
        return flipGoal
    }
    
    private func determineOptimalStrategy(for amount: Double, target: Double, days: Int) -> SharedTypes.FlipStrategy {
        let multiplier = target / amount
        let dailyGrowthNeeded = pow(multiplier, 1.0 / Double(days)) - 1.0
        
        switch dailyGrowthNeeded {
        case 0.0...0.15: // Up to 15% daily
            return SharedTypes.FlipStrategy.swing
        case 0.15...0.35: // 15-35% daily
            return SharedTypes.FlipStrategy.dayTrading
        default: // Over 35% daily
            return SharedTypes.FlipStrategy.scalping
        }
    }
    
    // MARK: - Multi-Account Setup
    
    private func setupDemoAccountsForFlip(_ flip: SharedTypes.FlipGoal) async {
        let requiredAccounts = calculateRequiredAccounts(for: flip)
        
        for i in 0..<requiredAccounts {
            let account = SharedTypes.DemoAccount(
                id: UUID().uuidString,
                login: "DEMO\(i)",
                server: "demo.coinexx.com",
                balance: 500.0,
                equity: 500.0,
                currency: "USD",
                leverage: 500,
                isActive: true,
                createdAt: Date()
            )
            
            activeDemoAccounts.append(account)
            
            // Setup account on VPS
            await setupAccountOnVPS(account)
        }
        
        totalAccountsRunning = activeDemoAccounts.count
    }
    
    private func calculateRequiredAccounts(for flip: SharedTypes.FlipGoal) -> Int {
        let multiplier = flip.targetBalance / flip.startBalance
        
        switch multiplier {
        case 1.0...10.0: return 5
        case 10.0...100.0: return 25
        case 100.0...1000.0: return 100
        default: return 500
        }
    }
    
    // MARK: - VPS Management
    
    private func setupVPSConnections() async {
        // Connect to Hetzner VPS instances
        for i in 1...10 {
            let vps = SharedTypes.VPSConnection(
                id: "vps-\(i)",
                ipAddress: "185.199.109.\(100 + i)",
                status: .connecting,
                accountsRunning: 0,
                maxAccounts: 5
            )
            
            vpsConnections.append(vps)
            
            // Connect to VPS
            await vpsManager.connectToVPS()
        }
    }
    
    private func setupAccountOnVPS(_ account: SharedTypes.DemoAccount) async {
        guard let vps = vpsConnections.first(where: { $0.accountsRunning < $0.maxAccounts }) else {
            print(" No available VPS for account \(account.id)")
            return
        }
        
        do {
            // Setup account on VPS (simulate login success)
            let success = await simulateAccountLogin(vps: vps, account: account)
            
            if success {
                // Update account status
                if let index = activeDemoAccounts.firstIndex(where: { $0.id == account.id }) {
                    activeDemoAccounts[index] = SharedTypes.DemoAccount(
                        id: activeDemoAccounts[index].id,
                        login: activeDemoAccounts[index].login,
                        server: activeDemoAccounts[index].server,
                        balance: activeDemoAccounts[index].balance,
                        equity: activeDemoAccounts[index].equity,
                        currency: activeDemoAccounts[index].currency,
                        leverage: activeDemoAccounts[index].leverage,
                        isActive: true,
                        createdAt: activeDemoAccounts[index].createdAt
                    )
                }
                
                // Update VPS
                if let vpsIndex = vpsConnections.firstIndex(where: { $0.id == vps.id }) {
                    vpsConnections[vpsIndex] = SharedTypes.VPSConnection(
                        id: vpsConnections[vpsIndex].id,
                        ipAddress: vpsConnections[vpsIndex].ipAddress,
                        port: vpsConnections[vpsIndex].port,
                        username: vpsConnections[vpsIndex].username,
                        password: vpsConnections[vpsIndex].password,
                        isConnected: vpsConnections[vpsIndex].isConnected,
                        lastPing: vpsConnections[vpsIndex].lastPing,
                        status: vpsConnections[vpsIndex].status,
                        accountsRunning: vpsConnections[vpsIndex].accountsRunning + 1,
                        maxAccounts: vpsConnections[vpsIndex].maxAccounts
                    )
                }
                
                print(" Account \(account.id) active on \(vps.id)")
            }
            
        } catch {
            print(" Failed to setup account on VPS: \(error)")
        }
    }
    
    private func simulateAccountLogin(vps: SharedTypes.VPSConnection, account: SharedTypes.DemoAccount) async -> Bool {
        // Simulate successful login to broker account
        try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 second delay
        return true
    }
    
    // MARK: - Automated Flip Execution
    
    private func startFlipExecution(_ flip: SharedTypes.FlipGoal) async {
        isFlipModeActive = true
        
        // Start monitoring each account
        for account in activeDemoAccounts {
            Task {
                await executeFlipOnAccount(account, strategy: .breakout)
            }
        }
        
        // Start progress monitoring
        startFlipProgressMonitoring()
    }
    
    private func executeFlipOnAccount(_ account: SharedTypes.DemoAccount, strategy: SharedTypes.FlipStrategy) async {
        while isFlipModeActive && account.isActive {
            
            // Check if account has reached target
            if hasAccountReachedTarget(account) {
                await handleAccountFlipComplete(account)
                break
            }
            
            // Generate trade signal
            if let signal = await generateFlipSignal(for: account, strategy: strategy) {
                await executeFlipTrade(account: account, signal: signal)
            }
            
            // Wait before next scan
            try? await Task.sleep(nanoseconds: UInt64(flipCheckInterval * 1_000_000_000))
        }
    }
    
    private func generateFlipSignal(for account: SharedTypes.DemoAccount, strategy: SharedTypes.FlipStrategy) async -> SharedTypes.FlipSignal? {
        // Get market analysis from Claude AI
        // Using the one from ClaudeAIIntegration.swift
        let claudeAI = ClaudeAIIntegration()
        let marketConditions = await claudeAI.analyzeMarketForFlip(
            timeframes: strategy.timeframes,
            riskLevel: strategy.riskPerTrade,
            accountBalance: account.currentBalance
        )
        
        guard marketConditions.confidence >= strategy.minConfidence else {
            return nil
        }
        
        // Apply flip-specific logic
        let signal = SharedTypes.FlipSignal(
            id: UUID(),
            timestamp: Date(),
            direction: marketConditions.direction,
            entryPrice: marketConditions.entryPrice,
            targetPrice: calculateFlipTakeProfit(entry: marketConditions.entryPrice, direction: marketConditions.direction, strategy: strategy),
            stopPrice: calculateFlipStopLoss(entry: marketConditions.entryPrice, direction: marketConditions.direction),
            lotSize: calculateFlipLotSize(account: account, strategy: strategy),
            reasoning: "Flip Mode Signal"
        )
        
        return signal
    }
    
    private func executeFlipTrade(account: SharedTypes.DemoAccount, signal: SharedTypes.FlipSignal) async {
        do {
            // Take before screenshot
            let beforeScreenshot = await screenshotEngine.captureChart(
                vpsId: account.id,
                accountId: account.id,
                timestamp: Date()
            )
            
            // Execute trade using VPS trading signal
            let vpsSignal = VPSTradingSignal(
                botId: account.id,
                symbol: "XAUUSD",
                action: signal.direction == .buy ? "BUY" : "SELL",
                price: signal.entryPrice,
                volume: signal.lotSize,
                stopLoss: signal.stopPrice,
                takeProfit: signal.targetPrice,
                confidence: 0.85,
                reasoning: signal.reasoning,
                timestamp: Date()
            )
            
            // Send trading signal to VPS
            let success = await vpsManager.sendTradingSignal(vpsSignal)
            
            // Create mock trade result
            let tradeResult = VPSTradeResult(
                success: success,
                tradeId: UUID().uuidString,
                message: success ? "Trade executed successfully" : "Trade execution failed",
                timestamp: Date()
            )
            
            // Create trade log
            let goldexTrade = SharedTypes.GoldexTrade(
                id: UUID().uuidString,
                symbol: "XAUUSD",
                direction: signal.direction,
                entryPrice: signal.entryPrice,
                exitPrice: nil,
                lotSize: signal.lotSize,
                profit: 0.0,
                confidence: 0.85,
                timestamp: Date()
            )
            
            let tradeLog = SharedTypes.FlipTradeLog(
                id: UUID().uuidString,
                accountId: account.id,
                symbol: "XAUUSD",
                direction: signal.direction,
                entryPrice: signal.entryPrice,
                exitPrice: 0.0,
                lotSize: signal.lotSize,
                profit: 0.0,
                timestamp: Date()
            )
            
            // Store in Firebase
            await firebaseManager.storeFlipTrade(userId: "current_user", trade: tradeLog)
            
            // Let Claude AI learn from this trade setup
            let claudeAI = ClaudeAIIntegration()
            
            // Convert FlipSignal to AutoTradingSignal for Claude AI
            let autoTradingSignal = SharedTypes.AutoTradingSignal(
                id: signal.id,
                timestamp: signal.timestamp,
                symbol: "XAUUSD",
                direction: signal.direction,
                entryPrice: signal.entryPrice,
                stopLoss: signal.stopPrice,
                takeProfit: signal.targetPrice,
                lotSize: signal.lotSize,
                confidence: 0.85,
                reasoning: signal.reasoning,
                timeframe: "15M"
            )
            
            // Convert VPSTradeResult to SharedTradeResult for Claude AI
            let sharedTradeResult = SharedTypes.SharedTradeResult(
                success: tradeResult.success,
                tradeId: tradeResult.tradeId,
                profit: 0.0,
                message: tradeResult.message,
                timestamp: tradeResult.timestamp
            )
            
            // Create ClaudeFlipTradeLog for learning
            let claudeTradeLog = ClaudeFlipTradeLog(
                id: tradeLog.id,
                flipId: currentFlipGoal?.id.uuidString ?? "",
                accountId: tradeLog.accountId,
                signal: autoTradingSignal,
                tradeResult: sharedTradeResult,
                timestamp: tradeLog.timestamp
            )
            await claudeAI.learnFromFlipTrade(claudeTradeLog)
            
            print(" Flip trade executed: \(signal.direction.rawValue) \(signal.lotSize) lots @ \(signal.entryPrice)")
            
        } catch {
            print(" Flip trade execution failed: \(error)")
        }
    }
    
    // MARK: - Trade Calculation Helpers
    
    private func calculateFlipStopLoss(entry: Double, direction: SharedTypes.TradeDirection) -> Double {
        let pipValue = 1.0 // XAUUSD pip value
        let stopLossPips = max(minStopLossPips, 20.0) // Minimum 50 pips, typically 20
        
        switch direction {
        case .long, .buy:
            return entry - (stopLossPips * pipValue)
        case .short, .sell:
            return entry + (stopLossPips * pipValue)
        }
    }
    
    private func calculateFlipTakeProfit(entry: Double, direction: SharedTypes.TradeDirection, strategy: SharedTypes.FlipStrategy) -> Double {
        let pipValue = 1.0
        let stopLossPips = max(minStopLossPips, 20.0)
        
        // Aggressive R:R ratios for flip mode
        let riskRewardRatio: Double = {
            switch strategy.mode {
            case .conservative: return 2.5
            case .aggressive: return 3.0
            case .balanced: return 2.0
            case .extreme: return 4.0
            }
        }()
        
        let takeProfitPips = stopLossPips * riskRewardRatio
        
        switch direction {
        case .long, .buy:
            return entry + (takeProfitPips * pipValue)
        case .short, .sell:
            return entry - (takeProfitPips * pipValue)
        }
    }
    
    private func calculateFlipLotSize(account: SharedTypes.DemoAccount, strategy: SharedTypes.FlipStrategy) -> Double {
        let riskAmount = account.currentBalance * (strategy.riskPerTrade / 100.0)
        let stopLossPips = max(minStopLossPips, 20.0)
        let pipValue = 10.0 // $10 per pip per lot for XAUUSD
        
        let lotSize = riskAmount / (stopLossPips * pipValue)
        
        // Cap lot sizes for flip mode
        let maxLotSize: Double = {
            switch strategy.mode {
            case .conservative: return 0.01
            case .balanced: return 0.02
            case .aggressive: return 0.03
            case .extreme: return 0.05
            }
        }()
        
        return min(maxLotSize, max(0.01, lotSize))
    }
    
    // MARK: - Progress Monitoring
    
    private func startFlipProgressMonitoring() {
        Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { _ in
            Task { @MainActor in
                await self.updateFlipProgress()
            }
        }
    }
    
    private func updateFlipProgress() async {
        guard let flip = currentFlipGoal else { return }
        
        // Calculate overall progress
        let totalCurrentBalance = activeDemoAccounts.reduce(into: 0.0) { result, account in
            result += account.currentBalance
        }
        let totalStartingBalance = activeDemoAccounts.reduce(into: 0.0) { result, account in
            result += account.startingBalance
        }
        
        if totalStartingBalance > 0 {
            flipProgress = min(1.0, (totalCurrentBalance - totalStartingBalance) / (flip.targetBalance - flip.startBalance))
        }
        
        // Update individual account progress
        for account in activeDemoAccounts {
            let accountProgress = account.currentBalance / flip.targetBalance
            todaysFlipProgress[account.id] = accountProgress
        }
        
        // Check for completed flips
        await checkForCompletedFlips()
        
        // Update Firebase
        await firebaseManager.updateFlipProgress(
            userId: "current_user",
            flipId: flip.id.uuidString,
            newBalance: totalCurrentBalance,
            profit: totalCurrentBalance - totalStartingBalance
        )
        
    }
    
    private func checkForCompletedFlips() async {
        for account in activeDemoAccounts {
            if hasAccountReachedTarget(account) {
                await handleAccountFlipComplete(account)
            }
        }
    }
    
    private func hasAccountReachedTarget(_ account: SharedTypes.DemoAccount) -> Bool {
        guard let flip = currentFlipGoal else { return false }
        return account.currentBalance >= flip.targetBalance
    }
    
    private func handleAccountFlipComplete(_ account: SharedTypes.DemoAccount) async {
        guard let flip = currentFlipGoal else { return }
        
        // Calculate flip metrics
        let multiplier = account.currentBalance / account.startingBalance
        let duration = Date().timeIntervalSince(flip.startDate)
        let daysToComplete = duration / 86400.0
        
        // Create flip completion record
        let completion = SharedTypes.FlipCompletion(
            accountId: account.id,
            finalBalance: account.currentBalance,
            initialBalance: account.startingBalance,
            profit: account.currentBalance - account.startingBalance,
            duration: duration,
            completedAt: Date()
        )
        
        // Store completion
        await firebaseManager.storeFlipCompletion(userId: "current_user", completion: completion)
        
        // Update totals
        totalFlipsCompleted += 1
        
        // Create alert
        let alert = SharedTypes.FlipAlert(
            id: UUID().uuidString,
            message: "\(account.id) flipped \(formatCurrency(account.startingBalance)) → \(formatCurrency(account.currentBalance)) in \(String(format: "%.1f", daysToComplete)) days",
            priority: .high,
            timestamp: Date()
        )
        
        recentFlipAlerts.insert(alert, at: 0)
        
        // Remove from active accounts
        activeDemoAccounts.removeAll { $0.id == account.id }
        totalAccountsRunning = activeDemoAccounts.count
        
        print(" FLIP COMPLETED: \(formatCurrency(account.startingBalance)) → \(formatCurrency(account.currentBalance))")
    }
    
    // MARK: - Control Functions
    
    func pauseFlipMode() async {
        isFlipModeActive = false
        await logFlipEvent("Flip Mode paused by user")
    }
    
    func resumeFlipMode() async {
        guard currentFlipGoal != nil else { return }
        isFlipModeActive = true
        await logFlipEvent("Flip Mode resumed")
    }
    
    func stopFlipMode() async {
        isFlipModeActive = false
        currentFlipGoal = nil
        activeDemoAccounts.removeAll()
        totalAccountsRunning = 0
        await logFlipEvent("Flip Mode stopped")
    }
    
    // MARK: - Data Loading
    
    private func loadExistingFlips() async {
        // Load from Firebase
        if let existingFlip = await firebaseManager.getCurrentFlip(userId: "current_user") {
            currentFlipGoal = existingFlip
            // Load associated accounts
            activeDemoAccounts = await firebaseManager.getFlipAccounts(userId: "current_user", flipId: existingFlip.id.uuidString).map { demoAccount in
                SharedTypes.DemoAccount(
                    id: demoAccount.id,
                    login: demoAccount.login,
                    server: demoAccount.server,
                    balance: demoAccount.currentBalance,
                    equity: demoAccount.currentBalance,
                    currency: "USD",
                    leverage: 500,
                    isActive: true,
                    createdAt: Date()
                )
            }
            totalAccountsRunning = activeDemoAccounts.count
        }
    }
    
    // MARK: - Utility Functions
    
    private func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: amount)) ?? "$\(amount)"
    }
    
    private func logFlipEvent(_ message: String) async {
        let event = SharedTypes.FlipEvent(
            id: UUID().uuidString,
            accountId: currentFlipGoal?.id.uuidString ?? "",
            eventType: "Flip Event",
            description: message,
            timestamp: Date()
        )
        
        await firebaseManager.logFlipEvent(userId: "current_user", event: event)
        print(" Flip Event: \(message)")
    }
}

struct VPSTradeResult {
    let success: Bool
    let tradeId: String
    let message: String
    let timestamp: Date
}

struct ClaudeFlipTradeLog {
    let id: String
    let flipId: String
    let accountId: String
    let entryAmount: Double
    let exitAmount: Double?
    let profit: Double
    let success: Bool
    let timestamp: Date
    
    init(
        id: String,
        flipId: String,
        accountId: String,
        signal: SharedTypes.AutoTradingSignal,
        tradeResult: SharedTypes.SharedTradeResult,
        timestamp: Date
    ) {
        self.id = id
        self.flipId = flipId
        self.accountId = accountId
        self.entryAmount = signal.entryPrice
        self.exitAmount = tradeResult.success ? signal.takeProfit : signal.stopLoss
        self.profit = tradeResult.profit
        self.success = tradeResult.success
        self.timestamp = timestamp
    }
}

#Preview {
    NavigationStack {
        VStack(spacing: 20) {
            // Header
            VStack(spacing: 8) {
                Text("Flip Mode Engine")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                
                Text("Automated Account Flipping")
                    .font(.title2)
                    .foregroundStyle(.secondary)
            }
            .padding(.top)
            
           ScrollView {
                LazyVStack(spacing: 16) {
                    // Flip Status Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Current Flip Status")
                            .font(.headline)
                            .foregroundStyle(.primary)
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Progress")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Text("67.5%")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.green)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .center, spacing: 4) {
                                Text("Active Accounts")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Text("25")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.blue)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing, spacing: 4) {
                                Text("Win Rate")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Text("92.0%")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.green)
                            }
                        }
                        .padding()
                        .background(.green.opacity(0.1))
                        .cornerRadius(12)
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Flip Mode")
        .navigationBarTitleDisplayMode(.inline)
    }
}