//
//  ProfessionalToast.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 1/21/25.
//

import SwiftUI

struct ProfessionalToast: View {
    let message: String
    let type: ToastType
    let duration: TimeInterval
    @Binding var isShowing: Bool
    
    @State private var offset: CGFloat = -100
    @State private var opacity: Double = 0
    
    var body: some View {
        VStack {
            HStack(spacing: 12) {
                Image(systemName: type.icon)
                    .font(.title3)
                    .foregroundColor(type.iconColor)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(type.title)
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text(message)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                
                Spacer()
                
                Button(action: { dismissToast() }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(type.borderColor, lineWidth: 1)
                    )
            )
            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 60)
        .offset(y: offset)
        .opacity(opacity)
        .onChange(of: isShowing) { showing in
            if showing {
                showToast()
            } else {
                hideToast()
            }
        }
    }
    
    private func showToast() {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            offset = 0
            opacity = 1
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            dismissToast()
        }
    }
    
    private func hideToast() {
        withAnimation(.spring(response: 0.4, dampingFraction: 1.0)) {
            offset = -100
            opacity = 0
        }
    }
    
    private func dismissToast() {
        isShowing = false
    }
}

enum ToastType {
    case success, warning, error, info, trading
    
    var title: String {
        switch self {
        case .success: return "Success"
        case .warning: return "Warning"
        case .error: return "Error"
        case .info: return "Info"
        case .trading: return "Trading Update"
        }
    }
    
    var icon: String {
        switch self {
        case .success: return "checkmark.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .error: return "xmark.circle.fill"
        case .info: return "info.circle.fill"
        case .trading: return "chart.line.uptrend.xyaxis"
        }
    }
    
    var iconColor: Color {
        switch self {
        case .success: return .green
        case .warning: return .orange
        case .error: return .red
        case .info: return .blue
        case .trading: return DesignSystem.primaryGold
        }
    }
    
    var borderColor: Color {
        return iconColor.opacity(0.3)
    }
}

// MARK: - Toast Manager

class ToastManager: ObservableObject {
    static let shared = ToastManager()
    
    @Published var isShowing = false
    @Published var message = ""
    @Published var type: ToastType = .info
    @Published var duration: TimeInterval = 3.0
    
    private init() {}
    
    func show(_ message: String, type: ToastType = .info, duration: TimeInterval = 3.0) {
        self.message = message
        self.type = type
        self.duration = duration
        self.isShowing = true
    }
    
    func showTrading(_ message: String) {
        show(message, type: .trading, duration: 2.0)
    }
    
    func showSuccess(_ message: String) {
        show(message, type: .success, duration: 2.0)
    }
    
    func showError(_ message: String) {
        show(message, type: .error, duration: 4.0)
    }
}

#Preview {
    ZStack {
        Color.gray.ignoresSafeArea()
        
        ProfessionalToast(
            message: "Bot 'Quantum AI Pro' opened a new BUY position on EUR/USD",
            type: .trading,
            duration: 3.0,
            isShowing: .constant(true)
        )
    }
}