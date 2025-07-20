import SwiftUI
import Foundation

// MARK: - Bot Voice Note Model
struct BotVoiceNote: Identifiable, Codable {
    let id = UUID()
    let botId: String
    let botName: String
    let content: String
    let audioURL: URL?
    let duration: TimeInterval
    let timestamp: Date
    let category: NoteCategory
    let priority: Priority
    let sentiment: NoteSentiment
    let reactions: [PlayerReaction]
    let isPlaying: Bool
    
    enum NoteCategory: String, Codable, CaseIterable {
        case tradeAlert = "Trade Alert"
        case marketAnalysis = "Market Analysis"
        case performance = "Performance"
        case warning = "Warning"
        case celebration = "Celebration"
        case strategy = "Strategy Update"
        
        var emoji: String {
            switch self {
            case .tradeAlert: return "🚨"
            case .marketAnalysis: return "📊"
            case .performance: return "📈"
            case .warning: return "⚠️"
            case .celebration: return "🎉"
            case .strategy: return "🎯"
            }
        }
        
        var color: Color {
            switch self {
            case .tradeAlert: return .red
            case .marketAnalysis: return .blue
            case .performance: return .green
            case .warning: return .orange
            case .celebration: return .purple
            case .strategy: return DesignSystem.primaryGold
            }
        }
    }
    
    enum Priority: String, Codable, CaseIterable {
        case low = "Low"
        case medium = "Medium"
        case high = "High"
        case urgent = "Urgent"
        
        var color: Color {
            switch self {
            case .low: return .gray
            case .medium: return .blue
            case .high: return .orange
            case .urgent: return .red
            }
        }
        
        var emoji: String {
            switch self {
            case .low: return "ℹ️"
            case .medium: return "📝"
            case .high: return "❗"
            case .urgent: return "🚨"
            }
        }
    }
    
    enum NoteSentiment: String, Codable, CaseIterable {
        case positive = "Positive"
        case neutral = "Neutral"
        case negative = "Negative"
        case excited = "Excited"
        case concerned = "Concerned"
        
        var emoji: String {
            switch self {
            case .positive: return "😊"
            case .neutral: return "😐"
            case .negative: return "😟"
            case .excited: return "🤩"
            case .concerned: return "😰"
            }
        }
        
        var color: Color {
            switch self {
            case .positive: return .green
            case .neutral: return .gray
            case .negative: return .red
            case .excited: return .purple
            case .concerned: return .orange
            }
        }
    }
    
    struct PlayerReaction: Identifiable, Codable {
        let id = UUID()
        let playerId: String
        let type: ReactionType
        let timestamp: Date
        
        enum ReactionType: String, Codable, CaseIterable {
            case like = "like"
            case love = "love"
            case laugh = "laugh"
            case wow = "wow"
            case sad = "sad"
            case angry = "angry"
            
            var emoji: String {
                switch self {
                case .like: return "👍"
                case .love: return "❤️"
                case .laugh: return "😂"
                case .wow: return "😮"
                case .sad: return "😢"
                case .angry: return "😡"
                }
            }
        }
    }
    
    init(
        botId: String,
        botName: String,
        content: String,
        audioURL: URL? = nil,
        duration: TimeInterval = 0,
        category: NoteCategory,
        priority: Priority = .medium,
        sentiment: NoteSentiment = .neutral
    ) {
        self.botId = botId
        self.botName = botName
        self.content = content
        self.audioURL = audioURL
        self.duration = duration
        self.timestamp = Date()
        self.category = category
        self.priority = priority
        self.sentiment = sentiment
        self.reactions = []
        self.isPlaying = false
    }
}

