//
//  BotVoiceNoteModel.swift
//  Planet ProTrader
//
//  Created by AI Assistant on 1/25/25.
//

import SwiftUI
import Foundation

struct BotVoiceNote: Identifiable, Codable {
    let id = UUID()
    let botId: String
    let botName: String
    let content: String
    let category: Category
    let priority: Priority
    let timestamp: Date
    let duration: TimeInterval
    var reactions: [PlayerReaction] = []
    
    init(botId: String, botName: String, content: String, category: Category, priority: Priority = .medium, duration: TimeInterval = 10.0) {
        self.botId = botId
        self.botName = botName
        self.content = content
        self.category = category
        self.priority = priority
        self.timestamp = Date()
        self.duration = duration
    }
    
    // MARK: - Voice Note Categories
    enum Category: String, CaseIterable, Codable {
        case tradeAlert = "tradeAlert"
        case warning = "warning"
        case celebration = "celebration"
        case performance = "performance"
        case coaching = "coaching"
        case market = "market"
        case system = "system"
        
        var displayName: String {
            switch self {
            case .tradeAlert: return "🚨 Trade Alert"
            case .warning: return "⚠️ Warning"
            case .celebration: return "🎉 Celebration"
            case .performance: return "📊 Performance"
            case .coaching: return "🎯 Coaching"
            case .market: return "📈 Market"
            case .system: return "⚙️ System"
            }
        }
        
        var emoji: String {
            switch self {
            case .tradeAlert: return "🚨"
            case .warning: return "⚠️"
            case .celebration: return "🎉"
            case .performance: return "📊"
            case .coaching: return "🎯"
            case .market: return "📈"
            case .system: return "⚙️"
            }
        }
        
        var color: Color {
            switch self {
            case .tradeAlert: return .red
            case .warning: return .orange
            case .celebration: return .yellow
            case .performance: return .blue
            case .coaching: return .green
            case .market: return .purple
            case .system: return .gray
            }
        }
    }
    
    // MARK: - Priority Levels
    enum Priority: String, CaseIterable, Codable {
        case low = "low"
        case medium = "medium"
        case high = "high"
        case urgent = "urgent"
        
        var displayName: String {
            switch self {
            case .low: return "Low"
            case .medium: return "Medium"
            case .high: return "High"
            case .urgent: return "🚨 Urgent"
            }
        }
        
        var color: Color {
            switch self {
            case .low: return .green
            case .medium: return .blue
            case .high: return .orange
            case .urgent: return .red
            }
        }
    }
    
    // MARK: - Player Reactions
    struct PlayerReaction: Codable, Identifiable {
        let id = UUID()
        let type: ReactionType
        let timestamp: Date = Date()
        
        enum ReactionType: String, CaseIterable, Codable {
            case love = "love"
            case fire = "fire"
            case rocket = "rocket"
            case money = "money"
            case surprised = "surprised"
            case worried = "worried"
            case thumbsUp = "thumbsUp"
            case clap = "clap"
            
            var emoji: String {
                switch self {
                case .love: return "❤️"
                case .fire: return "🔥"
                case .rocket: return "🚀"
                case .money: return "💰"
                case .surprised: return "😱"
                case .worried: return "😰"
                case .thumbsUp: return "👍"
                case .clap: return "👏"
                }
            }
        }
    }
    
    // MARK: - Sample Data
    static var sampleVoiceNotes: [BotVoiceNote] {
        [
            BotVoiceNote(
                botId: "gold-rush-alpha",
                botName: "Gold Rush Alpha",
                content: "🎯 Perfect entry point detected! Gold is showing strong bullish momentum at $2,045. This could be your winning trade!",
                category: .tradeAlert,
                priority: .urgent,
                duration: 15.0
            ),
            BotVoiceNote(
                botId: "zeus-thunder",
                botName: "Zeus Thunder",
                content: "⚡ Incredible job! You just nailed that trade for +$47.50 profit! Your timing was absolutely perfect!",
                category: .celebration,
                priority: .high,
                duration: 12.0
            ),
            BotVoiceNote(
                botId: "steady-eddie",
                botName: "Steady Eddie",
                content: "📊 Your win rate is now at 78%! You're showing excellent discipline with your risk management. Keep it up!",
                category: .performance,
                priority: .medium,
                duration: 18.0
            ),
            BotVoiceNote(
                botId: "quantum-leap",
                botName: "Quantum Leap",
                content: "🚀 Market volatility spike detected! Consider reducing position size for the next 10 minutes.",
                category: .warning,
                priority: .high,
                duration: 8.0
            ),
            BotVoiceNote(
                botId: "day-warrior",
                botName: "Day Warrior",
                content: "⚔️ Remember: patience is your weapon. Wait for the perfect setup rather than forcing trades.",
                category: .coaching,
                priority: .medium,
                duration: 14.0
            ),
            BotVoiceNote(
                botId: "market-sage",
                botName: "Market Sage",
                content: "📈 Fed announcement in 30 minutes. Expect increased volatility. Adjust your strategy accordingly.",
                category: .market,
                priority: .urgent,
                duration: 11.0
            )
        ]
    }
}

