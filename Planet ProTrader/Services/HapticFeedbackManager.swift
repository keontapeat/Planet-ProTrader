//
//  HapticFeedbackManager.swift
//  Planet ProTrader
//
//  FIXED: Professional haptic feedback system
//  Created by AI Assistant on 1/25/25.
//

import UIKit
import SwiftUI

class HapticFeedbackManager {
    static let shared = HapticFeedbackManager()
    
    private init() {}
    
    // MARK: - Impact Feedback
    
    func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare()
        generator.impactOccurred()
    }
    
    func lightImpact() {
        impact(.light)
    }
    
    func mediumImpact() {
        impact(.medium)
    }
    
    func heavyImpact() {
        impact(.heavy)
    }
    
    // MARK: - Selection Feedback
    
    func selection() {
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
    }
    
    // MARK: - Notification Feedback
    
    func notification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }
    
    func success() {
        notification(.success)
    }
    
    func warning() {
        notification(.warning)
    }
    
    func error() {
        notification(.error)
    }
    
    // MARK: - Trading-Specific Feedback
    
    func tradeExecuted() {
        success()
    }
    
    func profitAlert() {
        // Double tap for profit
        DispatchQueue.main.async {
            self.success()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.lightImpact()
        }
    }
    
    func lossAlert() {
        // Different pattern for losses
        warning()
    }
    
    func signalGenerated() {
        mediumImpact()
    }
    
    func botStatusChanged() {
        selection()
    }
    
    func emergencyStop() {
        // Strong feedback for emergency stops
        heavyImpact()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.heavyImpact()
        }
    }
    
    // MARK: - Additional Feedback Methods
    
    func selectionChanged() {
        selection()
    }
}

// MARK: - SwiftUI View Extension

extension View {
    func hapticFeedback(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) -> some View {
        self.onTapGesture {
            HapticFeedbackManager.shared.impact(style)
        }
    }
    
    func hapticSelection() -> some View {
        self.onTapGesture {
            HapticFeedbackManager.shared.selection()
        }
    }
    
    func hapticSuccess() -> some View {
        self.onTapGesture {
            HapticFeedbackManager.shared.success()
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        Text(" Haptic Feedback Manager")
            .font(.title.bold())
            .foregroundColor(.green)
        
        Text("Professional haptic feedback system")
            .font(.subheadline)
            .foregroundColor(.secondary)
        
        VStack(spacing: 12) {
            Button("Light Impact") {
                HapticFeedbackManager.shared.lightImpact()
            }
            .buttonStyle(.borderedProminent)
            
            Button("Success Feedback") {
                HapticFeedbackManager.shared.success()
            }
            .buttonStyle(.borderedProminent)
            
            Button("Trading Profit Alert") {
                HapticFeedbackManager.shared.profitAlert()
            }
            .buttonStyle(.borderedProminent)
            .tint(.green)
        }
    }
    .padding()
    .background(Color(.systemGroupedBackground))
    .cornerRadius(12)
}