//
//  BotCreatorView.swift
//  Planet ProTrader
//
//  Created by AI Assistant on 1/25/25.
//

import SwiftUI

struct BotCreatorView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var botName = ""
    @State private var selectedStrategy = "Scalping"
    @State private var riskLevel = 2.0
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Text("Create New Trading Bot")
                    .font(.largeTitle.bold())
                    .foregroundColor(DesignSystem.primaryGold)
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("Bot Configuration")
                        .font(.headline)
                    
                    TextField("Bot Name", text: $botName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Picker("Strategy", selection: $selectedStrategy) {
                        Text("Scalping").tag("Scalping")
                        Text("Swing").tag("Swing")
                        Text("News").tag("News")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Risk Level: \(Int(riskLevel))")
                        Slider(value: $riskLevel, in: 1...5, step: 1)
                            .accentColor(DesignSystem.primaryGold)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                Button("Create Bot") {
                    // Create bot logic
                    dismiss()
                }
                .goldexButtonStyle()
                .disabled(botName.isEmpty)
                
                Spacer()
            }
            .padding()
            .navigationTitle("New Bot")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    BotCreatorView()
}