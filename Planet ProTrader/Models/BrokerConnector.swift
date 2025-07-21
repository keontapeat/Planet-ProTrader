//
//  BrokerConnector.swift
//  Planet ProTrader
//
//  Created by Senior iOS Engineer on 1/25/25.
//

import SwiftUI
import Combine

@MainActor
class BrokerConnector: ObservableObject {
    @Published var isConnected = false
    @Published var connectionStatus = "Disconnected"
    @Published var brokerName = ""
    @Published var serverName = ""
    @Published var connectionQuality: ConnectionQuality = .poor
    @Published var lastPing: Double = 0.0
    @Published var reconnectAttempts = 0
    @Published var maxReconnectAttempts = 5
    @Published var autoReconnect = true
    @Published var connectionErrors: [ConnectionError] = []
    
    enum ConnectionQuality: String, CaseIterable {
        case excellent = "Excellent"
        case good = "Good" 
        case fair = "Fair"
        case poor = "Poor"
        case critical = "Critical"
        
        var color: Color {
            switch self {
            case .excellent: return .green
            case .good: return .mint
            case .fair: return .yellow
            case .poor: return .orange
            case .critical: return .red
            }
        }
        
        var icon: String {
            switch self {
            case .excellent: return "wifi"
            case .good: return "wifi"
            case .fair: return "wifi.slash"
            case .poor: return "wifi.exclamationmark"
            case .critical: return "wifi.slash"
            }
        }
    }
    
    struct ConnectionError: Identifiable {
        let id = UUID()
        let message: String
        let timestamp: Date
        let errorCode: Int
    }
    
    enum BrokerType: String, CaseIterable {
        case mt5 = "MetaTrader 5"
        case mt4 = "MetaTrader 4"
        case coinexx = "Coinexx"
        case tradeLocker = "TradeLocker"
        case custom = "Custom"
    }
    
    @Published var currentBroker: BrokerType = .coinexx
    @Published var accountNumber = ""
    @Published var isDemo = true
    
    private var connectionTimer: Timer?
    private var pingTimer: Timer?
    
    init() {
        setupDefaultConnection()
        startConnectionMonitoring()
    }
    
    deinit {
        connectionTimer?.invalidate()
        pingTimer?.invalidate()
    }
    
    private func setupDefaultConnection() {
        // Simulate default Coinexx connection
        brokerName = "Coinexx"
        serverName = "Coinexx-Demo"
        accountNumber = "845638"
        isConnected = true
        connectionStatus = "Connected"
        connectionQuality = .good
        lastPing = 45.2
    }
    
    private func startConnectionMonitoring() {
        // Monitor connection every 10 seconds
        connectionTimer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { _ in
            Task { @MainActor in
                await self.updateConnectionStatus()
            }
        }
        
        // Update ping every 5 seconds
        pingTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
            Task { @MainActor in
                self.updatePingStatus()
            }
        }
    }
    
    private func updateConnectionStatus() async {
        // Simulate connection status updates
        if isConnected {
            let randomQuality = ConnectionQuality.allCases.randomElement() ?? .good
            connectionQuality = randomQuality
            
            if connectionQuality == .critical || connectionQuality == .poor {
                // Simulate occasional disconnection
                if Bool.random() && Double.random(in: 0...1) < 0.1 {
                    await disconnect()
                }
            }
        }
    }
    
    private func updatePingStatus() {
        if isConnected {
            switch connectionQuality {
            case .excellent:
                lastPing = Double.random(in: 20...40)
            case .good:
                lastPing = Double.random(in: 40...80)
            case .fair:
                lastPing = Double.random(in: 80...150)
            case .poor:
                lastPing = Double.random(in: 150...300)
            case .critical:
                lastPing = Double.random(in: 300...1000)
            }
        } else {
            lastPing = 0.0
        }
    }
    
    func connect(broker: BrokerType, server: String, account: String, isDemo: Bool = true) async {
        self.currentBroker = broker
        self.brokerName = broker.rawValue
        self.serverName = server
        self.accountNumber = account
        self.isDemo = isDemo
        
        connectionStatus = "Connecting..."
        
        // Simulate connection delay
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        
        // Simulate connection success/failure
        if Bool.random() || Double.random(in: 0...1) > 0.1 { // 90% success rate
            isConnected = true
            connectionStatus = "Connected"
            connectionQuality = .good
            reconnectAttempts = 0
        } else {
            await handleConnectionError("Failed to connect to \(broker.rawValue)")
        }
    }
    
    func disconnect() async {
        isConnected = false
        connectionStatus = "Disconnected"
        connectionQuality = .poor
        reconnectAttempts = 0
    }
    
    func reconnect() async {
        guard !isConnected && reconnectAttempts < maxReconnectAttempts else { return }
        
        reconnectAttempts += 1
        connectionStatus = "Reconnecting... (\(reconnectAttempts)/\(maxReconnectAttempts))"
        
        await connect(
            broker: currentBroker,
            server: serverName,
            account: accountNumber,
            isDemo: isDemo
        )
    }
    
    private func handleConnectionError(_ message: String) async {
        let error = ConnectionError(
            message: message,
            timestamp: Date(),
            errorCode: 1001
        )
        
        connectionErrors.append(error)
        connectionStatus = "Connection Error"
        isConnected = false
        
        // Auto-reconnect if enabled
        if autoReconnect && reconnectAttempts < maxReconnectAttempts {
            try? await Task.sleep(nanoseconds: 3_000_000_000) // Wait 3 seconds
            await reconnect()
        }
    }
    
    var connectionStatusColor: Color {
        if isConnected {
            return .green
        } else if connectionStatus.contains("Connecting") || connectionStatus.contains("Reconnecting") {
            return .orange
        } else {
            return .red
        }
    }
    
    var formattedPing: String {
        if lastPing == 0 {
            return "-- ms"
        }
        return "\(Int(lastPing)) ms"
    }
    
    var connectionStrength: Double {
        switch connectionQuality {
        case .excellent: return 1.0
        case .good: return 0.8
        case .fair: return 0.6
        case .poor: return 0.4
        case .critical: return 0.2
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        Text("Broker Connector")
            .font(.title)
            .fontWeight(.bold)
        
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Status:")
                    .fontWeight(.semibold)
                Spacer()
                Text("Connected")
                    .foregroundColor(.green)
            }
            
            HStack {
                Text("Broker:")
                    .fontWeight(.semibold)
                Spacer()
                Text("Coinexx")
            }
            
            HStack {
                Text("Quality:")
                    .fontWeight(.semibold)
                Spacer()
                Text("Good")
                    .foregroundColor(.mint)
            }
            
            HStack {
                Text("Ping:")
                    .fontWeight(.semibold)
                Spacer()
                Text("45 ms")
                    .foregroundColor(.green)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
    .padding()
    .environmentObject(BrokerConnector())
}