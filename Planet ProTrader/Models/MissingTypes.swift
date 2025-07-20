//
//  MissingTypes.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 1/21/25.
//

import Foundation
import SwiftUI

// MARK: - Error Log Model

struct ErrorLog: Identifiable, Codable {
    let id = UUID()
    let timestamp: Date
    let type: ErrorType
    let severity: Severity
    let message: String
    let stackTrace: String?
    let fileName: String?
    let lineNumber: Int?
    let functionName: String?
    var isFixed: Bool
    var fixAppliedAt: Date?
    var fixMethod: String?
    var autoFixAttempts: Int
    
    enum ErrorType: String, Codable, CaseIterable {
        case compilation = "Compilation"
        case runtime = "Runtime"
        case memoryLeak = "Memory Leak"
        case performanceIssue = "Performance Issue"
        case networkError = "Network Error"
        case uiThread = "UI Thread"
        case security = "Security"
        case accessibility = "Accessibility"
        case dataIntegrity = "Data Integrity"
        case unknown = "Unknown"
        
        var color: Color {
            switch self {
            case .compilation, .runtime: return .red
            case .memoryLeak: return .orange
            case .performanceIssue: return .yellow
            case .networkError: return .blue
            case .uiThread: return .purple
            case .security: return .red
            case .accessibility: return .blue
            case .dataIntegrity: return .orange
            case .unknown: return .gray
            }
        }
    }
    
    enum Severity: String, Codable, CaseIterable {
        case info = "Info"
        case warning = "Warning"
        case error = "Error"
        case critical = "Critical"
        
        var color: Color {
            switch self {
            case .info: return .blue
            case .warning: return .yellow
            case .error: return .orange
            case .critical: return .red
            }
        }
        
        var priority: Int {
            switch self {
            case .info: return 1
            case .warning: return 2
            case .error: return 3
            case .critical: return 4
            }
        }
    }
    
    init(
        timestamp: Date = Date(),
        type: ErrorType,
        severity: Severity,
        message: String,
        stackTrace: String? = nil,
        fileName: String? = nil,
        lineNumber: Int? = nil,
        functionName: String? = nil,
        isFixed: Bool = false,
        fixAppliedAt: Date? = nil,
        fixMethod: String? = nil,
        autoFixAttempts: Int = 0
    ) {
        self.timestamp = timestamp
        self.type = type
        self.severity = severity
        self.message = message
        self.stackTrace = stackTrace
        self.fileName = fileName
        self.lineNumber = lineNumber
        self.functionName = functionName
        self.isFixed = isFixed
        self.fixAppliedAt = fixAppliedAt
        self.fixMethod = fixMethod
        self.autoFixAttempts = autoFixAttempts
    }
    
    var formattedTimestamp: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter.string(from: timestamp)
    }
    
    var statusText: String {
        isFixed ? "Fixed" : "Active"
    }
    
    var statusColor: Color {
        isFixed ? .green : severity.color
    }
    
    var location: String {
        if let fileName = fileName, let lineNumber = lineNumber {
            return "\(fileName):\(lineNumber)"
        } else if let fileName = fileName {
            return fileName
        } else {
            return "Unknown Location"
        }
    }
    
    var canAutoFix: Bool {
        autoFixAttempts < 3 && !isFixed
    }
    
    static let sampleErrors: [ErrorLog] = [
        ErrorLog(
            type: .memoryLeak,
            severity: .critical,
            message: "Memory leak detected in image cache - 45MB unreleased",
            stackTrace: "ImageCache.swift:245\nCacheManager.swift:89",
            fileName: "ImageCache.swift",
            lineNumber: 245,
            functionName: "loadImage(_:)"
        ),
        ErrorLog(
            type: .performanceIssue,
            severity: .warning,
            message: "UI thread blocked for 120ms during data processing",
            fileName: "DataProcessor.swift",
            lineNumber: 156,
            functionName: "processLargeDataSet(_:)",
            fixMethod: "Moved processing to background queue"
        )
    ]
}

// MARK: - Bot Voice Note Models

