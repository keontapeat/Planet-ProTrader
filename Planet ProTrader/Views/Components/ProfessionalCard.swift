// ... existing code ...

struct ProfessionalCard<Content: View>: View {
    let content: () -> Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        content()
            .padding(20)
            .background(
                LinearGradient(
                    colors: [
                        Color.white.opacity(0.08),
                        Color.white.opacity(0.04)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.2),
                                Color.clear
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .shadow(
                color: Color.black.opacity(0.3),
                radius: 8,
                x: 0,
                y: 4
            )
    }
}

// MARK: - Preview

#Preview {
    ProfessionalCard {
        VStack(spacing: 16) {
            Text("Professional Card")
                .font(.headline)
                .foregroundColor(.white)
            
            Text("This is a professional card component used throughout the app")
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
        }
    }
    .padding()
    .preferredColorScheme(.dark)
}

// ... existing code ...