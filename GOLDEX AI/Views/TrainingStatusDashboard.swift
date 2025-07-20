 //
//  TrainingStatusDashboard.swift
//  GOLDEX AI
//
//  Created by Keonta on 7/13/25.
//

import SwiftUI

struct TrainingStatusDashboard: View {
    @StateObject private var trainingViewModel = TrainingStatusViewModel()
    @State private var animateProgress = false
    @State private var showingUploadSheet = false
    @State private var showingReplayMode = false
    @State private var pulseAnimation = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background with subtle gradient
                LinearGradient(
                    colors: [
                        Color.white,
                        DesignSystem.primaryGold.opacity(0.02),
                        Color.white
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header Section
                        headerSection
                        
                        // Training Status Indicator
                        trainingStatusCard
                        
                        // Progress Overview
                        progressOverviewCard
                        
                        // Historical Data Fed Section
                        historicalDataFedCard
                        
                        // Intelligence Metrics
                        intelligenceMetricsCard
                        
                        // Training Summary
                        trainingSummaryCard
                        
                        // Data Upload Section
                        dataUploadCard
                        
                        // Recent Notifications
                        recentNotificationsCard
                        
                        // Quick Actions
                        quickActionsSection
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                }
                .refreshable {
                    await trainingViewModel.refreshTrainingData()
                }
            }
            .navigationTitle("Training Status")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingReplayMode = true
                    }) {
                        Image(systemName: "play.circle.fill")
                            .font(.title2)
                            .foregroundColor(DesignSystem.primaryGold)
                    }
                }
            }
            .sheet(isPresented: $showingUploadSheet) {
                DataUploadSheet(viewModel: trainingViewModel)
            }
            .sheet(isPresented: $showingReplayMode) {
                ReplayModeSheet(viewModel: trainingViewModel)
            }
        }
        .onAppear {
            startAnimations()
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: "brain.head.profile")
                    .font(.system(size: 32, weight: .ultraLight))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [DesignSystem.primaryGold, DesignSystem.primaryGold.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .scaleEffect(pulseAnimation ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: pulseAnimation)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Flip Mode Training")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                    
                    Text("AI Learning Dashboard")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Live indicator
                HStack(spacing: 6) {
                    Circle()
                        .fill(trainingViewModel.isTrainingActive ? Color.green : Color.gray)
                        .frame(width: 8, height: 8)
                        .scaleEffect(trainingViewModel.isTrainingActive && pulseAnimation ? 1.2 : 1.0)
                        .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: pulseAnimation)
                    
                    Text(trainingViewModel.isTrainingActive ? "ACTIVE" : "IDLE")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(trainingViewModel.isTrainingActive ? .green : .secondary)
                }
            }
        }
        .padding(.horizontal, 4)
    }
    
    // MARK: - Training Status Card
    private var trainingStatusCard: some View {
        UltraPremiumCard {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: trainingViewModel.statusIcon)
                        .font(.title2)
                        .foregroundColor(trainingViewModel.statusColor)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Training Status")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.primary)
                        
                        Text(trainingViewModel.statusMessage)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    // Status badge
                    Text(trainingViewModel.trainingStatus.rawValue.uppercased())
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(trainingViewModel.statusColor)
                        )
                }
                
                // Current processing info
                if trainingViewModel.isTrainingActive {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Currently Processing:")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.secondary)
                        
                        Text(trainingViewModel.currentProcessingInfo)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.primary)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(DesignSystem.primaryGold.opacity(0.1))
                            )
                    }
                }
            }
        }
    }
    
    // MARK: - Progress Overview Card
    private var progressOverviewCard: some View {
        UltraPremiumCard {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .font(.title2)
                        .foregroundColor(DesignSystem.primaryGold)
                    
                    Text("Training Progress")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Text("\(String(format: "%.1f", trainingViewModel.progressPercentage))%")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(DesignSystem.primaryGold)
                }
                
                // Progress bar
                VStack(alignment: .leading, spacing: 8) {
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 8)
                                .cornerRadius(4)
                            
                            Rectangle()
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            DesignSystem.primaryGold,
                                            DesignSystem.primaryGold.opacity(0.8)
                                        ],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(
                                    width: animateProgress ? geometry.size.width * (trainingViewModel.progressPercentage / 100) : 0,
                                    height: 8
                                )
                                .cornerRadius(4)
                                .animation(.easeInOut(duration: 1.5), value: animateProgress)
                        }
                    }
                    .frame(height: 8)
                    
                    HStack {
                        Text("\(trainingViewModel.processedBars) / \(trainingViewModel.totalBars) bars processed")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        if trainingViewModel.isTrainingActive {
                            Text("ETA: \(trainingViewModel.estimatedTimeRemaining)")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Historical Data Fed Card
    private var historicalDataFedCard: some View {
        UltraPremiumCard {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: "folder.fill.badge.gearshape")
                        .font(.title2)
                        .foregroundColor(DesignSystem.primaryGold)
                    
                    Text("Historical Data Fed")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Button(action: {
                        showingUploadSheet = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                            .foregroundColor(DesignSystem.primaryGold)
                    }
                }
                
                // Data metrics grid
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                    // Trading days processed
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Image(systemName: "calendar")
                                .font(.caption)
                                .foregroundColor(DesignSystem.primaryGold)
                            Text("Trading Days")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.secondary)
                        }
                        Text("\(trainingViewModel.tradingDaysProcessed)")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.primary)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(DesignSystem.primaryGold.opacity(0.05))
                    )
                    
                    // Total ticks learned
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Image(systemName: "waveform")
                                .font(.caption)
                                .foregroundColor(DesignSystem.primaryGold)
                            Text("Ticks Learned")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.secondary)
                        }
                        Text("\(trainingViewModel.totalTicksLearned.formatted())")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.primary)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(DesignSystem.primaryGold.opacity(0.05))
                    )
                }
                
                // Data sources breakdown
                VStack(alignment: .leading, spacing: 12) {
                    Text("Data Sources Processed")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    ForEach(trainingViewModel.dataSources, id: \.name) { source in
                        HStack {
                            Circle()
                                .fill(source.color)
                                .frame(width: 8, height: 8)
                            
                            Text(source.name)
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            VStack(alignment: .trailing, spacing: 2) {
                                Text("\(source.recordCount.formatted()) records")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.secondary)
                                
                                Text(source.dateRange)
                                    .font(.system(size: 11, weight: .regular))
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color.gray.opacity(0.05))
                        )
                    }
                }
            }
        }
    }
    
    // MARK: - Intelligence Metrics Card
    private var intelligenceMetricsCard: some View {
        UltraPremiumCard {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: "brain")
                        .font(.title2)
                        .foregroundColor(DesignSystem.primaryGold)
                    
                    Text("Flip Mode Intelligence")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    // Intelligence score with animation
                    HStack(spacing: 4) {
                        Text("\(String(format: "%.1f", trainingViewModel.intelligenceScore))")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(DesignSystem.primaryGold)
                        
                        Text("/ 100")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                }
                
                // Intelligence progress bar
                VStack(alignment: .leading, spacing: 8) {
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 6)
                                .cornerRadius(3)
                            
                            Rectangle()
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color.blue.opacity(0.8),
                                            DesignSystem.primaryGold,
                                            Color.green.opacity(0.8)
                                        ],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(
                                    width: animateProgress ? geometry.size.width * (trainingViewModel.intelligenceScore / 100) : 0,
                                    height: 6
                                )
                                .cornerRadius(3)
                                .animation(.easeInOut(duration: 2.0), value: animateProgress)
                        }
                    }
                    .frame(height: 6)
                    
                    HStack {
                        Text("Intelligence Level:")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.secondary)
                        
                        Text(trainingViewModel.intelligenceLevel)
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(DesignSystem.primaryGold)
                        
                        Spacer()
                        
                        if trainingViewModel.intelligenceImprovement > 0 {
                            HStack(spacing: 2) {
                                Image(systemName: "arrow.up.right")
                                    .font(.system(size: 10))
                                    .foregroundColor(.green)
                                
                                Text("+\(String(format: "%.1f", trainingViewModel.intelligenceImprovement))%")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.green)
                            }
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Training Summary Card
    private var trainingSummaryCard: some View {
        UltraPremiumCard {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: "chart.bar.fill")
                        .font(.title2)
                        .foregroundColor(DesignSystem.primaryGold)
                    
                    Text("Training Summary")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Text("This Week")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(Color.gray.opacity(0.1))
                        )
                }
                
                // Performance metrics
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 12) {
                    // Win rate
                    VStack(spacing: 4) {
                        Text("Win Rate")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.secondary)
                        
                        Text("\(String(format: "%.1f", trainingViewModel.winRate))%")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.green)
                    }
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.green.opacity(0.05))
                    )
                    
                    // Risk/Reward ratio
                    VStack(spacing: 4) {
                        Text("Avg R:R")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.secondary)
                        
                        Text("\(String(format: "%.1f", trainingViewModel.riskRewardRatio)):1")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(DesignSystem.primaryGold)
                    }
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(DesignSystem.primaryGold.opacity(0.05))
                    )
                    
                    // Adaptive score
                    VStack(spacing: 4) {
                        Text("Adaptive")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.secondary)
                        
                        HStack(spacing: 2) {
                            Image(systemName: "arrow.up")
                                .font(.system(size: 10))
                                .foregroundColor(.blue)
                            
                            Text("\(String(format: "%.1f", trainingViewModel.adaptiveScore))%")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.blue.opacity(0.05))
                    )
                }
                
                // Key patterns detected
                VStack(alignment: .leading, spacing: 8) {
                    Text("Key Patterns Detected")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                        ForEach(trainingViewModel.keyPatterns, id: \.self) { pattern in
                            Text(pattern)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.primary)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(
                                    Capsule()
                                        .fill(DesignSystem.primaryGold.opacity(0.1))
                                )
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Data Upload Card
    private var dataUploadCard: some View {
        UltraPremiumCard {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: "icloud.and.arrow.up")
                        .font(.title2)
                        .foregroundColor(DesignSystem.primaryGold)
                    
                    Text("Upload Historical Data")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    Spacer()
                }
                
                // Upload options
                VStack(spacing: 12) {
                    Button(action: {
                        showingUploadSheet = true
                    }) {
                        HStack {
                            Image(systemName: "doc.badge.plus")
                                .font(.title3)
                                .foregroundColor(.white)
                            
                            Text("Upload CSV / Zip Files")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Image(systemName: "arrow.up.circle.fill")
                                .font(.title3)
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(DesignSystem.primaryGold)
                        )
                    }
                    
                    Button(action: {
                        // Handle FXReplay link paste
                    }) {
                        HStack {
                            Image(systemName: "link")
                                .font(.title3)
                                .foregroundColor(DesignSystem.primaryGold)
                            
                            Text("Paste FXReplay Link")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(DesignSystem.primaryGold)
                            
                            Spacer()
                            
                            Image(systemName: "arrow.right.circle")
                                .font(.title3)
                                .foregroundColor(DesignSystem.primaryGold)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(DesignSystem.primaryGold, lineWidth: 1)
                        )
                    }
                }
                
                // Suggested uploads
                VStack(alignment: .leading, spacing: 8) {
                    Text("Suggested Next Uploads")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    ForEach(trainingViewModel.suggestedUploads, id: \.title) { suggestion in
                        HStack {
                            Image(systemName: "lightbulb")
                                .font(.caption)
                                .foregroundColor(.orange)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(suggestion.title)
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(.primary)
                                
                                Text(suggestion.description)
                                    .font(.system(size: 11, weight: .regular))
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Text(suggestion.priority)
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(
                                    Capsule()
                                        .fill(suggestion.priorityColor)
                                )
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color.gray.opacity(0.05))
                        )
                    }
                }
            }
        }
    }
    
    // MARK: - Recent Notifications Card
    private var recentNotificationsCard: some View {
        UltraPremiumCard {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: "bell.fill")
                        .font(.title2)
                        .foregroundColor(DesignSystem.primaryGold)
                    
                    Text("Recent Notifications")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    if trainingViewModel.notifications.count > 0 {
                        Text("\(trainingViewModel.notifications.count)")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(
                                Circle()
                                    .fill(Color.red)
                            )
                    }
                }
                
                if trainingViewModel.notifications.isEmpty {
                    VStack(spacing: 8) {
                        Image(systemName: "bell.slash")
                            .font(.title)
                            .foregroundColor(.secondary)
                        
                        Text("No recent notifications")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                } else {
                    LazyVStack(spacing: 8) {
                        ForEach(trainingViewModel.notifications.prefix(3), id: \.id) { notification in
                            HStack(alignment: .top) {
                                Image(systemName: notification.icon)
                                    .font(.caption)
                                    .foregroundColor(notification.iconColor)
                                    .frame(width: 20)
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(notification.title)
                                        .font(.system(size: 13, weight: .medium))
                                        .foregroundColor(.primary)
                                    
                                    Text(notification.message)
                                        .font(.system(size: 12, weight: .regular))
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                Text(notification.timeAgo)
                                    .font(.system(size: 11, weight: .regular))
                                    .foregroundColor(.secondary)
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 6)
                            .background(
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(notification.backgroundColor)
                            )
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Quick Actions Section
    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Quick Actions")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.primary)
                .padding(.horizontal, 4)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                // Replay Mode
                Button(action: {
                    showingReplayMode = true
                }) {
                    HStack {
                        Image(systemName: "play.rectangle")
                            .font(.title3)
                            .foregroundColor(DesignSystem.primaryGold)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Replay Mode")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.primary)
                            
                            Text("Watch AI decisions")
                                .font(.system(size: 12, weight: .regular))
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(DesignSystem.primaryGold.opacity(0.1))
                    )
                }
                
                // Export Training Data
                Button(action: {
                    // Handle export
                }) {
                    HStack {
                        Image(systemName: "square.and.arrow.up")
                            .font(.title3)
                            .foregroundColor(DesignSystem.primaryGold)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Export Data")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.primary)
                            
                            Text("Training results")
                                .font(.system(size: 12, weight: .regular))
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(DesignSystem.primaryGold.opacity(0.1))
                    )
                }
                
                // Reset Training
                Button(action: {
                    // Handle reset
                }) {
                    HStack {
                        Image(systemName: "arrow.counterclockwise")
                            .font(.title3)
                            .foregroundColor(.red)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Reset Training")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.primary)
                            
                            Text("Start fresh")
                                .font(.system(size: 12, weight: .regular))
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.red.opacity(0.1))
                    )
                }
                
                // Advanced Settings
                Button(action: {
                    // Handle advanced settings
                }) {
                    HStack {
                        Image(systemName: "gearshape.2")
                            .font(.title3)
                            .foregroundColor(DesignSystem.primaryGold)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Advanced")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.primary)
                            
                            Text("Training config")
                                .font(.system(size: 12, weight: .regular))
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(DesignSystem.primaryGold.opacity(0.1))
                    )
                }
            }
        }
        .padding(.bottom, 20)
    }
    
    // MARK: - Animation Functions
    private func startAnimations() {
        withAnimation(.easeInOut(duration: 0.5).delay(0.3)) {
            animateProgress = true
        }
        
        withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
            pulseAnimation = true
        }
    }
}

