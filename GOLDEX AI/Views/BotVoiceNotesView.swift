//
//  BotVoiceNotesView.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 1/25/25.
//

import SwiftUI

struct BotVoiceNotesView: View {
    @State private var voiceNotes: [BotVoiceNote] = []
    @State private var selectedFilter: VoiceNoteFilter = .all
    @State private var isPlaying: String? = nil
    @State private var showingBotSelector = false
    @State private var selectedBot: String? = nil
    @State private var animateNotes = false
    
    enum VoiceNoteFilter: String, CaseIterable {
        case all = "all"
        case unread = "unread"
        case urgent = "urgent"
        case today = "today"
        case encouragement = "encouragement"
        case warnings = "warnings"
        case celebrations = "celebrations"
        
        var displayName: String {
            switch self {
            case .all: return "All Notes"
            case .unread: return "Unread"
            case .urgent: return "🚨 Urgent"
            case .today: return "📅 Today"
            case .encouragement: return "💪 Encouragement"
            case .warnings: return "⚠️ Warnings"
            case .celebrations: return "🎉 Celebrations"
            }
        }
        
        var color: Color {
            switch self {
            case .all: return .primary
            case .unread: return .blue
            case .urgent: return .red
            case .today: return .green
            case .encouragement: return .orange
            case .warnings: return .red
            case .celebrations: return .yellow
            }
        }
    }
    
