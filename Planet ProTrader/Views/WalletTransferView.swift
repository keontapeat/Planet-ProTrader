//
//  WalletTransferView.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 7/18/25.
//

import SwiftUI

struct WalletTransferView: View {
    @StateObject private var transferManager = WalletTransferManager()
    @Environment(\.dismiss) private var dismiss
    
    @State private var fromWallet: WalletDashboardView.WalletType = .trading
    @State private var toWallet: WalletDashboardView.WalletType = .botEarnings
    @State private var transferAmount = ""
    @State private var showingConfirmation = false
    @State private var isProcessingTransfer = false
    @State private var animateCards = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Premium Background
                LinearGradient(
                    colors: [
                        Color(.systemBackground),
                        DesignSystem.primaryGold.opacity(0.03),
                        Color(.systemBackground)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header
                        headerSection
                        
                        // Wallet Selection
                        walletSelectionSection
                        
                        // Transfer Arrow & Swap
                        transferArrowSection
                        
                        // Amount Input
                        amountInputSection
                        
                        // Transfer Summary
                        if !transferAmount.isEmpty, let amount = Double(transferAmount), amount > 0 {
                            transferSummarySection(amount: amount)
                        }
                        
                        // Transfer Button
                        transferButton
                        
                        // Recent Transfers
                        recentTransfersSection
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .navigationTitle("")
            .navigationBarHidden(true)
            .onAppear {
                startAnimations()
                transferManager.loadTransferData()
            }
        }
        .alert("Confirm Transfer", isPresented: $showingConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Confirm") {
                processTransfer()
            }
        } message: {
            if let amount = Double(transferAmount) {
                Text("Transfer $\(String(format: "%.2f", amount)) from \(fromWallet.displayName) to \(toWallet.displayName)?")
            }
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 16) {
            HStack {
                Button("Cancel") {
                    dismiss()
                }
                .foregroundColor(.secondary)
                
                Spacer()
                
                VStack(spacing: 4) {
                    Text("Transfer Funds")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                    
                    Text("Move money between wallets")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button("Help") {
                    // Help action
                }
                .foregroundColor(DesignSystem.primaryGold)
            }
            .padding(.top, 8)
        }
        .scaleEffect(animateCards ? 1.0 : 0.95)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1), value: animateCards)
    }
    
    // MARK: - Wallet Selection Section
    private var walletSelectionSection: some View {
        VStack(spacing: 16) {
            // From Wallet
            VStack(alignment: .leading, spacing: 12) {
                Text("FROM")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.secondary)
                
                WalletSelectionCard(
                    walletType: fromWallet,
                    balance: getWalletBalance(fromWallet),
                    isSelected: true
                ) {
                    // Toggle from wallet
                    withAnimation(.spring()) {
                        let temp = fromWallet
                        fromWallet = toWallet
                        toWallet = temp
                    }
                }
            }
            
            // To Wallet
            VStack(alignment: .leading, spacing: 12) {
                Text("TO")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.secondary)
                
                WalletSelectionCard(
                    walletType: toWallet,
                    balance: getWalletBalance(toWallet),
                    isSelected: true
                ) {
                    // Toggle to wallet
                    withAnimation(.spring()) {
                        let temp = fromWallet
                        fromWallet = toWallet
                        toWallet = temp
                    }
                }
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.95)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2), value: animateCards)
    }
    
    // MARK: - Transfer Arrow Section
    private var transferArrowSection: some View {
        HStack {
            Spacer()
            
            Button(action: {
                withAnimation(.spring()) {
                    let temp = fromWallet
                    fromWallet = toWallet
                    toWallet = temp
                }
            }) {
                ZStack {
                    Circle()
                        .fill(DesignSystem.goldGradient)
                        .frame(width: 48, height: 48)
                        .shadow(color: DesignSystem.primaryGold.opacity(0.3), radius: 8, x: 0, y: 4)
                    
                    Image(systemName: "arrow.up.arrow.down")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            .scaleEffect(animateCards ? 1.0 : 0.9)
            .animation(.easeInOut(duration: 0.2), value: animateCards)
            
            Spacer()
        }
        .scaleEffect(animateCards ? 1.0 : 0.95)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3), value: animateCards)
    }
    
    // MARK: - Amount Input Section
    private var amountInputSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("💰 Transfer Amount")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
            
            UltraPremiumCard {
                VStack(spacing: 16) {
                    // Amount Input
                    HStack {
                        Text("$")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.primary)
                        
                        TextField("0.00", text: $transferAmount)
                            .font(.system(size: 24, weight: .bold))
                            .keyboardType(.decimalPad)
                            .placeholder("Enter amount", when: transferAmount.isEmpty)
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    // Quick Amount Buttons
                    HStack(spacing: 12) {
                        ForEach(getQuickAmounts(), id: \.self) { amount in
                            Button(action: {
                                transferAmount = amount.replacingOccurrences(of: "$", with: "").replacingOccurrences(of: "Max", with: String(format: "%.2f", getWalletBalance(fromWallet)))
                            }) {
                                Text(amount)
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(DesignSystem.primaryGold)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(.ultraThinMaterial)
                                    .clipShape(Capsule())
                            }
                        }
                    }
                    
                    // Available Balance
                    HStack {
                        Text("Available: \(String(format: "$%.2f", getWalletBalance(fromWallet)))")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                        
                        Spacer()
                    }
                }
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.95)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.4), value: animateCards)
    }
    
    // MARK: - Transfer Summary Section
    private func transferSummarySection(amount: Double) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("📊 Transfer Summary")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
            
            UltraPremiumCard {
                VStack(spacing: 12) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("YOU'RE TRANSFERRING")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.secondary)
                            
                            Text(String(format: "$%.2f", amount))
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.primary)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            Text("TRANSFER FEE")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.secondary)
                            
                            Text("FREE")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.green)
                        }
                    }
                    
                    Divider()
                    
                    VStack(spacing: 8) {
                        HStack {
                            Text("From:")
                                .font(.system(size: 12))
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            HStack(spacing: 4) {
                                Image(systemName: fromWallet.icon)
                                    .font(.system(size: 10))
                                    .foregroundColor(fromWallet.color)
                                Text(fromWallet.displayName)
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.primary)
                            }
                        }
                        
                        HStack {
                            Text("To:")
                                .font(.system(size: 12))
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            HStack(spacing: 4) {
                                Image(systemName: toWallet.icon)
                                    .font(.system(size: 10))
                                    .foregroundColor(toWallet.color)
                                Text(toWallet.displayName)
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.primary)
                            }
                        }
                        
                        HStack {
                            Text("Processing Time:")
                                .font(.system(size: 12))
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            Text("Instant")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.green)
                        }
                    }
                }
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.95)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.5), value: animateCards)
    }
    
    // MARK: - Transfer Button
    private var transferButton: some View {
        Button(action: {
            showingConfirmation = true
        }) {
            HStack(spacing: 12) {
                if isProcessingTransfer {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.8)
                } else {
                    Image(systemName: "arrow.left.arrow.right.circle.fill")
                        .font(.system(size: 18, weight: .bold))
                }
                
                VStack(spacing: 2) {
                    Text(isProcessingTransfer ? "Processing Transfer..." : "Transfer Funds")
                        .font(.system(size: 16, weight: .bold))
                    
                    if let amount = Double(transferAmount), amount > 0, !isProcessingTransfer {
                        Text("$\(String(format: "%.2f", amount)) → \(toWallet.displayName)")
                            .font(.system(size: 12))
                    }
                }
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                canTransfer ? 
                LinearGradient(
                    colors: [DesignSystem.primaryGold, DesignSystem.secondaryGold],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ) :
                LinearGradient(
                    colors: [Color.gray, Color.gray],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: canTransfer ? DesignSystem.primaryGold.opacity(0.3) : .clear, radius: 8, x: 0, y: 4)
        }
        .disabled(!canTransfer || isProcessingTransfer)
        .scaleEffect(canTransfer ? 1.02 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: canTransfer)
        .scaleEffect(animateCards ? 1.0 : 0.95)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.6), value: animateCards)
    }
    
    // MARK: - Recent Transfers Section
    private var recentTransfersSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("📋 Recent Transfers")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
            
            LazyVStack(spacing: 8) {
                ForEach(transferManager.recentTransfers.prefix(5)) { transfer in
                    RecentTransferRow(transfer: transfer)
                }
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.95)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.7), value: animateCards)
    }
    
    // MARK: - Helper Methods
    private func startAnimations() {
        withAnimation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.2)) {
            animateCards = true
        }
    }
    
    private func getWalletBalance(_ walletType: WalletDashboardView.WalletType) -> Double {
        switch walletType {
        case .trading: return 2547.83
        case .botEarnings: return 8247.93
        }
    }
    
    private func getQuickAmounts() -> [String] {
        let balance = getWalletBalance(fromWallet)
        let amounts = ["$100", "$500", "$1000"]
        return amounts + ["Max"]
    }
    
    private var canTransfer: Bool {
        guard let amount = Double(transferAmount),
              amount > 0,
              amount <= getWalletBalance(fromWallet) else {
            return false
        }
        return fromWallet != toWallet
    }
    
    private func processTransfer() {
        guard let amount = Double(transferAmount) else { return }
        
        isProcessingTransfer = true
        
        Task {
            do {
                try await transferManager.processTransfer(
                    from: fromWallet,
                    to: toWallet,
                    amount: amount
                )
                
                await MainActor.run {
                    isProcessingTransfer = false
                    dismiss()
                }
            } catch {
                await MainActor.run {
                    isProcessingTransfer = false
                    // Error handling
                }
            }
        }
    }
}