// MARK: - Training Status View Model
@MainActor
class TrainingStatusViewModel: ObservableObject {
    @Published var isTrainingActive = true
    @Published var trainingStatus: TrainingStatus = .active
    @Published var progressPercentage: Double = 34.7
    @Published var processedBars = 17384
    @Published var totalBars = 50000
    @Published var estimatedTimeRemaining = "2h 45m"
    @Published var tradingDaysProcessed = 937
    @Published var totalTicksLearned = 15840334
    @Published var intelligenceScore: Double = 86.2
    @Published var intelligenceImprovement: Double = 14.2
    @Published var winRate: Double = 88.9
    @Published var riskRewardRatio: Double = 7.4
    @Published var adaptiveScore: Double = 14.2
    @Published var keyPatterns = ["Power Trend", "London Sweep", "NY Reversal", "FOMC Reaction", "Asian Range Break"]
    @Published var dataSources: [DataSource] = [
        DataSource(name: "M1 Gold Data", recordCount: 8450000, dateRange: "2020-2023", color: .gold),
        DataSource(name: "NFP Weeks", recordCount: 1250000, dateRange: "2018-2023", color: .blue),
        DataSource(name: "FOMC Sessions", recordCount: 890000, dateRange: "2019-2023", color: .purple),
        DataSource(name: "London Session", recordCount: 5250000, dateRange: "2021-2023", color: .green)
    ]
    @Published var notifications: [TrainingNotification] = []
    @Published var suggestedUploads: [SuggestedUpload] = [
        SuggestedUpload(
            title: "2020-2022 NFP Weeks",
            description: "High volatility periods for better pattern recognition",
            priority: "HIGH",
            priorityColor: .red
        ),
        SuggestedUpload(
            title: "Asian Session Data",
            description: "Fill gaps in 24-hour trading patterns",
            priority: "MEDIUM",
            priorityColor: .orange
        ),
        SuggestedUpload(
            title: "Brexit Volatility",
            description: "Unique market conditions for adaptive learning",
            priority: "LOW",
            priorityColor: .gray
        )
    ]
    
