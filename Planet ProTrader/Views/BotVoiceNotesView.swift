//
//  BotVoiceNotesView.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 1/25/25.
//

import SwiftUI

struct BotVoiceNotesView: View {
    @StateObject private var manager = BotVoiceNoteManager()
    @State private var selectedFilter: VoiceNoteFilter = .all
    @State private var showingBotSelector = false
    @State private var selectedBot: String? = nil
    @State private var animateNotes = false
    
    enum VoiceNoteFilter: String, CaseIterable {
        case all = "all"
        case unread = "unread" 
        case urgent = "urgent"
        case today = "today"
        case tradeAlert = "tradeAlert"
        case warnings = "warnings"
        case celebrations = "celebrations"
        
        var displayName: String {
            switch self {
            case .all: return "All Notes"
            case .unread: return "Unread"
            case .urgent: return "🚨 Urgent"
            case .today: return "📅 Today"
            case .tradeAlert: return "🚨 Trade Alerts"
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
            case .tradeAlert: return .red
            case .warnings: return .orange
            case .celebrations: return .yellow
            }
        }
    }
    
    var filteredNotes: [BotVoiceNote] {
        let filtered = manager.filteredNotes.filter { note in
            switch selectedFilter {
            case .all: return true
            case .unread: return false // This property doesn't exist in our model
            case .urgent: return note.priority == .urgent
            case .today: return Calendar.current.isDateInToday(note.timestamp)
            case .tradeAlert: return note.category == .tradeAlert
            case .warnings: return note.category == .warning
            case .celebrations: return note.category == .celebration
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
                value: "\(manager.voiceNotes.count)",
                icon: "message.fill",
                color: .blue,
                trend: "+12"
            )
            
            StatCard(
                title: "Urgent",
                value: "\(manager.voiceNotes.filter { $0.priority == .urgent }.count)",
                icon: "exclamationmark.triangle.fill",
                color: .red,
                trend: "🚨"
            )
            
            StatCard(
                title: "This Hour", 
                value: "\(manager.voiceNotes.filter { $0.timestamp.timeIntervalSinceNow > -3600 }.count)",
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
                        isPlaying: manager.currentlyPlayingNote?.id == note.id,
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
        case .all: return manager.voiceNotes.count
        case .unread: return 0 // Property doesn't exist
        case .urgent: return manager.voiceNotes.filter { $0.priority == .urgent }.count
        case .today: return manager.voiceNotes.filter { Calendar.current.isDateInToday($0.timestamp) }.count
        case .tradeAlert: return manager.voiceNotes.filter { $0.category == .tradeAlert }.count
        case .warnings: return manager.voiceNotes.filter { $0.category == .warning }.count
        case .celebrations: return manager.voiceNotes.filter { $0.category == .celebration }.count
        }
    }
    
    private func handleNoteAction(_ note: BotVoiceNote, _ action: VoiceNoteAction) {
        switch action {
        case .play:
            manager.togglePlayback(note)
            
        case .markRead:
            // This functionality would need to be added to the manager
            break
            
        case .react(let reaction):
            manager.addReaction(note, reaction: reaction)
            
        case .delete:
            // Remove note from manager
            break
        }
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
                        .fill(note.category.color.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Text(note.category.emoji)
                        .font(.title2)
                }
                .overlay(
                    Circle()
                        .stroke(note.priority == .urgent ? .red : .clear, lineWidth: 2)
                )
                
                // Note Content
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(note.botName)
                            .font(.subheadline.bold())
                        
                        Text(note.category.emoji)
                            .font(.caption)
                        
                        Spacer()
                        
                        Text(timeAgo(from: note.timestamp))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Text(note.content)
                        .font(.subheadline)
                        .lineLimit(2)
                    
                    HStack(spacing: 16) {
                        // Play Button
                        Button(action: { onAction(.play) }) {
                            HStack(spacing: 4) {
                                Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                                
                                Text(formattedDuration(note.duration))
                                    .font(.caption)
                                    .foregroundColor(.blue)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        // Priority Indicator
                        if note.priority != .low {
                            HStack(spacing: 2) {
                                Image(systemName: "exclamationmark.circle.fill")
                                    .font(.caption)
                                    .foregroundColor(note.priority.color)
                                
                                Text(note.priority.rawValue)
                                    .font(.caption)
                                    .foregroundColor(note.priority.color)
                            }
                        }
                        
                        Spacer()
                        
                        // Reactions
                        if !note.reactions.isEmpty {
                            HStack(spacing: 2) {
                                ForEach(Array(Set(note.reactions.map { $0.type })).prefix(3), id: \.self) { reaction in
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
            .background(.clear)
            
            if showDivider {
                Divider()
                    .padding(.leading, 74)
            }
        }
        .contextMenu {
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
    
    private func timeAgo(from date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }
    
    private func formattedDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        if minutes > 0 {
            return String(format: "%d:%02d", minutes, seconds)
        } else {
            return String(format: "0:%02d", seconds)
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
        ("Gold Rush Alpha", "🏆", "gold-rush-alpha"),
        ("Zeus Thunder", "⚡", "zeus-thunder"),
        ("Steady Eddie", "🐢", "steady-eddie"),
        ("Quantum Leap", "🚀", "quantum-leap"),
        ("Day Warrior", "⚔️", "day-warrior")
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

// MARK: - StatCard View
struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    let trend: String
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                Spacer()
                Text(trend)
                    .font(.caption.bold())
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(value)
                    .font(.title2.bold())
                    .foregroundColor(.primary)
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(12)
    }
}

// MARK: - Supporting Types
enum VoiceNoteAction {
    case play
    case markRead
    case react(BotVoiceNote.PlayerReaction.ReactionType)
    case delete
}

#Preview {
    BotVoiceNotesView()
}