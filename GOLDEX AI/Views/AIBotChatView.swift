//
//  AIBotChatView.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 1/21/25.
//

import SwiftUI

struct AIBotChatView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var chatManager = BotChatManager.shared
    @State private var messageText = ""
    @State private var selectedBot: TradingBotProfile?
    @State private var showBotSelector = false
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Chat header with bot selector
                chatHeader
                
                // Messages list
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(chatManager.messages) { message in
                                ChatMessageView(message: message)
                                    .id(message.id)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                    }
                    .onChange(of: chatManager.messages.count) { _ in
                        if let lastMessage = chatManager.messages.last {
                            withAnimation(.easeOut(duration: 0.5)) {
                                proxy.scrollTo(lastMessage.id, anchor: .bottom)
                            }
                        }
                    }
                }
                
                // Message input
                messageInputView
            }
            .background(Color(.systemBackground))
            .navigationTitle("🤖 Bot Chat")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .foregroundColor(DesignSystem.primaryGold)
                }
            }
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
        .sheet(isPresented: $showBotSelector) {
            BotSelectorView(selectedBot: $selectedBot)
        }
        .onAppear {
            selectedBot = chatManager.availableBots.first
            chatManager.startConversation()
        }
    }
    
    // MARK: - Chat Header
    
    private var chatHeader: some View {
        VStack(spacing: 12) {
            HStack {
                // Active bot display
                if let bot = selectedBot {
                    HStack(spacing: 12) {
                        // Bot avatar
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [bot.primaryColor, bot.secondaryColor],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 50, height: 50)
                            
                            Image(systemName: bot.icon)
                                .font(.title2)
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                            
                            // Activity indicator
                            if bot.isActive {
                                Circle()
                                    .fill(Color.green)
                                    .frame(width: 12, height: 12)
                                    .offset(x: 18, y: -18)
                                    .scaleEffect(1.0)
                                    .animation(.easeInOut(duration: 1.0).repeatForever(), value: bot.isActive)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(bot.name)
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            
                            HStack(spacing: 8) {
                                Text(bot.status)
                                    .font(.caption)
                                    .foregroundColor(bot.statusColor)
                                
                                Text("•")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                
                                Text("Win Rate: \(Int(bot.winRate * 100))%")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        Spacer()
                        
                        // Bot selector
                        Button(action: { showBotSelector = true }) {
                            Image(systemName: "chevron.down.circle.fill")
                                .font(.title3)
                                .foregroundColor(DesignSystem.primaryGold)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6).opacity(0.5))
                    .cornerRadius(16)
                }
            }
            
            // Quick actions
            quickActionsBar
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(Color(.systemGray6).opacity(0.3))
    }
    
    private var quickActionsBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                quickActionButton(
                    title: "Current Trades",
                    icon: "chart.bar.fill",
                    action: { sendQuickMessage("Show me my current trades") }
                )
                
                quickActionButton(
                    title: "P&L Today",
                    icon: "dollarsign.circle.fill",
                    action: { sendQuickMessage("What's my P&L today?") }
                )
                
                quickActionButton(
                    title: "Market Analysis",
                    icon: "brain.head.profile",
                    action: { sendQuickMessage("Give me your market analysis") }
                )
                
                quickActionButton(
                    title: "Risk Check",
                    icon: "shield.checkerboard",
                    action: { sendQuickMessage("Check my risk levels") }
                )
                
                quickActionButton(
                    title: "Strategy",
                    icon: "target",
                    action: { sendQuickMessage("Explain your current strategy") }
                )
            }
            .padding(.horizontal, 4)
        }
    }
    
    private func quickActionButton(title: String, icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.caption)
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .foregroundColor(DesignSystem.primaryGold)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(DesignSystem.primaryGold.opacity(0.1))
            .cornerRadius(8)
        }
    }
    
    // MARK: - Message Input
    
    private var messageInputView: some View {
        VStack(spacing: 0) {
            Divider()
            
            HStack(spacing: 12) {
                // Voice input button
                Button(action: {
                    // Start voice recording
                    ToastManager.shared.showTrading("Voice commands coming soon!")
                }) {
                    Image(systemName: "mic.fill")
                        .font(.title3)
                        .foregroundColor(DesignSystem.primaryGold)
                        .padding(10)
                        .background(DesignSystem.primaryGold.opacity(0.1))
                        .clipShape(Circle())
                }
                
                // Text input
                TextField("Ask your bot anything...", text: $messageText, axis: .vertical)
                    .focused($isTextFieldFocused)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .lineLimit(1...4)
                
                // Send button
                Button(action: sendMessage) {
                    Image(systemName: "paperplane.fill")
                        .font(.title3)
                        .foregroundColor(.white)
                        .padding(10)
                        .background(
                            messageText.isEmpty 
                            ? Color.gray 
                            : DesignSystem.primaryGold
                        )
                        .clipShape(Circle())
                }
                .disabled(messageText.isEmpty)
            }
            .padding()
        }
        .background(Color(.systemBackground))
    }
    
    // MARK: - Helper Methods
    
    private func sendMessage() {
        guard !messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        chatManager.sendMessage(messageText, to: selectedBot)
        messageText = ""
        isTextFieldFocused = false
    }
    
    private func sendQuickMessage(_ message: String) {
        chatManager.sendMessage(message, to: selectedBot)
    }
}

