//
//  PlaybookView.swift - The Trader's Dream Playbook
//  GOLDEX AI - Worthy of Mark Douglas, Jared Tendler & Mike Bellafiore
//
//  Created by AI Assistant on 7/18/25.
//

import SwiftUI
import PhotosUI
import UniformTypeIdentifiers

struct PlaybookView: View {
    @StateObject private var playbookEngine = LegendaryPlaybookEngine()
    @StateObject private var markDouglasEngine = PlanetMarkDouglasEngine()
    
    // MARK: - State Management
    @State private var selectedTab: PlaybookSection = .live
    @State private var searchText = ""
    @State private var showingTradeEntry = false
    @State private var showingTradeDetail = false
    @State private var selectedTrade: PlaybookTrade?
    @State private var animateOnAppear = false
    
    // MARK: - Photo Picker for Screenshots
    @State private var selectedPhotos: [PhotosPickerItem] = []
    @State private var showingPhotoPicker = false
    
    enum PlaybookSection: String, CaseIterable {
        case live = "LIVE TRADES"
        case journal = "JOURNAL"
        case grades = "GRADES"
        case psychology = "PSYCHOLOGY"
        case statistics = "STATISTICS"
        
        var icon: String {
            switch self {
            case .live: return "bolt.circle.fill"
            case .journal: return "book.fill"
            case .grades: return "graduationcap.fill"
            case .psychology: return "brain.head.profile"
            case .statistics: return "chart.bar.fill"
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Premium Trading Floor Background
                tradingFloorBackground
                    .ignoresSafeArea()
                
                if playbookEngine.isLoading {
                    loadingView
                } else {
                    mainContent
                }
            }
            .navigationBarHidden(true)
            .searchable(text: $searchText, prompt: "Search trades, setups, patterns...")
            .sheet(isPresented: $showingTradeEntry) {
                TradeEntrySheet(engine: playbookEngine)
            }
            .sheet(item: $selectedTrade) { trade in
                TradeDetailSheet(trade: trade, engine: playbookEngine)
            }
            .photosPicker(
                isPresented: $showingPhotoPicker,
                selection: $selectedPhotos,
                maxSelectionCount: 3,
                matching: .images
            )
            .onChange(of: selectedPhotos) { _, newPhotos in
                handlePhotoSelection(newPhotos)
            }
            .onAppear {
                withAnimation(DesignSystem.springAnimation.delay(0.1)) {
                    animateOnAppear = true
                }
            }
            .alert("Error", isPresented: .constant(playbookEngine.errorMessage != nil)) {
                Button("OK") {
                    playbookEngine.errorMessage = nil
                }
            } message: {
                Text(playbookEngine.errorMessage ?? "")
            }
        }
    }
    
    // MARK: - Main Content
    
    private var mainContent: some View {
        VStack(spacing: 0) {
            // LEGENDARY Header
            legendaryPlaybookHeader
            
            // Performance Dashboard
            performanceDashboard
            
            // Premium Tab Navigation
            premiumTabNavigation
            
            // Main Content
            TabView(selection: $selectedTab) {
                liveTradesTab.tag(PlaybookSection.live)
                journalTab.tag(PlaybookSection.journal)
                gradesTab.tag(PlaybookSection.grades)
                psychologyTab.tag(PlaybookSection.psychology)
                statisticsTab.tag(PlaybookSection.statistics)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
    }
    
    // MARK: - Loading View
    
    private var loadingView: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(2.0)
                .tint(DesignSystem.primaryGold)
            
            Text("Loading Trading Data...")
                .font(DesignSystem.headlineFont)
                .foregroundColor(.white)
        }
    }
    
    // MARK: - Trading Floor Background
    
