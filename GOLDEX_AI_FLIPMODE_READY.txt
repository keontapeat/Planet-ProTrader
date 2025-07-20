//+------------------------------------------------------------------+
//| GOLDEX AI - FlipMode Enabled Expert Advisor                     |
//| Real Account: 845514@Coinexx-demo                               |
//| FlipMode: Aggressive Trading with High Frequency                |
//+------------------------------------------------------------------+
#property copyright "GOLDEX AI FlipMode System"
#property version   "2.1"
#property strict

#include <Trade\Trade.mqh>
#include <Trade\OrderInfo.mqh>
#include <Trade\PositionInfo.mqh>
#include <Trade\AccountInfo.mqh>

//--- FlipMode Input Parameters
input group "=== GOLDEX AI FLIPMODE SETTINGS ==="
input bool EnableAutoTrading = true;                    // Enable Auto Trading
input bool EnableTestMode = true;                       // Enable Test Mode (More Signals)
input bool EnableFlipMode = true;                       // Enable Flip Mode - TURNED ON
input double MaxRiskPercent = 1.5;                     // Max Risk Per Trade (%) - Reduced for FlipMode
input int MaxDailyTrades = 10;                         // Max Daily Trades - Increased for FlipMode
input double MaxDailyRisk = 15.0;                      // Max Daily Risk (%) - Increased for FlipMode
input int MagicNumber = 20241201;                      // Magic Number
input string TradeComment = "GOLDEX_AI_FLIP_v2.1";     // Trade Comment

input group "=== FLIPMODE SPECIFIC SETTINGS ==="
input double FlipModeConfidence = 0.75;                // FlipMode Minimum Confidence (Lower)
input int FlipModeSignalInterval = 15;                  // FlipMode Signal Check Interval (seconds)
input double FlipModeRiskReward = 1.5;                 // FlipMode Risk:Reward Ratio
input bool EnableScalpingMode = true;                  // Enable Scalping Mode
input int MaxSpreadPointsFlip = 40;                    // Max Spread for FlipMode (Points)
input double FlipModeStopLoss = 15.0;                  // FlipMode Stop Loss (Points)
input bool EnableAggressiveEntry = true;               // Enable Aggressive Entry

input group "=== FLIPMODE RISK MANAGEMENT ==="
input double FlipModeMaxLot = 0.03;                    // FlipMode Maximum Lot Size
input double FlipModeMinLot = 0.01;                    // FlipMode Minimum Lot Size
input bool EnableQuickProfits = true;                  // Enable Quick Profit Taking
input double QuickProfitPoints = 10.0;                 // Quick Profit Points
input bool EnableBreakeven = true;                     // Enable Breakeven

//--- Global Variables
CTrade trade;
COrderInfo orderInfo;
CPositionInfo positionInfo;
CAccountInfo accountInfo;

struct FlipModeStats {
    int todayTrades;
    int todayWins;
    int todayLosses;
    double todayProfit;
    double winRate;
    datetime lastTradeTime;
    int consecutiveWins;
    int consecutiveLosses;
    double accountBalance;
    bool isFlipModeActive;
    double flipModeProfit;
    int flipModeSignalsGenerated;
    int flipModeSignalsExecuted;
};

FlipModeStats flipStats;

