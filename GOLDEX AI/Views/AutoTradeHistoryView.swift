//
//  AutoTradeHistoryView.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 7/13/25.
//

import SwiftUI

struct AutoTradeHistoryView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var tradingViewModel: TradingViewModel
    @EnvironmentObject private var accountManager: RealTimeAccountManager
    
    @State private var selectedFilter: TradeFilter = .all
    @State private var selectedTrade: SharedTypes.AutoTrade?
    @State private var searchText = ""
    @State private var showingTradeDetail = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                performanceSummarySection
                
                filtersSection
                
                List(filteredTrades, id: \.id) { trade in
                    TradeRowView(trade: trade)
                        .onTapGesture {
                            selectedTrade = trade
                            showingTradeDetail = true
                        }
                }
                .listStyle(.plain)
            }
            .navigationTitle("Trade History")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showingTradeDetail) {
                if let trade = selectedTrade {
                    TradeDetailView(trade: trade)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button("Export CSV") {
                            exportTrades()
                        }
                        Button("Share Report") {
                            shareReport()
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
        }
    }
    
    private var performanceSummarySection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Performance Summary")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
                
                Text(selectedFilter.rawValue)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(.blue.opacity(0.2))
                    .foregroundStyle(.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
            }
            
            HStack(spacing: 16) {
                SummaryMetric(
                    title: "Total Trades",
                    value: "\(filteredTrades.count)",
                    color: .blue
                )
                
                SummaryMetric(
                    title: "Win Rate",
                    value: "\(Int(winRate * 100))%",
                    color: winRate > 0.7 ? .green : .orange
                )
                
                SummaryMetric(
                    title: "Net P&L",
                    value: "$\(String(format: "%.2f", totalProfit))",
                    color: totalProfit > 0 ? .green : .red
                )
                
                SummaryMetric(
                    title: "Best Trade",
                    value: "$\(String(format: "%.2f", bestTrade))",
                    color: .green
                )
            }
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal)
        .padding(.top)
    }
    
    private var filtersSection: some View {
        VStack(spacing: 12) {
            // Timeframe Filter
            HStack {
                Text("Timeframe")
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Spacer()
                
                Picker("Timeframe", selection: .constant(TimeframeFilter.all)) {
                    ForEach(TimeframeFilter.allCases, id: \.self) { timeframe in
                        Text(timeframe.rawValue).tag(timeframe)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(maxWidth: 200)
            }
            
            // Trade Type Filter
            HStack {
                Text("Filter")
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Spacer()
                
                Picker("Filter", selection: $selectedFilter) {
                    ForEach(TradeFilter.allCases, id: \.self) { filter in
                        Text(filter.displayName).tag(filter)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(maxWidth: 250)
            }
        }
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal)
    }
    
    private var filteredTrades: [SharedTypes.AutoTrade] {
        var filtered = sampleTrades
        
        // Filter by trade result
        switch selectedFilter {
        case .wins:
            filtered = filtered.filter { $0.result == .win }
        case .losses:
            filtered = filtered.filter { $0.result == .loss }
        case .all:
            break
        }
        
        // Filter by search text
        if !searchText.isEmpty {
            filtered = filtered.filter { trade in
                trade.symbol.lowercased().contains(searchText.lowercased()) ||
                trade.reasoning.lowercased().contains(searchText.lowercased())
            }
        }
        
        return filtered.sorted { $0.timestamp > $1.timestamp }
    }
    
    private var winRate: Double {
        let wins = filteredTrades.filter { $0.result == .win }.count
        let total = filteredTrades.count
        return total > 0 ? Double(wins) / Double(total) : 0.0
    }
    
    private var totalProfit: Double {
        filteredTrades.compactMap { $0.profitLoss }.reduce(0, +)
    }
    
    private var bestTrade: Double {
        filteredTrades.compactMap { $0.profitLoss }.max() ?? 0
    }
    
    private var sampleTrades: [SharedTypes.AutoTrade] {
        return [
            SharedTypes.AutoTrade(
                id: UUID().uuidString,
                symbol: "XAUUSD",
                direction: .buy,
                entryPrice: 2374.50,
                exitPrice: 2380.25,
                lotSize: 0.01,
                profit: 57.50,
                status: .closed,
                timestamp: Date().addingTimeInterval(-3600),
                mode: .auto,
                stopLoss: 2365.00,
                takeProfit: 2385.00,
                confidence: 0.85,
                reasoning: "Strong bullish momentum with institutional support",
                result: .win,
                profitLoss: 57.50
            ),
            SharedTypes.AutoTrade(
                id: UUID().uuidString,
                symbol: "XAUUSD",
                direction: .sell,
                entryPrice: 2378.00,
                exitPrice: 2375.50,
                lotSize: 0.01,
                profit: 25.00,
                status: .closed,
                timestamp: Date().addingTimeInterval(-7200),
                mode: .auto,
                stopLoss: 2382.00,
                takeProfit: 2370.00,
                confidence: 0.78,
                reasoning: "Resistance level rejection with volume confirmation",
                result: .win,
                profitLoss: 25.00
            ),
            SharedTypes.AutoTrade(
                id: UUID().uuidString,
                symbol: "XAUUSD",
                direction: .buy,
                entryPrice: 2370.00,
                exitPrice: 2365.75,
                lotSize: 0.01,
                profit: -42.50,
                status: .closed,
                timestamp: Date().addingTimeInterval(-10800),
                mode: .auto,
                stopLoss: 2365.00,
                takeProfit: 2380.00,
                confidence: 0.72,
                reasoning: "False breakout, stopped out at support",
                result: .loss,
                profitLoss: -42.50
            )
        ]
    }
    
    private func exportTrades() {
        // Implement CSV export
        print("Exporting trades to CSV...")
    }
    
    private func shareReport() {
        // Implement share functionality
        print("Sharing trade report...")
    }
}

// MARK: - Trade Detail View
struct TradeDetailView: View {
    let trade: SharedTypes.AutoTrade
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Trade Header
                    VStack(spacing: 12) {
                        HStack {
                            Text(trade.symbol)
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Spacer()
                            
                            Text(trade.direction.displayName)
                                .font(.headline)
                                .foregroundColor(trade.direction.color)
                        }
                        
                        HStack {
                            Text("Entry: $\(String(format: "%.2f", trade.entryPrice))")
                            Spacer()
                            if let exitPrice = trade.exitPrice {
                                Text("Exit: $\(String(format: "%.2f", exitPrice))")
                            }
                        }
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    
                    // Trade Levels
                    VStack(spacing: 12) {
                        if let stopLoss = trade.stopLoss {
                            TradeLevelRow(title: "Stop Loss", value: "$\(String(format: "%.2f", stopLoss))", color: .red)
                        }
                        
                        if let takeProfit = trade.takeProfit {
                            TradeLevelRow(title: "Take Profit", value: "$\(String(format: "%.2f", takeProfit))", color: .green)
                        }
                        
                        TradeLevelRow(title: "Profit/Loss", value: "$\(String(format: "%.2f", trade.profit))", color: trade.profit >= 0 ? .green : .red)
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    
                    // Trade Reasoning
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Trade Reasoning")
                            .font(.headline)
                        
                        Text(trade.reasoning)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Trade Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Supporting Views
struct TradeLevelRow: View {
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

struct SummaryMetric: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundStyle(color)
        }
        .frame(maxWidth: .infinity)
    }
}

struct TradeRowView: View {
    let trade: SharedTypes.AutoTrade
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(trade.symbol)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Spacer()
                Text(trade.direction.displayName)
                    .font(.headline)
                    .foregroundColor(trade.direction.color)
            }
            
            HStack {
                Text("Entry: $\(String(format: "%.2f", trade.entryPrice))")
                Spacer()
                if let exitPrice = trade.exitPrice {
                    Text("Exit: $\(String(format: "%.2f", exitPrice))")
                }
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
        }
        .padding()
        .background(.regularMaterial)
        .cornerRadius(12)
    }
}

// MARK: - Filter Enum
enum TradeFilter: String, CaseIterable {
    case all = "All"
    case wins = "Wins"
    case losses = "Losses"
    
    var displayName: String {
        return rawValue
    }
}

enum TimeframeFilter: String, CaseIterable {
    case today = "Today"
    case week = "Week"
    case month = "Month"
    case all = "All Time"
}

#Preview {
    AutoTradeHistoryView()
        .environmentObject(TradingViewModel())
        .environmentObject(RealTimeAccountManager())
}