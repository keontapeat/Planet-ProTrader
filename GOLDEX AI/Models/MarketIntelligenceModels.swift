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
        let id: UUID
        let reportDate: Date
        let marketSymbol: String
        let positions: COTPositions
        let analysis: COTAnalysis
        let sentiment: MarketSentiment
        let prediction: COTPrediction
        let historicalContext: HistoricalContext
        
        struct COTPositions: Codable {
            // Commercial (Smart Money) - Banks, Funds, Institutions
            let commercialLong: Int64
            let commercialShort: Int64
            let commercialNet: Int64
            
            // Large Speculators (Hedge Funds, CTAs)
            let largeLong: Int64
            let largeShort: Int64
            let largeNet: Int64
            
            // Small Speculators (Retail Traders)
            let smallLong: Int64
            let smallShort: Int64
            let smallNet: Int64
            
            // Non-Reportable (Smaller Players)
            let nonReportableLong: Int64
            let nonReportableShort: Int64
            
            var commercialNetChange: Int64?
            var largeNetChange: Int64?
            var smallNetChange: Int64?
            
            var smartMoneyBias: SmartMoneyBias {
                if commercialNet > 50000 {
                    return .bullish
                } else if commercialNet < -50000 {
                    return .bearish
                } else {
                    return .neutral
                }
            }
            
            enum SmartMoneyBias: String, CaseIterable {
                case bullish = "BULLISH"
                case bearish = "BEARISH" 
                case neutral = "NEUTRAL"
                
                var color: Color {
                    switch self {
                    case .bullish: return .green
                    case .bearish: return .red
                    case .neutral: return .gray
                    }
                }
                
                var emoji: String {
                    switch self {
                    case .bullish: return "🟢"
                    case .bearish: return "🔴"
                    case .neutral: return "🟡"
                    }
                }
            }
            
            var retailVsSmartMoney: RetailSentiment {
                // When retail is extremely bullish and smart money is bearish = contrarian signal
                let retailBullishness = Double(smallNet) / Double(smallLong + smallShort) * 100
                let smartMoneyBullishness = Double(commercialNet) / Double(commercialLong + commercialShort) * 100
                
                if retailBullishness > 70 && smartMoneyBullishness < -30 {
                    return .extremeContrarian
                } else if retailBullishness < -70 && smartMoneyBullishness > 30 {
                    return .extremeContrarian
                } else if abs(retailBullishness - smartMoneyBullishness) > 50 {
                    return .contrarian
                } else {
                    return .aligned
                }
            }
            
            enum RetailSentiment: String {
                case extremeContrarian = "EXTREME_CONTRARIAN"
                case contrarian = "CONTRARIAN"
                case aligned = "ALIGNED"
                
                var signal: String {
                    switch self {
                    case .extremeContrarian: return "🚨 EXTREME CONTRARIAN SIGNAL"
                    case .contrarian: return "⚠️ Contrarian Signal"
                    case .aligned: return "✅ Aligned Sentiment"
                    }
                }
                
                var description: String {
                    switch self {
                    case .extremeContrarian: return "Retail and Smart Money in extreme disagreement - High probability reversal"
                    case .contrarian: return "Retail and Smart Money disagree - Potential reversal setup"
                    case .aligned: return "Retail and Smart Money agree - Trend continuation likely"
                    }
                }
            }
        }
        
        struct COTAnalysis: Codable {
            let overallSentiment: String
            let keySignals: [TradingSignal]
            let extremeReadings: [ExtremeReading]
            let weeklyChange: PositionChange
            let historicalPercentile: HistoricalPercentile
            
            struct TradingSignal: Identifiable, Codable {
                let id: UUID
                let type: SignalType
                let strength: SignalStrength
                let description: String
                let actionable: Bool
                
                enum SignalType: String, CaseIterable {
                    case contrarian = "CONTRARIAN"
                    case momentum = "MOMENTUM" 
                    case extreme = "EXTREME"
                    case divergence = "DIVERGENCE"
                    
                    var icon: String {
                        switch self {
                        case .contrarian: return "arrow.triangle.2.circlepath"
                        case .momentum: return "arrow.up.right"
                        case .extreme: return "exclamationmark.triangle"
                        case .divergence: return "arrow.left.arrow.right"
                        }
                    }
                }
                
                enum SignalStrength: String, CaseIterable {
                    case weak = "WEAK"
                    case moderate = "MODERATE"
                    case strong = "STRONG"
                    case extreme = "EXTREME"
                    
                    var color: Color {
                        switch self {
                        case .weak: return .gray
                        case .moderate: return .yellow
                        case .strong: return .orange
                        case .extreme: return .red
                        }
                    }
                }
            }
            
            struct ExtremeReading: Identifiable, Codable {
                let id: UUID
                let category: String // "Commercial Long", "Retail Short", etc.
                let currentValue: Int64
                let percentile: Double // 0-100
                let implication: String
            }
            
            struct PositionChange: Codable {
                let commercialChange: Int64
                let largeSpecChange: Int64
                let smallSpecChange: Int64
                let significance: ChangeSignificance
                
                enum ChangeSignificance: String {
                    case minor = "MINOR"
                    case notable = "NOTABLE"
                    case major = "MAJOR"
                    case extreme = "EXTREME"
                }
            }
            
            struct HistoricalPercentile: Codable {
                let commercialNetPercentile: Double
                let largeSpecNetPercentile: Double
                let smallSpecNetPercentile: Double
                
                var isCommercialExtreme: Bool {
                    commercialNetPercentile > 90 || commercialNetPercentile < 10
                }
            }
        }
        
        struct COTPrediction: Codable {
            let priceDirection: PriceDirection
            let timeframe: PredictionTimeframe
            let confidence: Double
            let targets: PriceTargets
            let reasoning: [String]
            
            enum PriceDirection: String, CaseIterable {
                case bullish = "BULLISH"
                case bearish = "BEARISH"
                case sideways = "SIDEWAYS"
                
                var emoji: String {
                    switch self {
                    case .bullish: return "📈"
                    case .bearish: return "📉" 
                    case .sideways: return "➡️"
                    }
                }
            }
            
            enum PredictionTimeframe: String, CaseIterable {
                case shortTerm = "1-2 weeks"
                case mediumTerm = "1-2 months"
                case longTerm = "3-6 months"
            }
            
            struct PriceTargets: Codable {
                let upside: Double?
                let downside: Double?
                let probability: Double
            }
        }
        
        struct HistoricalContext: Codable {
            let similarSetups: [HistoricalSetup]
            let successRate: Double
            let avgMoveSize: Double
            let avgTimeToTarget: Int // days
            
            struct HistoricalSetup: Identifiable, Codable {
                let id: UUID
                let date: Date
                let setup: String
                let outcome: String
                let moveSize: Double
                let timeToMove: Int
            }
        }
    }
    
    // MARK: - Enhanced Historical Data
    
    struct EnhancedHistoricalData: Identifiable, Codable {
        let id: UUID
        let symbol: String
        let timeframe: String
        let data: [HistoricalDataPoint]
        let patterns: [PatternRecognition]
        let statistics: MarketStatistics
        let seasonality: SeasonalityAnalysis
        let correlations: CorrelationData
        
        struct HistoricalDataPoint: Identifiable, Codable {
            let id: UUID
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
                let id: UUID
                let type: EventType
                let description: String
                let impact: EventImpact
                
                enum EventType: String, CaseIterable {
                    case fomc = "FOMC"
                    case nfp = "NFP" 
                    case cpi = "CPI"
                    case centralBank = "CENTRAL_BANK"
                    case geopolitical = "GEOPOLITICAL"
                    case earnings = "EARNINGS"
                    case technical = "TECHNICAL"
                }
                
                enum EventImpact: String, CaseIterable {
                    case high = "HIGH"
                    case medium = "MEDIUM" 
                    case low = "LOW"
                }
            }
        }
        
        struct PatternRecognition: Identifiable, Codable {
            let id: UUID
            let pattern: PatternType
            let startDate: Date
            let endDate: Date
            let reliability: Double
            let priceTarget: Double
            let stopLoss: Double
            let status: PatternStatus
            
            enum PatternType: String, CaseIterable {
                case headAndShoulders = "HEAD_AND_SHOULDERS"
                case doubleTop = "DOUBLE_TOP"
                case doubleBottom = "DOUBLE_BOTTOM"
                case triangle = "TRIANGLE"
                case flag = "FLAG"
                case wedge = "WEDGE"
                case cupAndHandle = "CUP_AND_HANDLE"
                
                var description: String {
                    switch self {
                    case .headAndShoulders: return "Head and Shoulders"
                    case .doubleTop: return "Double Top"
                    case .doubleBottom: return "Double Bottom"
                    case .triangle: return "Triangle"
                    case .flag: return "Flag"
                    case .wedge: return "Wedge"
                    case .cupAndHandle: return "Cup and Handle"
                    }
                }
            }
            
            enum PatternStatus: String, CaseIterable {
                case forming = "FORMING"
                case complete = "COMPLETE"
                case confirmed = "CONFIRMED"
                case failed = "FAILED"
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
                let id: UUID
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
                let londonOpen: SessionStats
                let newYorkOpen: Session Stats
                let asianSession: SessionStats
                let overlap_London_NY: SessionStats
                
                struct SessionStats: Codable {
                    let avgMove: Double
                    let direction: String // "Bullish", "Bearish", "Neutral"
                    let reliability: Double
                    let volume: Double
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
                let correlation: Double
                let strength: CorrelationStrength
                let reliability: Double
                let divergences: [DivergenceEvent]
                
                enum CorrelationStrength: String, CaseIterable {
                    case veryStrong = "VERY_STRONG"  // > 0.8
                    case strong = "STRONG"          // 0.6-0.8
                    case moderate = "MODERATE"      // 0.3-0.6
                    case weak = "WEAK"              // < 0.3
                    
                    var description: String {
                        switch self {
                        case .veryStrong: return "Very Strong"
                        case .strong: return "Strong"
                        case .moderate: return "Moderate"
                        case .weak: return "Weak"
                        }
                    }
                }
                
                struct DivergenceEvent: Identifiable, Codable {
                    let id: UUID
                    let date: Date
                    let description: String
                    let significance: Double
                }
            }
        }
    }
    
    // MARK: - Free API Sources
    
    struct FreeAPIConfig: Codable {
        let sources: [APISource]
        
        struct APISource: Identifiable, Codable {
            let id: UUID
            let name: String
            let type: APIType
            let baseURL: String
            let endpoints: [String]
            let rateLimit: RateLimit
            let dataQuality: DataQuality
            let coverage: DataCoverage
            
            enum APIType: String, CaseIterable {
                case historical = "HISTORICAL"
                case realtime = "REALTIME"
                case cot = "COT"
                case news = "NEWS"
                case economic = "ECONOMIC"
                case sentiment = "SENTIMENT"
            }
            
            struct RateLimit: Codable {
                let requestsPerMinute: Int
                let requestsPerDay: Int
                let requestsPerMonth: Int
            }
            
            enum DataQuality: String, CaseIterable {
                case excellent = "EXCELLENT"
                case good = "GOOD"
                case fair = "FAIR"
                case basic = "BASIC"
            }
            
            struct DataCoverage: Codable {
                let symbols: [String]
                let timeframes: [String]
                let historyLength: String
                let updateFrequency: String
            }
        }
        
        static let freeAPIs = FreeAPIConfig(sources: [
            APISource(
                id: UUID(),
                name: "FRED Economic Data",
                type: .economic,
                baseURL: "https://api.stlouisfed.org/fred",
                endpoints: [
                    "/series/observations?series_id=GOLDAMGBD228NLBM", // Gold prices
                    "/series/observations?series_id=DGS10",            // 10Y Treasury
                    "/series/observations?series_id=DEXUSEU"           // DXY
                ],
                rateLimit: RateLimit(requestsPerMinute: 120, requestsPerDay: 1000, requestsPerMonth: 100000),
                dataQuality: .excellent,
                coverage: DataCoverage(
                    symbols: ["GOLD", "DXY", "10Y", "RATES"],
                    timeframes: ["1D", "1W", "1M"],
                    historyLength: "50+ years",
                    updateFrequency: "Daily"
                )
            ),
            APISource(
                id: UUID(),
                name: "CFTC COT Reports",
                type: .cot,
                baseURL: "https://www.cftc.gov/dea/newcot",
                endpoints: [
                    "/c_disagg.txt",        // Disaggregated COT
                    "/f_disagg.txt",        // Financial COT
                    "/c_year.txt"           // Historical COT
                ],
                rateLimit: RateLimit(requestsPerMinute: 10, requestsPerDay: 100, requestsPerMonth: 1000),
                dataQuality: .excellent,
                coverage: DataCoverage(
                    symbols: ["GOLD", "SILVER", "CRUDE", "FOREX"],
                    timeframes: ["1W"],
                    historyLength: "20+ years",
                    updateFrequency: "Weekly (Friday)"
                )
            ),
            APISource(
                id: UUID(),
                name: "Alpha Vantage",
                type: .historical,
                baseURL: "https://www.alphavantage.co/query",
                endpoints: [
                    "?function=TIME_SERIES_DAILY&symbol=XAUUSD",
                    "?function=FX_DAILY&from_symbol=USD&to_symbol=EUR",
                    "?function=COMMODITY_CHANNEL_INDEX"
                ],
                rateLimit: RateLimit(requestsPerMinute: 5, requestsPerDay: 500, requestsPerMonth: 25000),
                dataQuality: .good,
                coverage: DataCoverage(
                    symbols: ["XAUUSD", "FOREX", "STOCKS"],
                    timeframes: ["1M", "5M", "15M", "1H", "1D"],
                    historyLength: "20+ years",
                    updateFrequency: "Real-time"
                )
            ),
            APISource(
                id: UUID(),
                name: "Yahoo Finance",
                type: .historical,
                baseURL: "https://query1.finance.yahoo.com/v8/finance/chart",
                endpoints: [
                    "/GC=F?interval=1d&range=5y",    // Gold futures
                    "/DX-Y.NYB?interval=1d&range=5y", // Dollar Index
                    "/^GSPC?interval=1d&range=5y"     // S&P 500
                ],
                rateLimit: RateLimit(requestsPerMinute: 100, requestsPerDay: 2000, requestsPerMonth: 100000),
                dataQuality: .good,
                coverage: DataCoverage(
                    symbols: ["GOLD", "DXY", "SPX", "BONDS"],
                    timeframes: ["1M", "5M", "1H", "1D"],
                    historyLength: "10+ years",
                    updateFrequency: "Real-time"
                )
            ),
            APISource(
                id: UUID(),
                name: "Quandl/NASDAQ Data",
                type: .historical,
                baseURL: "https://data.nasdaq.com/api/v3/datasets",
                endpoints: [
                    "/LBMA/GOLD.json",              // London Bullion Market
                    "/CHRIS/CME_GC1.json",         // CME Gold Futures
                    "/FRED/GOLDAMGBD228NLBM.json"  // Fed Gold Price
                ],
                rateLimit: RateLimit(requestsPerMinute: 10, requestsPerDay: 50, requestsPerMonth: 50000),
                dataQuality: .excellent,
                coverage: DataCoverage(
                    symbols: ["GOLD", "SILVER", "COMMODITIES"],
                    timeframes: ["1D"],
                    historyLength: "40+ years",
                    updateFrequency: "Daily"
                )
            )
        ])
    }
    
    // MARK: - Market Intelligence Manager
    
    @MainActor
    class MarketIntelligenceManager: ObservableObject {
        @Published var cotReports: [COTReport] = []
        @Published var historicalData: [EnhancedHistoricalData] = []
        @Published var isLoading = false
        @Published var lastUpdate: Date?
        @Published var dataQualityScore: Double = 0.0
        
        private let apiConfig = FreeAPIConfig.freeAPIs
        
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
            cotReports = COTReport.sampleReports
        }
        
        private func loadHistoricalData() async {
            // Simulate loading enhanced historical data
            historicalData = EnhancedHistoricalData.sampleData
        }
        
        private func calculateDataQuality() async {
            // Calculate overall data quality based on API sources
            let qualitySum = apiConfig.sources.reduce(0.0) { sum, source in
                switch source.dataQuality {
                case .excellent: return sum + 4.0
                case .good: return sum + 3.0
                case .fair: return sum + 2.0
                case .basic: return sum + 1.0
                }
            }
            
            dataQualityScore = (qualitySum / Double(apiConfig.sources.count)) / 4.0 * 100.0
        }
        
        // MARK: - Smart Money Analysis
        
        func getSmartMoneySignals() -> [COTReport.COTAnalysis.TradingSignal] {
            guard let latestCOT = cotReports.first else { return [] }
            
            var signals: [COTReport.COTAnalysis.TradingSignal] = []
            
            // Commercial extreme positioning
            if latestCOT.analysis.historicalPercentile.isCommercialExtreme {
                signals.append(COTReport.COTAnalysis.TradingSignal(
                    id: UUID(),
                    type: .extreme,
                    strength: .strong,
                    description: "Commercial traders at extreme positioning - High probability reversal setup",
                    actionable: true
                ))
            }
            
            // Retail vs Smart Money divergence
            if latestCOT.positions.retailVsSmartMoney == .extremeContrarian {
                signals.append(COTReport.COTAnalysis.TradingSignal(
                    id: UUID(),
                    type: .contrarian,
                    strength: .extreme,
                    description: "Extreme retail vs smart money divergence - Major reversal incoming",
                    actionable: true
                ))
            }
            
            return signals
        }
        
        // MARK: - Best Time to Trade
        
        func getBestTradingTimes() -> [String] {
            guard let goldData = historicalData.first(where: { $0.symbol == "XAUUSD" }) else {
                return ["London Open (8:00 GMT)", "NY Open (13:00 GMT)"]
            }
            
            let bestHours = goldData.statistics.bestTradingHours
                .sorted { $0.winRate > $1.winRate }
                .prefix(3)
                .map { hour in
                    "\(hour.hour):00 GMT (Win Rate: \(String(format: "%.1f", hour.winRate))%)"
                }
            
            return Array(bestHours)
        }
        
        // MARK: - Seasonal Edge
        
        func getCurrentSeasonalBias() -> String {
            let currentMonth = Calendar.current.component(.month, from: Date())
            
            guard let goldData = historicalData.first(where: { $0.symbol == "XAUUSD" }),
                  let monthlyData = goldData.seasonality.monthlyPerformance.first(where: { $0.month == currentMonth }) else {
                return "Neutral bias - No seasonal data available"
            }
            
            if monthlyData.avgReturn > 2.0 {
                return "🟢 Strong bullish seasonal bias (\(String(format: "%.1f", monthlyData.avgReturn))% avg return)"
            } else if monthlyData.avgReturn < -2.0 {
                return "🔴 Strong bearish seasonal bias (\(String(format: "%.1f", monthlyData.avgReturn))% avg return)"
            } else {
                return "🟡 Neutral seasonal bias"
            }
        }
        
        // MARK: - Ultimate Edge Score
        
        func calculateUltimateEdgeScore() -> Double {
            var score = 0.0
            
            // COT signals weight (30%)
            let cotSignals = getSmartMoneySignals()
            if !cotSignals.isEmpty {
                let avgStrength = cotSignals.reduce(0.0) { sum, signal in
                    switch signal.strength {
                    case .extreme: return sum + 4.0
                    case .strong: return sum + 3.0
                    case .moderate: return sum + 2.0
                    case .weak: return sum + 1.0
                    }
                } / Double(cotSignals.count)
                score += (avgStrength / 4.0) * 30.0
            }
            
            // Historical patterns weight (25%)
            let patternScore = historicalData.first?.patterns.filter { $0.reliability > 0.7 }.count ?? 0
            score += min(25.0, Double(patternScore) * 5.0)
            
            // Seasonal bias weight (20%)
            let currentMonth = Calendar.current.component(.month, from: Date())
            if let monthlyData = historicalData.first?.seasonality.monthlyPerformance.first(where: { $0.month == currentMonth }) {
                score += (monthlyData.winRate / 100.0) * 20.0
            }
            
            // Data quality weight (15%)
            score += (dataQualityScore / 100.0) * 15.0
            
            // Correlation analysis weight (10%)
            score += 10.0 // Default bonus for having correlation data
            
            return min(100.0, score)
        }
    }
}

