//
//  MarketIntelligenceModels.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 1/27/25.
//  Ultimate Market Edge - COT Reports, Historical Data, Market Intelligence
//

import Foundation
import SwiftUI

// MARK: - Market Intelligence Models

struct MarketIntelligenceModels {
    
    // MARK: - COT Report Model
    
    struct COTReport: Identifiable, Codable {
        let id = UUID()
        let reportDate: Date
        let instrument: String
        let commercialLong: Double
        let commercialShort: Double
        let nonCommercialLong: Double
        let nonCommercialShort: Double
        let totalOpenInterest: Double
        let analysis: COTAnalysis
        let prediction: COTPrediction
        
        struct COTAnalysis: Codable {
            let netCommercial: Double
            let netNonCommercial: Double
            let commercialSentiment: SentimentLevel
            let speculativePositioning: PositioningLevel
            let marketBias: MarketBias
            let signals: [TradingSignal]
            let weeklyChanges: [PositionChange]
            
            enum SentimentLevel: String, CaseIterable, Codable {
                case extremelyBullish = "Extremely Bullish"
                case bullish = "Bullish"
                case neutral = "Neutral"
                case bearish = "Bearish"
                case extremelyBearish = "Extremely Bearish"
                
                var color: Color {
                    switch self {
                    case .extremelyBullish: return .green
                    case .bullish: return Color.green.opacity(0.7)
                    case .neutral: return .gray
                    case .bearish: return Color.red.opacity(0.7)
                    case .extremelyBearish: return .red
                    }
                }
            }
            
            enum PositioningLevel: String, CaseIterable, Codable {
                case extreme = "Extreme"
                case high = "High"
                case moderate = "Moderate"
                case low = "Low"
                
                var color: Color {
                    switch self {
                    case .extreme: return .red
                    case .high: return .orange
                    case .moderate: return .yellow
                    case .low: return .green
                    }
                }
            }
            
            enum MarketBias: String, CaseIterable, Codable {
                case bullish = "Bullish"
                case bearish = "Bearish"
                case neutral = "Neutral"
                case mixed = "Mixed"
                
                var arrow: String {
                    switch self {
                    case .bullish: return "arrow.up"
                    case .bearish: return "arrow.down"
                    case .neutral: return "arrow.left.and.right"
                    case .mixed: return "arrow.up.arrow.down"
                    }
                }
            }
            
            struct TradingSignal: Identifiable, Codable {
                let id = UUID()
                let type: SignalType
                let strength: SignalStrength
                let description: String
                let targetPrice: Double?
                let stopLoss: Double?
                let confidence: Double
                let timeframe: String
                
                enum SignalType: String, CaseIterable, Codable {
                    case buy = "Buy"
                    case sell = "Sell"
                    case hold = "Hold"
                    case reversal = "Reversal"
                    
                    var color: Color {
                        switch self {
                        case .buy: return .green
                        case .sell: return .red
                        case .hold: return .gray
                        case .reversal: return .orange
                        }
                    }
                }
                
                enum SignalStrength: String, CaseIterable, Codable {
                    case weak = "Weak"
                    case moderate = "Moderate"
                    case strong = "Strong"
                    case veryStrong = "Very Strong"
                    
                    var rating: Int {
                        switch self {
                        case .weak: return 1
                        case .moderate: return 2
                        case .strong: return 3
                        case .veryStrong: return 4
                        }
                    }
                }
            }
            
            struct PositionChange: Codable {
                let week: String
                let commercialChange: Double
                let nonCommercialChange: Double
                let openInterestChange: Double
                let significance: ChangeSignificance
                
                enum ChangeSignificance: String, CaseIterable, Codable {
                    case minimal = "Minimal"
                    case moderate = "Moderate"
                    case significant = "Significant"
                    case extreme = "Extreme"
                    
                    var color: Color {
                        switch self {
                        case .minimal: return .gray
                        case .moderate: return .blue
                        case .significant: return .orange
                        case .extreme: return .red
                        }
                    }
                }
            }
        }
        
        struct COTPrediction: Codable {
            let priceDirection: PredictionDirection
            let confidence: Double
            let targetRange: PriceRange
            let timeHorizon: TimeHorizon
            let keyLevels: [PriceLevel]
            let riskFactors: [String]
            
