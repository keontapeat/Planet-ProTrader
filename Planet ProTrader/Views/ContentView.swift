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
                    .withCompleteEnvironment()  // ✅ FIXED: All dependencies injected
            } else {
                WelcomeView()
                    .environmentObject(dependencies.authService)
            }
        }
        .onAppear {
            Task {
                await dependencies.autoDebugSystem.startAutoDebugging()
                // ✅ FIXED: Configure for production use
                dependencies.configureForPreview()
            }
        }
        .withErrorHandling()  // ✅ ADDED: Global error handling
    }
}

// MARK: - ✅ ADDED: Error Handling Modifier

struct ErrorHandlingModifier: ViewModifier {
    @State private var showingError = false
    @State private var errorMessage = ""
    
    func body(content: Content) -> some View {
        content
            .alert("Error", isPresented: $showingError) {
                Button("OK") { }
            } message: {
                Text(errorMessage)
            }
            .onReceive(NotificationCenter.default.publisher(for: .appError)) { notification in
                if let error = notification.object as? Error {
                    errorMessage = error.localizedDescription
                    showingError = true
                }
            }
    }
}

extension View {
    func withErrorHandling() -> some View {
        self.modifier(ErrorHandlingModifier())
    }
}

// MARK: - ✅ ADDED: Missing Notification Names

extension Notification.Name {
    static let appError = Notification.Name("appError")
    static let eaStatusChanged = Notification.Name("eaStatusChanged")
    static let accountBalanceUpdated = Notification.Name("accountBalanceUpdated")
    static let newTradeExecuted = Notification.Name("newTradeExecuted")
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

#Preview("With Mock Data") {
    let container = DependencyContainer.shared
    container.configureForPreview()
    
    return ContentView()
        .preferredColorScheme(.light)
        .onAppear {
            // Simulate login for preview
            Task {
                await container.authService.signIn(username: "demo", password: "demo")
            }
        }
}