    private var tradingFloorBackground: some View {
        LinearGradient(
            stops: [
                .init(color: Color.black, location: 0.0),
                .init(color: Color.green.opacity(0.1), location: 0.3),
                .init(color: Color.blue.opacity(0.1), location: 0.6),
                .init(color: Color.black, location: 1.0)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    // MARK: - Legendary Header
    
    private var legendaryPlaybookHeader: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("THE PLAYBOOK™")
                        .font(DesignSystem.titleFont)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [DesignSystem.primaryGold, .white, DesignSystem.primaryGold],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                    
                    Text("TRADER'S DREAM JOURNAL")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white.opacity(0.8))
                        .tracking(2)
                }
                
                Spacer()
                
                Button(action: { showingTradeEntry = true }) {
                    HStack(spacing: 8) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                        
                        Text("NEW TRADE")
                            .font(.system(size: 14, weight: .bold))
                    }
                    .foregroundColor(.black)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(DesignSystem.primaryGold)
                    )
                }
                .buttonStyle(.plain)
            }
            
            // Live Trading Status
            HStack(spacing: 20) {
                StatusBadge(
                    title: "MARK DOUGLAS",
                    status: markDouglasEngine.currentEmotionalState.rawValue,
                    color: markDouglasEngine.currentEmotionalState.color
                )
                
                StatusBadge(
                    title: "AUTO-LOG",
                    status: "ACTIVE",
                    color: .green
                )
                
                StatusBadge(
                    title: "PSYCHOLOGY",
                    status: "\(Int(markDouglasEngine.probabilisticThinking * 100))%",
                    color: .blue
                )
                
                StatusBadge(
                    title: "DISCIPLINE",
                    status: "\(Int(markDouglasEngine.disciplineScore * 100))%",
                    color: .purple
                )
            }
        }
        .padding()
        .scaleEffect(animateOnAppear ? 1.0 : 0.8)
        .opacity(animateOnAppear ? 1.0 : 0.0)
        .animation(DesignSystem.springAnimation, value: animateOnAppear)
    }
    
    // MARK: - Performance Dashboard
    
    private var performanceDashboard: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 12) {
            PerformanceCard(
                title: "Win Rate",
                value: "\(Int(playbookEngine.winRate * 100))%",
                change: "+5.2%",
                color: playbookEngine.winRate > 0.7 ? .green : .orange,
                icon: "target"
            )
            
            PerformanceCard(
                title: "Profit Factor",
                value: String(format: "%.2f", playbookEngine.profitFactor),
                change: "+0.15",
                color: playbookEngine.profitFactor > 1.5 ? .green : .orange,
                icon: "chart.line.uptrend.xyaxis"
            )
            
            PerformanceCard(
                title: "R-Multiple",
                value: String(format: "%.1fR", playbookEngine.averageRMultiple),
                change: "+0.3R",
                color: playbookEngine.averageRMultiple > 1.0 ? .green : .red,
                icon: "multiply.circle.fill"
            )
            
            PerformanceCard(
                title: "Grade A+",
                value: "\(playbookEngine.eliteTrades)",
                change: "+3",
                color: .purple,
                icon: "star.fill"
            )
        }
        .padding(.horizontal)
        .scaleEffect(animateOnAppear ? 1.0 : 0.9)
        .opacity(animateOnAppear ? 1.0 : 0.0)
        .animation(DesignSystem.springAnimation.delay(0.2), value: animateOnAppear)
    }
    
    // MARK: - Premium Tab Navigation
    
    private var premiumTabNavigation: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(PlaybookSection.allCases, id: \.self) { section in
                    Button(action: {
                        withAnimation(DesignSystem.springAnimation) {
                            selectedTab = section
                        }
                    }) {
                        VStack(spacing: 6) {
                            Image(systemName: section.icon)
                                .font(.system(size: 16, weight: .medium))
                            
                            Text(section.rawValue)
                                .font(.system(size: 10, weight: .bold))
                                .lineLimit(1)
                        }
                        .foregroundStyle(selectedTab == section ? DesignSystem.primaryGold : .white.opacity(0.6))
                        .frame(minWidth: 80)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: DesignSystem.cornerRadius)
                                .fill(selectedTab == section ? DesignSystem.primaryGold.opacity(0.2) : .clear)
                                .overlay(
                                    RoundedRectangle(cornerRadius: DesignSystem.cornerRadius)
                                        .stroke(selectedTab == section ? DesignSystem.primaryGold : .clear, lineWidth: 2)
                                )
                        )
                        .scaleEffect(selectedTab == section ? 1.05 : 1.0)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 8)
    }
    
    // MARK: - Tab Views
    
    private var liveTradesTab: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(filteredTrades) { trade in
                    LegendaryTradeCard(
                        trade: trade,
                        onTap: {
                            selectedTrade = trade
                            showingTradeDetail = true
                        }
                    )
                }
                
                if filteredTrades.isEmpty && !searchText.isEmpty {
                    EmptyStateView(
                        title: "No Matching Trades",
                        subtitle: "Try adjusting your search criteria",
                        action: { searchText = "" }
                    )
                } else if playbookEngine.trades.isEmpty {
                    EmptyStateView(
                        title: "No Trades Yet",
                        subtitle: "Start documenting your trading journey",
                        action: { showingTradeEntry = true }
                    )
                }
            }
            .padding()
        }
    }
    
    private var journalTab: some View {
        ScrollView {
            VStack(spacing: 20) {
                JournalStatsHeader(engine: playbookEngine)
                
                LazyVStack(spacing: 12) {
                    ForEach(playbookEngine.journalEntries) { entry in
                        JournalEntryCard(entry: entry)
                    }
                }
                
                if playbookEngine.journalEntries.isEmpty {
                    EmptyStateView(
                        title: "No Journal Entries",
                        subtitle: "Add a trade to generate your first entry",
                        action: { showingTradeEntry = true }
                    )
                }
            }
            .padding()
        }
    }
    
    private var gradesTab: some View {
        ScrollView {
            VStack(spacing: 20) {
                GradeDistributionChart(engine: playbookEngine)
                
                LazyVStack(spacing: 12) {
                    ForEach(TradeGrade.allCases.filter { $0 != .all }, id: \.self) { grade in
                        GradeBreakdownCard(
                            grade: grade,
                            trades: playbookEngine.trades.filter { $0.grade == grade }
                        )
                    }
                }
            }
            .padding()
        }
    }
    
    private var psychologyTab: some View {
        ScrollView {
            VStack(spacing: 20) {
                PsychologyDashboard(markDouglasEngine: markDouglasEngine)
                TradingPsychologyInsights(
                    trades: playbookEngine.trades,
                    markDouglasEngine: markDouglasEngine
                )
            }
            .padding()
        }
    }
    
    private var statisticsTab: some View {
        ScrollView {
            VStack(spacing: 20) {
                ComprehensiveStats(engine: playbookEngine)
                AdvancedAnalytics(engine: playbookEngine)
            }
            .padding()
        }
    }
    
    // MARK: - Computed Properties
    
    private var filteredTrades: [PlaybookTrade] {
        var trades = playbookEngine.trades
        
        if !searchText.isEmpty {
            trades = trades.filter { trade in
                trade.symbol.localizedCaseInsensitiveContains(searchText) ||
                trade.setupDescription.localizedCaseInsensitiveContains(searchText) ||
                trade.emotionalState.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return trades.sorted { $0.timestamp > $1.timestamp }
    }
    
    // MARK: - Helper Methods
    
    private func handlePhotoSelection(_ photos: [PhotosPickerItem]) {
        guard !photos.isEmpty else { return }
        
        Task {
            do {
                for photo in photos {
                    if let data = try await photo.loadTransferable(type: Data.self) {
                        print("Screenshot uploaded: \(data.count) bytes")
                        // Process screenshot and add to current trade
                    }
                }
            } catch {
                playbookEngine.errorMessage = "Failed to load photos: \(error.localizedDescription)"
            }
        }
        selectedPhotos.removeAll()
    }
}

// MARK: - Supporting Views

struct StatusBadge: View {
    let title: String
    let status: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.system(size: 8, weight: .bold))
                .foregroundColor(.white.opacity(0.6))
                .tracking(1)
            
            Text(status)
                .font(.system(size: 10, weight: .black))
                .foregroundColor(color)
        }
    }
}

