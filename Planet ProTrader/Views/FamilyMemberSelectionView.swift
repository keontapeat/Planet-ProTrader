//
//  FamilyMemberSelectionView.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 1/25/25.
//

import SwiftUI

struct FamilyMemberSelectionView: View {
    @StateObject private var familyManager = FamilyModeManager()
    @State private var selectedMember: FamilyMemberType? = nil
    @State private var showingMemberDetail = false
    @State private var animatingCards = false
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [
                        DesignSystem.primaryGold.opacity(0.1),
                        Color.black.opacity(0.05)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header
                        headerSection
                        
                        // Family member grid
                        familyMemberGrid
                        
                        // Selection button
                        if let selectedMember {
                            selectionButton(for: selectedMember)
                        }
                        
                        // Progress indicator
                        progressSection
                    }
                    .padding()
                }
            }
            .navigationTitle("Choose Your Family")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                    .foregroundColor(DesignSystem.primaryGold)
                }
            }
        }
        .sheet(isPresented: $showingMemberDetail) {
            if let member = selectedMember {
                FamilyMemberDetailView(
                    memberType: member,
                    familyManager: familyManager
                )
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8)) {
                animatingCards = true
            }
        }
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            Text("👨‍👩‍👧‍👦")
                .font(.system(size: 60))
                .scaleEffect(animatingCards ? 1.0 : 0.5)
                .animation(.bouncy(duration: 1.0), value: animatingCards)
            
            Text("Choose Your Trading Family Member")
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .foregroundColor(.primary)
            
            Text("Each family member has a unique personality and trading style that will guide your journey!")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 2)
        )
    }
    
    // MARK: - Family Member Grid
    
    private var familyMemberGrid: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
            ForEach(Array(FamilyMemberType.allCases.enumerated()), id: \.element) { index, memberType in
                familyMemberCard(memberType, index: index)
            }
        }
    }
    
    private func familyMemberCard(_ memberType: FamilyMemberType, index: Int) -> some View {
        let isUnlocked = familyManager.unlockedMembers.contains(memberType)
        let isSelected = selectedMember == memberType
        let member = familyManager.getFamilyMember(memberType)
        
        Button(action: {
            if isUnlocked {
                selectedMember = memberType
                HapticFeedbackManager.shared.impact(.medium)
            } else {
                HapticFeedbackManager.shared.notification(.warning)
            }
        }) {
            VStack(spacing: 12) {
                // Emoji and lock overlay
                ZStack {
                    Text(memberType.emoji)
                        .font(.system(size: 40))
                        .scaleEffect(isSelected ? 1.1 : 1.0)
                        .animation(.bouncy(duration: 0.3), value: isSelected)
                    
                    if !isUnlocked {
                        // Lock overlay
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.black.opacity(0.6))
                            .frame(width: 50, height: 50)
                            .overlay(
                                Image(systemName: "lock.fill")
                                    .foregroundColor(.white)
                                    .font(.title3)
                            )
                    }
                }
                
                VStack(spacing: 4) {
                    Text(memberType.displayName)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(isUnlocked ? .primary : .secondary)
                    
                    if let member = member {
                        Text(member.nickname)
                            .font(.caption)
                            .foregroundColor(memberType.primaryColor)
                            .fontWeight(.medium)
                        
                        // Risk tolerance indicator
                        HStack(spacing: 4) {
                            Circle()
                                .fill(member.riskTolerance.color)
                                .frame(width: 6, height: 6)
                            
                            Text(member.riskTolerance.rawValue)
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                // Unlock requirement or bond level
                if !isUnlocked {
                    if let requirement = member?.unlockRequirement {
                        Text("🔒 \(requirement)")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 4)
                    }
                } else {
                    // Bond level
                    let bondLevel = familyManager.familyBonds[memberType] ?? 0.0
                    HStack(spacing: 4) {
                        Text("Bond:")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        
                        Text("\(Int(bondLevel))/100")
                            .font(.caption2)
                            .fontWeight(.medium)
                            .foregroundColor(memberType.primaryColor)
                    }
                }
                
                // Details button
                if isUnlocked {
                    Button("Details") {
                        selectedMember = memberType
                        showingMemberDetail = true
                        HapticFeedbackManager.shared.impact(.light)
                    }
                    .font(.caption)
                    .foregroundColor(memberType.primaryColor)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, minHeight: 180)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isUnlocked ? Color(.systemBackground) : Color(.systemGray6))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(
                                isSelected ? memberType.primaryColor : (isUnlocked ? Color.clear : Color(.systemGray4)),
                                lineWidth: isSelected ? 3 : 1
                            )
                    )
                    .shadow(
                        color: isSelected ? memberType.primaryColor.opacity(0.3) : .black.opacity(0.05),
                        radius: isSelected ? 8 : 4,
                        x: 0,
                        y: 2
                    )
            )
            .scaleEffect(isSelected ? 1.02 : (animatingCards ? 1.0 : 0.9))
            .animation(.bouncy(duration: 0.6).delay(Double(index) * 0.1), value: animatingCards)
            .animation(.bouncy(duration: 0.3), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(!isUnlocked)
    }
    
    // MARK: - Selection Button
    
    private func selectionButton(for memberType: FamilyMemberType) -> some View {
        VStack(spacing: 12) {
            Button(action: {
                familyManager.selectedFamilyMember = memberType
                HapticFeedbackManager.shared.impact(.heavy)
                
                withAnimation(.bouncy(duration: 0.5)) {
                    isPresented = false
                }
            }) {
                HStack {
                    Text(memberType.emoji)
                        .font(.title2)
                    
                    Text("Start Trading with \(memberType.displayName)")
                        .fontWeight(.bold)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                colors: [memberType.primaryColor, memberType.primaryColor.opacity(0.8)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                )
            }
            .buttonStyle(ScaleButtonStyle())
            
            if let member = familyManager.getFamilyMember(memberType) {
                Text(member.catchPhrase)
                    .font(.caption)
                    .italic()
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(color: memberType.primaryColor.opacity(0.1), radius: 10, x: 0, y: 4)
        )
    }
    
    // MARK: - Progress Section
    
    private var progressSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("🏆 Your Progress")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(DesignSystem.primaryGold)
            
            VStack(spacing: 8) {
                progressRow(
                    title: "Family Members Unlocked",
                    progress: Double(familyManager.unlockedMembers.count),
                    total: Double(FamilyMemberType.allCases.count),
                    color: .blue
                )
                
                progressRow(
                    title: "Average Bond Level",
                    progress: familyManager.familyBonds.values.reduce(0, +) / Double(familyManager.familyBonds.count),
                    total: 100.0,
                    color: .green
                )
                
                progressRow(
                    title: "Trading Streak",
                    progress: Double(familyManager.currentStreak),
                    total: 30.0,
                    color: DesignSystem.primaryGold
                )
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemGray6))
        )
    }
    
    private func progressRow(title: String, progress: Double, total: Double, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Spacer()
                
                Text("\(Int(progress))/\(Int(total))")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(color)
            }
            
            ProgressView(value: progress, total: total)
                .progressViewStyle(LinearProgressViewStyle(tint: color))
        }
    }
}

