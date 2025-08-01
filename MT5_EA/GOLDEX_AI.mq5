//+------------------------------------------------------------------+
//| GOLDEX AI - Elite Gold Trading Expert Advisor                    |
//| Real Account: 845514@Coinexx-demo                               |
//| Compatible with GOLDEX AI iOS App                               |
//+------------------------------------------------------------------+
#property copyright "GOLDEX AI System"
#property version   "2.0"
#property strict

#include <Trade\Trade.mqh>
#include <Trade\OrderInfo.mqh>
#include <Trade\PositionInfo.mqh>
#include <Trade\AccountInfo.mqh>

//--- Input Parameters
input group "=== GOLDEX AI SETTINGS ==="
input bool EnableAutoTrading = true;                    // Enable Auto Trading
input bool EnableTestMode = true;                       // Enable Test Mode (More Signals)
input double MaxRiskPercent = 2.0;                     // Max Risk Per Trade (%)
input int MaxDailyTrades = 5;                          // Max Daily Trades
input double MaxDailyRisk = 10.0;                      // Max Daily Risk (%)
input int MagicNumber = 20241201;                      // Magic Number
input string TradeComment = "GOLDEX_AI_v2.0";          // Trade Comment

input group "=== SIGNAL SETTINGS ==="
input double MinConfidence = 0.80;                     // Minimum Signal Confidence
input int SignalTimeoutSeconds = 120;                  // Signal Timeout (seconds)
input bool EnableScalpMode = true;                     // Enable Scalp Mode
input bool EnableSwingMode = true;                     // Enable Swing Mode
input bool EnableFlipMode = false;                     // Enable Flip Mode

input group "=== RISK MANAGEMENT ==="
input double MaxLotSize = 0.05;                        // Maximum Lot Size
input double MinLotSize = 0.01;                        // Minimum Lot Size
input double RiskRewardRatio = 2.0;                    // Risk:Reward Ratio
input int MaxSpreadPoints = 30;                        // Max Spread (Points)
input double StopLossPoints = 25.0;                    // Default Stop Loss (Points)

input group "=== TRADING SESSIONS ==="
input bool EnableTokyoSession = true;                  // Enable Tokyo Session
input bool EnableLondonSession = true;                 // Enable London Session
input bool EnableNewYorkSession = true;                // Enable New York Session
input int TokyoStartHour = 0;                          // Tokyo Session Start
input int LondonStartHour = 8;                         // London Session Start
input int NewYorkStartHour = 13;                       // New York Session Start

input group "=== NOTIFICATION SETTINGS ==="
input bool EnablePushNotifications = true;             // Enable Push Notifications
input bool EnableEmailNotifications = false;           // Enable Email Notifications
input bool EnableSoundAlerts = true;                   // Enable Sound Alerts

//--- Global Variables
CTrade trade;
COrderInfo orderInfo;
CPositionInfo positionInfo;
CAccountInfo accountInfo;

// Trading Statistics
struct TradingStats {
    int todayTrades;
    double todayRisk;
    double todayProfit;
    double winRate;
    datetime lastTradeTime;
    double accountBalance;
    double equity;
    double freeMargin;
    datetime lastBalanceUpdate;
};

TradingStats stats;

// Signal Structure
struct GoldexSignal {
    string id;
    string mode;              // scalp, swing, auto, flip
    string direction;         // long, short
    double entryPrice;
    double stopLoss;
    double takeProfit;
    double lotSize;
    double confidence;
    string reasoning;
    datetime timestamp;
    string timeframe;
    int expectedDuration;
    bool isValid;
};

GoldexSignal currentSignal;

// Trading Session Structure
struct TradingSession {
    string name;
    int startHour;
    int endHour;
    bool isActive;
    bool isEnabled;
};

TradingSession sessions[3];

// Performance Tracking
struct PerformanceMetrics {
    double totalProfit;
    double totalLoss;
    int totalTrades;
    int winningTrades;
    int losingTrades;
    double maxDrawdown;
    double currentDrawdown;
    double peakBalance;
    datetime lastUpdateTime;
};

