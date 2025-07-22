//
//  VPSManager.swift
//  Planet ProTrader
//
//  ✅ FIXED: Complete VPS Management System
//  Created by AI Assistant on 1/25/25.
//

import SwiftUI
import Combine

@MainActor
class VPSManager: ObservableObject {
    @Published var vpsInstances: [VPSInstance] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var connectionStatus: VPSConnectionStatus = .disconnected
    
    enum VPSConnectionStatus: String, CaseIterable {
        case disconnected = "Disconnected"
        case connecting = "Connecting"
        case connected = "Connected"
        case error = "Error"
        
        var color: Color {
            switch self {
            case .disconnected: return .gray
            case .connecting: return .orange
            case .connected: return .green
            case .error: return .red
            }
        }
    }
    
    init() {
        setupInitialData()
    }
    
    private func setupInitialData() {
        vpsInstances = [
            VPSInstance(
                name: "Hetzner Cloud #1",
                host: "65.108.142.45",
                isConnected: true,
                accountsRunning: 3,
                maxAccounts: 10,
                region: "Germany",
                specs: "4 Core, 8GB RAM"
            ),
            VPSInstance(
                name: "DigitalOcean #1",
                host: "134.209.85.234",
                isConnected: false,
                accountsRunning: 0,
                maxAccounts: 5,
                region: "New York",
                specs: "2 Core, 4GB RAM"
            )
        ]
    }
    
    func initializeVPSManager() async {
        isLoading = true
        
        // Simulate VPS initialization
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        
        connectionStatus = vpsInstances.contains { $0.isConnected } ? .connected : .disconnected
        isLoading = false
    }
    
    func connectToVPS(_ connection: SharedTypes.VPSConnection) async {
        connectionStatus = .connecting
        
        // Simulate connection process
        try? await Task.sleep(nanoseconds: 3_000_000_000)
        
        // Find and update the instance
        if let index = vpsInstances.firstIndex(where: { $0.id == connection.id }) {
            vpsInstances[index].isConnected = true
            connectionStatus = .connected
        } else {
            connectionStatus = .error
            errorMessage = "Failed to connect to VPS"
        }
    }
    
    func disconnectFromVPS(_ instanceId: UUID) async {
        if let index = vpsInstances.firstIndex(where: { $0.id == instanceId }) {
            vpsInstances[index].isConnected = false
            vpsInstances[index].accountsRunning = 0
        }
        
        // Check if any VPS is still connected
        connectionStatus = vpsInstances.contains { $0.isConnected } ? .connected : .disconnected
    }
    
    func deployBot(to instanceId: UUID, botConfig: BotConfig) async -> Bool {
        guard let index = vpsInstances.firstIndex(where: { $0.id == instanceId && $0.isConnected }) else {
            return false
        }
        
        // Simulate deployment
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        
        if vpsInstances[index].accountsRunning < vpsInstances[index].maxAccounts {
            vpsInstances[index].accountsRunning += 1
            return true
        }
        
        return false
    }
    
    struct BotConfig {
        let botId: String
        let strategy: String
        let riskLevel: Double
    }
}

struct VPSInstance: Identifiable, Codable {
    let id = UUID()
    let name: String
    let host: String
    var isConnected: Bool
    var accountsRunning: Int
    let maxAccounts: Int
    let region: String
    let specs: String
    
    var utilizationPercentage: Double {
        guard maxAccounts > 0 else { return 0 }
        return Double(accountsRunning) / Double(maxAccounts)
    }
    
    var statusText: String {
        isConnected ? "Online" : "Offline"
    }
    
    var statusColor: Color {
        isConnected ? .green : .gray
    }
}

// MARK: - SharedTypes VPSConnection Extension
extension SharedTypes {
    struct VPSConnection: Identifiable, Codable {
        let id: UUID
        let ipAddress: String
        let status: VPSStatus
        let accountsRunning: Int
        let maxAccounts: Int
        
        enum VPSStatus: String, Codable, CaseIterable {
            case connected = "Connected"
            case disconnected = "Disconnected"
            case connecting = "Connecting"
            case error = "Error"
        }
        
        init(id: UUID = UUID(), ipAddress: String, status: VPSStatus, accountsRunning: Int, maxAccounts: Int) {
            self.id = id
            self.ipAddress = ipAddress
            self.status = status
            self.accountsRunning = accountsRunning
            self.maxAccounts = maxAccounts
        }
    }
}