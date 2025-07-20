#!/usr/bin/env python3
import os
import time
import json
import logging
import schedule
import firebase_admin
from firebase_admin import credentials, firestore
from anthropic import Anthropic
from datetime import datetime

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

class GoldexBot:
    def __init__(self):
        self.setup()
        
    def setup(self):
        # Firebase
        cred = credentials.Certificate('/opt/goldex-ai/firebase-key.json')
        firebase_admin.initialize_app(cred)
        self.db = firestore.client()
        
        # Claude AI
        self.claude = Anthropic(api_key=os.getenv('CLAUDE_API_KEY'))
        
        logger.info("🚀 GOLDEX AI Ready!")
        
    def analyze_market(self):
        prompt = """
        Analyze XAUUSD for trading opportunity.
        
        Look for:
        1. NY session liquidity sweeps
        2. Order blocks
        3. Fibonacci levels
        
        Respond with JSON:
        {
            "signal": "BUY/SELL/NONE",
            "confidence": 0-100,
            "entry": 2374.50,
            "stop": 2354.50,
            "target": 2404.50,
            "reason": "explanation"
        }
        """
        
        try:
            response = self.claude.messages.create(
                model="claude-3-sonnet-20240229",
                max_tokens=1000,
                messages=[{"role": "user", "content": prompt}]
            )
            
            content = response.content[0].text
            start = content.find('{')
            end = content.rfind('}') + 1
            
            if start != -1:
                signal = json.loads(content[start:end])
                logger.info(f"📊 Signal: {signal['signal']} - {signal['confidence']}%")
                
                if signal['confidence'] >= 85:
                    self.send_to_app(signal)
                    
                return signal
        except Exception as e:
            logger.error(f"Analysis failed: {e}")
            
    def send_to_app(self, signal):
        try:
            self.db.collection('signals').add({
                'signal': signal,
                'timestamp': firestore.SERVER_TIMESTAMP,
                'delivered': False
            })
            logger.info("📱 Signal sent to app")
        except Exception as e:
            logger.error(f"Send failed: {e}")
            
    def trading_session(self):
        logger.info("🔄 Running trading session...")
        self.analyze_market()
        
    def run(self):
        schedule.every(5).minutes.do(self.trading_session)
        
        while True:
            schedule.run_pending()
            time.sleep(60)

if __name__ == "__main__":
    bot = GoldexBot()
    bot.run()