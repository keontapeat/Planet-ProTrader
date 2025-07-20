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
                
                VStack(spacing: 0) {
                    // LEGENDARY Header
                    legendaryPlaybookHeader
                    
                    // Performance Dashboard
                    performanceDashboard
                    
                    // Premium Tab Navigation
                    premiumTabNavigation
                    
                    // Main Content
                    TabView(selection: $selectedTab) {
                        // Live Trades Tab
                        liveTradesTab
                            .tag(PlaybookSection.live)
                        
                        // Journal Tab
                        journalTab
                            .tag(PlaybookSection.journal)
                        
                        // Grades Tab
                        gradesTab
                            .tag(PlaybookSection.grades)
                        
                        // Psychology Tab
                        psychologyTab
                            .tag(PlaybookSection.psychology)
                        
                        // Statistics Tab
                        statisticsTab
                            .tag(PlaybookSection.statistics)
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
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
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1)) {
                    animateOnAppear = true
                }
            }
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
                        .font(.system(size: 28, weight: .black, design: .rounded))
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
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2), value: animateOnAppear)
    }
    
    // MARK: - Premium Tab Navigation
    
    private var premiumTabNavigation: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(PlaybookSection.allCases, id: \.self) { section in
                    Button(action: {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
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
                            RoundedRectangle(cornerRadius: 12)
                                .fill(selectedTab == section ? DesignSystem.primaryGold.opacity(0.2) : .clear)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(selectedTab == section ? DesignSystem.primaryGold : .clear, lineWidth: 2)
                                )
                        )
                        .scaleEffect(selectedTab == section ? 1.05 : 1.0)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 8)
    }
    
    // MARK: - Live Trades Tab
    
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
                
                if filteredTrades.isEmpty {
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
    
    // MARK: - Journal Tab
    
    private var journalTab: some View {
        ScrollView {
            VStack(spacing: 20) {
                JournalStatsHeader(engine: playbookEngine)
                
                LazyVStack(spacing: 12) {
                    ForEach(playbookEngine.journalEntries) { entry in
                        JournalEntryCard(entry: entry)
                    }
                }
            }
            .padding()
        }
    }
    
    // MARK: - Grades Tab
    
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
    
    // MARK: - Psychology Tab
    
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
    
    // MARK: - Statistics Tab
    
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
                trade.symbol.lowercased().contains(searchText.lowercased()) ||
                trade.setupDescription.lowercased().contains(searchText.lowercased()) ||
                trade.emotionalState.lowercased().contains(searchText.lowercased())
            }
        }
        
        return trades.sorted { $0.timestamp > $1.timestamp }
    }
    
    // MARK: - Helper Methods
    
    private func handlePhotoSelection(_ photos: [PhotosPickerItem]) {
        // Handle screenshot uploads
        Task {
            for photo in photos {
                if let data = try? await photo.loadTransferable(type: Data.self) {
                    // Process screenshot and add to current trade
                    print("Screenshot uploaded: \(data.count) bytes")
                }
            }
        }
        selectedPhotos.removeAll()
    }
}

// MARK: - Legendary Playbook Engine

@MainActor
class LegendaryPlaybookEngine: ObservableObject {
    @Published var trades: [PlaybookTrade] = []
    @Published var journalEntries: [JournalEntry] = []
    @Published var isAutoLogging = true
    
    init() {
        loadSampleData()
    }
    
    // MARK: - Computed Statistics
    
    var winRate: Double {
        let wins = trades.filter { $0.result == .win }.count
        return trades.isEmpty ? 0.0 : Double(wins) / Double(trades.count)
    }
    
    var profitFactor: Double {
        let grossProfit = trades.filter { $0.result == .win }.reduce(0) { $0 + $1.pnl }
        let grossLoss = abs(trades.filter { $0.result == .loss }.reduce(0) { $0 + $1.pnl })
        return grossLoss == 0 ? 0 : grossProfit / grossLoss
    }
    
    var averageRMultiple: Double {
        return trades.isEmpty ? 0.0 : trades.reduce(0) { $0 + $1.rMultiple } / Double(trades.count)
    }
    
    var eliteTrades: Int {
        return trades.filter { $0.grade == .elite }.count
    }
    
    // MARK: - Trade Management
    
    func addTrade(_ trade: PlaybookTrade) {
        trades.append(trade)
        
        // Auto-generate journal entry
        if isAutoLogging {
            generateJournalEntry(for: trade)
        }
    }
    
    private func generateJournalEntry(for trade: PlaybookTrade) {
        let entry = JournalEntry(
            id: UUID().uuidString,
            timestamp: trade.timestamp,
            type: .tradeAnalysis,
            title: "Auto-Generated: \(trade.symbol) Trade",
            content: generateAutoAnalysis(for: trade),
            emotionalRating: trade.emotionalRating,
            markDouglasLesson: generateMarkDouglasLesson(for: trade)
        )
        journalEntries.append(entry)
    }
    