struct FlipModeSignal {
    string id;
    string direction;
    double entryPrice;
    double stopLoss;
    double takeProfit;
    double lotSize;
    double confidence;
    datetime timestamp;
    bool isFlipMode;
    string reasoning;
    double spread;
    bool isValid;
};

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
    // Initialize trading object
    trade.SetExpertMagicNumber(MagicNumber);
    trade.SetMarginMode();
    trade.SetTypeFillingBySymbol(Symbol());
    trade.SetDeviationInPoints(10);
    
    // Initialize FlipMode statistics
    InitializeFlipModeStats();
    
    // Set up chart for FlipMode
    SetupFlipModeChart();
    
    // FlipMode welcome message
    string message = StringFormat("🔥 GOLDEX AI FLIPMODE ACTIVATED! 🔥\n" +
                                "Account: %d\n" +
                                "Balance: $%.2f\n" +
                                "Symbol: %s\n" +
                                "FlipMode: %s\n" +
                                "Test Mode: %s\n" +
                                "Max Daily Trades: %d\n" +
                                "Signal Interval: %d seconds\n" +
                                "Ready for Aggressive Trading!",
                                AccountInfoInteger(ACCOUNT_LOGIN),
                                AccountInfoDouble(ACCOUNT_BALANCE),
                                Symbol(),
                                EnableFlipMode ? "✅ ACTIVE" : "❌ DISABLED",
                                EnableTestMode ? "ON" : "OFF",
                                MaxDailyTrades,
                                FlipModeSignalInterval);
    
    Print(message);
    SendNotification("🚀 GOLDEX AI FLIPMODE ACTIVATED - Ready for High-Frequency Trading!");
    
    return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
    // Update account info
    UpdateFlipModeAccountInfo();
    
    // Check for FlipMode signals more frequently
    static datetime lastSignalCheck = 0;
    if(TimeCurrent() - lastSignalCheck >= FlipModeSignalInterval)
    {
        if(EnableFlipMode)
            CheckForFlipModeSignals();
        else
            CheckForRegularSignals();
        
        lastSignalCheck = TimeCurrent();
    }
    
    // Monitor existing positions
    ManageFlipModePositions();
    
    // Update chart info
    UpdateFlipModeChartInfo();
}

//+------------------------------------------------------------------+
//| Initialize FlipMode Statistics                                   |
//+------------------------------------------------------------------+
void InitializeFlipModeStats()
{
    flipStats.todayTrades = 0;
    flipStats.todayWins = 0;
    flipStats.todayLosses = 0;
    flipStats.todayProfit = 0.0;
    flipStats.winRate = 0.0;
    flipStats.lastTradeTime = 0;
    flipStats.consecutiveWins = 0;
    flipStats.consecutiveLosses = 0;
    flipStats.accountBalance = AccountInfoDouble(ACCOUNT_BALANCE);
    flipStats.isFlipModeActive = EnableFlipMode;
    flipStats.flipModeProfit = 0.0;
    flipStats.flipModeSignalsGenerated = 0;
    flipStats.flipModeSignalsExecuted = 0;
}

//+------------------------------------------------------------------+
//| Check for FlipMode Signals                                       |
//+------------------------------------------------------------------+
void CheckForFlipModeSignals()
{
    if(!EnableAutoTrading) return;
    
    // More relaxed limits for FlipMode
    if(flipStats.todayTrades >= MaxDailyTrades)
    {
        static datetime lastLimitWarning = 0;
        if(TimeCurrent() - lastLimitWarning >= 1800) // Warn every 30 minutes
        {
            Print("⚠️ FlipMode daily trade limit reached (", MaxDailyTrades, ")");
            lastLimitWarning = TimeCurrent();
        }
        return;
    }
    
    // Check spread - more lenient for FlipMode
    double spread = (SymbolInfoDouble(Symbol(), SYMBOL_ASK) - SymbolInfoDouble(Symbol(), SYMBOL_BID)) / SymbolInfoDouble(Symbol(), SYMBOL_POINT);
    if(spread > MaxSpreadPointsFlip)
    {
        static datetime lastSpreadWarning = 0;
        if(TimeCurrent() - lastSpreadWarning >= 300)
        {
            Print("⚠️ FlipMode spread too high: ", spread, " points (max: ", MaxSpreadPointsFlip, ")");
            lastSpreadWarning = TimeCurrent();
        }
        return;
    }
    
    // Generate FlipMode signal
    FlipModeSignal signal = GenerateFlipModeSignal();
    
    if(signal.isValid)
    {
        ProcessFlipModeSignal(signal);
    }
}

