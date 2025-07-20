//
//  TradingManager.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 1/25/25.
//

import SwiftUI
import Foundation

@MainActor
class TradingManager: ObservableObject {
    @Published var todaysPnL: Double = 250.45
    @Published var todaysChangePercent: Double = 12.8
    @Published var winRate: Double = 73.5
    @Published var activeTrades: [Trade] = []
    @Published var pendingOrders: [Order] = []
    @Published var currentGoldPrice: Double = 2045.67
    @Published var goldPriceChange: Double = 15.23
    @Published var goldPriceChangePercent: Double = 0.75
    @Published var weeklyPnL: Double = 1250.75
    @Published var weeklyChangePercent: Double = 8.4
    @Published var monthlyPnL: Double = 3450.25
    @Published var monthlyChangePercent: Double = 15.7
    
    init() {
        generateSampleData()
    }
    
    func refreshData() async {
        // Simulate data refresh
        try? await Task.sleep(for: .seconds(0.5))
        
        // Simulate price updates
        currentGoldPrice += Double.random(in: -5...5)
        goldPriceChange = Double.random(in: -20...20)
        goldPriceChangePercent = (goldPriceChange / currentGoldPrice) * 100
        
        // Update P&L with small variations
        todaysPnL += Double.random(in: -10...10)
        todaysChangePercent = Double.random(in: -2...2)
    }
    
    private func generateSampleData() {
        // Generate sample trades
        activeTrades = [
            Trade(
                id: "1",
                symbol: "XAUUSD",
                side: .buy,
                size: 0.1,
                entryPrice: 2040.25,
                currentPrice: 2045.67,
                pnl: 54.2,
                timestamp: Date().addingTimeInterval(-3600)
            ),
            Trade(
                id: "2",
                symbol: "XAUUSD",
                side: .sell,
                size: 0.05,
                entryPrice: 2050.10,
                currentPrice: 2045.67,
                pnl: 22.15,
                timestamp: Date().addingTimeInterval(-1800)
            )
        ]
        
        // Generate sample orders
        pendingOrders = [
            Order(
                id: "1",
                symbol: "XAUUSD",
                side: .buy,
                size: 0.1,
                orderPrice: 2030.00,
                orderType: .limit,
                timestamp: Date().addingTimeInterval(-900)
            )
        ]
    }
}

struct Trade: Identifiable, Codable {
    let id: String
    let symbol: String
    let side: TradeSide
    let size: Double
    let entryPrice: Double
    let currentPrice: Double
    let pnl: Double
    let timestamp: Date
}

struct Order: Identifiable, Codable {
    let id: String
    let symbol: String
    let side: TradeSide
    let size: Double
    let orderPrice: Double
    let orderType: OrderType
    let timestamp: Date
}

enum TradeSide: String, CaseIterable, Codable {
    case buy = "Buy"
    case sell = "Sell"
}

enum OrderType: String, CaseIterable, Codable {
    case market = "Market"
    case limit = "Limit"
    case stop = "Stop"
    case stopLimit = "Stop Limit"
}