// MARK: - BotVoiceNoteManager
@MainActor
class BotVoiceNoteManager: ObservableObject {
    @Published var voiceNotes: [BotVoiceNote] = []
    @Published var filteredNotes: [BotVoiceNote] = []
    @Published var currentlyPlayingNote: BotVoiceNote?
    @Published var isPlaying = false
    
    init() {
        loadSampleData()
        filteredNotes = voiceNotes
    }
    
    func loadSampleData() {
        voiceNotes = BotVoiceNote.sampleVoiceNotes
        
        // Add some recent notes with current timestamps
        let recentNotes = [
            BotVoiceNote(
                botId: "game-coach",
                botName: "Game Coach",
                content: "🎮 Welcome to MicroFlip! Your game session is about to begin. Stay focused and trust your instincts!",
                category: .system,
                priority: .medium,
                duration: 13.0
            ),
            BotVoiceNote(
                botId: "profit-tracker",
                botName: "Profit Tracker",
                content: "💰 You're up +$127.50 for the day! Amazing consistency! Keep this momentum going!",
                category: .celebration,
                priority: .high,
                duration: 9.0
            )
        ]
        
        voiceNotes.append(contentsOf: recentNotes)
        voiceNotes.sort { $0.timestamp > $1.timestamp }
    }
    
    func addVoiceNote(_ note: BotVoiceNote) {
        voiceNotes.insert(note, at: 0)
        filteredNotes = voiceNotes
    }
    
    func togglePlayback(_ note: BotVoiceNote) {
        if currentlyPlayingNote?.id == note.id {
            // Stop current playback
            currentlyPlayingNote = nil
            isPlaying = false
        } else {
            // Start new playback
            currentlyPlayingNote = note
            isPlaying = true
            
            // Simulate playback duration
            DispatchQueue.main.asyncAfter(deadline: .now() + note.duration) {
                self.currentlyPlayingNote = nil
                self.isPlaying = false
            }
        }
    }
    
    func addReaction(_ note: BotVoiceNote, reaction: BotVoiceNote.PlayerReaction.ReactionType) {
        if let index = voiceNotes.firstIndex(where: { $0.id == note.id }) {
            let playerReaction = BotVoiceNote.PlayerReaction(type: reaction)
            voiceNotes[index].reactions.append(playerReaction)
            filteredNotes = voiceNotes
        }
    }
    
    func filterNotes(by category: BotVoiceNote.Category? = nil, priority: BotVoiceNote.Priority? = nil) {
        filteredNotes = voiceNotes.filter { note in
            if let category = category, note.category != category {
                return false
            }
            if let priority = priority, note.priority != priority {
                return false
            }
            return true
        }
    }
    
    func clearAllNotes() {
        voiceNotes.removeAll()
        filteredNotes.removeAll()
    }
}

#Preview {
    VStack(spacing: 16) {
        ForEach(BotVoiceNote.sampleVoiceNotes) { note in
            HStack(spacing: 12) {
                // Bot Icon
                ZStack {
                    Circle()
                        .fill(note.category.color.opacity(0.2))
                        .frame(width: 40, height: 40)
                    
                    Text(note.category.emoji)
                        .font(.title3)
                }
                
                // Content
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(note.botName)
                            .font(.subheadline.bold())
                        
                        Spacer()
                        
                        Text(note.priority.displayName)
                            .font(.caption)
                            .foregroundColor(note.priority.color)
                    }
                    
                    Text(note.content)
                        .font(.caption)
                        .lineLimit(2)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        Text("\(Int(note.duration))s")
                            .font(.caption2)
                            .foregroundColor(.blue)
                        
                        Spacer()
                        
                        Text("now")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(12)
        }
    }
    .padding()
}