//
//  SignalsView.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 7/13/25.
//

import SwiftUI

struct SignalsView: View {
    @EnvironmentObject var tradingViewModel: TradingViewModel
    @State private var showingSignalDetail = false
    @State private var selectedSignal: TradingModels.GoldSignal?
    
    var body: some View {
        NavigationStack {
            ZStack {
                DesignSystem.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Current Signal Card
                        if let currentSignal = tradingViewModel.currentSignal {
                            SignalCard(signal: currentSignal) {
                                selectedSignal = currentSignal
                                showingSignalDetail = true
                            }
                        }
                        
                        // Generate New Signal Button
                        Button(action: {
                            tradingViewModel.generateSignal()
                        }) {
                            HStack {
                                Image(systemName: "bolt.fill")
                                    .font(.system(size: 16, weight: .bold))
                                
                                Text("Generate New Signal")
                                    .font(.system(size: 16, weight: .semibold))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(
                                    colors: [DesignSystem.primaryGold, DesignSystem.primaryGold.opacity(0.8)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(12)
                        }
                        .disabled(tradingViewModel.isGeneratingSignal)
                        
                        // Signal History
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Signal History")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.primary)
                            
                            LazyVStack(spacing: 12) {
                                ForEach(tradingViewModel.signalHistory, id: \.id) { signal in
                                    QuickSignalCard(signal: signal) {
                                        selectedSignal = signal
                                        showingSignalDetail = true
                                    }
                                }
                            }
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .navigationTitle("Trading Signals")
            .navigationBarTitleDisplayMode(.large)
        }
        .sheet(item: $selectedSignal) { signal in
            SignalDetailView(signal: TradingTypes.GoldSignal(
                type: TradingTypes.GoldSignal.SignalType(rawValue: signal.type.rawValue) ?? .buy,
                entryPrice: signal.entryPrice,
                stopLoss: signal.stopLoss,
                takeProfit: signal.takeProfit,
                confidence: signal.confidence,
                timeframe: TradingTypes.GoldSignal.Timeframe(rawValue: signal.timeframe.rawValue) ?? .h1
            ))
        }
    }
}

struct SignalCard: View {
    let signal: TradingModels.GoldSignal
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("GOLD SIGNAL")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(DesignSystem.primaryGold)
                        
                        HStack(spacing: 8) {
                            Image(systemName: signal.type.icon)
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(signal.type.color)
                            
                            Text(signal.type.displayName.uppercased())
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.primary)
                        }
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("CONFIDENCE")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.secondary)
                        
                        Text(signal.formattedConfidence)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(DesignSystem.primaryGold)
                    }
                }
                
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("ENTRY PRICE")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.secondary)
                        
                        Text("$\(String(format: "%.2f", signal.entryPrice))")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.primary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .center, spacing: 4) {
                        Text("STOP LOSS")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.secondary)
                        
                        Text("$\(String(format: "%.2f", signal.stopLoss))")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.red)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("TAKE PROFIT")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.secondary)
                        
                        Text("$\(String(format: "%.2f", signal.takeProfit))")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.green)
                    }
                }
                
                Text(signal.reasoning)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
            }
            .padding()
            .background(.regularMaterial)
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct QuickSignalCard: View {
    let signal: TradingModels.GoldSignal
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                Image(systemName: signal.type.icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(signal.type.color)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(signal.type.displayName.uppercased())
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.primary)
                    
                    Text(signal.formattedEntryPrice)
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Text(signal.formattedConfidence)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(DesignSystem.primaryGold)
            }
            .padding()
            .background(.regularMaterial)
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    SignalsView()
        .environmentObject(TradingViewModel())
}