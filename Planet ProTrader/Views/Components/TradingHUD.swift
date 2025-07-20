//
//  TradingHUD.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 1/21/25.
//

import SwiftUI

struct TradingHUD: View {
    @StateObject private var chartData = ChartDataService.shared
    @State private var showQuickStats = false
    @State private var pulseEffect = false
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                VStack(spacing: 8) {
                    // Quick P&L Display
                    profitLossHUD
                    
                    // Active Bots Indicator
                    activeBotsHUD
                    
                    // Connection Status
                    connectionHUD
                    
                    // Quick Stats Toggle
                    if showQuickStats {
                        quickStatsPanel
                            .transition(.scale.combined(with: .opacity))
                    }
                }
                .padding(.trailing, 16)
                .padding(.top, 60)
            }
            
            Spacer()
        }
        .onTapGesture {
            withAnimation(.spring()) {
                showQuickStats.toggle()
            }
        }
    }
    
    // MARK: - Profit/Loss HUD
    
    private var profitLossHUD: some View {
        VStack(spacing: 2) {
            Text(chartData.totalBotPL, format: .currency(code: "USD"))
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(chartData.totalBotPL >= 0 ? .green : .red)
            
            Text("P&L")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color.black.opacity(0.8))
        .cornerRadius(8)
        .scaleEffect(pulseEffect ? 1.1 : 1.0)
        .animation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true), value: pulseEffect)
        .onAppear {
            pulseEffect = chartData.totalBotPL > 0
        }
    }
    
    // MARK: - Active Bots HUD
    
    private var activeBotsHUD: some View {
        VStack(spacing: 2) {
            HStack(spacing: 4) {
                Image(systemName: "robot.fill")
                    .font(.caption2)
                    .foregroundColor(DesignSystem.primaryGold)
                
                Text("\(chartData.activeBots.count)")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            
            Text("BOTS")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color.black.opacity(0.8))
        .cornerRadius(8)
    }
    
    // MARK: - Connection HUD
    
    private var connectionHUD: some View {
        VStack(spacing: 2) {
            Circle()
                .fill(chartData.connectionStatus.color)
                .frame(width: 8, height: 8)
                .scaleEffect(chartData.connectionStatus == .connected ? 1.0 : 0.7)
                .animation(.easeInOut(duration: 1.0).repeatForever(), value: chartData.connectionStatus == .connected)
            
            Text("LIVE")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color.black.opacity(0.8))
        .cornerRadius(8)
    }
    
    // MARK: - Quick Stats Panel
    
    private var quickStatsPanel: some View {
        VStack(alignment: .trailing, spacing: 6) {
            statRow(title: "Win Rate", value: "\(Int(chartData.botWinRate * 100))%", color: .green)
            statRow(title: "Active Trades", value: "\(chartData.activeBotTrades)", color: .blue)
            statRow(title: "Today's Trades", value: "47", color: .orange)
            statRow(title: "Spread", value: "\(String(format: "%.1f", chartData.spread / chartData.currentInstrument.pip)) pips", color: .gray)
        }
        .padding(10)
        .background(Color.black.opacity(0.9))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(DesignSystem.primaryGold.opacity(0.3), lineWidth: 1)
        )
    }
    
    private func statRow(title: String, value: String, color: Color) -> some View {
        HStack {
            Text(title)
                .font(.caption2)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.caption2)
                .fontWeight(.bold)
                .foregroundColor(color)
        }
    }
}

#Preview {
    ZStack {
        Color.gray
        TradingHUD()
    }
}