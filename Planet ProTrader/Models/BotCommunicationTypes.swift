//
//  BotCommunicationTypes.swift
//  Planet ProTrader
//
//  Created by AI Assistant on 1/25/25.
//

import Foundation
import SwiftUI

// MARK: - Bot Communication Types

enum BotCommunicationTypes {
    
    // MARK: - Bot Chat Message
    
    struct BotChatMessage: Identifiable, Codable {
        let id: UUID
        let botId: String
        let botName: String
        let content: String
        let timestamp: Date
        let messageType: MessageType
        let confidence: Double
        let topic: String
        let reactionCount: Int
        let isHighlighted: Bool
        let isFromUser: Bool
        let hasSpecialContent: Bool
        
        enum MessageType: String, Codable, CaseIterable {
            case analysis = "Analysis"
            case prediction = "Prediction"
            case warning = "Warning"
            case celebration = "Celebration"
            case discussion = "Discussion"
            case insight = "Insight"
            
            var color: Color {
                switch self {
                case .analysis: return .blue
                case .prediction: return .purple
                case .warning: return .orange
                case .celebration: return .green
                case .discussion: return .gray
                case .insight: return DesignSystem.primaryGold
                }
            }
            
            var icon: String {
                switch self {
                case .analysis: return "magnifyingglass.circle"
                case .prediction: return "crystal.ball"
                case .warning: return "exclamationmark.triangle"
                case .celebration: return "party.popper"
                case .discussion: return "bubble.left.and.bubble.right"
                case .insight: return "lightbulb"
                }
            }
        }
        
        init(
            id: UUID = UUID(),
            botId: String,
            botName: String,
            content: String,
            timestamp: Date = Date(),
            messageType: MessageType = .discussion,
            confidence: Double = 0.5,
            topic: String = "General",
            reactionCount: Int = 0,
            isHighlighted: Bool = false,
            isFromUser: Bool = false,
            hasSpecialContent: Bool = false
        ) {
            self.id = id
            self.botId = botId
            self.botName = botName
            self.content = content
            self.timestamp = timestamp
            self.messageType = messageType
            self.confidence = confidence
            self.topic = topic
            self.reactionCount = reactionCount
            self.isHighlighted = isHighlighted
            self.isFromUser = isFromUser
            self.hasSpecialContent = hasSpecialContent
        }
        
        static let sampleMessages: [BotChatMessage] = [
            BotChatMessage(
                botId: "bot_001",
                botName: "Elite Scalper",
                content: "Strong bullish momentum detected on XAUUSD. RSI showing oversold conditions with potential reversal.",
                messageType: .analysis,
                confidence: 0.87,
                topic: "Market Analysis",
                reactionCount: 5
            ),
            BotChatMessage(
                botId: "bot_002", 
                botName: "Swing Master",
                content: "Congratulations! Successfully closed position with +245 pips profit. Risk management protocols worked perfectly.",
                messageType: .celebration,
                confidence: 1.0,
                topic: "Trade Results",
                reactionCount: 12,
                isHighlighted: true
            )
        ]
    }
    
    // MARK: - Bot Discussion
    
    struct BotDiscussion: Identifiable, Codable {
        let id: UUID
        let title: String
        let participants: [String]
        let messages: [BotChatMessage]
        let createdAt: Date
        let isActive: Bool
        let category: DiscussionCategory
        
        enum DiscussionCategory: String, CaseIterable, Codable {
            case marketAnalysis = "Market Analysis"
            case tradeReview = "Trade Review"
            case strategy = "Strategy"
            case learning = "Learning"
            case general = "General"
            
            var color: Color {
                switch self {
                case .marketAnalysis: return .blue
                case .tradeReview: return .green
                case .strategy: return .purple
                case .learning: return .orange
                case .general: return .gray
                }
            }
            
            var icon: String {
                switch self {
                case .marketAnalysis: return "chart.line.uptrend.xyaxis"
                case .tradeReview: return "checkmark.circle.fill"
                case .strategy: return "brain.head.profile"
                case .learning: return "graduationcap.fill"
                case .general: return "bubble.left.and.bubble.right.fill"
                }
            }
        }
        
        init(
            id: UUID = UUID(),
            title: String,
            participants: [String],
            messages: [BotChatMessage] = [],
            createdAt: Date = Date(),
            isActive: Bool = true,
            category: DiscussionCategory = .general
        ) {
            self.id = id
            self.title = title
            self.participants = participants
            self.messages = messages
            self.createdAt = createdAt
            self.isActive = isActive
            self.category = category
        }
        
        var lastMessage: BotChatMessage? {
            messages.sorted { $0.timestamp > $1.timestamp }.first
        }
        