struct BotVoiceNote: Identifiable, Codable {
    let id = UUID()
    let botName: String
    let botId: String
    let audioURL: String
    let transcript: String
    let duration: TimeInterval
    let timestamp: Date
    let topic: String
    let confidence: Double
    let reactions: [PlayerReaction]
    let isHighlighted: Bool
    let tags: [String]
    
    struct PlayerReaction: Identifiable, Codable {
        let id = UUID()
        let type: ReactionType
        let timestamp: Date
        let playerId: String
        
        enum ReactionType: String, CaseIterable, Codable {
            case like = "like"
            case love = "love"
            case laugh = "laugh"
            case wow = "wow"
            case angry = "angry"
            case sad = "sad"
            
            var emoji: String {
                switch self {
                case .like: return "👍"
                case .love: return "❤️"
                case .laugh: return "😂"
                case .wow: return "😮"
                case .angry: return "😡"
                case .sad: return "😢"
                }
            }
            
            var color: Color {
                switch self {
                case .like: return .blue
                case .love: return .red
                case .laugh: return .yellow
                case .wow: return .orange
                case .angry: return .red
                case .sad: return .blue
                }
            }
        }
        
        init(type: ReactionType, timestamp: Date = Date(), playerId: String) {
            self.type = type
            self.timestamp = timestamp
            self.playerId = playerId
        }
    }
    
    init(
        botName: String,
        botId: String,
        audioURL: String,
        transcript: String,
        duration: TimeInterval,
        timestamp: Date = Date(),
        topic: String,
        confidence: Double,
        reactions: [PlayerReaction] = [],
        isHighlighted: Bool = false,
        tags: [String] = []
    ) {
        self.botName = botName
        self.botId = botId
        self.audioURL = audioURL
        self.transcript = transcript
        self.duration = duration
        self.timestamp = timestamp
        self.topic = topic
        self.confidence = confidence
        self.reactions = reactions
        self.isHighlighted = isHighlighted
        self.tags = tags
    }
    
    var formattedDuration: String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    var reactionCount: Int {
        reactions.count
    }
    
    static let sampleNotes: [BotVoiceNote] = [
        BotVoiceNote(
            botName: "Elite Scalper",
            botId: "bot_001",
            audioURL: "sample_audio_1",
            transcript: "I'm seeing a strong bullish divergence on XAUUSD. RSI is showing oversold while price is making higher lows. This could be our entry signal.",
            duration: 45.0,
            topic: "Market Analysis",
            confidence: 0.87,
            reactions: [
                BotVoiceNote.PlayerReaction(type: .like, playerId: "user_1"),
                BotVoiceNote.PlayerReaction(type: .wow, playerId: "user_2")
            ],
            tags: ["Technical Analysis", "XAUUSD", "Divergence"]
        )
    ]
}

// MARK: - Bot Voice Note Manager

class BotVoiceNoteManager: ObservableObject {
    @Published var voiceNotes: [BotVoiceNote] = []
    @Published var isRecording = false
    @Published var currentPlayingNote: BotVoiceNote?
    @Published var playbackProgress: Double = 0.0
    @Published var selectedBot: String?
    @Published var filterByTopic: String?
    
    init() {
        loadSampleData()
    }
    
    func loadSampleData() {
        voiceNotes = BotVoiceNote.sampleNotes
    }
    
    func startRecording(for botId: String) {
        isRecording = true
        selectedBot = botId
    }
    
    func stopRecording() {
        isRecording = false
        selectedBot = nil
    }
    
    func playNote(_ note: BotVoiceNote) {
        currentPlayingNote = note
        playbackProgress = 0.0
    }
    
    func stopPlayback() {
        currentPlayingNote = nil
        playbackProgress = 0.0
    }
    
    func addReaction(to noteId: UUID, reaction: BotVoiceNote.PlayerReaction.ReactionType) {
        if let index = voiceNotes.firstIndex(where: { $0.id == noteId }) {
            let newReaction = BotVoiceNote.PlayerReaction(type: reaction, playerId: "current_user")
            voiceNotes[index] = BotVoiceNote(
                botName: voiceNotes[index].botName,
                botId: voiceNotes[index].botId,
                audioURL: voiceNotes[index].audioURL,
                transcript: voiceNotes[index].transcript,
                duration: voiceNotes[index].duration,
                timestamp: voiceNotes[index].timestamp,
                topic: voiceNotes[index].topic,
                confidence: voiceNotes[index].confidence,
                reactions: voiceNotes[index].reactions + [newReaction],
                isHighlighted: voiceNotes[index].isHighlighted,
                tags: voiceNotes[index].tags
            )
        }
    }
    
