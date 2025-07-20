//
//  PaymentModels.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 7/18/25.
//

import Foundation
import SwiftUI

// MARK: - Payment System Models

struct PaymentMethodModel: Identifiable, Codable {
    let id: UUID
    let type: PaymentType
    let displayName: String
    let lastFour: String
    let isActive: Bool
    let isDefault: Bool
    let addedAt: Date
    let expiresAt: Date?
    let provider: PaymentProvider
    
    enum PaymentType: String, Codable, CaseIterable {
        case debitCard = "debit_card"
        case creditCard = "credit_card"
        case bankAccount = "bank_account"
        case applePay = "apple_pay"
        case googlePay = "google_pay"
        case cashApp = "cash_app"
        case venmo = "venmo"
        case zelle = "zelle"
        case paypal = "paypal"
        case cryptoWallet = "crypto_wallet"
        
        var displayName: String {
            switch self {
            case .debitCard: return "Debit Card"
            case .creditCard: return "Credit Card"
            case .bankAccount: return "Bank Account"
            case .applePay: return "Apple Pay"
            case .googlePay: return "Google Pay"
            case .cashApp: return "Cash App"
            case .venmo: return "Venmo"
            case .zelle: return "Zelle"
            case .paypal: return "PayPal"
            case .cryptoWallet: return "Crypto Wallet"
            }
        }
        
        var systemImage: String {
            switch self {
            case .debitCard, .creditCard: return "creditcard.fill"
            case .bankAccount: return "building.columns.fill"
            case .applePay: return "apple.logo"
            case .googlePay: return "g.circle.fill"
            case .cashApp: return "dollarsign.square.fill"
            case .venmo: return "v.square.fill"
            case .zelle: return "z.square.fill"
            case .paypal: return "p.square.fill"
            case .cryptoWallet: return "bitcoinsign.circle.fill"
            }
        }
        
        var color: Color {
            switch self {
            case .debitCard: return .blue
            case .creditCard: return .purple
            case .bankAccount: return .green
            case .applePay: return .black
            case .googlePay: return .blue
            case .cashApp: return .green
            case .venmo: return .blue
            case .zelle: return .purple
            case .paypal: return .blue
            case .cryptoWallet: return .orange
            }
        }
    }
    
    enum PaymentProvider: String, Codable, CaseIterable {
        case ramp = "ramp"
        case transak = "transak"
        case moonpay = "moonpay"
        case coinbase = "coinbase"
        case stripe = "stripe"
        case plaid = "plaid"
        case dwolla = "dwolla"
        case ach = "ach"
        
        var displayName: String {
            switch self {
            case .ramp: return "Ramp"
            case .transak: return "Transak"
            case .moonpay: return "MoonPay"
            case .coinbase: return "Coinbase"
            case .stripe: return "Stripe"
            case .plaid: return "Plaid"
            case .dwolla: return "Dwolla"
            case .ach: return "ACH"
            }
        }
        
        var supportsCrypto: Bool {
            switch self {
            case .ramp, .transak, .moonpay, .coinbase: return true
            case .stripe, .plaid, .dwolla, .ach: return false
            }
        }
    }
    
    init(
        id: UUID = UUID(),
        type: PaymentType,
        displayName: String,
        lastFour: String,
        isActive: Bool = true,
        isDefault: Bool = false,
        addedAt: Date = Date(),
        expiresAt: Date? = nil,
        provider: PaymentProvider
    ) {
        self.id = id
        self.type = type
        self.displayName = displayName
        self.lastFour = lastFour
        self.isActive = isActive
        self.isDefault = isDefault
        self.addedAt = addedAt
        self.expiresAt = expiresAt
        self.provider = provider
    }
    
    var isExpired: Bool {
        guard let expiresAt = expiresAt else { return false }
        return Date() > expiresAt
    }
    
    var formattedDisplayName: String {
        return "\(displayName) ••••\(lastFour)"
    }
    
    static let samplePaymentMethods: [PaymentMethodModel] = [
        PaymentMethodModel(
            type: .debitCard,
            displayName: "Chase Debit",
            lastFour: "4242",
            isDefault: true,
            provider: .stripe
        ),
        PaymentMethodModel(
            type: .bankAccount,
            displayName: "Chase Checking",
            lastFour: "7890",
            provider: .plaid
        ),
        PaymentMethodModel(
            type: .applePay,
            displayName: "Apple Pay",
            lastFour: "1234",
            provider: .stripe
        )
    ]
}

