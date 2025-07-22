//
//  DesignSystem.swift
//  Planet ProTrader
//
//  FIXED: Complete Design System - Referenced by all views
//  Created by Senior iOS Engineer on 1/25/25.
//

import SwiftUI
import Foundation

struct DesignSystem {
    
    // MARK: - Colors
    static let primaryGold = Color(red: 1.0, green: 0.843, blue: 0.0) // #FFD700
    static let secondaryGold = Color(red: 1.0, green: 0.647, blue: 0.0) // #FFA500
    static let accentGold = Color(red: 0.855, green: 0.647, blue: 0.125) // #DAA520
    
    static let tradingGreen = Color(red: 0.0, green: 0.8, blue: 0.0) // #00CC00
    static let tradingRed = Color(red: 0.9, green: 0.0, blue: 0.0) // #E60000
    static let tradingBlue = Color(red: 0.0, green: 0.478, blue: 1.0) // #007AFF
    
    // MARK: - Additional Colors
    static let darkGold = Color(red: 0.855, green: 0.647, blue: 0.125) // #DAA520
    static let lightGold = Color(red: 1.0, green: 0.894, blue: 0.769) // #FFE4C4
    
    static let successGreen = Color(red: 0.0, green: 0.8, blue: 0.0) // #00CC00
    static let dangerRed = Color(red: 0.9, green: 0.0, blue: 0.0) // #E60000
    static let warningOrange = Color(red: 1.0, green: 0.647, blue: 0.0) // #FFA500
    static let infoBlue = Color(red: 0.0, green: 0.478, blue: 1.0) // #007AFF
    
