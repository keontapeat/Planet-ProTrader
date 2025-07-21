//
//  SharedComponents.swift
//  Planet ProTrader
//
//  Created by AI Assistant on 1/25/25.
//

import SwiftUI

// MARK: - Shared UI Components

// Note: StatCard is now defined in StatCard.swift to avoid duplicates
// This file contains other shared components

struct SettingsRowAlt: View {
    let icon: String
    let title: String
    let subtitle: String
    let action: () -> Void
    
    init(icon: String, title: String, subtitle: String, action: @escaping () -> Void = {}) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(DesignSystem.primaryGold)
                    .frame(width: 24)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    VStack(spacing: 16) {
        // StatCard is now in its own file
        Text("SharedComponents Preview")
            .font(.title)
        
        SettingsRowAlt(
            icon: "bell.fill",
            title: "Notifications",
            subtitle: "Trading alerts and updates"
        )
    }
    .padding()
}