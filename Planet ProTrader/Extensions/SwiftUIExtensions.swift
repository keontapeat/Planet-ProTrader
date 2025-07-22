//
//  SwiftUIExtensions.swift
//  Planet ProTrader - SwiftUI Extensions
//
//  Essential SwiftUI Extensions and Modifiers
//  Created by Elite Engineering Team
//

import SwiftUI
import Foundation

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
    
    // Premium color palette
    static let premiumGold = Color(hex: "#FFD700") ?? .yellow
    static let premiumSilver = Color(hex: "#C0C0C0") ?? .gray
    static let premiumBronze = Color(hex: "#CD7F32") ?? .orange
    static let premiumBlack = Color(hex: "#1C1C1E") ?? .black
    static let premiumWhite = Color(hex: "#FFFFFF") ?? .white
    
    // Trading colors
    static let bullishGreen = Color(hex: "#00C851") ?? .green
    static let bearishRed = Color(hex: "#FF4444") ?? .red
    static let neutralGray = Color(hex: "#6C757D") ?? .gray
    
    // Status colors
    static let successGreen = Color(hex: "#28A745") ?? .green
    static let warningOrange = Color(hex: "#FFC107") ?? .orange
    static let dangerRed = Color(hex: "#DC3545") ?? .red
    static let infoBlue = Color(hex: "#17A2B8") ?? .blue
}

// MARK: - View Extensions

extension View {
    // MARK: - Conditional Modifiers
    
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
    
    @ViewBuilder
    func ifLet<T, Content: View>(_ value: T?, transform: (Self, T) -> Content) -> some View {
        if let value = value {
            transform(self, value)
        } else {
            self
        }
    }
    
    // MARK: - Premium Styling
    
    func premiumGlassBackground() -> some View {
        self
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.2),
                                Color.clear,
                                DesignSystem.primaryGold.opacity(0.1)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .shadow(color: .black.opacity(0.05), radius: 20, x: 0, y: 10)
    }
    
    func premiumCardStyle(cornerRadius: CGFloat = 16, shadowRadius: CGFloat = 8) -> some View {
        self
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .shadow(color: .black.opacity(0.1), radius: shadowRadius, x: 0, y: 4)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color(.separator).opacity(0.2), lineWidth: 1)
            )
    }
    
    func goldBorder(lineWidth: CGFloat = 2, cornerRadius: CGFloat = 12) -> some View {
        self
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(DesignSystem.goldGradient, lineWidth: lineWidth)
            )
    }
    
    // MARK: - Animations
    
    func pulseEffect(scale: CGFloat = 1.1, duration: Double = 1.0) -> some View {
        self
            .scaleEffect(1.0)
            .animation(.easeInOut(duration: duration).repeatForever(autoreverses: true), value: UUID())
    }
    
    func bounceEffect(scale: CGFloat = 1.2, duration: Double = 0.6) -> some View {
        self
            .scaleEffect(1.0)
            .animation(.interpolatingSpring(stiffness: 300, damping: 10, initialVelocity: 0), value: UUID())
    }
    
    func slideInFromBottom(delay: Double = 0) -> some View {
        self
            .offset(y: 100)
            .opacity(0)
            .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(delay), value: UUID())
    }
    
    // MARK: - Haptic Feedback
    
    func onTapHaptic(style: UIImpactFeedbackGenerator.FeedbackStyle = .light, action: @escaping () -> Void) -> some View {
        self
            .onTapGesture {
                HapticFeedbackManager.shared.impact(style)
                action()
            }
    }
    
    // MARK: - Loading States
    
    func skeleton(isLoading: Bool, cornerRadius: CGFloat = 8) -> some View {
        self
            .overlay(
                Group {
                    if isLoading {
                        ShimmerView(cornerRadius: cornerRadius)
                    }
                }
            )
    }
    
    // MARK: - Accessibility
    
    func accessibilityTradingData(
        label: String,
        value: String,
        change: String? = nil,
        isPositive: Bool? = nil
    ) -> some View {
        self
            .accessibilityLabel(label)
            .accessibilityValue(value + (change.map { ", change: \($0)" } ?? ""))
            .accessibilityHint(isPositive.map { $0 ? "Positive change" : "Negative change" } ?? "")
    }
    
    // MARK: - Safe Area
    
    func safeAreaInsetTop(_ inset: CGFloat) -> some View {
        self
            .safeAreaInset(edge: .top) {
                Spacer()
                    .frame(height: inset)
            }
    }
    
    func safeAreaInsetBottom(_ inset: CGFloat) -> some View {
        self
            .safeAreaInset(edge: .bottom) {
                Spacer()
                    .frame(height: inset)
            }
    }
}

