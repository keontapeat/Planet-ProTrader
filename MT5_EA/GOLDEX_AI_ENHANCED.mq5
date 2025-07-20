//+------------------------------------------------------------------+
//| GOLDEX AI - Enhanced Performance Expert Advisor                  |
//| Real Account: 845514@Coinexx-demo                               |
//| High Win Rate Optimization System                               |
//+------------------------------------------------------------------+
#property copyright "GOLDEX AI Enhanced System"
#property version   "3.0"
#property strict

#include <Trade\Trade.mqh>
#include <Trade\OrderInfo.mqh>
#include <Trade\PositionInfo.mqh>
#include <Trade\AccountInfo.mqh>

//--- Enhanced Input Parameters
input group "=== GOLDEX AI ENHANCED SETTINGS ==="
input bool EnableAutoTrading = true;                    // Enable Auto Trading
input bool EnableHighWinRateMode = true;               // Enable High Win Rate Mode
input double MaxRiskPercent = 1.0;                     // Max Risk Per Trade (%) - Reduced for better RR
input int MaxDailyTrades = 3;                          // Max Daily Trades - Reduced for quality
input double MaxDailyRisk = 5.0;                       // Max Daily Risk (%) - Reduced
input int MagicNumber = 20241201;                      // Magic Number
input string TradeComment = "GOLDEX_AI_v3.0";          // Trade Comment

input group "=== ENHANCED SIGNAL SETTINGS ==="
input double MinConfidence = 0.85;                     // Minimum Signal Confidence - Increased
input int SignalCooldownMinutes = 30;                  // Signal Cooldown (minutes)
input bool EnableSmartFiltering = true;                // Enable Smart Signal Filtering
input bool EnableMarketStructureFilter = true;         // Enable Market Structure Filter
input bool EnableVolumeFilter = true;                  // Enable Volume Filter
input bool EnableVolatilityFilter = true;              // Enable Volatility Filter

input group "=== ENHANCED RISK MANAGEMENT ==="
input double MaxLotSize = 0.02;                        // Maximum Lot Size - Reduced
input double MinLotSize = 0.01;                        // Minimum Lot Size
input double BaseRiskRewardRatio = 3.0;                // Base Risk:Reward Ratio - Increased
input double DynamicRRMultiplier = 1.5;                // Dynamic RR Multiplier
input int MaxSpreadPoints = 20;                        // Max Spread (Points) - Reduced
input double ATRMultiplier = 1.5;                      // ATR Multiplier for Dynamic SL
input bool EnableTrailingStop = true;                  // Enable Trailing Stop
input double TrailingStopATR = 2.0;                    // Trailing Stop ATR Multiplier

input group "=== MARKET TIMING SETTINGS ==="
input bool EnableSessionFilter = true;                 // Enable Session Filter
input bool OnlyTradeHighVolatility = true;             // Only Trade High Volatility
input int MinTimeBetweenTrades = 60;                   // Min Time Between Trades (minutes)
input bool AvoidNews = true;                           // Avoid News Events
input bool EnableLiquidityFilter = true;               // Enable Liquidity Filter

input group "=== TECHNICAL ANALYSIS SETTINGS ==="
input int ATRPeriod = 14;                              // ATR Period
input int RSIPeriod = 14;                              // RSI Period
input int MACDFast = 12;                               // MACD Fast Period
input int MACDSlow = 26;                               // MACD Slow Period
input int MACDSignal = 9;                              // MACD Signal Period
input int BBPeriod = 20;                               // Bollinger Bands Period
input double BBDeviation = 2.0;                        // Bollinger Bands Deviation

//--- Global Variables
CTrade trade;
COrderInfo orderInfo;
CPositionInfo positionInfo;
CAccountInfo accountInfo;

// Enhanced Trading Statistics
struct EnhancedTradingStats {
    int todayTrades;
    int todayWins;
    int todayLosses;
    double todayRisk;
    double todayProfit;
    double winRate;
    double actualWinRate;
    double avgWinSize;
    double avgLossSize;
    double profitFactor;
    datetime lastTradeTime;
    double accountBalance;
    double equity;
    double freeMargin;
    double maxDrawdown;
    double currentDrawdown;
    double peakBalance;
    datetime lastBalanceUpdate;
    double dailyPnL;
    int consecutiveWins;
    int consecutiveLosses;
    double riskAdjustedReturn;
};

EnhancedTradingStats enhancedStats;

// Enhanced Signal Structure
struct EnhancedGoldexSignal {
    string id;
    string mode;
    string direction;
    double entryPrice;
    double stopLoss;
    double takeProfit;
    double lotSize;
    double confidence;
    double atr;
    double rsi;
    double macd;
    double bbDistance;
    double volatility;
    double volume;
    double spread;
    string reasoning;
    datetime timestamp;
    string timeframe;
    int expectedDuration;
    bool isValid;
    double qualityScore;
    double riskReward;
    string marketStructure;
    string sessionName;
    bool passedAllFilters;
};

EnhancedGoldexSignal currentSignal;

