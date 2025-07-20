import SwiftUI

struct SplashScreenView: View {
    @State private var animate = false
    @State private var transitionStep = 0
    @State private var isOnboardingActive = false
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: 24) {
                // EPIC SPACE PLANET IMAGE (save as "planet_trader_bg")
                Image("planet_trader_bg")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 270, height: 270)
                    .shadow(color: .yellow.opacity(0.7), radius: 50, y: 10)
                    .opacity(animate ? 1 : 0)
                    .scaleEffect(animate ? 1.1 : 0.8)
                    .animation(.spring(duration: 1.0), value: animate)
                
                Text("Planet ProTrader")
                    .font(.system(size: 48, weight: .heavy, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.yellow, .orange, .blue, .purple], 
                            startPoint: .topLeading, endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: .yellow.opacity(0.5), radius: 10)
                    .padding(.top, -16)
                
                if transitionStep > 0 {
                    Text("AI. Trading. Evolved.")
                        .font(.title.bold())
                        .foregroundColor(.white)
                        .opacity(animate ? 1 : 0)
                        .offset(y: animate ? 0 : 40)
                        .animation(.easeOut.delay(0.8), value: animate)
                }
                
                Spacer()
                
                if transitionStep > 1 {
                    ProgressView()
                        .scaleEffect(1.4)
                        .tint(.yellow)
                        .padding(.bottom, 30)
                }
            }
            .padding(.top, 64)
            .onAppear {
                withAnimation { animate = true }
                Timer.scheduledTimer(withTimeInterval: 1.2, repeats: false) { _ in
                    transitionStep = 1
                }
                Timer.scheduledTimer(withTimeInterval: 2.3, repeats: false) { _ in
                    transitionStep = 2
                    // Advance to onboarding after splash
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        withAnimation { isOnboardingActive = true }
                    }
                }
            }
            
            if isOnboardingActive {
                OnboardingView()
                    .transition(.asymmetric(insertion: .move(edge: .trailing).combined(with: .opacity),
                                            removal: .move(edge: .leading).combined(with: .opacity)))
            }
        }
    }
}

#Preview {
    SplashScreenView()
}