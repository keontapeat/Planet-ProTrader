import SwiftUI

struct CosmicLightning: View {
    @State private var showBolt = false
    @State private var zapAngle: Double = Double.random(in: 0...340)
    @State private var zapPos: CGPoint = .zero
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                if showBolt {
                    LightningShape()
                        .stroke(LinearGradient(colors: [.yellow, .orange, .white], startPoint: .top, endPoint: .bottom), lineWidth: 4)
                        .frame(width: 56, height: 130)
                        .rotationEffect(.degrees(zapAngle))
                        .position(zapPos)
                        .opacity(0.76)
                        .shadow(color: .yellow.opacity(0.9), radius: 40)
                        .transition(.scale(scale: 0.22, anchor: .center).combined(with: .opacity))
                        .animation(.easeInOut(duration: 0.22), value: showBolt)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.13) { showBolt = false }
                        }
                }
            }
            .onAppear {
                triggerZap(in: geo.size)
            }
            .onChange(of: showBolt) { _, active in
                if !active {
                    DispatchQueue.main.asyncAfter(deadline: .now() + .random(in: 1.7...4.5)) {
                        triggerZap(in: geo.size)
                    }
                }
            }
        }
        .allowsHitTesting(false)
    }
    
    func triggerZap(in size: CGSize) {
        zapAngle = Double.random(in: -35...80)
        zapPos = CGPoint(
            x: .random(in: 70...(size.width-70)),
            y: .random(in: 60...min(size.height-100, 370))
        )
        showBolt = true
    }
}

private struct LightningShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.width*0.61, y: 0))
        path.addLine(to: CGPoint(x: rect.width*0.19, y: rect.height*0.43))
        path.addLine(to: CGPoint(x: rect.width*0.42, y: rect.height*0.48))
        path.addLine(to: CGPoint(x: rect.width*0.22, y: rect.height*1.0))
        path.addLine(to: CGPoint(x: rect.width*0.81, y: rect.height*0.54))
        path.addLine(to: CGPoint(x: rect.width*0.57, y: rect.height*0.49))
        path.closeSubpath()
        return path
    }
}