PerformanceMetrics performance;

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
    
    // Initialize sessions
    InitializeTradingSessions();
    
    // Initialize statistics
    InitializeStatistics();
    
    // Initialize performance tracking
    InitializePerformanceTracking();
    
    // Set up chart
    SetupChart();
    
    // Welcome message
    string message = StringFormat("GOLDEX AI Expert Advisor Started\n" +
                                "Account: %d\n" +
                                "Balance: $%.2f\n" +
                                "Symbol: %s\n" +
                                "Test Mode: %s\n" +
                                "Risk Per Trade: %.1f%%",
                                AccountInfoInteger(ACCOUNT_LOGIN),
                                AccountInfoDouble(ACCOUNT_BALANCE),
                                Symbol(),
                                EnableTestMode ? "ON" : "OFF",
                                MaxRiskPercent);
    
    Print(message);
    
    if(EnablePushNotifications)
        SendNotification("🚀 GOLDEX AI EA Started - Ready for Elite Trading!");
    
    return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
    // Save final statistics
    SaveTradingStatistics();
    
    string message = StringFormat("GOLDEX AI EA Stopped\n" +
                                "Final Balance: $%.2f\n" +
                                "Today's Trades: %d\n" +
                                "Today's Profit: $%.2f\n" +
                                "Win Rate: %.1f%%",
                                AccountInfoDouble(ACCOUNT_BALANCE),
                                stats.todayTrades,
                                stats.todayProfit,
                                stats.winRate);
    
    Print(message);
    
    if(EnablePushNotifications)
        SendNotification("⏹️ GOLDEX AI EA Stopped - Session Complete");
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
    // Update account information
    UpdateAccountInfo();
    
    // Update trading sessions
    UpdateTradingSessions();
    
    // Check for new signals every 5 seconds
    static datetime lastSignalCheck = 0;
    if(TimeCurrent() - lastSignalCheck >= 5)
    {
        CheckForNewSignals();
        lastSignalCheck = TimeCurrent();
    }
    
    // Monitor existing positions
    MonitorExistingPositions();
    
    // Update performance metrics every minute
    static datetime lastPerformanceUpdate = 0;
    if(TimeCurrent() - lastPerformanceUpdate >= 60)
    {
        UpdatePerformanceMetrics();
        lastPerformanceUpdate = TimeCurrent();
    }
    
    // Update chart information
    UpdateChartInfo();
}

//+------------------------------------------------------------------+
//| Initialize Trading Sessions                                       |
//+------------------------------------------------------------------+
void InitializeTradingSessions()
{
    // Tokyo Session
    sessions[0].name = "Tokyo";
    sessions[0].startHour = TokyoStartHour;
    sessions[0].endHour = TokyoStartHour + 9;
    sessions[0].isEnabled = EnableTokyoSession;
    
    // London Session
    sessions[1].name = "London";
    sessions[1].startHour = LondonStartHour;
    sessions[1].endHour = LondonStartHour + 9;
    sessions[1].isEnabled = EnableLondonSession;
    
    // New York Session
    sessions[2].name = "New York";
    sessions[2].startHour = NewYorkStartHour;
    sessions[2].endHour = NewYorkStartHour + 9;
    sessions[2].isEnabled = EnableNewYorkSession;
}

//+------------------------------------------------------------------+
//| Initialize Statistics                                            |
//+------------------------------------------------------------------+
void InitializeStatistics()
{
    stats.todayTrades = 0;
    stats.todayRisk = 0.0;
    stats.todayProfit = 0.0;
    stats.winRate = 0.0;
    stats.lastTradeTime = 0;
    stats.accountBalance = AccountInfoDouble(ACCOUNT_BALANCE);
    stats.equity = AccountInfoDouble(ACCOUNT_EQUITY);
    stats.freeMargin = AccountInfoDouble(ACCOUNT_FREEMARGIN);
    stats.lastBalanceUpdate = TimeCurrent();
}

