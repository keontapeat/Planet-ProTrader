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
                let now = timeline.date.timeIntervalSince1970
                for i in 0..<count {
                    let time = times[safe: i] ?? now
                    let p = positions[safe: i] ?? .zero
                    let offsetY = CGFloat(sin(now * speed + time * speed + Double(i))) * 12 + CGFloat(now * speed * 8)
                    let newPoint = CGPoint(
                        x: p.x,
                        y: (p.y + offsetY).truncatingRemainder(dividingBy: size.height + 12)
                    )
                    var star = context.resolveSymbol(id: i) ?? Path(ellipseIn: CGRect(origin: .zero, size: CGSize(width: radius, height: radius)))
                    context.fill(
                        star.offsetBy(dx: newPoint.x, dy: newPoint.y),
                        with: .color(color)
                    )
                }
            } symbols: {
                ForEach(0..<count, id: \.self) { _ in
                    Path(ellipseIn: CGRect(origin: .zero, size: CGSize(width: radius, height: radius)))
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
        return indices.contains(idx) ? self[idx] : nil
    }
}