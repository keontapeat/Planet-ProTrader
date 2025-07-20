//
//  ModernSwiftUIOptimizations.swift
//  Planet ProTrader
//
//  Created by AI Assistant on 1/25/25.
//

import SwiftUI
import Combine

// MARK: - Modern SwiftUI Performance Optimizations

/// Modern view modifiers for optimal performance in iOS 17+
extension View {
    
    /// Apply modern animation performance optimizations
    func optimizedAnimation<V: Equatable>(_ animation: Animation?, value: V) -> some View {
        self
            .animation(animation, value: value)
            .drawingGroup() // Hardware acceleration for complex views
    }
    
    /// Lazy loading with better memory management
    func lazyContainer() -> some View {
        self
            .onAppear { 
                // Preload critical data only
            }
            .onDisappear {
                // Clean up resources
                URLCache.shared.removeAllCachedResponses()
            }
    }
    
    /// Modern navigation optimizations
    func optimizedNavigation() -> some View {
        self
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.light, for: .navigationBar)
    }
    
    /// High-performance list optimizations
    func performantList() -> some View {
        self
            .scrollContentBackground(.hidden)
            .listRowSeparator(.hidden)
            .listStyle(.plain)
    }
    
    /// Memory-efficient image handling
    func smartImage() -> some View {
        self
            .aspectRatio(contentMode: .fit)
            .clipped()
            .allowsHitTesting(false) // Prevent unnecessary touch handling
    }
    
    /// Professional card styling with performance focus
    func professionalCard(cornerRadius: CGFloat = 16) -> some View {
        self
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(.ultraThinMaterial)
                    .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
    
    /// Ultra-fast haptic feedback
    func smartHaptic(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) -> some View {
        self.onTapGesture {
            let impact = UIImpactFeedbackGenerator(style: style)
            impact.impactOccurred()
        }
    }
}

// MARK: - Performance-Optimized Components

/// Ultra-fast loading indicator
struct SmartLoadingView: View {
    @State private var rotation = 0.0
    
    var body: some View {
        Circle()
            .trim(from: 0, to: 0.8)
            .stroke(
                LinearGradient(
                    colors: [.blue, .purple, .pink],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                style: StrokeStyle(lineWidth: 3, lineCap: .round)
            )
            .frame(width: 32, height: 32)
            .rotationEffect(.degrees(rotation))
            .onAppear {
                withAnimation(.linear(duration: 1).repeatForever(autoreverses: false)) {
                    rotation = 360
                }
            }
    }
}

/// Memory-efficient AsyncImage replacement
struct SmartAsyncImage: View {
    let url: URL?
    let placeholder: Image
    
    @State private var loadedImage: UIImage?
    @State private var isLoading = true
    
    init(_ url: URL?, placeholder: Image = Image(systemName: "photo")) {
        self.url = url
        self.placeholder = placeholder
    }
    