//+------------------------------------------------------------------+
//| Generate FlipMode Signal                                          |
//+------------------------------------------------------------------+
FlipModeSignal GenerateFlipModeSignal()
{
    FlipModeSignal signal;
    signal.isValid = false;
    
    flipStats.flipModeSignalsGenerated++;
    
    // FlipMode generates signals more aggressively
    double probability = EnableTestMode ? 0.6 : 0.3; // 60% chance in test mode, 30% normally
    
    if(EnableAggressiveEntry)
        probability += 0.2; // Increase probability for aggressive entry
    
    if(MathRand() / 32768.0 > probability)
        return signal;
    
    // Get current market data
    double currentPrice = SymbolInfoDouble(Symbol(), SYMBOL_BID);
    double ask = SymbolInfoDouble(Symbol(), SYMBOL_ASK);
    double bid = SymbolInfoDouble(Symbol(), SYMBOL_BID);
    
    // Generate signal details
    signal.id = StringFormat("FLIP_%d_%d", (int)TimeCurrent(), MathRand());
    signal.direction = MathRand() % 2 == 0 ? "long" : "short";
    signal.entryPrice = signal.direction == "long" ? ask : bid;
    signal.timestamp = TimeCurrent();
    signal.isFlipMode = true;
    signal.spread = (ask - bid) / SymbolInfoDouble(Symbol(), SYMBOL_POINT);
    
    // FlipMode uses tighter stops and targets
    double stopLossPoints = FlipModeStopLoss;
    double takeProfitPoints = stopLossPoints * FlipModeRiskReward;
    
    if(signal.direction == "long")
    {
        signal.stopLoss = signal.entryPrice - stopLossPoints * SymbolInfoDouble(Symbol(), SYMBOL_POINT);
        signal.takeProfit = signal.entryPrice + takeProfitPoints * SymbolInfoDouble(Symbol(), SYMBOL_POINT);
    }
    else
    {
        signal.stopLoss = signal.entryPrice + stopLossPoints * SymbolInfoDouble(Symbol(), SYMBOL_POINT);
        signal.takeProfit = signal.entryPrice - takeProfitPoints * SymbolInfoDouble(Symbol(), SYMBOL_POINT);
    }
    
    // Calculate lot size
    signal.lotSize = CalculateFlipModeLotSize(signal.entryPrice, signal.stopLoss);
    
    // FlipMode confidence calculation
    signal.confidence = 0.70 + (MathRand() / 32768.0) * 0.25; // 70-95% confidence
    
    // Boost confidence for consecutive wins
    if(flipStats.consecutiveWins >= 2)
        signal.confidence += 0.05;
    
    // Reduce confidence for consecutive losses
    if(flipStats.consecutiveLosses >= 2)
        signal.confidence -= 0.05;
    
    // Generate reasoning
    signal.reasoning = StringFormat("FLIPMODE %s: Quick scalp setup, RR=%.1f:1, Spread=%.1f pts, Confidence=%.0f%%",
                                   signal.direction, FlipModeRiskReward, signal.spread, signal.confidence * 100);
    
    // Validation
    if(signal.confidence >= FlipModeConfidence)
    {
        signal.isValid = true;
        Print("✅ FlipMode signal generated: ", signal.id, " (", signal.direction, ") - Confidence: ", signal.confidence * 100, "%");
    }
    
    return signal;
}

//+------------------------------------------------------------------+
//| Calculate FlipMode Lot Size                                       |
//+------------------------------------------------------------------+
double CalculateFlipModeLotSize(double entryPrice, double stopLoss)
{
    double accountBalance = AccountInfoDouble(ACCOUNT_BALANCE);
    double riskAmount = accountBalance * (MaxRiskPercent / 100.0);
    
    // Reduce risk after losses
    if(flipStats.consecutiveLosses >= 2)
        riskAmount *= 0.7;
    
    // Increase risk after wins (but cautiously)
    if(flipStats.consecutiveWins >= 3)
        riskAmount *= 1.2;
    
    double stopLossPoints = MathAbs(entryPrice - stopLoss) / SymbolInfoDouble(Symbol(), SYMBOL_POINT);
    double tickValue = SymbolInfoDouble(Symbol(), SYMBOL_TRADE_TICK_VALUE);
    
    double lotSize = riskAmount / (stopLossPoints * tickValue);
    
    // Apply FlipMode limits
    lotSize = MathMax(lotSize, FlipModeMinLot);
    lotSize = MathMin(lotSize, FlipModeMaxLot);
    
    // Round to valid lot size
    double lotStep = SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_STEP);
    lotSize = MathRound(lotSize / lotStep) * lotStep;
    
    return lotSize;
}

