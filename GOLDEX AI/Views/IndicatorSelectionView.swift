//
//  IndicatorSelectionView.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 7/18/25.
//

import SwiftUI

struct IndicatorSelectionView: View {
    @Binding var settings: ChartSettings
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    @State private var selectedCategory: IndicatorCategory = .all
    @State private var showingCustomIndicator = false
    
    enum IndicatorCategory: String, CaseIterable {
        case all = "All"
        case trend = "Trend"
        case momentum = "Momentum"
        case volume = "Volume"
        case volatility = "Volatility"
        case custom = "Custom"
        
        var icon: String {
            switch self {
            case .all: return "square.grid.2x2"
            case .trend: return "chart.line.uptrend.xyaxis"
            case .momentum: return "speedometer"
            case .volume: return "chart.bar.fill"
            case .volatility: return "waveform"
            case .custom: return "slider.horizontal.below.rectangle"
            }
        }
        
        var color: Color {
            switch self {
            case .all: return .gray
            case .trend: return .blue
            case .momentum: return .purple
            case .volume: return .green
            case .volatility: return .orange
            case .custom: return DesignSystem.primaryGold
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Search and category selector
                searchAndCategorySection
                
                // Selected indicators summary
                selectedIndicatorsSection
                
                // Available indicators
                availableIndicatorsSection
            }
            .navigationTitle("📊 Technical Indicators")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Clear All") {
                        settings.selectedIndicators.removeAll()
                    }
                    .foregroundColor(.secondary)
                    .disabled(settings.selectedIndicators.isEmpty)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(DesignSystem.primaryGold)
                }
            }
        }
        .sheet(isPresented: $showingCustomIndicator) {
            CustomIndicatorView()
        }
    }
    
    // MARK: - Search and Category Section
    
    private var searchAndCategorySection: some View {
        VStack(spacing: 12) {
            // Search bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                
                TextField("Search indicators...", text: $searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                
                if !searchText.isEmpty {
                    Button("Clear") {
                        searchText = ""
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
            
            // Category selector
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(IndicatorCategory.allCases, id: \.self) { category in
                        categoryButton(category: category)
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding()
        .background(Color(.systemBackground))
    }
    
    private func categoryButton(category: IndicatorCategory) -> some View {
        Button(action: {
            selectedCategory = category
        }) {
            HStack(spacing: 6) {
                Image(systemName: category.icon)
                    .font(.caption)
                
                Text(category.rawValue)
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .foregroundColor(selectedCategory == category ? .white : category.color)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                selectedCategory == category 
                ? category.color 
                : category.color.opacity(0.1)
            )
            .cornerRadius(20)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // MARK: - Selected Indicators Section
    
    private var selectedIndicatorsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("🎯 ACTIVE INDICATORS (\(settings.selectedIndicators.count))")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Spacer()
                
                if !settings.selectedIndicators.isEmpty {
                    Button("Remove All") {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            settings.selectedIndicators.removeAll()
                        }
                    }
                    .font(.caption)
                    .foregroundColor(.red)
                }
            }
            
            if settings.selectedIndicators.isEmpty {
                Text("No indicators selected")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 20)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(settings.selectedIndicators, id: \.self) { indicator in
                            selectedIndicatorChip(indicator: indicator)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
    }
    
    private func selectedIndicatorChip(indicator: TechnicalIndicator) -> some View {
        HStack(spacing: 6) {
            Circle()
                .fill(indicator.defaultColor)
                .frame(width: 8, height: 8)
            
            Text(indicator.displayName)
                .font(.caption)
                .foregroundColor(.primary)
            
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    settings.selectedIndicators.removeAll { $0 == indicator }
                }
            }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(indicator.defaultColor.opacity(0.3), lineWidth: 1)
        )
    }
    
    // MARK: - Available Indicators Section
    
    private var availableIndicatorsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("📈 AVAILABLE INDICATORS")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Button(action: {
                    showingCustomIndicator = true
                }) {
                    Label("Custom", systemImage: "plus.circle")
                        .font(.caption)
                        .foregroundColor(DesignSystem.primaryGold)
                }
            }
            .padding(.horizontal)
            
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(filteredIndicators, id: \.self) { indicator in
                        indicatorRow(indicator: indicator)
                    }
                }
            }
        }
    }
    
    private var filteredIndicators: [TechnicalIndicator] {
        let allIndicators = TechnicalIndicator.allCases
        let categoryFiltered: [TechnicalIndicator]
        
        switch selectedCategory {
        case .all:
            categoryFiltered = allIndicators
        case .trend:
            categoryFiltered = [.sma, .ema, .bollinger]
        case .momentum:
            categoryFiltered = [.rsi, .stochastic, .williams, .cci]
        case .volume:
            categoryFiltered = [.atr]
        case .volatility:
            categoryFiltered = [.bollinger, .atr]
        case .custom:
            categoryFiltered = [] // Custom indicators would go here
        }
        
        if searchText.isEmpty {
            return categoryFiltered
        } else {
            return categoryFiltered.filter { indicator in
                indicator.displayName.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    private func indicatorRow(indicator: TechnicalIndicator) -> some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.3)) {
                if settings.selectedIndicators.contains(indicator) {
                    settings.selectedIndicators.removeAll { $0 == indicator }
                } else {
                    settings.selectedIndicators.append(indicator)
                }
            }
        }) {
            HStack(spacing: 16) {
                // Indicator icon and color
                VStack(spacing: 4) {
                    Circle()
                        .fill(indicator.defaultColor)
                        .frame(width: 16, height: 16)
                    
                    Text(getIndicatorSymbol(indicator))
                        .font(.caption2)
                        .foregroundColor(indicator.defaultColor)
                }
                
                // Indicator info
                VStack(alignment: .leading, spacing: 4) {
                    Text(indicator.displayName)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    Text(getIndicatorDescription(indicator))
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                
                Spacer()
                
                // Selection state and overlay info
                VStack(alignment: .trailing, spacing: 4) {
                    if settings.selectedIndicators.contains(indicator) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                            .font(.title3)
                    } else {
                        Image(systemName: "plus.circle")
                            .foregroundColor(.secondary)
                            .font(.title3)
                    }
                    
                    Text(indicator.isOverlay ? "Overlay" : "Sub-chart")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color(.systemGray6))
                        .cornerRadius(4)
                }
            }
            .padding()
            .background(
                settings.selectedIndicators.contains(indicator) 
                ? indicator.defaultColor.opacity(0.05) 
                : Color.clear
            )
            .overlay(
                Rectangle()
                    .fill(Color(.systemGray4))
                    .frame(height: 0.5)
                    .opacity(0.5),
                alignment: .bottom
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func getIndicatorSymbol(indicator: TechnicalIndicator) -> String {
        switch indicator {
        case .sma: return "SMA"
        case .ema: return "EMA"
        case .rsi: return "RSI"
        case .macd: return "MACD"
        case .bollinger: return "BB"
        case .stochastic: return "STOCH"
        case .williams: return "%R"
        case .cci: return "CCI"
        case .atr: return "ATR"
        case .adx: return "ADX"
        case .fibonacci: return "FIB"
        case .pivotPoints: return "PP"
        }
    }
    
    private func getIndicatorDescription(indicator: TechnicalIndicator) -> String {
        switch indicator {
        case .sma:
            return "Simple Moving Average - Shows average price over time period"
        case .ema:
            return "Exponential Moving Average - Gives more weight to recent prices"
        case .rsi:
            return "Relative Strength Index - Momentum oscillator (0-100)"
        case .macd:
            return "MACD - Moving Average Convergence Divergence"
        case .bollinger:
            return "Bollinger Bands - Volatility bands around moving average"
        case .stochastic:
            return "Stochastic Oscillator - Compares closing price to range"
        case .williams:
            return "Williams %R - Momentum indicator (-100 to 0)"
        case .cci:
            return "Commodity Channel Index - Cyclical turning points"
        case .atr:
            return "Average True Range - Measures market volatility"
        case .adx:
            return "Average Directional Index - Trend strength indicator"
        case .fibonacci:
            return "Fibonacci Retracements - Support/resistance levels"
        case .pivotPoints:
            return "Pivot Points - Key support and resistance levels"
        }
    }
}

