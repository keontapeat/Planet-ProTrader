//+------------------------------------------------------------------+
//|                                    GOLDEX_AI_ULTRA_AGGRESSIVE_V10.mq5 |
//|                                  Copyright 2025, GOLDEX AI  |
//|                                             https://goldexai.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, GOLDEX AI Keonta"
#property link      "https://goldexai.com"
#property version   "10.00"
#property strict

#include <Trade\Trade.mqh>
#include <Trade\PositionInfo.mqh>
#include <Trade\AccountInfo.mqh>

CTrade trade;
CPositionInfo position;
CAccountInfo account;

//--- Trade Frequency Enum
enum ENUM_TRADE_FREQUENCY
{
   FREQ_EVERY_30_SECONDS = 30,
   FREQ_EVERY_1_MINUTE = 60,
   FREQ_EVERY_2_MINUTES = 120,
   FREQ_EVERY_5_MINUTES = 300,
   FREQ_EVERY_10_MINUTES = 600,
   FREQ_EVERY_15_MINUTES = 900,
   FREQ_EVERY_30_MINUTES = 1800,
   FREQ_EVERY_1_HOUR = 3600,
   FREQ_EVERY_2_HOURS = 7200,
   FREQ_CUSTOM = 0
};

//--- FIXED Input Parameters - Your Settings Will STICK!
input group "=== TRADE FREQUENCY CONTROL ==="
input ENUM_TRADE_FREQUENCY TradeFrequency = FREQ_EVERY_1_MINUTE; // Your preferred frequency
input int CustomFrequencySeconds = 60; // Custom frequency in seconds
input bool EnableForceTrading = true; // Force trades at set intervals
input bool EnableClockwiseTrading = true; // 24/7 trading
input int MaxTradesPerHour = 60; // Maximum trades per hour (INCREASED)
input int MaxTradesPerDay = 500; // Maximum trades per day (INCREASED)
input bool EnableProgressiveRisk = true; // Increase risk after losses

input group "=== FLIP MODE SETTINGS ==="
input ENUM_TIMEFRAMES FlipTimeframe = PERIOD_M1;
input double FlipRiskPercent = 10.0; // INCREASED for faster growth
input double FlipTargetPercent = 20.0; // INCREASED target
input bool EnableFlipMode = true; // ALWAYS ON
input bool EnableScalpMode = true; // ALWAYS ON
input bool EnableAggressiveMode = true; // ALWAYS ON

input group "=== RISK MANAGEMENT ==="
input double RiskPercentage = 15.0; // INCREASED risk for $1k->$100k
input double MaxRiskPercentage = 25.0; // INCREASED max risk
input double StopLossPoints = 25.0; // TIGHTER stops
input double TakeProfitPoints = 75.0; // OPTIMIZED target
input double TrailingStopPoints = 15.0; // ACTIVE trailing

input group "=== TRADING SETTINGS ==="
input bool EnableAutoTrading = true; // ALWAYS ON
input bool EnableNotifications = true; // ALWAYS ON
input bool EnableSoundAlerts = true; // ALWAYS ON
input int MagicNumber = 100064; // UNIQUE magic number
input string TradeComment = "GOLDEX_AI_V10_FLIP"; // Version 10 comment

input group "=== AI ENHANCEMENT ==="
input bool EnableAILearning = true; // ALWAYS ON
input bool EnableSmartEntry = true; // ALWAYS ON
input bool EnableDynamicSizing = true; // ALWAYS ON
input bool EnableMultiTimeframe = true; // ALWAYS ON

input group "=== ULTRA AGGRESSIVE MODE ==="
input bool EnableUltraAggressive = true; // ALWAYS ON
input int MaxSimultaneousPositions = 10; // INCREASED positions
input double ScalpProfitPoints = 15.0; // INCREASED scalp profit
input double QuickExitPoints = 10.0; // INCREASED quick exit
input bool EnableInstantScalping = true; // ALWAYS ON
input bool EnableHedging = true; // ALWAYS ON
input bool EnableMartingale = true; // ENABLED for recovery
input double MartingaleMultiplier = 2.0; // INCREASED multiplier

input group "=== PROGRESSIVE PROFIT SYSTEM ==="
input bool EnableProgressiveProfit = true; // ALWAYS ON
input double ProfitMultiplier = 3.0; // INCREASED multiplier
input int WinStreakForBonus = 3; // REDUCED streak needed
input double BonusMultiplier = 50.0; // INCREASED bonus
input bool EnableLossRecovery = true; // ALWAYS ON

input group "=== V10 OPTIMIZATION ==="
input bool EnableTurboMode = true; // NEW: Ultra-fast execution
input bool EnableSmartMartingale = true; // NEW: Intelligent martingale
input bool EnableVolumeBooster = true; // NEW: Volume multiplication
input double VolumeMultiplier = 2.0; // NEW: Volume booster
input bool EnableRapidGrowth = true; // NEW: Rapid growth mode
input double GrowthTargetMultiplier = 100.0; // NEW: 100x growth target

//--- Global Variables (FIXED - Won't reset)
double AccountBalance = 0.0;
double InitialBalance = 0.0;
double CurrentDrawdown = 0.0;
double MaxDrawdown = 0.0;
double DailyTarget = 0.0;
double WeeklyTarget = 0.0;
int TotalTrades = 0;
int WinningTrades = 0;
int ConsecutiveWins = 0;
int ConsecutiveLosses = 0;
double WinRate = 0.0;
bool FlipModeActive = false;
datetime LastTradeTime = 0;
datetime LastForceTradeTime = 0;
double LastPrice = 0.0;
string TradeSymbol = "";
double CurrentMultiplier = 1.0;
bool AlwaysInTrade = false;
int TradesThisHour = 0;
int TradesThisDay = 0;
datetime CurrentHour = 0;
datetime CurrentDay = 0;
int ActualTradeFrequency = 60; // Will be set from inputs and STICK

//--- Arrays for multiple position tracking
ulong PositionTickets[];
datetime PositionOpenTimes[];
double PositionProfits[];
int ActivePositions = 0;

//--- Indicator Handles
int RSI_Handle;
int MACD_Handle;
int MA_Handle_5;
int MA_Handle_20;
int MA_Handle_50;
int ATR_Handle;
int BB_Handle;
int MOM_Handle;
int STOCH_Handle;

//--- V10 Enums
enum ENUM_ULTRA_MODE
{
   ULTRA_CONSERVATIVE,
   ULTRA_MODERATE,
   ULTRA_AGGRESSIVE,
   ULTRA_INSANE,
   ULTRA_SCALP_MASTER,
   ULTRA_TURBO_V10
};

enum ENUM_SIGNAL_TYPE
{
   SIGNAL_NONE,
   SIGNAL_BUY,
   SIGNAL_SELL,
   SIGNAL_CLOSE_BUY,
   SIGNAL_CLOSE_SELL,
   SIGNAL_SCALP_BUY,
   SIGNAL_SCALP_SELL,
   SIGNAL_HEDGE_BUY,
   SIGNAL_HEDGE_SELL,
   SIGNAL_FORCE_BUY,
   SIGNAL_FORCE_SELL,
   SIGNAL_RECOVERY_BUY,
   SIGNAL_RECOVERY_SELL,
   SIGNAL_TURBO_BUY,
   SIGNAL_TURBO_SELL
};

//--- V10 Structures
struct V10_UltraAggressiveSignal
{
   ENUM_SIGNAL_TYPE direction;
   double entryPrice;
   double stopLoss;
   double takeProfit;
   double lotSize;
   double confidence;
   double urgency;
   bool isScalp;
   bool isHedge;
   bool isForced;
   bool isRecovery;
   bool isTurbo;
   int timeframe;
   double expectedProfit;
   double riskReward;
   string signalReason;
   datetime signalTime;
   double volumeBoost;
   bool isRapidGrowth;
};

struct V10_TradingState
{
   bool inUptrend;
   bool inDowntrend;
   bool inRange;
   double volatility;
   double momentum;
   double strength;
   double opportunity;
   double turboFactor;
   bool isRapidGrowthTime;
   double marketSpeed;
};

struct V10_TradingStats
{
   int totalTrades;
   int winningTrades;
   int losingTrades;
   double totalProfit;
   double totalLoss;
   double largestWin;
   double largestLoss;
   double averageWin;
   double averageLoss;
   double profitFactor;
   double winRate;
   int maxConsecutiveWins;
   int maxConsecutiveLosses;
   double maxDrawdown;
   double recovery;
   double growthRate;
   double turboProfit;
   datetime sessionStart;
};

