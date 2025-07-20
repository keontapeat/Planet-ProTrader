//
//  PlaybookView.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 7/13/25.
//

import SwiftUI

struct PlaybookView: View {
    @State private var selectedTab: PlaybookTab = .all
    @State private var searchText = ""
    @State private var showingTradeDetail = false
    @State private var selectedTrade: SharedTypes.PlaybookTrade?
    @State private var isLoading = false
    @StateObject private var playbookManager = PlaybookManager()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header Stats
                PlaybookStatsHeaderView(manager: playbookManager)
                
                // Filter Tabs
                PlaybookFilterTabsView(selectedTab: $selectedTab)
                
                // Trade List
                PlaybookTradeListView(
                    trades: filteredTrades,
                    selectedTrade: $selectedTrade,
                    showingDetail: $showingTradeDetail
                )
            }
            .navigationTitle("Playbook")
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $searchText, prompt: "Search trades...")
            .sheet(isPresented: $showingTradeDetail) {
                if let trade = selectedTrade {
                    PlaybookTradeDetailView(trade: trade)
                }
            }
        }
    }
    
    private var filteredTrades: [SharedTypes.PlaybookTrade] {
        var filtered = playbookManager.allTrades
        
        // Filter by grade
        switch selectedTab {
        case .all:
            break
        case .elite:
            filtered = filtered.filter { $0.grade == .elite }
        case .good:
            filtered = filtered.filter { $0.grade == .good }
        case .average:
            filtered = filtered.filter { $0.grade == .average }
        case .poor:
            filtered = filtered.filter { $0.grade == .poor }
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
    
    private func calculateResult() -> SharedTypes.TradeResult {
        return .win // Simplified for compilation
    }
    
    private func colorForGrade(_ grade: SharedTypes.TradeGrade) -> Color {
        switch grade {
        case .all: return .gray
        case .elite: return .purple
        case .good: return .green
        case .average: return .orange
        case .poor: return .red
        }
    }
}

// MARK: - Playbook Manager
class PlaybookManager: ObservableObject {
    @Published var allTrades: [SharedTypes.PlaybookTrade] = []
    
    init() {
        loadSampleTrades()
    }
    
    private func loadSampleTrades() {
        allTrades = [
            SharedTypes.PlaybookTrade(
                id: UUID().uuidString,
                symbol: "XAUUSD",
                direction: .buy,
                entryPrice: 2374.50,
                exitPrice: 2380.25,
                lotSize: 0.01,
                profit: 57.50,
                grade: .elite,
                reasoning: "Perfect institutional order flow confluence",
                timestamp: Date().addingTimeInterval(-3600)
            ),
            SharedTypes.PlaybookTrade(
                id: UUID().uuidString,
                symbol: "XAUUSD",
                direction: .sell,
                entryPrice: 2378.00,
                exitPrice: 2375.50,
                lotSize: 0.01,
                profit: 25.00,
                grade: .good,
                reasoning: "Clean resistance rejection with volume",
                timestamp: Date().addingTimeInterval(-7200)
            ),
            SharedTypes.PlaybookTrade(
                id: UUID().uuidString,
                symbol: "XAUUSD",
                direction: .buy,
                entryPrice: 2370.00,
                exitPrice: 2365.75,
                lotSize: 0.01,
                profit: -42.50,
                grade: .poor,
                reasoning: "False breakout, poor entry timing",
                timestamp: Date().addingTimeInterval(-10800)
            ),
            SharedTypes.PlaybookTrade(
                id: UUID().uuidString,
                symbol: "XAUUSD",
                direction: .sell,
                entryPrice: 2385.00,
                exitPrice: 2390.75,
                lotSize: 0.01,
                profit: -57.50,
                grade: .average,
                reasoning: "News spike caught us off guard",
                timestamp: Date().addingTimeInterval(-14400)
            ),
            SharedTypes.PlaybookTrade(
                id: UUID().uuidString,
                symbol: "XAUUSD",
                direction: .buy,
                entryPrice: 2365.00,
                exitPrice: 2375.50,
                lotSize: 0.02,
                profit: 105.00,
                grade: .elite,
                reasoning: "Perfect London session breakout trade",
                timestamp: Date().addingTimeInterval(-18000)
            )
        ]
    }
    
    var winningTrades: [SharedTypes.PlaybookTrade] {
        return allTrades.filter { $0.profit > 0 }
    }
    
    var losingTrades: [SharedTypes.PlaybookTrade] {
        return allTrades.filter { $0.profit <= 0 }
    }
    
    var eliteTrades: Int {
        return allTrades.filter { $0.grade == .elite }.count
    }
    
    var winRate: Double {
        let total = allTrades.count
        let wins = winningTrades.count
        return total > 0 ? Double(wins) / Double(total) : 0.0
    }
}

// MARK: - Supporting Views
struct PlaybookStatsHeaderView: View {
    let manager: PlaybookManager
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 20) {
                StatCardView(
                    title: "Total Trades",
                    value: "\(manager.allTrades.count)",
                    color: .blue
                )
                
                StatCardView(
                    title: "Win Rate",
                    value: String(format: "%.1f%%", manager.winRate * 100),
                    color: manager.winRate > 0.7 ? .green : .orange
                )
                
                StatCardView(
                    title: "Elite Trades",
                    value: "\(manager.eliteTrades)",
                    color: .purple
                )
            }
        }
        .padding()
        .background(.ultraThinMaterial)
    }
}