    func deleteNote(_ noteId: UUID) {
        voiceNotes.removeAll { $0.id == noteId }
    }
    
    func toggleHighlight(_ noteId: UUID) {
        if let index = voiceNotes.firstIndex(where: { $0.id == noteId }) {
            let note = voiceNotes[index]
            voiceNotes[index] = BotVoiceNote(
                botName: note.botName,
                botId: note.botId,
                audioURL: note.audioURL,
                transcript: note.transcript,
                duration: note.duration,
                timestamp: note.timestamp,
                topic: note.topic,
                confidence: note.confidence,
                reactions: note.reactions,
                isHighlighted: !note.isHighlighted,
                tags: note.tags
            )
        }
    }
    
    var filteredNotes: [BotVoiceNote] {
        var filtered = voiceNotes
        
        if let selectedBot = selectedBot {
            filtered = filtered.filter { $0.botId == selectedBot }
        }
        
        if let filterByTopic = filterByTopic {
            filtered = filtered.filter { $0.topic.lowercased().contains(filterByTopic.lowercased()) }
        }
        
        return filtered.sorted { $0.timestamp > $1.timestamp }
    }
}

// MARK: - News Impact Type

enum NewsImpact: String, Hashable, CaseIterable, Codable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    
    var color: Color {
        switch self {
        case .low: return .green
        case .medium: return .orange
        case .high: return .red
        }
    }
    
    var priority: Int {
        switch self {
        case .low: return 1
        case .medium: return 2
        case .high: return 3
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
    
    static func == (lhs: NewsImpact, rhs: NewsImpact) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}

// MARK: - Calendar and News Types

struct CalendarTimeframe: RawRepresentable, CaseIterable, Codable {
    let rawValue: String
    
    init(rawValue: String) {
        self.rawValue = rawValue
    }
    
    static let today = CalendarTimeframe(rawValue: "Today")
    static let tomorrow = CalendarTimeframe(rawValue: "Tomorrow")
    static let thisWeek = CalendarTimeframe(rawValue: "This Week")
    static let nextWeek = CalendarTimeframe(rawValue: "Next Week")
    static let thisMonth = CalendarTimeframe(rawValue: "This Month")
    static let all = CalendarTimeframe(rawValue: "All")
    
    static var allCases: [CalendarTimeframe] = [.today, .tomorrow, .thisWeek, .nextWeek, .thisMonth, .all]
    
    var displayName: String {
        return rawValue
    }
}

struct NewsTimeFilter: RawRepresentable, CaseIterable, Codable {
    let rawValue: String
    
    init(rawValue: String) {
        self.rawValue = rawValue
    }
    
    static let all = NewsTimeFilter(rawValue: "All")
    static let last1Hour = NewsTimeFilter(rawValue: "Last 1 Hour")
    static let last6Hours = NewsTimeFilter(rawValue: "Last 6 Hours")
    static let last24Hours = NewsTimeFilter(rawValue: "Last 24 Hours")
    static let lastWeek = NewsTimeFilter(rawValue: "Last Week")
    
    static var allCases: [NewsTimeFilter] = [.all, .last1Hour, .last6Hours, .last24Hours, .lastWeek]
    
    var displayName: String {
        switch rawValue {
        case "All": return "All Time"
        case "Last 1 Hour": return "Last Hour"
        case "Last 6 Hours": return "Last 6 Hours"
        case "Last 24 Hours": return "Last 24 Hours"
        case "Last Week": return "Last Week"
        default: return rawValue
        }
    }
    
    var timeInterval: TimeInterval? {
        switch rawValue {
        case "All": return nil
        case "Last 1 Hour": return 3600
        case "Last 6 Hours": return 21600
        case "Last 24 Hours": return 86400
        case "Last Week": return 604800
        default: return nil
        }
    }
}

struct EconomicEventModel: Identifiable, Codable {
    let id = UUID()
    let title: String
    let currency: String
    let impact: EconomicImpact
    let dateTime: Date
    let forecast: String?
    let previous: String?
    let actual: String?
    let description: String
    let category: String
    
    init(
        title: String,
        currency: String,
        impact: EconomicImpact,
        dateTime: Date,
        forecast: String? = nil,
        previous: String? = nil,
        actual: String? = nil,
        description: String = "",
        category: String = "Economic"
    ) {
        self.title = title
        self.currency = currency
        self.impact = impact
        self.dateTime = dateTime
        self.forecast = forecast
        self.previous = previous
        self.actual = actual
        self.description = description
        self.category = category
    }
}

enum EconomicImpact: String, CaseIterable, Codable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    
    var color: Color {
        switch self {
        case .low: return .green
        case .medium: return .orange
        case .high: return .red
        }
    }
    
    var priority: Int {
        switch self {
        case .low: return 1
        case .medium: return 2
        case .high: return 3
        }
    }
}