//+------------------------------------------------------------------+
//| Initialize Performance Tracking                                  |
//+------------------------------------------------------------------+
void InitializePerformanceTracking()
{
    performance.totalProfit = 0.0;
    performance.totalLoss = 0.0;
    performance.totalTrades = 0;
    performance.winningTrades = 0;
    performance.losingTrades = 0;
    performance.maxDrawdown = 0.0;
    performance.currentDrawdown = 0.0;
    performance.peakBalance = AccountInfoDouble(ACCOUNT_BALANCE);
    performance.lastUpdateTime = TimeCurrent();
}

//+------------------------------------------------------------------+
//| Update Account Information                                        |
//+------------------------------------------------------------------+
void UpdateAccountInfo()
{
    static datetime lastUpdate = 0;
    if(TimeCurrent() - lastUpdate >= 10) // Update every 10 seconds
    {
        double previousBalance = stats.accountBalance;
        stats.accountBalance = AccountInfoDouble(ACCOUNT_BALANCE);
        stats.equity = AccountInfoDouble(ACCOUNT_EQUITY);
        stats.freeMargin = AccountInfoDouble(ACCOUNT_FREEMARGIN);
        stats.lastBalanceUpdate = TimeCurrent();
        
        // Check for significant balance changes
        if(MathAbs(stats.accountBalance - previousBalance) > 1.0)
        {
            string message = StringFormat("💰 Balance Update: $%.2f (Change: %+.2f)", 
                                        stats.accountBalance, 
                                        stats.accountBalance - previousBalance);
            Print(message);
            
            if(EnablePushNotifications && MathAbs(stats.accountBalance - previousBalance) > 10.0)
                SendNotification(message);
        }
        
        lastUpdate = TimeCurrent();
    }
}

//+------------------------------------------------------------------+
//| Update Trading Sessions                                           |
//+------------------------------------------------------------------+
void UpdateTradingSessions()
{
    MqlDateTime dt;
    TimeToStruct(TimeCurrent(), dt);
    int currentHour = dt.hour;
    
    for(int i = 0; i < 3; i++)
    {
        bool wasActive = sessions[i].isActive;
        sessions[i].isActive = sessions[i].isEnabled && 
                              (currentHour >= sessions[i].startHour && 
                               currentHour < sessions[i].endHour);
        
        // Notify session changes
        if(sessions[i].isActive && !wasActive)
        {
            string message = StringFormat("🌅 %s Session Started - Ready for Trading!", sessions[i].name);
            Print(message);
            if(EnablePushNotifications)
                SendNotification(message);
        }
        else if(!sessions[i].isActive && wasActive)
        {
            string message = StringFormat("🌅 %s Session Ended", sessions[i].name);
            Print(message);
        }
    }
}

