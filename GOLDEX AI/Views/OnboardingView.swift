//
//  OnboardingView.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 7/13/25.
//

import SwiftUI

struct OnboardingView: View {
    @Binding var isOnboardingComplete: Bool
    @State private var currentPage = 0
    @State private var animateElements = false
    @State private var showProfitAnimation = false
    @State private var showFlipAnimation = false
    @State private var showAIAnimation = false
    
    private let pages = [
        OnboardingPage(
            title: "GOLDEX AI",
            subtitle: "Elite Gold Trading Revolution",
            description: "The world's most advanced AI trading system that transforms $100 into $100,000 in just one trading week using institutional-grade algorithms.",
            imageName: "brain.head.profile",
            color: DesignSystem.primaryGold,
            features: [
                "Revolutionary AI Technology",
                "Institutional-Grade Analysis",
                "Real-Time Market Intelligence",
                "Smart Money Concepts"
            ]
        ),
        OnboardingPage(
            title: "$100 → $100K Challenge",
            subtitle: "One Week Transformation",
            description: "Our proven FLIP MODE system compounds small accounts exponentially. Watch $100 become $100,000 in just 7 trading days through precision scaling.",
            imageName: "chart.line.uptrend.xyaxis",
            color: .green,
            features: [
                "Day 1: $100 → $1,000 (10x)",
                "Day 3: $1,000 → $10,000 (100x)", 
                "Day 7: $10,000 → $100,000 (1,000x)",
                "84.7% Win Rate Guaranteed"
            ]
        ),
        OnboardingPage(
            title: "AI-Powered Signals",
            subtitle: "Precision Beyond Human Capability",
            description: "Advanced machine learning analyzes 47 market variables per second, delivering signals with 84.7% win rate and 3.2:1 risk-reward ratio.",
            imageName: "bolt.fill",
            color: .blue,
            features: [
                "Multi-Timeframe Analysis",
                "Smart Money Concepts",
                "Liquidity Mapping",
                "Institutional Order Flow"
            ]
        ),
        OnboardingPage(
            title: "Mass Trading System",
            subtitle: "Scale Across Multiple Accounts",
            description: "Deploy AI across 100+ demo accounts simultaneously. Each account compounds independently, creating massive profit potential.",
            imageName: "server.rack",
            color: .purple,
            features: [
                "100+ Simultaneous Accounts",
                "VPS Auto-Deployment",
                "Real-Time Monitoring",
                "Automated Risk Management"
            ]
        ),
        OnboardingPage(
            title: "Smart Money Concepts",
            subtitle: "Trade Like Institutions",
            description: "Access the same strategies used by Goldman Sachs, JP Morgan, and other elite institutions. Follow the smart money, not retail sentiment.",
            imageName: "building.columns.fill",
            color: .orange,
            features: [
                "Order Block Analysis",
                "Liquidity Sweeps",
                "Fair Value Gaps",
                "Market Structure Shifts"
            ]
        ),
        OnboardingPage(
            title: "Ready to Transform?",
            subtitle: "Your Trading Revolution Starts Now",
            description: "Join thousands of traders who've already transformed their financial future. The next $100K success story could be yours.",
            imageName: "star.fill",
            color: DesignSystem.primaryGold,
            features: [
                "Complete Setup in 60 Seconds",
                "No Trading Experience Required",
                "24/7 AI-Powered Trading",
                "Lifetime Access & Updates"
            ]
        )
    ]
    
    var body: some View {
        ZStack {
            // Dynamic background
            AnimatedBackground(currentPage: currentPage)
            
            VStack(spacing: 0) {
                // Progress indicator
                ProgressIndicator(currentPage: currentPage, totalPages: pages.count)
                    .padding(.top, 20)
                
                // Main content
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(
                            page: pages[index],
                            isActive: currentPage == index,
                            showSpecialAnimation: getSpecialAnimation(for: index)
                        )
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut(duration: 0.5), value: currentPage)
                
                // Bottom controls
                VStack(spacing: 16) {
                    // Navigation buttons
                    HStack(spacing: 16) {
                        if currentPage > 0 {
                            Button("Previous") {
                                withAnimation(.spring()) {
                                    currentPage -= 1
                                }
                            }
                            .goldexSecondaryButtonStyle()
                        }
                        
                        Spacer()
                        
                        if currentPage < pages.count - 1 {
                            Button("Next") {
                                withAnimation(.spring()) {
                                    currentPage += 1
                                }
                            }
                            .goldexButtonStyle()
                        } else {
                            Button("Start Trading") {
                                withAnimation(.spring()) {
                                    isOnboardingComplete = true
                                }
                            }
                            .goldexButtonStyle()
                        }
                    }
                    .padding(.horizontal, 24)
                    
                    // Skip button
                    Button("Skip Introduction") {
                        withAnimation(.easeInOut) {
                            isOnboardingComplete = true
                        }
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .opacity(currentPage < pages.count - 1 ? 1 : 0)
                }
                .padding(.bottom, 34)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0).delay(0.5)) {
                animateElements = true
            }
        }
        .statusBarHidden()
    }
    
    private func getSpecialAnimation(for index: Int) -> Bool {
        switch index {
        case 1: return showFlipAnimation
        case 2: return showAIAnimation
        default: return false
        }
    }
}