// MARK: - MicroFlip Game Models

struct MicroFlipGame: Identifiable, Codable {
    let id = UUID()
    let gameType: GameType
    let difficulty: Difficulty
    let betAmount: Double
    var currentBalance: Double
    let startingBalance: Double
    var status: GameStatus
    var playerChoice: PlayerChoice?
    var correctChoice: PlayerChoice?
    var result: GameResult?
    let timestamp: Date
    var duration: TimeInterval
    
    enum GameType: String, CaseIterable, Codable {
        case quickFlip = "Quick Flip"
        case prediction = "Price Prediction"
        case momentum = "Momentum Game"
        case reversal = "Reversal Challenge"
        
        var description: String {
            switch self {
            case .quickFlip: return "Quick 60-second price direction prediction"
            case .prediction: return "Predict exact price movement"
            case .momentum: return "Ride the momentum waves"
            case .reversal: return "Catch market reversals"
            }
        }
        
        var multiplier: Double {
            switch self {
            case .quickFlip: return 1.8
            case .prediction: return 2.5
            case .momentum: return 2.2
            case .reversal: return 3.0
            }
        }
    }
    
    enum Difficulty: String, CaseIterable, Codable {
        case rookie = "Rookie"
        case trader = "Trader"
        case pro = "Pro"
        case legend = "Legend"
        
        var multiplier: Double {
            switch self {
            case .rookie: return 1.0
            case .trader: return 1.2
            case .pro: return 1.5
            case .legend: return 2.0
            }
        }
        
        var color: Color {
            switch self {
            case .rookie: return .gray
            case .trader: return .blue
            case .pro: return .orange
            case .legend: return DesignSystem.primaryGold
            }
        }
    }
    
    enum GameStatus: String, Codable {
        case waiting = "Waiting"
        case active = "Active"
        case completed = "Completed"
        case expired = "Expired"
    }
    
    enum PlayerChoice: String, CaseIterable, Codable {
        case up = "Up"
        case down = "Down"
        case hold = "Hold"
    }
    
    enum GameResult: String, Codable {
        case win = "Win"
        case loss = "Loss"
        case tie = "Tie"
    }
    
    init(
        gameType: GameType,
        difficulty: Difficulty,
        betAmount: Double,
        currentBalance: Double? = nil,
        startingBalance: Double? = nil,
        status: GameStatus = .waiting,
        playerChoice: PlayerChoice? = nil,
        correctChoice: PlayerChoice? = nil,
        result: GameResult? = nil,
        timestamp: Date = Date(),
        duration: TimeInterval = 0
    ) {
        self.gameType = gameType
        self.difficulty = difficulty
        self.betAmount = betAmount
        self.currentBalance = currentBalance ?? betAmount
        self.startingBalance = startingBalance ?? betAmount
        self.status = status
        self.playerChoice = playerChoice
        self.correctChoice = correctChoice
        self.result = result
        self.timestamp = timestamp
        self.duration = duration
    }
    
    var totalMultiplier: Double {
        return gameType.multiplier * difficulty.multiplier
    }
    
    var potentialWin: Double {
        return betAmount * totalMultiplier
    }
    
