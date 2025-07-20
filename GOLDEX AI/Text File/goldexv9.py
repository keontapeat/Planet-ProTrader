#!/usr/bin/env python3
"""
GOLDEX AI Ultra Aggressive Trading Bot - Real Demo Account Setup
Compatible with Linode VPS and mt5linux installation
"""

import sys
import time
import datetime
import logging
from typing import Dict, List, Optional, Tuple
import json
import os


    -------------------------------------------------
    from supabase import create_client
    SUPA_URL = os.getenv("SUPA_URL")
    SUPA_KEY = os.getenv("SUPA_KEY")
    supabase = create_client(SUPA_URL, SUPA_KEY)
    -------------------------------------------------
    

# Fix the MetaTrader5 import issue for mt5linux
try:
    import mt5linux as mt5
    print("✓ Successfully imported mt5linux")
    MT5_AVAILABLE = True
except ImportError:
    print("❌ mt5linux not found. Please install: pip install mt5linux")
    MT5_AVAILABLE = False
    sys.exit(1)  # Exit if mt5linux is not available

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('goldex_bot.log'),
        logging.StreamHandler(sys.stdout)
    ]
)
logger = logging.getLogger(__name__)

class GoldexBot:
    def __init__(self):
        self.symbol = "XAUUSD"
        self.risk_percentage = 2.0  # Reduced for demo safety
        self.trade_frequency_seconds = 300
        self.enable_martingale = False
        self.martingale_multiplier = 2.0
        self.enable_progressive_risk = True
        self.max_risk_percentage = 5.0  # Reduced for demo safety
        self.enable_notifications = True
        
        # Trading stats
        self.total_trades = 0
        self.winning_trades = 0
        self.consecutive_wins = 0
        self.consecutive_losses = 0
        self.max_drawdown = 0.0
        self.initial_balance = 0.0
        self.current_multiplier = 1.0
        
        # Market state
        self.market_state = {
            'in_uptrend': False,
            'in_downtrend': False,
            'in_range': False,
            'volatility': 0.0,
            'momentum': 0.0,
            'strength': 0.0,
            'opportunity': 0.0
        }
        
        self.last_trade_time = 0
        self.is_connected = False
        
        # Demo account credentials - UPDATE THESE WITH YOUR DETAILS
        self.demo_login = None      # Your demo account number
        self.demo_password = None   # Your demo account password
        self.demo_server = None     # Your broker server (e.g., "MetaQuotes-Demo")
        
    def set_demo_credentials(self, login: int, password: str, server: str):
        """Set demo account credentials"""
        self.demo_login = login
        self.demo_password = password
        self.demo_server = server
        logger.info(f"Demo credentials set for account: {login}")
        
    def connect_mt5(self):
        """Connect to MT5 terminal with demo account"""
        if not MT5_AVAILABLE:
            logger.error("mt5linux not available. Cannot connect to real account.")
            return False
            
        # Initialize MT5
        if not mt5.initialize():
            logger.error(f"Failed to initialize MT5: {mt5.last_error()}")
            return False
            
        logger.info("✓ MT5 initialized successfully")
        
        # Check if credentials are provided
        if not all([self.demo_login, self.demo_password, self.demo_server]):
            logger.error("❌ Demo account credentials not provided!")
            logger.error("Please set credentials using: bot.set_demo_credentials(login, password, server)")
            return False
            
        # Login to demo account
        if not mt5.login(self.demo_login, password=self.demo_password, server=self.demo_server):
            logger.error(f"❌ Failed to login to demo account: {mt5.last_error()}")
            return False
            
        # Get account info
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
        
        # Verify symbol exists
        symbol_info = mt5.symbol_info(self.symbol)
        if symbol_info is None:
            logger.error(f"❌ Symbol {self.symbol} not found!")
            return False
            
        logger.info(f"✅ Symbol {self.symbol} verified - Spread: {symbol_info.spread}")
        
        return True
        
    def get_symbol_info(self):
        """Get symbol information"""
        if not self.is_connected:
            logger.error("Not connected to MT5")
            return None
            
        symbol_info = mt5.symbol_info(self.symbol)
        if symbol_info is None:
            logger.error(f"Failed to get symbol info for {self.symbol}")
            return None
            
        return symbol_info
        
    def get_current_price(self):
        """Get current price"""
        if not self.is_connected:
            logger.error("Not connected to MT5")
            return None
            
        tick = mt5.symbol_info_tick(self.symbol)
        if tick is None:
            logger.error(f"Failed to get tick for {self.symbol}")
            return None
            
        return {'bid': tick.bid, 'ask': tick.ask}
        
    def get_rates(self, timeframe, count=100):
        """Get historical rates"""
        if not self.is_connected:
            logger.error("Not connected to MT5")
            return None
            
        rates = mt5.copy_rates_from_pos(self.symbol, timeframe, 0, count)
        if rates is None:
            logger.error(f"Failed to get rates for {self.symbol}")
            return None
            
        return rates
        
    def calculate_rsi(self, prices, period=14):
        """Calculate RSI"""
        if len(prices) < period + 1:
            return 50.0
            
        deltas = [prices[i] - prices[i-1] for i in range(1, len(prices))]
        gains = [max(0, delta) for delta in deltas]
        losses = [abs(min(0, delta)) for delta in deltas]
        
        avg_gain = sum(gains[-period:]) / period
        avg_loss = sum(losses[-period:]) / period
        
        if avg_loss == 0:
            return 100.0
            
        rs = avg_gain / avg_loss
        rsi = 100 - (100 / (1 + rs))
        
        return rsi
        
    def calculate_moving_average(self, prices, period):
        """Calculate simple moving average"""
        if len(prices) < period:
            return prices[-1] if prices else 0.0
            
        return sum(prices[-period:]) / period
        
    def calculate_atr(self, high_prices, low_prices, close_prices, period=14):
        """Calculate Average True Range"""
        if len(high_prices) < period + 1:
            return 0.001  # Default small value
            
        true_ranges = []
        for i in range(1, len(high_prices)):
            high_low = high_prices[i] - low_prices[i]
            high_close = abs(high_prices[i] - close_prices[i-1])
            low_close = abs(low_prices[i] - close_prices[i-1])
            true_ranges.append(max(high_low, high_close, low_close))
            
        return sum(true_ranges[-period:]) / period
        
    def analyze_market(self):
        """Analyze market conditions"""
        rates = self.get_rates(mt5.TIMEFRAME_M15, 100)
        if rates is None:
            logger.error("Failed to get market data")
            return None
            
        close_prices = [rate['close'] for rate in rates]
        high_prices = [rate['high'] for rate in rates]
        low_prices = [rate['low'] for rate in rates]
            
        current_price = close_prices[-1]
        
        # Calculate indicators
        rsi = self.calculate_rsi(close_prices)
        ma_5 = self.calculate_moving_average(close_prices, 5)
        ma_20 = self.calculate_moving_average(close_prices, 20)
        ma_50 = self.calculate_moving_average(close_prices, 50)
        atr = self.calculate_atr(high_prices, low_prices, close_prices)
        
        # Update market state
        self.market_state['in_uptrend'] = (current_price > ma_20 and ma_20 > ma_50)
        self.market_state['in_downtrend'] = (current_price < ma_20 and ma_20 < ma_50)
        self.market_state['in_range'] = not (self.market_state['in_uptrend'] or self.market_state['in_downtrend'])
        self.market_state['volatility'] = atr
        self.market_state['momentum'] = (current_price - ma_20) / ma_20 * 100
        self.market_state['strength'] = abs(self.market_state['momentum'])
        self.market_state['opportunity'] = self.market_state['strength'] * (self.market_state['volatility'] * 1000)
        
        return {
            'current_price': current_price,
            'rsi': rsi,
            'ma_5': ma_5,
            'ma_20': ma_20,
            'ma_50': ma_50,
            'atr': atr,
            'market_state': self.market_state
        }
        
    def generate_signal(self):
        """Generate trading signal"""
        analysis = self.analyze_market()
        if analysis is None:
            return None
            
        current_price = analysis['current_price']
        rsi = analysis['rsi']
        ma_5 = analysis['ma_5']
        ma_20 = analysis['ma_20']
        ma_50 = analysis['ma_50']
        atr = analysis['atr']
        
        bullish_score = 0.0
        bearish_score = 0.0
        
        # RSI signals
        if rsi < 30:
            bullish_score += 30.0
        elif rsi > 70:
            bearish_score += 30.0
        elif 50 < rsi <= 70:
            bullish_score += 10.0
        elif 30 <= rsi < 50:
            bearish_score += 10.0
            
        # Moving average signals
        if current_price > ma_5 and ma_5 > ma_20 and ma_20 > ma_50:
            bullish_score += 25.0
        elif current_price < ma_5 and ma_5 < ma_20 and ma_20 < ma_50:
            bearish_score += 25.0
            
        # Volatility boost
        if atr > 0.001:  # High volatility
            bullish_score += 10.0
            bearish_score += 10.0
            
        signal = {
            'direction': 'NONE',
            'confidence': 0.0,
            'entry_price': current_price,
            'stop_loss': 0.0,
            'take_profit': 0.0,
            'lot_size': 0.0,
            'reason': 'No signal'
        }
        
        if bullish_score > bearish_score and bullish_score >= 50.0:
            signal['direction'] = 'BUY'
            signal['confidence'] = bullish_score
            signal['stop_loss'] = current_price - atr * 2
            signal['take_profit'] = current_price + atr * 4
            signal['reason'] = f'Bullish signal (RSI: {rsi:.1f}, Score: {bullish_score:.1f})'
        elif bearish_score > bullish_score and bearish_score >= 50.0:
            signal['direction'] = 'SELL'
            signal['confidence'] = bearish_score
            signal['stop_loss'] = current_price + atr * 2
            signal['take_profit'] = current_price - atr * 4
            signal['reason'] = f'Bearish signal (RSI: {rsi:.1f}, Score: {bearish_score:.1f})'
            
        if signal['direction'] != 'NONE':
            signal['lot_size'] = self.calculate_lot_size(signal['stop_loss'], signal['entry_price'])
            
        return signal
        
    def calculate_lot_size(self, stop_loss, entry_price):
        """Calculate lot size based on risk management"""
        if not self.is_connected:
            return 0.01
            
        account_info = mt5.account_info()
        if account_info is None:
            return 0.01
            
        balance = account_info.balance
        risk_percent = self.risk_percentage
        
        # Progressive risk adjustment
        if self.consecutive_losses > 2 and self.enable_progressive_risk:
            risk_percent = min(self.max_risk_percentage, risk_percent * (1.0 + self.consecutive_losses * 0.3))
            
        # Martingale adjustment
        if self.enable_martingale and self.consecutive_losses > 0:
            self.current_multiplier = self.martingale_multiplier ** self.consecutive_losses
        else:
            self.current_multiplier = 1.0
            
        risk_amount = balance * (risk_percent / 100.0) * self.current_multiplier
        stop_loss_points = abs(entry_price - stop_loss)
        
        # Get symbol info for proper calculation
        symbol_info = self.get_symbol_info()
        if symbol_info is None:
            return 0.01
            
        # Calculate lot size based on gold specifications
        if stop_loss_points > 0:
            # For XAUUSD, 1 lot = 100 oz, point value varies by broker
            point_value = 1.0  # Adjust based on your broker
            lot_size = risk_amount / (stop_loss_points * point_value * 100)
        else:
            lot_size = 0.01
            
        # Ensure lot size is within broker limits
        lot_size = max(symbol_info.volume_min, min(symbol_info.volume_max, lot_size))
        
        # Round to broker's step size
        lot_size = round(lot_size / symbol_info.volume_step) * symbol_info.volume_step
        
        return lot_size
        
    def execute_trade(self, signal):
        """Execute trade based on signal"""
        if signal['direction'] == 'NONE':
            return False
            
        if not self.is_connected:
            logger.error("Not connected to MT5 - cannot execute trade")
            return False
            
        # Real MT5 trade execution
        symbol_info = self.get_symbol_info()
        if symbol_info is None:
            logger.error("Cannot get symbol info")
            return False
            
        price = self.get_current_price()
        if price is None:
            logger.error("Cannot get current price")
            return False
            
        # Prepare trade request
        request = {
            "action": mt5.TRADE_ACTION_DEAL,
            "symbol": self.symbol,
            "volume": signal['lot_size'],
            "type": mt5.ORDER_TYPE_BUY if signal['direction'] == 'BUY' else mt5.ORDER_TYPE_SELL,
            "price": price['ask'] if signal['direction'] == 'BUY' else price['bid'],
            "sl": signal['stop_loss'],
            "tp": signal['take_profit'],
            "deviation": 20,
            "magic": 234000,
            "comment": "GOLDEX AI DEMO",
            "type_time": mt5.ORDER_TIME_GTC,
            "type_filling": mt5.ORDER_FILLING_IOC,
        }
        
        logger.info(f"🎯 Executing {signal['direction']} trade...")
        logger.info(f"📊 Volume: {signal['lot_size']} lots")
        logger.info(f"💰 Price: {request['price']:.5f}")
        logger.info(f"🛑 Stop Loss: {signal['stop_loss']:.5f}")
        logger.info(f"🎯 Take Profit: {signal['take_profit']:.5f}")
        
        # Send trade request
        result = mt5.order_send(request)
        if result is None:
            logger.error("❌ Trade execution failed - no result")
            return False
            
        if result.retcode != mt5.TRADE_RETCODE_DONE:
            logger.error(f"❌ Trade failed with retcode: {result.retcode}")
            logger.error(f"Error: {result.comment}")
            return False
            
        self.total_trades += 1
        logger.info(f"✅ Trade executed successfully!")
        logger.info(f"📝 Order: {result.order}")
        logger.info(f"🎫 Deal: {result.deal}")
        logger.info(f"📊 Volume: {result.volume}")
        
        return True
        
    def get_account_stats(self):
        """Get current account statistics"""
        if not self.is_connected:
            logger.error("Not connected to MT5")
            return None
            
        account_info = mt5.account_info()
        if account_info is None:
            logger.error("Cannot get account info")
            return None
            
        # Get open positions
        positions = mt5.positions_get(symbol=self.symbol)
        open_positions = len(positions) if positions else 0
        
        win_rate = (self.winning_trades / self.total_trades * 100) if self.total_trades > 0 else 0
        
        return {
            'balance': account_info.balance,
            'equity': account_info.equity,
            'margin': account_info.margin,
            'free_margin': account_info.margin_free,
            'profit': account_info.profit,
            'open_positions': open_positions,
            'total_trades': self.total_trades,
            'winning_trades': self.winning_trades,
            'win_rate': win_rate,
            'consecutive_wins': self.consecutive_wins,
            'consecutive_losses': self.consecutive_losses,
            'current_multiplier': self.current_multiplier
        }
        
    def print_status(self):
        """Print current status"""
        stats = self.get_account_stats()
        if stats is None:
            logger.error("Cannot get account stats")
            return
            
        analysis = self.analyze_market()
        if analysis is None:
            logger.error("Cannot analyze market")
            return
            
        print(f"\n{'='*60}")
        print(f"🏆 GOLDEX AI - LIVE DEMO TRADING")
        print(f"{'='*60}")
        print(f"💰 Balance: ${stats['balance']:.2f}")
        print(f"📊 Equity: ${stats['equity']:.2f}")
        print(f"💸 Profit: ${stats['profit']:.2f}")
        print(f"🎯 Win Rate: {stats['win_rate']:.1f}%")
        print(f"📈 Total Trades: {stats['total_trades']}")
        print(f"🔥 Consecutive Wins: {stats['consecutive_wins']}")
        print(f"❄️  Consecutive Losses: {stats['consecutive_losses']}")
        print(f"📍 Open Positions: {stats['open_positions']}")
        print(f"⚡ Current Price: ${analysis['current_price']:.5f}")
        print(f"📊 RSI: {analysis['rsi']:.1f}")
        print(f"🎯 Market State: {'📈 UPTREND' if analysis['market_state']['in_uptrend'] else '📉 DOWNTREND' if analysis['market_state']['in_downtrend'] else '📊 RANGE'}")
        print(f"🔥 Opportunity Score: {analysis['market_state']['opportunity']:.2f}")
        print(f"{'='*60}")
        
    def run(self):
        """Main trading loop"""
        logger.info("🚀 Starting GOLDEX AI - Demo Trading Mode")
        
        if not self.connect_mt5():
            logger.error("❌ Failed to connect to MT5. Exiting...")
            return
            
        try:
            while True:
                current_time = time.time()
                
                # Check if enough time has passed since last trade
                if current_time - self.last_trade_time >= self.trade_frequency_seconds:
                    
                    # Print current status
                    self.print_status()
                    
                    # Generate signal
                    signal = self.generate_signal()
                    if signal and signal['direction'] != 'NONE':
                        logger.info(f"🎯 Signal generated: {signal['direction']} (Confidence: {signal['confidence']:.1f}%)")
                        
                        # Execute trade
                        if self.execute_trade(signal):
                            self.last_trade_time = current_time
                            
                            if self.enable_notifications:
                                logger.info(f"📱 Trade executed: {signal['direction']} at {signal['entry_price']:.5f}")
                    else:
                        logger.info("⏳ No trading signal generated - waiting for opportunity")
                        
                # Sleep for a short time to prevent excessive CPU usage
                time.sleep(30)  # Check every 30 seconds
                
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
    """Main function with demo account setup"""
    bot = GoldexBot()
    
    # SET YOUR DEMO ACCOUNT CREDENTIALS HERE
    # Replace with your actual demo account details
    DEMO_LOGIN    = 845638            # <— your demo account number
    DEMO_PASSWORD = "GI7#svVJbBekrg"  # <— your demo password
    DEMO_SERVER   = "Coinexx-demo"    # <— your broker’s server name
    
    print("🚀 GOLDEX AI - Demo Account Setup")
    print("=" * 50)
    
    if not all([DEMO_LOGIN, DEMO_PASSWORD, DEMO_SERVER]):
        print("❌ Please set your demo account credentials in the script!")
        print("Update the following variables:")
        print("DEMO_LOGIN = 845638  # Your demo account number")
        print("DEMO_PASSWORD = 'GI7#svVJbBekrg'  # Your demo password")
        print("DEMO_SERVER = 'Coinexx-demo'  # Your broker server")
        return
        
    # Set demo credentials
    bot.set_demo_credentials(DEMO_LOGIN, DEMO_PASSWORD, DEMO_SERVER)
    
    # Run the bot
    bot.run()

if __name__ == "__main__":
    main()