    private func generateAutoAnalysis(for trade: PlaybookTrade) -> String {
        let outcome = trade.result == .win ? "successful" : "unsuccessful"
        return """
        Trade Analysis - \(trade.symbol):
        
        Setup: \(trade.setupDescription)
        Entry: \(String(format: "%.2f", trade.entryPrice))
        Exit: \(String(format: "%.2f", trade.exitPrice ?? 0))
        Result: \(outcome) (\(String(format: "%.1fR", trade.rMultiple)))
        
        What went right: \(trade.result == .win ? "Proper execution of setup" : "Followed risk management rules")
        What could improve: \(generateImprovementSuggestion(for: trade))
        
        Emotional state: \(trade.emotionalState)
        Grade: \(trade.grade.rawValue)
        """
    }
    
    private func generateMarkDouglasLesson(for trade: PlaybookTrade) -> String {
        let lessons = [
            "Every trade outcome is independent - this doesn't predict the next trade",
            "Focus on executing your process, not the outcome",
            "Maintain emotional equilibrium regardless of results",
            "Think in probabilities, not certainties",
            "Trust your edge and execute consistently"
        ]
        return lessons.randomElement()!
    }
    
    private func generateImprovementSuggestion(for trade: PlaybookTrade) -> String {
        switch trade.grade {
        case .elite:
            return "Perfect execution - maintain this standard"
        case .good:
            return "Good trade - minor timing improvements possible"
        case .average:
            return "Consider better entry timing and risk management"
        case .poor:
            return "Review setup criteria and emotional state before entry"
        case .all:
            return "Continue learning and developing skills"
        }
    }
    
    private func loadSampleData() {
        trades = [
            PlaybookTrade(
                id: UUID().uuidString,
                symbol: "XAUUSD",
                direction: .buy,
                entryPrice: 2674.50,
                exitPrice: 2682.25,
                stopLoss: 2668.00,
                takeProfit: 2690.00,
                lotSize: 0.01,
                pnl: 77.50,
                rMultiple: 1.2,
                result: .win,
                grade: .elite,
                setupDescription: "Perfect institutional order flow confluence at London open",
                emotionalState: "Calm and confident",
                timestamp: Date().addingTimeInterval(-3600),
                beforeScreenshot: nil,
                duringScreenshot: nil,
                afterScreenshot: nil,
                emotionalRating: 5
            ),
            PlaybookTrade(
                id: UUID().uuidString,
                symbol: "XAUUSD",
                direction: .sell,
                entryPrice: 2680.00,
                exitPrice: 2675.50,
                stopLoss: 2685.00,
                takeProfit: 2670.00,
                lotSize: 0.01,
                pnl: 45.00,
                rMultiple: 0.9,
                result: .win,
                grade: .good,
                setupDescription: "Clean resistance rejection with volume confirmation",
                emotionalState: "Patient and disciplined",
                timestamp: Date().addingTimeInterval(-7200),
                beforeScreenshot: nil,
                duringScreenshot: nil,
                afterScreenshot: nil,
                emotionalRating: 4
            )
        ]
        
        journalEntries = [
            JournalEntry(
                id: UUID().uuidString,
                timestamp: Date(),
                type: .dailyReview,
                title: "Daily Review - Excellent Progress",
                content: "Today I executed two high-quality setups with perfect discipline. The Mark Douglas principles are becoming second nature.",
                emotionalRating: 5,
                markDouglasLesson: "Consistency comes from within, not from the markets"
            )
        ]
    }
}

// MARK: - Data Models

struct PlaybookTrade: Identifiable {
    let id: String
    let symbol: String
    let direction: SharedTypes.TradeDirection
    let entryPrice: Double
    var exitPrice: Double?
    let stopLoss: Double
    let takeProfit: Double
    let lotSize: Double
    var pnl: Double
    var rMultiple: Double
    var result: TradeResult
    var grade: TradeGrade
    let setupDescription: String
    let emotionalState: String
    let timestamp: Date
    var beforeScreenshot: UIImage?
    var duringScreenshot: UIImage?
    var afterScreenshot: UIImage?
    let emotionalRating: Int // 1-5 scale
    
    enum TradeResult: String, CaseIterable {
        case win = "WIN"
        case loss = "LOSS"
        case breakeven = "BREAKEVEN"
        case running = "RUNNING"
        
        var color: Color {
            switch self {
            case .win: return .green
            case .loss: return .red
            case .breakeven: return .orange
            case .running: return .blue
            }
        }
    }
}

enum TradeGrade: String, CaseIterable {
    case all = "ALL"
    case elite = "A+ ELITE"
    case good = "A GOOD"
    case average = "B AVERAGE"
    case poor = "C POOR"
    
    var color: Color {
        switch self {
        case .all: return .gray
        case .elite: return .purple
        case .good: return .green
        case .average: return .orange
        case .poor: return .red
        }
    }
    