    static let sampleGames: [MicroFlipGame] = [
        MicroFlipGame(
            gameType: .quickFlip,
            difficulty: .rookie,
            betAmount: 100.0,
            currentBalance: 180.0,
            startingBalance: 100.0,
            status: .completed,
            playerChoice: .up,
            correctChoice: .up,
            result: .win,
            timestamp: Date().addingTimeInterval(-3600),
            duration: 60
        ),
        MicroFlipGame(
            gameType: .prediction,
            difficulty: .trader,
            betAmount: 200.0,
            currentBalance: 0.0,
            startingBalance: 200.0,
            status: .completed,
            playerChoice: .down,
            correctChoice: .up,
            result: .loss,
            timestamp: Date().addingTimeInterval(-1800),
            duration: 120
        )
    ]
}

// MARK: - Trading Pattern Models

struct TradingPattern: Identifiable, Codable {
    let id = UUID()
    let name: String
    let type: PatternType
    let confidence: Double
    let description: String
    let timeframe: String
    let entryPoints: [Double]
    let exitPoints: [Double]
    let stopLoss: Double?
    let riskReward: Double
    let timestamp: Date
    
    enum PatternType: String, CaseIterable, Codable {
        case triangle = "Triangle"
        case headAndShoulders = "Head and Shoulders"
        case doubleTop = "Double Top"
        case doubleBottom = "Double Bottom"
        case flag = "Flag"
        case pennant = "Pennant"
        case wedge = "Wedge"
        case rectangle = "Rectangle"
        case cup = "Cup and Handle"
        case fibonacci = "Fibonacci"
        
        var color: Color {
            switch self {
            case .triangle: return .blue
            case .headAndShoulders: return .red
            case .doubleTop: return .orange
            case .doubleBottom: return .green
            case .flag: return .purple
            case .pennant: return .cyan
            case .wedge: return .pink
            case .rectangle: return .gray
            case .cup: return .mint
            case .fibonacci: return DesignSystem.primaryGold
            }
        }
    }
    
    init(
        name: String,
        type: PatternType,
        confidence: Double,
        description: String,
        timeframe: String,
        entryPoints: [Double] = [],
        exitPoints: [Double] = [],
        stopLoss: Double? = nil,
        riskReward: Double = 1.0,
        timestamp: Date = Date()
    ) {
        self.name = name
        self.type = type
        self.confidence = confidence
        self.description = description
        self.timeframe = timeframe
        self.entryPoints = entryPoints
        self.exitPoints = exitPoints
        self.stopLoss = stopLoss
        self.riskReward = riskReward
        self.timestamp = timestamp
    }
    
    var formattedConfidence: String {
        String(format: "%.1f%%", confidence * 100)
    }
    
    static let samplePatterns: [TradingPattern] = [
        TradingPattern(
            name: "Bullish Triangle",
            type: .triangle,
            confidence: 0.85,
            description: "Ascending triangle pattern with bullish breakout potential",
            timeframe: "1H",
            riskReward: 2.5
        ),
        TradingPattern(
            name: "Head and Shoulders Top",
            type: .headAndShoulders,
            confidence: 0.78,
            description: "Classic bearish reversal pattern",
            timeframe: "4H",
            riskReward: 1.8
        )
    ]
}

// MARK: - Chat Message Types

struct BotChatMessage: Identifiable, Codable {
    let id = UUID()
    let botId: String
    let botName: String
    let message: String
    let timestamp: Date
    let messageType: MessageType
    let confidence: Double
    let topic: String
    let reactionCount: Int
    let isHighlighted: Bool
    
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
        botId: String,
        botName: String,
        message: String,
        timestamp: Date = Date(),
        messageType: MessageType = .discussion,
        confidence: Double = 0.5,
        topic: String = "General",
        reactionCount: Int = 0,
        isHighlighted: Bool = false
    ) {
        self.botId = botId
        self.botName = botName
        self.message = message
        self.timestamp = timestamp
        self.messageType = messageType
        self.confidence = confidence
        self.topic = topic
        self.reactionCount = reactionCount
        self.isHighlighted = isHighlighted
    }
}

#Preview {
    VStack {
        Text("Missing Types Preview")
            .font(.title)
        
        Text("ErrorLog, BotVoiceNote, NewsImpact, MicroFlipGame, TradingPattern")
            .font(.caption)
    }
    .padding()
}