//
//  CardPaymentView.swift
//  GOLDEX AI - Ultra Premium Payment Interface
//
//  Created by AI Assistant on 7/18/25.
//

import SwiftUI

struct CardPaymentView: View {
    @StateObject private var paymentManager = PaymentManager()
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedAmount = ""
    @State private var customAmount = ""
    @State private var selectedPaymentMethod: PaymentMethodModel?
    @State private var currentQuote: PaymentQuote?
    @State private var showingPaymentMethods = false
    @State private var showingAddPaymentMethod = false
    @State private var isProcessingPayment = false
    @State private var animateCards = false
    @State private var pulseAnimation = false
    
    private let quickAmounts = ["$25", "$50", "$100", "$250", "$500", "$1000"]
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Premium Background with animated elements
                premiumBackground
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
    
    // MARK: - Premium Background
    private var premiumBackground: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(.systemBackground),
                    DesignSystem.primaryGold.opacity(0.08),
                    Color(.systemBackground).opacity(0.95),
                    DesignSystem.primaryGold.opacity(0.05)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            // Animated payment-themed orbs
            ForEach(0..<8, id: \.self) { index in
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                DesignSystem.primaryGold.opacity(0.15),
                                Color.green.opacity(0.1),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: 60
                        )
                    )
                    .frame(width: CGFloat.random(in: 60...120))
                    .offset(
                        x: CGFloat.random(in: -150...150),
                        y: CGFloat.random(in: -200...200)
                    )
                    .blur(radius: 15)
                    .animation(
                        .easeInOut(duration: Double.random(in: 8...15))
                        .repeatForever(autoreverses: true)
                        .delay(Double(index) * 0.3),
                        value: animateCards
                    )
            }
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 20) {
            HStack {
                Button(action: { dismiss() }) {
                    HStack(spacing: 6) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold))
                        Text("Cancel")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(spacing: 6) {
                    Text("💰 Fund Trading Account")
                        .font(.system(size: 22, weight: .black, design: .rounded))
                        .foregroundStyle(DesignSystem.goldGradient)
                    
                    Text("Add funds instantly with any card")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button("Help") {
                    // Help action
                }
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(DesignSystem.primaryGold)
            }
            .padding(.top, 8)
            
            // Enhanced Balance Display
            UltraPremiumCard {
                VStack(spacing: 16) {
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("CURRENT BALANCE")
                                .font(.system(size: 11, weight: .black))
                                .foregroundColor(.secondary)
                                .tracking(1)
                            
                            Text("$2,547.83")
                                .font(.system(size: 28, weight: .black, design: .monospaced))
                                .foregroundColor(.primary)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 8) {
                            Text("AVAILABLE CREDIT")
                                .font(.system(size: 11, weight: .black))
                                .foregroundColor(.secondary)
                                .tracking(1)
                            
                            Text("$97,452.17")
                                .font(.system(size: 18, weight: .bold, design: .monospaced))
                                .foregroundColor(.green)
                        }
                    }
                    
                    // Quick Stats Row
                    HStack(spacing: 20) {
                        QuickStat(title: "Today's P&L", value: "+$247", color: .green)
                        QuickStat(title: "Open Trades", value: "3", color: .blue)
                        QuickStat(title: "Buying Power", value: "4.2x", color: DesignSystem.primaryGold)
                    }
                }
                .padding(20)
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.95)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.1), value: animateCards)
    }
    
    // MARK: - Amount Selection Section
    private var amountSelectionSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("💳 Select Funding Amount")
                .font(.system(size: 20, weight: .black, design: .rounded))
                .foregroundColor(.primary)
            
            UltraPremiumCard {
                VStack(spacing: 24) {
                    // Quick Amount Buttons with enhanced styling
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 12) {
                        ForEach(quickAmounts, id: \.self) { amount in
                            Button(action: {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                    selectedAmount = amount
                                    customAmount = ""
                                }
                            }) {
                                VStack(spacing: 6) {
                                    Text(amount)
                                        .font(.system(size: 18, weight: .bold, design: .monospaced))
                                    
                                    Text("Quick")
                                        .font(.system(size: 10, weight: .semibold))
                                        .opacity(0.8)
                                }
                                .foregroundColor(selectedAmount == amount ? .white : .primary)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    ZStack {
                                        if selectedAmount == amount {
                                            LinearGradient(
                                                colors: [DesignSystem.primaryGold, DesignSystem.primaryGold.opacity(0.8)],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        } else {
                                            Color(.systemGray6)
                                        }
                                    }
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(selectedAmount == amount ? DesignSystem.primaryGold : Color.clear, lineWidth: 2)
                                )
                                .scaleEffect(selectedAmount == amount ? 1.05 : 1.0)
                                .shadow(
                                    color: selectedAmount == amount ? DesignSystem.primaryGold.opacity(0.3) : .clear,
                                    radius: 8,
                                    x: 0,
                                    y: 4
                                )
                            }
                        }
                    }
                    
                    // Elegant divider
                    HStack {
                        VStack { Divider() }
                        Text("OR")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                        VStack { Divider() }
                    }
                    
                    // Enhanced Custom Amount Input
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Enter Custom Amount")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.secondary)
                        
                        HStack(spacing: 12) {
                            Text("$")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(DesignSystem.primaryGold)
                            
                            TextField("0.00", text: $customAmount)
                                .font(.system(size: 24, weight: .bold, design: .monospaced))
                                .keyboardType(.decimalPad)
                                .onChange(of: customAmount) { _ in
                                    selectedAmount = ""
                                }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(!customAmount.isEmpty ? DesignSystem.primaryGold.opacity(0.5) : Color.gray.opacity(0.2), lineWidth: 2)
                        )
                    }
                    
                    // Amount Limits with enhanced styling
                    HStack {
                        HStack(spacing: 4) {
                            Image(systemName: "info.circle.fill")
                                .font(.system(size: 10))
                            Text("Min: $10")
                                .font(.system(size: 11, weight: .medium))
                        }
                        .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        HStack(spacing: 4) {
                            Text("Max: $10,000")
                                .font(.system(size: 11, weight: .medium))
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 10))
                        }
                        .foregroundColor(.secondary)
                    }
                }
                .padding(20)
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.95)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.2), value: animateCards)
    }
    
    // MARK: - Payment Method Section
    private var paymentMethodSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("💳 Payment Method")
                    .font(.system(size: 20, weight: .black, design: .rounded))
                    .foregroundColor(.primary)
                
                Spacer()
                
                Button(action: { showingAddPaymentMethod = true }) {
                    HStack(spacing: 4) {
                        Image(systemName: "plus.circle.fill")
                        Text("Add New")
                    }
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(DesignSystem.primaryGold)
                }
            }
            
            if let selectedMethod = selectedPaymentMethod {
                // Enhanced Selected Payment Method Display
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
                // Enhanced Select Payment Method Button
                Button(action: { showingPaymentMethods = true }) {
                    UltraPremiumCard {
                        HStack(spacing: 16) {
                            ZStack {
                                Circle()
                                    .fill(DesignSystem.primaryGold.opacity(0.2))
                                    .frame(width: 48, height: 48)
                                
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(DesignSystem.primaryGold)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Select Payment Method")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.primary)
                                
                                Text("Choose from saved cards or add new")
                                    .font(.system(size: 12))
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right.circle")
                                .font(.system(size: 20))
                                .foregroundColor(.secondary)
                        }
                        .padding(20)
                    }
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.95)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.3), value: animateCards)
    }
    
    // MARK: - Quote Section
    private func quoteSection(_ quote: PaymentQuote) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("📊 Transaction Quote")
                    .font(.system(size: 20, weight: .black, design: .rounded))
                    .foregroundColor(.primary)
                
                Spacer()
                
                if !quote.isExpired {
                    HStack(spacing: 6) {
                        Image(systemName: "clock.fill")
                            .font(.system(size: 12))
                        Text(quote.formattedTimeRemaining)
                            .font(.system(size: 12, weight: .bold, design: .monospaced))
                    }
                    .foregroundColor(.orange)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(.orange.opacity(0.1))
                    .clipShape(Capsule())
                }
            }
            
            UltraPremiumCard {
                VStack(spacing: 20) {
                    // Enhanced Main Quote Display
                    VStack(spacing: 16) {
                        HStack(alignment: .center) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("YOU PAY")
                                    .font(.system(size: 11, weight: .black))
                                    .foregroundColor(.secondary)
                                    .tracking(1)
                                
                                Text(quote.formattedTotalAmount)
                                    .font(.system(size: 28, weight: .black, design: .monospaced))
                                    .foregroundColor(.primary)
                            }
                            
                            Spacer()
                            
                            ZStack {
                                Circle()
                                    .fill(DesignSystem.primaryGold.opacity(0.2))
                                    .frame(width: 40, height: 40)
                                
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(DesignSystem.primaryGold)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing, spacing: 8) {
                                Text("YOU GET")
                                    .font(.system(size: 11, weight: .black))
                                    .foregroundColor(.secondary)
                                    .tracking(1)
                                
                                Text(quote.formattedCryptoAmount)
                                    .font(.system(size: 18, weight: .bold, design: .monospaced))
                                    .foregroundStyle(DesignSystem.goldGradient)
                            }
                        }
                        
                        // Enhanced divider with gradient
                        HStack {
                            VStack {
                                Rectangle()
                                    .fill(
                                        LinearGradient(
                                            colors: [.clear, .gray.opacity(0.3), .clear],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .frame(height: 1)
                            }
                        }
                        
                        // Enhanced Quote Breakdown
                        VStack(spacing: 12) {
                            QuoteBreakdownRow(title: "Amount", value: quote.formattedAmount)
                            QuoteBreakdownRow(title: "Processing Fee", value: quote.fees.formattedTotal)
                            QuoteBreakdownRow(title: "Exchange Rate", value: quote.formattedExchangeRate, isHighlighted: true)
                            QuoteBreakdownRow(title: "Est. Processing Time", value: quote.estimatedTime, icon: "clock")
                        }
                    }
                    
                    // Enhanced Provider Badge
                    HStack {
                        HStack(spacing: 6) {
                            Image(systemName: "checkmark.seal.fill")
                                .font(.system(size: 12))
                                .foregroundColor(.green)
                            
                            Text("Powered by \(quote.provider.displayName)")
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        HStack(spacing: 6) {
                            Image(systemName: "lock.shield.fill")
                                .font(.system(size: 12))
                                .foregroundColor(.green)
                            
                            Text("Bank-Level Security")
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundColor(.green)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(.green.opacity(0.05))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .padding(20)
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.95)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.4), value: animateCards)
    }
    
    // MARK: - Enhanced Action Button
    private var actionButton: some View {
        VStack(spacing: 16) {
            Button(action: {
                processPayment()
            }) {
                HStack(spacing: 12) {
                    if isProcessingPayment {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(0.9)
                    } else {
                        Image(systemName: "creditcard.and.123")
                            .font(.system(size: 20, weight: .bold))
                    }
                    
                    VStack(spacing: 2) {
                        Text(isProcessingPayment ? "Processing Payment..." : "💰 Add Funds Instantly")
                            .font(.system(size: 17, weight: .bold))
                        
                        if let quote = currentQuote, !isProcessingPayment {
                            Text("Total: \(quote.formattedTotalAmount)")
                                .font(.system(size: 13, weight: .medium))
                        }
                    }
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(
                    ZStack {
                        if canProcessPayment {
                            LinearGradient(
                                colors: [DesignSystem.primaryGold, DesignSystem.primaryGold.opacity(0.8)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        } else {
                            Color.gray.opacity(0.5)
                        }
                    }
                )
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(
                    color: canProcessPayment ? DesignSystem.primaryGold.opacity(0.4) : .clear,
                    radius: 12,
                    x: 0,
                    y: 6
                )
                .scaleEffect(pulseAnimation && canProcessPayment ? 1.02 : 1.0)
            }
            .disabled(!canProcessPayment || isProcessingPayment)
            .onAppear {
                withAnimation(.easeInOut(duration: 1.5).repeatForever()) {
                    pulseAnimation = true
                }
            }
            
            // Enhanced security message
            VStack(spacing: 8) {
                HStack(spacing: 4) {
                    Image(systemName: "lock.shield.fill")
                        .font(.system(size: 12))
                        .foregroundColor(.green)
                    Text("256-bit SSL encryption")
                        .font(.system(size: 11, weight: .semibold))
                    Text("•")
                        .foregroundColor(.secondary)
                    Text("Instant processing")
                        .font(.system(size: 11, weight: .semibold))
                    Text("•")
                        .foregroundColor(.secondary)
                    Text("No hidden fees")
                        .font(.system(size: 11, weight: .semibold))
                }
                .foregroundColor(.secondary)
                
                Text("🏆 Trusted by 100,000+ traders worldwide")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.secondary)
            }
            .multilineTextAlignment(.center)
        }
        .scaleEffect(animateCards ? 1.0 : 0.95)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.5), value: animateCards)
    }
    
    // MARK: - Enhanced Features Section
    private var featuresSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("✨ Why Traders Choose GOLDEX Funding")
                .font(.system(size: 20, weight: .black, design: .rounded))
                .foregroundColor(.primary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                FeatureCard(
                    icon: "bolt.circle.fill",
                    title: "Instant Deposits",
                    description: "Funds available in seconds",
                    color: .blue
                )
                
                FeatureCard(
                    icon: "shield.lefthalf.filled.badge.checkmark",
                    title: "Military-Grade Security",
                    description: "Your data is fortress-protected",
                    color: .green
                )
                
                FeatureCard(
                    icon: "percent.ar",
                    title: "Ultra-Low Fees",
                    description: "Best rates guaranteed",
                    color: .orange
                )
                
                FeatureCard(
                    icon: "bitcoinsign.circle.fill",
                    title: "Crypto Backend",
                    description: "Seamless BTC conversion",
                    color: DesignSystem.primaryGold
                )
                
                FeatureCard(
                    icon: "phone.badge.checkmark",
                    title: "24/7 Support",
                    description: "Expert help anytime",
                    color: .purple
                )
                
                FeatureCard(
                    icon: "chart.line.uptrend.xyaxis.circle.fill",
                    title: "Instant Trading",
                    description: "Start trading immediately",
                    color: .cyan
                )
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.95)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.6), value: animateCards)
    }
    
    // MARK: - Helper Methods
    private func startAnimations() {
        withAnimation(.spring(response: 1.0, dampingFraction: 0.8).delay(0.3)) {
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

// MARK: - Enhanced Supporting Views

struct QuickStat: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text(title.uppercased())
                .font(.system(size: 9, weight: .bold))
                .foregroundColor(.secondary)
                .tracking(0.5)
            
            Text(value)
                .font(.system(size: 13, weight: .bold, design: .monospaced))
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity)
    }
}

