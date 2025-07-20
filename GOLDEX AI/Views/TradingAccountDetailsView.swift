//
//  TradingAccountDetailsView.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 7/13/25.
//

import SwiftUI

struct TradingAccountDetailsView: View {
    @ObservedObject var accountManager: RealTimeAccountManager
    @Environment(\.dismiss) private var dismiss
    @State private var animateCards = false
    @State private var showingConnectionStatus = false
    
    var body: some View {
        NavigationView {
            ZStack {
                DesignSystem.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Account Header
                        accountHeaderSection
                        
                        // Real-Time Balance Card
                        realTimeBalanceCard
                        
                        // Account Statistics
                        accountStatisticsSection
                        
                        // Active Trades
                        activeTradesSection
                        
                        // Connection Details
                        connectionDetailsSection
                        
                        // EA Status
                        eaStatusSection
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .navigationTitle("Account Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(DesignSystem.primaryGold)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Refresh") {
                        Task {
                            await accountManager.refreshAccountData()
                        }
                    }
                    .foregroundColor(DesignSystem.primaryGold)
                }
            })
            .onAppear {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2)) {
                    animateCards = true
                }
            }
        }
    }
    
    // MARK: - Account Header Section
    
    private var accountHeaderSection: some View {
        UltraPremiumCard {
            VStack(spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(accountManager.currentAccount?.accountName ?? "No Account")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Text("Login: \(accountManager.currentAccount?.accountNumber ?? "N/A")")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Circle()
                            .fill(accountManager.isConnected ? .green : .red)
                            .frame(width: 12, height: 12)
                            .scaleEffect(accountManager.isConnected ? 1.2 : 1.0)
                            .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: accountManager.isConnected)
                        
                        Text(accountManager.isConnected ? "CONNECTED" : "DISCONNECTED")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(accountManager.isConnected ? .green : .red)
                    }
                }
                
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Server")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text(accountManager.currentAccount?.serverName ?? "N/A")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .center, spacing: 4) {
                        Text("Platform")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text(accountManager.currentAccount?.platform ?? "N/A")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Type")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text("DEMO")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.orange)
                        Text(accountManager.currentAccount?.brokerType.displayName ?? "N/A")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                    }
                }
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.9)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: animateCards)
    }
    
    // MARK: - Real-Time Balance Card
    
    private var realTimeBalanceCard: some View {
        UltraPremiumCard {
            VStack(spacing: 20) {
                HStack {
                    Text("Account Balance")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Text("USD")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color(.systemGray5))
                        .cornerRadius(4)
                }
                
                // Main Balance Display
                VStack(spacing: 8) {
                    Text(accountManager.formattedBalance)
                        .font(.system(size: 42, weight: .bold, design: .rounded))
                        .foregroundColor(DesignSystem.primaryGold)
                    
                    Text("Available Balance")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                // Balance Breakdown
                VStack(spacing: 12) {
                    BalanceDetailRow(
                        title: "Equity",
                        value: accountManager.formattedEquity,
                        color: .green
                    )
                    
                    BalanceDetailRow(
                        title: "Floating P&L",
                        value: accountManager.formattedFloatingPnL,
                        color: accountManager.floatingPnL >= 0 ? .green : .red
                    )
                    
                    BalanceDetailRow(
                        title: "Today's P&L",
                        value: accountManager.formattedTodaysPnL,
                        color: accountManager.todaysPnL >= 0 ? .green : .red
                    )
                    
                    BalanceDetailRow(
                        title: "Free Margin",
                        value: String(format: "$%.2f", accountManager.freeMargin),
                        color: .blue
                    )
                }
                
                // Last Update
                HStack {
                    Circle()
                        .fill(.green)
                        .frame(width: 6, height: 6)
                    
                    Text("Last updated: \(accountManager.lastUpdate.formatted(date: .omitted, time: .shortened))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                }
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.9)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1), value: animateCards)
    }
    
    // MARK: - Account Statistics Section
    
    private var accountStatisticsSection: some View {
        UltraPremiumCard {
            VStack(alignment: .leading, spacing: 16) {
                Text("Today's Statistics")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                    TradingAccountStatCard(
                        title: "Total Trades",
                        value: "\(accountManager.todayTrades)",
                        color: .blue,
                        icon: "arrow.up.arrow.down"
                    )
                    
                    TradingAccountStatCard(
                        title: "Win Rate",
                        value: accountManager.formattedWinRate,
                        color: .green,
                        icon: "chart.line.uptrend.xyaxis"
                    )
                    
                    TradingAccountStatCard(
                        title: "Best Trade",
                        value: String(format: "$%.2f", accountManager.bestTrade),
                        color: .green,
                        icon: "star.fill"
                    )
                    
                    TradingAccountStatCard(
                        title: "Worst Trade",
                        value: String(format: "$%.2f", accountManager.worstTrade),
                        color: .red,
                        icon: "star"
                    )
                }
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.9)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2), value: animateCards)
    }
    
    // MARK: - Active Trades Section
    
    private var activeTradesSection: some View {
        UltraPremiumCard {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("Active Trades")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Text("\(accountManager.activeTrades.count) Open")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color(.systemGray5))
                        .cornerRadius(4)
                }
                
                if accountManager.activeTrades.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "chart.line.uptrend.xyaxis")
                            .font(.system(size: 30))
                            .foregroundColor(.secondary)
                        
                        Text("No Active Trades")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Text("Your EA will open trades automatically")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                } else {
                    LazyVStack(spacing: 12) {
                        ForEach(accountManager.activeTrades, id: \.ticket) { trade in
                            ActiveTradeRow(trade: trade)
                        }
                    }
                }
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.9)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3), value: animateCards)
    }
    
    // MARK: - Connection Details Section
    
    private var connectionDetailsSection: some View {
        UltraPremiumCard {
            VStack(alignment: .leading, spacing: 16) {
                Text("Connection Details")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                VStack(spacing: 12) {
                    ConnectionDetailRow(
                        title: "Status",
                        value: accountManager.connectionStatus,
                        color: accountManager.isConnected ? .green : .red
                    )
                    
                    ConnectionDetailRow(
                        title: "Server Time",
                        value: accountManager.serverTime.formatted(date: .omitted, time: .complete),
                        color: .blue
                    )
                    
                    ConnectionDetailRow(
                        title: "Ping",
                        value: "< 50ms",
                        color: .green
                    )
                    
                    ConnectionDetailRow(
                        title: "Last Sync",
                        value: accountManager.lastUpdate.formatted(date: .omitted, time: .shortened),
                        color: .secondary
                    )
                }
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.9)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.4), value: animateCards)
    }
    
    // MARK: - EA Status Section
    
    private var eaStatusSection: some View {
        UltraPremiumCard {
            VStack(alignment: .leading, spacing: 16) {
                Text("EA Status")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("GOLDEX AI EA")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                        
                        Text(accountManager.eaIsRunning ? "Running" : "Stopped")
                            .font(.caption)
                            .foregroundColor(accountManager.eaIsRunning ? .green : .red)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Circle()
                            .fill(accountManager.eaStatusColor)
                            .frame(width: 12, height: 12)

                        
                        Text(accountManager.eaCanTrade ? "Trading" : "Monitoring")
                            .font(.caption)
                            .foregroundColor(accountManager.eaCanTrade ? .green : .orange)
                    }
                }
                
                if !accountManager.eaSignals.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Recent Signals")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                        
                        ForEach(accountManager.eaSignals.prefix(3)) { signal in
                            HStack {
                                Image(systemName: signal.direction.icon)
                                    .foregroundColor(signal.direction.color)
                                    .frame(width: 16)
                                
                                Text(signal.reasoning)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .lineLimit(1)
                                
                                Spacer()
                                
                                Text("\(Int(signal.confidence * 100))%")
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .foregroundColor(.primary)
                            }
                        }
                    }
                }
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.9)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.5), value: animateCards)
    }
}

// MARK: - Supporting Views

struct BalanceDetailRow: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(color)
        }
    }
}

struct TradingAccountStatCard: View {
    let title: String
    let value: String
    let color: Color
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(color)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
}

struct ActiveTradeRow: View {
    let trade: RealTimeTrade
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(trade.symbol)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                Text("Entry: \(String(format: "%.2f", trade.openPrice))")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .center, spacing: 2) {
                Text(trade.direction.rawValue)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(trade.direction.color)
                
                Text("\(String(format: "%.2f", trade.lotSize)) lots")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                Text(String(format: "$%.2f", trade.floatingPnL))
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(trade.floatingPnL >= 0 ? .green : .red)
                
                Text(trade.openTime.formatted(date: .omitted, time: .shortened))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

struct ConnectionDetailRow: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(color)
        }
    }
}

// MARK: - Extensions

struct TradingAccountDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        TradingAccountDetailsView(accountManager: RealTimeAccountManager())
    }
}