// MARK: - Chat Message View

struct ChatMessageView: View {
    let message: BotChatMessage
    
    var body: some View {
        HStack {
            if message.isFromUser {
                Spacer()
                userMessageBubble
            } else {
                botMessageBubble
                Spacer()
            }
        }
    }
    
    private var userMessageBubble: some View {
        VStack(alignment: .trailing, spacing: 4) {
            Text(message.content)
                .font(.subheadline)
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(DesignSystem.primaryGold)
                .cornerRadius(16, corners: [.topLeft, .topRight, .bottomLeft])
            
            Text(message.timestamp.formatted(.dateTime.hour().minute()))
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: 250, alignment: .trailing)
    }
    
    private var botMessageBubble: some View {
        HStack(alignment: .top, spacing: 12) {
            // Bot avatar
            Circle()
                .fill(
                    LinearGradient(
                        colors: [Color.blue, Color.purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 32, height: 32)
                .overlay(
                    Image(systemName: "robot.fill")
                        .font(.caption)
                        .foregroundColor(.white)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                // Message content
                if message.hasSpecialContent {
                    specialContentView(for: message)
                } else {
                    Text(message.content)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(Color(.systemGray6))
                        .cornerRadius(16, corners: [.topLeft, .topRight, .bottomRight])
                }
                
                HStack {
                    Text(message.botName)
                        .font(.caption2)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                    
                    Text("•")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    
                    Text(message.timestamp.formatted(.dateTime.hour().minute()))
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
        }
        .frame(maxWidth: 280, alignment: .leading)
    }
    
    private func specialContentView(for message: BotChatMessage) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            // Special content based on message type
            if message.content.contains("trades") {
                tradingStatsCard
            } else if message.content.contains("P&L") {
                plStatsCard
            } else if message.content.contains("analysis") {
                marketAnalysisCard
            } else {
                Text(message.content)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color(.systemGray6))
                    .cornerRadius(16, corners: [.topLeft, .topRight, .bottomRight])
            }
        }
    }
    
    private var tradingStatsCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("📊 Current Trading Status")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Active Trades")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    Text("3")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Profit/Loss")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    Text("+$127.50")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Win Rate")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    Text("73%")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                }
            }
        }
        .padding(12)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private var plStatsCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("💰 Today's P&L Breakdown")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            VStack(spacing: 4) {
                plRow(label: "EUR/USD", value: "+$87.25", color: .green)
                plRow(label: "GBP/USD", value: "+$45.75", color: .green)
                plRow(label: "USD/JPY", value: "-$15.50", color: .red)
                
                Divider()
                
                HStack {
                    Text("Total P&L")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Text("+$117.50")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                }
            }
        }
        .padding(12)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private func plRow(label: String, value: String, color: Color) -> some View {
        HStack {
            Text(label)
                .font(.caption2)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.caption2)
                .fontWeight(.medium)
                .foregroundColor(color)
        }
    }
    
    private var marketAnalysisCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("🧠 Market Analysis")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            VStack(alignment: .leading, spacing: 6) {
                analysisRow(icon: "arrow.up", text: "EUR/USD showing bullish momentum", color: .green)
                analysisRow(icon: "arrow.down", text: "DXY weakening on Fed dovish stance", color: .red)
                analysisRow(icon: "exclamationmark.triangle", text: "High impact news at 2:30 PM EST", color: .orange)
            }
        }
        .padding(12)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private func analysisRow(icon: String, text: String, color: Color) -> some View {
        HStack(alignment: .top, spacing: 6) {
            Image(systemName: icon)
                .font(.caption2)
                .foregroundColor(color)
                .padding(.top, 1)
            
            Text(text)
                .font(.caption2)
                .foregroundColor(.primary)
                .lineLimit(2)
        }
    }
}

// MARK: - Bot Chat Manager

class BotChatManager: ObservableObject {
    static let shared = BotChatManager()
    
    @Published var messages: [BotChatMessage] = []
    @Published var availableBots: [TradingBotProfile] = []
    @Published var isTyping = false
    
    private init() {
        setupAvailableBots()
    }
    
