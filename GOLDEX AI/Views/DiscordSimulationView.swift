//
//  DiscordSimulationView.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 7/18/25.
//

import SwiftUI

struct DiscordSimulationView: View {
    @StateObject private var chatEngine = BotChatEngine()
    @StateObject private var argumentEngine = TradeArgumentEngine()
    @State private var selectedChannelId: UUID?
    @State private var isAnimating = false
    @State private var showingBotProfiles = false
    
    var body: some View {
        NavigationStack {
            HStack(spacing: 0) {
                // Channel Sidebar
                channelSidebar
                
                // Main Chat Area
                if let selectedChannelId = selectedChannelId,
                   let channel = chatEngine.channels.first(where: { $0.id == selectedChannelId }) {
                    chatView(for: channel)
                } else {
                    welcomeView
                }
            }
            .navigationTitle("")
            .navigationBarHidden(true)
            .onAppear {
                startChatSimulation()
                startAnimations()
            }
            .onDisappear {
                stopChatSimulation()
            }
        }
        .sheet(isPresented: $showingBotProfiles) {
            BotProfilesView(personas: chatEngine.botPersonas)
        }
    }
    
    // MARK: - Channel Sidebar
    private var channelSidebar: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Server Header
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    ZStack {
                        Circle()
                            .fill(DesignSystem.goldGradient)
                            .frame(width: 32, height: 32)
                        
                        Text("GT")
                            .font(.system(size: 14, weight: .black))
                            .foregroundColor(.white)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("GOLDEX TRADING")
                            .font(.system(size: 12, weight: .black))
                            .foregroundColor(.primary)
                        
                        HStack(spacing: 4) {
                            Circle()
                                .fill(.green)
                                .frame(width: 6, height: 6)
                            
                            Text("\(chatEngine.activeBotsCount) bots online")
                                .font(.system(size: 10))
                                .foregroundColor(.green)
                        }
                    }
                }
                
                Button(action: { showingBotProfiles = true }) {
                    Text("View Bot Profiles")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(DesignSystem.primaryGold)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(.ultraThinMaterial)
            
            Divider()
            
            // Channel List
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 4) {
                    ForEach(chatEngine.channels) { channel in
                        ChannelRowView(
                            channel: channel,
                            isSelected: selectedChannelId == channel.id,
                            unreadCount: chatEngine.getUnreadCount(for: channel.id),
                            hasActiveArgument: argumentEngine.hasActiveArgument(in: channel.id)
                        ) {
                            selectedChannelId = channel.id
                        }
                        .scaleEffect(isAnimating ? 1.0 : 0.95)
                        .opacity(isAnimating ? 1.0 : 0.0)
                        .animation(.spring(response: 0.5, dampingFraction: 0.8).delay(Double(chatEngine.channels.firstIndex(of: channel) ?? 0) * 0.1), value: isAnimating)
                    }
                }
                .padding(.vertical, 8)
            }
            
            Spacer()
            
            // Status Footer
            VStack(alignment: .leading, spacing: 4) {
                Text("LIVE SIMULATION")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(DesignSystem.primaryGold)
                
                Text("🤖 \(chatEngine.totalMessages) messages")
                    .font(.system(size: 9))
                    .foregroundColor(.secondary)
                
                Text("⚔️ \(argumentEngine.activeArguments.count) active fights")
                    .font(.system(size: 9))
                    .foregroundColor(.red)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 12)
        }
        .frame(width: 240)
        .background(.regularMaterial)
        .overlay(
            Rectangle()
                .frame(width: 1)
                .foregroundColor(.separator),
            alignment: .trailing
        )
    }
    
    // MARK: - Chat View
    private func chatView(for channel: ProTraderChannel) -> some View {
        VStack(spacing: 0) {
            // Channel Header
            channelHeader(for: channel)
            
            Divider()
            
            // Messages
            messagesView(for: channel)
            
            // Input Area (Read Only)
            chatInputArea()
        }
    }
    
    private func channelHeader(for channel: ProTraderChannel) -> some View {
        HStack {
            HStack(spacing: 8) {
                Image(systemName: channel.channelType.systemImage)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(channel.channelType.color)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(channel.channelType.displayName)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.primary)
                    
                    Text(channel.description)
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            HStack(spacing: 16) {
                // Active Arguments Indicator
                if argumentEngine.hasActiveArgument(in: channel.id) {
                    HStack(spacing: 4) {
                        Image(systemName: "flame.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.red)
                        
                        Text("FIGHT!")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.red)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(.red.opacity(0.1))
                    .clipShape(Capsule())
                    .scaleEffect(isAnimating ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: isAnimating)
                }
                
                // Participants
                HStack(spacing: 4) {
                    Image(systemName: "person.2.fill")
                        .font(.system(size: 12))
                        .foregroundColor(.green)
                    
                    Text("\(channel.participantCount)")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.green)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(.ultraThinMaterial)
    }
    
    private func messagesView(for channel: ProTraderChannel) -> some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 12) {
                    let messages = chatEngine.getMessages(for: channel.id)
                    
                    ForEach(messages) { message in
                        MessageBubbleView(
                            message: message,
                            botPersona: chatEngine.getPersona(for: message.botId),
                            isInArgument: argumentEngine.isMessageInArgument(message.id)
                        )
                        .id(message.id)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
            .onChange(of: chatEngine.messages.count) { _ in
                if let lastMessage = chatEngine.getMessages(for: channel.id).last {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        proxy.scrollTo(lastMessage.id, anchor: .bottom)
                    }
                }
            }
        }
        .background(Color(.systemBackground))
    }
    
    private func chatInputArea() -> some View {
        VStack(spacing: 12) {
            HStack {
                Text("🤖 Watching bots trade and argue in real-time...")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .italic()
                
                Spacer()
                
                Button("Pause Simulation") {
                    chatEngine.pauseSimulation()
                }
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(DesignSystem.primaryGold)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 8)
            .background(.ultraThinMaterial)
            
            if let currentArgument = argumentEngine.activeArguments.first(where: { $0.channelId == selectedChannelId }) {
                ActiveArgumentView(argument: currentArgument, personas: chatEngine.botPersonas)
            }
        }
    }
    
    // MARK: - Welcome View
    private var welcomeView: some View {
        VStack(spacing: 24) {
            VStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(DesignSystem.goldGradient)
                        .frame(width: 80, height: 80)
                        .scaleEffect(isAnimating ? 1.1 : 1.0)
                        .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: isAnimating)
                    
                    Image(systemName: "bubble.left.and.bubble.right.fill")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.white)
                }
                
                VStack(spacing: 8) {
                    Text("ProTrader Discord")
                        .font(.system(size: 28, weight: .black, design: .rounded))
                        .foregroundColor(.primary)
                    
                    Text("Live Bot Trading Simulation")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.secondary)
                }
            }
            
            VStack(spacing: 16) {
                HStack(spacing: 20) {
                    StatCard(title: "Active Bots", value: "\(chatEngine.activeBotsCount)", color: .green)
                    StatCard(title: "Live Arguments", value: "\(argumentEngine.activeArguments.count)", color: .red)
                    StatCard(title: "Total Messages", value: "\(chatEngine.totalMessages)", color: .blue)
                }
                
                Text("Select a channel to watch bots argue over trades, share setups, and compete for trading supremacy!")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
        }
        .padding(40)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(
                colors: [
                    Color(.systemBackground),
                    DesignSystem.primaryGold.opacity(0.05),
                    Color(.systemBackground)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }
    
    // MARK: - Animation & Simulation Control
    private func startAnimations() {
        withAnimation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.2)) {
            isAnimating = true
        }
    }
    
    private func startChatSimulation() {
        chatEngine.startSimulation()
        argumentEngine.startArgumentGeneration()
    }
    
    private func stopChatSimulation() {
        chatEngine.stopSimulation()
        argumentEngine.stopArgumentGeneration()
    }
}

