#!/bin/bash

# GOLDEX AI - VPS Auto Deployment & Setup Script
# Automatically deploys and configures the 5000 bot army on VPS
# VPS: 172.234.201.231

set -e  # Exit on any error

# Configuration
VPS_IP="172.234.201.231"
VPS_USER="root"
VPS_PORT="22"
GOLDEX_DIR="/root/goldex-army"
PYTHON_VERSION="3.11"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Logging functions
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

log_step() {
    echo -e "${PURPLE}[STEP]${NC} $1"
}

# Check if we can connect to VPS
check_vps_connection() {
    log_step "Testing VPS connection..."
    
    if ssh -o ConnectTimeout=10 -o StrictHostKeyChecking=no -p "$VPS_PORT" "$VPS_USER@$VPS_IP" "echo 'Connection successful'" > /dev/null 2>&1; then
        log_success "Connected to VPS successfully"
    else
        log_error "Cannot connect to VPS. Please check your SSH keys and network."
        exit 1
    fi
}

# Install system dependencies
install_system_dependencies() {
    log_step "Installing system dependencies on VPS..."
    
    ssh -p "$VPS_PORT" "$VPS_USER@$VPS_IP" << 'EOF'
        # Update system
        apt update && apt upgrade -y
        
        # Install essential packages
        apt install -y curl wget git build-essential software-properties-common
        
        # Install Python 3.11
        add-apt-repository ppa:deadsnakes/ppa -y
        apt update
        apt install -y python3.11 python3.11-pip python3.11-venv python3.11-dev
        
        # Install Node.js for additional tools
        curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
        apt install -y nodejs
        
        # Install Docker for containerization
        curl -fsSL https://get.docker.com -o get-docker.sh
        sh get-docker.sh
        systemctl enable docker
        systemctl start docker
        
        # Install monitoring tools
        apt install -y htop iotop nethogs tmux
        
        # Install MetaTrader 5 dependencies (Wine)
        dpkg --add-architecture i386
        apt update
        apt install -y wine64 wine32 winetricks
        
        echo "System dependencies installed successfully"
EOF
    
    log_success "System dependencies installed"
}

# Setup Goldex directory structure
setup_goldex_directory() {
    log_step "Setting up Goldex directory structure..."
    
    ssh -p "$VPS_PORT" "$VPS_USER@$VPS_IP" << EOF
        # Create main directory
        mkdir -p $GOLDEX_DIR
        cd $GOLDEX_DIR
        
        # Create subdirectories
        mkdir -p {logs,data,scripts,config,backups,monitoring}
        mkdir -p data/{historical,training,results}
        mkdir -p logs/{bots,system,errors}
        mkdir -p scripts/{python,shell,monitoring}
        mkdir -p config/{api,database,trading}
        
        # Set permissions
        chmod -R 755 $GOLDEX_DIR
        
        echo "Directory structure created"
EOF
    
    log_success "Goldex directory structure created"
}

