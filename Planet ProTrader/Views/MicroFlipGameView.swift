//
//  MicroFlipGameView.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 1/25/25.
//

import SwiftUI

struct MicroFlipGameView: View {
    @State private var selectedGameType: MicroFlipGame.GameType = .quickFlip
    @State private var selectedDifficulty: MicroFlipGame.Difficulty = .rookie
    @State private var entryAmount: Double = 25.0
    @State private var activeGame: MicroFlipGame?
    @State private var gameHistory = MicroFlipGame.sampleGames
    @State private var showGameSetup = false
    @State private var showGameController = false
    @State private var animateElements = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 20) {
                    // Header Stats
                    headerStatsView
                    
                    // Active Game Card
                    if let game = activeGame {
                        ActiveGameCard(game: game) {
                            showGameController = true
                        }
                    } else {
                        // Game Type Selection
                        gameTypeSelection
                    }
                    
                    // Quick Start Options
                    quickStartOptions
                    
                    // Recent Games
                    recentGamesSection
                    
                    // Performance Stats
                    performanceStatsView
                }
                .padding(.horizontal)
            }
            .navigationTitle("⚡ MicroFlip Arena")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showGameSetup = true }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.blue)
                    }
                }
            }
        }
        .onAppear {
            startAnimations()
            loadActiveGame()
        }
        .sheet(isPresented: $showGameSetup) {
            GameSetupSheet(
                selectedGameType: $selectedGameType,
                selectedDifficulty: $selectedDifficulty,
                entryAmount: $entryAmount
            ) { gameType, difficulty, amount in
                startNewGame(type: gameType, difficulty: difficulty, amount: amount)
            }
        }
        .fullScreenCover(isPresented: $showGameController) {
            if let game = activeGame {
                GameControllerView(game: game) { updatedGame in
                    activeGame = updatedGame
                    if updatedGame?.status == .completed || updatedGame?.status == .failed {
                        activeGame = nil
                    }
                }
            }
        }
    }
    
    private var headerStatsView: some View {
        HStack(spacing: 16) {
            StatCard(
                title: "Active Games",
                value: activeGame != nil ? "1" : "0",
                icon: "gamecontroller.fill",
                color: .blue,
                trend: "🎮"
            )
            
            StatCard(
                title: "Win Rate",
                value: "73.2%",
                icon: "target",
                color: .green,
                trend: "+2.4%"
            )
            
            StatCard(
                title: "Best Streak",
                value: "12",
                icon: "flame.fill",
                color: .orange,
                trend: "🔥"
            )
        }
        .opacity(animateElements ? 1 : 0)
        .offset(y: animateElements ? 0 : -20)
        .animation(.spring(dampingFraction: 0.8).delay(0.1), value: animateElements)
    }
    
    private var gameTypeSelection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("🎮 Choose Your Game")
                .font(.title2.bold())
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                ForEach(MicroFlipGame.GameType.allCases, id: \.self) { gameType in
                    GameTypeCard(
                        gameType: gameType,
                        isSelected: selectedGameType == gameType
                    ) {
                        withAnimation(.spring()) {
                            selectedGameType = gameType
                        }
                    }
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(15)
        .opacity(animateElements ? 1 : 0)
        .offset(x: animateElements ? 0 : 30)
        .animation(.spring(dampingFraction: 0.8).delay(0.2), value: animateElements)
    }
    
    private var quickStartOptions: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("⚡ Quick Start")
                .font(.title2.bold())
            
            HStack(spacing: 12) {
                QuickStartButton(
                    title: "Baby Steps",
                    amount: "$20",
                    difficulty: .rookie,
                    color: .green
                ) {
                    startNewGame(type: selectedGameType, difficulty: .rookie, amount: 20.0)
                }
                
                QuickStartButton(
                    title: "Standard",
                    amount: "$50",
                    difficulty: .pro,
                    color: .blue
                ) {
                    startNewGame(type: selectedGameType, difficulty: .pro, amount: 50.0)
                }
                
                QuickStartButton(
                    title: "High Roller",
                    amount: "$100",
                    difficulty: .expert,
                    color: .purple
                ) {
                    startNewGame(type: selectedGameType, difficulty: .expert, amount: 100.0)
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(15)
        .opacity(animateElements ? 1 : 0)
        .offset(x: animateElements ? 0 : -30)
        .animation(.spring(dampingFraction: 0.8).delay(0.3), value: animateElements)
    }
    
    private var recentGamesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("📊 Recent Games")
                    .font(.title2.bold())
                
                Spacer()
                
                Button("View All") {
                    // Show full history
                }
                .font(.subheadline)
                .foregroundColor(.blue)
            }
            
            VStack(spacing: 8) {
                ForEach(gameHistory.prefix(3)) { game in
                    RecentGameRow(game: game)
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(15)
        .opacity(animateElements ? 1 : 0)
        .offset(y: animateElements ? 0 : 20)
        .animation(.spring(dampingFraction: 0.8).delay(0.4), value: animateElements)
    }
    
    private var performanceStatsView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("📈 Performance Stats")
                .font(.title2.bold())
            
            HStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    StatRow(title: "Total Games", value: "47")
                    StatRow(title: "Total Profit", value: "+$1,247.50")
                    StatRow(title: "Avg Game Time", value: "4m 32s")
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    StatRow(title: "Wins", value: "34")
                    StatRow(title: "Losses", value: "13")
                    StatRow(title: "Best Game", value: "+$285.00")
                }
            }
            
            // Performance Chart Placeholder
            RoundedRectangle(cornerRadius: 10)
                .fill(.ultraThinMaterial)
                .frame(height: 120)
                .overlay(
                    VStack {
                        Image(systemName: "chart.line.uptrend.xyaxis")
                            .font(.title)
                            .foregroundColor(.blue)
                        
                        Text("Performance Chart")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                )
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(15)
        .opacity(animateElements ? 1 : 0)
        .offset(y: animateElements ? 0 : 30)
        .animation(.spring(dampingFraction: 0.8).delay(0.5), value: animateElements)
    }
    
    private func startAnimations() {
        withAnimation(.easeInOut(duration: 0.8)) {
            animateElements = true
        }
    }
    
    private func loadActiveGame() {
        // Check for any active games
        if let game = gameHistory.first(where: { $0.status == .active }) {
            activeGame = game
        }
    }
    
    private func startNewGame(type: MicroFlipGame.GameType, difficulty: MicroFlipGame.Difficulty, amount: Double) {
        let targetAmount = amount * type.baseMultiplier
        let duration: TimeInterval = {
            switch type {
            case .quickFlip: return 300 // 5 minutes
            case .speedRun: return 180 // 3 minutes
            case .precision: return 600 // 10 minutes
            case .endurance: return 1800 // 30 minutes
            case .riskMaster: return 240 // 4 minutes
            case .botBattle: return 450 // 7.5 minutes
            }
        }()
        
        let newGame = MicroFlipGame(
            playerId: "current_player",
            gameType: type,
            entryAmount: amount,
            targetAmount: targetAmount,
            duration: duration,
            status: .active,
            difficulty: difficulty
        )
        
        activeGame = newGame
        showGameController = true
    }
}

