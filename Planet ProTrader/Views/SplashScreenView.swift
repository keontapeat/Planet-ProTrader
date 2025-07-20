import SwiftUI
import AVFoundation

struct SplashScreenView: View {
    @State private var animate = false
    @State private var ripple = false
    @State private var showOnboarding = false
    @AppStorage("hasOnboarded") private var hasOnboarded: Bool = false

    var body: some View {
        ZStack {
            ParallaxStarsBackground()
            CometField(cometCount: 3)
            CosmicLightning()
            // Floating orbs/planets
            Group {
                Circle()
                    .fill(AngularGradient(colors: [.purple, .blue, .cyan], center: .center))
                    .frame(width: 122, height: 122)
                    .opacity(0.13)
                    .offset(x: -100, y: -120)
                    .blur(radius: animate ? 4 : 22)
                    .scaleEffect(animate ? 1.08 : 0.94)
                    .animation(.easeInOut(duration: 2.8).repeatForever(autoreverses: true), value: animate)
                
                Circle()
                    .fill(AngularGradient(colors: [.yellow, .orange, .pink], center: .center))
                    .frame(width: 88, height: 88)
                    .opacity(0.11)
                    .offset(x: 120, y: 140)
                    .blur(radius: animate ? 2 : 14)
                    .scaleEffect(animate ? 1.05 : 0.98)
                    .animation(.easeInOut(duration: 3.6).repeatForever(autoreverses: true), value: animate)
            }

            // Glowing center planet
            ZStack {
                Circle()
                    .fill(AngularGradient(
                        gradient: Gradient(colors: [.yellow, .cyan, .purple, .orange, .yellow]),
                        center: .center
                    ))
                    .frame(width: 250, height: 250)
                    .opacity(animate ? 0.19 : 0.13)
                    .scaleEffect(animate ? 1.2 : 1.0)
                    .blur(radius: 40)
                    .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: animate)

                Circle()
                    .fill(.ultraThinMaterial)
                    .frame(width: 170, height: 170)
                    .overlay(
                        Image(systemName: "globe.americas.fill")
                            .resizable()
                            .foregroundColor(.yellow)
                            .shadow(color: .yellow.opacity(0.45), radius: 20, x: 0, y: 12)
                            .aspectRatio(contentMode: .fit)
                            .padding(20)
                    )
                    .shadow(color: .orange, radius: 40)
            }
            .blur(radius: ripple ? 0 : 8)
            .opacity(animate ? 1 : 0)
            
            VStack(spacing: 36) {
                Spacer()
                Text("Planet ProTrader")
                    .font(.system(size: 44, weight: .heavy, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.yellow, .orange, .purple, .blue, .cyan],
                            startPoint: .leading, endPoint: .trailing
                        )
                    )
                    .shadow(color: .yellow.opacity(0.5), radius: 24, y: 4)
                    .opacity(animate ? 1 : 0)
                    .offset(y: animate ? 0 : 44)
                    .animation(.spring(response: 0.7, dampingFraction: 0.85), value: animate)

                Text("AI. Trading. Evolved.")
                    .font(.title.bold())
                    .foregroundColor(.white.opacity(0.93))
                    .shadow(radius: 10)
                    .opacity(animate ? 1 : 0)
                    .animation(.easeInOut(duration: 1.2).delay(0.3), value: animate)

                Spacer()
                Spacer()
            }
            
            if showOnboarding {
                OnboardingView()
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .opacity
                    ))
            }
        }
        .onAppear {
            animate = true
            ripple = true
            if !hasOnboarded {
                BackgroundAudioPlayer.shared.play(sound: "interstellar_theme.mp3")
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
                withAnimation(.spring(response: 0.7)) {
                    showOnboarding = true
                }
            }
        }
        .onChange(of: hasOnboarded) { _, newValue in
            if newValue == true {
                BackgroundAudioPlayer.shared.stop(fadeOut: true)
            }
        }
    }
}

#Preview {
    SplashScreenView()
}