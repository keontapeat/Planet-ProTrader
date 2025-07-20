//
//  VPSManager.swift
//  GOLDEX AI
//
//  Created by Goldex AI on 7/19/25.
//

import SwiftUI
import Foundation
import Network
import Combine

@MainActor
class VPSManager: ObservableObject {
    @Published var isConnected = false
    @Published var connectionStatus: ConnectionStatus = .disconnected
    @Published var lastPing: TimeInterval = 0
    @Published var activeBots: [VPSBotStatus] = []
    @Published var systemStats: VPSSystemStats?
    @Published var tradingLogs: [VPSTradingLog] = []
    @Published var errorLogs: [VPSErrorLog] = []
    
    private let vpsIP = "172.234.201.231"
    private let apiPort = 8080
    private let socketPort = 8081
    private var monitor: NWPathMonitor?
    private var connection: NWConnection?
    private var reconnectTimer: Timer?
    
    private var cancellables = Set<AnyCancellable>()
    
    enum ConnectionStatus: String, CaseIterable {
        case connected = "🟢 Connected"
        case connecting = "🟡 Connecting"
        case disconnected = "🔴 Disconnected"
        case error = "❌ Error"
        case maintenance = "🔧 Maintenance"
    }
    
    init() {
        setupNetworkMonitoring()
        startConnectionMonitoring()
    }
    
    // MARK: - Connection Management
    
    func connectToVPS() async {
        connectionStatus = .connecting
        
        do {
            let endpoint = NWEndpoint.hostPort(host: .init(vpsIP), port: .init(integerLiteral: UInt16(apiPort)))
            connection = NWConnection(to: endpoint, using: .tcp)
            
            connection?.stateUpdateHandler = { [weak self] state in
                DispatchQueue.main.async {
                    switch state {
                    case .ready:
                        self?.connectionStatus = .connected
                        self?.isConnected = true
                        self?.startDataSync()
                    case .waiting(let error):
                        print("Connection waiting: \(error)")
                        self?.connectionStatus = .connecting
                    case .failed(let error):
                        print("Connection failed: \(error)")
                        self?.connectionStatus = .error
                        self?.isConnected = false
                        self?.scheduleReconnect()
                    default:
                        self?.connectionStatus = .disconnected
                        self?.isConnected = false
                    }
                }
            }
            
            connection?.start(queue: .global())
            
            // Test API endpoint
            await testAPIConnection()
            
        } catch {
            connectionStatus = .error
            isConnected = false
            print("VPS Connection error: \(error)")
        }
    }
    
