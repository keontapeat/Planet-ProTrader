import SwiftUI

struct ContentView: View {
    @StateObject private var authManager = AuthenticationManager()
    @StateObject private var opusDebugger = OpusAutodebugService() // ADD OPUS POWER!
    
    var body: some View {
        Group {
            if authManager.isAuthenticated {
                MainTabView()
                    .overlay(
                        // ADD OPUS DEBUG INTERFACE
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                OpusDebugInterface()
                                    .frame(maxWidth: 300)
                                    .padding()
                            }
                        }
                        .allowsHitTesting(true)
                    )
            } else {
                WelcomeView()
            }
        }
        .onAppear {
            // AUTO-START OPUS WHEN APP LOADS!
            if authManager.isAuthenticated {
                opusDebugger.unleashOpusPower()
            }
        }
    }
}