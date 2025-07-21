//
//  ContentView.swift
//  Planet ProTrader
//
//  Main content view - Fixes app compilation
//  Created by Alex AI Assistant
//

import SwiftUI

struct ContentView: View {
    @StateObject private var authManager = AuthenticationManager.shared
    @StateObject private var autoDebugSystem = AutoDebugSystem.shared
    
    var body: some View {
        Group {
            if authManager.isAuthenticated {
                MainTabView()
                    .environmentObject(authManager)
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

// MARK: - Authentication Manager Singleton Fix

extension AuthenticationManager {
    static let shared: AuthenticationManager = {
        let instance = AuthenticationManager()
        return instance
    }()
    
    convenience init() {
        self.init()
        // Initialize any additional properties here
    }
}

// MARK: - Preview

#Preview {
    ContentView()
        .preferredColorScheme(.light)
}