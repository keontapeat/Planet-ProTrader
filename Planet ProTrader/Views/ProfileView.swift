//
//  ProfileView.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 1/25/25.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var authManager: AuthenticationManager
    @State private var showingSignOut = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Profile Header
                    profileHeader
                    
                    // Account Stats
                    accountStatsSection
                    
                    // Settings Options
                    settingsOptionsSection
                    
                    // Sign Out Button
                    signOutSection
                    
                    Spacer(minLength: 100)
                }
                .padding()
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private var profileHeader: some View {
        UltraPremiumCard {
            VStack(spacing: 16) {
                // Profile Picture
                ZStack {
                    Circle()
                        .fill(DesignSystem.goldGradient)
                        .frame(width: 80, height: 80)
                    
                    Image(systemName: "person.fill")
                        .font(.system(size: 36))
                        .foregroundColor(.white)
                }
                
                VStack(spacing: 4) {
                    Text(authManager.currentUserDisplayName ?? "Elite Trader")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text(authManager.currentUserEmail ?? "trader@goldex.ai")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        Image(systemName: "crown.fill")
                            .font(.caption)
                            .foregroundColor(DesignSystem.primaryGold)
                        
                        Text("Pro Member")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(DesignSystem.primaryGold)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(DesignSystem.primaryGold.opacity(0.1))
                    .cornerRadius(12)
                }
            }
        }
    }
    
    private var accountStatsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Account Statistics")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                StatCard(
                    title: "Total P&L",
                    value: "$5,247.85",
                    change: "+12.4%",
                    color: .green
                )
                
                StatCard(
                    title: "Win Rate",
                    value: "73.2%",
                    change: "Last 30 days",
                    color: .blue
                )
                
                StatCard(
                    title: "Total Trades",
                    value: "1,245",
                    change: "All time",
                    color: .purple
                )
                
                StatCard(
                    title: "Risk Score",
                    value: "Medium",
                    change: "Balanced",
                    color: .orange
                )
            }
        }
    }
    
    private var settingsOptionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Settings")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            VStack(spacing: 12) {
                SettingsRow(
                    icon: "bell.fill",
                    title: "Notifications",
                    subtitle: "Trading alerts and updates"
                )
                
                SettingsRow(
                    icon: "shield.fill",
                    title: "Security",
                    subtitle: "Password and authentication"
                )
                
                SettingsRow(
                    icon: "chart.bar.fill",
                    title: "Trading Preferences",
                    subtitle: "Risk settings and strategies"
                )
                
                SettingsRow(
                    icon: "questionmark.circle.fill",
                    title: "Help & Support",
                    subtitle: "FAQs and customer support"
                )
                
                SettingsRow(
                    icon: "info.circle.fill",
                    title: "About",
                    subtitle: "Version and legal information"
                )
            }
        }
    }
    
    private var signOutSection: some View {
        Button(action: {
            showingSignOut = true
        }) {
            HStack {
                Image(systemName: "arrow.right.square.fill")
                    .font(.title3)
                    .foregroundColor(.red)
                
                Text("Sign Out")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.red)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.red.opacity(0.3), lineWidth: 1)
            )
        }
        .alert("Sign Out", isPresented: $showingSignOut) {
            Button("Cancel", role: .cancel) { }
            Button("Sign Out", role: .destructive) {
                authManager.signOut()
            }
        } message: {
            Text("Are you sure you want to sign out?")
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let change: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text(change)
                .font(.caption)
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let subtitle: String
    
    var body: some View {
        Button(action: {
            // Navigate to settings
        }) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(DesignSystem.primaryGold)
                    .frame(width: 24)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.medium)
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
            .background(.ultraThinMaterial)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthenticationManager.shared)
}