//
//  OpusDebugInterface.swift
//  Planet ProTrader
//
//  Created by Senior iOS Engineer - Missing Dependency Fix
//

import SwiftUI

struct OpusDebugInterface: View {
    @Environment(\.dismiss) private var dismiss
    @State private var debugLogs: [DebugLog] = []
    @State private var isActive = false
    
    struct DebugLog: Identifiable {
        let id = UUID()
        let timestamp: Date
        let level: LogLevel
        let message: String
        
        enum LogLevel: String, CaseIterable {
            case info = "INFO"
            case warning = "WARNING"
            case error = "ERROR"
            case success = "SUCCESS"
            
            var color: Color {
                switch self {
                case .info: return .blue
                case .warning: return .orange
                case .error: return .red
                case .success: return .green
                }
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                headerSection
                
                // Debug Console
                debugConsole
                
                // Controls
                controlsSection
            }
            .navigationTitle("OPUS AI Assistant")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(DesignSystem.primaryGold)
                }
            }
        }
        .onAppear {
            generateSampleLogs()
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "brain.head.profile.fill")
                    .font(.title)
                    .foregroundColor(isActive ? .green : .gray)
                
                VStack(alignment: .leading) {
                    Text("OPUS AI Status")
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    Text(isActive ? "Active & Learning" : "Standby Mode")
                        .font(.subheadline)
                        .foregroundColor(isActive ? .green : .secondary)
                }
                
                Spacer()
                
                Button(isActive ? "Pause" : "Activate") {
                    withAnimation {
                        isActive.toggle()
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isActive ? .red : .green)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .padding()
            .background(Color(.systemGray6))
        }
    }
    
    private var debugConsole: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Debug Console")
                .font(.headline)
                .padding(.horizontal)
            
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 4) {
                    ForEach(debugLogs.reversed()) { log in
                        HStack(alignment: .top) {
                            Text(log.timestamp, style: .time)
                                .font(.caption2)
                                .foregroundColor(.secondary)
                                .frame(width: 60, alignment: .leading)
                            
                            Text(log.level.rawValue)
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(log.level.color)
                                .frame(width: 70, alignment: .leading)
                            
                            Text(log.message)
                                .font(.caption)
                                .foregroundColor(.primary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(.horizontal, 4)
                        .padding(.vertical, 2)
                        .background(log.level.color.opacity(0.1))
                        .cornerRadius(4)
                    }
                }
                .padding(.horizontal)
            }
            .background(Color.black.opacity(0.1))
        }
    }
    
    private var controlsSection: some View {
        VStack(spacing: 12) {
            HStack {
                Button("Clear Logs") {
                    debugLogs.removeAll()
                }
                .foregroundColor(.red)
                
                Spacer()
                
                Button("Export Logs") {
                    // Handle export
                }
                .foregroundColor(DesignSystem.primaryGold)
                
                Spacer()
                
                Button("Refresh") {
                    generateSampleLogs()
                }
                .foregroundColor(.blue)
            }
            
            HStack {
                Text("Diagnostics: ")
                    .fontWeight(.semibold)
                
                Text("All systems operational")
                    .foregroundColor(.green)
                
                Spacer()
                
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
            }
        }
        .padding()
        .background(Color(.systemGray6))
    }
    
    private func generateSampleLogs() {
        debugLogs = [
            DebugLog(timestamp: Date(), level: .success, message: "OPUS AI system initialized successfully"),
            DebugLog(timestamp: Date().addingTimeInterval(-30), level: .info, message: "Market data connection established"),
            DebugLog(timestamp: Date().addingTimeInterval(-60), level: .info, message: "AI models loaded and ready"),
            DebugLog(timestamp: Date().addingTimeInterval(-90), level: .warning, message: "High volatility detected in XAUUSD"),
            DebugLog(timestamp: Date().addingTimeInterval(-120), level: .success, message: "Auto-trading signal generated"),
            DebugLog(timestamp: Date().addingTimeInterval(-150), level: .info, message: "Performance metrics updated"),
        ]
    }
}

#Preview {
    OpusDebugInterface()
}