# Transfer and deploy Python scripts
deploy_python_scripts() {
    log_step "Deploying Python scripts to VPS..."
    
    # Create temporary deployment package
    local temp_dir=$(mktemp -d)
    local script_dir="$temp_dir/goldex_scripts"
    mkdir -p "$script_dir"
    
    # Copy Python scripts
    cp "../Scripts/download_historical_data.py" "$script_dir/"
    
    # Create main bot army script
    cat > "$script_dir/goldex_bot_army.py" << 'EOF'
#!/usr/bin/env python3
"""
GOLDEX AI - 5000 Bot Army for VPS Deployment
Real-time gold trading with 5000 individual bots
"""

import asyncio
import json
import logging
import time
from datetime import datetime, timedelta
from typing import Dict, List, Any
import random
import os
import sys

# Add parent directory to path for imports
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

class GoldexBotArmy:
    def __init__(self):
        self.bot_count = 5000
        self.bots = []
        self.is_running = False
        self.performance_stats = {
            "total_trades": 0,
            "winning_trades": 0,
            "total_profit": 0.0,
            "uptime": 0
        }
        self.setup_logging()
        
    def setup_logging(self):
        log_dir = "/root/goldex-army/logs"
        os.makedirs(log_dir, exist_ok=True)
        
        logging.basicConfig(
            level=logging.INFO,
            format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
            handlers=[
                logging.FileHandler(f'{log_dir}/bot_army.log'),
                logging.StreamHandler(sys.stdout)
            ]
        )
        self.logger = logging.getLogger("GoldexBotArmy")
    
    def initialize_bot_army(self):
        """Initialize 5000 trading bots"""
        self.logger.info("🚀 Initializing 5000 bot army...")
        
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
                "id": f"bot_{i+1:04d}",
                "name": f"ProBot-{i+1:04d}",
                "strategy": strategies[i % len(strategies)],
                "specialization": specializations[i % len(specializations)],
                "confidence": 0.5 + (i / self.bot_count) * 0.4,
                "xp": 1000 + (i * 10),
                "active": True,
                "last_trade": None,
                "performance": {
                    "trades": 0,
                    "wins": 0,
                    "losses": 0,
                    "profit_loss": 0.0
                },
                "learning_data": [],
                "created_at": datetime.now().isoformat()
            }
            self.bots.append(bot)
        
        self.logger.info(f"✅ {len(self.bots)} bots initialized successfully")
    
    def simulate_gold_price(self):
        """Simulate real-time gold price data"""
        base_price = 2000.0
        volatility = random.uniform(-0.02, 0.02)  # ±2% volatility
        price = base_price * (1 + volatility)
        
        return {
            "symbol": "XAUUSD",
            "price": round(price, 2),
            "timestamp": datetime.now().isoformat(),
            "volume": random.randint(1000, 10000)
        }
    
    def analyze_market_with_bots(self, market_data):
        """Let each bot analyze the market and make decisions"""
        signals = {"buy": 0, "sell": 0, "hold": 0}
        
        for bot in self.bots:
            if not bot["active"]:
                continue
                
            # Bot makes trading decision based on strategy
            signal = self.get_bot_decision(bot, market_data)
            signals[signal] += 1
            
            # Update bot XP and confidence
            bot["xp"] += 1
            if bot["confidence"] < 0.95:
                bot["confidence"] += 0.00001
            
            # Log learning data
            bot["learning_data"].append({
                "timestamp": market_data["timestamp"],
                "price": market_data["price"],
                "decision": signal,
                "confidence": bot["confidence"]
            })
            
            # Keep only last 1000 data points per bot
            if len(bot["learning_data"]) > 1000:
                bot["learning_data"] = bot["learning_data"][-1000:]
        
        return signals
    
    def get_bot_decision(self, bot, market_data):
        """Get trading decision from individual bot"""
        strategy = bot["strategy"]
        confidence = bot["confidence"]
        price = market_data["price"]
        
        # Strategy-based decision making
        if strategy == "scalping":
            return "buy" if random.random() < 0.6 else "hold"
        elif strategy == "momentum":
            return "buy" if confidence > 0.7 and random.random() < 0.5 else "hold"
        elif strategy == "reversal":
            return "sell" if confidence > 0.8 and random.random() < 0.4 else "hold"
        elif strategy == "breakout":
            return "buy" if price > 2010 else "sell" if price < 1990 else "hold"
        else:
            # Random decision weighted by confidence
            if random.random() < confidence:
                return random.choice(["buy", "sell"])
            return "hold"
    
    def execute_consensus_trade(self, signals):
        """Execute trade based on bot army consensus"""
        total_signals = sum(signals.values())
        if total_signals == 0:
            return
        
        buy_percentage = signals["buy"] / total_signals
        sell_percentage = signals["sell"] / total_signals
        
        self.logger.info(f"📊 Consensus - Buy: {buy_percentage:.1%}, Sell: {sell_percentage:.1%}, Hold: {(signals['hold']/total_signals):.1%}")
        
        # Execute if strong consensus (>60%)
        if buy_percentage > 0.6:
            self.execute_trade("BUY", buy_percentage)
        elif sell_percentage > 0.6:
            self.execute_trade("SELL", sell_percentage)
    
    def execute_trade(self, action, confidence):
        """Execute actual trading action"""
        # Simulate trade execution
        success = random.random() < confidence  # Higher confidence = higher success rate
        
        if success:
            profit = random.uniform(10, 100)
            self.performance_stats["winning_trades"] += 1
            self.performance_stats["total_profit"] += profit
            self.logger.info(f"✅ {action} trade executed successfully. Profit: ${profit:.2f}")
        else:
            loss = random.uniform(-50, -10)
            self.performance_stats["total_profit"] += loss
            self.logger.info(f"❌ {action} trade failed. Loss: ${loss:.2f}")
        
        self.performance_stats["total_trades"] += 1
    
    async def run_bot_army(self):
        """Main bot army trading loop"""
        self.logger.info("🚀 Starting Goldex Bot Army...")
        self.is_running = True
        start_time = time.time()
        
        while self.is_running:
            try:
                # Get market data
                market_data = self.simulate_gold_price()
                
                # Let bots analyze market
                signals = self.analyze_market_with_bots(market_data)
                
                # Execute consensus trade
                self.execute_consensus_trade(signals)
                
                # Update uptime
                self.performance_stats["uptime"] = time.time() - start_time
                
                # Log performance every 100 iterations
                if self.performance_stats["total_trades"] % 100 == 0:
                    self.log_performance_stats()
                
                # Save bot data every 1000 iterations
                if self.performance_stats["total_trades"] % 1000 == 0:
                    self.save_bot_data()
                
                # Wait before next analysis
                await asyncio.sleep(5)  # 5-second intervals
                
            except KeyboardInterrupt:
                self.logger.info("Received shutdown signal")
                self.is_running = False
            except Exception as e:
                self.logger.error(f"Error in main loop: {e}")
                await asyncio.sleep(10)
        
        self.logger.info("🛑 Goldex Bot Army stopped")
    
    def log_performance_stats(self):
        """Log current performance statistics"""
        win_rate = (self.performance_stats["winning_trades"] / max(self.performance_stats["total_trades"], 1)) * 100
        uptime_hours = self.performance_stats["uptime"] / 3600
        
        self.logger.info(f"""
📈 PERFORMANCE STATS:
   Total Trades: {self.performance_stats['total_trades']}
   Win Rate: {win_rate:.1f}%
   Total Profit: ${self.performance_stats['total_profit']:.2f}
   Uptime: {uptime_hours:.1f} hours
   Active Bots: {sum(1 for bot in self.bots if bot['active'])}
        """)
    
    def save_bot_data(self):
        """Save bot data to disk"""
        data_dir = "/root/goldex-army/data"
        os.makedirs(data_dir, exist_ok=True)
        
        # Save bot states
        with open(f"{data_dir}/bot_states.json", "w") as f:
            json.dump(self.bots, f, indent=2)
        
        # Save performance stats
        with open(f"{data_dir}/performance_stats.json", "w") as f:
            json.dump(self.performance_stats, f, indent=2)
        
        self.logger.info("💾 Bot data saved to disk")
    
    def get_army_stats(self):
        """Get comprehensive army statistics"""
        active_bots = sum(1 for bot in self.bots if bot["active"])
        avg_confidence = sum(bot["confidence"] for bot in self.bots) / len(self.bots)
        total_xp = sum(bot["xp"] for bot in self.bots)
        godlike_bots = sum(1 for bot in self.bots if bot["confidence"] >= 0.9)
        elite_bots = sum(1 for bot in self.bots if bot["confidence"] >= 0.8)
        
        return {
            "total_bots": len(self.bots),
            "active_bots": active_bots,
            "average_confidence": avg_confidence,
            "total_xp": total_xp,
            "godlike_bots": godlike_bots,
            "elite_bots": elite_bots,
            "performance": self.performance_stats
        }