struct OnboardingPage {
    let title: String
    let subtitle: String
    let description: String
    let imageName: String
    let color: Color
    let features: [String]
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    let isActive: Bool
    let showSpecialAnimation: Bool
    
    @State private var titleAnimation = false
    @State private var featuresAnimation = false
    @State private var iconAnimation = false
    @State private var profitCounter = 100.0
    @State private var showProfitGlow = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                Spacer(minLength: 40)
                
                // Icon with special effects
                ZStack {
                    // Animated rings for first page
                    if page.title == "GOLDEX AI" {
                        ForEach(0..<3) { index in
                            Circle()
                                .stroke(
                                    page.color.opacity(0.3 - Double(index) * 0.1),
                                    lineWidth: 2
                                )
                                .frame(width: 120 + CGFloat(index * 30))
                                .scaleEffect(isActive ? 1.0 : 0.8)
                                .animation(
                                    .easeInOut(duration: 2.0)
                                        .repeatForever(autoreverses: true)
                                        .delay(Double(index) * 0.3),
                                    value: isActive
                                )
                        }
                    }
                    
                    // Profit animation for flip mode page
                    if page.title == "$100 → $100K Challenge" {
                        ProfitAnimationView(isActive: isActive)
                    } else {
                        // Regular icon
                        ZStack {
                            Circle()
                                .fill(page.color.opacity(0.1))
                                .frame(width: 120, height: 120)
                                .scaleEffect(isActive ? 1.0 : 0.9)
                            
                            Image(systemName: page.imageName)
                                .font(.system(size: 50, weight: .light))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [page.color, page.color.opacity(0.7)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .scaleEffect(iconAnimation ? 1.0 : 0.8)
                                .animation(.spring(response: 0.8, dampingFraction: 0.6), value: iconAnimation)
                        }
                    }
                }
                .onAppear {
                    withAnimation(.spring().delay(0.3)) {
                        iconAnimation = true
                    }
                }
                
                // Title section
                VStack(spacing: 8) {
                    Text(page.title)
                        .font(.system(size: 34, weight: .black, design: .rounded))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [page.color, page.color.opacity(0.8)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .opacity(titleAnimation ? 1 : 0)
                        .offset(y: titleAnimation ? 0 : 20)
                    
                    Text(page.subtitle)
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                        .opacity(titleAnimation ? 1 : 0)
                        .offset(y: titleAnimation ? 0 : 20)
                }
                .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.5), value: titleAnimation)
                
                // Description
                Text(page.description)
                    .font(.system(size: 16, weight: .regular))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.primary)
                    .opacity(titleAnimation ? 1 : 0)
                    .offset(y: titleAnimation ? 0 : 20)
                    .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.7), value: titleAnimation)
                
                // Features list
                VStack(spacing: 12) {
                    ForEach(Array(page.features.enumerated()), id: \.offset) { index, feature in
                        FeatureRow(
                            feature: feature,
                            color: page.color,
                            isVisible: featuresAnimation,
                            delay: Double(index) * 0.1
                        )
                    }
                }
                .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.9), value: featuresAnimation)
                
                Spacer(minLength: 100)
            }
            .padding(.horizontal, 24)
        }
        .onAppear {
            if isActive {
                withAnimation(.spring().delay(0.5)) {
                    titleAnimation = true
                }
                withAnimation(.spring().delay(0.9)) {
                    featuresAnimation = true
                }
            }
        }
        .onChange(of: isActive) { _, newValue in
            if newValue {
                withAnimation(.spring().delay(0.2)) {
                    titleAnimation = true
                }
                withAnimation(.spring().delay(0.6)) {
                    featuresAnimation = true
                }
            }
        }
    }
}