    var statusIcon: String {
        switch trainingStatus {
        case .active: return "checkmark.circle.fill"
        case .idle: return "pause.circle.fill"
        case .error: return "exclamationmark.triangle.fill"
        }
    }
    
    var statusColor: Color {
        switch trainingStatus {
        case .active: return .green
        case .idle: return .gray
        case .error: return .red
        }
    }
    
    var statusMessage: String {
        switch trainingStatus {
        case .active: return "Currently processing historical gold data..."
        case .idle: return "Waiting for new data or user input"
        case .error: return "Training encountered an error"
        }
    }
    
    var currentProcessingInfo: String {
        "Processing 2018 Gold Data - London Session Hours"
    }
    
    var intelligenceLevel: String {
        switch intelligenceScore {
        case 0..<30: return "Beginner"
        case 30..<50: return "Learning"
        case 50..<70: return "Intermediate"
        case 70..<85: return "Advanced"
        case 85..<95: return "Expert"
        default: return "Elite"
        }
    }
    
    init() {
        loadSampleNotifications()
    }
    
    func refreshTrainingData() async {
        // Simulate data refresh
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        // Update some values
        progressPercentage = Double.random(in: 30...45)
        intelligenceScore = Double.random(in: 80...90)
        winRate = Double.random(in: 85...92)
        
        loadSampleNotifications()
    }
    
