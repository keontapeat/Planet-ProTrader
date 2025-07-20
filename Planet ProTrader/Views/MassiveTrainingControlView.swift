//
//  MassiveTrainingControlView.swift
//  GOLDEX AI
//
//  Created by Goldex AI on 7/19/25.
//

import SwiftUI

struct MassiveTrainingControlView: View {
    @StateObject private var dataEngine = MassiveDataAcquisitionEngine.shared
    @StateObject private var armyManager = EnhancedProTraderArmyManager()
    @State private var isTraining = false
    @State private var showingResults = false
    @State private var trainingResults: MassiveTrainingResults?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    headerSection
                    
                    // Data Sources
                    dataSourcesSection
                    
                    // Training Controls
                    trainingControlsSection
                    
                    // Progress Section
                    if dataEngine.isDownloading || isTraining {
                        progressSection
                    }
                    
                    // Results
                    if let results = trainingResults {
                        resultsSection(results)
                    }
                }
                .padding()
            }
            .navigationTitle("🚀 Massive Training")
            .navigationBarTitleDisplayMode(.large)
            .background(DesignSystem.backgroundGradient)
        }
        .sheet(isPresented: $showingResults) {
            if let results = trainingResults {
                TrainingResultsDetailView(results: results)
            }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            Image(systemName: "brain.head.profile")
                .font(.system(size: 64))
                .foregroundColor(.blue)
            
            VStack(spacing: 8) {
                Text("Massive AI Training System")
                    .font(.title.bold())
                
                Text("Train 5,000 bots with 20+ years of gold data")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private var dataSourcesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("📊 Free Data Sources")
                .font(.headline.bold())
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                ForEach(Array(dataEngine.availableDataSources.enumerated()), id: \.offset) { index, source in
                    DataSourceCard(source: source)
                }
            }
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Total Data Points")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("\(dataEngine.totalDataPoints)")
                        .font(.title2.bold())
                        .foregroundColor(.blue)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Estimated Training")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(dataEngine.estimatedTrainingTime)
                        .font(.caption.bold())
                        .foregroundColor(.green)
                }
            }
            .padding()
            .background(.quaternary.opacity(0.3))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private var trainingControlsSection: some View {
        VStack(spacing: 16) {
            Text("🎯 Training Controls")
                .font(.headline.bold())
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Button(action: startMassiveTraining) {
                HStack {
                    if isTraining || dataEngine.isDownloading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(0.8)
                    } else {
                        Image(systemName: "brain.fill")
                            .font(.title2)
                    }
                    
                    Text(isTraining ? "Training in Progress..." : 
                         dataEngine.isDownloading ? "Downloading Data..." : 
                         "🚀 Start Massive Training")
                        .font(.title3.bold())
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .disabled(isTraining || dataEngine.isDownloading)
            }
            .buttonStyle(.plain)
            
            HStack(spacing: 12) {
                Button("📥 Download Data Only") {
                    Task {
                        await dataEngine.downloadAllHistoricalData()
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(dataEngine.isDownloading)
                
                Button("📊 View Dataset") {
                    print(dataEngine.getDatasetSummary())
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private var progressSection: some View {
        VStack(spacing: 16) {
            Text(dataEngine.isDownloading ? "📥 Downloading Data" : "🧠 Training Bots")
                .font(.headline.bold())
            
            if dataEngine.isDownloading {
                VStack(spacing: 12) {
                    Text("Current Source: \(dataEngine.currentDataSource)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    ProgressView(value: dataEngine.downloadProgress)
                        .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                    
                    HStack {
                        Text("\(dataEngine.downloadedDataPoints)/\(dataEngine.totalDataPoints)")
                            .font(.caption.bold())
                        
                        Spacer()
                        
                        Text(dataEngine.downloadSpeed)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            } else if isTraining {
                VStack(spacing: 12) {
                    Text("Training 5,000 AI Bots...")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                        .scaleEffect(1.5)
                    
                    Text("This may take several minutes")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private func resultsSection(_ results: MassiveTrainingResults) -> some View {
        VStack(spacing: 16) {
            Text("🎉 Training Complete!")
                .font(.headline.bold())
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                TrainingResultCard(title: "Bots Trained", value: "\(results.trainedBots)", color: .blue)
                TrainingResultCard(title: "Data Points", value: "\(results.totalDataPoints)", color: .green)
                TrainingResultCard(title: "GODMODE Bots", value: "\(results.newGodmodeBots)", color: DesignSystem.primaryGold)
                TrainingResultCard(title: "Training Time", value: "\(String(format: "%.1f", results.totalTrainingTime))s", color: .purple)
            }
            
            Button("📊 View Detailed Results") {
                showingResults = true
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private func startMassiveTraining() {
        isTraining = true
        
        Task {
            let results = await dataEngine.startMassiveTraining(armyManager)
            
            await MainActor.run {
                self.trainingResults = results
                self.isTraining = false
            }
        }
    }
}

struct DataSourceCard: View {
    let source: HistoricalDataSource
    
    var body: some View {
        VStack(spacing: 8) {
            Text(source.name)
                .font(.caption.bold())
                .multilineTextAlignment(.center)
                .lineLimit(2)
            
            Text("\(source.dataPoints)")
                .font(.title3.bold())
                .foregroundColor(.blue)
            
            Text("data points")
                .font(.caption2)
                .foregroundColor(.secondary)
            
            Text("\(source.yearsAvailable) years")
                .font(.caption2.bold())
                .foregroundColor(.green)
        }
        .padding()
        .background(.quaternary.opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct TrainingResultCard: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.title2.bold())
                .foregroundColor(color)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .background(.quaternary.opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct TrainingResultsDetailView: View {
    let results: MassiveTrainingResults
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Text(results.summary)
                        .font(.system(.body, design: .monospaced))
                        .padding()
                        .background(.quaternary.opacity(0.3))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding()
            }
            .navigationTitle("Training Results")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    MassiveTrainingControlView()
}