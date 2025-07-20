#!/bin/bash

# VPS MetaTrader 5 Setup Script for GOLDEX AI Historical Data Collection
# VPS: 172.234.201.231
# Ubuntu 22.04 LTS with Wine 10.0
# Author: GOLDEX AI
# Date: 2025-07-19

set -e  # Exit on any error

# VPS Configuration
VPS_HOST="172.234.201.231"
VPS_USER="root"
SSH_KEY_PATH="$HOME/.ssh/goldex_vps_key"

# MT5 Configuration
MT5_LOGIN="1888520701"
MT5_SERVER="Dukascopy-demo-mt5-1"
MT5_PASSWORD="3HuoTT"
MT5_SYMBOL="XAUUSD"
DATA_OUTPUT_DIR="/root/mt5_data"
MT5_INSTALL_DIR="/root/.wine/drive_c/Program Files/MetaTrader 5"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] $1${NC}"
}

warn() {
    echo -e "${YELLOW}[$(date +'%Y-%m-%d %H:%M:%S')] WARNING: $1${NC}"
}

error() {
    echo -e "${RED}[$(date +'%Y-%m-%d %H:%M:%S')] ERROR: $1${NC}"
    exit 1
}

info() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')] INFO: $1${NC}"
}

# Function to execute commands on VPS
execute_on_vps() {
    local command="$1"
    local description="$2"
    
    log "Executing on VPS: $description"
    ssh -i "$SSH_KEY_PATH" -o StrictHostKeyChecking=no "$VPS_USER@$VPS_HOST" "$command"
}

# Function to copy files to VPS
copy_to_vps() {
    local local_file="$1"
    local remote_path="$2"
    local description="$3"
    
    log "Copying to VPS: $description"
    scp -i "$SSH_KEY_PATH" -o StrictHostKeyChecking=no "$local_file" "$VPS_USER@$VPS_HOST:$remote_path"
}

# Function to setup system dependencies
setup_system_dependencies() {
    log "Setting up system dependencies on VPS..."
    
    execute_on_vps "
        apt update && apt upgrade -y
        apt install -y wget curl unzip python3 python3-pip xvfb winbind
        apt install -y wine-stable winetricks
        
        # Configure Wine
        export DISPLAY=:99
        Xvfb :99 -screen 0 1024x768x24 &
        sleep 2
        
        # Initialize Wine prefix
        WINEARCH=win64 WINEPREFIX=\$HOME/.wine winecfg
        
        # Install required Windows components
        winetricks -q vcrun2019 msxml6 gdiplus
    " "System dependency installation"
}

# Function to download and install MT5
install_mt5() {
    log "Installing MetaTrader 5 on VPS..."
    
    execute_on_vps "
        # Create directories
        mkdir -p $DATA_OUTPUT_DIR
        mkdir -p /tmp/mt5_install
        cd /tmp/mt5_install
        
        # Download MT5 terminal
        wget -O mt5setup.exe 'https://download.mql5.com/cdn/web/metaquotes.software.corp/mt5/mt5setup.exe'
        
        # Install MT5 silently
        export DISPLAY=:99
        wine mt5setup.exe /S
        
        # Wait for installation to complete
        sleep 30
        
        # Verify installation
        if [ -d '$MT5_INSTALL_DIR' ]; then
            echo 'MT5 installed successfully'
        else
            echo 'MT5 installation failed'
            exit 1
        fi
    " "MT5 installation"
}

# Function to create MT5 Python API script
create_mt5_python_script() {
    log "Creating MT5 Python data collection script..."
    
    cat > /tmp/mt5_data_collector.py << 'EOF'
#!/usr/bin/env python3
import MetaTrader5 as mt5
import pandas as pd
import numpy as np
from datetime import datetime, timedelta
import os
import sys
import json
import time
import logging
from pathlib import Path

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('/root/mt5_data/mt5_collector.log'),
        logging.StreamHandler()
    ]
)