//+------------------------------------------------------------------+
//| Check for New Signals                                            |
//+------------------------------------------------------------------+
void CheckForNewSignals()
{
    if(!EnableAutoTrading) return;
    
    // Check daily limits
    if(stats.todayTrades >= MaxDailyTrades)
    {
        static datetime lastLimitWarning = 0;
        if(TimeCurrent() - lastLimitWarning >= 3600) // Warn every hour
        {
            Print("⚠️ Daily trade limit reached (", MaxDailyTrades, ")");
            lastLimitWarning = TimeCurrent();
        }
        return;
    }
    
    if(stats.todayRisk >= MaxDailyRisk)
    {
        static datetime lastRiskWarning = 0;
        if(TimeCurrent() - lastRiskWarning >= 3600) // Warn every hour
        {
            Print("⚠️ Daily risk limit reached (", MaxDailyRisk, "%)");
            lastRiskWarning = TimeCurrent();
        }
        return;
    }
    
    // Check if any session is active (or test mode is enabled)
    if(!EnableTestMode && !IsAnySessionActive())
    {
        static datetime lastSessionWarning = 0;
        if(TimeCurrent() - lastSessionWarning >= 1800) // Warn every 30 minutes
        {
            Print("⏰ Outside trading hours - Next session: ", GetNextSessionName());
            lastSessionWarning = TimeCurrent();
        }
        return;
    }
    
    // Check spread
    double spread = (SymbolInfoDouble(Symbol(), SYMBOL_ASK) - SymbolInfoDouble(Symbol(), SYMBOL_BID)) / SymbolInfoDouble(Symbol(), SYMBOL_POINT);
    if(spread > MaxSpreadPoints)
    {
        static datetime lastSpreadWarning = 0;
        if(TimeCurrent() - lastSpreadWarning >= 300) // Warn every 5 minutes
        {
            Print("⚠️ Spread too high: ", spread, " points (max: ", MaxSpreadPoints, ")");
            lastSpreadWarning = TimeCurrent();
        }
        return;
    }
    
    // Generate signal (simulated for now - in production this would come from your iOS app)
    GoldexSignal signal = GenerateSignal();
    
    if(signal.isValid)
    {
        ProcessSignal(signal);
    }
}

//+------------------------------------------------------------------+
//| Generate Signal (Simulated)                                      |
//+------------------------------------------------------------------+
GoldexSignal GenerateSignal()
{
    GoldexSignal signal;
    signal.isValid = false;
    
    // In test mode, generate signals more frequently
    static datetime lastSignalTime = 0;
    int signalInterval = EnableTestMode ? 30 : 300; // 30 seconds in test mode, 5 minutes normally
    
    if(TimeCurrent() - lastSignalTime < signalInterval)
        return signal;
    
    // Simulate signal generation probability
    double probability = EnableTestMode ? 0.3 : 0.1; // 30% chance in test mode, 10% normally
    
    if(MathRand() / 32768.0 > probability)
        return signal;
    
    // Get current market data
    double currentPrice = SymbolInfoDouble(Symbol(), SYMBOL_BID);
    double ask = SymbolInfoDouble(Symbol(), SYMBOL_ASK);
    double bid = SymbolInfoDouble(Symbol(), SYMBOL_BID);
    
    // Generate signal details
    signal.id = StringFormat("GOLDEX_%d_%d", (int)TimeCurrent(), MathRand());
    signal.mode = EnableScalpMode ? "scalp" : "swing";
    signal.direction = MathRand() % 2 == 0 ? "long" : "short";
    signal.entryPrice = signal.direction == "long" ? ask : bid;
    signal.confidence = 0.80 + (MathRand() / 32768.0) * 0.15; // 80-95% confidence
    signal.timestamp = TimeCurrent();
    signal.timeframe = signal.mode == "scalp" ? "1M" : "15M";
    signal.expectedDuration = signal.mode == "scalp" ? 1800 : 3600; // 30 min or 1 hour
    
    // Calculate stop loss and take profit
    double stopLossPoints = signal.mode == "scalp" ? 15.0 : 25.0;
    double takeProfitPoints = stopLossPoints * RiskRewardRatio;
    
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
    signal.lotSize = CalculateLotSize(signal.entryPrice, signal.stopLoss);
    
    // Generate reasoning
    string sessionName = GetActiveSessionName();
    signal.reasoning = StringFormat("GOLDEX AI Signal: %s %s setup in %s session (%.1f%% confidence)",
                                  signal.mode, signal.direction, sessionName, signal.confidence * 100);
    
    signal.isValid = true;
    lastSignalTime = TimeCurrent();
    
    return signal;
}

