//
//  RealAccountDashboard.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 7/13/25.
//

import SwiftUI

/// Dashboard showing real MT5 account data from your Coinexx account
struct RealAccountDashboard: View {
    @StateObject private var brokerConnector = BrokerConnector()
    @StateObject private var screenshotManager = FirebaseScreenshotManager()
    @State private var showAccountDetails = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Real Account Header
                RealAccountHeader(
                    account: brokerConnector.currentAccount,
                    isConnected: brokerConnector.isConnected
                )
                
                // Real Balance Card
                RealBalanceCard(
                    balance: brokerConnector.currentAccount?.balance ?? 0.0,
                    equity: brokerConnector.currentAccount?.equity ?? 0.0,
                    margin: brokerConnector.currentAccount?.margin ?? 0.0,
                    freeMargin: brokerConnector.currentAccount?.freeMargin ?? 0.0
                )
                
                // Real Trades Section
                RealTradesSection(
                    trades: brokerConnector.activeTrades,
                    symbol: brokerConnector.currentSymbol
                )
                
                // Real Performance Metrics
                RealPerformanceMetrics(
                    account: brokerConnector.currentAccount,
                    trades: brokerConnector.activeTrades
                )
                
                // Screenshot Controls
                ScreenshotControls(screenshotManager: screenshotManager)
                
                // Connection Status
                ConnectionStatusCard(
                    status: brokerConnector.connectionStatus,
                    isConnected: brokerConnector.isConnected
                )
            }
            .padding()
        }
        .navigationTitle("Real Account")
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            Task {
                await connectToRealAccount()
            }
        }
        .refreshable {
            await refreshAccountData()
        }
    }
    
    private func connectToRealAccount() async {
        let credentials = SharedTypes.BrokerCredentials(
            login: "845514",
            password: "Jj0@AfHgVv7kpj",
            server: "Coinexx-demo",
            brokerType: .coinexx
        )
        
        do {
            brokerConnector.connect()
            
            // Start real-time updates
            await startRealTimeUpdates()
            
        } catch {
            print("❌ Failed to connect to real account: \(error)")
        }
    }
    
    private func startRealTimeUpdates() async {
        // Update balance every 10 seconds
        Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { _ in
            Task {
                await brokerConnector.updateRealTimeBalance()
            }
        }
        
        // Load real trades every 30 seconds
        Timer.scheduledTimer(withTimeInterval: 30.0, repeats: true) { _ in
            Task {
                await brokerConnector.loadRealTradesFromMT5()
            }
        }
    }
    
    private func refreshAccountData() async {
        await brokerConnector.updateRealTimeBalance()
        await brokerConnector.loadRealTradesFromMT5()
    }
}

// MARK: - Real Account Header

struct RealAccountHeader: View {
    let account: SharedTypes.MT5Account?
    let isConnected: Bool
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: isConnected ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .font(.title2)
                    .foregroundColor(isConnected ? .green : .red)
                
