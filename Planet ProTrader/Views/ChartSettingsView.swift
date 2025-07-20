//
//  ChartSettingsView.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 7/18/25.
//

import SwiftUI

struct ChartSettingsView: View {
    @Binding var settings: ChartSettings
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTimezone = TimeZone.current
    @State private var showingTimezoneSelector = false
    
    var body: some View {
        NavigationStack {
            List {
                // Chart Appearance Section
                Section("🎨 CHART APPEARANCE") {
                    chartAppearanceSettings
                }
                
                // Trading Display Section
                Section("📈 TRADING DISPLAY") {
                    tradingDisplaySettings
                }
                
                // Timezone & Time Settings
                Section("🌍 TIME & TIMEZONE") {
                    timezoneSettings
                }
                
                // Auto-Trading Settings
                Section("🤖 AUTO-TRADING") {
                    autoTradingSettings
                }
                
                // Performance Settings
                Section("⚡ PERFORMANCE") {
                    performanceSettings
                }
                
                // Alert Settings
                Section("🔔 ALERTS & NOTIFICATIONS") {
                    alertSettings
                }
            }
            .navigationTitle("⚙️ Chart Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Reset") {
                        resetToDefaults()
                    }
                    .foregroundColor(.secondary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(DesignSystem.primaryGold)
                }
            }
        }
        .sheet(isPresented: $showingTimezoneSelector) {
            TimezoneSelectionView(selectedTimezone: $selectedTimezone)
        }
    }
    
    // MARK: - Chart Appearance Settings
    
    private var chartAppearanceSettings: some View {
        Group {
            // Candle Style
            HStack {
                Label("Candle Style", systemImage: "chart.bar")
                    .foregroundColor(.primary)
                
                Spacer()
                
                Picker("", selection: $settings.candleStyle) {
                    ForEach(ChartSettings.CandleStyle.allCases, id: \.self) { style in
                        Text(style.displayName).tag(style)
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }
            
            // Color Scheme
            HStack {
                Label("Color Scheme", systemImage: "paintbrush")
                    .foregroundColor(.primary)
                
                Spacer()
                
                Picker("", selection: $settings.colorScheme) {
                    ForEach(ChartSettings.ChartColorScheme.allCases, id: \.self) { scheme in
                        Text(scheme.rawValue).tag(scheme)
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }
            
            // Visual Elements Toggles
            Toggle(isOn: $settings.showGrid) {
                Label("Show Grid", systemImage: "grid")
                    .foregroundColor(.primary)
            }
            .tint(DesignSystem.primaryGold)
            
            Toggle(isOn: $settings.showVolume) {
                Label("Show Volume", systemImage: "chart.bar.fill")
                    .foregroundColor(.primary)
            }
            .tint(DesignSystem.primaryGold)
            
            Toggle(isOn: $settings.showCrosshair) {
                Label("Show Crosshair", systemImage: "plus")
                    .foregroundColor(.primary)
            }
            .tint(DesignSystem.primaryGold)
        }
    }
    
    // MARK: - Trading Display Settings
    
    private var tradingDisplaySettings: some View {
        Group {
            Toggle(isOn: $settings.showOrderLines) {
                Label("Show Order Lines", systemImage: "minus")
                    .foregroundColor(.primary)
            }
            .tint(DesignSystem.primaryGold)
            
            Toggle(isOn: $settings.showBotSignals) {
                Label("Show Bot Signals", systemImage: "robot")
                    .foregroundColor(.primary)
            }
            .tint(DesignSystem.primaryGold)
            
            Toggle(isOn: $settings.showLastPrice) {
                Label("Show Last Price Line", systemImage: "arrow.right")
                    .foregroundColor(.primary)
            }
            .tint(DesignSystem.primaryGold)
            
            Toggle(isOn: $settings.showBidAsk) {
                Label("Show Bid/Ask Prices", systemImage: "dollarsign.circle")
                    .foregroundColor(.primary)
            }
            .tint(DesignSystem.primaryGold)
            
            Toggle(isOn: $settings.showSpread) {
                Label("Show Spread Info", systemImage: "arrow.left.and.right")
                    .foregroundColor(.primary)
            }
            .tint(DesignSystem.primaryGold)
        }
    }
    
    // MARK: - Timezone Settings
    
    private var timezoneSettings: some View {
        Group {
            Button(action: {
                showingTimezoneSelector = true
            }) {
                HStack {
                    Label("Timezone", systemImage: "clock.badge.exclamationmark")
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 2) {
                        Text(selectedTimezone.identifier)
                            .foregroundColor(.secondary)
                            .font(.caption)
                        
                        Text("UTC\(timezoneOffset)")
                            .foregroundColor(DesignSystem.primaryGold)
                            .font(.caption2)
                    }
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
            }
            .buttonStyle(PlainButtonStyle())
            
            // Quick timezone buttons
            VStack(alignment: .leading, spacing: 8) {
                Text("Quick Select:")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 8) {
                    quickTimezoneButton(name: "NY", timezone: TimeZone(identifier: "America/New_York")!)
                    quickTimezoneButton(name: "LONDON", timezone: TimeZone(identifier: "Europe/London")!)
                    quickTimezoneButton(name: "TOKYO", timezone: TimeZone(identifier: "Asia/Tokyo")!)
                }
            }
        }
    }
    
    private func quickTimezoneButton(name: String, timezone: TimeZone) -> some View {
        Button(action: {
            selectedTimezone = timezone
        }) {
            VStack(spacing: 4) {
                Text(name)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(selectedTimezone == timezone ? .white : .primary)
                
                Text(currentTime(for: timezone))
                    .font(.caption2)
                    .foregroundColor(selectedTimezone == timezone ? .white.opacity(0.8) : .secondary)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .background(
                selectedTimezone == timezone 
                ? DesignSystem.primaryGold 
                : Color(.systemGray5)
            )
            .cornerRadius(8)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // MARK: - Auto-Trading Settings
    
    private var autoTradingSettings: some View {
        Group {
            // Auto-trading mode indicator style
            VStack(alignment: .leading, spacing: 12) {
                Text("Auto-Trading Indicator Style")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                    autoModeStyleButton(
                        title: "Minimal Dot",
                        description: "Small indicator dot",
                        icon: "circle.fill",
                        style: .minimal
                    )
                    
                    autoModeStyleButton(
                        title: "Status Bar",
                        description: "Full status bar",
                        icon: "rectangle.fill",
                        style: .statusBar
                    )
                    
                    autoModeStyleButton(
                        title: "Floating Badge",
                        description: "Floating robot badge",
                        icon: "robot.fill",
                        style: .floating
                    )
                    
                    autoModeStyleButton(
                        title: "Corner Banner",
                        description: "Corner banner",
                        icon: "flag.fill",
                        style: .banner
                    )
                }
            }
            
            // Bot activity display
            Toggle(isOn: $settings.showBotSignals) {
                Label("Show Live Bot Activity", systemImage: "antenna.radiowaves.left.and.right")
                    .foregroundColor(.primary)
            }
            .tint(DesignSystem.primaryGold)
            
            // Trade execution visualization
            VStack(alignment: .leading, spacing: 8) {
                Text("Trade Execution Animation")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                HStack {
                    Toggle("", isOn: .constant(true))
                        .tint(DesignSystem.primaryGold)
                    
                    Text("Animate trade placement and fills")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
    
    private func autoModeStyleButton(title: String, description: String, icon: String, style: AutoModeStyle) -> some View {
        Button(action: {
            // Update auto mode style
        }) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(DesignSystem.primaryGold)
                
                VStack(spacing: 4) {
                    Text(title)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    Text(description)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(DesignSystem.primaryGold.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    enum AutoModeStyle {
        case minimal, statusBar, floating, banner
    }
    
    // MARK: - Performance Settings
    
    private var performanceSettings: some View {
        Group {
            Toggle(isOn: $settings.autoScalePrice) {
                Label("Auto-Scale Price Axis", systemImage: "arrow.up.and.down")
                    .foregroundColor(.primary)
            }
            .tint(DesignSystem.primaryGold)
            
            // Chart update frequency
            VStack(alignment: .leading, spacing: 8) {
                Text("Chart Update Frequency")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                Picker("Update Frequency", selection: .constant(1)) {
                    Text("Real-time (1s)").tag(1)
                    Text("Fast (5s)").tag(5)
                    Text("Normal (15s)").tag(15)
                    Text("Slow (30s)").tag(30)
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            
            // Memory optimization
            Toggle(isOn: .constant(true)) {
                Label("Optimize for Performance", systemImage: "speedometer")
                    .foregroundColor(.primary)
            }
            .tint(DesignSystem.primaryGold)
        }
    }
    
    // MARK: - Alert Settings
    
    private var alertSettings: some View {
        Group {
            Toggle(isOn: $settings.enableAlerts) {
                Label("Enable Price Alerts", systemImage: "bell")
                    .foregroundColor(.primary)
            }
            .tint(DesignSystem.primaryGold)
            
            Toggle(isOn: $settings.soundAlerts) {
                Label("Sound Alerts", systemImage: "speaker.wave.2")
                    .foregroundColor(.primary)
            }
            .tint(DesignSystem.primaryGold)
            .disabled(!settings.enableAlerts)
            
            Toggle(isOn: $settings.enableNews) {
                Label("News Notifications", systemImage: "newspaper")
                    .foregroundColor(.primary)
            }
            .tint(DesignSystem.primaryGold)
            
            Toggle(isOn: $settings.showEconomicCalendar) {
                Label("Economic Calendar", systemImage: "calendar")
                    .foregroundColor(.primary)
            }
            .tint(DesignSystem.primaryGold)
        }
    }
    
    // MARK: - Helper Methods
    
    private var timezoneOffset: String {
        let offset = selectedTimezone.secondsFromGMT() / 3600
        let sign = offset >= 0 ? "+" : ""
        return "\(sign)\(offset)"
    }
    
    private func currentTime(for timezone: TimeZone) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = timezone
        formatter.timeStyle = .short
        return formatter.string(from: Date())
    }
    
    private func resetToDefaults() {
        settings = ChartSettings()
        selectedTimezone = TimeZone.current
    }
}

// MARK: - Timezone Selection View

struct TimezoneSelectionView: View {
    @Binding var selectedTimezone: TimeZone
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    
    private let majorTimezones: [(String, TimeZone)] = [
        ("New York (EST)", TimeZone(identifier: "America/New_York")!),
        ("London (GMT)", TimeZone(identifier: "Europe/London")!),
        ("Tokyo (JST)", TimeZone(identifier: "Asia/Tokyo")!),
        ("Sydney (AEST)", TimeZone(identifier: "Australia/Sydney")!),
        ("Frankfurt (CET)", TimeZone(identifier: "Europe/Berlin")!),
        ("Singapore (SGT)", TimeZone(identifier: "Asia/Singapore")!),
        ("Dubai (GST)", TimeZone(identifier: "Asia/Dubai")!),
        ("Hong Kong (HKT)", TimeZone(identifier: "Asia/Hong_Kong")!),
        ("Los Angeles (PST)", TimeZone(identifier: "America/Los_Angeles")!),
        ("Chicago (CST)", TimeZone(identifier: "America/Chicago")!),
        ("Toronto (EST)", TimeZone(identifier: "America/Toronto")!),
        ("Mumbai (IST)", TimeZone(identifier: "Asia/Kolkata")!),
        ("Moscow (MSK)", TimeZone(identifier: "Europe/Moscow")!),
        ("Zurich (CET)", TimeZone(identifier: "Europe/Zurich")!),
        ("Seoul (KST)", TimeZone(identifier: "Asia/Seoul")!)
    ]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Search bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                    
                    TextField("Search timezone...", text: $searchText)
                        .textFieldStyle(PlainTextFieldStyle())
                }
                .padding()
                .background(Color(.systemGray6))
                
                // Timezone list
                List {
                    Section("🌍 MAJOR TRADING CENTERS") {
                        ForEach(filteredTimezones, id: \.1.identifier) { name, timezone in
                            timezoneRow(name: name, timezone: timezone)
                        }
                    }
                }
            }
            .navigationTitle("🕐 Select Timezone")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(DesignSystem.primaryGold)
                }
            }
        }
    }
    
    private var filteredTimezones: [(String, TimeZone)] {
        if searchText.isEmpty {
            return majorTimezones
        } else {
            return majorTimezones.filter { name, _ in
                name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    private func timezoneRow(name: String, timezone: TimeZone) -> some View {
        Button(action: {
            selectedTimezone = timezone
            dismiss()
        }) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(name)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                    
                    Text(timezone.identifier)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(currentTime(for: timezone))
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(DesignSystem.primaryGold)
                    
                    Text("UTC\(timezoneOffset(for: timezone))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                if selectedTimezone == timezone {
                    Image(systemName: "checkmark")
                        .foregroundColor(DesignSystem.primaryGold)
                        .font(.caption)
                }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func currentTime(for timezone: TimeZone) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = timezone
        formatter.timeStyle = .short
        return formatter.string(from: Date())
    }
    
    private func timezoneOffset(for timezone: TimeZone) -> String {
        let offset = timezone.secondsFromGMT() / 3600
        let sign = offset >= 0 ? "+" : ""
        return "\(sign)\(offset)"
    }
}

#Preview {
    ChartSettingsView(settings: .constant(ChartSettings()))
}