//--- Global Objects
V10_UltraAggressiveSignal currentSignal;
V10_TradingState marketState;
V10_TradingStats stats;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
   TradeSymbol = _Symbol;
   AccountBalance = account.Balance();
   InitialBalance = AccountBalance;
   
   // FIXED: Set trade frequency from inputs and make it STICK
   if(TradeFrequency == FREQ_CUSTOM)
   {
      ActualTradeFrequency = CustomFrequencySeconds;
   }
   else
   {
      ActualTradeFrequency = (int)TradeFrequency;
   }
   
   // Initialize time tracking
   CurrentHour = TimeCurrent() / 3600 * 3600;
   CurrentDay = TimeCurrent() / 86400 * 86400;
   
   // Initialize ALL indicator handles
   RSI_Handle = iRSI(TradeSymbol, PERIOD_M1, 14, PRICE_CLOSE);
   MACD_Handle = iMACD(TradeSymbol, PERIOD_M1, 12, 26, 9, PRICE_CLOSE);
   MA_Handle_5 = iMA(TradeSymbol, PERIOD_M1, 5, 0, MODE_EMA, PRICE_CLOSE);
   MA_Handle_20 = iMA(TradeSymbol, PERIOD_M1, 20, 0, MODE_EMA, PRICE_CLOSE);
   MA_Handle_50 = iMA(TradeSymbol, PERIOD_M1, 50, 0, MODE_EMA, PRICE_CLOSE);
   ATR_Handle = iATR(TradeSymbol, PERIOD_M1, 14);
   BB_Handle = iBands(TradeSymbol, PERIOD_M1, 20, 0, 2, PRICE_CLOSE);
   MOM_Handle = iMomentum(TradeSymbol, PERIOD_M1, 10, PRICE_CLOSE);
   STOCH_Handle = iStochastic(TradeSymbol, PERIOD_M1, 5, 3, 3, MODE_SMA, STO_LOWHIGH);
   
   // Check ALL handles
   if(RSI_Handle == INVALID_HANDLE || MACD_Handle == INVALID_HANDLE || 
      MA_Handle_5 == INVALID_HANDLE || MA_Handle_20 == INVALID_HANDLE || 
      MA_Handle_50 == INVALID_HANDLE || ATR_Handle == INVALID_HANDLE ||
      BB_Handle == INVALID_HANDLE || MOM_Handle == INVALID_HANDLE ||
      STOCH_Handle == INVALID_HANDLE)
   {
      Print("❌ Error creating indicator handles");
      return(INIT_FAILED);
   }
   
   // Initialize arrays with INCREASED size
   ArrayResize(PositionTickets, MaxSimultaneousPositions);
   ArrayResize(PositionOpenTimes, MaxSimultaneousPositions);
   ArrayResize(PositionProfits, MaxSimultaneousPositions);
   
   // Initialize V10 stats
   InitializeV10Stats();
   
   // Set up V10 ultra aggressive mode
   SetupV10UltraAggressiveMode();
   
   // Set up V10 flip mode targets
   SetupV10FlipModeTargets();
   
   // Enable always in trade mode
   AlwaysInTrade = EnableUltraAggressive;
   
   // V10 Welcome Message
   Print("🚀🚀🚀 GOLDEX AI ULTRA AGGRESSIVE V10 INITIALIZED 🚀🚀🚀");
   Print("💰 Account Balance: $", AccountBalance);
   Print("🎯 TARGET: $1,000 → $100,000 (100x Growth!)");
   Print("⚡ Trade Frequency: Every ", ActualTradeFrequency, " seconds (FIXED)");
   Print("🔥 Max Trades/Hour: ", MaxTradesPerHour, " (INCREASED)");
   Print("📅 Max Trades/Day: ", MaxTradesPerDay, " (INCREASED)");
   Print("💎 Risk Per Trade: ", RiskPercentage, "% (OPTIMIZED)");
   Print("🎲 Progressive Profit: ", EnableProgressiveProfit ? "✅ ENABLED" : "❌ DISABLED");
   Print("🔄 24/7 Trading: ", EnableClockwiseTrading ? "✅ ENABLED" : "❌ DISABLED");
   Print("💨 Instant Scalping: ", EnableInstantScalping ? "✅ ENABLED" : "❌ DISABLED");
   Print("⚡ Turbo Mode: ", EnableTurboMode ? "✅ ENABLED" : "❌ DISABLED");
   Print("🎯 Rapid Growth: ", EnableRapidGrowth ? "✅ ENABLED" : "❌ DISABLED");
   Print("💪 Max Positions: ", MaxSimultaneousPositions, " (INCREASED)");
   Print("🔥 Martingale: ", EnableMartingale ? "✅ ENABLED" : "❌ DISABLED");
   Print("🚀 Volume Booster: ", EnableVolumeBooster ? "✅ ENABLED" : "❌ DISABLED");
   
   SendNotification("🚀 GOLDEX AI V10 ACTIVATED - $1K TO $100K CHALLENGE STARTED!");
   
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                               |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   // Release ALL indicator handles
   if(RSI_Handle != INVALID_HANDLE) IndicatorRelease(RSI_Handle);
   if(MACD_Handle != INVALID_HANDLE) IndicatorRelease(MACD_Handle);
   if(MA_Handle_5 != INVALID_HANDLE) IndicatorRelease(MA_Handle_5);
   if(MA_Handle_20 != INVALID_HANDLE) IndicatorRelease(MA_Handle_20);
   if(MA_Handle_50 != INVALID_HANDLE) IndicatorRelease(MA_Handle_50);
   if(ATR_Handle != INVALID_HANDLE) IndicatorRelease(ATR_Handle);
   if(BB_Handle != INVALID_HANDLE) IndicatorRelease(BB_Handle);
   if(MOM_Handle != INVALID_HANDLE) IndicatorRelease(MOM_Handle);
   if(STOCH_Handle != INVALID_HANDLE) IndicatorRelease(STOCH_Handle);
   
   Print("🔥 GOLDEX AI V10 DEINITIALIZED. Reason: ", reason);
   SaveV10Stats();
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
   if(!EnableAutoTrading) return;
   
   // Update time tracking
   UpdateV10TimeTracking();
   
   // Update account and market state
   UpdateV10AccountInfo();
   UpdateV10MarketState();
   
   // V10 TURBO MODE - Ultra-fast execution
   if(EnableTurboMode)
   {
      ExecuteV10TurboStrategy();
   }
   
   // Check for forced trading at FIXED intervals
   if(EnableForceTrading && ShouldForceNewTrade())
   {
      ExecuteV10ForceTrading();
   }
   
   // V10 Ultra aggressive trading logic
   if(EnableUltraAggressive)
   {
      ExecuteV10UltraAggressiveStrategy();
   }
   
   // V10 Flip mode trading
   if(EnableFlipMode)
   {
      ExecuteV10FlipModeStrategy();
   }
   
   // V10 Scalping logic
   if(EnableScalpMode || EnableInstantScalping)
   {
      ExecuteV10ScalpingStrategy();
   }
   
   // V10 Loss recovery system
   if(EnableLossRecovery && ConsecutiveLosses >= 2) // Faster recovery
   {
      ExecuteV10LossRecoveryStrategy();
   }
   
   // V10 Rapid Growth Mode
   if(EnableRapidGrowth)
   {
      ExecuteV10RapidGrowthStrategy();
   }
   
   // Manage all positions
   ManageV10AllPositions();
   
   // Ensure always in trade if enabled
   if(AlwaysInTrade && ActivePositions == 0 && CanTrade())
   {
      ForceV10TradeEntry();
   }
   
   // Update position tracking
   UpdateV10PositionTracking();
   
   // Update V10 statistics
   UpdateV10Stats();
}

//+------------------------------------------------------------------+
//| V10 Update Time Tracking                                        |
//+------------------------------------------------------------------+
void UpdateV10TimeTracking()
{
   datetime currentTime = TimeCurrent();
   datetime newHour = currentTime / 3600 * 3600;
   datetime newDay = currentTime / 86400 * 86400;
   
   // Reset hourly counter
   if(newHour != CurrentHour)
   {
      CurrentHour = newHour;
      TradesThisHour = 0;
      Print("🕐 New Hour Started - Trades Reset: ", TradesThisHour, "/", MaxTradesPerHour);
   }
   
   // Reset daily counter
   if(newDay != CurrentDay)
   {
      CurrentDay = newDay;
      TradesThisDay = 0;
      Print("🌅 New Day Started - Trades Reset: ", TradesThisDay, "/", MaxTradesPerDay);
   }
}

//+------------------------------------------------------------------+
//| V10 Should Force New Trade (FIXED)                             |
//+------------------------------------------------------------------+
bool ShouldForceNewTrade()
{
   // Check if enough time has passed since last trade (USING FIXED FREQUENCY)
   if(TimeCurrent() - LastForceTradeTime < ActualTradeFrequency)
      return false;
   
   // Check trade limits
   if(!CanTrade())
      return false;
   
   // Check if we need to force a trade
   if(ActivePositions == 0)
      return true;
   
   // Force trade even with active positions for maximum aggression
   if(ActivePositions < MaxSimultaneousPositions)
      return true;
   
   return false;
}

//+------------------------------------------------------------------+
//| V10 Can Trade                                                   |
//+------------------------------------------------------------------+
bool CanTrade()
{
   // Check hourly limit
   if(TradesThisHour >= MaxTradesPerHour)
   {
      static datetime lastHourlyWarning = 0;
      if(TimeCurrent() - lastHourlyWarning >= 300) // Warn every 5 minutes
      {
         Print("⚠️ Hourly trade limit reached: ", TradesThisHour, "/", MaxTradesPerHour);
         lastHourlyWarning = TimeCurrent();
      }
      return false;
   }
   
   // Check daily limit
   if(TradesThisDay >= MaxTradesPerDay)
   {
      static datetime lastDailyWarning = 0;
      if(TimeCurrent() - lastDailyWarning >= 1800) // Warn every 30 minutes
      {
         Print("⚠️ Daily trade limit reached: ", TradesThisDay, "/", MaxTradesPerDay);
         lastDailyWarning = TimeCurrent();
      }
      return false;
   }
   
   // Check if 24/7 trading is enabled
   if(!EnableClockwiseTrading)
   {
      MqlDateTime dt;
      TimeCurrent(dt);
      if(dt.hour < 1 || dt.hour > 23) // Allow almost 24/7
         return false;
   }
   
   // Check maximum drawdown
   if(CurrentDrawdown > MaxRiskPercentage)
   {
      Print("⚠️ Maximum drawdown reached: ", CurrentDrawdown, "%");
      return false;
   }
   
   return true;
}

