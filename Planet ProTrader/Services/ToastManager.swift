//
//  ToastManager.swift
//  Planet ProTrader
//
//  ✅ TOAST MANAGER - Professional toast notification system
//

import SwiftUI

@MainActor
class ToastManager: ObservableObject {
    static let shared = ToastManager()
    
    @Published var showToast = false
    @Published var toastMessage = ""
    @Published var toastType: ToastType = .info
    
    private init() {}
    
    enum ToastType {
        case success, error, info, warning
        
        var color: Color {
            switch self {
            case .success: return .green
            case .error: return .red
            case .info: return .blue
            case .warning: return .orange
            }
        }
        
        var icon: String {
            switch self {
            case .success: return "checkmark.circle.fill"
            case .error: return "xmark.circle.fill"
            case .info: return "info.circle.fill"
            case .warning: return "exclamationmark.triangle.fill"
            }
        }
    }
    
    func show(_ message: String, type: ToastType = .info) {
        toastMessage = message
        toastType = type
        
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            showToast = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                self.showToast = false
            }
        }
    }
    
    func hide() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            showToast = false
        }
    }
}