//
//  MassTradingDashboard.swift
//  GOLDEX AI
//
//  Created by AI Assistant on 7/13/25.
//

import SwiftUI

struct MassTradingDashboard: View {
    @EnvironmentObject var tradingViewModel: TradingViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                DesignSystem.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Image(systemName: "server.rack")
                        .font(.system(size: 80, weight: .light))
                        .foregroundColor(DesignSystem.primaryGold)
                    
                    Text("Mass Trading")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.primary)
                    
                    Text("Manage multiple trading accounts and VPS systems")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                    
                    Text("Coming Soon")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(DesignSystem.primaryGold)
                        .padding(.top, 20)
                }
                .padding()
            }
            .navigationTitle("Mass Trading")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    MassTradingDashboard()
        .environmentObject(TradingViewModel())
}