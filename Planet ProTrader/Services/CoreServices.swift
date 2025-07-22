//
//  CoreServices.swift
//  Planet ProTrader - Essential Services
//
//  Business Logic and API Services Layer
//  Created by Elite Engineering Team
//

import SwiftUI
import Foundation
import Combine

// MARK: - Authentication Service

@MainActor
class AuthenticationManager: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    struct User: Identifiable, Codable {
        let id: UUID
        let username: String
        let email: String
        let firstName: String
        let lastName: String
        let accountType: AccountType
        let createdAt: Date
        
        enum AccountType: String, Codable, CaseIterable {
            case basic = "Basic"
            case premium = "Premium"
            case elite = "Elite"
            case enterprise = "Enterprise"
            
            var color: Color {
                switch self {
                case .basic: return .gray
                case .premium: return .blue
                case .elite: return DesignSystem.primaryGold
                case .enterprise: return .purple
                }
            }
            
            var features: [String] {
                switch self {
                case .basic:
                    return ["1 Trading Bot", "Basic Analytics", "Email Support"]
                case .premium:
                    return ["5 Trading Bots", "Advanced Analytics", "Priority Support", "AI Signals"]
                case .elite:
                    return ["Unlimited Bots", "Real-time Data", "Personal Manager", "Custom Strategies"]
                case .enterprise:
                    return ["White Label", "API Access", "Dedicated Infrastructure", "Custom Development"]
                }
            }
        }
    }
    
    init() {
        checkAuthenticationStatus()
    }
    
    func signIn(username: String, password: String) async {
        isLoading = true
        errorMessage = nil
        
        // Simulate API call delay
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        // Demo authentication logic
        if username == "demo" && password == "demo123" {
            currentUser = User(
                id: UUID(),
                username: username,
                email: "demo@planetprotrader.com",
                firstName: "Demo",
                lastName: "User",
                accountType: .elite,
                createdAt: Date()
            )
            isAuthenticated = true
            saveAuthenticationState()
        } else {
            errorMessage = "Invalid credentials"
        }
        
        isLoading = false
    }
    
    func signOut() {
        currentUser = nil
        isAuthenticated = false
        clearAuthenticationState()
    }
    
    func register(username: String, email: String, password: String, firstName: String, lastName: String) async {
        isLoading = true
        errorMessage = nil
        
        // Simulate API call
        try? await Task.sleep(nanoseconds: 1_500_000_000)
        
        // Create new user
        currentUser = User(
            id: UUID(),
            username: username,
            email: email,
            firstName: firstName,
            lastName: lastName,
            accountType: .basic,
            createdAt: Date()
        )
        isAuthenticated = true
        saveAuthenticationState()
        
        isLoading = false
    }
    
    private func checkAuthenticationStatus() {
        // Check for stored authentication
        if let userData = UserDefaults.standard.data(forKey: "currentUser"),
           let user = try? JSONDecoder().decode(User.self, from: userData) {
            currentUser = user
            isAuthenticated = true
        }
    }
    
    private func saveAuthenticationState() {
        if let user = currentUser,
           let userData = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(userData, forKey: "currentUser")
            UserDefaults.standard.set(true, forKey: "isAuthenticated")
        }
    }
    
    private func clearAuthenticationState() {
        UserDefaults.standard.removeObject(forKey: "currentUser")
        UserDefaults.standard.removeObject(forKey: "isAuthenticated")
    }
}

// MARK: - Real-Time Account Manager

@MainActor
class RealTimeAccountManager: ObservableObject {
    @Published var activeAccounts: [TradingAccount] = []
    @Published var selectedAccountIndex = 0
    @Published var isLoading = false
    @Published var lastUpdateTime = Date()
    
    // Real-time data
    @Published var equity: Double = 11247.85
    @Published var balance: Double = 10000.0
    @Published var freeMargin: Double = 9500.0
    @Published var todaysProfit: Double = 247.85
    @Published var openPL: Double = 87.20
    @Published var winRate: Double = 0.875
    