struct StatCardView: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.title2)
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

struct PlaybookFilterTabsView: View {
    @Binding var selectedTab: PlaybookTab
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(SharedTypes.TradeGrade.allCases, id: \.self) { grade in
                    Button(action: {
                        selectedTab = grade
                    }) {
                        Text(grade.rawValue)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(selectedTab == grade ? DesignSystem.primaryGold : Color.gray.opacity(0.2))
                            .foregroundColor(selectedTab == grade ? .white : .primary)
                            .cornerRadius(20)
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 8)
    }
}

struct PlaybookTradeListView: View {
    let trades: [SharedTypes.PlaybookTrade]
    @Binding var selectedTrade: SharedTypes.PlaybookTrade?
    @Binding var showingDetail: Bool
    
    var body: some View {
        List(trades, id: \.id) { trade in
            PlaybookTradeRowView(trade: trade)
                .onTapGesture {
                    selectedTrade = trade
                    showingDetail = true
                }
        }
        .listStyle(.plain)
    }
}

struct PlaybookTradeRowView: View {
    let trade: SharedTypes.PlaybookTrade
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(trade.symbol)
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text(trade.direction.displayName)
                        .font(.subheadline)
                        .foregroundColor(trade.direction.color)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(trade.profit >= 0 ? "+\(String(format: "%.2f", trade.profit))" : "\(String(format: "%.2f", trade.profit))")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(trade.profit >= 0 ? .green : .red)
                    
                    Text(trade.grade.rawValue)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(colorForGrade(trade.grade).opacity(0.2))
                        .foregroundColor(colorForGrade(trade.grade))
                        .cornerRadius(8)
                }
            }
            
            Text(trade.reasoning)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(2)
            
            HStack {
                Text("Entry: \(String(format: "%.2f", trade.entryPrice))")
                Text("•")
                Text("Exit: \(String(format: "%.2f", trade.exitPrice))")
                
                Spacer()
                
                Text(timeAgo(for: trade.timestamp))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .font(.caption)
            .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
    
    private func timeAgo(for date: Date) -> String {
        let interval = Date().timeIntervalSince(date)
        
        if interval < 60 {
            return "Now"
        } else if interval < 3600 {
            return "\(Int(interval / 60))m ago"
        } else if interval < 86400 {
            return "\(Int(interval / 3600))h ago"
        } else {
            let days = Int(interval / 86400)
            return "\(days)d ago"
        }
    }
    
    private func colorForGrade(_ grade: SharedTypes.TradeGrade) -> Color {
        switch grade {
        case .all: return .gray
        case .elite: return .purple
        case .good: return .green
        case .average: return .orange
        case .poor: return .red
        }
    }
}

struct PlaybookTradeDetailView: View {
    let trade: SharedTypes.PlaybookTrade
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Trade Header
                    VStack(spacing: 16) {
                        HStack {
                            Text(trade.symbol)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            
                            Spacer()
                            
                            VStack(alignment: .trailing, spacing: 4) {
                                Text(trade.direction.displayName)
                                    .font(.headline)
                                    .foregroundColor(trade.direction.color)
                                
                                Text(trade.grade.rawValue)
                                    .font(.subheadline)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 4)
                                    .background(colorForGrade(trade.grade).opacity(0.2))
                                    .foregroundColor(colorForGrade(trade.grade))
                                    .cornerRadius(8)
                            }
                        }
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Profit/Loss")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                Text("$\(String(format: "%.2f", trade.profit))")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(trade.profit >= 0 ? .green : .red)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing, spacing: 4) {
                                Text("Lot Size")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                Text(String(format: "%.2f", trade.lotSize))
                                    .font(.title2)
                                    .fontWeight(.semibold)
                            }
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(16)
                    
                    // Trade Details
                    VStack(spacing: 16) {
                        DetailRowView(title: "Entry Price", value: "$\(String(format: "%.2f", trade.entryPrice))")
                        DetailRowView(title: "Exit Price", value: "$\(String(format: "%.2f", trade.exitPrice))")
                        DetailRowView(title: "Date", value: formatDateString(trade.timestamp))
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(16)
                    
                    // Trade Reasoning
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Analysis & Reasoning")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Text(trade.reasoning)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(16)
                    
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
    
    private func formatDateString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    private func colorForGrade(_ grade: SharedTypes.TradeGrade) -> Color {
        switch grade {
        case .all: return .gray
        case .elite: return .purple
        case .good: return .green
        case .average: return .orange
        case .poor: return .red
        }
    }
}

struct DetailRowView: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
        }
    }
}

// MARK: - Type Aliases
typealias PlaybookTab = SharedTypes.TradeGrade

#Preview {
    PlaybookView()
}