    private func testAPIConnection() async {
        do {
            let url = URL(string: "http://\(vpsIP):\(apiPort)/api/status")!
            let (data, response) = try await URLSession.shared.data(from: url)
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                lastPing = Date().timeIntervalSince1970
                await parseSystemStats(data)
            }
        } catch {
            print("API test failed: \(error)")
        }
    }
    
    private func scheduleReconnect() {
        reconnectTimer?.invalidate()
        reconnectTimer = Timer.scheduledTimer(withTimeInterval: 30, repeats: false) { [weak self] _ in
            Task {
                await self?.connectToVPS()
            }
        }
    }
    
    // MARK: - Data Synchronization
    
    private func startDataSync() {
        // Start periodic data fetching
        Timer.publish(every: 5, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                if self?.isConnected == true {
                    Task {
                        await self?.syncBotStatuses()
                        await self?.syncTradingLogs()
                        await self?.syncSystemStats()
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    private func syncBotStatuses() async {
        do {
            let url = URL(string: "http://\(vpsIP):\(apiPort)/api/bots/status")!
            let (data, _) = try await URLSession.shared.data(from: url)
            let botStatuses = try JSONDecoder().decode([VPSBotStatus].self, from: data)
            
            activeBots = botStatuses
        } catch {
            print("Failed to sync bot statuses: \(error)")
        }
    }
    
    private func syncTradingLogs() async {
        do {
            let url = URL(string: "http://\(vpsIP):\(apiPort)/api/trades/recent?limit=50")!
            let (data, _) = try await URLSession.shared.data(from: url)
            let logs = try JSONDecoder().decode([VPSTradingLog].self, from: data)
            
            tradingLogs = logs.sorted { $0.timestamp > $1.timestamp }
        } catch {
            print("Failed to sync trading logs: \(error)")
        }
    }
    
    private func syncSystemStats() async {
        do {
            let url = URL(string: "http://\(vpsIP):\(apiPort)/api/system/stats")!
            let (data, _) = try await URLSession.shared.data(from: url)
            let stats = try JSONDecoder().decode(VPSSystemStats.self, from: data)
            
            systemStats = stats
        } catch {
            print("Failed to sync system stats: \(error)")
        }
    }
    
    private func parseSystemStats(_ data: Data) async {
        do {
            let stats = try JSONDecoder().decode(VPSSystemStats.self, from: data)
            systemStats = stats
        } catch {
            print("Failed to parse system stats: \(error)")
        }
    }
    
    // MARK: - Bot Management
    
    func deployBot(_ bot: EnhancedProTraderBot) async -> Bool {
        do {
            let url = URL(string: "http://\(vpsIP):\(apiPort)/api/bots/deploy")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let deployRequest = VPSBotDeployRequest(
                botId: bot.id.uuidString,
                name: bot.name,
                strategy: bot.strategy.rawValue,
                config: VPSBotConfig(
                    maxRisk: bot.riskProfile.maxPositionSize,
                    stopLoss: bot.riskProfile.stopLossPercentage,
                    takeProfit: bot.riskProfile.takeProfitRatio,
                    aiEngine: bot.aiEngine.rawValue
                )
            )
            
            request.httpBody = try JSONEncoder().encode(deployRequest)
            
            let (_, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                return httpResponse.statusCode == 200
            }
            
            return false
        } catch {
            print("Failed to deploy bot: \(error)")
            return false
        }
    }
    
    func stopBot(_ botId: String) async -> Bool {
        do {
            let url = URL(string: "http://\(vpsIP):\(apiPort)/api/bots/\(botId)/stop")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            let (_, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                return httpResponse.statusCode == 200
            }
            
            return false
        } catch {
            print("Failed to stop bot: \(error)")
            return false
        }
    }
    
    func restartBot(_ botId: String) async -> Bool {
        do {
            let url = URL(string: "http://\(vpsIP):\(apiPort)/api/bots/\(botId)/restart")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            let (_, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                return httpResponse.statusCode == 200
            }
            
            return false
        } catch {
            print("Failed to restart bot: \(error)")
            return false
        }
    }
    
    func updateBotConfig(_ botId: String, config: VPSBotConfig) async -> Bool {
        do {
            let url = URL(string: "http://\(vpsIP):\(apiPort)/api/bots/\(botId)/config")!
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            request.httpBody = try JSONEncoder().encode(config)
            
            let (_, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                return httpResponse.statusCode == 200
            }
            
            return false
        } catch {
            print("Failed to update bot config: \(error)")
            return false
        }
    }
    
    // MARK: - Trading Operations
    
    func sendTradingSignal(_ signal: VPSTradingSignal) async -> Bool {
        do {
            let url = URL(string: "http://\(vpsIP):\(apiPort)/api/trading/signal")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            request.httpBody = try JSONEncoder().encode(signal)
            
            let (_, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                return httpResponse.statusCode == 200
            }
            
            return false
        } catch {
            print("Failed to send trading signal: \(error)")
            return false
        }
    }
    
    func closeTrade(_ tradeId: String) async -> Bool {
        do {
            let url = URL(string: "http://\(vpsIP):\(apiPort)/api/trades/\(tradeId)/close")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            let (_, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                return httpResponse.statusCode == 200
            }
            
            return false
        } catch {
            print("Failed to close trade: \(error)")
            return false
        }
    }
    
    // MARK: - Screenshot Management
    
    func uploadScreenshot(_ imageData: Data, tradeId: String) async -> String? {
        do {
            let url = URL(string: "http://\(vpsIP):\(apiPort)/api/screenshots/upload")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            let boundary = UUID().uuidString
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            
            var body = Data()
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"image\"; filename=\"screenshot.png\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
            body.append(imageData)
            body.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"tradeId\"\r\n\r\n".data(using: .utf8)!)
            body.append(tradeId.data(using: .utf8)!)
            body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
            
            request.httpBody = body
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                if let result = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let url = result["url"] as? String {
                    return url
                }
            }
            
            return nil
        } catch {
            print("Failed to upload screenshot: \(error)")
            return nil
        }
    }
    
    // MARK: - System Management
    
    func getSystemHealth() async -> VPSSystemHealth? {
        do {
            let url = URL(string: "http://\(vpsIP):\(apiPort)/api/system/health")!
            let (data, _) = try await URLSession.shared.data(from: url)
            let health = try JSONDecoder().decode(VPSSystemHealth.self, from: data)
            return health
        } catch {
            print("Failed to get system health: \(error)")
            return nil
        }
    }
    
    func restartSystem() async -> Bool {
        do {
            let url = URL(string: "http://\(vpsIP):\(apiPort)/api/system/restart")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            let (_, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                return httpResponse.statusCode == 200
            }
            
            return false
        } catch {
            print("Failed to restart system: \(error)")
            return false
        }
    }
    
    func updateSystemConfig(_ config: VPSSystemConfig) async -> Bool {
        do {
            let url = URL(string: "http://\(vpsIP):\(apiPort)/api/system/config")!
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            request.httpBody = try JSONEncoder().encode(config)
            
            let (_, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                return httpResponse.statusCode == 200
            }
            
            return false
        } catch {
            print("Failed to update system config: \(error)")
            return false
        }
    }
    
    // MARK: - Network Monitoring
    
    private func setupNetworkMonitoring() {
        monitor = NWPathMonitor()
        monitor?.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                if path.status == .satisfied && !(self?.isConnected ?? false) {
                    Task {
                        await self?.connectToVPS()
                    }
                } else if path.status != .satisfied {
                    self?.connectionStatus = .disconnected
                    self?.isConnected = false
                }
            }
        }
        monitor?.start(queue: .global())
    }
    
    private func startConnectionMonitoring() {
        Timer.publish(every: 30, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                Task {
                    await self?.pingVPS()
                }
            }
            .store(in: &cancellables)
    }
    
    private func pingVPS() async {
        do {
            let startTime = CFAbsoluteTimeGetCurrent()
            let url = URL(string: "http://\(vpsIP):\(apiPort)/api/ping")!
            let (_, response) = try await URLSession.shared.data(from: url)
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                let endTime = CFAbsoluteTimeGetCurrent()
                lastPing = (endTime - startTime) * 1000 // Convert to milliseconds
            }
        } catch {
            if self.isConnected {
                connectionStatus = .error
                isConnected = false
            }
        }
    }
    
    deinit {
        monitor?.cancel()
        connection?.cancel()
        reconnectTimer?.invalidate()
        cancellables.forEach { $0.cancel() }
    }
}