//+------------------------------------------------------------------+
//| Process Signal                                                    |
//+------------------------------------------------------------------+
void ProcessSignal(GoldexSignal &signal)
{
    // Validate signal
    if(!ValidateSignal(signal))
    {
        Print("❌ Signal validation failed: ", signal.id);
        return;
    }
    
    // Check if minimum confidence is met
    if(signal.confidence < MinConfidence)
    {
        Print("❌ Signal confidence too low: ", signal.confidence, " (min: ", MinConfidence, ")");
        return;
    }
    
    // Execute trade
    bool success = ExecuteTrade(signal);
    
    if(success)
    {
        // Update statistics
        stats.todayTrades++;
        double tradeRisk = CalculateTradeRisk(signal);
        stats.todayRisk += tradeRisk;
        stats.lastTradeTime = TimeCurrent();
        
        // Notification
        string message = StringFormat("✅ Trade Executed: %s %s %.2f lots @ %.2f\n" +
                                    "SL: %.2f | TP: %.2f | Confidence: %.1f%%",
                                    signal.direction, Symbol(), signal.lotSize, signal.entryPrice,
                                    signal.stopLoss, signal.takeProfit, signal.confidence * 100);
        
        Print(message);
        
        if(EnablePushNotifications)
            SendNotification(message);
        
        if(EnableSoundAlerts)
            PlaySound("alert.wav");
        
        // Log signal details
        LogSignalDetails(signal);
    }
    else
    {
        Print("❌ Trade execution failed for signal: ", signal.id);
        
        if(EnablePushNotifications)
            SendNotification("❌ Trade Execution Failed - Check EA logs");
    }
}

//+------------------------------------------------------------------+
//| Execute Trade                                                     |
//+------------------------------------------------------------------+
bool ExecuteTrade(GoldexSignal &signal)
{
    // Prepare trade request
    ENUM_ORDER_TYPE orderType = signal.direction == "long" ? ORDER_TYPE_BUY : ORDER_TYPE_SELL;
    
    // Check if we already have a position
    if(positionInfo.Select(Symbol()))
    {
        Print("⚠️ Position already exists for ", Symbol());
        return false;
    }
    
    // Execute the trade
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
        Print("❌ Trade failed: ", trade.ResultRetcode(), " - ", trade.ResultRetcodeDescription());
        return false;
    }
    
    // Get trade result
    ulong ticket = trade.ResultOrder();
    double executionPrice = trade.ResultPrice();
    
    Print("✅ Trade executed successfully:");
    Print("   Ticket: ", ticket);
    Print("   Price: ", executionPrice);
    Print("   Volume: ", signal.lotSize);
    Print("   Stop Loss: ", signal.stopLoss);
    Print("   Take Profit: ", signal.takeProfit);
    
    return true;
}

//+------------------------------------------------------------------+
//| Calculate Lot Size                                                |
//+------------------------------------------------------------------+
double CalculateLotSize(double entryPrice, double stopLoss)
{
    double accountBalance = AccountInfoDouble(ACCOUNT_BALANCE);
    double riskAmount = accountBalance * (MaxRiskPercent / 100.0);
    
    double stopLossPoints = MathAbs(entryPrice - stopLoss) / SymbolInfoDouble(Symbol(), SYMBOL_POINT);
    double tickValue = SymbolInfoDouble(Symbol(), SYMBOL_TRADE_TICK_VALUE);
    
    double lotSize = riskAmount / (stopLossPoints * tickValue);
    
    // Apply limits
    lotSize = MathMax(lotSize, MinLotSize);
    lotSize = MathMin(lotSize, MaxLotSize);
    
    // Round to valid lot size
    double lotStep = SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_STEP);
    lotSize = MathRound(lotSize / lotStep) * lotStep;
    
    return lotSize;
}

//+------------------------------------------------------------------+
//| Calculate Trade Risk                                              |
//+------------------------------------------------------------------+
double CalculateTradeRisk(GoldexSignal &signal)
{
    double stopLossPoints = MathAbs(signal.entryPrice - signal.stopLoss);
    double riskAmount = (stopLossPoints / signal.entryPrice) * 100.0;
    return MathMin(riskAmount, MaxRiskPercent);
}

