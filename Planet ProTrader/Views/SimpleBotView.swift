//
//  SimpleBotView.swift
//  Planet ProTrader
//
//  Created by AI Assistant on 7/20/25.
//

import SwiftUI

struct SimpleBotView: View {
    @State private var isTrading = false
    @State private var botPerformance = 87.5
    @State private var totalTrades = 234
    @State private var winRate = 72.3
    
    var body: some View {
        NavigationView {
            ZStack {
                DesignSystem.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Bot Status Card
                        UltraPremiumCard {
                            VStack(spacing: 16) {
                                HStack {
                                    Image(systemName: "robot.fill")
                                        .font(.largeTitle)
                                        .foregroundColor(DesignSystem.primaryGold)
                                    
                                    VStack(alignment: .leading) {
                                        Text("ProTrader Bot")
                                            .font(.title2)
                                            .fontWeight(.bold)
                                        
                                        Text(isTrading ? "Active Trading" : "Standby")
                                            .font(.subheadline)
                                            .foregroundColor(isTrading ? .green : .orange)
                                    }
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        isTrading.toggle()
                                    }) {
                                        Text(isTrading ? "Stop" : "Start")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 20)
                                            .padding(.vertical, 10)
                                            .background(isTrading ? Color.red : Color.green)
                                            .cornerRadius(8)
                                    }
                                }
                            }
                        }
                        
                        // Performance Metrics
                        UltraPremiumCard {
                            VStack(spacing: 16) {
                                Text("Performance Metrics")
                                    .font(.headline)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                HStack {
                                    VStack {
                                        Text("\(Int(botPerformance))%")
                                            .font(.title)
                                            .fontWeight(.bold)
                                            .foregroundColor(DesignSystem.primaryGold)
                                        Text("Success Rate")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    Spacer()
                                    
                                    VStack {
                                        Text("\(totalTrades)")
                                            .font(.title)
                                            .fontWeight(.bold)
                                            .foregroundColor(.blue)
                                        Text("Total Trades")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    Spacer()
                                    
                                    VStack {
                                        Text("\(winRate, specifier: "%.1f")%")
                                            .font(.title)
                                            .fontWeight(.bold)
                                            .foregroundColor(.green)
                                        Text("Win Rate")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                        }
                        
                        // Quick Actions
                        UltraPremiumCard {
                            VStack(spacing: 16) {
                                Text("Quick Actions")
                                    .font(.headline)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                                    ActionButton(title: "View Trades", icon: "chart.line.uptrend.xyaxis") {
                                        // Navigate to trades view
                                    }
                                    
                                    ActionButton(title: "Bot Settings", icon: "gearshape.fill") {
                                        // Navigate to settings
                                    }
                                    
                                    ActionButton(title: "Performance", icon: "speedometer") {
                                        // Navigate to performance
                                    }
                                    
                                    ActionButton(title: "Analytics", icon: "chart.bar.fill") {
                                        // Navigate to analytics
                                    }
                                }
                            }
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .navigationTitle("ProTrader Bot")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ActionButton: View {
    let title: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(DesignSystem.primaryGold)
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
        }
    }
}

#Preview {
    SimpleBotView()
        .preferredColorScheme(.dark)
}