// Market Analysis Structure
struct MarketAnalysis {
    double atr;
    double rsi;
    double macd;
    double macdSignal;
    double macdHistogram;
    double bbUpper;
    double bbLower;
    double bbMiddle;
    double currentPrice;
    double spread;
    double volatility;
    double volume;
    string marketTrend;
    string marketStructure;
    double supportLevel;
    double resistanceLevel;
    bool isHighVolatility;
    bool isLiquidityHigh;
    string activeSession;
    datetime analysisTime;
};

MarketAnalysis marketAnalysis;

// Trade Quality Metrics
struct TradeQuality {
    double entryQuality;
    double timingQuality;
    double riskRewardQuality;
    double marketConditionQuality;
    double overallQuality;
    string qualityRating;
};

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
    // Initialize enhanced trading object
    trade.SetExpertMagicNumber(MagicNumber);
    trade.SetMarginMode();
    trade.SetTypeFillingBySymbol(Symbol());
    trade.SetDeviationInPoints(5); // Reduced deviation for better fills
    
    // Initialize enhanced statistics
    InitializeEnhancedStatistics();
    
    // Set up enhanced chart
    SetupEnhancedChart();
    
    // Initialize market analysis
    InitializeMarketAnalysis();
    
    // Welcome message
    string message = StringFormat("🚀 GOLDEX AI ENHANCED v3.0 Started\n" +
                                "Account: %d\n" +
                                "Balance: $%.2f\n" +
                                "Symbol: %s\n" +
                                "High Win Rate Mode: %s\n" +
                                "Max Risk Per Trade: %.1f%%\n" +
                                "Target Win Rate: 80%+",
                                AccountInfoInteger(ACCOUNT_LOGIN),
                                AccountInfoDouble(ACCOUNT_BALANCE),
                                Symbol(),
                                EnableHighWinRateMode ? "ON" : "OFF",
                                MaxRiskPercent);
    
    Print(message);
    
    SendNotification("🔥 GOLDEX AI ENHANCED Started - Targeting 80%+ Win Rate!");
    
    return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
    // Update enhanced account information
    UpdateEnhancedAccountInfo();
    
    // Perform comprehensive market analysis
    static datetime lastAnalysis = 0;
    if(TimeCurrent() - lastAnalysis >= 60) // Analyze every minute
    {
        PerformMarketAnalysis();
        lastAnalysis = TimeCurrent();
    }
    
    // Check for new high-quality signals
    static datetime lastSignalCheck = 0;
    if(TimeCurrent() - lastSignalCheck >= 30) // Check every 30 seconds
    {
        CheckForHighQualitySignals();
        lastSignalCheck = TimeCurrent();
    }
    
    // Monitor and manage existing positions
    ManageExistingPositions();
    
    // Update performance metrics
    static datetime lastPerformanceUpdate = 0;
    if(TimeCurrent() - lastPerformanceUpdate >= 300) // Update every 5 minutes
    {
        UpdateEnhancedPerformanceMetrics();
        lastPerformanceUpdate = TimeCurrent();
    }
    
    // Update enhanced chart information
    UpdateEnhancedChartInfo();
}

//+------------------------------------------------------------------+
//| Initialize Enhanced Statistics                                   |
//+------------------------------------------------------------------+
void InitializeEnhancedStatistics()
{
    enhancedStats.todayTrades = 0;
    enhancedStats.todayWins = 0;
    enhancedStats.todayLosses = 0;
    enhancedStats.todayRisk = 0.0;
    enhancedStats.todayProfit = 0.0;
    enhancedStats.winRate = 0.0;
    enhancedStats.actualWinRate = 0.0;
    enhancedStats.avgWinSize = 0.0;
    enhancedStats.avgLossSize = 0.0;
    enhancedStats.profitFactor = 0.0;
    enhancedStats.lastTradeTime = 0;
    enhancedStats.accountBalance = AccountInfoDouble(ACCOUNT_BALANCE);
    enhancedStats.equity = AccountInfoDouble(ACCOUNT_EQUITY);
    enhancedStats.freeMargin = AccountInfoDouble(ACCOUNT_FREEMARGIN);
    enhancedStats.maxDrawdown = 0.0;
    enhancedStats.currentDrawdown = 0.0;
    enhancedStats.peakBalance = AccountInfoDouble(ACCOUNT_BALANCE);
    enhancedStats.lastBalanceUpdate = TimeCurrent();
    enhancedStats.dailyPnL = 0.0;
    enhancedStats.consecutiveWins = 0;
    enhancedStats.consecutiveLosses = 0;
    enhancedStats.riskAdjustedReturn = 0.0;
}