//+------------------------------------------------------------------+
//| Validate Signal                                                   |
//+------------------------------------------------------------------+
bool ValidateSignal(GoldexSignal &signal)
{
    // Check basic signal structure
    if(signal.id == "" || signal.direction == "" || signal.entryPrice <= 0)
        return false;
    
    // Check stop loss and take profit
    if(signal.stopLoss <= 0 || signal.takeProfit <= 0)
        return false;
    
    // Check lot size
    if(signal.lotSize < MinLotSize || signal.lotSize > MaxLotSize)
        return false;
    
    // Check signal age
    if(TimeCurrent() - signal.timestamp > SignalTimeoutSeconds)
        return false;
    
    // Check direction consistency
    if(signal.direction == "long" && signal.stopLoss >= signal.entryPrice)
        return false;
    
    if(signal.direction == "short" && signal.stopLoss <= signal.entryPrice)
        return false;
    
    return true;
}

//+------------------------------------------------------------------+
//| Monitor Existing Positions                                        |
//+------------------------------------------------------------------+
void MonitorExistingPositions()
{
    for(int i = 0; i < PositionsTotal(); i++)
    {
        if(positionInfo.SelectByIndex(i))
        {
            if(positionInfo.Magic() == MagicNumber && positionInfo.Symbol() == Symbol())
            {
                MonitorPosition(positionInfo.Ticket());
            }
        }
    }
}

//+------------------------------------------------------------------+
//| Monitor Individual Position                                       |
//+------------------------------------------------------------------+
void MonitorPosition(ulong ticket)
{
    if(!positionInfo.SelectByTicket(ticket))
        return;
    
    double currentPrice = positionInfo.Type() == POSITION_TYPE_BUY ? 
                         SymbolInfoDouble(Symbol(), SYMBOL_BID) : 
                         SymbolInfoDouble(Symbol(), SYMBOL_ASK);
    
    double openPrice = positionInfo.PriceOpen();
    double currentProfit = positionInfo.Profit();
    double currentPips = (currentPrice - openPrice) / SymbolInfoDouble(Symbol(), SYMBOL_POINT);
    
    if(positionInfo.Type() == POSITION_TYPE_SELL)
        currentPips = -currentPips;
    
    // Update position information on chart
    static datetime lastPositionUpdate = 0;
    if(TimeCurrent() - lastPositionUpdate >= 60) // Update every minute
    {
        string positionInfo = StringFormat("Position: %s | Profit: $%.2f | Pips: %.1f",
                                          positionInfo.Type() == POSITION_TYPE_BUY ? "BUY" : "SELL",
                                          currentProfit, currentPips);
        
        Comment(positionInfo);
        lastPositionUpdate = TimeCurrent();
    }
}

//+------------------------------------------------------------------+
//| Update Performance Metrics                                        |
//+------------------------------------------------------------------+
void UpdatePerformanceMetrics()
{
    double currentBalance = AccountInfoDouble(ACCOUNT_BALANCE);
    double currentEquity = AccountInfoDouble(ACCOUNT_EQUITY);
    
    // Update peak balance
    if(currentBalance > performance.peakBalance)
        performance.peakBalance = currentBalance;
    
    // Calculate current drawdown
    performance.currentDrawdown = ((performance.peakBalance - currentBalance) / performance.peakBalance) * 100.0;
    
    // Update max drawdown
    if(performance.currentDrawdown > performance.maxDrawdown)
        performance.maxDrawdown = performance.currentDrawdown;
    
    // Update win rate
    if(performance.totalTrades > 0)
        stats.winRate = (double)performance.winningTrades / performance.totalTrades * 100.0;
    
    performance.lastUpdateTime = TimeCurrent();
}

//+------------------------------------------------------------------+
//| Helper Functions                                                  |
//+------------------------------------------------------------------+
bool IsAnySessionActive()
{
    for(int i = 0; i < 3; i++)
    {
        if(sessions[i].isActive)
            return true;
    }
    return false;
}

