//
//  CLAUDE_INTEGRATION_DASHBOARD.swift
//  Planet ProTrader  
//
//  Created by AI Assistant on 1/25/25.
//

import SwiftUI

/// Master dashboard for Claude AI integration and error management
struct ClaudeIntegrationDashboard: View {
    @StateObject private var errorAnalyzer = ErrorAnalyzer.shared
    @StateObject private var supabaseTracker = SupabaseErrorTracker.shared
    @State private var selectedTab: DashboardTab = .overview
    @State private var showingErrorAnalyzer = false
    
    enum DashboardTab: String, CaseIterable {
        case overview = "Overview"
        case errors = "Errors"
        case supabase = "Supabase"
        case github = "GitHub"
        
        var icon: String {
            switch self {
            case .overview: return "chart.line.uptrend.xyaxis"
            case .errors: return "exclamationmark.triangle"
            case .supabase: return "cloud"
            case .github: return "externaldrive.connected.to.line.below"
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Custom Tab Bar
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(DashboardTab.allCases, id: \.self) { tab in
                            TabButton(
                                tab: tab,
                                isSelected: selectedTab == tab,
                                action: { selectedTab = tab }
                            )
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 12)
                .background(.ultraThinMaterial)
                
                // Content
                ScrollView {
                    VStack(spacing: 20) {
                        switch selectedTab {
                        case .overview:
                            OverviewSection()
                        case .errors:
                            ErrorsSection()
                        case .supabase:
                            SupabaseSection()
                        case .github:
                            GitHubSection()
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("🤖 Claude Integration")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Quick Fix") {
                        showingErrorAnalyzer = true
                    }
                    .foregroundColor(DesignSystem.primaryGold)
                }
            }
        }
        .sheet(isPresented: $showingErrorAnalyzer) {
            ErrorAnalyzerView()
        }
    }
}

struct TabButton: View {
    let tab: ClaudeIntegrationDashboard.DashboardTab
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: tab.icon)
                    .font(.system(size: 16, weight: .medium))
                
                Text(tab.rawValue)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            .foregroundColor(isSelected ? .white : .primary)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(isSelected ? DesignSystem.primaryGold : Color.clear)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(isSelected ? Color.clear : Color.secondary.opacity(0.3), lineWidth: 1)
            )
        }
    }
}

// MARK: - Overview Section
struct OverviewSection: View {
    @StateObject private var errorAnalyzer = ErrorAnalyzer.shared
    @StateObject private var supabaseTracker = SupabaseErrorTracker.shared
    
    var body: some View {
        VStack(spacing: 16) {
            // Project Health Card
            ProjectHealthCard()
            
            // Quick Actions
            QuickActionsGrid()
            
            // Recent Activity
            RecentActivityCard()
            
            // Claude Tips
            ClaudeTipsCard()
        }
    }
}

struct ProjectHealthCard: View {
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "heart.fill")
                    .foregroundColor(.green)
                    .font(.title2)
                
                Text("Project Health")
                    .font(.headline)
                    .fontWeight(.bold)
                
                Spacer()
                
                Text("85%")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
            }
            
            HStack(spacing: 16) {
                HealthMetric(title: "Build Status", value: "✅ Passing", color: .green)
                HealthMetric(title: "Errors", value: "3 Minor", color: .orange)
                HealthMetric(title: "Performance", value: "Good", color: .blue)
            }
            
            ProgressView(value: 0.85)
                .tint(.green)
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(12)
    }
}

struct HealthMetric: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity)
    }
}

struct QuickActionsGrid: View {
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
            QuickActionButton(
                title: "Analyze Errors",
                icon: "magnifyingglass",
                color: .red,
                action: { /* Action */ }
            )
            
            QuickActionButton(
                title: "Sync Supabase", 
                icon: "cloud.fill",
                color: .blue,
                action: { /* Action */ }
            )
            
            QuickActionButton(
                title: "Build Project",
                icon: "hammer.fill", 
                color: .green,
                action: { /* Action */ }
            )
            
            QuickActionButton(
                title: "Push to GitHub",
                icon: "arrow.up.circle.fill",
                color: .purple,
                action: { /* Action */ }
            )
        }
    }
}