//+------------------------------------------------------------------+
//| Perform Comprehensive Market Analysis                            |
//+------------------------------------------------------------------+
void PerformMarketAnalysis()
{
    // Calculate ATR
    double atr_array[];
    int atr_handle = iATR(Symbol(), PERIOD_CURRENT, ATRPeriod);
    if(CopyBuffer(atr_handle, 0, 0, 1, atr_array) > 0)
        marketAnalysis.atr = atr_array[0];
    
    // Calculate RSI
    double rsi_array[];
    int rsi_handle = iRSI(Symbol(), PERIOD_CURRENT, RSIPeriod, PRICE_CLOSE);
    if(CopyBuffer(rsi_handle, 0, 0, 1, rsi_array) > 0)
        marketAnalysis.rsi = rsi_array[0];
    
    // Calculate MACD
    double macd_main[], macd_signal[];
    int macd_handle = iMACD(Symbol(), PERIOD_CURRENT, MACDFast, MACDSlow, MACDSignal, PRICE_CLOSE);
    if(CopyBuffer(macd_handle, 0, 0, 1, macd_main) > 0 && CopyBuffer(macd_handle, 1, 0, 1, macd_signal) > 0)
    {
        marketAnalysis.macd = macd_main[0];
        marketAnalysis.macdSignal = macd_signal[0];
        marketAnalysis.macdHistogram = macd_main[0] - macd_signal[0];
    }
    
    // Calculate Bollinger Bands
    double bb_upper[], bb_lower[], bb_middle[];
    int bb_handle = iBands(Symbol(), PERIOD_CURRENT, BBPeriod, 0, BBDeviation, PRICE_CLOSE);
    if(CopyBuffer(bb_handle, 0, 0, 1, bb_middle) > 0 && 
       CopyBuffer(bb_handle, 1, 0, 1, bb_upper) > 0 && 
       CopyBuffer(bb_handle, 2, 0, 1, bb_lower) > 0)
    {
        marketAnalysis.bbMiddle = bb_middle[0];
        marketAnalysis.bbUpper = bb_upper[0];
        marketAnalysis.bbLower = bb_lower[0];
    }
    
    // Get current market data
    marketAnalysis.currentPrice = SymbolInfoDouble(Symbol(), SYMBOL_BID);
    marketAnalysis.spread = (SymbolInfoDouble(Symbol(), SYMBOL_ASK) - SymbolInfoDouble(Symbol(), SYMBOL_BID)) / SymbolInfoDouble(Symbol(), SYMBOL_POINT);
    
    // Calculate volatility
    marketAnalysis.volatility = marketAnalysis.atr / marketAnalysis.currentPrice * 100;
    
    // Determine market trend
    if(marketAnalysis.currentPrice > marketAnalysis.bbMiddle && marketAnalysis.macd > marketAnalysis.macdSignal)
        marketAnalysis.marketTrend = "BULLISH";
    else if(marketAnalysis.currentPrice < marketAnalysis.bbMiddle && marketAnalysis.macd < marketAnalysis.macdSignal)
        marketAnalysis.marketTrend = "BEARISH";
    else
        marketAnalysis.marketTrend = "SIDEWAYS";
    
    // Determine market structure
    if(marketAnalysis.volatility > 0.5)
        marketAnalysis.marketStructure = "TRENDING";
    else
        marketAnalysis.marketStructure = "RANGING";
    
    // Check liquidity and volatility
    marketAnalysis.isHighVolatility = marketAnalysis.volatility > 0.3;
    marketAnalysis.isLiquidityHigh = marketAnalysis.spread <= MaxSpreadPoints;
    
    // Get active session
    marketAnalysis.activeSession = GetActiveSession();
    marketAnalysis.analysisTime = TimeCurrent();
}

//+------------------------------------------------------------------+
//| Check for High Quality Signals                                   |
//+------------------------------------------------------------------+
void CheckForHighQualitySignals()
{
    if(!EnableAutoTrading) return;
    
    // Check enhanced limits
    if(enhancedStats.todayTrades >= MaxDailyTrades) return;
    if(enhancedStats.todayRisk >= MaxDailyRisk) return;
    
    // Check minimum time between trades
    if(TimeCurrent() - enhancedStats.lastTradeTime < MinTimeBetweenTrades * 60) return;
    
    // Check if we have a position
    if(positionInfo.Select(Symbol())) return;
    
    // Generate enhanced signal
    EnhancedGoldexSignal signal = GenerateEnhancedSignal();
    
    if(signal.isValid && signal.passedAllFilters)
    {
        ProcessEnhancedSignal(signal);
    }
}

