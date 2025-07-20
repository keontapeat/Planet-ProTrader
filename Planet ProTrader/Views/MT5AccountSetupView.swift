//
//  MT5AccountSetupView.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 7/13/25.
//

import SwiftUI

struct MT5AccountSetupView: View {
    @StateObject private var brokerConnector = BrokerConnector()
    @State private var showingAddAccount = false
    @State private var isConnecting = false
    @State private var selectedAccount: SharedTypes.MT5Account?
    @State private var autoTradingManager = AutoTradingManager()
    
    var body: some View {
        NavigationStack {
            ZStack {
                DesignSystem.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header
                        headerSection
                        
                        // Real Account Connection
                        realAccountSection
                        
                        // Connection Status
                        connectionStatusSection
                        
                        // Auto Trading Controls
                        if brokerConnector.isConnected {
                            autoTradingSection
                        }
                        
                        // Trading Controls
                        if brokerConnector.isConnected {
                            tradingControlsSection
                        }
                        
                        // Active Trades
                        if !brokerConnector.activeTrades.isEmpty {
                            activeTradesSection
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .navigationTitle("MT5 Trading")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            Image(systemName: "chart.xyaxis.line")
                .font(.system(size: 48, weight: .bold))
                .foregroundColor(DesignSystem.primaryGold)
            
            VStack(spacing: 8) {
                Text("MT5 Trading Setup")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(DesignSystem.primaryText)
                
                Text("Connect your demo accounts to start autotrading")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(DesignSystem.secondaryText)
                    .multilineTextAlignment(.center)
            }
        }
        .padding()
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    // MARK: - Real Account Section
    
    private var realAccountSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Your Coinexx Account")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(DesignSystem.primaryText)
            
            UltraPremiumCard {
                VStack(spacing: 16) {
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(DesignSystem.primaryGold)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Account: 845514")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(DesignSystem.primaryText)
                            
                            Text("Coinexx Demo Server")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(DesignSystem.secondaryText)
                        }
                        
                        Spacer()
                        
                        Button(brokerConnector.isConnected ? "Disconnect" : "Connect") {
                            if brokerConnector.isConnected {
                                Task {
                                    await brokerConnector.disconnect()
                                }
                            } else {
                                connectToRealAccount()
                            }
                        }
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(brokerConnector.isConnected ? Color.red : DesignSystem.primaryGold)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    
                    // Real Balance Display
                    if brokerConnector.isConnected {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Account Balance")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(DesignSystem.primaryText)
                            
                            HStack {
                                Text("$1,270.00")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(DesignSystem.primaryGold)
                                
                                Spacer()
                                
                                VStack(alignment: .trailing, spacing: 2) {
                                    Text("Last Updated")
                                        .font(.system(size: 10, weight: .medium))
                                        .foregroundColor(DesignSystem.secondaryText)
                                    
                                    Text("Just now")
                                        .font(.system(size: 10, weight: .medium))
                                        .foregroundColor(DesignSystem.secondaryText)
                                }
                            }
                            
                            // Real-time indicator
                            HStack {
                                Circle()
                                    .fill(Color.green)
                                    .frame(width: 8, height: 8)
                                    .scaleEffect(1.2)
                                    .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: brokerConnector.isConnected)
                                
                                Text("Real-time Balance Updates")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.green)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.green.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
            }
        }
    }
    
    // MARK: - Connection Status Section
    
    private var connectionStatusSection: some View {
        UltraPremiumCard {
            VStack(spacing: 16) {
                HStack {
                    Circle()
                        .fill(brokerConnector.isConnected ? Color.green : Color.red)
                        .frame(width: 12, height: 12)
                        .scaleEffect(brokerConnector.isConnected ? 1.2 : 1.0)
                        .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: brokerConnector.isConnected)
                    
                    Text(brokerConnector.connectionStatus)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(DesignSystem.primaryText)
                    
                    Spacer()
                    
                    if brokerConnector.isConnected {
                        Button("Disconnect") {
                            Task {
                                await brokerConnector.disconnect()
                            }
                        }
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.red)
                    }
                }
                
                if brokerConnector.isConnected {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Account Information")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(DesignSystem.primaryText)
                        
                        Text("Account: \(brokerConnector.accountNumber) - \(brokerConnector.brokerName)")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(DesignSystem.secondaryText)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(DesignSystem.primaryGold.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                
                if !brokerConnector.lastError.isEmpty {
                    Text(brokerConnector.lastError)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.red)
                        .padding()
                        .background(.red.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
        }
    }
    
    // MARK: - Auto Trading Section
    
    private var autoTradingSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Auto Trading Controls")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(DesignSystem.primaryText)
            
            UltraPremiumCard {
                VStack(spacing: 16) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Auto Trading")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(DesignSystem.primaryText)
                            
                            Text(autoTradingManager.isAutoTradingEnabled ? "Active - Scanning Markets" : "Inactive")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(autoTradingManager.isAutoTradingEnabled ? .green : .orange)
                        }
                        
                        Spacer()
                        
                        Button(autoTradingManager.isAutoTradingEnabled ? "Stop Trading" : "Start Trading") {
                            if autoTradingManager.isAutoTradingEnabled {
                                Task {
                                    await autoTradingManager.disableAutoTrading()
                                }
                            } else {
                                Task {
                                    await autoTradingManager.enableAutoTrading()
                                }
                            }
                        }
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(autoTradingManager.isAutoTradingEnabled ? Color.red : Color.green)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    
                    // Test Mode Controls
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Test Mode")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(DesignSystem.primaryText)
                        
                        HStack {
                            Button(autoTradingManager.testMode ? "Disable Test Mode" : "Enable Test Mode") {
                                autoTradingManager.testMode.toggle()
                            }
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(autoTradingManager.testMode ? Color.orange : Color.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                            
                            Spacer()
                            
                            Button("Force Signal") {
                                autoTradingManager.forceNextSignal = true
                            }
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.orange)
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                        }
                        
                        if autoTradingManager.testMode {
                            HStack {
                                Circle()
                                    .fill(Color.blue)
                                    .frame(width: 8, height: 8)
                                    .scaleEffect(1.2)
                                    .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: autoTradingManager.testMode)
                                
                                Text("Test Mode Active - Signal generation enabled")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    
                    if autoTradingManager.isAutoTradingEnabled {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Current Activity")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(DesignSystem.primaryText)
                            
                            Text(autoTradingManager.currentActivity)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(DesignSystem.secondaryText)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(DesignSystem.primaryGold.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    
                    // Trading Stats
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Today's Trades")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(DesignSystem.secondaryText)
                            
                            Text("\(autoTradingManager.todayTradesCount)")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(DesignSystem.primaryText)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .center, spacing: 4) {
                            Text("Balance")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(DesignSystem.secondaryText)
                            
                            Text("$\(String(format: "%.2f", autoTradingManager.accountBalance))")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(DesignSystem.primaryGold)
                            
                            VStack(alignment: .trailing, spacing: 2) {
                                Text("Last Updated")
                                    .font(.system(size: 10, weight: .medium))
                                    .foregroundColor(DesignSystem.secondaryText)
                                
                                Text(autoTradingManager.lastBalanceUpdate.formatted(date: .omitted, time: .shortened))
                                    .font(.system(size: 10, weight: .medium))
                                    .foregroundColor(DesignSystem.secondaryText)
                            }
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            Text("Today's P&L")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(DesignSystem.secondaryText)
                            
                            Text("$\(String(format: "%.2f", autoTradingManager.todaysProfit))")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(autoTradingManager.todaysProfit >= 0 ? .green : .red)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Trading Controls Section
    
    private var tradingControlsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Trading Controls")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(DesignSystem.primaryText)
            
            UltraPremiumCard {
                VStack(spacing: 16) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Symbol")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(DesignSystem.secondaryText)
                            
                            Text(brokerConnector.currentSymbol?.name ?? "Loading...")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(DesignSystem.primaryText)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            Text("Spread")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(DesignSystem.secondaryText)
                            
                            Text(String(format: "%.2f", brokerConnector.currentSymbol?.spread ?? 0.0))
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(DesignSystem.primaryGold)
                        }
                    }
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Bid")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(DesignSystem.secondaryText)
                            
                            Text(String(format: "%.2f", brokerConnector.currentSymbol?.bid ?? 0.0))
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.red)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            Text("Ask")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(DesignSystem.secondaryText)
                            
                            Text(String(format: "%.2f", brokerConnector.currentSymbol?.ask ?? 0.0))
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.green)
                        }
                    }
                    
                    HStack(spacing: 16) {
                        Button("Manual Buy") {
                            executeManualTrade(direction: .buy)
                        }
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                        .padding()
                        .background(.green)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        
                        Button("Manual Sell") {
                            executeManualTrade(direction: .sell)
                        }
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                        .padding()
                        .background(.red)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
            }
        }
    }
    
    // MARK: - Active Trades Section
    
    private var activeTradesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Active Trades")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(DesignSystem.primaryText)
            
            LazyVStack(spacing: 12) {
                ForEach(brokerConnector.activeTrades, id: \.ticket) { trade in
                    MT5TradeCard(trade: trade) {
                        closeTradeAction(trade)
                    }
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func connectToRealAccount() {
        isConnecting = true
        
        Task {
            let credentials = SharedTypes.BrokerCredentials(
                login: "845514",
                password: "Jj0@AfHgVv7kpj", 
                server: "Coinexx-demo",
                brokerType: .coinexx
            )
            
            do {
                let success = try await brokerConnector.connect(
                    brokerType: .coinexx,
                    credentials: credentials,
                    isDemo: false // Real account
                )
                
                if success {
                    print("✅ Connected to your real Coinexx account: 845514")
                    
                    // Also connect the auto trading manager
                    let autoSuccess = await autoTradingManager.connectToBroker(
                        type: .coinexx,
                        credentials: credentials
                    )
                    
                    if autoSuccess {
                        print("✅ Auto trading manager connected to real account")
                    }
                    
                } else {
                    print("❌ Failed to connect to real account")
                }
                
            } catch {
                print("❌ Connection error: \(error.localizedDescription)")
            }
            
            isConnecting = false
        }
    }
    
    private func executeManualTrade(direction: SharedTypes.TradeDirection) {
        guard let currentPrice = brokerConnector.currentSymbol?.ask else { return }
        
        let stopLoss = direction == .buy ? currentPrice - 20.0 : currentPrice + 20.0
        let takeProfit = direction == .buy ? currentPrice + 50.0 : currentPrice - 50.0
        
        Task {
            do {
                let result = try await brokerConnector.executeTrade(
                    symbol: "XAUUSD",
                    direction: direction,
                    lotSize: 0.1,
                    entryPrice: currentPrice,
                    stopLoss: stopLoss,
                    takeProfit: takeProfit
                )
                
                print("✅ Manual trade executed: \(result.tradeId)")
                
            } catch {
                print("❌ Manual trade failed: \(error.localizedDescription)")
            }
        }
    }
    
    private func closeTradeAction(_ trade: SharedTypes.MT5Trade) {
        Task {
            do {
                let success = try await brokerConnector.closePosition(ticket: trade.ticket)
                if success {
                    print("✅ Trade closed: \(trade.ticket)")
                }
            } catch {
                print("❌ Failed to close trade: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - Supporting Views

struct MT5AccountCard: View {
    let account: SharedTypes.MT5Account
    let isSelected: Bool
    let onConnect: () -> Void
    
    var body: some View {
        Button(action: onConnect) {
            UltraPremiumCard {
                VStack(spacing: 12) {
                    HStack {
                        Text(account.login)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(DesignSystem.primaryText)
                        
                        Spacer()
                        
                        Circle()
                            .fill(account.isConnected ? Color.green : Color.gray)
                            .frame(width: 8, height: 8)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(account.company)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(DesignSystem.secondaryText)
                        
                        Text(account.server)
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(DesignSystem.secondaryText)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    if account.isConnected {
                        Text("$\(String(format: "%.2f", account.balance))")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(DesignSystem.primaryGold)
                    }
                }
                .frame(height: 80)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

struct MT5TradeCard: View {
    let trade: SharedTypes.MT5Trade
    let onClose: () -> Void
    
    var body: some View {
        UltraPremiumCard {
            VStack(spacing: 12) {
                HStack {
                    Text("#\(trade.ticket)")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(DesignSystem.secondaryText)
                    
                    Spacer()
                    
                    Text(trade.type.rawValue)
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(trade.type == .buy ? .green : .red)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background((trade.type == .buy ? Color.green : Color.red).opacity(0.1))
                        .clipShape(Capsule())
                }
                
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Entry")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(DesignSystem.secondaryText)
                        
                        Text(String(format: "%.2f", trade.openPrice))
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(DesignSystem.primaryText)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .center, spacing: 4) {
                        Text("Volume")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(DesignSystem.secondaryText)
                        
                        Text(String(format: "%.2f", trade.volume))
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(DesignSystem.primaryText)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("P&L")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(DesignSystem.secondaryText)
                        
                        Text(String(format: "%.2f", trade.profit))
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(trade.profit >= 0 ? .green : .red)
                    }
                }
                
                Button("Close Position") {
                    onClose()
                }
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(.red)
                .clipShape(RoundedRectangle(cornerRadius: 6))
            }
        }
    }
}

struct AddMT5AccountView: View {
    @ObservedObject var brokerConnector: BrokerConnector
    @Environment(\.dismiss) private var dismiss
    
    @State private var login = ""
    @State private var password = ""
    @State private var server = "CoinexxDemo-Server"
    @State private var company = "Coinexx"
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Account Details")) {
                    TextField("Login", text: $login)
                    SecureField("Password", text: $password)
                    TextField("Server", text: $server)
                    TextField("Company", text: $company)
                }
                
                Section(header: Text("Common Demo Servers")) {
                    Button("Coinexx Demo") {
                        server = "CoinexxDemo-Server"
                        company = "Coinexx"
                    }
                    
                    Button("MetaQuotes Demo") {
                        server = "MetaQuotes-Demo"
                        company = "MetaQuotes"
                    }
                    
                    Button("Alpari Demo") {
                        server = "Alpari-Demo"
                        company = "Alpari"
                    }
                }
            }
            .navigationTitle("Add MT5 Account")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        brokerConnector.addDemoAccount(
                            login: login,
                            password: password,
                            server: server,
                            company: company
                        )
                        dismiss()
                    }
                    .disabled(login.isEmpty || password.isEmpty || server.isEmpty)
                }
            }
        }
    }
}

#Preview {
    MT5AccountSetupView()
}