// MARK: - Text Extensions

extension Text {
    func premiumTitle() -> some View {
        self
            .font(.system(size: 28, weight: .black, design: .rounded))
            .foregroundStyle(DesignSystem.goldGradient)
    }
    
    func premiumSubtitle() -> some View {
        self
            .font(.system(size: 18, weight: .semibold))
            .foregroundColor(.secondary)
    }
    
    func premiumCaption() -> some View {
        self
            .font(.system(size: 12, weight: .medium))
            .foregroundColor(.secondary)
            .textCase(.uppercase)
            .tracking(0.5)
    }
    
    func tradingPrice() -> some View {
        self
            .font(.system(size: 32, weight: .black, design: .monospaced))
            .foregroundColor(.primary)
    }
    
    func tradingChange(isPositive: Bool) -> some View {
        self
            .font(.system(size: 16, weight: .bold, design: .monospaced))
            .foregroundColor(isPositive ? .bullishGreen : .bearishRed)
    }
}

// MARK: - Animation Extensions

extension Animation {
    static let premiumSpring = Animation.interpolatingSpring(stiffness: 300, damping: 30, initialVelocity: 0)
    static let premiumEaseInOut = Animation.easeInOut(duration: 0.3)
    static let premiumBounce = Animation.interpolatingSpring(stiffness: 600, damping: 15, initialVelocity: 10)
}

// MARK: - Transition Extensions

extension AnyTransition {
    static let slideFromBottom = AnyTransition.move(edge: .bottom).combined(with: .opacity)
    static let slideFromTop = AnyTransition.move(edge: .top).combined(with: .opacity)
    static let slideFromLeading = AnyTransition.move(edge: .leading).combined(with: .opacity)
    static let slideFromTrailing = AnyTransition.move(edge: .trailing).combined(with: .opacity)
    
    static let scaleAndFade = AnyTransition.scale(scale: 0.8).combined(with: .opacity)
    static let rotateAndFade = AnyTransition.modifier(
        active: RotationModifier(rotation: 90),
        identity: RotationModifier(rotation: 0)
    ).combined(with: .opacity)
}

// MARK: - Custom Modifiers

struct RotationModifier: ViewModifier {
    let rotation: Double
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(rotation))
    }
}

struct PremiumShadowModifier: ViewModifier {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
    
    func body(content: Content) -> some View {
        content
            .shadow(color: color, radius: radius, x: x, y: y)
    }
}

struct GradientBorderModifier: ViewModifier {
    let gradient: LinearGradient
    let lineWidth: CGFloat
    let cornerRadius: CGFloat
    
    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(gradient, lineWidth: lineWidth)
            )
    }
}

// MARK: - Environment Extensions

extension EnvironmentValues {
    var hapticFeedbackEnabled: Bool {
        get { self[HapticFeedbackEnabledKey.self] }
        set { self[HapticFeedbackEnabledKey.self] = newValue }
    }
}

struct HapticFeedbackEnabledKey: EnvironmentKey {
    static let defaultValue = true
}

// MARK: - Shape Extensions

extension RoundedRectangle {
    static func premiumCorners(_ radius: CGFloat = 16) -> RoundedRectangle {
        RoundedRectangle(cornerRadius: radius)
    }
}

