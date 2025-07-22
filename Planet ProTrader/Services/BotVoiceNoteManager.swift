//
//  BotVoiceNoteManager.swift
//  Planet ProTrader
//
//  Created by AI Assistant on 1/25/25.
//

import SwiftUI
import Foundation
import Combine

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
        voiceNotes = [
            BotVoiceNote(
                botName: "Gold Rush Alpha",
                botId: "gold-rush-alpha",
                audioURL: "",
                transcript: "🎯 Perfect entry point detected! Gold is showing strong bullish momentum at $2,045. This could be your winning trade!",
                duration: 15.0,
                topic: "Trade Alert",
                confidence: 0.95,
                isHighlighted: true,
                tags: ["gold", "bullish", "entry"],
                priority: .tradeAlert
            ),
            BotVoiceNote(
                botName: "Zeus Thunder",
                botId: "zeus-thunder",
                audioURL: "",
                transcript: "⚡ Incredible job! You just nailed that trade for +$47.50 profit! Your timing was absolutely perfect!",
                duration: 12.0,
                topic: "Celebration",
                confidence: 1.0,
                isHighlighted: true,
                tags: ["profit", "success", "timing"],
                priority: .celebration
            ),
            BotVoiceNote(
                botName: "Steady Eddie",
                botId: "steady-eddie",
                audioURL: "",
                transcript: "📊 Your win rate is now at 78%! You're showing excellent discipline with your risk management. Keep it up!",
                duration: 18.0,
                topic: "Performance Review",
                confidence: 0.88,
                tags: ["win-rate", "discipline", "risk-management"],
                priority: .performance
            ),
            BotVoiceNote(
                botName: "Quantum Leap",
                botId: "quantum-leap",
                audioURL: "",
                transcript: "🚀 Market volatility spike detected! Consider reducing position size for the next 10 minutes.",
                duration: 8.0,
                topic: "Risk Warning",
                confidence: 0.92,
                isHighlighted: true,
                tags: ["volatility", "risk", "position-size"],
                priority: .warning
            ),
            BotVoiceNote(
                botName: "Day Warrior",
                botId: "day-warrior",
                audioURL: "",
                transcript: "⚔️ Remember: patience is your weapon. Wait for the perfect setup rather than forcing trades.",
                duration: 14.0,
                topic: "Trading Psychology",
                confidence: 0.85,
                tags: ["patience", "setup", "psychology"],
                priority: .info
            ),
            BotVoiceNote(
                botName: "Market Sage",
                botId: "market-sage",
                audioURL: "",
                transcript: "📈 Fed announcement in 30 minutes. Expect increased volatility. Adjust your strategy accordingly.",
                duration: 11.0,
                topic: "News Alert",
                confidence: 0.98,
                isHighlighted: true,
                tags: ["fed", "news", "volatility"],
                priority: .urgent
            )
        ]
        
        // Add some recent notes with current timestamps
        let recentNotes = [
            BotVoiceNote(
                botName: "Game Coach",
                botId: "game-coach",
                audioURL: "",
                transcript: "🎮 Welcome to MicroFlip! Your game session is about to begin. Stay focused and trust your instincts!",
                duration: 13.0,
                timestamp: Date().addingTimeInterval(-60), // 1 minute ago
                topic: "Game Start",
                confidence: 1.0,
                tags: ["microflip", "game", "focus"],
                priority: .info
            ),
            BotVoiceNote(
                botName: "Profit Tracker",
                botId: "profit-tracker",
                audioURL: "",
                transcript: "💰 You're up +$127.50 for the day! Amazing consistency! Keep this momentum going!",
                duration: 9.0,
                timestamp: Date().addingTimeInterval(-30), // 30 seconds ago
                topic: "Daily P&L",
                confidence: 1.0,
                isHighlighted: true,
                tags: ["profit", "daily", "consistency"],
                priority: .celebration
            )
        ]
        
        voiceNotes.append(contentsOf: recentNotes)
        voiceNotes.sort { $0.timestamp > $1.timestamp }
    }
    
    func addVoiceNote(_ note: BotVoiceNote) {
        voiceNotes.insert(note, at: 0)
        updateFilteredNotes()
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
                if self.currentlyPlayingNote?.id == note.id {
                    self.currentlyPlayingNote = nil
                    self.isPlaying = false
                }
            }
        }
    }
    
    func addReaction(_ note: BotVoiceNote, reaction: BotVoiceNote.PlayerReaction.ReactionType) {
        // Find the note and add reaction
        if let index = voiceNotes.firstIndex(where: { $0.id == note.id }) {
            // Create a new reaction (this would be stored separately in a real app)
            // For now, we'll just trigger a UI update
            objectWillChange.send()
        }
    }
    
    func filterNotes(by priority: BotVoiceNote.VoiceNotePriority? = nil, botId: String? = nil) {
        filteredNotes = voiceNotes.filter { note in
            if let priority = priority, note.priority != priority {
                return false
            }
            if let botId = botId, note.botId != botId {
                return false
            }
            return true
        }
    }
    
    func filterNotesByCategory(_ category: BotVoiceNote.VoiceNotePriority) {
        filteredNotes = voiceNotes.filter { $0.priority == category }
    }
    
    func filterNotesByTimeframe(_ hours: Int) {
        let cutoffDate = Date().addingTimeInterval(-TimeInterval(hours * 3600))
        filteredNotes = voiceNotes.filter { $0.timestamp >= cutoffDate }
    }
    
    func resetFilters() {
        filteredNotes = voiceNotes
    }
    
    private func updateFilteredNotes() {
        if filteredNotes.count == voiceNotes.count - 1 {
            // If we were showing all notes, continue showing all
            filteredNotes = voiceNotes
        }
    }
    
    func clearAllNotes() {
        voiceNotes.removeAll()
        filteredNotes.removeAll()
        currentlyPlayingNote = nil
        isPlaying = false
    }
    
    // MARK: - Game-specific methods
    
    func addGameNote(botName: String, content: String, category: BotVoiceNote.VoiceNotePriority) {
        let note = BotVoiceNote(
            botId: botName.lowercased().replacingOccurrences(of: " ", with: "-"),
            botName: botName,
            content: content,
            category: category
        )
        addVoiceNote(note)
    }
    
    func getNotesForBot(_ botId: String) -> [BotVoiceNote] {
        return voiceNotes.filter { $0.botId == botId }
    }
    
    func getUrgentNotes() -> [BotVoiceNote] {
        return voiceNotes.filter { $0.priority == .urgent || $0.priority == .tradeAlert }
    }
    
    func getTodaysNotes() -> [BotVoiceNote] {
        let today = Calendar.current.startOfDay(for: Date())
        return voiceNotes.filter { Calendar.current.startOfDay(for: $0.timestamp) == today }
    }
}