            enum PredictionDirection: String, CaseIterable, Codable {
                case strongBuy = "Strong Buy"
                case buy = "Buy"
                case neutral = "Neutral"
                case sell = "Sell"
                case strongSell = "Strong Sell"
                
                var color: Color {
                    switch self {
                    case .strongBuy: return .green
                    case .buy: return Color.green.opacity(0.7)
                    case .neutral: return .gray
                    case .sell: return Color.red.opacity(0.7)
                    case .strongSell: return .red
                    }
                }
            }
            
            enum TimeHorizon: String, CaseIterable, Codable {
                case shortTerm = "1-2 Weeks"
                case mediumTerm = "1-3 Months"
                case longTerm = "3-12 Months"
                
                var days: Int {
                    switch self {
                    case .shortTerm: return 14
                    case .mediumTerm: return 90
                    case .longTerm: return 365
                    }
                }
            }
            
            struct PriceRange: Codable {
                let low: Double
                let high: Double
                let mostProbable: Double
                
                var range: String {
                    return "$\(String(format: "%.2f", low)) - $\(String(format: "%.2f", high))"
                }
            }
            
            struct PriceLevel: Identifiable, Codable {
                let id = UUID()
                let price: Double
                let type: LevelType
                let importance: Importance
                let description: String
                
                enum LevelType: String, CaseIterable, Codable {
                    case support = "Support"
                    case resistance = "Resistance"
                    case target = "Target"
                    case stopLoss = "Stop Loss"
                    
                    var color: Color {
                        switch self {
                        case .support: return .green
                        case .resistance: return .red
                        case .target: return .blue
                        case .stopLoss: return .orange
                        }
                    }
                }
                
                enum Importance: String, CaseIterable, Codable {
                    case low = "Low"
                    case medium = "Medium"
                    case high = "High"
                    case critical = "Critical"
                    
