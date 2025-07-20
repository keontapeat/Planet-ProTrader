//
//  WithdrawalView.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 7/18/25.
//

import SwiftUI

struct WithdrawalView: View {
    @StateObject private var withdrawalManager = WithdrawalManager()
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedTab = 0
    @State private var withdrawalAmount = ""
    @State private var selectedMethod: WithdrawalRequest.WithdrawalMethod?
    @State private var showingAddMethod = false
    @State private var isProcessingWithdrawal = false
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
                
                VStack(spacing: 0) {
                    // Header
                    headerSection
                    
                    // Tab Selector
                    tabSelector
                    
                    // Content
                    TabView(selection: $selectedTab) {
                        // Withdraw Tab
                        withdrawTab
                            .tag(0)
                        
                        // History Tab
                        historyTab
                            .tag(1)
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                }
            }
            .navigationTitle("")
            .navigationBarHidden(true)
            .onAppear {
                startAnimations()
                loadWithdrawalMethods()
            }
        }
        .sheet(isPresented: $showingAddMethod) {
            AddWithdrawalMethodView()
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
                    Text("Withdraw Profits")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                    
                    Text("Cash out your trading profits")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button("Help") {
                    // Help action
                }
                .foregroundColor(DesignSystem.primaryGold)
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            
            // Available Balance
            UltraPremiumCard {
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("AVAILABLE TO WITHDRAW")
                            .font(.system(size: 11, weight: .black))
                            .foregroundColor(.secondary)
                        
                        Text("$8,247.93")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.green)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 6) {
                        Text("PROFIT THIS MONTH")
                            .font(.system(size: 11, weight: .black))
                            .foregroundColor(.secondary)
                        
                        HStack(spacing: 4) {
                            Image(systemName: "arrow.up.right")
                                .font(.system(size: 12, weight: .bold))
                            Text("+$3,892.47")
                                .font(.system(size: 16, weight: .bold))
                        }
                        .foregroundColor(.green)
                    }
                }
                .padding()
            }
            .padding(.horizontal, 20)
        }
        .scaleEffect(animateCards ? 1.0 : 0.95)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1), value: animateCards)
    }
    
    // MARK: - Tab Selector
    private var tabSelector: some View {
        HStack(spacing: 0) {
            Button(action: {
                withAnimation(.spring()) {
                    selectedTab = 0
                }
            }) {
                VStack(spacing: 8) {
                    Text("Withdraw")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(selectedTab == 0 ? DesignSystem.primaryGold : .secondary)
                    
                    Rectangle()
                        .fill(selectedTab == 0 ? DesignSystem.primaryGold : Color.clear)
                        .frame(height: 2)
                }
            }
            .frame(maxWidth: .infinity)
            
            Button(action: {
                withAnimation(.spring()) {
                    selectedTab = 1
                }
            }) {
                VStack(spacing: 8) {
                    Text("History")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(selectedTab == 1 ? DesignSystem.primaryGold : .secondary)
                    
                    Rectangle()
                        .fill(selectedTab == 1 ? DesignSystem.primaryGold : Color.clear)
                        .frame(height: 2)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .background(.regularMaterial)
    }
    
    // MARK: - Withdraw Tab
    private var withdrawTab: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Amount Input Section
                amountInputSection
                
                // Withdrawal Methods
                withdrawalMethodsSection
                
                // Transaction Summary
                if !withdrawalAmount.isEmpty, let amount = Double(withdrawalAmount), amount > 0 {
                    transactionSummarySection(amount: amount)
                }
                
                // Withdraw Button
                withdrawButton
                
                // Features Section
                featuresSection
                
                Spacer(minLength: 100)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
        }
    }
    
    // MARK: - Amount Input Section
    private var amountInputSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("💰 Withdrawal Amount")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
            
            UltraPremiumCard {
                VStack(spacing: 16) {
                    // Amount Input
                    HStack {
                        Text("$")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.primary)
                        
                        TextField("0.00", text: $withdrawalAmount)
                            .font(.system(size: 24, weight: .bold))
                            .keyboardType(.decimalPad)
                            .placeholder("Enter amount", when: withdrawalAmount.isEmpty)
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    // Quick Amount Buttons
                    HStack(spacing: 12) {
                        ForEach(["$100", "$500", "$1000", "Max"], id: \.self) { amount in
                            Button(action: {
                                if amount == "Max" {
                                    withdrawalAmount = "8247.93"
                                } else {
                                    withdrawalAmount = amount.replacingOccurrences(of: "$", with: "")
                                }
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
                    
                    // Limits
                    HStack {
                        Text("Min: $50")
                            .font(.system(size: 10))
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Text("Max: $8,247.93")
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
    
    // MARK: - Withdrawal Methods Section
    private var withdrawalMethodsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("🏦 Withdrawal Method")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                
                Spacer()
                
                Button("Add Method") {
                    showingAddMethod = true
                }
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(DesignSystem.primaryGold)
            }
            
            LazyVStack(spacing: 12) {
                ForEach(withdrawalManager.withdrawalMethods, id: \.displayName) { method in
                    WithdrawalMethodCard(
                        method: method,
                        isSelected: isMethodSelected(method),
                        onSelect: {
                            selectedMethod = method
                        }
                    )
                }
                
                if withdrawalManager.withdrawalMethods.isEmpty {
                    UltraPremiumCard {
                        VStack(spacing: 12) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 32))
                                .foregroundColor(DesignSystem.primaryGold)
                            
                            Text("Add Withdrawal Method")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.primary)
                            
                            Text("Add a bank account, Cash App, or other method to withdraw your profits")
                                .font(.system(size: 12))
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                            
                            Button("Get Started") {
                                showingAddMethod = true
                            }
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 8)
                            .background(DesignSystem.goldGradient)
                            .clipShape(Capsule())
                        }
                        .padding()
                    }
                }
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.95)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3), value: animateCards)
    }
    
    // MARK: - Transaction Summary Section
    private func transactionSummarySection(amount: Double) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("📊 Transaction Summary")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
            
            UltraPremiumCard {
                VStack(spacing: 12) {
                    SummaryRow(title: "Withdrawal Amount", value: String(format: "$%.2f", amount))
                    SummaryRow(title: "Processing Fee", value: calculateFee(amount: amount))
                    
                    Divider()
                    
                    SummaryRow(
                        title: "You'll Receive",
                        value: String(format: "$%.2f", amount - getFeeAmount(amount: amount)),
                        isHighlighted: true
                    )
                    
                    if let method = selectedMethod {
                        HStack {
                            Text("Processing Time:")
                                .font(.system(size: 12))
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            Text(method.processingTime)
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.green)
                        }
                    }
                }
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.95)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.4), value: animateCards)
    }
    
    // MARK: - Withdraw Button
    private var withdrawButton: some View {
        Button(action: {
            processWithdrawal()
        }) {
            HStack(spacing: 12) {
                if isProcessingWithdrawal {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.8)
                } else {
                    Image(systemName: "arrow.down.circle.fill")
                        .font(.system(size: 18, weight: .bold))
                }
                
                VStack(spacing: 2) {
                    Text(isProcessingWithdrawal ? "Processing Withdrawal..." : "Withdraw Funds")
                        .font(.system(size: 16, weight: .bold))
                    
                    if let amount = Double(withdrawalAmount), amount > 0, !isProcessingWithdrawal {
                        Text("Receive: \(String(format: "$%.2f", amount - getFeeAmount(amount: amount)))")
                            .font(.system(size: 12))
                    }
                }
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                canWithdraw ? 
                DesignSystem.goldGradient :
                Color.gray
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: canWithdraw ? DesignSystem.primaryGold.opacity(0.3) : .clear, radius: 8, x: 0, y: 4)
        }
        .disabled(!canWithdraw || isProcessingWithdrawal)
        .scaleEffect(canWithdraw ? 1.02 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: canWithdraw)
        .scaleEffect(animateCards ? 1.0 : 0.95)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.5), value: animateCards)
    }
    
    // MARK: - Features Section
    private var featuresSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("✨ Withdrawal Features")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                WithdrawalFeatureCard(
                    icon: "clock.fill",
                    title: "Fast Processing",
                    description: "Most withdrawals process instantly",
                    color: .blue
                )
                
                WithdrawalFeatureCard(
                    icon: "lock.shield.fill",
                    title: "Secure Transfer",
                    description: "Bank-level security",
                    color: .green
                )
                
                WithdrawalFeatureCard(
                    icon: "percent",
                    title: "Low Fees",
                    description: "Minimal processing costs",
                    color: .orange
                )
                
                WithdrawalFeatureCard(
                    icon: "checkmark.seal.fill",
                    title: "Guaranteed",
                    description: "100% success rate",
                    color: DesignSystem.primaryGold
                )
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.95)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.6), value: animateCards)
    }
    
    // MARK: - History Tab
    private var historyTab: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Summary Stats
                HStack(spacing: 12) {
                    StatCard(title: "Total Withdrawn", value: "$47,392", color: .green)
                    StatCard(title: "This Month", value: "$12,847", color: .blue)
                    StatCard(title: "Pending", value: "$0", color: .orange)
                }
                .padding(.horizontal, 20)
                
                // Withdrawal History
                LazyVStack(spacing: 12) {
                    ForEach(withdrawalManager.withdrawalHistory) { withdrawal in
                        WithdrawalHistoryCard(withdrawal: withdrawal)
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer(minLength: 100)
            }
            .padding(.top, 20)
        }
    }
    
    // MARK: - Helper Methods
    private func startAnimations() {
        withAnimation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.2)) {
            animateCards = true
        }
    }
    
    private func loadWithdrawalMethods() {
        withdrawalManager.loadWithdrawalMethods()
    }
    
    private func isMethodSelected(_ method: WithdrawalRequest.WithdrawalMethod) -> Bool {
        guard let selected = selectedMethod else { return false }
        return method.displayName == selected.displayName
    }
    
    private func calculateFee(amount: Double) -> String {
        return String(format: "$%.2f", getFeeAmount(amount: amount))
    }
    
    private func getFeeAmount(amount: Double) -> Double {
        // Example fee structure
        let percentageFee = amount * 0.005 // 0.5%
        let fixedFee = 2.99
        return max(percentageFee, fixedFee)
    }
    
    private var canWithdraw: Bool {
        guard let amount = Double(withdrawalAmount),
              amount >= 50 && amount <= 8247.93,
              selectedMethod != nil else {
            return false
        }
        return true
    }
    
    private func processWithdrawal() {
        guard let amount = Double(withdrawalAmount),
              let method = selectedMethod else {
            return
        }
        
        isProcessingWithdrawal = true
        
        Task {
            do {
                let withdrawal = try await withdrawalManager.processWithdrawal(
                    amount: amount,
                    method: method
                )
                
                await MainActor.run {
                    isProcessingWithdrawal = false
                    // Success handling
                    dismiss()
                }
            } catch {
                await MainActor.run {
                    isProcessingWithdrawal = false
                    // Error handling
                }
            }
        }
    }
}

