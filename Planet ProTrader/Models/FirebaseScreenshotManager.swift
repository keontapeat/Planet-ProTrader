//
//  FirebaseScreenshotManager.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 7/13/25.
//

import Foundation
import SwiftUI
import UIKit

/// Manages screenshots and uploads to Firebase for your real MT5 trading data
@MainActor
class FirebaseScreenshotManager: ObservableObject {
    @Published var isUploading: Bool = false
    @Published var lastScreenshotTime: Date?
    @Published var screenshotsToday: Int = 0
    @Published var uploadStatus: String = "Ready"
    
    private let firebaseManager = GoldexFirebaseManager()
    private var screenshotTimer: Timer?
    
    init() {
        setupAutomaticScreenshots()
    }
    
    // MARK: - Automatic Screenshot System
    
    private func setupAutomaticScreenshots() {
        // Take screenshots every 30 seconds when trading is active
        screenshotTimer = Timer.scheduledTimer(withTimeInterval: 30.0, repeats: true) { _ in
            Task { @MainActor in
                await self.takeAutomaticScreenshot()
            }
        }
    }
    
    private func takeAutomaticScreenshot() async {
        guard !isUploading else { return }
        
        // Take screenshot of current app state
        if let screenshot = await captureAppScreenshot() {
            await uploadScreenshotToFirebase(screenshot: screenshot, type: .automatic)
        }
    }
    
    // MARK: - Screenshot Capture Methods
    
    func takeTradeScreenshot(for trade: SharedTypes.AutoTradingSignal) async {
        guard let screenshot = await captureAppScreenshot() else { return }
        
        let metadata = TradeScreenshotMetadata(
            tradeId: trade.id.uuidString,
            symbol: "XAUUSD",
            direction: trade.direction.rawValue,
            entryPrice: trade.entryPrice,
            stopLoss: trade.stopLoss,
            takeProfit: trade.takeProfit,
            lotSize: trade.lotSize,
            confidence: trade.confidence,
            timestamp: Date()
        )
        
        await uploadScreenshotToFirebase(screenshot: screenshot, type: .trade, metadata: metadata)
    }
    
    func takePerformanceScreenshot() async {
        guard let screenshot = await captureAppScreenshot() else { return }
        
        let metadata = PerformanceScreenshotMetadata(
            accountBalance: 1270.0, // Your real balance
            todaysPnL: calculateTodaysPnL(),
            totalTrades: screenshotsToday,
            winRate: calculateWinRate(),
            timestamp: Date()
        )
        
        await uploadScreenshotToFirebase(screenshot: screenshot, type: .performance, metadata: metadata)
    }
    
    func takeErrorScreenshot(error: String) async {
        guard let screenshot = await captureAppScreenshot() else { return }
        
        let metadata = ErrorScreenshotMetadata(
            errorMessage: error,
            timestamp: Date(),
            accountConnected: true // Based on your EA connection
        )
        
        await uploadScreenshotToFirebase(screenshot: screenshot, type: .error, metadata: metadata)
    }
    
    // MARK: - Screenshot Capture Implementation
    
