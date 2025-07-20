#!/usr/bin/env python3
"""
GOLDEX AI Ultra Aggressive Trading Bot - Fixed for mt5linux
Compatible with Linode VPS and mt5linux installation
"""

import sys
import time
import datetime
import logging
from typing import Dict, List, Optional, Tuple
import json

# Fix the MetaTrader5 import issue for mt5linux
try:
    import mt5linux as mt5
    print("✓ Successfully imported mt5linux")
    MT5_AVAILABLE = True
except ImportError:
    print("❌ mt5linux not found. Please install: pip install mt5linux")
    MT5_AVAILABLE = False
    # Create a mock mt5 module for testing
    class MockMT5:
        def initialize(self): return False
        def login(self, *args): return False
        def terminal_info(self): return None
        def account_info(self): return None
        def symbol_info(self, symbol): return None
        def symbol_info_tick(self, symbol): return None
        def copy_rates_from_pos(self, *args): return None
        def positions_get(self, *args): return []
        def orders_get(self, *args): return []
        def order_send(self, *args): return None
        def shutdown(self): pass
        
        # Constants
        TRADE_ACTION_DEAL = 1
        ORDER_TYPE_BUY = 0
        ORDER_TYPE_SELL = 1
        ORDER_FILLING_IOC = 1
        ORDER_TIME_GTC = 0
        
    mt5 = MockMT5()

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
        self.risk_percentage = 5.0
        self.trade_frequency_seconds = 300
        self.enable_martingale = False
        self.martingale_multiplier = 2.0
        self.enable_progressive_risk = True
        self.max_risk_percentage = 10.0
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
        
    def connect_mt5(self, login: int = None, password: str = None, server: str = None):
        """Connect to MT5 terminal"""
        if not MT5_AVAILABLE:
            logger.error("mt5linux not available. Running in mock mode.")
            return False
            
        if not mt5.initialize():
            logger.error("Failed to initialize MT5")
            return False
            
        if login and password and server:
            if not mt5.login(login, password=password, server=server):
                logger.error(f"Failed to login to MT5: {mt5.last_error()}")
                return False
                
        # Get account info
        account_info = mt5.account_info()
        if account_info is None:
            logger.error("Failed to get account info")
            return False
            
        self.initial_balance = account_info.balance
        self.is_connected = True
        
        logger.info(f"✓ Connected to MT5")
        logger.info(f"Account: {account_info.login}")
        logger.info(f"Server: {account_info.server}")
        logger.info(f"Balance: ${account_info.balance:.2f}")
        
        return True
        
    def get_symbol_info(self):
        """Get symbol information"""
        if not self.is_connected:
            return self._mock_symbol_info()
            
        symbol_info = mt5.symbol_info(self.symbol)
        if symbol_info is None:
            logger.error(f"Failed to get symbol info for {self.symbol}")
            return None
            
        return symbol_info
        
    def get_current_price(self):
        """Get current price"""
        if not self.is_connected:
            return self._mock_price()
            
        tick = mt5.symbol_info_tick(self.symbol)
        if tick is None:
            logger.error(f"Failed to get tick for {self.symbol}")
            return None
            
        return {'bid': tick.bid, 'ask': tick.ask}
        
    def get_rates(self, timeframe, count=100):
        """Get historical rates"""
        if not self.is_connected:
            return self._mock_rates(count)
            
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
        rates = self.get_rates(mt5.TIMEFRAME_M15 if self.is_connected else 15, 100)
        if rates is None:
            return None
            
        if self.is_connected:
            close_prices = [rate['close'] for rate in rates]
            high_prices = [rate['high'] for rate in rates]
            low_prices = [rate['low'] for rate in rates]
        else:
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
            return 0.01  # Mock lot size
            
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
        
        # Simple lot size calculation for gold
        if stop_loss_points > 0:
            lot_size = risk_amount / (stop_loss_points * 100)  # Simplified for gold
        else:
            lot_size = 0.01
            
        # Ensure lot size is within limits
        lot_size = max(0.01, min(10.0, lot_size))
        lot_size = round(lot_size, 2)
        
        return lot_size
        
    def execute_trade(self, signal):
        """Execute trade based on signal"""
        if signal['direction'] == 'NONE':
            return False
            
        if not self.is_connected:
            logger.info(f"🔄 MOCK TRADE: {signal['direction']} {signal['lot_size']} lots at {signal['entry_price']:.5f}")
            logger.info(f"📊 Reason: {signal['reason']}")
            self.total_trades += 1
            # Mock 70% win rate
            if self.total_trades % 10 <= 7:
                self.winning_trades += 1
                self.consecutive_wins += 1
                self.consecutive_losses = 0
                logger.info("✅ MOCK TRADE WON")
            else:
                self.consecutive_losses += 1
                self.consecutive_wins = 0
                logger.info("❌ MOCK TRADE LOST")
            return True
            
        # Real MT5 trade execution
        symbol_info = self.get_symbol_info()
        if symbol_info is None:
            return False
            
        price = self.get_current_price()
        if price is None:
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
            "comment": "GOLDEX AI",
            "type_time": mt5.ORDER_TIME_GTC,
            "type_filling": mt5.ORDER_FILLING_IOC,
        }
        
        # Send trade request
        result = mt5.order_send(request)
        if result is None:
            logger.error("Trade execution failed")
            return False
            
        if result.retcode != mt5.TRADE_RETCODE_DONE:
            logger.error(f"Trade failed: {result.retcode}")
            return False
            
        self.total_trades += 1
        logger.info(f"✅ Trade executed: {signal['direction']} {signal['lot_size']} lots")
        logger.info(f"📊 Entry: {request['price']:.5f}, SL: {signal['stop_loss']:.5f}, TP: {signal['take_profit']:.5f}")
        
        return True
        
    def get_account_stats(self):
        """Get current account statistics"""
        if not self.is_connected:
            return self._mock_account_stats()
            
        account_info = mt5.account_info()
        if account_info is None:
            return None
            
        win_rate = (self.winning_trades / self.total_trades * 100) if self.total_trades > 0 else 0
        
        return {
            'balance': account_info.balance,
            'equity': account_info.equity,
            'margin': account_info.margin,
            'free_margin': account_info.margin_free,
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
            return
            
        analysis = self.analyze_market()
        if analysis is None:
            return
            
        status_mode = "🔴 MOCK MODE" if not self.is_connected else "🟢 LIVE MODE"
        
        print(f"\n{'='*60}")
        print(f"🏆 GOLDEX AI ULTRA AGGRESSIVE - {status_mode}")
        print(f"{'='*60}")
        print(f"💰 Balance: ${stats['balance']:.2f}")
        print(f"📊 Equity: ${stats['equity']:.2f}")
        print(f"🎯 Win Rate: {stats['win_rate']:.1f}%")
        print(f"📈 Total Trades: {stats['total_trades']}")
        print(f"🔥 Consecutive Wins: {stats['consecutive_wins']}")
        print(f"❄️  Consecutive Losses: {stats['consecutive_losses']}")
        print(f"⚡ Current Price: ${analysis['current_price']:.5f}")
        print(f"📊 RSI: {analysis['rsi']:.1f}")
        print(f"🎯 Market State: {'📈 UPTREND' if analysis['market_state']['in_uptrend'] else '📉 DOWNTREND' if analysis['market_state']['in_downtrend'] else '📊 RANGE'}")
        print(f"🔥 Opportunity Score: {analysis['market_state']['opportunity']:.2f}")
        print(f"{'='*60}")
        
    def run(self):
        """Main trading loop"""
        logger.info("🚀 Starting GOLDEX AI Ultra Aggressive Bot")
        
        if not self.connect_mt5():
            logger.warning("⚠️  Running in MOCK MODE - No real trades will be executed")
            
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
                                logger.info(f"📱 Notification: {signal['direction']} trade executed")
                    else:
                        logger.info("⏳ No trading signal generated")
                        
                # Sleep for a short time to prevent excessive CPU usage
                time.sleep(30)  # Check every 30 seconds
                
        except KeyboardInterrupt:
            logger.info("🛑 Bot stopped by user")
        except Exception as e:
            logger.error(f"❌ Error in main loop: {e}")
        finally:
            if self.is_connected:
                mt5.shutdown()
                logger.info("🔌 MT5 connection closed")
                
    def _mock_symbol_info(self):
        """Mock symbol info for testing"""
        class MockSymbolInfo:
            spread = 0.5
            digits = 5
            point = 0.00001
            trade_tick_value = 1.0
            trade_tick_size = 0.00001
            volume_min = 0.01
            volume_max = 10.0
            volume_step = 0.01
            
        return MockSymbolInfo()
        
    def _mock_price(self):
        """Mock price for testing"""
        import random
        base_price = 2000.0
        spread = 0.5
        return {
            'bid': base_price + random.uniform(-10, 10),
            'ask': base_price + random.uniform(-10, 10) + spread
        }
        
    def _mock_rates(self, count):
        """Mock rates for testing"""
        import random
        rates = []
        base_price = 2000.0
        
        for i in range(count):
            price = base_price + random.uniform(-50, 50)
            rates.append({
                'time': time.time() - (count - i) * 900,  # 15-minute intervals
                'open': price,
                'high': price + random.uniform(0, 5),
                'low': price - random.uniform(0, 5),
                'close': price + random.uniform(-2, 2),
                'tick_volume': random.randint(100, 1000)
            })
            
        return rates
        
    def _mock_account_stats(self):
        """Mock account stats for testing"""
        return {
            'balance': 10000.0 + self.winning_trades * 100 - (self.total_trades - self.winning_trades) * 50,
            'equity': 10000.0 + self.winning_trades * 100 - (self.total_trades - self.winning_trades) * 50,
            'margin': 100.0,
            'free_margin': 9900.0,
            'total_trades': self.total_trades,
            'winning_trades': self.winning_trades,
            'win_rate': (self.winning_trades / self.total_trades * 100) if self.total_trades > 0 else 0,
            'consecutive_wins': self.consecutive_wins,
            'consecutive_losses': self.consecutive_losses,
            'current_multiplier': self.current_multiplier
        }

if __name__ == "__main__":
    bot = GoldexBot()
    
    # Optional: Add your MT5 credentials here
    # bot.connect_mt5(login=YOUR_LOGIN, password="YOUR_PASSWORD", server="YOUR_SERVER")
    
    bot.run()