// MARK: - Supporting Views

struct WalletSelectionCard: View {
    let walletType: WalletDashboardView.WalletType
    let balance: Double
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            UltraPremiumCard {
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(walletType.color.opacity(0.1))
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: walletType.icon)
                            .font(.system(size: 18))
                            .foregroundColor(walletType.color)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(walletType.displayName)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.primary)
                        
                        Text(walletType.description)
                            .font(.system(size: 11))
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text(String(format: "$%.2f", balance))
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(walletType.color)
                        
                        Text("Available")
                            .font(.system(size: 10))
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct RecentTransferRow: View {
    let transfer: TransferRecord
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.1))
                    .frame(width: 32, height: 32)
                
                Image(systemName: "arrow.left.arrow.right")
                    .font(.system(size: 12))
                    .foregroundColor(.blue)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text("\(transfer.fromWallet) → \(transfer.toWallet)")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.primary)
                
                Text(transfer.timestamp, style: .relative)
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                Text(String(format: "$%.2f", transfer.amount))
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.primary)
                
                Text("Completed")
                    .font(.system(size: 9, weight: .medium))
                    .foregroundColor(.green)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

// MARK: - Transfer Manager
@MainActor
class WalletTransferManager: ObservableObject {
    @Published var recentTransfers: [TransferRecord] = []
    @Published var isLoading = false
    