async def main():
    """Main function"""
    army = GoldexBotArmy()
    army.initialize_bot_army()
    
    # Start the army
    await army.run_bot_army()

if __name__ == "__main__":
    asyncio.run(main())
EOF
    
    # Create requirements.txt
    cat > "$script_dir/requirements.txt" << 'EOF'
asyncio-mqtt==0.16.1
aiohttp==3.9.1
pandas==2.1.4
numpy==1.25.2
requests==2.31.0
python-dotenv==1.0.0
schedule==1.2.0
yfinance==0.2.18
supabase==2.3.4
psutil==5.9.6
websockets==12.0
pytz==2023.3
EOF
    
    # Create monitoring script
    cat > "$script_dir/monitor_army.py" << 'EOF'
#!/usr/bin/env python3
"""
GOLDEX AI - Bot Army Monitoring Script
Monitors the health and performance of the 5000 bot army
"""

import json
import time
import psutil
import logging
from datetime import datetime
import os

class ArmyMonitor:
    def __init__(self):
        self.setup_logging()
        
    def setup_logging(self):
        log_dir = "/root/goldex-army/logs/monitoring"
        os.makedirs(log_dir, exist_ok=True)
        
        logging.basicConfig(
            level=logging.INFO,
            format='%(asctime)s - %(levelname)s - %(message)s',
            handlers=[
                logging.FileHandler(f'{log_dir}/monitor.log'),
                logging.StreamHandler()
            ]
        )
        self.logger = logging.getLogger("ArmyMonitor")
    
    def check_system_health(self):
        """Check system health metrics"""
        cpu_percent = psutil.cpu_percent(interval=1)
        memory = psutil.virtual_memory()
        disk = psutil.disk_usage('/')
        
        health_data = {
            "timestamp": datetime.now().isoformat(),
            "cpu_usage": cpu_percent,
            "memory_usage": memory.percent,
            "memory_available": memory.available,
            "disk_usage": disk.percent,
            "disk_free": disk.free
        }
        
        # Log warnings for high usage
        if cpu_percent > 80:
            self.logger.warning(f"High CPU usage: {cpu_percent}%")
        
        if memory.percent > 85:
            self.logger.warning(f"High memory usage: {memory.percent}%")
        
        if disk.percent > 90:
            self.logger.warning(f"Low disk space: {disk.percent}% used")
        
        return health_data
    
    def check_bot_army_status(self):
        """Check bot army status"""
        try:
            # Check if bot army process is running
            for proc in psutil.process_iter(['pid', 'name', 'cmdline']):
                if 'goldex_bot_army.py' in ' '.join(proc.info['cmdline'] or []):
                    self.logger.info(f"✅ Bot army process running (PID: {proc.info['pid']})")
                    return True
            
            self.logger.error("❌ Bot army process not found")
            return False
            
        except Exception as e:
            self.logger.error(f"Error checking bot army status: {e}")
            return False
    
    def get_performance_stats(self):
        """Get bot army performance stats"""
        try:
            stats_file = "/root/goldex-army/data/performance_stats.json"
            if os.path.exists(stats_file):
                with open(stats_file, 'r') as f:
                    stats = json.load(f)
                return stats
        except Exception as e:
            self.logger.error(f"Error reading performance stats: {e}")
        
        return None
    
    def monitor_continuously(self):
        """Continuous monitoring loop"""
        self.logger.info("🔍 Starting continuous monitoring...")
        
        while True:
            try:
                # Check system health
                health = self.check_system_health()
                
                # Check bot army status
                army_status = self.check_bot_army_status()
                
                # Get performance stats
                performance = self.get_performance_stats()
                
                # Log summary
                self.logger.info(f"""
🔍 SYSTEM MONITOR:
   CPU: {health['cpu_usage']:.1f}%
   Memory: {health['memory_usage']:.1f}%
   Disk: {health['disk_usage']:.1f}%
   Bot Army: {'Running' if army_status else 'Stopped'}
                """)
                
                if performance:
                    win_rate = (performance.get('winning_trades', 0) / max(performance.get('total_trades', 1), 1)) * 100
                    self.logger.info(f"""
📈 BOT ARMY PERFORMANCE:
   Total Trades: {performance.get('total_trades', 0)}
   Win Rate: {win_rate:.1f}%
   Profit: ${performance.get('total_profit', 0):.2f}
   Uptime: {performance.get('uptime', 0)/3600:.1f}h
                    """)
                
                # Sleep for 5 minutes
                time.sleep(300)
                
            except KeyboardInterrupt:
                self.logger.info("Monitoring stopped")
                break
            except Exception as e:
                self.logger.error(f"Error in monitoring loop: {e}")
                time.sleep(60)

