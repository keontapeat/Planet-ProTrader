//
//  DashboardTradeHistoryView.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 7/13/25.
//

import SwiftUI

struct DashboardTradeHistoryView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTimeframe: TradeHistoryTimeframe = .today
    @State private var animateCards = false
    @State private var searchText = ""
    @State private var showingFilterOptions = false
    
    // Sample trade data
    @State private var trades: [HistoricalTrade] = [
        HistoricalTrade(
            id: "1",
            symbol: "XAUUSD",
            type: .buy,
            lotSize: 0.01,
            openPrice: 2665.50,
            closePrice: 2670.25,
            openTime: Date().addingTimeInterval(-3600),
            closeTime: Date().addingTimeInterval(-1800),
            profit: 47.50,
            status: .closed
        ),
        HistoricalTrade(
            id: "2",
            symbol: "XAUUSD",
            type: .sell,
            lotSize: 0.01,
            openPrice: 2672.00,
            closePrice: 2668.75,
            openTime: Date().addingTimeInterval(-7200),
            closeTime: Date().addingTimeInterval(-5400),
            profit: 32.50,
            status: .closed
        )
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                DesignSystem.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header Section
                        headerSection
                        
                        // Timeframe Selection
                        timeframeSelectionSection
                        
                        // Statistics Cards
                        statisticsSection
                        
                        // Search and Filter
                        searchAndFilterSection
                        
                        // Trade History List
                        tradeHistorySection
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .navigationTitle("Trade History")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(DesignSystem.primaryGold)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Filter") {
                        showingFilterOptions = true
                    }
                    .foregroundColor(DesignSystem.primaryGold)
                }
            })
            .onAppear {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2)) {
                    animateCards = true
                }
            }
            .sheet(isPresented: $showingFilterOptions) {
                FilterOptionsView()
            }
        }
    }
    
    private var headerSection: some View {
        UltraPremiumCard {
            VStack(spacing: 16) {
                HStack {
                    Image(systemName: "clock.arrow.circlepath")
                        .font(.system(size: 40))
                        .foregroundColor(DesignSystem.primaryGold)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Trade History")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Text("Complete record of all your trading activities")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                }
                
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Total Trades")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text("\(trades.count)")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Win Rate")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text("85%")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.green)
                    }
                }
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.9)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: animateCards)
    }
    
    private var timeframeSelectionSection: some View {
        UltraPremiumCard {
            VStack(alignment: .leading, spacing: 16) {
                Text("Timeframe")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                HStack(spacing: 8) {
                    ForEach(TradeHistoryTimeframe.allCases, id: \.self) { timeframe in
                        Button(action: {
                            selectedTimeframe = timeframe
                        }) {
                            Text(timeframe.rawValue)
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(selectedTimeframe == timeframe ? .white : DesignSystem.primaryGold)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(selectedTimeframe == timeframe ? DesignSystem.primaryGold : Color.clear)
                                .cornerRadius(6)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(DesignSystem.primaryGold, lineWidth: 1)
                                )
                        }
                    }
                }
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.9)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1), value: animateCards)
    }
    
    private var statisticsSection: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
            StatisticCard(
                title: "Total Profit",
                value: "$80.00",
                color: .green,
                icon: "chart.line.uptrend.xyaxis"
            )
            
            StatisticCard(
                title: "Best Trade",
                value: "$47.50",
                color: .green,
                icon: "star.fill"
            )
            
            StatisticCard(
                title: "Average Win",
                value: "$40.00",
                color: .blue,
                icon: "arrow.up.right"
            )
            
            StatisticCard(
                title: "Drawdown",
                value: "2.5%",
                color: .orange,
                icon: "arrow.down.right"
            )
        }
        .scaleEffect(animateCards ? 1.0 : 0.9)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2), value: animateCards)
    }
    
    private var searchAndFilterSection: some View {
        UltraPremiumCard {
            VStack(spacing: 12) {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                    
                    TextField("Search trades...", text: $searchText)
                        .textFieldStyle(PlainTextFieldStyle())
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                
                HStack {
                    Text("Showing \(filteredTrades.count) trades")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Button("Clear Filters") {
                        searchText = ""
                        selectedTimeframe = .today
                    }
                    .font(.caption)
                    .foregroundColor(DesignSystem.primaryGold)
                }
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.9)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3), value: animateCards)
    }
    
    private var tradeHistorySection: some View {
        LazyVStack(spacing: 12) {
            ForEach(filteredTrades) { trade in
                TradeHistoryCard(trade: trade)
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.9)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.4), value: animateCards)
    }
    
    private var filteredTrades: [HistoricalTrade] {
        trades.filter { trade in
            if !searchText.isEmpty {
                return trade.symbol.localizedCaseInsensitiveContains(searchText)
            }
            return true
        }
    }
}

// MARK: - Supporting Views

struct StatisticCard: View {
    let title: String
    let value: String
    let color: Color
    let icon: String
    
    var body: some View {
        UltraPremiumCard {
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
        }
    }
}

struct TradeHistoryCard: View {
    let trade: HistoricalTrade
    
    var body: some View {
        UltraPremiumCard {
            VStack(spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(trade.symbol)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        
                        Text(trade.type.rawValue.uppercased())
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(trade.type == .buy ? .green : .red)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text(String(format: "$%.2f", trade.profit))
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(trade.profit >= 0 ? .green : .red)
                        
                        Text(trade.status.rawValue.uppercased())
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Entry: \(String(format: "%.2f", trade.openPrice))")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text("Exit: \(String(format: "%.2f", trade.closePrice))")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("\(String(format: "%.2f", trade.lotSize)) lots")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text(trade.openTime.formatted(date: .omitted, time: .shortened))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
}

struct FilterOptionsView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Filter Options")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding()
                
                Text("Filter options coming soon...")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(DesignSystem.primaryGold)
                }
            })
        }
    }
}

// MARK: - Data Models

enum TradeHistoryTimeframe: String, CaseIterable {
    case today = "Today"
    case week = "Week"
    case month = "Month"
    case year = "Year"
    case all = "All"
}

struct HistoricalTrade: Identifiable {
    let id: String
    let symbol: String
    let type: TradeType
    let lotSize: Double
    let openPrice: Double
    let closePrice: Double
    let openTime: Date
    let closeTime: Date
    let profit: Double
    let status: TradeStatus
}

enum TradeType: String {
    case buy = "buy"
    case sell = "sell"
}

enum TradeStatus: String {
    case closed = "closed"
    case open = "open"
}

struct DashboardTradeHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardTradeHistoryView()
    }
}