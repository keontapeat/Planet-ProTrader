//
//  PremiumComponents.swift
//  Planet ProTrader - Reusable UI Components
//
//  Ultra Premium Component Library
//  Created by Elite UI Team
//

import SwiftUI

// MARK: - Premium Glass Card

struct PremiumGlassCard<Content: View>: View {
    let content: Content
    let cornerRadius: CGFloat
    let strokeWidth: CGFloat
    
    init(
        cornerRadius: CGFloat = 20,
        strokeWidth: CGFloat = 1,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.cornerRadius = cornerRadius
        self.strokeWidth = strokeWidth
    }
    
    var body: some View {
        content
            .padding(24)
            .background(
                ZStack {
                    // Glass effect
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(.ultraThinMaterial)
                    
                    // Border gradient
                    RoundedRectangle(cornerRadius: cornerRadius)
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
                            lineWidth: strokeWidth
                        )
                }
            )
            .shadow(color: .black.opacity(0.05), radius: 20, x: 0, y: 10)
    }
}

// MARK: - Premium Button Style

struct PremiumButtonStyle: ButtonStyle {
    let color: Color
    let isEnabled: Bool
    
    init(color: Color = DesignSystem.primaryGold, isEnabled: Bool = true) {
        self.color = color
        self.isEnabled = isEnabled
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 16, weight: .bold))
            .foregroundColor(.white)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(
                LinearGradient(
                    colors: isEnabled ? [color, color.opacity(0.8)] : [Color.gray.opacity(0.3)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: isEnabled ? color.opacity(0.3) : .clear, radius: 8, x: 0, y: 4)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - Stat Card

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
            // Icon
            if let icon = icon {
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(color)
            }
            
            // Content
            VStack(spacing: 4) {
                Text(value)
                    .font(.system(size: 24, weight: .black, design: .rounded))
                    .foregroundColor(color)
                
                Text(title)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.secondary.opacity(0.7))
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(color.opacity(0.2), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.03), radius: 8, x: 0, y: 4)
    }
}

// MARK: - Premium Text Field

struct PremiumTextField: View {
    let title: String
    @Binding var text: String
    let icon: String
    let placeholder: String?
    
    init(
        title: String,
        text: Binding<String>,
        icon: String,
        placeholder: String? = nil
    ) {
        self.title = title
        self._text = text
        self.icon = icon
        self.placeholder = placeholder ?? "Enter \(title.lowercased())"
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Title
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.secondary)
                
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.primary)
            }
            
            // Text Field
            TextField(placeholder ?? "", text: $text)
                .font(.system(size: 16, weight: .medium))
                .padding(16)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
        }
    }
}

// MARK: - Premium Secure Field

struct PremiumSecureField: View {
    let title: String
    @Binding var text: String
    let icon: String
    let placeholder: String?
    
    init(
        title: String,
        text: Binding<String>,
        icon: String,
        placeholder: String? = nil
    ) {
        self.title = title
        self._text = text
        self.icon = icon
        self.placeholder = placeholder ?? "Enter \(title.lowercased())"
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Title
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.secondary)
                
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.primary)
            }
            
            // Secure Field
            SecureField(placeholder ?? "", text: $text)
                .font(.system(size: 16, weight: .medium))
                .padding(16)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
        }
    }
}

// MARK: - Professional Toast

struct ProfessionalToast: View {
    let title: String
    let message: String
    let type: ToastType
    @Binding var isPresented: Bool
    
    enum ToastType {
        case success, warning, error, info
        
        var color: Color {
            switch self {
            case .success: return .green
            case .warning: return .orange
            case .error: return .red
            case .info: return .blue
            }
        }
        
        var icon: String {
            switch self {
            case .success: return "checkmark.circle.fill"
            case .warning: return "exclamationmark.triangle.fill"
            case .error: return "xmark.circle.fill"
            case .info: return "info.circle.fill"
            }
        }
    }
    
    var body: some View {
        if isPresented {
            VStack {
                Spacer()
                
                HStack(spacing: 12) {
                    Image(systemName: type.icon)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(type.color)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(title)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.primary)
                        
                        Text(message)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation(.spring()) {
                            isPresented = false
                        }
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.secondary)
                    }
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.ultraThinMaterial)
                        .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)
                )
                .padding(.horizontal, 20)
                .padding(.bottom, 100)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
            .onAppear {
                // Auto dismiss after 4 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                    withAnimation(.spring()) {
                        isPresented = false
                    }
                }
            }
        }
    }
}

// MARK: - Ultra Premium Card

struct UltraPremiumCard<Content: View>: View {
    let content: Content
    let backgroundColor: Color
    let accentColor: Color
    
