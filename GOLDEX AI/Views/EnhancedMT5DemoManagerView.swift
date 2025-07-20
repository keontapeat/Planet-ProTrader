//
//  EnhancedMT5DemoManagerView.swift  
//  GOLDEX AI
//
//  🔥 ENHANCED MT5 DEMO ACCOUNT MANAGER - Add 25+ accounts easily! 🔥
//

import SwiftUI
import Foundation

struct EnhancedMT5DemoManagerView: View {
    @StateObject private var accountManager = EnhancedMT5Manager()
    @StateObject private var botAssignmentManager = BotAssignmentManager()
    @State private var showingAddAccounts = false
    @State private var selectedAccount: DemoTradingAccount?
    @State private var showingBotAssignment = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [.black, .blue.opacity(0.8), .purple.opacity(0.6)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // 🔥 Header Section
                        headerSection
                        
                        // 🚀 Quick Stats
                        statsSection
                        
                        // ⚡ Quick Add Section
                        quickAddSection
                        
                        // 💎 Demo Accounts Grid
                        accountsGridSection
                        
                        // 🤖 Bot Assignment Overview
                        botAssignmentSection
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .navigationTitle("MT5 Demo Army")
            .navigationBarTitleDisplayMode(.large)
            .foregroundColor(.white)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddAccounts.toggle()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddAccounts) {
            BulkAccountAddView(accountManager: accountManager)
        }
        .sheet(item: $selectedAccount) { account in
            AccountDetailView(account: account, botManager: botAssignmentManager)
        }
        .sheet(isPresented: $showingBotAssignment) {
            BotAssignmentView(accountManager: accountManager, botManager: botAssignmentManager)
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "brain.head.profile")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.cyan)
                
                Text("MT5 Demo Army")
                    .font(.system(size: 28, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                
                Spacer()
                
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.green)
            }
            
            Text("Deploy bots across multiple demo accounts for maximum market dominance! 🚀")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(LinearGradient(colors: [.cyan, .blue], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 2)
                )
        )
    }
    
    // MARK: - Stats Section
    private var statsSection: some View {
        HStack(spacing: 16) {
            StatCard(
                title: "Demo Accounts", 
                value: "\(accountManager.demoAccounts.count)",
                subtitle: "Active Accounts",
                icon: "server.rack",
                color: .blue
            )
            
            StatCard(
                title: "Bots Deployed", 
                value: "\(botAssignmentManager.totalDeployedBots)",
                subtitle: "Trading Bots",
                icon: "brain.filled.head.profile",
                color: .purple
            )
            
            StatCard(
                title: "Total Balance", 
                value: accountManager.totalDemoBalance,
                subtitle: "Demo Funds",
                icon: "dollarsign.circle.fill",
                color: .green
            )
        }
    }
    
    // MARK: - Quick Add Section
    private var quickAddSection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Quick Deploy")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Spacer()
            }
            
            HStack(spacing: 12) {
                QuickAddButton(
                    title: "Add 5 Accounts",
                    icon: "plus.circle.fill",
                    color: .green
                ) {
                    accountManager.quickAddDemoAccounts(count: 5)
                }
                
                QuickAddButton(
                    title: "Add 10 Accounts",
                    icon: "plus.square.fill.on.square.fill",
                    color: .blue
                ) {
                    accountManager.quickAddDemoAccounts(count: 10)
                }
                
                QuickAddButton(
                    title: "Add 25 Accounts",
                    icon: "square.3.layers.3d.down.right.fill",
                    color: .purple
                ) {
                    accountManager.quickAddDemoAccounts(count: 25)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
        )
    }
    
    // MARK: - Accounts Grid Section
    private var accountsGridSection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Demo Accounts")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Spacer()
                
                Button("Assign Bots") {
                    showingBotAssignment.toggle()
                }
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(.purple)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
            if accountManager.demoAccounts.isEmpty {
                EmptyAccountsView {
                    showingAddAccounts.toggle()
                }
            } else {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 16) {
                    ForEach(accountManager.demoAccounts) { account in
                        EnhancedDemoAccountCard(
                            account: account,
                            assignedBots: botAssignmentManager.getAssignedBots(for: account.id)
                        ) {
                            selectedAccount = account
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Bot Assignment Section
    private var botAssignmentSection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Bot Deployment Status")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Spacer()
                
                Circle()
                    .fill(botAssignmentManager.totalDeployedBots > 0 ? .green : .orange)
                    .frame(width: 12, height: 12)
                    .scaleEffect(1.2)
                    .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: botAssignmentManager.totalDeployedBots > 0)
            }
            
            LazyVStack(spacing: 12) {
                ForEach(botAssignmentManager.botDeployments, id: \.id) { deployment in
                    BotDeploymentCard(deployment: deployment)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
        )
    }
}

