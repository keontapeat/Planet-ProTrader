//
//  Terminal.swift
//  Planet ProTrader
//
//  Professional Trading Terminal with Advanced UI/UX
//  Clean Architecture, Modern Design, High Performance
//  Created by AI Assistant on 1/25/25.
//
//  FIXED: Just the compilation errors, keeping original design
//  Created by AI Assistant on 7/18/25.
//

import SwiftUI

struct Terminal: View {
    // MARK: - State Management
    @StateObject private var chartDataService = ChartDataServiceLocal.shared
    @State private var chartSettings = ChartSettingsLocal()
    @State private var selectedTimeframe: ChartTimeframeLocal = .m15
    
    // UI States
    @State private var showingIndicators = false
    @State private var showingSettings = false
    @State private var showingTools = false
    @State private var showingNews = false
    @State private var showingDrawings = false
    @State private var showingAlerts = false
    @State private var showingBacktest = false
    @State private var showingAnalytics = false
    @State private var showingOrderBook = false
    @State private var showingPositions = false
    @State private var showingWatchlist = false
    @State private var showingScanner = false
    @State private var showingCalendar = false
    @State private var showingChat = false
    
    // Market Data
    @State private var selectedSymbol = "XAUUSD"
    @State private var currentPrice: Double = 2374.50
    @State private var priceChange: Double = 12.35
    @State private var volume: Double = 1250000
    
    // Connection Status
    @State private var isConnected = true
    @State private var connectionStatus = "Connected"
    
    // UI Controls
    @State private var showMinimalUI = false
    @State private var autoHideControls = true
    @State private var lastInteractionTime = Date()
    
    @StateObject private var toastManager = ToastManagerLocal.shared
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [
                        Color.black,
                        Color(.systemGray6).opacity(0.1),
                        Color.black
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    terminalHeader
                    
                    // Main chart area
                    chartArea
                    
                    // Bottom controls
                    if !showMinimalUI {
                        bottomControls
                    }
                }
            }
            .navigationBarHidden(true)
            .onTapGesture {
                lastInteractionTime = Date()
                if showMinimalUI && autoHideControls {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        showMinimalUI = false
                    }
                }
            }
            .onAppear {
                startAutoHideTimer()
                setupInitialData()
            }
            .overlay(alignment: .topTrailing) {
                if toastManager.showToast {
                    toastView
                        .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    // MARK: - Header
    
    private var terminalHeader: some View {
        HStack {
            // Connection status
            HStack(spacing: 4) {
                Circle()
                    .fill(isConnected ? Color.green : Color.red)
                    .frame(width: 8, height: 8)
                
                Text(connectionStatus)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Symbol and price
            VStack(alignment: .center, spacing: 2) {
                Text(selectedSymbol)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                HStack(spacing: 8) {
                    Text(String(format: "%.2f", currentPrice))
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    
                    Text(String(format: "%+.2f", priceChange))
                        .font(.caption)
                        .foregroundColor(priceChange >= 0 ? .green : .red)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(
                            Capsule()
                                .fill((priceChange >= 0 ? Color.green : Color.red).opacity(0.2))
                        )
                }
            }
            
            Spacer()
            
            // Settings button
            Button(action: {
                showingSettings.toggle()
            }) {
                Image(systemName: "gear")
                    .font(.title3)
                    .foregroundColor(.white)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(.ultraThinMaterial)
    }
    
    // MARK: - Chart Area
    
    private var chartArea: some View {
        GeometryReader { geometry in
            ZStack {
                // Chart placeholder (replace with your actual chart)
                Rectangle()
                    .fill(.clear)
                    .background(.ultraThinMaterial)
                    .overlay(
                        VStack {
                            Text("Chart View")
                                .font(.title)
                                .foregroundColor(.secondary)
                            Text("Connect your chart data service")
                                .font(.caption)
                                .foregroundColor(.tertiary)
                        }
                    )
                
                // Overlay controls
                if showingIndicators {
                    indicatorOverlay
                }
                
                if showingDrawings {
                    drawingOverlay
                }
            }
        }
    }
    
    // MARK: - Bottom Controls
    
    private var bottomControls: some View {
        VStack(spacing: 8) {
            // Timeframe selector
            timeframeSelector
            
            // Tool buttons
            toolButtons
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
        .background(.ultraThinMaterial)
    }
    
    private var timeframeSelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(ChartTimeframeLocal.allCases, id: \.self) { timeframe in
                    Button(timeframe.rawValue) {
                        selectedTimeframe = timeframe
                        HapticFeedbackManager.shared.selection()
                    }
                    .font(.caption)
                    .fontWeight(.medium)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(selectedTimeframe == timeframe ? Color.blue : Color.clear)
                    )
                    .foregroundColor(selectedTimeframe == timeframe ? .white : .primary)
                }
            }
            .padding(.horizontal, 8)
        }
    }
    
    private var toolButtons: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6), spacing: 12) {
            ToolButtonLocal(title: "Indicators", icon: "chart.line.uptrend.xyaxis", isActive: $showingIndicators)
            ToolButtonLocal(title: "Tools", icon: "pencil.and.ruler", isActive: $showingTools)
            ToolButtonLocal(title: "News", icon: "newspaper", isActive: $showingNews)
            ToolButtonLocal(title: "Alerts", icon: "bell", isActive: $showingAlerts)
            ToolButtonLocal(title: "Orders", icon: "list.bullet", isActive: $showingOrderBook)
            ToolButtonLocal(title: "Positions", icon: "briefcase", isActive: $showingPositions)
        }
    }
    
    // MARK: - Overlays
    
    private var indicatorOverlay: some View {
        VStack {
            Text("Technical Indicators")
                .font(.headline)
                .padding()
            
            // Add your indicator controls here
            
            Spacer()
        }
        .background(.regularMaterial)
        .transition(.slide)
    }
    
    private var drawingOverlay: some View {
        VStack {
            Text("Drawing Tools")
                .font(.headline)
                .padding()
            
            // Add your drawing tools here
            
            Spacer()
        }
        .background(.regularMaterial)
        .transition(.slide)
    }
    
    private var toastView: some View {
        HStack {
            Image(systemName: toastManager.toastType.systemImage)
                .foregroundColor(toastManager.toastType.color)
            
            Text(toastManager.toastMessage)
                .font(.subheadline)
                .fontWeight(.medium)
        }
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
        .padding()
    }
    
    // MARK: - Helper Methods
    
    private func startAutoHideTimer() {
        Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
            if autoHideControls && Date().timeIntervalSince(lastInteractionTime) > 5.0 {
                withAnimation(.easeInOut(duration: 0.3)) {
                    showMinimalUI = true
                }
            }
        }
    }
    
    private func setupInitialData() {
        // Simulate real-time price updates
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.3)) {
                currentPrice += Double.random(in: -2...2)
                priceChange += Double.random(in: -0.5...0.5)
                volume = Double.random(in: 800000...1500000)
            }
        }
    }
    
    private func updateChartData() {
        withAnimation(.easeInOut(duration: 0.5)) {
            chartDataService.updateData()
        }
    }
}