//+------------------------------------------------------------------+
//| Generate Enhanced Signal                                          |
//+------------------------------------------------------------------+
EnhancedGoldexSignal GenerateEnhancedSignal()
{
    EnhancedGoldexSignal signal;
    signal.isValid = false;
    signal.passedAllFilters = false;
    
    // Only generate signals during optimal conditions
    if(!IsOptimalTradingCondition()) return signal;
    
    // Apply multiple filters for high-quality signals
    if(!PassesSmartFiltering()) return signal;
    
    double currentPrice = marketAnalysis.currentPrice;
    double atr = marketAnalysis.atr;
    
    // Determine signal direction using multiple confirmations
    string direction = DetermineSignalDirection();
    if(direction == "NONE") return signal;
    
    // Generate signal details
    signal.id = StringFormat("GOLDEX_ENH_%d_%d", (int)TimeCurrent(), MathRand());
    signal.mode = "enhanced";
    signal.direction = direction;
    signal.entryPrice = direction == "long" ? SymbolInfoDouble(Symbol(), SYMBOL_ASK) : SymbolInfoDouble(Symbol(), SYMBOL_BID);
    signal.atr = atr;
    signal.rsi = marketAnalysis.rsi;
    signal.macd = marketAnalysis.macd;
    signal.volatility = marketAnalysis.volatility;
    signal.spread = marketAnalysis.spread;
    signal.timestamp = TimeCurrent();
    signal.timeframe = "15M";
    signal.sessionName = marketAnalysis.activeSession;
    
    // Calculate dynamic stop loss and take profit
    CalculateDynamicStopLossAndTakeProfit(signal);
    
    // Calculate lot size
    signal.lotSize = CalculateOptimalLotSize(signal);
    
    // Calculate quality score
    signal.qualityScore = CalculateSignalQuality(signal);
    
    // Calculate confidence based on multiple factors
    signal.confidence = CalculateEnhancedConfidence(signal);
    
    // Generate reasoning
    signal.reasoning = GenerateSignalReasoning(signal);
    
    // Final validation
    if(signal.confidence >= MinConfidence && signal.qualityScore >= 0.8)
    {
        signal.isValid = true;
        signal.passedAllFilters = true;
    }
    
    return signal;
}

//+------------------------------------------------------------------+
//| Determine Signal Direction                                        |
//+------------------------------------------------------------------+
string DetermineSignalDirection()
{
    int bullishSignals = 0;
    int bearishSignals = 0;
    
    // RSI signals
    if(marketAnalysis.rsi < 30) bullishSignals++;
    if(marketAnalysis.rsi > 70) bearishSignals++;
    
    // MACD signals
    if(marketAnalysis.macd > marketAnalysis.macdSignal && marketAnalysis.macdHistogram > 0) bullishSignals++;
    if(marketAnalysis.macd < marketAnalysis.macdSignal && marketAnalysis.macdHistogram < 0) bearishSignals++;
    
    // Bollinger Bands signals
    if(marketAnalysis.currentPrice < marketAnalysis.bbLower) bullishSignals++;
    if(marketAnalysis.currentPrice > marketAnalysis.bbUpper) bearishSignals++;
    
    // Trend signals
    if(marketAnalysis.marketTrend == "BULLISH") bullishSignals++;
    if(marketAnalysis.marketTrend == "BEARISH") bearishSignals++;
    
    // Require at least 3 confirmations
    if(bullishSignals >= 3 && bullishSignals > bearishSignals) return "long";
    if(bearishSignals >= 3 && bearishSignals > bullishSignals) return "short";
    
    return "NONE";
}

//+------------------------------------------------------------------+
//| Calculate Dynamic Stop Loss and Take Profit                      |
//+------------------------------------------------------------------+
void CalculateDynamicStopLossAndTakeProfit(EnhancedGoldexSignal &signal)
{
    double atrDistance = signal.atr * ATRMultiplier;
    double baseRR = BaseRiskRewardRatio;
    
    // Adjust RR based on market conditions
    if(marketAnalysis.volatility > 0.5) baseRR *= DynamicRRMultiplier;
    if(marketAnalysis.marketStructure == "TRENDING") baseRR *= 1.2;
    
    if(signal.direction == "long")
    {
        signal.stopLoss = signal.entryPrice - atrDistance;
        signal.takeProfit = signal.entryPrice + (atrDistance * baseRR);
    }
    else
    {
        signal.stopLoss = signal.entryPrice + atrDistance;
        signal.takeProfit = signal.entryPrice - (atrDistance * baseRR);
    }
    
    signal.riskReward = baseRR;
}