    func loadTransferData() {
        recentTransfers = TransferRecord.sampleTransfers
    }
    
    func processTransfer(from: WalletDashboardView.WalletType, to: WalletDashboardView.WalletType, amount: Double) async throws {
        // Simulate processing
        try await Task.sleep(nanoseconds: 2_000_000_000)
        
        let transfer = TransferRecord(
            fromWallet: from.displayName,
            toWallet: to.displayName,
            amount: amount
        )
        
        recentTransfers.insert(transfer, at: 0)
    }
}

struct TransferRecord: Identifiable, Codable {
    let id: UUID
    let fromWallet: String
    let toWallet: String
    let amount: Double
    let timestamp: Date
    let status: String
    
    init(
        id: UUID = UUID(),
        fromWallet: String,
        toWallet: String,
        amount: Double,
        timestamp: Date = Date(),
        status: String = "completed"
    ) {
        self.id = id
        self.fromWallet = fromWallet
        self.toWallet = toWallet
        self.amount = amount
        self.timestamp = timestamp
        self.status = status
    }
    
    static let sampleTransfers: [TransferRecord] = [
        TransferRecord(
            fromWallet: "Trading Fuel",
            toWallet: "Bot Earnings",
            amount: 500.0,
            timestamp: Date().addingTimeInterval(-3600)
        ),
        TransferRecord(
            fromWallet: "Bot Earnings",
            toWallet: "Trading Fuel",
            amount: 250.0,
            timestamp: Date().addingTimeInterval(-7200)
        ),
        TransferRecord(
            fromWallet: "Trading Fuel",
            toWallet: "Bot Earnings",
            amount: 1000.0,
            timestamp: Date().addingTimeInterval(-86400)
        )
    ]
}

#Preview {
    WalletTransferView()
}