//
//  WelcomeView.swift
//  Planet ProTrader - Onboarding Experience
//
//  Premium Welcome Screen
//  Created by Elite Design Team
//

import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var authService: AuthenticationManager
    @State private var animateElements = false
    @State private var currentPage = 0
    @State private var showLogin = false
    
    private let welcomePages = [
        WelcomePage(
            title: "AI-Powered Trading",
            subtitle: "Experience the future of gold trading with advanced AI algorithms",
            icon: "brain.head.profile.fill",
            color: DesignSystem.primaryGold
        ),
        WelcomePage(
            title: "ProTrader Bot Army",
            subtitle: "Deploy multiple trading bots to maximize your profits 24/7",
            icon: "person.3.sequence.fill",
            color: .blue
        ),
        WelcomePage(
            title: "Real-Time Analytics",
            subtitle: "Advanced market intelligence and live trading insights",
            icon: "chart.line.uptrend.xyaxis",
            color: .green
        )
    ]
    
    var body: some View {
        ZStack {
            // Premium Background
            LinearGradient(
                colors: [
                    Color(.systemBackground),
                    DesignSystem.primaryGold.opacity(0.05),
                    Color(.systemBackground)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                headerSection
                    .scaleEffect(animateElements ? 1.0 : 0.8)
                    .opacity(animateElements ? 1.0 : 0.0)
                
                // Page View
                TabView(selection: $currentPage) {
                    ForEach(welcomePages.indices, id: \.self) { index in
                        WelcomePageView(page: welcomePages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .frame(height: 400)
                .scaleEffect(animateElements ? 1.0 : 0.9)
                .opacity(animateElements ? 1.0 : 0.0)
                
                // Page Indicator
                pageIndicator
                    .padding(.vertical, 30)
                    .opacity(animateElements ? 1.0 : 0.0)
                
                Spacer()
                
                // Action Buttons
                actionButtons
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                    .opacity(animateElements ? 1.0 : 0.0)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 1.0, dampingFraction: 0.8).delay(0.3)) {
                animateElements = true
            }
        }
        .sheet(isPresented: $showLogin) {
            LoginView()
                .environmentObject(authService)
        }
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            // App Logo
            ZStack {
                Circle()
                    .fill(DesignSystem.goldGradient)
                    .frame(width: 80, height: 80)
                    .shadow(color: DesignSystem.primaryGold.opacity(0.4), radius: 20, x: 0, y: 10)
                
                Image(systemName: "brain.head.profile.fill")
                    .font(.system(size: 36, weight: .black))
                    .foregroundColor(.white)
            }
            
            VStack(spacing: 8) {
                Text("PLANET PROTRADER")
                    .font(.system(size: 28, weight: .black, design: .rounded))
                    .foregroundStyle(DesignSystem.goldGradient)
                    .tracking(1.5)
                
                Text("Elite AI Trading Platform")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.secondary)
                    .tracking(0.5)
            }
        }
        .padding(.top, 60)
        .padding(.bottom, 20)
    }
    
    // MARK: - Page Indicator
    
    private var pageIndicator: some View {
        HStack(spacing: 12) {
            ForEach(welcomePages.indices, id: \.self) { index in
                Button(action: {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                        currentPage = index
                    }
                }) {
                    Capsule()
                        .fill(index == currentPage ? DesignSystem.primaryGold : Color.gray.opacity(0.3))
                        .frame(width: index == currentPage ? 30 : 8, height: 8)
                }
            }
        }
    }
    
    // MARK: - Action Buttons
    
    private var actionButtons: some View {
        VStack(spacing: 16) {
            // Get Started Button
            Button(action: {
                // Demo login for quick start
                Task {
                    await authService.signIn(username: "demo", password: "demo123")
                }
            }) {
                HStack {
                    Text("Get Started")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                    
                    Image(systemName: "arrow.right.circle.fill")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(DesignSystem.goldGradient)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: DesignSystem.primaryGold.opacity(0.4), radius: 12, x: 0, y: 6)
            }
            
            // Sign In Button
            Button(action: {
                showLogin = true
            }) {
                Text("Sign In")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(DesignSystem.primaryGold)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(DesignSystem.primaryGold, lineWidth: 2)
                    )
            }
            
            // Terms and Privacy
            Text("By continuing, you agree to our [Terms of Service](https://planetprotrader.com/terms) and [Privacy Policy](https://planetprotrader.com/privacy)")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.top, 8)
        }
    }
}

