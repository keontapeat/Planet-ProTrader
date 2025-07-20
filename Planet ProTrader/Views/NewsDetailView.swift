//
//  NewsDetailView.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 1/21/25.
//

import SwiftUI

struct NewsDetailView: View {
    @Environment(\.dismiss) private var dismiss
    let article: NewsArticleModel  // Use consolidated type
    @StateObject private var marketAnalyzer = NewsMarketAnalyzer()
    @State private var showingRelatedNews = false
    @State private var showingMarketImpact = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Article header
                    articleHeader
                    
                    // Impact analysis
                    impactAnalysis
                    
                    // Article content
                    articleContent
                    
                    // Market implications
                    marketImplications
                    
                    // Currency impact
                    currencyImpactSection
                    
                    // Related articles
                    relatedArticlesSection
                    
                    // Trading opportunities
                    tradingOpportunities
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
            .background(Color(.systemBackground))
            .navigationTitle("News Detail")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: { showingMarketImpact = true }) {
                        Image(systemName: "chart.bar.fill")
                            .foregroundColor(DesignSystem.primaryGold)
                    }
                    
                    Button("Done") {
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .foregroundColor(DesignSystem.primaryGold)
                }
            }
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
        .sheet(isPresented: $showingMarketImpact) {
            MarketImpactAnalysisView(article: article)
        }
        .onAppear {
            Task {
                await marketAnalyzer.analyzeArticle(article)
            }
        }
    }
    
    // MARK: - Article Header
    
    private var articleHeader: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Source and time
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: "newspaper.fill")
                        .font(.caption)
                        .foregroundColor(DesignSystem.primaryGold)
                    
                    Text(article.source)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                }
                
                Spacer()
                
                Text(timeAgo(from: article.publishedAt))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            // Title
            Text(article.title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .lineLimit(nil)
            
            // Impact badge only (remove sentiment for now)
            HStack(spacing: 12) {
                impactBadge(impact: article.impact)
                
                Spacer()
                
                // Share button
                Button(action: {
                    // Share functionality
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.caption)
                        Text("Share")
                            .font(.caption)
                    }
                    .foregroundColor(DesignSystem.primaryGold)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(DesignSystem.primaryGold.opacity(0.1))
                    .cornerRadius(6)
                }
            }
        }
    }
    
    // MARK: - Impact Analysis
    
    private var impactAnalysis: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("📊 Market Impact Analysis")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            VStack(spacing: 12) {
                // Impact meter
                impactMeter
                
                // Quick insights
                quickInsights
            }
            .padding(16)
            .background(Color(.systemGray6).opacity(0.5))
            .cornerRadius(12)
        }
    }
    
    private var impactMeter: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Market Impact Level")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Text(article.impact.rawValue.uppercased())
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(article.impact.color)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(article.impact.color.opacity(0.1))
                    .cornerRadius(4)
            }
            
            // Visual impact bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color(.systemGray5))
                        .frame(height: 8)
                        .cornerRadius(4)
                    
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [.green, .orange, .red],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * impactPercentage, height: 8)
                        .cornerRadius(4)
                        .animation(.easeInOut(duration: 1.0), value: impactPercentage)
                }
            }
            .frame(height: 8)
        }
    }
    
    private var quickInsights: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
            insightCard(title: "Volatility", value: marketAnalyzer.volatilityImpact, icon: "waveform.path")
            insightCard(title: "Duration", value: marketAnalyzer.impactDuration, icon: "clock.fill")
            insightCard(title: "Confidence", value: "\(Int(marketAnalyzer.analysisConfidence * 100))%", icon: "checkmark.seal.fill")
            insightCard(title: "Urgency", value: marketAnalyzer.urgencyLevel, icon: "exclamationmark.triangle.fill")
        }
    }
    
    private func insightCard(title: String, value: String, icon: String) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundColor(DesignSystem.primaryGold)
            
            Text(value)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text(title)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(Color(.systemBackground))
        .cornerRadius(8)
    }
    
    // MARK: - Article Content
    
    private var articleContent: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("📄 Article Summary")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text(article.summary)
                .font(.body)
                .foregroundColor(.primary)
                .lineLimit(nil)
            
            // Full article content
            VStack(alignment: .leading, spacing: 8) {
                Text("Full Article Content")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
                
                Text(article.content)
                    .font(.body)
                    .foregroundColor(.primary)
                    .lineLimit(10)
                    .padding()
                    .background(Color(.systemGray6).opacity(0.5))
                    .cornerRadius(8)
            }
        }
    }
    
    // MARK: - Market Implications
    
    private var marketImplications: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("🎯 Market Implications")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            LazyVStack(spacing: 8) {
                ForEach(marketAnalyzer.implications, id: \.self) { implication in
                    implicationRow(implication: implication)
                }
            }
            .padding(12)
            .background(Color(.systemGray6).opacity(0.5))
            .cornerRadius(12)
        }
    }
    
    private func implicationRow(implication: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "arrow.right.circle.fill")
                .font(.caption)
                .foregroundColor(DesignSystem.primaryGold)
                .padding(.top, 2)
            
            Text(implication)
                .font(.subheadline)
                .foregroundColor(.primary)
            
            Spacer()
        }
    }
    
    // MARK: - Currency Impact
    
    private var currencyImpactSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("💱 Currency Impact")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            // Use tags instead of affectedCurrencies
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 8) {
                ForEach(Array(article.tags.prefix(3)), id: \.self) { currency in
                    currencyImpactCard(currency: currency)
                }
            }
        }
    }
    
    private func currencyImpactCard(currency: String) -> some View {
        VStack(spacing: 6) {
            Text(currency)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(currencyColor(currency))
                .cornerRadius(8)
            
            VStack(spacing: 2) {
                Text(marketAnalyzer.getCurrencyImpact(currency))
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(marketAnalyzer.getCurrencyImpactColor(currency))
                
                Text("Expected")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(currencyColor(currency).opacity(0.3), lineWidth: 1)
        )
    }
    
    // MARK: - Related Articles
    
    private var relatedArticlesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("📰 Related News")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Button("View All") {
                    showingRelatedNews = true
                }
                .font(.caption)
                .foregroundColor(DesignSystem.primaryGold)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(marketAnalyzer.relatedArticles.prefix(3), id: \.id) { relatedArticle in
                        relatedNewsCard(article: relatedArticle)
                    }
                }
                .padding(.horizontal, 4)
            }
        }
    }
    
    private func relatedNewsCard(article: NewsArticleModel) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(article.title)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
                .lineLimit(2)
            
            HStack {
                Text(article.source)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text(timeAgo(from: article.publishedAt))
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            // Impact badge using consolidated type
            HStack(spacing: 4) {
                Text(article.impact.emoji)
                    .font(.caption2)
                
                Text(article.impact.rawValue)
                    .font(.caption2)
                    .fontWeight(.bold)
            }
            .foregroundColor(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(article.impact.color)
            .cornerRadius(6)
        }
        .padding(12)
        .frame(width: 200)
        .background(Color(.systemGray6).opacity(0.5))
        .cornerRadius(10)
    }
    
    // MARK: - Trading Opportunities
    
    private var tradingOpportunities: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("⚡ Trading Opportunities")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            LazyVStack(spacing: 8) {
                ForEach(marketAnalyzer.tradingOpportunities, id: \.id) { opportunity in
                    tradingOpportunityCard(opportunity: opportunity)
                }
            }
        }
    }
    
    private func tradingOpportunityCard(opportunity: TradingOpportunity) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                HStack(spacing: 6) {
                    Image(systemName: opportunity.direction.icon)
                        .font(.caption)
                        .foregroundColor(opportunity.direction.color)
                    
                    Text(opportunity.pair)
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                }
                
                Spacer()
                
                Text("Confidence: \(Int(opportunity.confidence * 100))%")
                    .font(.caption)
                    .foregroundColor(opportunity.confidence > 0.7 ? .green : .orange)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background((opportunity.confidence > 0.7 ? Color.green : Color.orange).opacity(0.1))
                    .cornerRadius(4)
            }
            
            Text(opportunity.reasoning)
                .font(.caption)
                .foregroundColor(.secondary)
                .lineLimit(2)
            
            HStack {
                Label("Risk: \(opportunity.riskLevel)", systemImage: "exclamationmark.triangle.fill")
                    .font(.caption2)
                    .foregroundColor(.orange)
                
                Spacer()
                
                Label("Timeframe: \(opportunity.timeframe)", systemImage: "clock.fill")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding(12)
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(opportunity.direction.color.opacity(0.3), lineWidth: 1)
        )
    }
    
    // MARK: - Helper Views
    
    private func impactBadge(impact: NewsImpactLevel) -> some View {
        HStack(spacing: 4) {
            Text(impact.emoji)
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

    private func sentimentBadge(sentiment: String) -> some View {
        HStack(spacing: 4) {
            Image(systemName: "text.bubble.fill")
                .font(.caption2)
            
            Text(sentiment)
                .font(.caption2)
                .fontWeight(.bold)
        }
        .foregroundColor(.white)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(.blue)
        .cornerRadius(6)
    }
    
    // MARK: - Helper Methods
    
    private var impactPercentage: CGFloat {
        switch article.impact {
        case .low: return 0.3
        case .medium: return 0.6
        case .high: return 0.9
        case .critical: return 1.0
        }
    }
    
    private func timeAgo(from date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
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
}

// MARK: - News Market Analyzer

class NewsMarketAnalyzer: ObservableObject {
    @Published var volatilityImpact: String = "High"
    @Published var impactDuration: String = "2-4 hours"
    @Published var analysisConfidence: Double = 0.85
    @Published var urgencyLevel: String = "Medium"
    @Published var implications: [String] = []
    @Published var relatedArticles: [NewsArticleModel] = []
    @Published var tradingOpportunities: [TradingOpportunity] = []
    
    func analyzeArticle(_ article: NewsArticleModel) async {
        // Simulate AI analysis
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        DispatchQueue.main.async {
            self.performAnalysis(article)
        }
    }
    
    private func performAnalysis(_ article: NewsArticleModel) {
        // Set analysis results based on article
        implications = generateImplications(for: article)
        relatedArticles = generateRelatedArticles(for: article)
        tradingOpportunities = generateTradingOpportunities(for: article)
        
        // Update analysis metrics
        volatilityImpact = article.impact == .high || article.impact == .critical ? "Very High" : "Moderate"
        analysisConfidence = Double.random(in: 0.75...0.95)
        urgencyLevel = article.impact == .high || article.impact == .critical ? "High" : "Medium"
    }
    
    private func generateImplications(for article: NewsArticleModel) -> [String] {
        return [
            "Increased volatility expected in \(article.tags.joined(separator: ", ")) related markets",
            "Central bank policy expectations may shift significantly",
            "Risk sentiment likely to be affected across major markets",
            "Technical levels may be tested in coming sessions"
        ]
    }
    
    private func generateRelatedArticles(for article: NewsArticleModel) -> [NewsArticleModel] {
        // Return sample related articles from ConsolidatedTypes
        return Array(NewsArticleModel.sampleNews.filter { $0.id != article.id }.prefix(3))
    }
    
    private func generateTradingOpportunities(for article: NewsArticleModel) -> [TradingOpportunity] {
        let tags = article.tags
        var opportunities: [TradingOpportunity] = []
        
        if tags.contains("USD") || tags.contains("Fed") {
            opportunities.append(TradingOpportunity(
                pair: "EUR/USD",
                direction: .buy,
                confidence: 0.75,
                reasoning: "USD strength expected from Federal Reserve policy implications",
                riskLevel: "Medium",
                timeframe: "2-4 hours"
            ))
        }
        
        return opportunities
    }
    
    func getCurrencyImpact(_ currency: String) -> String {
        let impacts = ["Bullish", "Bearish", "Neutral", "Strong Bullish", "Strong Bearish"]
        return impacts.randomElement() ?? "Neutral"
    }
    
    func getCurrencyImpactColor(_ currency: String) -> Color {
        let impact = getCurrencyImpact(currency)
        switch impact {
        case "Bullish", "Strong Bullish": return .green
        case "Bearish", "Strong Bearish": return .red
        default: return .gray
        }
    }
}

// MARK: - Trading Opportunity Model

struct TradingOpportunity: Identifiable {
    let id = UUID()
    let pair: String
    let direction: TradeDirection
    let confidence: Double
    let reasoning: String
    let riskLevel: String
    let timeframe: String
}

enum TradeDirection: String, CaseIterable {
    case buy = "BUY"
    case sell = "SELL"
    
    var icon: String {
        switch self {
        case .buy: return "arrow.up.circle.fill"
        case .sell: return "arrow.down.circle.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .buy: return .green
        case .sell: return .red
        }
    }
}

#Preview {
    NewsDetailView(article: NewsArticleModel(
        title: "Fed Chair Powell Signals Potential Rate Pause Ahead",
        summary: "Federal Reserve Chairman Jerome Powell hints at a potential pause in interest rate hikes, citing inflation concerns and economic uncertainty.",
        content: "In a highly anticipated speech, Federal Reserve Chairman Jerome Powell provided insights into the central bank's future monetary policy direction...",
        impact: .high,
        publishedAt: Date().addingTimeInterval(-300),
        source: "Reuters",
        category: "Central Banking",
        tags: ["Fed", "Interest Rates", "USD"]
    ))
}