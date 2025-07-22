//
//  TradingTerminal.swift
//  Planet ProTrader - Professional Trading Terminal
//
//  MARK: - Elite Trading Terminal
//  Complete rewrite with proper MVVM architecture
//  Created by Claude Doctor™
//

import SwiftUI
import Combine

// MARK: - Trading Terminal View Model

@MainActor
class TradingTerminalViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var selectedSymbol = "XAUUSD"
    @Published var currentPrice: Double = 2374.50
    @Published var priceChange: Double = 12.35
    @Published var priceChangePercent: Double = 0.52
    @Published var volume: Double = 1250000
    @Published var selectedTimeframe: ChartTimeframe = .m15
    @Published var isConnected = true
    @Published var connectionStatus = "Connected"
    @Published var candlestickData: [CandlestickPoint] = []
    @Published var isLoading = false
    @Published var error: String?
    
    // UI State
    @Published var showMinimalUI = false
    @Published var activeTools: Set<TradingTool> = []
    @Published var chartSettings = ChartSettings()
    
    // MARK: - Private Properties
    private var priceUpdateTimer: Timer?
    private var dataUpdateTimer: Timer?
    private var autoHideTimer: Timer?
    private var lastInteractionTime = Date()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Dependencies
    private let hapticManager = HapticFeedbackManager.shared
    private let toastManager = ToastManager.shared
    
    // MARK: - Initialization
    
    init() {
        setupInitialData()
        startRealTimeUpdates()
        setupAutoHideTimer()
    }
    
    deinit {
        stopAllTimers()
    }
    
    // MARK: - Public Methods
    
    func selectSymbol(_ symbol: String) {
        selectedSymbol = symbol
        refreshChartData()
        hapticManager.selection()
    }
    
    func selectTimeframe(_ timeframe: ChartTimeframe) {
        selectedTimeframe = timeframe
        refreshChartData()
        hapticManager.impact(.light)
    }
    
    func toggleTool(_ tool: TradingTool) {
        if activeTools.contains(tool) {
            activeTools.remove(tool)
        } else {
            activeTools.insert(tool)
        }
        hapticManager.selection()
    }
    
    func refreshChartData() {
        isLoading = true
        
        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.loadSampleData()
            self.isLoading = false
        }
    }
    
    func userDidInteract() {
        lastInteractionTime = Date()
        if showMinimalUI {
            withAnimation(.easeInOut(duration: 0.3)) {
                showMinimalUI = false
            }
        }
    }
    
    func toggleMinimalUI() {
        withAnimation(.easeInOut(duration: 0.3)) {
            showMinimalUI.toggle()
        }
    }
    
    func showToast(_ message: String, type: ToastType = .info) {
        toastManager.show(title: "Trading Terminal", message: message, type: type)
    }
    
    // MARK: - Private Methods
    
    private func setupInitialData() {
        loadSampleData()
    }
    
    private func startRealTimeUpdates() {
        // Price updates every second
        priceUpdateTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updatePrice()
        }
        
        // Chart data updates every 15 seconds
        dataUpdateTimer = Timer.scheduledTimer(withTimeInterval: 15.0, repeats: true) { [weak self] _ in
            self?.updateChartData()
        }
    }
    
    private func setupAutoHideTimer() {
        autoHideTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            if Date().timeIntervalSince(self.lastInteractionTime) > 5.0 {
                withAnimation(.easeInOut(duration: 0.3)) {
                    self.showMinimalUI = true
                }
            }
        }
    }
    
    private func updatePrice() {
        let volatility = 2.0
        let change = Double.random(in: -volatility...volatility)
        
        withAnimation(.easeInOut(duration: 0.3)) {
            currentPrice += change
            priceChange += change * 0.1
            priceChangePercent = (priceChange / (currentPrice - priceChange)) * 100
            volume = Double.random(in: 800000...1500000)
            
            // Simulate connection status changes
            if Double.random(in: 0...1) > 0.95 {
                isConnected.toggle()
                connectionStatus = isConnected ? "Connected" : "Reconnecting..."
            }
        }
    }
    
    private func updateChartData() {
        // Add new candlestick point
        let newPoint = CandlestickPoint(
            timestamp: Date(),
            open: currentPrice,
            high: currentPrice + Double.random(in: 0...3),
            low: currentPrice - Double.random(in: 0...3),
            close: currentPrice + Double.random(in: -2...2),
            volume: volume
        )
        
        withAnimation(.easeInOut(duration: 0.5)) {
            candlestickData.append(newPoint)
            
            // Keep only last 200 points for performance
            if candlestickData.count > 200 {
                candlestickData.removeFirst()
            }
        }
    }
    
    private func loadSampleData() {
        candlestickData = CandlestickPoint.generateSampleData(count: 100, basePrice: currentPrice)
    }
    
    private func stopAllTimers() {
        priceUpdateTimer?.invalidate()
        dataUpdateTimer?.invalidate()
        autoHideTimer?.invalidate()
        priceUpdateTimer = nil
        dataUpdateTimer = nil
        autoHideTimer = nil
    }
}