    var filteredNotes: [BotVoiceNote] {
        let filtered = voiceNotes.filter { note in
            switch selectedFilter {
            case .all: return true
            case .unread: return !note.isRead
            case .urgent: return note.importance == .urgent
            case .today: return Calendar.current.isDateInToday(note.timestamp)
            case .encouragement: return note.noteType == .encouragement
            case .warnings: return note.noteType == .warning
            case .celebrations: return note.noteType == .celebration
            }
        }
        
        if let selectedBot = selectedBot {
            return filtered.filter { $0.botId == selectedBot }
        }
        
        return filtered.sorted { $0.timestamp > $1.timestamp }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header Stats
                headerStatsView
                    .padding()
                    .background(.ultraThinMaterial)
                
                // Filter Bar
                filterBar
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                
                // Voice Notes List
                if filteredNotes.isEmpty {
                    emptyStateView
                } else {
                    voiceNotesList
                }
            }
            .navigationTitle("🎙️ Bot Voice Notes")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingBotSelector = true }) {
                        Image(systemName: "brain.head.profile")
                            .foregroundColor(.blue)
                    }
                }
            }
        }
        .onAppear {
            loadVoiceNotes()
            startAnimations()
        }
        .sheet(isPresented: $showingBotSelector) {
            BotSelectorSheet(selectedBot: $selectedBot)
        }
    }
    
    private var headerStatsView: some View {
        HStack(spacing: 20) {
            StatCard(
                title: "Total Notes",
                value: "\(voiceNotes.count)",
                icon: "message.fill",
                color: .blue,
                trend: "+12"
            )
            
            StatCard(
                title: "Unread",
                value: "\(voiceNotes.filter { !$0.isRead }.count)",
                icon: "bell.fill",
                color: .red,
                trend: "🔔"
            )
            
            StatCard(
                title: "This Hour",
                value: "\(voiceNotes.filter { $0.timestamp.timeIntervalSinceNow > -3600 }.count)",
                icon: "clock.fill",
                color: .green,
                trend: "+5"
            )
        }
    }
    
    private var filterBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(VoiceNoteFilter.allCases, id: \.self) { filter in
                    FilterChip(
                        filter: filter,
                        isSelected: selectedFilter == filter,
                        count: getFilterCount(filter)
                    ) {
                        withAnimation(.spring()) {
                            selectedFilter = filter
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    private var voiceNotesList: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(Array(filteredNotes.enumerated()), id: \.element.id) { index, note in
                    VoiceNoteRow(
                        note: note,
                        isPlaying: isPlaying == note.id.uuidString,
                        showDivider: index < filteredNotes.count - 1
                    ) { action in
                        handleNoteAction(note, action)
                    }
                    .opacity(animateNotes ? 1 : 0)
                    .offset(x: animateNotes ? 0 : 30)
                    .animation(
                        .spring(dampingFraction: 0.8)
                        .delay(Double(index) * 0.05),
                        value: animateNotes
                    )
                }
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "speaker.slash.fill")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("No Voice Notes")
                .font(.title.bold())
                .foregroundColor(.primary)
            
            Text("Your trading bots haven't sent any voice notes yet. Start a MicroFlip game to hear from them!")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button("Start MicroFlip Game") {
                // Navigate to MicroFlip
            }
            .font(.headline)
            .padding()
            .background(.blue)
            .foregroundColor(.white)
            .cornerRadius(15)
            
            Spacer()
        }
    }
    
    private func getFilterCount(_ filter: VoiceNoteFilter) -> Int {
        switch filter {
        case .all: return voiceNotes.count
        case .unread: return voiceNotes.filter { !$0.isRead }.count
        case .urgent: return voiceNotes.filter { $0.importance == .urgent }.count
        case .today: return voiceNotes.filter { Calendar.current.isDateInToday($0.timestamp) }.count
        case .encouragement: return voiceNotes.filter { $0.noteType == .encouragement }.count
        case .warnings: return voiceNotes.filter { $0.noteType == .warning }.count
        case .celebrations: return voiceNotes.filter { $0.noteType == .celebration }.count
        }
    }
    
    private func handleNoteAction(_ note: BotVoiceNote, _ action: VoiceNoteAction) {
        switch action {
        case .play:
            if isPlaying == note.id.uuidString {
                isPlaying = nil
            } else {
                isPlaying = note.id.uuidString
                // Simulate playing for demo
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    isPlaying = nil
                }
            }
            
        case .markRead:
            if let index = voiceNotes.firstIndex(where: { $0.id == note.id }) {
                voiceNotes[index] = BotVoiceNote(
                    id: note.id,
                    botId: note.botId,
                    botName: note.botName,
                    botPersonality: note.botPersonality,
                    gameId: note.gameId,
                    tradeId: note.tradeId,
                    noteType: note.noteType,
                    message: note.message,
                    emotion: note.emotion,
                    confidence: note.confidence,
                    timestamp: note.timestamp,
                    duration: note.duration,
                    audioURL: note.audioURL,
                    isRead: true,
                    importance: note.importance,
                    tags: note.tags,
                    reactions: note.reactions
                )
            }
            
        case .react(let reaction):
            // Add reaction to note
            if let index = voiceNotes.firstIndex(where: { $0.id == note.id }) {
                var updatedReactions = voiceNotes[index].reactions
                updatedReactions.append(BotVoiceNote.PlayerReaction(
                    playerId: "current_player",
                    reaction: reaction,
                    timestamp: Date()
                ))
                
                voiceNotes[index] = BotVoiceNote(
                    id: note.id,
                    botId: note.botId,
                    botName: note.botName,
                    botPersonality: note.botPersonality,
                    gameId: note.gameId,
                    tradeId: note.tradeId,
                    noteType: note.noteType,
                    message: note.message,
                    emotion: note.emotion,
                    confidence: note.confidence,
                    timestamp: note.timestamp,
                    duration: note.duration,
                    audioURL: note.audioURL,
                    isRead: note.isRead,
                    importance: note.importance,
                    tags: note.tags,
                    reactions: updatedReactions
                )
            }
            
        case .delete:
            voiceNotes.removeAll { $0.id == note.id }
        }
    }
    
    private func loadVoiceNotes() {
        // Load sample voice notes
        voiceNotes = BotVoiceNote.sampleVoiceNotes
    }
    
    private func startAnimations() {
        withAnimation(.spring(dampingFraction: 0.8).delay(0.3)) {
            animateNotes = true
        }
    }
}

// MARK: - Supporting Views

struct FilterChip: View {
    let filter: BotVoiceNotesView.VoiceNoteFilter
    let isSelected: Bool
    let count: Int
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Text(filter.displayName)
                    .font(.caption.bold())
                
