//
//  PlanetProTraderLaunchView.swift
//  Planet ProTrader™
//
//  Created by AI Assistant on 1/25/25.
//

import SwiftUI

struct PlanetProTraderLaunchView: View {
    @State private var animateTitle = false
    @State private var animateSlogan = false
    @State private var animatePlanet = false
    @State private var showParticles = false
    @State private var rotationAngle: Double = 0
    @State private var pulseScale: CGFloat = 1.0
    @State private var showMainApp = false
    
    var body: some View {
        ZStack {
            // Epic Space Background
            backgroundView
            
            VStack(spacing: 0) {
                Spacer()
                
                // Planet Animation
                planetView
                
                Spacer().frame(height: 60)
                
                // Main Title
                titleView
                
                Spacer().frame(height: 20)
                
                // Hero Slogan
                heroSloganView
                
                Spacer().frame(height: 40)
                
                // Tagline
                taglineView
                
                Spacer().frame(height: 60)
                
                // Enter Button
                enterButton
                
                Spacer().frame(height: 40)
            }
        }
        .onAppear {
            startEpicAnimations()
        }
        .fullScreenCover(isPresented: $showMainApp) {
            EnhancedHomeDashboardView() // Your main app
        }
    }
    
    private var backgroundView: some View {
        ZStack {
            // Deep space gradient
            LinearGradient(
                colors: [
                    Color.black,
                    Color.purple.opacity(0.4),
                    Color.blue.opacity(0.3),
                    Color.black
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Animated stars
            if showParticles {
                ForEach(0..<100, id: \.self) { i in
                    Circle()
                        .fill(.white.opacity(Double.random(in: 0.3...0.9)))
                        .frame(width: CGFloat.random(in: 1...4))
                        .position(
                            x: CGFloat.random(in: 0...400),
                            y: CGFloat.random(in: 0...900)
                        )
                        .opacity(animateTitle ? 1 : 0)
                        .scaleEffect(animateTitle ? 1 : 0)
                        .animation(
                            .easeInOut(duration: Double.random(in: 2...4))
                            .delay(Double.random(in: 0...2))
                            .repeatForever(autoreverses: true),
                            value: animateTitle
                        )
                }
            }
            
            // Money rain effect
            if animateSlogan {
                ForEach(0..<20, id: \.self) { i in
                    Text("💰")
                        .font(.title)
                        .position(
                            x: CGFloat.random(in: 0...400),
                            y: CGFloat.random(in: 0...900)
                        )
                        .opacity(0.6)
                        .animation(
                            .linear(duration: Double.random(in: 3...6))
                            .delay(Double.random(in: 0...3))
                            .repeatForever(autoreverses: false),
                            value: animateSlogan
                        )
                }
            }
        }
    }
    
    private var planetView: some View {
        ZStack {
            // Planet glow
            Circle()
                .fill(
                    RadialGradient(
                        colors: [.blue.opacity(0.8), .purple.opacity(0.4), .clear],
                        center: .center,
                        startRadius: 50,
                        endRadius: 120
                    )
                )
                .frame(width: 240, height: 240)
                .scaleEffect(pulseScale)
                .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: pulseScale)
            
            // Planet core
            Circle()
                .fill(
                    LinearGradient(
                        colors: [.blue, .purple, .green, .gold],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 100, height: 100)
                .overlay(
                    Circle()
                        .stroke(.white.opacity(0.3), lineWidth: 2)
                )
                .rotationEffect(.degrees(rotationAngle))
                .scaleEffect(animatePlanet ? 1.0 : 0.1)
                .opacity(animatePlanet ? 1 : 0)
            
            // Trading symbols orbiting
            ForEach(["📈", "💰", "🚀", "⚡", "💎", "🔥"], id: \.self) { symbol in
                Text(symbol)
                    .font(.title2)
                    .offset(
                        x: cos(rotationAngle * .pi / 180 + Double(["📈", "💰", "🚀", "⚡", "💎", "🔥"].firstIndex(of: symbol) ?? 0) * 60) * 80,
                        y: sin(rotationAngle * .pi / 180 + Double(["📈", "💰", "🚀", "⚡", "💎", "🔥"].firstIndex(of: symbol) ?? 0) * 60) * 80
                    )
                    .opacity(animatePlanet ? 1 : 0)
            }
        }
        .onAppear {
            withAnimation(.linear(duration: 20).repeatForever(autoreverses: false)) {
                rotationAngle = 360
            }
            
            withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                pulseScale = 1.2
            }
        }
    }
    
    private var titleView: some View {
        VStack(spacing: 8) {
            // Planet ProTrader™
            HStack(spacing: 8) {
                Text("🌍")
                    .font(.system(size: 40))
                    .opacity(animateTitle ? 1 : 0)
                    .scaleEffect(animateTitle ? 1 : 0.5)
                    .rotationEffect(.degrees(animateTitle ? 0 : 180))
                
                VStack(spacing: 4) {
                    Text("Planet")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.blue, .cyan, .green],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .opacity(animateTitle ? 1 : 0)
                        .offset(x: animateTitle ? 0 : -100)
                    
                    Text("ProTrader™")
                        .font(.system(size: 36, weight: .black, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.gold, .orange, .red],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .opacity(animateTitle ? 1 : 0)
                        .offset(x: animateTitle ? 0 : 100)
                }
            }
            .shadow(color: .blue.opacity(0.5), radius: 10, x: 0, y: 0)
            .shadow(color: .purple.opacity(0.3), radius: 20, x: 0, y: 0)
        }
    }
    
    private var heroSloganView: some View {
        VStack(spacing: 12) {
            Text("\"Where Poverty")
                .font(.system(size: 24, weight: .semibold, design: .rounded))
                .foregroundColor(.white)
                .opacity(animateSlogan ? 1 : 0)
                .offset(y: animateSlogan ? 0 : 30)
            
            Text("Doesn't Exist!\"")
                .font(.system(size: 24, weight: .black, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.green, .gold, .green],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .opacity(animateSlogan ? 1 : 0)
                .offset(y: animateSlogan ? 0 : 30)
                .shadow(color: .green.opacity(0.5), radius: 5, x: 0, y: 0)
        }
    }
    
    private var taglineView: some View {
        VStack(spacing: 8) {
            Text("Where trading is a game.")
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundColor(.white.opacity(0.9))
                .opacity(animateSlogan ? 1 : 0)
                .offset(y: animateSlogan ? 0 : 20)
            
            Text("And the money is real.")
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundColor(.gold)
                .opacity(animateSlogan ? 1 : 0)
                .offset(y: animateSlogan ? 0 : 20)
        }
    }
    
    private var enterButton: some View {
        Button(action: {
            withAnimation(.spring(dampingFraction: 0.6)) {
                showMainApp = true
            }
        }) {
            HStack(spacing: 12) {
                Text("🚀")
                    .font(.title2)
                
                Text("ENTER THE PLANET")
                    .font(.system(size: 18, weight: .black, design: .rounded))
                
                Text("💰")
                    .font(.title2)
            }
            .padding(.horizontal, 30)
            .padding(.vertical, 16)
            .background(
                LinearGradient(
                    colors: [.blue, .purple, .blue],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .foregroundColor(.white)
            .cornerRadius(25)
            .shadow(color: .blue.opacity(0.5), radius: 20, x: 0, y: 10)
            .shadow(color: .purple.opacity(0.3), radius: 30, x: 0, y: 20)
            .scaleEffect(animateSlogan ? 1 : 0.8)
            .opacity(animateSlogan ? 1 : 0)
        }
        .buttonStyle(PlanetButtonStyle())
    }
    
    private func startEpicAnimations() {
        // Planet animation
        withAnimation(.spring(dampingFraction: 0.6).delay(0.5)) {
            animatePlanet = true
        }
        
        // Title animation
        withAnimation(.spring(dampingFraction: 0.7).delay(1.0)) {
            animateTitle = true
        }
        
        // Slogan animation
        withAnimation(.spring(dampingFraction: 0.8).delay(1.5)) {
            animateSlogan = true
        }
        
        // Particles
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            showParticles = true
        }
    }
}

struct PlanetButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

#Preview {
    PlanetProTraderLaunchView()
}