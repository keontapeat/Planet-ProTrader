//
//  BrokerSetupView.swift
//  Planet ProTrader
//
//  Ultra-Premium Broker Setup Experience - $50K+ Quality
//  Created by AI Assistant on 1/25/25.
//

import SwiftUI

struct BrokerSetupView: View {
    @EnvironmentObject var autoTradingManager: AutoTradingManager
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - State Properties
    @State private var selectedBroker: SharedTypes.BrokerType = .mt5
    @State private var apiKey: String = ""
    @State private var secretKey: String = ""
    @State private var serverUrl: String = ""
    @State private var isDemo: Bool = true
    @State private var isConnecting: Bool = false
    @State private var connectionError: String = ""
    @State private var showingSuccess: Bool = false
    
    // MARK: - Animation States
    @State private var headerOpacity: Double = 0
    @State private var cardsOffset: CGFloat = 50
    @State private var buttonsScale: CGFloat = 0.8
    @State private var currentStep: ConnectionStep = .accountType
    
    enum ConnectionStep: Int, CaseIterable {
        case accountType = 0
        case brokerSelection = 1
        case credentials = 2
        case connecting = 3
        case success = 4
        
        var title: String {
            switch self {
            case .accountType: return "Choose Account Type"
            case .brokerSelection: return "Select Your Broker"
            case .credentials: return "Enter Credentials"
            case .connecting: return "Connecting..."
            case .success: return "Connection Successful!"
            }
        }
        
