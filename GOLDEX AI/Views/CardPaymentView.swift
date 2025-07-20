//
//  CardPaymentView.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 7/18/25.
//

import SwiftUI

struct CardPaymentView: View {
    @StateObject private var paymentManager = PaymentManager()
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedAmount = ""
    @State private var customAmount = ""
    @State private var selectedPaymentMethod: PaymentMethod?
    @State private var currentQuote: PaymentQuote?
    @State private var showingPaymentMethods = false
    @State private var showingAddPaymentMethod = false
    @State private var isProcessingPayment = false
    @State private var animateCards = false
    
    private let quickAmounts = ["$25", "$50", "$100", "$250", "$500", "$1000"]
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Premium Background
                LinearGradient(
                    colors: [
                        Color(.systemBackground),
                        DesignSystem.primaryGold.opacity(0.05),
                        Color(.systemBackground)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header Section
                        headerSection
                        
                        // Amount Selection
                        amountSelectionSection
                        
                        // Payment Method Selection
                        paymentMethodSection
                        
                        // Quote Display
                        if let quote = currentQuote {
                            quoteSection(quote)
                        }
                        
                        // Action Button
                        actionButton
                        
                        // Features & Benefits
                        featuresSection
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .navigationTitle("")
            .navigationBarHidden(true)
            .onAppear {
                startAnimations()
                loadPaymentMethods()
            }
        }
        .sheet(isPresented: $showingPaymentMethods) {
            PaymentMethodsView(selectedMethod: $selectedPaymentMethod)
        }
        .sheet(isPresented: $showingAddPaymentMethod) {
            AddPaymentMethodView()
        }
        .onChange(of: selectedAmount) { _ in
            updateQuote()
        }
        .onChange(of: customAmount) { _ in
            updateQuote()
        }
        .onChange(of: selectedPaymentMethod) { _ in
            updateQuote()
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
                    Text("Fund Trading Account")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                    
                    Text("Add funds instantly with any card")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Help button placeholder
                Button("Help") {
                    // Help action
                }
                .foregroundColor(DesignSystem.primaryGold)
            }
            .padding(.top, 8)
            
            // Balance Display
            UltraPremiumCard {
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("CURRENT BALANCE")
                            .font(.system(size: 11, weight: .black))
                            .foregroundColor(.secondary)
                        
                        Text("$2,547.83")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.primary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 6) {
                        Text("AVAILABLE CREDIT")
                            .font(.system(size: 11, weight: .black))
                            .foregroundColor(.secondary)
                        
                        Text("$97,452.17")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.green)
                    }
                }
                .padding()
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.95)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1), value: animateCards)
    }
    
    // MARK: - Amount Selection Section
    private var amountSelectionSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("💰 Select Amount")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
            
            UltraPremiumCard {
                VStack(spacing: 20) {
                    // Quick Amount Buttons
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 12) {
                        ForEach(quickAmounts, id: \.self) { amount in
                            Button(action: {
                                withAnimation(.spring()) {
                                    selectedAmount = amount
                                    customAmount = ""
                                }
                            }) {
                                Text(amount)
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(selectedAmount == amount ? .white : .primary)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(
                                        selectedAmount == amount ? 
                                        DesignSystem.goldGradient : 
                                        Color(.systemGray6)
                                    )
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                        }
                    }
                    
                    Divider()
                    
                    // Custom Amount Input
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Or enter custom amount")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.secondary)
                        
                        HStack {
                            Text("$")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.primary)
                            
                            TextField("0.00", text: $customAmount)
                                .font(.system(size: 18, weight: .bold))
                                .keyboardType(.decimalPad)
                                .onChange(of: customAmount) { _ in
                                    selectedAmount = ""
                                }
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    
                    // Amount Limits
                    HStack {
                        Text("Min: $10")
                            .font(.system(size: 10))
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Text("Max: $10,000")
                            .font(.system(size: 10))
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.95)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2), value: animateCards)
    }
    
    // MARK: - Payment Method Section
    private var paymentMethodSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("💳 Payment Method")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                
                Spacer()
                
                Button("Add New") {
                    showingAddPaymentMethod = true
                }
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(DesignSystem.primaryGold)
            }
            
            if let selectedMethod = selectedPaymentMethod {
                // Selected Payment Method
                UltraPremiumCard {
                    PaymentMethodRow(
                        method: selectedMethod,
                        isSelected: true,
                        showChangeButton: true
                    ) {
                        showingPaymentMethods = true
                    }
                }
            } else {
                // Select Payment Method
                Button(action: {
                    showingPaymentMethods = true
                }) {
                    UltraPremiumCard {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 24))
                                .foregroundColor(DesignSystem.primaryGold)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Select Payment Method")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.primary)
                                
                                Text("Choose from saved cards or add new")
                                    .font(.system(size: 12))
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                        }
                        .padding()
                    }
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.95)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3), value: animateCards)
    }
    
    // MARK: - Quote Section
    private func quoteSection(_ quote: PaymentQuote) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("📊 Transaction Quote")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                
                Spacer()
                
                if !quote.isExpired {
                    HStack(spacing: 4) {
                        Image(systemName: "clock.fill")
                            .font(.system(size: 10))
                        Text(quote.formattedTimeRemaining)
                            .font(.system(size: 11, weight: .bold))
                    }
                    .foregroundColor(.orange)
                }
            }
            
            UltraPremiumCard {
                VStack(spacing: 16) {
                    // Main Quote Display
                    VStack(spacing: 12) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("YOU PAY")
                                    .font(.system(size: 11, weight: .black))
                                    .foregroundColor(.secondary)
                                
                                Text(quote.formattedTotalAmount)
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.primary)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "arrow.right")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(DesignSystem.primaryGold)
                            
                            Spacer()
                            
                            VStack(alignment: .trailing, spacing: 4) {
                                Text("YOU GET")
                                    .font(.system(size: 11, weight: .black))
                                    .foregroundColor(.secondary)
                                
                                Text(quote.formattedCryptoAmount)
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(DesignSystem.primaryGold)
                            }
                        }
                        
                        Divider()
                        
                        // Quote Breakdown
                        VStack(spacing: 8) {
                            QuoteBreakdownRow(title: "Amount", value: quote.formattedAmount)
                            QuoteBreakdownRow(title: "Processing Fee", value: quote.fees.formattedTotal)
                            QuoteBreakdownRow(title: "Exchange Rate", value: quote.formattedExchangeRate, isHighlighted: true)
                            QuoteBreakdownRow(title: "Estimated Time", value: quote.estimatedTime)
                        }
                    }
                    
                    // Provider Badge
                    HStack {
                        Text("Powered by \(quote.provider.displayName)")
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Text("🔒 Secure & Encrypted")
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundColor(.green)
                    }
                }
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.95)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.4), value: animateCards)
    }
    
    // MARK: - Action Button
    private var actionButton: some View {
        VStack(spacing: 12) {
            Button(action: {
                processPayment()
            }) {
                HStack(spacing: 12) {
                    if isProcessingPayment {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(0.8)
                    } else {
                        Image(systemName: "creditcard.fill")
                            .font(.system(size: 18, weight: .bold))
                    }
                    
                    VStack(spacing: 2) {
                        Text(isProcessingPayment ? "Processing Payment..." : "Add Funds Now")
                            .font(.system(size: 16, weight: .bold))
                        
                        if let quote = currentQuote, !isProcessingPayment {
                            Text("Total: \(quote.formattedTotalAmount)")
                                .font(.system(size: 12))
                        }
                    }
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    canProcessPayment ? 
                    DesignSystem.goldGradient :
                    Color.gray
                )
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: canProcessPayment ? DesignSystem.primaryGold.opacity(0.3) : .clear, radius: 8, x: 0, y: 4)
            }
            .disabled(!canProcessPayment || isProcessingPayment)
            .scaleEffect(canProcessPayment ? 1.02 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: canProcessPayment)
            
            Text("🔐 256-bit SSL encryption • Instant processing • No hidden fees")
                .font(.system(size: 10))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .scaleEffect(animateCards ? 1.0 : 0.95)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.5), value: animateCards)
    }
    
    // MARK: - Features Section
    private var featuresSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("✨ Why Choose GOLDEX Funding")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                FeatureCard(
                    icon: "bolt.fill",
                    title: "Instant Deposits",
                    description: "Funds available immediately",
                    color: .blue
                )
                
                FeatureCard(
                    icon: "shield.checkerboard",
                    title: "Bank-Level Security",
                    description: "Your data is protected",
                    color: .green
                )
                
                FeatureCard(
                    icon: "percent",
                    title: "Low Fees",
                    description: "Competitive rates",
                    color: .orange
                )
                
                FeatureCard(
                    icon: "bitcoinsign.circle.fill",
                    title: "Bitcoin Backend",
                    description: "Automatic conversion",
                    color: DesignSystem.primaryGold
                )
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.95)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.6), value: animateCards)
    }
    
    // MARK: - Helper Methods
    private func startAnimations() {
        withAnimation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.2)) {
            animateCards = true
        }
    }
    
    private func loadPaymentMethods() {
        paymentManager.loadPaymentMethods()
        
        // Set default payment method
        if let defaultMethod = paymentManager.paymentMethods.first(where: { $0.isDefault }) {
            selectedPaymentMethod = defaultMethod
        }
    }
    
    private func updateQuote() {
        guard let amount = getSelectedAmount(),
              amount > 0,
              let paymentMethod = selectedPaymentMethod else {
            currentQuote = nil
            return
        }
        
        Task {
            currentQuote = await paymentManager.getQuote(
                amount: amount,
                paymentMethod: paymentMethod
            )
        }
    }
    
    private func getSelectedAmount() -> Double? {
        if !customAmount.isEmpty {
            return Double(customAmount)
        } else if !selectedAmount.isEmpty {
            let cleanAmount = selectedAmount.replacingOccurrences(of: "$", with: "").replacingOccurrences(of: ",", with: "")
            return Double(cleanAmount)
        }
        return nil
    }
    
    private var canProcessPayment: Bool {
        guard let amount = getSelectedAmount(),
              amount >= 10 && amount <= 10000,
              let _ = selectedPaymentMethod,
              let quote = currentQuote,
              !quote.isExpired else {
            return false
        }
        return true
    }
    
    private func processPayment() {
        guard let amount = getSelectedAmount(),
              let paymentMethod = selectedPaymentMethod,
              let quote = currentQuote else {
            return
        }
        
        isProcessingPayment = true
        
        Task {
            do {
                let transaction = try await paymentManager.processPayment(
                    amount: amount,
                    paymentMethod: paymentMethod,
                    quote: quote
                )
                
                // Success handling
                await MainActor.run {
                    isProcessingPayment = false
                    // Show success and dismiss
                    dismiss()
                }
            } catch {
                await MainActor.run {
                    isProcessingPayment = false
                    // Show error
                }
            }
        }
    }
}

