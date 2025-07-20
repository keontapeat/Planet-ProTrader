//
//  CSVImporterView.swift
//  GOLDEX AI
//
//  Created by Goldex AI on 7/19/25.
//

import SwiftUI
import UniformTypeIdentifiers

struct EnhancedCSVImporterView: View {
    let armyManager: EnhancedProTraderArmyManager
    @StateObject private var csvImporter = CSVImporter()
    @Environment(\.dismiss) private var dismiss
    
    @State private var dragOver = false
    @State private var showingFilePicker = false
    @State private var csvContent = ""
    @State private var showingTrainingResults = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 32) {
                    // Header
                    VStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [.blue, .purple],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 80, height: 80)
                            
                            Image(systemName: "doc.text.fill")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundStyle(.white)
                        }
                        
                        VStack(spacing: 8) {
                            Text("🚀 GOLDEX AI DATA IMPORTER")
                                .font(.system(size: 24, weight: .black, design: .rounded))
                                .foregroundStyle(.white)
                            
                            Text("Import your year's worth of historical data to train 5,000 AI bots")
                                .font(.system(size: 14, weight: .medium, design: .rounded))
                                .foregroundStyle(.white.opacity(0.8))
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding(.top, 20)
                    
                    // File Drop Zone
                    VStack(spacing: 24) {
                        Button(action: { showingFilePicker = true }) {
                            VStack(spacing: 20) {
                                Image(systemName: "icloud.and.arrow.up")
                                    .font(.system(size: 48, weight: .bold))
                                    .foregroundStyle(.blue)
                                
                                VStack(spacing: 8) {
                                    Text("Drop CSV File or Click to Browse")
                                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                                        .foregroundStyle(.white)
                                    
                                    Text("Supports: CSV, TXT • Max: 100MB")
                                        .font(.system(size: 12, weight: .medium, design: .rounded))
                                        .foregroundStyle(.white.opacity(0.6))
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(40)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(.white.opacity(dragOver ? 0.1 : 0.05))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(.blue.opacity(0.5), lineWidth: 2)
                                            .animation(.easeInOut(duration: 0.2), value: dragOver)
                                    )
                            )
                        }
                        .buttonStyle(.plain)
                        .onDrop(of: [.fileURL], isTargeted: $dragOver) { providers in
                            handleDrop(providers: providers)
                            return true
                        }
                        
                        // Sample Format
                        VStack(alignment: .leading, spacing: 12) {
                            Text("📋 Expected CSV Format:")
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                .foregroundStyle(.white)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Date,Time,Open,High,Low,Close,Volume")
                                Text("2024.07.19,00:00:00,2000.12,2001.45,1999.78,2000.98,1500")
                                Text("2024.07.19,01:00:00,2000.98,2002.23,2000.56,2001.67,1200")
                            }
                            .font(.system(size: 12, weight: .regular, design: .monospaced))
                            .foregroundStyle(.green.opacity(0.8))
                            .padding(12)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(.white.opacity(0.05))
                            )
                        }
                        
                        // Processing Status
                        if csvImporter.isProcessing {
                            VStack(spacing: 16) {
                                Text("🧠 Processing Your Data...")
                                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                                    .foregroundStyle(.white)
                                
                                Text(csvImporter.processingStage)
                                    .font(.system(size: 14, weight: .medium, design: .rounded))
                                    .foregroundStyle(.white.opacity(0.8))
                                
                                ProgressView(value: csvImporter.progress)
                                    .frame(width: 280)
                                    .tint(.blue)
                                    .background(.white.opacity(0.2))
                                    .clipShape(Capsule())
                                
                                HStack(spacing: 20) {
                                    VStack(spacing: 4) {
                                        Text("\(Int(csvImporter.progress * 100))%")
                                            .font(.system(size: 16, weight: .bold, design: .rounded))
                                            .foregroundStyle(.blue)
                                        Text("Progress")
                                            .font(.system(size: 10, weight: .medium, design: .rounded))
                                            .foregroundStyle(.white.opacity(0.7))
                                    }
                                    
                                    VStack(spacing: 4) {
                                        Text(String(format: "%.0f", csvImporter.processingSpeed))
                                            .font(.system(size: 16, weight: .bold, design: .rounded))
                                            .foregroundStyle(.green)
                                        Text("Records/sec")
                                            .font(.system(size: 10, weight: .medium, design: .rounded))
                                            .foregroundStyle(.white.opacity(0.7))
                                    }
                                    
                                    VStack(spacing: 4) {
                                        Text(String(format: "%.1f", csvImporter.dataQualityScore))
                                            .font(.system(size: 16, weight: .bold, design: .rounded))
                                            .foregroundStyle(.orange)
                                        Text("Quality Score")
                                            .font(.system(size: 10, weight: .medium, design: .rounded))
                                            .foregroundStyle(.white.opacity(0.7))
                                    }
                                }
                            }
                            .padding(24)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(.white.opacity(0.05))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(.blue.opacity(0.3), lineWidth: 1)
                                    )
                            )
                        }
                        
                        // Start Training Button
                        if !csvImporter.lastImportedData.isEmpty && !csvImporter.isProcessing {
                            Button(action: startTraining) {
                                HStack(spacing: 12) {
                                    Image(systemName: "brain.head.profile")
                                        .font(.system(size: 18, weight: .bold))
                                    
                                    Text("🚀 START TRAINING 5,000 BOTS")
                                        .font(.system(size: 16, weight: .black, design: .rounded))
                                    
                                    Image(systemName: "arrow.right")
                                        .font(.system(size: 14, weight: .bold))
                                }
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding(16)
                                .background(
                                    LinearGradient(
                                        colors: [.blue, .purple],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .clipShape(Capsule())
                                .shadow(color: .blue.opacity(0.3), radius: 10, y: 5)
                            }
                            .buttonStyle(.plain)
                            
                            // Data Stats
                            HStack(spacing: 20) {
                                VStack(spacing: 4) {
                                    Text("\(csvImporter.validDataPoints)")
                                        .font(.system(size: 18, weight: .bold, design: .rounded))
                                        .foregroundStyle(.green)
                                    Text("Valid Records")
                                        .font(.system(size: 12, weight: .medium, design: .rounded))
                                        .foregroundStyle(.white.opacity(0.7))
                                }
                                
                                VStack(spacing: 4) {
                                    Text(String(format: "%.1f%%", csvImporter.dataQualityScore))
                                        .font(.system(size: 18, weight: .bold, design: .rounded))
                                        .foregroundStyle(.orange)
                                    Text("Quality Score")
                                        .font(.system(size: 12, weight: .medium, design: .rounded))
                                        .foregroundStyle(.white.opacity(0.7))
                                }
                            }
                        }
                        
                        // Error Display
                        if let error = csvImporter.errorMessage {
                            VStack(spacing: 8) {
                                HStack(spacing: 8) {
                                    Image(systemName: "exclamationmark.triangle.fill")
                                        .foregroundStyle(.red)
                                    Text("Import Error")
                                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                                        .foregroundStyle(.red)
                                }
                                
                                Text(error)
                                    .font(.system(size: 12, weight: .medium, design: .rounded))
                                    .foregroundStyle(.white.opacity(0.8))
                                    .multilineTextAlignment(.center)
                            }
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(.red.opacity(0.1))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(.red.opacity(0.3), lineWidth: 1)
                                    )
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
            .background(
                LinearGradient(
                    colors: [
                        Color(red: 0.02, green: 0.05, blue: 0.15),
                        Color(red: 0.05, green: 0.08, blue: 0.20),
                        Color(red: 0.08, green: 0.12, blue: 0.25)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
            )
            .navigationTitle("Data Import")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundStyle(.white)
                }
            }
        }
        .fileImporter(
            isPresented: $showingFilePicker,
            allowedContentTypes: [.commaSeparatedText, .plainText, .text],
            allowsMultipleSelection: false
        ) { result in
            handleFileImport(result: result)
        }
        .sheet(isPresented: $showingTrainingResults) {
            if let results = armyManager.lastTrainingResults {
                TrainingResultsSheet(results: results)
            }
        }
    }
    
    private func handleDrop(providers: [NSItemProvider]) {
        providers.first?.loadFileRepresentation(forTypeIdentifier: UTType.fileURL.identifier) { url, error in
            guard let url = url else { return }
            
            DispatchQueue.main.async {
                loadCSVFile(url: url)
            }
        }
    }
    
    private func handleFileImport(result: Result<[URL], Error>) {
        switch result {
        case .success(let urls):
            guard let url = urls.first else { return }
            loadCSVFile(url: url)
        case .failure(let error):
            csvImporter.errorMessage = "File import failed: \(error.localizedDescription)"
        }
    }
    
    private func loadCSVFile(url: URL) {
        do {
            let content = try String(contentsOf: url)
            csvContent = content
            
            Task {
                _ = await csvImporter.importCSV(from: content)
            }
        } catch {
            csvImporter.errorMessage = "Failed to read file: \(error.localizedDescription)"
        }
    }
    
    private func startTraining() {
        Task {
            let results = await armyManager.trainWithHistoricalData(csvData: csvContent)
            
            DispatchQueue.main.async {
                showingTrainingResults = true
            }
        }
    }
}