struct FundingTransaction: Identifiable, Codable {
    let id: UUID
    let userId: String
    let paymentMethodId: UUID
    let amount: Double
    let currency: String
    let cryptoAmount: Double?
    let cryptoCurrency: String?
    let status: TransactionStatus
    let type: TransactionType
    let provider: PaymentMethodModel.PaymentProvider
    let fees: TransactionFees
    let exchangeRate: Double?
    let createdAt: Date
    let completedAt: Date?
    let failedAt: Date?
    let externalId: String?
    
    enum TransactionStatus: String, Codable, CaseIterable {
        case pending = "pending"
        case processing = "processing"
        case completed = "completed"
        case failed = "failed"
        case cancelled = "cancelled"
        case expired = "expired"
        case refunded = "refunded"
        
        var displayName: String {
            switch self {
            case .pending: return "Pending"
            case .processing: return "Processing"
            case .completed: return "Completed"
            case .failed: return "Failed"
            case .cancelled: return "Cancelled"
            case .expired: return "Expired"
            case .refunded: return "Refunded"
            }
        }
        
        var color: Color {
            switch self {
            case .pending: return .orange
            case .processing: return .blue
            case .completed: return .green
            case .failed, .cancelled, .expired: return .red
            case .refunded: return .purple
            }
        }
        
        var systemImage: String {
            switch self {
            case .pending: return "clock.fill"
            case .processing: return "arrow.2.circlepath"
            case .completed: return "checkmark.circle.fill"
            case .failed: return "xmark.circle.fill"
            case .cancelled: return "minus.circle.fill"
            case .expired: return "exclamationmark.triangle.fill"
            case .refunded: return "arrow.counterclockwise.circle.fill"
            }
        }
    }
    
    enum TransactionType: String, Codable, CaseIterable {
        case deposit = "deposit"
        case withdrawal = "withdrawal"
        case transfer = "transfer"
        case fee = "fee"
        case refund = "refund"
        case bonus = "bonus"
        
        var displayName: String {
            switch self {
            case .deposit: return "Deposit"
            case .withdrawal: return "Withdrawal"
            case .transfer: return "Transfer"
            case .fee: return "Fee"
            case .refund: return "Refund"
            case .bonus: return "Bonus"
            }
        }
    }
    
    struct TransactionFees: Codable {
        let processingFee: Double
        let networkFee: Double
        let exchangeFee: Double
        let totalFees: Double
        let feePercentage: Double
        
        init(processingFee: Double = 0.0, networkFee: Double = 0.0, exchangeFee: Double = 0.0) {
            self.processingFee = processingFee
            self.networkFee = networkFee
            self.exchangeFee = exchangeFee
            self.totalFees = processingFee + networkFee + exchangeFee
            self.feePercentage = 0.0 // Calculate based on amount
        }
        
        var formattedTotal: String {
            return String(format: "$%.2f", totalFees)
        }
    }
    
    init(
        id: UUID = UUID(),
        userId: String,
        paymentMethodId: UUID,
        amount: Double,
        currency: String = "USD",
        cryptoAmount: Double? = nil,
        cryptoCurrency: String? = nil,
        status: TransactionStatus = .pending,
        type: TransactionType,
        provider: PaymentMethodModel.PaymentProvider,
        fees: TransactionFees = TransactionFees(),
        exchangeRate: Double? = nil,
        createdAt: Date = Date(),
        completedAt: Date? = nil,
        failedAt: Date? = nil,
        externalId: String? = nil
    ) {
        self.id = id
        self.userId = userId
        self.paymentMethodId = paymentMethodId
        self.amount = amount
        self.currency = currency
        self.cryptoAmount = cryptoAmount
        self.cryptoCurrency = cryptoCurrency
        self.status = status
        self.type = type
        self.provider = provider
        self.fees = fees
        self.exchangeRate = exchangeRate
        self.createdAt = createdAt
        self.completedAt = completedAt
        self.failedAt = failedAt
        self.externalId = externalId
    }
    
    var formattedAmount: String {
        return String(format: "$%.2f", amount)
    }
    
