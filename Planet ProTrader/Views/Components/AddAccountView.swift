//
//  AddAccountView.swift
//  Planet ProTrader
//
//  ✅ ADD ACCOUNT COMPONENT - Professional account connection
//

import SwiftUI

struct AddAccountView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var login = ""
    @State private var password = ""
    @State private var server = ""
    @State private var accountType: AccountType = .demo
    @State private var isConnecting = false
    
    enum AccountType: String, CaseIterable {
        case demo = "Demo"
        case live = "Live"
        
        var color: Color {
            switch self {
            case .demo: return .orange
            case .live: return .green
            }
        }
        
        var icon: String {
            switch self {
            case .demo: return "play.circle.fill"
            case .live: return "bolt.circle.fill"
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 32) {
                    // Header
                    VStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(DesignSystem.goldGradient)
                                .frame(width: 80, height: 80)
                            
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.white)
                        }
                        
                        VStack(spacing: 8) {
                            Text("Connect Trading Account")
                                .font(.title2.bold())
                            
                            Text("Add your MT5/MT4 broker account")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding(.top)
                    
                    // Form
                    VStack(spacing: 20) {
                        CustomTextField(
                            title: "Account Login",
                            text: $login,
                            icon: "person.circle.fill",
                            placeholder: "Enter your login number"
                        )
                        
                        CustomSecureField(
                            title: "Password",
                            text: $password,
                            icon: "lock.circle.fill",
                            placeholder: "Enter your password"
                        )
                        
                        CustomTextField(
                            title: "Server",
                            text: $server,
                            icon: "server.rack",
                            placeholder: "e.g., MetaQuotes-Demo"
                        )
                        
                        // Account type selector
                        accountTypeSelector
                    }
                    
                    Spacer()
                    
                    // Actions
                    VStack(spacing: 16) {
                        Button(action: connectAccount) {
                            HStack(spacing: 12) {
                                if isConnecting {
                                    ProgressView()
                                        .scaleEffect(0.8)
                                        .tint(.white)
                                } else {
                                    Image(systemName: "link.circle.fill")
                                        .font(.system(size: 18, weight: .bold))
                                }
                                
                                Text(isConnecting ? "Connecting..." : "Connect Account")
                                    .font(.headline)
                                    .fontWeight(.bold)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(
                                isFormValid ? DesignSystem.goldGradient : Color.gray.gradient
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .shadow(
                                color: isFormValid ? DesignSystem.primaryGold.opacity(0.3) : .clear,
                                radius: 12,
                                x: 0,
                                y: 6
                            )
                        }
                        .disabled(!isFormValid || isConnecting)
                        
                        Button("Cancel") {
                            dismiss()
                        }
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.secondary)
                    }
                }
                .padding()
            }
            .navigationTitle("Add Account")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
    
    private var accountTypeSelector: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Account Type")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.primary)
            
            HStack(spacing: 12) {
                ForEach(AccountType.allCases, id: \.self) { type in
                    Button(action: {
                        HapticFeedbackManager.shared.selection()
                        accountType = type
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: type.icon)
                                .font(.system(size: 16, weight: .bold))
                            
                            Text(type.rawValue)
                                .font(.system(size: 14, weight: .semibold))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(accountType == type ? type.color : Color.gray.opacity(0.2))
                        .foregroundColor(accountType == type ? .white : .primary)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
            }
        }
    }
    
    private var isFormValid: Bool {
        !login.isEmpty && !password.isEmpty && !server.isEmpty
    }
    
    private func connectAccount() {
        guard isFormValid else { return }
        
        isConnecting = true
        
        // Simulate connection delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            isConnecting = false
            HapticFeedbackManager.shared.success()
            
            // Create new account
            let newAccount = CoreTypes.TradingAccountDetails(
                accountNumber: login,
                broker: .mt5,
                accountType: accountType.rawValue,
                balance: accountType == .demo ? 10000.0 : 5000.0,
                equity: accountType == .demo ? 10000.0 : 5000.0,
                freeMargin: accountType == .demo ? 9500.0 : 4800.0,
                leverage: 500,
                isActive: false
            )
            
            // Add to account manager (this would normally go through the real manager)
            // realTimeAccountManager.addAccount(newAccount)
            
            dismiss()
        }
    }
}

struct CustomTextField: View {
    let title: String
    @Binding var text: String
    let icon: String
    let placeholder: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.secondary)
                
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.primary)
            }
            
            TextField(placeholder, text: $text)
                .padding(16)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
        }
    }
}

struct CustomSecureField: View {
    let title: String
    @Binding var text: String
    let icon: String
    let placeholder: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.secondary)
                
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.primary)
            }
            
            SecureField(placeholder, text: $text)
                .padding(16)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
        }
    }
}

#Preview {
    AddAccountView()
}