    var description: String {
        switch self {
        case .all: return "All trades"
        case .elite: return "Perfect execution, Mark Douglas would be proud"
        case .good: return "Solid trade with minor improvements possible"
        case .average: return "Acceptable but needs refinement"
        case .poor: return "Learning opportunity, review psychology"
        }
    }
}

struct JournalEntry: Identifiable {
    let id: String
    let timestamp: Date
    let type: EntryType
    let title: String
    let content: String
    let emotionalRating: Int
    let markDouglasLesson: String
    
    enum EntryType: String, CaseIterable {
        case tradeAnalysis = "TRADE ANALYSIS"
        case dailyReview = "DAILY REVIEW"
        case psychologyNote = "PSYCHOLOGY NOTE"
        case marketObservation = "MARKET OBSERVATION"
        case improvement = "IMPROVEMENT PLAN"
        
        var icon: String {
            switch self {
            case .tradeAnalysis: return "chart.line.uptrend.xyaxis"
            case .dailyReview: return "calendar"
            case .psychologyNote: return "brain.head.profile"
            case .marketObservation: return "eye"
            case .improvement: return "arrow.up.circle"
            }
        }
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
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
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
                
                // Screenshot indicators
                HStack {
                    Text("Screenshots:")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.white.opacity(0.6))
                    
                    HStack(spacing: 4) {
                        ScreenshotIndicator(hasScreenshot: trade.beforeScreenshot != nil, label: "Before")
                        ScreenshotIndicator(hasScreenshot: trade.duringScreenshot != nil, label: "During")
                        ScreenshotIndicator(hasScreenshot: trade.afterScreenshot != nil, label: "After")
                    }
                    
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
        .buttonStyle(PlainButtonStyle())
    }
    
    private func timeAgo(_ date: Date) -> String {
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

struct ScreenshotIndicator: View {
    let hasScreenshot: Bool
    let label: String
    
    var body: some View {
        HStack(spacing: 2) {
            Circle()
                .fill(hasScreenshot ? .green : .red)
                .frame(width: 6, height: 6)
            
            Text(label)
                .font(.system(size: 8, weight: .medium))
                .foregroundColor(.white.opacity(0.6))
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
        }
        .padding(.top, 50)
    }
}

struct TradeEntrySheet: View {
    let engine: LegendaryPlaybookEngine
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Quick Trade Entry")
                        .font(.title)
                        .padding()
                    
                    Text("Advanced trade entry form coming soon...")
                        .foregroundColor(.secondary)
                    
                    Spacer()
                }
            }
            .navigationTitle("New Trade")
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

struct TradeDetailSheet: View {
    let trade: PlaybookTrade
    let engine: LegendaryPlaybookEngine
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Trade Details")
                        .font(.title)
                        .padding()
                    
                    Text("Comprehensive trade analysis coming soon...")
                        .foregroundColor(.secondary)
                    
                    Spacer()
                }
            }
            .navigationTitle("Trade Analysis")
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

// MARK: - Additional Supporting Views (Placeholders for now)

struct JournalStatsHeader: View {
    let engine: LegendaryPlaybookEngine
    
    var body: some View {
        Text("Journal Statistics")
            .font(.headline)
            .padding()
    }
}

struct JournalEntryCard: View {
    let entry: JournalEntry
    
    var body: some View {
        VStack {
            Text(entry.title)
                .font(.headline)
            Text(entry.content)
                .font(.body)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
        )
    }
}

struct GradeDistributionChart: View {
    let engine: LegendaryPlaybookEngine
    
    var body: some View {
        Text("Grade Distribution Chart")
            .font(.headline)
            .padding()
    }
}

struct GradeBreakdownCard: View {
    let grade: TradeGrade
    let trades: [PlaybookTrade]
    
    var body: some View {
        VStack {
            Text(grade.rawValue)
                .font(.headline)
                .foregroundColor(grade.color)
            Text("\(trades.count) trades")
                .font(.body)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
        )
    }
}

struct PsychologyDashboard: View {
    let markDouglasEngine: PlanetMarkDouglasEngine
    
    var body: some View {
        Text("Psychology Dashboard")
            .font(.headline)
            .padding()
    }
}

struct TradingPsychologyInsights: View {
    let trades: [PlaybookTrade]
    let markDouglasEngine: PlanetMarkDouglasEngine
    
    var body: some View {
        Text("Psychology Insights")
            .font(.headline)
            .padding()
    }
}

struct ComprehensiveStats: View {
    let engine: LegendaryPlaybookEngine
    
    var body: some View {
        Text("Comprehensive Statistics")
            .font(.headline)
            .padding()
    }
}

struct AdvancedAnalytics: View {
    let engine: LegendaryPlaybookEngine
    
    var body: some View {
        Text("Advanced Analytics")
            .font(.headline)
            .padding()
    }
}

#Preview {
    PlaybookView()
}