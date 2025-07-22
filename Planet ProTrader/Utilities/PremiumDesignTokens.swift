//
//  PremiumDesignTokens.swift
//  Planet ProTrader
//
//  Ultra-Premium Design System for $50K+ App Quality
//  Created by AI Assistant on 1/25/25.
//

import SwiftUI

struct PremiumDesignTokens {
    
    // MARK: - Premium Color Palette
    
    struct Colors {
        // Primary Brand Colors
        static let primaryGold = Color(red: 1.0, green: 0.84, blue: 0.0)
        static let primaryGoldLight = Color(red: 1.0, green: 0.92, blue: 0.4)
        static let primaryGoldDark = Color(red: 0.8, green: 0.67, blue: 0.0)
        
        // Semantic Colors
        static let success = Color(red: 0.2, green: 0.78, blue: 0.35)
        static let successLight = Color(red: 0.2, green: 0.78, blue: 0.35).opacity(0.1)
        static let warning = Color(red: 1.0, green: 0.58, blue: 0.0)
        static let warningLight = Color(red: 1.0, green: 0.58, blue: 0.0).opacity(0.1)
        static let error = Color(red: 1.0, green: 0.23, blue: 0.19)
        static let errorLight = Color(red: 1.0, green: 0.23, blue: 0.19).opacity(0.1)
        
        // Neutral Colors
        static let textPrimary = Color.primary
        static let textSecondary = Color.secondary
        static let textTertiary = Color.secondary.opacity(0.6)
        
        // Surface Colors
        static let surfacePrimary = Color(.systemBackground)
        static let surfaceSecondary = Color(.secondarySystemBackground)
        static let surfaceTertiary = Color(.tertiarySystemBackground)
        
        // Premium Glass Effect Colors
        static let glassPrimary = Color.white.opacity(0.85)
        static let glassSecondary = Color.white.opacity(0.65)
        static let glassTertiary = Color.white.opacity(0.45)
        
        // Shadow Colors
        static let shadowLight = Color.black.opacity(0.05)
        static let shadowMedium = Color.black.opacity(0.1)
        static let shadowDark = Color.black.opacity(0.2)
    }
    
    // MARK: - Premium Gradients
    
