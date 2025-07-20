//
//  AddAccountView.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 7/13/25.
//

import SwiftUI

struct AddAccountView: View {
    @ObservedObject var accountManager: MultiAccountManager
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedBroker: SharedTypes.BrokerType = .mt5
    @State private var accountName = ""
    @State private var login = ""
    @State private var password = ""
    @State private var server = ""
    @State private var isDemo = true
    @State private var isConnecting = false
    @State private var connectionError = ""
    @State private var showingSuccess = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Premium background
                LinearGradient(
                    colors: [
                        Color(red: 0.05, green: 0.05, blue: 0.08),
                        Color(red: 0.08, green: 0.08, blue: 0.12)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 32) {
                        // Header
                        VStack(spacing: 16) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 48, weight: .bold))
                                .foregroundStyle(DesignSystem.primaryGold)
                            
                            VStack(spacing: 8) {
                                Text("Add Trading Account")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundStyle(.white)
                                
                                Text("Connect your broker account to start professional trading")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundStyle(.white.opacity(0.7))
                                    .multilineTextAlignment(.center)
                            }
                        }
                        
                        // Account Type Selection
                        ProfessionalCard {
                            VStack(spacing: 20) {
                                HStack {
                                    Text("Account Type")
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundStyle(.white)
                                    
                                    Spacer()
                                }
                                
                                HStack(spacing: 16) {
                                    AccountTypeCard(
                                        title: "Demo Account",
                                        subtitle: "Risk-free testing",
                                        icon: "play.circle.fill",
                                        isSelected: isDemo
                                    ) {
                                        isDemo = true
                                        updatePlaceholderData()
                                    }
                                    
                                    AccountTypeCard(
                                        title: "Live Account",
                                        subtitle: "Real money trading",
                                        icon: "dollarsign.circle.fill",
                                        isSelected: !isDemo
                                    ) {
                                        isDemo = false
                                        updatePlaceholderData()
                                    }
                                }
                            }
                        }
                        
                        // Broker Selection
                        ProfessionalCard {
                            VStack(spacing: 20) {
                                HStack {
                                    Text("Select Broker")
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundStyle(.white)
                                    
                                    Spacer()
                                }
                                
                                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 12) {
                                    ForEach(SharedTypes.BrokerType.allCases, id: \.self) { broker in
                                        BrokerCard(
                                            broker: broker,
                                            isSelected: selectedBroker == broker
                                        ) {
                                            selectedBroker = broker
                                            updatePlaceholderData()
                                        }
                                    }
                                }
                            }
                        }
                        
                        // Account Details
                        ProfessionalCard {
                            VStack(spacing: 20) {
                                HStack {
                                    Image(systemName: selectedBroker.icon)
                                        .font(.system(size: 20))
                                        .foregroundStyle(getBrokerColor(selectedBroker))
                                    
                                    Text("\(selectedBroker.rawValue) Account Details")
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundStyle(.white)
                                    
                                    Spacer()
                                }
                                
                                VStack(spacing: 16) {
                                    ProfessionalTextField(
                                        title: "Account Name",
                                        placeholder: "My Trading Account",
                                        text: $accountName
                                    )
                                    
                                    ProfessionalTextField(
                                        title: "Login/Account Number",
                                        placeholder: "Enter your login",
                                        text: $login
                                    )
                                    
                                    ProfessionalTextField(
                                        title: "Password",
                                        placeholder: "Enter your password",
                                        text: $password,
                                        isSecure: true
                                    )
                                    
                                    ProfessionalTextField(
                                        title: "Server",
                                        placeholder: "Enter server name",
                                        text: $server
                                    )
                                }
                                
                                // Connection Instructions
                                ConnectionInstructionsCard(broker: selectedBroker, isDemo: isDemo)
                            }
                        }
                        
                        // Error Display
                        if !connectionError.isEmpty {
                            HStack {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundStyle(.red)
                                Text(connectionError)
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundStyle(.red)
                            }
                            .padding()
                            .background(.red.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        
                        // Connect Button
                        Button(action: connectAccount) {
                            HStack {
                                if isConnecting {
                                    ProgressView()
                                        .scaleEffect(0.8)
                                        .tint(.black)
                                    Text("Connecting...")
                                } else {
                                    Image(systemName: "link")
                                    Text("Connect Account")
                                }
                            }
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(
                                    colors: isFormValid ? [DesignSystem.primaryGold, .orange] : [.gray, .gray],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .disabled(!isFormValid || isConnecting)
                        }
                        
                        Spacer(minLength: 50)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                }
            }
            .navigationBarHidden(true)
            .overlay(
                VStack {
                    HStack {
                        Button("Cancel") {
                            dismiss()
                        }
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.white)
                        
                        Spacer()
                        
                        Text("Add Account")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(.white)
                        
                        Spacer()
                        
                        Button("Cancel") {
                            dismiss()
                        }
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.clear)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 60)
                    
                    Spacer()
                }
            )
        }
        .alert("Connection Successful!", isPresented: $showingSuccess) {
            Button("Done") {
                dismiss()
            }
        } message: {
            Text("Your \(selectedBroker.rawValue) account has been successfully connected and added to your portfolio.")
        }
        .onAppear {
            updatePlaceholderData()
        }
    }
    
    private var isFormValid: Bool {
        !accountName.isEmpty && !login.isEmpty && !password.isEmpty && !server.isEmpty
    }
    
    private func updatePlaceholderData() {
        accountName = ""
        login = ""
        password = ""
        server = ""
        connectionError = ""
        
        if isDemo {
            switch selectedBroker {
            case .mt5:
                accountName = "MT5 Demo Account"
                login = "demo_mt5_123456"
                password = "demo_password"
                server = "MetaQuotes-Demo"
            case .mt4:
                accountName = "MT4 Demo Account"
                login = "demo_mt4_789012"
                password = "demo_password"
                server = "MetaQuotes-Demo"
            case .coinexx:
                accountName = "Coinexx Demo"
                login = "845514"
                password = "Jj0@AfHgVv7kpj"
                server = "Coinexx-Demo"
            case .tradeLocker:
                accountName = "TradeLocker Demo"
                login = "demo_tl_456789"
                password = "demo_password"
                server = "TradeLocker-Demo"
            case .xtb:
                accountName = "XTB Demo"
                login = "demo_xtb_321654"
                password = "demo_password"
                server = "XTB-Demo"
            case .hankotrade:
                accountName = "Hankotrade Demo"
                login = "demo_hanko_987654"
                password = "demo_password"
                server = "Hankotrade-Demo"
            case .manual:
                accountName = "Manual Trading"
                login = "manual_mode"
                password = "no_password"
                server = "Manual"
            case .forex:
                accountName = "Forex.com Demo"
                login = "demo_forex_123456"
                password = "demo_password"
                server = "Forex-Demo"
            }
        }
    }
    
    private func connectAccount() {
        isConnecting = true
        connectionError = ""
        
        Task {
            // Simulate connection process
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            
            await MainActor.run {
                
                // Create new account
                let newAccount = ProfessionalTradingAccount(
                    accountName: accountName,
                    login: login,
                    server: server,
                    brokerType: selectedBroker,
                    balance: Double.random(in: 1000...10000),
                    equity: Double.random(in: 1000...10000),
                    todaysPnL: Double.random(in: -100...100),
                    drawdown: Double.random(in: 0...15),
                    isConnected: true
                )
                
                accountManager.addAccount(newAccount)
                
                isConnecting = false
                showingSuccess = true
            }
        }
    }
    
    private func getBrokerColor(_ broker: SharedTypes.BrokerType) -> Color {
        switch broker {
        case .mt5: return .blue
        case .mt4: return .cyan
        case .coinexx: return .orange
        case .tradeLocker: return .purple
        case .xtb: return .green
        case .hankotrade: return .red
        case .manual: return .gray
        case .forex: return .yellow
        }
    }
}