// MARK: - Trading Terminal View

struct TradingTerminal: View {
    // MARK: - Properties
    @StateObject private var viewModel = TradingTerminalViewModel()
    @State private var showingSettings = false
    
    // MARK: - Body
    var body: some View {
        ZStack {
            // Background
            terminalBackground
            
            VStack(spacing: 0) {
                // Header
                if !viewModel.showMinimalUI {
                    terminalHeader
                        .transition(.move(edge: .top).combined(with: .opacity))
                }
                
                // Chart Area
                chartArea
                
                // Controls
                if !viewModel.showMinimalUI {
                    terminalControls
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
        .navigationBarHidden(true)
        .onTapGesture {
            viewModel.userDidInteract()
        }
        .sheet(isPresented: $showingSettings) {
            TradingSettingsView(settings: $viewModel.chartSettings)
        }
    }
    
    // MARK: - Background
    private var terminalBackground: some View {
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
    }
    
    // MARK: - Header
    private var terminalHeader: some View {
        HStack {
            // Connection Status
            ConnectionStatusView(
                isConnected: viewModel.isConnected,
                status: viewModel.connectionStatus
            )
            
            Spacer()
            
            // Symbol & Price Display
            SymbolPriceView(
                symbol: viewModel.selectedSymbol,
                price: viewModel.currentPrice,
                change: viewModel.priceChange,
                changePercent: viewModel.priceChangePercent
            )
            
            Spacer()
            
            // Settings Button
            Button(action: { showingSettings = true }) {
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
        ZStack {
            // Main Chart
            TradingChartView(
                data: viewModel.candlestickData,
                timeframe: viewModel.selectedTimeframe,
                settings: viewModel.chartSettings,
                isLoading: viewModel.isLoading
            )
            .onTapGesture {
                viewModel.userDidInteract()
            }
            
            // Tool Overlays
            ForEach(Array(viewModel.activeTools), id: \.self) { tool in
                toolOverlay(for: tool)
            }
            
            // Minimal UI Toggle
            VStack {
                HStack {
                    Spacer()
                    Button(action: viewModel.toggleMinimalUI) {
                        Image(systemName: viewModel.showMinimalUI ? "eye" : "eye.slash")
                            .font(.title3)
                            .foregroundColor(.white.opacity(0.7))
                            .padding(8)
                            .background(Color.black.opacity(0.3))
                            .clipShape(Circle())
                    }
                }
                Spacer()
            }
            .padding()
        }
    }
    
    // MARK: - Controls
    private var terminalControls: some View {
        VStack(spacing: 12) {
            // Timeframe Selector
            TimeframeSelectorView(
                selectedTimeframe: $viewModel.selectedTimeframe,
                onSelection: viewModel.selectTimeframe
            )
            
            // Trading Tools
            TradingToolsGrid(
                activeTools: viewModel.activeTools,
                onToolToggle: viewModel.toggleTool
            )
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
        .background(.ultraThinMaterial)
    }
    
    // MARK: - Tool Overlays
    @ViewBuilder
    private func toolOverlay(for tool: TradingTool) -> some View {
        switch tool {
        case .indicators:
            IndicatorsOverlay()
        case .drawingTools:
            DrawingToolsOverlay()
        case .orderBook:
            OrderBookOverlay()
        case .news:
            NewsOverlay()
        case .alerts:
            AlertsOverlay()
        case .positions:
            PositionsOverlay()
        }
    }
}

// MARK: - Supporting Views

struct ConnectionStatusView: View {
    let isConnected: Bool
    let status: String
    
    var body: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(isConnected ? Color.green : Color.red)
                .frame(width: 8, height: 8)
            
            Text(status)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

struct SymbolPriceView: View {
    let symbol: String
    let price: Double
    let change: Double
    let changePercent: Double
    
    var body: some View {
        VStack(spacing: 4) {
            Text(symbol)
                .font(.headline.bold())
                .foregroundColor(.white)
            
            HStack(spacing: 8) {
                Text(String(format: "%.2f", price))
                    .font(.title3.bold())
                    .foregroundColor(.white)
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text(String(format: "%+.2f", change))
                        .font(.caption.bold())
                    Text(String(format: "%+.2f%%", changePercent))
                        .font(.caption2)
                }
                .foregroundColor(change >= 0 ? .green : .red)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill((change >= 0 ? Color.green : Color.red).opacity(0.2))
                )
            }
        }
    }
}

struct TimeframeSelectorView: View {
    @Binding var selectedTimeframe: ChartTimeframe
    let onSelection: (ChartTimeframe) -> Void
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(ChartTimeframe.allCases, id: \.self) { timeframe in
                    Button(timeframe.displayName) {
                        selectedTimeframe = timeframe
                        onSelection(timeframe)
                    }
                    .font(.caption.bold())
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
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
}

struct TradingToolsGrid: View {
    let activeTools: Set<TradingTool>
    let onToolToggle: (TradingTool) -> Void
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6), spacing: 12) {
            ForEach(TradingTool.allCases, id: \.self) { tool in
                TradingToolButton(
                    tool: tool,
                    isActive: activeTools.contains(tool),
                    onTap: { onToolToggle(tool) }
                )
            }
        }
    }
}

struct TradingToolButton: View {
    let tool: TradingTool
    let isActive: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 4) {
                Image(systemName: tool.icon)
                    .font(.title3)
                    .foregroundColor(isActive ? .white : .primary)
                
                Text(tool.title)
                    .font(.caption2)
                    .foregroundColor(isActive ? .white : .secondary)
                    .lineLimit(1)
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

// MARK: - Chart View

struct TradingChartView: View {
    let data: [CandlestickPoint]
    let timeframe: ChartTimeframe
    let settings: ChartSettings
    let isLoading: Bool
    
    var body: some View {
        ZStack {
            if isLoading {
                ProgressView("Loading chart data...")
                    .foregroundColor(.white)
            } else if data.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "chart.xyaxis.line")
                        .font(.system(size: 48))
                        .foregroundColor(.secondary)
                    
                    Text("No chart data available")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    Button("Refresh Data") {
                        // Refresh action
                    }
                    .buttonStyle(.borderedProminent)
                }
            } else {
                // Actual chart implementation would go here
                CandlestickChartView(data: data, settings: settings)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.ultraThinMaterial)
    }
}

struct CandlestickChartView: View {
    let data: [CandlestickPoint]
    let settings: ChartSettings
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Grid
                if settings.showGrid {
                    ChartGridView()
                }
                
                // Candlesticks
                CandlestickRenderer(
                    data: data,
                    size: geometry.size
                )
                
                // Volume (if enabled)
                if settings.showVolume {
                    VolumeRenderer(
                        data: data,
                        size: geometry.size
                    )
                }
            }
        }
    }
}

