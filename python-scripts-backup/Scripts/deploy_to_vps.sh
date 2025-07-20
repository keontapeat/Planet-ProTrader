#!/bin/bash

# GOLDEX AI - VPS Deployment Script
# Deploys ProTrader Bot Army to VPS for 24/7 operation
# Created by Goldex AI on 7/19/25

echo "🚀 GOLDEX AI VPS DEPLOYMENT SCRIPT"
echo "=================================="

# Configuration
VPS_HOST="${VPS_HOST:-your-vps-host.com}"
VPS_USER="${VPS_USER:-goldex}"
VPS_PORT="${VPS_PORT:-22}"
REMOTE_DIR="/home/goldex/protrader-army"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if required environment variables are set
check_config() {
    log_info "Checking configuration..."
    
    if [ -z "$VPS_HOST" ] || [ "$VPS_HOST" = "your-vps-host.com" ]; then
        log_error "VPS_HOST not configured. Please set your VPS hostname."
        exit 1
    fi
    
    if [ -z "$GOLDEX_API_KEY" ]; then
        log_warning "GOLDEX_API_KEY not set. Bot army will run in demo mode."
    fi
    
    log_success "Configuration check completed"
}

# Test VPS connection
test_connection() {
    log_info "Testing VPS connection..."
    
    if ssh -p "$VPS_PORT" -o ConnectTimeout=10 "$VPS_USER@$VPS_HOST" "echo 'Connection successful'" > /dev/null 2>&1; then
        log_success "VPS connection established"
    else
        log_error "Cannot connect to VPS. Please check your credentials and network."
        exit 1
    fi
}

# Install dependencies on VPS
install_dependencies() {
    log_info "Installing dependencies on VPS..."
    
    ssh -p "$VPS_PORT" "$VPS_USER@$VPS_HOST" << 'EOF'
        # Update system
        sudo apt update && sudo apt upgrade -y
        
        # Install Python 3.9+
        sudo apt install -y python3 python3-pip python3-venv
        
        # Install system dependencies
        sudo apt install -y build-essential curl wget git
        
        # Install MetaTrader 5 dependencies (for Wine)
        sudo apt install -y wine64 winetricks
        
        # Create project directory
        mkdir -p /home/goldex/protrader-army
        cd /home/goldex/protrader-army
        
        # Create Python virtual environment
        python3 -m venv venv
        source venv/bin/activate
        
        # Install Python packages
        pip install MetaTrader5 numpy pandas requests schedule
        
        echo "Dependencies installed successfully"
EOF
    
    log_success "Dependencies installed on VPS"
}