// MARK: - Supporting Views

struct PaymentMethodRow: View {
    let method: PaymentMethod
    let isSelected: Bool
    let showChangeButton: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                Image(systemName: method.type.systemImage)
                    .font(.system(size: 20))
                    .foregroundColor(method.type.color)
                    .frame(width: 32)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(method.formattedDisplayName)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    HStack(spacing: 8) {
                        Text(method.provider.displayName)
                            .font(.system(size: 11))
                            .foregroundColor(.secondary)
                        
                        if method.isDefault {
                            Text("Default")
                                .font(.system(size: 9, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 4)
                                .padding(.vertical, 1)
                                .background(.green)
                                .clipShape(Capsule())
                        }
                    }
                }
                
                Spacer()
                
                if showChangeButton {
                    Text("Change")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(DesignSystem.primaryGold)
                } else if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                }
            }
            .padding()
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct QuoteBreakdownRow: View {
    let title: String
    let value: String
    let isHighlighted: Bool
    
    init(title: String, value: String, isHighlighted: Bool = false) {
        self.title = title
        self.value = value
        self.isHighlighted = isHighlighted
    }
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 12))
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.system(size: 12, weight: isHighlighted ? .bold : .medium))
                .foregroundColor(isHighlighted ? DesignSystem.primaryGold : .primary)
        }
    }
}

