import SwiftUI

struct ParallaxStarsBackground: View {
    private let layers: [StarLayer] = [
        StarLayer(count: 55, speed: 0.08, radius: 1.3, color: Color.white.opacity(0.35)),
        StarLayer(count: 24, speed: 0.20, radius: 2.0, color: Color.yellow.opacity(0.26)),
        StarLayer(count: 15, speed: 0.48, radius: 4.7, color: Color.purple.opacity(0.19))
    ]
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(layers) { layer in
                    StarParticles(
                        count: layer.count,
                        speed: layer.speed,
                        radius: layer.radius,
                        color: layer.color,
                        size: geo.size
                    )
                }
            }
            .ignoresSafeArea()
        }
    }
}

private struct StarLayer: Identifiable {
    let id = UUID()
    let count: Int
    let speed: Double
    let radius: CGFloat
    let color: Color
}

private struct StarParticles: View {
    let count: Int
    let speed: Double
    let radius: CGFloat
    let color: Color
    let size: CGSize
    
    @State private var positions: [CGPoint] = []
    @State private var times: [Double] = []
    
    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, _ in
                let now = timeline.date.timeIntervalSinceReferenceDate
                for i in 0..<count {
                    let baseTime = times[safe: i] ?? now
                    let basePos = positions[safe: i] ?? .zero
                    let yDrift = CGFloat((now + baseTime) * speed).truncatingRemainder(dividingBy: (size.height + 18))
                    let finalY = (basePos.y + yDrift).truncatingRemainder(dividingBy: size.height + 18)
                    let starRect = CGRect(x: basePos.x, y: finalY, width: radius, height: radius)
                    context.fill(Path(ellipseIn: starRect), with: .color(color))
                }
            }
        }
        .onAppear {
            positions = (0..<count).map { _ in
                CGPoint(x: .random(in: 0...size.width), y: .random(in: 0...size.height))
            }
            times = (0..<count).map { _ in Double.random(in: 0..<100) }
        }
    }
}

// Safe subscript to avoid out-of-bounds
fileprivate extension Array {
    subscript(safe idx: Int) -> Element? {
        indices.contains(idx) ? self[idx] : nil
    }
}