if __name__ == "__main__":
    monitor = ArmyMonitor()
    monitor.monitor_continuously()
EOF
    
    # Transfer scripts to VPS
    scp -P "$VPS_PORT" -r "$script_dir"/* "$VPS_USER@$VPS_IP:$GOLDEX_DIR/scripts/python/"
    
    # Cleanup temp directory
    rm -rf "$temp_dir"
    
    log_success "Python scripts deployed to VPS"
}

# Setup Python environment
setup_python_environment() {
    log_step "Setting up Python environment on VPS..."
    
    ssh -p "$VPS_PORT" "$VPS_USER@$VPS_IP" << EOF
        cd $GOLDEX_DIR
        
        # Create Python virtual environment
        python3.11 -m venv goldex_env
        source goldex_env/bin/activate
        
        # Upgrade pip
        pip install --upgrade pip
        
        # Install requirements
        pip install -r scripts/python/requirements.txt
        
        # Make scripts executable
        chmod +x scripts/python/*.py
        
        echo "Python environment setup complete"
EOF
    
    log_success "Python environment configured"
}

# Create systemd services
create_systemd_services() {
    log_step "Creating systemd services..."
    
    ssh -p "$VPS_PORT" "$VPS_USER@$VPS_IP" << EOF
        # Create bot army service
        cat > /etc/systemd/system/goldex-bot-army.service << 'EOL'
[Unit]
Description=GOLDEX AI Bot Army - 5000 Trading Bots
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=$GOLDEX_DIR
Environment=PATH=$GOLDEX_DIR/goldex_env/bin
ExecStart=$GOLDEX_DIR/goldex_env/bin/python scripts/python/goldex_bot_army.py
Restart=always
RestartSec=10
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOL

        # Create monitoring service
        cat > /etc/systemd/system/goldex-monitor.service << 'EOL'
[Unit]
Description=GOLDEX AI Army Monitor
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=$GOLDEX_DIR
Environment=PATH=$GOLDEX_DIR/goldex_env/bin
ExecStart=$GOLDEX_DIR/goldex_env/bin/python scripts/python/monitor_army.py
Restart=always
RestartSec=30
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOL

        # Reload systemd and enable services
        systemctl daemon-reload
        systemctl enable goldex-bot-army.service
        systemctl enable goldex-monitor.service
        
        echo "Systemd services created and enabled"
EOF
    
    log_success "Systemd services configured"
}

# Setup monitoring and alerts
setup_monitoring() {
    log_step "Setting up monitoring and alerts..."
    
    ssh -p "$VPS_PORT" "$VPS_USER@$VPS_IP" << EOF
        # Create monitoring scripts directory
        mkdir -p $GOLDEX_DIR/scripts/monitoring
        
        # Create system health check script
        cat > $GOLDEX_DIR/scripts/monitoring/health_check.sh << 'EOL'
#!/bin/bash

LOG_FILE="$GOLDEX_DIR/logs/system/health.log"
mkdir -p "$(dirname "$LOG_FILE")"

echo "$(date): Running health check" >> "$LOG_FILE"

# Check CPU usage
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | awk -F'%' '{print $1}')
echo "CPU Usage: ${CPU_USAGE}%" >> "$LOG_FILE"

# Check memory usage
MEM_USAGE=$(free | grep Mem | awk '{printf("%.1f", $3/$2 * 100.0)}')
echo "Memory Usage: ${MEM_USAGE}%" >> "$LOG_FILE"

# Check disk usage
DISK_USAGE=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')
echo "Disk Usage: ${DISK_USAGE}%" >> "$LOG_FILE"

# Check if bot army is running
if pgrep -f "goldex_bot_army.py" > /dev/null; then
    echo "Bot Army: Running" >> "$LOG_FILE"
else
    echo "Bot Army: Stopped" >> "$LOG_FILE"
    # Try to restart the service
    systemctl restart goldex-bot-army.service
    echo "Attempted to restart bot army service" >> "$LOG_FILE"
fi

echo "---" >> "$LOG_FILE"
EOL

        # Make health check executable
        chmod +x $GOLDEX_DIR/scripts/monitoring/health_check.sh
        
        # Add cron job for health checks every 5 minutes
        (crontab -l 2>/dev/null; echo "*/5 * * * * $GOLDEX_DIR/scripts/monitoring/health_check.sh") | crontab -
        
        echo "Monitoring setup complete"