//+------------------------------------------------------------------+
//| V10 Execute Turbo Strategy                                      |
//+------------------------------------------------------------------+
void ExecuteV10TurboStrategy()
{
   if(!EnableTurboMode) return;
   
   // Ultra-fast signal generation
   static datetime lastTurboCheck = 0;
   if(TimeCurrent() - lastTurboCheck < 5) // Check every 5 seconds
      return;
   
   V10_UltraAggressiveSignal turboSignal = GenerateV10TurboSignal();
   
   if(turboSignal.direction != SIGNAL_NONE && turboSignal.confidence >= 60.0)
   {
      turboSignal.isTurbo = true;
      turboSignal.signalReason = "V10_TURBO_MODE";
      turboSignal.volumeBoost = EnableVolumeBooster ? VolumeMultiplier : 1.0;
      
      if(ActivePositions < MaxSimultaneousPositions && CanTrade())
      {
         ExecuteV10UltraSignal(turboSignal);
      }
   }
   
   lastTurboCheck = TimeCurrent();
}

//+------------------------------------------------------------------+
//| V10 Generate Turbo Signal                                      |
//+------------------------------------------------------------------+
V10_UltraAggressiveSignal GenerateV10TurboSignal()
{
   V10_UltraAggressiveSignal signal;
   signal.direction = SIGNAL_NONE;
   signal.isTurbo = true;
   signal.confidence = 0.0;
   signal.urgency = 99.0;
   signal.signalTime = TimeCurrent();
   signal.entryPrice = SymbolInfoDouble(TradeSymbol, SYMBOL_ASK);
   signal.volumeBoost = EnableVolumeBooster ? VolumeMultiplier : 1.0;
   
   // Get rapid indicators
   double rsi[], stoch[], mom[];
   ArraySetAsSeries(rsi, true);
   ArraySetAsSeries(stoch, true);
   ArraySetAsSeries(mom, true);
   
   if(CopyBuffer(RSI_Handle, 0, 0, 3, rsi) > 0 && 
      CopyBuffer(STOCH_Handle, 0, 0, 3, stoch) > 0 && 
      CopyBuffer(MOM_Handle, 0, 0, 3, mom) > 0)
   {
      double bullishScore = 0.0;
      double bearishScore = 0.0;
      
      // Ultra-fast RSI signals
      if(rsi[0] < 40) bullishScore += 40.0;
      if(rsi[0] > 60) bearishScore += 40.0;
      
      // Stochastic signals
      if(stoch[0] < 20) bullishScore += 30.0;
      if(stoch[0] > 80) bearishScore += 30.0;
      
      // Momentum signals
      if(mom[0] > 100.02) bullishScore += 30.0;
      if(mom[0] < 99.98) bearishScore += 30.0;
      
      // Determine turbo direction
      if(bullishScore > bearishScore && bullishScore >= 70.0)
      {
         signal.direction = SIGNAL_TURBO_BUY;
         signal.confidence = bullishScore;
      }
      else if(bearishScore > bullishScore && bearishScore >= 70.0)
      {
         signal.direction = SIGNAL_TURBO_SELL;
         signal.confidence = bearishScore;
      }
      
      // Set turbo parameters
      if(signal.direction != SIGNAL_NONE)
      {
         signal.stopLoss = CalculateV10TurboStopLoss(signal.direction, signal.entryPrice);
         signal.takeProfit = CalculateV10TurboTakeProfit(signal.direction, signal.entryPrice);
         signal.lotSize = CalculateV10AggressiveLotSize(signal.stopLoss, signal.entryPrice, true);
         signal.lotSize *= signal.volumeBoost; // Apply volume booster
         signal.riskReward = MathAbs(signal.takeProfit - signal.entryPrice) / MathAbs(signal.entryPrice - signal.stopLoss);
         signal.expectedProfit = signal.lotSize * MathAbs(signal.takeProfit - signal.entryPrice) * 100000;
      }
   }
   
   return signal;
}

//+------------------------------------------------------------------+
//| V10 Execute Force Trading                                       |
//+------------------------------------------------------------------+
void ExecuteV10ForceTrading()
{
   V10_UltraAggressiveSignal forceSignal;
   forceSignal.isForced = true;
   forceSignal.confidence = 80.0;
   forceSignal.urgency = 95.0;
   forceSignal.signalTime = TimeCurrent();
   forceSignal.signalReason = "V10_FORCE_TRADE_" + IntegerToString(ActualTradeFrequency) + "s";
   forceSignal.volumeBoost = EnableVolumeBooster ? VolumeMultiplier : 1.0;
   
   // Generate V10 force signal
   forceSignal = GenerateV10ForceSignal();
   
   if(forceSignal.direction != SIGNAL_NONE)
   {
      ExecuteV10UltraSignal(forceSignal);
      LastForceTradeTime = TimeCurrent();
   }
}

//+------------------------------------------------------------------+
//| V10 Generate Force Signal                                       |
//+------------------------------------------------------------------+
V10_UltraAggressiveSignal GenerateV10ForceSignal()
{
   V10_UltraAggressiveSignal signal;
   signal.direction = SIGNAL_NONE;
   signal.isForced = true;
   signal.confidence = 75.0;
   signal.urgency = 90.0;
   signal.signalTime = TimeCurrent();
   signal.entryPrice = SymbolInfoDouble(TradeSymbol, SYMBOL_ASK);
   signal.volumeBoost = EnableVolumeBooster ? VolumeMultiplier : 1.0;
   
   // Get comprehensive market data
   double ma5[], ma20[], ma50[], rsi[], atr[], bb_upper[], bb_lower[];
   ArraySetAsSeries(ma5, true);
   ArraySetAsSeries(ma20, true);
   ArraySetAsSeries(ma50, true);
   ArraySetAsSeries(rsi, true);
   ArraySetAsSeries(atr, true);
   ArraySetAsSeries(bb_upper, true);
   ArraySetAsSeries(bb_lower, true);
   
   if(CopyBuffer(MA_Handle_5, 0, 0, 3, ma5) > 0 && 
      CopyBuffer(MA_Handle_20, 0, 0, 3, ma20) > 0 && 
      CopyBuffer(MA_Handle_50, 0, 0, 3, ma50) > 0 && 
      CopyBuffer(RSI_Handle, 0, 0, 3, rsi) > 0 &&
      CopyBuffer(ATR_Handle, 0, 0, 3, atr) > 0 &&
      CopyBuffer(BB_Handle, 1, 0, 3, bb_upper) > 0 &&
      CopyBuffer(BB_Handle, 2, 0, 3, bb_lower) > 0)
   {
      double currentPrice = signal.entryPrice;
      double bullishScore = 0.0;
      double bearishScore = 0.0;
      
      // Enhanced trend analysis
      if(currentPrice > ma5[0] && ma5[0] > ma20[0] && ma20[0] > ma50[0]) bullishScore += 40.0;
      if(currentPrice < ma5[0] && ma5[0] < ma20[0] && ma20[0] < ma50[0]) bearishScore += 40.0;
      
      // Enhanced RSI analysis
      if(rsi[0] < 35) bullishScore += 30.0;
      if(rsi[0] > 65) bearishScore += 30.0;
      
      // Bollinger Bands analysis
      if(currentPrice < bb_lower[0]) bullishScore += 25.0;
      if(currentPrice > bb_upper[0]) bearishScore += 25.0;
      
      // Market momentum factor
      double priceChange = (currentPrice - ma20[0]) / ma20[0] * 100;
      if(priceChange > 0.05) bullishScore += 20.0;
      if(priceChange < -0.05) bearishScore += 20.0;
      
      // Enhanced random factor for continuous trading
      int randomFactor = MathRand() % 100;
      if(randomFactor > 40) bullishScore += 15.0;
      else bearishScore += 15.0;
      
      // Determine direction
      if(bullishScore > bearishScore)
      {
         signal.direction = SIGNAL_FORCE_BUY;
         signal.confidence = bullishScore;
      }
      else
      {
         signal.direction = SIGNAL_FORCE_SELL;
         signal.confidence = bearishScore;
      }
      
      // Calculate enhanced stops and targets
      signal.stopLoss = CalculateV10ForceStopLoss(signal.direction, currentPrice, atr[0]);
      signal.takeProfit = CalculateV10ForceTakeProfit(signal.direction, currentPrice, atr[0]);
      signal.lotSize = CalculateV10AggressiveLotSize(signal.stopLoss, currentPrice, false);
      signal.lotSize *= signal.volumeBoost; // Apply volume booster
      signal.riskReward = MathAbs(signal.takeProfit - signal.entryPrice) / MathAbs(signal.entryPrice - signal.stopLoss);
      signal.expectedProfit = signal.lotSize * MathAbs(signal.takeProfit - signal.entryPrice) * 100000;
      
      // Apply V10 progressive profit system
      if(EnableProgressiveProfit)
      {
         ApplyV10ProgressiveProfit(signal);
      }
   }
   
   return signal;
}

//+------------------------------------------------------------------+
//| V10 Execute Rapid Growth Strategy                               |
//+------------------------------------------------------------------+
void ExecuteV10RapidGrowthStrategy()
{
   if(!EnableRapidGrowth) return;
   
   // Check for rapid growth opportunities
   double growthRate = ((AccountBalance - InitialBalance) / InitialBalance) * 100.0;
   
   if(growthRate < 10.0) // If growth is slow, be more aggressive
   {
      V10_UltraAggressiveSignal rapidSignal = GenerateV10RapidGrowthSignal();
      
      if(rapidSignal.direction != SIGNAL_NONE && rapidSignal.confidence >= 65.0)
      {
         rapidSignal.isRapidGrowth = true;
         rapidSignal.signalReason = "V10_RAPID_GROWTH";
         rapidSignal.volumeBoost = EnableVolumeBooster ? VolumeMultiplier * 1.5 : 1.5;
         
         if(ActivePositions < MaxSimultaneousPositions && CanTrade())
         {
            ExecuteV10UltraSignal(rapidSignal);
         }
      }
   }
}