struct PaymentMethodRow: View {
    let method: PaymentMethodModel
    let isSelected: Bool
    let showChangeButton: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Enhanced payment method icon
                ZStack {
                    Circle()
                        .fill(method.type.color.opacity(0.2))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: method.type.systemImage)
                        .font(.system(size: 20))
                        .foregroundColor(method.type.color)
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(method.formattedDisplayName)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.primary)
                    
                    HStack(spacing: 8) {
                        Text(method.provider.displayName)
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                        
                        if method.isDefault {
                            Text("Default")
                                .font(.system(size: 9, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(.green)
                                .clipShape(Capsule())
                        }
                    }
                }
                
                Spacer()
                
                if showChangeButton {
                    Button("Change") {
                        onTap()
                    }
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(DesignSystem.primaryGold)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(DesignSystem.primaryGold.opacity(0.1))
                    .clipShape(Capsule())
                } else if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.green)
                }
            }
            .padding(20)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct QuoteBreakdownRow: View {
    let title: String
    let value: String
    let isHighlighted: Bool
    let icon: String?
    
    init(title: String, value: String, isHighlighted: Bool = false, icon: String? = nil) {
        self.title = title
        self.value = value
        self.isHighlighted = isHighlighted
        self.icon = icon
    }
    
    var body: some View {
        HStack {
            HStack(spacing: 6) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                }
                Text(title)
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(value)
                .font(.system(size: 13, weight: isHighlighted ? .bold : .medium))
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
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: icon)
                        .font(.system(size: 18))
                        .foregroundColor(color)
                }
                
                VStack(spacing: 4) {
                    Text(title)
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                    
                    Text(description)
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity)
        }
    }
}

