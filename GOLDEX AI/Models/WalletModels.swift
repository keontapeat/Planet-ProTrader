//
//  WalletModels.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 1/27/25.
//  Split Wallet System - Bot Earnings vs Trading Funds
//

import Foundation
import SwiftUI

// MARK: - Wallet Models

struct WalletModels {
    
    // MARK: - Wallet Types
    
    enum WalletType: String, CaseIterable, Codable {
        case botEarnings = "BOT_EARNINGS"
        case tradingFunds = "TRADING_FUNDS"
        case totalBalance = "TOTAL_BALANCE"
        
        var displayName: String {
            switch self {
            case .botEarnings: return "Bot Earnings 💰"
            case .tradingFunds: return "Trading Funds 🔄"
            case .totalBalance: return "Total Balance 💎"
            }
        }
        
        var description: String {
            switch self {
            case .botEarnings: return "Money your bots made for you - secured and locked"
            case .tradingFunds: return "Active trading capital for bot operations"
            case .totalBalance: return "Combined balance across all wallets"
            }
        }
        
        var icon: String {
            switch self {
            case .botEarnings: return "safe.fill"
            case .tradingFunds: return "arrow.triangle.2.circlepath"
            case .totalBalance: return "dollarsign.circle.fill"
            }
        }
        
        var color: Color {
            switch self {
            case .botEarnings: return .green
            case .tradingFunds: return .blue
            case .totalBalance: return DesignSystem.primaryGold
            }
        }
        