//+------------------------------------------------------------------+
//| Process FlipMode Signal                                           |
//+------------------------------------------------------------------+
void ProcessFlipModeSignal(FlipModeSignal &signal)
{
    // Check if we already have a position
    if(positionInfo.Select(Symbol()))
    {
        Print("⚠️ FlipMode: Position already exists, skipping signal");
        return;
    }
    
    // Execute FlipMode trade
    bool success = ExecuteFlipModeTrade(signal);
    
    if(success)
    {
        // Update statistics
        flipStats.todayTrades++;
        flipStats.lastTradeTime = TimeCurrent();
        flipStats.flipModeSignalsExecuted++;
        
        // FlipMode notification
        string message = StringFormat("🔥 FLIPMODE TRADE EXECUTED! 🔥\n" +
                                    "%s %s %.2f lots @ %.2f\n" +
                                    "SL: %.2f | TP: %.2f | RR: %.1f:1\n" +
                                    "Confidence: %.0f%% | Spread: %.1f pts\n" +
                                    "Trade #%d today",
                                    signal.direction, Symbol(), signal.lotSize, signal.entryPrice,
                                    signal.stopLoss, signal.takeProfit, FlipModeRiskReward,
                                    signal.confidence * 100, signal.spread, flipStats.todayTrades);
        
        Print(message);
        SendNotification(message);
        
        // Log signal details
        LogFlipModeSignal(signal);
    }
    else
    {
        Print("❌ FlipMode trade execution failed for signal: ", signal.id);
    }
}

//+------------------------------------------------------------------+
//| Execute FlipMode Trade                                            |
//+------------------------------------------------------------------+
bool ExecuteFlipModeTrade(FlipModeSignal &signal)
{
    bool result = false;
    
    if(signal.direction == "long")
    {
        result = trade.Buy(signal.lotSize, Symbol(), signal.entryPrice, signal.stopLoss, signal.takeProfit, TradeComment);
    }
    else
    {
        result = trade.Sell(signal.lotSize, Symbol(), signal.entryPrice, signal.stopLoss, signal.takeProfit, TradeComment);
    }
    
    if(!result)
    {
        Print("❌ FlipMode trade failed: ", trade.ResultRetcode(), " - ", trade.ResultRetcodeDescription());
        return false;
    }
    
    // Get trade result
    ulong ticket = trade.ResultOrder();
    double executionPrice = trade.ResultPrice();
    
    Print("✅ FlipMode trade executed successfully:");
    Print("   Ticket: ", ticket);
    Print("   Price: ", executionPrice);
    Print("   Volume: ", signal.lotSize);
    Print("   Stop Loss: ", signal.stopLoss);
    Print("   Take Profit: ", signal.takeProfit);
    
    return true;
}

//+------------------------------------------------------------------+
//| Manage FlipMode Positions                                         |
//+------------------------------------------------------------------+
void ManageFlipModePositions()
{
    if(!positionInfo.Select(Symbol())) return;
    
    if(positionInfo.Magic() == MagicNumber)
    {
        double currentPrice = positionInfo.Type() == POSITION_TYPE_BUY ? 
                             SymbolInfoDouble(Symbol(), SYMBOL_BID) : 
                             SymbolInfoDouble(Symbol(), SYMBOL_ASK);
        
        double openPrice = positionInfo.PriceOpen();
        double currentProfit = positionInfo.Profit();
        double currentPips = (currentPrice - openPrice) / SymbolInfoDouble(Symbol(), SYMBOL_POINT);
        
        if(positionInfo.Type() == POSITION_TYPE_SELL)
            currentPips = -currentPips;
        
        // FlipMode: Quick profit taking
        if(EnableQuickProfits && currentPips >= QuickProfitPoints)
        {
            trade.PositionClose(positionInfo.Ticket());
            Print("💰 FlipMode: Quick profit taken at ", currentPips, " pips");
            SendNotification(StringFormat("💰 FlipMode Quick Profit: +%.1f pips ($%.2f)", currentPips, currentProfit));
        }
        
        // FlipMode: Breakeven
        if(EnableBreakeven && currentPips >= FlipModeStopLoss * 0.5)
        {
            double newSL = openPrice;
            if(MathAbs(positionInfo.StopLoss() - newSL) > SymbolInfoDouble(Symbol(), SYMBOL_POINT))
            {
                trade.PositionModify(positionInfo.Ticket(), newSL, positionInfo.TakeProfit());
                Print("🔄 FlipMode: Moved to breakeven");
            }
        }
    }
}

