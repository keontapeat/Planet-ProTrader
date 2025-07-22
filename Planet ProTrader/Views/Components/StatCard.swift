//
//  StatCard.swift
//  Planet ProTrader - Universal Statistics Card Component
//
//  MARK: - Missing Component Fixed
//  Created by Claude Doctor™
//

import SwiftUI

struct StatCard: View {
    let title: String
    let value: String
    let color: Color
    let icon: String?
    let subtitle: String?
    
    init(
        title: String,
        value: String,
        color: Color,
        icon: String? = nil,
        subtitle: String? = nil
    ) {
        self.title = title
        self.value = value
        self.color = color
        self.icon = icon
        self.subtitle = subtitle
    }
    
    var body: some View {
        VStack(spacing: 12) {
            // Icon (if provided)
            if let icon = icon {
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(color)
            }
            
            // Main content
            VStack(spacing: 4) {
                Text(value)
                    .font(.system(size: 24, weight: .black, design: .rounded))
                    .foregroundColor(color)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                
                Text(title)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.secondary.opacity(0.7))
                        .multilineTextAlignment(.center)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .padding(.horizontal, 12)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(color.opacity(0.2), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.03), radius: 8, x: 0, y: 4)
    }
}

// MARK: - Compact Variant

struct CompactStatCard: View {
    let title: String
    let value: String
    let color: Color
    let icon: String?
    
    init(title: String, value: String, color: Color, icon: String? = nil) {
        self.title = title
        self.value = value
        self.color = color
        self.icon = icon
    }
    
    var body: some View {
        HStack(spacing: 12) {
            if let icon = icon {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(color)
                    .frame(width: 24, height: 24)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(color)
                
                Text(title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Animated Stat Card

struct AnimatedStatCard: View {
    let title: String
    let value: String
    let color: Color
    let icon: String?
    @State private var animateValue = false
    
    init(title: String, value: String, color: Color, icon: String? = nil) {
        self.title = title
        self.value = value
        self.color = color
        self.icon = icon
    }
    
    var body: some View {
        StatCard(title: title, value: value, color: color, icon: icon)
            .scaleEffect(animateValue ? 1.05 : 1.0)
            .animation(.spring(response: 0.6, dampingFraction: 0.8), value: animateValue)
            .onAppear {
                withAnimation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.1)) {
                    animateValue = true
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation(.spring(response: 0.8, dampingFraction: 0.8)) {
                        animateValue = false
                    }
                }
            }
    }
}

// MARK: - Previews

#Preview("Standard Stat Cards") {
    VStack(spacing: 16) {
        HStack(spacing: 16) {
            StatCard(
                title: "Win Rate", 
                value: "89.5%", 
                color: .green, 
                icon: "target"
            )
            
            StatCard(
                title: "Total Profit", 
                value: "$12.5K", 
                color: DesignSystem.primaryGold, 
                icon: "dollarsign.circle.fill"
            )
            
            StatCard(
                title: "Active Trades", 
                value: "7", 
                color: .blue, 
                icon: "chart.bar.fill"
            )
        }
        
        HStack(spacing: 16) {
            StatCard(
                title: "Performance", 
                value: "+127.8%", 
                color: .green,
                subtitle: "This Month"
            )
            
            StatCard(
                title: "Drawdown", 
                value: "2.1%", 
                color: .red,
                subtitle: "Max Risk"
            )
        }
    }
    .padding()
    .preferredColorScheme(.light)
}

#Preview("Compact Stat Cards") {
    VStack(spacing: 12) {
        CompactStatCard(title: "CPU Usage", value: "23%", color: .green, icon: "cpu")
        CompactStatCard(title: "Memory", value: "445 MB", color: .blue, icon: "memorychip")
        CompactStatCard(title: "Network", value: "45ms", color: .orange, icon: "network")
        CompactStatCard(title: "FPS", value: "60", color: DesignSystem.primaryGold, icon: "speedometer")
    }
    .padding()
    .preferredColorScheme(.light)
}

#Preview("Animated Stat Cards") {
    HStack(spacing: 16) {
        AnimatedStatCard(title: "Live Price", value: "$2,374.85", color: DesignSystem.primaryGold, icon: "chart.line.uptrend.xyaxis")
        AnimatedStatCard(title: "24h Change", value: "+0.52%", color: .green, icon: "arrow.up.circle.fill")
        AnimatedStatCard(title: "Volume", value: "1.2M", color: .blue, icon: "chart.bar.fill")
    }
    .padding()
    .preferredColorScheme(.light)
}