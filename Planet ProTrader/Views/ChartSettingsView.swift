import SwiftUI

// ---- SINGLE source of truth ----
struct AChartSettings: Equatable {
    var showGrid = true
    var showVolume = true
    var showOrderLines = true
    var showBotSignals = true
    var showCrosshair = true
    var showLastPrice = true
    var showBidAsk = true
    var showSpread = true
    var autoScalePrice = true
    var enableAlerts = true
    var soundAlerts = true
    var enableNews = true
    var showEconomicCalendar = true
    var colorScheme = ChartColorScheme.dark
    var candleStyle = CandleStyle.candlestick
    var selectedIndicators: Set<TechnicalIndicator> = []
    
    enum TechnicalIndicator: String, CaseIterable, Hashable, Identifiable {
        case sma = "SMA", ema = "EMA", rsi = "RSI", macd = "MACD"
        case bollinger = "Bollinger Bands", stochastic = "Stochastic"
        var id: String { rawValue }
        var displayName: String { rawValue }
    }
    enum CandleStyle: String, CaseIterable, Codable, Identifiable {
        case candlestick = "Candlestick"
        case ohlcBar = "OHLC Bar"
        case line = "Line"
        case area = "Area"
        var id: Self { self }
        var displayName: String { rawValue }
    }
    enum ChartColorScheme: String, CaseIterable, Codable, Identifiable {
        case dark = "Dark", light = "Light", auto = "Auto"
        var id: Self { self }
        var backgroundColor: Color {
            switch self {
            case .dark: return .black
            case .light: return .white
            case .auto: return Color(.systemBackground)
            }
        }
    }
}

struct ChartSettingsView: View {
    @Binding var settings: AChartSettings
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTimezone = TimeZone.current
    @State private var showingTimezoneSelector = false

    var body: some View {
        NavigationStack {
            List {
                Section("🎨 CHART APPEARANCE") { chartAppearanceSettings }
                Section("📈 TRADING DISPLAY") { tradingDisplaySettings }
                Section("🌍 TIME & TIMEZONE") { timezoneSettings }
                Section("🤖 AUTO-TRADING") { autoTradingSettings }
                Section("⚡ PERFORMANCE") { performanceSettings }
                Section("🔔 ALERTS & NOTIFICATIONS") { alertSettings }
            }
            .navigationTitle("⚙️ Chart Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Reset") { resetToDefaults() }
                        .foregroundColor(.secondary)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                        .foregroundColor(DesignSystem.primaryGold)
                }
            }
        }
        .sheet(isPresented: $showingTimezoneSelector) {
            TimezoneSelectionView(selectedTimezone: $selectedTimezone)
        }
    }

    private var chartAppearanceSettings: some View {
        VStack {
            HStack {
                Label("Candle Style", systemImage: "chart.bar")
                Spacer()
                Picker("", selection: $settings.candleStyle) {
                    ForEach(AChartSettings.CandleStyle.allCases) { style in
                        Text(style.displayName).tag(style)
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }
            HStack {
                Label("Color Scheme", systemImage: "paintbrush")
                Spacer()
                Picker("", selection: $settings.colorScheme) {
                    ForEach(AChartSettings.ChartColorScheme.allCases) { scheme in
                        Text(scheme.rawValue).tag(scheme)
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }
            Toggle(isOn: $settings.showGrid) { Label("Show Grid", systemImage: "grid") }
                .tint(DesignSystem.primaryGold)
            Toggle(isOn: $settings.showVolume) { Label("Show Volume", systemImage: "chart.bar.fill") }
                .tint(DesignSystem.primaryGold)
            Toggle(isOn: $settings.showCrosshair) { Label("Show Crosshair", systemImage: "plus") }
                .tint(DesignSystem.primaryGold)
        }
    }
    private var tradingDisplaySettings: some View {
        VStack {
            Toggle(isOn: $settings.showOrderLines) { Label("Show Order Lines", systemImage: "minus") }
                .tint(DesignSystem.primaryGold)
            Toggle(isOn: $settings.showBotSignals) { Label("Show Bot Signals", systemImage: "robot") }
                .tint(DesignSystem.primaryGold)
            Toggle(isOn: $settings.showLastPrice) { Label("Show Last Price Line", systemImage: "arrow.right") }
                .tint(DesignSystem.primaryGold)
            Toggle(isOn: $settings.showBidAsk) { Label("Show Bid/Ask Prices", systemImage: "dollarsign.circle") }
                .tint(DesignSystem.primaryGold)
            Toggle(isOn: $settings.showSpread) { Label("Show Spread Info", systemImage: "arrow.left.and.right") }
                .tint(DesignSystem.primaryGold)
        }
    }
    private var timezoneSettings: some View {
        VStack(alignment: .leading) {
            Button(action: { showingTimezoneSelector = true }) {
                HStack {
                    Label("Timezone", systemImage: "clock.badge.exclamationmark")
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
        }
    }
    private var autoTradingSettings: some View {
        VStack {
            Toggle(isOn: $settings.showBotSignals) {
                Label("Show Live Bot Activity", systemImage: "antenna.radiowaves.left.and.right")
            }
            .tint(DesignSystem.primaryGold)
        }
    }
    private var performanceSettings: some View {
        VStack {
            Toggle(isOn: $settings.autoScalePrice) { Label("Auto-Scale Price Axis", systemImage: "arrow.up.and.down") }
                .tint(DesignSystem.primaryGold)
            Toggle(isOn: .constant(true)) { Label("Optimize for Performance", systemImage: "speedometer") }
                .tint(DesignSystem.primaryGold)
        }
    }
    private var alertSettings: some View {
        VStack {
            Toggle(isOn: $settings.enableAlerts) { Label("Enable Price Alerts", systemImage: "bell") }
                .tint(DesignSystem.primaryGold)
            Toggle(isOn: $settings.soundAlerts) { Label("Sound Alerts", systemImage: "speaker.wave.2") }
                .tint(DesignSystem.primaryGold)
                .disabled(!settings.enableAlerts)
            Toggle(isOn: $settings.enableNews) { Label("News Notifications", systemImage: "newspaper") }
                .tint(DesignSystem.primaryGold)
            Toggle(isOn: $settings.showEconomicCalendar) { Label("Economic Calendar", systemImage: "calendar") }
                .tint(DesignSystem.primaryGold)
        }
    }
    private var timezoneOffset: String {
        let offset = selectedTimezone.secondsFromGMT() / 3600
        let sign = offset >= 0 ? "+" : ""
        return "\(sign)\(offset)"
    }
    private func resetToDefaults() {
        settings = AChartSettings()
        selectedTimezone = TimeZone.current
    }
}

// MARK: Simple, self-contained placeholder for TimezoneSelectionView if needed
struct TimezoneSelectionView: View {
    @Binding var selectedTimezone: TimeZone
    var body: some View {
        VStack(spacing: 24) {
            Text("Select Timezone").font(.headline)
            Button("Use Current") { selectedTimezone = .current }
            Button("GMT") { selectedTimezone = TimeZone(identifier: "GMT")! }
            Button("Dismiss") {}
        }
        .padding()
    }
}

#Preview {
    ChartSettingsView(settings: .constant(AChartSettings()))
}