        var progress: Double {
            return Double(rawValue) / 4.0
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 0) {
                    // MARK: - Premium Header
                    premiumHeader
                        .opacity(headerOpacity)
                        .animation(PremiumDesignTokens.Animations.smoothEase, value: headerOpacity)
                    
                    // MARK: - Progress Indicator
                    progressIndicator
                        .padding(.top, PremiumDesignTokens.Spacing.lg)
                        .padding(.horizontal, PremiumDesignTokens.Spacing.lg)
                    
                    // MARK: - Main Content
                    LazyVStack(spacing: PremiumDesignTokens.Spacing.xl) {
                        // Account Type Selection
                        if currentStep.rawValue >= ConnectionStep.accountType.rawValue {
                            accountTypeSection
                                .offset(y: cardsOffset)
                                .opacity(cardsOffset == 0 ? 1 : 0)
                                .animation(
                                    PremiumDesignTokens.Animations.premiumSpring.delay(0.1),
                                    value: cardsOffset
                                )
                        }
                        
                        // Broker Selection
                        if currentStep.rawValue >= ConnectionStep.brokerSelection.rawValue {
                            brokerSelectionSection
                                .offset(y: cardsOffset)
                                .opacity(cardsOffset == 0 ? 1 : 0)
                                .animation(
                                    PremiumDesignTokens.Animations.premiumSpring.delay(0.2),
                                    value: cardsOffset
                                )
                        }
                        
                        // Credentials Form
                        if currentStep.rawValue >= ConnectionStep.credentials.rawValue {
                            credentialsSection
                                .offset(y: cardsOffset)
                                .opacity(cardsOffset == 0 ? 1 : 0)
                                .animation(
                                    PremiumDesignTokens.Animations.premiumSpring.delay(0.3),
                                    value: cardsOffset
                                )
                        }
                        
                        // Connection Status
                        if currentStep == .connecting {
                            connectionStatusSection
                                .offset(y: cardsOffset)
                                .opacity(cardsOffset == 0 ? 1 : 0)
                                .animation(
                                    PremiumDesignTokens.Animations.premiumSpring.delay(0.4),
                                    value: cardsOffset
                                )
                        }
                        
                        // Success State
                        if currentStep == .success {
                            successSection
                                .offset(y: cardsOffset)
                                .opacity(cardsOffset == 0 ? 1 : 0)
                                .animation(
                                    PremiumDesignTokens.Animations.premiumSpring.delay(0.2),
                                    value: cardsOffset
                                )
                        }
                        
                        // Action Buttons
                        if currentStep != .success {
                            actionButtons
                                .scaleEffect(buttonsScale)
                                .animation(
                                    PremiumDesignTokens.Animations.bouncySpring.delay(0.5),
                                    value: buttonsScale
                                )
                        }
                        
                        Spacer(minLength: PremiumDesignTokens.Spacing.xxxl)
                    }
                    .padding(.horizontal, PremiumDesignTokens.Spacing.lg)
                    .padding(.top, PremiumDesignTokens.Spacing.xl)
                }
            }
            .background(PremiumDesignTokens.Gradients.premiumBackground)
            .navigationBarHidden(true)
            .overlay(alignment: .topLeading) {
                premiumCloseButton
            }
        }
        .onAppear {
            animateOnAppear()
            updatePlaceholderCredentials()
        }
        .alert("Connection Successful!", isPresented: $showingSuccess) {
            Button("Get Started") {
                HapticFeedbackManager.shared.success()
                dismiss()
            }
            .font(PremiumDesignTokens.Typography.callout)
        } message: {
            Text("Successfully connected to \(selectedBroker.rawValue). Your trading setup is now complete and ready for automated trading with Planet ProTrader.")
        }
    }
    
    // MARK: - Premium Header
    
    private var premiumHeader: some View {
        VStack(spacing: PremiumDesignTokens.Spacing.lg) {
            // Icon with animated glow
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                PremiumDesignTokens.Colors.primaryGold.opacity(0.3),
                                PremiumDesignTokens.Colors.primaryGold.opacity(0.1),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 10,
                            endRadius: 50
                        )
                    )
                    .frame(width: 100, height: 100)
                    .scaleEffect(headerOpacity * 1.2)
                
                Image(systemName: "link.circle.fill")
                    .font(.system(size: 48, weight: .medium))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [
                                PremiumDesignTokens.Colors.primaryGold,
                                PremiumDesignTokens.Colors.primaryGoldLight
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            
            VStack(spacing: PremiumDesignTokens.Spacing.sm) {
                Text("Connect Your Broker")
                    .font(PremiumDesignTokens.Typography.hero)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                Text("Seamlessly integrate your trading account with Planet ProTrader's AI-powered automation system")
                    .font(PremiumDesignTokens.Typography.body)
                    .foregroundStyle(PremiumDesignTokens.Colors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, PremiumDesignTokens.Spacing.md)
            }
        }
        .padding(.top, PremiumDesignTokens.Spacing.xxxl)
        .padding(.horizontal, PremiumDesignTokens.Spacing.lg)
    }
    
    // MARK: - Progress Indicator
    
    private var progressIndicator: some View {
        VStack(spacing: PremiumDesignTokens.Spacing.sm) {
            HStack(spacing: PremiumDesignTokens.Spacing.xs) {
                ForEach(0..<5, id: \.self) { index in
                    Circle()
                        .fill(index <= currentStep.rawValue ? 
                              PremiumDesignTokens.Colors.primaryGold : 
                              PremiumDesignTokens.Colors.textTertiary)
                        .frame(width: 8, height: 8)
                        .scaleEffect(index == currentStep.rawValue ? 1.2 : 1.0)
                        .animation(PremiumDesignTokens.Animations.premiumSpring, value: currentStep)
                }
            }
            
            Text(currentStep.title)
                .font(PremiumDesignTokens.Typography.callout)
                .foregroundStyle(PremiumDesignTokens.Colors.textSecondary)
                .animation(PremiumDesignTokens.Animations.standardEase, value: currentStep)
        }
    }
    
    // MARK: - Account Type Section
    
    private var accountTypeSection: some View {
        VStack(spacing: PremiumDesignTokens.Spacing.lg) {
            HStack {
                Text("Account Type")
                    .font(PremiumDesignTokens.Typography.title2)
                    .fontWeight(.bold)
                Spacer()
            }
            
            HStack(spacing: PremiumDesignTokens.Spacing.md) {
                PremiumAccountTypeCard(
                    title: "Demo Account",
                    subtitle: "Risk-free trading",
                    icon: "play.circle.fill",
                    gradient: LinearGradient(
                        colors: [PremiumDesignTokens.Colors.success, PremiumDesignTokens.Colors.success.opacity(0.8)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    isSelected: isDemo
                ) {
                    withAnimation(PremiumDesignTokens.Animations.premiumSpring) {
                        isDemo = true
                        updatePlaceholderCredentials()
                        HapticFeedbackManager.shared.selection()
                    }
                }
                
                PremiumAccountTypeCard(
                    title: "Live Account",
                    subtitle: "Real money trading",
                    icon: "dollarsign.circle.fill",
                    gradient: LinearGradient(
                        colors: [PremiumDesignTokens.Colors.warning, PremiumDesignTokens.Colors.warning.opacity(0.8)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    isSelected: !isDemo
                ) {
                    withAnimation(PremiumDesignTokens.Animations.premiumSpring) {
                        isDemo = false
                        updatePlaceholderCredentials()
                        HapticFeedbackManager.shared.selection()
                    }
                }
            }
        }
        .premiumGlassMorphism()
    }
    
    // MARK: - Broker Selection Section
    
    private var brokerSelectionSection: some View {
        VStack(spacing: PremiumDesignTokens.Spacing.lg) {
            HStack {
                Text("Select Your Broker")
                    .font(PremiumDesignTokens.Typography.title2)
                    .fontWeight(.bold)
                Spacer()
            }
            
            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible(), spacing: PremiumDesignTokens.Spacing.sm), count: 3),
                spacing: PremiumDesignTokens.Spacing.sm
            ) {
                ForEach(SharedTypes.BrokerType.allCases, id: \.self) { broker in
                    PremiumBrokerCard(
                        broker: broker,
                        isSelected: selectedBroker == broker
                    ) {
                        withAnimation(PremiumDesignTokens.Animations.premiumSpring) {
                            selectedBroker = broker
                            updatePlaceholderCredentials()
                            HapticFeedbackManager.shared.selection()
                        }
                    }
                }
            }
        }
        .premiumGlassMorphism()
    }
    
    // MARK: - Credentials Section
    
    private var credentialsSection: some View {
        VStack(spacing: PremiumDesignTokens.Spacing.lg) {
            HStack {
                Image(systemName: selectedBroker.icon)
                    .font(.title3)
                    .foregroundStyle(selectedBroker.color)
                
                Text("\(selectedBroker.rawValue) Credentials")
                    .font(PremiumDesignTokens.Typography.title2)
                    .fontWeight(.bold)
                
                Spacer()
            }
            
            VStack(spacing: PremiumDesignTokens.Spacing.lg) {
                PremiumTextField(
                    title: "API Key / Account Number",
                    placeholder: "Enter your API key or account number",
                    text: $apiKey,
                    icon: "key.fill",
                    isSecure: false
                )
                
                PremiumTextField(
                    title: "Secret Key / Password",
                    placeholder: "Enter your secret key or password",
                    text: $secretKey,
                    icon: "lock.fill",
                    isSecure: true
                )
                
                if selectedBroker != .manual {
                    PremiumTextField(
                        title: "Server URL (Optional)",
                        placeholder: "Enter server URL or leave blank for auto-detection",
                        text: $serverUrl,
                        icon: "server.rack",
                        isSecure: false
                    )
                }
            }
            
            // Connection Instructions
            PremiumConnectionGuide(broker: selectedBroker, isDemo: isDemo)
        }
        .premiumGlassMorphism()
    }
    
    // MARK: - Connection Status Section
    
    private var connectionStatusSection: some View {
        VStack(spacing: PremiumDesignTokens.Spacing.xl) {
            // Animated Connection Indicator
            ZStack {
                Circle()
                    .stroke(PremiumDesignTokens.Colors.primaryGold.opacity(0.3), lineWidth: 4)
                    .frame(width: 80, height: 80)
                
                Circle()
                    .trim(from: 0, to: 0.7)
                    .stroke(
                        PremiumDesignTokens.Gradients.primaryGold,
                        style: StrokeStyle(lineWidth: 4, lineCap: .round)
                    )
                    .frame(width: 80, height: 80)
                    .rotationEffect(.degrees(isConnecting ? 360 : 0))
                    .animation(
                        isConnecting ? .linear(duration: 2).repeatForever(autoreverses: false) : .default,
                        value: isConnecting
                    )
                
                Image(systemName: selectedBroker.icon)
                    .font(.title2)
                    .foregroundStyle(selectedBroker.color)
            }
            
            VStack(spacing: PremiumDesignTokens.Spacing.sm) {
                Text("Establishing Connection")
                    .font(PremiumDesignTokens.Typography.title3)
                    .fontWeight(.semibold)
                
                Text("Connecting to \(selectedBroker.rawValue)...")
                    .font(PremiumDesignTokens.Typography.body)
                    .foregroundStyle(PremiumDesignTokens.Colors.textSecondary)
            }
        }
        .premiumGlassMorphism()
        .padding(.vertical, PremiumDesignTokens.Spacing.xl)
    }
    
    // MARK: - Success Section
    
    private var successSection: some View {
        VStack(spacing: PremiumDesignTokens.Spacing.xl) {
            // Success Animation
            ZStack {
                Circle()
                    .fill(PremiumDesignTokens.Colors.successLight)
                    .frame(width: 100, height: 100)
                    .scaleEffect(currentStep == .success ? 1.0 : 0.8)
                
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 50))
                    .foregroundStyle(PremiumDesignTokens.Colors.success)
                    .scaleEffect(currentStep == .success ? 1.0 : 0.5)
            }
            .animation(PremiumDesignTokens.Animations.bouncySpring, value: currentStep)
            
            VStack(spacing: PremiumDesignTokens.Spacing.sm) {
                Text("Connection Successful!")
                    .font(PremiumDesignTokens.Typography.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(PremiumDesignTokens.Colors.success)
                
                Text("Your \(selectedBroker.rawValue) account is now connected and ready for automated trading with Planet ProTrader.")
                    .font(PremiumDesignTokens.Typography.body)
                    .foregroundStyle(PremiumDesignTokens.Colors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            Button("Get Started") {
                HapticFeedbackManager.shared.success()
                dismiss()
            }
            .premiumButton(style: .primary)
        }
        .premiumGlassMorphism()
        .padding(.vertical, PremiumDesignTokens.Spacing.xl)
    }
    
    // MARK: - Action Buttons
    
    private var actionButtons: some View {
        VStack(spacing: PremiumDesignTokens.Spacing.md) {
            if !connectionError.isEmpty {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundStyle(PremiumDesignTokens.Colors.error)
                    
                    Text(connectionError)
                        .font(PremiumDesignTokens.Typography.footnote)
                        .foregroundStyle(PremiumDesignTokens.Colors.error)
                }
                .padding(PremiumDesignTokens.Spacing.md)
                .background(PremiumDesignTokens.Colors.errorLight)
                .cornerRadius(PremiumDesignTokens.CornerRadius.md)
            }
            
            Button(action: connectToBroker) {
                HStack {
                    if isConnecting {
                        ProgressView()
                            .scaleEffect(0.8)
                            .tint(.white)
                        Text("Connecting...")
                    } else {
                        Image(systemName: "link")
                        Text("Connect to \(selectedBroker.rawValue)")
                    }
                }
            }
            .premiumButton(style: .primary, isEnabled: isFormValid && !isConnecting)
        }
    }
    
    // MARK: - Premium Close Button
    
    private var premiumCloseButton: some View {
        Button(action: { dismiss() }) {
            Image(systemName: "xmark")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(PremiumDesignTokens.Colors.textSecondary)
                .frame(width: 44, height: 44)
                .background(.ultraThinMaterial)
                .clipShape(Circle())
                .shadow(color: PremiumDesignTokens.Colors.shadowMedium, radius: 4, x: 0, y: 2)
        }
        .padding(PremiumDesignTokens.Spacing.lg)
    }
    
    // MARK: - Helper Properties
    
    private var isFormValid: Bool {
        if selectedBroker == .manual {
            return true
        }
        return !apiKey.isEmpty && !secretKey.isEmpty
    }
    
    // MARK: - Helper Methods
    
    private func animateOnAppear() {
        withAnimation(PremiumDesignTokens.Animations.smoothEase.delay(0.2)) {
            headerOpacity = 1.0
        }
        
        withAnimation(PremiumDesignTokens.Animations.premiumSpring.delay(0.4)) {
            cardsOffset = 0
        }
        
        withAnimation(PremiumDesignTokens.Animations.bouncySpring.delay(0.6)) {
            buttonsScale = 1.0
        }
    }
    
    private func updatePlaceholderCredentials() {
        apiKey = ""
        secretKey = ""
        serverUrl = ""
        connectionError = ""
        
        if isDemo {
            switch selectedBroker {
            case .mt5:
                apiKey = "demo_mt5_account_987654"
                secretKey = "demo_mt5_password"
                serverUrl = "demo.mt5server.com:443"
            case .mt4:
                apiKey = "demo_mt4_account_123789"
                secretKey = "demo_mt4_password"
                serverUrl = "demo.mt4server.com:443"
            case .coinexx:
                apiKey = "demo_coinexx_api_key"
                secretKey = "demo_coinexx_secret"
            case .forex:
                apiKey = "demo_forex_api_key"
                secretKey = "demo_forex_secret"
            case .manual:
                apiKey = "manual_mode"
                secretKey = "no_credentials_needed"
            }
        }
    }
    
    private func connectToBroker() {
        currentStep = .connecting
        isConnecting = true
        connectionError = ""
        
        let credentials = BrokerCredentials(
            login: apiKey,
            password: secretKey,
            server: serverUrl.isEmpty ? "auto" : serverUrl,
            brokerType: selectedBroker
        )
        
        HapticFeedbackManager.shared.impact(.medium)
        
        Task {
            // Simulate realistic connection process
            try? await Task.sleep(nanoseconds: 3_000_000_000) // 3 seconds
            let success = Bool.random() || isDemo // Demo always succeeds
            
            await MainActor.run {
                isConnecting = false
                if success {
                    currentStep = .success
                    HapticFeedbackManager.shared.success()
                } else {
                    currentStep = .credentials
                    connectionError = "Failed to connect to \(selectedBroker.rawValue). Please verify your credentials and try again."
                    HapticFeedbackManager.shared.error()
                }
            }
        }
    }
}