    private func loadSampleNotifications() {
        notifications = [
            TrainingNotification(
                id: UUID(),
                title: "Training Complete",
                message: "Flip Mode completed training on 2018 Gold Data",
                icon: "checkmark.circle.fill",
                iconColor: .green,
                backgroundColor: Color.green.opacity(0.05),
                timeAgo: "2m ago"
            ),
            TrainingNotification(
                id: UUID(),
                title: "Intelligence Improved",
                message: "Intelligence Score improved to 86.2 (+2.1 points)",
                icon: "brain.fill",
                iconColor: .blue,
                backgroundColor: Color.blue.opacity(0.05),
                timeAgo: "5m ago"
            ),
            TrainingNotification(
                id: UUID(),
                title: "New Pattern Detected",
                message: "London Sweep pattern added to knowledge base",
                icon: "eye.fill",
                iconColor: .purple,
                backgroundColor: Color.purple.opacity(0.05),
                timeAgo: "12m ago"
            )
        ]
    }
}

// MARK: - Supporting Models
enum TrainingStatus: String, CaseIterable {
    case active = "Active"
    case idle = "Idle"
    case error = "Error"
}

struct DataSource {
    let name: String
    let recordCount: Int
    let dateRange: String
    let color: Color
}

extension Color {
    static let gold = Color(red: 1.0, green: 0.84, blue: 0.0)
}

