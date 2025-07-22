//
//  ContentView.swift
//  Planet ProTrader
//
//  ✅ MAIN ENTRY POINT - Complete dependency injection and error handling
//  Professional Architecture with Latest SwiftUI Best Practices
//

import SwiftUI

struct ContentView: View {
    @StateObject private var dependencies = DependencyContainer.shared
    @State private var isInitialized = false
    @State private var showError = false
    @State private var errorMessage = ""

    var body: some View {
        Group {
            if !isInitialized {
                SplashScreenView()
                    .transition(.opacity)
            } else if dependencies.authService.isAuthenticated {
                MainTabView()
                    .environmentObject(dependencies.authService)
                    .environmentObject(dependencies.tradingViewModel)
                    .environmentObject(dependencies.realTimeAccountManager)
                    .environmentObject(dependencies.autoTradingManager)
                    .environmentObject(dependencies.brokerConnector)
                    .environmentObject(dependencies.realDataManager)
                    .environmentObject(dependencies.tradingBotManager)
                    .environmentObject(dependencies.toastManager)
                    .environmentObject(dependencies.performanceMonitor)
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
            } else {
                WelcomeView()
                    .environmentObject(dependencies.authService)
                    .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing)))
            }
        }
        .animation(.easeInOut(duration: 0.5), value: isInitialized)
        .animation(.easeInOut(duration: 0.3), value: dependencies.authService.isAuthenticated)
        .onAppear {
            initializeApp()
        }
        .alert("Initialization Error", isPresented: $showError) {
            Button("Retry") {
                initializeApp()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
        .preferredColorScheme(.light)
    }
    
    private func initializeApp() {
        Task { @MainActor in
            do {
                // Initialize core services
                try await dependencies.configureForProduction()
                
                // Auto-login for demo (remove in production)
                await dependencies.authService.signIn(username: "demo", password: "demo123")
                
                // Start background services
                await dependencies.autoDebugSystem.startAutoDebugging()
                
                withAnimation(.easeInOut(duration: 0.8)) {
                    isInitialized = true
                }
            } catch {
                errorMessage = error.localizedDescription
                showError = true
            }
        }
    }
}

#Preview("Light Mode") {
    ContentView()
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    ContentView()
        .preferredColorScheme(.dark)
}