    init(
        backgroundColor: Color = Color(.systemBackground),
        accentColor: Color = DesignSystem.primaryGold,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.backgroundColor = backgroundColor
        self.accentColor = accentColor
    }
    
    var body: some View {
        content
            .padding(24)
            .background(
                ZStack {
                    // Background
                    RoundedRectangle(cornerRadius: 20)
                        .fill(backgroundColor)
                    
                    // Gradient border
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    accentColor.opacity(0.6),
                                    accentColor.opacity(0.1),
                                    Color.clear
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2
                        )
                    
                    // Inner shadow effect
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.2),
                                    Color.clear
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                }
            )
            .shadow(color: accentColor.opacity(0.1), radius: 20, x: 0, y: 10)
    }
}

// MARK: - Loading Shimmer Effect

struct ShimmerView: View {
    @State private var animateShimmer = false
    let cornerRadius: CGFloat
    let height: CGFloat
    
    init(cornerRadius: CGFloat = 8, height: CGFloat = 20) {
        self.cornerRadius = cornerRadius
        self.height = height
    }
    
    var body: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.3))
            .frame(height: height)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.clear,
                                Color.white.opacity(0.6),
                                Color.clear
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .offset(x: animateShimmer ? 200 : -200)
                    .animation(.linear(duration: 1.5).repeatForever(autoreverses: false), value: animateShimmer)
            )
            .onAppear {
                animateShimmer = true
            }
    }
}

// MARK: - Floating Action Button

struct FloatingActionButton: View {
    let icon: String
    let action: () -> Void
    let size: CGFloat
    let color: Color
    
    init(
        icon: String = "plus",
        size: CGFloat = 56,
        color: Color = DesignSystem.primaryGold,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.action = action
        self.size = size
        self.color = color
    }
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [color, color.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: size, height: size)
                    .shadow(color: color.opacity(0.4), radius: 12, x: 0, y: 6)
                
                Image(systemName: icon)
                    .font(.system(size: size * 0.4, weight: .bold))
                    .foregroundColor(.white)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Progress Ring

struct ProgressRing: View {
    let progress: Double
    let lineWidth: CGFloat
    let size: CGFloat
    let color: Color
    
    init(
        progress: Double,
        lineWidth: CGFloat = 8,
        size: CGFloat = 60,
        color: Color = DesignSystem.primaryGold
    ) {
        self.progress = max(0, min(1, progress))
        self.lineWidth = lineWidth
        self.size = size
        self.color = color
    }
    
    var body: some View {
        ZStack {
            // Background ring
            Circle()
                .stroke(color.opacity(0.2), lineWidth: lineWidth)
            
            // Progress ring
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    LinearGradient(
                        colors: [color, color.opacity(0.8)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    style: StrokeStyle(
                        lineWidth: lineWidth,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
            
            // Progress text
            Text("\(Int(progress * 100))%")
                .font(.system(size: size * 0.25, weight: .bold))
                .foregroundColor(color)
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Previews

#Preview("Premium Glass Card") {
    PremiumGlassCard {
        VStack(spacing: 16) {
            Text("Premium Glass Card")
                .font(.title2.bold())
            
            Text("Ultra-premium design with glassmorphism effect and gradient borders.")
                .foregroundColor(.secondary)
        }
    }
    .padding()
    .preferredColorScheme(.light)
}

#Preview("Stat Cards") {
    HStack(spacing: 16) {
        StatCard(title: "Win Rate", value: "89.5%", color: .green, icon: "target")
        StatCard(title: "Profit", value: "$12.5K", color: DesignSystem.primaryGold, icon: "dollarsign.circle.fill")
        StatCard(title: "Trades", value: "342", color: .blue, icon: "chart.bar.fill")
    }
    .padding()
    .preferredColorScheme(.light)
}

#Preview("Premium Components") {
    ScrollView {
        VStack(spacing: 24) {
            // Text Fields
            VStack(spacing: 16) {
                PremiumTextField(title: "Username", text: .constant(""), icon: "person.circle.fill")
                PremiumSecureField(title: "Password", text: .constant(""), icon: "lock.circle.fill")
            }
            
            // Buttons
            VStack(spacing: 12) {
                Button("Premium Button") {}
                    .buttonStyle(PremiumButtonStyle())
                
                Button("Secondary Button") {}
                    .buttonStyle(PremiumButtonStyle(color: .blue))
            }
            
            // Progress Ring
            ProgressRing(progress: 0.75)
            
            // Floating Action Button
            FloatingActionButton(icon: "bolt.fill") {
                // Action
            }
        }
        .padding()
    }
    .preferredColorScheme(.light)
}