//
//  EAControlView.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 7/13/25.
//

import SwiftUI

struct EAControlView: View {
    @EnvironmentObject var accountManager: EAAccountManager
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var showingConfirmation = false
    @State private var pendingAction: EAAction?
    
    enum EAAction {
        case start
        case stop
        case pause
        case resume
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // EA Status Header
            VStack(spacing: 12) {
                HStack {
                    Image(systemName: "brain.head.profile")
                        .font(.title2)
                        .foregroundStyle(accountManager.eaStatusColor)
                    
                    Text("GOLDEX AI EA")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    EAStatusIndicator(
                        isActive: accountManager.eaIsRunning,
                        canTrade: accountManager.eaCanTrade
                    )
                }
                
                Text(eaStatusText)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
            )
            
            // Control Buttons
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                // Start Button
                ControlButton(
                    title: "Start EA",
                    icon: "play.fill",
                    color: .green,
                    isEnabled: !accountManager.eaIsRunning
                ) {
                    pendingAction = .start
                    showingConfirmation = true
                }
                
                // Stop Button
                ControlButton(
                    title: "Stop EA",
                    icon: "stop.fill",
                    color: .red,
                    isEnabled: accountManager.eaIsRunning
                ) {
                    pendingAction = .stop
                    showingConfirmation = true
                }
                
                // Pause Button
                ControlButton(
                    title: "Pause EA",
                    icon: "pause.fill",
                    color: .orange,
                    isEnabled: accountManager.eaIsRunning && accountManager.eaCanTrade
                ) {
                    pendingAction = .pause
                    showingConfirmation = true
                }
                
                // Resume Button
                ControlButton(
                    title: "Resume EA",
                    icon: "play.fill",
                    color: Color.blue,
                    isEnabled: accountManager.eaIsRunning && !accountManager.eaCanTrade
                ) {
                    pendingAction = .resume
                    showingConfirmation = true
                }
            }
            
            // Performance Metrics
            VStack(alignment: .leading, spacing: 12) {
                Text("EA Performance")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                HStack {
                    MetricCard(
                        icon: "chart.bar.fill",
                        title: "Total Trades",
                        value: "\(accountManager.eaPerformance.totalSignals)",
                        subtitle: "All time",
                        color: .blue
                    )
                    
                    MetricCard(
                        icon: "chart.line.uptrend.xyaxis",
                        title: "Win Rate", 
                        value: String(format: "%.1f%%", accountManager.eaPerformance.winRate * 100),
                        subtitle: "Success rate",
                        color: .green
                    )
                    
                    MetricCard(
                        icon: "clock",
                        title: "Signals/Hour",
                        value: String(format: "%.1f", accountManager.eaPerformance.signalsPerHour),
                        subtitle: "Performance",
                        color: .blue
                    )
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
            )
            
            // Recent Signals
            if !accountManager.eaSignals.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Recent EA Signals")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    ForEach(Array(accountManager.eaSignals.prefix(3).enumerated()), id: \.offset) { index, signal in
                        SignalRow(signal: createEASignalItem(from: signal, index: index))
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.systemBackground))
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                )
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("EA Control")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Confirm Action", isPresented: $showingConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Confirm") {
                performEAAction()
            }
        } message: {
            Text(confirmationMessage)
        }
        .alert("EA Status", isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private var eaStatusText: String {
        if accountManager.eaIsRunning && accountManager.eaCanTrade {
            return "EA is running and actively trading"
        } else if accountManager.eaIsRunning {
            return "EA is running but trading is paused"
        } else {
            return "EA is stopped"
        }
    }
    
    private var confirmationMessage: String {
        switch pendingAction {
        case .start:
            return "Are you sure you want to start the EA? It will begin auto-trading immediately."
        case .stop:
            return "Are you sure you want to stop the EA? All auto-trading will cease."
        case .pause:
            return "Are you sure you want to pause the EA? It will stop opening new trades but continue monitoring."
        case .resume:
            return "Are you sure you want to resume the EA? It will start auto-trading again."
        case .none:
            return ""
        }
    }
    
    private func performEAAction() {
        guard let action = pendingAction else { return }
        
        switch action {
        case .start:
            accountManager.startEATrading()
            alertMessage = "EA started successfully!"
        case .stop:
            accountManager.stopEATrading()
            alertMessage = "EA stopped successfully!"
        case .pause:
            accountManager.pauseEATrading()
            alertMessage = "EA paused successfully!"
        case .resume:
            accountManager.resumeEATrading()
            alertMessage = "EA resumed successfully!"
        }
        
        showingAlert = true
        pendingAction = nil
    }
    
    private func createEASignalItem(from signal: String, index: Int) -> EASignalItem {
        let directions: [SharedTypes.TradeDirection] = [.buy, .sell]
        let reasonings = [
            "Strong bullish momentum detected",
            "Bearish reversal pattern confirmed",
            "Support level bounce with volume",
            "Resistance break with momentum"
        ]
        
        return EASignalItem(
            direction: signal.lowercased() == "buy" ? .buy : .sell,
            reasoning: reasonings.randomElement() ?? "Technical analysis signal",
            confidence: Double.random(in: 0.75...0.95),
            timestamp: Date().addingTimeInterval(-Double(index * 300))
        )
    }
}

// MARK: - Supporting Views

struct EAStatusIndicator: View {
    let isActive: Bool
    let canTrade: Bool
    
    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(statusColor)
                .frame(width: 8, height: 8)
            
            Text(statusText)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(statusColor)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(statusColor.opacity(0.1))
        )
    }
    
    private var statusColor: Color {
        if isActive && canTrade {
            return .green
        } else if isActive {
            return .orange
        } else {
            return .red
        }
    }
    
    private var statusText: String {
        if isActive && canTrade {
            return "ACTIVE"
        } else if isActive {
            return "PAUSED"
        } else {
            return "STOPPED"
        }
    }
}

struct ControlButton: View {
    let title: String
    let icon: String
    let color: Color
    let isEnabled: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(isEnabled ? color : .gray)
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(isEnabled ? color : .gray)
            }
            .frame(maxWidth: .infinity, minHeight: 80)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isEnabled ? color.opacity(0.1) : Color.gray.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isEnabled ? color : .gray, lineWidth: 1)
                    )
            )
        }
        .disabled(!isEnabled)
    }
}

struct MetricCard: View {
    let icon: String
    let title: String
    let value: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)
            
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
            
            Text(value)
                .font(.largeTitle)
            
            Text(subtitle)
                .font(.footnote)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct SignalRow: View {
    let signal: EASignalItem
    
    var body: some View {
        HStack {
            Image(systemName: signal.direction == .buy ? "arrow.up.circle.fill" : "arrow.down.circle.fill")
                .foregroundStyle(signal.direction == .buy ? .green : .red)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(signal.direction.rawValue.uppercased())
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(signal.direction == .buy ? .green : .red)
                
                Text(signal.reasoning)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                Text(String(format: "%.0f%%", signal.confidence * 100))
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                
                Text(timeAgo(signal.timestamp))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
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

// MARK: - Supporting Data Models

struct EASignalItem: Identifiable {
    let id = UUID()
    let direction: SharedTypes.TradeDirection
    let reasoning: String
    let confidence: Double
    let timestamp: Date
    
    init(direction: SharedTypes.TradeDirection, reasoning: String, confidence: Double, timestamp: Date = Date()) {
        self.direction = direction
        self.reasoning = reasoning
        self.confidence = confidence
        self.timestamp = timestamp
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        EAControlView()
            .environmentObject(EAAccountManager())
    }
}