// MARK: - Supporting Views

struct ActiveGameCard: View {
    let game: MicroFlipGame
    let onTap: () -> Void
    @State private var pulseAnimation = false
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 16) {
                // Header
                HStack {
                    HStack(spacing: 8) {
                        Text(game.gameType.emoji)
                            .font(.title)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("ACTIVE GAME")
                                .font(.caption.bold())
                                .foregroundColor(.green)
                            
                            Text(game.gameType.displayName)
                                .font(.headline.bold())
                        }
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 2) {
                        Text(game.difficulty.displayName)
                            .font(.caption.bold())
                            .foregroundColor(game.difficulty.color)
                        
                        HStack(spacing: 4) {
                            Circle()
                                .fill(.green)
                                .frame(width: 6, height: 6)
                                .scaleEffect(pulseAnimation ? 1.3 : 1.0)
                                .animation(.easeInOut(duration: 1).repeatForever(), value: pulseAnimation)
                            
                            Text("LIVE")
                                .font(.caption.bold())
                                .foregroundColor(.green)
                        }
                    }
                }
                
                // Progress
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Progress to Target")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Text("\(Int(game.progressToTarget * 100))%")
                            .font(.subheadline.bold())
                            .foregroundColor(.blue)
                    }
                    
                    ProgressView(value: game.progressToTarget)
                        .tint(.blue)
                        .scaleEffect(y: 2.0)
                }
                
                // Stats
                HStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Current")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text("$\(String(format: "%.2f", game.currentBalance))")
                            .font(.headline.bold())
                            .foregroundColor(.green)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Target")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text("$\(String(format: "%.2f", game.targetAmount))")
                            .font(.headline.bold())
                            .foregroundColor(.blue)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Time Left")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text(formatTimeRemaining(game.timeRemaining))
                            .font(.headline.bold())
                            .foregroundColor(.orange)
                    }
                }
                
                // Action Button
                HStack {
                    Spacer()
                    
                    HStack(spacing: 6) {
                        Image(systemName: "gamecontroller.fill")
                        Text("ENTER GAME")
                            .font(.subheadline.bold())
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    
                    Spacer()
                }
            }
            .padding()
            .background(
                LinearGradient(
                    colors: [.blue.opacity(0.1), .green.opacity(0.1)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(.blue.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .onAppear {
            pulseAnimation = true
        }
    }
    
    private func formatTimeRemaining(_ time: TimeInterval) -> String {
        let minutes = Int(time / 60)
        let seconds = Int(time.truncatingRemainder(dividingBy: 60))
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

struct GameTypeCard: View {
    let gameType: MicroFlipGame.GameType
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(gameType.emoji)
                        .font(.title)
                    
                    Spacer()
                    
                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.blue)
                    }
                }
                
                Text(gameType.displayName.replacingOccurrences(of: gameType.emoji + " ", with: ""))
                    .font(.subheadline.bold())
                    .multilineTextAlignment(.leading)
                
                Text(gameType.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                HStack {
                    Text("Multiplier:")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("\(String(format: "%.1f", gameType.baseMultiplier))x")
                        .font(.caption.bold())
                        .foregroundColor(.green)
                }
            }
            .padding()
            .frame(height: 120)
            .background(isSelected ? .blue.opacity(0.1) : .ultraThinMaterial)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isSelected ? .blue : .clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct QuickStartButton: View {
    let title: String
    let amount: String
    let difficulty: MicroFlipGame.Difficulty
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Text(amount)
                    .font(.headline.bold())
                    .foregroundColor(color)
                
                Text(title)
                    .font(.caption.bold())
                
                Text(difficulty.displayName)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(color.opacity(0.1))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(color.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct RecentGameRow: View {
    let game: MicroFlipGame
    
    var body: some View {
        HStack(spacing: 12) {
            // Game Type Icon
            Text(game.gameType.emoji)
                .font(.title3)
            
            // Game Info
            VStack(alignment: .leading, spacing: 2) {
                Text(game.gameType.displayName.replacingOccurrences(of: game.gameType.emoji + " ", with: ""))
                    .font(.subheadline.bold())
                
                Text("\(game.difficulty.displayName) • $\(String(format: "%.0f", game.entryAmount)) entry")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Result
            VStack(alignment: .trailing, spacing: 2) {
                if let result = game.result {
                    Text(result.displayText)
                        .font(.subheadline.bold())
                        .foregroundColor(result.color)
                    
                    Text(game.status.displayName)
                        .font(.caption)
                        .foregroundColor(.secondary)
                } else {
                    Text(game.status.displayName)
                        .font(.subheadline.bold())
                        .foregroundColor(game.status.color)
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial.opacity(0.5))
        .cornerRadius(8)
    }
}

struct StatRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.caption.bold())
        }
    }
}

struct GameSetupSheet: View {
    @Binding var selectedGameType: MicroFlipGame.GameType
    @Binding var selectedDifficulty: MicroFlipGame.Difficulty
    @Binding var entryAmount: Double
    let onStart: (MicroFlipGame.GameType, MicroFlipGame.Difficulty, Double) -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // Game Type Selection
                VStack(alignment: .leading, spacing: 12) {
                    Text("Game Type")
                        .font(.headline.bold())
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                        ForEach(MicroFlipGame.GameType.allCases, id: \.self) { gameType in
                            GameTypeCard(
                                gameType: gameType,
                                isSelected: selectedGameType == gameType
                            ) {
                                selectedGameType = gameType
                            }
                        }
                    }
                }
                
                // Difficulty Selection
                VStack(alignment: .leading, spacing: 12) {
                    Text("Difficulty")
                        .font(.headline.bold())
                    
                    HStack(spacing: 8) {
                        ForEach(MicroFlipGame.Difficulty.allCases, id: \.self) { difficulty in
                            Button(action: { selectedDifficulty = difficulty }) {
                                Text(difficulty.displayName)
                                    .font(.caption.bold())
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(selectedDifficulty == difficulty ? difficulty.color : .ultraThinMaterial)
                                    .foregroundColor(selectedDifficulty == difficulty ? .white : .primary)
                                    .cornerRadius(15)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
                
                // Entry Amount
                VStack(alignment: .leading, spacing: 12) {
                    Text("Entry Amount")
                        .font(.headline.bold())
                    
                    HStack(spacing: 12) {
                        ForEach([20, 50, 100, 200], id: \.self) { amount in
                            Button(action: { entryAmount = Double(amount) }) {
                                Text("$\(amount)")
                                    .font(.subheadline.bold())
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(entryAmount == Double(amount) ? .blue : .ultraThinMaterial)
                                    .foregroundColor(entryAmount == Double(amount) ? .white : .primary)
                                    .cornerRadius(10)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    
                    Stepper(
                        value: $entryAmount,
                        in: 10...1000,
                        step: 5
                    ) {
                        Text("Custom: $\(String(format: "%.0f", entryAmount))")
                            .font(.subheadline)
                    }
                }
                
                Spacer()
                
                // Start Button
                Button(action: {
                    onStart(selectedGameType, selectedDifficulty, entryAmount)
                    dismiss()
                }) {
                    HStack(spacing: 8) {
                        Text(selectedGameType.emoji)
                        Text("START GAME")
                            .font(.headline.bold())
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(15)
                }
            }
            .padding()
            .navigationTitle("Setup Game")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    MicroFlipGameView()
}