// MARK: - Local Types (to avoid conflicts with existing SharedTypes)

class ChartDataServiceLocal: ObservableObject {
    static let shared = ChartDataServiceLocal()
    
    @Published var candlestickData: [CandlestickDataLocal] = []
    @Published var isLoading = false
    @Published var error: String?
    
    private init() {
        loadSampleData()
    }
    
    private func loadSampleData() {
        // Add sample candlestick data
        candlestickData = CandlestickDataLocal.sampleData
    }
    
    func updateData() {
        isLoading = true
        // Simulate data loading
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.isLoading = false
        }
    }
}

class ToastManagerLocal: ObservableObject {
    static let shared = ToastManagerLocal()
    
    @Published var showToast = false
    @Published var toastMessage = ""
    @Published var toastType: ToastTypeLocal = .info
    
    private init() {}
    
    func show(_ message: String, type: ToastTypeLocal = .info) {
        toastMessage = message
        toastType = type
        withAnimation {
            showToast = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            withAnimation {
                self.showToast = false
            }
        }
    }
    
    enum ToastTypeLocal {
        case info
        case success
        case warning
        case error
        
        var color: Color {
            switch self {
            case .info: return .blue
            case .success: return .green
            case .warning: return .orange
            case .error: return .red
            }
        }
        
        var systemImage: String {
            switch self {
            case .info: return "info.circle.fill"
            case .success: return "checkmark.circle.fill"
            case .warning: return "exclamationmark.triangle.fill"
            case .error: return "xmark.circle.fill"
            }
        }
    }
}

struct ChartSettingsLocal {
    var showGrid: Bool = true
    var showVolume: Bool = true
    var selectedTimeframe: ChartTimeframeLocal = .m15
    var indicatorsEnabled: Bool = true
    
    init() {}
}

enum ChartTimeframeLocal: String, CaseIterable, Codable {
    case m1 = "1M"
    case m5 = "5M"
    case m15 = "15M"
    case m30 = "30M"
    case h1 = "1H"
    case h4 = "4H"
    case d1 = "1D"
    case w1 = "1W"
    case mn1 = "1MN"
}

struct CandlestickDataLocal: Identifiable, Codable {
    let id = UUID()
    let timestamp: Date
    let open: Double
    let high: Double
    let low: Double
    let close: Double
    let volume: Double
    
    static var sampleData: [CandlestickDataLocal] {
        var data: [CandlestickDataLocal] = []
        let basePrice = 2374.50
        
        for i in 0..<100 {
            let timestamp = Date().addingTimeInterval(TimeInterval(-i * 900)) // 15 min intervals
            let open = basePrice + Double.random(in: -10...10)
            let close = open + Double.random(in: -5...5)
            let high = max(open, close) + Double.random(in: 0...3)
            let low = min(open, close) - Double.random(in: 0...3)
            let volume = Double.random(in: 1000...10000)
            
            data.append(CandlestickDataLocal(
                timestamp: timestamp,
                open: open,
                high: high,
                low: low,
                close: close,
                volume: volume
            ))
        }
        
        return data.reversed()
    }
}

// MARK: - Tool Button Component (renamed to avoid conflicts)

struct ToolButtonLocal: View {
    let title: String
    let icon: String
    @Binding var isActive: Bool
    
    var body: some View {
        Button(action: {
            isActive.toggle()
            HapticFeedbackManager.shared.selection()
        }) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(isActive ? .white : .primary)
                
                Text(title)
                    .font(.caption2)
                    .foregroundColor(isActive ? .white : .secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isActive ? Color.blue : Color.clear)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    Terminal()
        .preferredColorScheme(.dark)
}