struct FeatureCard: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        UltraPremiumCard {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(color)
                
                Text(title)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                
                Text(description)
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.vertical, 8)
        }
    }
}

// MARK: - Payment Manager
@MainActor
class PaymentManager: ObservableObject {
    @Published var paymentMethods: [PaymentMethod] = []
    @Published var transactions: [FundingTransaction] = []
    @Published var isLoading = false
    
    func loadPaymentMethods() {
        // Simulate loading payment methods
        paymentMethods = PaymentMethod.samplePaymentMethods
    }
    
    func getQuote(amount: Double, paymentMethod: PaymentMethod) async -> PaymentQuote {
        // Simulate API call delay
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        let exchangeRate = Double.random(in: 38000...42000)
        let cryptoAmount = amount / exchangeRate
        let processingFee = amount * 0.015 // 1.5%
        let networkFee = 2.50
        
        return PaymentQuote(
            amount: amount,
            cryptoAmount: cryptoAmount,
            exchangeRate: exchangeRate,
            fees: FundingTransaction.TransactionFees(
                processingFee: processingFee,
                networkFee: networkFee
            ),
            provider: .ramp,
            expiresAt: Date().addingTimeInterval(300), // 5 minutes
            estimatedTime: "2-5 minutes"
        )
    }
    
    func processPayment(amount: Double, paymentMethod: PaymentMethod, quote: PaymentQuote) async throws -> FundingTransaction {
        // Simulate payment processing
        try await Task.sleep(nanoseconds: 3_000_000_000) // 3 seconds
        
        let transaction = FundingTransaction(
            userId: "current_user",
            paymentMethodId: paymentMethod.id,
            amount: amount,
            cryptoAmount: quote.cryptoAmount,
            cryptoCurrency: quote.cryptoCurrency,
            status: .completed,
            type: .deposit,
            provider: quote.provider,
            fees: quote.fees,
            exchangeRate: quote.exchangeRate,
            completedAt: Date()
        )
        
        transactions.append(transaction)
        return transaction
    }
}

