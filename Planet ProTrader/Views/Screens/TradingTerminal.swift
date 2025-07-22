//
//  TradingTerminal.swift
//  Planet ProTrader
//
//  ✅ TRADING TERMINAL - Professional trading interface
//

import SwiftUI

struct TradingTerminal: View {
    @State private var selectedTimeframe: String = "15M"
    @State private var selectedSymbol: String = "XAUUSD"
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                VStack(alignment: .leading) {
                    Text(selectedSymbol)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("$2,374.50")
                        .font(.title3)
                        .foregroundColor(DesignSystem.primaryGold)
                }
                
                Spacer()
                
                HStack(spacing: 4) {
                    Text("+12.35")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.green)
                    
                    Text("(+0.52%)")
                        .font(.caption)
                        .foregroundColor(.green)
                }
            }
            .padding()
            
            // Chart placeholder
            Rectangle()
                .fill(.ultraThinMaterial)
                .overlay(
                    VStack {
                        Image(systemName: "chart.line.uptrend.xyaxis")
                            .font(.largeTitle)
                            .foregroundColor(DesignSystem.primaryGold)
                        Text("Trading Chart")
                            .font(.headline)
                        Text("Coming Soon")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                )
            
            // Controls
            VStack(spacing: 12) {
                // Timeframe selector
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(["1M", "5M", "15M", "1H", "4H", "1D"], id: \.self) { timeframe in
                            Button(timeframe) {
                                selectedTimeframe = timeframe
                            }
                            .font(.caption)
                            .fontWeight(.medium)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(selectedTimeframe == timeframe ? DesignSystem.primaryGold : Color.clear)
                            )
                            .foregroundColor(selectedTimeframe == timeframe ? .white : .primary)
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Trading buttons
                HStack(spacing: 16) {
                    Button("BUY") {
                        // Buy action
                    }
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.green)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    Button("SELL") {
                        // Sell action
                    }
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.red)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding(.horizontal)
            }
            .padding(.bottom)
        }
        .navigationTitle("Trading")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationView {
        TradingTerminal()
    }
}