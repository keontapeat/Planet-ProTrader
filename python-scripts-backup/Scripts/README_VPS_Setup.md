# GOLDEX AI VPS MetaTrader 5 Setup Guide

## Overview
This script automates the setup of MetaTrader 5 on your VPS (172.234.201.231) for collecting historical XAUUSD data to train your 5,000 bot army.

## VPS Configuration
- **Host**: 172.234.201.231
- **OS**: Ubuntu 22.04 LTS
- **Wine**: 10.0
- **User**: root

## MT5 Demo Account Details
- **Login**: 1888520701
- **Server**: Dukascopy-demo-mt5-1
- **Password**: 3HuoTT
- **Symbol**: XAUUSD (Gold)

## Quick Start

### 1. Run the Setup Script
```bash
cd "GOLDEX AI/Scripts"
./vps_mt5_setup.sh
```

### 2. What the Script Does
- ✅ Installs system dependencies (Wine, Python3, Xvfb)
- ✅ Downloads and installs MetaTrader 5
- ✅ Installs MetaTrader5 Python package
- ✅ Creates automated data collection script
- ✅ Sets up systemd service for 4-hour data collection
- ✅ Creates monitoring and cleanup scripts
- ✅ Runs initial data collection

### 3. Data Collection Schedule
- **Automatic**: Every 4 hours (00:00, 04:00, 08:00, 12:00, 16:00, 20:00 UTC)
- **Timeframes**: M1, M5, M15, M30, H1, H4, D1
- **Data Location**: `/root/mt5_data/`

## Manual Operations

### SSH Access
```bash
ssh -i ~/.ssh/goldex_vps_key root@172.234.201.231
```

### Manual Data Collection
```bash
# Run data collection now
systemctl start mt5-collector.service

# Check collection status
systemctl status mt5-collector.service

# View real-time logs
journalctl -u mt5-collector.service -f
```

### Monitor Data Collection
```bash
# Run monitoring script
/root/mt5_monitor.sh

# Check latest status
cat /root/mt5_data/status.json

# List collected files
ls -la /root/mt5_data/*.csv
```

### Service Management
```bash
# Check timer status
systemctl status mt5-collector.timer

# Stop automatic collection
systemctl stop mt5-collector.timer

# Start automatic collection
systemctl start mt5-collector.timer

# Restart collection service
systemctl restart mt5-collector.service
```

## Data Format
CSV files are formatted for direct import into GOLDEX AI:
```csv
Date,Time,Open,High,Low,Close,Volume
2025.07.19,00:00:00,2000.123,2001.456,1999.789,2000.987,1500
2025.07.19,00:01:00,2000.987,2002.234,2000.567,2001.678,1200
```

## File Structure
```
/root/mt5_data/
├── XAUUSD_M1_20250719_120000.csv    # 1-minute data
├── XAUUSD_M5_20250719_120000.csv    # 5-minute data
├── XAUUSD_H1_20250719_120000.csv    # 1-hour data
├── XAUUSD_D1_20250719_120000.csv    # Daily data
├── collection_report_*.json          # Status reports
├── status.json                       # Current status
├── mt5_collector.log                 # Collection logs
└── monitor.log                       # Monitor logs
```

## Integration with GOLDEX AI

### 1. Download Data to Local Machine
```bash
# Download all CSV files
scp -i ~/.ssh/goldex_vps_key root@172.234.201.231:/root/mt5_data/*.csv ./

# Download specific timeframe
scp -i ~/.ssh/goldex_vps_key root@172.234.201.231:/root/mt5_data/XAUUSD_H1_*.csv ./
```

### 2. Import into GOLDEX AI
1. Open GOLDEX AI app
2. Navigate to ProTrader Dashboard
3. Click "Import Training Data"
4. Select the downloaded CSV files
5. Start training your 5,000 bot army

### 3. Automated Sync (Future Enhancement)
The VPS can be configured to automatically sync data with your GOLDEX AI app using:
- Supabase integration
- Firebase storage
- Direct API endpoints

## Troubleshooting

### Connection Issues
```bash
# Test MT5 connection
python3 -c "
import MetaTrader5 as mt5
mt5.initialize()
print('MT5 initialized:', mt5.last_error())
"
```

### Xvfb Display Issues
```bash
# Start virtual display
export DISPLAY=:99
Xvfb :99 -screen 0 1024x768x24 &
```

### Wine Configuration
```bash
# Reconfigure Wine
WINEARCH=win64 WINEPREFIX=$HOME/.wine winecfg
```

### Disk Space Management
```bash
# Check disk usage
df -h /root/mt5_data

# Clean old files (30+ days)
find /root/mt5_data -name "*.csv" -mtime +30 -delete
```

## Monitoring & Alerts

### Status Check
```bash
# Quick status
curl -s http://localhost:8080/status 2>/dev/null || echo "Service not running"

# Detailed status
python3 -c "
import json
with open('/root/mt5_data/status.json') as f:
    status = json.load(f)
    print(f'Status: {status[\"status\"]}')
    print(f'Files: {status[\"files_count\"]}')
    print(f'Last Update: {status[\"timestamp\"]}')
"
```

### Log Analysis
```bash
# Recent errors
tail -n 50 /root/mt5_data/mt5_collector.log | grep ERROR

# Collection statistics
grep "data points for XAUUSD" /root/mt5_data/mt5_collector.log | tail -10
```

## Security Notes
- SSH key authentication required
- MT5 demo account (no real money at risk)
- Firewall configured for SSH only
- Automated security updates enabled

## Support
For issues or enhancements:
1. Check logs: `/root/mt5_data/mt5_collector.log`
2. Verify services: `systemctl status mt5-collector.timer`
3. Test connection: Run manual collection script
4. Review monitoring: `/root/mt5_monitor.sh`

---

**🚀 Your 5,000 bot army is now powered by real historical XAUUSD data from Dukascopy!**