    private var updateTimer: Timer?
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupSampleAccounts()
        startRealTimeUpdates()
    }
    
    deinit {
        stopRealTimeUpdates()
    }
    
    func refreshAccountData() async {
        isLoading = true
        
        // Simulate API call
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        // Update with simulated real-time data
        let randomFactor = Double.random(in: 0.98...1.02)
        equity = balance + (balance * 0.124785 * randomFactor)
        todaysProfit = equity - balance
        openPL = Double.random(in: -150...200)
        winRate = Double.random(in: 0.82...0.92)
        
        lastUpdateTime = Date()
        isLoading = false
    }
    
    func switchToAccount(at index: Int) {
        guard index < activeAccounts.count else { return }
        selectedAccountIndex = index
        
        // Update metrics for selected account
        let account = activeAccounts[index]
        balance = account.balance
        equity = account.equity
        freeMargin = account.freeMargin
        
        Task {
            await refreshAccountData()
        }
    }
    
    func addAccount(_ account: TradingAccount) {
        activeAccounts.append(account)
    }
    
    func removeAccount(at index: Int) {
        guard index < activeAccounts.count else { return }
        activeAccounts.remove(at: index)
        
        if selectedAccountIndex >= activeAccounts.count {
            selectedAccountIndex = max(0, activeAccounts.count - 1)
        }
    }
    
    private func setupSampleAccounts() {
        activeAccounts = TradingAccount.sampleAccounts
    }
    
    private func startRealTimeUpdates() {
        updateTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            Task {
                await self?.refreshAccountData()
            }
        }
    }
    
    private func stopRealTimeUpdates() {
        updateTimer?.invalidate()
        updateTimer = nil
    }
    
    // MARK: - Computed Properties
    
    var currentAccount: TradingAccount? {
        guard selectedAccountIndex < activeAccounts.count else { return nil }
        return activeAccounts[selectedAccountIndex]
    }
    
    var formattedEquity: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: NSNumber(value: equity)) ?? "$0.00"
    }
    
    var formattedBalance: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: NSNumber(value: balance)) ?? "$0.00"
    }
    
    var formattedTodaysProfit: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.positivePrefix = "+"
        return formatter.string(from: NSNumber(value: todaysProfit)) ?? "$0.00"
    }
    
    var formattedOpenPL: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.positivePrefix = "+"
        return formatter.string(from: NSNumber(value: openPL)) ?? "$0.00"
    }
    
    var formattedWinRate: String {
        String(format: "%.1f%%", winRate * 100)
    }
    
    var todaysProfitColor: Color {
        todaysProfit >= 0 ? .green : .red
    }
    
    var openPLColor: Color {
        openPL >= 0 ? .green : .red
    }
}

// MARK: - Auto Trading Manager

@MainActor
class AutoTradingManager: ObservableObject {
    @Published var isAutoTradingEnabled = false
    @Published var activeBots: [TradingBot] = []
    @Published var tradingMode: TradingMode = .conservative
    @Published var riskLevel: RiskLevel = .medium
    @Published var maxDailyLoss: Double = 500.0
    @Published var maxDailyProfit: Double = 1000.0
    @Published var isProcessing = false
    
    // Performance metrics
    @Published var dailyProfitLoss: Double = 0.0
    @Published var totalTrades: Int = 0
    @Published var winningTrades: Int = 0
    @Published var currentDrawdown: Double = 0.0
    
    private var tradingTimer: Timer?
    
    enum TradingMode: String, CaseIterable {
        case conservative = "Conservative"
        case moderate = "Moderate"
        case aggressive = "Aggressive"
        case custom = "Custom"
        
        var description: String {
            switch self {
            case .conservative: return "Low risk, steady profits"
            case .moderate: return "Balanced risk/reward ratio"
            case .aggressive: return "High risk, high reward"
            case .custom: return "User-defined parameters"
            }
        }
        
        var color: Color {
            switch self {
            case .conservative: return .green
            case .moderate: return .blue
            case .aggressive: return .red
            case .custom: return .purple
            }
        }
        