// MARK: - Welcome Page View

struct WelcomePageView: View {
    let page: WelcomePage
    @State private var animateIcon = false
    
    var body: some View {
        VStack(spacing: 32) {
            // Icon
            ZStack {
                Circle()
                    .fill(page.color.opacity(0.2))
                    .frame(width: 120, height: 120)
                    .scaleEffect(animateIcon ? 1.1 : 1.0)
                
                Image(systemName: page.icon)
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(page.color)
                    .scaleEffect(animateIcon ? 1.1 : 1.0)
            }
            .onAppear {
                withAnimation(.easeInOut(duration: 2).repeatForever()) {
                    animateIcon = true
                }
            }
            
            // Content
            VStack(spacing: 16) {
                Text(page.title)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                
                Text(page.subtitle)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .padding(.horizontal, 32)
            }
        }
        .padding()
    }
}

// MARK: - Login View

struct LoginView: View {
    @EnvironmentObject var authService: AuthenticationManager
    @Environment(\.dismiss) private var dismiss
    @State private var username = ""
    @State private var password = ""
    @State private var isLoading = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 32) {
                    // Header
                    VStack(spacing: 16) {
                        Image(systemName: "brain.head.profile.fill")
                            .font(.system(size: 48, weight: .bold))
                            .foregroundStyle(DesignSystem.goldGradient)
                        
                        Text("Welcome Back")
                            .font(.largeTitle.bold())
                        
                        Text("Sign in to continue your trading journey")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 40)
                    
                    // Form
                    VStack(spacing: 20) {
                        PremiumTextField(
                            title: "Username",
                            text: $username,
                            icon: "person.circle.fill"
                        )
                        
                        PremiumSecureField(
                            title: "Password",
                            text: $password,
                            icon: "lock.circle.fill"
                        )
                        
                        // Sign In Button
                        Button(action: signIn) {
                            HStack {
                                if isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .scaleEffect(0.8)
                                } else {
                                    Text("Sign In")
                                        .font(.system(size: 18, weight: .bold))
                                }
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(DesignSystem.goldGradient)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                        .disabled(isLoading || username.isEmpty || password.isEmpty)
                        
                        // Demo Login
                        Button("Try Demo Account") {
                            username = "demo"
                            password = "demo123"
                            signIn()
                        }
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(DesignSystem.primaryGold)
                    }
                }
                .padding(.horizontal, 24)
            }
            .navigationTitle("Sign In")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
    
    private func signIn() {
        isLoading = true
        Task {
            await authService.signIn(username: username, password: password)
            await MainActor.run {
                isLoading = false
                dismiss()
            }
        }
    }
}

// MARK: - Supporting Types

struct WelcomePage {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
}

// MARK: - Previews

#Preview("Welcome View") {
    WelcomeView()
        .environmentObject(AuthenticationManager())
        .preferredColorScheme(.light)
}

#Preview("Login View") {
    LoginView()
        .environmentObject(AuthenticationManager())
        .preferredColorScheme(.light)
}

#Preview("Welcome Page") {
    WelcomePageView(
        page: WelcomePage(
            title: "AI-Powered Trading",
            subtitle: "Experience the future of gold trading with advanced AI algorithms",
            icon: "brain.head.profile.fill",
            color: DesignSystem.primaryGold
        )
    )
    .preferredColorScheme(.light)
}