// MARK: - Enhanced MT5 Manager

@MainActor
class EnhancedMT5Manager: ObservableObject {
    @Published var demoAccounts: [DemoTradingAccount] = []
    @Published var isConnecting = false
    
    // Popular brokers for demo accounts
    private let popularBrokers = [
        ("Coinexx", "Coinexx-Demo"),
        ("MetaQuotes", "MetaQuotes-Demo"), 
        ("Alpari", "Alpari-Demo"),
        ("FXCM", "FXCM-Demo"),
        ("IG", "IG-Demo"),
        ("XTB", "XTB-Demo"),
        ("Admiral", "Admiral-Demo"),
        ("Pepperstone", "Pepperstone-Demo")
    ]
    
    var totalDemoBalance: String {
        let total = demoAccounts.reduce(0) { $0 + $1.balance }
        return formatCurrency(total)
    }
    
    func quickAddDemoAccounts(count: Int) {
        isConnecting = true
        
        Task {
            for i in 0..<count {
                let broker = popularBrokers.randomElement()!
                let account = DemoTradingAccount(
                    login: "\(Int.random(in: 100000...999999))",
                    password: "demo_pass_\(i)",
                    server: broker.1,
                    company: broker.0,
                    balance: Double.random(in: 5000...20000),
                    leverage: [100, 200, 500, 1000].randomElement()!,
                    accountType: .demo
                )
                
                await MainActor.run {
                    demoAccounts.append(account)
                }
                
                // Small delay to show progress
                try? await Task.sleep(nanoseconds: 200_000_000)
            }
            
            await MainActor.run {
                isConnecting = false
            }
        }
    }
    
    func addSingleDemoAccount(login: String, password: String, server: String, company: String) {
        let account = DemoTradingAccount(
            login: login,
            password: password,
            server: server,
            company: company,
            balance: 10000.0,
            leverage: 500,
            accountType: .demo
        )
        demoAccounts.append(account)
    }
    
    func removeAccount(_ account: DemoTradingAccount) {
        demoAccounts.removeAll { $0.id == account.id }
    }
    
    private func formatCurrency(_ amount: Double) -> String {
        if amount >= 1_000_000 {
            return String(format: "$%.1fM", amount / 1_000_000)
        } else if amount >= 1_000 {
            return String(format: "$%.1fK", amount / 1_000)
        } else {
            return String(format: "$%.0f", amount)
        }
    }
}

// MARK: - Demo Trading Account Model

struct DemoTradingAccount: Identifiable, Codable {
    let id = UUID()
    let login: String
    let password: String
    let server: String
    let company: String
    var balance: Double
    var equity: Double
    let leverage: Int
    var isConnected: Bool
    var lastUpdate: Date
    let accountType: AccountType
    var activeTrades: Int
    var todayProfitLoss: Double
    
    enum AccountType: String, CaseIterable, Codable {
        case demo = "Demo"
        case live = "Live"
        
        var emoji: String {
            switch self {
            case .demo: return "🧪"
            case .live: return "💰"
            }
        }
        
        var color: Color {
            switch self {
            case .demo: return .blue
            case .live: return .green
            }
        }
        
        var badge: String {
            switch self {
            case .demo: return "DEMO"
            case .live: return "LIVE"
            }
        }
    }
    
