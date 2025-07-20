//
//  SignalDetailView.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 7/13/25.
//

import SwiftUI

struct SignalDetailView: View {
    let signal: TradingTypes.GoldSignal
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            mainContent
        }
    }
    
    private var mainContent: some View {
        ZStack {
            DesignSystem.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    // Signal Header
                    UltraPremiumCard {
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Signal Details")
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(.primary)
                                    
                                    HStack {
                                        Image(systemName: signal.type.icon)
                                            .font(.system(size: 24, weight: .bold))
                                            .foregroundColor(signal.type.color)
                                        
                                        Text(signal.type.rawValue)
                                            .font(.system(size: 28, weight: .bold))
                                            .foregroundColor(.primary)
                                    }
                                }
                                
                                Spacer()
                                
                                VStack(alignment: .trailing, spacing: 4) {
                                    Text("Confidence")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(.secondary)
                                    
                                    Text("\(String(format: "%.0f", signal.confidence * 100))%")
                                        .font(.system(size: 24, weight: .bold))
                                        .foregroundColor(signal.confidence > 0.8 ? .green : .orange)
                                }
                            }
                            
                            Text("Generated: \(Date().formatted())")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    // Price Levels
                    UltraPremiumCard {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Price Levels")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.primary)
                            
                            VStack(spacing: 12) {
                                HStack {
                                    Text("Entry Price")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.secondary)
                                    
                                    Spacer()
                                    
                                    Text("$\(String(format: "%.2f", signal.entryPrice))")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.primary)
                                }
                                
                                HStack {
                                    Text("Stop Loss")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.secondary)
                                    
                                    Spacer()
                                    
                                    Text("$\(String(format: "%.2f", signal.stopLoss))")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.red)
                                }
                                
                                HStack {
                                    Text("Take Profit")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.secondary)
                                    
                                    Spacer()
                                    
                                    Text("$\(String(format: "%.2f", signal.takeProfit))")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.green)
                                }
                                
                                HStack {
                                    Text("Risk/Reward")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.secondary)
                                    
                                    Spacer()
                                    
                                    Text("1:\(String(format: "%.1f", signal.riskRewardRatio))")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                    }
                    
                    // Analysis
                    UltraPremiumCard {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Analysis")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.primary)
                            
                            Text(generateAnalysisText(for: signal))
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.leading)
                            
                            HStack {
                                Text("Timeframe")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.secondary)
                                
                                Spacer()
                                
                                Text(signal.timeframe.rawValue)
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.primary)
                            }
                        }
                    }
                    
                    // Signal Strength Indicator
                    UltraPremiumCard {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Signal Strength")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.primary)
                            
                            VStack(spacing: 12) {
                                HStack {
                                    Text("Confidence Level")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.secondary)
                                    
                                    Spacer()
                                    
                                    Text(getConfidenceLevel(signal.confidence))
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(getConfidenceLevelColor(signal.confidence))
                                }
                                
                                ProgressView(value: signal.confidence)
                                    .progressViewStyle(LinearProgressViewStyle(tint: getConfidenceLevelColor(signal.confidence)))
                                    .scaleEffect(y: 2.0)
                                
                                HStack {
                                    Text("Risk Assessment")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.secondary)
                                    
                                    Spacer()
                                    
                                    Text(getRiskLevel(signal.riskRewardRatio))
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(getRiskLevelColor(signal.riskRewardRatio))
                                }
                            }
                        }
                    }
                    
                    Spacer(minLength: 50)
                }
                .padding(.horizontal, 20)
            }
        }
        .navigationTitle("Signal Detail")
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
    
    // Helper function to generate analysis text based on signal properties
    private func generateAnalysisText(for signal: TradingTypes.GoldSignal) -> String {
        let confidenceText = signal.confidence > 0.8 ? "high confidence" : signal.confidence > 0.6 ? "moderate confidence" : "lower confidence"
        let directionText = signal.type == .buy ? "bullish momentum" : "bearish momentum"
        let timeframeText = signal.timeframe.rawValue
        let riskRewardText = signal.riskRewardRatio > 2.0 ? "excellent" : signal.riskRewardRatio > 1.5 ? "good" : "acceptable"
        
        switch signal.type {
        case .buy:
            return "This \(confidenceText) BUY signal indicates strong \(directionText) on the \(timeframeText) timeframe. Technical analysis suggests favorable market conditions with institutional buying pressure. The \(riskRewardText) risk-to-reward ratio of 1:\(String(format: "%.1f", signal.riskRewardRatio)) provides a solid trading opportunity."
            
        case .sell:
            return "This \(confidenceText) SELL signal shows clear \(directionText) on the \(timeframeText) timeframe. Market structure indicates bearish pressure with potential for downside movement. The \(riskRewardText) risk-to-reward ratio of 1:\(String(format: "%.1f", signal.riskRewardRatio)) offers good profit potential."
            
        case .scalp:
            return "This \(confidenceText) SCALP signal presents a quick trading opportunity on the \(timeframeText) timeframe. Ideal for short-term profits with rapid entry and exit. The \(riskRewardText) risk-to-reward ratio of 1:\(String(format: "%.1f", signal.riskRewardRatio)) is suitable for scalping strategies."
            
        case .swing:
            return "This \(confidenceText) SWING signal identifies a medium-term trading opportunity on the \(timeframeText) timeframe. Perfect for position trading with extended profit targets. The \(riskRewardText) risk-to-reward ratio of 1:\(String(format: "%.1f", signal.riskRewardRatio)) justifies the longer holding period."
        }
    }
    
    private func getConfidenceLevel(_ confidence: Double) -> String {
        if confidence >= 0.9 {
            return "Excellent"
        } else if confidence >= 0.8 {
            return "High"
        } else if confidence >= 0.7 {
            return "Good"
        } else if confidence >= 0.6 {
            return "Moderate"
        } else {
            return "Low"
        }
    }
    
    private func getConfidenceLevelColor(_ confidence: Double) -> Color {
        if confidence >= 0.8 {
            return .green
        } else if confidence >= 0.6 {
            return .orange
        } else {
            return .red
        }
    }
    
    private func getRiskLevel(_ ratio: Double) -> String {
        if ratio >= 3.0 {
            return "Low Risk"
        } else if ratio >= 2.0 {
            return "Moderate Risk"
        } else if ratio >= 1.5 {
            return "Medium Risk"
        } else {
            return "High Risk"
        }
    }
    
    private func getRiskLevelColor(_ ratio: Double) -> Color {
        if ratio >= 2.5 {
            return .green
        } else if ratio >= 1.5 {
            return .orange
        } else {
            return .red
        }
    }
}

#Preview {
    let sampleSignal = TradingTypes.GoldSignal(
        type: .buy,
        entryPrice: 2374.50,
        stopLoss: 2354.50,
        takeProfit: 2404.50,
        confidence: 0.85,
        timeframe: .h1
    )
    
    SignalDetailView(signal: sampleSignal)
}