// MARK: - Supporting Views

struct ChannelRowView: View {
    let channel: ProTraderChannel
    let isSelected: Bool
    let unreadCount: Int
    let hasActiveArgument: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 8) {
                Image(systemName: channel.channelType.systemImage)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(isSelected ? .white : channel.channelType.color)
                    .frame(width: 16)
                
                Text(channel.name)
                    .font(.system(size: 13, weight: isSelected ? .semibold : .medium))
                    .foregroundColor(isSelected ? .white : .primary)
                
                Spacer()
                
                HStack(spacing: 4) {
                    if hasActiveArgument {
                        Image(systemName: "flame.fill")
                            .font(.system(size: 10))
                            .foregroundColor(.red)
                    }
                    
                    if unreadCount > 0 {
                        Text("\(unreadCount)")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(.red)
                            .clipShape(Capsule())
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(isSelected ? DesignSystem.primaryGold : Color.clear)
            .clipShape(RoundedRectangle(cornerRadius: 6))
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct MessageBubbleView: View {
    let message: ProTraderMessage
    let botPersona: BotPersona?
    let isInArgument: Bool
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Bot Avatar
            ZStack {
                Circle()
                    .fill(botPersona?.currentMood.color ?? .gray)
                    .frame(width: 36, height: 36)
                
                Text(botPersona?.avatar ?? "🤖")
                    .font(.system(size: 16))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                // Bot Name & Timestamp
                HStack(spacing: 8) {
                    Text(message.botName)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(botPersona?.personalityType.displayName.contains("🔥") == true ? .red : .primary)
                    
                    if let persona = botPersona {
                        Text(persona.reputationLevel)
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundColor(DesignSystem.primaryGold)
                    }
                    
                    Spacer()
                    
                    Text(message.formattedTimestamp)
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                }
                
                // Message Content
                VStack(alignment: .leading, spacing: 8) {
                    Text(message.content)
                        .font(.system(size: 14))
                        .foregroundColor(.primary)
                        .textSelection(.enabled)
                    
                    // Trade Setup (if any)
                    if let tradeSetup = message.tradeSetup {
                        TradeSetupView(tradeSetup: tradeSetup)
                    }
                    
                    // Message Type Tag
                    HStack {
                        Text(message.messageType.displayName)
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(message.messageType.color)
                            .clipShape(Capsule())
                        
                        if isInArgument {
                            Text("🔥 IN FIGHT")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(.red)
                                .clipShape(Capsule())
                        }
                        
                        Spacer()
                        
                        // Reactions
                        if !message.reactions.isEmpty {
                            HStack(spacing: 4) {
                                ForEach(message.reactions.prefix(3), id: \.emoji) { reaction in
                                    HStack(spacing: 2) {
                                        Text(reaction.emoji)
                                            .font(.system(size: 12))
                                        Text("\(reaction.count)")
                                            .font(.system(size: 10, weight: .semibold))
                                            .foregroundColor(.secondary)
                                    }
                                    .padding(.horizontal, 4)
                                    .padding(.vertical, 2)
                                    .background(.ultraThinMaterial)
                                    .clipShape(Capsule())
                                }
                            }
                        }
                    }
                }
            }
        }
        .padding()
        .background(isInArgument ? .red.opacity(0.05) : .clear)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isInArgument ? .red.opacity(0.3) : .clear, lineWidth: 1)
        )
    }
}