    init(login: String, password: String, server: String, company: String, balance: Double, leverage: Int, accountType: AccountType) {
        self.login = login
        self.password = password
        self.server = server
        self.company = company
        self.balance = balance
        self.equity = balance
        self.leverage = leverage
        self.isConnected = Bool.random()
        self.lastUpdate = Date()
        self.accountType = accountType
        self.activeTrades = Int.random(in: 0...5)
        self.todayProfitLoss = Double.random(in: -200...500)
    }
    
    var formattedBalance: String {
        return String(format: "$%.2f", balance)
    }
    
    var profitLossColor: Color {
        return todayProfitLoss >= 0 ? .green : .red
    }
    
    var connectionStatus: String {
        return isConnected ? "🟢 Connected" : "🔴 Offline"
    }
}

// MARK: - Bot Assignment Manager

@MainActor
class BotAssignmentManager: ObservableObject {
    @Published var botDeployments: [BotDeployment] = []
    @Published var availableBots: [TradingBotModel] = []
    
    init() {
        loadAvailableBots()
        loadSampleDeployments()
    }
    
    var totalDeployedBots: Int {
        botDeployments.reduce(0) { $0 + $1.assignedAccounts.count }
    }
    
    func getAssignedBots(for accountId: UUID) -> [TradingBotModel] {
        return botDeployments
            .filter { $0.assignedAccounts.contains(accountId) }
            .map { $0.bot }
    }
    
    func assignBotToAccount(botId: UUID, accountId: UUID) {
        if let index = botDeployments.firstIndex(where: { $0.bot.id == botId }) {
            if !botDeployments[index].assignedAccounts.contains(accountId) {
                botDeployments[index].assignedAccounts.append(accountId)
            }
        }
    }
    
    func removeBotFromAccount(botId: UUID, accountId: UUID) {
        if let index = botDeployments.firstIndex(where: { $0.bot.id == botId }) {
            botDeployments[index].assignedAccounts.removeAll { $0 == accountId }
        }
    }
    
    private func loadAvailableBots() {
        availableBots = [
            TradingBotModel(name: "Gold Rush Alpha", strategy: "Scalping", winRate: 92.5, status: .active),
            TradingBotModel(name: "Zeus Thunder", strategy: "News Trading", winRate: 88.7, status: .active),
            TradingBotModel(name: "Steady Eddie", strategy: "Swing Trading", winRate: 76.2, status: .active),
            TradingBotModel(name: "Quantum Leap", strategy: "AI Prediction", winRate: 95.1, status: .active),
            TradingBotModel(name: "Day Warrior", strategy: "Day Trading", winRate: 83.4, status: .active)
        ]
    }
    
    private func loadSampleDeployments() {
        botDeployments = availableBots.map { bot in
            BotDeployment(
                bot: bot,
                assignedAccounts: [],
                isActive: false,
                deployedAt: Date()
            )
        }
    }
}

// MARK: - Trading Bot Model

struct TradingBotModel: Identifiable, Codable {
    let id = UUID()
    let name: String
    let strategy: String
    let winRate: Double
    let status: BotStatus
    var isTrading: Bool = false
    var todayTrades: Int = 0
    var todayProfit: Double = 0.0
    
    enum BotStatus: String, CaseIterable, Codable {
        case active = "Active"
        case paused = "Paused"
        case offline = "Offline"
        
        var color: Color {
            switch self {
            case .active: return .green
            case .paused: return .orange  
            case .offline: return .red
            }
        }
        
        var emoji: String {
            switch self {
            case .active: return "🟢"
            case .paused: return "⏸️"
            case .offline: return "🔴"
            }
        }
    }
    
    var formattedWinRate: String {
        return String(format: "%.1f%%", winRate)
    }
}

// MARK: - Bot Deployment Model

struct BotDeployment: Identifiable {
    let id = UUID()
    let bot: TradingBotModel
    var assignedAccounts: [UUID]
    var isActive: Bool
    let deployedAt: Date
    
    var accountCount: Int {
        return assignedAccounts.count
    }
    
    var statusText: String {
        if assignedAccounts.isEmpty {
            return "Not Deployed"
        } else if isActive {
            return "Trading on \(accountCount) accounts"
        } else {
            return "Assigned to \(accountCount) accounts (Paused)"
        }
    }
}

// MARK: - Supporting Views

struct StatCard: View {
    let title: String
    let value: String
    let subtitle: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(color)
            