// MARK: - Chart Renderers

struct ChartGridView: View {
    var body: some View {
        Canvas { context, size in
            let gridSpacing: CGFloat = 50
            
            // Vertical lines
            for x in stride(from: 0, to: size.width, by: gridSpacing) {
                context.stroke(
                    Path { path in
                        path.move(to: CGPoint(x: x, y: 0))
                        path.addLine(to: CGPoint(x: x, y: size.height))
                    },
                    with: .color(.secondary.opacity(0.2)),
                    lineWidth: 0.5
                )
            }
            
            // Horizontal lines
            for y in stride(from: 0, to: size.height, by: gridSpacing) {
                context.stroke(
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: y))
                        path.addLine(to: CGPoint(x: size.width, y: y))
                    },
                    with: .color(.secondary.opacity(0.2)),
                    lineWidth: 0.5
                )
            }
        }
    }
}

struct CandlestickRenderer: View {
    let data: [CandlestickPoint]
    let size: CGSize
    
    var body: some View {
        Canvas { context, size in
            guard !data.isEmpty else { return }
            
            let candleWidth = size.width / CGFloat(data.count) * 0.8
            let maxPrice = data.map(\.high).max() ?? 0
            let minPrice = data.map(\.low).min() ?? 0
            let priceRange = maxPrice - minPrice
            
            for (index, candle) in data.enumerated() {
                let x = CGFloat(index) * (size.width / CGFloat(data.count))
                let openY = size.height - CGFloat((candle.open - minPrice) / priceRange) * size.height
                let closeY = size.height - CGFloat((candle.close - minPrice) / priceRange) * size.height
                let highY = size.height - CGFloat((candle.high - minPrice) / priceRange) * size.height
                let lowY = size.height - CGFloat((candle.low - minPrice) / priceRange) * size.height
                
                let isGreen = candle.close >= candle.open
                let bodyColor: Color = isGreen ? .green : .red
                
                // Wick
                context.stroke(
                    Path { path in
                        path.move(to: CGPoint(x: x + candleWidth/2, y: highY))
                        path.addLine(to: CGPoint(x: x + candleWidth/2, y: lowY))
                    },
                    with: .color(bodyColor),
                    lineWidth: 1
                )
                
                // Body
                let bodyRect = CGRect(
                    x: x,
                    y: min(openY, closeY),
                    width: candleWidth,
                    height: abs(closeY - openY)
                )
                
                context.fill(
                    Path(bodyRect),
                    with: .color(bodyColor)
                )
            }
        }
    }
}