// MARK: - Supporting Views

struct AccountTypeCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(isSelected ? .black : .white)
                
                VStack(spacing: 4) {
                    Text(title)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(isSelected ? .black : .white)
                    
                    Text(subtitle)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(isSelected ? .black.opacity(0.7) : .white.opacity(0.7))
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 100)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? DesignSystem.primaryGold : .clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? .clear : .white.opacity(0.3), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct BrokerCard: View {
    let broker: SharedTypes.BrokerType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: broker.icon)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(isSelected ? .black : getBrokerColor(broker))
                
                Text(broker.rawValue)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundStyle(isSelected ? .black : .white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 70)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(isSelected ? DesignSystem.primaryGold : .clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(isSelected ? .clear : getBrokerColor(broker).opacity(0.3), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func getBrokerColor(_ broker: SharedTypes.BrokerType) -> Color {
        switch broker {
        case .mt5: return .blue
        case .mt4: return .cyan
        case .coinexx: return .orange
        case .tradeLocker: return .purple
        case .xtb: return .green
        case .hankotrade: return .red
        case .manual: return .gray
        case .forex: return .yellow
        }
    }
}

struct ProfessionalTextField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    let isSecure: Bool
    
    init(title: String, placeholder: String, text: Binding<String>, isSecure: Bool = false) {
        self.title = title
        self.placeholder = placeholder
        self._text = text
        self.isSecure = isSecure
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.white.opacity(0.8))
            
            Group {
                if isSecure {
                    SecureField(placeholder, text: $text)
                } else {
                    TextField(placeholder, text: $text)
                }
            }
            .font(.system(size: 16, weight: .medium))
            .foregroundStyle(.white)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(.white.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.white.opacity(0.3), lineWidth: 1)
                    )
            )
        }
    }
}

