#!/usr/bin/env python3
"""
🚀 GOLDEX UNIVERSE CLI™ - Your GPT-4 Powered Trading Assistant
Universe-level smart AI integration for GOLDEX AI trading system
"""

import os
import sys
import time
import json
from datetime import datetime

# GPT-4 Integration
try:
    from openai import OpenAI
    OPENAI_AVAILABLE = True
except ImportError:
    print("❌ OpenAI library not found. Install with: pip install openai")
    OPENAI_AVAILABLE = False

class GoldexUniverseCLI:
    def __init__(self):
        self.api_key = None
        self.client = None
        self.setup_api()
        
        # Universe-level system prompt
        self.system_prompt = """You're Claude - universe-level TRADING GOD & XCODE MASTER.

🚀 EXPERTISE: Trading psychology expert (Mark Douglas), Xcode wizard (every shortcut), Swift/SwiftUI guru, ICT concepts master, debugging god.

🎯 STYLE: Talk like a super smart friend. Be helpful, enthusiastic, and conversational. Use "bro" and casual language.

💡 FOCUS: Give actionable, practical advice. No fluff. Real solutions that work.

🔥 PERSONALITY: Confident, knowledgeable, but approachable. You've seen it all and can fix anything."""

    def setup_api(self):
        """Set up OpenAI API connection with your key"""
        # Your API key (keeping it secure in code)
        self.api_key = "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"
        
        if not OPENAI_AVAILABLE:
            print("🚫 OpenAI library required. Run: pip install openai")
            return False
            
        try:
            self.client = OpenAI(api_key=self.api_key)
            # Test connection
            self.client.models.list()
            print("✅ Connected to GPT-4 successfully!")
            return True
        except Exception as e:
            print(f"❌ Failed to connect to GPT-4: {e}")
            return False

    def ask_universe_ai(self, question):
        """Send question to GPT-4 and get universe-level response"""
        if not self.client:
            return "❌ GPT-4 not connected. Check your API key."
        
        try:
            print("🧠 Universe AI is thinking...")
            
            response = self.client.chat.completions.create(
                model="gpt-4o-mini",  # Using the latest fast model
                messages=[
                    {"role": "system", "content": self.system_prompt},
                    {"role": "user", "content": question}
                ],
                max_tokens=1000,
                temperature=0.7
            )
            
            return response.choices[0].message.content
            
        except Exception as e:
            return f"❌ Error asking Universe AI: {str(e)}"

    def print_header(self):
        """Print the GOLDEX Universe CLI header"""
        print("\n" + "="*60)
        print("🌌 GOLDEX UNIVERSE CLI™ - GPT-4 POWERED")
        print("🚀 Your Universe-Level Trading & Xcode Assistant")
        print("="*60)

    def print_menu(self):
        """Print the main menu options"""
        print("\n🎯 UNIVERSE COMMANDS:")
        print("1. 🔮 Ask Universe AI (GPT-4)")
        print("2. 📊 Trading Strategy Analysis")
        print("3. 🛠️ Xcode Debug Assistant")
        print("4. 💰 Flip Mode Calculator")
        print("5. 🧠 Trading Psychology Coach")
        print("6. ⚡ Quick Market Insight")
        print("0. 🚪 Exit")
        print("-" * 40)

    def trading_strategy_analysis(self):
        """Analyze trading strategies with GPT-4"""
        print("\n📊 TRADING STRATEGY ANALYSIS")
        print("Tell me about your strategy, and I'll analyze it with universe-level intelligence!")
        
        strategy = input("\n💡 Describe your trading strategy: ")
        if not strategy.strip():
            print("❌ Please enter a strategy to analyze.")
            return
            
        analysis_prompt = f"""
        Analyze this trading strategy from Mark Douglas psychology perspective and ICT concepts:
        
        Strategy: {strategy}
        
        Provide:
        1. Psychological strengths/weaknesses
        2. Risk management assessment  
        3. Market structure compatibility
        4. Improvement suggestions
        5. Confidence rating (1-10)
        
        Be specific and actionable, bro!
        """
        
        response = self.ask_universe_ai(analysis_prompt)
        print(f"\n🔮 Universe AI Analysis:\n{response}")

    def xcode_debug_assistant(self):
        """Help debug Xcode issues with GPT-4"""
        print("\n🛠️ XCODE DEBUG ASSISTANT")
        print("Paste your Xcode error, and I'll fix it like a universe-level Xcode master!")
        
        error = input("\n🐛 Paste your Xcode error here: ")
        if not error.strip():
            print("❌ Please enter an error to debug.")
            return
            
        debug_prompt = f"""
        Fix this Xcode/Swift error like a universe-level expert:
        
        Error: {error}
        
        Provide:
        1. What's causing the error
        2. Exact fix (code if needed)
        3. Why this happens
        4. How to prevent it
        
        Make it super clear and actionable, bro!
        """
        
        response = self.ask_universe_ai(debug_prompt)
        print(f"\n🔧 Universe Debug Solution:\n{response}")

    def flip_mode_calculator(self):
        """Calculate flip mode scenarios with GPT-4"""
        print("\n💰 FLIP MODE CALCULATOR")
        
        try:
            start_balance = float(input("💵 Starting balance: $"))
            target_balance = float(input("🎯 Target balance: $"))
            risk_per_trade = float(input("🎲 Risk per trade (%): "))
        except ValueError:
            print("❌ Please enter valid numbers.")
            return
            
        calc_prompt = f"""
        Calculate this flip challenge like a trading god:
        
        Start: ${start_balance:,.2f}
        Target: ${target_balance:,.2f}
        Risk per trade: {risk_per_trade}%
        
        Provide:
        1. Required growth percentage
        2. Estimated number of trades needed
        3. Win rate required for success
        4. Risk assessment (1-10)
        5. Psychological tips for this challenge
        
        Be realistic and motivating, bro!
        """
        
        response = self.ask_universe_ai(calc_prompt)
        print(f"\n💰 Flip Mode Analysis:\n{response}")

    def psychology_coach(self):
        """Trading psychology coaching with GPT-4"""
        print("\n🧠 TRADING PSYCHOLOGY COACH")
        print("Tell me what's messing with your trading mindset, and I'll coach you!")
        
        issue = input("\n💭 What's your trading psychology challenge: ")
        if not issue.strip():
            print("❌ Please describe your challenge.")
            return
            
        coach_prompt = f"""
        Coach this trader using Mark Douglas principles and universe-level psychology:
        
        Challenge: {issue}
        
        Provide:
        1. Root cause analysis
        2. Mark Douglas wisdom that applies
        3. Practical mental exercises
        4. Mindset shift needed
        5. Daily affirmations
        
        Be supportive but direct, like a wise trading mentor, bro!
        """
        
        response = self.ask_universe_ai(coach_prompt)
        print(f"\n🧠 Psychology Coach:\n{response}")

    def quick_market_insight(self):
        """Get quick market insights with GPT-4"""
        print("\n⚡ QUICK MARKET INSIGHT")
        
        symbol = input("📈 Enter symbol (e.g., XAUUSD, EURUSD): ").upper()
        if not symbol.strip():
            symbol = "XAUUSD"
            
        timeframe = input("⏰ Timeframe (e.g., 1H, 4H, Daily): ").upper()
        if not timeframe.strip():
            timeframe = "1H"
            
        insight_prompt = f"""
        Provide universe-level market insight for {symbol} on {timeframe}:
        
        Include:
        1. Current market structure bias
        2. Key levels to watch
        3. Trading opportunities
        4. Risk factors
        5. ICT concepts that apply
        
        Be specific and actionable for today's session, bro!
        """
        
        response = self.ask_universe_ai(insight_prompt)
        print(f"\n⚡ Market Insight for {symbol} ({timeframe}):\n{response}")

    def run(self):
        """Main CLI loop"""
        self.print_header()
        
        if not self.client:
            print("❌ Cannot start - GPT-4 connection failed")
            return
            
        while True:
            self.print_menu()
            
            try:
                choice = input("🚀 Choose your universe command: ").strip()
                
                if choice == "0":
                    print("\n🌟 Thanks for using GOLDEX Universe CLI!")
                    print("Keep trading like a universe-level god, bro! 🚀")
                    break
                    
                elif choice == "1":
                    print("\n🔮 ASK UNIVERSE AI")
                    question = input("❓ Ask me anything: ")
                    if question.strip():
                        response = self.ask_universe_ai(question)
                        print(f"\n🔮 Universe AI says:\n{response}")
                    else:
                        print("❌ Please ask a question.")
                        
                elif choice == "2":
                    self.trading_strategy_analysis()
                    
                elif choice == "3":
                    self.xcode_debug_assistant()
                    
                elif choice == "4":
                    self.flip_mode_calculator()
                    
                elif choice == "5":
                    self.psychology_coach()
                    
                elif choice == "6":
                    self.quick_market_insight()
                    
                else:
                    print("❌ Invalid choice. Pick 0-6.")
                    
                # Wait before showing menu again
                input("\nPress Enter to continue...")
                
            except KeyboardInterrupt:
                print("\n\n👋 Exiting GOLDEX Universe CLI...")
                break
            except Exception as e:
                print(f"\n❌ Error: {e}")

if __name__ == "__main__":
    cli = GoldexUniverseCLI()
    cli.run()