// MARK: - VPS Data Structures

struct VPSBotStatus: Codable, Identifiable {
    let id: String
    let name: String
    let status: String
    let isActive: Bool
    let uptime: TimeInterval
    let tradesCount: Int
    let profit: Double
    let lastActivity: Date
    let cpuUsage: Double
    let memoryUsage: Double
    let errors: [String]
}

struct VPSSystemStats: Codable {
    let timestamp: Date
    let cpuUsage: Double
    let memoryUsage: Double
    let diskUsage: Double
    let networkIn: Double
    let networkOut: Double
    let activeBots: Int
    let totalTrades: Int
    let uptime: TimeInterval
    let systemLoad: Double
}

struct VPSSystemHealth: Codable {
    let status: String
    let issues: [String]
    let recommendations: [String]
    let lastCheck: Date
    let services: [VPSServiceHealth]
}

struct VPSServiceHealth: Codable {
    let name: String
    let status: String
    let uptime: TimeInterval
    let lastError: String?
}

struct VPSTradingLog: Codable, Identifiable {
    let id: String
    let botId: String
    let symbol: String
    let action: String
    let price: Double
    let volume: Double
    let timestamp: Date
    let result: String
    let profit: Double?
    let duration: TimeInterval?
    let screenshotUrl: String?
}

struct VPSErrorLog: Codable, Identifiable {
    let id: String
    let timestamp: Date
    let level: String
    let component: String
    let message: String
    let details: String?
}

struct VPSBotDeployRequest: Codable {
    let botId: String
    let name: String
    let strategy: String
    let config: VPSBotConfig
}

struct VPSBotConfig: Codable {
    let maxRisk: Double
    let stopLoss: Double
    let takeProfit: Double
    let aiEngine: String
    var autoRestart: Bool = true
    var screenshotEnabled: Bool = true
    var newsFilterEnabled: Bool = true
    var maxConcurrentTrades: Int = 5
    var minConfidence: Double = 0.7
}

struct VPSTradingSignal: Codable {
    let botId: String
    let symbol: String
    let action: String // "BUY" or "SELL"
    let price: Double
    let volume: Double
    let stopLoss: Double?
    let takeProfit: Double?
    let confidence: Double
    let reasoning: String
    let timestamp: Date
}

struct VPSSystemConfig: Codable {
    let maxConcurrentBots: Int
    let systemRestartHour: Int
    let backupInterval: Int
    let logRetentionDays: Int
    let screenshotRetentionDays: Int
    let alertEmailEnabled: Bool
    let alertEmail: String?
}

// Preview removed - ContentView not available in model scope