struct PerformanceCard: View {
    let title: String
    let value: String
    let change: String
    let color: Color
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(color)
            
            Text(value)
                .font(.system(size: 16, weight: .black, design: .monospaced))
                .foregroundColor(.white)
            
            Text(change)
                .font(.system(size: 10, weight: .semibold))
                .foregroundColor(.green)
            
            Text(title)
                .font(.system(size: 8, weight: .medium))
                .foregroundColor(.white.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: DesignSystem.cornerRadius)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: DesignSystem.cornerRadius)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

struct LegendaryTradeCard: View {
    let trade: PlaybookTrade
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 12) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(trade.symbol)
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text(trade.direction.rawValue)
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.black)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 2)
                                .background(
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(trade.direction.color)
                                )
                        }
                        
                        Text(trade.setupDescription)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white.opacity(0.8))
                            .lineLimit(2)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text(trade.grade.rawValue)
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(trade.grade.color)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(trade.grade.color.opacity(0.2))
                            )
                        
                        Text("\(String(format: "%.1fR", trade.rMultiple))")
                            .font(.system(size: 14, weight: .black, design: .monospaced))
                            .foregroundColor(trade.rMultiple > 0 ? .green : .red)
                    }
                }
                
                // Performance metrics
                HStack(spacing: 20) {
                    MetricView(
                        title: "P&L",
                        value: "$\(String(format: "%.2f", trade.pnl))",
                        color: trade.pnl > 0 ? .green : .red
                    )
                    
                    MetricView(
                        title: "Entry",
                        value: String(format: "%.2f", trade.entryPrice),
                        color: .blue
                    )
                    
                    MetricView(
                        title: "Exit",
                        value: trade.exitPrice != nil ? String(format: "%.2f", trade.exitPrice!) : "Running",
                        color: trade.result.color
                    )
                    
                    MetricView(
                        title: "Emotion",
                        value: "\(trade.emotionalRating)/5",
                        color: .purple
                    )
                }
                
                // Timestamp
                HStack {
                    Spacer()
                    Text(timeAgo(trade.timestamp))
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.white.opacity(0.5))
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(trade.grade.color.opacity(0.3), lineWidth: 2)
                    )
            )
        }
        .buttonStyle(.plain)
    }
    
    private func timeAgo(_ date: Date) -> String {
        let interval = Date().timeIntervalSince(date)
        
        switch interval {
        case ..<60:
            return "Now"
        case 60..<3600:
            return "\(Int(interval / 60))m ago"
        case 3600..<86400:
            return "\(Int(interval / 3600))h ago"
        default:
            let days = Int(interval / 86400)
            return "\(days)d ago"
        }
    }
}