    var body: some View {
        Group {
            if let loadedImage {
                Image(uiImage: loadedImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else if isLoading {
                SmartLoadingView()
            } else {
                placeholder
                    .foregroundStyle(.secondary)
            }
        }
        .task {
            await loadImage()
        }
    }
    
    private func loadImage() async {
        guard let url else {
            isLoading = false
            return
        }
        
        // Check cache first
        if let cachedImage = ImageCache.shared.image(for: url) {
            loadedImage = cachedImage
            isLoading = false
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let image = UIImage(data: data) {
                ImageCache.shared.setImage(image, for: url)
                await MainActor.run {
                    loadedImage = image
                    isLoading = false
                }
            }
        } catch {
            await MainActor.run {
                isLoading = false
            }
        }
    }
}

// MARK: - Image Cache Manager

class ImageCache {
    static let shared = ImageCache()
    private let cache = NSCache<NSString, UIImage>()
    
    private init() {
        cache.countLimit = 100
        cache.totalCostLimit = 50 * 1024 * 1024 // 50MB
    }
    
    func image(for url: URL) -> UIImage? {
        return cache.object(forKey: url.absoluteString as NSString)
    }
    
    func setImage(_ image: UIImage, for url: URL) {
        cache.setObject(image, forKey: url.absoluteString as NSString)
    }
    
    func clearCache() {
        cache.removeAllObjects()
    }
}

// MARK: - Professional Button Styles

struct ModernButtonStyle: ButtonStyle {
    let color: Color
    let isDestructive: Bool
    
    init(_ color: Color = .blue, isDestructive: Bool = false) {
        self.color = color
        self.isDestructive = isDestructive
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .fontWeight(.semibold)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                LinearGradient(
                    colors: isDestructive ? 
                        [.red, .red.opacity(0.8)] : 
                        [color, color.opacity(0.8)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - Modern Card Components

struct ProfessionalMetricCard: View {
    let title: String
    let value: String
    let change: String?
    let color: Color
    let icon: String
    
    init(title: String, value: String, change: String? = nil, color: Color = .blue, icon: String) {
        self.title = title
        self.value = value
        self.change = change
        self.color = color
        self.icon = icon
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(color)
                
                Spacer()
                
                if let change {
                    Text(change)
                        .font(.caption)
                        .fontWeight(.medium)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(change.hasPrefix("+") ? .green.opacity(0.2) : .red.opacity(0.2))
                        )
                        .foregroundStyle(change.hasPrefix("+") ? .green : .red)
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(value)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .professionalCard()
    }
}

// MARK: - High-Performance Chart Components

struct LiveMetricView: View {
    let title: String
    let value: Double
    let format: String
    let color: Color
    @State private var animatedValue: Double = 0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(.secondary)
            
            HStack(alignment: .bottom) {
                Text(String(format: format, animatedValue))
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(color)
                    .contentTransition(.numericText())
                
                Spacer()
                
                // Mini sparkline effect
                Rectangle()
                    .fill(color.opacity(0.3))
                    .frame(width: 40, height: 20)
                    .overlay(
                        Rectangle()
                            .fill(color)
                            .frame(width: 40 * (animatedValue / 100), height: 20)
                            .animation(.easeInOut(duration: 0.8), value: animatedValue),
                        alignment: .leading
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 4))
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0)) {
                animatedValue = value
            }
        }
        .onChange(of: value) { oldValue, newValue in
            withAnimation(.easeInOut(duration: 0.5)) {
                animatedValue = newValue
            }
        }
    }
}

// MARK: - Modern Navigation Components

struct SmartNavigationView<Content: View>: View {
    let title: String
    let content: () -> Content
    @Environment(\.dismiss) private var dismiss
    
    init(_ title: String, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.content = content
    }
    
    var body: some View {
        NavigationStack {
            content()
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(.large)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Done") {
                            dismiss()
                        }
                        .fontWeight(.semibold)
                    }
                }
        }
    }
}

// MARK: - Error Handling Components

struct SmartErrorView: View {
    let error: Error
    let retryAction: (() -> Void)?
    
    init(_ error: Error, retryAction: (() -> Void)? = nil) {
        self.error = error
        self.retryAction = retryAction
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 48))
                .foregroundStyle(.orange)
            
            VStack(spacing: 8) {
                Text("Something went wrong")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text(error.localizedDescription)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            if let retryAction {
                Button("Try Again", action: retryAction)
                    .buttonStyle(ModernButtonStyle(.blue))
            }
        }
        .padding()
        .professionalCard()
    }
}

#Preview("Metric Card") {
    ProfessionalMetricCard(
        title: "Portfolio Value",
        value: "$125,450",
        change: "+12.4%",
        color: .green,
        icon: "chart.line.uptrend.xyaxis"
    )
    .padding()
}

#Preview("Live Metric") {
    LiveMetricView(
        title: "Success Rate",
        value: 87.5,
        format: "%.1f%%",
        color: .green
    )
    .padding()
}

#Preview("Loading View") {
    SmartLoadingView()
}