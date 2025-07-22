//
//  Planet_ProTrader_AIApp.swift
//  Planet ProTrader
//
//  Created by Planet ProTrader Team
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct Planet_ProTrader_App: App {
    // Register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.light)
        }
    }
}

#Preview {
    // ✅ FIXED: Use proper preview content
    ContentView()
        .withCompleteEnvironment()
        .preferredColorScheme(.light)
}