            Text(value)
                .font(.system(size: 20, weight: .black, design: .rounded))
                .foregroundColor(.white)
            
            VStack(spacing: 2) {
                Text(title)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white)
                
                Text(subtitle)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.white.opacity(0.7))
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(color.opacity(0.5), lineWidth: 1)
                )
        )
    }
}

struct QuickAddButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                
                Text(title)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(LinearGradient(colors: [color, color.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing))
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct EnhancedDemoAccountCard: View {
    let account: DemoTradingAccount
    let assignedBots: [TradingBotModel]
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 12) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(account.company)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("#\(account.login)")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Circle()
                            .fill(account.isConnected ? .green : .red)
                            .frame(width: 8, height: 8)
                        
                        Text(account.accountType.badge)
                            .font(.system(size: 8, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(account.accountType.color)
                            .clipShape(Capsule())
                    }
                }
                
                // Balance
                VStack(alignment: .leading, spacing: 4) {
                    Text("Balance")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                    
                    Text(account.formattedBalance)
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // P&L
                HStack {
                    Text("Today P&L:")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                    
                    Spacer()
                    
                    Text(String(format: "%+.2f", account.todayProfitLoss))
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(account.profitLossColor)
                }
                
                // Assigned Bots
                VStack(alignment: .leading, spacing: 6) {
                    Text("Assigned Bots (\(assignedBots.count))")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                    
                    if assignedBots.isEmpty {
                        Text("No bots assigned")
                            .font(.system(size: 9, weight: .medium))
                            .foregroundColor(.orange)
                    } else {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 4) {
                                ForEach(assignedBots.prefix(3)) { bot in
                                    Text(bot.name)
                                        .font(.system(size: 8, weight: .medium))
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 2)
                                        .background(.purple.opacity(0.8))
                                        .clipShape(Capsule())
                                }
                                
                                if assignedBots.count > 3 {
                                    Text("+\(assignedBots.count - 3)")
                                        .font(.system(size: 8, weight: .medium))
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 2)
                                        .background(.gray.opacity(0.8))
                                        .clipShape(Capsule())
                                }
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // Trading Status
                if account.activeTrades > 0 {
                    HStack {
                        Circle()
                            .fill(.green)
                            .frame(width: 6, height: 6)
                            .scaleEffect(1.2)
                            .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: account.activeTrades > 0)
                        
                        Text("\(account.activeTrades) active trades")
                            .font(.system(size: 9, weight: .medium))
                            .foregroundColor(.green)
                        
                        Spacer()
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(account.isConnected ? .green.opacity(0.5) : .red.opacity(0.5), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct BotDeploymentCard: View {
    let deployment: BotDeployment
    
    var body: some View {
        HStack(spacing: 12) {
            // Bot Status Indicator
            Circle()
                .fill(deployment.bot.status.color)
                .frame(width: 12, height: 12)
                .scaleEffect(deployment.isActive ? 1.2 : 1.0)
                .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: deployment.isActive)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(deployment.bot.name)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                
                Text(deployment.statusText)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(deployment.bot.formattedWinRate)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.green)
                
                Text(deployment.bot.strategy)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.white.opacity(0.7))
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
        )
    }
}

struct EmptyAccountsView: View {
    let onAdd: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "plus.circle.dashed")
                .font(.system(size: 48, weight: .bold))
                .foregroundColor(.white.opacity(0.6))
            
            VStack(spacing: 8) {
                Text("No Demo Accounts")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                
                Text("Add demo accounts to deploy your trading bots")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
            }
            
            Button("Add Your First Account") {
                onAdd()
            }
            .font(.system(size: 16, weight: .semibold))
            .foregroundColor(.white)
            .padding()
            .background(.purple)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .frame(maxWidth: .infinity)
        .padding(40)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
        )
    }
}

// MARK: - Bulk Account Add View