                    var weight: Double {
                        switch self {
                        case .low: return 0.25
                        case .medium: return 0.5
                        case .high: return 0.75
                        case .critical: return 1.0
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Enhanced Historical Data
    
    struct EnhancedHistoricalData: Identifiable, Codable {
        let id = UUID()
        let symbol: String
        let timeframe: String
        let data: [HistoricalDataPoint]
        let patterns: [PatternRecognition]
        let statistics: MarketStatistics
        let seasonality: SeasonalityAnalysis
        let correlations: CorrelationData
        
        struct HistoricalDataPoint: Identifiable, Codable {
            let id = UUID()
            let timestamp: Date
            let open: Double
            let high: Double
            let low: Double
            let close: Double
            let volume: Int64
            let indicators: TechnicalIndicators
            let marketEvents: [MarketEvent]
            
            struct TechnicalIndicators: Codable {
                let rsi: Double
                let macd: Double
                let macdSignal: Double
                let macdHist: Double
                let bb_upper: Double
                let bb_middle: Double
                let bb_lower: Double
                let atr: Double
                let adx: Double
                let stoch_k: Double
                let stoch_d: Double
                let ema_9: Double
                let ema_21: Double
                let ema_50: Double
                let ema_200: Double
                let pivotPoint: Double
                let resistance1: Double
                let resistance2: Double
                let support1: Double
                let support2: Double
            }
            
            struct MarketEvent: Identifiable, Codable {
                let id = UUID()
                let title: String
                let date: Date
                let impact: EventImpact
                let description: String
                let priceEffect: Double
                let category: EventCategory
                
                enum EventImpact: String, CaseIterable, Codable {
                    case low = "Low"
                    case medium = "Medium"
                    case high = "High"
                    case extreme = "Extreme"
                    
                    var color: Color {
                        switch self {
                        case .low: return .green
                        case .medium: return .yellow
                        case .high: return .orange
                        case .extreme: return .red
                        }
                    }
                }
                
                enum EventCategory: String, CaseIterable, Codable {
                    case economic = "Economic"
                    case geopolitical = "Geopolitical"
                    case monetary = "Monetary Policy"
                    case technical = "Technical"
                    
                    var icon: String {
                        switch self {
                        case .economic: return "chart.bar"
                        case .geopolitical: return "globe"
                        case .monetary: return "banknote"
                        case .technical: return "chart.line.uptrend.xyaxis"
                        }
                    }
                }
            }
        }
        
        struct PatternRecognition: Identifiable, Codable {
            let id = UUID()
            let patternType: PatternType
            let confidence: Double
            let timeframe: String
            let startDate: Date
            let endDate: Date?
            let keyPoints: [PatternPoint]
            let prediction: PatternPrediction
            
            enum PatternType: String, CaseIterable, Codable {
                case headAndShoulders = "Head and Shoulders"
                case doubleTop = "Double Top"
                case doubleBottom = "Double Bottom"
                case triangle = "Triangle"
                case flag = "Flag"
                case wedge = "Wedge"
                case cup = "Cup and Handle"
                
                var bullishProbability: Double {
                    switch self {
                    case .headAndShoulders: return 0.3
                    case .doubleTop: return 0.2
                    case .doubleBottom: return 0.8
                    case .triangle: return 0.5
                    case .flag: return 0.7
                    case .wedge: return 0.4
                    case .cup: return 0.8
                    }
                }
            }
            
            struct PatternPoint: Identifiable, Codable {
                let id = UUID()
                let date: Date
                let price: Double
                let type: PointType
                let significance: Double
                
                enum PointType: String, CaseIterable, Codable {
                    case peak = "Peak"
                    case valley = "Valley"
                    case breakout = "Breakout"
                    case support = "Support"
                    case resistance = "Resistance"
                }
            }
            
            struct PatternPrediction: Codable {
                let direction: PredictionDirection
                let targetPrice: Double
                let stopLoss: Double
                let probability: Double
                let timeToTarget: TimeInterval
                
                enum PredictionDirection: String, CaseIterable, Codable {
                    case bullish = "Bullish"
                    case bearish = "Bearish"
                    case neutral = "Neutral"
                    
                    var arrow: String {
                        switch self {
                        case .bullish: return "arrow.up"
                        case .bearish: return "arrow.down"
                        case .neutral: return "arrow.left.and.right"
                        }
                    }
                }
            }
        }
        
        struct MarketStatistics: Codable {
            let avgDailyRange: Double
            let avgDailyVolume: Int64
            let volatility: Double
            let correlation_DXY: Double
            let correlation_SPX: Double
            let correlation_10Y: Double
            let bestTradingHours: [TradingHour]
            let worstTradingHours: [TradingHour]
            let seasonalBias: [MonthlyBias]
            
            struct TradingHour: Codable {
                let hour: Int
                let avgMove: Double
                let winRate: Double
                let volume: Double
            }
            
            struct MonthlyBias: Codable {
                let month: Int
                let avgReturn: Double
                let winRate: Double
                let volatility: Double
            }
        }
        
        struct SeasonalityAnalysis: Codable {
            let monthlyPerformance: [MonthlyPerformance]
            let weeklyBias: WeeklyBias
            let intraday: IntradaySeasonality
            
            struct MonthlyPerformance: Identifiable, Codable {
                let id = UUID()
                let month: Int
                let avgReturn: Double
                let winRate: Double
                let bestYears: [Int]
                let worstYears: [Int]
                
                var monthName: String {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "MMMM"
                    return formatter.string(from: Calendar.current.date(from: DateComponents(month: month))!)
                }
            }
            
            struct WeeklyBias: Codable {
                let mondayBias: Double
                let tuesdayBias: Double
                let wednesdayBias: Double
                let thursdayBias: Double
                let fridayBias: Double
                
                var bestDay: String {
                    let days = [
                        ("Monday", mondayBias),
                        ("Tuesday", tuesdayBias),
                        ("Wednesday", wednesdayBias),
                        ("Thursday", thursdayBias),
                        ("Friday", fridayBias)
                    ]
                    return days.max { $0.1 < $1.1 }?.0 ?? "Monday"
                }
            }
            
            struct IntradaySeasonality: Codable {
                let londonOpen: SessionStatsModel
                let newYorkOpen: SessionStatsModel
                let asiaOpen: SessionStatsModel
                let overlap: SessionStatsModel
                
                struct SessionStatsModel: Codable {
                    let averageVolatility: Double
                    let priceDirection: SessionDirection
                    let strength: Double
                    let reliability: Double
                    let optimalEntry: String
                    let riskLevel: RiskLevel
                    
                    enum SessionDirection: String, CaseIterable, Codable {
                        case bullish = "Bullish"
                        case bearish = "Bearish"
                        case neutral = "Neutral"
                        
                        var color: Color {
                            switch self {
                            case .bullish: return .green
                            case .bearish: return .red
                            case .neutral: return .gray
                            }
                        }
                    }
                    
                    enum RiskLevel: String, CaseIterable, Codable {
                        case low = "Low"
                        case medium = "Medium"
                        case high = "High"
                        case extreme = "Extreme"
                        
                        var color: Color {
                            switch self {
                            case .low: return .green
                            case .medium: return .yellow
                            case .high: return .orange
                            case .extreme: return .red
                            }
                        }
                    }
                }
            }
        }
        
        struct CorrelationData: Codable {
            let dollarIndex: CorrelationStats
            let sp500: CorrelationStats
            let bitcoin: CorrelationStats
            let bonds: CorrelationStats
            let oil: CorrelationStats
            
            struct CorrelationStats: Codable {
                let pearsonCorrelation: Double
                let rollingCorrelation: Double
                let significance: Double
                let trend: CorrelationTrend
                let strength: CorrelationStrength
                
                enum CorrelationTrend: String, CaseIterable, Codable {
                    case increasing = "Increasing"
                    case decreasing = "Decreasing"
                    case stable = "Stable"
                    case volatile = "Volatile"
                    
                    var color: Color {
                        switch self {
                        case .increasing: return .green
                        case .decreasing: return .red
                        case .stable: return .blue
                        case .volatile: return .orange
                        }
                    }
                }
                
                enum CorrelationStrength: String, CaseIterable, Codable {
                    case veryWeak = "Very Weak"
                    case weak = "Weak"
                    case moderate = "Moderate"
                    case strong = "Strong"
                    case veryStrong = "Very Strong"
                    
                    var threshold: Double {
                        switch self {
                        case .veryWeak: return 0.2
                        case .weak: return 0.4
                        case .moderate: return 0.6
                        case .strong: return 0.8
                        case .veryStrong: return 1.0
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Free API Sources
    
    struct FreeAPIConfig: Codable {
        let sources: [APISource]
        
        struct APISource: Identifiable, Codable {
            let id = UUID()
            let name: String
            let baseURL: String
            let apiKey: String?
            let rateLimit: RateLimit
            let reliability: Double
            let coverage: DataCoverage
            let cost: APICost
            
            struct RateLimit: Codable {
                let requestsPerMinute: Int
                let requestsPerDay: Int
                let requestsPerMonth: Int
                
                var formattedLimits: String {
                    return "\(requestsPerMinute)/min, \(requestsPerDay)/day, \(requestsPerMonth)/month"
                }
            }
            
            struct DataCoverage: Codable {
                let instruments: [String]
                let timeframes: [String]
                let historicalDepth: String
                let realTime: Bool
                let fundamentalData: Bool
                
                var instrumentCount: Int {
                    return instruments.count
                }
            }
            
            enum APICost: String, CaseIterable, Codable {
                case free = "Free"
                case freemium = "Freemium"
                case paid = "Paid"
                case enterprise = "Enterprise"
                
                var color: Color {
                    switch self {
                    case .free: return .green
                    case .freemium: return .blue
                    case .paid: return .orange
                    case .enterprise: return .purple
                    }
                }
            }
        }
        
        static let sampleAPISources: [APISource] = [
            APISource(
                name: "Alpha Vantage",
                baseURL: "https://www.alphavantage.co/query",
                apiKey: nil,
                rateLimit: APISource.RateLimit(requestsPerMinute: 120, requestsPerDay: 1000, requestsPerMonth: 100000),
                reliability: 0.95,
                coverage: APISource.DataCoverage(
                    instruments: ["XAUUSD", "XAGUSD", "DXY", "EURUSD"],
                    timeframes: ["1min", "5min", "15min", "30min", "1hour", "4hour", "daily"],
                    historicalDepth: "20+ years",
                    realTime: true,
                    fundamentalData: true
                ),
                cost: .freemium
            ),
            APISource(
                name: "IEX Cloud",
                baseURL: "https://cloud.iexapis.com/stable",
                apiKey: nil,
                rateLimit: APISource.RateLimit(requestsPerMinute: 10, requestsPerDay: 100, requestsPerMonth: 1000),
                reliability: 0.92,
                coverage: APISource.DataCoverage(
                    instruments: ["GLD", "SLV", "SPY", "QQQ"],
                    timeframes: ["1min", "5min", "daily"],
                    historicalDepth: "5 years",
                    realTime: true,
                    fundamentalData: false
                ),
                cost: .freemium
            ),
            APISource(
                name: "FRED Economic Data",
                baseURL: "https://api.stlouisfed.org/fred",
                apiKey: nil,
                rateLimit: APISource.RateLimit(requestsPerMinute: 5, requestsPerDay: 500, requestsPerMonth: 25000),
                reliability: 0.99,
                coverage: APISource.DataCoverage(
                    instruments: ["Gold Price", "USD Index", "Interest Rates"],
                    timeframes: ["daily", "weekly", "monthly"],
                    historicalDepth: "50+ years",
                    realTime: false,
                    fundamentalData: true
                ),
                cost: .free
            ),
            APISource(
                name: "Financial Modeling Prep",
                baseURL: "https://financialmodelingprep.com/api/v3",
                apiKey: nil,
                rateLimit: APISource.RateLimit(requestsPerMinute: 100, requestsPerDay: 2000, requestsPerMonth: 100000),
                reliability: 0.94,
                coverage: APISource.DataCoverage(
                    instruments: ["XAUUSD", "Stocks", "Forex", "Crypto"],
                    timeframes: ["1min", "5min", "15min", "daily"],
                    historicalDepth: "30+ years",
                    realTime: true,
                    fundamentalData: true
                ),
                cost: .freemium
            ),
            APISource(
                name: "Quandl (Nasdaq Data Link)",
                baseURL: "https://www.quandl.com/api/v3",
                apiKey: nil,
                rateLimit: APISource.RateLimit(requestsPerMinute: 10, requestsPerDay: 50, requestsPerMonth: 50000),
                reliability: 0.97,
                coverage: APISource.DataCoverage(
                    instruments: ["Gold", "Commodities", "Economic Indicators"],
                    timeframes: ["daily", "weekly", "monthly"],
                    historicalDepth: "100+ years",
                    realTime: false,
                    fundamentalData: true
                ),
                cost: .freemium
            )
        ]
    }
    
    // MARK: - Sample Data
    
    static let sampleCOTReports: [COTReport] = [
        COTReport(
            id: UUID(),
            reportDate: Date(),
            instrument: "XAUUSD",
            commercialLong: 245678,
            commercialShort: 189432,
            nonCommercialLong: 124321,
            nonCommercialShort: 98765,
            totalOpenInterest: 125000,
            analysis: COTAnalysis(
                netCommercial: 56246,
                netNonCommercial: 12345,
                commercialSentiment: .bullish,
                speculativePositioning: .high,
                marketBias: .bullish,
                signals: [
                    TradingSignal(
                        id: UUID(),
                        type: .buy,
                        strength: .strong,
                        description: "Commercial traders increasing net long",
                        targetPrice: 1800,
                        stopLoss: 1600,
                        confidence: 0.85,
                        timeframe: "3 months"
                    )
                ],
                weeklyChanges: [
                    PositionChange(
                        week: "2024-03-04",
                        commercialChange: 12453,
                        nonCommercialChange: -8976,
                        openInterestChange: 1500,
                        significance: .moderate
                    )
                ]
            ),
            prediction: COTPrediction(
                priceDirection: .strongBuy,
                confidence: 0.85,
                targetRange: PriceRange(
                    low: 1800,
                    high: 2200,
                    mostProbable: 2000
                ),
                timeHorizon: .mediumTerm,
                keyLevels: [
                    PriceLevel(
                        id: UUID(),
                        price: 1850,
                        type: .support,
                        importance: .high,
                        description: "Key support level"
                    ),
                    PriceLevel(
                        id: UUID(),
                        price: 2100,
                        type: .resistance,
                        importance: .high,
                        description: "Key resistance level"
                    )
                ],
                riskFactors: ["Interest rates", "Inflation"]
            )
        )
    ]
    
    // MARK: - Sample Data Extensions
    static let sampleSeasonality: SeasonalityAnalysis = SeasonalityAnalysis(
        monthlyPerformance: [
            SeasonalityAnalysis.MonthlyPerformance(
                month: 1,
                avgReturn: 2.5,
                winRate: 0.65,
                bestYears: [2020, 2021, 2022],
                worstYears: [2008, 2018]
            )
        ],
        weeklyBias: SeasonalityAnalysis.WeeklyBias(
            mondayBias: 0.2,
            tuesdayBias: -0.1,
            wednesdayBias: 0.3,
            thursdayBias: 0.1,
            fridayBias: -0.2
        ),
        intraday: SeasonalityAnalysis.IntradaySeasonality(
            londonOpen: SeasonalityAnalysis.IntradaySeasonality.SessionStatsModel(
                averageVolatility: 0.012,
                priceDirection: .bullish,
                strength: 0.73,
                reliability: 0.81,
                optimalEntry: "08:00 GMT",
                riskLevel: .medium
            ),
            newYorkOpen: SeasonalityAnalysis.IntradaySeasonality.SessionStatsModel(
                averageVolatility: 0.018,
                priceDirection: .neutral,
                strength: 0.65,
                reliability: 0.74,
                optimalEntry: "13:30 GMT",
                riskLevel: .high
            ),
            asiaOpen: SeasonalityAnalysis.IntradaySeasonality.SessionStatsModel(
                averageVolatility: 0.008,
                priceDirection: .bearish,
                strength: 0.58,
                reliability: 0.69,
                optimalEntry: "00:00 GMT",
                riskLevel: .low
            ),
            overlap: SeasonalityAnalysis.IntradaySeasonality.SessionStatsModel(
                averageVolatility: 0.022,
                priceDirection: .bullish,
                strength: 0.84,
                reliability: 0.89,
                optimalEntry: "12:00 GMT",
                riskLevel: .extreme
            )
        )
    )

    // MARK: - Market Intelligence Manager
    
    @MainActor
    class MarketIntelligenceManager: ObservableObject {
        @Published var cotReports: [COTReport] = []
        @Published var historicalData: [EnhancedHistoricalData] = []
        @Published var isLoading = false
        @Published var lastUpdate: Date?
        @Published var dataQualityScore: Double = 0.0
        
        private let apiConfig = FreeAPIConfig.sampleAPISources
        
        init() {
            loadMarketIntelligence()
        }
        
        // MARK: - Data Loading
        
        func loadMarketIntelligence() {
            isLoading = true
            
            Task {
                await loadCOTReports()
                await loadHistoricalData()
                await calculateDataQuality()
                
                isLoading = false
                lastUpdate = Date()
            }
        }
        
        private func loadCOTReports() async {
            // Simulate loading COT reports
            cotReports = sampleCOTReports
        }
        
        private func loadHistoricalData() async {
            // Simulate loading enhanced historical data
        }
        
        private func calculateDataQuality() async {
            // Calculate overall data quality based on API sources
            let qualitySum = apiConfig.reduce(0.0) { sum, source in
                switch source.cost {
                case .free: return sum + 4.0
                case .freemium: return sum + 3.0
                case .paid: return sum + 2.0
                case .enterprise: return sum + 1.0
                }
            }
            
            dataQualityScore = (qualitySum / Double(apiConfig.count)) / 4.0 * 100.0
        }
    }
}

#Preview("Market Intelligence Models") {
    NavigationView {
        VStack {
            Text("Ultimate Market Edge")
                .font(.title)
                .padding()
            
            Text("COT Reports + Historical Data + FREE APIs! 📊")
                .font(Font.system(size: 17, weight: .semibold, design: .default))

            Spacer()
        }
    }
}