//
//  PlaybookEngine.swift
//  Planet ProTrader
//
//  Created by AI Assistant
//

import SwiftUI
import Foundation
import Combine

@MainActor
class LegendaryPlaybookEngine: ObservableObject {
    @Published var trades: [PlaybookTrade] = []
    @Published var journalEntries: [JournalEntry] = []
    @Published var isAutoLogging = true
    @Published var isLoading = false
    @Published var errorMessage: String?

    init() {
        loadSampleData()
    }

    // MARK: - Computed Statistics (Safe)

    var winRate: Double {
        guard !trades.isEmpty else { return 0.0 }
        let wins = trades.filter { $0.result == .win }.count
        return Double(wins) / Double(trades.count)
    }

    var profitFactor: Double {
        let grossProfit = trades.filter { $0.result == .win }.reduce(0) { $0 + $1.pnl }
        let grossLoss = abs(trades.filter { $0.result == .loss }.reduce(0) { $0 + $1.pnl })
        return grossLoss == 0 ? (grossProfit > 0 ? Double.infinity : 0) : grossProfit / grossLoss
    }

    var averageRMultiple: Double {
        guard !trades.isEmpty else { return 0.0 }
        return trades.reduce(0) { $0 + $1.rMultiple } / Double(trades.count)
    }

    var eliteTrades: Int {
        return trades.filter { $0.grade == .elite }.count
    }

    // MARK: - Trade Management (Safe)

    func addTrade(_ trade: PlaybookTrade) {
        trades.append(trade)

        if isAutoLogging {
            generateJournalEntry(for: trade)
        }

        // Trigger haptic feedback for user confirmation
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
    }

    func updateTrade(_ trade: PlaybookTrade) {
        guard let index = trades.firstIndex(where: { $0.id == trade.id }) else { return }
        trades[index] = trade
    }

    func deleteTrade(_ trade: PlaybookTrade) {
        trades.removeAll { $0.id == trade.id }
        journalEntries.removeAll { $0.title.contains(trade.symbol) }
    }

    // MARK: - Journal Management

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
        Exit: \(trade.exitPrice.map { String(format: "%.2f", $0) } ?? "N/A")
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
        // Safe random selection
        return lessons.randomElement() ?? lessons[0]
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

    // MARK: - Data Loading

    private func loadSampleData() {
        isLoading = true

        // Simulate data loading delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.trades = [
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
                    emotionalRating: 4
                ),
                PlaybookTrade(
                    id: UUID().uuidString,
                    symbol: "XAUUSD",
                    direction: .buy,
                    entryPrice: 2672.00,
                    exitPrice: 2669.50,
                    stopLoss: 2665.00,
                    takeProfit: 2685.00,
                    lotSize: 0.01,
                    pnl: -25.00,
                    rMultiple: -0.36,
                    result: .loss,
                    grade: .average,
                    setupDescription: "False breakout - market structure analysis needed",
                    emotionalState: "Disappointed but controlled",
                    timestamp: Date().addingTimeInterval(-14400),
                    emotionalRating: 3
                ),
                PlaybookTrade(
                    id: UUID().uuidString,
                    symbol: "XAUUSD",
                    direction: .sell,
                    entryPrice: 2678.75,
                    exitPrice: nil,
                    stopLoss: 2684.00,
                    takeProfit: 2665.00,
                    lotSize: 0.01,
                    pnl: 0.0,
                    rMultiple: 0.0,
                    result: .running,
                    grade: .good,
                    setupDescription: "Current running trade - nice rejection at resistance",
                    emotionalState: "Confident and patient",
                    timestamp: Date().addingTimeInterval(-1800),
                    emotionalRating: 4
                )
            ]

            self.journalEntries = [
                JournalEntry(
                    id: UUID().uuidString,
                    timestamp: Date(),
                    type: .dailyReview,
                    title: "Daily Review - Excellent Progress",
                    content: "Today I executed high-quality setups with excellent discipline. The Mark Douglas principles are becoming second nature. Need to continue focusing on process over outcomes.",
                    emotionalRating: 5,
                    markDouglasLesson: "Consistency comes from within, not from the markets"
                ),
                JournalEntry(
                    id: UUID().uuidString,
                    timestamp: Date().addingTimeInterval(-3600),
                    type: .tradeAnalysis,
                    title: "XAUUSD Trade Analysis",
                    content: "Perfect execution on the London open setup. Entry was precise, risk management followed exactly as planned. This is the standard I need to maintain.",
                    emotionalRating: 5,
                    markDouglasLesson: "Trust your edge and execute consistently"
                ),
                JournalEntry(
                    id: UUID().uuidString,
                    timestamp: Date().addingTimeInterval(-14400),
                    type: .psychologyNote,
                    title: "Learning from Loss",
                    content: "The false breakout loss was handled well emotionally. No revenge trading, stuck to the plan. This shows psychological progress and maturity in my approach.",
                    emotionalRating: 4,
                    markDouglasLesson: "Every trade outcome is independent - this doesn't predict the next trade"
                )
            ]

            self.isLoading = false
        }
    }
}