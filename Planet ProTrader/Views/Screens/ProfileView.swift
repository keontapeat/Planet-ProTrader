//
//  ProfileView.swift
//  Planet ProTrader
//
//  ✅ PROFILE SCREEN - User profile and settings management
//  Professional design with comprehensive user controls
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @EnvironmentObject var realTimeAccountManager: RealTimeAccountManager
    @EnvironmentObject var tradingBotManager: TradingBotManager
    
    @State private var showingSettings = false
    @State private var showingAccountManagement = false
    @State private var showingSupport = false
    @State private var showingAbout = false
    @State private var animateCards = false
    @State private var showingSignOutAlert = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 24) {
                    // Profile Header
                    profileHeader
                    
                    // Stats Overview
                    statsOverview
                    
                    // Account Management
                    accountManagementSection
                    
                    // Trading Settings
                    tradingSettingsSection
                    
                    // Support & Information
                    supportSection
                    
                    // Sign Out
                    signOutSection
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
            }
            .background(
                LinearGradient(
                    colors: [
                        Color(.systemBackground),
                        DesignSystem.primaryGold.opacity(0.02),
                        Color(.systemBackground).opacity(0.98)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
            )
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                startAnimations()
            }
            .alert("Sign Out", isPresented: $showingSignOutAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Sign Out", role: .destructive) {
                    authManager.signOut()
                }
            } message: {
                Text("Are you sure you want to sign out?")
            }
        }
    }
    
    // MARK: - Profile Header
    private var profileHeader: some View {
        VStack(spacing: 20) {
            // Avatar and basic info
            VStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(DesignSystem.goldGradient)
                        .frame(width: 100, height: 100)
                        .shadow(color: DesignSystem.primaryGold.opacity(0.3), radius: 12, x: 0, y: 6)
                    
                    if let displayName = authManager.currentUserDisplayName, !displayName.isEmpty {
                        Text(String(displayName.prefix(1).uppercased()))
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    } else {
                        Image(systemName: "person.fill")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                    }
                }
                
                VStack(spacing: 8) {
                    Text(authManager.currentUserDisplayName ?? "Pro Trader")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text(authManager.currentUserEmail ?? "demo@planetprotrader.com")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    // Pro badge
                    HStack(spacing: 6) {
                        Image(systemName: "crown.fill")
                            .font(.caption)
                        Text("PRO MEMBER")
                            .font(.caption)
                            .fontWeight(.bold)
                            .tracking(0.5)
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(DesignSystem.goldGradient)
                    .clipShape(Capsule())
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
        .scaleEffect(animateCards ? 1.0 : 0.95)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.8, dampingFraction: 0.8), value: animateCards)
    }
    
    // MARK: - Stats Overview
    private var statsOverview: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Trading Overview")
                .font(.title3)
                .fontWeight(.semibold)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                ProfileStatCard(
                    title: "Total Equity",
                    value: realTimeAccountManager.formattedEquity,
                    icon: "dollarsign.circle.fill",
                    color: DesignSystem.primaryGold
                )
                
                ProfileStatCard(
                    title: "Win Rate",
                    value: realTimeAccountManager.formattedWinRate,
                    icon: "target",
                    color: .green
                )
                
                ProfileStatCard(
                    title: "Active Bots",
                    value: "\(tradingBotManager.activeBots.count)",
                    icon: "brain.head.profile.fill",
                    color: .blue
                )
                
                ProfileStatCard(
                    title: "Total Trades",
                    value: "\(realTimeAccountManager.totalTrades)",
                    icon: "chart.bar.fill",
                    color: .purple
                )
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.95)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.1), value: animateCards)
    }
    
    // MARK: - Account Management Section
    private var accountManagementSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Account Management")
                .font(.title3)
                .fontWeight(.semibold)
            
            VStack(spacing: 12) {
                ProfileActionRow(
                    title: "Trading Accounts",
                    subtitle: "\(realTimeAccountManager.activeAccounts.count) connected",
                    icon: "building.columns.fill",
                    color: .blue
                ) {
                    showingAccountManagement = true
                }
                
                ProfileActionRow(
                    title: "Subscription",
                    subtitle: "Pro Plan Active",
                    icon: "crown.fill",
                    color: DesignSystem.primaryGold
                ) {
                    // Handle subscription management
                }
                
                ProfileActionRow(
                    title: "Security",
                    subtitle: "Two-factor authentication",
                    icon: "shield.checkerboard",
                    color: .green
                ) {
                    // Handle security settings
                }
                
                ProfileActionRow(
                    title: "Notifications",
                    subtitle: "Manage alerts & preferences",
                    icon: "bell.badge.fill",
                    color: .orange
                ) {
                    // Handle notification settings
                }
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.95)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.2), value: animateCards)
    }
    
    // MARK: - Trading Settings Section
    private var tradingSettingsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Trading Settings")
                .font(.title3)
                .fontWeight(.semibold)
            
            VStack(spacing: 12) {
                ProfileActionRow(
                    title: "Risk Management",
                    subtitle: "Position sizing & limits",
                    icon: "shield.lefthalf.filled.badge.checkmark",
                    color: .red
                ) {
                    // Handle risk management
                }
                
                ProfileActionRow(
                    title: "Bot Configuration",
                    subtitle: "AI trading preferences",
                    icon: "gearshape.2.fill",
                    color: .blue
                ) {
                    // Handle bot configuration
                }
                
                ProfileActionRow(
                    title: "Chart Settings",
                    subtitle: "Indicators & timeframes",
                    icon: "chart.line.uptrend.xyaxis",
                    color: .green
                ) {
                    // Handle chart settings
                }
                
                ProfileActionRow(
                    title: "API Connections",
                    subtitle: "External integrations",
                    icon: "link.circle.fill",
                    color: .purple
                ) {
                    // Handle API connections
                }
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.95)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.3), value: animateCards)
    }
    
    // MARK: - Support Section
    private var supportSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Support & Information")
                .font(.title3)
                .fontWeight(.semibold)
            
            VStack(spacing: 12) {
                ProfileActionRow(
                    title: "Help Center",
                    subtitle: "FAQs & tutorials",
                    icon: "questionmark.circle.fill",
                    color: .blue
                ) {
                    showingSupport = true
                }
                
                ProfileActionRow(
                    title: "Contact Support",
                    subtitle: "Get help from our team",
                    icon: "message.circle.fill",
                    color: .green
                ) {
                    // Handle contact support
                }
                
                ProfileActionRow(
                    title: "Community",
                    subtitle: "Join Discord & forums",
                    icon: "person.3.sequence.fill",
                    color: .purple
                ) {
                    // Handle community
                }
                
                ProfileActionRow(
                    title: "About",
                    subtitle: "Version 1.0.0 (Beta)",
                    icon: "info.circle.fill",
                    color: .gray
                ) {
                    showingAbout = true
                }
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.95)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.4), value: animateCards)
    }
    
    // MARK: - Sign Out Section
    private var signOutSection: some View {
        Button(action: {
            HapticFeedbackManager.shared.warning()
            showingSignOutAlert = true
        }) {
            HStack {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .font(.title3)
                    .foregroundColor(.red)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Sign Out")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.red)
                    
                    Text("Sign out of your account")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.red.opacity(0.3), lineWidth: 1)
            )
        }
        .scaleEffect(animateCards ? 1.0 : 0.95)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.5), value: animateCards)
    }
    
    // MARK: - Helper Methods
    private func startAnimations() {
        withAnimation(.spring(response: 1.0, dampingFraction: 0.8).delay(0.2)) {
            animateCards = true
        }
    }
}

// MARK: - Supporting Components

struct ProfileStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(color)
            
            VStack(spacing: 4) {
                Text(value)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
}

struct ProfileActionRow: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            HapticFeedbackManager.shared.selection()
            action()
        }) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(color)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthenticationManager())
        .environmentObject(RealTimeAccountManager())
        .environmentObject(TradingBotManager.shared)
        .preferredColorScheme(.light)
}