//
//  TradingRepository.swift
//  Planet ProTrader
//
//  Created by Senior iOS Engineer on 1/25/25.
//

import Foundation
import Combine

protocol TradingRepositoryProtocol {
    func getCurrentPrice(for symbol: String) async throws -> Double
    func getMarketData(for symbol: String) async throws -> TradingModels.MarketData
    func executeTrade(_ trade: SharedTypes.AutoTrade) async throws -> Bool
    func getSignalHistory() async throws -> [TradingModels.GoldSignal]
    func subscribeToRealTimeData(for symbol: String) -> AnyPublisher<Double, Never>
}

@MainActor
class TradingRepository: TradingRepositoryProtocol, ObservableObject {
    private let apiService: APIService
    private let cacheService: CacheService
    private let realtimeService: RealtimeDataService
    
    init(
        apiService: APIService = APIService(),
        cacheService: CacheService = CacheService(),
        realtimeService: RealtimeDataService = RealtimeDataService()
    ) {
        self.apiService = apiService
        self.cacheService = cacheService
        self.realtimeService = realtimeService
    }
    
    func getCurrentPrice(for symbol: String) async throws -> Double {
        // Check cache first for recent data
        if let cachedPrice = cacheService.getCachedPrice(for: symbol) {
            return cachedPrice
        }
        
        // Fetch from API
        let price = try await apiService.fetchCurrentPrice(for: symbol)
        cacheService.cachePrice(price, for: symbol)
        return price
    }
    
    func getMarketData(for symbol: String) async throws -> TradingModels.MarketData {
        // Check cache for market data
        if let cachedData = cacheService.getCachedMarketData(for: symbol) {
            return cachedData
        }
        
        let marketData = try await apiService.fetchMarketData(for: symbol)
        cacheService.cacheMarketData(marketData, for: symbol)
        return marketData
    }
    
    func executeTrade(_ trade: SharedTypes.AutoTrade) async throws -> Bool {
        let result = try await apiService.executeTrade(trade)
        
        if result {
            // Post notification of successful trade
            NotificationCenter.default.post(name: .newTradeExecuted, object: trade)
        }
        
        return result
    }
    
    func getSignalHistory() async throws -> [TradingModels.GoldSignal] {
        return try await apiService.fetchSignalHistory()
    }
    
    func subscribeToRealTimeData(for symbol: String) -> AnyPublisher<Double, Never> {
        return realtimeService.priceStream(for: symbol)
    }
}

// MARK: - Supporting Services

class APIService {
    func fetchCurrentPrice(for symbol: String) async throws -> Double {
        // Simulate API delay
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        // Simulate XAUUSD price with realistic movement
        let basePrice: Double = 2374.50
        let movement = Double.random(in: -5.0...5.0)
        return basePrice + movement
    }
    
    func fetchMarketData(for symbol: String) async throws -> TradingModels.MarketData {
        try await Task.sleep(nanoseconds: 200_000_000) // 0.2 seconds
        
        let currentPrice = try await fetchCurrentPrice(for: symbol)
        let change = Double.random(in: -15.0...20.0)
        
        return TradingModels.MarketData(
            currentPrice: currentPrice,
            change24h: change,
            changePercentage: (change / currentPrice) * 100,
            high24h: currentPrice + Double.random(in: 5.0...15.0),
            low24h: currentPrice - Double.random(in: 5.0...15.0),
            volume: Double.random(in: 100_000...500_000),
            lastUpdated: Date()
        )
    }
    
    func executeTrade(_ trade: SharedTypes.AutoTrade) async throws -> Bool {
        // Simulate trade execution delay
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        
        // Simulate 95% success rate
        return Double.random(in: 0...1) < 0.95
    }
    
    func fetchSignalHistory() async throws -> [TradingModels.GoldSignal] {
        try await Task.sleep(nanoseconds: 300_000_000) // 0.3 seconds
        return TradingModels.GoldSignal.sampleSignals
    }
}

class CacheService {
    private var priceCache: [String: (price: Double, timestamp: Date)] = [:]
    private var marketDataCache: [String: (data: TradingModels.MarketData, timestamp: Date)] = [:]
    
    private let cacheTimeout: TimeInterval = 5.0 // 5 seconds
    
    func getCachedPrice(for symbol: String) -> Double? {
        guard let cached = priceCache[symbol],
              Date().timeIntervalSince(cached.timestamp) < cacheTimeout else {
            return nil
        }
        return cached.price
    }
    
    func cachePrice(_ price: Double, for symbol: String) {
        priceCache[symbol] = (price: price, timestamp: Date())
    }
    
    func getCachedMarketData(for symbol: String) -> TradingModels.MarketData? {
        guard let cached = marketDataCache[symbol],
              Date().timeIntervalSince(cached.timestamp) < cacheTimeout else {
            return nil
        }
        return cached.data
    }
    
    func cacheMarketData(_ data: TradingModels.MarketData, for symbol: String) {
        marketDataCache[symbol] = (data: data, timestamp: Date())
    }
    
    func clearCache() {
        priceCache.removeAll()
        marketDataCache.removeAll()
    }
}

class RealtimeDataService {
    private let priceSubject = PassthroughSubject<Double, Never>()
    private var timer: Timer?
    
    func priceStream(for symbol: String) -> AnyPublisher<Double, Never> {
        startPriceStream(for: symbol)
        return priceSubject.eraseToAnyPublisher()
    }
    
    private func startPriceStream(for symbol: String) {
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            let basePrice: Double = 2374.50
            let movement = Double.random(in: -2.0...2.0)
            let newPrice = basePrice + movement
            
            self?.priceSubject.send(newPrice)
        }
    }
    
    deinit {
        timer?.invalidate()
    }
}