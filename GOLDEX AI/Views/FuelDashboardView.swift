//
//  FuelDashboardView.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 7/18/25.
//

import SwiftUI

struct FuelDashboardView: View {
    @StateObject private var fuelManager = TradingFuelManager()
    @State private var showingAutoReloadSettings = false
    @State private var showingFuelAlerts = false
    @State private var showingAddFuelSheet = false
    @State private var animateCards = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Premium Background
                LinearGradient(
                    colors: [
                        Color(.systemBackground),
                        Color.blue.opacity(0.02),
                        Color(.systemBackground)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header Section
                        headerSection
                        
                        // Fuel Gauge
                        fuelGaugeSection
                        
                        // Quick Stats
                        quickStatsSection
                        
                        // Auto-Reload Settings
                        autoReloadSection
                        
                        // Fuel Alerts
                        fuelAlertsSection
                        
                        // Usage Analytics
                        usageAnalyticsSection
                        
                        // Recent Activity
                        recentActivitySection
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                }
                .refreshable {
                    await refreshFuelData()
                }
            }
            .navigationTitle("")
            .navigationBarHidden(true)
            .onAppear {
                startAnimations()
                fuelManager.startMonitoring()
            }
            .onDisappear {
                fuelManager.stopMonitoring()
            }
        }
        .sheet(isPresented: $showingAutoReloadSettings) {
            AutoReloadSettingsView()
        }
        .sheet(isPresented: $showingFuelAlerts) {
            FuelAlertsView()
        }
        .sheet(isPresented: $showingAddFuelSheet) {
            CardPaymentView()
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("TRADING FUEL")
                        .font(.system(size: 24, weight: .black, design: .rounded))
                        .foregroundColor(.blue)
                    
                    Text("Fuel Management Dashboard")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Quick Actions
                HStack(spacing: 12) {
                    Button(action: { showingFuelAlerts = true }) {
                        Image(systemName: "bell.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.blue)
                    }
                    
                    Button(action: { showingAutoReloadSettings = true }) {
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.blue)
                    }
                }
            }
            .padding(.top, 8)
        }
        .scaleEffect(animateCards ? 1.0 : 0.95)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1), value: animateCards)
    }
    
    // MARK: - Fuel Gauge Section
    private var fuelGaugeSection: some View {
        UltraPremiumCard {
            VStack(spacing: 20) {
                // Fuel Level Display
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("CURRENT FUEL LEVEL")
                            .font(.system(size: 11, weight: .black))
                            .foregroundColor(.secondary)
                        
                        HStack(spacing: 8) {
                            Text("\(fuelManager.currentFuelLevel)%")
                                .font(.system(size: 32, weight: .black, design: .rounded))
                                .foregroundColor(fuelManager.fuelLevelColor)
                            
                            Image(systemName: "fuelpump.fill")
                                .font(.system(size: 20))
                                .foregroundColor(fuelManager.fuelLevelColor)
                        }
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 6) {
                        Text("FUEL BALANCE")
                            .font(.system(size: 11, weight: .black))
                            .foregroundColor(.secondary)
                        
                        Text(fuelManager.formattedFuelBalance)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.primary)
                    }
                }
                
                // Fuel Progress Bar
                VStack(spacing: 8) {
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(.gray.opacity(0.2))
                            .frame(height: 12)
                            .clipShape(Capsule())
                        
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    colors: fuelManager.fuelGradientColors,
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: CGFloat(fuelManager.currentFuelLevel) / 100 * (UIScreen.main.bounds.width - 80), height: 12)
                            .clipShape(Capsule())
                            .animation(.easeInOut(duration: 1.0), value: fuelManager.currentFuelLevel)
                    }
                    
                    HStack {
                        Text("Empty")
                            .font(.system(size: 10))
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Text("Full")
                            .font(.system(size: 10))
                            .foregroundColor(.secondary)
                    }
                }
                
                // Fuel Status
                HStack {
                    HStack(spacing: 6) {
                        Circle()
                            .fill(fuelManager.isAutoReloadEnabled ? .green : .orange)
                            .frame(width: 8, height: 8)
                        
                        Text(fuelManager.isAutoReloadEnabled ? "Auto-Reload ON" : "Manual Refuel")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(fuelManager.isAutoReloadEnabled ? .green : .orange)
                    }
                    
                    Spacer()
                    
                    Text(fuelManager.fuelStatusMessage)
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }
                
                // Add Fuel Button
                Button(action: {
                    showingAddFuelSheet = true
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 16))
                        Text("Add Fuel")
                            .font(.system(size: 14, weight: .bold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        LinearGradient(
                            colors: [.blue, .blue.opacity(0.8)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.95)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2), value: animateCards)
    }
    
    // MARK: - Quick Stats Section
    private var quickStatsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("⚡ Fuel Statistics")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
            
            HStack(spacing: 12) {
                FuelStatCard(
                    title: "Burn Rate",
                    value: fuelManager.formattedBurnRate,
                    subtitle: "per day",
                    icon: "flame.fill",
                    color: .red
                )
                
                FuelStatCard(
                    title: "Efficiency",
                    value: "\(fuelManager.fuelEfficiency)%",
                    subtitle: "optimal",
                    icon: "speedometer",
                    color: .green
                )
                
                FuelStatCard(
                    title: "Runtime",
                    value: fuelManager.estimatedRuntime,
                    subtitle: "remaining",
                    icon: "clock.fill",
                    color: .orange
                )
                
                FuelStatCard(
                    title: "Refuels",
                    value: "\(fuelManager.totalRefuels)",
                    subtitle: "this month",
                    icon: "arrow.clockwise.circle.fill",
                    color: .blue
                )
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.95)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3), value: animateCards)
    }
    
    // MARK: - Auto-Reload Section
    private var autoReloadSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("🔄 Auto-Reload Settings")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                
                Spacer()
                
                Button("Configure") {
                    showingAutoReloadSettings = true
                }
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.blue)
            }
            
            UltraPremiumCard {
                VStack(spacing: 16) {
                    // Auto-Reload Toggle
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Auto-Reload")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.primary)
                            
                            Text("Automatically refuel when low")
                                .font(.system(size: 11))
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Toggle("", isOn: .constant(fuelManager.isAutoReloadEnabled))
                            .scaleEffect(0.8)
                    }
                    
                    if fuelManager.isAutoReloadEnabled {
                        Divider()
                        
                        // Auto-Reload Settings Display
                        VStack(spacing: 12) {
                            HStack {
                                Text("Trigger Level:")
                                    .font(.system(size: 12))
                                    .foregroundColor(.secondary)
                                
                                Spacer()
                                
                                Text("\(fuelManager.autoReloadTrigger)%")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.primary)
                            }
                            
                            HStack {
                                Text("Refuel Amount:")
                                    .font(.system(size: 12))
                                    .foregroundColor(.secondary)
                                
                                Spacer()
                                
                                Text(fuelManager.formattedAutoReloadAmount)
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.primary)
                            }
                            
                            HStack {
                                Text("Payment Method:")
                                    .font(.system(size: 12))
                                    .foregroundColor(.secondary)
                                
                                Spacer()
                                
                                Text(fuelManager.autoReloadPaymentMethod)
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.primary)
                            }
                        }
                        .padding()
                        .background(.blue.opacity(0.05))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.95)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.4), value: animateCards)
    }
    
    // MARK: - Fuel Alerts Section
    private var fuelAlertsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("🔔 Fuel Alerts")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                
                Spacer()
                
                Button("Manage") {
                    showingFuelAlerts = true
                }
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.blue)
            }
            
            LazyVStack(spacing: 8) {
                ForEach(fuelManager.activeAlerts) { alert in
                    FuelAlertCard(alert: alert)
                }
                
                if fuelManager.activeAlerts.isEmpty {
                    UltraPremiumCard {
                        VStack(spacing: 8) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.green)
                            
                            Text("All Good!")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.primary)
                            
                            Text("No fuel alerts at this time")
                                .font(.system(size: 11))
                                .foregroundColor(.secondary)
                        }
                        .padding()
                    }
                }
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.95)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.5), value: animateCards)
    }
    
    // MARK: - Usage Analytics Section
    private var usageAnalyticsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("📈 Usage Analytics")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
            
            UltraPremiumCard {
                VStack(spacing: 16) {
                    // Today's Usage
                    HStack {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("TODAY'S CONSUMPTION")
                                .font(.system(size: 11, weight: .black))
                                .foregroundColor(.secondary)
                            
                            Text(fuelManager.formattedTodayConsumption)
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.blue)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 6) {
                            Text("VS YESTERDAY")
                                .font(.system(size: 11, weight: .black))
                                .foregroundColor(.secondary)
                            
                            HStack(spacing: 4) {
                                Image(systemName: fuelManager.consumptionTrend >= 0 ? "arrow.up.right" : "arrow.down.right")
                                    .font(.system(size: 10))
                                Text(String(format: "%+.1f%%", fuelManager.consumptionTrend))
                                    .font(.system(size: 12, weight: .bold))
                            }
                            .foregroundColor(fuelManager.consumptionTrend >= 0 ? .red : .green)
                        }
                    }
                    
                    Divider()
                    
                    // Usage Breakdown
                    VStack(spacing: 8) {
                        UsageBreakdownRow(category: "Active Trading", percentage: 65, amount: "$157.83")
                        UsageBreakdownRow(category: "Position Monitoring", percentage: 25, amount: "$60.75")
                        UsageBreakdownRow(category: "Market Analysis", percentage: 10, amount: "$24.30")
                    }
                }
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.95)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.6), value: animateCards)
    }
    
    // MARK: - Recent Activity Section
    private var recentActivitySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("📋 Recent Activity")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
            
            LazyVStack(spacing: 8) {
                ForEach(fuelManager.recentActivities.prefix(5)) { activity in
                    FuelActivityRow(activity: activity)
                }
            }
        }
        .scaleEffect(animateCards ? 1.0 : 0.95)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.7), value: animateCards)
    }
    
    // MARK: - Helper Methods
    private func startAnimations() {
        withAnimation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.2)) {
            animateCards = true
        }
    }
    
    private func refreshFuelData() async {
        await fuelManager.refreshFuelData()
    }
}

