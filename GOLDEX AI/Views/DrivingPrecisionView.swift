//
//  DrivingPrecisionView.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 7/13/25.
//

import SwiftUI

struct DrivingPrecisionView: View {
    @StateObject private var drivingEngine = DrivingPrecisionEngine()
    @State private var showingRouteDetails = false
    @State private var showingDrivingStats = false
    @State private var showingSettings = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Driving Dashboard
                    DrivingDashboardView(
                        drivingEngine: drivingEngine
                    )
                    
                    // Route Status
                    RouteStatusView(
                        routeStatus: drivingEngine.routeStatus,
                        flowState: drivingEngine.flowState,
                        precision: drivingEngine.precision,
                        isActivelyDriving: drivingEngine.isActivelyDriving
                    )
                    
                    // Driving Mode Selection
                    DrivingModeSelectionView(
                        selectedMode: drivingEngine.drivingMode,
                        onModeChange: { mode in
                            drivingEngine.setDrivingMode(mode)
                        }
                    )
                    
                    // Situational Awareness
                    SituationalAwarenessView(
                        awareness: drivingEngine.situationalAwareness
                    )
                    
                    // Road Conditions
                    RoadConditionsView(
                        roadConditions: drivingEngine.roadConditions
                    )
                    
                    // Autonomous Driving Controls
                    AutonomousDrivingView(
                        autonomousDriving: drivingEngine.autonomousDriving,
                        onAutopilotToggle: {
                            if drivingEngine.autonomousDriving.isEnabled {
                                drivingEngine.disableAutopilot()
                            } else {
                                drivingEngine.enableAutopilot()
                            }
                        }
                    )
                    
                    // Emergency Brake Status
                    EmergencyBrakeView(
                        emergencyBrake: drivingEngine.emergencyBrake,
                        onReset: {
                            drivingEngine.resetEmergencyBrake()
                        }
                    )
                    
                    // Driving Stats Summary
                    DrivingStatsSummaryView(
                        drivingStats: drivingEngine.drivingStats,
                        totalDrives: drivingEngine.totalDrives,
                        successfulDrives: drivingEngine.successfulDrives
                    )
                    
                    Spacer(minLength: 100)
                }
                .padding()
            }
            .navigationTitle("Driving Precision Engine")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Button("Routes") {
                            showingRouteDetails = true
                        }
                        
                        Button("Stats") {
                            showingDrivingStats = true
                        }
                        
                        Button("Settings") {
                            showingSettings = true
                        }
                    }
                }
            }
            .sheet(isPresented: $showingRouteDetails) {
                RouteDetailsView(drivingEngine: drivingEngine)
            }
            .sheet(isPresented: $showingDrivingStats) {
                DrivingStatsDetailView(drivingEngine: drivingEngine)
            }
            .sheet(isPresented: $showingSettings) {
                DrivingSettingsView(drivingEngine: drivingEngine)
            }
        }
    }
}

// MARK: - Supporting Views

struct DrivingDashboardView: View {
    let drivingEngine: DrivingPrecisionEngine
    
    var body: some View {
        VStack(spacing: 16) {
            // Speedometer Style Display
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.3), lineWidth: 8)
                    .frame(width: 160, height: 160)
                
                Circle()
                    .trim(from: 0, to: drivingEngine.precision / 100.0)
                    .stroke(
                        AngularGradient(
                            colors: [.red, .yellow, .green],
                            center: .center,
                            startAngle: .degrees(-90),
                            endAngle: .degrees(270)
                        ),
                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                    )
                    .frame(width: 160, height: 160)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 0.5), value: drivingEngine.precision)
                
                VStack(spacing: 4) {
                    Text("\(Int(drivingEngine.precision))")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(getPrecisionColor(drivingEngine.precision))
                    
                    Text("Precision")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            
            // Status Indicators
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                StatusIndicator(
                    title: "Route Status",
                    value: drivingEngine.routeStatus.rawValue,
                    color: drivingEngine.routeStatus.color,
                    icon: drivingEngine.routeStatus.icon
                )
                
                StatusIndicator(
                    title: "Flow State",
                    value: drivingEngine.flowState.rawValue,
                    color: drivingEngine.flowState.color,
                    icon: "water.waves"
                )
                
                StatusIndicator(
                    title: "Driving Mode",
                    value: drivingEngine.drivingMode.rawValue,
                    color: drivingEngine.drivingMode.color,
                    icon: "car.fill"
                )
            }
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
    
    private func getPrecisionColor(_ precision: Double) -> Color {
        switch precision {
        case 80...100: return .green
        case 60..<80: return .yellow
        case 40..<60: return .orange
        default: return .red
        }
    }
}