// MARK: - Enhanced Payment Manager
@MainActor
class PaymentManager: ObservableObject {
    @Published var paymentMethods: [PaymentMethodModel] = []
    @Published var transactions: [FundingTransaction] = []
    @Published var isLoading = false
    
    func loadPaymentMethods() {
        // Simulate loading payment methods
        paymentMethods = PaymentMethodModel.samplePaymentMethods
    }
    
    func getQuote(amount: Double, paymentMethod: PaymentMethodModel) async -> PaymentQuote {
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
    
    func processPayment(amount: Double, paymentMethod: PaymentMethodModel, quote: PaymentQuote) async throws -> FundingTransaction {
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

// MARK: - Enhanced Payment Methods Sheet
struct PaymentMethodsView: View {
    @Binding var selectedMethod: PaymentMethodModel?
    @Environment(\.dismiss) private var dismiss
    @StateObject private var paymentManager = PaymentManager()
    @State private var animateList = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Premium background
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
                
                VStack(spacing: 24) {
                    Text("💳 Select Payment Method")
                        .font(.system(size: 24, weight: .black, design: .rounded))
                        .foregroundStyle(DesignSystem.goldGradient)
                        .padding(.top)
                    
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(Array(paymentManager.paymentMethods.enumerated()), id: \.element.id) { index, method in
                                UltraPremiumCard {
                                    PaymentMethodRow(
                                        method: method,
                                        isSelected: selectedMethod?.id == method.id,
                                        showChangeButton: false
                                    ) {
                                        selectedMethod = method
                                        dismiss()
                                    }
                                }
                                .scaleEffect(animateList ? 1.0 : 0.9)
                                .opacity(animateList ? 1.0 : 0.0)
                                .animation(
                                    .spring(response: 0.6, dampingFraction: 0.8)
                                    .delay(Double(index) * 0.1),
                                    value: animateList
                                )
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    Spacer()
                }
            }
            .navigationTitle("Payment Methods")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(DesignSystem.primaryGold)
                }
            }
        }
        .onAppear {
            paymentManager.loadPaymentMethods()
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.2)) {
                animateList = true
            }
        }
    }
}

