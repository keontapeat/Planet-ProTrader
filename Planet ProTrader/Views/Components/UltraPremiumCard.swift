//
//  UltraPremiumCard.swift
//  Planet ProTrader
//
//  ✅ FIXED: Missing UltraPremiumCard component
//  Referenced by StatCard and other components
//

import SwiftUI

struct UltraPremiumCard<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .background {
                ZStack {
                    // Base glass effect
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.ultraThinMaterial)
                    
                    // Gradient border
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.3),
                                    Color.clear,
                                    DesignSystem.primaryGold.opacity(0.2),
                                    Color.clear,
                                    Color.white.opacity(0.1)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                    
                    // Inner glow
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(DesignSystem.primaryGold.opacity(0.1), lineWidth: 0.5)
                        .blur(radius: 0.5)
                }
            }
            .shadow(color: .black.opacity(0.05), radius: 12, x: 0, y: 6)
            .shadow(color: DesignSystem.primaryGold.opacity(0.1), radius: 20, x: 0, y: 10)
    }
}

// MARK: - Additional Premium Components

struct PremiumGlassCard<Content: View>: View {
    let content: Content
    let cornerRadius: CGFloat
    let showBorder: Bool
    
    init(
        cornerRadius: CGFloat = 16,
        showBorder: Bool = true,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.cornerRadius = cornerRadius
        self.showBorder = showBorder
    }
    
    var body: some View {
        content
            .background {
                ZStack {
                    // Glass base
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(.ultraThinMaterial)
                    
                    if showBorder {
                        // Premium border
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        DesignSystem.primaryGold.opacity(0.4),
                                        Color.clear,
                                        DesignSystem.primaryGold.opacity(0.2),
                                        Color.clear
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    }
                }
            }
            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

struct UltraModernCard<Content: View>: View {
    let content: Content
    let accentColor: Color
    
    init(accentColor: Color = DesignSystem.primaryGold, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.accentColor = accentColor
    }
    
    var body: some View {
        content
            .background {
                ZStack {
                    // Base card
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.regularMaterial)
                    
                    // Accent stripe
                    VStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(
                                LinearGradient(
                                    colors: [accentColor, accentColor.opacity(0.3), Color.clear],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(height: 3)
                        
                        Spacer()
                    }
                }
            }
            .shadow(color: .black.opacity(0.08), radius: 16, x: 0, y: 8)
    }
}

// MARK: - Card Style Modifiers

extension View {
    func ultraPremiumCard() -> some View {
        UltraPremiumCard {
            self
        }
    }
    
    func premiumGlassCard(cornerRadius: CGFloat = 16, showBorder: Bool = true) -> some View {
        PremiumGlassCard(cornerRadius: cornerRadius, showBorder: showBorder) {
            self
        }
    }
    
    func ultraModernCard(accentColor: Color = DesignSystem.primaryGold) -> some View {
        UltraModernCard(accentColor: accentColor) {
            self
        }
    }
}

#Preview {
    ScrollView {
        LazyVStack(spacing: 20) {
            Text("✅ Premium Card Components")
                .font(.title.bold())
                .foregroundStyle(DesignSystem.primaryGold)
            
            VStack(spacing: 12) {
                Text("Sample Text")
                    .font(.headline)
                Text("Secondary text")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding()
            .ultraPremiumCard()
            
            VStack(spacing: 12) {
                Text("Glass Card")
                    .font(.headline)
                Text("With premium glass effect")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding()
            .premiumGlassCard()
            
            VStack(spacing: 12) {
                Text("Modern Card")
                    .font(.headline)
                Text("With accent stripe")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding()
            .ultraModernCard(accentColor: .blue)
        }
        .padding()
    }
    .background(Color(.systemGroupedBackground))
}