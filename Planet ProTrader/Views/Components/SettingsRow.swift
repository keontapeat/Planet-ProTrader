//
//  SettingsRow.swift
//  Planet ProTrader
//
//  Created by AI Assistant on 1/25/25.
//

import SwiftUI

struct SettingsRow: View {
    let icon: String
    let title: String
    let subtitle: String
    var action: (() -> Void)?
    
    init(icon: String, title: String, subtitle: String, action: (() -> Void)? = nil) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.action = action
    }
    
    var body: some View {
        Button(action: {
            action?()
        }) {
            HStack(spacing: 16) {
                // Icon
                ZStack {
                    Circle()
                        .fill(DesignSystem.primaryGold.opacity(0.1))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(DesignSystem.primaryGold)
                }
                
                // Content
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.headline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                
                Spacer()
                
                // Chevron
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.quaternary)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .background(.ultraThinMaterial)
            .cornerRadius(12)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.easeInOut(duration: 0.2), value: action != nil)
    }
}

#Preview {
    VStack(spacing: 12) {
        SettingsRow(
            icon: "bell.fill",
            title: "Notifications",
            subtitle: "Trading alerts and updates"
        )
        
        SettingsRow(
            icon: "shield.fill",
            title: "Security",
            subtitle: "Password and authentication"
        )
        
        SettingsRow(
            icon: "chart.bar.fill",
            title: "Trading Preferences",
            subtitle: "Risk settings and strategies"
        )
        
        SettingsRow(
            icon: "questionmark.circle.fill",
            title: "Help & Support",
            subtitle: "FAQs and customer support"
        )
        
        SettingsRow(
            icon: "info.circle.fill",
            title: "About",
            subtitle: "Version and legal information"
        )
    }
    .padding()
    .environmentObject(AuthenticationManager.shared)
}