// MARK: - Extensions

extension BotVoiceNote {
    // Player Reaction types for compatibility
    struct PlayerReaction: Identifiable, Codable {
        let id = UUID()
        let type: ReactionType
        let timestamp = Date()
        
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
    
    // Add computed property for reactions compatibility
    var reactions: [PlayerReaction] {
        return [] // This would be stored separately in a real implementation
    }
}

// MARK: - Preview

#Preview {
    struct PreviewWrapper: View {
        @StateObject private var manager = BotVoiceNoteManager()
        
        var body: some View {
            VStack(spacing: 16) {
                Text("🎙️ Bot Voice Notes Manager")
                    .font(.title.bold())
                
                Text("\(manager.voiceNotes.count) voice notes loaded")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(manager.voiceNotes.prefix(3)) { note in
                            HStack {
                                Text(note.priority.systemImage)
                                    .foregroundColor(note.priority.color)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(note.botName)
                                        .font(.subheadline.bold())
                                    
                                    Text(note.transcript)
                                        .font(.caption)
                                        .lineLimit(2)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                Button(action: {
                                    manager.togglePlayback(note)
                                }) {
                                    Image(systemName: manager.currentlyPlayingNote?.id == note.id ? "pause.fill" : "play.fill")
                                        .foregroundColor(.blue)
                                }
                            }
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(10)
                        }
                    }
                }
                .frame(maxHeight: 300)
            }
            .padding()
        }
    }
    
    return PreviewWrapper()
}