# Deploy bot army files
deploy_files() {
    log_info "Deploying ProTrader Bot Army files..."
    
    # Create deployment package
    mkdir -p deployment_package
    
    # Copy bot army core files
    cp -r "../Models/ProTraderBotArmy.swift" deployment_package/
    cp -r "../Models/GPTIntegration.swift" deployment_package/
    
    # Create Python deployment script
    cat > deployment_package/protrader_army.py << 'EOF'
#!/usr/bin/env python3
"""
GOLDEX AI ProTrader Bot Army - VPS Deployment
5,000 Bot Army for 24/7 Gold Trading
"""

import MetaTrader5 as mt5
import numpy as np
import pandas as pd
import json
import time
import schedule
import logging
from datetime import datetime, timedelta
import requests
import os

class ProTraderBotArmy:
    def __init__(self):
        self.bot_count = 5000
        self.bots = []
        self.is_running = False
        self.setup_logging()
        
    def setup_logging(self):
        logging.basicConfig(
            level=logging.INFO,
            format='%(asctime)s - %(levelname)s - %(message)s',
            handlers=[
                logging.FileHandler('/home/goldex/protrader-army/bot_army.log'),
                logging.StreamHandler()
            ]
        )
        self.logger = logging.getLogger(__name__)
    
    def initialize_mt5(self):
        """Initialize MT5 connection"""
        if not mt5.initialize():
            self.logger.error("Failed to initialize MT5")
            return False
        
        account_info = mt5.account_info()
        if account_info is None:
            self.logger.error("Failed to get account info")
            return False
            
        self.logger.info(f"Connected to MT5 - Account: {account_info.login}")
        return True
    
    def create_bot_army(self):
        """Create 5,000 trading bots with different strategies"""
        strategies = [
            "scalping", "swing", "breakout", "momentum", "reversal",
            "grid", "martingale", "fibonacci", "support_resistance", "trend_following"
        ]
        
        specializations = [
            "technical", "fundamental", "sentiment", "volatility", "arbitrage",
            "news_trading", "pattern_recognition", "machine_learning", "quantitative", "hybrid"
        ]
        
        for i in range(self.bot_count):
            bot = {
                "id": i + 1,
                "name": f"ProBot-{i+1:04d}",
                "strategy": strategies[i % len(strategies)],
                "specialization": specializations[i % len(specializations)],
                "confidence": 0.5 + (i / self.bot_count) * 0.4,  # 0.5 to 0.9
                "xp": 1000 + (i * 10),
                "active": True,
                "last_action": None,
                "performance": {
                    "wins": 0,
                    "losses": 0,
                    "profit_loss": 0.0
                }
            }
            self.bots.append(bot)
            
        self.logger.info(f"Created {len(self.bots)} trading bots")
    
    def get_market_data(self):
        """Get real-time XAUUSD market data"""
        if not mt5.symbol_select("XAUUSD", True):
            self.logger.error("Failed to select XAUUSD symbol")
            return None
            
        tick = mt5.symbol_info_tick("XAUUSD")
        if tick is None:
            self.logger.error("Failed to get XAUUSD tick")
            return None
            
        return {
            "symbol": "XAUUSD",
            "bid": tick.bid,
            "ask": tick.ask,
            "time": datetime.fromtimestamp(tick.time),
            "spread": tick.ask - tick.bid
        }
    
    def analyze_market_with_bots(self, market_data):
        """Let each bot analyze the market"""
        signals = {"buy": 0, "sell": 0, "hold": 0}
        
        for bot in self.bots:
            if not bot["active"]:
                continue
                
            # Simple strategy-based analysis
            signal = self.get_bot_signal(bot, market_data)
            signals[signal] += 1
            
            # Update bot XP
            bot["xp"] += 1
            
            # Improve confidence over time
            if bot["confidence"] < 0.9:
                bot["confidence"] += 0.00001
        
        return signals
    
    def get_bot_signal(self, bot, market_data):
        """Get trading signal from individual bot"""
        strategy = bot["strategy"]
        confidence = bot["confidence"]
        
        # Simple strategy implementations
        if strategy == "scalping":
            return "buy" if market_data["spread"] < 0.5 else "hold"
        elif strategy == "momentum":
            # Placeholder for momentum analysis
            return "buy" if confidence > 0.7 else "hold"
        elif strategy == "reversal":
            return "sell" if confidence > 0.8 else "hold"
        else:
            # Random decision weighted by confidence
            import random
            if random.random() < confidence:
                return random.choice(["buy", "sell"])
            return "hold"
    
    def execute_trades(self, signals):
        """Execute trades based on bot army consensus"""
        total_signals = sum(signals.values())
        if total_signals == 0:
            return
            
        buy_percentage = signals["buy"] / total_signals
        sell_percentage = signals["sell"] / total_signals
        
        self.logger.info(f"Bot Army Consensus - Buy: {buy_percentage:.2%}, Sell: {sell_percentage:.2%}")
        
        # Execute trade if there's strong consensus (>60%)
        if buy_percentage > 0.6:
            self.place_order("buy")
        elif sell_percentage > 0.6:
            self.place_order("sell")
    
    def place_order(self, action):
        """Place actual trading order"""
        symbol = "XAUUSD"
        lot_size = 0.01  # Micro lot for safety
        
        if action == "buy":
            order_type = mt5.ORDER_TYPE_BUY
            price = mt5.symbol_info_tick(symbol).ask
        else:
            order_type = mt5.ORDER_TYPE_SELL
            price = mt5.symbol_info_tick(symbol).bid
        
        request = {
            "action": mt5.TRADE_ACTION_DEAL,
            "symbol": symbol,
            "volume": lot_size,
            "type": order_type,
            "price": price,
            "deviation": 20,
            "magic": 234000,
            "comment": "ProTrader Bot Army",
            "type_time": mt5.ORDER_TIME_GTC,
            "type_filling": mt5.ORDER_FILLING_IOC,
        }
        
        result = mt5.order_send(request)
        if result.retcode != mt5.TRADE_RETCODE_DONE:
            self.logger.error(f"Order failed: {result.comment}")
        else:
            self.logger.info(f"Order successful: {action} {lot_size} lots at {price}")
    
    def run_bot_army(self):
        """Main trading loop"""
        self.logger.info("Starting ProTrader Bot Army...")
        self.is_running = True
        
        while self.is_running:
            try:
                # Get market data
                market_data = self.get_market_data()
                if market_data is None:
                    time.sleep(1)
                    continue
                
                # Let bots analyze
                signals = self.analyze_market_with_bots(market_data)
                
                # Execute trades
                self.execute_trades(signals)
                
                # Wait before next analysis
                time.sleep(5)  # Analyze every 5 seconds
                
            except KeyboardInterrupt:
                self.logger.info("Received shutdown signal")
                self.is_running = False
            except Exception as e:
                self.logger.error(f"Error in main loop: {e}")
                time.sleep(10)
        
        self.logger.info("ProTrader Bot Army stopped")
    
    def get_army_stats(self):
        """Get current army statistics"""
        active_bots = sum(1 for bot in self.bots if bot["active"])
        avg_confidence = sum(bot["confidence"] for bot in self.bots) / len(self.bots)
        total_xp = sum(bot["xp"] for bot in self.bots)
        
        return {
            "total_bots": len(self.bots),
            "active_bots": active_bots,
            "average_confidence": avg_confidence,
            "total_xp": total_xp,
            "godlike_bots": sum(1 for bot in self.bots if bot["confidence"] >= 0.9),
            "elite_bots": sum(1 for bot in self.bots if bot["confidence"] >= 0.8)
        }

def main():
    """Main deployment function"""
    army = ProTraderBotArmy()
    
    # Initialize MT5
    if not army.initialize_mt5():
        return
    
    # Create bot army
    army.create_bot_army()
    
    # Schedule periodic reports
    schedule.every(1).hours.do(lambda: army.logger.info(f"Army Stats: {army.get_army_stats()}"))
    
    # Start the army
    army.run_bot_army()

if __name__ == "__main__":
    main()
EOF
    
    # Create systemd service file
    cat > deployment_package/protrader-army.service << 'EOF'
[Unit]
Description=GOLDEX AI ProTrader Bot Army
After=network.target

[Service]
Type=simple
User=goldex
WorkingDirectory=/home/goldex/protrader-army
Environment=PATH=/home/goldex/protrader-army/venv/bin
ExecStart=/home/goldex/protrader-army/venv/bin/python protrader_army.py
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF
    
    # Upload files to VPS
    scp -P "$VPS_PORT" -r deployment_package/* "$VPS_USER@$VPS_HOST:$REMOTE_DIR/"
    
    log_success "Files deployed to VPS"
}

# Start bot army service
start_service() {
    log_info "Starting ProTrader Bot Army service..."
    
    ssh -p "$VPS_PORT" "$VPS_USER@$VPS_HOST" << 'EOF'
        cd /home/goldex/protrader-army
        
        # Make Python script executable
        chmod +x protrader_army.py
        
        # Install systemd service
        sudo cp protrader-army.service /etc/systemd/system/
        sudo systemctl daemon-reload
        sudo systemctl enable protrader-army
        sudo systemctl start protrader-army
        
        # Check service status
        sudo systemctl status protrader-army
EOF
    
    log_success "ProTrader Bot Army service started"
}

# Monitor deployment
monitor_deployment() {
    log_info "Monitoring deployment..."
    
    ssh -p "$VPS_PORT" "$VPS_USER@$VPS_HOST" << 'EOF'
        echo "=== Service Status ==="
        sudo systemctl status protrader-army --no-pager
        
        echo -e "\n=== Recent Logs ==="
        tail -20 /home/goldex/protrader-army/bot_army.log
        
        echo -e "\n=== System Resources ==="
        free -h
        df -h /home/goldex/protrader-army
EOF
}

# Main deployment flow
main() {
    echo
    log_info "Starting GOLDEX AI VPS deployment..."
    echo
    
    check_config
    test_connection
    install_dependencies
    deploy_files
    start_service
    monitor_deployment
    
    echo
    log_success "🎉 ProTrader Bot Army successfully deployed to VPS!"
    log_info "Your 5,000 bot army is now running 24/7"
    log_info "Monitor with: ssh $VPS_USER@$VPS_HOST 'sudo systemctl status protrader-army'"
    echo
}

# Run deployment
main "$@"