    var formattedCryptoAmount: String {
        guard let cryptoAmount = cryptoAmount,
              let cryptoCurrency = cryptoCurrency else {
            return "N/A"
        }
        return String(format: "%.8f %@", cryptoAmount, cryptoCurrency)
    }
    
    var isComplete: Bool {
        return status == .completed
    }
    
    var isPending: Bool {
        return status == .pending || status == .processing
    }
    
    var netAmount: Double {
        return amount - fees.totalFees
    }
    
    var formattedNetAmount: String {
        return String(format: "$%.2f", netAmount)
    }
    
    static let sampleTransactions: [FundingTransaction] = [
        FundingTransaction(
            userId: "user123",
            paymentMethodId: UUID(),
            amount: 500.0,
            cryptoAmount: 0.0125,
            cryptoCurrency: "BTC",
            status: .completed,
            type: .deposit,
            provider: .ramp,
            fees: TransactionFees(processingFee: 5.0, networkFee: 2.5),
            exchangeRate: 40000.0,
            completedAt: Date().addingTimeInterval(-3600)
        ),
        FundingTransaction(
            userId: "user123",
            paymentMethodId: UUID(),
            amount: 250.0,
            status: .processing,
            type: .deposit,
            provider: .stripe,
            fees: TransactionFees(processingFee: 7.5)
        ),
        FundingTransaction(
            userId: "user123",
            paymentMethodId: UUID(),
            amount: 1000.0,
            status: .pending,
            type: .deposit,
            provider: .transak,
            fees: TransactionFees(processingFee: 15.0, exchangeFee: 10.0)
        )
    ]
}

struct WithdrawalRequest: Identifiable, Codable {
    let id: UUID
    let userId: String
    let amount: Double
    let currency: String
    let withdrawalMethod: WithdrawalMethod
    let status: WithdrawalStatus
    let fees: FundingTransaction.TransactionFees
    let requestedAt: Date
    let processedAt: Date?
    let completedAt: Date?
    let failedAt: Date?
    let failureReason: String?
    let externalId: String?
    
    enum WithdrawalMethod: Codable {
        case bankAccount(BankAccountDetails)
        case cashApp(CashAppDetails)
        case venmo(VenmoDetails)
        case zelle(ZelleDetails)
        case paypal(PayPalDetails)
        
        var displayName: String {
            switch self {
            case .bankAccount(let details):
                return details.displayName
            case .cashApp(let details):
                return details.displayName
            case .venmo(let details):
                return details.displayName
            case .zelle(let details):
                return details.displayName
            case .paypal(let details):
                return details.displayName
            }
        }
        
        var systemImage: String {
            switch self {
            case .bankAccount: return "building.columns.fill"
            case .cashApp: return "dollarsign.square.fill"
            case .venmo: return "v.square.fill"
            case .zelle: return "z.square.fill"
            case .paypal: return "p.square.fill"
            }
        }
        
        var processingTime: String {
            switch self {
            case .bankAccount: return "1-3 business days"
            case .cashApp: return "Instant"
            case .venmo: return "Instant"
            case .zelle: return "Minutes"
            case .paypal: return "1-2 hours"
            }
        }
    }
    
    struct BankAccountDetails: Codable {
        let accountName: String
        let routingNumber: String
        let accountNumber: String
        let accountType: String
        let bankName: String
        
        var displayName: String {
            return "\(bankName) (\(accountType.capitalized))"
        }
    }
    
    struct CashAppDetails: Codable {
        let cashTag: String
        let displayName: String
    }
    
    struct VenmoDetails: Codable {
        let username: String
        let displayName: String
    }
    
    struct ZelleDetails: Codable {
        let email: String
        let phone: String?
        
        var displayName: String {
            return "Zelle (\(email))"
        }
    }
    
    struct PayPalDetails: Codable {
        let email: String
        
        var displayName: String {
            return "PayPal (\(email))"
        }
    }
    
    enum WithdrawalStatus: String, Codable, CaseIterable {
        case pending = "pending"
        case approved = "approved"
        case processing = "processing"
        case completed = "completed"
        case failed = "failed"
        case cancelled = "cancelled"
        case rejected = "rejected"
        
        var displayName: String {
            switch self {
            case .pending: return "Pending Review"
            case .approved: return "Approved"
            case .processing: return "Processing"
            case .completed: return "Completed"
            case .failed: return "Failed"
            case .cancelled: return "Cancelled"
            case .rejected: return "Rejected"
            }
        }
        