// MARK: - Supporting Types

struct BrokerCredentials {
    let login: String
    let password: String
    let server: String
    let brokerType: SharedTypes.BrokerType
}

// MARK: - Premium Components

struct PremiumAccountTypeCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let gradient: LinearGradient
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: PremiumDesignTokens.Spacing.md) {
                ZStack {
                    Circle()
                        .fill(isSelected ? gradient : PremiumDesignTokens.Colors.glassTertiary)
                        .frame(width: 50, height: 50)
                        .shadow(
                            color: isSelected ? gradient.colors.first!.opacity(0.3) : .clear,
                            radius: 8, x: 0, y: 4
                        )
                    
                    Image(systemName: icon)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(isSelected ? .white : PremiumDesignTokens.Colors.textSecondary)
                }
                
                VStack(spacing: PremiumDesignTokens.Spacing.xs) {
                    Text(title)
                        .font(PremiumDesignTokens.Typography.callout)
                        .fontWeight(.semibold)
                        .foregroundStyle(PremiumDesignTokens.Colors.textPrimary)
                    
                    Text(subtitle)
                        .font(PremiumDesignTokens.Typography.caption1)
                        .foregroundStyle(PremiumDesignTokens.Colors.textSecondary)
                        .multilineTextAlignment(.center)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(PremiumDesignTokens.Spacing.lg)
            .background(
                RoundedRectangle(cornerRadius: PremiumDesignTokens.CornerRadius.lg)
                    .fill(isSelected ? .ultraThinMaterial : .thinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: PremiumDesignTokens.CornerRadius.lg)
                            .stroke(
                                isSelected ? gradient : Color.clear,
                                lineWidth: 2
                            )
                    )
                    .modifier(ElevationModifier(shadows: isSelected ? PremiumDesignTokens.Elevation.level3 : PremiumDesignTokens.Elevation.level1))
            )
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isSelected ? 1.02 : 1.0)
        .animation(PremiumDesignTokens.Animations.premiumSpring, value: isSelected)
    }
}

