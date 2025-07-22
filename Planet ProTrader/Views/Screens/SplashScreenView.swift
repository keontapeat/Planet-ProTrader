//
//  SplashScreenView.swift
//  Planet ProTrader
//
//  ✅ SPLASH SCREEN - Simplified professional splash screen
//  Clean design without complex dependencies
//

import SwiftUI

struct SplashScreenView: View {
    @State private var animate = false
    @State private var logoScale: CGFloat = 0.8
    @State private var logoOpacity: Double = 0.0
    @State private var textOpacity: Double = 0.0
    @State private var shimmerOffset: CGFloat = -200
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.black,
                    Color.black.opacity(0.9),
                    DesignSystem.primaryGold.opacity(0.1),
                    Color.black
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Animated background orbs
            Group {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                DesignSystem.primaryGold.opacity(0.3),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 10,
                            endRadius: 100
                        )
                    )
                    .frame(width: 200, height: 200)
                    .offset(x: -100, y: -150)
                    .scaleEffect(animate ? 1.2 : 0.8)
                    .opacity(animate ? 0.6 : 0.0)
                    .blur(radius: 30)
                
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.blue.opacity(0.2),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 10,
                            endRadius: 80
                        )
                    )
                    .frame(width: 150, height: 150)
                    .offset(x: 120, y: 180)
                    .scaleEffect(animate ? 1.1 : 0.9)
                    .opacity(animate ? 0.4 : 0.0)
                    .blur(radius: 25)
            }
            .animation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true), value: animate)
            
            // Main content
            VStack(spacing: 40) {
                Spacer()
                
                // Logo
                ZStack {
                    // Glow effect
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    DesignSystem.primaryGold.opacity(0.4),
                                    Color.clear
                                ],
                                center: .center,
                                startRadius: 0,
                                endRadius: 80
                            )
                        )
                        .frame(width: 160, height: 160)
                        .scaleEffect(animate ? 1.1 : 0.9)
                        .opacity(logoOpacity)
                    
                    // Main logo circle
                    Circle()
                        .fill(DesignSystem.goldGradient)
                        .frame(width: 120, height: 120)
                        .shadow(color: DesignSystem.primaryGold.opacity(0.5), radius: 20, x: 0, y: 10)
                        .scaleEffect(logoScale)
                        .opacity(logoOpacity)
                    
                    // Logo icon
                    Image(systemName: "brain.head.profile")
                        .font(.system(size: 50, weight: .bold))
                        .foregroundColor(.white)
                        .scaleEffect(logoScale)
                        .opacity(logoOpacity)
                }
                
                // App name with shimmer effect
                ZStack {
                    // Background text
                    Text("PLANET PROTRADER")
                        .font(.system(size: 32, weight: .black, design: .rounded))
                        .foregroundColor(.white.opacity(0.1))
                    
                    // Foreground text with shimmer
                    Text("PLANET PROTRADER")
                        .font(.system(size: 32, weight: .black, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [
                                    .white.opacity(0.8),
                                    DesignSystem.primaryGold,
                                    .white.opacity(0.8)
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .mask(
                            Rectangle()
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color.clear,
                                            Color.black,
                                            Color.black,
                                            Color.clear
                                        ],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .offset(x: shimmerOffset)
                        )
                        .opacity(textOpacity)
                }
                
                // Tagline
                Text("Elite AI Trading Platform")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white.opacity(0.7))
                    .opacity(textOpacity)
                
                Spacer()
                
                // Loading indicator
                VStack(spacing: 12) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: DesignSystem.primaryGold))
                        .scaleEffect(1.2)
                        .opacity(textOpacity)
                    
                    Text("Initializing AI Systems...")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.6))
                        .opacity(textOpacity)
                }
                
                Spacer()
                    .frame(height: 50)
            }
        }
        .onAppear {
            startAnimations()
        }
    }
    
    private func startAnimations() {
        // Start background animation
        withAnimation(.easeInOut(duration: 2.0)) {
            animate = true
        }
        
        // Logo animation
        withAnimation(.spring(response: 1.0, dampingFraction: 0.6).delay(0.2)) {
            logoScale = 1.0
            logoOpacity = 1.0
        }
        
        // Text animation
        withAnimation(.easeInOut(duration: 0.8).delay(0.8)) {
            textOpacity = 1.0
        }
        
        // Shimmer effect
        withAnimation(.linear(duration: 2.0).delay(1.0).repeatForever(autoreverses: false)) {
            shimmerOffset = 200
        }
    }
}

#Preview {
    SplashScreenView()
        .preferredColorScheme(.dark)
}