//
//  ReplayEngineView.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 7/13/25.
//

import SwiftUI

struct ReplayEngineView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedReplayDate = Date()
    @State private var isReplaying = false
    @State private var replayProgress: Double = 0.0
    @State private var animateCards = false
    
    var body: some View {
        NavigationView {
            ZStack {
                DesignSystem.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header Section
                        headerSection
                        
                        // Date Selection
                        dateSelectionSection
                        
                        // Replay Controls
                        replayControlsSection
                        
                        // Progress Section
                        progressSection
                        
                        // Historical Data Preview
                        historicalDataSection
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .navigationTitle("Replay Engine")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(DesignSystem.primaryGold)
                }
            })
            .onAppear {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2)) {
                    animateCards = true
                }
            }
        }
    }
    
    private var headerSection: some View {
        UltraPremiumCard {
            VStack(spacing: 16) {
                HStack {
                    Image(systemName: "clock.arrow.circlepath")
                        .font(.system(size: 40))
                        .foregroundColor(DesignSystem.primaryGold)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Market Replay")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Text("Replay historical market data and analyze trading opportunities")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                }
                
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Available Data")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text("30 Days")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Speed")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text("10x Faster")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.green)
                    }
                }
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.9)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: animateCards)
    }
    
    private var dateSelectionSection: some View {
        UltraPremiumCard {
            VStack(alignment: .leading, spacing: 16) {
                Text("Select Replay Date")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                DatePicker("Date", selection: $selectedReplayDate, displayedComponents: .date)
                    .datePickerStyle(.graphical)
                    .accentColor(DesignSystem.primaryGold)
                
                Text("Selected: \(selectedReplayDate.formatted(date: .abbreviated, time: .omitted))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.9)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1), value: animateCards)
    }
    
    private var replayControlsSection: some View {
        UltraPremiumCard {
            VStack(spacing: 16) {
                HStack {
                    Text("Replay Controls")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Text(isReplaying ? "PLAYING" : "STOPPED")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(isReplaying ? .green : .red)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(isReplaying ? Color.green.opacity(0.1) : Color.red.opacity(0.1))
                        .cornerRadius(4)
                }
                
                HStack(spacing: 12) {
                    Button(action: {
                        startReplay()
                    }) {
                        HStack {
                            Image(systemName: "play.fill")
                                .font(.system(size: 12, weight: .medium))
                            Text("START")
                                .font(.system(size: 12, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.green)
                        .cornerRadius(8)
                    }
                    .disabled(isReplaying)
                    
                    Button(action: {
                        pauseReplay()
                    }) {
                        HStack {
                            Image(systemName: "pause.fill")
                                .font(.system(size: 12, weight: .medium))
                            Text("PAUSE")
                                .font(.system(size: 12, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.orange)
                        .cornerRadius(8)
                    }
                    .disabled(!isReplaying)
                    
                    Button(action: {
                        stopReplay()
                    }) {
                        HStack {
                            Image(systemName: "stop.fill")
                                .font(.system(size: 12, weight: .medium))
                            Text("STOP")
                                .font(.system(size: 12, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.red)
                        .cornerRadius(8)
                    }
                }
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.9)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2), value: animateCards)
    }
    
    private var progressSection: some View {
        UltraPremiumCard {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("Progress")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Text("\(Int(replayProgress * 100))%")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(DesignSystem.primaryGold)
                }
                
                ProgressView(value: replayProgress)
                    .progressViewStyle(LinearProgressViewStyle(tint: DesignSystem.primaryGold))
                    .scaleEffect(y: 2.0)
                
                HStack {
                    Text("Time Elapsed")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text("Remaining")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.9)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3), value: animateCards)
    }
    
    private var historicalDataSection: some View {
        UltraPremiumCard {
            VStack(alignment: .leading, spacing: 16) {
                Text("Historical Data Preview")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                VStack(spacing: 12) {
                    HStack {
                        Text("Gold Price Range")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Text("$2,650 - $2,680")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(DesignSystem.primaryGold)
                    }
                    
                    HStack {
                        Text("Volume")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Text("High")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.green)
                    }
                    
                    HStack {
                        Text("Market Sentiment")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Text("Bullish")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.green)
                    }
                }
                
                Text("This replay will show market movements and potential trading opportunities based on historical data.")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.top, 8)
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.9)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.4), value: animateCards)
    }
    
    // MARK: - Actions
    
    private func startReplay() {
        isReplaying = true
        replayProgress = 0.0
        
        // Simulate replay progress
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            replayProgress += 0.01
            if replayProgress >= 1.0 {
                timer.invalidate()
                isReplaying = false
                replayProgress = 1.0
            }
        }
    }
    
    private func pauseReplay() {
        isReplaying = false
    }
    
    private func stopReplay() {
        isReplaying = false
        replayProgress = 0.0
    }
}

struct ReplayEngineView_Previews: PreviewProvider {
    static var previews: some View {
        ReplayEngineView()
    }
}