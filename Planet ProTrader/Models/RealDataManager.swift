//
//  RealDataManager.swift
//  Planet ProTrader
//
//  Created by Senior iOS Engineer on 1/25/25.
//

import SwiftUI
import Combine

@MainActor
class RealDataManager: ObservableObject {
    @Published var lastUpdate = Date()
    @Published var connectionQuality = "Excellent"
    @Published var dataFeed = "Live"
    @Published var feedStatus: FeedStatus = .active
    @Published var dataLatency: Double = 25.5 // milliseconds
    @Published var bytesReceived: Int64 = 0
    @Published var packetsPerSecond: Double = 0.0
    @Published var isRealTime = true
    @Published var marketDataProviders: [DataProvider] = []
    @Published var currentSymbol = "XAUUSD"
    @Published var priceUpdatesPerMinute = 120
    
    enum FeedStatus: String, CaseIterable {
        case active = "Active"
        case delayed = "Delayed"
        case stale = "Stale"
        case disconnected = "Disconnected"
        case maintenance = "Maintenance"
        
        var color: Color {
            switch self {
            case .active: return .green
            case .delayed: return .orange
            case .stale: return .yellow
            case .disconnected: return .red
            case .maintenance: return .purple
            }
        }
        
        var icon: String {
            switch self {
            case .active: return "antenna.radiowaves.left.and.right"
            case .delayed: return "clock"
            case .stale: return "exclamationmark.triangle"
            case .disconnected: return "wifi.slash"
            case .maintenance: return "wrench"
            }
        }
    }
    
    struct DataProvider: Identifiable {
        let id = UUID()
        let name: String
        let type: ProviderType
        let latency: Double
        let isConnected: Bool
        let priority: Int
        
        enum ProviderType: String, CaseIterable {
            case primary = "Primary"
            case backup = "Backup"
            case emergency = "Emergency"
        }
    }
    
    struct MarketDataPoint {
        let symbol: String
        let bid: Double
        let ask: Double
        let timestamp: Date
        let volume: Int
    }
    
    @Published var currentMarketData: MarketDataPoint?
    @Published var dataHistory: [MarketDataPoint] = []
    @Published var averageLatency: Double = 0.0
    @Published var dataCompressionRatio: Double = 0.85
    @Published var errorCount = 0
    @Published var totalRequests = 0
    
    private var updateTimer: Timer?
    private var latencyTimer: Timer?
    private var metricsTimer: Timer?
    
    init() {
        setupDataProviders()
        setupInitialData()
        startRealTimeUpdates()
        startMetricsTracking()
    }
    
    deinit {
        updateTimer?.invalidate()
        latencyTimer?.invalidate()
        metricsTimer?.invalidate()
    }
    
    private func setupDataProviders() {
        marketDataProviders = [
            DataProvider(
                name: "Reuters",
                type: .primary,
                latency: 15.2,
                isConnected: true,
                priority: 1
            ),
            DataProvider(
                name: "Bloomberg",
                type: .backup,
                latency: 22.8,
                isConnected: true,
                priority: 2
            ),
            DataProvider(
                name: "Yahoo Finance",
                type: .emergency,
                latency: 45.1,
                isConnected: false,
                priority: 3
            )
        ]
    }
    
    private func setupInitialData() {
        currentMarketData = MarketDataPoint(
            symbol: currentSymbol,
            bid: 2374.25,
            ask: 2374.45,
            timestamp: Date(),
            volume: 1250
        )
        
        feedStatus = .active
        dataLatency = 25.5
        bytesReceived = 1_024_576 // 1 MB
        packetsPerSecond = 45.2
        averageLatency = 22.3
    }
    
