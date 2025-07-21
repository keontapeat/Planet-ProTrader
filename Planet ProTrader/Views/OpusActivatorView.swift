//
//  OpusActivatorView.swift
//  Planet ProTrader
//
//  Created by AI Assistant on 1/25/25.
//

import SwiftUI

struct OpusActivatorView: View {
    @StateObject private var opusService = OpusAutodebugService()
    @StateObject private var apiConfig = APIConfiguration()
    @State private var showingAPIConfig = false
    @State private var showingOpusInterface = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Premium background
                LinearGradient(
                    colors: [
                        Color(red: 0.05, green: 0.05, blue: 0.08),
                        Color(red: 0.08, green: 0.08, blue: 0.12)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 32) {
                        // Header
                        headerSection
                        
                        // API Status
                        apiStatusSection
                        
                        // Opus Status
                        opusStatusSection
                        
                        // Activation Button
                        activationButton
                        
                        // Quick Stats
                        if opusService.isActive {
                            quickStatsSection
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("OPUS HYPER AI")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showingAPIConfig) {
                APIConfigurationView()
            }
            .sheet(isPresented: $showingOpusInterface) {
                OpusDebugInterface()
            }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            Image(systemName: "cpu.fill")
                .font(.system(size: 64, weight: .bold))
                .foregroundStyle(
                    LinearGradient(
                        colors: [DesignSystem.primaryGold, .orange, .red],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            VStack(spacing: 8) {
                Text("🚀 OPUS HYPER AI")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(.white)
                
                Text("Claude Opus + Mark Douglas Psychology")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(DesignSystem.primaryGold)
                
                Text("Autonomous AI debugging at superhuman speeds")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
            }
        }
    }
    
    private var apiStatusSection: some View {
        ProfessionalCard {
            VStack(spacing: 16) {
                HStack {
                    Image(systemName: "key.fill")
                        .foregroundStyle(DesignSystem.primaryGold)
                    
                    Text("API Configuration")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(.white)
                    
                    Spacer()
                    
                    Button("Configure") {
                        showingAPIConfig = true
                    }
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(DesignSystem.primaryGold)
                }
                
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        apiStatusRow(
                            title: "Anthropic Claude Opus",
                            isValid: apiConfig.validateAnthropicKey(),
                            icon: "cpu.fill"
                        )
                        
                        apiStatusRow(
                            title: "OpenAI GPT-4",
                            isValid: apiConfig.validateOpenAIKey(),
                            icon: "brain.head.profile.fill"
                        )
                        
                        apiStatusRow(
                            title: "Supabase Database",
                            isValid: apiConfig.validateSupabaseConfig(),
                            icon: "cylinder.fill"
                        )
                    }
                    
                    Spacer()
                }
            }
        }
    }
    
    private var opusStatusSection: some View {
        ProfessionalCard {
            VStack(spacing: 16) {
                HStack {
                    Image(systemName: opusService.isActive ? "bolt.circle.fill" : "pause.circle.fill")
                        .foregroundStyle(opusService.isActive ? .green : .orange)
                        .font(.title2)
                    
                    Text("Opus Status")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(.white)
                    
                    Spacer()
                    
                    Text(opusService.isActive ? "ACTIVE" : "STANDBY")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(opusService.isActive ? .green : .orange)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background((opusService.isActive ? Color.green : Color.orange).opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(opusService.currentStatus)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.white.opacity(0.8))
                    
                    if opusService.isActive {
                        HStack {
                            Label("\(opusService.errorsFixed) fixes", systemImage: "checkmark.circle.fill")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundStyle(.green)
                            
                            Spacer()
                            
                            Label("\(String(format: "%.1f", opusService.performanceGains))% faster", systemImage: "speedometer")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundStyle(.blue)
                        }
                    }
                }
            }
        }
    }
    
    private var activationButton: some View {
        VStack(spacing: 12) {
            if apiConfig.validateAnthropicKey() {
                Button(action: {
                    if opusService.isActive {
                        showingOpusInterface = true
                    } else {
                        opusService.unleashOpusPower()
                    }
                }) {
                    HStack {
                        Image(systemName: opusService.isActive ? "eye.fill" : "bolt.fill")
                            .font(.title2)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(opusService.isActive ? "VIEW HYPER INTERFACE" : "🚀 UNLEASH OPUS POWER")
                                .font(.system(size: 16, weight: .bold))
                            
                            Text(opusService.isActive ? "Monitor real-time optimizations" : "Activate autonomous debugging")
                                .font(.system(size: 12, weight: .medium))
                                .opacity(0.8)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.title3)
                    }
                    .foregroundColor(.black)
                    .padding()
                    .background(
                        LinearGradient(
                            colors: opusService.isActive ? [.blue, .purple] : [DesignSystem.primaryGold, .orange, .red],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            } else {
                Button(action: {
                    showingAPIConfig = true
                }) {
                    HStack {
                        Image(systemName: "key.fill")
                        Text("Configure API Key First")
                    }
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.gray.opacity(0.3))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            
            if opusService.isActive {
                Button(action: {
                    opusService.stopOpus()
                }) {
                    HStack {
                        Image(systemName: "stop.fill")
                        Text("Stop Opus")
                    }
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.red.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.red.opacity(0.3), lineWidth: 1)
                    )
                }
            }
        }
    }
    
    private var quickStatsSection: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
            StatCard(
                title: "Speed Multiplier",
                value: "\(String(format: "%.1f", opusService.hyperEngine.speedMultiplier))x",
                icon: "speedometer",
                color: .orange
            )
            
            StatCard(
                title: "Mental Clarity",
                value: "\(String(format: "%.0f", opusService.hyperEngine.performanceMetrics.markDouglasAlignment * 100))%",
                icon: "brain.head.profile.fill",
                color: .purple
            )
            
            StatCard(
                title: "Optimizations",
                value: "\(opusService.hyperEngine.performanceMetrics.totalOptimizations)",
                icon: "gearshape.2.fill",
                color: .blue
            )
            
            StatCard(
                title: "Recent Fixes",
                value: "\(opusService.recentFixes.count)",
                icon: "checkmark.circle.fill",
                color: .green
            )
        }
    }
    
    private func apiStatusRow(title: String, isValid: Bool, icon: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundStyle(isValid ? .green : .orange)
                .font(.system(size: 14))
            
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.white.opacity(0.8))
            
            Spacer()
            
            Image(systemName: isValid ? "checkmark.circle.fill" : "exclamationmark.circle.fill")
                .foregroundStyle(isValid ? .green : .orange)
                .font(.system(size: 14))
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)
            
            Text(value)
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(.white)
            
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(.white.opacity(0.7))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(color.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

#Preview {
    OpusActivatorView()
}