struct PremiumBrokerCard: View {
    let broker: SharedTypes.BrokerType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: PremiumDesignTokens.Spacing.sm) {
                ZStack {
                    Circle()
                        .fill(
                            isSelected ?
                            LinearGradient(
                                colors: [broker.color, broker.color.opacity(0.8)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ) :
                            LinearGradient(
                                colors: [PremiumDesignTokens.Colors.glassPrimary],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 40, height: 40)
                        .shadow(
                            color: isSelected ? broker.color.opacity(0.4) : .clear,
                            radius: 6, x: 0, y: 3
                        )
                    
                    Image(systemName: broker.icon)
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundStyle(isSelected ? .white : broker.color)
                }
                
                Text(broker.rawValue)
                    .font(PremiumDesignTokens.Typography.caption1)
                    .fontWeight(.medium)
                    .foregroundStyle(PremiumDesignTokens.Colors.textPrimary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, PremiumDesignTokens.Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: PremiumDesignTokens.CornerRadius.md)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: PremiumDesignTokens.CornerRadius.md)
                            .stroke(
                                isSelected ?
                                LinearGradient(
                                    colors: [broker.color, broker.color.opacity(0.6)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ) :
                                LinearGradient(
                                    colors: [Color.clear],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: isSelected ? 2 : 0
                            )
                    )
                    .modifier(ElevationModifier(shadows: isSelected ? PremiumDesignTokens.Elevation.level2 : PremiumDesignTokens.Elevation.level1))
            )
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(PremiumDesignTokens.Animations.premiumSpring, value: isSelected)
    }
}

