//
//  MarketNewsView.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 1/21/25.
//

import SwiftUI

struct MarketNewsView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var newsManager = MarketNewsManager.shared
    @State private var selectedCategory: NewsCategory = .all
    @State private var showingFilters = false
    @State private var selectedArticle: NewsArticle?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header with live updates
                headerSection
                
                // News categories
                categorySelector
                
                // News feed
                ScrollView {
                    LazyVStack(spacing: 16) {
                        if newsManager.isLoading {
                            loadingView
                        } else {
                            ForEach(filteredNews) { article in
                                newsCard(article: article)
                                    .onTapGesture {
                                        selectedArticle = article
                                    }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                }
                .refreshable {
                    await newsManager.refreshNews()
                }
            }
            .background(Color(.systemBackground))
            .navigationTitle("📰 Market News")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: { showingFilters = true }) {
                        Image(systemName: "slider.horizontal.3")
                            .foregroundColor(.orange)
                    }
                    
                    Button("Done") {
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .foregroundColor(.orange)
                }
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
        .sheet(isPresented: $showingFilters) {
            NewsFiltersView(newsManager: newsManager)
        }
        .sheet(item: $selectedArticle) { article in
            NewsDetailView(article: article)
        }
        .onAppear {
            Task {
                await newsManager.loadNews()
            }
        }
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Live Market Updates")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    HStack(spacing: 8) {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 8, height: 8)
                            .scaleEffect(newsManager.isLive ? 1.0 : 0.5)
                            .animation(.easeInOut(duration: 1.0).repeatForever(), value: newsManager.isLive)
                        
                        Text(newsManager.isLive ? "Live Updates" : "Offline")
                            .font(.caption)
                            .foregroundColor(newsManager.isLive ? .green : .secondary)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("\(newsManager.totalNews)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.orange)
                    
                    Text("articles")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            // Market Impact Summary
            marketImpactSummary
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .padding(.bottom, 16)
        .background(Color(.systemGray6).opacity(0.5))
    }
    
    private var marketImpactSummary: some View {
        HStack(spacing: 16) {
            impactIndicator(
                title: "High Impact",
                count: newsManager.highImpactCount,
                color: .red,
                icon: "exclamationmark.triangle.fill"
            )
            
            impactIndicator(
                title: "Medium Impact",
                count: newsManager.mediumImpactCount,
                color: .orange,
                icon: "exclamationmark.circle.fill"
            )
            
            impactIndicator(
                title: "Low Impact",
                count: newsManager.lowImpactCount,
                color: .green,
                icon: "info.circle.fill"
            )
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
    
    private func impactIndicator(title: String, count: Int, color: Color, icon: String) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
            
            Text("\(count)")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Category Selector
    
    private var categorySelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(NewsCategory.allCases, id: \.self) { category in
                    categoryButton(category: category)
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 12)
        .background(Color(.systemGray6).opacity(0.3))
    }
    
    private func categoryButton(category: NewsCategory) -> some View {
        Button(action: {
            withAnimation(.spring()) {
                selectedCategory = category
            }
        }) {
            HStack(spacing: 6) {
                Image(systemName: category.icon)
                    .font(.caption)
                
                Text(category.displayName)
                    .font(.caption)
                    .fontWeight(.medium)
                
                if category != .all {
                    Text("\(newsManager.getNewsCount(for: category))")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color(.systemGray5))
                        .cornerRadius(4)
                }
            }
            .foregroundColor(selectedCategory == category ? .white : .primary)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                selectedCategory == category 
                ? Color.orange
                : Color(.systemBackground)
            )
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(
                        selectedCategory == category 
                        ? Color.orange
                        : Color(.systemGray4), 
                        lineWidth: 1
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // MARK: - News Cards
    
    private var filteredNews: [NewsArticle] {
        newsManager.getFilteredNews(category: selectedCategory)
    }
    
    private func newsCard(article: NewsArticle) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header with impact and time
            HStack {
                impactBadge(impact: article.impact)
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text(article.source)
                        .font(.caption2)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                    
                    Text(article.timeAgo)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            
            // Title
            Text(article.title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
                .lineLimit(3)
            
            // Summary
            if let summary = article.summary {
                Text(summary)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            // Footer with currencies and sentiment
            HStack {
                // Affected currencies
                HStack(spacing: 4) {
                    ForEach(Array(article.affectedCurrencies.prefix(3)), id: \.self) { currency in
                        Text(currency)
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(currencyColor(currency))
                            .cornerRadius(4)
                    }
                    
                    if article.affectedCurrencies.count > 3 {
                        Text("+\(article.affectedCurrencies.count - 3)")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                // Sentiment indicator
                sentimentIndicator(sentiment: article.sentiment)
            }
        }
        .padding(16)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(article.impact.color.opacity(0.3), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
    
    private func impactBadge(impact: NewsImpactLevel) -> some View {
        HStack(spacing: 4) {
            Image(systemName: impact.emoji)
                .font(.caption2)
            
            Text(impact.rawValue)
                .font(.caption2)
                .fontWeight(.bold)
        }
        .foregroundColor(.white)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(impact.color)
        .cornerRadius(6)
    }
    
    private func sentimentIndicator(sentiment: NewsSentiment) -> some View {
        HStack(spacing: 4) {
            Image(systemName: sentiment.icon)
                .font(.caption2)
            
            Text(sentiment.displayName)
                .font(.caption2)
                .fontWeight(.medium)
        }
        .foregroundColor(sentiment.color)
        .padding(.horizontal, 6)
        .padding(.vertical, 2)
        .background(sentiment.color.opacity(0.1))
        .cornerRadius(4)
    }
    
    private func currencyColor(_ currency: String) -> Color {
        switch currency {
        case "USD": return .blue
        case "EUR": return .purple
        case "GBP": return .green
        case "JPY": return .red
        case "CHF": return .orange
        case "CAD": return .pink
        case "AUD": return .cyan
        case "NZD": return .mint
        default: return .gray
        }
    }
    
    // MARK: - Loading View
    
    private var loadingView: some View {
        VStack(spacing: 16) {
            ForEach(0..<5) { _ in
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color(.systemGray5))
                            .frame(width: 80, height: 20)
                        
                        Spacer()
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color(.systemGray5))
                            .frame(width: 60, height: 16)
                    }
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(.systemGray5))
                        .frame(height: 20)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(.systemGray5))
                        .frame(height: 16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack {
                        ForEach(0..<3) { _ in
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color(.systemGray5))
                                .frame(width: 30, height: 16)
                        }
                        
                        Spacer()
                    }
                }
                .padding(16)
                .background(Color(.systemBackground))
                .cornerRadius(12)
            }
        }
        .redacted(reason: .placeholder)
        .shimmering()
    }
}

// MARK: - Market News Manager

class MarketNewsManager: ObservableObject {
    static let shared = MarketNewsManager()
    
    @Published var news: [NewsArticle] = []
    @Published var isLoading: Bool = false
    @Published var isLive: Bool = true
    
    // Filter properties
    @Published var activeFilters: NewsFilters = NewsFilters()
    
    private init() {
        // Start with sample data
        loadSampleNews()
    }
    
    var totalNews: Int { news.count }
    var highImpactCount: Int { news.filter { $0.impact == .high }.count }
    var mediumImpactCount: Int { news.filter { $0.impact == .medium }.count }
    var lowImpactCount: Int { news.filter { $0.impact == .low }.count }
    
    func loadNews() async {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        // Simulate API call
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        DispatchQueue.main.async {
            self.loadSampleNews()
            self.isLoading = false
        }
    }
    
    func refreshNews() async {
        await loadNews()
    }
    
    func updateFilters(
        impacts: Set<NewsImpactLevel>,
        sentiments: Set<NewsSentiment>,
        currencies: Set<String>,
        sources: Set<String>,
        timeFilter: NewsTimeFilterConsolidated
    ) {
        activeFilters = NewsFilters(
            impacts: impacts,
            sentiments: sentiments,
            currencies: currencies,
            sources: sources,
            timeFilter: timeFilter
        )
    }
    
    func getFilteredNews(category: NewsCategory) -> [NewsArticle] {
        var filteredNews = news
        
        // Filter by category
        if category != .all {
            filteredNews = filteredNews.filter { $0.category == category }
        }
        
        // Apply active filters
        filteredNews = filteredNews.filter { article in
            // Impact filter
            guard activeFilters.impacts.isEmpty || activeFilters.impacts.contains(article.impact) else {
                return false
            }
            
            // Sentiment filter
            guard activeFilters.sentiments.isEmpty || activeFilters.sentiments.contains(article.sentiment) else {
                return false
            }
            
            // Currency filter
            guard activeFilters.currencies.isEmpty || !Set(article.affectedCurrencies).isDisjoint(with: activeFilters.currencies) else {
                return false
            }
            
            // Source filter
            guard activeFilters.sources.isEmpty || activeFilters.sources.contains(article.source) else {
                return false
            }
            
            // Time filter
            guard passesTimeFilter(article: article, filter: activeFilters.timeFilter) else {
                return false
            }
            
            return true
        }
        
        return filteredNews.sorted { $0.timestamp > $1.timestamp }
    }
    
    func getNewsCount(for category: NewsCategory) -> Int {
        return news.filter { $0.category == category }.count
    }
    
    private func passesTimeFilter(article: NewsArticle, filter: NewsTimeFilterConsolidated) -> Bool {
        let now = Date()
        let articleTime = article.timestamp
        
        switch filter {
        case .all:
            return true
        case .lastHour:
            return now.timeIntervalSince(articleTime) <= 3600
        case .today:
            return Calendar.current.isDate(articleTime, inSameDayAs: now)
        case .thisWeek:
            let weekAgo = Calendar.current.date(byAdding: .day, value: -7, to: now) ?? now
            return articleTime >= weekAgo
        }
    }
    
    private func loadSampleNews() {
        news = [
            NewsArticle(
                title: "Fed Chair Powell Signals Potential Rate Pause Ahead",
                summary: "Federal Reserve Chairman Jerome Powell hints at a potential pause in interest rate hikes, citing inflation concerns and economic uncertainty.",
                source: "Reuters",
                category: .centralBank,
                impact: .high,
                sentiment: .neutral,
                affectedCurrencies: ["USD", "EUR", "GBP"],
                timestamp: Date().addingTimeInterval(-300)
            ),
            
            NewsArticle(
                title: "Gold Prices Surge on Safe Haven Demand",
                summary: "XAU/USD climbs above $2,050 as geopolitical tensions drive investors towards precious metals.",
                source: "Bloomberg",
                category: .commodities,
                impact: .medium,
                sentiment: .bullish,
                affectedCurrencies: ["USD", "EUR"],
                timestamp: Date().addingTimeInterval(-600)
            ),
            
            NewsArticle(
                title: "ECB Officials Split on Next Policy Move",
                summary: "European Central Bank officials show division on future monetary policy direction ahead of next meeting.",
                source: "Financial Times",
                category: .centralBank,
                impact: .high,
                sentiment: .bearish,
                affectedCurrencies: ["EUR", "USD", "GBP"],
                timestamp: Date().addingTimeInterval(-900)
            ),
            
            NewsArticle(
                title: "US Dollar Weakens on Mixed Economic Data",
                summary: "DXY falls as latest employment and inflation data present mixed signals for Fed policy.",
                source: "MarketWatch",
                category: .economic,
                impact: .medium,
                sentiment: .bearish,
                affectedCurrencies: ["USD", "JPY", "CHF"],
                timestamp: Date().addingTimeInterval(-1200)
            ),
            
            NewsArticle(
                title: "Oil Prices Rally on OPEC+ Production Cuts",
                summary: "Crude oil surges as OPEC+ announces unexpected production cuts, boosting energy sector outlook.",
                source: "CNN Business",
                category: .commodities,
                impact: .high,
                sentiment: .bullish,
                affectedCurrencies: ["CAD", "NOK", "RUB"],
                timestamp: Date().addingTimeInterval(-1500)
            ),
            
            NewsArticle(
                title: "UK Inflation Shows Signs of Cooling",
                summary: "British inflation data comes in below expectations, reducing pressure on Bank of England.",
                source: "BBC Business",
                category: .economic,
                impact: .medium,
                sentiment: .bullish,
                affectedCurrencies: ["GBP", "EUR", "USD"],
                timestamp: Date().addingTimeInterval(-1800)
            ),
            
            NewsArticle(
                title: "Tech Stocks Rally Boosts Risk Appetite",
                summary: "Major technology stocks surge, improving market sentiment and supporting risk-sensitive currencies.",
                source: "CNBC",
                category: .stocks,
                impact: .low,
                sentiment: .bullish,
                affectedCurrencies: ["AUD", "NZD", "CAD"],
                timestamp: Date().addingTimeInterval(-2100)
            )
        ]
    }
}

// MARK: - Data Models

struct NewsArticle: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let summary: String?
    let source: String
    let category: NewsCategory
    let impact: NewsImpactLevel
    let sentiment: NewsSentiment
    let affectedCurrencies: [String]
    let timestamp: Date
    
    var timeAgo: String {
        let interval = Date().timeIntervalSince(timestamp)
        
        if interval < 60 {
            return "\(Int(interval))s ago"
        } else if interval < 3600 {
            return "\(Int(interval / 60))m ago"
        } else {
            return "\(Int(interval / 3600))h ago"
        }
    }
}

