import SwiftUI

struct CometField: View {
    let cometCount: Int
    let duration: Double = 3.7
    @State private var resets: [Bool]
    
    init(cometCount: Int = 3) {
        self.cometCount = cometCount
        self._resets = State(initialValue: .init(repeating: false, count: cometCount))
    }
    
    var body: some View {
        ZStack {
            ForEach(0..<cometCount, id: \.self) { i in
                CometView(duration: duration, resetFlag: $resets[i])
                    .offset(x: CGFloat.random(in: -160...80),
                            y: CGFloat.random(in: -60...(UIScreen.main.bounds.height / 2)))
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 1.2) {
                            resets[i].toggle()
                        }
                    }
            }
        }
    }
}

private struct CometView: View {
    let duration: Double
    @Binding var resetFlag: Bool
    @State private var progress: CGFloat = -0.3
    
    var body: some View {
        GeometryReader { geo in
            Capsule()
                .fill(LinearGradient(
                    colors: [Color.white.opacity(0.15), Color.yellow.opacity(0.32), .clear],
                    startPoint: .leading, endPoint: .trailing
                ))
                .frame(width: 144, height: 4.9)
                .rotationEffect(.degrees(-23))
                .offset(x: geo.size.width * progress, y: 0)
                .onAppear { animate() }
                .onChange(of: resetFlag) { _, _ in
                    progress = -0.3
                    animate()
                }
        }
    }
    
    func animate() {
        withAnimation(.linear(duration: Double.random(in: duration*0.75...duration*1.18))) {
            progress = 1.18
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + duration + .random(in: 0...2.5)) {
            progress = -0.3
            animate()
        }
    }
}