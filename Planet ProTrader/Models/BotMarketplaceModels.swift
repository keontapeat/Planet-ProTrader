//
//  BotMarketplaceModels.swift
//  Planet ProTrader
//
//  Bot marketplace data models
//

import Foundation

// Marketplace bot models for the ProTrader bot store
extension SharedTypes {
    
    struct MarketplaceBotModel: Identifiable, Codable {
        let id: String
        let name: String
        let description: String
        let price: Double
        let rating: Double
        let downloads: Int
        let category: String
        let features: [String]
        
        init(
            id: String = UUID().uuidString,
            name: String,
            description: String,
            price: Double = 0.0,
            rating: Double = 0.0,
            downloads: Int = 0,
            category: String = "Trading Bot",
            features: [String] = []
        ) {
            self.id = id
            self.name = name
            self.description = description
            self.price = price
            self.rating = rating
            self.downloads = downloads
            self.category = category
            self.features = features
        }
        
        static let sample = MarketplaceBotModel(
            name: "Gold Master Pro",
            description: "Advanced gold trading algorithm with 90% win rate",
            price: 99.99,
            rating: 4.8,
            downloads: 1250,
            features: ["Auto Trading", "Risk Management", "Real-time Signals"]
        )
    }
}