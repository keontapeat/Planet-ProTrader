//
//  PlanetProTraderAIManager.swift
//  Planet ProTrader
//
//  Created by Keonta  on 7/17/25.
//

import Foundation
import SwiftUI
import Combine

class PlanetProTraderAIManager: ObservableObject {
    static let shared = PlanetProTraderAIManager()
    
    // Replace with your VPS IP
    private let baseURL = "http://172.234.201.231:8000/api"
    
    @Published var botStatus: BotStatus?
    @Published var accountInfo: AccountInfo?
    @Published var recentTrades: [Trade] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    private init() {}
    
    // MARK: - Data Models
    struct BotStatus: Codable {
        let status: String
        let botRunning: Bool
        let serviceStatus: String
        let timestamp: Int
        
        enum CodingKeys: String, CodingKey {
            case status
            case botRunning = "bot_running"
            case serviceStatus = "service_status"
            case timestamp
        }
    }
    
    struct AccountInfo: Codable {
        let status: String
        let account: Account
        let timestamp: Int
        
        struct Account: Codable {
            let login: Int
            let server: String
            let balance: Double
            let equity: Double
            let profit: Double
            let currency: String
            let leverage: Int
        }
    }
    
    struct Trade: Codable, Identifiable {
        let id = UUID()
        let timestamp: Int
        let type: String
        let status: String
        let log: String
        
        var formattedTime: String {
            let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            return formatter.string(from: date)
        }
        
        private enum CodingKeys: String, CodingKey {
            case timestamp, type, status, log
        }
    }
    
    struct TradeResponse: Codable {
        let status: String
        let trades: [Trade]
        let totalTrades: Int
        
        enum CodingKeys: String, CodingKey {
            case status, trades
            case totalTrades = "total_trades"
        }
    }
    
    // MARK: - API Methods
    func refreshData() {
        isLoading = true
        errorMessage = nil
        
        let group = DispatchGroup()
        
        // Get bot status
        group.enter()
        getBotStatus { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let status):
                    self.botStatus = status
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
                group.leave()
            }
        }
        
        // Get account info
        group.enter()
        getAccountInfo { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let info):
                    self.accountInfo = info
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
                group.leave()
            }
        }
        
        // Get recent trades
        group.enter()
        getRecentTrades { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.recentTrades = response.trades
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            self.isLoading = false
        }
    }
    
    private func getBotStatus(completion: @escaping (Result<BotStatus, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/status") else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(APIError.noData))
                return
            }
            
            do {
                let botStatus = try JSONDecoder().decode(BotStatus.self, from: data)
                completion(.success(botStatus))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    private func getAccountInfo(completion: @escaping (Result<AccountInfo, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/account") else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(APIError.noData))
                return
            }
            
            do {
                let accountInfo = try JSONDecoder().decode(AccountInfo.self, from: data)
                completion(.success(accountInfo))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    private func getRecentTrades(completion: @escaping (Result<TradeResponse, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/trades") else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(APIError.noData))
                return
            }
            
            do {
                let trades = try JSONDecoder().decode(TradeResponse.self, from: data)
                completion(.success(trades))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func startBot() {
        controlBot(action: "start")
    }
    
    func stopBot() {
        controlBot(action: "stop")
    }
    
    private func controlBot(action: String) {
        guard let url = URL(string: "\(baseURL)/control/\(action)") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = error.localizedDescription
                } else {
                    // Refresh data after starting/stopping
                    self.refreshData()
                }
            }
        }.resume()
    }
    
    func startAutoRefresh() {
        // Auto-refresh every 5 seconds
        Timer.publish(every: 5.0, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                self.refreshData()
            }
            .store(in: &cancellables)
    }
}

// MARK: - API Errors
enum APIError: Error {
    case invalidURL
    case noData
    case invalidResponse
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received"
        case .invalidResponse:
            return "Invalid response format"
        }
    }
}

#Preview {
    VStack {
        Text("Goldex AI Manager")
            .font(.title.bold())
        
        Text("AI-powered trading intelligence")
            .font(.caption)
            .foregroundColor(.secondary)
        
        Text("Status: Active")
            .font(.subheadline)
            .foregroundColor(.green)
    }
    .padding()
}