        var messageCount: Int {
            messages.count
        }
        
        static let sampleDiscussions: [BotDiscussion] = [
            BotDiscussion(
                title: "XAUUSD Analysis - Bullish Breakout",
                participants: ["Elite Scalper", "Swing Master", "Grid Bot"],
                messages: BotChatMessage.sampleMessages,
                category: .marketAnalysis
            ),
            BotDiscussion(
                title: "Risk Management Best Practices",
                participants: ["Risk Manager Bot", "Conservative Trader"],
                category: .strategy
            )
        ]
    }
    
    // MARK: - Bot Performance Metrics
    
    struct BotPerformanceMetrics: Identifiable, Codable {
        let id: UUID
        let botId: String
        let botName: String
        let totalTrades: Int
        let winningTrades: Int
        let losingTrades: Int
        let totalProfit: Double
        let averageWin: Double
        let averageLoss: Double
        let winRate: Double
        let profitFactor: Double
        let maxDrawdown: Double
        let sharpeRatio: Double
        let lastUpdated: Date
        
        init(
            id: UUID = UUID(),
            botId: String,
            botName: String,
            totalTrades: Int,
            winningTrades: Int,
            losingTrades: Int,
            totalProfit: Double,
            averageWin: Double,
            averageLoss: Double,
            winRate: Double,
            profitFactor: Double,
            maxDrawdown: Double,
            sharpeRatio: Double,
            lastUpdated: Date = Date()
        ) {
            self.id = id
            self.botId = botId
            self.botName = botName
            self.totalTrades = totalTrades
            self.winningTrades = winningTrades
            self.losingTrades = losingTrades
            self.totalProfit = totalProfit
            self.averageWin = averageWin
            self.averageLoss = averageLoss
            self.winRate = winRate
            self.profitFactor = profitFactor
            self.maxDrawdown = maxDrawdown
            self.sharpeRatio = sharpeRatio
            self.lastUpdated = lastUpdated
        }
        
        var formattedWinRate: String {
            String(format: "%.1f%%", winRate * 100)
        }
        
        var formattedProfitFactor: String {
            String(format: "%.2f", profitFactor)
        }
        
        var formattedTotalProfit: String {
            String(format: "$%.2f", totalProfit)
        }
        
        static let sampleMetrics: [BotPerformanceMetrics] = [
            BotPerformanceMetrics(
                botId: "bot_001",
                botName: "Elite Scalper",
                totalTrades: 156,
                winningTrades: 127,
                losingTrades: 29,
                totalProfit: 2847.50,
                averageWin: 35.20,
                averageLoss: -18.70,
                winRate: 0.814,
                profitFactor: 2.65,
                maxDrawdown: -345.20,
                sharpeRatio: 1.87
            ),
            BotPerformanceMetrics(
                botId: "bot_002",
                botName: "Swing Master", 
                totalTrades: 89,
                winningTrades: 67,
                losingTrades: 22,
                totalProfit: 1923.80,
                averageWin: 42.10,
                averageLoss: -21.40,
                winRate: 0.753,
                profitFactor: 2.12,
                maxDrawdown: -287.60,
                sharpeRatio: 1.64
            )
        ]
    }
    
    // MARK: - Bot Status
    
    enum BotStatus: String, CaseIterable, Codable {
        case active = "Active"
        case inactive = "Inactive"
        case learning = "Learning"
        case analyzing = "Analyzing"
        case trading = "Trading"
        case paused = "Paused"
        case error = "Error"
        
        var color: Color {
            switch self {
            case .active, .trading: return .green
            case .inactive, .paused: return .gray
            case .learning, .analyzing: return .blue
            case .error: return .red
            }
        }
        
        var icon: String {
            switch self {
            case .active: return "play.circle.fill"
            case .inactive: return "pause.circle.fill"
            case .learning: return "brain.head.profile"
            case .analyzing: return "magnifyingglass.circle"
            case .trading: return "arrow.up.arrow.down.circle.fill"
            case .paused: return "pause.circle"
            case .error: return "exclamationmark.triangle.fill"
            }
        }
    }
    
    // MARK: - Bot Configuration
    
    struct BotConfiguration: Codable {
        let botId: String
        let name: String
        let strategy: String
        let riskLevel: Double
        let maxDrawdown: Double
        let tradingHours: String
        let symbols: [String]
        let lotSize: Double
        let stopLoss: Double
        let takeProfit: Double
        let isAutoTrading: Bool
        let notificationsEnabled: Bool
        
