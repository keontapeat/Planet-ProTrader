//
//  AccountSwitcherView.swift
//  Planet ProTrader
//
//  ✅ ACCOUNT SWITCHER COMPONENT - Professional account management
//

import SwiftUI

struct AccountSwitcherView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var realTimeAccountManager: RealTimeAccountManager
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(realTimeAccountManager.activeAccounts.indices, id: \.self) { index in
                        let account = realTimeAccountManager.activeAccounts[index]
                        
                        Button(action: {
                            realTimeAccountManager.switchToAccount(at: index)
                            dismiss()
                        }) {
                            AccountRow(
                                account: account, 
                                isSelected: index == realTimeAccountManager.selectedAccountIndex
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding()
            }
            .navigationTitle("Select Account")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

struct AccountRow: View {
    let account: CoreTypes.TradingAccountDetails
    let isSelected: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(account.isDemo ? Color.orange : Color.green)
                    .frame(width: 40, height: 40)
                
                Image(systemName: account.isDemo ? "play.circle.fill" : "bolt.circle.fill")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(account.name)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.primary)
                    
                    Text(account.isDemo ? "DEMO" : "LIVE")
                        .font(.system(size: 10, weight: .black))
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(account.isDemo ? Color.orange : Color.green)
                        .clipShape(Capsule())
                }
                
                Text(account.formattedBalance)
                    .font(.system(size: 18, weight: .black, design: .monospaced))
                    .foregroundStyle(DesignSystem.goldGradient)
                
                Text("Server: \(account.server)")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.green)
            }
        }
        .padding(20)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(.ultraThinMaterial)
                
                if isSelected {
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(DesignSystem.goldGradient, lineWidth: 2)
                }
            }
        )
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

#Preview {
    AccountSwitcherView()
        .environmentObject(RealTimeAccountManager())
}