    struct Gradients {
        static let primaryGold = LinearGradient(
            colors: [Colors.primaryGold, Colors.primaryGoldLight],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        static let premiumBackground = LinearGradient(
            colors: [
                Color(red: 0.98, green: 0.98, blue: 1.0),
                Color(red: 0.95, green: 0.97, blue: 0.99),
                Color(red: 0.96, green: 0.96, blue: 0.98)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        static let glassMorphism = LinearGradient(
            colors: [
                Colors.glassPrimary,
                Colors.glassSecondary,
                Colors.glassTertiary
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        static let premiumCard = LinearGradient(
            colors: [
                Color.white.opacity(0.95),
                Color.white.opacity(0.85),
                Color.white.opacity(0.75)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    // MARK: - Typography Scale
    
    struct Typography {
        static let hero = Font.system(size: 34, weight: .bold, design: .default)
        static let title1 = Font.system(size: 28, weight: .bold, design: .default)
        static let title2 = Font.system(size: 22, weight: .bold, design: .default)
        static let title3 = Font.system(size: 20, weight: .semibold, design: .default)
        static let headline = Font.system(size: 17, weight: .semibold, design: .default)
        static let body = Font.system(size: 17, weight: .regular, design: .default)
        static let callout = Font.system(size: 16, weight: .medium, design: .default)
        static let subheadline = Font.system(size: 15, weight: .medium, design: .default)
        static let footnote = Font.system(size: 13, weight: .regular, design: .default)
        static let caption1 = Font.system(size: 12, weight: .medium, design: .default)
        static let caption2 = Font.system(size: 11, weight: .medium, design: .default)
    }
    
    // MARK: - Spacing Scale
    
    struct Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 48
        static let xxxl: CGFloat = 64
    }
    
    // MARK: - Corner Radius
    
    struct CornerRadius {
        static let xs: CGFloat = 6
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 20
        static let xxl: CGFloat = 28
        static let circular: CGFloat = 50
    }
    
    // MARK: - Elevation (Shadow Layers)
    
    struct Elevation {
        static let level0: [Shadow] = []
        
        static let level1: [Shadow] = [
            Shadow(color: Colors.shadowLight, radius: 2, x: 0, y: 1)
        ]
        
        static let level2: [Shadow] = [
            Shadow(color: Colors.shadowLight, radius: 4, x: 0, y: 2),
            Shadow(color: Colors.shadowMedium, radius: 1, x: 0, y: 1)
        ]
        
        static let level3: [Shadow] = [
            Shadow(color: Colors.shadowMedium, radius: 8, x: 0, y: 4),
            Shadow(color: Colors.shadowLight, radius: 2, x: 0, y: 2)
        ]
        
        static let level4: [Shadow] = [
            Shadow(color: Colors.shadowDark, radius: 16, x: 0, y: 8),
            Shadow(color: Colors.shadowMedium, radius: 4, x: 0, y: 4)
        ]
    }
    
    // MARK: - Animations
    
    struct Animations {
        static let quickEase = Animation.easeInOut(duration: 0.2)
        static let standardEase = Animation.easeInOut(duration: 0.3)
        static let smoothEase = Animation.easeInOut(duration: 0.5)
        static let premiumSpring = Animation.spring(response: 0.6, dampingFraction: 0.8)
        static let bouncySpring = Animation.spring(response: 0.8, dampingFraction: 0.6)
        static let gentleSpring = Animation.spring(response: 1.0, dampingFraction: 0.9)
    }
}

// MARK: - Shadow Helper

struct Shadow {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
}

// MARK: - Premium View Modifiers

struct PremiumGlassMorphismModifier: ViewModifier {
    let cornerRadius: CGFloat
    let elevation: [Shadow]
    
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(PremiumDesignTokens.Gradients.glassMorphism)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
                    .modifier(ElevationModifier(shadows: elevation))
            )
    }
}

struct ElevationModifier: ViewModifier {
    let shadows: [Shadow]
    
    func body(content: Content) -> some View {
        shadows.reduce(content) { view, shadow in
            view.shadow(color: shadow.color, radius: shadow.radius, x: shadow.x, y: shadow.y)
        }
    }
}

struct PremiumButtonModifier: ViewModifier {
    let isEnabled: Bool
    let style: ButtonStyle
    
    enum ButtonStyle {
        case primary
        case secondary
        case tertiary
        case destructive
    }
    
    func body(content: Content) -> some View {
        content
            .font(PremiumDesignTokens.Typography.callout)
            .fontWeight(.semibold)
            .foregroundStyle(foregroundColor)
            .padding(.horizontal, PremiumDesignTokens.Spacing.lg)
            .padding(.vertical, PremiumDesignTokens.Spacing.md)
            .frame(maxWidth: .infinity)
            .background(backgroundView)
            .opacity(isEnabled ? 1.0 : 0.6)
            .scaleEffect(isEnabled ? 1.0 : 0.98)
            .animation(PremiumDesignTokens.Animations.premiumSpring, value: isEnabled)
    }
    
    private var foregroundColor: Color {
        switch style {
        case .primary:
            return .white
        case .secondary:
            return PremiumDesignTokens.Colors.primaryGold
        case .tertiary:
            return PremiumDesignTokens.Colors.textPrimary
        case .destructive:
            return .white
        }
    }
    
    @ViewBuilder
    private var backgroundView: some View {
        RoundedRectangle(cornerRadius: PremiumDesignTokens.CornerRadius.md)
            .fill(backgroundGradient)
            .modifier(ElevationModifier(shadows: PremiumDesignTokens.Elevation.level2))
            .overlay(strokeOverlay)
    }
    
    private var backgroundGradient: LinearGradient {
        switch style {
        case .primary:
            return PremiumDesignTokens.Gradients.primaryGold
        case .secondary:
            return LinearGradient(
                colors: [Color.clear],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .tertiary:
            return LinearGradient(
                colors: [
                    PremiumDesignTokens.Colors.glassPrimary,
                    PremiumDesignTokens.Colors.glassSecondary
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .destructive:
            return LinearGradient(
                colors: [PremiumDesignTokens.Colors.error, PremiumDesignTokens.Colors.error.opacity(0.8)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
    
    @ViewBuilder
    private var strokeOverlay: some View {
        switch style {
        case .primary, .destructive:
            EmptyView()
        case .secondary:
            RoundedRectangle(cornerRadius: PremiumDesignTokens.CornerRadius.md)
                .stroke(PremiumDesignTokens.Colors.primaryGold, lineWidth: 2)
        case .tertiary:
            RoundedRectangle(cornerRadius: PremiumDesignTokens.CornerRadius.md)
                .stroke(Color.white.opacity(0.3), lineWidth: 1)
        }
    }
}

// MARK: - View Extensions

extension View {
    func premiumGlassMorphism(
        cornerRadius: CGFloat = PremiumDesignTokens.CornerRadius.lg,
        elevation: [Shadow] = PremiumDesignTokens.Elevation.level2
    ) -> some View {
        modifier(PremiumGlassMorphismModifier(cornerRadius: cornerRadius, elevation: elevation))
    }
    
    func premiumButton(
        style: PremiumButtonModifier.ButtonStyle = .primary,
        isEnabled: Bool = true
    ) -> some View {
        modifier(PremiumButtonModifier(isEnabled: isEnabled, style: style))
    }
    
    func premiumCard(
        cornerRadius: CGFloat = PremiumDesignTokens.CornerRadius.lg,
        elevation: [Shadow] = PremiumDesignTokens.Elevation.level2
    ) -> some View {
        self
            .padding(PremiumDesignTokens.Spacing.lg)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(PremiumDesignTokens.Gradients.premiumCard)
                    .modifier(ElevationModifier(shadows: elevation))
            )
    }
}

#Preview {
    ScrollView {
        VStack(spacing: PremiumDesignTokens.Spacing.lg) {
            // Typography Preview
            VStack(alignment: .leading, spacing: PremiumDesignTokens.Spacing.sm) {
                Text("Premium Design Tokens")
                    .font(PremiumDesignTokens.Typography.hero)
                Text("Ultra-premium design system for $50K+ quality")
                    .font(PremiumDesignTokens.Typography.title3)
                    .foregroundStyle(PremiumDesignTokens.Colors.textSecondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // Glass Morphism Card
            VStack(spacing: PremiumDesignTokens.Spacing.md) {
                Text("Glass Morphism Effect")
                    .font(PremiumDesignTokens.Typography.headline)
                Text("Ultra-premium glassmorphism with multi-layer shadows")
                    .font(PremiumDesignTokens.Typography.body)
                    .foregroundStyle(PremiumDesignTokens.Colors.textSecondary)
            }
            .premiumGlassMorphism()
            
            // Button Styles
            VStack(spacing: PremiumDesignTokens.Spacing.md) {
                Button("Primary Button") {}
                    .premiumButton(style: .primary)
                
                Button("Secondary Button") {}
                    .premiumButton(style: .secondary)
                
                Button("Tertiary Button") {}
                    .premiumButton(style: .tertiary)
                
                Button("Destructive Button") {}
                    .premiumButton(style: .destructive)
            }
            
            // Premium Card
            VStack(spacing: PremiumDesignTokens.Spacing.sm) {
                Text("Premium Card")
                    .font(PremiumDesignTokens.Typography.headline)
                Text("Multi-layer card with premium gradients")
                    .font(PremiumDesignTokens.Typography.body)
                    .foregroundStyle(PremiumDesignTokens.Colors.textSecondary)
            }
            .premiumCard()
        }
        .padding(PremiumDesignTokens.Spacing.lg)
    }
    .background(PremiumDesignTokens.Gradients.premiumBackground)
}