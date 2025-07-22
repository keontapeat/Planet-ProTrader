//
//  WelcomeView.swift
//  Planet ProTrader
//
//  ✅ WELCOME SCREEN - Premium onboarding experience
//  Fixed type ambiguity and preview issues
//

import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @State private var currentPage = 0
    @State private var showingLogin = false
    @State private var animateContent = false
    
    private let features = [
        WelcomeFeature(
            icon: "brain.head.profile.fill",
            title: "AI-Powered Trading",
            subtitle: "Advanced algorithms analyze markets 24/7",
            gradient: [DesignSystem.primaryGold, DesignSystem.primaryGold.opacity(0.8)]
        ),
        WelcomeFeature(
            icon: "chart.line.uptrend.xyaxis",
            title: "Real-Time Analytics",
            subtitle: "Professional charts and live market data",
            gradient: [Color.blue, Color.blue.opacity(0.8)]
        ),
        WelcomeFeature(
            icon: "shield.checkerboard",
            title: "Secure & Reliable",
            subtitle: "Bank-grade security for your investments",
            gradient: [Color.green, Color.green.opacity(0.8)]
        )
    ]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                LinearGradient(
                    colors: [
                        Color(.systemBackground),
                        DesignSystem.primaryGold.opacity(0.05),
                        Color(.systemBackground).opacity(0.95)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Logo and branding
                    headerSection
                        .padding(.top, geometry.safeAreaInsets.top + 40)
                    
                    // Feature carousel
                    TabView(selection: $currentPage) {
                        ForEach(features.indices, id: \.self) { index in
                            FeatureCard(feature: features[index])
                                .tag(index)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle())
                    .frame(height: 400)
                    .animation(.easeInOut, value: currentPage)
                    
                    Spacer()
                    
                    // Bottom actions
                    actionButtons
                        .padding(.bottom, geometry.safeAreaInsets.bottom + 20)
                }
                .scaleEffect(animateContent ? 1.0 : 0.95)
                .opacity(animateContent ? 1.0 : 0.0)
            }
        }
        .onAppear {
            startAnimations()
        }
        .sheet(isPresented: $showingLogin) {
            LoginSheet()
                .environmentObject(authManager)
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 20) {
            // Logo
            ZStack {
                Circle()
                    .fill(DesignSystem.goldGradient)
                    .frame(width: 100, height: 100)
                    .shadow(color: DesignSystem.primaryGold.opacity(0.3), radius: 20, x: 0, y: 10)
                
                Image(systemName: "brain.head.profile")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.white)
            }
            
            VStack(spacing: 8) {
                Text("PLANET PROTRADER")
                    .font(.largeTitle)
                    .fontWeight(.black)
                    .foregroundStyle(DesignSystem.goldGradient)
                
                Text("Elite AI Trading Platform")
                    .font(.headline)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    // MARK: - Action Buttons
    private var actionButtons: some View {
        VStack(spacing: 16) {
            // Get Started Button
            Button(action: {
                HapticFeedbackManager.shared.success()
                showingLogin = true
            }) {
                HStack(spacing: 12) {
                    Image(systemName: "bolt.fill")
                        .font(.system(size: 18, weight: .bold))
                    
                    Text("Get Started")
                        .font(.headline)
                        .fontWeight(.bold)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(DesignSystem.goldGradient)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: DesignSystem.primaryGold.opacity(0.3), radius: 12, x: 0, y: 6)
            }
            
            // Demo Button
            Button(action: {
                HapticFeedbackManager.shared.selection()
                // Auto-login with demo credentials
                Task {
                    await authManager.signIn(username: "demo", password: "demo123")
                }
            }) {
                HStack(spacing: 12) {
                    Image(systemName: "play.circle.fill")
                        .font(.system(size: 18, weight: .bold))
                    
                    Text("Try Demo")
                        .font(.headline)
                        .fontWeight(.semibold)
                }
                .foregroundColor(DesignSystem.primaryGold)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(DesignSystem.primaryGold.opacity(0.5), lineWidth: 1)
                )
            }
            
            // Terms and Privacy
            VStack(spacing: 4) {
                Text("By continuing, you agree to our")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                HStack(spacing: 4) {
                    Button("Terms of Service") {
                        // Handle terms
                    }
                    .font(.caption)
                    .foregroundColor(DesignSystem.primaryGold)
                    
                    Text("and")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Button("Privacy Policy") {
                        // Handle privacy
                    }
                    .font(.caption)
                    .foregroundColor(DesignSystem.primaryGold)
                }
            }
        }
        .padding(.horizontal, 20)
    }
    
    private func startAnimations() {
        withAnimation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.3)) {
            animateContent = true
        }
    }
}