// MARK: - Custom Indicator View

struct CustomIndicatorView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var indicatorName = ""
    @State private var selectedType: CustomIndicatorType = .movingAverage
    @State private var period = 14
    @State private var selectedColor = Color.blue
    
    enum CustomIndicatorType: String, CaseIterable {
        case movingAverage = "Moving Average"
        case oscillator = "Oscillator"
        case volatility = "Volatility"
        case custom = "Custom Formula"
        
        var icon: String {
            switch self {
            case .movingAverage: return "chart.line.uptrend.xyaxis"
            case .oscillator: return "waveform"
            case .volatility: return "chart.bar.doc.horizontal"
            case .custom: return "function"
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 8) {
                    Text("🔧 Create Custom Indicator")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("Build your own technical indicator")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top)
                
                // Form
                VStack(spacing: 20) {
                    // Indicator name
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Indicator Name")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        TextField("Enter indicator name", text: $indicatorName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    // Indicator type
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Type")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                            ForEach(CustomIndicatorType.allCases, id: \.self) { type in
                                customTypeButton(type: type)
                            }
                        }
                    }
                    
                    // Period setting
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Period: \(period)")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Slider(value: Binding(
                            get: { Double(period) },
                            set: { period = Int($0) }
                        ), in: 1...200, step: 1)
                        .tint(DesignSystem.primaryGold)
                    }
                    
                    // Color selection
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Color")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        ColorPicker("Select Color", selection: $selectedColor)
                            .labelsHidden()
                    }
                }
                
                Spacer()
                
                // Action buttons
                VStack(spacing: 12) {
                    Button("Create Indicator") {
                        createCustomIndicator()
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .disabled(indicatorName.isEmpty)
                    
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.secondary)
                }
            }
            .padding()
        }
    }
    
    private func customTypeButton(type: CustomIndicatorType) -> some View {
        Button(action: {
            selectedType = type
        }) {
            VStack(spacing: 8) {
                Image(systemName: type.icon)
                    .font(.title2)
                    .foregroundColor(selectedType == type ? .white : DesignSystem.primaryGold)
                
                Text(type.rawValue)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(selectedType == type ? .white : .primary)
                    .multilineTextAlignment(.center)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                selectedType == type 
                ? DesignSystem.primaryGold 
                : DesignSystem.primaryGold.opacity(0.1)
            )
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func createCustomIndicator() {
        // Logic to create custom indicator
        dismiss()
    }
}

#Preview {
    IndicatorSelectionView(settings: .constant(ChartSettings()))
}