//
//  ToastManager.swift
//  Planet ProTrader
//
//  Created by Senior iOS Engineer - Missing Dependency Fix
//

import SwiftUI

@MainActor
class ToastManager: ObservableObject {
    static let shared = ToastManager()
    
    @Published var isShowing = false
    @Published var message = ""
    @Published var type: ToastType = .info
    @Published var duration: Double = 3.0
    
    enum ToastType {
        case info
        case success
        case warning
        case error
        case trading
        
        var color: Color {
            switch self {
            case .info: return .blue
            case .success: return .green  
            case .warning: return .orange
            case .error: return .red
            case .trading: return .purple
            }
        }
        
        var icon: String {
            switch self {
            case .info: return "info.circle.fill"
            case .success: return "checkmark.circle.fill"
            case .warning: return "exclamationmark.triangle.fill"
            case .error: return "xmark.circle.fill"
            case .trading: return "chart.line.uptrend.xyaxis"
            }
        }
    }
    
    private init() {}
    
    func show(_ message: String, type: ToastType = .info, duration: Double = 3.0) {
        self.message = message
        self.type = type
        self.duration = duration
        
        withAnimation(.easeInOut) {
            isShowing = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            withAnimation(.easeInOut) {
                self.isShowing = false
            }
        }
    }
    
    func showSuccess(_ message: String) {
        show(message, type: .success)
    }
    
    func showWarning(_ message: String) {
        show(message, type: .warning)
    }
    
    func showError(_ message: String) {
        show(message, type: .error)
    }
    
    func showTrading(_ message: String) {
        show(message, type: .trading, duration: 5.0)
    }
    
    func hide() {
        withAnimation(.easeInOut) {
            isShowing = false
        }
    }
}

#Preview {
    VStack {
        Text("Toast Manager ✅")
            .font(.title.bold())
            .foregroundColor(.green)
        
        Text("Centralized toast notification system")
            .font(.caption)
            .foregroundColor(.secondary)
    }
}