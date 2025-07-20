//
//  GPTChatView.swift
//  GOLDEX AI
//
//  Created by Goldex AI on 7/19/25.
//

import SwiftUI
import UIKit            // required for UIBezierPath / UIRectCorner

struct GPTChatView: View {
    @StateObject private var gptIntegration = GPTIntegration()
    @State private var messageText = ""
    @State private var isTyping = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                
                // MARK: – Chat Header
                chatHeader
                
                // MARK: – Messages Area
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            
                            // Welcome
                            if gptIntegration.chatHistory.isEmpty {
                                welcomeMessage
                            }
                            
                            // Messages
                            ForEach(Array(gptIntegration.chatHistory.enumerated()), id: \.offset) { index, message in
                                ChatMessageBubble(message: message)
                                    .id(index)
                            }
                            
                            // Typing indicator
                            if gptIntegration.isLoading {
                                loadingIndicator
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                    }
                    // keep the list scrolled to bottom
                    .onChange(of: gptIntegration.chatHistory.count) { _, newCount in
                        guard newCount > 0 else { return }
                        withAnimation(.easeInOut) {
                            proxy.scrollTo(newCount - 1, anchor: .bottom)
                        }
                    }
                }
                
                // MARK: – Input
                messageInputArea
            }
            .background(DesignSystem.backgroundGradient)
            .navigationTitle("GPT-4 Oracle")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(DesignSystem.primaryGold)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Clear") {
                        gptIntegration.clearHistory()
                    }
                    .foregroundColor(DesignSystem.primaryGold)
                    .disabled(gptIntegration.chatHistory.isEmpty)
                }
            }
        }
    }
}

// MARK: - Sub-Views
private extension GPTChatView {
    
    // Chat Header
    var chatHeader: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [DesignSystem.primaryGold.opacity(0.2),
                                         DesignSystem.accentOrange.opacity(0.2)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 48, height: 48)
                    
                    Image(systemName: "brain.head.profile")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [DesignSystem.primaryGold, DesignSystem.accentOrange],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("GOLDEX GPT-4 ORACLE")
                        .font(DesignSystem.typography.headlineSmall)
                        .foregroundColor(DesignSystem.primaryText)
                    
                    HStack(spacing: 6) {
                        Circle()
                            .fill(.green)
                            .frame(width: 8, height: 8)
                        
                        Text("Online • Elite Trading Assistant")
                            .font(DesignSystem.typography.captionMedium)
                            .foregroundColor(DesignSystem.secondaryText)
                    }
                }
                
                Spacer()
            }
            
            // Quick Actions
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    QuickActionChip(
                        icon: "chart.xyaxis.line",
                        title: "Market Analysis"
                    ) {
                        sendQuickMessage("Analyze the current gold market conditions and provide trading recommendations")
                    }
                    
                    QuickActionChip(
                        icon: "bolt.fill",
                        title: "Signal Review"
                    ) {
                        sendQuickMessage("Review my latest trading signals and provide insights")
                    }
                    
                    QuickActionChip(
                        icon: "newspaper",
                        title: "News Impact"
                    ) {
                        sendQuickMessage("What news events are impacting gold prices today?")
                    }
                    
                    QuickActionChip(
                        icon: "brain",
                        title: "Strategy Tips"
                    ) {
                        sendQuickMessage("Give me 3 advanced gold trading strategies for this market")
                    }
                }
                .padding(.horizontal, 20)
            }
        }
        .padding(.vertical, 16)
        .background(DesignSystem.cardBackground)
    }
    
    // Welcome
    var welcomeMessage: some View {
        VStack(spacing: 16) {
            Image(systemName: "brain.head.profile.fill")
                .font(.system(size: 48, weight: .bold))
                .foregroundStyle(
                    LinearGradient(
                        colors: [DesignSystem.primaryGold, DesignSystem.accentOrange],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            Text("🏛️ Welcome to GPT-4 Oracle")
                .font(DesignSystem.typography.headlineLarge)
                .foregroundColor(DesignSystem.primaryText)
                .multilineTextAlignment(.center)
            
            Text("""
                 Your elite gold trading assistant powered by GPT-4. Ask me anything about:

                 • Market analysis & trends
                 • Trading strategies
                 • Risk management
                 • Technical analysis
                 • News impact assessment
                 """)
                .font(DesignSystem.typography.bodyMedium)
                .foregroundColor(DesignSystem.secondaryText)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
        }
        .padding(24)
        .background(DesignSystem.cardBackground)
        .cornerRadius(16)
        .padding(.top, 20)
    }
    
    // Typing Indicator
    var loadingIndicator: some View {
        HStack(spacing: 12) {
            Image(systemName: "brain.head.profile")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(DesignSystem.primaryGold)
            
            HStack(spacing: 4) {
                ForEach(0..<3) { index in
                    Circle()
                        .fill(DesignSystem.primaryGold)
                        .frame(width: 6, height: 6)
                        .scaleEffect(isTyping ? 1.2 : 0.8)
                        .animation(
                            .easeInOut(duration: 0.6)
                                .repeatForever(autoreverses: true)
                                .delay(Double(index) * 0.2),
                            value: isTyping
                        )
                }
            }
            
            Text("GPT-4 is thinking...")
                .font(DesignSystem.typography.bodyMedium)
                .foregroundColor(DesignSystem.secondaryText)
            
            Spacer()
        }
        .padding(16)
        .background(DesignSystem.cardBackground)
        .cornerRadius(12)
        .onAppear { isTyping = true }
        .onDisappear { isTyping = false }
    }
    
    // Input
    var messageInputArea: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                HStack(spacing: 12) {
                    Image(systemName: "message")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(DesignSystem.primaryGold)
                    
                    TextField("Ask GPT-4 about trading...", text: $messageText, axis: .vertical)
                        .font(DesignSystem.typography.bodyMedium)
                        .foregroundColor(DesignSystem.primaryText)
                        .lineLimit(1...4)
                        .submitLabel(.send)
                        .onSubmit { sendMessage() }
                }
                .padding(16)
                .background(DesignSystem.cardBackground)
                .cornerRadius(24)
                
                Button(action: sendMessage) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 32, weight: .semibold))
                        .foregroundStyle(
                            messageText.isEmpty
                            ? AnyShapeStyle(DesignSystem.secondaryText)
                            : AnyShapeStyle(
                                LinearGradient(
                                    colors: [DesignSystem.primaryGold, DesignSystem.accentOrange],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                              )
                        )
                }
                .disabled(messageText.isEmpty || gptIntegration.isLoading)
            }
            
            // Error
            if let error = gptIntegration.errorMessage {
                HStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.red)
                    Text(error)
                        .font(DesignSystem.typography.captionMedium)
                        .foregroundColor(.red)
                        .lineLimit(2)
                    Spacer()
                }
                .padding(.horizontal, 4)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(DesignSystem.cardBackground)
    }
    
    // Helper: user-typed message
    func sendMessage() {
        let trimmed = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        messageText = ""
        
        Task { await gptIntegration.chatWithGPT(message: trimmed) }
    }
    
    // Helper: quick chip tap
    func sendQuickMessage(_ message: String) {
        Task { await gptIntegration.chatWithGPT(message: message) }
    }
}