                VStack(alignment: .leading) {
                    Text("Coinexx Account")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(account?.login ?? "Not Connected")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text(isConnected ? "LIVE" : "OFFLINE")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(isConnected ? .green : .red)
                    
                    Text(account?.server ?? "---")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Divider()
            
            HStack {
                Text("Real Money Trading")
                    .font(.subheadline)
                    .foregroundColor(.orange)
                
                Spacer()
                
                Text("Account: \(account?.login ?? "---")")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}

// MARK: - Real Balance Card

struct RealBalanceCard: View {
    let balance: Double
    let equity: Double
    let margin: Double
    let freeMargin: Double
    
    var body: some View {
        VStack(spacing: 16) {
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
            
            // Main Balance
            VStack(spacing: 8) {
                Text("$\(String(format: "%.2f", balance))")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                
                Text("Available Balance")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            // Balance Details
            VStack(spacing: 12) {
                BalanceRow(title: "Equity", value: equity, color: .green)
                BalanceRow(title: "Used Margin", value: margin, color: .orange)
                BalanceRow(title: "Free Margin", value: freeMargin, color: .blue)
            }
            
            // Balance Status
            HStack {
                Circle()
                    .fill(balance > 1000 ? Color.green : Color.red)
                    .frame(width: 8, height: 8)
                
                Text(balance > 1000 ? "Account Healthy" : "Low Balance Warning")
                    .font(.caption)
                    .foregroundColor(balance > 1000 ? .green : .red)
                
                Spacer()
                
                Text("Last Updated: \(Date().formatted(date: .omitted, time: .shortened))")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}

struct BalanceRow: View {
    let title: String
    let value: Double
    let color: Color
    
    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text("$\(String(format: "%.2f", value))")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(color)
        }
    }
}

// MARK: - Real Trades Section

struct RealTradesSection: View {
    let trades: [SharedTypes.MT5Trade]
    let symbol: SharedTypes.MT5Symbol?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Active Trades")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Text("\(trades.count) Open")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color(.systemGray5))
                    .cornerRadius(4)
            }
            
            if trades.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .font(.system(size: 40))
                        .foregroundColor(.secondary)
                    
                    Text("No Active Trades")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text("Your EA will open trades automatically based on signals")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
            } else {
                LazyVStack(spacing: 12) {
                    ForEach(trades, id: \.ticket) { trade in
                        RealTradeCard(trade: trade, symbol: symbol)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}

struct RealTradeCard: View {
    let trade: SharedTypes.MT5Trade
    let symbol: SharedTypes.MT5Symbol?
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(trade.symbol)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text("Ticket: \(trade.ticket)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(trade.type.rawValue)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(trade.type == .buy ? .green : .red)
                    
                    Text("\(String(format: "%.2f", trade.volume)) lots")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Entry: \(String(format: "%.2f", trade.openPrice))")
                        .font(.subheadline)
                        .foregroundColor(.primary)
                    
                    Text("SL: \(String(format: "%.2f", trade.stopLoss))")
                        .font(.caption)
                        .foregroundColor(.red)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("P&L: \(trade.profit >= 0 ? "+" : "")\(String(format: "%.2f", trade.profit))")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(trade.profit >= 0 ? .green : .red)
                    
                    Text("TP: \(String(format: "%.2f", trade.takeProfit))")
                        .font(.caption)
                        .foregroundColor(.green)
                }
            }
            
            HStack {
                Text("Opened: \(trade.openTime.formatted(date: .omitted, time: .shortened))")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text(trade.comment)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

// MARK: - Real Performance Metrics

struct RealPerformanceMetrics: View {
    let account: SharedTypes.MT5Account?
    let trades: [SharedTypes.MT5Trade]
    
    private var totalPnL: Double {
        trades.reduce(0.0) { $0 + $1.profit }
    }
    
    private var winningTrades: Int {
        trades.filter { $0.profit > 0 }.count
    }
    
    private var winRate: Double {
        guard !trades.isEmpty else { return 0.0 }
        return Double(winningTrades) / Double(trades.count) * 100.0
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Performance Metrics")
                .font(.headline)
                .foregroundColor(.primary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                RealAccountMetricCard(title: "Total P&L", value: "$\(String(format: "%.2f", totalPnL))", color: totalPnL >= 0 ? .green : .red)
                RealAccountMetricCard(title: "Win Rate", value: "\(String(format: "%.1f", winRate))%", color: winRate >= 60 ? .green : .orange)
                RealAccountMetricCard(title: "Open Trades", value: "\(trades.count)", color: .blue)
                RealAccountMetricCard(title: "Account Level", value: "\(String(format: "%.1f", (account?.equity ?? 0.0) / 1270.0 * 100))%", color: .purple)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}

struct RealAccountMetricCard: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

// MARK: - Screenshot Controls

struct ScreenshotControls: View {
    @ObservedObject var screenshotManager: FirebaseScreenshotManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Screenshot System")
                .font(.headline)
                .foregroundColor(.primary)
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Today: \(screenshotManager.screenshotsToday)")
                        .font(.subheadline)
                        .foregroundColor(.primary)
                    
                    Text("Status: \(screenshotManager.uploadStatus)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button(action: {
                    Task {
                        await screenshotManager.captureManualScreenshot()
                    }
                }) {
                    HStack {
                        Image(systemName: "camera")
                        Text("Capture")
                    }
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.blue)
                    .cornerRadius(6)
                }
                .disabled(screenshotManager.isUploading)
            }
            
            if let lastTime = screenshotManager.lastScreenshotTime {
                Text("Last screenshot: \(lastTime.formatted(date: .omitted, time: .shortened))")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}

// MARK: - Connection Status

struct ConnectionStatusCard: View {
    let status: String
    let isConnected: Bool
    
    var body: some View {
        HStack {
            Circle()
                .fill(isConnected ? Color.green : Color.red)
                .frame(width: 12, height: 12)
            
            Text(status)
                .font(.subheadline)
                .foregroundColor(.primary)
            
            Spacer()
            
            Text(isConnected ? "CONNECTED" : "DISCONNECTED")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(isConnected ? .green : .red)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

// MARK: - Preview

#Preview {
    NavigationView {
        RealAccountDashboard()
    }
}