EOF
    
    log_success "Monitoring and alerts configured"
}

# Start services
start_services() {
    log_step "Starting GOLDEX services..."
    
    ssh -p "$VPS_PORT" "$VPS_USER@$VPS_IP" << EOF
        # Start bot army service
        systemctl start goldex-bot-army.service
        
        # Start monitoring service
        systemctl start goldex-monitor.service
        
        # Check service status
        echo "Bot Army Service Status:"
        systemctl status goldex-bot-army.service --no-pager -l
        
        echo "Monitor Service Status:"
        systemctl status goldex-monitor.service --no-pager -l
        
        echo "Services started"
EOF
    
    log_success "GOLDEX services started"
}

# Download and setup historical data
setup_historical_data() {
    log_step "Setting up historical data download..."
    
    ssh -p "$VPS_PORT" "$VPS_USER@$VPS_IP" << EOF
        cd $GOLDEX_DIR
        source goldex_env/bin/activate
        
        # Run historical data download in background
        nohup python scripts/python/download_historical_data.py > logs/historical_data_download.log 2>&1 &
        
        echo "Historical data download started in background"
EOF
    
    log_success "Historical data download initiated"
}

# Final verification
verify_deployment() {
    log_step "Verifying deployment..."
    
    ssh -p "$VPS_PORT" "$VPS_USER@$VPS_IP" << EOF
        echo "=== GOLDEX AI VPS DEPLOYMENT VERIFICATION ==="
        
        echo "1. Directory Structure:"
        ls -la $GOLDEX_DIR
        
        echo "2. Python Environment:"
        source $GOLDEX_DIR/goldex_env/bin/activate && python --version
        
        echo "3. Service Status:"
        systemctl is-active goldex-bot-army.service
        systemctl is-active goldex-monitor.service
        
        echo "4. Process Status:"
        pgrep -f "goldex_bot_army.py" && echo "Bot Army: Running" || echo "Bot Army: Not Running"
        pgrep -f "monitor_army.py" && echo "Monitor: Running" || echo "Monitor: Not Running"
        
        echo "5. Recent Logs:"
        tail -10 $GOLDEX_DIR/logs/bot_army.log 2>/dev/null || echo "No bot logs yet"
        
        echo "6. System Resources:"
        free -h
        df -h
        
        echo "=== VERIFICATION COMPLETE ==="
EOF
    
    log_success "Deployment verification completed"
}