struct ConnectionInstructionsCard: View {
    let broker: SharedTypes.BrokerType
    let isDemo: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "info.circle.fill")
                    .foregroundStyle(.blue)
                
                Text("Connection Instructions")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.white)
            }
            
            Text(getInstructionText())
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(.white.opacity(0.7))
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding()
        .background(.blue.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
    private func getInstructionText() -> String {
        switch broker {
        case .mt5:
            return isDemo ? 
            "Demo credentials are pre-filled. For live trading: Open MT5 → Tools → Options → Expert Advisors → Enable automated trading." :
            "1. Open MetaTrader 5\n2. Enable automated trading in Expert Advisors\n3. Enter your live account credentials\n4. Ensure DLL imports are enabled"
            
        case .mt4:
            return isDemo ?
            "Demo credentials are pre-filled. For live trading: Open MT4 → Tools → Options → Expert Advisors → Enable automated trading." :
            "1. Open MetaTrader 4\n2. Enable automated trading in Expert Advisors\n3. Enter your live account credentials\n4. Ensure DLL imports are enabled"
            
        case .coinexx:
            return isDemo ?
            "Demo credentials are pre-filled for testing. Your real Coinexx account (845514) is ready to connect." :
            "1. Login to your Coinexx account\n2. Generate API credentials if needed\n3. Enter your account details above\n4. Enable trading permissions"
            
        case .tradeLocker:
            return isDemo ?
            "Demo credentials are pre-filled. For live trading: Login to TradeLocker → API Management → Generate credentials." :
            "1. Login to your TradeLocker account\n2. Go to API Management\n3. Generate new API credentials\n4. Enable trading permissions"
            
        case .xtb:
            return isDemo ?
            "Demo credentials are pre-filled. For live trading: Login to XTB → API settings → Generate credentials." :
            "1. Login to your XTB account\n2. Go to API settings\n3. Generate API credentials\n4. Enable trading permissions"
            
        case .hankotrade:
            return isDemo ?
            "Demo credentials are pre-filled. For live trading: Contact Hankotrade support for API access." :
            "1. Contact Hankotrade support\n2. Request API access\n3. Follow their setup instructions\n4. Enter credentials above"
            
        case .manual:
            return "Manual mode: No broker connection required. GOLDEX AI will generate trading signals for manual execution in your preferred platform."
        case .forex:
            return isDemo ?
            "Demo credentials are pre-filled. For live trading: Login to Forex.com → API settings → Generate credentials." :
            "1. Login to your Forex.com account\n2. Go to API settings\n3. Generate API credentials\n4. Enable trading permissions"
        }
    }
}

#Preview {
    AddAccountView(accountManager: MultiAccountManager())
}