struct ProfitAnimationView: View {
    let isActive: Bool
    @State private var currentAmount = 100.0
    @State private var showGlow = false
    @State private var pulseScale = 1.0
    
    private let milestones = [100.0, 500.0, 1000.0, 5000.0, 10000.0, 50000.0, 100000.0]
    
    var body: some View {
        ZStack {
            // Glow effect
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.green.opacity(showGlow ? 0.3 : 0.1),
                            Color.green.opacity(0.05),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 20,
                        endRadius: 80
                    )
                )
                .frame(width: 160, height: 160)
                .scaleEffect(pulseScale)
                .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: pulseScale)
            
            // Main content
            VStack(spacing: 8) {
                Text("$\(formatAmount(currentAmount))")
                    .font(.system(size: 24, weight: .black, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.green, .green.opacity(0.8)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                
                Text("Week 1 Target")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .scaleEffect(showGlow ? 1.1 : 1.0)
            .animation(.spring(response: 0.5, dampingFraction: 0.6), value: showGlow)
        }
        .onAppear {
            if isActive {
                startAnimation()
            }
        }
        .onChange(of: isActive) { _, newValue in
            if newValue {
                startAnimation()
            }
        }
    }
    
    private func startAnimation() {
        pulseScale = 1.1
        
        for (index, milestone) in milestones.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.8) {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    currentAmount = milestone
                    showGlow = true
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    withAnimation(.easeOut(duration: 0.3)) {
                        showGlow = false
                    }
                }
            }
        }
    }
    
    private func formatAmount(_ amount: Double) -> String {
        if amount >= 1000 {
            return String(format: "%.0fK", amount / 1000)
        } else {
            return String(format: "%.0f", amount)
        }
    }
}

struct FeatureRow: View {
    let feature: String
    let color: Color
    let isVisible: Bool
    let delay: Double
    
    @State private var appeared = false
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(color)
                .scaleEffect(appeared ? 1.0 : 0.8)
            
            Text(feature)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.primary)
                .multilineTextAlignment(.leading)
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(color.opacity(0.1))
                .opacity(appeared ? 1 : 0)
        )
        .opacity(appeared ? 1 : 0)
        .offset(x: appeared ? 0 : 20)
        .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(delay), value: appeared)
        .onAppear {
            if isVisible {
                withAnimation(.spring().delay(delay)) {
                    appeared = true
                }
            }
        }
        .onChange(of: isVisible) { _, newValue in
            if newValue {
                withAnimation(.spring().delay(delay)) {
                    appeared = true
                }
            }
        }
    }
}

struct AnimatedBackground: View {
    let currentPage: Int
    
    var body: some View {
        ZStack {
            // Base background
            LinearGradient(
                colors: [
                    Color.white,
                    getPageColor().opacity(0.03),
                    Color.white
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Animated particles
            ForEach(0..<8) { index in
                Circle()
                    .fill(getPageColor().opacity(0.1))
                    .frame(width: CGFloat.random(in: 4...12))
                    .position(
                        x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                        y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                    )
                    .animation(
                        .linear(duration: Double.random(in: 10...20))
                            .repeatForever(autoreverses: false)
                            .delay(Double(index) * 0.5),
                        value: currentPage
                    )
            }
        }
        .animation(.easeInOut(duration: 0.8), value: currentPage)
    }
    
    private func getPageColor() -> Color {
        let colors: [Color] = [
            DesignSystem.primaryGold,
            .green,
            .blue,
            .purple,
            .orange,
            DesignSystem.primaryGold
        ]
        return colors[min(currentPage, colors.count - 1)]
    }
}

struct ProgressIndicator: View {
    let currentPage: Int
    let totalPages: Int
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<totalPages, id: \.self) { index in
                Capsule()
                    .fill(index == currentPage ? DesignSystem.primaryGold : Color.gray.opacity(0.3))
                    .frame(width: index == currentPage ? 24 : 8, height: 4)
                    .animation(.spring(response: 0.6, dampingFraction: 0.8), value: currentPage)
            }
        }
        .padding(.horizontal, 24)
    }
}

#Preview {
    OnboardingView(isOnboardingComplete: .constant(false))
}

// MARK: - Apple Semantic Color System
extension SharedTypes.TradeGrade {
    /// Colors following Apple's semantic color guidelines
    var onboardingColor: Color {
        switch self {
        case .elite: return .green
        case .good: return Color(.systemGreen)
        case .average: return .yellow
        case .poor: return .orange
        case .all: return Color(.systemGray)
        }
    }
}