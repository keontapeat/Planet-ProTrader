//
//  ErrorHandler.swift
//  Planet ProTrader
//
//  Created by Senior iOS Engineer on 1/25/25.
//

import Foundation
import SwiftUI
import os.log

// MARK: - App Errors

enum AppError: LocalizedError, Identifiable {
    case network(NetworkError)
    case trading(TradingError)
    case authentication(AuthError)
    case dataCorruption(String)
    case unknown(Error)
    
    var id: String {
        switch self {
        case .network: return "network"
        case .trading: return "trading"
        case .authentication: return "auth"
        case .dataCorruption: return "data"
        case .unknown: return "unknown"
        }
    }
    
    var errorDescription: String? {
        switch self {
        case .network(let error): return "Network Error: \(error.localizedDescription)"
        case .trading(let error): return "Trading Error: \(error.localizedDescription)"
        case .authentication(let error): return "Authentication Error: \(error.localizedDescription)"
        case .dataCorruption(let message): return "Data Error: \(message)"
        case .unknown(let error): return "Unknown Error: \(error.localizedDescription)"
        }
    }
}

enum NetworkError: LocalizedError {
    case noConnection
    case timeout
    case serverError(Int)
    case invalidResponse
    
    var errorDescription: String? {
        switch self {
        case .noConnection: return "No internet connection"
        case .timeout: return "Request timed out"
        case .serverError(let code): return "Server error (Code: \(code))"
        case .invalidResponse: return "Invalid server response"
        }
    }
}

enum TradingError: LocalizedError {
    case insufficientBalance
    case invalidSymbol
    case marketClosed
    case executionFailed
    
    var errorDescription: String? {
        switch self {
        case .insufficientBalance: return "Insufficient account balance"
        case .invalidSymbol: return "Invalid trading symbol"
        case .marketClosed: return "Market is currently closed"
        case .executionFailed: return "Trade execution failed"
        }
    }
}

enum AuthError: LocalizedError {
    case invalidCredentials
    case sessionExpired
    case accountLocked
    
    var errorDescription: String? {
        switch self {
        case .invalidCredentials: return "Invalid username or password"
        case .sessionExpired: return "Session expired. Please log in again"
        case .accountLocked: return "Account temporarily locked"
        }
    }
}

// MARK: - Error Handler

@MainActor
class ErrorHandler: ObservableObject {
    static let shared = ErrorHandler()
    
    @Published var currentError: AppError?
    @Published var showingError = false
    
    private let logger = Logger(subsystem: "com.planetprotrader.app", category: "errors")
    
    private init() {}
    
    func handle(_ error: Error) {
        let appError = mapToAppError(error)
        
        // Log the error
        logger.error("App Error: \(appError.localizedDescription)")
        
        // Report to AutoDebugSystem
        Task {
            await AutoDebugSystem.shared.logAppError(
                appError.id,
                message: appError.localizedDescription ?? "Unknown error"
            )
        }
        
        // Show to user if needed
        if shouldShowToUser(appError) {
            currentError = appError
            showingError = true
        }
    }
    
    private func mapToAppError(_ error: Error) -> AppError {
        if let appError = error as? AppError {
            return appError
        }
        
        // Map common system errors
        if let urlError = error as? URLError {
            switch urlError.code {
            case .notConnectedToInternet:
                return .network(.noConnection)
            case .timedOut:
                return .network(.timeout)
            default:
                return .network(.invalidResponse)
            }
        }
        
        return .unknown(error)
    }
    
    private func shouldShowToUser(_ error: AppError) -> Bool {
        switch error {
        case .network, .trading, .authentication:
            return true
        case .dataCorruption, .unknown:
            return false // Log only
        }
    }
    
    func dismissError() {
        currentError = nil
        showingError = false
    }
}

// MARK: - Error Alert Modifier

struct ErrorAlert: ViewModifier {
    @StateObject private var errorHandler = ErrorHandler.shared
    
    func body(content: Content) -> some View {
        content
            .alert("Error", isPresented: $errorHandler.showingError) {
                Button("OK") {
                    errorHandler.dismissError()
                }
            } message: {
                if let error = errorHandler.currentError {
                    Text(error.localizedDescription ?? "An unknown error occurred")
                }
            }
    }
}

extension View {
    func withErrorHandling() -> some View {
        self.modifier(ErrorAlert())
    }
}