    private func startRealTimeUpdates() {
        // Update market data every 2 seconds
        updateTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
            Task { @MainActor in
                await self.updateMarketData()
            }
        }
    }
    
    private func startMetricsTracking() {
        // Update metrics every 5 seconds
        metricsTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
            Task { @MainActor in
                self.updateMetrics()
            }
        }
        
        // Update latency every second
        latencyTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            Task { @MainActor in
                self.updateLatency()
            }
        }
    }
    
    private func updateMarketData() async {
        lastUpdate = Date()
        
        // Simulate market data update
        if let current = currentMarketData {
            let bidChange = Double.random(in: -2.0...2.0)
            let askChange = bidChange + Double.random(in: 0.1...0.5)
            
            let newData = MarketDataPoint(
                symbol: currentSymbol,
                bid: max(2300, current.bid + bidChange),
                ask: max(2300.5, current.ask + askChange),
                timestamp: Date(),
                volume: Int.random(in: 500...2000)
            )
            
            currentMarketData = newData
            dataHistory.append(newData)
            
            // Keep only last 100 data points
            if dataHistory.count > 100 {
                dataHistory.removeFirst()
            }
        }
        
        // Update status based on data freshness
        updateFeedStatus()
    }
    
    private func updateFeedStatus() {
        let timeSinceUpdate = Date().timeIntervalSince(lastUpdate)
        
        if timeSinceUpdate < 5 {
            feedStatus = .active
        } else if timeSinceUpdate < 30 {
            feedStatus = .delayed
        } else if timeSinceUpdate < 120 {
            feedStatus = .stale
        } else {
            feedStatus = .disconnected
        }
    }
    
    private func updateLatency() {
        // Simulate latency fluctuation
        let baseLatency = 25.0
        let variation = Double.random(in: -10...15)
        dataLatency = max(5.0, baseLatency + variation)
        
        // Update average latency
        averageLatency = (averageLatency * 0.9) + (dataLatency * 0.1)
        
        // Update connection quality based on latency
        if dataLatency < 50 {
            connectionQuality = "Excellent"
        } else if dataLatency < 100 {
            connectionQuality = "Good"
        } else if dataLatency < 200 {
            connectionQuality = "Fair"
        } else {
            connectionQuality = "Poor"
        }
    }
    
    private func updateMetrics() {
        // Update bytes received (simulate continuous data flow)
        bytesReceived += Int64.random(in: 1024...8192) // 1-8 KB per update
        
        // Update packets per second
        packetsPerSecond = Double.random(in: 30...60)
        
        // Update price updates per minute
        priceUpdatesPerMinute = Int.random(in: 100...150)
        
        // Simulate occasional errors
        if Double.random(in: 0...1) < 0.05 { // 5% chance
            errorCount += 1
        }
        
        totalRequests += Int.random(in: 1...5)
    }
    
    func refreshData() async {
        feedStatus = .active
        await updateMarketData()
        updateLatency()
        updateMetrics()
    }
    
    func switchSymbol(_ symbol: String) async {
        currentSymbol = symbol
        await refreshData()
    }
    
    func resetCounters() {
        errorCount = 0
        totalRequests = 0
        bytesReceived = 0
    }
    
    // MARK: - Computed Properties
    
    var formattedLatency: String {
        String(format: "%.1f ms", dataLatency)
    }
    
    var formattedAverageLatency: String {
        String(format: "%.1f ms", averageLatency)
    }
    
    var formattedBytesReceived: String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useMB, .useKB, .useBytes]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: bytesReceived)
    }
    
    var formattedPacketsPerSecond: String {
        String(format: "%.1f pps", packetsPerSecond)
    }
    
    var successRate: Double {
        guard totalRequests > 0 else { return 100.0 }
        return Double(totalRequests - errorCount) / Double(totalRequests) * 100
    }
    
    var formattedSuccessRate: String {
        String(format: "%.1f%%", successRate)
    }
    
    var connectionQualityColor: Color {
        switch connectionQuality {
        case "Excellent": return .green
        case "Good": return .mint
        case "Fair": return .yellow
        case "Poor": return .orange
        default: return .red
        }
    }
    
    var currentSpread: Double {
        guard let data = currentMarketData else { return 0.0 }
        return data.ask - data.bid
    }
    
    var formattedSpread: String {
        String(format: "%.2f", currentSpread)
    }
}

#Preview {
    VStack(spacing: 16) {
        Text("Real Data Manager")
            .font(.title)
            .fontWeight(.bold)
        
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Feed Status:")
                    .fontWeight(.semibold)
                Spacer()
                Text("Active")
                    .foregroundColor(.green)
            }
            
            HStack {
                Text("Quality:")
                    .fontWeight(.semibold)
                Spacer()
                Text("Excellent")
                    .foregroundColor(.green)
            }
            
            HStack {
                Text("Latency:")
                    .fontWeight(.semibold)
                Spacer()
                Text("25.5 ms")
                    .foregroundColor(.mint)
            }
            
            HStack {
                Text("Data Rate:")
                    .fontWeight(.semibold)
                Spacer()
                Text("45.2 pps")
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
    .padding()
    .environmentObject(RealDataManager())
}