//
//  MT5SignalSender.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 7/13/25.
//

import Foundation
import SwiftUI
import Network

/// Real-time MT5 signal sender for GOLDEX AI
@MainActor
class MT5SignalSender: ObservableObject {
    @Published var isConnected: Bool = false
    @Published var lastSignalSent: Date?
    @Published var signalsSentToday: Int = 0
    @Published var connectionStatus: String = "Disconnected"
    
    private let mt5ServerHost = "localhost" // Your MT5 terminal IP
    private let mt5ServerPort: UInt16 = 9090 // Custom port for signal communication
    private var connection: NWConnection?
    
    // MARK: - Connection Management
    
    func connectToMT5() async {
        await startConnection()
    }
    
    func disconnectFromMT5() {
        connection?.cancel()
        connection = nil
        isConnected = false
        connectionStatus = "Disconnected"
    }
    
    private func startConnection() async {
        let endpoint = NWEndpoint.hostPort(host: NWEndpoint.Host(mt5ServerHost), port: NWEndpoint.Port(mt5ServerPort)!)
        connection = NWConnection(to: endpoint, using: .tcp)
        
        connection?.stateUpdateHandler = { [weak self] state in
            Task { @MainActor in
                await self?.handleConnectionStateUpdate(state)
            }
        }
        
        connection?.start(queue: .global())
        connectionStatus = "Connecting..."
    }
    
    private func handleConnectionStateUpdate(_ state: NWConnection.State) async {
        switch state {
        case .ready:
            isConnected = true
            connectionStatus = "Connected to MT5"
            print("✅ Connected to MT5 EA")
            
        case .failed(let error):
            isConnected = false
            connectionStatus = "Connection failed: \(error.localizedDescription)"
            print("❌ MT5 connection failed: \(error)")
            
        case .cancelled:
            isConnected = false
            connectionStatus = "Connection cancelled"
            print("⚠️ MT5 connection cancelled")
            
        default:
            connectionStatus = "Connecting..."
        }
    }
    
    // MARK: - Signal Sending
    
    func sendSignalToMT5(_ signal: SharedTypes.AutoTradingSignal) async -> Bool {
        guard isConnected, let connection = connection else {
            print("❌ Cannot send signal: Not connected to MT5")
            return false
        }
        
        let signalData = createSignalData(signal)
        
        return await withCheckedContinuation { continuation in
            connection.send(content: signalData, completion: .contentProcessed { error in
                if let error = error {
                    print("❌ Failed to send signal: \(error)")
                    continuation.resume(returning: false)
                } else {
                    print("✅ Signal sent to MT5 successfully")
                    Task { @MainActor in
                        self.lastSignalSent = Date()
                        self.signalsSentToday += 1
                    }
                    continuation.resume(returning: true)
                }
            })
        }
    }
    
    func sendManualSignal(_ signal: ManualTradingSignal) async -> Bool {
        guard isConnected, let connection = connection else {
            print("❌ Cannot send manual signal: Not connected to MT5")
            return false
        }
        
        let signalData = createManualSignalData(signal)
        
        return await withCheckedContinuation { continuation in
            connection.send(content: signalData, completion: .contentProcessed { error in
                if let error = error {
                    print("❌ Failed to send manual signal: \(error)")
                    continuation.resume(returning: false)
                } else {
                    print("✅ Manual signal sent to MT5 successfully")
                    Task { @MainActor in
                        self.lastSignalSent = Date()
                        self.signalsSentToday += 1
                    }
                    continuation.resume(returning: true)
                }
            })
        }
    }
    
    // MARK: - Data Creation
    