// MARK: - Gradient Extensions

extension LinearGradient {
    static let goldGradient = LinearGradient(
        colors: [Color.premiumGold, Color.premiumGold.opacity(0.8)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let silverGradient = LinearGradient(
        colors: [Color.premiumSilver, Color.premiumSilver.opacity(0.8)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let premiumBackground = LinearGradient(
        colors: [
            Color(.systemBackground),
            Color.premiumGold.opacity(0.03),
            Color(.systemBackground)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let bullishGradient = LinearGradient(
        colors: [Color.bullishGreen, Color.bullishGreen.opacity(0.7)],
        startPoint: .leading,
        endPoint: .trailing
    )
    
    static let bearishGradient = LinearGradient(
        colors: [Color.bearishRed, Color.bearishRed.opacity(0.7)],
        startPoint: .leading,
        endPoint: .trailing
    )
}

// MARK: - Preference Keys

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct BoundsPreferenceKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}

// MARK: - Custom View Modifiers

struct PremiumButtonStyle: ViewModifier {
    let color: Color
    let isEnabled: Bool
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: 16, weight: .bold))
            .foregroundColor(.white)
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
            .background(
                LinearGradient(
                    colors: isEnabled ? [color, color.opacity(0.8)] : [Color.gray.opacity(0.3)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: isEnabled ? color.opacity(0.3) : .clear, radius: 8, x: 0, y: 4)
    }
}

// MARK: - Helper Functions

extension View {
    func premiumButton(color: Color = DesignSystem.primaryGold, isEnabled: Bool = true) -> some View {
        modifier(PremiumButtonStyle(color: color, isEnabled: isEnabled))
    }
    
    func premiumShadow(color: Color = .black.opacity(0.1), radius: CGFloat = 8, x: CGFloat = 0, y: CGFloat = 4) -> some View {
        modifier(PremiumShadowModifier(color: color, radius: radius, x: x, y: y))
    }
    
    func gradientBorder(
        _ gradient: LinearGradient = .goldGradient,
        lineWidth: CGFloat = 2,
        cornerRadius: CGFloat = 12
    ) -> some View {
        modifier(GradientBorderModifier(gradient: gradient, lineWidth: lineWidth, cornerRadius: cornerRadius))
    }
}

// MARK: - Previews

#Preview("SwiftUI Extensions") {
    ScrollView {
        VStack(spacing: 24) {
            // Color Extensions
            VStack(spacing: 12) {
                Text("Premium Colors")
                    .premiumTitle()
                
                HStack(spacing: 16) {
                    Circle().fill(Color.premiumGold).frame(width: 40, height: 40)
                    Circle().fill(Color.bullishGreen).frame(width: 40, height: 40)
                    Circle().fill(Color.bearishRed).frame(width: 40, height: 40)
                    Circle().fill(Color.infoBlue).frame(width: 40, height: 40)
                }
            }
            .premiumGlassBackground()
            .padding()
            
            // Text Extensions
            VStack(spacing: 12) {
                Text("Premium Typography")
                    .premiumTitle()
                
                Text("Subtitle Example")
                    .premiumSubtitle()
                
                Text("Caption Text")
                    .premiumCaption()
                
                Text("$2,374.85")
                    .tradingPrice()
                
                Text("+12.45")
                    .tradingChange(isPositive: true)
            }
            .premiumCardStyle()
            .padding()
            
            // Button Extensions
            VStack(spacing: 16) {
                Text("Premium Buttons")
                    .premiumSubtitle()
                
                Button("Gold Button") {}
                    .premiumButton()
                
                Button("Success Button") {}
                    .premiumButton(color: .successGreen)
                
                Button("Danger Button") {}
                    .premiumButton(color: .dangerRed)
                
                Button("Disabled Button") {}
                    .premiumButton(isEnabled: false)
            }
            .premiumGlassBackground()
            .padding()
        }
        .padding()
    }
    .background(.premiumBackground)
    .preferredColorScheme(.light)
}