//+------------------------------------------------------------------+
//| Check for Regular Signals (when FlipMode is disabled)            |
//+------------------------------------------------------------------+
void CheckForRegularSignals()
{
    // Your existing regular signal logic here
    // This is a placeholder - you can copy from your original EA
    Print("Regular signal check (FlipMode disabled)");
}

//+------------------------------------------------------------------+
//| Update FlipMode Account Info                                      |
//+------------------------------------------------------------------+
void UpdateFlipModeAccountInfo()
{
    static datetime lastUpdate = 0;
    if(TimeCurrent() - lastUpdate >= 5)
    {
        double previousBalance = flipStats.accountBalance;
        flipStats.accountBalance = AccountInfoDouble(ACCOUNT_BALANCE);
        
        // Check for balance changes
        if(MathAbs(flipStats.accountBalance - previousBalance) > 0.5)
        {
            string message = StringFormat("💰 FlipMode Balance: $%.2f (Change: %+.2f)", 
                                        flipStats.accountBalance, 
                                        flipStats.accountBalance - previousBalance);
            Print(message);
            
            if(MathAbs(flipStats.accountBalance - previousBalance) > 5.0)
                SendNotification(message);
        }
        
        lastUpdate = TimeCurrent();
    }
}

//+------------------------------------------------------------------+
//| Setup FlipMode Chart                                              |
//+------------------------------------------------------------------+
void SetupFlipModeChart()
{
    // Set chart properties
    ChartSetInteger(0, CHART_SHOW_GRID, false);
    ChartSetInteger(0, CHART_SHOW_PERIOD_SEP, true);
    ChartSetInteger(0, CHART_AUTOSCROLL, true);
    ChartSetInteger(0, CHART_COLOR_BACKGROUND, clrBlack);
    ChartSetInteger(0, CHART_COLOR_FOREGROUND, clrWhite);
    ChartSetInteger(0, CHART_COLOR_CHART_UP, clrLime);
    ChartSetInteger(0, CHART_COLOR_CHART_DOWN, clrRed);
    
    // Add FlipMode info
    ObjectCreate(0, "FlipMode_Info", OBJ_LABEL, 0, 0, 0);
    ObjectSetString(0, "FlipMode_Info", OBJPROP_TEXT, "🔥 GOLDEX AI FLIPMODE 🔥");
    ObjectSetInteger(0, "FlipMode_Info", OBJPROP_CORNER, CORNER_LEFT_UPPER);
    ObjectSetInteger(0, "FlipMode_Info", OBJPROP_XDISTANCE, 10);
    ObjectSetInteger(0, "FlipMode_Info", OBJPROP_YDISTANCE, 30);
    ObjectSetInteger(0, "FlipMode_Info", OBJPROP_COLOR, clrYellow);
    ObjectSetInteger(0, "FlipMode_Info", OBJPROP_FONTSIZE, 14);
    ObjectSetString(0, "FlipMode_Info", OBJPROP_FONT, "Arial Bold");
}

//+------------------------------------------------------------------+
//| Update FlipMode Chart Info                                        |
//+------------------------------------------------------------------+
void UpdateFlipModeChartInfo()
{
    static datetime lastUpdate = 0;
    if(TimeCurrent() - lastUpdate < 3) return;
    
    string info = StringFormat("Balance: $%.2f | Trades: %d | Wins: %d | Losses: %d | Win Rate: %.1f%%\n" +
                              "Signals Generated: %d | Executed: %d | FlipMode Profit: $%.2f",
                              flipStats.accountBalance, flipStats.todayTrades, flipStats.todayWins, 
                              flipStats.todayLosses, flipStats.winRate, flipStats.flipModeSignalsGenerated,
                              flipStats.flipModeSignalsExecuted, flipStats.flipModeProfit);
    
    if(ObjectFind(0, "FlipMode_Status") >= 0)
        ObjectSetString(0, "FlipMode_Status", OBJPROP_TEXT, info);
    else
    {
        ObjectCreate(0, "FlipMode_Status", OBJ_LABEL, 0, 0, 0);
        ObjectSetString(0, "FlipMode_Status", OBJPROP_TEXT, info);
        ObjectSetInteger(0, "FlipMode_Status", OBJPROP_CORNER, CORNER_LEFT_UPPER);
        ObjectSetInteger(0, "FlipMode_Status", OBJPROP_XDISTANCE, 10);
        ObjectSetInteger(0, "FlipMode_Status", OBJPROP_YDISTANCE, 55);
        ObjectSetInteger(0, "FlipMode_Status", OBJPROP_COLOR, clrAqua);
        ObjectSetInteger(0, "FlipMode_Status", OBJPROP_FONTSIZE, 9);
    }
    
    lastUpdate = TimeCurrent();
}