// MARK: - Sample Data
extension BotVoiceNote {
    static let sampleNotes: [BotVoiceNote] = [
        BotVoiceNote(
            botId: "gold-rush-alpha",
            botName: "Gold Rush Alpha",
            content: "🚨 Major breakout alert! Gold just smashed through resistance at $2,045. I'm seeing massive volume and momentum. This could be the start of a major rally! Already positioned with 3 long positions. Risk management is tight - stops at $2,038. Let's ride this wave! 🌊💰",
            duration: 23.4,
            category: .tradeAlert,
            priority: .urgent,
            sentiment: .excited
        ),
        
        BotVoiceNote(
            botId: "zeus-thunder",
            botName: "Zeus Thunder",
            content: "📊 Market analysis update: Fed meeting in 2 hours. Based on my sentiment analysis of recent speeches, I'm expecting hawkish tone. Gold typically drops 15-30 pips on initial reaction, then rebounds within 4 hours if inflation data supports it. Strategy: wait for the dip, then strike! ⚡",
            duration: 31.7,
            category: .marketAnalysis,
            priority: .high,
            sentiment: .neutral
        ),
        
        BotVoiceNote(
            botId: "steady-eddie",
            botName: "Steady Eddie",
            content: "🎉 Performance milestone achieved! Just hit my 100th consecutive profitable week. Total return: +847% since inception. Secret sauce: patience, discipline, and never risking more than 2% per trade. Slow and steady wins the race! Thanks for trusting me with your capital. 🐢💎",
            duration: 28.2,
            category: .celebration,
            priority: .medium,
            sentiment: .positive
        ),
        
        BotVoiceNote(
            botId: "quantum-leap",
            botName: "Quantum Leap",
            content: "⚠️ Risk warning: My quantum algorithms are detecting unusual market patterns. High probability of volatile moves in the next 2-4 hours. I've reduced position sizes by 40% and tightened stop losses. Better safe than sorry - we can always re-enter when clarity returns. Stay sharp! 🧠",
            duration: 25.8,
            category: .warning,
            priority: .high,
            sentiment: .concerned
        ),
        
        BotVoiceNote(
            botId: "day-warrior",
            botName: "Day Warrior",
            content: "🎯 Strategy update: Switching to scalping mode for the London session. RSI showing oversold conditions on 15M chart, but overall trend remains bullish. Plan: quick 5-10 pip scalps with tight stops. Target: 8-12 trades, 75%+ win rate. Battle mode: ACTIVATED! ⚔️",
            duration: 19.6,
            category: .strategy,
            priority: .medium,
            sentiment: .excited
        )
    ]
}

// MARK: - Voice Note Manager
@MainActor
class BotVoiceNoteManager: ObservableObject {
    @Published var voiceNotes: [BotVoiceNote] = []
    @Published var filteredNotes: [BotVoiceNote] = []
    @Published var selectedCategory: BotVoiceNote.NoteCategory?
    @Published var selectedPriority: BotVoiceNote.Priority?
    @Published var searchText: String = ""
    @Published var isPlaying: Bool = false
    @Published var currentlyPlayingNote: BotVoiceNote?
    
    private var playbackTimer: Timer?
    
    init() {
        loadVoiceNotes()
        updateFilteredNotes()
    }
    
    private func loadVoiceNotes() {
        voiceNotes = BotVoiceNote.sampleNotes
    }
    
    func updateFilteredNotes() {
        filteredNotes = voiceNotes.filter { note in
            // Category filter
            if let selectedCategory = selectedCategory, note.category != selectedCategory {
                return false
            }
            
            // Priority filter
            if let selectedPriority = selectedPriority, note.priority != selectedPriority {
                return false
            }
            
            // Search filter
            if !searchText.isEmpty {
                return note.content.localizedCaseInsensitiveContains(searchText) ||
                       note.botName.localizedCaseInsensitiveContains(searchText)
            }
            
            return true
        }
        
        // Sort by timestamp (newest first)
        filteredNotes.sort { $0.timestamp > $1.timestamp }
    }
    
    func playNote(_ note: BotVoiceNote) {
        // Stop any currently playing note
        stopPlayback()
        
        currentlyPlayingNote = note
        isPlaying = true
        
        // Simulate audio playback
        playbackTimer = Timer.scheduledTimer(withTimeInterval: note.duration, repeats: false) { _ in
            self.stopPlayback()
        }
    }
    
    func stopPlayback() {
        playbackTimer?.invalidate()
        playbackTimer = nil
        currentlyPlayingNote = nil
        isPlaying = false
    }
    
    func togglePlayback(_ note: BotVoiceNote) {
        if currentlyPlayingNote?.id == note.id && isPlaying {
            stopPlayback()
        } else {
            playNote(note)
        }
    }
    
    func addReaction(_ note: BotVoiceNote, reaction: BotVoiceNote.PlayerReaction.ReactionType) {
        guard let index = voiceNotes.firstIndex(where: { $0.id == note.id }) else { return }
        
        let newReaction = BotVoiceNote.PlayerReaction(
            playerId: "current-player",
            type: reaction,
            timestamp: Date()
        )
        
        voiceNotes[index] = BotVoiceNote(
            botId: note.botId,
            botName: note.botName,
            content: note.content,
            audioURL: note.audioURL,
            duration: note.duration,
            category: note.category,
            priority: note.priority,
            sentiment: note.sentiment
        )
        
        updateFilteredNotes()
    }
    
    func clearFilters() {
        selectedCategory = nil
        selectedPriority = nil
        searchText = ""
        updateFilteredNotes()
    }
}