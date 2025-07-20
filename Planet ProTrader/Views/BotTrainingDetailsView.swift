//
//  BotTrainingDetailsView.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 1/21/25.
//

import SwiftUI

struct BotTrainingDetailsView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var trainingManager = BotTrainingManager.shared
    @State private var selectedModule: TrainingModule = .personalDevelopment
    @State private var showingTrainingProgress = false
    @State private var animateProgress = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 32) {
                    // Hero section
                    heroSection
                    
                    // Training modules
                    trainingModulesSection
                    
                    // Jim Rohn wisdom integration
                    jimRohnWisdomSection
                    
                    // Bot learning process
                    learningProcessSection
                    
                    // Training progress
                    if showingTrainingProgress {
                        trainingProgressSection
                    }
                    
                    // Start training button
                    startTrainingSection
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
            .background(
                LinearGradient(
                    colors: [Color(.systemBackground), Color.purple.opacity(0.05)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .navigationTitle("🧠 Bot Training System")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(DesignSystem.primaryGold)
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5)) {
                animateProgress = true
            }
        }
    }
    
    // MARK: - Hero Section
    
    private var heroSection: some View {
        VStack(spacing: 20) {
            // Animated brain with Jim Rohn
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.purple, Color.blue],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 120)
                    .scaleEffect(animateProgress ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: animateProgress)
                
                VStack(spacing: 4) {
                    Image(systemName: "brain.head.profile")
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                    
                    Text("ROHN")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
            }
            
            VStack(spacing: 12) {
                Text("🧠 JIM ROHN AI TRAINING SYSTEM")
                    .font(.title)
                    .fontWeight(.black)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                
                Text("Transform your trading bots with the wisdom of America's foremost business philosopher")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            // Training stats
            HStack(spacing: 20) {
                trainingStat(number: "500+", label: "Wisdom\nQuotes", color: .purple)
                trainingStat(number: "12", label: "Core\nPrinciples", color: .blue)
                trainingStat(number: "24/7", label: "Learning\nActive", color: .green)
            }
        }
    }
    
    private func trainingStat(number: String, label: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Text(number)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
    
    // MARK: - Training Modules Section
    
    private var trainingModulesSection: some View {
        VStack(spacing: 20) {
            Text("📚 TRAINING MODULES")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            // Module selector
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(TrainingModule.allCases, id: \.self) { module in
                        moduleButton(module: module)
                    }
                }
                .padding(.horizontal, 4)
            }
            
            // Selected module details
            selectedModuleDetails
        }
    }
    
    private func moduleButton(module: TrainingModule) -> some View {
        Button(action: {
            withAnimation(.spring()) {
                selectedModule = module
            }
        }) {
            VStack(spacing: 6) {
                Image(systemName: module.icon)
                    .font(.title3)
                    .foregroundColor(selectedModule == module ? .white : module.color)
                
                Text(module.name)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(selectedModule == module ? .white : .primary)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
            }
            .frame(width: 80, height: 80)
            .background(
                selectedModule == module 
                ? module.color 
                : module.color.opacity(0.1)
            )
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(selectedModule == module ? module.color : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var selectedModuleDetails: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: selectedModule.icon)
                    .font(.title2)
                    .foregroundColor(selectedModule.color)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(selectedModule.name)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text(selectedModule.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            
            // Module content
            LazyVStack(spacing: 12) {
                ForEach(selectedModule.lessons, id: \.self) { lesson in
                    lessonRow(lesson: lesson)
                }
            }
        }
        .padding(20)
        .background(selectedModule.color.opacity(0.05))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(selectedModule.color.opacity(0.2), lineWidth: 1)
        )
    }
    
    private func lessonRow(lesson: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .font(.caption)
                .foregroundColor(selectedModule.color)
            
            Text(lesson)
                .font(.subheadline)
                .foregroundColor(.primary)
            
            Spacer()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color(.systemBackground))
        .cornerRadius(8)
    }
    
    // MARK: - Jim Rohn Wisdom Section
    
    private var jimRohnWisdomSection: some View {
        VStack(spacing: 20) {
            Text("💎 JIM ROHN WISDOM INTEGRATION")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            // Wisdom categories
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                wisdomCard(
                    title: "Personal Development",
                    quotes: 127,
                    keyTheme: "Self-improvement mindset",
                    botBenefit: "Bots develop growth mentality",
                    color: .purple
                )
                
                wisdomCard(
                    title: "Financial Philosophy",
                    quotes: 94,
                    keyTheme: "Wealth building principles",
                    botBenefit: "Long-term wealth strategies",
                    color: .green
                )
                
                wisdomCard(
                    title: "Success Habits",
                    quotes: 156,
                    keyTheme: "Daily disciplines",
                    botBenefit: "Consistent trading habits",
                    color: .blue
                )
                
                wisdomCard(
                    title: "Leadership",
                    quotes: 83,
                    keyTheme: "Influence & impact",
                    botBenefit: "Market leadership positions",
                    color: .orange
                )
            }
        }
    }
    
    private func wisdomCard(title: String, quotes: Int, keyTheme: String, botBenefit: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Text("\(quotes)")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(color)
                    .cornerRadius(4)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text("🎯 THEME:")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(color)
                
                Text(keyTheme)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                
                Text("🤖 BOT LEARNS:")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(color)
                
                Text(botBenefit)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding(16)
        .background(color.opacity(0.1))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(color.opacity(0.3), lineWidth: 1)
        )
    }
    
    // MARK: - Learning Process Section
    
    private var learningProcessSection: some View {
        VStack(spacing: 20) {
            Text("🔄 BOT LEARNING PROCESS")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            // Process steps
            VStack(spacing: 0) {
                ForEach(Array(LearningStep.allCases.enumerated()), id: \.element) { index, step in
                    learningStepView(step: step, stepNumber: index + 1)
                    
                    if index < LearningStep.allCases.count - 1 {
                        // Connection line
                        Rectangle()
                            .fill(DesignSystem.primaryGold.opacity(0.3))
                            .frame(width: 2, height: 30)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 30)
                    }
                }
            }
        }
    }
    
    private func learningStepView(step: LearningStep, stepNumber: Int) -> some View {
        HStack(alignment: .top, spacing: 16) {
            // Step indicator
            ZStack {
                Circle()
                    .fill(DesignSystem.primaryGold)
                    .frame(width: 40, height: 40)
                
                Text("\(stepNumber)")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(step.title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text(step.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                // Example
                HStack(alignment: .top, spacing: 6) {
                    Text("💡 EXAMPLE:")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(DesignSystem.primaryGold)
                    
                    Text(step.example)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .lineLimit(3)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(DesignSystem.primaryGold.opacity(0.1))
                .cornerRadius(8)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }
    
    // MARK: - Training Progress Section
    
    private var trainingProgressSection: some View {
        VStack(spacing: 20) {
            Text("📊 TRAINING PROGRESS")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            // Overall progress
            VStack(spacing: 12) {
                HStack {
                    Text("Overall Bot Intelligence")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Text("\(Int(trainingManager.overallProgress * 100))%")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(DesignSystem.primaryGold)
                }
                
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(Color(.systemGray5))
                            .frame(height: 12)
                            .cornerRadius(6)
                        
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    colors: [.purple, DesignSystem.primaryGold, .green],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(
                                width: geometry.size.width * CGFloat(animateProgress ? trainingManager.overallProgress : 0),
                                height: 12
                            )
                            .cornerRadius(6)
                            .animation(.easeInOut(duration: 2.0), value: animateProgress)
                    }
                }
                .frame(height: 12)
            }
            
            // Module progress
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                ForEach(TrainingModule.allCases, id: \.self) { module in
                    moduleProgressCard(module: module)
                }
            }
        }
        .padding(20)
        .background(Color(.systemGray6).opacity(0.3))
        .cornerRadius(16)
    }
    
    private func moduleProgressCard(module: TrainingModule) -> some View {
        VStack(spacing: 8) {
            Image(systemName: module.icon)
                .font(.title3)
                .foregroundColor(module.color)
            
            Text(module.shortName)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
                .lineLimit(1)
            
            // Progress circle
            ZStack {
                Circle()
                    .stroke(Color(.systemGray5), lineWidth: 4)
                    .frame(width: 40, height: 40)
                
                Circle()
                    .trim(from: 0, to: animateProgress ? trainingManager.getModuleProgress(module) : 0)
                    .stroke(module.color, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                    .frame(width: 40, height: 40)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 1.5), value: animateProgress)
                
                Text("\(Int(trainingManager.getModuleProgress(module) * 100))%")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
            }
        }
        .padding(12)
        .background(Color(.systemBackground))
        .cornerRadius(10)
    }
    
    // MARK: - Start Training Section
    
    private var startTrainingSection: some View {
        VStack(spacing: 16) {
            if showingTrainingProgress {
                // Training active
                VStack(spacing: 12) {
                    Text("🧠 TRAINING ACTIVE")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                    
                    Text("Your bots are currently absorbing Jim Rohn's wisdom and becoming legendary traders!")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                    
                    Button("Pause Training") {
                        withAnimation(.spring()) {
                            showingTrainingProgress = false
                            trainingManager.pauseTraining()
                        }
                    }
                    .font(.subheadline)
                    .foregroundColor(.orange)
                }
            } else {
                // Start training
                VStack(spacing: 12) {
                    Text("🚀 READY TO CREATE LEGENDS?")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("Start the Jim Rohn AI training process and watch your bots transform into legendary traders")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                    
                    Button(action: {
                        withAnimation(.spring()) {
                            showingTrainingProgress = true
                            trainingManager.startTraining()
                        }
                    }) {
                        HStack {
                            Image(systemName: "brain.head.profile")
                                .font(.title3)
                            
                            Text("START JIM ROHN TRAINING")
                                .font(.headline)
                                .fontWeight(.bold)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                colors: [.purple, .blue],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(12)
                        .shadow(color: .purple.opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                }
            }
        }
    }
}

// MARK: - Supporting Models and Enums

enum TrainingModule: CaseIterable {
    case personalDevelopment, wealthBuilding, successHabits, leadership, philosophy, entrepreneurship
    
    var name: String {
        switch self {
        case .personalDevelopment: return "Personal Development"
        case .wealthBuilding: return "Wealth Building"
        case .successHabits: return "Success Habits"
        case .leadership: return "Leadership"
        case .philosophy: return "Life Philosophy"
        case .entrepreneurship: return "Entrepreneurship"
        }
    }
    
    var shortName: String {
        switch self {
        case .personalDevelopment: return "Personal"
        case .wealthBuilding: return "Wealth"
        case .successHabits: return "Habits"
        case .leadership: return "Leadership"
        case .philosophy: return "Philosophy"
        case .entrepreneurship: return "Business"
        }
    }
    
    var icon: String {
        switch self {
        case .personalDevelopment: return "person.fill.checkmark"
        case .wealthBuilding: return "dollarsign.circle.fill"
        case .successHabits: return "target"
        case .leadership: return "crown.fill"
        case .philosophy: return "brain.head.profile"
        case .entrepreneurship: return "building.2.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .personalDevelopment: return .purple
        case .wealthBuilding: return .green
        case .successHabits: return .blue
        case .leadership: return DesignSystem.primaryGold
        case .philosophy: return .orange
        case .entrepreneurship: return .red
        }
    }
    
    var description: String {
        switch self {
        case .personalDevelopment:
            return "Transform bots with self-improvement mindset and growth principles"
        case .wealthBuilding:
            return "Teach bots long-term wealth creation and compound thinking"
        case .successHabits:
            return "Instill daily disciplines and consistent excellence in trading"
        case .leadership:
            return "Develop market leadership and influence in trading decisions"
        case .philosophy:
            return "Core life philosophy and wisdom-based decision making"
        case .entrepreneurship:
            return "Business mindset and opportunity recognition skills"
        }
    }
    
    var lessons: [String] {
        switch self {
        case .personalDevelopment:
            return [
                "The power of personal responsibility in trading",
                "Continuous learning and skill development",
                "Emotional intelligence and self-control",
                "Goal setting and achievement mindset"
            ]
        case .wealthBuilding:
            return [
                "Compound interest and long-term thinking",
                "Multiple income streams strategy",
                "Value creation over time extraction",
                "Financial discipline and patience"
            ]
        case .successHabits:
            return [
                "Daily disciplines for consistent results",
                "The slight edge principle in trading",
                "Preparation and planning excellence",
                "Persistence through market volatility"
            ]
        case .leadership:
            return [
                "Influence without authority in markets",
                "Leading by example in risk management",
                "Inspiring confidence through consistency",
                "Creating value for others"
            ]
        case .philosophy:
            return [
                "Success is not an accident, it's a choice",
                "You become what you study",
                "Success is something you attract",
                "Work harder on yourself than your job"
            ]
        case .entrepreneurship:
            return [
                "Opportunity recognition in market cycles",
                "Risk assessment and calculated risks",
                "Innovation and creative problem solving",
                "Building systems that work without you"
            ]
        }
    }
}

enum LearningStep: CaseIterable {
    case absorption, processing, integration, application, mastery
    
    var title: String {
        switch self {
        case .absorption: return "Wisdom Absorption"
        case .processing: return "Principle Processing"
        case .integration: return "Knowledge Integration"
        case .application: return "Real-world Application"
        case .mastery: return "Mastery Achievement"
        }
    }
    
    var description: String {
        switch self {
        case .absorption:
            return "Bot analyzes thousands of Jim Rohn quotes, speeches, and principles"
        case .processing:
            return "AI extracts core concepts and creates trading decision frameworks"
        case .integration:
            return "Wisdom principles merge with technical analysis capabilities"
        case .application:
            return "Bot applies learned principles to live market conditions"
        case .mastery:
            return "Bot achieves consistent profitable trading with wisdom-based decisions"
        }
    }
    
    var example: String {
        switch self {
        case .absorption:
            return "Bot reads: 'Profits are better than wages' and understands entrepreneurial mindset"
        case .processing:
            return "Bot creates rule: Prioritize high-reward opportunities over safe, small gains"
        case .integration:
            return "Bot combines wisdom with technical indicators for better entry timing"
        case .application:
            return "Bot takes calculated risks on breakout patterns using Jim Rohn principles"
        case .mastery:
            return "Bot consistently generates $1000+ daily profits with wisdom-guided decisions"
        }
    }
}

// MARK: - Bot Training Manager

class BotTrainingManager: ObservableObject {
    static let shared = BotTrainingManager()
    
    @Published var isTraining = false
    @Published var overallProgress: Double = 0.0
    @Published var moduleProgresses: [TrainingModule: Double] = [:]
    
    private init() {
        // Initialize with some sample progress
        TrainingModule.allCases.forEach { module in
            moduleProgresses[module] = Double.random(in: 0.1...0.8)
        }
        calculateOverallProgress()
    }
    
    func startTraining() {
        isTraining = true
        simulateTrainingProgress()
        ToastManager.shared.showSuccess("🧠 Jim Rohn training started!")
    }
    
    func pauseTraining() {
        isTraining = false
        ToastManager.shared.show("⏸️ Training paused", type: .info)
    }
    
    func getModuleProgress(_ module: TrainingModule) -> Double {
        return moduleProgresses[module] ?? 0.0
    }
    
    private func calculateOverallProgress() {
        let total = moduleProgresses.values.reduce(0, +)
        overallProgress = total / Double(TrainingModule.allCases.count)
    }
    
    private func simulateTrainingProgress() {
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { timer in
            guard self.isTraining else {
                timer.invalidate()
                return
            }
            
            // Randomly update module progress
            let randomModule = TrainingModule.allCases.randomElement()!
            let currentProgress = self.moduleProgresses[randomModule] ?? 0.0
            let newProgress = min(1.0, currentProgress + Double.random(in: 0.01...0.05))
            
            DispatchQueue.main.async {
                self.moduleProgresses[randomModule] = newProgress
                self.calculateOverallProgress()
                
                if newProgress == 1.0 {
                    ToastManager.shared.showSuccess("🎉 \(randomModule.name) training completed!")
                }
            }
        }
    }
}

#Preview {
    BotTrainingDetailsView()
}