struct StatusIndicator: View {
    let title: String
    let value: String
    let color: Color
    let icon: String
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)
            
            Text(title)
                .font(.caption2)
                .foregroundStyle(.secondary)
            
            Text(value)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(color)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(color.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct RouteStatusView: View {
    let routeStatus: DrivingPrecisionEngine.RouteStatus
    let flowState: DrivingPrecisionEngine.FlowState
    let precision: Double
    let isActivelyDriving: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: routeStatus.icon)
                    .foregroundStyle(routeStatus.color)
                Text("Route Status")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
                
                if isActivelyDriving {
                    HStack {
                        Circle()
                            .fill(.green)
                            .frame(width: 8, height: 8)
                            .scaleEffect(1.2)
                            .animation(.easeInOut(duration: 0.8).repeatForever(), value: isActivelyDriving)
                        
                        Text("DRIVING")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundStyle(.green)
                    }
                }
            }
            
            Text(routeStatus.rawValue)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(routeStatus.color)
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Flow State")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Text(flowState.rawValue)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(flowState.color)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Precision")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Text("\(Int(precision))%")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(getPrecisionColor(precision))
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
    
    private func getPrecisionColor(_ precision: Double) -> Color {
        switch precision {
        case 80...100: return .green
        case 60..<80: return .yellow
        case 40..<60: return .orange
        default: return .red
        }
    }
}

struct DrivingModeSelectionView: View {
    let selectedMode: DrivingPrecisionEngine.DrivingMode
    let onModeChange: (DrivingPrecisionEngine.DrivingMode) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Driving Style")
                .font(.headline)
                .fontWeight(.semibold)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                ForEach(DrivingPrecisionEngine.DrivingMode.allCases, id: \.self) { mode in
                    DrivingModeCard(
                        mode: mode,
                        isSelected: selectedMode == mode,
                        onSelect: {
                            onModeChange(mode)
                        }
                    )
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
}

struct DrivingModeCard: View {
    let mode: DrivingPrecisionEngine.DrivingMode
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            VStack(spacing: 8) {
                Image(systemName: "car.fill")
                    .font(.title2)
                    .foregroundStyle(isSelected ? .white : mode.color)
                
                Text(mode.rawValue)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(isSelected ? .white : .primary)
                
                Text(mode.description)
                    .font(.caption2)
                    .foregroundStyle(isSelected ? .white.opacity(0.8) : .secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? AnyShapeStyle(mode.color.gradient) : AnyShapeStyle(Color.clear))
                    .stroke(isSelected ? .clear : mode.color.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct SituationalAwarenessView: View {
    let awareness: DrivingPrecisionEngine.SituationalAwareness
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "eye.fill")
                    .foregroundStyle(.blue)
                Text("Situational Awareness")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
                Text("\(Int(awareness.overallAwareness * 100))%")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(getAwarenessColor(awareness.overallAwareness))
            }
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                AwarenessIndicator(
                    title: "Rearview Mirror",
                    icon: "car.rear.fill",
                    value: "\(awareness.rearviewMirror.recentPriceAction.count) points",
                    color: .blue
                )
                
                AwarenessIndicator(
                    title: "Side Mirrors",
                    icon: "car.side.fill",
                    value: "\(awareness.sideMirrors.correlatedAssets.count) assets",
                    color: .green
                )
                
                AwarenessIndicator(
                    title: "Windshield",
                    icon: "windshield.front.and.windshield.rear.up.fill",
                    value: "\(Int(awareness.windshield.visibility * 100))% clear",
                    color: .mint
                )
                
                AwarenessIndicator(
                    title: "Dashboard",
                    icon: "gauge.medium.fill",
                    value: "\(Int(awareness.dashboard.engineHealth * 100))% health",
                    color: .orange
                )
            }
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
    
    private func getAwarenessColor(_ awareness: Double) -> Color {
        switch awareness {
        case 0.8...1.0: return .green
        case 0.6..<0.8: return .yellow
        case 0.4..<0.6: return .orange
        default: return .red
        }
    }
}

struct AwarenessIndicator: View {
    let title: String
    let icon: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(color)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Text(value)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(.primary)
            }
            