struct BulkAccountAddView: View {
    @ObservedObject var accountManager: EnhancedMT5Manager
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedCount = 5
    @State private var isAdding = false
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    colors: [.black, .blue.opacity(0.8), .purple.opacity(0.6)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 32) {
                    // Header
                    VStack(spacing: 16) {
                        Image(systemName: "server.rack")
                            .font(.system(size: 48, weight: .bold))
                            .foregroundColor(.cyan)
                        
                        Text("Deploy Demo Army")
                            .font(.system(size: 24, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text("Add multiple demo accounts instantly!")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    
                    // Count Selection
                    VStack(spacing: 20) {
                        Text("How many accounts?")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                        
                        HStack(spacing: 16) {
                            ForEach([5, 10, 25], id: \.self) { count in
                                Button("\(count)") {
                                    selectedCount = count
                                }
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(selectedCount == count ? .black : .white)
                                .frame(width: 60, height: 60)
                                .background(
                                    Circle()
                                        .fill(selectedCount == count ? .white : .clear)
                                        .overlay(
                                            Circle()
                                                .stroke(.white, lineWidth: 2)
                                        )
                                )
                            }
                        }
                        
                        // Custom count
                        HStack {
                            Text("Custom:")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white)
                            
                            TextField("Count", value: $selectedCount, format: .number)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(width: 80)
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.ultraThinMaterial)
                    )
                    
                    // Add Button
                    Button {
                        addAccounts()
                    } label: {
                        HStack {
                            if isAdding {
                                ProgressView()
                                    .tint(.white)
                                    .scaleEffect(0.8)
                                Text("Adding accounts...")
                            } else {
                                Image(systemName: "plus.circle.fill")
                                Text("Add \(selectedCount) Demo Accounts")
                            }
                        }
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.purple)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    .disabled(isAdding)
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Add Demo Accounts")
            .navigationBarTitleDisplayMode(.inline)
            .foregroundColor(.white)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
        }
    }
    
    private func addAccounts() {
        isAdding = true
        
        Task {
            accountManager.quickAddDemoAccounts(count: selectedCount)
            
            // Wait a bit for the accounts to be added
            try? await Task.sleep(nanoseconds: UInt64(selectedCount * 300_000_000))
            
            await MainActor.run {
                isAdding = false
                dismiss()
            }
        }
    }
}

// MARK: - Account Detail View

struct AccountDetailView: View {
    let account: DemoTradingAccount
    @ObservedObject var botManager: BotAssignmentManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    colors: [.black, .blue.opacity(0.8)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Account Info
                        AccountInfoCard(account: account)
                        
                        // Assigned Bots
                        AssignedBotsSection(account: account, botManager: botManager)
                        
                        Spacer(minLength: 100)
                    }
                    .padding()
                }
            }
            .navigationTitle("Account Details")
            .navigationBarTitleDisplayMode(.inline)
            .foregroundColor(.white)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
        }
    }
}

struct AccountInfoCard: View {
    let account: DemoTradingAccount
    
    var body: some View {
        VStack(spacing: 16) {
            // Header
            HStack {
                Text(account.company)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Text(account.connectionStatus)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white)
            }
            
            // Account Details
            VStack(spacing: 12) {
                InfoRow(label: "Account", value: "#\(account.login)")
                InfoRow(label: "Server", value: account.server)
                InfoRow(label: "Balance", value: account.formattedBalance)
                InfoRow(label: "Leverage", value: "1:\(account.leverage)")
                InfoRow(label: "Active Trades", value: "\(account.activeTrades)")
                InfoRow(label: "Today P&L", value: String(format: "%+.2f", account.todayProfitLoss), valueColor: account.profitLossColor)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
        )
    }
}

struct InfoRow: View {
    let label: String
    let value: String
    var valueColor: Color = .white
    
    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white.opacity(0.7))
            
            Spacer()
            
            Text(value)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(valueColor)
        }
    }
}

struct AssignedBotsSection: View {
    let account: DemoTradingAccount
    @ObservedObject var botManager: BotAssignmentManager
    
    var assignedBots: [TradingBotModel] {
        botManager.getAssignedBots(for: account.id)
    }
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Assigned Bots (\(assignedBots.count))")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
            }
            
            if assignedBots.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "brain.head.profile")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white.opacity(0.6))
                    
                    Text("No bots assigned")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                    
                    Text("Assign bots from the main screen")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.5))
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.ultraThinMaterial)
                )
            } else {
                LazyVStack(spacing: 12) {
                    ForEach(assignedBots) { bot in
                        AssignedBotCard(bot: bot)
                    }
                }
            }
        }
    }
}