// MARK: - Enhanced Add Payment Method Sheet
struct AddPaymentMethodView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var cardNumber = ""
    @State private var expiryDate = ""
    @State private var cvv = ""
    @State private var cardholderName = ""
    @State private var zipCode = ""
    @State private var animateForm = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Premium background
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
                        VStack(spacing: 16) {
                            ZStack {
                                Circle()
                                    .fill(DesignSystem.goldGradient)
                                    .frame(width: 80, height: 80)
                                
                                Image(systemName: "creditcard.and.123")
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            
                            Text("Add Payment Method")
                                .font(.system(size: 24, weight: .black, design: .rounded))
                                .foregroundStyle(DesignSystem.goldGradient)
                        }
                        .scaleEffect(animateForm ? 1.0 : 0.8)
                        .opacity(animateForm ? 1.0 : 0.0)
                        .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.1), value: animateForm)
                        
                        // Enhanced Form
                        UltraPremiumCard {
                            VStack(spacing: 20) {
                                PremiumTextField(
                                    title: "Cardholder Name",
                                    text: $cardholderName,
                                    icon: "person.circle.fill",
                                    placeholder: "John Doe"
                                )
                                
                                PremiumTextField(
                                    title: "Card Number",
                                    text: $cardNumber,
                                    icon: "creditcard.fill",
                                    placeholder: "1234 5678 9012 3456",
                                    keyboardType: .numberPad
                                )
                                
                                HStack(spacing: 16) {
                                    PremiumTextField(
                                        title: "Expiry Date",
                                        text: $expiryDate,
                                        icon: "calendar.circle.fill",
                                        placeholder: "MM/YY"
                                    )
                                    
                                    PremiumTextField(
                                        title: "CVV",
                                        text: $cvv,
                                        icon: "lock.circle.fill",
                                        placeholder: "123",
                                        keyboardType: .numberPad
                                    )
                                }
                                
                                PremiumTextField(
                                    title: "ZIP Code",
                                    text: $zipCode,
                                    icon: "location.circle.fill",
                                    placeholder: "90210",
                                    keyboardType: .numberPad
                                )
                            }
                            .padding(24)
                        }
                        .scaleEffect(animateForm ? 1.0 : 0.95)
                        .opacity(animateForm ? 1.0 : 0.0)
                        .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.2), value: animateForm)
                        
                        // Action buttons
                        VStack(spacing: 16) {
                            Button("💳 Add Payment Method") {
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
                        .scaleEffect(animateForm ? 1.0 : 0.95)
                        .opacity(animateForm ? 1.0 : 0.0)
                        .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.3), value: animateForm)
                    }
                    .padding()
                }
            }
            .navigationTitle("Add Card")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(DesignSystem.primaryGold)
                }
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.1)) {
                animateForm = true
            }
        }
    }
}

struct PremiumTextField: View {
    let title: String
    @Binding var text: String
    let icon: String
    let placeholder: String
    let keyboardType: UIKeyboardType
    
    init(title: String, text: Binding<String>, icon: String, placeholder: String, keyboardType: UIKeyboardType = .default) {
        self.title = title
        self._text = text
        self.icon = icon
        self.placeholder = placeholder
        self.keyboardType = keyboardType
    }
    
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
                .font(.system(size: 16, weight: .medium))
                .keyboardType(keyboardType)
                .padding(16)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(!text.isEmpty ? DesignSystem.primaryGold.opacity(0.5) : Color.gray.opacity(0.2), lineWidth: 2)
                )
        }
    }
}

#Preview("Light Mode") {
    CardPaymentView()
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    CardPaymentView()
        .preferredColorScheme(.dark)
}