// MARK: - Supporting Views

struct FuelStatCard: View {
    let title: String
    let value: String
    let subtitle: String
    let icon: String
    let color: Color
    
    var body: some View {
        UltraPremiumCard {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(color)
                
                Text(value)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.primary)
                
                VStack(spacing: 2) {
                    Text(title)
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    Text(subtitle)
                        .font(.system(size: 8))
                        .foregroundColor(.secondary)
                }
            }
            .padding(.vertical, 4)
        }
    }
}

struct FuelAlertCard: View {
    let alert: FuelAlert
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(alert.severity.color.opacity(0.1))
                    .frame(width: 32, height: 32)
                
                Image(systemName: alert.severity.systemImage)
                    .font(.system(size: 14))
                    .foregroundColor(alert.severity.color)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(alert.title)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.primary)
                
                Text(alert.message)
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(alert.timestamp, style: .time)
                    .font(.system(size: 9))
                    .foregroundColor(.secondary)
                
                if alert.isActionable {
                    Button("Fix") {
                        // Handle alert action
                    }
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(.blue)
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct UsageBreakdownRow: View {
    let category: String
    let percentage: Int
    let amount: String
    
    var body: some View {
        HStack {
            Text(category)
                .font(.system(size: 11))
                .foregroundColor(.secondary)
            
            Spacer()
            
            HStack(spacing: 8) {
                Text("\(percentage)%")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.primary)
                
                Text(amount)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.blue)
            }
        }
    }
}

struct FuelActivityRow: View {
    let activity: FuelActivity
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(activity.type.color.opacity(0.1))
                    .frame(width: 32, height: 32)
                
                Image(systemName: activity.type.systemImage)
                    .font(.system(size: 12))
                    .foregroundColor(activity.type.color)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(activity.description)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.primary)
                
                Text(activity.timestamp, style: .relative)
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(activity.formattedAmount)
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(activity.amount >= 0 ? .green : .red)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

#Preview {
    FuelDashboardView()
}