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
    
    // MARK: - Strategic UI Optimization for Maximum Screen Usage
    
    @State private var isCompactMode = false
    @State private var showMinimalUI = false
    @State private var autoHideControls = true
    @State private var lastInteractionTime = Date()
    
    @StateObject private var toastManager = ToastManager.shared
    
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
                
                // Professional HUD Overlay
                TradingHUD()
                
                // Professional Toast System
                if toastManager.isShowing {
                    ProfessionalToast(
                        message: toastManager.message,
                        type: toastManager.type,
                        duration: toastManager.duration,
                        isShowing: $toastManager.isShowing
                    )
                    .zIndex(999)
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
        .onAppear {
            setupChartOptimizations()
            startToastDemoSequence()
        }
    }
    
    // MARK: - Portrait Layout
    
    private func portraitLayout(geometry: GeometryProxy) -> some View {
        VStack(spacing: 0) {
            // Adaptive top toolbar
            if !showMinimalUI || !autoHideControls {
                topToolbar
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
            
            // Optimized instrument info
            if !isCompactMode {
                instrumentInfoBar
                    .transition(.move(edge: .top).combined(with: .opacity))
            } else {
                compactInstrumentBar
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
            
            // Maximized main chart - uses most screen space
            mainChartView(geometry: geometry)
                .frame(height: optimizedChartHeight(geometry: geometry))
                .clipped()
            
            // Smart timeframe selector
            if !showMinimalUI {
                smartTimeframeSelector
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
            
            // Contextual bottom controls
            if !showMinimalUI || !autoHideControls {
                optimizedBottomControls
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
            
            // Floating live orders (overlay style)
            if !chartData.liveOrders.isEmpty && !showMinimalUI {
                floatingOrdersPanel
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .onTapGesture {
            handleScreenTap()
        }
        .gesture(
            DragGesture()
                .onChanged { _ in
                    handleUserInteraction()
                }
        )
    }
    
    private var compactInstrumentBar: some View {
        HStack {
            // Essential info only
            HStack(spacing: 8) {
                Text(chartData.currentInstrument.symbol)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text(String(format: "%.5f", chartData.currentPrice))
                    .font(.system(.subheadline, design: .monospaced))
                    .foregroundColor(.primary)
                
                Text("(\(chartData.getNextCandleCountdown()))")
                    .font(.caption)
                    .foregroundColor(DesignSystem.primaryGold)
            }
            
            Spacer()
            
            // Quick actions
            HStack(spacing: 8) {
                quickActionButton(icon: "chart.xyaxis.line", size: .small) { showingIndicators = true }
                quickActionButton(icon: "pencil.and.ruler", size: .small) { showingTools = true }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color(.systemGray6).opacity(0.8))
    }
    
    private var smartTimeframeSelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 6) {
                // Show most important timeframes first
                let priorityTimeframes = [ChartTimeframe.m1, .m5, .m15, .h1, .h4, .d1]
                
                ForEach(priorityTimeframes, id: \.self) { timeframe in
                    compactTimeframeButton(timeframe: timeframe)
                }
                
                // Expandable for more timeframes
                if !isCompactMode {
                    ForEach(ChartTimeframe.allCases.filter { !priorityTimeframes.contains($0) }, id: \.self) { timeframe in
                        compactTimeframeButton(timeframe: timeframe)
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 6)
        .background(Color(.systemGray6).opacity(0.5))
    }
    
    private func compactTimeframeButton(timeframe: ChartTimeframe) -> some View {
        Button(action: {
            selectedTimeframe = timeframe
            chartData.changeTimeframe(timeframe)
            handleUserInteraction()
        }) {
            Text(timeframe.displayName)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(selectedTimeframe == timeframe ? .white : .primary)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    selectedTimeframe == timeframe 
                    ? timeframe.color 
                    : Color(.systemBackground)
                )
                .cornerRadius(6)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var optimizedBottomControls: some View {
        HStack(spacing: 12) {
            // Essential controls only
            controlButton(icon: "chart.xyaxis.line", title: "Indicators") { showingIndicators = true }
            controlButton(icon: "pencil.and.ruler", title: "Tools") { showingTools = true }
            controlButton(icon: "newspaper", title: "News") { showingNews = true }
            
            Spacer()
            
            // Mode toggles
            HStack(spacing: 8) {
                modeToggleButton(
                    icon: "rectangle.compress.vertical", 
                    isActive: isCompactMode,
                    action: { 
                        withAnimation(.spring()) {
                            isCompactMode.toggle()
                        }
                    }
                )
                
                modeToggleButton(
                    icon: "eye.slash", 
                    isActive: showMinimalUI,
                    action: { 
                        withAnimation(.spring()) {
                            showMinimalUI.toggle()
                        }
                    }
                )
            }
            
            // Auto-trading status
            autoTradingStatusButton
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color(.systemGray6).opacity(0.8))
    }
    
    private func controlButton(icon: String, title: String, action: @escaping () -> Void) -> some View {
        Button(action: {
            action()
            handleUserInteraction()
        }) {
            VStack(spacing: 2) {
                Image(systemName: icon)
                    .font(.caption)
                
                if !isCompactMode {
                    Text(title)
                        .font(.caption2)
                }
            }
            .foregroundColor(DesignSystem.primaryGold)
        }
        .frame(minWidth: isCompactMode ? 30 : 50)
    }
    
    private func modeToggleButton(icon: String, isActive: Bool, action: @escaping () -> Void) -> some View {
        Button(action: {
            action()
            handleUserInteraction()
        }) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundColor(isActive ? .white : .secondary)
                .padding(6)
                .background(isActive ? DesignSystem.primaryGold : Color(.systemGray5))
                .clipShape(Circle())
        }
    }
    
    private var autoTradingStatusButton: some View {
        Button(action: {
            // Toggle autotrading
            handleUserInteraction()
        }) {
            HStack(spacing: 4) {
                Image(systemName: "robot.fill")
                    .font(.caption2)
                
                if !isCompactMode {
                    Text("AUTO")
                        .font(.caption2)
                        .fontWeight(.bold)
                }
            }
            .foregroundColor(.white)
            .padding(.horizontal, 6)
            .padding(.vertical, 4)
            .background(chartData.isAutoTradingActive ? .green : .gray)
            .cornerRadius(6)
        }
    }
    
    private var floatingOrdersPanel: some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                
                VStack(alignment: .trailing, spacing: 8) {
                    ForEach(Array(chartData.liveOrders.prefix(3)), id: \.id) { order in
                        floatingOrderCard(order: order)
                    }
                    
                    if chartData.liveOrders.count > 3 {
                        Button("+\(chartData.liveOrders.count - 3) more") {
                            // Show all orders
                            handleUserInteraction()
                        }
                        .font(.caption2)
                        .foregroundColor(DesignSystem.primaryGold)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.black.opacity(0.8))
                        .cornerRadius(6)
                    }
                }
                .padding(.trailing, 20)
                .padding(.bottom, showMinimalUI ? 20 : 80)
            }
        }
        .allowsHitTesting(false) // Allow chart interaction through the overlay
    }
    
    private func floatingOrderCard(order: LiveTradingOrder) -> some View {
        HStack(spacing: 6) {
            Image(systemName: order.direction.arrow)
                .font(.caption2)
                .foregroundColor(order.direction.color)
            
            Text(order.formattedPL)
                .font(.caption2)
                .fontWeight(.bold)
                .foregroundColor(order.profitColor)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color.black.opacity(0.8))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(order.direction.color.opacity(0.6), lineWidth: 1)
        )
    }
    
    private enum ButtonSize {
        case small, medium, large
        
        var iconSize: Font {
            switch self {
            case .small: return .caption
            case .medium: return .subheadline
            case .large: return .title3
            }
        }
        
        var padding: CGFloat {
            switch self {
            case .small: return 6
            case .medium: return 8
            case .large: return 12
            }
        }
    }
    
    private func quickActionButton(icon: String, size: ButtonSize = .medium, action: @escaping () -> Void) -> some View {
        Button(action: {
            action()
            handleUserInteraction()
        }) {
            Image(systemName: icon)
                .font(size.iconSize)
                .foregroundColor(DesignSystem.primaryGold)
                .padding(size.padding)
                .background(Color(.systemGray5))
                .clipShape(Circle())
        }
    }
    
    // MARK: - Screen Optimization Helpers
    
    private func optimizedChartHeight(geometry: GeometryProxy) -> CGFloat {
        let screenHeight = geometry.size.height
        let safeAreaTop = geometry.safeAreaInsets.top
        let safeAreaBottom = geometry.safeAreaInsets.bottom
        
        var usedHeight: CGFloat = safeAreaTop + safeAreaBottom
        
        // Add heights of visible UI components
        if !showMinimalUI || !autoHideControls {
            usedHeight += 44 // Top toolbar
        }
        
        if !isCompactMode {
            usedHeight += 70 // Full instrument bar
        } else {
            usedHeight += 36 // Compact instrument bar
        }
        
        if !showMinimalUI {
            usedHeight += 32 // Timeframe selector
            usedHeight += 50 // Bottom controls
        }
        
        // Reserve some space for the floating orders
        if !chartData.liveOrders.isEmpty && !showMinimalUI {
            usedHeight += 20
        }
        
        return max(300, screenHeight - usedHeight)
    }
    
    private func handleScreenTap() {
        if autoHideControls {
            withAnimation(.spring()) {
                showMinimalUI.toggle()
            }
        }
        handleUserInteraction()
    }
    
    private func handleUserInteraction() {
        lastInteractionTime = Date()
        
        if showMinimalUI && autoHideControls {
            withAnimation(.spring()) {
                showMinimalUI = false
            }
        }
        
        // Auto-hide after 5 seconds of inactivity
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            if Date().timeIntervalSince(lastInteractionTime) >= 5.0 && autoHideControls {
                withAnimation(.spring()) {
                    showMinimalUI = true
                }
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
                    quickActionButton(icon: "chart.xyaxis.line", size: .small) { showingIndicators = true }
                    quickActionButton(icon: "gearshape", size: .small) { showingSettings = true }
                    quickActionButton(icon: "newspaper", size: .small) { showingNews = true }
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
            
            // ENHANCED: Auto-trading indicators
            enhancedAutoTradingIndicators(geometry: geometry, isFullScreen: isFullScreen)
            
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
    
    // MARK: - Enhanced Auto-Trading Indicators
    
    private func enhancedAutoTradingIndicators(geometry: GeometryProxy, isFullScreen: Bool) -> some View {
        let width = isFullScreen ? geometry.size.width - 80 : geometry.size.width
        let height = isFullScreen ? geometry.size.height - 60 : chartHeight
        
        return ZStack {
            // Active bot trading overlay
            if chartData.isAutoTradingActive {
                activeTradingOverlay(width: width, height: height)
            }
            
            // Bot entry/exit signals
            ForEach(chartData.botSignals) { signal in
                botSignalIndicator(signal: signal, width: width, height: height)
            }
            
            // Live order execution indicators
            ForEach(chartData.liveOrders.filter { $0.isFromBot }) { order in
                liveOrderIndicator(order: order, width: width, height: height)
            }
            
            // Profit/Loss visualization
            if !chartData.botTrades.isEmpty {
                profitLossVisualization(width: width, height: height)
            }
        }
    }
    
    private func activeTradingOverlay(width: CGFloat, height: CGFloat) -> some View {
        ZStack {
            // Pulsing border to show active trading
            Rectangle()
                .stroke(
                    LinearGradient(
                        colors: [DesignSystem.primaryGold, .green, DesignSystem.primaryGold],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 3
                )
                .opacity(0.8)
                .scaleEffect(1.02)
                .animation(.easeInOut(duration: 2.0).repeatForever(), value: chartData.isAutoTradingActive)
            
            // Top indicator bar
            VStack {
                HStack {
                    HStack(spacing: 8) {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 10, height: 10)
                            .scaleEffect(1.0)
                            .animation(.easeInOut(duration: 1.0).repeatForever(), value: chartData.isAutoTradingActive)
                        
                        Text("🤖 AUTO-TRADING ACTIVE")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                        
                        Text("• \(chartData.activeBots.count) BOTS LIVE")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(8)
                    
                    Spacer()
                    
                    // Active P&L
                    Text("P&L: \(chartData.totalBotPL, format: .currency(code: "USD"))")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(chartData.totalBotPL >= 0 ? .green : .red)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background((chartData.totalBotPL >= 0 ? Color.green : Color.red).opacity(0.1))
                        .cornerRadius(6)
                }
                .padding(.horizontal, 12)
                .padding(.top, 8)
                
                Spacer()
            }
        }
    }
    
    private func botSignalIndicator(signal: BotSignal, width: CGFloat, height: CGFloat) -> some View {
        let priceRange = getPriceRange()
        let yPosition = getYPosition(for: signal.price, priceRange: priceRange, height: height)
        let xPosition = width * CGFloat(signal.candleIndex) / CGFloat(chartData.candleData.count)
        
        return ZStack {
            // Signal arrow
            Image(systemName: signal.direction == .buy ? "arrowtriangle.up.fill" : "arrowtriangle.down.fill")
                .font(.title2)
                .foregroundColor(signal.direction == .buy ? .green : .red)
                .background(Color.white)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(signal.direction == .buy ? .green : .red, lineWidth: 2)
                )
                .position(x: xPosition, y: yPosition + (signal.direction == .buy ? 20 : -20))
            
            // Bot name label
            Text(signal.botName)
                .font(.caption2)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(signal.direction == .buy ? Color.green : Color.red)
                .cornerRadius(4)
                .position(x: xPosition, y: yPosition + (signal.direction == .buy ? 40 : -40))
            
            // Confidence indicator
            if signal.confidence > 0.8 {
                Image(systemName: "star.fill")
                    .font(.caption2)
                    .foregroundColor(DesignSystem.primaryGold)
                    .position(x: xPosition + 15, y: yPosition + (signal.direction == .buy ? 5 : -5))
            }
        }
        .opacity(signal.isActive ? 1.0 : 0.6)
        .scaleEffect(signal.isActive ? 1.0 : 0.8)
        .animation(.spring(), value: signal.isActive)
    }
    
    private func liveOrderIndicator(order: LiveTradingOrder, width: CGFloat, height: CGFloat) -> some View {
        let priceRange = getPriceRange()
        let yPosition = getYPosition(for: order.openPrice, priceRange: priceRange, height: height)
        
        return HStack {
            // Order visualization
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Image(systemName: "robot.fill")
                        .font(.caption2)
                        .foregroundColor(DesignSystem.primaryGold)
                    
                    Text(order.botName ?? "AI Bot")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                
                HStack(spacing: 8) {
                    Text(order.direction.rawValue.uppercased())
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("\(order.volume, format: .number.precision(.fractionLength(2))) lots")
                        .font(.caption2)
                        .foregroundColor(.white)
                }
                
                // Live P&L with animation
                Text(order.formattedPL)
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(order.profitColor)
                    .scaleEffect(order.isProfit ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 0.3), value: order.profitLoss)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .background(Color.black.opacity(0.8))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(order.direction.color, lineWidth: 2)
            )
            
            Spacer()
        }
        .position(x: width * 0.15, y: yPosition)
    }
    
    private func profitLossVisualization(width: CGFloat, height: CGFloat) -> some View {
        VStack {
            Spacer()
            
            // Profit/Loss summary bar
            HStack(spacing: 16) {
                // Total P&L
                VStack(spacing: 2) {
                    Text("Total P&L")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    
                    Text(chartData.totalBotPL, format: .currency(code: "USD"))
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(chartData.totalBotPL >= 0 ? .green : .red)
                }
                
                Divider()
                    .frame(height: 20)
                
                // Win Rate
                VStack(spacing: 2) {
                    Text("Win Rate")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    
                    Text("\(Int(chartData.botWinRate * 100))%")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(chartData.botWinRate > 0.6 ? .green : .orange)
                }
                
                Divider()
                    .frame(height: 20)
                
                // Active Trades
                VStack(spacing: 2) {
                    Text("Active")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    
                    Text("\(chartData.activeBotTrades)")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(DesignSystem.primaryGold)
                }
                
                Spacer()
                
                // Bot performance indicator
                HStack(spacing: 4) {
                    ForEach(chartData.activeBots.prefix(3), id: \.id) { bot in
                        Circle()
                            .fill(bot.isPerformingWell ? .green : .orange)
                            .frame(width: 8, height: 8)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Color.black.opacity(0.8))
            .cornerRadius(12)
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
        }
    }
    
    // MARK: - Chart Components
    
    private var loadingView: some View {
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

// MARK: - Setup and Demo Functions

extension ProfessionalChartView {
    private func setupChartOptimizations() {
        // Enable auto-hide controls by default
        autoHideControls = true
        
        // Generate sample bot data for demo
        chartData.generateSampleBotData()
        
        // Optimize for performance
        optimizeChartPerformance()
    }
    
    private func optimizeChartPerformance() {
        // Limit candle data for smooth performance
        if chartData.candleData.count > 500 {
            chartData.candleData = Array(chartData.candleData.suffix(500))
        }
        
        // Pre-calculate common values
        _ = getPriceRange()
    }
    
    private func startToastDemoSequence() {
        // Demo toast sequence to show professional notifications
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            toastManager.showTrading("Bot 'Quantum AI Pro' opened BUY EUR/USD at 1.0875")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 8.0) {
            toastManager.showSuccess("Take Profit hit! +$127.50 profit on GBP/USD")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 15.0) {
            toastManager.show("High impact news detected: Fed Rate Decision in 30 minutes", type: .warning)
        }
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