        var color: Color {
            switch self {
            case .pending: return .orange
            case .approved: return .blue
            case .processing: return .blue
            case .completed: return .green
            case .failed, .cancelled, .rejected: return .red
            }
        }
    }
    
    init(
        id: UUID = UUID(),
        userId: String,
        amount: Double,
        currency: String = "USD",
        withdrawalMethod: WithdrawalMethod,
        status: WithdrawalStatus = .pending,
        fees: FundingTransaction.TransactionFees = FundingTransaction.TransactionFees(),
        requestedAt: Date = Date(),
        processedAt: Date? = nil,
        completedAt: Date? = nil,
        failedAt: Date? = nil,
        failureReason: String? = nil,
        externalId: String? = nil
    ) {
        self.id = id
        self.userId = userId
        self.amount = amount
        self.currency = currency
        self.withdrawalMethod = withdrawalMethod
        self.status = status
        self.fees = fees
        self.requestedAt = requestedAt
        self.processedAt = processedAt
        self.completedAt = completedAt
        self.failedAt = failedAt
        self.failureReason = failureReason
        self.externalId = externalId
    }
    
    var formattedAmount: String {
        return String(format: "$%.2f", amount)
    }
    
    var netAmount: Double {
        return amount - fees.totalFees
    }
    
    var formattedNetAmount: String {
        return String(format: "$%.2f", netAmount)
    }
    
    var isComplete: Bool {
        return status == .completed
    }
    
    var isPending: Bool {
        return status == .pending || status == .approved || status == .processing
    }
}

struct PaymentQuote: Identifiable, Codable {
    let id: UUID
    let amount: Double
    let currency: String
    let cryptoAmount: Double
    let cryptoCurrency: String
    let exchangeRate: Double
    let fees: FundingTransaction.TransactionFees
    let provider: PaymentMethodModel.PaymentProvider
    let expiresAt: Date
    let estimatedTime: String
    let createdAt: Date
    
    init(
        id: UUID = UUID(),
        amount: Double,
        currency: String = "USD",
        cryptoAmount: Double,
        cryptoCurrency: String = "BTC",
        exchangeRate: Double,
        fees: FundingTransaction.TransactionFees,
        provider: PaymentMethodModel.PaymentProvider,
        expiresAt: Date,
        estimatedTime: String,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.amount = amount
        self.currency = currency
        self.cryptoAmount = cryptoAmount
        self.cryptoCurrency = cryptoCurrency
        self.exchangeRate = exchangeRate
        self.fees = fees
        self.provider = provider
        self.expiresAt = expiresAt
        self.estimatedTime = estimatedTime
        self.createdAt = createdAt
    }
    
    var formattedAmount: String {
        return String(format: "$%.2f", amount)
    }
    
    var formattedCryptoAmount: String {
        return String(format: "%.8f %@", cryptoAmount, cryptoCurrency)
    }
    
    var formattedExchangeRate: String {
        return String(format: "$%.2f per %@", exchangeRate, cryptoCurrency)
    }
    
    var totalAmount: Double {
        return amount + fees.totalFees
    }
    
    var formattedTotalAmount: String {
        return String(format: "$%.2f", totalAmount)
    }
    
    var isExpired: Bool {
        return Date() > expiresAt
    }
    
    var timeRemaining: TimeInterval {
        return expiresAt.timeIntervalSinceNow
    }
    
    var formattedTimeRemaining: String {
        let minutes = Int(timeRemaining / 60)
        let seconds = Int(timeRemaining.truncatingRemainder(dividingBy: 60))
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 16) {
        Text("Payment Models")
            .font(.title)
            .fontWeight(.bold)
        
        ForEach(PaymentMethodModel.samplePaymentMethods.prefix(3)) { method in
            HStack {
                Image(systemName: method.type.systemImage)
                    .foregroundColor(method.type.color)
                    .frame(width: 24)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(method.formattedDisplayName)
                        .font(.system(size: 14, weight: .semibold))
                    
                    Text(method.provider.displayName)
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if method.isDefault {
                    Text("Default")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.green)
                        .clipShape(Capsule())
                }
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(10)
        }
    }
    .padding()
}