struct VolumeRenderer: View {
    let data: [CandlestickPoint]
    let size: CGSize
    
    var body: some View {
        Canvas { context, size in
            guard !data.isEmpty else { return }
            
            let barWidth = size.width / CGFloat(data.count) * 0.6
            let maxVolume = data.map(\.volume).max() ?? 0
            let volumeHeight = size.height * 0.2 // Volume takes bottom 20%
            
            for (index, candle) in data.enumerated() {
                let x = CGFloat(index) * (size.width / CGFloat(data.count))
                let barHeight = CGFloat(candle.volume / maxVolume) * volumeHeight
                let y = size.height - barHeight
                
                let barRect = CGRect(
                    x: x,
                    y: y,
                    width: barWidth,
                    height: barHeight
                )
                
                context.fill(
                    Path(barRect),
                    with: .color(.blue.opacity(0.3))
                )
            }
        }
    }
}

// MARK: - Tool Overlays

struct IndicatorsOverlay: View {
    var body: some View {
        VStack {
            Text("Technical Indicators")
                .font(.headline.bold())
                .foregroundColor(.white)
                .padding()
            
            ScrollView {
                LazyVStack(spacing: 12) {
                    IndicatorToggle(name: "RSI", isEnabled: .constant(true))
                    IndicatorToggle(name: "MACD", isEnabled: .constant(false))
                    IndicatorToggle(name: "Bollinger Bands", isEnabled: .constant(true))
                    IndicatorToggle(name: "Moving Average", isEnabled: .constant(false))
                }
                .padding()
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.regularMaterial)
        .transition(.slide)
    }
}

struct IndicatorToggle: View {
    let name: String
    @Binding var isEnabled: Bool
    
