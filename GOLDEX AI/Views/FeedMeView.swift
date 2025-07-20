//
//  FeedMeView.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 7/18/25.
//

import SwiftUI
import PhotosUI
import UniformTypeIdentifiers

struct FeedMeView: View {
    @StateObject private var supabaseService = SupabaseService.shared
    @State private var selectedTab = 0
    @State private var isUploading = false
    @State private var uploadProgress: Double = 0.0
    @State private var uploadStatus = "Ready to feed your bots!"
    @State private var showingFilePicker = false
    @State private var showingPhotoPicker = false
    @State private var selectedPhotos: [PhotosPickerItem] = []
    @State private var showingDocumentPicker = false
    @State private var feedingStreak = 11
    @State private var totalContentUploaded = 127
    @State private var botsTrainedToday = 7
    
    // Manual entry states
    @State private var manualTitle = ""
    @State private var manualContent = ""
    @State private var manualCategory = ContentCategory.strategy
    @State private var showingManualEntry = false
    
    // Bot selection
    @State private var selectedBots: Set<UUID> = []
    @State private var sampleBots = BotModel.sampleBots
    
    enum ContentCategory: String, CaseIterable {
        case strategy = "STRATEGY"
        case analysis = "ANALYSIS"
        case news = "NEWS"
        case education = "EDUCATION"
        case pattern = "PATTERN"
        case psychology = "PSYCHOLOGY"
        
        var displayName: String {
            switch self {
            case .strategy: return "Trading Strategy"
            case .analysis: return "Market Analysis"
            case .news: return "Market News"
            case .education: return "Educational Content"
            case .pattern: return "Chart Patterns"
            case .psychology: return "Trading Psychology"
            }
        }
        
        var color: Color {
            switch self {
            case .strategy: return .blue
            case .analysis: return .green
            case .news: return .red
            case .education: return .purple
            case .pattern: return .orange
            case .psychology: return .pink
            }
        }
        