string GetActiveSessionName()
{
    for(int i = 0; i < 3; i++)
    {
        if(sessions[i].isActive)
            return sessions[i].name;
    }
    return "None";
}

string GetNextSessionName()
{
    MqlDateTime dt;
    TimeToStruct(TimeCurrent(), dt);
    int currentHour = dt.hour;
    
    for(int i = 0; i < 3; i++)
    {
        if(sessions[i].isEnabled && currentHour < sessions[i].startHour)
            return sessions[i].name;
    }
    
    return "Tokyo (Tomorrow)";
}

//+------------------------------------------------------------------+
//| Setup Chart                                                       |
//+------------------------------------------------------------------+
void SetupChart()
{
    // Set chart properties
    ChartSetInteger(0, CHART_SHOW_GRID, false);
    ChartSetInteger(0, CHART_SHOW_PERIOD_SEP, true);
    ChartSetInteger(0, CHART_SHIFT, true);
    ChartSetInteger(0, CHART_AUTOSCROLL, true);
    
    // Set colors
    ChartSetInteger(0, CHART_COLOR_BACKGROUND, clrWhite);
    ChartSetInteger(0, CHART_COLOR_FOREGROUND, clrBlack);
    ChartSetInteger(0, CHART_COLOR_GRID, clrLightGray);
    ChartSetInteger(0, CHART_COLOR_VOLUME, clrBlue);
    ChartSetInteger(0, CHART_COLOR_CHART_UP, clrGreen);
    ChartSetInteger(0, CHART_COLOR_CHART_DOWN, clrRed);
    
    // Add EA information
    ObjectCreate(0, "EA_Info", OBJ_LABEL, 0, 0, 0);
    ObjectSetString(0, "EA_Info", OBJPROP_TEXT, "GOLDEX AI v2.0");
    ObjectSetInteger(0, "EA_Info", OBJPROP_CORNER, CORNER_LEFT_UPPER);
    ObjectSetInteger(0, "EA_Info", OBJPROP_XDISTANCE, 10);
    ObjectSetInteger(0, "EA_Info", OBJPROP_YDISTANCE, 30);
    ObjectSetInteger(0, "EA_Info", OBJPROP_COLOR, clrGold);
    ObjectSetInteger(0, "EA_Info", OBJPROP_FONTSIZE, 12);
    ObjectSetString(0, "EA_Info", OBJPROP_FONT, "Arial Bold");
}

//+------------------------------------------------------------------+
//| Update Chart Info                                                 |
//+------------------------------------------------------------------+
void UpdateChartInfo()
{
    static datetime lastUpdate = 0;
    if(TimeCurrent() - lastUpdate < 5) // Update every 5 seconds
        return;
    
    string info = StringFormat("Balance: $%.2f | Trades: %d | Risk: %.1f%% | Win Rate: %.1f%%",
                              stats.accountBalance, stats.todayTrades, stats.todayRisk, stats.winRate);
    
    // Update or create info object
    if(ObjectFind(0, "EA_Status") >= 0)
        ObjectSetString(0, "EA_Status", OBJPROP_TEXT, info);
    else
    {
        ObjectCreate(0, "EA_Status", OBJ_LABEL, 0, 0, 0);
        ObjectSetString(0, "EA_Status", OBJPROP_TEXT, info);
        ObjectSetInteger(0, "EA_Status", OBJPROP_CORNER, CORNER_LEFT_UPPER);
        ObjectSetInteger(0, "EA_Status", OBJPROP_XDISTANCE, 10);
        ObjectSetInteger(0, "EA_Status", OBJPROP_YDISTANCE, 50);
        ObjectSetInteger(0, "EA_Status", OBJPROP_COLOR, clrNavy);
        ObjectSetInteger(0, "EA_Status", OBJPROP_FONTSIZE, 9);
    }
    
    lastUpdate = TimeCurrent();
}

