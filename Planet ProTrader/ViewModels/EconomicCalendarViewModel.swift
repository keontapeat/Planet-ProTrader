//
//  EconomicCalendarViewModel.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 7/13/25.
//

import Foundation
import SwiftUI

@MainActor
class EconomicCalendarViewModel: ObservableObject {
    @Published var events: [EconomicEventModel] = []
    @Published var filteredEvents: [EconomicEventModel] = []
    @Published var isLoading = false
    @Published var selectedTimeframe: CalendarTimeframe = .today
    
    // Filter settings
    @Published var showHighImpact = true
    @Published var showMediumImpact = true
    @Published var showLowImpact = true
    @Published var selectedCurrencies: Set<String> = ["USD", "EUR", "GBP", "JPY"]
    
    private var updateTimer: Timer?
    
    let availableCurrencies = ["USD", "EUR", "GBP", "JPY", "AUD", "CAD", "CHF", "NZD"]
    
    var highImpactCount: Int {
        events.filter { $0.impact == .high }.count
    }
    
    var mediumImpactCount: Int {
        events.filter { $0.impact == .medium }.count
    }
    
    var lowImpactCount: Int {
        events.filter { $0.impact == .low }.count
    }
    
    var hasHighImpactNews: Bool {
        events.contains { $0.impact == .high && Calendar.current.isDateInToday($0.date) }
    }
    
    func loadEvents() {
        isLoading = true
        
        // Simulate loading events
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.events = self.generateSampleEvents()
            self.applyFilters()
            self.isLoading = false
        }
    }
    
    func startRealTimeUpdates() {
        updateTimer = Timer.scheduledTimer(withTimeInterval: 300.0, repeats: true) { _ in
            Task { @MainActor in
                self.loadEvents()
            }
        }
    }
    
    func stopRealTimeUpdates() {
        updateTimer?.invalidate()
        updateTimer = nil
    }
    
    func toggleCurrency(_ currency: String) {
        if selectedCurrencies.contains(currency) {
            selectedCurrencies.remove(currency)
        } else {
            selectedCurrencies.insert(currency)
        }
        applyFilters()
    }
    
    private func applyFilters() {
        filteredEvents = events.filter { event in
            let impactFilter = (event.impact == .high && showHighImpact) ||
                             (event.impact == .medium && showMediumImpact) ||
                             (event.impact == .low && showLowImpact)
            
            let currencyFilter = selectedCurrencies.contains(event.currency)
            
            return impactFilter && currencyFilter
        }
    }
    
    private func generateSampleEvents() -> [EconomicEventModel] {
        return [
            EconomicEventModel(
                title: "Non-Farm Payrolls",
                country: "US",
                currency: "USD",
                time: "8:30 AM",
                date: Date(),
                impact: .high,
                forecast: 200.0,
                actual: nil,
                previous: 180.0,
                description: "Monthly change in employment excluding farm workers",
                volatilityRange: 15.0
            ),
            EconomicEventModel(
                title: "Federal Reserve Interest Rate Decision",
                country: "US",
                currency: "USD",
                time: "2:00 PM",
                date: Date(),
                impact: .high,
                forecast: 5.25,
                actual: nil,
                previous: 5.00,
                description: "Federal Reserve's decision on interest rates",
                volatilityRange: 25.0
            ),
            EconomicEventModel(
                title: "Consumer Price Index",
                country: "US",
                currency: "USD",
                time: "8:30 AM",
                date: Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date(),
                impact: .high,
                forecast: 3.2,
                actual: nil,
                previous: 3.0,
                description: "Monthly change in consumer prices",
                volatilityRange: 20.0
            ),
            EconomicEventModel(
                title: "Unemployment Rate",
                country: "US",
                currency: "USD",
                time: "8:30 AM",
                date: Date(),
                impact: .medium,
                forecast: 3.8,
                actual: nil,
                previous: 3.9,
                description: "Percentage of unemployed workers",
                volatilityRange: 10.0
            ),
            EconomicEventModel(
                title: "GDP Growth Rate",
                country: "US",
                currency: "USD",
                time: "8:30 AM",
                date: Calendar.current.date(byAdding: .day, value: 2, to: Date()) ?? Date(),
                impact: .high,
                forecast: 2.1,
                actual: nil,
                previous: 2.0,
                description: "Quarterly GDP growth rate",
                volatilityRange: 18.0
            )
        ]
    }
}

// MARK: - Data Models

struct EconomicEventModel: Identifiable, Codable {
    let id = UUID()
    let title: String
    let country: String
    let currency: String
    let time: String
    let date: Date
    let impact: EconomicImpact
    let forecast: Double?
    let actual: Double?
    let previous: Double?
    let description: String
    let volatilityRange: Double
    
    var hasForecast: Bool {
        forecast != nil
    }
    
    var hasActual: Bool {
        actual != nil
    }
}

enum EconomicImpact: String, CaseIterable, Codable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    
    var color: Color {
        switch self {
        case .low: return .green
        case .medium: return .orange
        case .high: return .red
        }
    }
    
    var level: Int {
        switch self {
        case .low: return 1
        case .medium: return 2
        case .high: return 3
        }
    }
}

enum CalendarTimeframe: String, CaseIterable, Codable {
    case today = "Today"
    case tomorrow = "Tomorrow"
    case week = "This Week"
    case month = "This Month"
}