// MARK: - Sample Data

extension MarketIntelligenceModels.COTReport {
    static let sampleReports: [MarketIntelligenceModels.COTReport] = [
        MarketIntelligenceModels.COTReport(
            id: UUID(),
            reportDate: Date().addingTimeInterval(-86400 * 3), // 3 days ago (Tuesday report)
            marketSymbol: "XAUUSD",
            positions: MarketIntelligenceModels.COTReport.COTPositions(
                commercialLong: 245678,
                commercialShort: 189432,
                commercialNet: 56246,
                largeLong: 123456,
                largeShort: 187643,
                largeNet: -64187,
                smallLong: 87234,
                smallShort: 76543,
                smallNet: 10691,
                nonReportableLong: 45321,
                nonReportableShort: 56789,
                commercialNetChange: 12453,
                largeNetChange: -8976,
                smallNetChange: 3421
            ),
            analysis: MarketIntelligenceModels.COTReport.COTAnalysis(
                overallSentiment: "Smart money is building long positions while large specs are short - Classic contrarian setup",
                keySignals: [
                    MarketIntelligenceModels.COTReport.COTAnalysis.TradingSignal(
                        id: UUID(),
                        type: .contrarian,
                        strength: .strong,
                        description: "Commercial traders increased net long by 12,453 contracts - Bullish signal",
                        actionable: true
                    ),
                    MarketIntelligenceModels.COTReport.COTAnalysis.TradingSignal(
                        id: UUID(),
                        type: .extreme,
                        strength: .moderate,
                        description: "Large speculators at 85th percentile short - Potential squeeze setup",
                        actionable: true
                    )
                ],
                extremeReadings: [
                    MarketIntelligenceModels.COTReport.COTAnalysis.ExtremeReading(
                        id: UUID(),
                        category: "Commercial Long",
                        currentValue: 245678,
                        percentile: 78.5,
                        implication: "Above average bullish positioning by smart money"
                    )
                ],
                weeklyChange: MarketIntelligenceModels.COTReport.COTAnalysis.PositionChange(
                    commercialChange: 12453,
                    largeSpecChange: -8976,
                    smallSpecChange: 3421,
                    significance: .notable
                ),
                historicalPercentile: MarketIntelligenceModels.COTReport.COTAnalysis.HistoricalPercentile(
                    commercialNetPercentile: 78.5,
                    largeSpecNetPercentile: 15.2,
                    smallSpecNetPercentile: 62.3
                )
            ),
            sentiment: MarketSentiment(
                overall: "BULLISH",
                confidence: 75.8,
                keyFactors: ["Smart money accumulation", "Large spec extremes", "Seasonal tailwinds"]
            ),
            prediction: MarketIntelligenceModels.COTReport.COTPrediction(
                priceDirection: .bullish,
                timeframe: .mediumTerm,
                confidence: 78.5,
                targets: MarketIntelligenceModels.COTReport.COTPrediction.PriceTargets(
                    upside: 2450.0,
                    downside: 2280.0,
                    probability: 0.785
                ),
                reasoning: [
                    "Commercial traders building largest long position in 6 months",
                    "Large speculators at extreme short positioning (15th percentile)",
                    "Historical setups with similar COT structure succeeded 78% of the time",
                    "Seasonal Q1 gold strength typically begins in late January"
                ]
            ),
            historicalContext: MarketIntelligenceModels.COTReport.HistoricalContext(
                similarSetups: [
                    MarketIntelligenceModels.COTReport.HistoricalContext.HistoricalSetup(
                        id: UUID(),
                        date: Date().addingTimeInterval(-86400 * 365), // 1 year ago
                        setup: "Commercial net long >50k, Large spec net short >60k",
                        outcome: "Gold rallied +8.5% over next 6 weeks",
                        moveSize: 8.5,
                        timeToMove: 42
                    ),
                    MarketIntelligenceModels.COTReport.HistoricalContext.HistoricalSetup(
                        id: UUID(),
                        date: Date().addingTimeInterval(-86400 * 730), // 2 years ago
                        setup: "Similar commercial accumulation pattern",
                        outcome: "Gold gained +12.3% in 8 weeks",
                        moveSize: 12.3,
                        timeToMove: 56
                    )
                ],
                successRate: 78.5,
                avgMoveSize: 9.2,
                avgTimeToTarget: 45
            )
        )
    ]
}