//+------------------------------------------------------------------+
//| Calculate Optimal Lot Size                                        |
//+------------------------------------------------------------------+
double CalculateOptimalLotSize(EnhancedGoldexSignal &signal)
{
    double accountBalance = AccountInfoDouble(ACCOUNT_BALANCE);
    double riskAmount = accountBalance * (MaxRiskPercent / 100.0);
    
    // Reduce risk if we've had recent losses
    if(enhancedStats.consecutiveLosses >= 2) riskAmount *= 0.5;
    
    double stopLossPoints = MathAbs(signal.entryPrice - signal.stopLoss) / SymbolInfoDouble(Symbol(), SYMBOL_POINT);
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
//| Calculate Signal Quality                                          |
//+------------------------------------------------------------------+
double CalculateSignalQuality(EnhancedGoldexSignal &signal)
{
    double quality = 0.0;
    
    // RSI quality
    if(signal.direction == "long" && signal.rsi < 40) quality += 0.2;
    if(signal.direction == "short" && signal.rsi > 60) quality += 0.2;
    
    // MACD quality
    if(signal.direction == "long" && signal.macd > 0) quality += 0.15;
    if(signal.direction == "short" && signal.macd < 0) quality += 0.15;
    
    // Volatility quality
    if(signal.volatility > 0.3 && signal.volatility < 0.8) quality += 0.2;
    
    // Spread quality
    if(signal.spread <= MaxSpreadPoints * 0.7) quality += 0.15;
    
    // Session quality
    if(signal.sessionName == "London" || signal.sessionName == "New York") quality += 0.15;
    
    // Risk-reward quality
    if(signal.riskReward >= 2.5) quality += 0.15;
    
    return MathMin(quality, 1.0);
}

//+------------------------------------------------------------------+
//| Calculate Enhanced Confidence                                     |
//+------------------------------------------------------------------+
double CalculateEnhancedConfidence(EnhancedGoldexSignal &signal)
{
    double confidence = 0.5; // Base confidence
    
    // Add confidence based on multiple factors
    confidence += signal.qualityScore * 0.3;
    confidence += (signal.riskReward / 5.0) * 0.1;
    confidence += (marketAnalysis.isHighVolatility ? 0.1 : 0.0);
    confidence += (marketAnalysis.isLiquidityHigh ? 0.1 : 0.0);
    
    // Adjust based on recent performance
    if(enhancedStats.consecutiveWins >= 2) confidence += 0.05;
    if(enhancedStats.consecutiveLosses >= 2) confidence -= 0.1;
    
    return MathMin(confidence, 0.95);
}

//+------------------------------------------------------------------+
//| Generate Signal Reasoning                                         |
//+------------------------------------------------------------------+
string GenerateSignalReasoning(EnhancedGoldexSignal &signal)
{
    string reasoning = StringFormat("ENHANCED %s Signal: ", signal.direction);
    reasoning += StringFormat("RSI=%.1f, MACD=%.4f, ", signal.rsi, signal.macd);
    reasoning += StringFormat("ATR=%.2f, Vol=%.1f%%, ", signal.atr, signal.volatility);
    reasoning += StringFormat("RR=%.1f:1, Quality=%.0f%%, ", signal.riskReward, signal.qualityScore * 100);
    reasoning += StringFormat("Session=%s, Structure=%s", signal.sessionName, marketAnalysis.marketStructure);
    
    return reasoning;
}

//+------------------------------------------------------------------+
//| Process Enhanced Signal                                           |
//+------------------------------------------------------------------+
void ProcessEnhancedSignal(EnhancedGoldexSignal &signal)
{
    // Final validation
    if(!ValidateEnhancedSignal(signal)) return;
    
    // Execute trade
    bool success = ExecuteEnhancedTrade(signal);
    
    if(success)
    {
        // Update statistics
        enhancedStats.todayTrades++;
        enhancedStats.todayRisk += CalculateTradeRisk(signal);
        enhancedStats.lastTradeTime = TimeCurrent();
        
        // Send notification
        string message = StringFormat("🔥 ENHANCED Trade: %s %s %.2f lots @ %.2f\n" +
                                    "SL: %.2f | TP: %.2f | RR: %.1f:1\n" +
                                    "Confidence: %.0f%% | Quality: %.0f%%",
                                    signal.direction, Symbol(), signal.lotSize, signal.entryPrice,
                                    signal.stopLoss, signal.takeProfit, signal.riskReward,
                                    signal.confidence * 100, signal.qualityScore * 100);
        
        Print(message);
        SendNotification(message);
        
        // Log detailed signal
        LogEnhancedSignal(signal);
    }
}

//+------------------------------------------------------------------+
//| Execute Enhanced Trade                                            |
//+------------------------------------------------------------------+
bool ExecuteEnhancedTrade(EnhancedGoldexSignal &signal)
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
    
    return result;
}

//+------------------------------------------------------------------+
//| Manage Existing Positions                                         |
//+------------------------------------------------------------------+
void ManageExistingPositions()
{
    if(!positionInfo.Select(Symbol())) return;
    
    if(positionInfo.Magic() == MagicNumber)
    {
        // Implement trailing stop
        if(EnableTrailingStop)
        {
            UpdateTrailingStop();
        }
        
        // Monitor position performance
        MonitorPositionPerformance();
    }
}

//+------------------------------------------------------------------+
//| Update Trailing Stop                                              |
//+------------------------------------------------------------------+
void UpdateTrailingStop()
{
    double currentPrice = positionInfo.Type() == POSITION_TYPE_BUY ? 
                         SymbolInfoDouble(Symbol(), SYMBOL_BID) : 
                         SymbolInfoDouble(Symbol(), SYMBOL_ASK);
    
    double currentSL = positionInfo.StopLoss();
    double trailingDistance = marketAnalysis.atr * TrailingStopATR;
    
    double newSL = 0;
    bool shouldUpdate = false;
    
    if(positionInfo.Type() == POSITION_TYPE_BUY)
    {
        newSL = currentPrice - trailingDistance;
        shouldUpdate = (newSL > currentSL && newSL > positionInfo.PriceOpen());
    }
    else
    {
        newSL = currentPrice + trailingDistance;
        shouldUpdate = (newSL < currentSL && newSL < positionInfo.PriceOpen());
    }
    
    if(shouldUpdate)
    {
        trade.PositionModify(positionInfo.Ticket(), newSL, positionInfo.TakeProfit());
        Print("✅ Trailing stop updated to: ", newSL);
    }
}

