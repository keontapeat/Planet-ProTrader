//
//  ToastManager.swift
//  Planet ProTrader
//
//  Created by AI Assistant
//

import SwiftUI
import Foundation

enum ToastType {
    case success, warning, error, info, trading
    
    var color: Color {
        switch self {
        case .success: return .green
        case .warning: return .orange
        case .error: return .red
        case .info: return .blue
        case .trading: return DesignSystem.primaryGold
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
}

@MainActor
class ToastManager: ObservableObject {
    static let shared = ToastManager()
    
    @Published var isShowing = false
    @Published var message = ""
    @Published var type: ToastType = .info
    @Published var duration: Double = 3.0
    
    private var workItem: DispatchWorkItem?
    
    private init() {}
    
    func show(_ message: String, type: ToastType = .info, duration: Double = 3.0) {
        // Cancel previous toast
        workItem?.cancel()
        
        self.message = message
        self.type = type
        self.duration = duration
        
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            isShowing = true
        }
        
        // Auto-dismiss
        workItem = DispatchWorkItem {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                self.isShowing = false
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: workItem!)
    }
    
    func showSuccess(_ message: String, duration: Double = 3.0) {
        show(message, type: .success, duration: duration)
    }
    
    func showWarning(_ message: String, duration: Double = 3.0) {
        show(message, type: .warning, duration: duration)
    }
    
    func showError(_ message: String, duration: Double = 3.0) {
        show(message, type: .error, duration: duration)
    }
    
    func showTrading(_ message: String, duration: Double = 4.0) {
        show(message, type: .trading, duration: duration)
    }
    
    func dismiss() {
        workItem?.cancel()
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            isShowing = false
        }
    }
}

struct ProfessionalToast: View {
    let message: String
    let type: ToastType
    let duration: Double
    @Binding var isShowing: Bool
    
    @State private var progress: Double = 0
    
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                Spacer()
                
                HStack(spacing: 12) {
                    Image(systemName: type.icon)
                        .font(.title3)
                        .foregroundColor(type.color)
                    
                    Text(message)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)
                        .lineLimit(3)
                        .multilineTextAlignment(.leading)
                    
                    Button(action: {
                        isShowing = false
                    }) {
                        Image(systemName: "xmark")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.ultraThinMaterial)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(type.color.opacity(0.6), lineWidth: 1)
                        )
                )
                .overlay(
                    // Progress indicator
                    VStack {
                        Spacer()
                        
                        Rectangle()
                            .fill(type.color)
                            .frame(height: 2)
                            .scaleEffect(x: 1 - progress, y: 1, anchor: .leading)
                            .animation(.linear(duration: duration), value: progress)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                )
                .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                
                Spacer()
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 60)
        .transition(.asymmetric(
            insertion: .move(edge: .top).combined(with: .opacity),
            removal: .move(edge: .top).combined(with: .opacity)
        ))
        .onAppear {
            withAnimation(.linear(duration: duration)) {
                progress = 1.0
            }
        }
        .onTapGesture {
            isShowing = false
        }
    }
}