struct TrainingResultsSheet: View {
    let results: EnhancedTrainingResults
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Success Header
                    VStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [.green, .blue],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 80, height: 80)
                            
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 40, weight: .bold))
                                .foregroundStyle(.white)
                        }
                        
                        Text("🎉 TRAINING COMPLETE!")
                            .font(.system(size: 24, weight: .black, design: .rounded))
                            .foregroundStyle(.white)
                        
                        Text("Your army of 5,000 AI bots has been successfully trained!")
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundStyle(.white.opacity(0.8))
                            .multilineTextAlignment(.center)
                    }
                    
                    // Results Grid
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                        ResultCard(title: "Bots Trained", value: "\(results.botsTrained)", icon: "robot", color: .blue)
                        ResultCard(title: "Data Points", value: "\(results.dataPointsProcessed)", icon: "chart.bar", color: .green)
                        ResultCard(title: "GODMODE Bots", value: "\(results.newGodmodeBots)", icon: "crown.fill", color: .orange)
                        ResultCard(title: "Elite Bots", value: "\(results.newEliteBots)", icon: "diamond.fill", color: .purple)
                        ResultCard(title: "A+ Screenshots", value: "\(results.screenshotsCaptured)", icon: "camera.fill", color: .red)
                        ResultCard(title: "VPS Deployed", value: "\(results.vpsDeployments)", icon: "server.rack", color: .cyan)
                    }
                    
                    // Summary Text
                    VStack(alignment: .leading, spacing: 12) {
                        Text("📊 Training Summary:")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .foregroundStyle(.white)
                        
                        Text(results.summary)
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                            .foregroundStyle(.white.opacity(0.8))
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(.white.opacity(0.05))
                            )
                    }
                    
                    Button("🚀 START AUTO-TRADING") {
                        Task {
                            // Start auto-trading would be implemented here
                            dismiss()
                        }
                    }
                    .font(.system(size: 16, weight: .black, design: .rounded))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(16)
                    .background(
                        LinearGradient(
                            colors: [.green, .blue],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(Capsule())
                }
                .padding(20)
            }
            .background(
                LinearGradient(
                    colors: [
                        Color(red: 0.02, green: 0.05, blue: 0.15),
                        Color(red: 0.05, green: 0.08, blue: 0.20),
                        Color(red: 0.08, green: 0.12, blue: 0.25)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
            )
            .navigationTitle("Training Results")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundStyle(.white)
                }
            }
        }
    }
}

struct ResultCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(color)
            
            Text(value)
                .font(.system(size: 18, weight: .black, design: .rounded))
                .foregroundStyle(.white)
            
            Text(title)
                .font(.system(size: 10, weight: .medium, design: .rounded))
                .foregroundStyle(.white.opacity(0.7))
                .multilineTextAlignment(.center)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.white.opacity(0.08))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.white.opacity(0.1), lineWidth: 1)
                )
        )
    }
}

#Preview {
    EnhancedCSVImporterView(armyManager: EnhancedProTraderArmyManager())
        .preferredColorScheme(.dark)
}