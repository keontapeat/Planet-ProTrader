import SwiftUI

struct OnboardingStep: Identifiable {
    var id = UUID()
    var title: String
    var subtitle: String
    var iconSystem: String
    var gradient: [Color]

    static let all: [OnboardingStep] = [
        .init(title: "Welcome To Planet ProTrader",
              subtitle: "Trade across planets, assisted by AI signals sharper than a supernova.",
              iconSystem: "globe.asia.australia.fill",
              gradient: [.yellow, .orange, .purple, .cyan]),
        .init(title: "AI Signals, Real Wins 🔥",
              subtitle: "Hyper-accurate, custom risk. Our neural nets scan the universe nonstop.",
              iconSystem: "cpu.fill",
              gradient: [.purple, .blue, .cyan, .mint]),
        .init(title: "Advanced Analytics 📈",
              subtitle: "Visualize, forecast, and ride gold, crypto, and more with next-level insight.",
              iconSystem: "chart.bar.fill",
              gradient: [.yellow, .orange, .mint, .indigo]),
        .init(title: "Unleash Your Edge 🚀",
              subtitle: "Unlock your edge. Enter the future of mastery, speed, and clarity.",
              iconSystem: "bolt.fill",
              gradient: [.mint, .yellow, .orange, .pink])
    ]
}

struct OnboardingView: View {
    @State private var currentIndex = 0
    @State private var loaded = false
    @AppStorage("hasOnboarded") private var hasOnboarded: Bool = false

    let steps = OnboardingStep.all

    var body: some View {
        ZStack {
            RadialGradient(
                gradient: Gradient(colors: steps[currentIndex].gradient + [.black]),
                center: .center,
                startRadius: 10, endRadius: 500
            )
            .ignoresSafeArea()
            .animation(.easeInOut(duration: 1), value: currentIndex)
            VStack(spacing: 32) {
                Spacer()
                ZStack {
                    RoundedRectangle(cornerRadius: 42, style: .continuous)
                        .fill(.ultraThinMaterial)
                        .frame(width: 220, height: 220)
                        .shadow(color: steps[currentIndex].gradient.first!.opacity(0.55), radius: 22, y: 8)
                        .overlay(
                            Image(systemName: steps[currentIndex].iconSystem)
                                .resizable()
                                .scaledToFit()
                                .padding(38)
                                .foregroundStyle(
                                    LinearGradient(colors: steps[currentIndex].gradient, startPoint: .top, endPoint: .bottom)
                                )
                                .shadow(color: .yellow.opacity(0.15), radius: 10)
                        )
                        .scaleEffect(loaded ? 1.0 : 1.18)
                        .opacity(loaded ? 1 : 0)
                }
                .padding(.top, 24)
                .padding(.bottom, 6)
                Text(steps[currentIndex].title)
                    .font(.largeTitle.bold())
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
                    .shadow(color: .black.opacity(0.12), radius: 3)
                Text(steps[currentIndex].subtitle)
                    .font(.title3.weight(.medium))
                    .foregroundColor(.white.opacity(0.92))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                Spacer()
                HStack(spacing: 12) {
                    ForEach(steps.indices, id: \.self) { idx in
                        Capsule()
                            .frame(width: currentIndex == idx ? 26 : 10, height: 10)
                            .foregroundColor(currentIndex == idx ? .yellow : .gray.opacity(0.3))
                            .animation(.spring(response: 0.2), value: currentIndex)
                    }
                }
                .padding(.bottom, 10)
                Button(action: {
                    ButtonSFXPlayer.play() // SFX on button tap!
                    if currentIndex < steps.count - 1 {
                        withAnimation(.easeInOut) { currentIndex += 1 }
                    } else {
                        hasOnboarded = true
                    }
                }) {
                    HStack {
                        Text(currentIndex < steps.count - 1 ? "Next" : "Enter App 🚀")
                            .font(.title2.bold())
                        Image(systemName: currentIndex < steps.count - 1 ? "chevron.right" : "checkmark.seal.fill")
                    }
                    .padding()
                    .frame(maxWidth: 280)
                    .background(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(LinearGradient(
                                gradient: Gradient(colors: steps[currentIndex].gradient),
                                startPoint: .leading, endPoint: .trailing
                            ))
                            .shadow(color: .yellow.opacity(0.3), radius: 8, y: 5)
                    )
                    .foregroundColor(.black)
                }
                .padding(.bottom, 28)
            }
            .onAppear { loaded = true }
        }
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }
}

#Preview {
    OnboardingView()
}