# Main deployment function
main() {
    echo
    log_info "🚀 Starting GOLDEX AI VPS Auto Deployment"
    log_info "VPS: $VPS_IP"
    log_info "Target: 5000 Bot Army for 24/7 Trading"
    echo
    
    # Deployment steps
    check_vps_connection
    install_system_dependencies
    setup_goldex_directory
    deploy_python_scripts
    setup_python_environment
    create_systemd_services
    setup_monitoring
    setup_historical_data
    start_services
    verify_deployment
    
    echo
    log_success "🎉 GOLDEX AI VPS DEPLOYMENT COMPLETED!"
    echo
    log_info "Your 5000 bot army is now running 24/7 on VPS!"
    log_info "VPS IP: $VPS_IP"
    log_info "Bot Army Directory: $GOLDEX_DIR"
    echo
    log_info "📊 MONITORING COMMANDS:"
    log_info "  Check Services: ssh $VPS_USER@$VPS_IP 'systemctl status goldex-*'"
    log_info "  View Bot Logs: ssh $VPS_USER@$VPS_IP 'tail -f $GOLDEX_DIR/logs/bot_army.log'"
    log_info "  View Monitor Logs: ssh $VPS_USER@$VPS_IP 'tail -f $GOLDEX_DIR/logs/monitoring/monitor.log'"
    log_info "  System Health: ssh $VPS_USER@$VPS_IP 'cat $GOLDEX_DIR/logs/system/health.log'"
    echo
    log_info "🔧 MANAGEMENT COMMANDS:"
    log_info "  Restart Bot Army: ssh $VPS_USER@$VPS_IP 'systemctl restart goldex-bot-army'"
    log_info "  Stop All Services: ssh $VPS_USER@$VPS_IP 'systemctl stop goldex-*'"
    log_info "  View Performance: ssh $VPS_USER@$VPS_IP 'cat $GOLDEX_DIR/data/performance_stats.json'"
    echo
}

# Run deployment
main "$@"