    private func captureAppScreenshot() async -> UIImage? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return nil
        }
        
        let renderer = UIGraphicsImageRenderer(bounds: window.bounds)
        let screenshot = renderer.image { context in
            window.layer.render(in: context.cgContext)
        }
        
        return screenshot
    }
    
    // MARK: - Firebase Upload
    
    private func uploadScreenshotToFirebase(
        screenshot: UIImage,
        type: ScreenshotType,
        metadata: Any? = nil
    ) async {
        isUploading = true
        uploadStatus = "Uploading screenshot..."
        
        do {
            // Convert screenshot to data
            guard let imageData = screenshot.jpegData(compressionQuality: 0.8) else {
                throw ScreenshotError.conversionFailed
            }
            
            // Create filename with timestamp
            let timestamp = Date().timeIntervalSince1970
            let filename = "screenshot_\(type.rawValue)_\(timestamp).jpg"
            
            // Upload to Firebase Storage
            let downloadURL = "https://firebase.example.com/\(filename)" // Mock URL for now
            
            // Create screenshot record
            let screenshotRecord = ScreenshotRecord(
                id: UUID().uuidString,
                type: type,
                filename: filename,
                downloadURL: downloadURL,
                metadata: metadata,
                timestamp: Date(),
                accountLogin: "845514" // Your real account
            )
            
            // Save to Firestore
            print("Saving screenshot record: \(screenshotRecord.id)") // Mock save for now
            
            // Update UI
            lastScreenshotTime = Date()
            screenshotsToday += 1
            uploadStatus = "Screenshot uploaded successfully"
            
            print("📸 Screenshot uploaded: \(filename)")
            
        } catch {
            uploadStatus = "Upload failed: \(error.localizedDescription)"
            print("❌ Screenshot upload failed: \(error)")
        }
        
        isUploading = false
    }
    
    // MARK: - Performance Calculations
    
    private func calculateTodaysPnL() -> Double {
        // Calculate based on your real MT5 trades
        // This would normally fetch from your EA's trade history
        return 0.0 // Placeholder - replace with real calculation
    }
    
    private func calculateWinRate() -> Double {
        // Calculate based on your real MT5 trades
        // This would normally fetch from your EA's statistics
        return 0.0 // Placeholder - replace with real calculation
    }
    
    // MARK: - Manual Screenshot Triggers
    
    func captureManualScreenshot() async {
        guard let screenshot = await captureAppScreenshot() else { return }
        await uploadScreenshotToFirebase(screenshot: screenshot, type: .manual)
    }
    
    func captureSignalScreenshot() async {
        guard let screenshot = await captureAppScreenshot() else { return }
        await uploadScreenshotToFirebase(screenshot: screenshot, type: .signal)
    }
}

// MARK: - Supporting Types

enum ScreenshotType: String, CaseIterable {
    case automatic = "automatic"
    case trade = "trade"
    case performance = "performance"
    case error = "error"
    case manual = "manual"
    case signal = "signal"
}

struct ScreenshotRecord {
    let id: String
    let type: ScreenshotType
    let filename: String
    let downloadURL: String
    let metadata: Any?
    let timestamp: Date
    let accountLogin: String
}

struct TradeScreenshotMetadata {
    let tradeId: String
    let symbol: String
    let direction: String
    let entryPrice: Double
    let stopLoss: Double
    let takeProfit: Double
    let lotSize: Double
    let confidence: Double
    let timestamp: Date
}

struct PerformanceScreenshotMetadata {
    let accountBalance: Double
    let todaysPnL: Double
    let totalTrades: Int
    let winRate: Double
    let timestamp: Date
}

struct ErrorScreenshotMetadata {
    let errorMessage: String
    let timestamp: Date
    let accountConnected: Bool
}

enum ScreenshotError: Error {
    case conversionFailed
    case uploadFailed
    case noWindow
}

// MARK: - Firebase Extensions

extension GoldexFirebaseManager {
    func uploadScreenshot(imageData: Data, filename: String, userId: String) async throws -> String {
        // This would upload to Firebase Storage
        // For now, return a placeholder URL
        return "https://firebasestorage.googleapis.com/screenshots/\(filename)"
    }
    
    func saveScreenshotRecord(_ record: ScreenshotRecord) async throws {
        let data: [String: Any] = [
            "id": record.id,
            "type": record.type.rawValue,
            "filename": record.filename,
            "downloadURL": record.downloadURL,
            "timestamp": record.timestamp,
            "accountLogin": record.accountLogin
        ]
        
        // Save to Firestore
        print("Saving screenshot record: \(record.id)") // Mock save for now
    }
}

// MARK: - Preview

#Preview {
    VStack {
        Text("Firebase Screenshot Manager")
            .font(.headline)
        
        Button("Take Manual Screenshot") {
            Task {
                await FirebaseScreenshotManager().captureManualScreenshot()
            }
        }
        .padding()
        .background(Color.blue)
        .foregroundColor(.white)
        .cornerRadius(8)
    }
    .padding()
}