enum NewsCategory: String, CaseIterable {
    case all = "all"
    case centralBank = "central_bank"
    case economic = "economic"
    case stocks = "stocks"
    case commodities = "commodities"
    case crypto = "crypto"
    case geopolitical = "geopolitical"
    
    var displayName: String {
        switch self {
        case .all: return "All"
        case .centralBank: return "Central Banks"
        case .economic: return "Economic"
        case .stocks: return "Stocks"
        case .commodities: return "Commodities"
        case .crypto: return "Crypto"
        case .geopolitical: return "Geopolitical"
        }
    }
    
    var icon: String {
        switch self {
        case .all: return "globe"
        case .centralBank: return "building.columns"
        case .economic: return "chart.bar.fill"
        case .stocks: return "chart.line.uptrend.xyaxis"
        case .commodities: return "oilcan.fill"
        case .crypto: return "bitcoinsign.circle.fill"
        case .geopolitical: return "flag.fill"
        }
    }
}

enum NewsSentiment: String, CaseIterable {
    case bullish = "bullish"
    case neutral = "neutral"
    case bearish = "bearish"
    
    var displayName: String {
        switch self {
        case .bullish: return "Bullish"
        case .neutral: return "Neutral"
        case .bearish: return "Bearish"
        }
    }
    
    var icon: String {
        switch self {
        case .bullish: return "arrow.up.circle.fill"
        case .neutral: return "minus.circle.fill"
        case .bearish: return "arrow.down.circle.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .bullish: return .green
        case .neutral: return .gray
        case .bearish: return .red
        }
    }
}

enum NewsTimeFilterConsolidated: String, CaseIterable {
    case all = "all"
    case lastHour = "last_hour"
    case today = "today"
    case thisWeek = "this_week"
}

struct NewsFilters {
    var impacts: Set<NewsImpactLevel> = Set(NewsImpactLevel.allCases)
    var sentiments: Set<NewsSentiment> = Set(NewsSentiment.allCases)
    var currencies: Set<String> = []
    var sources: Set<String> = []
    var timeFilter: NewsTimeFilterConsolidated = .all
}

// MARK: - Shimmer Effect

extension View {
    func shimmering() -> some View {
        self.modifier(ShimmerModifier())
    }
}

struct ShimmerModifier: ViewModifier {
    @State private var phase: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .overlay(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.clear,
                        Color.white.opacity(0.4),
                        Color.clear
                    ]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .rotationEffect(.degrees(45))
                .offset(x: phase)
                .clipped()
            )
            .onAppear {
                withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                    phase = 400
                }
            }
    }
}

// MARK: - Preview
struct MarketNewsView_Previews: PreviewProvider {
    static var previews: some View {
        MarketNewsView()
    }
}