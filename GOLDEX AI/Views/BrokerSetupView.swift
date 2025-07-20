//
//  BrokerSetupView.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 7/13/25.
//

import SwiftUI

struct BrokerSetupView: View {
    @StateObject private var manager = AutoTradingManager()
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedBroker: SharedTypes.BrokerType = .tradeLocker
    @State private var apiKey: String = ""
    @State private var secretKey: String = ""
    @State private var serverUrl: String = ""
    @State private var isDemo: Bool = true
    @State private var isConnecting: Bool = false
    @State private var connectionError: String = ""
    @State private var showingSuccess: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 16) {
                        Image(systemName: "link.circle.fill")
                            .font(.system(size: 48))
                            .foregroundStyle(.blue)
                        
                        Text("Connect Your Broker")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("Connect your MT5, MT4, or TradeLocker account to enable automated trading with GOLDEX AI")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .padding(.top)
                    
                    // Account Type Toggle
                    VStack(spacing: 16) {
                        HStack {
                            Text("Account Type")
                                .font(.headline)
                                .fontWeight(.semibold)
                            Spacer()
                        }
                        
                        HStack(spacing: 12) {
                            AccountTypeButton(
                                title: "Demo",
                                subtitle: "Risk-free testing",
                                icon: "play.circle.fill",
                                color: .green,
                                isSelected: isDemo
                            ) {
                                isDemo = true
                                updatePlaceholderCredentials()
                            }
                            
                            AccountTypeButton(
                                title: "Live",
                                subtitle: "Real trading",
                                icon: "dollarsign.circle.fill",
                                color: .orange,
                                isSelected: !isDemo
                            ) {
                                isDemo = false
                                updatePlaceholderCredentials()
                            }
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                    
                    // Broker Selection
                    VStack(spacing: 16) {
                        HStack {
                            Text("Select Your Broker")
                                .font(.headline)
                                .fontWeight(.semibold)
                            Spacer()
                        }
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible()),
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 12) {
                            ForEach(SharedTypes.BrokerType.allCases, id: \.self) { broker in
                                BrokerSelectionCard(
                                    broker: broker,
                                    isSelected: selectedBroker == broker
                                ) {
                                    selectedBroker = broker
                                    updatePlaceholderCredentials()
                                }
                            }
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                    
                    // Credentials Form
                    VStack(spacing: 16) {
                        HStack {
                            Image(systemName: selectedBroker.icon)
                                .foregroundStyle(.blue)
                            Text("\(selectedBroker.rawValue) Credentials")
                                .font(.headline)
                                .fontWeight(.semibold)
                            Spacer()
                        }
                        
                        VStack(spacing: 16) {
                            CredentialField(
                                title: "API Key",
                                placeholder: "Enter your API key",
                                text: $apiKey,
                                isSecure: false
                            )
                            
                            CredentialField(
                                title: "Secret Key / Password",
                                placeholder: "Enter your secret key or password",
                                text: $secretKey,
                                isSecure: true
                            )
                            
                            if selectedBroker != .tradeLocker && selectedBroker != .manual {
                                CredentialField(
                                    title: "Server URL",
                                    placeholder: "Enter server URL (optional for MT4/MT5)",
                                    text: $serverUrl,
                                    isSecure: false
                                )
                            }
                        }
                        
                        // Connection Instructions
                        ConnectionInstructionsView(broker: selectedBroker, isDemo: isDemo)
                    }
                    .padding()
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                    
                    // Error Display
                    if !connectionError.isEmpty {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundStyle(.red)
                            Text(connectionError)
                                .font(.caption)
                                .foregroundStyle(.red)
                        }
                        .padding()
                        .background(.red.opacity(0.1), in: RoundedRectangle(cornerRadius: 8))
                    }
                    
                    // Connect Button
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
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isFormValid ? .blue : .gray.opacity(0.3))
                        .foregroundStyle(.white)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .disabled(!isFormValid || isConnecting)
                    
                    Spacer(minLength: 100)
                }
                .padding()
            }
            .navigationTitle("Broker Setup")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
        .alert("Connection Successful!", isPresented: $showingSuccess) {
            Button("Done") {
                dismiss()
            }
        } message: {
            Text("Successfully connected to \(selectedBroker.rawValue). You can now enable auto trading in the main screen.")
        }
        .onAppear {
            updatePlaceholderCredentials()
        }
    }
    
    private var isFormValid: Bool {
        if selectedBroker == .manual {
            return true
        }
        return !apiKey.isEmpty && !secretKey.isEmpty
    }
    
    private func updatePlaceholderCredentials() {
        // Clear existing credentials when switching brokers
        apiKey = ""
        secretKey = ""
        serverUrl = ""
        connectionError = ""
        
        // Set demo credentials for testing
        if isDemo {
            switch selectedBroker {
            case .tradeLocker:
                apiKey = "demo_tl_api_key_123456"
                secretKey = "demo_tl_secret_789012"
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
            case .hankotrade:
                apiKey = "demo_hankotrade_api_key"
                secretKey = "demo_hankotrade_secret"
            case .xtb:
                apiKey = "demo_xtb_api_key"
                secretKey = "demo_xtb_secret"
            case .manual:
                apiKey = "manual_mode"
                secretKey = "no_credentials_needed"
            case .forex:
                apiKey = "demo_forex_api_key"
                secretKey = "demo_forex_secret"
            }
        }
    }
    
    private func connectToBroker() {
        isConnecting = true
        connectionError = ""
        
        let credentials = SharedTypes.BrokerCredentials(
            login: apiKey,
            password: secretKey,
            server: serverUrl.isEmpty ? "auto" : serverUrl,
            brokerType: selectedBroker
        )
        
        Task {
            // Simulate broker connection
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            let success = Bool.random() // Simulate connection result
            
            await MainActor.run {
                isConnecting = false
                if success {
                    showingSuccess = true
                } else {
                    connectionError = "Failed to connect to \(selectedBroker.rawValue). Please check your credentials and try again."
                }
            }
        }
    }
}

