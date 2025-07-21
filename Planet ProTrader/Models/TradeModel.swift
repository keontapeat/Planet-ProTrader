//
//  TradeModel.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 7/18/25.
//

import Foundation
import SwiftUI

// MARK: - Trade Model

struct TradeModel: Identifiable, Codable {
    let id: UUID
    let botId: UUID
    let symbol: String
    let entryPrice: Double
    let exitPrice: Double?
    let stopLoss: Double?
    let takeProfit: Double?
    let lotSize: Double
    let profit: Double
    let tradeDirection: MasterSharedTypes.TradeDirection
    let tradeStartTime: Date
    let tradeEndTime: Date?
    let confidenceScore: Double
    let screenshotBeforeUrl: String?
    let screenshotDuringUrl: String?
    let screenshotAfterUrl: String?
    let tradeReasoning: String?
    let tradeGrade: MasterSharedTypes.TradeGrade
    let marketSession: MarketSession?
    let tradeStatus: MasterSharedTypes.TradeStatus
    let createdAt: Date
    let updatedAt: Date
    
    // MARK: - Supporting Enums
    
    enum MarketSession: String, Codable, CaseIterable {
        case sydney = "SYDNEY"
        case tokyo = "TOKYO"
        case london = "LONDON"
        case newYork = "NEWYORK"
        
        var displayName: String {
            switch self {
            case .sydney: return "Sydney"
            case .tokyo: return "Tokyo"
            case .london: return "London"
            case .newYork: return "New York"
            }
        }
        
        var color: Color {
            switch self {
            case .sydney: return .blue
            case .tokyo: return .red
            case .london: return .green
            case .newYork: return .orange
            }
        }
        
        var timezone: String {
            switch self {
            case .sydney: return "AEDT"
            case .tokyo: return "JST"
            case .london: return "GMT"
            case .newYork: return "EST"
            }
        }
    }
    
    // MARK: - Computed Properties
    
    var isOpen: Bool {
        tradeStatus == .open
    }
    
    var isClosed: Bool {
        tradeStatus == .closed
    }
    
    var isWinning: Bool {
        profit > 0
    }
    
    var isLosing: Bool {
        profit < 0
    }
    
    var tradeDuration: TimeInterval? {
        guard let endTime = tradeEndTime else { return nil }
        return endTime.timeIntervalSince(tradeStartTime)
    }
    