    var body: some View {
        HStack {
            Text(name)
                .font(.subheadline)
                .foregroundColor(.primary)
            
            Spacer()
            
            Toggle("", isOn: $isEnabled)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct DrawingToolsOverlay: View {
    var body: some View {
        VStack {
            Text("Drawing Tools")
                .font(.headline.bold())
                .foregroundColor(.white)
                .padding()
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 16) {
                DrawingToolButton(icon: "pencil", title: "Freehand")
                DrawingToolButton(icon: "minus", title: "Trend Line")
                DrawingToolButton(icon: "rectangle", title: "Rectangle")
                DrawingToolButton(icon: "circle", title: "Circle")
                DrawingToolButton(icon: "triangle", title: "Triangle")
                DrawingToolButton(icon: "arrow.up", title: "Arrow")
            }
            .padding()
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.regularMaterial)
        .transition(.slide)
    }
}

struct DrawingToolButton: View {
    let icon: String
    let title: String
    
    var body: some View {
        Button(action: {}) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(.primary)
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct OrderBookOverlay: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Order Book")
                .font(.headline.bold())
                .foregroundColor(.white)
                .padding()
            
            // Order book content
            ScrollView {
                VStack(spacing: 1) {
                    // Sell orders
                    ForEach(0..<10, id: \.self) { _ in
                        OrderBookRow(
                            price: Double.random(in: 2375...2380),
                            volume: Double.random(in: 10...1000),
                            isBuy: false
                        )
                    }
                    
                    // Current price
                    Divider()
                        .background(.white)
                        .padding(.vertical, 4)
                    
                    // Buy orders
                    ForEach(0..<10, id: \.self) { _ in
                        OrderBookRow(
                            price: Double.random(in: 2370...2375),
                            volume: Double.random(in: 10...1000),
                            isBuy: true
                        )
                    }
                }
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.regularMaterial)
        .transition(.slide)
    }
}

struct OrderBookRow: View {
    let price: Double
    let volume: Double
    let isBuy: Bool
    
    var body: some View {
        HStack {
            Text(String(format: "%.2f", price))
                .font(.system(.caption, design: .monospaced))
                .foregroundColor(isBuy ? .green : .red)
            
            Spacer()
            
            Text(String(format: "%.0f", volume))
                .font(.system(.caption, design: .monospaced))
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 2)
        .background((isBuy ? Color.green : Color.red).opacity(0.1))
    }
}

struct NewsOverlay: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Market News")
                .font(.headline.bold())
                .foregroundColor(.white)
                .padding()
            
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(0..<5, id: \.self) { _ in
                        NewsItem(
                            headline: "Gold reaches new highs amid economic uncertainty",
                            time: "2 hours ago",
                            impact: .high
                        )
                    }
                }
                .padding()
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.regularMaterial)
        .transition(.slide)
    }
}

struct NewsItem: View {
    let headline: String
    let time: String
    let impact: NewsImpact
    
    enum NewsImpact {
        case low, medium, high
        
        var color: Color {
            switch self {
            case .low: return .green
            case .medium: return .orange
            case .high: return .red
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Circle()
                    .fill(impact.color)
                    .frame(width: 8, height: 8)
                
                Text(time)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            
            Text(headline)
                .font(.subheadline)
                .foregroundColor(.primary)
                .multilineTextAlignment(.leading)
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct AlertsOverlay: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Price Alerts")
                .font(.headline.bold())
                .foregroundColor(.white)
                .padding()
            
            // Alerts list would go here
            Text("No active alerts")
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.regularMaterial)
        .transition(.slide)
    }
}

struct PositionsOverlay: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Open Positions")
                .font(.headline.bold())
                .foregroundColor(.white)
                .padding()
            
            // Positions list would go here
            Text("No open positions")
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.regularMaterial)
        .transition(.slide)
    }
}

// MARK: - Settings View