// MARK: - Family Member Detail View

struct FamilyMemberDetailView: View {
    let memberType: FamilyMemberType
    let familyManager: FamilyModeManager
    @Environment(\.dismiss) private var dismiss
    
    private var member: FamilyMemberProfile? {
        familyManager.getFamilyMember(memberType)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    if let member = member {
                        // Profile header
                        profileHeader(member)
                        
                        // Stats
                        statsSection(member)
                        
                        // Specialties
                        specialtiesSection(member)
                        
                        // Backstory
                        backstorySection(member)
                        
                        // Bond progress
                        bondSection(member)
                    }
                }
                .padding()
            }
            .navigationTitle(member?.name ?? "Family Member")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(memberType.primaryColor)
                }
            }
        }
    }
    
    private func profileHeader(_ member: FamilyMemberProfile) -> some View {
        VStack(spacing: 16) {
            Text(memberType.emoji)
                .font(.system(size: 80))
            
            VStack(spacing: 4) {
                Text(member.name)
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("\"\(member.nickname)\"")
                    .font(.headline)
                    .foregroundColor(memberType.primaryColor)
                
                Text(member.catchPhrase)
                    .font(.subheadline)
                    .italic()
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(memberType.primaryColor.opacity(0.1))
        )
    }
    
    private func statsSection(_ member: FamilyMemberProfile) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("📊 Trading Profile")
                .font(.headline)
                .fontWeight(.bold)
            
            VStack(spacing: 8) {
                statRow(title: "Experience", value: "\(member.tradingExperience.rawValue) (\(member.tradingExperience.years))")
                statRow(title: "Risk Tolerance", value: member.riskTolerance.rawValue)
                statRow(title: "Trading Style", value: member.tradingStyle)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemGray6))
        )
    }
    
    private func statRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
                .foregroundColor(memberType.primaryColor)
        }
    }
    
    private func specialtiesSection(_ member: FamilyMemberProfile) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("🎯 Specialties & Strategies")
                .font(.headline)
                .fontWeight(.bold)
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(member.specialties, id: \.self) { specialty in
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(memberType.primaryColor)
                            .font(.caption)
                        
                        Text(specialty)
                            .font(.subheadline)
                    }
                }
                
                Divider()
                    .padding(.vertical, 4)
                
                ForEach(member.favoriteStrategies, id: \.self) { strategy in
                    HStack {
                        Image(systemName: "chart.line.uptrend.xyaxis")
                            .foregroundColor(.blue)
                            .font(.caption)
                        
                        Text(strategy)
                            .font(.subheadline)
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemGray6))
        )
    }
    
    private func backstorySection(_ member: FamilyMemberProfile) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("📖 Background")
                .font(.headline)
                .fontWeight(.bold)
            
            Text(member.backstory)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineSpacing(4)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemGray6))
        )
    }
    
    private func bondSection(_ member: FamilyMemberProfile) -> some View {
        let bondLevel = familyManager.familyBonds[memberType] ?? 0.0
        
        return VStack(alignment: .leading, spacing: 12) {
            Text("💝 Family Bond")
                .font(.headline)
                .fontWeight(.bold)
            
            VStack(spacing: 8) {
                HStack {
                    Text("Bond Strength")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    Spacer()
                    
                    Text("\(Int(bondLevel))/100")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(memberType.primaryColor)
                }
                
                ProgressView(value: bondLevel, total: 100.0)
                    .progressViewStyle(LinearProgressViewStyle(tint: memberType.primaryColor))
                
                Text(bondDescription(for: bondLevel))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemGray6))
        )
    }
    
    private func bondDescription(for level: Double) -> String {
        switch level {
        case 0..<25:
            return "Getting to know each other 🌱"
        case 25..<50:
            return "Building trust 🤝"
        case 50..<75:
            return "Strong family bond 💪"
        case 75..<100:
            return "Unbreakable connection ❤️"
        default:
            return "Perfect family harmony! 🏆"
        }
    }
}

// MARK: - Scale Button Style

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.bouncy(duration: 0.2), value: configuration.isPressed)
    }
}

// MARK: - Preview

#Preview {
    FamilyMemberSelectionView(isPresented: .constant(true))
}