                if count > 0 && filter != .all {
                    Text("\(count)")
                        .font(.caption2.bold())
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(isSelected ? .white.opacity(0.3) : filter.color.opacity(0.3))
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(isSelected ? filter.color : .ultraThinMaterial)
            .foregroundColor(isSelected ? .white : .primary)
            .cornerRadius(15)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct VoiceNoteRow: View {
    let note: BotVoiceNote
    let isPlaying: Bool
    let showDivider: Bool
    let onAction: (VoiceNoteAction) -> Void
    @State private var showingReactions = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                // Bot Avatar
                ZStack {
                    Circle()
                        .fill(note.noteType.color.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Text(note.botPersonality.emoji)
                        .font(.title2)
                }
                .overlay(
                    Circle()
                        .stroke(note.isUrgent ? .red : .clear, lineWidth: 2)
                )
                
                // Note Content
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(note.botName)
                            .font(.subheadline.bold())
                        
                        Text(note.noteType.emoji)
                            .font(.caption)
                        
                        if !note.isRead {
                            Circle()
                                .fill(.blue)
                                .frame(width: 8, height: 8)
                        }
                        
                        Spacer()
                        
                        Text(note.timeAgo)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Text(note.message)
                        .font(.subheadline)
                        .lineLimit(2)
                    
                    HStack(spacing: 16) {
                        // Play Button
                        Button(action: { onAction(.play) }) {
                            HStack(spacing: 4) {
                                Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                                
                                Text(note.formattedDuration)
                                    .font(.caption)
                                    .foregroundColor(.blue)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        // Importance Indicator
                        if note.importance != .low {
                            HStack(spacing: 2) {
                                Image(systemName: "exclamationmark.circle.fill")
                                    .font(.caption)
                                    .foregroundColor(note.importance.color)
                                
                                Text(note.importance.displayName)
                                    .font(.caption)
                                    .foregroundColor(note.importance.color)
                            }
                        }
                        
                        Spacer()
                        
                        // Reactions
                        if !note.reactions.isEmpty {
                            HStack(spacing: 2) {
                                ForEach(Array(Set(note.reactions.map { $0.reaction })).prefix(3), id: \.self) { reaction in
                                    Text(reaction.emoji)
                                        .font(.caption)
                                }
                                
                                if note.reactions.count > 3 {
                                    Text("+\(note.reactions.count - 3)")
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        
                        // Reaction Button
                        Button(action: { showingReactions = true }) {
                            Image(systemName: "heart.circle")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            .padding()
            .background(note.isRead ? .clear : .blue.opacity(0.05))
            .onTapGesture {
                if !note.isRead {
                    onAction(.markRead)
                }
            }
            
            if showDivider {
                Divider()
                    .padding(.leading, 74)
            }
        }
        .contextMenu {
            Button(action: { onAction(.markRead) }) {
                Label(note.isRead ? "Mark Unread" : "Mark Read", systemImage: "envelope")
            }
            
            Button(action: { onAction(.delete) }) {
                Label("Delete", systemImage: "trash")
            }
        }
        .sheet(isPresented: $showingReactions) {
            ReactionSheet { reaction in
                onAction(.react(reaction))
            }
        }
    }
}

struct ReactionSheet: View {
    let onReaction: (BotVoiceNote.PlayerReaction.ReactionType) -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            Text("React to this voice note")
                .font(.title2.bold())
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 16) {
                ForEach(BotVoiceNote.PlayerReaction.ReactionType.allCases, id: \.self) { reaction in
                    Button(action: {
                        onReaction(reaction)
                        dismiss()
                    }) {
                        VStack(spacing: 8) {
                            Text(reaction.emoji)
                                .font(.system(size: 40))
                            
                            Text(reaction.rawValue.capitalized)
                                .font(.caption.bold())
                                .foregroundColor(.primary)
                        }
                        .frame(width: 80, height: 80)
                        .background(.ultraThinMaterial)
                        .cornerRadius(15)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            
            Button("Cancel") {
                dismiss()
            }
            .padding()
        }
        .padding()
        .presentationDetents([.medium])
    }
}

struct BotSelectorSheet: View {
    @Binding var selectedBot: String?
    @Environment(\.dismiss) private var dismiss
    
    let availableBots = [
        ("Alpha Wolf", "🐺", "aggressive"),
        ("Quantum Beast", "🤖", "analytical"),
        ("Speed Demon", "⚡", "speedDemon"),
        ("Ice Queen", "❄️", "conservative"),
        ("Phoenix Trader", "🔥", "adaptive")
    ]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                Button(action: {
                    selectedBot = nil
                    dismiss()
                }) {
                    HStack {
                        Image(systemName: "brain.head.profile")
                            .font(.title2)
                            .foregroundColor(.blue)
                        
                        VStack(alignment: .leading) {
                            Text("All Bots")
                                .font(.headline.bold())
                            
                            Text("Show notes from all bots")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        if selectedBot == nil {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.blue)
                        }
                    }
                    .padding()
                    .background(selectedBot == nil ? .blue.opacity(0.1) : .ultraThinMaterial)
                    .cornerRadius(15)
                }
                .buttonStyle(PlainButtonStyle())
                
                ForEach(availableBots, id: \.2) { bot in
                    Button(action: {
                        selectedBot = bot.2
                        dismiss()
                    }) {
                        HStack {
                            Text(bot.1)
                                .font(.title2)
                            
                            VStack(alignment: .leading) {
                                Text(bot.0)
                                    .font(.headline.bold())
                                
                                Text("\(Int.random(in: 3...12)) recent notes")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            if selectedBot == bot.2 {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding()
                        .background(selectedBot == bot.2 ? .blue.opacity(0.1) : .ultraThinMaterial)
                        .cornerRadius(15)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Select Bot")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Supporting Types

enum VoiceNoteAction {
    case play
    case markRead
    case react(BotVoiceNote.PlayerReaction.ReactionType)
    case delete
}

// MARK: - Sample Data

extension BotVoiceNote {
    static let sampleVoiceNotes: [BotVoiceNote] = [
        BotVoiceNote(
            botId: "alpha_wolf",
            botName: "Alpha Wolf",
            botPersonality: .aggressive,
            gameId: UUID(),
            noteType: .encouragement,
            message: "Listen up, rookie! 🔥 That last trade was FIRE! Keep that momentum going and let's crush this target! 💰",
            emotion: .excited,
            confidence: 0.95,
            duration: 12.5,
            isRead: false,
            importance: .high
        ),
        BotVoiceNote(
            botId: "quantum_beast",
            botName: "Quantum Beast",
            botPersonality: .analytical,
            noteType: .analysis,
            message: "Market analysis complete. 📊 RSI indicates oversold conditions. Probability of reversal: 73.2%. Recommend cautious entry.",
            emotion: .neutral,
            confidence: 0.89,
            duration: 18.3,
            isRead: true,
            importance: .medium
        ),
        BotVoiceNote(
            botId: "speed_demon",
            botName: "Speed Demon",
            botPersonality: .speedDemon,
            noteType: .warning,
            message: "⚡ SPEED WARNING! ⚡ You're moving too slow! Market's heating up - need to execute faster or we'll miss the breakout! 🚀",
            emotion: .worried,
            confidence: 0.87,
            duration: 8.7,
            isRead: false,
            importance: .urgent,
            reactions: [
                BotVoiceNote.PlayerReaction(
                    playerId: "player1",
                    reaction: .fire,
                    timestamp: Date().addingTimeInterval(-300)
                )
            ]
        ),
        BotVoiceNote(
            botId: "ice_queen",
            botName: "Ice Queen",
            botPersonality: .conservative,
            noteType: .advice,
            message: "❄️ Stay cool, trader. Your position size is appropriate, but consider taking partial profits here. Discipline beats greed every time. 💎",
            emotion: .confident,
            confidence: 0.93,
            duration: 15.2,
            isRead: true,
            importance: .medium
        ),
        BotVoiceNote(
            botId: "phoenix_trader",
            botName: "Phoenix Trader",
            botPersonality: .adaptive,
            noteType: .celebration,
            message: "🎉 BOOM! Rising from the ashes! 🔥 That comeback was LEGENDARY! From -$47 to +$83 - now THAT'S how you Phoenix Trade! 🚀",
            emotion: .excited,
            confidence: 0.98,
            duration: 14.8,
            isRead: false,
            importance: .high,
            reactions: [
                BotVoiceNote.PlayerReaction(
                    playerId: "player1",
                    reaction: .love,
                    timestamp: Date().addingTimeInterval(-120)
                ),
                BotVoiceNote.PlayerReaction(
                    playerId: "player2",
                    reaction: .fire,
                    timestamp: Date().addingTimeInterval(-60)
                )
            ]
        )
    ]
}

#Preview {
    BotVoiceNotesView()
}