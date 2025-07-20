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
    @State private var showingColorPicker = false
    @State private var selectedDrawingColor: Color = DesignSystem.primaryGold
    @State private var selectedLineWidth: CGFloat = 2.0
    @State private var selectedDrawingStyle: DrawingStyle = .solid
    
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 3)
    private let twoColumns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 2)
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                DesignSystem.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header Section
                        headerSection
                        
                        // Quick Actions
                        quickActionsSection
                        
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
                        
                        // Drawing Settings
                        drawingSettingsSection
                        
                        // Current Drawings Management
                        currentDrawingsSection
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                }
            }
            .navigationTitle("🛠️ Chart Tools")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Clear All") {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                            drawingManager.clearAllDrawings()
                        }
                    }
                    .foregroundColor(.red)
                    .font(.subheadline)
                    .fontWeight(.medium)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(DesignSystem.primaryGold)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                }
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
        .animation(.easeInOut(duration: 0.3), value: selectedTool)
        .animation(.easeInOut(duration: 0.3), value: drawingManager.drawings.count)
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
                
                // Stats Badge
                VStack(spacing: 4) {
                    Text("\(drawingManager.drawings.count)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(DesignSystem.primaryGold)
                    
                    Text("Drawings")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(.ultraThinMaterial)
                .cornerRadius(10)
            }
            
            // Active Tool Indicator
            if selectedTool != .none {
                activeToolIndicator
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(.ultraThinMaterial)
        .cornerRadius(16)
    }
    
    private var activeToolIndicator: some View {
        HStack(spacing: 12) {
            // Tool Icon
            ZStack {
                Circle()
                    .fill(DesignSystem.primaryGold)
                    .frame(width: 40, height: 40)
                
                Image(systemName: selectedTool.icon)
                    .foregroundColor(.white)
                    .font(.title3)
            }
            
            // Tool Info
            VStack(alignment: .leading, spacing: 2) {
                Text("Active Tool: \(selectedTool.name)")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text(selectedTool.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            
            Spacer()
            
            // Deactivate Button
            Button("Stop") {
                withAnimation(.spring()) {
                    selectedTool = .none
                    drawingManager.setActiveTool(.none)
                }
            }
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(.red)
            .cornerRadius(8)
        }
        .padding()
        .background(DesignSystem.primaryGold.opacity(0.1))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(DesignSystem.primaryGold.opacity(0.3), lineWidth: 1)
        )
    }
    
    // MARK: - Quick Actions
    
    private var quickActionsSection: some View {
        HStack(spacing: 12) {
            // Undo Button
            quickActionButton(
                title: "Undo",
                systemImage: "arrow.uturn.backward.circle.fill",
                color: .blue,
                action: {
                    drawingManager.undoLastDrawing()
                }
            )
            .disabled(drawingManager.drawings.isEmpty)
            
            // Redo Button  
            quickActionButton(
                title: "Redo",
                systemImage: "arrow.uturn.forward.circle.fill",
                color: .green,
                action: {
                    drawingManager.redoLastDrawing()
                }
            )
            .disabled(!drawingManager.canRedo)
            
            // Toggle Visibility
            quickActionButton(
                title: drawingManager.allDrawingsVisible ? "Hide All" : "Show All",
                systemImage: drawingManager.allDrawingsVisible ? "eye.slash.fill" : "eye.fill",
                color: .orange,
                action: {
                    drawingManager.toggleAllDrawingsVisibility()
                }
            )
            .disabled(drawingManager.drawings.isEmpty)
        }
    }
    
    private func quickActionButton(title: String, systemImage: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: systemImage)
                    .font(.title2)
                    .foregroundColor(color)
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(.ultraThinMaterial)
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // MARK: - Basic Drawing Tools
    
    private var basicDrawingTools: some View {
        toolSection(title: "📏 Basic Tools", subtitle: "Essential drawing tools") {
            LazyVGrid(columns: columns, spacing: 12) {
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
            LazyVGrid(columns: twoColumns, spacing: 12) {
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
            LazyVGrid(columns: twoColumns, spacing: 12) {
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
            LazyVGrid(columns: twoColumns, spacing: 12) {
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
            LazyVGrid(columns: columns, spacing: 12) {
                toolButton(tool: .triangle, title: "Triangle", subtitle: "Pattern analysis")
                toolButton(tool: .parallel, title: "Parallel", subtitle: "Channel lines")
                toolButton(tool: .symmetry, title: "Symmetry", subtitle: "Mirror analysis", isPremium: true)
            }
        }
    }
    
    // MARK: - Drawing Settings
    
    private var drawingSettingsSection: some View {
        toolSection(title: "🎨 Drawing Settings", subtitle: "Customize your drawings") {
            VStack(spacing: 16) {
                // Color Selection
                HStack {
                    Text("Color")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    Spacer()
                    
                    Button(action: {
                        showingColorPicker.toggle()
                    }) {
                        Circle()
                            .fill(selectedDrawingColor)
                            .frame(width: 30, height: 30)
                            .overlay(
                                Circle()
                                    .stroke(Color.primary.opacity(0.2), lineWidth: 1)
                            )
                    }
                }
                
                // Line Width
                HStack {
                    Text("Line Width")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    Spacer()
                    
                    Text("\(Int(selectedLineWidth))px")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Slider(value: $selectedLineWidth, in: 1...5, step: 1)
                    .accentColor(DesignSystem.primaryGold)
                
                // Drawing Style
                HStack {
                    Text("Style")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    Spacer()
                    
                    Picker("Style", selection: $selectedDrawingStyle) {
                        ForEach(DrawingStyle.allCases, id: \.rawValue) { style in
                            Text(style.rawValue.capitalized).tag(style)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .frame(maxWidth: 200)
                }
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(12)
        }
        .sheet(isPresented: $showingColorPicker) {
            ColorPicker("Select Drawing Color", selection: $selectedDrawingColor)
                .padding()
        }
    }
    
    // MARK: - Current Drawings Section
    
    private var currentDrawingsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("📋 Active Drawings")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("Manage your chart annotations")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Stats Badge
                Text("\(drawingManager.drawings.count) items")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(.ultraThinMaterial)
                    .cornerRadius(6)
            }
            
            if drawingManager.drawings.isEmpty {
                emptyDrawingsState
            } else {
                LazyVStack(spacing: 8) {
                    ForEach(Array(drawingManager.drawings.enumerated()), id: \.element.id) { index, drawing in
                        drawingRow(drawing: drawing, index: index)
                            .transition(.asymmetric(
                                insertion: .move(edge: .leading).combined(with: .opacity),
                                removal: .move(edge: .trailing).combined(with: .opacity)
                            ))
                    }
                }
            }
        }
    }
    
    private var emptyDrawingsState: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(.ultraThinMaterial)
                    .frame(width: 80, height: 80)
                
                Image(systemName: "scribble.variable")
                    .font(.system(size: 32))
                    .foregroundColor(.secondary)
            }
            
            VStack(spacing: 8) {
                Text("No drawings yet")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text("Start drawing on the chart to see your creations here. Use the tools above to analyze price action like a pro.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
        .background(.ultraThinMaterial)
        .cornerRadius(16)
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
            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.impactOccurred()
            
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                selectedTool = tool
                drawingManager.setActiveTool(tool, color: selectedDrawingColor, lineWidth: selectedLineWidth, style: selectedDrawingStyle)
            }
        }) {
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(selectedTool == tool ? DesignSystem.primaryGold : Color(.systemGray5))
                        .frame(width: 50, height: 50)
                        .scaleEffect(selectedTool == tool ? 1.1 : 1.0)
                    
                    Image(systemName: tool.icon)
                        .font(.title2)
                        .foregroundColor(selectedTool == tool ? .white : .primary)
                        .scaleEffect(selectedTool == tool ? 1.2 : 1.0)
                    
                    if isPremium {
                        VStack {
                            HStack {
                                Spacer()
                                Image(systemName: "crown.fill")
                                    .font(.caption2)
                                    .foregroundColor(DesignSystem.primaryGold)
                                    .padding(3)
                                    .background(Color.white)
                                    .clipShape(Circle())
                                    .shadow(radius: 2)
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
                        .minimumScaleFactor(0.8)
                    
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
                ? DesignSystem.primaryGold.opacity(0.15)
                : .ultraThinMaterial
            )
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        selectedTool == tool 
                        ? DesignSystem.primaryGold 
                        : Color.clear, 
                        lineWidth: selectedTool == tool ? 2 : 0
                    )
            )
            .shadow(
                color: selectedTool == tool ? DesignSystem.primaryGold.opacity(0.3) : .clear,
                radius: selectedTool == tool ? 8 : 0
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func drawingRow(drawing: ChartDrawing, index: Int) -> some View {
        HStack(spacing: 12) {
            // Tool icon with color
            ZStack {
                Circle()
                    .fill(drawing.color.opacity(0.2))
                    .frame(width: 40, height: 40)
                
                Image(systemName: drawing.tool.icon)
                    .font(.title3)
                    .foregroundColor(drawing.color)
            }
            
            // Drawing info
            VStack(alignment: .leading, spacing: 2) {
                Text(drawing.tool.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                HStack(spacing: 8) {
                    Text("Created: \(drawing.timestamp.formatted(.dateTime.hour().minute()))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Circle()
                        .fill(Color.secondary.opacity(0.5))
                        .frame(width: 2, height: 2)
                    
                    Text("Style: \(drawing.style.rawValue.capitalized)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            // Action buttons
            HStack(spacing: 8) {
                // Visibility toggle
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        drawingManager.toggleDrawingVisibility(id: drawing.id)
                    }
                }) {
                    Image(systemName: drawing.isVisible ? "eye.fill" : "eye.slash.fill")
                        .font(.caption)
                        .foregroundColor(drawing.isVisible ? DesignSystem.primaryGold : .secondary)
                        .frame(width: 30, height: 30)
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                }
                .buttonStyle(PlainButtonStyle())
                
                // Delete button
                Button(action: {
                    let impact = UIImpactFeedbackGenerator(style: .light)
                    impact.impactOccurred()
                    
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                        drawingManager.removeDrawing(id: drawing.id)
                    }
                }) {
                    Image(systemName: "trash.fill")
                        .font(.caption)
                        .foregroundColor(.white)
                        .frame(width: 30, height: 30)
                        .background(.red)
                        .clipShape(Circle())
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(.ultraThinMaterial)
        .cornerRadius(12)
        .contextMenu {
            Button("Duplicate") {
                drawingManager.duplicateDrawing(id: drawing.id)
            }
            
            Button("Edit Properties") {
                // TODO: Implement edit properties
            }
            
            Button("Delete", role: .destructive) {
                drawingManager.removeDrawing(id: drawing.id)
            }
        }
    }
}

// MARK: - Drawing Tools Manager

class DrawingToolsManager: ObservableObject {
    static let shared = DrawingToolsManager()
    
    @Published var drawings: [ChartDrawing] = []
    @Published var activeTool: DrawingTool = .none
    @Published var isDrawing: Bool = false
    @Published var canRedo: Bool = false
    
    private var undoStack: [ChartDrawing] = []
    private var redoStack: [ChartDrawing] = []
    
    private init() {}
    
    func setActiveTool(_ tool: DrawingTool, color: Color? = nil, lineWidth: CGFloat? = nil, style: DrawingStyle? = nil) {
        activeTool = tool
    }
    
    func addDrawing(_ drawing: ChartDrawing) {
        drawings.append(drawing)
        undoStack.append(drawing)
        redoStack.removeAll()
        canRedo = false
    }
    
    func removeDrawing(id: UUID) {
        if let index = drawings.firstIndex(where: { $0.id == id }) {
            undoStack.append(drawings[index])
            drawings.remove(at: index)
        }
    }
    
    func clearAllDrawings() {
        undoStack.append(contentsOf: drawings)
        drawings.removeAll()
        activeTool = .none
    }
    
    func toggleDrawingVisibility(id: UUID) {
        if let index = drawings.firstIndex(where: { $0.id == id }) {
            drawings[index].isVisible.toggle()
        }
    }
    
    func duplicateDrawing(id: UUID) {
        if let drawing = drawings.first(where: { $0.id == id }) {
            var newDrawing = drawing
            // Offset the new drawing slightly
            let newPoints = drawing.points.map { CGPoint(x: $0.x + 10, y: $0.y + 10) }
            newDrawing = ChartDrawing(tool: drawing.tool, points: newPoints, color: drawing.color)
            addDrawing(newDrawing)
        }
    }
    
    func undoLastDrawing() {
        guard !drawings.isEmpty else { return }
        let lastDrawing = drawings.removeLast()
        redoStack.append(lastDrawing)
        canRedo = true
    }
    
    func redoLastDrawing() {
        guard !redoStack.isEmpty else { return }
        let lastRedo = redoStack.removeLast()
        drawings.append(lastRedo)
        canRedo = !redoStack.isEmpty
    }
    
    func toggleAllDrawingsVisibility() {
        let shouldHide = allDrawingsVisible
        drawings.indices.forEach { index in
            drawings[index].isVisible = !shouldHide
        }
    }
    
    var allDrawingsVisible: Bool {
        !drawings.isEmpty && drawings.allSatisfy { $0.isVisible }
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
        case .verticalLine: return "line.3.horizontal"
        case .rectangle: return "rectangle"
        case .circle: return "circle"
        case .arrow: return "arrow.up.right"
        case .triangle: return "triangle"
        case .parallel: return "equal"
        case .fibRetracement: return "function"
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
        case .speedResistance: return DesignSystem.primaryText
        case .regression: return DesignSystem.secondaryText
        case .harmonic: return .purple
        case .elliot: return .blue
        case .wedge: return .orange
        case .flag: return .green
        case .symmetry: return .pink
        }
    }
}

// MARK: - Chart Drawing Model

struct ChartDrawing: Identifiable, Codable {
    let id = UUID()
    let tool: DrawingTool
    let points: [CGPoint]
    let timestamp: Date
    var isVisible: Bool = true
    var color: Color
    var lineWidth: CGFloat = 2.0
    var style: DrawingStyle = .solid
    
    init(tool: DrawingTool, points: [CGPoint], color: Color? = nil, lineWidth: CGFloat = 2.0, style: DrawingStyle = .solid) {
        self.tool = tool
        self.points = points
        self.timestamp = Date()
        self.color = color ?? tool.color
        self.lineWidth = lineWidth
        self.style = style
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

// MARK: - Preview

#Preview {
    ChartToolsView()
        .preferredColorScheme(.light)
}