struct MetricView: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 2) {
            Text(title)
                .font(.system(size: 8, weight: .medium))
                .foregroundColor(.white.opacity(0.6))
            
            Text(value)
                .font(.system(size: 12, weight: .bold, design: .monospaced))
                .foregroundColor(color)
        }
    }
}

struct EmptyStateView: View {
    let title: String
    let subtitle: String
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "book.fill")
                .font(.system(size: 48))
                .foregroundColor(.white.opacity(0.3))
            
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text(subtitle)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
            
            Button("Start Trading") {
                action()
            }
            .foregroundColor(.black)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(DesignSystem.primaryGold)
            )
            .buttonStyle(.plain)
        }
        .padding(.top, 50)
    }
}

// MARK: - Sheet Views

struct TradeEntrySheet: View {
    let engine: LegendaryPlaybookEngine
    @Environment(\.dismiss) private var dismiss
    
    // Form state
    @State private var symbol = "XAUUSD"
    @State private var direction: TradeDirection = .buy
    @State private var entryPrice = ""
    @State private var stopLoss = ""
    @State private var takeProfit = ""
    @State private var lotSize = ""
    @State private var setupDescription = ""
    @State private var emotionalState = ""
    @State private var emotionalRating = 3
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Trade Details") {
                    TextField("Symbol", text: $symbol)
                    