struct TrainingNotification {
    let id: UUID
    let title: String
    let message: String
    let icon: String
    let iconColor: Color
    let backgroundColor: Color
    let timeAgo: String
}

struct SuggestedUpload {
    let title: String
    let description: String
    let priority: String
    let priorityColor: Color
}

// MARK: - Data Upload Sheet
struct DataUploadSheet: View {
    @ObservedObject var viewModel: TrainingStatusViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var selectedFiles: [String] = []
    @State private var fxReplayLink = ""
    @State private var isUploading = false
    @State private var uploadProgress: Double = 0.0
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 8) {
                    Image(systemName: "icloud.and.arrow.up")
                        .font(.system(size: 48))
                        .foregroundColor(DesignSystem.primaryGold)
                    
                    Text("Upload Historical Data")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.primary)
                    
                    Text("Feed Flip Mode with historical trading data to improve its intelligence")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                
                if isUploading {
                    // Upload progress
                    VStack(spacing: 16) {
                        ProgressView(value: uploadProgress)
                            .progressViewStyle(LinearProgressViewStyle(tint: DesignSystem.primaryGold))
                        
                        Text("Uploading... \(Int(uploadProgress * 100))%")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.primary)
                    }
                    .padding()
                } else {
                    // Upload options
                    VStack(spacing: 16) {
                        // File upload
                        Button(action: {
                            // Handle file selection
                        }) {
                            VStack(spacing: 12) {
                                Image(systemName: "doc.badge.plus")
                                    .font(.system(size: 32))
                                    .foregroundColor(DesignSystem.primaryGold)
                                
                                Text("Select CSV/ZIP Files")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.primary)
                                
                                Text("Upload M1 tick data, historical sessions, or market replay files")
                                    .font(.system(size: 12, weight: .regular))
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                            }
                            .padding(.vertical, 24)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(DesignSystem.primaryGold, style: StrokeStyle(lineWidth: 2, dash: [5]))
                            )
                        }
                        
                        // FX Replay link
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Or paste FXReplay link:")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.primary)
                            
                            TextField("https://fxreplay.com/...", text: $fxReplayLink)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .font(.system(size: 14))
                        }
                        
                        // Upload button
                        Button(action: {
                            startUpload()
                        }) {
                            Text("Start Upload")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(DesignSystem.primaryGold)
                                )
                        }
                        .disabled(selectedFiles.isEmpty && fxReplayLink.isEmpty)
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Upload Data")
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
    
    private func startUpload() {
        isUploading = true
        
        // Simulate upload progress
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            uploadProgress += 0.02
            
            if uploadProgress >= 1.0 {
                timer.invalidate()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    dismiss()
                }
            }
        }
    }
}

