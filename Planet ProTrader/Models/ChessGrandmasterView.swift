//
//  ChessGrandmasterView.swift
//  GOLDEX AI
//
//  Created by Keonta on 7/13/25.
//

import SwiftUI

struct ChessGrandmasterView: View {
    @StateObject private var chessEngine = ChessGrandmasterEngine()
    @State private var showingMoveDetails = false
    @State private var selectedMove: ChessGrandmasterEngine.MarketMove?
    @State private var animateChessBoard = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header with Chess Theme
                    headerSection
                    
                    // Engine Status
                    engineStatusSection
                    
                    // Chess Strategy Section
                    strategySection
                    
                    // Chess Board Visualization
                    chessBoardSection
                    
                    // Calculated Moves Section
                    calculatedMovesSection
                    
                    // Threat Assessment
                    threatAssessmentSection
                    
                    // Chess Openings Database
                    openingsSection
                    
                    // Controls
                    controlsSection
                }
                .padding()
            }
            .navigationTitle("Chess Grandmaster Engine")
            .navigationBarTitleDisplayMode(.large)
            .background(DesignSystem.backgroundGradient)
            .sheet(isPresented: $showingMoveDetails) {
                moveDetailsSheet
            }
        }
    }
    
    private var headerSection: some View {
        UltraPremiumCard {
            VStack(spacing: 16) {
                HStack {
                    Image(systemName: "crown.fill")
                        .font(.system(size: 32))
                        .foregroundStyle(DesignSystem.primaryGold)
                    
                    VStack(alignment: .leading) {
                        Text("Chess Grandmaster Engine")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("Think 20 moves ahead like a chess master")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text("Moves Calculated")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        Text("\(chessEngine.calculatedMoves.count)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(DesignSystem.primaryGold)
                    }
                }
                
                // Analysis Progress
                if chessEngine.isAnalyzing {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Analyzing Deep Strategy...")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            
                            Spacer()
                            
                            Text("20 moves ahead")
                                .font(.caption)
                                .foregroundStyle(DesignSystem.primaryGold)
                        }
                        
                        ProgressView(value: chessEngine.positionStrength)
                            .progressViewStyle(LinearProgressViewStyle(tint: DesignSystem.primaryGold))
                            .scaleEffect(y: 0.8)
                    }
                }
            }
        }
    }
    
    private var engineStatusSection: some View {
        UltraPremiumCard {
            VStack(spacing: 16) {
                HStack {
                    Text("Engine Status")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Circle()
                        .fill(chessEngine.isActive ? Color.green : Color.gray)
                        .frame(width: 12, height: 12)
                        .scaleEffect(chessEngine.isActive ? 1.2 : 1.0)
                        .animation(.easeInOut(duration: 0.3).repeatForever(autoreverses: true), value: chessEngine.isActive)
                }
                
                HStack(spacing: 20) {
                    VStack {
                        Text("Position Strength")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        Text("\(Int(chessEngine.positionStrength * 100))%")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundStyle(DesignSystem.primaryGold)
                    }
                    
                    Divider()
                        .frame(height: 40)
                    
                    VStack {
                        Text("Instinct Level")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        Text("\(chessEngine.movesAhead)")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundStyle(.blue)
                    }
                    
                    Divider()
                        .frame(height: 40)
                    
                    VStack {
                        Text("Last Analysis")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        Text(TimeFormatter.timeAgo(from: chessEngine.lastAnalysisTime))
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundStyle(.green)
                    }
                }
            }
        }
    }
    
    private var strategySection: some View {
        UltraPremiumCard {
            VStack(spacing: 16) {
                HStack {
                    Text("Current Strategy")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Image(systemName: chessEngine.currentStrategy.icon)
                        .font(.title2)
                        .foregroundStyle(DesignSystem.primaryGold)
                }
                
                HStack {
                    VStack(alignment: .leading) {
                        Text(chessEngine.currentStrategy.displayName)
                            .font(.title3)
                            .fontWeight(.bold)
                        
                        Text("Adapting to current market conditions")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text("Effectiveness")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        Text("\(Int(chessEngine.positionStrength * 100))%")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundStyle(DesignSystem.primaryGold)
                    }
                }
            }
        }
    }
    
    private var chessBoardSection: some View {
        UltraPremiumCard {
            VStack(spacing: 16) {
                HStack {
                    Text("Chess Board Visualization")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation(.spring()) {
                            animateChessBoard.toggle()
                        }
                    }) {
                        Image(systemName: "arrow.clockwise")
                            .font(.title2)
                            .foregroundStyle(DesignSystem.primaryGold)
                    }
                }
                
                // Chess Board Grid
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 2), count: 8), spacing: 2) {
                    ForEach(0..<64, id: \.self) { index in
                        let row = index / 8
                        let col = index % 8
                        let isLight = (row + col) % 2 == 0
                        
                        Rectangle()
                            .fill(isLight ? Color.white : Color.black.opacity(0.1))
                            .frame(height: 32)
                            .overlay(
                                chessPieceForPosition(row, col)
                            )
                            .scaleEffect(animateChessBoard ? 1.05 : 1.0)
                            .animation(.easeInOut(duration: 0.3).delay(Double(index) * 0.01), value: animateChessBoard)
                    }
                }
                .background(Color.black.opacity(0.05))
                .cornerRadius(8)
            }
        }
    }
    
    private func chessPieceForPosition(_ row: Int, _ col: Int) -> some View {
        Group {
            if row == 0 && col == 4 {
                // King position
                Image(systemName: "crown.fill")
                    .font(.system(size: 16))
                    .foregroundStyle(DesignSystem.primaryGold)
            } else if row == 7 && col == 4 {
                // Opponent King
                Image(systemName: "crown")
                    .font(.system(size: 16))
                    .foregroundStyle(.red)
            } else if (row == 1 || row == 6) && col % 2 == 0 {
                // Pawns
                Image(systemName: "person.fill")
                    .font(.system(size: 12))
                    .foregroundStyle(row == 1 ? DesignSystem.primaryGold : .red)
            } else {
                EmptyView()
            }
        }
    }
    
    private var calculatedMovesSection: some View {
        UltraPremiumCard {
            VStack(spacing: 16) {
                HStack {
                    Text("Calculated Moves")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Text("\(chessEngine.calculatedMoves.count) moves")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                if chessEngine.calculatedMoves.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "brain.head.profile")
                            .font(.system(size: 32))
                            .foregroundStyle(.secondary)
                        
                        Text("No moves calculated yet")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        Text("Start analysis to see calculated moves")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                    }
                    .frame(maxWidth: .infinity, minHeight: 100)
                } else {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                        ForEach(chessEngine.calculatedMoves.prefix(6)) { move in
                            moveCard(move)
                        }
                    }
                    
                    if chessEngine.calculatedMoves.count > 6 {
                        Button(action: {
                            showingMoveDetails = true
                        }) {
                            Text("View All \(chessEngine.calculatedMoves.count) Moves")
                                .font(.caption)
                                .foregroundStyle(DesignSystem.primaryGold)
                        }
                    }
                }
            }
        }
    }
    
    private func moveCard(_ move: ChessGrandmasterEngine.MarketMove) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Move #\(move.sequence)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                Text("\(Int(move.probability * 100))%")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(DesignSystem.primaryGold)
            }
            
            Text(move.description)
                .font(.caption)
                .foregroundStyle(.primary)
                .lineLimit(2)
            
            HStack {
                Text("\(Int(move.expectedPips)) pips")
                    .font(.caption)
                    .foregroundStyle(.green)
                
                Spacer()
                
                Text(move.timeframe)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(12)
        .background(Color.black.opacity(0.05))
        .cornerRadius(8)
        .onTapGesture {
            selectedMove = move
            showingMoveDetails = true
        }
    }
    
    private var threatAssessmentSection: some View {
        UltraPremiumCard {
            VStack(spacing: 16) {
                HStack {
                    Text("Threat Assessment")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Circle()
                        .fill(chessEngine.threatLevel.color)
                        .frame(width: 16, height: 16)
                }
                
                HStack {
                    VStack(alignment: .leading) {
                        Text(chessEngine.threatLevel.displayName)
                            .font(.title3)
                            .fontWeight(.bold)
                        
                        Text("Based on position analysis")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "shield.fill")
                        .font(.title2)
                        .foregroundStyle(chessEngine.threatLevel.color)
                }
            }
        }
    }
    
    private var openingsSection: some View {
        UltraPremiumCard {
            VStack(spacing: 16) {
                HStack {
                    Text("Chess Openings Database")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Text("5 openings")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 1), spacing: 12) {
                    ForEach(chessEngine.chessOpenings.prefix(3)) { opening in
                        openingCard(opening)
                    }
                }
            }
        }
    }
    
    private func openingCard(_ opening: ChessGrandmasterEngine.ChessOpening) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(opening.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Text("\(Int(opening.winRate))%")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(DesignSystem.primaryGold)
            }
            
            Text(opening.pattern)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(12)
        .background(Color.black.opacity(0.05))
        .cornerRadius(8)
    }
    
    private var controlsSection: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                Button(action: {
                    if chessEngine.isActive {
                        chessEngine.deactivateEngine()
                    } else {
                        chessEngine.activateEngine()
                    }
                }) {
                    HStack {
                        Image(systemName: chessEngine.isActive ? "stop.fill" : "play.fill")
                            .font(.headline)
                        
                        Text(chessEngine.isActive ? "Deactivate" : "Activate")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(chessEngine.isActive ? Color.red : DesignSystem.primaryGold)
                    .foregroundStyle(.white)
                    .cornerRadius(12)
                }
                
                Button(action: {
                    chessEngine.startAnalysis()
                }) {
                    HStack {
                        Image(systemName: "brain.head.profile")
                            .font(.headline)
                        
                        Text("Analyze")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundStyle(.white)
                    .cornerRadius(12)
                }
            }
        }
    }
    
    private var moveDetailsSheet: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    if let move = selectedMove {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Move #\(move.sequence)")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text(move.description)
                                .font(.body)
                            
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Probability")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                    
                                    Text("\(Int(move.probability * 100))%")
                                        .font(.headline)
                                        .foregroundStyle(DesignSystem.primaryGold)
                                }
                                
                                Spacer()
                                
                                VStack(alignment: .trailing) {
                                    Text("Expected Pips")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                    
                                    Text("\(Int(move.expectedPips))")
                                        .font(.headline)
                                        .foregroundStyle(.green)
                                }
                            }
                        }
                        .padding()
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(12)
                    }
                    
                    // All moves
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 1), spacing: 12) {
                        ForEach(chessEngine.calculatedMoves) { move in
                            moveCard(move)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("All Calculated Moves")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        showingMoveDetails = false
                    }
                }
            }
        }
    }
}