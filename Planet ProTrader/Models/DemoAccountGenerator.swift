//
//  DemoAccountGenerator.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 7/13/25.
//

import SwiftUI

struct DemoAccountGenerator: View {
    @State private var generatedAccounts: [SharedTypes.MT5Account] = []
    @State private var isGenerating = false
    @State private var selectedBroker = "Coinexx"
    @State private var accountCount = 5
    
    private let brokers = ["Coinexx", "Alpari", "XM", "FXCM", "MetaQuotes"]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 12) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(DesignSystem.primaryGold)
                    
                    Text("Demo Account Generator")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(DesignSystem.primaryText)
                    
                    Text("Generate demo accounts to start autotrading")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(DesignSystem.secondaryText)
                        .multilineTextAlignment(.center)
                }
                
                // Controls
                VStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Broker")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(DesignSystem.primaryText)
                        
                        Picker("Broker", selection: $selectedBroker) {
                            ForEach(brokers, id: \.self) { broker in
                                Text(broker).tag(broker)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Number of Accounts: \(accountCount)")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(DesignSystem.primaryText)
                        
                        Stepper("", value: $accountCount, in: 1...20)
                            .labelsHidden()
                    }
                    
                    Button(action: generateAccounts) {
                        HStack {
                            if isGenerating {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(0.8)
                            }
                            
                            Text(isGenerating ? "Generating..." : "Generate Accounts")
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(DesignSystem.primaryGold)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .disabled(isGenerating)
                }
                .padding()
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                
                // Generated Accounts
                if !generatedAccounts.isEmpty {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Generated Accounts")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(DesignSystem.primaryText)
                        
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(Array(generatedAccounts.enumerated()), id: \.offset) { index, account in
                                    GeneratedAccountCard(account: account, index: index + 1)
                                }
                            }
                        }
                        .frame(maxHeight: 300)
                    }
                }
                
                Spacer()
            }
            .padding()
            .background(DesignSystem.backgroundGradient)
            .navigationTitle("Demo Generator")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func generateAccounts() {
        isGenerating = true
        
        Task {
            // Simulate account generation
            try await Task.sleep(nanoseconds: 2_000_000_000)
            
            await MainActor.run {
                generatedAccounts = generateDemoAccounts(count: accountCount, broker: selectedBroker)
                isGenerating = false
            }
        }
    }
    
    private func generateDemoAccounts(count: Int, broker: String) -> [SharedTypes.MT5Account] {
        var accounts: [SharedTypes.MT5Account] = []
        
        for i in 1...count {
            let account = SharedTypes.MT5Account(
                login: "DEMO_\(broker.uppercased())_\(String(format: "%03d", i))",
                password: "GoldexAI\(i)23!",
                server: "\(broker)Demo-Server",
                company: broker,
                isConnected: false,
                balance: 10000.0,
                equity: 10000.0,
                margin: 0.0,
                freeMargin: 10000.0
            )
            
            accounts.append(account)
        }
        
        return accounts
    }
}

struct GeneratedAccountCard: View {
    let account: SharedTypes.MT5Account
    let index: Int
    
    var body: some View {
        UltraPremiumCard {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Account #\(index)")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(DesignSystem.primaryGold)
                    
                    Spacer()
                    
                    Button("Copy") {
                        copyToClipboard()
                    }
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.blue)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Login: \(account.login)")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(DesignSystem.primaryText)
                    
                    Text("Password: \(account.password)")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(DesignSystem.primaryText)
                    
                    Text("Server: \(account.server)")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(DesignSystem.secondaryText)
                }
            }
        }
    }
    
    private func copyToClipboard() {
        let accountInfo = """
        Login: \(account.login)
        Password: \(account.password)
        Server: \(account.server)
        """
        
        UIPasteboard.general.string = accountInfo
    }
}

#Preview {
    DemoAccountGenerator()
}