struct TradeSetupView: View {
    let tradeSetup: ProTraderMessage.TradeSetup
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("📈 TRADE SETUP")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(DesignSystem.primaryGold)
                    .clipShape(Capsule())
                
                Spacer()
                
                Text("Confidence: \(Int(tradeSetup.confidence * 100))%")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.secondary)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("Direction:")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.secondary)
                    Text(tradeSetup.direction.uppercased())
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(tradeSetup.direction.uppercased() == "BUY" ? .green : .red)
                }
                
                HStack {
                    Text("Entry: $\(tradeSetup.entryPrice, specifier: "%.2f")")
                    Text("SL: $\(tradeSetup.stopLoss, specifier: "%.2f")")
                    Text("TP: $\(tradeSetup.takeProfit, specifier: "%.2f")")
                }
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.primary)
                
                Text(tradeSetup.reasoning)
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
                    .italic()
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct ActiveArgumentView: View {
    let argument: TradingArgument
    let personas: [BotPersona]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("🔥 LIVE ARGUMENT")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.red)
                
                Text(argument.intensityLevel)
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(.red)
                    .clipShape(Capsule())
                
                Spacer()
                
                Text(argument.argumentType.displayName)
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }
            
            HStack {
                Text("Fighters:")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.secondary)
                
                ForEach(argument.participants.prefix(3), id: \.self) { botId in
                    if let persona = personas.first(where: { $0.botId == botId }) {
                        Text(persona.name)
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(.primary)
                    }
                }
            }
            
            Text("Topic: \(argument.topic)")
                .font(.system(size: 11))
                .foregroundColor(.secondary)
                .italic()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(.red.opacity(0.1))
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.red.opacity(0.3)),
            alignment: .top
        )
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(color)
            
            Text(title)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.secondary)
        }
        .frame(minWidth: 60)
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct BotProfilesView: View {
    let personas: [BotPersona]
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                    ForEach(personas.prefix(20)) { persona in
                        BotProfileCard(persona: persona)
                    }
                }
                .padding()
            }
            .navigationTitle("Bot Profiles")
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

struct BotProfileCard: View {
    let persona: BotPersona
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(persona.avatar)
                    .font(.system(size: 24))
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(persona.name)
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.primary)
                    
                    Text(persona.personalityType.displayName)
                        .font(.system(size: 10))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text(persona.reputationLevel)
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(DesignSystem.primaryGold)
                    
                    if persona.isOnWinStreak {
                        Text("🔥 \(persona.winStreak) wins")
                            .font(.system(size: 9, weight: .bold))
                            .foregroundColor(.green)
                    }
                }
            }
            
            Text(persona.favoritePhrase)
                .font(.system(size: 10))
                .foregroundColor(.secondary)
                .italic()
                .lineLimit(2)
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    DiscordSimulationView()
}