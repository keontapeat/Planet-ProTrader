//
//  ContentView.swift
//  Planet ProTrader
//
//  Main content view - Fixes app compilation
//  Created by Alex AI Assistant
//

import SwiftUI

struct ContentView: View {
    @StateObject private var authManager = AuthenticationManager()
    @StateObject private var autoDebugSystem = AutoDebugSystem.shared
    @StateObject private var tradingViewModel = TradingViewModel()
    @StateObject private var realTimeAccountManager = RealTimeAccountManager()
    
    var body: some View {
        Group {
            if authManager.isAuthenticated {
                MainTabView()
                    .environmentObject(authManager)
                    .environmentObject(tradingViewModel)
                    .environmentObject(realTimeAccountManager)
            } else {
                WelcomeView()
                    .environmentObject(authManager)
            }
        }
        .onAppear {
            Task {
                await autoDebugSystem.startAutoDebugging()
            }
        }
    }
}

// MARK: - Preview

#Preview {
    ContentView()
        .preferredColorScheme(.light)
}