        var gradient: LinearGradient {
            LinearGradient(
                colors: [color, color.opacity(0.7)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
    
    // MARK: - Wallet Model
    
    struct Wallet: Identifiable, Codable {
        let id: UUID
        let userId: String
        let type: WalletType
        var balance: Double
        var lockedBalance: Double
        var availableBalance: Double
        let createdAt: Date
        var updatedAt: Date
        let currency: String
        var autoLockPercentage: Double // Auto-lock X% of profits
        var minimumBalance: Double
        
        init(
            id: UUID = UUID(),
            userId: String,
            type: WalletType,
            balance: Double = 0.0,
            lockedBalance: Double = 0.0,
            currency: String = "USD",
            autoLockPercentage: Double = 0.0,
            minimumBalance: Double = 0.0
        ) {
            self.id = id
            self.userId = userId
            self.type = type
            self.balance = balance
            self.lockedBalance = lockedBalance
            self.availableBalance = max(0, balance - lockedBalance)
            self.createdAt = Date()
            self.updatedAt = Date()
            self.currency = currency
            self.autoLockPercentage = autoLockPercentage
            self.minimumBalance = minimumBalance
        }
        
        var formattedBalance: String {
            formatCurrency(balance)
        }
        
        var formattedAvailableBalance: String {
            formatCurrency(availableBalance)
        }
        
        var formattedLockedBalance: String {
            formatCurrency(lockedBalance)
        }
        
        private func formatCurrency(_ amount: Double) -> String {
            if amount >= 1000 {
                return String(format: "$%.1fK", amount / 1000)
            } else {
                return String(format: "$%.2f", amount)
            }
        }
        
        var canWithdraw: Bool {
            type == .botEarnings && availableBalance > minimumBalance
        }
        
        var withdrawableAmount: Double {
            max(0, availableBalance - minimumBalance)
        }
        
        var isLowBalance: Bool {
            type == .tradingFunds && balance < 50.0
        }
        
        var balanceStatus: BalanceStatus {
            if isLowBalance {
                return .low
            } else if balance >= 1000 {
                return .high
            } else {
                return .normal
            }
        }
        
        enum BalanceStatus: String {
            case low = "Low"
            case normal = "Normal"
            case high = "High"
            
            var color: Color {
                switch self {
                case .low: return .red
                case .normal: return .primary
                case .high: return .green
                }
            }
        }
    }
    
    // MARK: - Wallet Transaction
    
    struct WalletTransaction: Identifiable, Codable {
        let id: UUID
        let walletId: UUID
        let fromWallet: WalletType?
        let toWallet: WalletType?
        let type: TransactionType
        let amount: Double
        let fee: Double
        let netAmount: Double
        let status: TransactionStatus
        let description: String
        let reference: String?
        let timestamp: Date
        let metadata: [String: String]?
        
        enum TransactionType: String, CaseIterable, Codable {
            case deposit = "DEPOSIT"
            case withdrawal = "WITHDRAWAL"
            case transfer = "TRANSFER"
            case botProfit = "BOT_PROFIT"
            case botLoss = "BOT_LOSS"
            case autoLock = "AUTO_LOCK"
            case manualLock = "MANUAL_LOCK"
            case unlock = "UNLOCK"
            
            var displayName: String {
                switch self {
                case .deposit: return "Deposit"
                case .withdrawal: return "Withdrawal"
                case .transfer: return "Transfer"
                case .botProfit: return "Bot Profit"
                case .botLoss: return "Bot Loss"
                case .autoLock: return "Auto Lock"
                case .manualLock: return "Manual Lock"
                case .unlock: return "Unlock"
                }
            }
            
            var icon: String {
                switch self {
                case .deposit: return "plus.circle.fill"
                case .withdrawal: return "minus.circle.fill"
                case .transfer: return "arrow.left.arrow.right"
                case .botProfit: return "brain.head.profile"
                case .botLoss: return "exclamationmark.triangle.fill"
                case .autoLock: return "lock.fill"
                case .manualLock: return "lock.circle.fill"
                case .unlock: return "lock.open.fill"
                }
            }
            
            var color: Color {
                switch self {
                case .deposit, .botProfit: return .green
                case .withdrawal, .botLoss: return .red
                case .transfer: return .blue
                case .autoLock, .manualLock: return .orange
                case .unlock: return .purple
                }
            }
        }
        
        enum TransactionStatus: String, Codable {
            case pending = "PENDING"
            case completed = "COMPLETED"
            case failed = "FAILED"
            case cancelled = "CANCELLED"
            
            var color: Color {
                switch self {
                case .pending: return .orange
                case .completed: return .green
                case .failed: return .red
                case .cancelled: return .gray
                }
            }
        }
        
        init(
            id: UUID = UUID(),
            walletId: UUID,
            fromWallet: WalletType? = nil,
            toWallet: WalletType? = nil,
            type: TransactionType,
            amount: Double,
            fee: Double = 0.0,
            status: TransactionStatus = .completed,
            description: String,
            reference: String? = nil,
            metadata: [String: String]? = nil
        ) {
            self.id = id
            self.walletId = walletId
            self.fromWallet = fromWallet
            self.toWallet = toWallet
            self.type = type
            self.amount = amount
            self.fee = fee
            self.netAmount = amount - fee
            self.status = status
            self.description = description
            self.reference = reference
            self.timestamp = Date()
            self.metadata = metadata
        }
        
        var formattedAmount: String {
            let sign = type == .deposit || type == .botProfit ? "+" : type == .withdrawal || type == .botLoss ? "-" : ""
            if abs(amount) >= 1000 {
                return "\(sign)$\(String(format: "%.1f", abs(amount) / 1000))K"
            } else {
                return "\(sign)$\(String(format: "%.2f", abs(amount)))"
            }
        }
        
        var formattedNetAmount: String {
            let sign = type == .deposit || type == .botProfit ? "+" : type == .withdrawal || type == .botLoss ? "-" : ""
            if abs(netAmount) >= 1000 {
                return "\(sign)$\(String(format: "%.1f", abs(netAmount) / 1000))K"
            } else {
                return "\(sign)$\(String(format: "%.2f", abs(netAmount)))"
            }
        }
        
        var isIncoming: Bool {
            type == .deposit || type == .botProfit
        }
    }
    
    // MARK: - Wallet Manager
    
    class WalletManager: ObservableObject {
        @Published var wallets: [Wallet] = []
        @Published var transactions: [WalletTransaction] = []
        @Published var isLoading = false
        @Published var error: Error?
        
        private let userId: String = "current_user_id" // Replace with actual user ID
        
        init() {
            loadWallets()
        }
        
        // MARK: - Wallet Operations
        
        func loadWallets() {
            isLoading = true
            
            // Simulate loading from database
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.wallets = [
                    Wallet(
                        userId: self.userId,
                        type: .botEarnings,
                        balance: 1247.85,
                        lockedBalance: 200.0,
                        autoLockPercentage: 30.0,
                        minimumBalance: 50.0
                    ),
                    Wallet(
                        userId: self.userId,
                        type: .tradingFunds,
                        balance: 342.50,
                        lockedBalance: 0.0,
                        autoLockPercentage: 0.0,
                        minimumBalance: 10.0
                    )
                ]
                
                self.loadTransactions()
                self.isLoading = false
            }
        }
        
        func loadTransactions() {
            // Simulate loading transactions
            transactions = WalletTransaction.sampleTransactions
        }
        
        func getWallet(type: WalletType) -> Wallet? {
            wallets.first { $0.type == type }
        }
        
        var botEarningsWallet: Wallet? {
            getWallet(type: .botEarnings)
        }
        
        var tradingFundsWallet: Wallet? {
            getWallet(type: .tradingFunds)
        }
        
        var totalBalance: Double {
            wallets.reduce(0) { $0 + $1.balance }
        }
        
        var formattedTotalBalance: String {
            if totalBalance >= 1000 {
                return String(format: "$%.1fK", totalBalance / 1000)
            } else {
                return String(format: "$%.2f", totalBalance)
            }
        }
        
        var totalEarnings: Double {
            botEarningsWallet?.balance ?? 0.0
        }
        
        var availableTradingFunds: Double {
            tradingFundsWallet?.availableBalance ?? 0.0
        }
        
        // MARK: - Transaction Operations
        
        func transferBetweenWallets(
            from: WalletType,
            to: WalletType,
            amount: Double,
            description: String = ""
        ) async -> Bool {
            guard let fromWallet = getWallet(type: from),
                  let toWallet = getWallet(type: to),
                  fromWallet.availableBalance >= amount else {
                return false
            }
            
            // Create transaction
            let transaction = WalletTransaction(
                walletId: fromWallet.id,
                fromWallet: from,
                toWallet: to,
                type: .transfer,
                amount: amount,
                description: description.isEmpty ? "Transfer from \(from.displayName) to \(to.displayName)" : description
            )
            
            // Update wallets
            if let fromIndex = wallets.firstIndex(where: { $0.id == fromWallet.id }) {
                wallets[fromIndex].balance -= amount
                wallets[fromIndex].availableBalance = max(0, wallets[fromIndex].balance - wallets[fromIndex].lockedBalance)
                wallets[fromIndex].updatedAt = Date()
            }
            
            if let toIndex = wallets.firstIndex(where: { $0.id == toWallet.id }) {
                wallets[toIndex].balance += amount
                wallets[toIndex].availableBalance = max(0, wallets[toIndex].balance - wallets[toIndex].lockedBalance)
                wallets[toIndex].updatedAt = Date()
            }
            
            // Add transaction
            await MainActor.run {
                transactions.insert(transaction, at: 0)
            }
            
            return true
        }
        
        func addBotProfit(amount: Double, botName: String, reference: String? = nil) async {
            guard let botEarningsWallet = botEarningsWallet else { return }
            
            let transaction = WalletTransaction(
                walletId: botEarningsWallet.id,
                toWallet: .botEarnings,
                type: .botProfit,
                amount: amount,
                description: "Profit from \(botName)",
                reference: reference,
                metadata: ["bot_name": botName]
            )
            
            if let walletIndex = wallets.firstIndex(where: { $0.id == botEarningsWallet.id }) {
                wallets[walletIndex].balance += amount
                wallets[walletIndex].availableBalance = max(0, wallets[walletIndex].balance - wallets[walletIndex].lockedBalance)
                wallets[walletIndex].updatedAt = Date()
                
                // Auto-lock if enabled
                if wallets[walletIndex].autoLockPercentage > 0 {
                    let lockAmount = amount * (wallets[walletIndex].autoLockPercentage / 100)
                    await lockFunds(amount: lockAmount, walletType: .botEarnings, automatic: true)
                }
            }
            
            await MainActor.run {
                transactions.insert(transaction, at: 0)
            }
        }
        
        func lockFunds(amount: Double, walletType: WalletType, automatic: Bool = false) async {
            guard let wallet = getWallet(type: walletType),
                  wallet.availableBalance >= amount else { return }
            
            let transaction = WalletTransaction(
                walletId: wallet.id,
                type: automatic ? .autoLock : .manualLock,
                amount: amount,
                description: automatic ? "Auto-locked funds" : "Manually locked funds"
            )
            
            if let walletIndex = wallets.firstIndex(where: { $0.id == wallet.id }) {
                wallets[walletIndex].lockedBalance += amount
                wallets[walletIndex].availableBalance = max(0, wallets[walletIndex].balance - wallets[walletIndex].lockedBalance)
                wallets[walletIndex].updatedAt = Date()
            }
            
            await MainActor.run {
                transactions.insert(transaction, at: 0)
            }
        }
        
        func unlockFunds(amount: Double, walletType: WalletType) async {
            guard let wallet = getWallet(type: walletType),
                  wallet.lockedBalance >= amount else { return }
            
            let transaction = WalletTransaction(
                walletId: wallet.id,
                type: .unlock,
                amount: amount,
                description: "Unlocked funds"
            )
            
            if let walletIndex = wallets.firstIndex(where: { $0.id == wallet.id }) {
                wallets[walletIndex].lockedBalance -= amount
                wallets[walletIndex].availableBalance = max(0, wallets[walletIndex].balance - wallets[walletIndex].lockedBalance)
                wallets[walletIndex].updatedAt = Date()
            }
            
            await MainActor.run {
                transactions.insert(transaction, at: 0)
            }
        }
        
        // MARK: - Deposit/Withdrawal
        
        func depositFunds(amount: Double, toWallet: WalletType, method: String) async -> Bool {
            guard let wallet = getWallet(type: toWallet) else { return false }
            
            let transaction = WalletTransaction(
                walletId: wallet.id,
                toWallet: toWallet,
                type: .deposit,
                amount: amount,
                description: "Deposit via \(method)",
                metadata: ["method": method]
            )
            
            if let walletIndex = wallets.firstIndex(where: { $0.id == wallet.id }) {
                wallets[walletIndex].balance += amount
                wallets[walletIndex].availableBalance = max(0, wallets[walletIndex].balance - wallets[walletIndex].lockedBalance)
                wallets[walletIndex].updatedAt = Date()
            }
            
            await MainActor.run {
                transactions.insert(transaction, at: 0)
            }
            
            return true
        }
        
        func withdrawFunds(amount: Double, fromWallet: WalletType, method: String, destination: String) async -> Bool {
            guard let wallet = getWallet(type: fromWallet),
                  wallet.availableBalance >= amount else { return false }
            
            let transaction = WalletTransaction(
                walletId: wallet.id,
                fromWallet: fromWallet,
                type: .withdrawal,
                amount: amount,
                description: "Withdrawal via \(method) to \(destination)",
                metadata: ["method": method, "destination": destination]
            )
            
            if let walletIndex = wallets.firstIndex(where: { $0.id == wallet.id }) {
                wallets[walletIndex].balance -= amount
                wallets[walletIndex].availableBalance = max(0, wallets[walletIndex].balance - wallets[walletIndex].lockedBalance)
                wallets[walletIndex].updatedAt = Date()
            }
            
            await MainActor.run {
                transactions.insert(transaction, at: 0)
            }
            
            return true
        }
    }
}

// MARK: - Sample Data

extension WalletModels.WalletTransaction {
    static let sampleTransactions: [WalletModels.WalletTransaction] = [
        WalletModels.WalletTransaction(
            walletId: UUID(),
            toWallet: .botEarnings,
            type: .botProfit,
            amount: 45.50,
            description: "Profit from GoldSniper-X1",
            reference: "TRADE_12345",
            metadata: ["bot_name": "GoldSniper-X1", "trade_id": "12345"]
        ),
        WalletModels.WalletTransaction(
            walletId: UUID(),
            fromWallet: .tradingFunds,
            toWallet: .botEarnings,
            type: .transfer,
            amount: 100.0,
            description: "Lock profits for security"
        ),
        WalletModels.WalletTransaction(
            walletId: UUID(),
            toWallet: .tradingFunds,
            type: .deposit,
            amount: 200.0,
            description: "Deposit via CashApp Bitcoin",
            metadata: ["method": "CashApp BTC"]
        ),
        WalletModels.WalletTransaction(
            walletId: UUID(),
            fromWallet: .botEarnings,
            type: .withdrawal,
            amount: 150.0,
            description: "Withdrawal to bank account",
            metadata: ["method": "Bank Transfer", "destination": "Chase ****1234"]
        ),
        WalletModels.WalletTransaction(
            walletId: UUID(),
            toWallet: .botEarnings,
            type: .botProfit,
            amount: 23.75,
            description: "Profit from TrendMaster-AI",
            reference: "TRADE_12346",
            metadata: ["bot_name": "TrendMaster-AI", "trade_id": "12346"]
        )
    ]
}

#Preview("Wallet Models") {
    NavigationView {
        VStack {
            Text("Wallet Models Preview")
                .font(.title)
                .padding()
            
            // This would be used in actual wallet views
            Spacer()
        }
    }
}