// MARK: - Supporting Views

struct WithdrawalMethodCard: View {
    let method: WithdrawalRequest.WithdrawalMethod
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            UltraPremiumCard {
                HStack(spacing: 12) {
                    Image(systemName: method.systemImage)
                        .font(.system(size: 20))
                        .foregroundColor(isSelected ? DesignSystem.primaryGold : .primary)
                        .frame(width: 32)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(method.displayName)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.primary)
                        
                        Text(method.processingTime)
                            .font(.system(size: 11))
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                    }
                }
                .padding()
            }
        }
        .buttonStyle(PlainButtonStyle())
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? DesignSystem.primaryGold : Color.clear, lineWidth: 2)
        )
    }
}

struct SummaryRow: View {
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
                .font(.system(size: 12, weight: isHighlighted ? .semibold : .medium))
                .foregroundColor(isHighlighted ? .primary : .secondary)
            
            Spacer()
            
            Text(value)
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(isHighlighted ? DesignSystem.primaryGold : .primary)
        }
    }
}

struct WithdrawalFeatureCard: View {
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

struct WithdrawalHistoryCard: View {
    let withdrawal: WithdrawalRequest
    
    var body: some View {
        UltraPremiumCard {
            VStack(spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(withdrawal.withdrawalMethod.displayName)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.primary)
                        
                        Text(withdrawal.requestedAt, style: .date)
                            .font(.system(size: 11))
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text(withdrawal.formattedAmount)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.green)
                        
                        HStack(spacing: 4) {
                            Image(systemName: withdrawal.status.color == .green ? "checkmark.circle.fill" : "clock.fill")
                                .font(.system(size: 10))
                                .foregroundColor(withdrawal.status.color)
                            
                            Text(withdrawal.status.displayName)
                                .font(.system(size: 10, weight: .semibold))
                                .foregroundColor(withdrawal.status.color)
                        }
                    }
                }
            }
            .padding()
        }
    }
}

