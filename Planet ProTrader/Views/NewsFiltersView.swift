//
//  NewsFiltersView.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 1/21/25.
//

import SwiftUI

struct NewsFiltersView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var newsManager: MarketNewsManager
    @State private var selectedImpacts: Set<NewsImpact> = Set(NewsImpact.allCases)
    @State private var selectedSentiments: Set<NewsSentiment> = Set(NewsSentiment.allCases)
    @State private var selectedCurrencies: Set<String> = []
    @State private var selectedSources: Set<String> = []
    @State private var timeFilter: NewsTimeFilter = .all
    
    let availableCurrencies = ["USD", "EUR", "GBP", "JPY", "CHF", "CAD", "AUD", "NZD"]
    let availableSources = ["Reuters", "Bloomberg", "Financial Times", "MarketWatch", "CNN Business", "BBC Business", "CNBC"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    headerSection
                    
                    // Impact Filter
                    impactFilterSection
                    
                    // Sentiment Filter
                    sentimentFilterSection
                    
                    // Currency Filter
                    currencyFilterSection
                    
                    // Source Filter
                    sourceFilterSection
                    
                    // Time Filter
                    timeFilterSection
                    
                    // Quick Presets
                    presetsSection
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
            .background(Color(.systemBackground))
            .navigationTitle("🔍 News Filters")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button("Reset") {
                        resetFilters()
                    }
                    .foregroundColor(.red)
                }
                
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button("Apply") {
                        applyFilters()
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .foregroundColor(DesignSystem.primaryGold)
                }
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Customize Your News Feed")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("Filter news to match your trading interests")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "slider.horizontal.3")
                    .font(.title2)
                    .foregroundColor(DesignSystem.primaryGold)
            }
            
            // Active filters count
            if totalActiveFilters > 0 {
                HStack {
                    Text("\(totalActiveFilters) active filters")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text("~\(estimatedResults) results")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(DesignSystem.primaryGold)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color(.systemGray6))
                .cornerRadius(8)
            }
        }
    }
    
    // MARK: - Impact Filter
    
    private var impactFilterSection: some View {
        filterSection(title: "📊 Impact Level", subtitle: "Filter by market impact") {
            HStack(spacing: 12) {
                ForEach(NewsImpact.allCases, id: \.self) { impact in
                    impactToggle(impact: impact)
                }
                
                Spacer()
            }
        }
    }
    
    private func impactToggle(impact: NewsImpact) -> some View {
        Button(action: {
            withAnimation(.spring()) {
                if selectedImpacts.contains(impact) {
                    selectedImpacts.remove(impact)
                } else {
                    selectedImpacts.insert(impact)
                }
            }
        }) {
            HStack(spacing: 6) {
                Image(systemName: impact.icon)
                    .font(.caption)
                
                Text(impact.displayName)
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .foregroundColor(selectedImpacts.contains(impact) ? .white : impact.color)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                selectedImpacts.contains(impact) 
                ? impact.color 
                : impact.color.opacity(0.1)
            )
            .cornerRadius(8)
        }
    }
    
    // MARK: - Sentiment Filter
    
    private var sentimentFilterSection: some View {
        filterSection(title: "💭 Market Sentiment", subtitle: "Filter by news sentiment") {
            HStack(spacing: 12) {
                ForEach(NewsSentiment.allCases, id: \.self) { sentiment in
                    sentimentToggle(sentiment: sentiment)
                }
                
                Spacer()
            }
        }
    }
    
    private func sentimentToggle(sentiment: NewsSentiment) -> some View {
        Button(action: {
            withAnimation(.spring()) {
                if selectedSentiments.contains(sentiment) {
                    selectedSentiments.remove(sentiment)
                } else {
                    selectedSentiments.insert(sentiment)
                }
            }
        }) {
            HStack(spacing: 6) {
                Image(systemName: sentiment.icon)
                    .font(.caption)
                
                Text(sentiment.displayName)
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .foregroundColor(selectedSentiments.contains(sentiment) ? .white : sentiment.color)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                selectedSentiments.contains(sentiment) 
                ? sentiment.color 
                : sentiment.color.opacity(0.1)
            )
            .cornerRadius(8)
        }
    }
    
    // MARK: - Currency Filter
    
    private var currencyFilterSection: some View {
        filterSection(title: "💱 Currencies", subtitle: "Focus on specific currencies") {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 8) {
                ForEach(availableCurrencies, id: \.self) { currency in
                    currencyToggle(currency: currency)
                }
            }
        }
    }
    
    private func currencyToggle(currency: String) -> some View {
        Button(action: {
            withAnimation(.spring()) {
                if selectedCurrencies.contains(currency) {
                    selectedCurrencies.remove(currency)
                } else {
                    selectedCurrencies.insert(currency)
                }
            }
        }) {
            Text(currency)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(selectedCurrencies.contains(currency) ? .white : .primary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(
                    selectedCurrencies.contains(currency) 
                    ? currencyColor(currency) 
                    : Color(.systemGray6)
                )
                .cornerRadius(8)
        }
    }
    
    // MARK: - Source Filter
    
    private var sourceFilterSection: some View {
        filterSection(title: "📰 News Sources", subtitle: "Select trusted sources") {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                ForEach(availableSources, id: \.self) { source in
                    sourceToggle(source: source)
                }
            }
        }
    }
    
    private func sourceToggle(source: String) -> some View {
        Button(action: {
            withAnimation(.spring()) {
                if selectedSources.contains(source) {
                    selectedSources.remove(source)
                } else {
                    selectedSources.insert(source)
                }
            }
        }) {
            Text(source)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(selectedSources.contains(source) ? .white : .primary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(
                    selectedSources.contains(source) 
                    ? DesignSystem.primaryGold 
                    : Color(.systemGray6)
                )
                .cornerRadius(8)
        }
    }
    
    // MARK: - Time Filter
    
    private var timeFilterSection: some View {
        filterSection(title: "⏰ Time Range", subtitle: "Filter by publication time") {
            VStack(spacing: 12) {
                ForEach(NewsTimeFilter.allCases, id: \.self) { filter in
                    timeFilterToggle(filter: filter)
                }
            }
        }
    }
    
    private func timeFilterToggle(filter: NewsTimeFilter) -> some View {
        Button(action: {
            withAnimation(.spring()) {
                timeFilter = filter
            }
        }) {
            HStack {
                Image(systemName: filter.icon)
                    .font(.caption)
                    .foregroundColor(timeFilter == filter ? .white : .primary)
                    .frame(width: 20)
                
                Text(filter.displayName)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(timeFilter == filter ? .white : .primary)
                
                Spacer()
                
                if timeFilter == filter {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.caption)
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                timeFilter == filter 
                ? DesignSystem.primaryGold 
                : Color(.systemGray6)
            )
            .cornerRadius(10)
        }
    }
    
    // MARK: - Presets Section
    
    private var presetsSection: some View {
        filterSection(title: "⚡ Quick Presets", subtitle: "Common filter combinations") {
            VStack(spacing: 8) {
                ForEach(FilterPreset.allCases, id: \.self) { preset in
                    presetButton(preset: preset)
                }
            }
        }
    }
    
    private func presetButton(preset: FilterPreset) -> some View {
        Button(action: {
            withAnimation(.spring()) {
                applyPreset(preset)
            }
        }) {
            HStack {
                Image(systemName: preset.icon)
                    .font(.title3)
                    .foregroundColor(preset.color)
                    .frame(width: 30)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(preset.name)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text(preset.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "arrow.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(.systemGray6).opacity(0.5))
            .cornerRadius(10)
        }
    }
    
    // MARK: - Helper Views
    
    private func filterSection<Content: View>(title: String, subtitle: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            content()
        }
        .padding(.vertical, 8)
    }
    
    // MARK: - Helper Methods
    
    private var totalActiveFilters: Int {
        var count = 0
        
        if selectedImpacts.count != NewsImpact.allCases.count {
            count += 1
        }
        
        if selectedSentiments.count != NewsSentiment.allCases.count {
            count += 1
        }
        
        if !selectedCurrencies.isEmpty {
            count += 1
        }
        
        if !selectedSources.isEmpty {
            count += 1
        }
        
        if timeFilter != .all {
            count += 1
        }
        
        return count
    }
    
    private var estimatedResults: Int {
        let baseCount = newsManager.totalNews
        let filterMultiplier = Double(totalActiveFilters) * 0.3
        let estimated = max(1, Int(Double(baseCount) * (1.0 - filterMultiplier)))
        return estimated
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
    
    private func resetFilters() {
        withAnimation(.spring()) {
            selectedImpacts = Set(NewsImpact.allCases)
            selectedSentiments = Set(NewsSentiment.allCases)
            selectedCurrencies = []
            selectedSources = []
            timeFilter = .all
        }
    }
    
    private func applyFilters() {
        // Apply filters to news manager
        newsManager.updateFilters(
            impacts: selectedImpacts,
            sentiments: selectedSentiments,
            currencies: selectedCurrencies,
            sources: selectedSources,
            timeFilter: timeFilter
        )
    }
    
    private func applyPreset(_ preset: FilterPreset) {
        switch preset {
        case .highImpact:
            selectedImpacts = [.high]
            selectedSentiments = Set(NewsSentiment.allCases)
            selectedCurrencies = []
            selectedSources = []
            timeFilter = .today
            
        case .forexFocus:
            selectedImpacts = Set(NewsImpact.allCases)
            selectedSentiments = Set(NewsSentiment.allCases)
            selectedCurrencies = Set(["USD", "EUR", "GBP", "JPY"])
            selectedSources = []
            timeFilter = .all
            
        case .centralBanks:
            selectedImpacts = [.high, .medium]
            selectedSentiments = Set(NewsSentiment.allCases)
            selectedCurrencies = []
            selectedSources = Set(["Reuters", "Bloomberg", "Financial Times"])
            timeFilter = .all
            
        case .breakingNews:
            selectedImpacts = [.high]
            selectedSentiments = Set(NewsSentiment.allCases)
            selectedCurrencies = []
            selectedSources = []
            timeFilter = .lastHour
        }
    }
}

// MARK: - Supporting Enums

enum NewsTimeFilter: String, CaseIterable {
    case all = "all"
    case lastHour = "last_hour"
    case today = "today"
    case thisWeek = "this_week"
    
    var displayName: String {
        switch self {
        case .all: return "All Time"
        case .lastHour: return "Last Hour"
        case .today: return "Today"
        case .thisWeek: return "This Week"
        }
    }
    
    var icon: String {
        switch self {
        case .all: return "infinity"
        case .lastHour: return "clock"
        case .today: return "calendar"
        case .thisWeek: return "calendar.badge.clock"
        }
    }
}

enum FilterPreset: String, CaseIterable {
    case highImpact = "high_impact"
    case forexFocus = "forex_focus"
    case centralBanks = "central_banks"
    case breakingNews = "breaking_news"
    
    var name: String {
        switch self {
        case .highImpact: return "High Impact Only"
        case .forexFocus: return "Forex Focus"
        case .centralBanks: return "Central Bank News"
        case .breakingNews: return "Breaking News"
        }
    }
    
    var description: String {
        switch self {
        case .highImpact: return "Major market-moving news only"
        case .forexFocus: return "Currency-focused updates"
        case .centralBanks: return "Fed, ECB, BOE, BOJ news"
        case .breakingNews: return "Latest urgent updates"
        }
    }
    
    var icon: String {
        switch self {
        case .highImpact: return "exclamationmark.triangle.fill"
        case .forexFocus: return "dollarsign.circle.fill"
        case .centralBanks: return "building.columns.fill"
        case .breakingNews: return "bolt.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .highImpact: return .red
        case .forexFocus: return .blue
        case .centralBanks: return .purple
        case .breakingNews: return .orange
        }
    }
}

#Preview {
    NewsFiltersView(newsManager: MarketNewsManager.shared)
}