class MT5DataCollector:
    def __init__(self, login, password, server, symbol="XAUUSD"):
        self.login = int(login)
        self.password = password
        self.server = server
        self.symbol = symbol
        self.data_dir = Path("/root/mt5_data")
        self.data_dir.mkdir(exist_ok=True)
        
    def connect(self):
        """Connect to MT5 terminal"""
        if not mt5.initialize():
            logging.error(f"initialize() failed, error code = {mt5.last_error()}")
            return False
            
        # Attempt to log in
        authorized = mt5.login(self.login, password=self.password, server=self.server)
        if not authorized:
            logging.error(f"Failed to connect at account #{self.login}, error code: {mt5.last_error()}")
            mt5.shutdown()
            return False
            
        logging.info(f"Connected to account #{self.login}")
        return True
        
    def get_historical_data(self, timeframe=mt5.TIMEFRAME_M1, days_back=365):
        """Get historical data for the specified symbol"""
        try:
            # Calculate date range
            utc_from = datetime.now() - timedelta(days=days_back)
            utc_to = datetime.now()
            
            # Get rates
            rates = mt5.copy_rates_range(self.symbol, timeframe, utc_from, utc_to)
            
            if rates is None:
                logging.error(f"No data received for {self.symbol}")
                return None
                
            # Convert to DataFrame
            rates_frame = pd.DataFrame(rates)
            rates_frame['time'] = pd.to_datetime(rates_frame['time'], unit='s')
            
            logging.info(f"Retrieved {len(rates_frame)} data points for {self.symbol}")
            return rates_frame
            
        except Exception as e:
            logging.error(f"Error getting historical data: {e}")
            return None
            
    def save_data_as_csv(self, data, timeframe_name):
        """Save data as CSV file"""
        if data is None or data.empty:
            logging.warning("No data to save")
            return None
            
        filename = f"{self.symbol}_{timeframe_name}_{datetime.now().strftime('%Y%m%d_%H%M%S')}.csv"
        filepath = self.data_dir / filename
        
        # Format data for GOLDEX AI
        formatted_data = pd.DataFrame({
            'Date': data['time'].dt.strftime('%Y.%m.%d'),
            'Time': data['time'].dt.strftime('%H:%M:%S'),
            'Open': data['open'],
            'High': data['high'],
            'Low': data['low'],
            'Close': data['close'],
            'Volume': data['tick_volume']
        })
        
        formatted_data.to_csv(filepath, index=False)
        logging.info(f"Data saved to {filepath}")
        return str(filepath)
        
    def collect_multiple_timeframes(self):
        """Collect data for multiple timeframes"""
        timeframes = {
            'M1': mt5.TIMEFRAME_M1,
            'M5': mt5.TIMEFRAME_M5,
            'M15': mt5.TIMEFRAME_M15,
            'M30': mt5.TIMEFRAME_M30,
            'H1': mt5.TIMEFRAME_H1,
            'H4': mt5.TIMEFRAME_H4,
            'D1': mt5.TIMEFRAME_D1
        }
        
        collected_files = []
        
        for tf_name, tf_const in timeframes.items():
            logging.info(f"Collecting {tf_name} data...")
            data = self.get_historical_data(tf_const, days_back=365)
            
            if data is not None:
                filepath = self.save_data_as_csv(data, tf_name)
                if filepath:
                    collected_files.append(filepath)
                    
            # Add delay between requests
            time.sleep(2)
            
        return collected_files
        
    def get_account_info(self):
        """Get account information"""
        account_info = mt5.account_info()
        if account_info is None:
            logging.error("Failed to get account info")
            return None
            
        return {
            'login': account_info.login,
            'trade_mode': account_info.trade_mode,
            'leverage': account_info.leverage,
            'limit_orders': account_info.limit_orders,
            'margin_so_mode': account_info.margin_so_mode,
            'trade_allowed': account_info.trade_allowed,
            'trade_expert': account_info.trade_expert,
            'margin_mode': account_info.margin_mode,
            'currency': account_info.currency,
            'balance': account_info.balance,
            'credit': account_info.credit,
            'profit': account_info.profit,
            'equity': account_info.equity,
            'margin': account_info.margin,
            'margin_free': account_info.margin_free,
            'margin_level': account_info.margin_level,
            'margin_so_call': account_info.margin_so_call,
            'margin_so_so': account_info.margin_so_so,
            'margin_initial': account_info.margin_initial,
            'margin_maintenance': account_info.margin_maintenance,
            'assets': account_info.assets,
            'liabilities': account_info.liabilities,
            'commission_blocked': account_info.commission_blocked,
            'name': account_info.name,
            'server': account_info.server,
            'company': account_info.company
        }
        
    def create_status_report(self, collected_files):
        """Create a status report"""
        report = {
            'timestamp': datetime.now().isoformat(),
            'account': self.get_account_info(),
            'symbol': self.symbol,
            'files_collected': len(collected_files),
            'file_paths': collected_files,
            'status': 'SUCCESS' if collected_files else 'FAILED'
        }
        
        report_path = self.data_dir / f"collection_report_{datetime.now().strftime('%Y%m%d_%H%M%S')}.json"
        with open(report_path, 'w') as f:
            json.dump(report, f, indent=2)
            
        logging.info(f"Status report saved to {report_path}")
        return report
        
    def disconnect(self):
        """Disconnect from MT5"""
        mt5.shutdown()
        logging.info("Disconnected from MT5")