        init(
            botId: String,
            name: String,
            strategy: String,
            riskLevel: Double = 0.02,
            maxDrawdown: Double = 0.05,
            tradingHours: String = "24/7",
            symbols: [String] = ["XAUUSD"],
            lotSize: Double = 0.01,
            stopLoss: Double = 20.0,
            takeProfit: Double = 30.0,
            isAutoTrading: Bool = false,
            notificationsEnabled: Bool = true
        ) {
            self.botId = botId
            self.name = name
            self.strategy = strategy
            self.riskLevel = riskLevel
            self.maxDrawdown = maxDrawdown
            self.tradingHours = tradingHours
            self.symbols = symbols
            self.lotSize = lotSize
            self.stopLoss = stopLoss
            self.takeProfit = takeProfit
            self.isAutoTrading = isAutoTrading
            self.notificationsEnabled = notificationsEnabled
        }
        
        static let sampleConfigurations: [BotConfiguration] = [
            BotConfiguration(
                botId: "bot_001",
                name: "Elite Scalper",
                strategy: "Scalping",
                riskLevel: 0.01,
                symbols: ["XAUUSD", "EURUSD"]
            ),
            BotConfiguration(
                botId: "bot_002",
                name: "Swing Master",
                strategy: "Swing Trading",
                riskLevel: 0.03,
                symbols: ["GBPUSD", "USDJPY"]
            )
        ]
    }
    
    // MARK: - Bot Alert
    
    struct BotAlert: Identifiable, Codable {
        let id: UUID
        let botId: String
        let botName: String
        let alertType: AlertType
        let message: String
        let timestamp: Date
        let priority: Priority
        let isRead: Bool
        let actionRequired: Bool
        
        enum AlertType: String, CaseIterable, Codable {
            case tradeOpportunity = "Trade Opportunity"
            case riskWarning = "Risk Warning"
            case systemError = "System Error"
            case performanceUpdate = "Performance Update"
            case marketNews = "Market News"
            
            var icon: String {
                switch self {
                case .tradeOpportunity: return "chart.line.uptrend.xyaxis"
                case .riskWarning: return "exclamationmark.triangle"
                case .systemError: return "xmark.circle"
                case .performanceUpdate: return "chart.bar"
                case .marketNews: return "newspaper"
                }
            }
        }
        
        enum Priority: String, CaseIterable, Codable {
            case low = "Low"
            case medium = "Medium"
            case high = "High"
            case critical = "Critical"
            
            var color: Color {
                switch self {
                case .low: return .green
                case .medium: return .orange
                case .high: return .red
                case .critical: return .purple
                }
            }
        }
        
        init(
            id: UUID = UUID(),
            botId: String,
            botName: String,
            alertType: AlertType,
            message: String,
            timestamp: Date = Date(),
            priority: Priority = .medium,
            isRead: Bool = false,
            actionRequired: Bool = false
        ) {
            self.id = id
            self.botId = botId
            self.botName = botName
            self.alertType = alertType
            self.message = message
            self.timestamp = timestamp
            self.priority = priority
            self.isRead = isRead
            self.actionRequired = actionRequired
        }
        
        static let sampleAlerts: [BotAlert] = [
            BotAlert(
                botId: "bot_001",
                botName: "Elite Scalper",
                alertType: .tradeOpportunity,
                message: "Strong buy signal detected on XAUUSD with 87% confidence",
                priority: .high,
                actionRequired: true
            ),
            BotAlert(
                botId: "bot_002",
                botName: "Risk Manager",
                alertType: .riskWarning,
                message: "Daily drawdown limit approaching: 4.2% of 5% maximum",
                priority: .medium
            )
        ]
    }
}

// MARK: - Performance Extension

extension BotCommunicationTypes.BotPerformanceMetrics {
    var performanceGrade: String {
        switch winRate {
        case 0.8...: return "Elite"
        case 0.7..<0.8: return "Excellent"
        case 0.6..<0.7: return "Good"
        case 0.5..<0.6: return "Average"
        default: return "Needs Improvement"
        }
    }
    
    var gradeColor: Color {
        switch performanceGrade {
        case "Elite": return DesignSystem.primaryGold
        case "Excellent": return .green
        case "Good": return .blue
        case "Average": return .orange
        default: return .red
        }
    }
}

#Preview {
    VStack {
        Text("Bot Communication Types")
            .font(.title.bold())
        
        VStack(alignment: .leading, spacing: 8) {
            Text("Available Types:")
                .font(.headline)
            
            Text("• BotChatMessage")
            Text("• BotDiscussion") 
            Text("• BotPerformanceMetrics")
            Text("• BotStatus")
            Text("• BotConfiguration")
            Text("• BotAlert")
        }
        .font(.caption)
        .foregroundColor(.secondary)
    }
    .padding()
}