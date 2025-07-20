//
//  VoiceCommandView.swift - Revolutionary Voice Trading Interface
//  GOLDEX AI - Talk Your Way to Success! 🗣️💰
//
//  Created by AI Assistant on 7/18/25.
//

import SwiftUI

struct VoiceCommandView: View {
    @StateObject private var voiceService = VoiceCommandService()
    @State private var showingSettings = false
    @State private var animateVoiceVisuals = false
    @State private var pulseAnimation = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Voice Command Background
                voiceCommandBackground
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header
                        voiceCommandHeader
                        
                        // Voice Status
                        voiceStatusCard
                        
                        // Voice Visualizer
                        voiceVisualizerSection
                        
                        // Quick Commands
                        quickCommandsSection
                        
                        // Command History
                        commandHistorySection
                        
                        // Voice Settings
                        voiceSettingsSection
                        
                        Spacer(minLength: 100)
                    }
                    .padding()
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingSettings) {
                VoiceSettingsSheet(voiceService: voiceService)
            }
            .onAppear {
                withAnimation(.easeInOut(duration: 0.8).repeatForever()) {
                    animateVoiceVisuals = true
                }
            }
        }
    }
    
    // MARK: - Voice Command Background
    
    private var voiceCommandBackground: some View {
        LinearGradient(
            stops: [
                .init(color: Color.black, location: 0.0),
                .init(color: Color.purple.opacity(0.4), location: 0.3),
                .init(color: Color.blue.opacity(0.3), location: 0.6),
                .init(color: Color.black, location: 1.0)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    // MARK: - Header
    
    private var voiceCommandHeader: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("🗣️ VOICE COMMAND")
                        .font(.system(size: 28, weight: .black, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [DesignSystem.primaryGold, .white],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                    
                    Text("HANDS-FREE TRADING REVOLUTION")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white.opacity(0.8))
                        .tracking(2)
                }
                
                Spacer()
                
                Button(action: { showingSettings = true }) {
                    Image(systemName: "gear")
                        .font(.title2)
                        .foregroundColor(DesignSystem.primaryGold)
                }
            }
            
            // Voice Personality Indicator
            HStack {
                Text("PERSONALITY:")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.white.opacity(0.6))
                
                Text(voiceService.voicePersonality.rawValue.uppercased())
                    .font(.system(size: 12, weight: .black))
                    .foregroundColor(DesignSystem.primaryGold)
                
                Spacer()
                
                Text("STATUS: \(voiceService.isVoiceEnabled ? "ENABLED" : "DISABLED")")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(voiceService.isVoiceEnabled ? .green : .red)
            }
        }
    }
    
    // MARK: - Voice Status
    
    private var voiceStatusCard: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Voice Assistant Status")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Circle()
                    .fill(voiceService.isListening ? .green : .gray)
                    .frame(width: 12, height: 12)
                    .scaleEffect(voiceService.isListening && pulseAnimation ? 1.3 : 1.0)
                    .animation(.easeInOut(duration: 0.8).repeatForever(), value: pulseAnimation)
                    .onAppear { pulseAnimation = true }
                
                Text(voiceService.isListening ? "LISTENING" : "READY")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(voiceService.isListening ? .green : .white.opacity(0.7))
            }
            
            if !voiceService.lastCommand.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Last Command:")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.white.opacity(0.7))
                    
                    Text(voiceService.lastCommand)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(DesignSystem.primaryGold)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(.ultraThinMaterial)
                        )
                }
            }
            
            if !voiceService.voiceResponse.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Response:")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.white.opacity(0.7))
                    
                    Text(voiceService.voiceResponse)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.green)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(.green.opacity(0.1))
                        )
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.white.opacity(0.2), lineWidth: 1)
                )
        )
    }
    
    // MARK: - Voice Visualizer
    
    private var voiceVisualizerSection: some View {
        VStack(spacing: 20) {
            Text("🎤 Voice Visualizer")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(DesignSystem.primaryGold)
            
            // Main Voice Button
            Button(action: {
                voiceService.toggleListening()
            }) {
                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    voiceService.isListening ? .green.opacity(0.8) : DesignSystem.primaryGold.opacity(0.8),
                                    voiceService.isListening ? .green.opacity(0.3) : DesignSystem.primaryGold.opacity(0.3),
                                    .clear
                                ],
                                center: .center,
                                startRadius: 20,
                                endRadius: 80
                            )
                        )
                        .frame(width: 120, height: 120)
                        .scaleEffect(voiceService.isListening ? 1.2 : 1.0)
                        .animation(.easeInOut(duration: 0.3), value: voiceService.isListening)
                    
                    Circle()
                        .stroke(voiceService.isListening ? .green : DesignSystem.primaryGold, lineWidth: 3)
                        .frame(width: 120, height: 120)
                        .scaleEffect(animateVoiceVisuals ? 1.1 : 1.0)
                    
                    Image(systemName: voiceService.isListening ? "mic.fill" : "mic")
                        .font(.system(size: 40, weight: .medium))
                        .foregroundColor(.white)
                }
            }
            .disabled(!voiceService.isVoiceEnabled)
            
            // Voice Waveform Visualization
            if voiceService.isListening {
                voiceWaveform
            }
            
            // Recognition Accuracy
            if voiceService.recognitionAccuracy > 0 {
                VStack(spacing: 8) {
                    Text("Recognition Accuracy")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.white.opacity(0.7))
                    
                    ProgressView(value: voiceService.recognitionAccuracy, total: 1.0)
                        .progressViewStyle(LinearProgressViewStyle(tint: .green))
                        .scaleEffect(y: 2.0)
                    
                    Text("\(Int(voiceService.recognitionAccuracy * 100))%")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.green)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.ultraThinMaterial)
                )
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(DesignSystem.primaryGold.opacity(0.3), lineWidth: 2)
                )
        )
    }
    
    private var voiceWaveform: some View {
        HStack(spacing: 4) {
            ForEach(0..<20, id: \.self) { index in
                RoundedRectangle(cornerRadius: 2)
                    .fill(.green)
                    .frame(width: 6, height: CGFloat.random(in: 10...40))
                    .animation(
                        .easeInOut(duration: Double.random(in: 0.3...0.8))
                        .repeatForever(autoreverses: true)
                        .delay(Double(index) * 0.1),
                        value: animateVoiceVisuals
                    )
            }
        }
        .frame(height: 50)
    }
    
    // MARK: - Quick Commands
    
    private var quickCommandsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("🚀 Quick Commands")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(DesignSystem.primaryGold)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                ForEach(voiceService.supportedCommands.prefix(6), id: \.description) { command in
                    QuickCommandCard(command: command) {
                        // Simulate voice command
                        voiceService.lastCommand = command.examples.first ?? ""
                    }
                }
            }
            
            Text("💡 Pro Tip: Just say \"Hey GOLDEX\" followed by your command!")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.white.opacity(0.7))
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.blue.opacity(0.1))
                )
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
        )
    }
    
    // MARK: - Command History
    
    private var commandHistorySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("📝 Command History")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(DesignSystem.primaryGold)
                
                Spacer()
                
                Button("Clear") {
                    voiceService.clearCommandHistory()
                }
                .foregroundColor(.red)
                .font(.system(size: 12, weight: .medium))
            }
            
            if voiceService.commandHistory.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "mic.slash")
                        .font(.system(size: 24))
                        .foregroundColor(.white.opacity(0.5))
                    
                    Text("No voice commands yet")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                    
                    Text("Try saying \"Hey GOLDEX, show my portfolio\"")
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.5))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
            } else {
                LazyVStack(spacing: 8) {
                    ForEach(voiceService.getCommandHistory()) { historyItem in
                        CommandHistoryCard(historyItem: historyItem)
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
        )
    }
    
    // MARK: - Voice Settings
    
    private var voiceSettingsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("⚙️ Voice Settings")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(DesignSystem.primaryGold)
            
            VStack(spacing: 12) {
                HStack {
                    Text("Voice Personality")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Picker("Personality", selection: Binding(
                        get: { voiceService.voicePersonality },
                        set: { voiceService.setVoicePersonality($0) }
                    )) {
                        ForEach(VoiceCommandService.VoicePersonality.allCases, id: \.self) { personality in
                            Text(personality.rawValue).tag(personality)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .accentColor(DesignSystem.primaryGold)
                }
                
                HStack {
                    Text("Voice Recognition")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text(voiceService.isVoiceEnabled ? "Enabled" : "Disabled")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(voiceService.isVoiceEnabled ? .green : .red)
                }
                
                Button("Test Voice Response") {
                    // Test voice response
                }
                .foregroundColor(DesignSystem.primaryGold)
                .font(.system(size: 14, weight: .semibold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(DesignSystem.primaryGold, lineWidth: 1)
                )
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
        )
    }
}

// MARK: - Supporting Views

struct QuickCommandCard: View {
    let command: VoiceCommand
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                Text(command.action.rawValue)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(DesignSystem.primaryGold)
                
                Text(command.examples.first ?? "")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                
                Text(command.description)
                    .font(.system(size: 8, weight: .medium))
                    .foregroundColor(.white.opacity(0.6))
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(DesignSystem.primaryGold.opacity(0.3), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct CommandHistoryCard: View {
    let historyItem: VoiceCommandHistory
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(historyItem.action.rawValue)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(getActionColor(historyItem.action))
                
                Spacer()
                
                Text(timeAgo(historyItem.timestamp))
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.white.opacity(0.5))
            }
            
            Text("Command: \(historyItem.command)")
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.white.opacity(0.8))
            
            Text("Response: \(historyItem.response)")
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.green.opacity(0.8))
                .lineLimit(2)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(.ultraThinMaterial)
        )
    }
    
    private func getActionColor(_ action: VoiceAction) -> Color {
        switch action {
        case .trade: return .green
        case .showPortfolio: return .blue
        case .analyze: return .purple
        case .backtest: return .orange
        case .botControl: return .red
        case .marketNews: return .yellow
        case .positionManagement: return .cyan
        case .help: return .gray
        case .motivational: return DesignSystem.primaryGold
        }
    }
    
    private func timeAgo(_ date: Date) -> String {
        let interval = Date().timeIntervalSince(date)
        
        if interval < 60 {
            return "Now"
        } else if interval < 3600 {
            return "\(Int(interval / 60))m ago"
        } else {
            return "\(Int(interval / 3600))h ago"
        }
    }
}

struct VoiceSettingsSheet: View {
    let voiceService: VoiceCommandService
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Voice Command Settings")
                    .font(.title)
                    .padding()
                
                Text("Advanced voice settings coming soon...")
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            .navigationTitle("Voice Settings")
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

#Preview {
    VoiceCommandView()
}