def main():
    # Configuration from environment or defaults
    login = os.getenv('MT5_LOGIN', '1888520701')
    password = os.getenv('MT5_PASSWORD', '3HuoTT')
    server = os.getenv('MT5_SERVER', 'Dukascopy-demo-mt5-1')
    symbol = os.getenv('MT5_SYMBOL', 'XAUUSD')
    
    collector = MT5DataCollector(login, password, server, symbol)
    
    try:
        # Connect to MT5
        if not collector.connect():
            sys.exit(1)
            
        # Collect data for multiple timeframes
        collected_files = collector.collect_multiple_timeframes()
        
        # Create status report
        report = collector.create_status_report(collected_files)
        
        logging.info(f"Data collection completed. {len(collected_files)} files collected.")
        
    except Exception as e:
        logging.error(f"Data collection failed: {e}")
        sys.exit(1)
        
    finally:
        collector.disconnect()

if __name__ == "__main__":
    main()
EOF

    copy_to_vps "/tmp/mt5_data_collector.py" "/root/mt5_data_collector.py" "MT5 Python data collector script"
}

# Function to install MetaTrader5 Python package
install_mt5_python_package() {
    log "Installing MetaTrader5 Python package..."
    
    execute_on_vps "
        pip3 install MetaTrader5 pandas numpy
        
        # Test import
        python3 -c 'import MetaTrader5 as mt5; print(f\"MT5 version: {mt5.__version__}\")'
    " "MT5 Python package installation"
}

# Function to create systemd service for automated data collection
create_systemd_service() {
    log "Creating systemd service for automated data collection..."
    
    # Create service file content
    cat > /tmp/mt5-collector.service << EOF
[Unit]
Description=MT5 GOLDEX AI Data Collector
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/root
Environment=DISPLAY=:99
Environment=MT5_LOGIN=$MT5_LOGIN
Environment=MT5_PASSWORD=$MT5_PASSWORD
Environment=MT5_SERVER=$MT5_SERVER
Environment=MT5_SYMBOL=$MT5_SYMBOL
ExecStartPre=/bin/bash -c 'Xvfb :99 -screen 0 1024x768x24 & sleep 2'
ExecStart=/usr/bin/python3 /root/mt5_data_collector.py
Restart=on-failure
RestartSec=300
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF

    # Create timer file for periodic execution
    cat > /tmp/mt5-collector.timer << EOF
[Unit]
Description=Run MT5 Data Collector every 4 hours
Requires=mt5-collector.service

[Timer]
OnCalendar=*-*-* 00,04,08,12,16,20:00:00
Persistent=true

[Install]
WantedBy=timers.target
EOF

    # Copy and enable services
    copy_to_vps "/tmp/mt5-collector.service" "/etc/systemd/system/mt5-collector.service" "MT5 collector service"
    copy_to_vps "/tmp/mt5-collector.timer" "/etc/systemd/system/mt5-collector.timer" "MT5 collector timer"
    
    execute_on_vps "
        systemctl daemon-reload
        systemctl enable mt5-collector.timer
        systemctl start mt5-collector.timer
        systemctl status mt5-collector.timer
    " "Enable and start MT5 collector timer"
}

