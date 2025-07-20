import SwiftUI
import Foundation
import Combine

// MARK: - Bot Marketplace Manager
@MainActor
class BotMarketplaceManager: ObservableObject {
    @Published var availableBots: [MarketplaceBotModel] = []
    @Published var hiredBots: [MarketplaceBotModel] = []
    @Published var topPerformers: [MarketplaceBotModel] = []
    @Published var searchQuery: String = ""
    @Published var sortOption: SortOption = .performance
    @Published var selectedFilters = FilterOptions()
    @Published var isLoading = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadSampleBots()
        setupBindings()
    }
    
    private func setupBindings() {
        Publishers.CombineLatest3($searchQuery, $sortOption, $selectedFilters)
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.updateFilteredBots()
            }
            .store(in: &cancellables)
    }
    
    var filteredBots: [MarketplaceBotModel] {
        var bots = availableBots
        
        // Apply search filter
        if !searchQuery.isEmpty {
            bots = bots.filter { bot in
                bot.name.localizedCaseInsensitiveContains(searchQuery) ||
                bot.nickname.localizedCaseInsensitiveContains(searchQuery) ||
                bot.ownerName.localizedCaseInsensitiveContains(searchQuery)
            }
        }
        
        // Apply category filter
        if !selectedFilters.categories.isEmpty {
            bots = bots.filter { bot in
                selectedFilters.categories.contains(bot.category)
            }
        }
        
        // Apply rating filter
        bots = bots.filter { bot in
            bot.averageRating >= selectedFilters.minRating
        }
        
        // Apply availability filter
        if selectedFilters.availableOnly {
            bots = bots.filter { $0.isAvailable }
        }
        
        // Sort bots
        switch sortOption {
        case .performance:
            bots.sort { $0.winRate > $1.winRate }
        case .earnings:
            bots.sort { $0.totalEarnings > $1.totalEarnings }
        case .rating:
            bots.sort { $0.averageRating > $1.averageRating }
        case .popularity:
            bots.sort { $0.followerCount > $1.followerCount }
        case .price:
            bots.sort { $0.hiringFee < $1.hiringFee }
        }
        
        return bots
    }
    
    private func updateFilteredBots() {
        // Trigger UI update
        objectWillChange.send()
    }
    
    func refreshData() {
        isLoading = true
        
        // Simulate network call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.loadSampleBots()
            self.isLoading = false
        }
    }
    
    private func loadSampleBots() {
        availableBots = MarketplaceBotModel.sampleBots
        hiredBots = Array(availableBots.prefix(3))
        topPerformers = availableBots.sorted { $0.winRate > $1.winRate }.prefix(5).map { $0 }
    }
    
    // MARK: - Enums
    enum SortOption: String, CaseIterable {
        case performance = "Performance"
        case earnings = "Earnings"
        case rating = "Rating"
        case popularity = "Popularity"
        case price = "Price"
        
        var systemImage: String {
            switch self {
            case .performance: return "chart.bar.fill"
            case .earnings: return "dollarsign.circle.fill"
            case .rating: return "star.fill"
            case .popularity: return "heart.fill"
            case .price: return "tag.fill"
            }
        }
    }
    
    struct FilterOptions {
        var categories: Set<BotCategory> = []
        var minRating: Double = 0.0
        var maxPrice: Double = 10000.0
        var availableOnly: Bool = false
        var riskLevels: Set<RiskLevel> = []
    }
}

// MARK: - Supporting Types
enum BotCategory: String, CaseIterable {
    case scalper = "Scalper"
    case swing = "Swing"
    case dayTrader = "Day Trader"
    case news = "News"
    case technical = "Technical"
    case fundamental = "Fundamental"
    
    var emoji: String {
        switch self {
        case .scalper: return "⚡"
        case .swing: return "📈"
        case .dayTrader: return "🎯"
        case .news: return "📰"
        case .technical: return "📊"
        case .fundamental: return "🏛️"
        }
    }
}

enum RiskLevel: String, CaseIterable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    case extreme = "Extreme"
    
    var emoji: String {
        switch self {
        case .low: return "🟢"
        case .medium: return "🟡"
        case .high: return "🟠"
        case .extreme: return "🔴"
        }
    }
    
    var color: Color {
        switch self {
        case .low: return .green
        case .medium: return .yellow
        case .high: return .orange
        case .extreme: return .red
        }
    }
}

enum PopularityLevel: String, CaseIterable {
    case rising = "Rising"
    case popular = "Popular"
    case viral = "Viral"
    case legendary = "Legendary"
    
    var emoji: String {
        switch self {
        case .rising: return "📈"
        case .popular: return "🔥"
        case .viral: return "⚡"
        case .legendary: return "👑"
        }
    }
}