            Spacer()
        }
        .padding()
        .background(color.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct RoadConditionsView: View {
    let roadConditions: DrivingPrecisionEngine.RoadConditions
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "road.lanes")
                    .foregroundStyle(.gray)
                Text("Road Conditions")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
                Text("\(Int(roadConditions.qualityScore * 100))%")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(getQualityColor(roadConditions.qualityScore))
            }
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Surface")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Text(getSurfaceDisplayName(roadConditions.surface))
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Visibility")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Text("\(Int(roadConditions.visibility * 100))%")
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
            }
            
            if !roadConditions.hazards.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Active Hazards")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(.orange)
                    
                    ForEach(roadConditions.hazards.indices, id: \.self) { index in
                        let hazard = roadConditions.hazards[index]
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundStyle(.orange)
                                .font(.caption)
                            
                            Text(getHazardDisplayName(hazard.type))
                                .font(.caption)
                                .fontWeight(.medium)
                            
                            Spacer()
                            
                            Text("\(Int(hazard.severity * 100))%")
                                .font(.caption)
                                .foregroundStyle(.orange)
                        }
                    }
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
    
    private func getQualityColor(_ quality: Double) -> Color {
        switch quality {
        case 0.8...1.0: return .green
        case 0.6..<0.8: return .yellow
        case 0.4..<0.6: return .orange
        default: return .red
        }
    }
    
    private func getSurfaceDisplayName(_ surface: DrivingPrecisionEngine.RoadConditions.RoadSurface) -> String {
        switch surface {
        case .smooth: return "Smooth"
        case .rough: return "Rough"
        case .icy: return "Icy"
        case .wet: return "Wet"
        case .damaged: return "Damaged"
        }
    }
    
    private func getHazardDisplayName(_ hazard: DrivingPrecisionEngine.RoadConditions.RoadHazard.HazardType) -> String {
        switch hazard {
        case .pothole: return "Pothole"
        case .debris: return "Debris"
        case .accident: return "Accident"
        case .animal: return "Animal"
        case .weather: return "Weather"
        }
    }
}

struct AutonomousDrivingView: View {
    let autonomousDriving: DrivingPrecisionEngine.AutonomousDriving
    let onAutopilotToggle: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "brain.head.profile")
                    .foregroundStyle(.purple)
                Text("Autonomous Driving")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
                
                Toggle("", isOn: .constant(autonomousDriving.isEnabled))
                    .onChange(of: autonomousDriving.isEnabled) { _, _ in
                        onAutopilotToggle()
                    }
            }
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Autopilot Level")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Text(autonomousDriving.autopilotLevel.rawValue)
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Confidence")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Text("\(Int(autonomousDriving.autopilotLevel.confidence * 100))%")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(.green)
                }
            }
            
            if autonomousDriving.overrideControls.manualOverride {
                HStack {
                    Image(systemName: "hand.raised.fill")
                        .foregroundStyle(.orange)
                    Text("Manual Override Active")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(.orange)
                }
                .padding(.vertical, 4)
                .padding(.horizontal, 8)
                .background(.orange.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 6))
            }
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
}

struct EmergencyBrakeView: View {
    let emergencyBrake: DrivingPrecisionEngine.EmergencyBrake
    let onReset: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "exclamationmark.octagon.fill")
                    .foregroundStyle(emergencyBrake.isActive ? .red : .gray)
                Text("Emergency Brake")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
                
                if emergencyBrake.isActive {
                    Button("Reset", action: onReset)
                        .buttonStyle(.borderedProminent)
                        .tint(.red)
                }
            }
            
            if emergencyBrake.isActive {
                VStack(alignment: .leading, spacing: 8) {
                    Text("EMERGENCY BRAKE ACTIVE")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundStyle(.red)
                    
                    Text(emergencyBrake.response.actionTaken)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    Text("Response Time: \(Int(emergencyBrake.response.responseTime * 1000))ms")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding()
                .background(.red.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            } else {
                Text("All systems normal")
                    .font(.subheadline)
                    .foregroundStyle(.green)
            }
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
}

struct DrivingStatsSummaryView: View {
    let drivingStats: DrivingPrecisionEngine.DrivingStats
    let totalDrives: Int
    let successfulDrives: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "chart.bar.fill")
                    .foregroundStyle(.green)
                Text("Driving Statistics")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
            }
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                DrivingStatCard(
                    title: "Total Drives",
                    value: "\(totalDrives)",
                    color: .blue
                )
                
                DrivingStatCard(
                    title: "Success Rate",
                    value: "\(Int(Double(successfulDrives) / Double(max(1, totalDrives)) * 100))%",
                    color: .green
                )
                
                DrivingStatCard(
                    title: "Safety Score",
                    value: "\(Int(drivingStats.safetyScore))",
                    color: .mint
                )
                
                DrivingStatCard(
                    title: "Perfect Drives",
                    value: "\(drivingStats.perfectDrives)",
                    color: .purple
                )
            }
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
}

struct DrivingStatCard: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(color)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(color.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

// MARK: - Detail Views

struct RouteDetailsView: View {
    let drivingEngine: DrivingPrecisionEngine
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Route Details")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    
                    // Route details content here
                    
                    Spacer()
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct DrivingStatsDetailView: View {
    let drivingEngine: DrivingPrecisionEngine
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Driving Statistics")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    
                    // Detailed stats content here
                    
                    Spacer()
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct DrivingSettingsView: View {
    let drivingEngine: DrivingPrecisionEngine
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List {
                Section("Driving Preferences") {
                    Text("Settings content coming soon...")
                }
            }
            .navigationTitle("Driving Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview("Driving Precision Engine") {
    DrivingPrecisionView()
}

#Preview("Driving Precision Engine Light") {
    DrivingPrecisionView()
        .preferredColorScheme(.light)
}