# Function to create monitoring script
create_monitoring_script() {
    log "Creating monitoring script..."
    
    cat > /tmp/mt5_monitor.sh << 'EOF'
#!/bin/bash

# MT5 Data Collection Monitor Script
LOG_FILE="/root/mt5_data/monitor.log"
DATA_DIR="/root/mt5_data"

log_message() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

check_mt5_process() {
    if pgrep -f "mt5_data_collector.py" > /dev/null; then
        return 0
    else
        return 1
    fi
}

check_data_freshness() {
    # Check if new data files have been created in the last 6 hours
    recent_files=$(find "$DATA_DIR" -name "*.csv" -mtime -0.25 | wc -l)
    if [ "$recent_files" -gt 0 ]; then
        return 0
    else
        return 1
    fi
}

check_disk_space() {
    # Check if disk space is above 90% usage
    usage=$(df "$DATA_DIR" | awk 'NR==2 {print $5}' | sed 's/%//')
    if [ "$usage" -gt 90 ]; then
        return 1
    else
        return 0
    fi
}

cleanup_old_files() {
    # Remove files older than 30 days
    find "$DATA_DIR" -name "*.csv" -mtime +30 -delete
    find "$DATA_DIR" -name "*.json" -mtime +30 -delete
    log_message "Cleaned up old files"
}

send_status_update() {
    local status="$1"
    local message="$2"
    
    # Create status file for GOLDEX AI to read
    cat > "$DATA_DIR/status.json" << EOL
{
    "timestamp": "$(date -Iseconds)",
    "status": "$status",
    "message": "$message",
    "vps_host": "172.234.201.231",
    "data_directory": "$DATA_DIR",
    "files_count": $(find "$DATA_DIR" -name "*.csv" | wc -l),
    "latest_file": "$(find "$DATA_DIR" -name "*.csv" -printf '%T@ %p\n' | sort -n | tail -1 | cut -d' ' -f2-)"
}
EOL
}

main() {
    log_message "=== MT5 Monitor Check Started ==="
    
    # Check MT5 process
    if ! check_mt5_process; then
        log_message "WARNING: MT5 data collector process not running"
        send_status_update "WARNING" "MT5 data collector process not running"
    fi
    
    # Check data freshness
    if ! check_data_freshness; then
        log_message "WARNING: No recent data files found"
        send_status_update "WARNING" "No recent data files found (last 6 hours)"
    else
        log_message "INFO: Recent data files found"
        send_status_update "OK" "Data collection is working properly"
    fi
    
    # Check disk space
    if ! check_disk_space; then
        log_message "WARNING: Disk space usage above 90%"
        cleanup_old_files
        send_status_update "WARNING" "Disk space usage high, cleaned up old files"
    fi
    
    # Display stats
    csv_count=$(find "$DATA_DIR" -name "*.csv" | wc -l)
    log_message "INFO: Total CSV files: $csv_count"
    
    log_message "=== MT5 Monitor Check Completed ==="
}

main "$@"
EOF

    copy_to_vps "/tmp/mt5_monitor.sh" "/root/mt5_monitor.sh" "MT5 monitoring script"
    
    execute_on_vps "chmod +x /root/mt5_monitor.sh" "Make monitoring script executable"
}

# Function to create cron job for monitoring
create_monitoring_cron() {
    log "Setting up monitoring cron job..."
    
    execute_on_vps "
        # Add cron job to run monitor every 30 minutes
        (crontab -l 2>/dev/null; echo '*/30 * * * * /root/mt5_monitor.sh') | crontab -
        
        # List current cron jobs
        crontab -l
    " "Setup monitoring cron job"
}