struct AssignedBotCard: View {
    let bot: TradingBotModel
    
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(bot.status.color)
                .frame(width: 12, height: 12)
                .scaleEffect(bot.isTrading ? 1.2 : 1.0)
                .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: bot.isTrading)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(bot.name)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                
                Text(bot.strategy)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(bot.formattedWinRate)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.green)
                
                Text(bot.status.rawValue)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(bot.status.color)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
        )
    }
}

// MARK: - Bot Assignment View

struct BotAssignmentView: View {
    @ObservedObject var accountManager: EnhancedMT5Manager
    @ObservedObject var botManager: BotAssignmentManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    colors: [.black, .purple.opacity(0.8)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header
                        VStack(spacing: 8) {
                            Text("Deploy Your Bot Army")
                                .font(.system(size: 24, weight: .black, design: .rounded))
                                .foregroundColor(.white)
                            
                            Text("Assign bots to demo accounts for maximum market coverage")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white.opacity(0.8))
                                .multilineTextAlignment(.center)
                        }
                        
                        // Bot Assignment Grid
                        LazyVStack(spacing: 16) {
                            ForEach(botManager.availableBots) { bot in
                                BotAssignmentCard(
                                    bot: bot,
                                    accounts: accountManager.demoAccounts,
                                    botManager: botManager
                                )
                            }
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding()
                }
            }
            .navigationTitle("Bot Assignment")
            .navigationBarTitleDisplayMode(.inline)
            .foregroundColor(.white)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
        }
    }
}

struct BotAssignmentCard: View {
    let bot: TradingBotModel
    let accounts: [DemoTradingAccount]
    @ObservedObject var botManager: BotAssignmentManager
    
    var assignedAccountIds: [UUID] {
        botManager.botDeployments.first { $0.bot.id == bot.id }?.assignedAccounts ?? []
    }
    
    var body: some View {
        VStack(spacing: 16) {
            // Bot Header
            HStack {
                Circle()
                    .fill(bot.status.color)
                    .frame(width: 12, height: 12)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(bot.name)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("\(bot.strategy) • \(bot.formattedWinRate) Win Rate")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                }
                
                Spacer()
                
                Text("\(assignedAccountIds.count) accounts")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(.purple)
                    .clipShape(Capsule())
            }
            
            // Account Selection Grid
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 8) {
                ForEach(accounts.prefix(9)) { account in
                    AccountSelectionButton(
                        account: account,
                        isSelected: assignedAccountIds.contains(account.id)
                    ) {
                        toggleBotAssignment(for: account)
                    }
                }
                
                if accounts.count > 9 {
                    Button("+\(accounts.count - 9) more") {
                        // Handle showing more accounts
                    }
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.white)
                    .frame(height: 40)
                    .frame(maxWidth: .infinity)
                    .background(.gray.opacity(0.5))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
        )
    }
    
    private func toggleBotAssignment(for account: DemoTradingAccount) {
        if assignedAccountIds.contains(account.id) {
            botManager.removeBotFromAccount(botId: bot.id, accountId: account.id)
        } else {
            botManager.assignBotToAccount(botId: bot.id, accountId: account.id)
        }
    }
}

struct AccountSelectionButton: View {
    let account: DemoTradingAccount
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text(account.company)
                    .font(.system(size: 8, weight: .bold))
                    .foregroundColor(isSelected ? .white : .white.opacity(0.7))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                
                Text("#\(account.login)")
                    .font(.system(size: 6, weight: .medium))
                    .foregroundColor(isSelected ? .white.opacity(0.8) : .white.opacity(0.5))
                
                Circle()
                    .fill(account.isConnected ? .green : .red)
                    .frame(width: 4, height: 4)
            }
            .frame(height: 40)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? .purple : .clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(isSelected ? .purple : .white.opacity(0.3), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview("Enhanced MT5 Demo Manager") {
    EnhancedMT5DemoManagerView()
        .preferredColorScheme(.dark)
}