//+------------------------------------------------------------------+
//| V10 Generate Rapid Growth Signal                               |
//+------------------------------------------------------------------+
V10_UltraAggressiveSignal GenerateV10RapidGrowthSignal()
{
   V10_UltraAggressiveSignal signal;
   signal.direction = SIGNAL_NONE;
   signal.isRapidGrowth = true;
   signal.confidence = 70.0;
   signal.urgency = 95.0;
   signal.signalTime = TimeCurrent();
   signal.entryPrice = SymbolInfoDouble(TradeSymbol, SYMBOL_ASK);
   signal.volumeBoost = EnableVolumeBooster ? VolumeMultiplier * 1.5 : 1.5;
   
   // Use multiple timeframes for rapid growth
   double ma5[], ma20[], rsi[], atr[];
   ArraySetAsSeries(ma5, true);
   ArraySetAsSeries(ma20, true);
   ArraySetAsSeries(rsi, true);
   ArraySetAsSeries(atr, true);
   
   if(CopyBuffer(MA_Handle_5, 0, 0, 3, ma5) > 0 && 
      CopyBuffer(MA_Handle_20, 0, 0, 3, ma20) > 0 && 
      CopyBuffer(RSI_Handle, 0, 0, 3, rsi) > 0 &&
      CopyBuffer(ATR_Handle, 0, 0, 3, atr) > 0)
   {
      double currentPrice = signal.entryPrice;
      
      // Rapid growth logic - more aggressive
      if(currentPrice > ma5[0] && rsi[0] < 60)
      {
         signal.direction = SIGNAL_BUY;
         signal.confidence = 85.0;
      }
      else if(currentPrice < ma5[0] && rsi[0] > 40)
      {
         signal.direction = SIGNAL_SELL;
         signal.confidence = 85.0;
      }
      
      if(signal.direction != SIGNAL_NONE)
      {
         // More aggressive parameters for rapid growth
         signal.stopLoss = CalculateV10RapidGrowthStopLoss(signal.direction, currentPrice, atr[0]);
         signal.takeProfit = CalculateV10RapidGrowthTakeProfit(signal.direction, currentPrice, atr[0]);
         signal.lotSize = CalculateV10AggressiveLotSize(signal.stopLoss, currentPrice, false);
         signal.lotSize *= signal.volumeBoost; // Apply enhanced volume booster
         signal.riskReward = MathAbs(signal.takeProfit - signal.entryPrice) / MathAbs(signal.entryPrice - signal.stopLoss);
         signal.expectedProfit = signal.lotSize * MathAbs(signal.takeProfit - signal.entryPrice) * 100000;
         
         // Apply enhanced progressive profit
         if(EnableProgressiveProfit)
         {
            ApplyV10ProgressiveProfit(signal);
         }
      }
   }
   
   return signal;
}

//+------------------------------------------------------------------+
//| V10 Apply Progressive Profit System                             |
//+------------------------------------------------------------------+
void ApplyV10ProgressiveProfit(V10_UltraAggressiveSignal &signal)
{
   if(!EnableProgressiveProfit) return;
   
   // Enhanced bonus system
   if(ConsecutiveWins >= WinStreakForBonus)
   {
      // Apply enhanced bonus multiplier
      double currentTarget = signal.takeProfit;
      double entryPrice = signal.entryPrice;
      double profitDistance = MathAbs(currentTarget - entryPrice);
      double newProfitDistance = profitDistance * BonusMultiplier;
      
      if(signal.direction == SIGNAL_FORCE_BUY || signal.direction == SIGNAL_BUY || signal.direction == SIGNAL_TURBO_BUY)
      {
         signal.takeProfit = entryPrice + newProfitDistance;
      }
      else
      {
         signal.takeProfit = entryPrice - newProfitDistance;
      }
      
      signal.signalReason += "_V10_MEGA_BONUS";
      signal.expectedProfit *= BonusMultiplier;
      signal.confidence = 99.0;
      signal.urgency = 100.0;
      
      Print("🎰🎰🎰 V10 MEGA BONUS ACTIVATED! ", BonusMultiplier, "x MULTIPLIER!");
   }
   else if(ConsecutiveWins >= 2)
   {
      // Apply regular multiplier
      double currentTarget = signal.takeProfit;
      double entryPrice = signal.entryPrice;
      double profitDistance = MathAbs(currentTarget - entryPrice);
      double newProfitDistance = profitDistance * ProfitMultiplier;
      
      if(signal.direction == SIGNAL_FORCE_BUY || signal.direction == SIGNAL_BUY || signal.direction == SIGNAL_TURBO_BUY)
      {
         signal.takeProfit = entryPrice + newProfitDistance;
      }
      else
      {
         signal.takeProfit = entryPrice - newProfitDistance;
      }
      
      signal.signalReason += "_V10_PROGRESSIVE";
      signal.expectedProfit *= ProfitMultiplier;
      
      Print("🚀 V10 Progressive Profit Activated! ", ProfitMultiplier, "x Multiplier!");
   }
   
   // Enhanced progressive risk after losses
   if(EnableProgressiveRisk && ConsecutiveLosses >= 2)
   {
      double riskMultiplier = 1.0 + (ConsecutiveLosses * 0.5);
      signal.lotSize *= riskMultiplier;
      signal.signalReason += "_V10_RECOVERY";
      
      Print("💪 V10 Recovery Mode: ", riskMultiplier, "x Lot Size!");
   }
   
   // Smart Martingale system
   if(EnableSmartMartingale && EnableMartingale && ConsecutiveLosses >= 1)
   {
      double martingaleMultiplier = MathPow(MartingaleMultiplier, MathMin(ConsecutiveLosses, 3)); // Cap at 3
      signal.lotSize *= martingaleMultiplier;
      signal.signalReason += "_V10_SMART_MARTINGALE";
      
      Print("🎯 V10 Smart Martingale: ", martingaleMultiplier, "x Lot Size!");
   }
}

//+------------------------------------------------------------------+
//| V10 Calculate Aggressive Lot Size                               |
//+------------------------------------------------------------------+
double CalculateV10AggressiveLotSize(double stopLoss, double entryPrice, bool isScalp)
{
   double balance = account.Balance();
   double riskPercent = isScalp ? (RiskPercentage * 0.7) : RiskPercentage;
   
   // Enhanced risk calculation
   if(EnableRapidGrowth)
   {
      double growthRate = ((balance - InitialBalance) / InitialBalance) * 100.0;
      if(growthRate < 5.0) // If slow growth, increase risk
      {
         riskPercent *= 1.5;
      }
   }
   
   // Apply volume booster
   if(EnableVolumeBooster)
   {
      riskPercent *= VolumeMultiplier;
   }
   
   double riskAmount = balance * (riskPercent / 100.0);
   double stopLossPoints = MathAbs(entryPrice - stopLoss);
   double tickValue = SymbolInfoDouble(TradeSymbol, SYMBOL_TRADE_TICK_VALUE);
   double lotSize = riskAmount / (stopLossPoints * tickValue * 100000);
   
   // Enhanced normalization
   double minLot = SymbolInfoDouble(TradeSymbol, SYMBOL_VOLUME_MIN);
   double maxLot = SymbolInfoDouble(TradeSymbol, SYMBOL_VOLUME_MAX);
   double lotStep = SymbolInfoDouble(TradeSymbol, SYMBOL_VOLUME_STEP);
   
   // Ensure minimum aggressive lot size
   lotSize = MathMax(lotSize, minLot * 2.0);
   lotSize = MathMin(lotSize, maxLot);
   lotSize = MathRound(lotSize / lotStep) * lotStep;
   
   return lotSize;
}

//+------------------------------------------------------------------+
//| V10 Calculate Stop Loss Functions                               |
//+------------------------------------------------------------------+
double CalculateV10TurboStopLoss(ENUM_SIGNAL_TYPE direction, double entryPrice)
{
   double point = SymbolInfoDouble(TradeSymbol, SYMBOL_POINT);
   double stopLossPoints = 10.0; // Very tight for turbo
   
   if(direction == SIGNAL_TURBO_BUY)
      return entryPrice - (stopLossPoints * point);
   else
      return entryPrice + (stopLossPoints * point);
}

double CalculateV10TurboTakeProfit(ENUM_SIGNAL_TYPE direction, double entryPrice)
{
   double point = SymbolInfoDouble(TradeSymbol, SYMBOL_POINT);
   double takeProfitPoints = 20.0; // Quick profit for turbo
   
   if(direction == SIGNAL_TURBO_BUY)
      return entryPrice + (takeProfitPoints * point);
   else
      return entryPrice - (takeProfitPoints * point);
}

double CalculateV10ForceStopLoss(ENUM_SIGNAL_TYPE direction, double entryPrice, double atr)
{
   double stopLoss = MathMax(atr * 1.0, StopLossPoints * SymbolInfoDouble(TradeSymbol, SYMBOL_POINT));
   
   if(direction == SIGNAL_FORCE_BUY)
      return entryPrice - stopLoss;
   else
      return entryPrice + stopLoss;
}

