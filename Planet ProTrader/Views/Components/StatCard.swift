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
    let change: String?
    let color: Color
    let icon: String?
    
    // Primary initializer with change text
    init(title: String, value: String, change: String, color: Color) {
        self.title = title
        self.value = value
        self.change = change
        self.color = color
        self.icon = nil
    }
    
    // Secondary initializer with icon (for MarketplaceBotDetailView compatibility)
    init(title: String, value: String, icon: String, color: Color) {
        self.title = title
        self.value = value
        self.change = nil
        self.color = color
        self.icon = icon
    }
    
    // Tertiary initializer for maximum flexibility
    init(title: String, value: String, change: String? = nil, icon: String? = nil, color: Color) {
        self.title = title
        self.value = value
        self.change = change
        self.color = color
        self.icon = icon
    }
    
    var body: some View {
        UltraPremiumCard {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(title)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    if let icon = icon {
                        Image(systemName: icon)
                            .foregroundColor(color)
                            .font(.caption)
                    } else {
                        Circle()
                            .fill(color)
                            .frame(width: 8, height: 8)
                    }
                }
                
                Text(value)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                
                if let change = change {
                    Text(change)
                        .font(.caption)
                        .foregroundStyle(color)
                        .fontWeight(.medium)
                } else if icon != nil {
                    Text("Current")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .fontWeight(.medium)
                }
            }
        }
        .frame(height: 100)
    }
}

#Preview {
    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
        // Original style with change
        StatCard(
            title: "Total P&L",
            value: "$5,247.85",
            change: "+12.4%",
            color: .green
        )
        
        // Icon style for bot details
        StatCard(
            title: "Win Rate",
            value: "73.2%",
            icon: "target",
            color: .blue
        )
        
        // Flexible style
        StatCard(
            title: "Total Return",
            value: "245.7%",
            change: "All time",
            icon: "chart.line.uptrend.xyaxis",
            color: .green
        )
        
        // Simple style
        StatCard(
            title: "Risk Score",
            value: "Medium",
            color: .orange
        )
    }
    .padding()
}