        var maxRiskPerTrade: Double {
            switch self {
            case .conservative: return 0.01
            case .moderate: return 0.02
            case .aggressive: return 0.05
            case .custom: return 0.03
            }
        }
    }
    
    init() {
        setupSampleBots()
    }
    
    func startAutoTrading() {
        guard !isAutoTradingEnabled else { return }
        
        isAutoTradingEnabled = true
        isProcessing = true
        
        // Activate selected bots
        for i in activeBots.indices {
            if activeBots[i].riskLevel.rawValue <= riskLevel.rawValue {
                activeBots[i] = TradingBot(
                    id: activeBots[i].id,
                    name: activeBots[i].name,
                    strategy: activeBots[i].strategy,
                    riskLevel: activeBots[i].riskLevel,
                    isActive: true,
                    winRate: activeBots[i].winRate,
                    totalTrades: activeBots[i].totalTrades,
                    profitLoss: activeBots[i].profitLoss,
                    performance: activeBots[i].performance,
                    lastUpdate: Date(),
                    status: .trading,
                    profit: activeBots[i].profit,
                    icon: activeBots[i].icon,
                    primaryColor: activeBots[i].primaryColor,
                    secondaryColor: activeBots[i].secondaryColor
                )
            }
        }
        
        startTradingSimulation()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.isProcessing = false
        }
    }
    
    func stopAutoTrading() {
        guard isAutoTradingEnabled else { return }
        
        isAutoTradingEnabled = false
        isProcessing = true
        
        // Deactivate all bots
        for i in activeBots.indices {
            activeBots[i] = TradingBot(
                id: activeBots[i].id,
                name: activeBots[i].name,
                strategy: activeBots[i].strategy,
                riskLevel: activeBots[i].riskLevel,
                isActive: false,
                winRate: activeBots[i].winRate,
                totalTrades: activeBots[i].totalTrades,
                profitLoss: activeBots[i].profitLoss,
                performance: activeBots[i].performance,
                lastUpdate: Date(),
                status: .stopped,
                profit: activeBots[i].profit,
                icon: activeBots[i].icon,
                primaryColor: activeBots[i].primaryColor,
                secondaryColor: activeBots[i].secondaryColor
            )
        }
        
        stopTradingSimulation()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.isProcessing = false
        }
    }
    
    func addBot(_ bot: TradingBot) {
        activeBots.append(bot)
    }
    
    func removeBot(at index: Int) {
        guard index < activeBots.count else { return }
        activeBots.remove(at: index)
    }
    
    private func setupSampleBots() {
        activeBots = Array(TradingBot.sampleBots.prefix(3))
    }
    
    private func startTradingSimulation() {
        tradingTimer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { [weak self] _ in
            self?.simulateTrading()
        }
    }
    
    private func stopTradingSimulation() {
        tradingTimer?.invalidate()
        tradingTimer = nil
    }
    
    private func simulateTrading() {
        guard isAutoTradingEnabled else { return }
        
        // Simulate random trading activity
        let tradePnL = Double.random(in: -50...100)
        dailyProfitLoss += tradePnL
        totalTrades += 1
        
        if tradePnL > 0 {
            winningTrades += 1
        }
        
        // Update bot performance
        for i in activeBots.indices where activeBots[i].isActive {
            let performanceChange = Double.random(in: -0.5...1.2)
            activeBots[i] = TradingBot(
                id: activeBots[i].id,
                name: activeBots[i].name,
                strategy: activeBots[i].strategy,
                riskLevel: activeBots[i].riskLevel,
                isActive: activeBots[i].isActive,
                winRate: min(0.95, max(0.5, activeBots[i].winRate + Double.random(in: -0.01...0.02))),
                totalTrades: activeBots[i].totalTrades + 1,
                profitLoss: activeBots[i].profitLoss + tradePnL,
                performance: activeBots[i].performance + performanceChange,
                lastUpdate: Date(),
                status: activeBots[i].status,
                profit: activeBots[i].profit + tradePnL,
                icon: activeBots[i].icon,
                primaryColor: activeBots[i].primaryColor,
                secondaryColor: activeBots[i].secondaryColor
            )
        }
        
        // Check safety limits
        if dailyProfitLoss <= -maxDailyLoss || dailyProfitLoss >= maxDailyProfit {
            stopAutoTrading()
        }
    }
    
    // MARK: - Computed Properties
    
    var winRate: Double {
        totalTrades > 0 ? Double(winningTrades) / Double(totalTrades) : 0
    }
    
    var formattedDailyPnL: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.positivePrefix = "+"
        return formatter.string(from: NSNumber(value: dailyProfitLoss)) ?? "$0.00"
    }
    
    var formattedWinRate: String {
        String(format: "%.1f%%", winRate * 100)
    }
    
    var activeBotsCount: Int {
        activeBots.filter { $0.isActive }.count
    }
}