    var tradeDurationString: String {
        guard let duration = tradeDuration else { return "Ongoing" }
        let hours = Int(duration) / 3600
        let minutes = (Int(duration) % 3600) / 60
        let seconds = Int(duration) % 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m \(seconds)s"
        } else if minutes > 0 {
            return "\(minutes)m \(seconds)s"
        } else {
            return "\(seconds)s"
        }
    }
    
    var formattedProfit: String {
        let sign = profit >= 0 ? "+" : ""
        return "\(sign)$\(String(format: "%.2f", profit))"
    }
    
    var formattedLotSize: String {
        String(format: "%.2f", lotSize)
    }
    
    var formattedConfidence: String {
        String(format: "%.1f%%", confidenceScore)
    }
    
    var profitColor: Color {
        if profit > 0 {
            return .green
        } else if profit < 0 {
            return .red
        } else {
            return .gray
        }
    }
    
    var riskRewardRatio: Double {
        guard let sl = stopLoss, let tp = takeProfit else { return 0.0 }
        let risk = abs(entryPrice - sl)
        let reward = abs(tp - entryPrice)
        return risk > 0 ? reward / risk : 0.0
    }
    
    var formattedRiskReward: String {
        String(format: "1:%.1f", riskRewardRatio)
    }
    
    var pipsGained: Double {
        guard let exitPrice = exitPrice else { return 0.0 }
        let pipDifference = abs(exitPrice - entryPrice)
        return pipDifference * 10000 // Convert to pips for XAUUSD
    }
    
    var formattedPips: String {
        String(format: "%.1f pips", pipsGained)
    }
    
    // MARK: - Initializers
    
    init(
        id: UUID = UUID(),
        botId: UUID,
        symbol: String = "XAUUSD",
        entryPrice: Double,
        exitPrice: Double? = nil,
        stopLoss: Double? = nil,
        takeProfit: Double? = nil,
        lotSize: Double,
        profit: Double = 0.0,
        tradeDirection: MasterSharedTypes.TradeDirection,
        tradeStartTime: Date = Date(),
        tradeEndTime: Date? = nil,
        confidenceScore: Double,
        screenshotBeforeUrl: String? = nil,
        screenshotDuringUrl: String? = nil,
        screenshotAfterUrl: String? = nil,
        tradeReasoning: String? = nil,
        tradeGrade: MasterSharedTypes.TradeGrade = .average,
        marketSession: MarketSession? = nil,
        tradeStatus: MasterSharedTypes.TradeStatus = .open,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.botId = botId
        self.symbol = symbol
        self.entryPrice = entryPrice
        self.exitPrice = exitPrice
        self.stopLoss = stopLoss
        self.takeProfit = takeProfit
        self.lotSize = lotSize
        self.profit = profit
        self.tradeDirection = tradeDirection
        self.tradeStartTime = tradeStartTime
        self.tradeEndTime = tradeEndTime
        self.confidenceScore = confidenceScore
        self.screenshotBeforeUrl = screenshotBeforeUrl
        self.screenshotDuringUrl = screenshotDuringUrl
        self.screenshotAfterUrl = screenshotAfterUrl
        self.tradeReasoning = tradeReasoning
        self.tradeGrade = tradeGrade
        self.marketSession = marketSession
        self.tradeStatus = tradeStatus
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    // MARK: - Helper Methods
    
    func closeTradeWith(exitPrice: Double, profit: Double) -> TradeModel {
        TradeModel(
            id: self.id,
            botId: self.botId,
            symbol: self.symbol,
            entryPrice: self.entryPrice,
            exitPrice: exitPrice,
            stopLoss: self.stopLoss,
            takeProfit: self.takeProfit,
            lotSize: self.lotSize,
            profit: profit,
            tradeDirection: self.tradeDirection,
            tradeStartTime: self.tradeStartTime,
            tradeEndTime: Date(),
            confidenceScore: self.confidenceScore,
            screenshotBeforeUrl: self.screenshotBeforeUrl,
            screenshotDuringUrl: self.screenshotDuringUrl,
            screenshotAfterUrl: self.screenshotAfterUrl,
            tradeReasoning: self.tradeReasoning,
            tradeGrade: self.tradeGrade,
            marketSession: self.marketSession,
            tradeStatus: .closed,
            createdAt: self.createdAt,
            updatedAt: Date()
        )
    }
    
    func updateScreenshots(
        beforeUrl: String? = nil,
        duringUrl: String? = nil,
        afterUrl: String? = nil
    ) -> TradeModel {
        TradeModel(
            id: self.id,
            botId: self.botId,
            symbol: self.symbol,
            entryPrice: self.entryPrice,
            exitPrice: self.exitPrice,
            stopLoss: self.stopLoss,
            takeProfit: self.takeProfit,
            lotSize: self.lotSize,
            profit: self.profit,
            tradeDirection: self.tradeDirection,
            tradeStartTime: self.tradeStartTime,
            tradeEndTime: self.tradeEndTime,
            confidenceScore: self.confidenceScore,
            screenshotBeforeUrl: beforeUrl ?? self.screenshotBeforeUrl,
            screenshotDuringUrl: duringUrl ?? self.screenshotDuringUrl,
            screenshotAfterUrl: afterUrl ?? self.screenshotAfterUrl,
            tradeReasoning: self.tradeReasoning,
            tradeGrade: self.tradeGrade,
            marketSession: self.marketSession,
            tradeStatus: self.tradeStatus,
            createdAt: self.createdAt,
            updatedAt: Date()
        )
    }
    
    // MARK: - Conversion Methods
    
    func toDatabaseTrade() -> DatabaseTrade {
        DatabaseTrade(
            id: id,
            botId: botId,
            userId: nil,
            symbol: symbol,
            entryPrice: entryPrice,
            exitPrice: exitPrice,
            stopLoss: stopLoss,
            takeProfit: takeProfit,
            lotSize: lotSize,
            profit: profit,
            tradeDirection: tradeDirection.rawValue,
            tradeStartTime: tradeStartTime,
            tradeEndTime: tradeEndTime,
            tradeDurationSeconds: tradeDuration.map { Int($0) },
            screenshotBeforeUrl: screenshotBeforeUrl,
            screenshotDuringUrl: screenshotDuringUrl,
            screenshotAfterUrl: screenshotAfterUrl,
            confidenceScore: confidenceScore,
            flippedPercentage: 0.0,
            newsFilterUsed: false,
            tradeReasoning: tradeReasoning,
            tradeGrade: tradeGrade.rawValue,
            marketSession: marketSession?.rawValue,
            tradeStatus: tradeStatus.rawValue,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
    
    static func fromDatabaseTrade(_ dbTrade: DatabaseTrade) -> TradeModel {
        TradeModel(
            id: dbTrade.id,
            botId: dbTrade.botId,
            symbol: dbTrade.symbol,
            entryPrice: dbTrade.entryPrice,
            exitPrice: dbTrade.exitPrice,
            stopLoss: dbTrade.stopLoss,
            takeProfit: dbTrade.takeProfit,
            lotSize: dbTrade.lotSize,
            profit: dbTrade.profit,
            tradeDirection: MasterSharedTypes.TradeDirection(rawValue: dbTrade.tradeDirection) ?? .buy,
            tradeStartTime: dbTrade.tradeStartTime,
            tradeEndTime: dbTrade.tradeEndTime,
            confidenceScore: dbTrade.confidenceScore,
            screenshotBeforeUrl: dbTrade.screenshotBeforeUrl,
            screenshotDuringUrl: dbTrade.screenshotDuringUrl,
            screenshotAfterUrl: dbTrade.screenshotAfterUrl,
            tradeReasoning: dbTrade.tradeReasoning,
            tradeGrade: MasterSharedTypes.TradeGrade(rawValue: dbTrade.tradeGrade) ?? .average,
            marketSession: dbTrade.marketSession.flatMap { MarketSession(rawValue: $0) },
            tradeStatus: MasterSharedTypes.TradeStatus(rawValue: dbTrade.tradeStatus) ?? .open,
            createdAt: dbTrade.createdAt,
            updatedAt: dbTrade.updatedAt
        )
    }
}

// MARK: - Sample Data

extension TradeModel {
    static let sampleTrades: [TradeModel] = [
        TradeModel(
            botId: UUID(),
            entryPrice: 2455.30,
            exitPrice: 2458.75,
            stopLoss: 2452.10,
            takeProfit: 2460.00,
            lotSize: 0.10,
            profit: 345.00,
            tradeDirection: .buy,
            tradeStartTime: Date().addingTimeInterval(-3600),
            tradeEndTime: Date().addingTimeInterval(-1800),
            confidenceScore: 87.5,
            tradeReasoning: "London session breakout with strong volume confirmation",
            tradeGrade: .elite,
            marketSession: .london,
            tradeStatus: .closed
        ),
        TradeModel(
            botId: UUID(),
            entryPrice: 2462.80,
            exitPrice: 2460.15,
            stopLoss: 2465.50,
            takeProfit: 2458.00,
            lotSize: 0.05,
            profit: -132.50,
            tradeDirection: .sell,
            tradeStartTime: Date().addingTimeInterval(-7200),
            tradeEndTime: Date().addingTimeInterval(-5400),
            confidenceScore: 72.0,
            tradeReasoning: "Failed breakout, quick reversal",
            tradeGrade: .poor,
            marketSession: .newYork,
            tradeStatus: .closed
        ),
        TradeModel(
            botId: UUID(),
            entryPrice: 2459.45,
            stopLoss: 2456.20,
            takeProfit: 2465.80,
            lotSize: 0.08,
            profit: 0.0,
            tradeDirection: .buy,
            tradeStartTime: Date().addingTimeInterval(-1800),
            confidenceScore: 91.2,
            tradeReasoning: "ICT Power of 3 setup, targeting Asian high",
            tradeGrade: .good,
            marketSession: .london,
            tradeStatus: .open
        )
    ]
}

// MARK: - Preview

#Preview {
    VStack(spacing: 20) {
        Text("✅ Trade Model - Using MasterSharedTypes")
            .font(.headline)
            .foregroundColor(.green)
        
        ForEach(TradeModel.sampleTrades) { trade in
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(trade.symbol)
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    HStack {
                        Image(systemName: trade.tradeDirection.systemImage)
                            .foregroundColor(trade.tradeDirection.color)
                        Text(trade.tradeDirection.displayName)
                            .font(.subheadline)
                            .foregroundColor(trade.tradeDirection.color)
                    }
                }
                
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Entry: \(String(format: "%.2f", trade.entryPrice))")
                        if let exitPrice = trade.exitPrice {
                            Text("Exit: \(String(format: "%.2f", exitPrice))")
                        }
                        Text("Lot: \(trade.formattedLotSize)")
                    }
                    .font(.caption)
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text(trade.formattedProfit)
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(trade.profitColor)
                        
                        Text(trade.formattedConfidence)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(trade.tradeGrade.color)
                            Text("\(trade.tradeGrade.rawValue)")
                                .font(.caption)
                                .foregroundColor(trade.tradeGrade.color)
                        }
                    }
                }
                
                if let reasoning = trade.tradeReasoning {
                    Text(reasoning)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
    }
    .padding()
}