// MARK: - Supporting Views

struct AccountTypeButton: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(isSelected ? .white : color)
                
                VStack(spacing: 2) {
                    Text(title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundStyle(isSelected ? .white : .primary)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(isSelected ? .white.opacity(0.8) : .secondary)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? AnyShapeStyle(color.gradient) : AnyShapeStyle(Color.clear))
                    .stroke(isSelected ? .clear : color.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct BrokerSelectionCard: View {
    let broker: SharedTypes.BrokerType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: broker.icon)
                    .font(.title2)
                    .foregroundStyle(isSelected ? .white : .blue)
                
                Text(broker.rawValue)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(isSelected ? .white : .primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(isSelected ? AnyShapeStyle(.blue.gradient) : AnyShapeStyle(Color.clear))
                    .stroke(isSelected ? .clear : .blue.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct CredentialField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    let isSecure: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(.secondary)
            
            Group {
                if isSecure {
                    SecureField(placeholder, text: $text)
                } else {
                    TextField(placeholder, text: $text)
                }
            }
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .autocapitalization(.none)
            .disableAutocorrection(true)
        }
    }
}

struct ConnectionInstructionsView: View {
    let broker: SharedTypes.BrokerType
    let isDemo: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "info.circle.fill")
                    .foregroundStyle(.blue)
                Text("Connection Guide")
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            
            Text(instructionText)
                .font(.caption)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding()
        .background(.blue.opacity(0.1), in: RoundedRectangle(cornerRadius: 8))
    }
    
    private var instructionText: String {
        switch broker {
        case .tradeLocker:
            return isDemo ? 
            "Demo credentials are pre-filled for testing.\n\nFor live trading: Login to your TradeLocker account → Settings → API Management → Generate new API key and secret." :
            "1. Login to your TradeLocker account\n2. Go to Settings → API Management\n3. Generate new API key and secret\n4. Copy and paste them above\n5. Enable auto trading permissions"
            
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
            
        case .hankotrade:
            return isDemo ?
            "Demo credentials are pre-filled for testing.\n\nFor live trading: Contact Hankotrade support for API access." :
            "1. Contact Hankotrade support\n2. Request API access\n3. Follow their setup instructions\n4. Enter credentials above"
            
        case .xtb:
            return isDemo ?
            "Demo credentials are pre-filled for testing.\n\nFor live trading: Login to your XTB account → API settings → Generate API credentials." :
            "1. Login to your XTB account\n2. Go to API settings\n3. Generate API credentials\n4. Copy and paste them above\n5. Enable trading permissions"
            
        case .manual:
            return "Manual mode selected: No broker connection required.\n\nGOLDEX AI will generate trading signals that you can execute manually in your preferred trading platform.\n\nYou'll receive notifications with entry, stop loss, and take profit levels."
            
        case .forex:
            return isDemo ?
            "Demo credentials are pre-filled for testing.\n\nFor live trading: Login to your Forex.com account → API settings → Generate API credentials." :
            "1. Login to your Forex.com account\n2. Go to API settings\n3. Generate API credentials\n4. Copy and paste them above\n5. Enable trading permissions"
        }
    }
}

#Preview("Broker Setup - Live Mode") {
    struct BrokerSetupPreview: View {
        var body: some View {
            BrokerSetupView()
        }
    }
    return BrokerSetupPreview()
}

#Preview("Broker Setup - Demo Mode") {
    struct BrokerSetupDemoPreview: View {
        var body: some View {
            BrokerSetupView()
        }
    }
    return BrokerSetupDemoPreview()
}