    private func createSignalData(_ signal: SharedTypes.AutoTradingSignal) -> Data {
        let signalDict: [String: Any] = [
            "id": signal.id,
            "mode": signal.mode.rawValue,
            "direction": signal.direction.rawValue,
            "entry_price": signal.entryPrice,
            "stop_loss": signal.stopLoss,
            "take_profit": signal.takeProfit,
            "lot_size": signal.lotSize,
            "confidence": signal.confidence,
            "reasoning": signal.reasoning,
            "timestamp": ISO8601DateFormatter().string(from: signal.timestamp),
            "timeframe": signal.timeframe,
            "expected_duration": signal.expectedDuration,
            "source": "GOLDEX_AI_iOS",
            "symbol": "XAUUSD"
        ]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: signalDict)
        return jsonData
    }
    
    private func createManualSignalData(_ signal: ManualTradingSignal) -> Data {
        let signalDict: [String: Any] = [
            "id": signal.id.uuidString,
            "mode": "manual",
            "direction": signal.action.rawValue,
            "entry_price": signal.entryPrice,
            "stop_loss": signal.stopLoss,
            "take_profit": signal.takeProfit,
            "lot_size": signal.lotSize,
            "confidence": signal.confidence,
            "reasoning": signal.reasoning,
            "timestamp": ISO8601DateFormatter().string(from: signal.timestamp),
            "timeframe": "1M",
            "expected_duration": 1800,
            "source": "GOLDEX_AI_MANUAL",
            "symbol": signal.symbol
        ]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: signalDict)
        return jsonData
    }
    
    // MARK: - Account Commands
    
    func sendAccountCommand(_ command: MT5Command) async -> Bool {
        guard isConnected, let connection = connection else {
            print("❌ Cannot send command: Not connected to MT5")
            return false
        }
        
        let commandData = createCommandData(command)
        
        return await withCheckedContinuation { continuation in
            connection.send(content: commandData, completion: .contentProcessed { error in
                if let error = error {
                    print("❌ Failed to send command: \(error)")
                    continuation.resume(returning: false)
                } else {
                    print("✅ Command sent to MT5 successfully")
                    continuation.resume(returning: true)
                }
            })
        }
    }
    
    private func createCommandData(_ command: MT5Command) -> Data {
        let commandDict: [String: Any] = [
            "type": "command",
            "action": command.action,
            "parameters": command.parameters,
            "timestamp": ISO8601DateFormatter().string(from: Date()),
            "source": "GOLDEX_AI_iOS"
        ]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: commandDict)
        return jsonData
    }
}

// MARK: - MT5 Command Structure

struct MT5Command {
    let action: String
    let parameters: [String: Any]
}

// MARK: - MT5 Status View

struct MT5ConnectionStatusView: View {
    @StateObject private var signalSender = MT5SignalSender()
    @State private var showConnectionDetails = false
    
    var body: some View {
        VStack(spacing: 16) {
            // Connection Status Header
            HStack {
                Image(systemName: signalSender.isConnected ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .font(.title2)
                    .foregroundColor(signalSender.isConnected ? .green : .red)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("MT5 Connection")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(signalSender.connectionStatus)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button(action: {
                    withAnimation {
                        showConnectionDetails.toggle()
                    }
                }) {
                    Image(systemName: "info.circle")
                        .font(.title3)
                        .foregroundColor(.blue)
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
            
            // Connection Details (Expandable)
            if showConnectionDetails {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Connection Details")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    DetailRow(title: "Server", value: "localhost:9090")
                    DetailRow(title: "Status", value: signalSender.connectionStatus)
                    DetailRow(title: "Signals Sent Today", value: "\(signalSender.signalsSentToday)")
                    
                    if let lastSignal = signalSender.lastSignalSent {
                        DetailRow(title: "Last Signal", value: lastSignal.formatted(date: .omitted, time: .standard))
                    }
                    
                    // Connection Controls
                    HStack(spacing: 12) {
                        Button(action: {
                            Task {
                                await signalSender.connectToMT5()
                            }
                        }) {
                            Text("Connect")
                                .font(.subheadline)
                                .foregroundColor(.white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Color.blue)
                                .cornerRadius(8)
                        }
                        .disabled(signalSender.isConnected)
                        
                        Button(action: {
                            signalSender.disconnectFromMT5()
                        }) {
                            Text("Disconnect")
                                .font(.subheadline)
                                .foregroundColor(.white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Color.red)
                                .cornerRadius(8)
                        }
                        .disabled(!signalSender.isConnected)
                        
                        Spacer()
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .onAppear {
            Task {
                await signalSender.connectToMT5()
            }
        }
    }
}

struct DetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
                .foregroundColor(.primary)
        }
    }
}

// MARK: - Preview

#Preview {
    MT5ConnectionStatusView()
        .padding()
}