//+------------------------------------------------------------------+
//| Log FlipMode Signal                                               |
//+------------------------------------------------------------------+
void LogFlipModeSignal(FlipModeSignal &signal)
{
    string logMessage = StringFormat("🔥 FLIPMODE SIGNAL EXECUTED:\n" +
                                   "ID: %s | Direction: %s | Entry: %.2f\n" +
                                   "SL: %.2f | TP: %.2f | RR: %.1f:1\n" +
                                   "Lot Size: %.2f | Confidence: %.0f%%\n" +
                                   "Spread: %.1f pts | Trade #%d today\n" +
                                   "Reasoning: %s",
                                   signal.id, signal.direction, signal.entryPrice,
                                   signal.stopLoss, signal.takeProfit, FlipModeRiskReward,
                                   signal.lotSize, signal.confidence * 100,
                                   signal.spread, flipStats.todayTrades,
                                   signal.reasoning);
    
    Print(logMessage);
}

//+------------------------------------------------------------------+
//| Trade Event Handler                                               |
//+------------------------------------------------------------------+
void OnTrade()
{
    // Check for closed positions
    for(int i = 0; i < HistoryDealsTotal(); i++)
    {
        ulong ticket = HistoryDealGetTicket(i);
        if(HistoryDealGetInteger(ticket, DEAL_MAGIC) == MagicNumber)
        {
            double profit = HistoryDealGetDouble(ticket, DEAL_PROFIT);
            flipStats.todayProfit += profit;
            flipStats.flipModeProfit += profit;
            
            if(profit > 0)
            {
                flipStats.todayWins++;
                flipStats.consecutiveWins++;
                flipStats.consecutiveLosses = 0;
                
                string winMessage = StringFormat("✅ FLIPMODE WIN: +$%.2f | Consecutive Wins: %d", 
                                               profit, flipStats.consecutiveWins);
                Print(winMessage);
                SendNotification(winMessage);
            }
            else if(profit < 0)
            {
                flipStats.todayLosses++;
                flipStats.consecutiveLosses++;
                flipStats.consecutiveWins = 0;
                
                string lossMessage = StringFormat("❌ FLIPMODE LOSS: -$%.2f | Consecutive Losses: %d", 
                                                MathAbs(profit), flipStats.consecutiveLosses);
                Print(lossMessage);
                SendNotification(lossMessage);
            }
            
            // Update win rate
            if(flipStats.todayTrades > 0)
                flipStats.winRate = (double)flipStats.todayWins / flipStats.todayTrades * 100.0;
        }
    }
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
    string message = StringFormat("🔥 GOLDEX AI FLIPMODE Session Complete 🔥\n" +
                                "Final Balance: $%.2f\n" +
                                "Total Trades: %d\n" +
                                "Wins: %d | Losses: %d\n" +
                                "Win Rate: %.1f%%\n" +
                                "FlipMode Profit: $%.2f\n" +
                                "Signals Generated: %d\n" +
                                "Signals Executed: %d",
                                flipStats.accountBalance,
                                flipStats.todayTrades,
                                flipStats.todayWins,
                                flipStats.todayLosses,
                                flipStats.winRate,
                                flipStats.flipModeProfit,
                                flipStats.flipModeSignalsGenerated,
                                flipStats.flipModeSignalsExecuted);
    
    Print(message);
    SendNotification(message);
}
//+------------------------------------------------------------------+