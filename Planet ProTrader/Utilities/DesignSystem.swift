//
//  DesignSystem.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 7/13/25.
//

import SwiftUI

struct DesignSystem {
    
    // MARK: - Colors
    
    static let primaryGold = Color(red: 1.0, green: 0.84, blue: 0.0)
    static let secondaryGold = Color(red: 1.0, green: 0.92, blue: 0.4)
    static let darkGold = Color(red: 0.8, green: 0.67, blue: 0.0)
    static let accentOrange = Color.orange
    
    static let primaryText = Color.primary
    static let secondaryText = Color.secondary
    static let tertiaryText = Color.secondary.opacity(0.7)
    
    static let success = Color.green
    static let warning = Color.orange
    static let error = Color.red
    static let info = Color.blue
    
    static let surfacePrimary = Color(UIColor.systemBackground)
    static let surfaceSecondary = Color(UIColor.secondarySystemBackground)
    static let surfaceTertiary = Color(UIColor.tertiarySystemBackground)
    static let cardBackground = Color(UIColor.secondarySystemBackground)
    
    // MARK: - Gradients
    
    static let backgroundGradient = LinearGradient(
        colors: [
            Color(red: 0.95, green: 0.95, blue: 0.97),
            Color(red: 0.98, green: 0.98, blue: 1.0)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let goldGradient = LinearGradient(
        colors: [primaryGold, secondaryGold],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        colors: [
            Color.white.opacity(0.9),
            Color.white.opacity(0.7)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    // MARK: - Shadows
    
    static let cardShadow = Color.black.opacity(0.08)
    static let elevatedShadow = Color.black.opacity(0.12)
    
    // MARK: - Spacing
    
    static let spacing = Spacing()
    
    struct Spacing {
        let xs: CGFloat = 4
        let sm: CGFloat = 8
        let md: CGFloat = 16
        let lg: CGFloat = 24
        let xl: CGFloat = 32
        let xxl: CGFloat = 48
    }
    
    // MARK: - Corner Radius
    
    static let cornerRadius = CornerRadius()
    
    struct CornerRadius {
        let sm: CGFloat = 8
        let md: CGFloat = 12
        let lg: CGFloat = 16
        let xl: CGFloat = 20
        let xxl: CGFloat = 24
    }
    
    // MARK: - Typography
    
    static let typography = Typography()
    
    struct Typography {
        let largeTitle = Font.largeTitle.weight(.bold)
        let title = Font.title.weight(.semibold)
        let title2 = Font.title2.weight(.semibold)
        let title3 = Font.title3.weight(.medium)
        let headline = Font.headline.weight(.semibold)
        let body = Font.body.weight(.regular)
        let callout = Font.callout.weight(.medium)
        let subheadline = Font.subheadline.weight(.medium)
        let footnote = Font.footnote.weight(.regular)
        let caption = Font.caption.weight(.regular)
        let caption2 = Font.caption2.weight(.regular)
        
        // Additional typography styles used in the app
        let headlineLarge = Font.system(.largeTitle, design: .default, weight: .bold)
        let headlineMedium = Font.system(.title2, design: .default, weight: .bold)
        let headlineSmall = Font.system(.title3, design: .default, weight: .semibold)
        
        let bodyLarge = Font.system(.title3, design: .default, weight: .regular)
        let bodyMedium = Font.system(.body, design: .default, weight: .medium)
        let bodyRegular = Font.system(.body, design: .default, weight: .regular)
        let bodySmall = Font.system(.callout, design: .default, weight: .regular)
        
        let captionLarge = Font.system(.callout, design: .default, weight: .medium)
        let captionMedium = Font.system(.subheadline, design: .default, weight: .medium)
        let captionRegular = Font.system(.caption, design: .default, weight: .regular)
        let captionSmall = Font.system(.caption2, design: .default, weight: .regular)
    }
    
    // MARK: - Animation
    
    static let animation = Animation()
    
    struct Animation {
        let quick = SwiftUI.Animation.easeInOut(duration: 0.2)
        let standard = SwiftUI.Animation.easeInOut(duration: 0.3)
        let smooth = SwiftUI.Animation.easeInOut(duration: 0.5)
        let spring = SwiftUI.Animation.spring(response: 0.6, dampingFraction: 0.8)
        let springBouncy = SwiftUI.Animation.spring(response: 0.8, dampingFraction: 0.6)
    }
}

// MARK: - View Extensions

extension View {
    func goldexCardStyle() -> some View {
        self
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: DesignSystem.cornerRadius.md))
            .shadow(color: DesignSystem.cardShadow, radius: 4, x: 0, y: 2)
    }
    
    func goldexButtonStyle() -> some View {
        self
            .font(.headline)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .padding()
            .background(DesignSystem.goldGradient)
            .clipShape(RoundedRectangle(cornerRadius: DesignSystem.cornerRadius.md))
            .shadow(color: DesignSystem.primaryGold.opacity(0.3), radius: 4, x: 0, y: 2)
    }
    
    func goldexSecondaryButtonStyle() -> some View {
        self
            .font(.headline)
            .fontWeight(.medium)
            .foregroundColor(DesignSystem.primaryGold)
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: DesignSystem.cornerRadius.md))
            .overlay(
                RoundedRectangle(cornerRadius: DesignSystem.cornerRadius.md)
                    .stroke(DesignSystem.primaryGold, lineWidth: 1)
            )
    }
}

// MARK: - Color Extensions

extension Color {
    static let goldexPrimary = DesignSystem.primaryGold
    static let goldexSecondary = DesignSystem.secondaryGold
    static let goldexDark = DesignSystem.darkGold
    
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Preview

struct DesignSystemPreview: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Colors Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Colors")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                            ColorSwatch(color: DesignSystem.primaryGold, name: "Primary Gold")
                            ColorSwatch(color: DesignSystem.secondaryGold, name: "Secondary Gold")
                            ColorSwatch(color: DesignSystem.success, name: "Success")
                            ColorSwatch(color: DesignSystem.error, name: "Error")
                        }
                    }
                    
                    // Typography Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Typography")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Large Title")
                                .font(DesignSystem.typography.largeTitle)
                            Text("Title")
                                .font(DesignSystem.typography.title)
                            Text("Headline")
                                .font(DesignSystem.typography.headline)
                            Text("Body")
                                .font(DesignSystem.typography.body)
                            Text("Caption")
                                .font(DesignSystem.typography.caption)
                        }
                    }
                    
                    // Buttons Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Buttons")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        VStack(spacing: 12) {
                            Button("Primary Button") {}
                                .goldexButtonStyle()
                            
                            Button("Secondary Button") {}
                                .goldexSecondaryButtonStyle()
                        }
                    }
                    
                    // Cards Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Cards")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        VStack(spacing: 20) {
                            Text("Sample Card Content")
                                .padding()
                                .goldexCardStyle()
                            
                            UltraPremiumCard {
                                Text("Ultra Premium Card")
                                    .padding()
                            }
                        }
                    }
                }
                .padding()
            }
            .background(DesignSystem.backgroundGradient)
            .navigationTitle("Design System")
        }
    }
}

struct ColorSwatch: View {
    let color: Color
    let name: String
    
    var body: some View {
        VStack(spacing: 8) {
            RoundedRectangle(cornerRadius: 8)
                .fill(color)
                .frame(height: 60)
            
            Text(name)
                .font(.caption)
                .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    DesignSystemPreview()
}