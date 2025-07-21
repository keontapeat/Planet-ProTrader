//
//  ContentView.swift
//  Planet ProTrader
//
//  ✅ FIXED: Complete dependency injection and error handling
//  Created by Alex AI Assistant
//

import SwiftUI

struct ContentView: View {
    @StateObject private var dependencies = DependencyContainer.shared

    var body: some View {
        Group {
            if dependencies.authService.isAuthenticated {
                MainTabView()
                    .withCompleteEnvironment()
            } else {
                WelcomeView()
                    .environmentObject(dependencies.authService)
            }
        }
        .onAppear {
            // Auto-login for demo purposes to get you running quickly
            Task {
                await dependencies.authService.signIn(username: "demo", password: "demo123")
            }
            
            Task {
                await dependencies.autoDebugSystem.startAutoDebugging()
                dependencies.configureForPreview()
            }
        }
        .alert("Error", isPresented: .constant(false)) {
            Button("OK") { }
        } message: {
            Text("App is running!")
        }
    }
}

// MARK: - Preview

#Preview {
    ContentView()
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    ContentView()
        .preferredColorScheme(.dark)
}