// MARK: - Chat Bubble
struct ChatMessageBubble: View {
    let message: GPTMessage
    
    var body: some View {
        HStack {
            if message.role == "user" {
                Spacer()
                VStack(alignment: .trailing, spacing: 4) {
                    Text(message.content)
                        .font(DesignSystem.typography.bodyMedium)
                        .foregroundColor(.white)
                        .padding(16)
                        .background(
                            LinearGradient(
                                colors: [DesignSystem.primaryGold, DesignSystem.accentOrange],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(18, corners: [.topLeft, .topRight, .bottomLeft])
                        .frame(maxWidth: UIScreen.main.bounds.width * 0.7, alignment: .trailing)
                    Text("You")
                        .font(DesignSystem.typography.captionRegular)
                        .foregroundColor(DesignSystem.secondaryText)
                }
            } else {
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: "brain.head.profile.fill")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(DesignSystem.primaryGold)
                        .frame(width: 32, height: 32)
                        .background(DesignSystem.primaryGold.opacity(0.1))
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(message.content)
                            .font(DesignSystem.typography.bodyMedium)
                            .foregroundColor(DesignSystem.primaryText)
                            .padding(16)
                            .background(DesignSystem.cardBackground)
                            .cornerRadius(18, corners: [.topLeft, .topRight, .bottomRight])
                            .frame(maxWidth: UIScreen.main.bounds.width * 0.7, alignment: .leading)
                        Text("GPT-4 Oracle")
                            .font(DesignSystem.typography.captionRegular)
                            .foregroundColor(DesignSystem.secondaryText)
                    }
                }
                Spacer()
            }
        }
    }
}

// MARK: - Quick Action Chip
struct QuickActionChip: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .medium))
                Text(title)
                    .font(DesignSystem.typography.captionMedium)
            }
            .foregroundColor(DesignSystem.primaryGold)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(DesignSystem.primaryGold.opacity(0.1))
            .cornerRadius(20)
            .overlay {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(DesignSystem.primaryGold.opacity(0.3), lineWidth: 1)
            }
        }
    }
}

// MARK: - Corner-Radius Utility
private extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

private struct RoundedCorner: Shape {
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

// MARK: - Preview
#Preview {
    GPTChatView()
}