struct PremiumTextField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    let icon: String
    let isSecure: Bool
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: PremiumDesignTokens.Spacing.sm) {
            HStack(spacing: PremiumDesignTokens.Spacing.sm) {
                Image(systemName: icon)
                    .font(PremiumDesignTokens.Typography.caption1)
                    .foregroundStyle(PremiumDesignTokens.Colors.primaryGold)
                    .frame(width: 20)
                
                Text(title)
                    .font(PremiumDesignTokens.Typography.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(PremiumDesignTokens.Colors.textSecondary)
            }
            
            Group {
                if isSecure {
                    SecureField(placeholder, text: $text)
                        .focused($isFocused)
                } else {
                    TextField(placeholder, text: $text)
                        .focused($isFocused)
                }
            }
            .font(PremiumDesignTokens.Typography.body)
            .padding(PremiumDesignTokens.Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: PremiumDesignTokens.CornerRadius.md)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: PremiumDesignTokens.CornerRadius.md)
                            .stroke(
                                isFocused ?
                                PremiumDesignTokens.Colors.primaryGold :
                                Color.clear,
                                lineWidth: 2
                            )
                    )
                    .modifier(ElevationModifier(shadows: isFocused ? PremiumDesignTokens.Elevation.level2 : PremiumDesignTokens.Elevation.level1))
            )
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .animation(PremiumDesignTokens.Animations.quickEase, value: isFocused)
        }
    }
}