# Function to test the setup
test_setup() {
    log "Testing MT5 setup..."
    
    execute_on_vps "
        cd /root
        export DISPLAY=:99
        
        # Start Xvfb if not running
        if ! pgrep Xvfb > /dev/null; then
            Xvfb :99 -screen 0 1024x768x24 &
            sleep 2
        fi
        
        # Test MT5 Python connection
        python3 -c '
import MetaTrader5 as mt5
import sys

print(\"Testing MT5 connection...\")
if not mt5.initialize():
    print(f\"MT5 initialize failed: {mt5.last_error()}\")
    sys.exit(1)

# Try to connect
login = int(\"$MT5_LOGIN\")
authorized = mt5.login(login, password=\"$MT5_PASSWORD\", server=\"$MT5_SERVER\")

if authorized:
    print(f\"✓ Successfully connected to account {login}\")
    account_info = mt5.account_info()
    if account_info:
        print(f\"✓ Account balance: {account_info.balance} {account_info.currency}\")
        print(f\"✓ Server: {account_info.server}\")
        print(f\"✓ Company: {account_info.company}\")
    
    # Test symbol data
    symbol_info = mt5.symbol_info(\"$MT5_SYMBOL\")
    if symbol_info:
        print(f\"✓ Symbol {symbol_info.name} is available\")
        print(f\"✓ Bid: {symbol_info.bid}, Ask: {symbol_info.ask}\")
    else:
        print(f\"✗ Symbol $MT5_SYMBOL not found\")
        
else:
    print(f\"✗ Failed to connect: {mt5.last_error()}\")
    sys.exit(1)

mt5.shutdown()
print(\"✓ MT5 connection test successful\")
'
    " "MT5 connection test"
}

# Function to run initial data collection
run_initial_collection() {
    log "Running initial data collection..."
    
    execute_on_vps "
        cd /root
        export DISPLAY=:99
        
        # Start Xvfb if not running
        if ! pgrep Xvfb > /dev/null; then
            Xvfb :99 -screen 0 1024x768x24 &
            sleep 2
        fi
        
        # Run the data collector
        python3 /root/mt5_data_collector.py
        
        # Show results
        echo '=== Data Collection Results ==='
        ls -la $DATA_OUTPUT_DIR/
        
        # Show latest status
        if [ -f '$DATA_OUTPUT_DIR/status.json' ]; then
            cat '$DATA_OUTPUT_DIR/status.json'
        fi
    " "Initial data collection"
}

# Function to display final status
show_final_status() {
    log "=== GOLDEX AI MT5 VPS Setup Complete ==="
    info "VPS Host: $VPS_HOST"
    info "MT5 Account: $MT5_LOGIN"
    info "MT5 Server: $MT5_SERVER"
    info "Symbol: $MT5_SYMBOL"
    info "Data Directory: $DATA_OUTPUT_DIR"
    
    echo ""
    log "Setup Summary:"
    echo "  ✓ System dependencies installed"
    echo "  ✓ Wine and MT5 configured"
    echo "  ✓ Python MT5 package installed"
    echo "  ✓ Data collection script deployed"
    echo "  ✓ Systemd service and timer configured"
    echo "  ✓ Monitoring script and cron job setup"
    echo "  ✓ Initial data collection completed"
    
    echo ""
    log "Services Status:"
    execute_on_vps "systemctl status mt5-collector.timer --no-pager -l" "Check timer status"
    
    echo ""
    log "Next Steps:"
    echo "  1. Data will be collected every 4 hours automatically"
    echo "  2. Monitor logs at: /root/mt5_data/mt5_collector.log"
    echo "  3. Check status at: /root/mt5_data/status.json"
    echo "  4. Access data files in: $DATA_OUTPUT_DIR"
    
    echo ""
    log "Manual Commands:"
    echo "  SSH: ssh -i $SSH_KEY_PATH $VPS_USER@$VPS_HOST"
    echo "  Collect Now: systemctl start mt5-collector.service"
    echo "  View Logs: journalctl -u mt5-collector.service -f"
    echo "  Monitor: /root/mt5_monitor.sh"
}

# Function to create SSH key if it doesn't exist
setup_ssh_key() {
    if [ ! -f "$SSH_KEY_PATH" ]; then
        warn "SSH key not found at $SSH_KEY_PATH"
        info "Please ensure you have SSH access to the VPS configured"
        info "You can create a key with: ssh-keygen -t rsa -b 4096 -f $SSH_KEY_PATH"
        read -p "Do you want to continue anyway? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
}

# Main execution
main() {
    log "Starting GOLDEX AI MT5 VPS Setup..."
    
    # Check prerequisites
    setup_ssh_key
    
    # Execute setup steps
    setup_system_dependencies
    install_mt5
    install_mt5_python_package
    create_mt5_python_script
    create_systemd_service
    create_monitoring_script
    create_monitoring_cron
    test_setup
    run_initial_collection
    
    # Show final status
    show_final_status
    
    log "GOLDEX AI MT5 VPS Setup completed successfully! 🚀"
}

# Check if script is being run directly
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    main "$@"
fi