// MARK: - Supporting Components

struct WelcomeFeature {
    let icon: String
    let title: String
    let subtitle: String
    let gradient: [Color]
}

struct FeatureCard: View {
    let feature: WelcomeFeature
    
    var body: some View {
        VStack(spacing: 24) {
            // Icon
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: feature.gradient,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)
                    .shadow(color: feature.gradient[0].opacity(0.3), radius: 12, x: 0, y: 6)
                
                Image(systemName: feature.icon)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
            }
            
            // Content
            VStack(spacing: 12) {
                Text(feature.title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                Text(feature.subtitle)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }
        }
        .padding()
    }
}

struct LoginSheet: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authManager: AuthenticationManager
    
    @State private var username = ""
    @State private var password = ""
    @State private var isSignUp = false
    @State private var email = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 32) {
                    // Header
                    VStack(spacing: 16) {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(DesignSystem.primaryGold)
                        
                        Text(isSignUp ? "Create Account" : "Welcome Back")
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    .padding(.top)
                    
                    // Form
                    VStack(spacing: 20) {
                        if isSignUp {
                            CustomTextField(
                                title: "Email",
                                text: $email,
                                icon: "envelope.circle.fill",
                                placeholder: "Enter your email"
                            )
                        }
                        
                        CustomTextField(
                            title: "Username",
                            text: $username,
                            icon: "person.circle.fill",
                            placeholder: "Enter your username"
                        )
                        
                        CustomSecureField(
                            title: "Password",
                            text: $password,
                            icon: "lock.circle.fill",
                            placeholder: "Enter your password"
                        )
                    }
                    
                    // Action Button
                    Button(action: handleLogin) {
                        HStack(spacing: 12) {
                            if authManager.isLoading {
                                ProgressView()
                                    .scaleEffect(0.8)
                                    .tint(.white)
                            } else {
                                Image(systemName: isSignUp ? "person.badge.plus" : "person.fill.checkmark")
                                    .font(.system(size: 16, weight: .bold))
                            }
                            
                            Text(authManager.isLoading ? "Please wait..." : (isSignUp ? "Sign Up" : "Sign In"))
                                .font(.headline)
                                .fontWeight(.bold)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            isFormValid ? DesignSystem.goldGradient : Color.gray.gradient
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .disabled(!isFormValid || authManager.isLoading)
                    
                    // Toggle Sign Up/Sign In
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isSignUp.toggle()
                        }
                    }) {
                        HStack(spacing: 4) {
                            Text(isSignUp ? "Already have an account?" : "Don't have an account?")
                                .foregroundColor(.secondary)
                            
                            Text(isSignUp ? "Sign In" : "Sign Up")
                                .fontWeight(.semibold)
                                .foregroundColor(DesignSystem.primaryGold)
                        }
                        .font(.subheadline)
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle(isSignUp ? "Sign Up" : "Sign In")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") { dismiss() }
                }
            }
            .alert("Error", isPresented: .constant(!authManager.errorMessage.isEmpty)) {
                Button("OK") { 
                    // Clear error message - you'd need to add this method to AuthenticationManager
                }
            } message: {
                Text(authManager.errorMessage)
            }
        }
    }
    
    private var isFormValid: Bool {
        if isSignUp {
            return !username.isEmpty && !password.isEmpty && !email.isEmpty
        } else {
            return !username.isEmpty && !password.isEmpty
        }
    }
    
    private func handleLogin() {
        Task {
            if isSignUp {
                await authManager.signUp(username: username, email: email, password: password)
            } else {
                await authManager.signIn(username: username, password: password)
            }
            
            if authManager.isAuthenticated {
                dismiss()
            }
        }
    }
}

#Preview("Welcome View") {
    WelcomeView()
        .environmentObject(AuthenticationManager())
        .preferredColorScheme(.light)
}

#Preview("Login Sheet") {
    LoginSheet()
        .environmentObject(AuthenticationManager())
        .preferredColorScheme(.light)
}