    // MARK: - Gradients
    static let goldGradient = LinearGradient(
        colors: [primaryGold, secondaryGold],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let premiumGradient = LinearGradient(
        colors: [primaryGold, accentGold, secondaryGold],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let tradingGradient = LinearGradient(
        colors: [tradingBlue, primaryGold],
        startPoint: .leading,
        endPoint: .trailing
    )
    
    static let profitGradient = LinearGradient(
        colors: [tradingGreen, Color.green.opacity(0.7)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let lossGradient = LinearGradient(
        colors: [tradingRed, Color.red.opacity(0.7)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    // MARK: - Background Gradients
    static let backgroundGradient = LinearGradient(
        colors: [
            Color(.systemBackground),
            primaryGold.opacity(0.05),
            Color(.systemBackground).opacity(0.95),
            primaryGold.opacity(0.03)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let darkBackgroundGradient = LinearGradient(
        colors: [
            Color.black,
            Color.black.opacity(0.95),
            primaryGold.opacity(0.02),
            Color.black
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    // MARK: - Typography
    struct Typography {
        static let largeTitle = Font.system(size: 34, weight: .black, design: .rounded)
        static let title1 = Font.system(size: 28, weight: .bold, design: .rounded)
        static let title2 = Font.system(size: 22, weight: .bold, design: .rounded)
        static let title3 = Font.system(size: 20, weight: .bold, design: .rounded)
        
        static let headline = Font.system(size: 17, weight: .semibold, design: .default)
        static let body = Font.system(size: 17, weight: .regular, design: .default)
        static let callout = Font.system(size: 16, weight: .regular, design: .default)
        static let subheadline = Font.system(size: 15, weight: .regular, design: .default)
        static let footnote = Font.system(size: 13, weight: .regular, design: .default)
        static let caption1 = Font.system(size: 12, weight: .regular, design: .default)
        static let caption2 = Font.system(size: 11, weight: .regular, design: .default)
        
        // Trading-specific typography
        static let priceFont = Font.system(size: 32, weight: .black, design: .monospaced)
        static let pnlFont = Font.system(size: 18, weight: .bold, design: .monospaced)
        static let metricFont = Font.system(size: 14, weight: .semibold, design: .rounded)
    }
    
    // MARK: - Spacing
    struct Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 48
    }
    
    // MARK: - Corner Radius
    struct CornerRadius {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 24
        static let xxl: CGFloat = 32
    }
    
    // MARK: - Shadows
    struct Shadow {
        static let soft = Color.black.opacity(0.05)
        static let medium = Color.black.opacity(0.1)
        static let strong = Color.black.opacity(0.2)
        
        static let goldShadow = primaryGold.opacity(0.3)
        static let tradingShadow = tradingBlue.opacity(0.2)
    }
    
    // MARK: - Animation
    struct Animation {
        static let quick = SwiftUI.Animation.easeInOut(duration: 0.2)
        static let standard = SwiftUI.Animation.easeInOut(duration: 0.3)
        static let slow = SwiftUI.Animation.easeInOut(duration: 0.5)
        
        static let spring = SwiftUI.Animation.spring(response: 0.6, dampingFraction: 0.8)
        static let bouncy = SwiftUI.Animation.spring(response: 0.4, dampingFraction: 0.6)
        
        // Trading-specific animations
        static let priceUpdate = SwiftUI.Animation.easeInOut(duration: 0.1)
        static let tradeExecution = SwiftUI.Animation.spring(response: 0.3, dampingFraction: 0.7)
    }
    
    // MARK: - Card Styles
    static func cardBackground() -> some View {
        RoundedRectangle(cornerRadius: CornerRadius.lg)
            .fill(.ultraThinMaterial)
            .shadow(color: Shadow.soft, radius: 8, x: 0, y: 4)
    }
    
    static func premiumCardBackground() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: CornerRadius.lg)
                .fill(.ultraThinMaterial)
            
            RoundedRectangle(cornerRadius: CornerRadius.lg)
                .stroke(goldGradient, lineWidth: 1)
        }
        .shadow(color: Shadow.goldShadow, radius: 12, x: 0, y: 6)
    }
    
    // MARK: - Button Styles
    struct Buttons {
        static func primary() -> some ButtonStyle {
            PrimaryButtonStyle()
        }
        
        static func secondary() -> some ButtonStyle {
            SecondaryButtonStyle()
        }
        
        static func trading() -> some ButtonStyle {
            TradingButtonStyle()
        }
    }
}

// MARK: - Button Styles Implementation

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(DesignSystem.Typography.headline)
            .foregroundColor(.white)
            .padding(.horizontal, DesignSystem.Spacing.lg)
            .padding(.vertical, DesignSystem.Spacing.md)
            .background(DesignSystem.goldGradient)
            .cornerRadius(DesignSystem.CornerRadius.md)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .animation(DesignSystem.Animation.quick, value: configuration.isPressed)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(DesignSystem.Typography.headline)
            .foregroundColor(DesignSystem.primaryGold)
            .padding(.horizontal, DesignSystem.Spacing.lg)
            .padding(.vertical, DesignSystem.Spacing.md)
            .background(.ultraThinMaterial)
            .cornerRadius(DesignSystem.CornerRadius.md)
            .overlay(
                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.md)
                    .stroke(DesignSystem.primaryGold, lineWidth: 1)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(DesignSystem.Animation.quick, value: configuration.isPressed)
    }
}

struct TradingButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(DesignSystem.Typography.headline.weight(.bold))
            .foregroundColor(.white)
            .padding(.horizontal, DesignSystem.Spacing.xl)
            .padding(.vertical, DesignSystem.Spacing.lg)
            .background(DesignSystem.tradingGradient)
            .cornerRadius(DesignSystem.CornerRadius.xl)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .shadow(color: DesignSystem.Shadow.tradingShadow, radius: 8, x: 0, y: 4)
            .animation(DesignSystem.Animation.tradeExecution, value: configuration.isPressed)
    }
}

// MARK: - View Extensions

extension View {
    func premiumCard() -> some View {
        self.padding(DesignSystem.Spacing.lg)
            .background {
                DesignSystem.premiumCardBackground()
            }
    }
    
    func standardCard() -> some View {
        self.padding(DesignSystem.Spacing.md)
            .background {
                DesignSystem.cardBackground()
            }
    }
    
    func goldText() -> some View {
        self.foregroundStyle(DesignSystem.goldGradient)
    }
    
    func tradingText(_ isProfit: Bool) -> some View {
        self.foregroundColor(isProfit ? DesignSystem.tradingGreen : DesignSystem.tradingRed)
    }
    
    func pulseEffect(_ isActive: Bool = true) -> some View {
        self.scaleEffect(isActive ? 1.05 : 1.0)
            .animation(
                isActive ? 
                DesignSystem.Animation.spring.repeatForever(autoreverses: true) :
                DesignSystem.Animation.standard,
                value: isActive
            )
    }
}

// MARK: - Status Colors

extension DesignSystem {
    static func statusColor(for status: String) -> Color {
        switch status.lowercased() {
        case "active", "connected", "online", "running": return tradingGreen
        case "inactive", "disconnected", "offline", "stopped": return .gray
        case "error", "failed", "cancelled": return tradingRed
        case "pending", "connecting", "loading": return .orange
        case "warning", "caution": return .yellow
        default: return .primary
        }
    }
    
    static func profitColor(for amount: Double) -> Color {
        if amount > 0 { return tradingGreen }
        if amount < 0 { return tradingRed }
        return .gray
    }
}

// MARK: - Color Preview
struct ColorPreview: View {
    let color: Color
    let name: String
    
    var body: some View {
        VStack(spacing: 8) {
            RoundedRectangle(cornerRadius: 8)
                .fill(color)
                .frame(height: 50)
            
            Text(name)
                .font(.caption)
                .foregroundColor(.primary)
        }
    }
}

// MARK: - Color Extensions
extension Color {
    init?(hex: String) {
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
            return nil
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

#Preview {
    ScrollView {
        VStack(spacing: DesignSystem.Spacing.lg) {
            Text("Design System")
                .font(DesignSystem.Typography.largeTitle)
                .goldText()
            
            Text("Complete design system created")
                .font(DesignSystem.Typography.body)
                .foregroundColor(.secondary)
            
            // Color Preview
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: DesignSystem.Spacing.sm) {
                ColorPreview(color: DesignSystem.primaryGold, name: "Primary Gold")
                ColorPreview(color: DesignSystem.tradingGreen, name: "Trading Green")
                ColorPreview(color: DesignSystem.tradingRed, name: "Trading Red")
                ColorPreview(color: DesignSystem.tradingBlue, name: "Trading Blue")
                ColorPreview(color: DesignSystem.lightGold, name: "Light Gold")
                ColorPreview(color: DesignSystem.darkGold, name: "Dark Gold")
                ColorPreview(color: DesignSystem.successGreen, name: "Success Green")
                ColorPreview(color: DesignSystem.dangerRed, name: "Danger Red")
                ColorPreview(color: DesignSystem.warningOrange, name: "Warning Orange")
                ColorPreview(color: DesignSystem.infoBlue, name: "Info Blue")
            }
            
            // Gradient Preview
            VStack(spacing: DesignSystem.Spacing.sm) {
                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.md)
                    .fill(DesignSystem.goldGradient)
                    .frame(height: 60)
                    .overlay(
                        Text("Gold Gradient")
                            .font(DesignSystem.Typography.headline)
                            .foregroundColor(.white)
                    )
                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.md)
                    .fill(DesignSystem.backgroundGradient)
                    .frame(height: 60)
                    .overlay(
                        Text("Background Gradient")
                            .font(DesignSystem.Typography.headline)
                            .foregroundColor(.primary)
                    )
                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.md)
                    .fill(DesignSystem.darkBackgroundGradient)
                    .frame(height: 60)
                    .overlay(
                        Text("Dark Background Gradient")
                            .font(DesignSystem.Typography.headline)
                            .foregroundColor(.white)
                    )
            }
        }
    }
}