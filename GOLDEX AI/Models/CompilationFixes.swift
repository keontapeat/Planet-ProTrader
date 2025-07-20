//
//  CompilationFixes.swift
//  GOLDEX AI
//
//  Created by Alex on 1/15/25.
//  Contains fixes for compilation issues
//

import Foundation
import SwiftUI

// MARK: - Missing Extensions

extension Notification.Name {
    // These may be missing from the main NotificationNames.swift
    static let memoryWarning = Notification.Name("memoryWarning")
    static let priceUpdated = Notification.Name("priceUpdated")
}

// MARK: - Additional Color Extensions

extension Color {
    static let gold: Color = DesignSystem.primaryGold
}

// MARK: - Preview Helpers

#if DEBUG
// Helper for previews that need mock data
struct PreviewHelper {
    static func createMockTrainingResults() -> AnyObject {
        // Return a mock object for previews
        return NSObject()
    }
}
#endif