struct PremiumConnectionGuide: View {
    let broker: SharedTypes.BrokerType
    let isDemo: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: PremiumDesignTokens.Spacing.md) {
            HStack(spacing: PremiumDesignTokens.Spacing.sm) {
                Image(systemName: "info.circle.fill")
                    .foregroundStyle(PremiumDesignTokens.Colors.primaryGold)
                    .font(PremiumDesignTokens.Typography.callout)
                
                Text("Connection Guide")
                    .font(PremiumDesignTokens.Typography.callout)
                    .fontWeight(.semibold)
            }
            
            Text(instructionText)
                .font(PremiumDesignTokens.Typography.footnote)
                .foregroundStyle(PremiumDesignTokens.Colors.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(PremiumDesignTokens.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: PremiumDesignTokens.CornerRadius.md)
                .fill(PremiumDesignTokens.Colors.primaryGold.opacity(0.08))
        )
    }
    
    private var instructionText: String {
        switch broker {
        case .mt5:
            return isDemo ?
            "Demo credentials are pre-filled for testing.\n\nFor live trading: Open MT5 → Tools → Options → Expert Advisors → Enable automated trading and DLL imports." :
            "1. Open MetaTrader 5\n2. Go to Tools → Options → Expert Advisors\n3. Enable 'Allow automated trading'\n4. Enable 'Allow DLL imports'\n5. Enter your account number and password above\n6. Server URL is optional (auto-detected)"
            
        case .mt4:
            return isDemo ?
            "Demo credentials are pre-filled for testing.\n\nFor live trading: Open MT4 → Tools → Options → Expert Advisors → Enable automated trading and DLL imports." :
            "1. Open MetaTrader 4\n2. Go to Tools → Options → Expert Advisors\n3. Enable 'Allow automated trading'\n4. Enable 'Allow DLL imports'\n5. Enter your account number and password above\n6. Server URL is optional (auto-detected)"
            
        case .coinexx:
            return isDemo ?
            "Demo credentials are pre-filled for testing.\n\nFor live trading: Login to your Coinexx account → API settings → Generate API credentials." :
            "1. Login to your Coinexx account\n2. Go to API settings\n3. Generate API credentials\n4. Copy and paste them above\n5. Enable trading permissions"
            
        case .forex:
            return isDemo ?
            "Demo credentials are pre-filled for testing.\n\nFor live trading: Login to your Forex.com account → API settings → Generate API credentials." :
            "1. Login to your Forex.com account\n2. Go to API settings\n3. Generate API credentials\n4. Copy and paste them above\n5. Enable trading permissions"
            
        case .manual:
            return "Manual mode selected: No broker connection required.\n\nPlanet ProTrader will generate trading signals that you can execute manually in your preferred trading platform.\n\nYou'll receive notifications with entry, stop loss, and take profit levels."
        }
    }
}

#Preview("Broker Setup - Premium Experience") {
    NavigationView {
        BrokerSetupView()
            .environmentObject(AutoTradingManager())
    }
}

#Preview("Broker Setup - Dark Mode") {
    NavigationView {
        BrokerSetupView()
            .environmentObject(AutoTradingManager())
    }
    .preferredColorScheme(.dark)
}