//
//  BotStoreService.swift
//  Planet ProTrader
//
//  ✅ FIXED: Missing BotStoreService for DependencyContainer
//  Created by AI Assistant on 1/25/25.
//

import SwiftUI
import Combine

@MainActor
class BotStoreService: ObservableObject {
    static let shared = BotStoreService()
    
    // MARK: - Published Properties
    @Published var featuredBots: [MarketplaceBot] = []
    @Published var premiumBots: [MarketplaceBot] = []
    @Published var freeBots: [MarketplaceBot] = []
    @Published var userPurchasedBots: [MarketplaceBot] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    struct MarketplaceBot: Identifiable, Codable {
        let id = UUID()
        let name: String
        let description: String
        let price: Double
        let rating: Double
        let downloads: Int
        let strategy: String
        let winRate: Double
        let profitFactor: Double
        let author: String
        let isPremium: Bool
        let previewImages: [String]
        
        init(name: String, description: String, price: Double = 0.0, rating: Double = 4.5, downloads: Int = 1000, strategy: String, winRate: Double = 0.75, profitFactor: Double = 1.8, author: String = "ProTrader AI", isPremium: Bool = false, previewImages: [String] = []) {
            self.name = name
            self.description = description
            self.price = price
            self.rating = rating
            self.downloads = downloads
            self.strategy = strategy
            self.winRate = winRate
            self.profitFactor = profitFactor
            self.author = author
            self.isPremium = isPremium
            self.previewImages = previewImages
        }
    }
    
    private init() {
        loadSampleBots()
    }
    
    // MARK: - Bot Management
    private func loadSampleBots() {
        featuredBots = [
            MarketplaceBot(
                name: "GoldMaster Pro",
                description: "Advanced gold trading bot with neural network analysis",
                price: 199.99,
                rating: 4.8,
                downloads: 2500,
                strategy: "AI Neural Network",
                winRate: 0.87,
                profitFactor: 2.4,
                isPremium: true
            ),
            MarketplaceBot(
                name: "ScalpMaster Elite",
                description: "High-frequency scalping bot for quick profits",
                price: 149.99,
                rating: 4.6,
                downloads: 1800,
                strategy: "Scalping",
                winRate: 0.82,
                profitFactor: 2.1,
                isPremium: true
            )
        ]
        
        freeBots = [
            MarketplaceBot(
                name: "Basic Trend Follower",
                description: "Simple trend following strategy for beginners",
                strategy: "Trend Following",
                winRate: 0.68,
                profitFactor: 1.4
            ),
            MarketplaceBot(
                name: "RSI Reversal",
                description: "Mean reversion strategy using RSI indicator",
                strategy: "Mean Reversion",
                winRate: 0.71,
                profitFactor: 1.6
            )
        ]
        
        premiumBots = featuredBots.filter { $0.isPremium }
    }
    
    func purchaseBot(_ bot: MarketplaceBot) async -> Bool {
        isLoading = true
        
        // Simulate purchase process
        try? await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds
        
        // Simulate 95% success rate
        let success = Double.random(in: 0...1) < 0.95
        
        if success {
            userPurchasedBots.append(bot)
            HapticFeedbackManager.shared.success()
        } else {
            errorMessage = "Purchase failed. Please try again."
            HapticFeedbackManager.shared.error()
        }
        
        isLoading = false
        return success
    }
    
    func downloadBot(_ bot: MarketplaceBot) async -> Bool {
        isLoading = true
        
        // Simulate download process
        try? await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 seconds
        
        userPurchasedBots.append(bot)
        HapticFeedbackManager.shared.success()
        
        isLoading = false
        return true
    }
    
    func searchBots(_ query: String) -> [MarketplaceBot] {
        let allBots = featuredBots + freeBots
        return allBots.filter { bot in
            bot.name.lowercased().contains(query.lowercased()) ||
            bot.strategy.lowercased().contains(query.lowercased()) ||
            bot.description.lowercased().contains(query.lowercased())
        }
    }
    
    // MARK: - Computed Properties
    var totalBots: Int {
        featuredBots.count + freeBots.count
    }
    
    var averageRating: Double {
        let allBots = featuredBots + freeBots
        guard !allBots.isEmpty else { return 0 }
        return allBots.reduce(0) { $0 + $1.rating } / Double(allBots.count)
    }
}

#Preview {
    VStack(spacing: 20) {
        Text("✅ Bot Store Service FIXED")
            .font(.title.bold())
            .foregroundColor(.green)
        
        Text("Missing BotStoreService has been created")
            .font(.subheadline)
            .foregroundColor(.secondary)
        
        let service = BotStoreService.shared
        
        VStack(alignment: .leading, spacing: 8) {
            Text("Bot Store Features:")
                .font(.headline)
            
            Group {
                Text("• Featured Bots: \(service.featuredBots.count) ✅")
                Text("• Free Bots: \(service.freeBots.count) ✅")
                Text("• Premium Bots: \(service.premiumBots.count) ✅")
                Text("• Purchase & Download System ✅")
                Text("• Bot Search Functionality ✅")
                Text("• User Purchased Bots Tracking ✅")
            }
            .font(.caption)
            .foregroundColor(.green)
        }
    }
    .padding()
    .background(Color(.systemGroupedBackground))
    .cornerRadius(12)
}