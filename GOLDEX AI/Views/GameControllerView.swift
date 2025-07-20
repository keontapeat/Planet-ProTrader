//
//  GameControllerView.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 1/25/25.
//

import SwiftUI

struct GameControllerView: View {
    @State var game: MicroFlipGame
    let onGameUpdate: (MicroFlipGame?) -> Void
    @Environment(\.dismiss) private var dismiss
    
    @State private var currentPrice: Double = 2045.30
    @State private var priceHistory: [Double] = []
    @State private var selectedAction: TradeAction?
    @State private var tradeAmount: Double = 50.0
    @State private var showTradeConfirm = false
    @State private var gameTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var priceTimer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    @State private var controllerHaptics = false
    @State private var showVoiceNotes = false
    @State private var latestVoiceNote: BotVoiceNote?
    @State private var animateController = false
    @State private var glowEffect = false
    
    enum TradeAction {
        case buy, sell
        
        var color: Color {
            switch self {
            case .buy: return .green
            case .sell: return .red
            }
        }
        
        var title: String {
            switch self {
            case .buy: return "BUY"
            case .sell: return "SELL"
            }
        }
        
        var systemImage: String {
            switch self {
            case .buy: return "arrow.up"
            case .sell: return "arrow.down"
            }
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                backgroundView
                
                VStack(spacing: 0) {
                    // Top HUD
                    topHUDView
                        .padding(.top, geometry.safeAreaInsets.top)
                    
                    Spacer()
                    
                    // Main Game Area
                    mainGameArea
                    
                    Spacer()
                    
                    // PS5-Style Controller
                    ps5ControllerView
                        .padding(.bottom, geometry.safeAreaInsets.bottom + 20)
                }
            }
        }
        .ignoresSafeArea()
        .onReceive(gameTimer) { _ in
            updateGameTimer()
        }
        .onReceive(priceTimer) { _ in
            updatePrice()
        }
        .onAppear {
            setupGame()
            startAnimations()
        }
        .sheet(isPresented: $showVoiceNotes) {
            if let voiceNote = latestVoiceNote {
                BotVoiceNoteSheet(voiceNote: voiceNote)
            }
        }
    }
    
    private var backgroundView: some View {
        ZStack {
            // Dark gradient background
            LinearGradient(
                colors: [
                    Color.black,
                    Color.blue.opacity(0.3),
                    Color.purple.opacity(0.2),
                    Color.black
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            // Animated particles
            ForEach(0..<20, id: \.self) { i in
                Circle()
                    .fill(.white.opacity(0.1))
                    .frame(width: CGFloat.random(in: 2...6))
                    .position(
                        x: CGFloat.random(in: 0...400),
                        y: CGFloat.random(in: 0...800)
                    )
                    .opacity(animateController ? 0.3 : 0.1)
                    .animation(
                        .easeInOut(duration: Double.random(in: 2...4))
                        .repeatForever(autoreverses: true)
                        .delay(Double.random(in: 0...2)),
                        value: animateController
                    )
            }
        }
    }
    
    private var topHUDView: some View {
        VStack(spacing: 16) {
            // Game Status Bar
            HStack {
                Button("EXIT") {
                    dismiss()
                }
                .font(.caption.bold())
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(.red.opacity(0.8))
                .cornerRadius(15)
                
                Spacer()
                
                VStack(spacing: 2) {
                    Text(game.gameType.displayName)
                        .font(.headline.bold())
                        .foregroundColor(.white)
                    
                    Text(formatTimeRemaining(game.timeRemaining))
                        .font(.subheadline.bold())
                        .foregroundColor(.orange)
                }
                
                Spacer()
                
                Button(action: { showVoiceNotes = true }) {
                    HStack(spacing: 4) {
                        Image(systemName: "speaker.wave.2.fill")
                            .foregroundColor(.blue)
                        
                        if latestVoiceNote != nil {
                            Circle()
                                .fill(.red)
                                .frame(width: 8, height: 8)
                        }
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(.ultraThinMaterial)
                .cornerRadius(15)
            }
            
            // Progress and Stats HUD
            VStack(spacing: 12) {
                // Progress Bar
                VStack(spacing: 6) {
                    HStack {
                        Text("Progress to Target")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                        
                        Spacer()
                        
                        Text("\(Int(game.progressToTarget * 100))%")
                            .font(.subheadline.bold())
                            .foregroundColor(.green)
                    }
                    
                    GeometryReader { proxy in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.ultraThinMaterial.opacity(0.3))
                                .frame(height: 8)
                            
                            RoundedRectangle(cornerRadius: 10)
                                .fill(
                                    LinearGradient(
                                        colors: [.green, .blue, .green],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(
                                    width: proxy.size.width * game.progressToTarget,
                                    height: 8
                                )
                                .glow(color: .green, radius: glowEffect ? 4 : 0)
                        }
                    }
                    .frame(height: 8)
                }
                
                // Stats Row
                HStack(spacing: 20) {
                    GameStat(
                        title: "ENTRY",
                        value: "$\(String(format: "%.0f", game.entryAmount))",
                        color: .blue
                    )
                    
                    GameStat(
                        title: "CURRENT",
                        value: "$\(String(format: "%.2f", game.currentBalance))",
                        color: game.currentBalance >= game.entryAmount ? .green : .red
                    )
                    
                    GameStat(
                        title: "TARGET",
                        value: "$\(String(format: "%.0f", game.targetAmount))",
                        color: .purple
                    )
                    
                    GameStat(
                        title: "P&L",
                        value: game.currentProfit >= 0 ? "+$\(String(format: "%.2f", game.currentProfit))" : "-$\(String(format: "%.2f", abs(game.currentProfit)))",
                        color: game.currentProfit >= 0 ? .green : .red
                    )
                }
            }
            .padding()
            .background(.ultraThinMaterial.opacity(0.5))
            .cornerRadius(15)
        }
        .padding(.horizontal)
    }
    
    private var mainGameArea: some View {
        VStack(spacing: 20) {
            // Price Display
            priceDisplayView
            
            // Chart Area
            chartAreaView
            
            // Quick Actions
            quickActionsView
        }
        .padding(.horizontal)
    }
    
    private var priceDisplayView: some View {
        VStack(spacing: 8) {
            Text("GOLD/USD")
                .font(.caption.bold())
                .foregroundColor(.white.opacity(0.7))
            
            HStack(spacing: 8) {
                Text("$\(String(format: "%.2f", currentPrice))")
                    .font(.system(size: 32, weight: .bold, design: .monospaced))
                    .foregroundColor(.white)
                    .glow(color: .blue, radius: glowEffect ? 2 : 0)
                
                HStack(spacing: 4) {
                    Image(systemName: priceDirection.systemImage)
                        .font(.headline)
                        .foregroundColor(priceDirection.color)
                    
                    Text(priceChange)
                        .font(.subheadline.bold())
                        .foregroundColor(priceDirection.color)
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial.opacity(0.3))
        .cornerRadius(15)
    }
    
    private var chartAreaView: some View {
        VStack(spacing: 8) {
            Text("LIVE CHART")
                .font(.caption.bold())
                .foregroundColor(.white.opacity(0.7))
            
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(.ultraThinMaterial.opacity(0.2))
                    .frame(height: 200)
                
                if priceHistory.count > 1 {
                    LineChart(data: priceHistory, color: .green)
                        .padding()
                } else {
                    VStack {
                        Image(systemName: "chart.line.uptrend.xyaxis")
                            .font(.title)
                            .foregroundColor(.blue)
                        
                        Text("Building Chart...")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                    }
                }
            }
        }
    }
    
    private var quickActionsView: some View {
        HStack(spacing: 16) {
            // Quick Buy
            Button(action: { executeQuickTrade(.buy) }) {
                HStack(spacing: 6) {
                    Image(systemName: "arrow.up.circle.fill")
                    Text("QUICK BUY")
                        .font(.caption.bold())
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(.green.opacity(0.8))
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .buttonStyle(GameButtonStyle())
            
            // Quick Sell
            Button(action: { executeQuickTrade(.sell) }) {
                HStack(spacing: 6) {
                    Image(systemName: "arrow.down.circle.fill")
                    Text("QUICK SELL")
                        .font(.caption.bold())
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(.red.opacity(0.8))
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .buttonStyle(GameButtonStyle())
        }
    }
    
    private var ps5ControllerView: some View {
        VStack(spacing: 20) {
            // Controller Handle
            controllerHandleView
            
            // Main Controller Body
            controllerBodyView
        }
        .scaleEffect(animateController ? 1.0 : 0.9)
        .opacity(animateController ? 1.0 : 0.8)
        .animation(.spring(dampingFraction: 0.8).delay(0.3), value: animateController)
    }
    
    private var controllerHandleView: some View {
        HStack(spacing: 40) {
            // Left Handle
            VStack(spacing: 16) {
                // D-Pad
                VStack(spacing: 4) {
                    Button(action: { increaseTradeAmount() }) {
                        Image(systemName: "plus")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(width: 35, height: 35)
                            .background(.ultraThinMaterial.opacity(0.8))
                            .cornerRadius(8)
                    }
                    .buttonStyle(PS5ButtonStyle())
                    
                    HStack(spacing: 4) {
                        Button(action: { decreaseTradeAmount() }) {
                            Image(systemName: "minus")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(width: 35, height: 35)
                                .background(.ultraThinMaterial.opacity(0.8))
                                .cornerRadius(8)
                        }
                        .buttonStyle(PS5ButtonStyle())
                        
                        Button(action: { resetTradeAmount() }) {
                            Image(systemName: "gobackward")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(width: 35, height: 35)
                                .background(.ultraThinMaterial.opacity(0.8))
                                .cornerRadius(8)
                        }
                        .buttonStyle(PS5ButtonStyle())
                    }
                }
                
                // Left Analog Stick (Price Tracker)
                ZStack {
                    Circle()
                        .fill(.ultraThinMaterial.opacity(0.6))
                        .frame(width: 60, height: 60)
                    
                    Circle()
                        .fill(.blue)
                        .frame(width: 20, height: 20)
                        .offset(
                            x: sin(Date().timeIntervalSince1970) * 10,
                            y: cos(Date().timeIntervalSince1970) * 10
                        )
                        .animation(.easeInOut(duration: 2).repeatForever(), value: animateController)
                }
            }
            
            Spacer()
            
            // Right Handle
            VStack(spacing: 16) {
                // Action Buttons
                VStack(spacing: 8) {
                    HStack(spacing: 8) {
                        Button(action: { showVoiceNotes = true }) {
                            Text("Y")
                                .font(.headline.bold())
                                .foregroundColor(.black)
                                .frame(width: 35, height: 35)
                                .background(.yellow)
                                .clipShape(Circle())
                        }
                        .buttonStyle(PS5ButtonStyle())
                        
                        Button(action: { executeQuickTrade(.buy) }) {
                            Text("X")
                                .font(.headline.bold())
                                .foregroundColor(.white)
                                .frame(width: 35, height: 35)
                                .background(.green)
                                .clipShape(Circle())
                        }
                        .buttonStyle(PS5ButtonStyle())
                    }
                    
                    HStack(spacing: 8) {
                        Button(action: { pauseGame() }) {
                            Text("□")
                                .font(.headline.bold())
                                .foregroundColor(.white)
                                .frame(width: 35, height: 35)
                                .background(.gray)
                                .clipShape(Circle())
                        }
                        .buttonStyle(PS5ButtonStyle())
                        
                        Button(action: { executeQuickTrade(.sell) }) {
                            Text("O")
                                .font(.headline.bold())
                                .foregroundColor(.white)
                                .frame(width: 35, height: 35)
                                .background(.red)
                                .clipShape(Circle())
                        }
                        .buttonStyle(PS5ButtonStyle())
                    }
                }
                
                // Right Analog Stick (Trade Amount)
                ZStack {
                    Circle()
                        .fill(.ultraThinMaterial.opacity(0.6))
                        .frame(width: 60, height: 60)
                    
                    VStack(spacing: 2) {
                        Text("$\(String(format: "%.0f", tradeAmount))")
                            .font(.caption.bold())
                            .foregroundColor(.white)
                        
                        Text("TRADE")
                            .font(.caption2)
                            .foregroundColor(.white.opacity(0.7))
                    }
                }
            }
        }
    }
    
    private var controllerBodyView: some View {
        HStack(spacing: 20) {
            // L1/L2 Buttons
            VStack(spacing: 8) {
                Button(action: { executeQuickTrade(.buy) }) {
                    HStack(spacing: 6) {
                        Image(systemName: "arrow.up.circle.fill")
                        Text("BUY")
                            .font(.caption.bold())
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(.green.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(20)
                }
                .buttonStyle(GameButtonStyle())
                
                Text("L1")
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.7))
            }
            
            // Center Touchpad Area
            VStack(spacing: 8) {
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(.ultraThinMaterial.opacity(0.8))
                        .frame(width: 120, height: 60)
                        .glow(color: .blue, radius: glowEffect ? 3 : 0)
                    
                    VStack(spacing: 4) {
                        Text("GOLDEX")
                            .font(.caption.bold())
                            .foregroundColor(.white)
                        
                        Text("MICROFLIP")
                            .font(.caption2)
                            .foregroundColor(.blue)
                        
                        HStack(spacing: 2) {
                            ForEach(0..<3, id: \.self) { _ in
                                Circle()
                                    .fill(.blue.opacity(0.6))
                                    .frame(width: 4, height: 4)
                            }
                        }
                    }
                }
                
                Text("TOUCHPAD")
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.7))
            }
            
            // R1/R2 Buttons
            VStack(spacing: 8) {
                Button(action: { executeQuickTrade(.sell) }) {
                    HStack(spacing: 6) {
                        Image(systemName: "arrow.down.circle.fill")
                        Text("SELL")
                            .font(.caption.bold())
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(.red.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(20)
                }
                .buttonStyle(GameButtonStyle())
                
                Text("R1")
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.7))
            }
        }
    }
    
    private var priceDirection: (systemImage: String, color: Color) {
        guard priceHistory.count > 1 else {
            return ("minus", .gray)
        }
        
        let currentPrice = priceHistory.last ?? 0
        let previousPrice = priceHistory[priceHistory.count - 2]
        
        if currentPrice > previousPrice {
            return ("arrow.up", .green)
        } else if currentPrice < previousPrice {
            return ("arrow.down", .red)
        } else {
            return ("minus", .gray)
        }
    }
    
    private var priceChange: String {
        guard priceHistory.count > 1 else { return "0.00" }
        
        let currentPrice = priceHistory.last ?? 0
        let previousPrice = priceHistory[priceHistory.count - 2]
        let change = currentPrice - previousPrice
        
        return String(format: "%.2f", abs(change))
    }
    
    private func startAnimations() {
        withAnimation(.spring(dampingFraction: 0.6).delay(0.5)) {
            animateController = true
        }
        
        withAnimation(.easeInOut(duration: 2).repeatForever()) {
            glowEffect = true
        }
    }
    
    private func setupGame() {
        // Initialize price history
        currentPrice = 2045.30
        priceHistory = [currentPrice]
        
        // Generate initial voice note
        latestVoiceNote = BotVoiceNote(
            botId: "game_bot",
            botName: "GameMaster",
            botPersonality: .coach,
            gameId: game.id,
            noteType: .encouragement,
            message: "Welcome to \(game.gameType.displayName)! Let's make some profit! 💰",
            emotion: .excited,
            confidence: 0.95,
            importance: .high
        )
    }
    
    private func updateGameTimer() {
        guard game.isActive else { return }
        
        // Update game time
        let newTimeRemaining = game.timeRemaining - 1
        
        if newTimeRemaining <= 0 {
            endGame()
        }
    }
    
    private func updatePrice() {
        guard game.isActive else { return }
        
        // Simulate price movement
        let volatility = 0.5
        let randomChange = Double.random(in: -volatility...volatility)
        currentPrice += randomChange
        
        priceHistory.append(currentPrice)
        
        // Keep only last 50 price points
        if priceHistory.count > 50 {
            priceHistory.removeFirst()
        }
        
        // Update game balance based on theoretical trades
        let balanceChange = Double.random(in: -2.0...3.0)
        game.currentBalance = max(0, game.currentBalance + balanceChange)
    }
    
    private func executeQuickTrade(_ action: TradeAction) {
        // Simulate trade execution
        let tradeResult = Double.random(in: -10.0...15.0)
        game.currentBalance += tradeResult
        
        // Generate bot voice note
        generateTradeVoiceNote(action: action, result: tradeResult)
        
        // Haptic feedback
        if controllerHaptics {
            // Add haptic feedback here
        }
        
        onGameUpdate(game)
    }
    
    private func generateTradeVoiceNote(action: TradeAction, result: Double) {
        let messages = result > 0 ?
        ["Nice trade! 🔥", "Profit secured! 💰", "You're on fire! 🚀"] :
        ["Don't worry, next one! 💪", "Shake it off! 🎯", "Stay focused! 🧠"]
        
        latestVoiceNote = BotVoiceNote(
            botId: "game_bot",
            botName: "GameMaster",
            botPersonality: .coach,
            gameId: game.id,
            noteType: result > 0 ? .celebration : .encouragement,
            message: messages.randomElement() ?? "Keep trading!",
            emotion: result > 0 ? .excited : .confident,
            confidence: 0.8,
            importance: .medium
        )
    }
    
    private func increaseTradeAmount() {
        tradeAmount = min(game.currentBalance, tradeAmount + 10)
    }
    
    private func decreaseTradeAmount() {
        tradeAmount = max(10, tradeAmount - 10)
    }
    
    private func resetTradeAmount() {
        tradeAmount = 50.0
    }
    
    private func pauseGame() {
        game.status = .paused
        onGameUpdate(game)
    }
    
    private func endGame() {
        let finalProfit = game.currentBalance - game.entryAmount
        
        if finalProfit >= game.profitTarget {
            game.result = .win(finalProfit)
            game.status = .completed
        } else if finalProfit > 0 {
            game.result = .win(finalProfit)
            game.status = .completed
        } else {
            game.result = .loss(abs(finalProfit))
            game.status = .failed
        }
        
        game.completedAt = Date()
        onGameUpdate(game)
        
        // Auto-dismiss after showing results
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            dismiss()
        }
    }
    
    private func formatTimeRemaining(_ time: TimeInterval) -> String {
        let minutes = Int(time / 60)
        let seconds = Int(time.truncatingRemainder(dividingBy: 60))
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

// MARK: - Supporting Views and Styles

struct GameStat: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.caption2.bold())
                .foregroundColor(.white.opacity(0.7))
            
            Text(value)
                .font(.caption.bold())
                .foregroundColor(color)
        }
    }
}

struct LineChart: View {
    let data: [Double]
    let color: Color
    
    var body: some View {
        GeometryReader { geometry in
            let maxValue = data.max() ?? 1
            let minValue = data.min() ?? 0
            let range = maxValue - minValue
            
            Path { path in
                guard !data.isEmpty, range > 0 else { return }
                
                let stepX = geometry.size.width / CGFloat(data.count - 1)
                
                for (index, value) in data.enumerated() {
                    let x = CGFloat(index) * stepX
                    let y = geometry.size.height - (CGFloat(value - minValue) / CGFloat(range) * geometry.size.height)
                    
                    if index == 0 {
                        path.move(to: CGPoint(x: x, y: y))
                    } else {
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                }
            }
            .stroke(color, lineWidth: 2)
        }
    }
}

struct GameButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct PS5ButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .opacity(configuration.isPressed ? 0.7 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct BotVoiceNoteSheet: View {
    let voiceNote: BotVoiceNote
    @Environment(\.dismiss) private var dismiss
    @State private var isPlaying = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Bot Avatar
            Text(voiceNote.botPersonality.emoji)
                .font(.system(size: 80))
            
            // Bot Info
            VStack(spacing: 8) {
                Text(voiceNote.botName)
                    .font(.title.bold())
                
                Text(voiceNote.noteType.displayName)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            // Message
            Text(voiceNote.message)
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(15)
            
            // Play Button
            Button(action: { isPlaying.toggle() }) {
                HStack(spacing: 8) {
                    Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .font(.title)
                    
                    Text(isPlaying ? "Playing..." : "Play Voice Note")
                        .font(.headline.bold())
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(.blue)
                .foregroundColor(.white)
                .cornerRadius(15)
            }
            
            Spacer()
        }
        .padding()
        .presentationDetents([.medium])
    }
}

extension View {
    func glow(color: Color, radius: CGFloat) -> some View {
        self.shadow(color: color, radius: radius)
            .shadow(color: color, radius: radius)
            .shadow(color: color, radius: radius)
    }
}

#Preview {
    GameControllerView(
        game: MicroFlipGame.sampleGames[0],
        onGameUpdate: { _ in }
    )
}