                    Picker("Direction", selection: $direction) {
                        ForEach(TradeDirection.allCases, id: \.self) { direction in
                            Text(direction.rawValue).tag(direction)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    TextField("Entry Price", text: $entryPrice)
                        .keyboardType(.decimalPad)
                    
                    TextField("Stop Loss", text: $stopLoss)
                        .keyboardType(.decimalPad)
                    
                    TextField("Take Profit", text: $takeProfit)
                        .keyboardType(.decimalPad)
                    
                    TextField("Lot Size", text: $lotSize)
                        .keyboardType(.decimalPad)
                }
                
                Section("Analysis") {
                    TextField("Setup Description", text: $setupDescription, axis: .vertical)
                        .lineLimit(3...6)
                    
                    TextField("Emotional State", text: $emotionalState)
                    
                    Stepper("Emotional Rating: \(emotionalRating)/5", value: $emotionalRating, in: 1...5)
                }
            }
            .navigationTitle("New Trade")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveTrade()
                    }
                    .disabled(!isFormValid)
                }
            }
        }
    }
    
    private var isFormValid: Bool {
        !symbol.isEmpty && 
        !entryPrice.isEmpty && 
        !stopLoss.isEmpty && 
        !takeProfit.isEmpty && 
        !lotSize.isEmpty &&
        !setupDescription.isEmpty
    }
    
    private func saveTrade() {
        guard let entryPriceValue = Double(entryPrice),
              let stopLossValue = Double(stopLoss),
              let takeProfitValue = Double(takeProfit),
              let lotSizeValue = Double(lotSize) else {
            return
        }
        
        let trade = PlaybookTrade(
            id: UUID().uuidString,
            symbol: symbol.uppercased(),
            direction: direction,
            entryPrice: entryPriceValue,
            stopLoss: stopLossValue,
            takeProfit: takeProfitValue,
            lotSize: lotSizeValue,
            pnl: 0,
            rMultiple: 0,
            result: .running,
            grade: .average,
            setupDescription: setupDescription,
            emotionalState: emotionalState.isEmpty ? "Neutral" : emotionalState,
            timestamp: Date(),
            emotionalRating: emotionalRating
        )
        
        engine.addTrade(trade)
        dismiss()
    }
}

struct TradeDetailSheet: View {
    let trade: PlaybookTrade
    let engine: LegendaryPlaybookEngine
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Trade Header
                    VStack(spacing: 8) {
                        HStack {
                            Text(trade.symbol)
                                .font(.system(size: 32, weight: .black))
                                .foregroundColor(.white)
                            
                            Text(trade.direction.rawValue)
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.black)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(trade.direction.color)
                                )
                        }
                        
                        Text(trade.grade.rawValue)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(trade.grade.color)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(trade.grade.color.opacity(0.2))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(trade.grade.color, lineWidth: 1)
                                    )
                            )
                    }
                    .padding()
                    
                    // Performance Summary
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                        DetailMetricCard(title: "P&L", value: "$\(String(format: "%.2f", trade.pnl))", color: trade.pnl > 0 ? .green : .red)
                        DetailMetricCard(title: "R-Multiple", value: "\(String(format: "%.1fR", trade.rMultiple))", color: trade.rMultiple > 0 ? .green : .red)
                        DetailMetricCard(title: "Entry Price", value: String(format: "%.2f", trade.entryPrice), color: .blue)
                        DetailMetricCard(title: "Exit Price", value: trade.exitPrice != nil ? String(format: "%.2f", trade.exitPrice!) : "Running", color: trade.result.color)
                        DetailMetricCard(title: "Stop Loss", value: String(format: "%.2f", trade.stopLoss), color: .red)
                        DetailMetricCard(title: "Take Profit", value: String(format: "%.2f", trade.takeProfit), color: .green)
                    }
                    .padding(.horizontal)
                    
                    // Trade Analysis
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Setup Analysis")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text(trade.setupDescription)
                            .font(.body)
                            .foregroundColor(.white.opacity(0.8))
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(.ultraThinMaterial)
                            )
                        
                        HStack {
                            Text("Emotional State:")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Text(trade.emotionalState)
                                .font(.body)
                                .foregroundColor(.blue)
                        }
                        
                        HStack {
                            Text("Emotional Rating:")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            HStack(spacing: 4) {
                                ForEach(1...5, id: \.self) { rating in
                                    Image(systemName: rating <= trade.emotionalRating ? "star.fill" : "star")
                                        .foregroundColor(rating <= trade.emotionalRating ? .yellow : .gray)
                                }
                            }
                        }
                    }
                    .padding()
                    
                    Spacer()
                }
            }
            .background(Color.black.ignoresSafeArea())
            .navigationTitle("Trade Analysis")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(DesignSystem.primaryGold)
                }
            }
        }
    }
}

