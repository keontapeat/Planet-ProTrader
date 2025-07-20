//
//  CSVImporter.swift
//  GOLDEX AI
//
//  Created by Goldex AI on 7/19/25.
//

import Foundation
import Combine
import SwiftUI

@MainActor
class CSVImporter: ObservableObject {
    @Published var isProcessing = false
    @Published var progress: Double = 0.0
    @Published var errorMessage: String?
    @Published var lastImportedData: [EnhancedGoldDataPoint] = []
    @Published var processingStage = "Ready to Import"
    @Published var dataQualityScore: Double = 0.0
    @Published var totalDataPoints = 0
    @Published var validDataPoints = 0
    @Published var processingSpeed = 0.0 // Records per second
    
    private var processingStartTime: Date?
    private let supabaseService = SupabaseService.shared
    
    func importCSV(from content: String) async -> [EnhancedGoldDataPoint] {
        isProcessing = true
        progress = 0.0
        errorMessage = nil
        processingStartTime = Date()
        
        defer {
            isProcessing = false
        }
        
        do {
            let dataPoints = try await processCSVContent(content)
            lastImportedData = dataPoints
            progress = 1.0
            processingStage = "Import Complete"
            
            // Calculate data quality score
            dataQualityScore = calculateDataQuality(dataPoints)
            
            // Save to Supabase for backup
            await saveToSupabase(dataPoints)
            
            return dataPoints
        } catch {
            errorMessage = error.localizedDescription
            processingStage = "Error: \(error.localizedDescription)"
            return []
        }
    }
    
    private func processCSVContent(_ content: String) async throws -> [EnhancedGoldDataPoint] {
        processingStage = "Parsing CSV Data..."
        
        let lines = content.components(separatedBy: .newlines)
        var dataPoints: [EnhancedGoldDataPoint] = []
        totalDataPoints = lines.count
        validDataPoints = 0
        
        let dateFormatter = createDateFormatter()
        var processedCount = 0
        
        for (index, line) in lines.enumerated() {
            // Skip header and empty lines
            guard index > 0, !line.trimmingCharacters(in: .whitespaces).isEmpty else { 
                continue 
            }
            
            // Update progress every 100 lines
            if processedCount % 100 == 0 {
                progress = Double(processedCount) / Double(lines.count)
                processingSpeed = Double(processedCount) / (Date().timeIntervalSince(processingStartTime ?? Date()))
                processingStage = "Processing line \(processedCount) of \(lines.count)"
                
                // Add small delay for smooth animation
                try await Task.sleep(for: .milliseconds(1))
            }
            
            if let dataPoint = try? parseCSVLine(line, dateFormatter: dateFormatter) {
                dataPoints.append(dataPoint)
                validDataPoints += 1
            }
            
            processedCount += 1
        }
        
        processingStage = "Enhancing Data with Technical Indicators..."
        progress = 0.8
        
        // Enhance data with technical indicators
        let enhancedData = await enhanceWithTechnicalIndicators(dataPoints)
        
        processingStage = "Validating Data Quality..."
        progress = 0.9
        
        // Validate and clean data
        let cleanedData = validateAndCleanData(enhancedData)
        
        processingStage = "Finalizing Import..."
        progress = 0.95
        
        return cleanedData.sorted { $0.timestamp < $1.timestamp }
    }
    