extension MarketIntelligenceModels.EnhancedHistoricalData {
    static let sampleData: [MarketIntelligenceModels.EnhancedHistoricalData] = [
        MarketIntelligenceModels.EnhancedHistoricalData(
            id: UUID(),
            symbol: "XAUUSD",
            timeframe: "1H",
            data: [], // Would contain thousands of data points
            patterns: [
                MarketIntelligenceModels.EnhancedHistoricalData.PatternRecognition(
                    id: UUID(),
                    pattern: .headAndShoulders,
                    startDate: Date().addingTimeInterval(-86400 * 14),
                    endDate: Date().addingTimeInterval(-86400 * 7),
                    reliability: 0.85,
                    priceTarget: 2450.0,
                    stopLoss: 2320.0,
                    status: .confirmed
                )
            ],
            statistics: MarketIntelligenceModels.EnhancedHistoricalData.MarketStatistics(
                avgDailyRange: 45.7,
                avgDailyVolume: 125000,
                volatility: 0.287,
                correlation_DXY: -0.73,
                correlation_SPX: 0.45,
                correlation_10Y: -0.52,
                bestTradingHours: [
                    MarketIntelligenceModels.EnhancedHistoricalData.MarketStatistics.TradingHour(
                        hour: 8,
                        avgMove: 12.5,
                        winRate: 68.7,
                        volume: 1.4
                    ),
                    MarketIntelligenceModels.EnhancedHistoricalData.MarketStatistics.TradingHour(
                        hour: 13,
                        avgMove: 18.3,
                        winRate: 71.2,
                        volume: 2.1
                    )
                ],
                worstTradingHours: [
                    MarketIntelligenceModels.EnhancedHistoricalData.MarketStatistics.TradingHour(
                        hour: 22,
                        avgMove: 4.2,
                        winRate: 45.1,
                        volume: 0.3
                    )
                ],
                seasonalBias: [
                    MarketIntelligenceModels.EnhancedHistoricalData.MarketStatistics.MonthlyBias(
                        month: 1,
                        avgReturn: 2.8,
                        winRate: 67.5,
                        volatility: 0.31
                    )
                ]
            ),
            seasonality: MarketIntelligenceModels.EnhancedHistoricalData.SeasonalityAnalysis(
                monthlyPerformance: [
                    MarketIntelligenceModels.EnhancedHistoricalData.SeasonalityAnalysis.MonthlyPerformance(
                        id: UUID(),
                        month: 1,
                        avgReturn: 2.8,
                        winRate: 67.5,
                        bestYears: [2019, 2020, 2023],
                        worstYears: [2015, 2018]
                    )
                ],
                weeklyBias: MarketIntelligenceModels.EnhancedHistoricalData.SeasonalityAnalysis.WeeklyBias(
                    mondayBias: -0.12,
                    tuesdayBias: 0.34,
                    wednesdayBias: 0.18,
                    thursdayBias: 0.45,
                    fridayBias: -0.23
                ),
                intraday: MarketIntelligenceModels.EnhancedHistoricalData.SeasonalityAnalysis.IntradaySeasonality(
                    londonOpen: MarketIntelligenceModels.EnhancedHistoricalData.SeasonalityAnalysis.IntradaySeasonality.SessionStats(
                        avgMove: 15.7,
                        direction: "Bullish",
                        reliability: 0.68,
                        volume: 1.8
                    ),
                    newYorkOpen: MarketIntelligenceModels.EnhancedHistoricalData.SeasonalityAnalysis.IntradaySeasonality.SessionStats(
                        avgMove: 22.1,
                        direction: "Bullish",
                        reliability: 0.72,
                        volume: 2.3
                    ),
                    asianSession: MarketIntelligenceModels.EnhancedHistoricalData.SeasonalityAnalysis.IntradaySeasonality.SessionStats(
                        avgMove: 8.4,
                        direction: "Neutral",
                        reliability: 0.51,
                        volume: 0.6
                    ),
                    overlap_London_NY: MarketIntelligenceModels.EnhancedHistoricalData.SeasonalityAnalysis.IntradaySeasonality.SessionStats(
                        avgMove: 28.9,
                        direction: "Bullish",
                        reliability: 0.78,
                        volume: 3.1
                    )
                )
            ),
            correlations: MarketIntelligenceModels.EnhancedHistoricalData.CorrelationData(
                dollarIndex: MarketIntelligenceModels.EnhancedHistoricalData.CorrelationData.CorrelationStats(
                    correlation: -0.73,
                    strength: .strong,
                    reliability: 0.89,
                    divergences: []
                ),
                sp500: MarketIntelligenceModels.EnhancedHistoricalData.CorrelationData.CorrelationStats(
                    correlation: 0.45,
                    strength: .moderate,
                    reliability: 0.67,
                    divergences: []
                ),
                bitcoin: MarketIntelligenceModels.EnhancedHistoricalData.CorrelationData.CorrelationStats(
                    correlation: 0.62,
                    strength: .strong,
                    reliability: 0.71,
                    divergences: []
                ),
                bonds: MarketIntelligenceModels.EnhancedHistoricalData.CorrelationData.CorrelationStats(
                    correlation: -0.52,
                    strength: .moderate,
                    reliability: 0.78,
                    divergences: []
                ),
                oil: MarketIntelligenceModels.EnhancedHistoricalData.CorrelationData.CorrelationStats(
                    correlation: 0.38,
                    strength: .moderate,
                    reliability: 0.61,
                    divergences: []
                )
            )
        )
    ]
}

// Add MarketSentiment if not defined elsewhere
struct MarketSentiment: Codable {
    let overall: String
    let confidence: Double
    let keyFactors: [String]
}

#Preview("Market Intelligence Models") {
    NavigationView {
        VStack {
            Text("Ultimate Market Edge")
                .font(.title)
                .padding()
            
            Text("COT Reports + Historical Data + FREE APIs! 📊")
                .font(.headline)
                .foregroundColor(.gold)
            
            Spacer()
        }
    }
}