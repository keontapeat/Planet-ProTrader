import SwiftUI

struct ContentView: View {
    @AppStorage("hasOnboarded") private var hasOnboarded: Bool = false

    var body: some View {
        Group {
            if hasOnboarded {
                // Replace this with your main real app view
                MainAppHomeView()
            } else {
                SplashScreenView()
            }
        }
        .animation(.easeInOut, value: hasOnboarded)
    }
}

// A dummy "main app" highly stylized placeholder/preview
struct MainAppHomeView: View {
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.black, .indigo, .purple, .yellow.opacity(0.6)]),
                           startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            VStack(spacing: 24) {
                Image(systemName: "star.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 140)
                    .foregroundColor(.yellow)
                    .shadow(color: .yellow, radius: 32)
                Text("Welcome to the Universe!")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                Text("Planet ProTrader Home")
                    .font(.title2)
                    .foregroundColor(.yellow)
            }
        }
    }
}

#Preview {
    ContentView()
}