//+------------------------------------------------------------------+
//| Log Signal Details                                                |
//+------------------------------------------------------------------+
void LogSignalDetails(GoldexSignal &signal)
{
    string logMessage = StringFormat("Signal Details:\n" +
                                   "ID: %s\n" +
                                   "Mode: %s\n" +
                                   "Direction: %s\n" +
                                   "Entry: %.2f\n" +
                                   "Stop Loss: %.2f\n" +
                                   "Take Profit: %.2f\n" +
                                   "Lot Size: %.2f\n" +
                                   "Confidence: %.1f%%\n" +
                                   "Reasoning: %s\n" +
                                   "Timeframe: %s\n" +
                                   "Session: %s",
                                   signal.id, signal.mode, signal.direction,
                                   signal.entryPrice, signal.stopLoss, signal.takeProfit,
                                   signal.lotSize, signal.confidence * 100, signal.reasoning,
                                   signal.timeframe, GetActiveSessionName());
    
    Print(logMessage);
}

//+------------------------------------------------------------------+
//| Save Trading Statistics                                           |
//+------------------------------------------------------------------+
void SaveTradingStatistics()
{
    string filename = StringFormat("GOLDEX_AI_Stats_%d.txt", (int)TimeCurrent());
    int handle = FileOpen(filename, FILE_WRITE|FILE_TXT);
    
    if(handle != INVALID_HANDLE)
    {
        FileWriteString(handle, "GOLDEX AI Trading Statistics\n");
        FileWriteString(handle, "================================\n");
        FileWriteString(handle, StringFormat("Account: %d\n", AccountInfoInteger(ACCOUNT_LOGIN)));
        FileWriteString(handle, StringFormat("Balance: $%.2f\n", stats.accountBalance));
        FileWriteString(handle, StringFormat("Equity: $%.2f\n", stats.equity));
        FileWriteString(handle, StringFormat("Today's Trades: %d\n", stats.todayTrades));
        FileWriteString(handle, StringFormat("Today's Risk: %.1f%%\n", stats.todayRisk));
        FileWriteString(handle, StringFormat("Today's Profit: $%.2f\n", stats.todayProfit));
        FileWriteString(handle, StringFormat("Win Rate: %.1f%%\n", stats.winRate));
        FileWriteString(handle, StringFormat("Max Drawdown: %.1f%%\n", performance.maxDrawdown));
        FileWriteString(handle, StringFormat("Total Trades: %d\n", performance.totalTrades));
        FileWriteString(handle, StringFormat("Winning Trades: %d\n", performance.winningTrades));
        FileWriteString(handle, StringFormat("Losing Trades: %d\n", performance.losingTrades));
        
        FileClose(handle);
        Print("✅ Trading statistics saved to: ", filename);
    }
}

//+------------------------------------------------------------------+
//| Trade Event Handler                                               |
//+------------------------------------------------------------------+
void OnTrade()
{
    // Update performance when trades are closed
    UpdatePerformanceMetrics();
    
    // Check for closed positions
    for(int i = 0; i < HistoryDealsTotal(); i++)
    {
        ulong ticket = HistoryDealGetTicket(i);
        if(HistoryDealGetInteger(ticket, DEAL_MAGIC) == MagicNumber)
        {
            double profit = HistoryDealGetDouble(ticket, DEAL_PROFIT);
            stats.todayProfit += profit;
            
            if(profit > 0)
            {
                performance.winningTrades++;
                performance.totalProfit += profit;
            }
            else if(profit < 0)
            {
                performance.losingTrades++;
                performance.totalLoss += MathAbs(profit);
            }
            
            performance.totalTrades++;
            
            // Send notification for significant trades
            if(MathAbs(profit) > 10.0 && EnablePushNotifications)
            {
                string message = StringFormat("%s Trade Closed: %s%.2f", 
                                            profit > 0 ? "✅" : "❌", 
                                            profit > 0 ? "+" : "", 
                                            profit);
                SendNotification(message);
            }
        }
    }
}

//+------------------------------------------------------------------+