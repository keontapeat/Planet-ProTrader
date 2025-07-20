//
//  GoldexAIAPI.swift
//  GOLDEX AI
//
//  Created by Keonta  on 7/17/25.
//


import Foundation

class GoldenAIAPI {
    static let shared = GoldenAIAPI()
    private let baseURL = "http://YOUR_VPS_IP:5000/api"
    
    private init() {}
    
    // MARK: - Data Models
    struct BotStatus: Codable {
        let status: String
        let botRunning: Bool
        let serviceStatus: String
        let recentActivity: String
        let timestamp: Int
        
        enum CodingKeys: String, CodingKey {
            case status
            case botRunning = "bot_running"
            case serviceStatus = "service_status"
            case recentActivity = "recent_activity"
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
    
    struct TradeResponse: Codable {
        let status: String
        let trades: [Trade]
        let totalTrades: Int
        
        enum CodingKeys: String, CodingKey {
            case status, trades
            case totalTrades = "total_trades"
        }
        
        struct Trade: Codable {
            let timestamp: Int
            let type: String
            let status: String
            let log: String
        }
    }
    
    // MARK: - API Methods
    func getBotStatus(completion: @escaping (Result<BotStatus, Error>) -> Void) {
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
    
    func getAccountInfo(completion: @escaping (Result<AccountInfo, Error>) -> Void) {
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
    
    func getRecentTrades(completion: @escaping (Result<TradeResponse, Error>) -> Void) {
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
    
    func startBot(completion: @escaping (Result<String, Error>) -> Void) {
        controlBot(action: "start", completion: completion)
    }
    
    func stopBot(completion: @escaping (Result<String, Error>) -> Void) {
        controlBot(action: "stop", completion: completion)
    }
    
    private func controlBot(action: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/control/\(action)") else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(APIError.noData))
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let message = json["message"] as? String {
                    completion(.success(message))
                } else {
                    completion(.failure(APIError.invalidResponse))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
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

// MARK: - Usage Example in your SwiftUI View
/*
struct ContentView: View {
    @State private var botStatus: GoldenAIAPI.BotStatus?
    @State private var accountInfo: GoldenAIAPI.AccountInfo?
    @State private var isLoading = false
    
    var body: some View {
        VStack {
            if let status = botStatus {
                Text("Bot Status: \(status.botRunning ? "Running" : "Stopped")")
                    .foregroundColor(status.botRunning ? .green : .red)
            }
            
            if let account = accountInfo {
                VStack {
                    Text("Balance: $\(account.account.balance, specifier: "%.2f")")
                    Text("Equity: $\(account.account.equity, specifier: "%.2f")")
                    Text("Profit: $\(account.account.profit, specifier: "%.2f")")
                }
            }
            
            HStack {
                Button("Start Bot") {
                    GoldenAIAPI.shared.startBot { result in
                        // Handle result
                    }
                }
                
                Button("Stop Bot") {
                    GoldenAIAPI.shared.stopBot { result in
                        // Handle result
                    }
                }
            }
        }
        .onAppear {
            loadData()
        }
    }
    
    private func loadData() {
        isLoading = true
        
        GoldenAIAPI.shared.getBotStatus { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let status):
                    self.botStatus = status
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        }
        
        GoldenAIAPI.shared.getAccountInfo { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let info):
                    self.accountInfo = info
                case .failure(let error):
                    print("Error: \(error)")
                }
                self.isLoading = false
            }
        }
    }
}
*/
