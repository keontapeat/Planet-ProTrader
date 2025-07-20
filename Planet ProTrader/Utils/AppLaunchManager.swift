//
//  AppLaunchManager.swift
//  GOLDEX AI
//
//  Created by Goldex AI on 7/19/25.
//

import SwiftUI
import Foundation

// MARK: - App Launch Manager
@MainActor
class AppLaunchManager: ObservableObject {
    static let shared = AppLaunchManager()
    
    @Published var hasInitialized = false
    private let autoDebugSystem = AutoDebugSystem.shared
    
    private init() {
        // Auto-initialize when app launches
        Task {
            await initializeAppSystems()
        }
    }
    
    private func initializeAppSystems() async {
        // Initialize auto debug system silently
        if !autoDebugSystem.isActive {
            await autoDebugSystem.startAutoDebugging()
        }
        
        // Initialize other background systems here if needed
        // await initializeOtherSystems()
        
        hasInitialized = true
        
        #if DEBUG
        print("🚀 [AppLaunch] All background systems initialized")
        #endif
    }
}

// MARK: - App Launch Extension
extension App {
    func initializeBackgroundSystems() {
        // This will auto-start the debug system
        let _ = AppLaunchManager.shared
    }
}