// MARK: - Withdrawal Manager
@MainActor
class WithdrawalManager: ObservableObject {
    @Published var withdrawalMethods: [WithdrawalRequest.WithdrawalMethod] = []
    @Published var withdrawalHistory: [WithdrawalRequest] = []
    @Published var isLoading = false
    
    func loadWithdrawalMethods() {
        // Simulate loading saved withdrawal methods
        withdrawalMethods = [
            .bankAccount(WithdrawalRequest.BankAccountDetails(
                accountName: "John Doe",
                routingNumber: "121000248",
                accountNumber: "****7890",
                accountType: "checking",
                bankName: "Chase Bank"
            )),
            .cashApp(WithdrawalRequest.CashAppDetails(
                cashTag: "$YourCashTag",
                displayName: "Cash App"
            ))
        ]
        
        // Load withdrawal history
        withdrawalHistory = [
            WithdrawalRequest(
                userId: "user123",
                amount: 1500.0,
                withdrawalMethod: .bankAccount(WithdrawalRequest.BankAccountDetails(
                    accountName: "John Doe",
                    routingNumber: "121000248",
                    accountNumber: "****7890",
                    accountType: "checking",
                    bankName: "Chase Bank"
                )),
                status: .completed,
                requestedAt: Date().addingTimeInterval(-86400),
                completedAt: Date().addingTimeInterval(-3600)
            ),
            WithdrawalRequest(
                userId: "user123",
                amount: 750.0,
                withdrawalMethod: .cashApp(WithdrawalRequest.CashAppDetails(
                    cashTag: "$YourCashTag",
                    displayName: "Cash App"
                )),
                status: .processing,
                requestedAt: Date().addingTimeInterval(-7200)
            )
        ]
    }
    