//+------------------------------------------------------------------+
//| Monitor Position Performance                                      |
//+------------------------------------------------------------------+
void MonitorPositionPerformance()
{
    double currentProfit = positionInfo.Profit();
    double currentPips = (positionInfo.Type() == POSITION_TYPE_BUY ? 
                         SymbolInfoDouble(Symbol(), SYMBOL_BID) - positionInfo.PriceOpen() :
                         positionInfo.PriceOpen() - SymbolInfoDouble(Symbol(), SYMBOL_ASK)) / SymbolInfoDouble(Symbol(), SYMBOL_POINT);
    
    // Update chart with position info
    static datetime lastUpdate = 0;
    if(TimeCurrent() - lastUpdate >= 60)
    {
        string posInfo = StringFormat("Position: %s | P&L: $%.2f | Pips: %.1f | RR: %.1f:1",
                                     positionInfo.Type() == POSITION_TYPE_BUY ? "BUY" : "SELL",
                                     currentProfit, currentPips, CalculateCurrentRR());
        
        UpdatePositionDisplay(posInfo);
        lastUpdate = TimeCurrent();
    }
}

//+------------------------------------------------------------------+
//| Helper Functions                                                  |
//+------------------------------------------------------------------+
bool IsOptimalTradingCondition()
{
    // Check session filter
    if(EnableSessionFilter && !IsOptimalSession()) return false;
    
    // Check volatility filter
    if(OnlyTradeHighVolatility && !marketAnalysis.isHighVolatility) return false;
    
    // Check liquidity filter
    if(EnableLiquidityFilter && !marketAnalysis.isLiquidityHigh) return false;
    
    // Check spread
    if(marketAnalysis.spread > MaxSpreadPoints) return false;
    
    return true;
}

bool PassesSmartFiltering()
{
    if(!EnableSmartFiltering) return true;
    
    // Multiple confirmation filters
    int confirmations = 0;
    
    // RSI filter
    if(marketAnalysis.rsi < 70 && marketAnalysis.rsi > 30) confirmations++;
    
    // MACD filter
    if(MathAbs(marketAnalysis.macdHistogram) > 0.0001) confirmations++;
    
    // Volatility filter
    if(marketAnalysis.volatility > 0.2 && marketAnalysis.volatility < 1.0) confirmations++;
    
    // Market structure filter
    if(EnableMarketStructureFilter && marketAnalysis.marketStructure == "TRENDING") confirmations++;
    
    return confirmations >= 3;
}

bool IsOptimalSession()
{
    string session = GetActiveSession();
    return (session == "London" || session == "New York" || session == "Overlap");
}

string GetActiveSession()
{
    MqlDateTime dt;
    TimeToStruct(TimeCurrent(), dt);
    int hour = dt.hour;
    
    if(hour >= 8 && hour < 17) return "London";
    if(hour >= 13 && hour < 22) return "New York";
    if(hour >= 13 && hour < 17) return "Overlap";
    if(hour >= 0 && hour < 9) return "Tokyo";
    
    return "None";
}

double CalculateCurrentRR()
{
    if(!positionInfo.Select(Symbol())) return 0.0;
    
    double entryPrice = positionInfo.PriceOpen();
    double sl = positionInfo.StopLoss();
    double tp = positionInfo.TakeProfit();
    
    if(sl == 0 || tp == 0) return 0.0;
    
    double risk = MathAbs(entryPrice - sl);
    double reward = MathAbs(tp - entryPrice);
    
    return reward / risk;
}

double CalculateTradeRisk(EnhancedGoldexSignal &signal)
{
    double riskDistance = MathAbs(signal.entryPrice - signal.stopLoss);
    return (riskDistance / signal.entryPrice) * 100.0;
}

bool ValidateEnhancedSignal(EnhancedGoldexSignal &signal)
{
    if(signal.confidence < MinConfidence) return false;
    if(signal.qualityScore < 0.7) return false;
    if(signal.riskReward < 2.0) return false;
    if(signal.lotSize < MinLotSize || signal.lotSize > MaxLotSize) return false;
    
    return true;
}

void LogEnhancedSignal(EnhancedGoldexSignal &signal)
{
    string logMessage = StringFormat("🔥 ENHANCED SIGNAL EXECUTED:\n" +
                                   "ID: %s | Direction: %s | Entry: %.2f\n" +
                                   "SL: %.2f | TP: %.2f | RR: %.1f:1\n" +
                                   "Confidence: %.0f%% | Quality: %.0f%%\n" +
                                   "ATR: %.2f | RSI: %.1f | MACD: %.4f\n" +
                                   "Volatility: %.1f%% | Spread: %.1f\n" +
                                   "Session: %s | Structure: %s\n" +
                                   "Reasoning: %s",
                                   signal.id, signal.direction, signal.entryPrice,
                                   signal.stopLoss, signal.takeProfit, signal.riskReward,
                                   signal.confidence * 100, signal.qualityScore * 100,
                                   signal.atr, signal.rsi, signal.macd,
                                   signal.volatility, signal.spread,
                                   signal.sessionName, marketAnalysis.marketStructure,
                                   signal.reasoning);
    
    Print(logMessage);
}

