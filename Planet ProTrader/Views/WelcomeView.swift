//
//  WelcomeView.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 7/13/25.
//  Fixed Preview ambiguity issue
//

import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject private var authManager: AuthenticationManager
    @State private var username = ""
    @State private var password = ""
    @State private var showingSignUp = false
    @State private var pulseAnimation = false
    
    var body: some View {
        ZStack {
            DesignSystem.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 40) {
                    // Hero Section
                    heroSection
                    
                    // Login Section
                    loginSection
                    
                    // Features Section
                    featuresSection
                    
                    Spacer(minLength: 50)
                }
                .padding(.horizontal, 24)
                .padding(.top, 50)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                pulseAnimation = true
            }
        }
    }
    
    private var heroSection: some View {
        VStack(spacing: 24) {
            // Logo/Icon
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                DesignSystem.primaryGold.opacity(0.4),
                                DesignSystem.primaryGold.opacity(0.2),
                                DesignSystem.primaryGold.opacity(0.1)
                            ],
                            center: .center,
                            startRadius: 30,
                            endRadius: 80
                        )
                    )
                    .frame(width: 120, height: 120)
                    .scaleEffect(pulseAnimation ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: pulseAnimation)
                
                Circle()
                    .stroke(DesignSystem.primaryGold, lineWidth: 3)
                    .frame(width: 100, height: 100)
                
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundStyle(DesignSystem.primaryGold)
            }
            
            VStack(spacing: 16) {
                Text("GOLDEX AI")
                    .font(.system(size: 42, weight: .black, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [DesignSystem.primaryGold, DesignSystem.darkGold],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                Text("Elite AI Trading Platform")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                
                Text("Unleash the power of advanced AI algorithms to dominate the gold trading markets with unprecedented precision and profit.")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
            }
        }
    }
    
    private var loginSection: some View {
        UltraPremiumCard {
            VStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Welcome Back")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)
                    
                    VStack(spacing: 16) {
                        TextField("Username", text: $username)
                            .textFieldStyle(.roundedBorder)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                        
                        SecureField("Password", text: $password)
                            .textFieldStyle(.roundedBorder)
                    }
                }
                
                VStack(spacing: 12) {
                    Button(action: signIn) {
                        HStack {
                            if authManager.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(0.8)
                            } else {
                                Image(systemName: "arrow.right.circle.fill")
                                    .font(.title3)
                            }
                            
                            Text(authManager.isLoading ? "Signing In..." : "Sign In")
                                .font(.headline)
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(DesignSystem.goldGradient)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(color: DesignSystem.primaryGold.opacity(0.4), radius: 8, x: 0, y: 4)
                    }
                    .disabled(authManager.isLoading || username.isEmpty || password.isEmpty)
                    
                    Button("Don't have an account? Sign up") {
                        showingSignUp = true
                    }
                    .font(.subheadline)
                    .foregroundColor(DesignSystem.primaryGold)
                }
            }
        }
    }
    
    private var featuresSection: some View {
        VStack(spacing: 20) {
            Text("Elite Features")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.primary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                WelcomeFeatureCard(
                    icon: "brain.head.profile",
                    title: "AI Trading",
                    description: "Advanced algorithms analyze markets 24/7",
                    color: DesignSystem.primaryGold
                )
                
                WelcomeFeatureCard(
                    icon: "chart.line.uptrend.xyaxis",
                    title: "Real-time Analysis",
                    description: "Live market data and instant signals",
                    color: .blue
                )
                
                WelcomeFeatureCard(
                    icon: "shield.checkered",
                    title: "Risk Management",
                    description: "Intelligent position sizing and protection",
                    color: .green
                )
                
                WelcomeFeatureCard(
                    icon: "crown.fill",
                    title: "Elite Performance",
                    description: "Professional-grade trading tools",
                    color: .purple
                )
            }
        }
    }
    
    private func signIn() {
        Task {
            await authManager.signIn(username: username, password: password)
        }
    }
}

struct WelcomeFeatureCard: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.1))
                    .frame(width: 60, height: 60)
                
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(color)
            }
            
            VStack(spacing: 4) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
                
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Preview Provider (Fixed ambiguous Preview)
struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
            .environmentObject(PreviewAuthenticationManager())
            .preferredColorScheme(.light)
    }
}

// MARK: - Preview Authentication Manager
class PreviewAuthenticationManager: ObservableObject {
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var user: User?
    
    func signIn(username: String, password: String) async {
        await MainActor.run {
            isLoading = true
        }
        
        // Simulate network delay
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        await MainActor.run {
            isLoading = false
            isAuthenticated = true
        }
    }
    
    func signOut() {
        isAuthenticated = false
        user = nil
    }
    
    func signUp(username: String, email: String, password: String) async {
        await signIn(username: username, password: password)
    }
}

// MARK: - Mock User for Preview
struct User: Codable {
    let id: String
    let username: String
    let email: String
    
    init(id: String = "preview-user", username: String = "demo", email: String = "demo@goldex.ai") {
        self.id = id
        self.username = username
        self.email = email
    }
}