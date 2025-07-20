//
//  ProfessionalChartView.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 7/18/25.
//

import SwiftUI

struct ProfessionalChartView: View {
    @StateObject private var chartData = ChartDataService.shared
    @State private var chartSettings = ChartSettings()
    @State private var selectedTimeframe: ChartTimeframe = .m15
    @State private var showingIndicators = false
    @State private var showingSettings = false
    @State private var showingTools = false
    @State private var showingNews = false
    @State private var isLandscape = false
    @State private var zoomScale: CGFloat = 1.0
    @State private var dragOffset: CGSize = .zero
    @State private var showCrosshair = false
    @State private var crosshairLocation: CGPoint = .zero
    
    // Chart dimensions
    @State private var chartHeight: CGFloat = 400
    @State private var chartWidth: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                chartSettings.colorScheme.backgroundColor
                    .ignoresSafeArea()
                
                if isLandscape {
                    landscapeLayout(geometry: geometry)
                } else {
                    portraitLayout(geometry: geometry)
                }
            }
        }
        .navigationBarHidden(isLandscape)
        .statusBarHidden(isLandscape)
        .onRotate { orientation in
            withAnimation(.easeInOut(duration: 0.3)) {
                isLandscape = orientation.isLandscape
            }
        }
        .sheet(isPresented: $showingIndicators) {
            IndicatorSelectionView(settings: $chartSettings)
        }
        .sheet(isPresented: $showingSettings) {
            ChartSettingsView(settings: $chartSettings)
        }
        .sheet(isPresented: $showingTools) {
            ChartToolsView()
        }
        .sheet(isPresented: $showingNews) {
            MarketNewsView()
        }
    }
    
    // MARK: - Portrait Layout
    
    private func portraitLayout(geometry: GeometryProxy) -> some View {
        VStack(spacing: 0) {
            // Top toolbar
            topToolbar
            
            // Instrument info
            instrumentInfoBar
            
            // Main chart
            mainChartView(geometry: geometry)
            
            // Timeframe selector
            timeframeSelector
            
            // Bottom controls
            bottomControls
            
            // Live orders panel
            if !chartData.liveOrders.isEmpty {
                liveOrdersPanel
            }
        }
    }
    
    // MARK: - Landscape Layout
    
    private func landscapeLayout(geometry: GeometryProxy) -> some View {
        HStack(spacing: 0) {
            // Left sidebar (condensed)
            VStack(spacing: 8) {
                // Exit landscape button
                Button(action: {
                    // Force portrait orientation
                    isLandscape = false
                }) {
                    Image(systemName: "arrow.up.left.and.arrow.down.right")
                        .font(.title2)
                        .foregroundColor(DesignSystem.primaryGold)
                        .padding(8)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                }
                
                // Timeframes (vertical)
                VStack(spacing: 4) {
                    ForEach(ChartTimeframe.allCases.prefix(6), id: \.self) { timeframe in
                        timeframeButton(timeframe: timeframe, isCompact: true)
                    }
                }
                
                Spacer()
                
                // Quick tools
                VStack(spacing: 8) {
                    quickActionButton(icon: "chart.xyaxis.line", action: { showingIndicators = true })
                    quickActionButton(icon: "gearshape", action: { showingSettings = true })
                    quickActionButton(icon: "newspaper", action: { showingNews = true })
                }
                
                // Connection status
                connectionIndicator(isCompact: true)
            }
            .frame(width: 80)
            .padding(.vertical, 12)
            .background(Color(.systemGray6))
            
            // Main chart area (full screen)
            VStack(spacing: 0) {
                // Minimal top bar
                HStack {
                    // Instrument selector
                    Text("\(chartData.currentInstrument.symbol)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    // Live prices
                    HStack(spacing: 12) {
                        VStack(alignment: .trailing, spacing: 2) {
                            Text("BID")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(String(format: "%.5f", chartData.bid))
                                .font(.system(.caption, design: .monospaced))
                                .foregroundColor(.red)
                        }
                        
                        VStack(alignment: .trailing, spacing: 2) {
                            Text("ASK")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(String(format: "%.5f", chartData.ask))
                                .font(.system(.caption, design: .monospaced))
                                .foregroundColor(.blue)
                        }
                        
                        VStack(alignment: .trailing, spacing: 2) {
                            Text("SPREAD")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(String(format: "%.1f", chartData.spread / chartData.currentInstrument.pip))
                                .font(.system(.caption, design: .monospaced))
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(Color(.systemBackground).opacity(0.9))
                
                // Full screen chart
                fullScreenChart(geometry: geometry)
            }
        }
    }
    
    // MARK: - Top Toolbar
    
    private var topToolbar: some View {
        HStack(spacing: 16) {
            // Connection status
            connectionIndicator()
            
            Spacer()
            
            // Chart controls
            HStack(spacing: 12) {
                Button(action: { showingIndicators = true }) {
                    Image(systemName: "chart.xyaxis.line")
                        .foregroundColor(DesignSystem.primaryGold)
                }
                
                Button(action: { showingTools = true }) {
                    Image(systemName: "pencil.and.ruler.fill")
                        .foregroundColor(DesignSystem.primaryGold)
                }
                
                Button(action: { showingSettings = true }) {
                    Image(systemName: "gearshape.fill")
                        .foregroundColor(DesignSystem.primaryGold)
                }
                
                Button(action: { showingNews = true }) {
                    Image(systemName: "newspaper.fill")
                        .foregroundColor(DesignSystem.primaryGold)
                }
                
                Button(action: { 
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isLandscape = true
                    }
                }) {
                    Image(systemName: "arrow.up.left.and.arrow.down.right")
                        .foregroundColor(DesignSystem.primaryGold)
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color(.systemGray6))
    }
    
    private func connectionIndicator(isCompact: Bool = false) -> some View {
        HStack(spacing: isCompact ? 4 : 8) {
            Image(systemName: chartData.connectionStatus.icon)
                .foregroundColor(chartData.connectionStatus.color)
                .font(.system(size: isCompact ? 12 : 16))
            
            if !isCompact {
                VStack(alignment: .leading, spacing: 2) {
                    Text(chartData.connectionStatus.rawValue)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(chartData.connectionStatus.color)
                    
                    Text("Updated: \(chartData.lastUpdateTime.formatted(.dateTime.hour().minute().second()))")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
    
    // MARK: - Instrument Info Bar
    
    private var instrumentInfoBar: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    Text(chartData.currentInstrument.symbol)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text(chartData.currentInstrument.displayName)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                HStack(spacing: 16) {
                    Text("Current: \(String(format: "%.5f", chartData.currentPrice))")
                        .font(.system(.caption, design: .monospaced))
                        .foregroundColor(.primary)
                    
                    Text("Spread: \(String(format: "%.1f", chartData.spread / chartData.currentInstrument.pip))")
                        .font(.system(.caption, design: .monospaced))
                        .foregroundColor(.secondary)
                    
                    Text("Next: \(chartData.getNextCandleCountdown())")
                        .font(.system(.caption, design: .monospaced))
                        .foregroundColor(DesignSystem.primaryGold)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(DesignSystem.primaryGold.opacity(0.1))
                        .cornerRadius(4)
                }
            }
            
            Spacer()
            
            // Bid/Ask prices
            VStack(alignment: .trailing, spacing: 4) {
                HStack(spacing: 16) {
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("BID")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(String(format: "%.5f", chartData.bid))
                            .font(.system(.subheadline, design: .monospaced))
                            .fontWeight(.semibold)
                            .foregroundColor(.red)
                    }
                    
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("ASK")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(String(format: "%.5f", chartData.ask))
                            .font(.system(.subheadline, design: .monospaced))
                            .fontWeight(.semibold)
                            .foregroundColor(.blue)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
    }
    
    // MARK: - Main Chart View
    
    private func mainChartView(geometry: GeometryProxy) -> some View {
        ZStack {
            // Chart background
            Rectangle()
                .fill(chartSettings.colorScheme.backgroundColor)
            
            if chartData.isLoadingData {
                loadingView
            } else {
                // Chart content
                chartContent(geometry: geometry)
            }
        }
        .frame(height: chartHeight)
        .clipShape(Rectangle())
        .onTapGesture { location in
            withAnimation(.easeInOut(duration: 0.2)) {
                showCrosshair.toggle()
                crosshairLocation = location
            }
        }
        .gesture(
            MagnificationGesture()
                .onChanged { scale in
                    zoomScale = scale
                }
                .onEnded { scale in
                    withAnimation(.spring()) {
                        zoomScale = max(0.5, min(scale, 3.0))
                    }
                }
        )
        .gesture(
            DragGesture()
                .onChanged { value in
                    dragOffset = value.translation
                }
                .onEnded { value in
                    withAnimation(.spring()) {
                        dragOffset = .zero
                    }
                }
        )
    }
    
    private func fullScreenChart(geometry: GeometryProxy) -> some View {
        ZStack {
            // Chart background
            Rectangle()
                .fill(chartSettings.colorScheme.backgroundColor)
            
            if chartData.isLoadingData {
                loadingView
            } else {
                // Full screen chart content
                chartContent(geometry: geometry, isFullScreen: true)
            }
        }
        .clipShape(Rectangle())
    }
    
    private func chartContent(geometry: GeometryProxy, isFullScreen: Bool = false) -> some View {
        ZStack {
            // Grid lines
            if chartSettings.showGrid {
                chartGrid(geometry: geometry, isFullScreen: isFullScreen)
            }
            
            // Candlestick chart
            candlestickChart(geometry: geometry, isFullScreen: isFullScreen)
            
            // Volume bars (if enabled)
            if chartSettings.showVolume {
                volumeBars(geometry: geometry, isFullScreen: isFullScreen)
            }
            
            // Technical indicators
            technicalIndicators(geometry: geometry, isFullScreen: isFullScreen)
            
            // Live orders visualization
            if chartSettings.showOrderLines {
                liveOrderLines(geometry: geometry, isFullScreen: isFullScreen)
            }
            
            // Bot signals
            if chartSettings.showBotSignals {
                botSignalOverlay(geometry: geometry, isFullScreen: isFullScreen)
            }
            
            // Crosshair
            if showCrosshair && chartSettings.showCrosshair {
                crosshairOverlay(geometry: geometry, isFullScreen: isFullScreen)
            }
            
            // Price labels
            priceLabels(geometry: geometry, isFullScreen: isFullScreen)
        }
    }
    
    // MARK: - Chart Components
    
    private func loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: DesignSystem.primaryGold))
                .scaleEffect(1.5)
            
            Text("Loading chart data...")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
    
    private func chartGrid(geometry: GeometryProxy, isFullScreen: Bool) -> some View {
        Path { path in
            let width = isFullScreen ? geometry.size.width - 80 : geometry.size.width
            let height = isFullScreen ? geometry.size.height - 60 : chartHeight
            
            // Horizontal grid lines
            for i in 1..<10 {
                let y = height * CGFloat(i) / 10
                path.move(to: CGPoint(x: 0, y: y))
                path.addLine(to: CGPoint(x: width, y: y))
            }
            
            // Vertical grid lines
            for i in 1..<20 {
                let x = width * CGFloat(i) / 20
                path.move(to: CGPoint(x: x, y: 0))
                path.addLine(to: CGPoint(x: x, y: height))
            }
        }
        .stroke(chartSettings.colorScheme.gridColor.opacity(0.3), lineWidth: 0.5)
    }
    
    private func candlestickChart(geometry: GeometryProxy, isFullScreen: Bool) -> some View {
        let width = isFullScreen ? geometry.size.width - 80 : geometry.size.width
        let height = isFullScreen ? geometry.size.height - 60 : chartHeight
        
        return HStack(spacing: 0) {
            ForEach(Array(chartData.candleData.enumerated()), id: \.element.id) { index, candle in
                candlestickView(candle: candle, width: width, height: height, index: index)
            }
        }
        .scaleEffect(x: zoomScale, y: 1.0, anchor: .center)
        .offset(dragOffset)
    }
    
    private func candlestickView(candle: CandlestickData, width: CGFloat, height: CGFloat, index: Int) -> some View {
        let candleWidth = width / CGFloat(chartData.candleData.count) * zoomScale
        let priceRange = getPriceRange()
        let priceScale = height / priceRange
        
        return GeometryReader { _ in
            VStack(spacing: 0) {
                // Upper wick
                Rectangle()
                    .fill(candle.isBullish ? chartSettings.colorScheme.bullCandleColor : chartSettings.colorScheme.bearCandleColor)
                    .frame(width: 1, height: candle.upperWickHeight * priceScale)
                
                // Candle body
                Rectangle()
                    .fill(candle.isBullish ? chartSettings.colorScheme.bullCandleColor : chartSettings.colorScheme.bearCandleColor)
                    .frame(width: max(candleWidth * 0.8, 1), height: max(candle.bodyHeight * priceScale, 1))
                
                // Lower wick
                Rectangle()
                    .fill(candle.isBullish ? chartSettings.colorScheme.bullCandleColor : chartSettings.colorScheme.bearCandleColor)
                    .frame(width: 1, height: candle.lowerWickHeight * priceScale)
            }
        }
        .frame(width: candleWidth, height: height)
        .position(x: candleWidth / 2, y: getYPosition(for: (candle.high + candle.low) / 2, priceRange: priceRange, height: height))
    }
    
    private func volumeBars(geometry: GeometryProxy, isFullScreen: Bool) -> some View {
        let width = isFullScreen ? geometry.size.width - 80 : geometry.size.width
        let volumeHeight: CGFloat = 60
        
        return VStack {
            Spacer()
            
            HStack(spacing: 0) {
                ForEach(Array(chartData.candleData.enumerated()), id: \.element.id) { index, candle in
                    let barWidth = width / CGFloat(chartData.candleData.count) * zoomScale
                    let maxVolume = chartData.candleData.map { $0.volume }.max() ?? 1
                    let barHeight = (candle.volume / maxVolume) * volumeHeight
                    
                    Rectangle()
                        .fill(candle.isBullish ? Color.green.opacity(0.6) : Color.red.opacity(0.6))
                        .frame(width: max(barWidth * 0.6, 1), height: barHeight)
                        .frame(width: barWidth, height: volumeHeight, alignment: .bottom)
                }
            }
            .scaleEffect(x: zoomScale, y: 1.0, anchor: .center)
            .offset(dragOffset)
        }
    }
    
    private func liveOrderLines(geometry: GeometryProxy, isFullScreen: Bool) -> some View {
        let width = isFullScreen ? geometry.size.width - 80 : geometry.size.width
        let height = isFullScreen ? geometry.size.height - 60 : chartHeight
        let priceRange = getPriceRange()
        
        return ZStack {
            ForEach(chartData.liveOrders) { order in
                // Entry line
                Path { path in
                    let y = getYPosition(for: order.openPrice, priceRange: priceRange, height: height)
                    path.move(to: CGPoint(x: 0, y: y))
                    path.addLine(to: CGPoint(x: width, y: y))
                }
                .stroke(order.direction.color.opacity(0.8), style: StrokeStyle(lineWidth: 2, dash: [5, 5]))
                
                // Stop Loss line
                if let stopLoss = order.stopLoss {
                    Path { path in
                        let y = getYPosition(for: stopLoss, priceRange: priceRange, height: height)
                        path.move(to: CGPoint(x: 0, y: y))
                        path.addLine(to: CGPoint(x: width, y: y))
                    }
                    .stroke(Color.red.opacity(0.6), style: StrokeStyle(lineWidth: 1, dash: [3, 3]))
                }
                
                // Take Profit line
                if let takeProfit = order.takeProfit {
                    Path { path in
                        let y = getYPosition(for: takeProfit, priceRange: priceRange, height: height)
                        path.move(to: CGPoint(x: 0, y: y))
                        path.addLine(to: CGPoint(x: width, y: y))
                    }
                    .stroke(Color.green.opacity(0.6), style: StrokeStyle(lineWidth: 1, dash: [3, 3]))
                }
                
                // Order info label
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(order.botName ?? "Manual")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("\(order.direction.rawValue) \(String(format: "%.2f", order.volume))")
                            .font(.caption2)
                            .foregroundColor(.white)
                        
                        Text(order.formattedPL)
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundColor(order.profitColor)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.black.opacity(0.8))
                    .cornerRadius(6)
                    
                    Spacer()
                }
                .position(
                    x: width * 0.1,
                    y: getYPosition(for: order.openPrice, priceRange: priceRange, height: height) - 20
                )
            }
        }
    }
    
    private func botSignalOverlay(geometry: GeometryProxy, isFullScreen: Bool) -> some View {
        let width = isFullScreen ? geometry.size.width - 80 : geometry.size.width
        let height = isFullScreen ? geometry.size.height - 60 : chartHeight
        
        return ZStack {
            // Sample bot signals
            ForEach(0..<3) { i in
                let x = width * CGFloat(0.2 + 0.3 * Double(i))
                let y = height * CGFloat(0.3 + 0.2 * Double(i))
                
                VStack(spacing: 4) {
                    Image(systemName: i % 2 == 0 ? "arrow.up.circle.fill" : "arrow.down.circle.fill")
                        .font(.title2)
                        .foregroundColor(i % 2 == 0 ? .green : .red)
                        .background(Color.white)
                        .clipShape(Circle())
                    
                    Text("Bot Signal")
                        .font(.caption2)
                        .foregroundColor(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(4)
                }
                .position(x: x, y: y)
            }
        }
    }
    
    private func technicalIndicators(geometry: GeometryProxy, isFullScreen: Bool) -> some View {
        let width = isFullScreen ? geometry.size.width - 80 : geometry.size.width
        let height = isFullScreen ? geometry.size.height - 60 : chartHeight
        
        return ZStack {
            // Sample moving averages
            if chartSettings.selectedIndicators.contains(.sma) {
                movingAverageLine(period: 20, color: .blue, width: width, height: height)
            }
            
            if chartSettings.selectedIndicators.contains(.ema) {
                movingAverageLine(period: 50, color: .orange, width: width, height: height)
            }
        }
    }
    
    private func movingAverageLine(period: Int, color: Color, width: CGFloat, height: CGFloat) -> some View {
        let priceRange = getPriceRange()
        
        return Path { path in
            guard chartData.candleData.count >= period else { return }
            
            for i in period..<chartData.candleData.count {
                let movingAverage = chartData.candleData[(i-period+1)...i].map { $0.close }.reduce(0, +) / Double(period)
                let x = width * CGFloat(i) / CGFloat(chartData.candleData.count)
                let y = getYPosition(for: movingAverage, priceRange: priceRange, height: height)
                
                if i == period {
                    path.move(to: CGPoint(x: x, y: y))
                } else {
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
        }
        .stroke(color, lineWidth: 2)
        .scaleEffect(x: zoomScale, y: 1.0, anchor: .center)
        .offset(dragOffset)
    }
    
    private func crosshairOverlay(geometry: GeometryProxy, isFullScreen: Bool) -> some View {
        let width = isFullScreen ? geometry.size.width - 80 : geometry.size.width
        let height = isFullScreen ? geometry.size.height - 60 : chartHeight
        
        return ZStack {
            // Vertical line
            Path { path in
                path.move(to: CGPoint(x: crosshairLocation.x, y: 0))
                path.addLine(to: CGPoint(x: crosshairLocation.x, y: height))
            }
            .stroke(Color.white.opacity(0.8), style: StrokeStyle(lineWidth: 1, dash: [3, 3]))
            
            // Horizontal line
            Path { path in
                path.move(to: CGPoint(x: 0, y: crosshairLocation.y))
                path.addLine(to: CGPoint(x: width, y: crosshairLocation.y))
            }
            .stroke(Color.white.opacity(0.8), style: StrokeStyle(lineWidth: 1, dash: [3, 3]))
            
            // Price label
            let priceRange = getPriceRange()
            let minPrice = chartData.candleData.map { $0.low }.min() ?? 0
            let price = minPrice + (priceRange * Double(1 - crosshairLocation.y / height))
            
            Text(String(format: "%.5f", price))
                .font(.system(.caption, design: .monospaced))
                .foregroundColor(.black)
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(Color.white)
                .cornerRadius(4)
                .position(x: width - 40, y: crosshairLocation.y)
        }
    }
    
    private func priceLabels(geometry: GeometryProxy, isFullScreen: Bool) -> some View {
        let width = isFullScreen ? geometry.size.width - 80 : geometry.size.width
        let height = isFullScreen ? geometry.size.height - 60 : chartHeight
        
        return VStack {
            ForEach(0..<6) { i in
                let priceRange = getPriceRange()
                let minPrice = chartData.candleData.map { $0.low }.min() ?? 0
                let price = minPrice + (priceRange * Double(5 - i) / 5)
                
                HStack {
                    Spacer()
                    
                    Text(String(format: "%.5f", price))
                        .font(.system(.caption, design: .monospaced))
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color(.systemBackground).opacity(0.9))
                        .cornerRadius(4)
                }
                
                if i < 5 { Spacer() }
            }
        }
    }
    
    // MARK: - Timeframe Selector
    
    private var timeframeSelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(ChartTimeframe.allCases, id: \.self) { timeframe in
                    timeframeButton(timeframe: timeframe)
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 8)
        .background(Color(.systemGray6))
    }
    
    private func timeframeButton(timeframe: ChartTimeframe, isCompact: Bool = false) -> some View {
        Button(action: {
            selectedTimeframe = timeframe
            chartData.changeTimeframe(timeframe)
        }) {
            Text(timeframe.displayName)
                .font(isCompact ? .caption2 : .caption)
                .fontWeight(.medium)
                .foregroundColor(selectedTimeframe == timeframe ? .white : timeframe.color)
                .padding(.horizontal, isCompact ? 6 : 12)
                .padding(.vertical, isCompact ? 4 : 8)
                .background(
                    selectedTimeframe == timeframe 
                    ? timeframe.color 
                    : timeframe.color.opacity(0.1)
                )
                .cornerRadius(isCompact ? 4 : 8)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // MARK: - Bottom Controls
    
    private var bottomControls: some View {
        HStack(spacing: 20) {
            Button(action: { showingIndicators = true }) {
                Label("Indicators", systemImage: "chart.xyaxis.line")
                    .font(.caption)
                    .foregroundColor(DesignSystem.primaryGold)
            }
            
            Button(action: { showingTools = true }) {
                Label("Tools", systemImage: "pencil.and.ruler")
                    .font(.caption)
                    .foregroundColor(DesignSystem.primaryGold)
            }
            
            Button(action: { showingNews = true }) {
                Label("News", systemImage: "newspaper")
                    .font(.caption)
                    .foregroundColor(DesignSystem.primaryGold)
            }
            
            Spacer()
            
            // Auto-trading toggle
            Button(action: {
                // Toggle autotrading
            }) {
                HStack(spacing: 4) {
                    Image(systemName: "robot.fill")
                        .foregroundColor(.green)
                    Text("AUTO ON")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.green.opacity(0.1))
                .cornerRadius(6)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color(.systemGray6))
    }
    
    // MARK: - Live Orders Panel
    
    private var liveOrdersPanel: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("🤖 LIVE TRADING")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(DesignSystem.primaryGold)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(chartData.liveOrders) { order in
                        liveOrderCard(order: order)
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.vertical, 8)
        .background(Color(.systemGray6))
    }
    
    private func liveOrderCard(order: LiveTradingOrder) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Image(systemName: order.direction.arrow)
                    .foregroundColor(order.direction.color)
                    .font(.caption)
                
                Text(order.botName ?? "Manual")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .lineLimit(1)
            }
            
            Text("\(order.direction.rawValue) \(String(format: "%.2f", order.volume))")
                .font(.caption2)
                .foregroundColor(.secondary)
            
            Text("Entry: \(String(format: "%.5f", order.openPrice))")
                .font(.caption2)
                .foregroundColor(.secondary)
            
            Text(order.formattedPL)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(order.profitColor)
        }
        .padding(8)
        .background(order.direction.color.opacity(0.1))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(order.direction.color.opacity(0.3), lineWidth: 1)
        )
    }
    
    private func quickActionButton(icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(DesignSystem.primaryGold)
                .padding(8)
                .background(Color(.systemGray5))
                .cornerRadius(6)
        }
    }
    
    // MARK: - Helper Methods
    
    private func getPriceRange() -> Double {
        let prices = chartData.candleData.flatMap { [$0.high, $0.low] }
        let maxPrice = prices.max() ?? 1.0
        let minPrice = prices.min() ?? 0.0
        return maxPrice - minPrice
    }
    
    private func getYPosition(for price: Double, priceRange: Double, height: CGFloat) -> CGFloat {
        let minPrice = chartData.candleData.map { $0.low }.min() ?? 0
        let normalizedPrice = (price - minPrice) / priceRange
        return height * (1 - CGFloat(normalizedPrice))
    }
}

// MARK: - Device Rotation Extension

extension View {
    func onRotate(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
        self.onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
            action(UIDevice.current.orientation)
        }
    }
}

// MARK: - Preview

#Preview {
    ProfessionalChartView()
}