void UpdateEnhancedAccountInfo()
{
    enhancedStats.accountBalance = AccountInfoDouble(ACCOUNT_BALANCE);
    enhancedStats.equity = AccountInfoDouble(ACCOUNT_EQUITY);
    enhancedStats.freeMargin = AccountInfoDouble(ACCOUNT_FREEMARGIN);
    
    // Update peak balance and drawdown
    if(enhancedStats.accountBalance > enhancedStats.peakBalance)
        enhancedStats.peakBalance = enhancedStats.accountBalance;
    
    enhancedStats.currentDrawdown = ((enhancedStats.peakBalance - enhancedStats.accountBalance) / enhancedStats.peakBalance) * 100.0;
    
    if(enhancedStats.currentDrawdown > enhancedStats.maxDrawdown)
        enhancedStats.maxDrawdown = enhancedStats.currentDrawdown;
}

void UpdateEnhancedPerformanceMetrics()
{
    if(enhancedStats.todayTrades > 0)
    {
        enhancedStats.actualWinRate = (double)enhancedStats.todayWins / enhancedStats.todayTrades * 100.0;
        
        if(enhancedStats.todayWins > 0 && enhancedStats.todayLosses > 0)
        {
            enhancedStats.profitFactor = enhancedStats.avgWinSize / enhancedStats.avgLossSize;
        }
        
        enhancedStats.riskAdjustedReturn = enhancedStats.todayProfit / enhancedStats.todayRisk;
    }
}

void SetupEnhancedChart()
{
    // Set up professional chart appearance
    ChartSetInteger(0, CHART_SHOW_GRID, false);
    ChartSetInteger(0, CHART_SHOW_PERIOD_SEP, true);
    ChartSetInteger(0, CHART_SHIFT, true);
    ChartSetInteger(0, CHART_AUTOSCROLL, true);
    ChartSetInteger(0, CHART_COLOR_BACKGROUND, clrWhite);
    ChartSetInteger(0, CHART_COLOR_FOREGROUND, clrBlack);
    ChartSetInteger(0, CHART_COLOR_CHART_UP, clrGreen);
    ChartSetInteger(0, CHART_COLOR_CHART_DOWN, clrRed);
    
    // Create enhanced info display
    ObjectCreate(0, "EA_Enhanced_Info", OBJ_LABEL, 0, 0, 0);
    ObjectSetString(0, "EA_Enhanced_Info", OBJPROP_TEXT, "GOLDEX AI ENHANCED v3.0");
    ObjectSetInteger(0, "EA_Enhanced_Info", OBJPROP_CORNER, CORNER_LEFT_UPPER);
    ObjectSetInteger(0, "EA_Enhanced_Info", OBJPROP_XDISTANCE, 10);
    ObjectSetInteger(0, "EA_Enhanced_Info", OBJPROP_YDISTANCE, 25);
    ObjectSetInteger(0, "EA_Enhanced_Info", OBJPROP_COLOR, clrGold);
    ObjectSetInteger(0, "EA_Enhanced_Info", OBJPROP_FONTSIZE, 12);
    ObjectSetString(0, "EA_Enhanced_Info", OBJPROP_FONT, "Arial Bold");
}

void UpdateEnhancedChartInfo()
{
    static datetime lastUpdate = 0;
    if(TimeCurrent() - lastUpdate < 10) return;
    
    string info = StringFormat("Balance: $%.2f | Trades: %d | Win Rate: %.1f%% | Max DD: %.1f%%\n" +
                              "Quality Mode: ON | Confidence: %.0f%%+ | RR: %.1f:1+",
                              enhancedStats.accountBalance, enhancedStats.todayTrades, 
                              enhancedStats.actualWinRate, enhancedStats.maxDrawdown,
                              MinConfidence * 100, BaseRiskRewardRatio);
    
    if(ObjectFind(0, "EA_Enhanced_Status") >= 0)
        ObjectSetString(0, "EA_Enhanced_Status", OBJPROP_TEXT, info);
    else
    {
        ObjectCreate(0, "EA_Enhanced_Status", OBJ_LABEL, 0, 0, 0);
        ObjectSetString(0, "EA_Enhanced_Status", OBJPROP_TEXT, info);
        ObjectSetInteger(0, "EA_Enhanced_Status", OBJPROP_CORNER, CORNER_LEFT_UPPER);
        ObjectSetInteger(0, "EA_Enhanced_Status", OBJPROP_XDISTANCE, 10);
        ObjectSetInteger(0, "EA_Enhanced_Status", OBJPROP_YDISTANCE, 45);
        ObjectSetInteger(0, "EA_Enhanced_Status", OBJPROP_COLOR, clrNavy);
        ObjectSetInteger(0, "EA_Enhanced_Status", OBJPROP_FONTSIZE, 8);
    }
    
    lastUpdate = TimeCurrent();
}

