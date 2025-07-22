//
//  Constants.swift
//  Planet ProTrader - App Constants
//
//  MARK: - Centralized Constants
//  Created by Claude Doctor™
//

import SwiftUI
import Foundation

// MARK: - App Constants

struct Constants {
    
    // MARK: - App Info
    struct App {
        static let name = "Planet ProTrader"
        static let version = "1.0.0"
        static let buildNumber = "100"
        static let bundleId = "com.planetprotrader.app"
    }
    
    // MARK: - API Configuration
    struct API {
        static let baseURL = "https://api.planetprotrader.com"
        static let timeout: TimeInterval = 30.0
        static let retryAttempts = 3
        
        // Endpoints
        static let auth = "/auth"
        static let trading = "/trading"
        static let market = "/market"
        static let bots = "/bots"
    }
    
    // MARK: - Trading Configuration
    struct Trading {
        static let defaultLeverage = 500
        static let maxPositionSize = 0.1
        static let minTradeAmount = 0.01
        static let defaultStopLoss = 50.0 // pips
        static let defaultTakeProfit = 100.0 // pips
        static let maxActivePositions = 20
    }
    
    // MARK: - UI Configuration
    struct UI {
        static let animationDuration: TimeInterval = 0.3
        static let longAnimationDuration: TimeInterval = 0.8
        static let cardCornerRadius: CGFloat = 16
        static let buttonCornerRadius: CGFloat = 12
        static let defaultPadding: CGFloat = 16
        static let largeSpacing: CGFloat = 24
        static let smallSpacing: CGFloat = 8
    }
    
    // MARK: - Colors
    struct Colors {
        static let primaryGold = "#FFD700"
        static let secondaryGold = "#FFA500"
        static let bullishGreen = "#00C851"
        static let bearishRed = "#FF4444"
        static let warningOrange = "#FFC107"
        static let infoBlue = "#17A2B8"
    }
    
    // MARK: - Notifications
    struct Notifications {
        static let priceAlert = "price_alert"
        static let tradeExecuted = "trade_executed"
        static let botUpdate = "bot_update"
        static let systemAlert = "system_alert"
    }
    
    // MARK: - UserDefaults Keys
    struct UserDefaults {
        static let isFirstLaunch = "is_first_launch"
        static let selectedTheme = "selected_theme"
        static let notificationsEnabled = "notifications_enabled"
        static let hapticEnabled = "haptic_enabled"
        static let autoTradingEnabled = "auto_trading_enabled"
        static let lastUpdateCheck = "last_update_check"
    }
    
    // MARK: - File Paths
    struct Paths {
        static let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        static let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        static let logsDirectory = documentsDirectory.appendingPathComponent("Logs")
        static let dataDirectory = documentsDirectory.appendingPathComponent("Data")
    }
    
    // MARK: - Debug Configuration
    struct Debug {
        static let enableLogging = true
        static let logLevel: LogLevel = .verbose
        static let enableCrashReporting = true
        static let enablePerformanceMonitoring = true
        
        enum LogLevel: String, CaseIterable {
            case none = "NONE"
            case error = "ERROR"
            case warning = "WARNING"  
            case info = "INFO"
            case verbose = "VERBOSE"
        }
    }
    
    // MARK: - Network Configuration
    struct Network {
        static let timeoutInterval: TimeInterval = 30.0
        static let maxConcurrentOperations = 5
        static let cachePolicy: URLRequest.CachePolicy = .reloadRevalidatingCacheData
        static let retryDelay: TimeInterval = 2.0
    }
    
    // MARK: - Security
    struct Security {
        static let keychainService = "PlanetProTraderKeychain"
        static let encryptionKey = "planet_protrader_key_2024"
        static let sessionTimeout: TimeInterval = 3600 // 1 hour
        static let maxLoginAttempts = 5
    }
    
    // MARK: - Performance Limits
    struct Performance {
        static let maxCacheSize = 100 * 1024 * 1024 // 100MB
        static let maxLogFileSize = 10 * 1024 * 1024 // 10MB
        static let maxHistoryItems = 1000
        static let refreshInterval: TimeInterval = 5.0
        static let backgroundTaskTimeout: TimeInterval = 30.0
    }
    
    // MARK: - Feature Flags
    struct Features {
        static let enableCharts = true
        static let enablePushNotifications = true
        static let enableBiometrics = true
        static let enableDarkMode = true
        static let enableAdvancedAnalytics = true
        static let enableSocialTrading = false // Future feature
    }
}

// MARK: - Environment Configuration

enum Environment {
    case development
    case staging
    case production
    
    static let current: Environment = {
        #if DEBUG
        return .development
        #else
        return .production
        #endif
    }()
    
    var apiURL: String {
        switch self {
        case .development:
            return "https://dev-api.planetprotrader.com"
        case .staging:
            return "https://staging-api.planetprotrader.com"
        case .production:
            return "https://api.planetprotrader.com"
        }
    }
    
    var enableLogging: Bool {
        switch self {
        case .development, .staging:
            return true
        case .production:
            return false
        }
    }
}

// MARK: - App URLs

struct AppURLs {
    static let website = URL(string: "https://www.planetprotrader.com")!
    static let support = URL(string: "https://support.planetprotrader.com")!
    static let terms = URL(string: "https://www.planetprotrader.com/terms")!
    static let privacy = URL(string: "https://www.planetprotrader.com/privacy")!
    static let appStore = URL(string: "https://apps.apple.com/app/planet-protrader/id123456789")!
}

// MARK: - Validation Rules

struct ValidationRules {
    static let minPasswordLength = 8
    static let maxPasswordLength = 128
    static let minUsernameLength = 3
    static let maxUsernameLength = 30
    static let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
}

#Preview {
    VStack(spacing: 16) {
        Text("📱 \(Constants.App.name)")
            .font(.title.bold())
            .foregroundStyle(Color(hex: Constants.Colors.primaryGold) ?? .yellow)
        
        Text("Version \(Constants.App.version) (\(Constants.App.buildNumber))")
            .font(.subheadline)
            .foregroundColor(.secondary)
        
        VStack(alignment: .leading, spacing: 8) {
            Text("🏗 Configuration:")
                .font(.headline)
            
            Group {
                Text("• Environment: \(Environment.current)")
                Text("• API URL: \(Environment.current.apiURL)")
                Text("• Logging: \(Environment.current.enableLogging ? "Enabled" : "Disabled")")
                Text("• Max Positions: \(Constants.Trading.maxActivePositions)")
                Text("• Default Leverage: \(Constants.Trading.defaultLeverage)x")
            }
            .font(.caption)
            .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        
        Text("✅ Constants Loaded Successfully")
            .font(.headline)
            .foregroundColor(.green)
    }
    .padding()
    .preferredColorScheme(.light)
}