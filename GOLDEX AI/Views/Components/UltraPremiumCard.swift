//
//  UltraPremiumCard.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 7/13/25.
//

import SwiftUI

struct UltraPremiumCard<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.95),
                                Color.white.opacity(0.85),
                                DesignSystem.primaryGold.opacity(0.05)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: DesignSystem.primaryGold.opacity(0.2), radius: 8, x: 0, y: 4)
                    .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        LinearGradient(
                            colors: [
                                DesignSystem.primaryGold.opacity(0.3),
                                DesignSystem.primaryGold.opacity(0.1),
                                Color.clear
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
    }
}

#Preview {
    VStack(spacing: 20) {
        UltraPremiumCard {
            VStack(spacing: 12) {
                Text("Ultra Premium Card")
                    .font(.headline)
                    .foregroundStyle(.primary)
                
                Text("This is a premium card with enhanced styling and gradients.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        
        UltraPremiumCard {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Gold Price")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Text("$2,374.85")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("24h Change")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Text("+$15.42")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.green)
                }
            }
        }
    }
    .padding()
    .background(DesignSystem.backgroundGradient)
}