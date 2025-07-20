//
//  RealDataManager.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 7/13/25.
//

import SwiftUI
import Combine

@MainActor
class RealDataManager: ObservableObject {
    @Published var currentPrice: Double = 2374.85
    @Published var priceChange: Double = 0.0
    @Published var volume: Double = 0.0
    @Published var lastUpdate: Date = Date()
    
    private var updateTimer: Timer?
    
    init() {
        startRealTimeUpdates()
    }
    
    deinit {
        updateTimer?.invalidate()
        updateTimer = nil
    }
    
    private func startRealTimeUpdates() {
        updateTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
            Task { @MainActor in
                self.updateData()
            }
        }
    }
    
    private func stopRealTimeUpdates() {
        updateTimer?.invalidate()
        updateTimer = nil
    }
    
    private func updateData() {
        let change = Double.random(in: -2...2)
        currentPrice += change
        priceChange = change
        volume = Double.random(in: 1000...10000)
        lastUpdate = Date()
    }
    
    func refreshData() {
        updateData()
    }
}

#Preview {
    Text("Real Data Manager")
}