double CalculateV10ForceTakeProfit(ENUM_SIGNAL_TYPE direction, double entryPrice, double atr)
{
   double takeProfit = MathMax(atr * 2.0, TakeProfitPoints * SymbolInfoDouble(TradeSymbol, SYMBOL_POINT));
   
   if(direction == SIGNAL_FORCE_BUY)
      return entryPrice + takeProfit;
   else
      return entryPrice - takeProfit;
}

double CalculateV10RapidGrowthStopLoss(ENUM_SIGNAL_TYPE direction, double entryPrice, double atr)
{
   double stopLoss = atr * 0.8; // Tighter stop for rapid growth
   
   if(direction == SIGNAL_BUY)
      return entryPrice - stopLoss;
   else
      return entryPrice + stopLoss;
}

double CalculateV10RapidGrowthTakeProfit(ENUM_SIGNAL_TYPE direction, double entryPrice, double atr)
{
   double takeProfit = atr * 4.0; // Larger target for rapid growth
   
   if(direction == SIGNAL_BUY)
      return entryPrice + takeProfit;
   else
      return entryPrice - takeProfit;
}

//+------------------------------------------------------------------+
//| V10 Execute Ultra Signal                                        |
//+------------------------------------------------------------------+
void ExecuteV10UltraSignal(V10_UltraAggressiveSignal &signal)
{
   if(!CanTrade()) return;
   
   bool success = false;
   ulong ticket = 0;
   
   // Enhanced execution logic
   switch(signal.direction)
   {
      case SIGNAL_BUY:
      case SIGNAL_SCALP_BUY:
      case SIGNAL_FORCE_BUY:
      case SIGNAL_RECOVERY_BUY:
      case SIGNAL_TURBO_BUY:
         success = trade.Buy(signal.lotSize, TradeSymbol, signal.entryPrice, signal.stopLoss, signal.takeProfit, TradeComment + "_" + signal.signalReason);
         ticket = trade.ResultOrder();
         break;
         
      case SIGNAL_SELL:
      case SIGNAL_SCALP_SELL:
      case SIGNAL_FORCE_SELL:
      case SIGNAL_RECOVERY_SELL:
      case SIGNAL_TURBO_SELL:
         success = trade.Sell(signal.lotSize, TradeSymbol, signal.entryPrice, signal.stopLoss, signal.takeProfit, TradeComment + "_" + signal.signalReason);
         ticket = trade.ResultOrder();
         break;
   }
   
   if(success && ticket > 0)
   {
      // Add to V10 position tracking
      if(ActivePositions < MaxSimultaneousPositions)
      {
         PositionTickets[ActivePositions] = ticket;
         PositionOpenTimes[ActivePositions] = TimeCurrent();
         PositionProfits[ActivePositions] = 0.0;
         ActivePositions++;
      }
      
      TotalTrades++;
      TradesThisHour++;
      TradesThisDay++;
      LastTradeTime = TimeCurrent();
      
      // Enhanced logging
      LogV10UltraAggressiveTrade(signal, ticket);
      
      // Enhanced notifications
      if(EnableNotifications)
      {
         SendNotification(CreateV10UltraNotification(signal));
      }
      
      // Enhanced sound alerts
      if(EnableSoundAlerts)
      {
         if(signal.isTurbo)
            PlaySound("alert2.wav");
         else if(signal.isRapidGrowth)
            PlaySound("alert.wav");
         else
            PlaySound("tick.wav");
      }
   }
   else
   {
      Print("❌ V10 Trade execution failed: ", trade.ResultRetcode(), " - ", trade.ResultRetcodeDescription());
   }
}

//+------------------------------------------------------------------+
//| V10 Execute Ultra Aggressive Strategy                           |
//+------------------------------------------------------------------+
void ExecuteV10UltraAggressiveStrategy()
{
   // Generate multiple V10 signals simultaneously
   V10_UltraAggressiveSignal signals[];
   int signalCount = GenerateV10MultipleSignals(signals);
   
   // Execute up to max simultaneous positions
   for(int i = 0; i < signalCount && ActivePositions < MaxSimultaneousPositions; i++)
   {
      if(signals[i].confidence > 65.0 && CanTrade())
      {
         ExecuteV10UltraSignal(signals[i]);
      }
   }
}

//+------------------------------------------------------------------+
//| V10 Generate Multiple Signals                                   |
//+------------------------------------------------------------------+
int GenerateV10MultipleSignals(V10_UltraAggressiveSignal &signals[])
{
   ArrayResize(signals, 15); // Increased array size
   int count = 0;
   
   // M1 Ultra-fast Signal
   V10_UltraAggressiveSignal m1Signal = GenerateV10TimeframeSignal(PERIOD_M1, true);
   if(m1Signal.direction != SIGNAL_NONE)
   {
      signals[count] = m1Signal;
      count++;
   }
   
   // M5 Quick Signal
   V10_UltraAggressiveSignal m5Signal = GenerateV10TimeframeSignal(PERIOD_M5, false);
   if(m5Signal.direction != SIGNAL_NONE)
   {
      signals[count] = m5Signal;
      count++;
   }
   
   // Multiple additional signals can be added here
   
   return count;
}

//+------------------------------------------------------------------+
//| V10 Generate Timeframe Signal                                   |
//+------------------------------------------------------------------+
V10_UltraAggressiveSignal GenerateV10TimeframeSignal(ENUM_TIMEFRAMES timeframe, bool isScalp)
{
   V10_UltraAggressiveSignal signal;
   signal.direction = SIGNAL_NONE;
   signal.confidence = 0.0;
   signal.isScalp = isScalp;
   signal.timeframe = timeframe;
   signal.signalTime = TimeCurrent();
   signal.volumeBoost = EnableVolumeBooster ? VolumeMultiplier : 1.0;
   
   double currentPrice = SymbolInfoDouble(TradeSymbol, SYMBOL_ASK);
   
   // Get enhanced indicator values
   double rsiValue[], macdMain[], macdSignal[], ma5[], ma20[], ma50[];
   ArraySetAsSeries(rsiValue, true);
   ArraySetAsSeries(macdMain, true);
   ArraySetAsSeries(macdSignal, true);
   ArraySetAsSeries(ma5, true);
   ArraySetAsSeries(ma20, true);
   ArraySetAsSeries(ma50, true);
   
   // Copy enhanced indicator data
   if(CopyBuffer(RSI_Handle, 0, 0, 5, rsiValue) <= 0) return signal;
   if(CopyBuffer(MACD_Handle, 0, 0, 5, macdMain) <= 0) return signal;
   if(CopyBuffer(MACD_Handle, 1, 0, 5, macdSignal) <= 0) return signal;
   if(CopyBuffer(MA_Handle_5, 0, 0, 5, ma5) <= 0) return signal;
   if(CopyBuffer(MA_Handle_20, 0, 0, 5, ma20) <= 0) return signal;
   if(CopyBuffer(MA_Handle_50, 0, 0, 5, ma50) <= 0) return signal;
   
   double rsi = rsiValue[0];
   
   // Enhanced signal logic
   double bullishScore = 0.0;
   double bearishScore = 0.0;
   
   // Enhanced RSI scoring
   if(rsi < 25) bullishScore += 40.0;
   if(rsi > 75) bearishScore += 40.0;
   if(rsi > 45 && rsi < 75) bullishScore += 15.0;
   if(rsi < 55 && rsi > 25) bearishScore += 15.0;
   
   // Enhanced MA scoring
   if(currentPrice > ma5[0] && ma5[0] > ma20[0] && ma20[0] > ma50[0]) bullishScore += 35.0;
   if(currentPrice < ma5[0] && ma5[0] < ma20[0] && ma20[0] < ma50[0]) bearishScore += 35.0;
   
   // Enhanced MACD scoring
   if(macdMain[0] > macdSignal[0] && macdMain[1] <= macdSignal[1]) bullishScore += 25.0;
   if(macdMain[0] < macdSignal[0] && macdMain[1] >= macdSignal[1]) bearishScore += 25.0;
   
   // Enhanced price action scoring
   double priceChange = (currentPrice - ma20[0]) / ma20[0] * 100;
   if(priceChange > 0.08) bullishScore += 20.0;
   if(priceChange < -0.08) bearishScore += 20.0;
   
   // V10 momentum boost
   if(marketState.turboFactor > 1.2) {
      bullishScore *= 1.2;
      bearishScore *= 1.2;
   }
   
   // Determine enhanced signal
   if(bullishScore > bearishScore && bullishScore >= 60.0)
   {
      signal.direction = isScalp ? SIGNAL_SCALP_BUY : SIGNAL_BUY;
      signal.confidence = bullishScore;
      signal.signalReason = "V10_Bullish_" + EnumToString(timeframe);
   }
   else if(bearishScore > bullishScore && bearishScore >= 60.0)
   {
      signal.direction = isScalp ? SIGNAL_SCALP_SELL : SIGNAL_SELL;
      signal.confidence = bearishScore;
      signal.signalReason = "V10_Bearish_" + EnumToString(timeframe);
   }
   
   // Set enhanced signal parameters
   if(signal.direction != SIGNAL_NONE)
   {
      signal.entryPrice = currentPrice;
      signal.urgency = isScalp ? 98.0 : 85.0;
      
      if(isScalp)
      {
         signal.stopLoss = CalculateV10ScalpStopLoss(signal.direction, currentPrice);
         signal.takeProfit = CalculateV10ScalpTakeProfit(signal.direction, currentPrice);
      }
      else
      {
         signal.stopLoss = CalculateV10StopLoss(signal.direction, currentPrice);
         signal.takeProfit = CalculateV10TakeProfit(signal.direction, currentPrice);
      }
      
      signal.lotSize = CalculateV10AggressiveLotSize(signal.stopLoss, currentPrice, isScalp);
      signal.lotSize *= signal.volumeBoost; // Apply volume booster
      signal.riskReward = MathAbs(signal.takeProfit - signal.entryPrice) / MathAbs(signal.entryPrice - signal.stopLoss);
      signal.expectedProfit = signal.lotSize * MathAbs(signal.takeProfit - signal.entryPrice) * 100000;
      
      // Apply V10 progressive profit system
      if(EnableProgressiveProfit)
      {
         ApplyV10ProgressiveProfit(signal);
      }
   }
   
   return signal;
}

