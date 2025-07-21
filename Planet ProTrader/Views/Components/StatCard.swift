//
//  StatCard.swift
//  Planet ProTrader
//
//  Created by AI Assistant on 1/25/25.
//

import SwiftUI

struct StatCard: View {
    let title: String
    let value: String
    let change: String
    let color: Color
    
    var body: some View {
        UltraPremiumCard {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(title)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    Circle()
                        .fill(color)
                        .frame(width: 8, height: 8)
                }
                
                Text(value)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                
                Text(change)
                    .font(.caption)
                    .foregroundStyle(color)
                    .fontWeight(.medium)
            }
        }
        .frame(height: 100)
    }
}

#Preview {
    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
        StatCard(
            title: "Total P&L",
            value: "$5,247.85",
            change: "+12.4%",
            color: .green
        )
        
        StatCard(
            title: "Win Rate",
            value: "73.2%",
            change: "Last 30 days",
            color: .blue
        )
        
        StatCard(
            title: "Total Trades",
            value: "1,245",
            change: "All time",
            color: .purple
        )
        
        StatCard(
            title: "Risk Score",
            value: "Medium",
            change: "Balanced",
            color: .orange
        )
    }
    .padding()
}