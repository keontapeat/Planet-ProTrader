//
//  ChartToolsView.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 1/21/25.
//

import SwiftUI

struct ChartToolsView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var drawingManager = DrawingToolsManager.shared
    @State private var selectedTool: DrawingTool = .none
    @State private var showingAdvancedTools = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                headerSection
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Basic Drawing Tools
                        basicDrawingTools
                        
                        // Technical Analysis Tools
                        technicalAnalysisTools
                        
                        // Advanced Pattern Tools
                        advancedPatternTools
                        
                        // Fibonacci Tools
                        fibonacciTools
                        
                        // Geometric Tools
                        geometricTools
                        
                        // Current Drawings Management
                        currentDrawingsSection
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                }
            }
            .background(Color(.systemBackground))
            .navigationTitle("🛠️ Chart Tools")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .foregroundColor(DesignSystem.primaryGold)
                }
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Professional Drawing Tools")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("Create institutional-level chart analysis")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Clear All Button
                Button(action: {
                    withAnimation(.spring()) {
                        drawingManager.clearAllDrawings()
                    }
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "trash.fill")
                            .font(.caption)
                        Text("Clear All")
                            .font(.caption)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.red)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(8)
                }
            }
            
            // Active Tool Indicator
            if selectedTool != .none {
                HStack {
                    Image(systemName: selectedTool.icon)
                        .foregroundColor(DesignSystem.primaryGold)
                        .font(.title3)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Active Tool: \(selectedTool.name)")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        
                        Text(selectedTool.description)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Button("Deactivate") {
                        withAnimation(.spring()) {
                            selectedTool = .none
                            drawingManager.setActiveTool(.none)
                        }
                    }
                    .font(.caption)
                    .foregroundColor(.red)
                }
                .padding()
                .background(DesignSystem.primaryGold.opacity(0.1))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(DesignSystem.primaryGold.opacity(0.3), lineWidth: 1)
                )
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .padding(.bottom, 16)
        .background(Color(.systemGray6).opacity(0.5))
    }
    
    // MARK: - Basic Drawing Tools
    
    private var basicDrawingTools: some View {
        toolSection(title: "📏 Basic Tools", subtitle: "Essential drawing tools") {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 12) {
                toolButton(tool: .trendLine, title: "Trend Line", subtitle: "Draw trend lines")
                toolButton(tool: .horizontalLine, title: "Horizontal", subtitle: "Support/Resistance")
                toolButton(tool: .verticalLine, title: "Vertical", subtitle: "Time reference")
                toolButton(tool: .rectangle, title: "Rectangle", subtitle: "Price ranges")
                toolButton(tool: .circle, title: "Circle", subtitle: "Cycle analysis")
                toolButton(tool: .arrow, title: "Arrow", subtitle: "Price targets")
            }
        }
    }
    
    // MARK: - Technical Analysis Tools
    
    private var technicalAnalysisTools: some View {
        toolSection(title: "📊 Technical Analysis", subtitle: "Professional analysis tools") {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                toolButton(tool: .pitchfork, title: "Andrews Pitchfork", subtitle: "Channel analysis", isPremium: true)
                toolButton(tool: .gannFan, title: "Gann Fan", subtitle: "Time/price analysis", isPremium: true)
                toolButton(tool: .speedResistance, title: "Speed Lines", subtitle: "Resistance levels", isPremium: true)
                toolButton(tool: .regression, title: "Regression", subtitle: "Statistical trend", isPremium: true)
            }
        }
    }
    
    // MARK: - Advanced Pattern Tools
    
    private var advancedPatternTools: some View {
        toolSection(title: "🎯 Pattern Recognition", subtitle: "Identify trading patterns") {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                toolButton(tool: .harmonic, title: "Harmonic Patterns", subtitle: "XABCD patterns", isPremium: true)
                toolButton(tool: .elliot, title: "Elliott Wave", subtitle: "Wave analysis", isPremium: true)
                toolButton(tool: .wedge, title: "Wedge", subtitle: "Consolidation", isPremium: true)
                toolButton(tool: .flag, title: "Flag/Pennant", subtitle: "Continuation", isPremium: true)
            }
        }
    }
    
    // MARK: - Fibonacci Tools
    
    private var fibonacciTools: some View {
        toolSection(title: "🌀 Fibonacci Suite", subtitle: "Complete Fibonacci toolkit") {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                toolButton(tool: .fibRetracement, title: "Retracement", subtitle: "38.2%, 50%, 61.8%")
                toolButton(tool: .fibExtension, title: "Extension", subtitle: "127.2%, 161.8%")
                toolButton(tool: .fibFan, title: "Fibonacci Fan", subtitle: "Trending support", isPremium: true)
                toolButton(tool: .fibTimeZone, title: "Time Zones", subtitle: "Time analysis", isPremium: true)
            }
        }
    }
    
    // MARK: - Geometric Tools
    
    private var geometricTools: some View {
        toolSection(title: "📐 Geometric Analysis", subtitle: "Advanced geometric tools") {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 12) {
                toolButton(tool: .triangle, title: "Triangle", subtitle: "Pattern analysis")
                toolButton(tool: .parallel, title: "Parallel", subtitle: "Channel lines")
                toolButton(tool: .symmetry, title: "Symmetry", subtitle: "Mirror analysis", isPremium: true)
            }
        }
    }
    
    // MARK: - Current Drawings Section
    
    private var currentDrawingsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("📋 Active Drawings")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Text("\(drawingManager.drawings.count) items")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color(.systemGray5))
                    .cornerRadius(6)
            }
            
            if drawingManager.drawings.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "scribble.variable")
                        .font(.system(size: 40))
                        .foregroundColor(.secondary)
                    
                    Text("No drawings yet")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text("Start drawing on the chart to see your creations here")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
                .background(Color(.systemGray6).opacity(0.5))
                .cornerRadius(12)
            } else {
                LazyVStack(spacing: 8) {
                    ForEach(Array(drawingManager.drawings.enumerated()), id: \.element.id) { index, drawing in
                        drawingRow(drawing: drawing, index: index)
                    }
                }
            }
        }
    }
    
    // MARK: - Helper Views
    
    private func toolSection<Content: View>(title: String, subtitle: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            content()
        }
        .padding(.vertical, 8)
    }
    
    private func toolButton(tool: DrawingTool, title: String, subtitle: String, isPremium: Bool = false) -> some View {
        Button(action: {
            withAnimation(.spring()) {
                selectedTool = tool
                drawingManager.setActiveTool(tool)
            }
        }) {
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(selectedTool == tool ? DesignSystem.primaryGold : Color(.systemGray5))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: tool.icon)
                        .font(.title2)
                        .foregroundColor(selectedTool == tool ? .white : .primary)
                    
                    if isPremium {
                        VStack {
                            HStack {
                                Spacer()
                                Image(systemName: "crown.fill")
                                    .font(.caption)
                                    .foregroundColor(DesignSystem.primaryGold)
                                    .padding(4)
                                    .background(Color.white)
                                    .clipShape(Circle())
                            }
                            Spacer()
                        }
                    }
                }
                
                VStack(spacing: 2) {
                    Text(title)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    
                    Text(subtitle)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                }
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 8)
            .background(
                selectedTool == tool 
                ? DesignSystem.primaryGold.opacity(0.1)
                : Color(.systemBackground)
            )
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        selectedTool == tool 
                        ? DesignSystem.primaryGold 
                        : Color(.systemGray4).opacity(0.5), 
                        lineWidth: selectedTool == tool ? 2 : 1
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func drawingRow(drawing: ChartDrawing, index: Int) -> some View {
        HStack(spacing: 12) {
            // Tool icon
            Image(systemName: drawing.tool.icon)
                .font(.title3)
                .foregroundColor(drawing.tool.color)
                .frame(width: 30)
            
            // Drawing info
            VStack(alignment: .leading, spacing: 2) {
                Text(drawing.tool.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                Text("Created: \(drawing.timestamp.formatted(.dateTime.hour().minute()))")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Visibility toggle
            Button(action: {
                drawingManager.toggleDrawingVisibility(id: drawing.id)
            }) {
                Image(systemName: drawing.isVisible ? "eye.fill" : "eye.slash.fill")
                    .font(.caption)
                    .foregroundColor(drawing.isVisible ? DesignSystem.primaryGold : .secondary)
                    .padding(8)
                    .background(Color(.systemGray6))
                    .clipShape(Circle())
            }
            
            // Delete button
            Button(action: {
                withAnimation(.spring()) {
                    drawingManager.removeDrawing(id: drawing.id)
                }
            }) {
                Image(systemName: "trash.fill")
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding(8)
                    .background(Color.red.opacity(0.1))
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(Color(.systemGray6).opacity(0.5))
        .cornerRadius(10)
    }
}

// MARK: - Drawing Tools Manager

class DrawingToolsManager: ObservableObject {
    static let shared = DrawingToolsManager()
    
    @Published var drawings: [ChartDrawing] = []
    @Published var activeTool: DrawingTool = .none
    @Published var isDrawing: Bool = false
    
    private init() {}
    
    func setActiveTool(_ tool: DrawingTool) {
        activeTool = tool
    }
    
    func addDrawing(_ drawing: ChartDrawing) {
        drawings.append(drawing)
    }
    
    func removeDrawing(id: UUID) {
        drawings.removeAll { $0.id == id }
    }
    
    func clearAllDrawings() {
        drawings.removeAll()
        activeTool = .none
    }
    
    func toggleDrawingVisibility(id: UUID) {
        if let index = drawings.firstIndex(where: { $0.id == id }) {
            drawings[index].isVisible.toggle()
        }
    }
}

// MARK: - Drawing Tool Enum

enum DrawingTool: String, CaseIterable {
    case none = "none"
    case trendLine = "trend_line"
    case horizontalLine = "horizontal_line"
    case verticalLine = "vertical_line"
    case rectangle = "rectangle"
    case circle = "circle"
    case arrow = "arrow"
    case triangle = "triangle"
    case parallel = "parallel"
    case fibRetracement = "fib_retracement"
    case fibExtension = "fib_extension"
    case fibFan = "fib_fan"
    case fibTimeZone = "fib_timezone"
    case pitchfork = "pitchfork"
    case gannFan = "gann_fan"
    case speedResistance = "speed_resistance"
    case regression = "regression"
    case harmonic = "harmonic"
    case elliot = "elliot"
    case wedge = "wedge"
    case flag = "flag"
    case symmetry = "symmetry"
    
    var name: String {
        switch self {
        case .none: return "None"
        case .trendLine: return "Trend Line"
        case .horizontalLine: return "Horizontal Line"
        case .verticalLine: return "Vertical Line"
        case .rectangle: return "Rectangle"
        case .circle: return "Circle"
        case .arrow: return "Arrow"
        case .triangle: return "Triangle"
        case .parallel: return "Parallel Lines"
        case .fibRetracement: return "Fib Retracement"
        case .fibExtension: return "Fib Extension"
        case .fibFan: return "Fibonacci Fan"
        case .fibTimeZone: return "Fib Time Zone"
        case .pitchfork: return "Pitchfork"
        case .gannFan: return "Gann Fan"
        case .speedResistance: return "Speed Lines"
        case .regression: return "Regression"
        case .harmonic: return "Harmonic"
        case .elliot: return "Elliott Wave"
        case .wedge: return "Wedge"
        case .flag: return "Flag"
        case .symmetry: return "Symmetry"
        }
    }
    
    var icon: String {
        switch self {
        case .none: return "hand.point.up.braille"
        case .trendLine: return "line.diagonal"
        case .horizontalLine: return "line.horizontal.3"
        case .verticalLine: return "line.vertical"
        case .rectangle: return "rectangle"
        case .circle: return "circle"
        case .arrow: return "arrow.up.right"
        case .triangle: return "triangle"
        case .parallel: return "equal"
        case .fibRetracement: return "fiberchannel"
        case .fibExtension: return "arrow.up.and.down.and.arrow.left.and.right"
        case .fibFan: return "fan.fill"
        case .fibTimeZone: return "clock.fill"
        case .pitchfork: return "tuningfork"
        case .gannFan: return "rays"
        case .speedResistance: return "speedometer"
        case .regression: return "waveform.path"
        case .harmonic: return "waveform"
        case .elliot: return "chart.line.uptrend.xyaxis"
        case .wedge: return "triangle.fill"
        case .flag: return "flag.fill"
        case .symmetry: return "arrow.left.and.right.righttriangle.left.righttriangle.right.fill"
        }
    }
    
    var description: String {
        switch self {
        case .none: return "Select a drawing tool"
        case .trendLine: return "Draw trend lines to identify price direction"
        case .horizontalLine: return "Mark support and resistance levels"
        case .verticalLine: return "Add vertical reference lines"
        case .rectangle: return "Define price ranges and consolidation zones"
        case .circle: return "Circle patterns for cycle analysis"
        case .arrow: return "Point to key price levels"
        case .triangle: return "Triangle patterns for breakout analysis"
        case .parallel: return "Draw parallel channel lines"
        case .fibRetracement: return "Fibonacci retracement levels"
        case .fibExtension: return "Fibonacci extension targets"
        case .fibFan: return "Fan-based Fibonacci analysis"
        case .fibTimeZone: return "Time-based Fibonacci analysis"
        case .pitchfork: return "Andrews Pitchfork channel analysis"
        case .gannFan: return "Gann Fan time/price relationship"
        case .speedResistance: return "Speed resistance lines"
        case .regression: return "Statistical trend regression"
        case .harmonic: return "XABCD harmonic pattern analysis"
        case .elliot: return "Elliott Wave count and analysis"
        case .wedge: return "Wedge consolidation patterns"
        case .flag: return "Flag and pennant continuation patterns"
        case .symmetry: return "Symmetry and mirror analysis"
        }
    }
    
    var color: Color {
        switch self {
        case .none: return .secondary
        case .trendLine: return .blue
        case .horizontalLine: return .red
        case .verticalLine: return .green
        case .rectangle: return .purple
        case .circle: return .orange
        case .arrow: return .pink
        case .triangle: return .cyan
        case .parallel: return .indigo
        case .fibRetracement: return DesignSystem.primaryGold
        case .fibExtension: return .yellow
        case .fibFan: return .mint
        case .fibTimeZone: return .teal
        case .pitchfork: return .brown
        case .gannFan: return .gray
        case .speedResistance: return .primary
        case .regression: return .secondary
        case .harmonic: return .purple
        case .elliot: return .blue
        case .wedge: return .orange
        case .flag: return .green
        case .symmetry: return .pink
        }
    }
}

// MARK: - Chart Drawing Model

struct ChartDrawing: Identifiable {
    let id = UUID()
    let tool: DrawingTool
    let points: [CGPoint]
    let timestamp: Date
    var isVisible: Bool = true
    var color: Color
    var lineWidth: CGFloat = 2.0
    var style: DrawingStyle = .solid
    
    init(tool: DrawingTool, points: [CGPoint], color: Color? = nil) {
        self.tool = tool
        self.points = points
        self.timestamp = Date()
        self.color = color ?? tool.color
    }
}

enum DrawingStyle: String, CaseIterable {
    case solid = "solid"
    case dashed = "dashed"
    case dotted = "dotted"
    
    var strokeStyle: StrokeStyle {
        switch self {
        case .solid:
            return StrokeStyle(lineWidth: 2.0)
        case .dashed:
            return StrokeStyle(lineWidth: 2.0, dash: [8, 4])
        case .dotted:
            return StrokeStyle(lineWidth: 2.0, dash: [2, 2])
        }
    }
}

#Preview {
    ChartToolsView()
}