//+------------------------------------------------------------------+
//| V10 Calculate Enhanced Stop Loss and Take Profit                |
//+------------------------------------------------------------------+
double CalculateV10ScalpStopLoss(ENUM_SIGNAL_TYPE direction, double entryPrice)
{
   double point = SymbolInfoDouble(TradeSymbol, SYMBOL_POINT);
   double stopLossPoints = 12.0; // Optimized for V10
   
   if(direction == SIGNAL_SCALP_BUY)
      return entryPrice - (stopLossPoints * point);
   else
      return entryPrice + (stopLossPoints * point);
}

double CalculateV10ScalpTakeProfit(ENUM_SIGNAL_TYPE direction, double entryPrice)
{
   double point = SymbolInfoDouble(TradeSymbol, SYMBOL_POINT);
   
   if(direction == SIGNAL_SCALP_BUY)
      return entryPrice + (ScalpProfitPoints * point);
   else
      return entryPrice - (ScalpProfitPoints * point);
}

double CalculateV10StopLoss(ENUM_SIGNAL_TYPE direction, double entryPrice)
{
   double point = SymbolInfoDouble(TradeSymbol, SYMBOL_POINT);
   
   if(direction == SIGNAL_BUY)
      return entryPrice - (StopLossPoints * point);
   else
      return entryPrice + (StopLossPoints * point);
}

double CalculateV10TakeProfit(ENUM_SIGNAL_TYPE direction, double entryPrice)
{
   double point = SymbolInfoDouble(TradeSymbol, SYMBOL_POINT);
   
   if(direction == SIGNAL_BUY)
      return entryPrice + (TakeProfitPoints * point);
   else
      return entryPrice - (TakeProfitPoints * point);
}

//+------------------------------------------------------------------+
//| V10 Execute Strategies                                          |
//+------------------------------------------------------------------+
void ExecuteV10FlipModeStrategy()
{
   if(!EnableFlipMode) return;
   
   // Check if we've reached the target
   if(AccountBalance >= WeeklyTarget)
   {
      FlipModeActive = false;
      Print("🎯🎯🎯 V10 FLIP MODE COMPLETE! TARGET REACHED: $", AccountBalance, " 🎯🎯🎯");
      SendNotification("🎯 GOLDEX AI V10 - $100K TARGET REACHED! 🎯");
      return;
   }
   
   // Generate V10 flip mode signal
   V10_UltraAggressiveSignal flipSignal = GenerateV10TimeframeSignal(FlipTimeframe, false);
   
   if(flipSignal.direction != SIGNAL_NONE && flipSignal.confidence >= 65.0 && CanTrade())
   {
      // Enhanced lot size for flip mode
      flipSignal.lotSize *= 2.0; // Double the lot size
      flipSignal.signalReason = "V10_FLIP_MODE";
      flipSignal.volumeBoost = EnableVolumeBooster ? VolumeMultiplier * 2.0 : 2.0;
      
      ExecuteV10UltraSignal(flipSignal);
   }
}

void ExecuteV10ScalpingStrategy()
{
   if(!CanTrade()) return;
   
   // Generate V10 scalping signals
   V10_UltraAggressiveSignal scalpSignal = GenerateV10TimeframeSignal(PERIOD_M1, true);
   
   if(scalpSignal.direction != SIGNAL_NONE && scalpSignal.confidence >= 60.0)
   {
      if(ActivePositions < MaxSimultaneousPositions)
      {
         ExecuteV10UltraSignal(scalpSignal);
      }
   }
}

void ExecuteV10LossRecoveryStrategy()
{
   if(ConsecutiveLosses < 2) return;
   
   V10_UltraAggressiveSignal recoverySignal;
   recoverySignal.isRecovery = true;
   recoverySignal.confidence = 90.0;
   recoverySignal.urgency = 98.0;
   recoverySignal.signalTime = TimeCurrent();
   recoverySignal.signalReason = "V10_LOSS_RECOVERY_" + IntegerToString(ConsecutiveLosses);
   recoverySignal.volumeBoost = EnableVolumeBooster ? VolumeMultiplier * 1.5 : 1.5;
   
   // Generate V10 aggressive recovery signal
   recoverySignal = GenerateV10RecoverySignal();
   
   if(recoverySignal.direction != SIGNAL_NONE && ActivePositions < MaxSimultaneousPositions)
   {
      ExecuteV10UltraSignal(recoverySignal);
   }
}

//+------------------------------------------------------------------+
//| V10 Generate Recovery Signal                                    |
//+------------------------------------------------------------------+
V10_UltraAggressiveSignal GenerateV10RecoverySignal()
{
   V10_UltraAggressiveSignal signal;
   signal.direction = SIGNAL_NONE;
   signal.isRecovery = true;
   signal.confidence = 85.0;
   signal.urgency = 95.0;
   signal.signalTime = TimeCurrent();
   signal.entryPrice = SymbolInfoDouble(TradeSymbol, SYMBOL_ASK);
   signal.volumeBoost = EnableVolumeBooster ? VolumeMultiplier * 1.5 : 1.5;
   
   // Enhanced recovery approach
   double currentPrice = signal.entryPrice;
   
   // V10 trend following for recovery
   double ma5[], ma20[], rsi[];
   ArraySetAsSeries(ma5, true);
   ArraySetAsSeries(ma20, true);
   ArraySetAsSeries(rsi, true);
   
   if(CopyBuffer(MA_Handle_5, 0, 0, 3, ma5) > 0 && 
      CopyBuffer(MA_Handle_20, 0, 0, 3, ma20) > 0 &&
      CopyBuffer(RSI_Handle, 0, 0, 3, rsi) > 0)
   {
      // Enhanced recovery logic
      if(currentPrice > ma5[0] && ma5[0] > ma20[0] && rsi[0] < 65)
      {
         signal.direction = SIGNAL_RECOVERY_BUY;
         signal.confidence = 90.0;
      }
      else if(currentPrice < ma5[0] && ma5[0] < ma20[0] && rsi[0] > 35)
      {
         signal.direction = SIGNAL_RECOVERY_SELL;
         signal.confidence = 90.0;
      }
      
      // Enhanced recovery parameters
      if(signal.direction != SIGNAL_NONE)
      {
         signal.stopLoss = CalculateV10RecoveryStopLoss(signal.direction, currentPrice);
         signal.takeProfit = CalculateV10RecoveryTakeProfit(signal.direction, currentPrice);
         signal.lotSize = CalculateV10RecoveryLotSize(signal.stopLoss, currentPrice);
         signal.lotSize *= signal.volumeBoost; // Apply volume booster
         signal.riskReward = MathAbs(signal.takeProfit - signal.entryPrice) / MathAbs(signal.entryPrice - signal.stopLoss);
         signal.expectedProfit = signal.lotSize * MathAbs(signal.takeProfit - signal.entryPrice) * 100000;
         
         // Apply enhanced progressive profit
         if(EnableProgressiveProfit)
         {
            ApplyV10ProgressiveProfit(signal);
         }
      }
   }
   
   return signal;
}

//+------------------------------------------------------------------+
//| V10 Calculate Recovery Parameters                               |
//+------------------------------------------------------------------+
double CalculateV10RecoveryStopLoss(ENUM_SIGNAL_TYPE direction, double entryPrice)
{
   double point = SymbolInfoDouble(TradeSymbol, SYMBOL_POINT);
   double stopLossPoints = 20.0; // Optimized stop for recovery
   
   if(direction == SIGNAL_RECOVERY_BUY)
      return entryPrice - (stopLossPoints * point);
   else
      return entryPrice + (stopLossPoints * point);
}

double CalculateV10RecoveryTakeProfit(ENUM_SIGNAL_TYPE direction, double entryPrice)
{
   double point = SymbolInfoDouble(TradeSymbol, SYMBOL_POINT);
   double takeProfitPoints = 60.0; // Enhanced target for recovery
   
   if(direction == SIGNAL_RECOVERY_BUY)
      return entryPrice + (takeProfitPoints * point);
   else
      return entryPrice - (takeProfitPoints * point);
}

double CalculateV10RecoveryLotSize(double stopLoss, double entryPrice)
{
   double balance = account.Balance();
   double riskPercent = MathMin(20.0, RiskPercentage * (1.0 + ConsecutiveLosses * 0.3));
   double riskAmount = balance * (riskPercent / 100.0);
   
   double stopLossPoints = MathAbs(entryPrice - stopLoss);
   double tickValue = SymbolInfoDouble(TradeSymbol, SYMBOL_TRADE_TICK_VALUE);
   double lotSize = riskAmount / (stopLossPoints * tickValue * 100000);
   
   // Enhanced normalization for recovery
   double minLot = SymbolInfoDouble(TradeSymbol, SYMBOL_VOLUME_MIN);
   double maxLot = SymbolInfoDouble(TradeSymbol, SYMBOL_VOLUME_MAX);
   double lotStep = SymbolInfoDouble(TradeSymbol, SYMBOL_VOLUME_STEP);
   
   lotSize = MathMax(lotSize, minLot * 3.0); // Minimum 3x lot size for recovery
   lotSize = MathMin(lotSize, maxLot);
   lotSize = MathRound(lotSize / lotStep) * lotStep;
   
   return lotSize;
}