struct QuickActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(.ultraThinMaterial)
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct RecentActivityCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("📈 Recent Activity")
                .font(.headline)
                .fontWeight(.bold)
            
            VStack(spacing: 8) {
                ActivityRow(
                    icon: "checkmark.circle.fill",
                    text: "Fixed 3 compilation errors",
                    time: "2 minutes ago",
                    color: .green
                )
                
                ActivityRow(
                    icon: "cloud.upload.fill",
                    text: "Synced analysis to Supabase",
                    time: "5 minutes ago", 
                    color: .blue
                )
                
                ActivityRow(
                    icon: "hammer.fill",
                    text: "Successful build completed",
                    time: "10 minutes ago",
                    color: .orange
                )
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(12)
    }
}

struct ActivityRow: View {
    let icon: String
    let text: String  
    let time: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 16)
            
            Text(text)
                .font(.subheadline)
            
            Spacer()
            
            Text(time)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

struct ClaudeTipsCard: View {
    let tips = [
        "💡 Always read PROJECT_ARCHITECTURE.md first",
        "🔧 Fix critical errors before optimizations", 
        "📝 Use proper commit messages with your email",
        "⚡ Test compilation after each change",
        "🤖 Let Claude handle the heavy lifting!"
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("🎯 Claude Pro Tips")
                .font(.headline)
                .fontWeight(.bold)
            
            ForEach(tips, id: \.self) { tip in
                Text(tip)
                    .font(.caption)
                    .padding(.leading, 8)
            }
        }
        .padding()
        .background(DesignSystem.primaryGold.opacity(0.1))
        .cornerRadius(12)
    }
}

// MARK: - Errors Section
struct ErrorsSection: View {
    var body: some View {
        ErrorAnalyzerView()
    }
}

// MARK: - Supabase Section  
struct SupabaseSection: View {
    var body: some View {
        SupabaseIntegrationView()
    }
}

// MARK: - GitHub Section
struct GitHubSection: View {
    var body: some View {
        VStack(spacing: 16) {
            GitHubStatusCard()
            GitHubActionsCard()
            GitHubSetupInstructions()
        }
    }
}

struct GitHubStatusCard: View {
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "externaldrive.connected.to.line.below")
                    .foregroundColor(.purple)
                    .font(.title2)
                
                VStack(alignment: .leading) {
                    Text("GitHub Repository")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text("Not connected")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button("Setup") {
                    // GitHub setup action
                }
                .buttonStyle(.borderedProminent)
                .tint(.purple)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(12)
    }
}

struct GitHubActionsCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("🚀 Quick GitHub Actions")
                .font(.headline)
                .fontWeight(.bold)
            
            VStack(spacing: 8) {
                GitHubActionButton(title: "Create Repository", icon: "plus.circle.fill")
                GitHubActionButton(title: "Push Current Changes", icon: "arrow.up.circle.fill")
                GitHubActionButton(title: "Create Branch", icon: "arrow.branch")
                GitHubActionButton(title: "View Commits", icon: "clock.fill")
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(12)
    }
}

struct GitHubActionButton: View {
    let title: String
    let icon: String
    
    var body: some View {
        Button(action: {}) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.purple)
                
                Text(title)
                    .font(.subheadline)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct GitHubSetupInstructions: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("📋 GitHub Setup Instructions")
                .font(.headline)
                .fontWeight(.bold)
            
            VStack(alignment: .leading, spacing: 8) {
                InstructionStep(number: 1, text: "Create new repository on GitHub")
                InstructionStep(number: 2, text: "Copy the repository URL")
                InstructionStep(number: 3, text: "Run: git remote add origin [URL]")
                InstructionStep(number: 4, text: "Push: git push -u origin main")
            }
            
            Text("💡 Your email keontapeat@gmail.com is already in commit history!")
                .font(.caption)
                .foregroundColor(.green)
                .padding(.top, 8)
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(12)
    }
}

struct InstructionStep: View {
    let number: Int
    let text: String
    
    var body: some View {
        HStack {
            Text("\(number)")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(width: 20, height: 20)
                .background(DesignSystem.primaryGold)
                .clipShape(Circle())
            
            Text(text)
                .font(.caption)
        }
    }
}

#Preview {
    ClaudeIntegrationDashboard()
}