struct DetailMetricCard: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
            
            Text(value)
                .font(.system(size: 18, weight: .bold, design: .monospaced))
                .foregroundColor(color)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

// MARK: - Placeholder Supporting Views

struct JournalStatsHeader: View {
    let engine: LegendaryPlaybookEngine
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Journal Statistics")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            HStack(spacing: 20) {
                VStack {
                    Text("\(engine.journalEntries.count)")
                        .font(.system(size: 24, weight: .black))
                        .foregroundColor(DesignSystem.primaryGold)
                    Text("Entries")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }
                
                VStack {
                    Text("\(Int(engine.winRate * 100))%")
                        .font(.system(size: 24, weight: .black))
                        .foregroundColor(.green)
                    Text("Win Rate")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }
                
                VStack {
                    Text("\(engine.eliteTrades)")
                        .font(.system(size: 24, weight: .black))
                        .foregroundColor(.purple)
                    Text("Elite Trades")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
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

struct JournalEntryCard: View {
    let entry: JournalEntry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: entry.type.icon)
                    .font(.title2)
                    .foregroundColor(DesignSystem.primaryGold)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(entry.title)
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text(entry.type.rawValue)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.6))
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    HStack(spacing: 2) {
                        ForEach(1...5, id: \.self) { rating in
                            Image(systemName: rating <= entry.emotionalRating ? "star.fill" : "star")
                                .font(.caption)
                                .foregroundColor(rating <= entry.emotionalRating ? .yellow : .gray)
                        }
                    }
                    
                    Text(entry.timestamp, style: .time)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.5))
                }
            }
            
            Text(entry.content)
                .font(.body)
                .foregroundColor(.white.opacity(0.8))
                .lineLimit(4)
            
            if !entry.markDouglasLesson.isEmpty {
                HStack {
                    Image(systemName: "brain.head.profile")
                        .foregroundColor(.purple)
                    
                    Text("Mark Douglas: \(entry.markDouglasLesson)")
                        .font(.caption)
                        .foregroundColor(.purple.opacity(0.8))
                        .italic()
                }
                .padding(.top, 4)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(DesignSystem.primaryGold.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

struct GradeDistributionChart: View {
    let engine: LegendaryPlaybookEngine
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Grade Distribution")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            HStack(spacing: 8) {
                ForEach(TradeGrade.allCases.filter { $0 != .all }, id: \.self) { grade in
                    let count = engine.trades.filter { $0.grade == grade }.count
                    let percentage = engine.trades.isEmpty ? 0 : Double(count) / Double(engine.trades.count)
                    
                    VStack(spacing: 8) {
                        Rectangle()
                            .fill(grade.color)
                            .frame(width: 40, height: max(20, percentage * 100))
                            .cornerRadius(4)
                        
                        Text(grade.rawValue.components(separatedBy: " ").first ?? "")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                        
                        Text("\(count)")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(grade.color)
                    }
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

struct GradeBreakdownCard: View {
    let grade: TradeGrade
    let trades: [PlaybookTrade]
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(grade.rawValue)
                    .font(.headline)
                    .foregroundColor(grade.color)
                
                Text(grade.description)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
                    .lineLimit(2)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(trades.count)")
                    .font(.system(size: 24, weight: .black))
                    .foregroundColor(grade.color)
                
                Text("trades")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.6))
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(grade.color.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

struct PsychologyDashboard: View {
    let markDouglasEngine: PlanetMarkDouglasEngine
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Psychology Dashboard")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                PsychologyMetricCard(
                    title: "Probabilistic Thinking",
                    value: markDouglasEngine.probabilisticThinking,
                    color: .blue
                )
                
                PsychologyMetricCard(
                    title: "Discipline Score",
                    value: markDouglasEngine.disciplineScore,
                    color: .purple
                )
                
                PsychologyMetricCard(
                    title: "Consistency",
                    value: markDouglasEngine.consistencyLevel,
                    color: .green
                )
                
                PsychologyMetricCard(
                    title: "Risk Acceptance",
                    value: markDouglasEngine.riskAcceptance,
                    color: .orange
                )
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Mark Douglas Insight")
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text(markDouglasEngine.getMarkDouglasInsight())
                    .font(.body)
                    .foregroundColor(.white.opacity(0.8))
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.ultraThinMaterial)
                    )
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
        )
    }
}