//+------------------------------------------------------------------+
//| V10 Manage All Positions                                        |
//+------------------------------------------------------------------+
void ManageV10AllPositions()
{
   for(int i = ActivePositions - 1; i >= 0; i--)
   {
      if(position.SelectByTicket(PositionTickets[i]))
      {
         // Update position profit
         PositionProfits[i] = position.Profit();
         
         // Enhanced quick exit
         if(PositionProfits[i] >= QuickExitPoints)
         {
            if(trade.PositionClose(PositionTickets[i]))
            {
               WinningTrades++;
               ConsecutiveWins++;
               ConsecutiveLosses = 0;
               RemoveV10PositionFromTracking(i);
               
               Print("✅ V10 Quick Exit Profit: $", PositionProfits[i]);
               continue;
            }
         }
         
         // Enhanced trailing stop
         if(TrailingStopPoints > 0)
         {
            ApplyV10TrailingStop(PositionTickets[i]);
         }
         
         // Enhanced time-based exit
         if(TimeCurrent() - PositionOpenTimes[i] > 180) // 3 minutes
         {
            if(PositionProfits[i] > 0) // Only close if profitable
            {
               if(trade.PositionClose(PositionTickets[i]))
               {
                  WinningTrades++;
                  ConsecutiveWins++;
                  ConsecutiveLosses = 0;
                  RemoveV10PositionFromTracking(i);
                  
                  Print("✅ V10 Time-based Exit Profit: $", PositionProfits[i]);
               }
            }
         }
      }
      else
      {
         // Position closed externally, remove from tracking
         RemoveV10PositionFromTracking(i);
      }
   }
}

//+------------------------------------------------------------------+
//| V10 Apply Trailing Stop                                         |
//+------------------------------------------------------------------+
void ApplyV10TrailingStop(ulong ticket)
{
   if(position.SelectByTicket(ticket))
   {
      double point = SymbolInfoDouble(TradeSymbol, SYMBOL_POINT);
      double currentPrice = (position.PositionType() == POSITION_TYPE_BUY) ? 
                           SymbolInfoDouble(TradeSymbol, SYMBOL_BID) : 
                           SymbolInfoDouble(TradeSymbol, SYMBOL_ASK);
      
      double newStopLoss = 0.0;
      bool shouldModify = false;
      
      if(position.PositionType() == POSITION_TYPE_BUY)
      {
         newStopLoss = currentPrice - (TrailingStopPoints * point);
         shouldModify = (newStopLoss > position.StopLoss());
      }
      else if(position.PositionType() == POSITION_TYPE_SELL)
      {
         newStopLoss = currentPrice + (TrailingStopPoints * point);
         shouldModify = (newStopLoss < position.StopLoss() || position.StopLoss() == 0);
      }
      
      if(shouldModify)
      {
         if(trade.PositionModify(ticket, newStopLoss, position.TakeProfit()))
         {
            Print("✅ V10 Trailing Stop Updated: ", newStopLoss);
         }
      }
   }
}

//+------------------------------------------------------------------+
//| V10 Helper Functions                                            |
//+------------------------------------------------------------------+
void RemoveV10PositionFromTracking(int index)
{
   if(index >= 0 && index < ActivePositions)
   {
      // Shift remaining positions
      for(int i = index; i < ActivePositions - 1; i++)
      {
         PositionTickets[i] = PositionTickets[i + 1];
         PositionOpenTimes[i] = PositionOpenTimes[i + 1];
         PositionProfits[i] = PositionProfits[i + 1];
      }
      
      ActivePositions--;
   }
}

void UpdateV10PositionTracking()
{
   // Clean up closed positions
   for(int i = ActivePositions - 1; i >= 0; i--)
   {
      if(!position.SelectByTicket(PositionTickets[i]))
      {
         RemoveV10PositionFromTracking(i);
      }
   }
}

void ForceV10TradeEntry()
{
   if(!AlwaysInTrade || !CanTrade()) return;
   
   // Generate a V10 forced entry signal
   V10_UltraAggressiveSignal forceSignal = GenerateV10ForceSignal();
   
   if(forceSignal.direction != SIGNAL_NONE)
   {
      ExecuteV10UltraSignal(forceSignal);
   }
}

//+------------------------------------------------------------------+
//| V10 Update Functions                                            |
//+------------------------------------------------------------------+
void UpdateV10AccountInfo()
{
   AccountBalance = account.Balance();
   double equity = account.Equity();
   
   CurrentDrawdown = ((InitialBalance - equity) / InitialBalance) * 100.0;
   MaxDrawdown = MathMax(MaxDrawdown, CurrentDrawdown);
   
   if(TotalTrades > 0)
   {
      WinRate = (double)WinningTrades / TotalTrades * 100.0;
   }
   
   // Calculate growth rate
   double growthRate = ((AccountBalance - InitialBalance) / InitialBalance) * 100.0;
   
   // Update market state with account info
   marketState.turboFactor = 1.0 + (growthRate / 100.0);
   marketState.isRapidGrowthTime = (growthRate < 10.0);
}

void UpdateV10MarketState()
{
   // Get enhanced market data
   double currentPrice = SymbolInfoDouble(TradeSymbol, SYMBOL_ASK);
   double ma5[], ma20[], ma50[], atr[], rsi[];
   
   ArraySetAsSeries(ma5, true);
   ArraySetAsSeries(ma20, true);
   ArraySetAsSeries(ma50, true);
   ArraySetAsSeries(atr, true);
   ArraySetAsSeries(rsi, true);
   
   if(CopyBuffer(MA_Handle_5, 0, 0, 3, ma5) > 0 && 
      CopyBuffer(MA_Handle_20, 0, 0, 3, ma20) > 0 && 
      CopyBuffer(MA_Handle_50, 0, 0, 3, ma50) > 0 && 
      CopyBuffer(ATR_Handle, 0, 0, 3, atr) > 0 &&
      CopyBuffer(RSI_Handle, 0, 0, 3, rsi) > 0)
   {
      marketState.inUptrend = (currentPrice > ma5[0] && ma5[0] > ma20[0] && ma20[0] > ma50[0]);
      marketState.inDowntrend = (currentPrice < ma5[0] && ma5[0] < ma20[0] && ma20[0] < ma50[0]);
      marketState.inRange = (!marketState.inUptrend && !marketState.inDowntrend);
      marketState.volatility = atr[0];
      marketState.momentum = (currentPrice - ma20[0]) / ma20[0] * 100;
      marketState.strength = MathAbs(marketState.momentum);
      marketState.opportunity = marketState.strength * (marketState.volatility * 1000);
      marketState.marketSpeed = MathAbs(rsi[0] - 50.0) / 50.0; // Market speed indicator
      
      // Enhanced turbo factor calculation
      marketState.turboFactor = 1.0 + (marketState.marketSpeed * 0.5);
   }
}

//+------------------------------------------------------------------+
//| V10 Setup Functions                                             |
//+------------------------------------------------------------------+
void SetupV10UltraAggressiveMode()
{
   // Configure for V10 maximum aggression
   trade.SetExpertMagicNumber(MagicNumber);
   trade.SetDeviationInPoints(5); // Tighter deviation for better fills
   trade.SetTypeFilling(ORDER_FILLING_IOC);
   
   Print("🔥🔥🔥 V10 ULTRA AGGRESSIVE MODE CONFIGURED 🔥🔥🔥");
   Print("⚡ Max Positions: ", MaxSimultaneousPositions);
   Print("💨 Scalp Profit: ", ScalpProfitPoints, " points");
   Print("🎯 Quick Exit: ", QuickExitPoints, " points");
   Print("⏰ Trade Frequency: ", ActualTradeFrequency, " seconds (FIXED)");
   Print("🎰 Progressive Profit: ", EnableProgressiveProfit ? "✅ ON" : "❌ OFF");
   Print("🚀 Turbo Mode: ", EnableTurboMode ? "✅ ON" : "❌ OFF");
   Print("💪 Volume Booster: ", EnableVolumeBooster ? "✅ ON" : "❌ OFF");
   Print("⚡ Smart Martingale: ", EnableSmartMartingale ? "✅ ON" : "❌ OFF");
}

void SetupV10FlipModeTargets()
{
   DailyTarget = InitialBalance * 1.0; // 100% daily growth target
   WeeklyTarget = InitialBalance * GrowthTargetMultiplier; // 100x growth target
   FlipModeActive = true;
   
   Print("🚀🚀🚀 V10 FLIP MODE TARGETS SET 🚀🚀🚀");
   Print("📊 Daily Target: $", DailyTarget);
   Print("🎯 Weekly Target: $", WeeklyTarget);
   Print("💎 Growth Multiplier: ", GrowthTargetMultiplier, "x");
}

void InitializeV10Stats()
{
   stats.totalTrades = 0;
   stats.winningTrades = 0;
   stats.losingTrades = 0;
   stats.totalProfit = 0.0;
   stats.totalLoss = 0.0;
   stats.largestWin = 0.0;
   stats.largestLoss = 0.0;
   stats.averageWin = 0.0;
   stats.averageLoss = 0.0;
   stats.profitFactor = 0.0;
   stats.winRate = 0.0;
   stats.maxConsecutiveWins = 0;
   stats.maxConsecutiveLosses = 0;
   stats.maxDrawdown = 0.0;
   stats.recovery = 0.0;
   stats.growthRate = 0.0;
   stats.turboProfit = 0.0;
   stats.sessionStart = TimeCurrent();
}

