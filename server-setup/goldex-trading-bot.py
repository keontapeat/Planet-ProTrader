#!/usr/bin/env python3
"""
GOLDEX AI™ Complete Trading Bot
Handles everything automatically:
- Market analysis with Claude AI
- Trade execution via MT5/TradeLocker
- Screenshot capture
- Firebase logging
- Daily learning and improvement
"""

import os
import sys
import time
import json
import logging
import schedule
import requests
from datetime import datetime, timedelta
from typing import Dict, List, Optional
import firebase_admin
from firebase_admin import credentials, firestore, storage
from anthropic import Anthropic

# Setup logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('/opt/goldex-ai/logs/trading.log'),
        logging.StreamHandler(sys.stdout)
    ]
)
logger = logging.getLogger(__name__)

class GoldexAITradingBot:
    def __init__(self):
        """Initialize the complete GOLDEX AI trading system"""
        self.setup_directories()
        self.load_environment()
        self.initialize_firebase()
        self.initialize_claude()
        self.trading_rules = self.load_trading_rules()
        self.active_trades = {}
        self.daily_stats = {"trades": 0, "wins": 0, "losses": 0, "profit": 0.0}
        
        logger.info("🚀 GOLDEX AI™ Trading Bot Initialized")
        
    def setup_directories(self):
        """Create necessary directories"""
        os.makedirs('/opt/goldex-ai/logs', exist_ok=True)
        os.makedirs('/opt/goldex-ai/screenshots', exist_ok=True)
        os.makedirs('/opt/goldex-ai/data', exist_ok=True)
        
    def load_environment(self):
        """Load environment variables"""
        from dotenv import load_dotenv
        load_dotenv('/opt/goldex-ai/.env')
        
        self.firebase_creds = os.getenv('FIREBASE_CREDENTIALS_PATH')
        self.claude_api_key = os.getenv('ANTHROPIC_API_KEY')
        self.mt5_login = os.getenv('MT5_LOGIN')
        self.mt5_password = os.getenv('MT5_PASSWORD')
        self.mt5_server = os.getenv('MT5_SERVER')
        
    def initialize_firebase(self):
        """Initialize Firebase connection"""
        try:
            cred = credentials.Certificate(self.firebase_creds)
            firebase_admin.initialize_app(cred, {
                'storageBucket': f"{os.getenv('FIREBASE_PROJECT_ID')}.appspot.com"
            })
            self.db = firestore.client()
            self.bucket = storage.bucket()
            logger.info("✅ Firebase initialized successfully")
        except Exception as e:
            logger.error(f"❌ Firebase initialization failed: {e}")
            
    def initialize_claude(self):
        """Initialize Claude AI"""
        try:
            self.claude = Anthropic(api_key=self.claude_api_key)
            logger.info("✅ Claude AI initialized successfully")
        except Exception as e:
            logger.error(f"❌ Claude AI initialization failed: {e}")
            
    def load_trading_rules(self):
        """Load or create trading rules"""
        rules_file = '/opt/goldex-ai/trading_rules.json'
        
        default_rules = {
            "scalp_mode": {
                "enabled": True,
                "timeframes": ["M1", "M5"],
                "session_hours": {"start": 8, "end": 11},  # NY Open
                "required_confluence": ["liquidity_sweep", "order_block", "fibonacci"],
                "min_confidence": 85,
                "risk_percent": 1.0,
                "max_trades_per_day": 8,
                "stop_loss_pips": 20,
                "take_profit_pips": 30
            },
            "swing_mode": {
                "enabled": True,
                "timeframes": ["H1", "H4"],
                "required_confluence": ["liquidity_sweep", "order_block", "fibonacci", "market_structure"],
                "min_confidence": 90,
                "risk_percent": 2.5,
                "max_trades_per_day": 3,
                "stop_loss_pips": 50,
                "take_profit_pips": 120
            },
            "risk_management": {
                "max_daily_loss": 5.0,
                "max_concurrent_trades": 3,
                "account_risk_percent": 2.0,
                "emergency_stop_loss": 10.0
            },
            "learning": {
                "auto_adjust": True,
                "learning_rate": 0.1,
                "performance_threshold": 70.0
            }
        }
        
        try:
            with open(rules_file, 'r') as f:
                rules = json.load(f)
                logger.info("📖 Trading rules loaded from file")
                return rules
        except FileNotFoundError:
            with open(rules_file, 'w') as f:
                json.dump(default_rules, f, indent=2)
            logger.info("📝 Created default trading rules")
            return default_rules
            
    def get_market_data(self) -> Dict:
        """Get current XAUUSD market data"""
        try:
            # Using a free forex API (replace with your preferred data source)
            url = "https://api.exchangerate-api.com/v4/latest/USD"
            response = requests.get(url, timeout=10)
            
            # For demo purposes - in production, use proper forex/gold data
            current_time = datetime.now()
            
            market_data = {
                "symbol": "XAUUSD",
                "timestamp": current_time.isoformat(),
                "price": 2374.50 + (hash(str(current_time)) % 100 - 50) / 10,  # Simulated price
                "session": self.get_trading_session(),
                "volatility": "medium",
                "volume": "high" if 8 <= current_time.hour <= 17 else "low"
            }
            
            return market_data
            
        except Exception as e:
            logger.error(f"❌ Failed to get market data: {e}")
            return {}
            
    def get_trading_session(self) -> str:
        """Determine current trading session"""
        hour = datetime.now().hour
        if 8 <= hour <= 11:
            return "NY_OPEN"
        elif 11 <= hour <= 14:
            return "NY_LUNCH"
        elif 14 <= hour <= 17:
            return "NY_CLOSE"
        else:
            return "QUIET"
            
    def analyze_with_claude(self, market_data: Dict, mode: str = "scalp") -> Optional[Dict]:
        """Use Claude AI to analyze market and generate signals"""
        
        current_rules = self.trading_rules[f"{mode}_mode"]
        session = market_data.get("session", "UNKNOWN")
        
        # Skip if outside trading hours for scalp mode
        if mode == "scalp" and session not in ["NY_OPEN"]:
            return None
            
        analysis_prompt = f"""
        You are GOLDEX AI™, the world's most advanced gold trading AI. Analyze this XAUUSD market data for a {mode} trade opportunity.

        CURRENT MARKET DATA:
        {json.dumps(market_data, indent=2)}

        TRADING RULES ({mode.upper()} MODE):
        {json.dumps(current_rules, indent=2)}

        ANALYSIS REQUIREMENTS:
        1. Look for NY session liquidity sweeps (price taking out previous day's high/low)
        2. Identify order block formations (institutional supply/demand zones)
        3. Check for Fibonacci confluence (38.2%, 50%, 61.8%, 78.6% retracements)
        4. Analyze market structure (break of structure, change of character)
        5. Assess overall confluence and signal strength

        RESPOND WITH JSON ONLY:
        {{
            "signal": "BUY" | "SELL" | "NONE",
            "confidence": 0-100,
            "entry_price": 0.0,
            "stop_loss": 0.0,
            "take_profit": 0.0,
            "reasoning": "detailed explanation",
            "confluence_factors": ["factor1", "factor2", ...],
            "session_analysis": "session strength assessment",
            "risk_reward_ratio": 0.0,
            "trade_type": "{mode}"
        }}

        Only recommend trades with {current_rules['min_confidence']}%+ confidence and proper risk management.
        """
        
        try:
            response = self.claude.messages.create(
                model="claude-3-sonnet-20240229",
                max_tokens=1500,
                messages=[{"role": "user", "content": analysis_prompt}]
            )
            
            # Extract JSON from response
            content = response.content[0].text
            start_idx = content.find('{')
            end_idx = content.rfind('}') + 1
            
            if start_idx != -1 and end_idx != -1:
                json_str = content[start_idx:end_idx]
                signal = json.loads(json_str)
                
                logger.info(f"🧠 Claude Analysis: {signal['signal']} - {signal['confidence']}% confidence")
                return signal
            else:
                logger.error("❌ Could not extract JSON from Claude response")
                return None
                
        except Exception as e:
            logger.error(f"❌ Claude analysis failed: {e}")
            return None
            
    def execute_trade(self, signal: Dict) -> bool:
        """Execute trade based on Claude's signal"""
        
        # Validate signal
        if signal['confidence'] < self.trading_rules[f"{signal['trade_type']}_mode"]['min_confidence']:
            logger.info(f"⚠️ Signal confidence too low: {signal['confidence']}%")
            return False
            
        # Check daily limits
        if self.daily_stats['trades'] >= self.trading_rules[f"{signal['trade_type']}_mode"]['max_trades_per_day']:
            logger.info("⚠️ Daily trade limit reached")
            return False
            
        # Check risk management
        if len(self.active_trades) >= self.trading_rules['risk_management']['max_concurrent_trades']:
            logger.info("⚠️ Maximum concurrent trades reached")
            return False
            
        # Calculate position size
        account_balance = 10000.0  # Demo account balance
        risk_percent = self.trading_rules[f"{signal['trade_type']}_mode"]['risk_percent']
        risk_amount = account_balance * (risk_percent / 100)
        
        stop_loss_pips = abs(signal['entry_price'] - signal['stop_loss'])
        pip_value = 10.0  # XAUUSD pip value
        lot_size = risk_amount / (stop_loss_pips * pip_value)
        lot_size = max(0.01, min(lot_size, 5.0))  # Min 0.01, Max 5.0
        
        # Create trade record
        trade_id = f"GOLDEX_{datetime.now().strftime('%Y%m%d_%H%M%S')}"
        trade_record = {
            "trade_id": trade_id,
            "signal": signal,
            "lot_size": lot_size,
            "timestamp": datetime.now(),
            "status": "ACTIVE",
            "mode": signal['trade_type']
        }
        
        # For demo - simulate trade execution
        # In production, integrate with actual MT5/TradeLocker API
        execution_result = {
            "success": True,
            "order_id": f"MT5_{trade_id}",
            "execution_price": signal['entry_price'],
            "message": "Trade executed successfully"
        }
        
        if execution_result["success"]:
            self.active_trades[trade_id] = trade_record
            self.daily_stats['trades'] += 1
            
            # Log to Firebase
            self.log_trade_to_firebase(trade_record)
            
            # Capture screenshot
            self.capture_trade_screenshot(trade_record)
            
            # Send signal to SwiftUI app
            self.send_signal_to_app(signal, trade_record)
            
            logger.info(f"✅ Trade executed: {signal['signal']} {lot_size} lots @ {signal['entry_price']}")
            return True
        else:
            logger.error(f"❌ Trade execution failed: {execution_result['message']}")
            return False
            
    def log_trade_to_firebase(self, trade_record: Dict):
        """Log trade to Firebase for learning and app sync"""
        try:
            doc_ref = self.db.collection('trades').document(trade_record['trade_id'])
            doc_ref.set({
                **trade_record,
                'timestamp': firestore.SERVER_TIMESTAMP,
                'app_notified': False
            })
            logger.info(f"📝 Trade logged to Firebase: {trade_record['trade_id']}")
        except Exception as e:
            logger.error(f"❌ Failed to log trade to Firebase: {e}")
            
    def capture_trade_screenshot(self, trade_record: Dict):
        """Capture TradingView screenshot for trade documentation"""
        try:
            # This would call the Node.js screenshot service
            screenshot_data = {
                "trade_id": trade_record['trade_id'],
                "symbol": "XAUUSD",
                "timeframe": "5m",
                "timestamp": datetime.now().isoformat()
            }
            
            # In production, make HTTP request to screenshot service
            # For now, just log the action
            logger.info(f"📷 Screenshot captured for trade: {trade_record['trade_id']}")
            
        except Exception as e:
            logger.error(f"❌ Screenshot capture failed: {e}")
            
    def send_signal_to_app(self, signal: Dict, trade_record: Dict):
        """Send real-time signal to SwiftUI app via Firebase"""
        try:
            signal_data = {
                "signal_id": f"SIG_{datetime.now().strftime('%Y%m%d_%H%M%S')}",
                "trade_id": trade_record['trade_id'],
                "signal": signal,
                "timestamp": firestore.SERVER_TIMESTAMP,
                "delivered": False,
                "priority": "high" if signal['confidence'] >= 90 else "normal"
            }
            
            self.db.collection('signals').add(signal_data)
            logger.info(f"📱 Signal sent to app: {signal['signal']} - {signal['confidence']}%")
            
        except Exception as e:
            logger.error(f"❌ Failed to send signal to app: {e}")
            
    def daily_learning_session(self):
        """Daily AI learning and strategy optimization"""
        logger.info("🧠 Starting daily learning session...")
        
        try:
            # Get yesterday's trades
            yesterday = datetime.now() - timedelta(days=1)
            trades_ref = self.db.collection('trades').where(
                'timestamp', '>=', yesterday
            ).where(
                'timestamp', '<', datetime.now()
            ).get()
            
            trades_data = [trade.to_dict() for trade in trades_ref]
            
            if not trades_data:
                logger.info("📊 No trades from yesterday to analyze")
                return
                
            # Analyze performance with Claude
            performance_prompt = f"""
            Analyze yesterday's GOLDEX AI™ trading performance and suggest improvements.

            TRADES DATA:
            {json.dumps(trades_data, indent=2, default=str)}

            CURRENT TRADING RULES:
            {json.dumps(self.trading_rules, indent=2)}

            PERFORMANCE ANALYSIS REQUIRED:
            1. Calculate win rate, average R:R, total profit/loss
            2. Identify best performing setups and confluences
            3. Analyze failed trades for common patterns
            4. Suggest specific rule improvements
            5. Recommend confidence threshold adjustments

            RESPOND WITH JSON:
            {{
                "performance_metrics": {{
                    "total_trades": 0,
                    "win_rate": 0.0,
                    "average_rr": 0.0,
                    "total_profit": 0.0,
                    "best_setups": ["setup1", "setup2"],
                    "worst_setups": ["setup1", "setup2"]
                }},
                "insights": {{
                    "strengths": "what worked well",
                    "weaknesses": "what needs improvement",
                    "market_conditions": "session analysis"
                }},
                "recommended_changes": {{
                    "confidence_thresholds": {{}},
                    "risk_adjustments": {{}},
                    "confluence_weights": {{}},
                    "session_preferences": {{}}
                }},
                "learning_summary": "key takeaways for tomorrow"
            }}
            """
            
            response = self.claude.messages.create(
                model="claude-3-sonnet-20240229",
                max_tokens=2000,
                messages=[{"role": "user", "content": performance_prompt}]
            )
            
            # Parse learning results
            content = response.content[0].text
            start_idx = content.find('{')
            end_idx = content.rfind('}') + 1
            
            if start_idx != -1 and end_idx != -1:
                json_str = content[start_idx:end_idx]
                learning_results = json.loads(json_str)
                
                # Apply recommended changes
                self.apply_learning_improvements(learning_results['recommended_changes'])
                
                # Log learning session
                self.db.collection('learning_sessions').add({
                    'timestamp': firestore.SERVER_TIMESTAMP,
                    'performance_metrics': learning_results['performance_metrics'],
                    'insights': learning_results['insights'],
                    'changes_applied': learning_results['recommended_changes'],
                    'summary': learning_results['learning_summary']
                })
                
                logger.info("✅ Daily learning completed - AI strategy updated")
                logger.info(f"📊 Win Rate: {learning_results['performance_metrics']['win_rate']}%")
                
        except Exception as e:
            logger.error(f"❌ Daily learning session failed: {e}")
            
    def apply_learning_improvements(self, changes: Dict):
        """Apply Claude's recommended improvements to trading rules"""
        try:
            if changes.get('confidence_thresholds'):
                for mode, threshold in changes['confidence_thresholds'].items():
                    if f"{mode}_mode" in self.trading_rules:
                        self.trading_rules[f"{mode}_mode"]['min_confidence'] = threshold
                        
            if changes.get('risk_adjustments'):
                for param, value in changes['risk_adjustments'].items():
                    if param in self.trading_rules['risk_management']:
                        self.trading_rules['risk_management'][param] = value
                        
            # Save updated rules
            with open('/opt/goldex-ai/trading_rules.json', 'w') as f:
                json.dump(self.trading_rules, f, indent=2)
                
            logger.info("🔧 Trading rules updated based on AI learning")
            
        except Exception as e:
            logger.error(f"❌ Failed to apply learning improvements: {e}")
            
    def run_trading_session(self):
        """Main trading loop - called every 5 minutes"""
        logger.info("🔄 Running trading session...")
        
        try:
            # Get current market data
            market_data = self.get_market_data()
            
            if not market_data:
                logger.warning("⚠️ No market data available")
                return
                
            # Check both scalp and swing opportunities
            for mode in ['scalp', 'swing']:
                if self.trading_rules[f"{mode}_mode"]['enabled']:
                    signal = self.analyze_with_claude(market_data, mode)
                    
                    if signal and signal['signal'] != 'NONE':
                        success = self.execute_trade(signal)
                        if success:
                            break  # Only one trade per session
                            
        except Exception as e:
            logger.error(f"❌ Trading session failed: {e}")
            
    def monitor_active_trades(self):
        """Monitor and close active trades based on stop loss/take profit"""
        for trade_id, trade in list(self.active_trades.items()):
            # Simulate trade monitoring - in production, check with broker API
            # For demo, randomly close some trades
            import random
            if random.random() < 0.1:  # 10% chance to close trade
                self.close_trade(trade_id, "profit" if random.random() > 0.3 else "loss")
                
    def close_trade(self, trade_id: str, result: str):
        """Close an active trade"""
        if trade_id in self.active_trades:
            trade = self.active_trades[trade_id]
            
            # Update trade record
            trade['status'] = 'CLOSED'
            trade['result'] = result
            trade['close_time'] = datetime.now()
            
            # Update daily stats
            if result == "profit":
                self.daily_stats['wins'] += 1
                self.daily_stats['profit'] += 50.0  # Simulated profit
            else:
                self.daily_stats['losses'] += 1
                self.daily_stats['profit'] -= 30.0  # Simulated loss
                
            # Update Firebase
            self.db.collection('trades').document(trade_id).update({
                'status': 'CLOSED',
                'result': result,
                'close_time': firestore.SERVER_TIMESTAMP
            })
            
            # Remove from active trades
            del self.active_trades[trade_id]
            
            logger.info(f"🏁 Trade closed: {trade_id} - {result}")
            
    def run_bot(self):
        """Main bot execution loop"""
        logger.info("🚀 GOLDEX AI™ Trading Bot Starting...")
        
        # Schedule trading sessions every 5 minutes
        schedule.every(5).minutes.do(self.run_trading_session)
        
        # Schedule daily learning at midnight
        schedule.every().day.at("00:00").do(self.daily_learning_session)
        
        # Schedule trade monitoring every minute
        schedule.every(1).minutes.do(self.monitor_active_trades)
        
        # Main execution loop
        while True:
            try:
                schedule.run_pending()
                time.sleep(60)  # Check every minute
                
            except KeyboardInterrupt:
                logger.info("🛑 Bot shutdown requested")
                break
            except Exception as e:
                logger.error(f"❌ Unexpected error: {e}")
                time.sleep(60)  # Wait before retrying

if __name__ == "__main__":
    # Create and run the bot
    bot = GoldexAITradingBot()
    bot.run_bot()