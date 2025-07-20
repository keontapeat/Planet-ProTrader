//
//  FamilyModeOnboardingView.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 1/27/25.
//  PEAT Family Mode™ Onboarding Experience
//

import SwiftUI
import AVFoundation

struct FamilyModeOnboardingView: View {
    // MARK: - Properties
    let familyMemberType: FamilyModeModels.FamilyMemberType
    @Binding var isOnboardingComplete: Bool
    
    // MARK: - State
    @State private var currentStep = 0
    @State private var showingMemberSelection = false
    @State private var animateContent = false
    @State private var showingFundingFlow = false
    @State private var voiceoverEnabled = false
    @State private var synthesizer = AVSpeechSynthesizer()
    
    // MARK: - Computed Properties
    private var onboardingSteps: [FamilyModeModels.OnboardingStep] {
        familyMemberType.onboardingSteps
    }
    
    private var currentStepData: FamilyModeModels.OnboardingStep {
        onboardingSteps.indices.contains(currentStep) ? onboardingSteps[currentStep] : onboardingSteps[0]
    }
    
    private var isLastStep: Bool {
        currentStep >= onboardingSteps.count - 1
    }
    
    var body: some View {
        ZStack {
            // Animated Background
            FamilyModeBackground(memberType: familyMemberType, isAnimating: animateContent)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                headerSection
                
                // Main Content
                ScrollView {
                    VStack(spacing: 30) {
                        // Step Animation/Visual
                        stepAnimationView
                        
                        // Content Section
                        contentSection
                        
                        // Progress Section
                        progressSection
                        
                        // Action Buttons
                        actionButtonsSection
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
        .onAppear {
            startAnimations()
            if voiceoverEnabled {
                speakCurrentStep()
            }
        }
        .onChange(of: currentStep) { _, _ in
            if voiceoverEnabled {
                speakCurrentStep()
            }
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                animateContent = true
            }
        }
        .sheet(isPresented: $showingFundingFlow) {
            FundingFlowView(memberType: familyMemberType) {
                completeOnboarding()
            }
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        HStack {
            Button(action: {
                if currentStep > 0 {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                        currentStep -= 1
                    }
                } else {
                    showingMemberSelection = true
                }
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                    Text(currentStep == 0 ? "Change" : "Back")
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundColor(familyMemberType.primaryColor)
            }
            
            Spacer()
            
            VStack(spacing: 4) {
                Text(familyMemberType.displayName)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.primary)
                
                Text("Step \(currentStep + 1) of \(onboardingSteps.count)")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button(action: {
                voiceoverEnabled.toggle()
                if voiceoverEnabled {
                    speakCurrentStep()
                } else {
                    synthesizer.stopSpeaking(at: .immediate)
                }
            }) {
                Image(systemName: voiceoverEnabled ? "speaker.wave.3.fill" : "speaker.slash")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(familyMemberType.primaryColor)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 20)
    }
    
    // MARK: - Step Animation View
    private var stepAnimationView: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            familyMemberType.primaryColor.opacity(0.3),
                            familyMemberType.primaryColor.opacity(0.1),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 20,
                        endRadius: 100
                    )
                )
                .frame(width: 200, height: 200)
                .scaleEffect(animateContent ? 1.0 : 0.8)
                .opacity(animateContent ? 1.0 : 0.7)
            
            ZStack {
                Circle()
                    .fill(familyMemberType.primaryColor.opacity(0.2))
                    .frame(width: 120, height: 120)
                    .scaleEffect(animateContent ? 1.1 : 1.0)
                
                Text(familyMemberType.emoji)
                    .font(.system(size: 48))
                    .scaleEffect(animateContent ? 1.0 : 0.9)
                    .rotationEffect(.degrees(animateContent ? 0 : -10))
            }
            
            // Step-specific icons
            if currentStep > 0 {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        getStepIcon()
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(familyMemberType.primaryColor)
                            .background(
                                Circle()
                                    .fill(.ultraThinMaterial)
                                    .frame(width: 40, height: 40)
                            )
                            .offset(x: 20, y: -20)
                            .scaleEffect(animateContent ? 1.0 : 0.5)
                            .opacity(animateContent ? 1.0 : 0.0)
                    }
                }
                .frame(width: 120, height: 120)
            }
        }
        .animation(.spring(response: 0.8, dampingFraction: 0.7), value: animateContent)
    }
    
    // MARK: - Content Section
    private var contentSection: some View {
        VStack(spacing: 20) {
            Text(currentStepData.title)
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .scaleEffect(animateContent ? 1.0 : 0.9)
                .opacity(animateContent ? 1.0 : 0.0)
            
            Text(currentStepData.content)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .lineSpacing(6)
                .padding(.horizontal, 10)
                .scaleEffect(animateContent ? 1.0 : 0.95)
                .opacity(animateContent ? 1.0 : 0.0)
            
            // Special content for specific steps
            if currentStep == 1 {
                botExplanationCards
            } else if currentStep == 2 {
                moneyFlowVisualization
            } else if currentStep == 3 {
                teachingVisualization
            } else if currentStep == 4 {
                passiveIncomeVisualization
            }
        }
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2), value: animateContent)
    }
    
    // MARK: - Progress Section
    private var progressSection: some View {
        VStack(spacing: 16) {
            HStack(spacing: 8) {
                ForEach(0..<onboardingSteps.count, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 4)
                        .fill(index <= currentStep ? familyMemberType.primaryColor : Color.gray.opacity(0.3))
                        .frame(width: index == currentStep ? 40 : 20, height: 6)
                        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: currentStep)
                }
            }
            
            Text("\(Int((Double(currentStep + 1) / Double(onboardingSteps.count)) * 100))% Complete")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(familyMemberType.primaryColor)
        }
        .padding(.vertical, 10)
    }
    
    // MARK: - Action Buttons Section
    private var actionButtonsSection: some View {
        VStack(spacing: 16) {
            Button(action: {
                handlePrimaryAction()
            }) {
                HStack {
                    if isLastStep {
                        Image(systemName: "dollarsign.circle.fill")
                            .font(.system(size: 18, weight: .bold))
                    }
                    Text(currentStepData.actionButton)
                        .font(.system(size: 18, weight: .bold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                    LinearGradient(
                        colors: [familyMemberType.primaryColor, familyMemberType.primaryColor.opacity(0.8)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: familyMemberType.primaryColor.opacity(0.3), radius: 8, x: 0, y: 4)
            }
            .scaleEffect(animateContent ? 1.0 : 0.95)
            .opacity(animateContent ? 1.0 : 0.0)
            
            if currentStep > 0 {
                Button(action: {
                    // Skip to funding or complete
                    if currentStep >= 3 {
                        showingFundingFlow = true
                    } else {
                        currentStep = onboardingSteps.count - 1
                    }
                }) {
                    Text("I Know This Already")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(familyMemberType.primaryColor)
                }
                .opacity(animateContent ? 0.8 : 0.0)
            }
        }
        .padding(.horizontal, 20)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3), value: animateContent)
    }
    
    // MARK: - Step-Specific Content
    
    private var botExplanationCards: some View {
        VStack(spacing: 12) {
            ForEach(["Learn", "Analyze", "Trade"], id: \.self) { feature in
                HStack {
                    Circle()
                        .fill(familyMemberType.primaryColor)
                        .frame(width: 30, height: 30)
                        .overlay(
                            Text(feature.prefix(1))
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.white)
                        )
                    
                    Text("Bots \(feature.lowercased()) for you 24/7")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                }
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding(.top, 20)
    }
    
    private var moneyFlowVisualization: some View {
        HStack(spacing: 20) {
            VStack(spacing: 8) {
                Circle()
                    .fill(Color.orange)
                    .frame(width: 60, height: 60)
                    .overlay(
                        Text("🤖")
                            .font(.system(size: 24))
                    )
                Text("Bot Trades")
                    .font(.caption)
                    .fontWeight(.semibold)
            }
            
            Image(systemName: "arrow.right")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(familyMemberType.primaryColor)
            
            VStack(spacing: 8) {
                Circle()
                    .fill(Color.green)
                    .frame(width: 60, height: 60)
                    .overlay(
                        Text("💰")
                            .font(.system(size: 24))
                    )
                Text("You Profit")
                    .font(.caption)
                    .fontWeight(.semibold)
            }
        }
        .padding(.vertical, 20)
    }
    
    private var teachingVisualization: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                ForEach(["📚", "📸", "🎥"], id: \.self) { emoji in
                    VStack {
                        Text(emoji)
                            .font(.system(size: 32))
                        
                        Text(getTeachingLabel(for: emoji))
                            .font(.caption)
                            .fontWeight(.medium)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            
            Image(systemName: "arrow.down")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(familyMemberType.primaryColor)
            
            Text("🧠 Smarter Bots = More Profits")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(familyMemberType.primaryColor)
                .padding()
                .background(familyMemberType.primaryColor.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding(.vertical, 20)
    }
    
    private var passiveIncomeVisualization: some View {
        VStack(spacing: 16) {
            Text("Your Bot Working 24/7")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.primary)
            
            HStack(spacing: 8) {
                ForEach(["🌅", "☀️", "🌙"], id: \.self) { time in
                    VStack(spacing: 8) {
                        Text(time)
                            .font(.system(size: 24))
                        
                        Text("💹")
                            .font(.system(size: 16))
                        
                        Text(getTimeLabel(for: time))
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
        }
        .padding(.vertical, 20)
    }
    
    // MARK: - Helper Methods
    
    private func startAnimations() {
        withAnimation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.1)) {
            animateContent = true
        }
    }
    
    private func handlePrimaryAction() {
        if isLastStep {
            showingFundingFlow = true
        } else {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                currentStep += 1
                animateContent = false
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    animateContent = true
                }
            }
        }
    }
    
    private func completeOnboarding() {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            isOnboardingComplete = true
        }
    }
    
    private func getStepIcon() -> Image {
        switch currentStep {
        case 1: return Image(systemName: "brain.head.profile")
        case 2: return Image(systemName: "dollarsign.circle.fill")
        case 3: return Image(systemName: "book.fill")
        case 4: return Image(systemName: "moon.zzz.fill")
        case 5: return Image(systemName: "creditcard.fill")
        default: return Image(systemName: "star.fill")
        }
    }
    
    private func getTeachingLabel(for emoji: String) -> String {
        switch emoji {
        case "📚": return "Trading\nBooks"
        case "📸": return "Chart\nScreenshots"
        case "🎥": return "Learning\nVideos"
        default: return "Knowledge"
        }
    }
    
    private func getTimeLabel(for emoji: String) -> String {
        switch emoji {
        case "🌅": return "Morning"
        case "☀️": return "Day"
        case "🌙": return "Night"
        default: return "Always"
        }
    }
    
    private func speakCurrentStep() {
        let utterance = AVSpeechUtterance(text: currentStepData.content)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5
        utterance.pitchMultiplier = 1.0
        utterance.volume = 0.8
        
        synthesizer.speak(utterance)
    }
}

// MARK: - Family Mode Background

struct FamilyModeBackground: View {
    let memberType: FamilyModeModels.FamilyMemberType
    let isAnimating: Bool
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color.white,
                    memberType.primaryColor.opacity(0.1),
                    memberType.primaryColor.opacity(0.05),
                    Color.white
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            if isAnimating {
                ForEach(0..<8, id: \.self) { index in
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    memberType.primaryColor.opacity(0.1),
                                    Color.clear
                                ],
                                center: .center,
                                startRadius: 0,
                                endRadius: 80
                            )
                        )
                        .frame(width: 160, height: 160)
                        .offset(
                            x: CGFloat.random(in: -200...200),
                            y: CGFloat.random(in: -300...300)
                        )
                        .animation(
                            .linear(duration: Double.random(in: 15...25))
                                .repeatForever(autoreverses: false)
                                .delay(Double(index) * 2),
                            value: isAnimating
                        )
                }
            }
        }
    }
}

// MARK: - Preview

#Preview("Sister Mode") {
    FamilyModeOnboardingView(
        familyMemberType: .sister,
        isOnboardingComplete: .constant(false)
    )
}

#Preview("Granny Mode") {
    FamilyModeOnboardingView(
        familyMemberType: .granny,
        isOnboardingComplete: .constant(false)
    )
}

#Preview("Cousin Mode") {
    FamilyModeOnboardingView(
        familyMemberType: .cousin,
        isOnboardingComplete: .constant(false)
    )
}