#!/bin/bash
# GOLDEX AI™ Complete Auto-Setup Script
# Just run: bash install-goldex.sh

set -e
echo "🚀 GOLDEX AI™ Auto-Installation Starting..."

# Update system
apt update && apt upgrade -y

# Install essentials
apt install -y curl wget git htop nano ufw fail2ban software-properties-common

# Install Node.js 18
curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
apt-get install -y nodejs

# Install Python 3.11
add-apt-repository ppa:deadsnakes/ppa -y
apt update
apt install -y python3.11 python3.11-pip python3.11-venv

# Install Chrome for screenshots
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list
apt update
apt install -y google-chrome-stable

# Create app directory
mkdir -p /opt/goldex-ai
cd /opt/goldex-ai

# Create Python virtual environment
python3.11 -m venv goldex-env
source goldex-env/bin/activate

# Install Python packages
pip install --upgrade pip
pip install firebase-admin MetaTrader5 requests selenium pandas numpy schedule python-dotenv anthropic beautifulsoup4

# Install Node.js packages
npm init -y
npm install express firebase-admin puppeteer ws axios dotenv node-cron anthropic

# Install PM2 for process management
npm install -g pm2

# Setup firewall
ufw allow 22
ufw allow 80
ufw allow 443
ufw allow 8080
ufw --force enable

echo "✅ GOLDEX AI™ Base Installation Complete!"
echo "Next: Upload your credentials and run the trading bot"