void UpdateV10Stats()
{
   stats.totalTrades = TotalTrades;
   stats.winningTrades = WinningTrades;
   stats.losingTrades = TotalTrades - WinningTrades;
   stats.winRate = WinRate;
   stats.maxConsecutiveWins = MathMax(stats.maxConsecutiveWins, ConsecutiveWins);
   stats.maxConsecutiveLosses = MathMax(stats.maxConsecutiveLosses, ConsecutiveLosses);
   stats.maxDrawdown = MaxDrawdown;
   stats.recovery = (AccountBalance - InitialBalance) / InitialBalance * 100.0;
   stats.growthRate = stats.recovery;
   
   // Enhanced V10 statistics
   if(stats.totalTrades > 0)
   {
      stats.profitFactor = (stats.totalProfit > 0 && stats.totalLoss > 0) ? 
                          (stats.totalProfit / stats.totalLoss) : 0.0;
   }
}

//+------------------------------------------------------------------+
//| V10 Logging Functions                                           |
//+------------------------------------------------------------------+
void LogV10UltraAggressiveTrade(V10_UltraAggressiveSignal &signal, ulong ticket)
{
   string logMessage = StringFormat("🔥🔥🔥 V10 ULTRA AGGRESSIVE TRADE #%d 🔥🔥🔥\n" +
                                   "Time: %s | Ticket: %d\n" +
                                   "Signal: %s | Reason: %s\n" +
                                   "Entry: %.5f | SL: %.5f | TP: %.5f\n" +
                                   "Lot Size: %.3f | Confidence: %.0f%%\n" +
                                   "R:R: %.2f | Expected: $%.2f\n" +
                                   "Volume Boost: %.1fx | Turbo: %s\n" +
                                   "Consecutive Wins: %d | Losses: %d\n" +
                                   "Active: %d/%d | Trades/Hour: %d/%d\n" +
                                   "Growth: %.1f%% | Balance: $%.2f",
                                   TotalTrades,
                                   TimeToString(TimeCurrent()),
                                   ticket,
                                   EnumToString(signal.direction),
                                   signal.signalReason,
                                   signal.entryPrice,
                                   signal.stopLoss,
                                   signal.takeProfit,
                                   signal.lotSize,
                                   signal.confidence,
                                   signal.riskReward,
                                   signal.expectedProfit,
                                   signal.volumeBoost,
                                   signal.isTurbo ? "YES" : "NO",
                                   ConsecutiveWins,
                                   ConsecutiveLosses,
                                   ActivePositions,
                                   MaxSimultaneousPositions,
                                   TradesThisHour,
                                   MaxTradesPerHour,
                                   stats.growthRate,
                                   AccountBalance);
   
   Print(logMessage);
}

string CreateV10UltraNotification(V10_UltraAggressiveSignal &signal)
{
   string bonusText = "";
   if(ConsecutiveWins >= WinStreakForBonus)
   {
      bonusText = " 🎰 MEGA BONUS!";
   }
   else if(ConsecutiveWins >= 2)
   {
      bonusText = " 🚀 PROGRESSIVE!";
   }
   
   if(signal.isTurbo)
   {
      bonusText += " ⚡ TURBO!";
   }
   
   if(signal.isRapidGrowth)
   {
      bonusText += " 💎 RAPID GROWTH!";
   }
   
   return StringFormat("🔥 V10 ULTRA AGGRESSIVE SIGNAL%s\n" +
                      "Signal: %s | Confidence: %.0f%%\n" +
                      "Entry: %.5f | R:R: %.2f | Boost: %.1fx\n" +
                      "Expected: $%.2f | Frequency: %ds\n" +
                      "Growth: %.1f%% | Target: $%.0f\n" +
                      "Wins: %d | Losses: %d | Active: %d/%d",
                      bonusText,
                      EnumToString(signal.direction),
                      signal.confidence,
                      signal.entryPrice,
                      signal.riskReward,
                      signal.volumeBoost,
                      signal.expectedProfit,
                      ActualTradeFrequency,
                      stats.growthRate,
                      WeeklyTarget,
                      ConsecutiveWins,
                      ConsecutiveLosses,
                      ActivePositions,
                      MaxSimultaneousPositions);
}

void SaveV10Stats()
{
   Print("🔥🔥🔥 V10 ULTRA AGGRESSIVE TRADING SESSION COMPLETE 🔥🔥🔥");
   Print("💰 Total Trades: ", TotalTrades);
   Print("🎯 Win Rate: ", WinRate, "%");
   Print("💵 Final Balance: $", AccountBalance);
   Print("📊 Growth Rate: ", stats.growthRate, "%");
   Print("💎 Max Drawdown: ", MaxDrawdown, "%");
   Print("🏆 Max Consecutive Wins: ", stats.maxConsecutiveWins);
   Print("💥 Max Consecutive Losses: ", stats.maxConsecutiveLosses);
   Print("⚡ Trades This Hour: ", TradesThisHour);
   Print("📅 Trades This Day: ", TradesThisDay);
   Print("🔄 Trade Frequency: ", ActualTradeFrequency, " seconds (FIXED)");
   Print("🚀 Flip Mode Status: ", FlipModeActive ? "ACTIVE" : "COMPLETE");
   Print("💪 Profit Factor: ", stats.profitFactor);
   Print("🎯 Target Progress: ", (AccountBalance/WeeklyTarget)*100, "%");
   
   string finalMessage = StringFormat("🎯 V10 SESSION COMPLETE!\n" +
                                     "Started: $%.2f\n" +
                                     "Ended: $%.2f\n" +
                                     "Growth: %.1f%%\n" +
                                     "Trades: %d\n" +
                                     "Win Rate: %.1f%%\n" +
                                     "Target: $%.0f (%.1f%%)",
                                     InitialBalance,
                                     AccountBalance,
                                     stats.growthRate,
                                     TotalTrades,
                                     WinRate,
                                     WeeklyTarget,
                                     (AccountBalance/WeeklyTarget)*100);
   
   SendNotification(finalMessage);
}

//+------------------------------------------------------------------+
//| OnTrade Event Handler                                           |
//+------------------------------------------------------------------+
void OnTrade()
{
   // Enhanced trade event handling
   for(int i = 0; i < HistoryDealsTotal(); i++)
   {
      ulong ticket = HistoryDealGetTicket(i);
      if(HistoryDealGetInteger(ticket, DEAL_MAGIC) == MagicNumber)
      {
         double profit = HistoryDealGetDouble(ticket, DEAL_PROFIT);
         
         if(profit > 0)
         {
            ConsecutiveWins++;
            ConsecutiveLosses = 0;
            stats.totalProfit += profit;
            stats.turboProfit += profit;
            
            string winMessage = StringFormat("✅ V10 WIN: +$%.2f | Streak: %d | Growth: %.1f%%",
                                           profit, ConsecutiveWins, stats.growthRate);
            Print(winMessage);
            
            if(profit > 50.0) // Significant win
            {
               SendNotification(winMessage);
            }
         }
         else if(profit < 0)
         {
            ConsecutiveLosses++;
            ConsecutiveWins = 0;
            stats.totalLoss += MathAbs(profit);
            
            string lossMessage = StringFormat("❌ V10 LOSS: -$%.2f | Streak: %d | Activating Recovery",
                                            MathAbs(profit), ConsecutiveLosses);
            Print(lossMessage);
            
            if(MathAbs(profit) > 50.0) // Significant loss
            {
               SendNotification(lossMessage);
            }
         }
      }
   }
   
   // Update enhanced statistics
   UpdateV10Stats();
   
   // Check for milestone achievements
   CheckV10Milestones();
}

//+------------------------------------------------------------------+
//| V10 Check Milestones                                            |
//+------------------------------------------------------------------+
void CheckV10Milestones()
{
   static double lastMilestone = 0.0;
   double currentGrowth = stats.growthRate;
   
   // Check for growth milestones
   if(currentGrowth >= 25.0 && lastMilestone < 25.0)
   {
      SendNotification("🎯 V10 MILESTONE: 25% Growth Achieved!");
      lastMilestone = 25.0;
   }
   else if(currentGrowth >= 50.0 && lastMilestone < 50.0)
   {
      SendNotification("🎯 V10 MILESTONE: 50% Growth Achieved!");
      lastMilestone = 50.0;
   }
   else if(currentGrowth >= 100.0 && lastMilestone < 100.0)
   {
      SendNotification("🎯 V10 MILESTONE: 100% Growth Achieved!");
      lastMilestone = 100.0;
   }
   else if(currentGrowth >= 500.0 && lastMilestone < 500.0)
   {
      SendNotification("🎯 V10 MILESTONE: 500% Growth Achieved!");
      lastMilestone = 500.0;
   }
   else if(currentGrowth >= 1000.0 && lastMilestone < 1000.0)
   {
      SendNotification("🎯 V10 MILESTONE: 1000% Growth Achieved!");
      lastMilestone = 1000.0;
   }
   else if(currentGrowth >= 5000.0 && lastMilestone < 5000.0)
   {
      SendNotification("🎯 V10 MILESTONE: 5000% Growth Achieved!");
      lastMilestone = 5000.0;
   }
   else if(currentGrowth >= 10000.0 && lastMilestone < 10000.0)
   {
      SendNotification("🎯🎯🎯 V10 ULTIMATE MILESTONE: 10000% GROWTH! TARGET ACHIEVED! 🎯🎯🎯");
      lastMilestone = 10000.0;
   }
}

//+------------------------------------------------------------------+
