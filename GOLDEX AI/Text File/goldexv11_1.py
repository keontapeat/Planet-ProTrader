#!/usr/bin/env python3
"""
GOLDEX AI Ultra Aggressive Trading Bot V10 - Demo/VPS Ready
Features: Flip Mode, Turbo Mode, Rapid Growth, Volume Booster, Credentials, and Full Terminal/VPS Compatibility
"""

import sys
import time
import datetime
import logging
import os

# If you want Supabase, uncomment and configure below:
# from supabase import create_client
# SUPA_URL = os.getenv("SUPA_URL")
# SUPA_KEY = os.getenv("SUPA_KEY")
# supabase = create_client(SUPA_URL, SUPA_KEY)

try:
    import mt5linux as mt5
    print("✓ Successfully imported mt5linux")
    MT5_AVAILABLE = True
except ImportError:
    print("❌ mt5linux not found. Please install: pip install mt5linux")
    MT5_AVAILABLE = False
    sys.exit(1)

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('goldex_bot_v10.log'),
        logging.StreamHandler(sys.stdout)
    ]
)
logger = logging.getLogger(__name__)

class GoldexBotV10:
    def __init__(self):
        # --- V10 User Settings ---
        self.symbol = "XAUUSD"
        self.risk_percentage = 15.0              # Increased risk for aggressive growth
        self.max_risk_percentage = 25.0
        self.trade_frequency_seconds = 60        # Trade every 1 min (customizable)
        self.enable_martingale = True
        self.martingale_multiplier = 2.0
        self.enable_progressive_risk = True
        self.enable_flip_mode = True
        self.enable_turbo_mode = True
        self.turbo_interval = 5                  # Turbo mode checks every 5 sec
        self.enable_volume_booster = True
        self.volume_multiplier = 2.0
        self.enable_rapid_growth = True
        self.max_simultaneous_positions = 10
        self.enable_notifications = True

        # --- Credentials (set in main) ---
        self.demo_login = None
        self.demo_password = None
        self.demo_server = None

        # --- Stats ---
        self.total_trades = 0
        self.winning_trades = 0
        self.consecutive_wins = 0
        self.consecutive_losses = 0
        self.max_drawdown = 0.0
        self.initial_balance = 0.0
        self.current_multiplier = 1.0
        self.last_trade_time = 0

        # --- Market state (reuse from v9) ---
        self.market_state = {
            'in_uptrend': False,
            'in_downtrend': False,
            'in_range': False,
            'volatility': 0.0,
            'momentum': 0.0,
            'strength': 0.0,
            'opportunity': 0.0
        }
        self.is_connected = False

    def set_demo_credentials(self, login, password, server):
        self.demo_login = login
        self.demo_password = password
        self.demo_server = server
        logger.info(f"Demo credentials set for account: {login}")

    def connect_mt5(self):
        if not MT5_AVAILABLE:
            logger.error("mt5linux not available. Cannot connect to real account.")
            return False

        if not mt5.initialize():
            logger.error(f"Failed to initialize MT5: {mt5.last_error()}")
            return False
        logger.info("✓ MT5 initialized successfully")

        if not all([self.demo_login, self.demo_password, self.demo_server]):
            logger.error("❌ Demo account credentials not provided!")
            logger.error("Please set credentials using: bot.set_demo_credentials(login, password, server)")
            return False

        if not mt5.login(self.demo_login, password=self.demo_password, server=self.demo_server):
            logger.error(f"❌ Failed to login to demo account: {mt5.last_error()}")
            return False

        account_info = mt5.account_info()
        if account_info is None:
            logger.error("❌ Failed to get account info")
            return False

        self.initial_balance = account_info.balance
        self.is_connected = True

        logger.info(f"✅ Successfully connected to DEMO account!")
        logger.info(f"📊 Account: {account_info.login}")
        logger.info(f"🏦 Server: {account_info.server}")
        logger.info(f"💰 Balance: ${account_info.balance:.2f}")
        logger.info(f"📈 Equity: ${account_info.equity:.2f}")
        logger.info(f"🏷️  Currency: {account_info.currency}")
        logger.info(f"🎯 Leverage: 1:{account_info.leverage}")

        symbol_info = mt5.symbol_info(self.symbol)
        if symbol_info is None:
            logger.error(f"❌ Symbol {self.symbol} not found!")
            return False

        logger.info(f"✅ Symbol {self.symbol} verified - Spread: {symbol_info.spread}")
        return True

    # --- Use the methods from V9 for market, indicators, get_rates/get_symbol_info/get_current_price etc...
    # You can copy-paste these as-is from your V9 script!

    def calculate_lot_size(self, stop_loss, entry_price):
        """Calculate lot size based on risk management and V10 settings."""
        if not self.is_connected:
            return 0.01

        account_info = mt5.account_info()
        if account_info is None:
            return 0.01

        balance = account_info.balance
        risk_percent = self.risk_percentage

        # Progressive/Escalating risk logic
        if self.consecutive_losses > 2 and self.enable_progressive_risk:
            risk_percent = min(self.max_risk_percentage, risk_percent * (1.0 + self.consecutive_losses * 0.3))

        # Martingale logic
        if self.enable_martingale and self.consecutive_losses > 0:
            self.current_multiplier = self.martingale_multiplier ** self.consecutive_losses
        else:
            self.current_multiplier = 1.0

        # Volume booster logic
        volume_boost = self.volume_multiplier if self.enable_volume_booster else 1.0

        risk_amount = balance * (risk_percent / 100.0) * self.current_multiplier * volume_boost
        stop_loss_points = abs(entry_price - stop_loss)
        symbol_info = self.get_symbol_info()
        if symbol_info is None:
            return 0.01

        # Calculation for XAUUSD (Gold) - 1 lot = 100 oz
        if stop_loss_points > 0:
            point_value = 1.0  # Adjust based on broker if needed
            lot_size = risk_amount / (stop_loss_points * point_value * 100)
        else:
            lot_size = 0.01

        # Enforce broker limits and step
        lot_size = max(symbol_info.volume_min, min(symbol_info.volume_max, lot_size))
        lot_size = round(lot_size / symbol_info.volume_step) * symbol_info.volume_step
        return lot_size

    # Reuse all indicator and signal logic from your File 63/v9 logic
    # Copy: get_rates, calculate_rsi, calculate_moving_average, calculate_atr,
    # analyze_market, generate_signal, get_symbol_info, get_current_price, execute_trade, etc.

    def run(self):
        logger.info("🚀 Starting GOLDEX V10 - Demo Trading Mode")
        if not self.connect_mt5():
            logger.error("❌ Failed to connect to MT5. Exiting...")
            return

        try:
            while True:
                current_time = time.time()
                # Flip Mode and Turbo Mode
                turbo_condition = self.enable_turbo_mode and ((current_time - self.last_trade_time) >= self.turbo_interval)
                flip_condition = self.enable_flip_mode and ((current_time - self.last_trade_time) >= self.trade_frequency_seconds)

                # Turbo trades (aggressive, scalping)
                if turbo_condition:
                    logger.info("⚡ V10 Turbo Mode: Checking for turbo trade...")
                    # ... (insert turbo signal/scalp logic, e.g., call generate_signal() and execute if strongest.)

                # Flip mode / normal frequency
                if flip_condition:
                    self.print_status()
                    signal = self.generate_signal()
                    if signal and signal['direction'] != 'NONE':
                        logger.info(f"🎯 Signal generated: {signal['direction']} (Confidence: {signal['confidence']:.1f}%)")
                        if self.execute_trade(signal):
                            self.last_trade_time = current_time
                            if self.enable_notifications:
                                logger.info(f"📱 Trade executed: {signal['direction']} at {signal['entry_price']:.5f}")
                    else:
                        logger.info("⏳ No signal generated - waiting for opportunity")

                time.sleep(self.turbo_interval if self.enable_turbo_mode else 30)
        except KeyboardInterrupt:
            logger.info("🛑 Bot stopped by user")
        except Exception as e:
            logger.error(f"❌ Error in main loop: {e}")
            import traceback
            traceback.print_exc()
        finally:
            if self.is_connected:
                mt5.shutdown()
                logger.info("🔌 MT5 connection closed")

def main():
    """DEMO ACCOUNT SETUP (update these with yours)"""
    bot = GoldexBotV10()

    DEMO_LOGIN    = 845638
    DEMO_PASSWORD = "GI7#svVJbBekrg"
    DEMO_SERVER   = "Coinexx-demo"

    print("🚀 GOLDEX AI V10 (Flip Mode, Turbo, Rapid Growth) - Demo Account Setup")
    print("=" * 50)

    if not all([DEMO_LOGIN, DEMO_PASSWORD, DEMO_SERVER]):
        print("❌ Please set your demo account credentials in the script!")
        print("Update: DEMO_LOGIN, DEMO_PASSWORD, DEMO_SERVER")
        return

    bot.set_demo_credentials(DEMO_LOGIN, DEMO_PASSWORD, DEMO_SERVER)
    bot.run()

if __name__ == "__main__":
    main()