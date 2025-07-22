//
//  PremiumDesignTokens.swift
//  Planet ProTrader
//
//  ✅ FIXED: Complete Premium Design System
//  Ultra-Premium Design Tokens for $50K+ App Quality
//  Created by AI Assistant on 1/25/25.
//

import SwiftUI

struct PremiumDesignTokens {
    
    // MARK: - Colors
    struct Colors {
        // Primary Colors
        static let primaryGold = Color(red: 1.0, green: 0.84, blue: 0.0)
        static let primaryGoldLight = Color(red: 1.0, green: 0.92, blue: 0.4)
        static let primaryGoldDark = Color(red: 0.8, green: 0.67, blue: 0.0)
        
        // Text Colors
        static let textPrimary = Color.primary
        static let textSecondary = Color.secondary
        static let textTertiary = Color.secondary.opacity(0.7)
        
        // Semantic Colors
        static let success = Color.green
        static let successLight = Color.green.opacity(0.1)
        static let warning = Color.orange
        static let warningLight = Color.orange.opacity(0.1)
        static let error = Color.red
        static let errorLight = Color.red.opacity(0.1)
        static let info = Color.blue
        static let infoLight = Color.blue.opacity(0.1)
        
        // Glass Morphism Colors
        static let glassPrimary = Color.white.opacity(0.1)
        static let glassSecondary = Color.white.opacity(0.05)
        static let glassTertiary = Color.black.opacity(0.05)
        
        // Shadow Colors
        static let shadowLight = Color.black.opacity(0.05)
        static let shadowMedium = Color.black.opacity(0.1)
        static let shadowHeavy = Color.black.opacity(0.2)
    }
    
    // MARK: - Gradients
    struct Gradients {
        static let primaryGold = LinearGradient(
            colors: [Colors.primaryGold, Colors.primaryGoldLight],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        static let premiumBackground = LinearGradient(
            colors: [
                Color(.systemBackground),
                Colors.primaryGold.opacity(0.02),
                Color(.systemBackground).opacity(0.95)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        static let cardGradient = LinearGradient(
            colors: [
                Color.white.opacity(0.1),
                Color.white.opacity(0.05)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    // MARK: - Typography
    struct Typography {
        static let hero = Font.system(size: 34, weight: .bold, design: .default)
        static let title = Font.system(size: 28, weight: .bold, design: .default)
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
    
    // MARK: - Spacing
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
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 20
        static let xxl: CGFloat = 24
    }
    
    // MARK: - Animations
    struct Animations {
        static let quickEase = Animation.easeInOut(duration: 0.2)
        static let standardEase = Animation.easeInOut(duration: 0.3)
        static let smoothEase = Animation.easeInOut(duration: 0.5)
        static let premiumSpring = Animation.spring(response: 0.6, dampingFraction: 0.8)
        static let bouncySpring = Animation.spring(response: 0.8, dampingFraction: 0.6)
    }
    
    // MARK: - Elevation (Shadows)
    struct Elevation {
        static let level1 = [Shadow(color: Colors.shadowLight, radius: 2, x: 0, y: 1)]
        static let level2 = [Shadow(color: Colors.shadowLight, radius: 4, x: 0, y: 2)]
        static let level3 = [Shadow(color: Colors.shadowMedium, radius: 8, x: 0, y: 4)]
        static let level4 = [Shadow(color: Colors.shadowMedium, radius: 16, x: 0, y: 8)]
        static let level5 = [Shadow(color: Colors.shadowHeavy, radius: 24, x: 0, y: 12)]
    }
}

// MARK: - Shadow Helper
struct Shadow {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
}

// MARK: - View Extensions

extension View {
    func premiumGlassMorphism() -> some View {
        self
            .background(.ultraThinMaterial)
            .cornerRadius(PremiumDesignTokens.CornerRadius.lg)
            .modifier(ElevationModifier(shadows: PremiumDesignTokens.Elevation.level2))
    }
    
    func premiumButton(style: PremiumButtonStyle, isEnabled: Bool = true) -> some View {
        self
            .font(PremiumDesignTokens.Typography.callout)
            .fontWeight(.semibold)
            .foregroundColor(style.foregroundColor(isEnabled))
            .frame(maxWidth: .infinity)
            .padding(.vertical, PremiumDesignTokens.Spacing.md)
            .background(style.backgroundColor(isEnabled))
            .cornerRadius(PremiumDesignTokens.CornerRadius.md)
            .modifier(ElevationModifier(shadows: isEnabled ? style.shadows : []))
            .disabled(!isEnabled)
            .scaleEffect(isEnabled ? 1.0 : 0.95)
            .animation(PremiumDesignTokens.Animations.quickEase, value: isEnabled)
    }
}

// MARK: - Premium Button Styles
enum PremiumButtonStyle {
    case primary
    case secondary
    case destructive
    
    func backgroundColor(_ isEnabled: Bool) -> some View {
        Group {
            if isEnabled {
                switch self {
                case .primary:
                    PremiumDesignTokens.Gradients.primaryGold
                case .secondary:
                    Color.clear
                case .destructive:
                    LinearGradient(colors: [.red, .red.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing)
                }
            } else {
                Color.gray.opacity(0.3)
            }
        }
    }
    
    func foregroundColor(_ isEnabled: Bool) -> Color {
        if !isEnabled { return .secondary }
        
        switch self {
        case .primary: return .white
        case .secondary: return PremiumDesignTokens.Colors.primaryGold
        case .destructive: return .white
        }
    }
    
    var shadows: [Shadow] {
        switch self {
        case .primary: return PremiumDesignTokens.Elevation.level2
        case .secondary: return []
        case .destructive: return PremiumDesignTokens.Elevation.level2
        }
    }
}

// MARK: - Elevation Modifier
struct ElevationModifier: ViewModifier {
    let shadows: [Shadow]
    
    func body(content: Content) -> some View {
        var modifiedContent = AnyView(content)
        
        for shadow in shadows {
            modifiedContent = AnyView(
                modifiedContent.shadow(
                    color: shadow.color,
                    radius: shadow.radius,
                    x: shadow.x,
                    y: shadow.y
                )
            )
        }
        
        return modifiedContent
    }
}

// MARK: - Preview
#Preview {
    ScrollView {
        VStack(spacing: 24) {
            Text("Premium Design System")
                .font(PremiumDesignTokens.Typography.hero)
                .foregroundStyle(PremiumDesignTokens.Gradients.primaryGold)
            
            VStack(spacing: 16) {
                Button("Primary Button") { }
                    .premiumButton(style: .primary)
                
                Button("Secondary Button") { }
                    .premiumButton(style: .secondary)
                
                Button("Destructive Button") { }
                    .premiumButton(style: .destructive)
                
                Button("Disabled Button") { }
                    .premiumButton(style: .primary, isEnabled: false)
            }
            
            VStack(spacing: 16) {
                Text("Glass Morphism Cards")
                    .font(PremiumDesignTokens.Typography.title2)
                
                Text("This is a premium glass morphism card with elevation and styling")
                    .padding()
                    .premiumGlassMorphism()
                
                HStack(spacing: 16) {
                    Text("Card 1")
                        .padding()
                        .premiumGlassMorphism()
                    
                    Text("Card 2")
                        .padding()
                        .premiumGlassMorphism()
                }
            }
        }
        .padding()
    }
    .background(PremiumDesignTokens.Gradients.premiumBackground)
}