    func processWithdrawal(amount: Double, method: WithdrawalRequest.WithdrawalMethod) async throws -> WithdrawalRequest {
        // Simulate processing
        try await Task.sleep(nanoseconds: 2_000_000_000)
        
        let withdrawal = WithdrawalRequest(
            userId: "current_user",
            amount: amount,
            withdrawalMethod: method,
            status: .processing
        )
        
        withdrawalHistory.insert(withdrawal, at: 0)
        return withdrawal
    }
}

// MARK: - Add Withdrawal Method Sheet
struct AddWithdrawalMethodView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedMethodType = 0
    
    private let methodTypes = ["Bank Account", "Cash App", "Venmo", "Zelle", "PayPal"]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Text("Add Withdrawal Method")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top)
                
                Picker("Method Type", selection: $selectedMethodType) {
                    ForEach(0..<methodTypes.count, id: \.self) { index in
                        Text(methodTypes[index]).tag(index)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                // Method-specific form
                Group {
                    switch selectedMethodType {
                    case 0: BankAccountForm()
                    case 1: CashAppForm()
                    case 2: VenmoForm()
                    case 3: ZelleForm()
                    case 4: PayPalForm()
                    default: BankAccountForm()
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                VStack(spacing: 12) {
                    Button("Add Method") {
                        // Add method logic
                        dismiss()
                    }
                    .goldexButtonStyle()
                    
                    Button("Cancel") {
                        dismiss()
                    }
                    .goldexSecondaryButtonStyle()
                }
                .padding(.horizontal)
            }
            .navigationTitle("Add Method")
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

// MARK: - Method Forms
struct BankAccountForm: View {
    @State private var accountName = ""
    @State private var routingNumber = ""
    @State private var accountNumber = ""
    @State private var accountType = "checking"
    
    var body: some View {
        VStack(spacing: 16) {
            TextField("Account Holder Name", text: $accountName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("Routing Number", text: $routingNumber)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
            
            TextField("Account Number", text: $accountNumber)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
            
            Picker("Account Type", selection: $accountType) {
                Text("Checking").tag("checking")
                Text("Savings").tag("savings")
            }
            .pickerStyle(SegmentedPickerStyle())
        }
    }
}

struct CashAppForm: View {
    @State private var cashTag = ""
    
    var body: some View {
        VStack(spacing: 16) {
            TextField("$CashTag", text: $cashTag)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
}

struct VenmoForm: View {
    @State private var username = ""
    
    var body: some View {
        VStack(spacing: 16) {
            TextField("Venmo Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
}

struct ZelleForm: View {
    @State private var email = ""
    @State private var phone = ""
    
    var body: some View {
        VStack(spacing: 16) {
            TextField("Email Address", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.emailAddress)
            
            TextField("Phone Number (Optional)", text: $phone)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.phonePad)
        }
    }
}

struct PayPalForm: View {
    @State private var email = ""
    
    var body: some View {
        VStack(spacing: 16) {
            TextField("PayPal Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.emailAddress)
        }
    }
}

// MARK: - Extensions
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
        
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
    
    func placeholder(
        _ text: String,
        when shouldShow: Bool,
        alignment: Alignment = .leading) -> some View {
        
        placeholder(when: shouldShow, alignment: alignment) {
            Text(text).foregroundColor(.secondary)
        }
    }
}

#Preview {
    WithdrawalView()
}