    private func createDateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd HH:mm:ss"
        return formatter
    }
    
    private func parseCSVLine(_ line: String, dateFormatter: DateFormatter) throws -> EnhancedGoldDataPoint {
        let components = line.components(separatedBy: ",")
        guard components.count >= 5 else {
            throw CSVError.invalidFormat("Insufficient columns in line: \(line)")
        }
        
        // Handle different CSV formats
        let dateString: String
        let openIndex: Int
        let highIndex: Int
        let lowIndex: Int
        let closeIndex: Int
        let volumeIndex: Int?
        
        if components.count >= 7 && components[1].contains(":") {
            // Format: Date, Time, Open, High, Low, Close, Volume
            dateString = "\(components[0]) \(components[1])"
            openIndex = 2
            highIndex = 3
            lowIndex = 4
            closeIndex = 5
            volumeIndex = 6
        } else if components.count >= 6 {
            // Format: DateTime, Open, High, Low, Close, Volume
            dateString = components[0]
            openIndex = 1
            highIndex = 2
            lowIndex = 3
            closeIndex = 4
            volumeIndex = 5
        } else {
            // Format: DateTime, Open, High, Low, Close
            dateString = components[0]
            openIndex = 1
            highIndex = 2
            lowIndex = 3
            closeIndex = 4
            volumeIndex = nil
        }
        
        guard let date = dateFormatter.date(from: dateString),
              let open = Double(components[openIndex]),
              let high = Double(components[highIndex]),
              let low = Double(components[lowIndex]),
              let close = Double(components[closeIndex]) else {
            throw CSVError.invalidData("Could not parse data from line: \(line)")
        }
        
        let volume = volumeIndex != nil ? Double(components[volumeIndex!]) : nil
        
        // Validate OHLC data
        guard high >= low, high >= max(open, close), low <= min(open, close) else {
            throw CSVError.invalidData("Invalid OHLC data: H:\(high) L:\(low) O:\(open) C:\(close)")
        }
        
        return EnhancedGoldDataPoint(
            timestamp: date,
            open: open,
            high: high,
            low: low,
            close: close,
            volume: volume
        )
    }
    
    private func enhanceWithTechnicalIndicators(_ dataPoints: [EnhancedGoldDataPoint]) async -> [EnhancedGoldDataPoint] {
        var enhancedPoints = dataPoints
        let prices = dataPoints.map { $0.close }
        
        // Calculate RSI
        let rsiValues = calculateRSI(prices: prices, period: 14)
        
        // Calculate MACD
        let macdValues = calculateMACD(prices: prices)
        
        // Calculate Bollinger Bands
        let bollingerBands = calculateBollingerBands(prices: prices, period: 20)
        
        // Apply indicators to data points
        for i in 0..<enhancedPoints.count {
            let point = enhancedPoints[i]
            
            // Safely extract values with proper unwrapping
            let rsiValue = i < rsiValues.count ? rsiValues[i] : nil
            let macdValue = i < macdValues.count ? macdValues[i] : nil
            let bollingerValue = i < bollingerBands.count ? bollingerBands[i] : nil
            
            enhancedPoints[i] = EnhancedGoldDataPoint(
                timestamp: point.timestamp,
                open: point.open,
                high: point.high,
                low: point.low,
                close: point.close,
                volume: point.volume,
                volatility: point.volatility,
                rsi: rsiValue,
                macd: macdValue,
                bollinger: bollingerValue,
                news: [],
                economicEvents: []
            )
        }
        
        return enhancedPoints
    }
    
    // MARK: - Technical Indicators
    
    private func calculateRSI(prices: [Double], period: Int = 14) -> [Double?] {
        guard prices.count > period else { return Array(repeating: nil, count: prices.count) }
        
        var rsiValues: [Double?] = Array(repeating: nil, count: period)
        var gains: [Double] = []
        var losses: [Double] = []
        
        // Calculate price changes
        for i in 1..<prices.count {
            let change = prices[i] - prices[i-1]
            gains.append(change > 0 ? change : 0)
            losses.append(change < 0 ? abs(change) : 0)
        }
        
        // Calculate RSI for each point
        for i in period..<gains.count {
            let recentGains = Array(gains[(i-period+1)...i])
            let recentLosses = Array(losses[(i-period+1)...i])
            
            let avgGain = recentGains.reduce(0, +) / Double(period)
            let avgLoss = recentLosses.reduce(0, +) / Double(period)
            
            if avgLoss == 0 {
                rsiValues.append(100)
            } else {
                let rs = avgGain / avgLoss
                let rsi = 100 - (100 / (1 + rs))
                rsiValues.append(rsi)
            }
        }
        
        return rsiValues
    }
    
    private func calculateMACD(prices: [Double]) -> [Double?] {
        let ema12 = calculateEMA(prices: prices, period: 12)
        let ema26 = calculateEMA(prices: prices, period: 26)
        
        var macdValues: [Double?] = []
        
        for i in 0..<prices.count {
            if i < ema12.count && i < ema26.count,
               let ema12Val = ema12[i], 
               let ema26Val = ema26[i] {
                macdValues.append(ema12Val - ema26Val)
            } else {
                macdValues.append(nil)
            }
        }
        
        return macdValues
    }
    
    private func calculateEMA(prices: [Double], period: Int) -> [Double?] {
        guard prices.count >= period else { return Array(repeating: nil, count: prices.count) }
        
        var emaValues: [Double?] = Array(repeating: nil, count: period - 1)
        let multiplier = 2.0 / Double(period + 1)
        
        // First EMA value is SMA
        let firstSMA = Array(prices[0..<period]).reduce(0, +) / Double(period)
        emaValues.append(firstSMA)
        
        // Calculate subsequent EMA values
        for i in period..<prices.count {
            if let previousEMA = emaValues.last as? Double {
                let ema = (prices[i] - previousEMA) * multiplier + previousEMA
                emaValues.append(ema)
            }
        }
        
        return emaValues
    }
    
    private func calculateBollingerBands(prices: [Double], period: Int = 20) -> [EnhancedBollingerBands?] {
        guard prices.count >= period else { return Array(repeating: nil, count: prices.count) }
        
        var bands: [EnhancedBollingerBands?] = Array(repeating: nil, count: period - 1)
        
        for i in (period-1)..<prices.count {
            let subset = Array(prices[(i-period+1)...i])
            let sma = subset.reduce(0, +) / Double(period)
            
            let variance = subset.map { pow($0 - sma, 2) }.reduce(0, +) / Double(period)
            let standardDeviation = sqrt(variance)
            
            bands.append(EnhancedBollingerBands(
                upper: sma + (2 * standardDeviation),
                middle: sma,
                lower: sma - (2 * standardDeviation)
            ))
        }
        
        return bands
    }
    
    // MARK: - Data Validation
    
    private func validateAndCleanData(_ dataPoints: [EnhancedGoldDataPoint]) -> [EnhancedGoldDataPoint] {
        var cleanedData: [EnhancedGoldDataPoint] = []
        
        for point in dataPoints {
            // Remove outliers and invalid data
            if isValidDataPoint(point) {
                cleanedData.append(point)
            }
        }
        
        // Remove duplicates based on timestamp
        cleanedData = removeDuplicates(cleanedData)
        
        return cleanedData
    }
    
    private func isValidDataPoint(_ point: EnhancedGoldDataPoint) -> Bool {
        // Basic validation
        guard point.high >= point.low,
              point.high >= max(point.open, point.close),
              point.low <= min(point.open, point.close) else {
            return false
        }
        
        // Check for reasonable price ranges (gold typically 1000-3000)
        guard point.low > 500 && point.high < 5000 else {
            return false
        }
        
        // Check for reasonable volatility
        guard point.volatility < 100 else {
            return false
        }
        
        return true
    }
    
    private func removeDuplicates(_ dataPoints: [EnhancedGoldDataPoint]) -> [EnhancedGoldDataPoint] {
        var uniquePoints: [EnhancedGoldDataPoint] = []
        var seenTimestamps: Set<Date> = []
        
        for point in dataPoints {
            if !seenTimestamps.contains(point.timestamp) {
                uniquePoints.append(point)
                seenTimestamps.insert(point.timestamp)
            }
        }
        
        return uniquePoints
    }
    
    // MARK: - Data Quality Assessment
    
    private func calculateDataQuality(_ dataPoints: [EnhancedGoldDataPoint]) -> Double {
        guard !dataPoints.isEmpty else { return 0.0 }
        
        var qualityScore = 100.0
        
        // Deduct for missing data
        let completenessRatio = Double(validDataPoints) / Double(totalDataPoints)
        qualityScore *= completenessRatio
        
        // Check for data consistency
        let consistencyScore = calculateConsistencyScore(dataPoints)
        qualityScore *= consistencyScore
        
        // Check for temporal continuity
        let continuityScore = calculateContinuityScore(dataPoints)
        qualityScore *= continuityScore
        
        return min(100.0, max(0.0, qualityScore))
    }
    
    private func calculateConsistencyScore(_ dataPoints: [EnhancedGoldDataPoint]) -> Double {
        guard dataPoints.count > 10 else { return 1.0 }
        
        var inconsistencies = 0
        let totalChecks = dataPoints.count - 1
        
        for i in 1..<dataPoints.count {
            let prev = dataPoints[i-1]
            let curr = dataPoints[i]
            
            // Check for unrealistic price jumps
            let priceChange = abs(curr.close - prev.close) / prev.close
            if priceChange > 0.1 { // 10% jump
                inconsistencies += 1
            }
        }
        
        return Double(totalChecks - inconsistencies) / Double(totalChecks)
    }
    
    private func calculateContinuityScore(_ dataPoints: [EnhancedGoldDataPoint]) -> Double {
        guard dataPoints.count > 2 else { return 1.0 }
        
        let sortedPoints = dataPoints.sorted { $0.timestamp < $1.timestamp }
        var gaps = 0
        let expectedInterval: TimeInterval = 3600 // 1 hour
        
        for i in 1..<sortedPoints.count {
            let timeDiff = sortedPoints[i].timestamp.timeIntervalSince(sortedPoints[i-1].timestamp)
            if timeDiff > expectedInterval * 2 { // Allow some flexibility
                gaps += 1
            }
        }
        
        return Double(sortedPoints.count - gaps) / Double(sortedPoints.count)
    }
    
    // MARK: - Supabase Integration
    
    private func saveToSupabase(_ dataPoints: [EnhancedGoldDataPoint]) async {
        do {
            // Create a dummy bot ID for historical data storage
            let dummyBotId = UUID()
            try await supabaseService.saveHistoricalDataBatch(data: dataPoints, botId: dummyBotId)
            
            // Save import statistics
            await saveImportStatistics(dataPoints: dataPoints)
        } catch {
            print("Failed to save to Supabase: \(error)")
        }
    }
    
    private func saveImportStatistics(dataPoints: [EnhancedGoldDataPoint]) async {
        let stats = ImportStatistics(
            totalRecords: totalDataPoints,
            validRecords: validDataPoints,
            dataQualityScore: dataQualityScore,
            processingSpeed: processingSpeed,
            dateRange: getDateRange(dataPoints),
            importDate: Date()
        )
        
        // This would be saved to a statistics table in Supabase
        print("Import Statistics: \(stats)")
    }
    
    private func getDateRange(_ dataPoints: [EnhancedGoldDataPoint]) -> String {
        guard let earliest = dataPoints.min(by: { $0.timestamp < $1.timestamp }),
              let latest = dataPoints.max(by: { $0.timestamp < $1.timestamp }) else {
            return "Unknown"
        }
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        
        return "\(formatter.string(from: earliest.timestamp)) to \(formatter.string(from: latest.timestamp))"
    }
}

// MARK: - Supporting Types

enum CSVError: Error, LocalizedError {
    case invalidFormat(String)
    case invalidData(String)
    case processingFailed(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidFormat(let message):
            return "Invalid CSV format: \(message)"
        case .invalidData(let message):
            return "Invalid data: \(message)"
        case .processingFailed(let message):
            return "Processing failed: \(message)"
        }
    }
}

struct ImportStatistics {
    let totalRecords: Int
    let validRecords: Int
    let dataQualityScore: Double
    let processingSpeed: Double
    let dateRange: String
    let importDate: Date
}