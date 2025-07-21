//
//  Terminal.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 7/18/25.
//

import SwiftUI

struct Terminal: View {
    @StateObject private var chartData = ChartDataService.shared
    @State private var chartSettings = ChartSettings()
    @State private var selectedTimeframe: ChartTimeframe = .m15
    @State private var showingIndicators = false
    @State private var showingSettings = false
    @State private var showingTools = false
    @State private var showingNews = false
    @State private var isLandscape = false
    @State private var zoomScale: CGFloat = 1.0
    @State private var dragOffset: CGSize = .zero
    @State private var showCrosshair = false
    @State private var crosshairLocation: CGPoint = .zero
    @State private var showingAccountFunding = false
    
    // Chart dimensions
    @State private var chartHeight: CGFloat = 400
    @State private var chartWidth: CGFloat = 0
    
    // MARK: - Strategic UI Optimization for Maximum Screen Usage
    
    @State private var isCompactMode = false
    @State private var showMinimalUI = false
    @State private var autoHideControls = true
    @State private var lastInteractionTime = Date()
    
    @StateObject private var toastManager = ToastManager.shared
    
    var body: some View {
        NavigationView {
            ZStack {
                // Professional Terminal Background
                Rectangle()
                    .fill(LinearGradient(
                        colors: [Color.black, Color.gray.opacity(0.8)],
                        startPoint: .top,
                        endPoint: .bottom
                    ))
                    .overlay(
                        VStack(spacing: 20) {
                            // Terminal Header
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("💎 TRADING TERMINAL")
                                        .font(.title.bold())
                                        .foregroundColor(DesignSystem.primaryGold)
                                    
                                    Text("Professional Trading Interface")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                                
                                Button("Fund Account") {
                                    showingAccountFunding = true
                                }
                                .font(.subheadline.bold())
                                .foregroundColor(.black)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(DesignSystem.primaryGold)
                                .cornerRadius(8)
                            }
                            .padding(.horizontal)
                            
                            // Live Chart Area
                            VStack(spacing: 12) {
                                Text("📈")
                                    .font(.system(size: 80))
                                
                                Text("XAUUSD Live Chart")
                                    .font(.title.bold())
                                    .foregroundColor(.white)
                                
                                Text("Real-time market data")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                
                                // Live Price Display
                                HStack(spacing: 20) {
                                    VStack {
                                        Text("BID")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                        Text("2,045.23")
                                            .font(.title3.bold())
                                            .foregroundColor(.red)
                                    }
                                    
                                    VStack {
                                        Text("ASK")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                        Text("2,045.26")
                                            .font(.title3.bold())
                                            .foregroundColor(.green)
                                    }
                                    
                                    VStack {
                                        Text("SPREAD")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                        Text("0.3")
                                            .font(.title3.bold())
                                            .foregroundColor(.orange)
                                    }
                                }
                                .padding()
                                .background(Color.black.opacity(0.3))
                                .cornerRadius(12)
                            }
                            
                            Spacer()
                        }
                    )
                
                // Toast overlay
                if toastManager.isShowing {
                    ProfessionalToast(
                        message: toastManager.message,
                        type: toastManager.type,
                        duration: toastManager.duration,
                        isShowing: $toastManager.isShowing
                    )
                }
            }
            .navigationTitle("")
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingAccountFunding) {
            CardPaymentView()
        }
        .onAppear {
            startTerminalDemo()
        }
    }
    
    private func startTerminalDemo() {
        // Demo sequence for terminal
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            toastManager.showTrading("🤖 Quantum AI Pro: BUY XAUUSD @ 2,045.23")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            toastManager.showSuccess("✅ Take Profit Hit! +$247.50 profit")
        }
    }
}

// MARK: - Preview
#Preview {
    Terminal()
}
//  Created by AI Assistant on 7/18/25.
//

import SwiftUI

struct Terminal: View {
    @StateObject private var chartData = ChartDataService.shared
    @State private var chartSettings = ChartSettings()
    @State private var selectedTimeframe: ChartTimeframe = .m15
    @State private var showingIndicators = false
    @State private var showingSettings = false
    @State private var showingTools = false
    @State private var showingNews = false
    @State private var isLandscape = false
    @State private var zoomScale: CGFloat = 1.0
    @State private var dragOffset: CGSize = .zero
    @State private var showCrosshair = false
    @State private var crosshairLocation: CGPoint = .zero
    @State private var showingAccountFunding = false
    
    // Chart dimensions
    @State private var chartHeight: CGFloat = 400
    @State private var chartWidth: CGFloat = 0
    
    // MARK: - Strategic UI Optimization for Maximum Screen Usage
    
    @State private var isCompactMode = false
    @State private var showMinimalUI = false
    @State private var autoHideControls = true
    @State private var lastInteractionTime = Date()
    
    @StateObject private var toastManager = ToastManager.shared
    
    var body: some View {
        NavigationView {
            ZStack {
                // Professional Terminal Background
                Rectangle()
                    .fill(LinearGradient(
                        colors: [Color.black, Color.gray.opacity(0.8)],
                        startPoint: .top,
                        endPoint: .bottom
                    ))
                    .overlay(
                        VStack(spacing: 20) {
                            // Terminal Header
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("💎 TRADING TERMINAL")
                                        .font(.title.bold())
                                        .foregroundColor(DesignSystem.primaryGold)
                                    
                                    Text("Professional Trading Interface")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                                
                                Button("Fund Account") {
                                    showingAccountFunding = true
                                }
                                .font(.subheadline.bold())
                                .foregroundColor(.black)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(DesignSystem.primaryGold)
                                .cornerRadius(8)
                            }
                            .padding(.horizontal)
                            
                            // Live Chart Area
                            VStack(spacing: 12) {
                                Text("📈")
                                    .font(.system(size: 80))
                                
                                Text("XAUUSD Live Chart")
                                    .font(.title.bold())
                                    .foregroundColor(.white)
                                
                                Text("Real-time market data")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                
                                // Live Price Display
                                HStack(spacing: 20) {
                                    VStack {
                                        Text("BID")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                        Text("2,045.23")
                                            .font(.title3.bold())
                                            .foregroundColor(.red)
                                    }
                                    
                                    VStack {
                                        Text("ASK")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                        Text("2,045.26")
                                            .font(.title3.bold())
                                            .foregroundColor(.green)
                                    }
                                    
                                    VStack {
                                        Text("SPREAD")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                        Text("0.3")
                                            .font(.title3.bold())
                                            .foregroundColor(.orange)
                                    }
                                }
                                .padding()
                                .background(Color.black.opacity(0.3))
                                .cornerRadius(12)
                            }
                            
                            Spacer()
                        }
                    )
                
                // Toast overlay
                if toastManager.isShowing {
                    ProfessionalToast(
                        message: toastManager.message,
                        type: toastManager.type,
                        duration: toastManager.duration,
                        isShowing: $toastManager.isShowing
                    )
                }
            }
            .navigationTitle("")
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingAccountFunding) {
            CardPaymentView()
        }
        .onAppear {
            startTerminalDemo()
        }
    }
    
    private func startTerminalDemo() {
        // Demo sequence for terminal
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            toastManager.showTrading("🤖 Quantum AI Pro: BUY XAUUSD @ 2,045.23")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            toastManager.showSuccess("✅ Take Profit Hit! +$247.50 profit")
        }
    }
}

// MARK: - Preview
#Preview {
    Terminal()
}