// MARK: - Replay Mode Sheet
struct ReplayModeSheet: View {
    @ObservedObject var viewModel: TrainingStatusViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var selectedDataSource = "M1 Gold Data"
    @State private var isPlaying = false
    @State private var playbackSpeed: Double = 1.0
    @State private var currentPosition: Double = 0.0
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 8) {
                    Image(systemName: "play.rectangle")
                        .font(.system(size: 32))
                        .foregroundColor(DesignSystem.primaryGold)
                    
                    Text("Training Replay Mode")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.primary)
                    
                    Text("Watch how Flip Mode makes decisions on historical data")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                
                // Data source selector
                VStack(alignment: .leading, spacing: 8) {
                    Text("Select Data Source:")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.primary)
                    
                    Picker("Data Source", selection: $selectedDataSource) {
                        ForEach(viewModel.dataSources, id: \.name) { source in
                            Text(source.name).tag(source.name)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                // Playback controls
                VStack(spacing: 16) {
                    // Progress bar
                    VStack(spacing: 8) {
                        HStack {
                            Text("00:00")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            Text("2:34:56")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.secondary)
                        }
                        
                        Slider(value: $currentPosition, in: 0...100)
                            .accentColor(DesignSystem.primaryGold)
                    }
                    
                    // Control buttons
                    HStack(spacing: 24) {
                        Button(action: {
                            // Previous
                        }) {
                            Image(systemName: "backward.fill")
                                .font(.title2)
                                .foregroundColor(DesignSystem.primaryGold)
                        }
                        
                        Button(action: {
                            isPlaying.toggle()
                        }) {
                            Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                                .font(.title)
                                .foregroundColor(.white)
                                .frame(width: 48, height: 48)
                                .background(
                                    Circle()
                                        .fill(DesignSystem.primaryGold)
                                )
                        }
                        
                        Button(action: {
                            // Next
                        }) {
                            Image(systemName: "forward.fill")
                                .font(.title2)
                                .foregroundColor(DesignSystem.primaryGold)
                        }
                    }
                    
                    // Speed control
                    VStack(spacing: 8) {
                        Text("Playback Speed: \(String(format: "%.1f", playbackSpeed))x")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.primary)
                        
                        Slider(value: $playbackSpeed, in: 0.1...5.0, step: 0.1)
                            .accentColor(DesignSystem.primaryGold)
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Replay Mode")
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

// MARK: - Preview
struct DataUploadSheet_Previews: PreviewProvider {
    static var previews: some View {
        DataUploadSheet(viewModel: TrainingStatusViewModel())
    }
}
