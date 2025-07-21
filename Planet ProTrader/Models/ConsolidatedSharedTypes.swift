//  ConsolidatedSharedTypes.swift
//  Planet ProTrader
//
//  DEPRECATED - ALL TYPES MOVED TO MasterSharedTypes.swift
//  This file now imports from the master file to prevent conflicts
//

import Foundation
import SwiftUI

// MARK: - Import All Types from Master File
// All types are now defined in MasterSharedTypes.swift to prevent conflicts

// This file remains for compatibility but redirects to master types
typealias ConsolidatedTradeDirection = TradeDirection
typealias ConsolidatedBrokerType = BrokerType  
typealias ConsolidatedTradeGrade = TradeGrade

// MARK: - Temporary Fix Preview
#Preview {
    VStack {
        Text("⚠️ Deprecated File")
            .font(.title.bold())
            .foregroundColor(.orange)
        
        Text("All types moved to MasterSharedTypes.swift")
            .font(.caption)
            .foregroundColor(.secondary)
            
        Text("This file now imports from master types")
            .font(.caption)
            .foregroundColor(.secondary)
    }
    .padding()
}