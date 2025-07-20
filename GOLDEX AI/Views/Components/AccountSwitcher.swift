//
//  AccountSwitcher.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 7/13/25.
//

import SwiftUI

struct AccountSwitcher: View {
    @ObservedObject var accountManager: RealTimeAccountManager
    @State private var showingAccountPicker = false
    @State private var animateBalance = false
    
    var body: some View {
        Button(action: {
            showingAccountPicker = true
        }) {
            HStack(spacing: 8) {
                // Wallet Icon
                Image(systemName: "wallet.pass")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(DesignSystem.primaryGold)
                
                // Account Info
                VStack(alignment: .trailing, spacing: 2) {
                    Text(accountManager.currentAccount?.name ?? "No Account")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    
                    Text(accountManager.formattedBalance)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(DesignSystem.primaryGold)
                        .scaleEffect(animateBalance ? 1.1 : 1.0)
                        .animation(.easeInOut(duration: 0.3), value: animateBalance)
                }
                
                // Dropdown Arrow
                Image(systemName: "chevron.down")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(DesignSystem.primaryGold.opacity(0.3), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showingAccountPicker) {
            AccountPickerView(accountManager: accountManager)
        }
        .onReceive(NotificationCenter.default.publisher(for: .accountBalanceUpdated)) { _ in
            withAnimation(.easeInOut(duration: 0.3)) {
                animateBalance.toggle()
            }
        }
    }
}

struct AccountPickerView: View {
    @ObservedObject var accountManager: RealTimeAccountManager
    @Environment(\.dismiss) private var dismiss
    @State private var animateCards = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 16) {
                    HStack {
                        Image(systemName: "wallet.pass.fill")
                            .font(.title2)
                            .foregroundColor(DesignSystem.primaryGold)
                        
                        Text("Trading Accounts")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Button("Done") {
                            dismiss()
                        }
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(DesignSystem.primaryGold)
                    }
                    
                    Text("Select your active trading account")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                // Account Cards
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(Array(accountManager.activeAccounts.enumerated()), id: \.element.id) { index, account in
                            TradingAccountCard(
                                account: account,
                                isSelected: index == accountManager.selectedAccountIndex,
                                onSelect: {
                                    accountManager.switchToAccount(at: index)
                                    dismiss()
                                }
                            )
                            .scaleEffect(animateCards ? 1.0 : 0.9)
                            .opacity(animateCards ? 1.0 : 0.0)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(Double(index) * 0.1), value: animateCards)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
                
                Spacer()
            }
            .background(DesignSystem.backgroundGradient)
            .navigationBarHidden(true)
            .onAppear {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2)) {
                    animateCards = true
                }
            }
        }
    }
}

struct TradingAccountCard: View {
    let account: SharedTypes.TradingAccountDetails
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 16) {
                // Account Icon
                ZStack {
                    Circle()
                        .fill(isSelected ? DesignSystem.primaryGold : Color.gray.opacity(0.3))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: account.isConnected ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(account.isConnected ? .white : .gray)
                }
                
                // Account Details
                VStack(alignment: .leading, spacing: 4) {
                    Text(account.name)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    Text("Account: \(account.accountNumber)")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.secondary)
                    
                    Text(account.serverName)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Balance & Status
                VStack(alignment: .trailing, spacing: 4) {
                    Text(String(format: "$%.2f", account.balance))
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(DesignSystem.primaryGold)
                    
                    Text(account.isConnected ? "Connected" : "Disconnected")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(account.isConnected ? .green : .red)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(
                            RoundedRectangle(cornerRadius: 4)
                                .fill(account.isConnected ? Color.green.opacity(0.1) : Color.red.opacity(0.1))
                        )
                    
                    if isSelected {
                        Text("ACTIVE")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(DesignSystem.primaryGold)
                            )
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemBackground))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(isSelected ? DesignSystem.primaryGold : Color.clear, lineWidth: 2)
                    )
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Preview

#Preview {
    AccountSwitcher(accountManager: RealTimeAccountManager())
}