struct PsychologyMetricCard: View {
    let title: String
    let value: Double
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
            
            Text("\(Int(value * 100))%")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(color)
            
            ProgressView(value: value)
                .progressViewStyle(LinearProgressViewStyle(tint: color))
                .scaleEffect(y: 2)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
        )
    }
}

struct TradingPsychologyInsights: View {
    let trades: [PlaybookTrade]
    let markDouglasEngine: PlanetMarkDouglasEngine
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Trading Psychology Insights")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Current Emotional State")
                    .font(.headline)
                    .foregroundColor(.white)
                
                HStack {
                    Circle()
                        .fill(markDouglasEngine.currentEmotionalState.color)
                        .frame(width: 12, height: 12)
                    
                    Text(markDouglasEngine.currentEmotionalState.rawValue)
                        .font(.body)
                        .foregroundColor(markDouglasEngine.currentEmotionalState.color)
                    
                    Spacer()
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.ultraThinMaterial)
                )
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Mark Douglas Fundamental")
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text(markDouglasEngine.getFundamental())
                    .font(.body)
                    .foregroundColor(.white.opacity(0.8))
                    .italic()
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.ultraThinMaterial)
                    )
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
        )
    }
}

struct ComprehensiveStats: View {
    let engine: LegendaryPlaybookEngine
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Comprehensive Statistics")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                StatCard(title: "Total Trades", value: "\(engine.trades.count)", color: .blue)
                StatCard(title: "Win Rate", value: "\(Int(engine.winRate * 100))%", color: .green)
                StatCard(title: "Profit Factor", value: String(format: "%.2f", engine.profitFactor), color: .purple)
                StatCard(title: "Avg R-Multiple", value: String(format: "%.2fR", engine.averageRMultiple), color: .orange)
            }
            
            // Additional stats can be added here
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
        )
    }
}

struct AdvancedAnalytics: View {
    let engine: LegendaryPlaybookEngine
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Advanced Analytics")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text("Detailed analytics dashboard coming soon...")
                .font(.body)
                .foregroundColor(.white.opacity(0.7))
                .padding()
            
            // Placeholder for advanced charts and analytics
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
        )
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
            
            Text(value)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(color)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

#Preview {
    PlaybookView()
        .preferredColorScheme(.dark)
}