    func startConversation() {
        // Welcome message
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.addBotMessage(
                "👋 Hey there! I'm your AI trading assistant. I've been analyzing the markets and managing your positions. How can I help you today?",
                botName: "Quantum AI Pro"
            )
        }
    }
    
    func sendMessage(_ content: String, to bot: TradingBotProfile?) {
        // Add user message
        let userMessage = BotChatMessage(
            content: content,
            isFromUser: true,
            botName: "",
            timestamp: Date()
        )
        messages.append(userMessage)
        
        // Simulate bot typing
        isTyping = true
        
        // Generate AI response
        DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 1.0...2.5)) {
            self.isTyping = false
            let response = self.generateBotResponse(to: content, from: bot)
            self.addBotMessage(response, botName: bot?.name ?? "AI Bot")
        }
    }
    
    private func addBotMessage(_ content: String, botName: String) {
        let botMessage = BotChatMessage(
            content: content,
            isFromUser: false,
            botName: botName,
            timestamp: Date()
        )
        messages.append(botMessage)
    }
    
    private func generateBotResponse(to message: String, from bot: TradingBotProfile?) -> String {
        let lowercaseMessage = message.lowercased()
        
        if lowercaseMessage.contains("trades") || lowercaseMessage.contains("position") {
            return "I'm currently managing 3 active positions for you. EUR/USD and GBP/USD are both in profit, while USD/JPY is slightly underwater but within acceptable risk parameters. Would you like me to show you the detailed breakdown?"
        }
        
        if lowercaseMessage.contains("p&l") || lowercaseMessage.contains("profit") {
            return "Great question! Today's performance has been strong with a total P&L of +$117.50. The EUR/USD trade has been our biggest winner at +$87.25. I'm maintaining a 73% win rate this week."
        }
        
        if lowercaseMessage.contains("analysis") || lowercaseMessage.contains("market") {
            return "Based on my current analysis, I'm seeing bullish momentum in EUR/USD with the DXY showing weakness. There's a high-impact news event coming at 2:30 PM EST that I'm monitoring closely. I've already adjusted position sizes accordingly."
        }
        
        if lowercaseMessage.contains("risk") || lowercaseMessage.contains("safety") {
            return "Risk management is my top priority! Current portfolio risk is at 2.3% (well below our 5% limit). All positions have proper stop losses, and I'm monitoring correlation exposure. Your account is safe with me! 🛡️"
        }
        
        if lowercaseMessage.contains("strategy") || lowercaseMessage.contains("plan") {
            return "My current strategy focuses on trend-following with smart money concepts. I'm using multi-timeframe analysis and waiting for high-probability setups. The market structure is bullish on higher timeframes, so I'm biased towards long positions in risk-on currencies."
        }
        
        // Default responses
        let responses = [
            "I'm constantly analyzing market data to find the best opportunities for you. Is there something specific you'd like to know about your trading performance?",
            "The markets are looking interesting today! I've identified several potential setups that align with our risk parameters. Want me to walk you through them?",
            "I appreciate you checking in! Your portfolio is performing well and I'm staying vigilant for any market changes. How can I assist you further?",
            "Great to hear from you! I've been busy optimizing our trading strategies based on recent market conditions. What would you like to discuss?",
            "I'm here and ready to help! My AI systems are running 24/7 to ensure we don't miss any profitable opportunities. What's on your mind?"
        ]
        
        return responses.randomElement() ?? "I'm here to help with your trading needs!"
    }
    
    private func setupAvailableBots() {
        availableBots = [
            TradingBotProfile(
                name: "Quantum AI Pro",
                icon: "brain.head.profile",
                primaryColor: .purple,
                secondaryColor: .blue,
                status: "Active • Trading",
                isActive: true,
                winRate: 0.73
            ),
            TradingBotProfile(
                name: "Gold Scalper Elite",
                icon: "bolt.fill",
                primaryColor: DesignSystem.primaryGold,
                secondaryColor: .orange,
                status: "Active • Scalping",
                isActive: true,
                winRate: 0.68
            ),
            TradingBotProfile(
                name: "Trend Master 3000",
                icon: "chart.line.uptrend.xyaxis",
                primaryColor: .green,
                secondaryColor: .mint,
                status: "Monitoring",
                isActive: false,
                winRate: 0.81
            )
        ]
    }
}

// MARK: - Supporting Models

struct BotChatMessage: Identifiable {
    let id = UUID()
    let content: String
    let isFromUser: Bool
    let botName: String
    let timestamp: Date
    
    var hasSpecialContent: Bool {
        return content.contains("trades") || content.contains("P&L") || content.contains("analysis")
    }
}

struct TradingBotProfile: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let primaryColor: Color
    let secondaryColor: Color
    let status: String
    let isActive: Bool
    let winRate: Double
    
    var statusColor: Color {
        return isActive ? .green : .orange
    }
}

// MARK: - Corner Radius Extension

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    AIBotChatView()
}