// MARK: - Bot Marketplace Manager

@MainActor
class BotMarketplaceManager: ObservableObject {
    @Published var featuredBots: [TradingBot] = []
    @Published var categories: [BotCategory] = []
    @Published var searchResults: [TradingBot] = []
    @Published var isLoading = false
    @Published var searchText = ""
    
    struct BotCategory: Identifiable, Hashable {
        let id = UUID()
        let name: String
        let icon: String
        let color: Color
        let botCount: Int
        
        static let allCategories = [
            BotCategory(name: "Scalping", icon: "bolt.fill", color: .red, botCount: 15),
            BotCategory(name: "Swing Trading", icon: "waveform.path", color: .green, botCount: 8),
            BotCategory(name: "News Trading", icon: "newspaper.fill", color: .orange, botCount: 12),
            BotCategory(name: "AI-Powered", icon: "brain.head.profile.fill", color: DesignSystem.primaryGold, botCount: 20),
            BotCategory(name: "Risk Management", icon: "shield.fill", color: .blue, botCount: 6),
            BotCategory(name: "Arbitrage", icon: "arrow.left.arrow.right", color: .purple, botCount: 4)
        ]
    }
    
    init() {
        setupInitialData()
    }
    
    func loadFeaturedBots() async {
        isLoading = true
        
        // Simulate API call
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        featuredBots = TradingBot.sampleBots
        isLoading = false
    }
    
    func searchBots(query: String) async {
        searchText = query
        isLoading = true
        
        // Simulate search delay
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        if query.isEmpty {
            searchResults = []
        } else {
            searchResults = TradingBot.sampleBots.filter {
                $0.name.localizedCaseInsensitiveContains(query) ||
                $0.strategy.displayName.localizedCaseInsensitiveContains(query)
            }
        }
        
        isLoading = false
    }
    
    func purchaseBot(_ bot: TradingBot) async -> Bool {
        isLoading = true
        
        // Simulate purchase process
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        
        isLoading = false
        return true // Simulate successful purchase
    }
    
    private func setupInitialData() {
        categories = BotCategory.allCategories
        
        Task {
            await loadFeaturedBots()
        }
    }
}

// MARK: - Toast Manager

@MainActor
class ToastManager: ObservableObject {
    @Published var toasts: [Toast] = []
    
    struct Toast: Identifiable, Equatable {
        let id = UUID()
        let title: String
        let message: String
        let type: ToastType
        let duration: TimeInterval
        
        enum ToastType {
            case success, warning, error, info
            
            var color: Color {
                switch self {
                case .success: return .green
                case .warning: return .orange
                case .error: return .red
                case .info: return .blue
                }
            }
            
            var icon: String {
                switch self {
                case .success: return "checkmark.circle.fill"
                case .warning: return "exclamationmark.triangle.fill"
                case .error: return "xmark.circle.fill"
                case .info: return "info.circle.fill"
                }
            }
        }
    }
    
    func show(title: String, message: String, type: Toast.ToastType, duration: TimeInterval = 3.0) {
        let toast = Toast(title: title, message: message, type: type, duration: duration)
        toasts.append(toast)
        
        // Auto-remove after duration
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            self.removeToast(toast)
        }
    }
    
    func removeToast(_ toast: Toast) {
        toasts.removeAll { $0.id == toast.id }
    }