struct TradingSettingsView: View {
    @Binding var settings: ChartSettings
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section("Chart Display") {
                    Toggle("Show Grid", isOn: $settings.showGrid)
                    Toggle("Show Volume", isOn: $settings.showVolume)
                    Toggle("Show Crosshairs", isOn: $settings.showCrosshairs)
                }
                
                Section("Indicators") {
                    Toggle("Enable Indicators", isOn: $settings.indicatorsEnabled)
                    Toggle("Show Values", isOn: $settings.showIndicatorValues)
                }
                
                Section("Performance") {
                    Toggle("Hardware Acceleration", isOn: $settings.hardwareAcceleration)
                    Toggle("Smooth Animations", isOn: $settings.smoothAnimations)
                }
            }
            .navigationTitle("Terminal Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

// MARK: - Data Models

enum ChartTimeframe: String, CaseIterable, Codable {
    case m1 = "1M"
    case m5 = "5M"
    case m15 = "15M"
    case m30 = "30M"
    case h1 = "1H"
    case h4 = "4H"
    case d1 = "1D"
    case w1 = "1W"
    case mn1 = "1MN"
    
    var displayName: String { rawValue }
}

enum TradingTool: String, CaseIterable {
    case indicators = "indicators"
    case drawingTools = "drawing"
    case orderBook = "orderbook"
    case news = "news"
    case alerts = "alerts"
    case positions = "positions"
    
    var title: String {
        switch self {
        case .indicators: return "Indicators"
        case .drawingTools: return "Drawing"
        case .orderBook: return "Book"
        case .news: return "News"
        case .alerts: return "Alerts"
        case .positions: return "Positions"
        }
    }
    
    var icon: String {
        switch self {
        case .indicators: return "chart.line.uptrend.xyaxis"
        case .drawingTools: return "pencil.and.ruler"
        case .orderBook: return "list.bullet.rectangle"
        case .news: return "newspaper"
        case .alerts: return "bell"
        case .positions: return "briefcase"
        }
    }
}

struct ChartSettings {
    var showGrid: Bool = true
    var showVolume: Bool = true
    var showCrosshairs: Bool = true
    var indicatorsEnabled: Bool = true
    var showIndicatorValues: Bool = false
    var hardwareAcceleration: Bool = true
    var smoothAnimations: Bool = true
}

struct CandlestickPoint: Identifiable, Codable {
    let id = UUID()
    let timestamp: Date
    let open: Double
    let high: Double
    let low: Double
    let close: Double
    let volume: Double
    
    static func generateSampleData(count: Int, basePrice: Double) -> [CandlestickPoint] {
        var data: [CandlestickPoint] = []
        var currentPrice = basePrice
        
        for i in 0..<count {
            let timestamp = Date().addingTimeInterval(TimeInterval(-i * 900)) // 15 min intervals
            let open = currentPrice
            let close = open + Double.random(in: -5...5)
            let high = max(open, close) + Double.random(in: 0...3)
            let low = min(open, close) - Double.random(in: 0...3)
            let volume = Double.random(in: 1000...10000)
            
            data.append(CandlestickPoint(
                timestamp: timestamp,
                open: open,
                high: high,
                low: low,
                close: close,
                volume: volume
            ))
            
            currentPrice = close
        }
        
        return data.reversed()
    }
}

enum ToastType {
    case info, success, warning, error
    
    var color: Color {
        switch self {
        case .info: return .blue
        case .success: return .green
        case .warning: return .orange
        case .error: return .red
        }
    }
}

// MARK: - Previews

#Preview("Trading Terminal") {
    TradingTerminal()
        .preferredColorScheme(.dark)
}

#Preview("Trading Terminal - Light") {
    TradingTerminal()
        .preferredColorScheme(.light)
}

#Preview("Candlestick Chart") {
    CandlestickChartView(
        data: CandlestickPoint.generateSampleData(count: 50, basePrice: 2374.50),
        settings: ChartSettings()
    )
    .frame(height: 400)
    .preferredColorScheme(.dark)
}