void UpdatePositionDisplay(string info)
{
    if(ObjectFind(0, "Position_Info") >= 0)
        ObjectSetString(0, "Position_Info", OBJPROP_TEXT, info);
    else
    {
        ObjectCreate(0, "Position_Info", OBJ_LABEL, 0, 0, 0);
        ObjectSetString(0, "Position_Info", OBJPROP_TEXT, info);
        ObjectSetInteger(0, "Position_Info", OBJPROP_CORNER, CORNER_LEFT_UPPER);
        ObjectSetInteger(0, "Position_Info", OBJPROP_XDISTANCE, 10);
        ObjectSetInteger(0, "Position_Info", OBJPROP_YDISTANCE, 65);
        ObjectSetInteger(0, "Position_Info", OBJPROP_COLOR, clrBlue);
        ObjectSetInteger(0, "Position_Info", OBJPROP_FONTSIZE, 9);
    }
}

void InitializeMarketAnalysis()
{
    marketAnalysis.analysisTime = TimeCurrent();
    marketAnalysis.currentPrice = SymbolInfoDouble(Symbol(), SYMBOL_BID);
    marketAnalysis.spread = 0.0;
    marketAnalysis.volatility = 0.0;
    marketAnalysis.marketTrend = "SIDEWAYS";
    marketAnalysis.marketStructure = "RANGING";
    marketAnalysis.isHighVolatility = false;
    marketAnalysis.isLiquidityHigh = false;
    marketAnalysis.activeSession = "None";
}

//+------------------------------------------------------------------+
//| Trade Event Handler                                               |
//+------------------------------------------------------------------+
void OnTrade()
{
    // Check for closed positions and update statistics
    for(int i = 0; i < HistoryDealsTotal(); i++)
    {
        ulong ticket = HistoryDealGetTicket(i);
        if(HistoryDealGetInteger(ticket, DEAL_MAGIC) == MagicNumber)
        {
            double profit = HistoryDealGetDouble(ticket, DEAL_PROFIT);
            enhancedStats.todayProfit += profit;
            enhancedStats.dailyPnL += profit;
            
            if(profit > 0)
            {
                enhancedStats.todayWins++;
                enhancedStats.consecutiveWins++;
                enhancedStats.consecutiveLosses = 0;
                enhancedStats.avgWinSize = (enhancedStats.avgWinSize * (enhancedStats.todayWins - 1) + profit) / enhancedStats.todayWins;
                
                string winMessage = StringFormat("✅ WIN: +$%.2f | Consecutive Wins: %d | Win Rate: %.1f%%",
                                               profit, enhancedStats.consecutiveWins, enhancedStats.actualWinRate);
                Print(winMessage);
                SendNotification(winMessage);
            }
            else if(profit < 0)
            {
                enhancedStats.todayLosses++;
                enhancedStats.consecutiveLosses++;
                enhancedStats.consecutiveWins = 0;
                enhancedStats.avgLossSize = (enhancedStats.avgLossSize * (enhancedStats.todayLosses - 1) + MathAbs(profit)) / enhancedStats.todayLosses;
                
                string lossMessage = StringFormat("❌ LOSS: -$%.2f | Consecutive Losses: %d | Adjusting Risk",
                                                MathAbs(profit), enhancedStats.consecutiveLosses);
                Print(lossMessage);
                SendNotification(lossMessage);
            }
        }
    }
    
    // Update performance metrics
    UpdateEnhancedPerformanceMetrics();
    
    // Send daily summary if needed
    static datetime lastSummary = 0;
    if(TimeCurrent() - lastSummary >= 86400) // Daily summary
    {
        SendDailySummary();
        lastSummary = TimeCurrent();
    }
}

void SendDailySummary()
{
    string summary = StringFormat("📊 GOLDEX AI ENHANCED Daily Summary\n" +
                                 "Balance: $%.2f | P&L: %+.2f\n" +
                                 "Trades: %d | Wins: %d | Losses: %d\n" +
                                 "Win Rate: %.1f%% | Profit Factor: %.2f\n" +
                                 "Max Drawdown: %.1f%% | Risk Adjusted Return: %.2f",
                                 enhancedStats.accountBalance, enhancedStats.dailyPnL,
                                 enhancedStats.todayTrades, enhancedStats.todayWins, enhancedStats.todayLosses,
                                 enhancedStats.actualWinRate, enhancedStats.profitFactor,
                                 enhancedStats.maxDrawdown, enhancedStats.riskAdjustedReturn);
    
    Print(summary);
    SendNotification(summary);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
    // Final summary
    string message = StringFormat("🔥 GOLDEX AI ENHANCED Session Complete\n" +
                                "Final Balance: $%.2f\n" +
                                "Total Trades: %d\n" +
                                "Win Rate: %.1f%%\n" +
                                "Total Profit: $%.2f\n" +
                                "Max Drawdown: %.1f%%",
                                enhancedStats.accountBalance,
                                enhancedStats.todayTrades,
                                enhancedStats.actualWinRate,
                                enhancedStats.todayProfit,
                                enhancedStats.maxDrawdown);
    
    Print(message);
    SendNotification(message);
    
    // Clean up chart objects
    ObjectsDeleteAll(0);
}

//+------------------------------------------------------------------+