        var systemImage: String {
            switch self {
            case .strategy: return "target"
            case .analysis: return "chart.xyaxis.line"
            case .news: return "newspaper"
            case .education: return "book"
            case .pattern: return "waveform"
            case .psychology: return "brain"
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header with stats
                feedingStatsHeader
                
                // Tab selector
                tabSelector
                
                // Content based on selected tab
                TabView(selection: $selectedTab) {
                    // Upload tab
                    uploadContentTab
                        .tag(0)
                    
                    // Library tab
                    contentLibraryTab
                        .tag(1)
                    
                    // Progress tab
                    trainingProgressTab
                        .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
            .navigationTitle("Feed Me")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Manual Entry") {
                        showingManualEntry = true
                    }
                    .foregroundColor(DesignSystem.primaryGold)
                }
            }
        }
        .sheet(isPresented: $showingManualEntry) {
            manualEntrySheet
        }
        .sheet(isPresented: $showingDocumentPicker) {
            DocumentPicker { urls in
                handleDocumentSelection(urls)
            }
        }
        .onChange(of: selectedPhotos) { _, newPhotos in
            handlePhotoSelection(newPhotos)
        }
        .onAppear {
            loadFeedData()
        }
    }
    
    // MARK: - Header
    
    private var feedingStatsHeader: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("🔥 Feeding Streak")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("\(feedingStreak) Days")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(DesignSystem.primaryGold)
                }
                
                Spacer()
                
                VStack(alignment: .center, spacing: 4) {
                    Text("📚 Total Content")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("\(totalContentUploaded)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("🤖 Bots Trained")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("\(botsTrainedToday)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                }
            }
            
            if isUploading {
                VStack(spacing: 8) {
                    ProgressView(value: uploadProgress, total: 1.0)
                        .progressViewStyle(LinearProgressViewStyle(tint: DesignSystem.primaryGold))
                    
                    Text(uploadStatus)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
    }
    
    // MARK: - Tab Selector
    
    private var tabSelector: some View {
        HStack(spacing: 0) {
            ForEach(["Upload", "Library", "Progress"], id: \.self) { title in
                let index = ["Upload", "Library", "Progress"].firstIndex(of: title) ?? 0
                
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        selectedTab = index
                    }
                }) {
                    VStack(spacing: 8) {
                        Image(systemName: tabIcon(for: index))
                            .font(.title2)
                        
                        Text(title)
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                    .foregroundColor(selectedTab == index ? DesignSystem.primaryGold : .secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                }
            }
        }
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
        .padding(.bottom, 8)
    }
    
    private func tabIcon(for index: Int) -> String {
        switch index {
        case 0: return "plus.circle.fill"
        case 1: return "folder.fill"
        case 2: return "chart.bar.fill"
        default: return "circle"
        }
    }
    
    // MARK: - Upload Tab
    
    private var uploadContentTab: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Upload options
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                    uploadOption(
                        title: "📄 Documents",
                        description: "PDFs, Word docs, eBooks",
                        color: .blue
                    ) {
                        showingDocumentPicker = true
                    }
                    
                    uploadOption(
                        title: "📸 Screenshots",
                        description: "Chart screenshots, trades",
                        color: .green
                    ) {
                        showingPhotoPicker = true
                    }
                    
                    uploadOption(
                        title: "📝 Manual Entry",
                        description: "Type your own content",
                        color: .purple
                    ) {
                        showingManualEntry = true
                    }
                    
                    uploadOption(
                        title: "🎥 Videos",
                        description: "Trading videos, tutorials",
                        color: .orange
                    ) {
                        // Video upload functionality
                    }
                }
                
                // Quick tips
                quickTipsSection
                
                // Bot selection
                botSelectionSection
            }
            .padding()
        }
        .photosPicker(
            isPresented: $showingPhotoPicker,
            selection: $selectedPhotos,
            maxSelectionCount: 5,
            matching: .images
        )
    }
    
    private func uploadOption(
        title: String,
        description: String,
        color: Color,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(color)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(color.opacity(0.1))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(color.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var quickTipsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("🧠 Quick Tips")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(DesignSystem.primaryGold)
            
            VStack(alignment: .leading, spacing: 8) {
                tipRow(
                    icon: "checkmark.circle.fill",
                    text: "Upload content daily to maintain your feeding streak",
                    color: .green
                )
                
                tipRow(
                    icon: "star.fill",
                    text: "High-quality content trains bots faster",
                    color: .gold
                )
                
                tipRow(
                    icon: "brain.head.profile",
                    text: "Claude will auto-analyze and extract key insights",
                    color: .blue
                )
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private func tipRow(icon: String, text: String, color: Color) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.system(size: 16, weight: .medium))
            
            Text(text)
                .font(.caption)
                .foregroundColor(.primary)
            
            Spacer()
        }
    }
    
    // MARK: - Bot Selection Section
    
    private var botSelectionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("🤖 Select Bots to Train")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(DesignSystem.primaryGold)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                ForEach(sampleBots.prefix(4)) { bot in
                    botSelectionCard(bot: bot)
                }
            }
            
            Button("Select All Bots") {
                if selectedBots.count == sampleBots.count {
                    selectedBots.removeAll()
                } else {
                    selectedBots = Set(sampleBots.map(\.id))
                }
            }
            .foregroundColor(DesignSystem.primaryGold)
            .font(.caption)
            .frame(maxWidth: .infinity)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private func botSelectionCard(bot: BotModel) -> some View {
        Button(action: {
            if selectedBots.contains(bot.id) {
                selectedBots.remove(bot.id)
            } else {
                selectedBots.insert(bot.id)
            }
        }) {
            VStack(spacing: 8) {
                HStack {
                    Image(systemName: selectedBots.contains(bot.id) ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(selectedBots.contains(bot.id) ? .green : .secondary)
                    
                    Spacer()
                    
                    Text(bot.formattedUniverseScore)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                
                Text(bot.name)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                
                Text(bot.strategyType.displayName)
                    .font(.caption2)
                    .foregroundColor(bot.strategyType.color)
            }
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(selectedBots.contains(bot.id) ? Color.green.opacity(0.1) : Color(.systemGray6))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(selectedBots.contains(bot.id) ? Color.green : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // MARK: - Content Library Tab
    
    private var contentLibraryTab: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(supabaseService.feedData) { content in
                    contentCard(content: content)
                }
                
                if supabaseService.feedData.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "folder")
                            .font(.system(size: 48))
                            .foregroundColor(.secondary)
                        
                        Text("No content uploaded yet")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        Text("Start feeding your bots by uploading your first content!")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 50)
                }
            }
            .padding()
        }
    }
    
    private func contentCard(content: DatabaseFeedData) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(content.contentTitle ?? "Untitled Content")
                        .font(.headline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    Text(content.contentType)
                        .font(.caption)
                        .foregroundColor(categoryColor(for: content.contentType))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(categoryColor(for: content.contentType).opacity(0.1))
                        .cornerRadius(4)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Impact: \(String(format: "%.1f", content.trainingImpactScore))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    if content.processedByAi {
                        Label("AI Processed", systemImage: "brain.head.profile")
                            .font(.caption2)
                            .foregroundColor(.blue)
                    }
                }
            }
            
            if let description = content.contentDescription {
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
            }
            
            if let aiSummary = content.aiSummary {
                Text("AI Summary: \(aiSummary)")
                    .font(.caption)
                    .foregroundColor(.blue)
                    .padding(.top, 4)
                    .lineLimit(2)
            }
            
            HStack {
                Text("Uploaded: \(content.createdAt.formatted(.relative(presentation: .named)))")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                if let fileName = content.fileName {
                    Text(fileName)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private func categoryColor(for contentType: String) -> Color {
        switch contentType.uppercased() {
        case "PDF": return .red
        case "SCREENSHOT": return .green
        case "TEXT": return .blue
        case "VIDEO": return .orange
        case "AUDIO": return .purple
        default: return .gray
        }
    }
    
    // MARK: - Training Progress Tab
    
    private var trainingProgressTab: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Overall progress
                progressOverviewSection
                
                // Bot progress
                botProgressSection
            }
            .padding()
        }
    }
    
    private var progressOverviewSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("📊 Training Overview")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(DesignSystem.primaryGold)
            
            VStack(spacing: 12) {
                progressRow(
                    title: "Content Processed",
                    value: "\(totalContentUploaded)",
                    progress: 0.75,
                    color: .blue
                )
                
                progressRow(
                    title: "Bots Trained",
                    value: "\(botsTrainedToday)",
                    progress: 0.65,
                    color: .green
                )
                
                progressRow(
                    title: "AI Analysis",
                    value: "89%",
                    progress: 0.89,
                    color: .purple
                )
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private func progressRow(title: String, value: String, progress: Double, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Spacer()
                
                Text(value)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(color)
            }
            
            ProgressView(value: progress, total: 1.0)
                .progressViewStyle(LinearProgressViewStyle(tint: color))
        }
    }
    
    private var botProgressSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("🤖 Bot Training Progress")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(DesignSystem.primaryGold)
            
            ForEach(sampleBots.prefix(3)) { bot in
                botProgressCard(bot: bot)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private func botProgressCard(bot: BotModel) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(bot.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Spacer()
                
                Text("Training Score: \(bot.formattedTrainingScore)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            HStack {
                Text("Learning Progress")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text("\(Int(bot.trainingScore))%")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(bot.strategyType.color)
            }
            
            ProgressView(value: bot.trainingScore, total: 100.0)
                .progressViewStyle(LinearProgressViewStyle(tint: bot.strategyType.color))
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(8)
    }
    
    // MARK: - Manual Entry Sheet
    
    private var manualEntrySheet: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Content Title")
                            .font(.headline)
                            .fontWeight(.medium)
                        
                        TextField("Enter a descriptive title", text: $manualTitle)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Category")
                            .font(.headline)
                            .fontWeight(.medium)
                        
                        Picker("Category", selection: $manualCategory) {
                            ForEach(ContentCategory.allCases, id: \.self) { category in
                                Label(category.displayName, systemImage: category.systemImage)
                                    .tag(category)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Content")
                            .font(.headline)
                            .fontWeight(.medium)
                        
                        TextEditor(text: $manualContent)
                            .frame(minHeight: 200)
                            .padding(4)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    }
                    
                    Button("Save Content") {
                        saveManualContent()
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .disabled(manualTitle.isEmpty || manualContent.isEmpty)
                }
                .padding()
            }
            .navigationTitle("Manual Entry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        showingManualEntry = false
                    }
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func loadFeedData() {
        Task {
            await supabaseService.fetchFeedData()
        }
    }
    
    private func handleDocumentSelection(_ urls: [URL]) {
        Task {
            await uploadDocuments(urls)
        }
    }
    
    private func handlePhotoSelection(_ photos: [PhotosPickerItem]) {
        Task {
            await uploadPhotos(photos)
        }
    }
    
    private func uploadDocuments(_ urls: [URL]) async {
        isUploading = true
        
        for (index, url) in urls.enumerated() {
            uploadProgress = Double(index) / Double(urls.count)
            uploadStatus = "Uploading \(url.lastPathComponent)..."
            
            do {
                let data = try Data(contentsOf: url)
                let fileName = url.lastPathComponent
                
                // Upload to Supabase
                let fileURL = try await supabaseService.uploadFile(
                    data: data,
                    filename: fileName,
                    bucket: "documents"
                )
                
                // Save metadata
                _ = try await supabaseService.saveFeedData(
                    contentType: "PDF",
                    fileName: fileName,
                    fileUrl: fileURL.absoluteString,
                    contentTitle: fileName,
                    contentDescription: "Document uploaded from device"
                )
                
                await MainActor.run {
                    totalContentUploaded += 1
                    if feedingStreak < 365 {
                        feedingStreak += 1
                    }
                }
                
            } catch {
                print("Error uploading document: \(error)")
            }
        }
        
        uploadProgress = 1.0
        uploadStatus = "Upload complete!"
        
        await supabaseService.fetchFeedData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isUploading = false
            uploadStatus = "Ready to feed your bots!"
        }
    }
    
    private func uploadPhotos(_ photos: [PhotosPickerItem]) async {
        isUploading = true
        
        for (index, photo) in photos.enumerated() {
            uploadProgress = Double(index) / Double(photos.count)
            uploadStatus = "Processing screenshot \(index + 1)..."
            
            do {
                if let data = try await photo.loadTransferable(type: Data.self) {
                    let fileName = "screenshot_\(Date().timeIntervalSince1970).jpg"
                    
                    // Upload to Supabase
                    let fileURL = try await supabaseService.uploadScreenshot(
                        data: data,
                        filename: fileName
                    )
                    
                    // Save metadata
                    _ = try await supabaseService.saveFeedData(
                        contentType: "SCREENSHOT",
                        fileName: fileName,
                        fileUrl: fileURL.absoluteString,
                        contentTitle: "Chart Screenshot",
                        contentDescription: "Screenshot uploaded for bot training"
                    )
                    
                    await MainActor.run {
                        totalContentUploaded += 1
                        if feedingStreak < 365 {
                            feedingStreak += 1
                        }
                    }
                }
            } catch {
                print("Error uploading photo: \(error)")
            }
        }
        
        uploadProgress = 1.0
        uploadStatus = "Upload complete!"
        
        await supabaseService.fetchFeedData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isUploading = false
            uploadStatus = "Ready to feed your bots!"
            selectedPhotos.removeAll()
        }
    }
    
    private func saveManualContent() {
        Task {
            do {
                _ = try await supabaseService.saveFeedData(
                    contentType: "TEXT",
                    contentTitle: manualTitle,
                    contentDescription: manualContent.prefix(500).description,
                    extractedText: manualContent
                )
                
                await MainActor.run {
                    totalContentUploaded += 1
                    if feedingStreak < 365 {
                        feedingStreak += 1
                    }
                    
                    manualTitle = ""
                    manualContent = ""
                    showingManualEntry = false
                }
                
                await supabaseService.fetchFeedData()
            } catch {
                print("Error saving manual content: \(error)")
            }
        }
    }
}

// MARK: - Supporting Views

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(DesignSystem.primaryGold)
            .cornerRadius(12)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

struct DocumentPicker: UIViewControllerRepresentable {
    let completion: ([URL]) -> Void
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.pdf, .plainText, .rtf, .epub])
        picker.allowsMultipleSelection = true
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        let parent: DocumentPicker
        
        init(_ parent: DocumentPicker) {
            self.parent = parent
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            parent.completion(urls)
        }
    }
}

// MARK: - Preview

#Preview {
    FeedMeView()
}