// MARK: - Payment Methods Sheet
struct PaymentMethodsView: View {
    @Binding var selectedMethod: PaymentMethod?
    @Environment(\.dismiss) private var dismiss
    @StateObject private var paymentManager = PaymentManager()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Select Payment Method")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top)
                
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(paymentManager.paymentMethods) { method in
                            PaymentMethodRow(
                                method: method,
                                isSelected: selectedMethod?.id == method.id,
                                showChangeButton: false
                            ) {
                                selectedMethod = method
                                dismiss()
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
            }
            .navigationTitle("Payment Methods")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            paymentManager.loadPaymentMethods()
        }
    }
}

// MARK: - Add Payment Method Sheet
struct AddPaymentMethodView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var cardNumber = ""
    @State private var expiryDate = ""
    @State private var cvv = ""
    @State private var cardholderName = ""
    @State private var zipCode = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Text("Add Payment Method")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top)
                
                VStack(spacing: 16) {
                    TextField("Cardholder Name", text: $cardholderName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextField("Card Number", text: $cardNumber)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                    
                    HStack {
                        TextField("MM/YY", text: $expiryDate)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        TextField("CVV", text: $cvv)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                    }
                    
                    TextField("ZIP Code", text: $zipCode)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                }
                .padding(.horizontal)
                
                Spacer()
                
                VStack(spacing: 12) {
                    Button("Add Card") {
                        // Add card logic
                        dismiss()
                    }
                    .goldexButtonStyle()
                    .disabled(cardNumber.isEmpty || expiryDate.isEmpty || cvv.isEmpty)
                    
                    Button("Cancel") {
                        dismiss()
                    }
                    .goldexSecondaryButtonStyle()
                }
                .padding(.horizontal)
            }
            .navigationTitle("Add Card")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    CardPaymentView()
}