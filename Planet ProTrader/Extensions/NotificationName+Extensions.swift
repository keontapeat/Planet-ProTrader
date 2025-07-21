//
//  NotificationName+Extensions.swift
//  Planet ProTrader
//
//  Created by Senior iOS Engineer on 1/25/25.
//

import Foundation

extension Notification.Name {
    static let eaStatusChanged = Notification.Name("eaStatusChanged")
    static let accountBalanceUpdated = Notification.Name("accountBalanceUpdated")
    static let tradeSignalGenerated = Notification.Name("tradeSignalGenerated")
    static let tradingModeChanged = Notification.Name("tradingModeChanged")
    static let performanceUpdated = Notification.Name("performanceUpdated")
    static let connectionStatusChanged = Notification.Name("connectionStatusChanged")
    static let marketDataUpdated = Notification.Name("marketDataUpdated")
    static let autoTradingStarted = Notification.Name("autoTradingStarted")
    static let autoTradingStopped = Notification.Name("autoTradingStopped")
    static let newTradeExecuted = Notification.Name("newTradeExecuted")
    static let riskLevelChanged = Notification.Name("riskLevelChanged")
}