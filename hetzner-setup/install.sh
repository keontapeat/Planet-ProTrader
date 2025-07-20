#!/bin/bash
echo "🚀 GOLDEX AI Setup Starting..."

# Update system
apt update && apt upgrade -y

# Install Node.js
curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
apt-get install -y nodejs

# Install Python
apt install -y python3.11 python3.11-pip python3.11-venv

# Install Chrome
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list
apt update && apt install -y google-chrome-stable

# Create app directory
mkdir -p /opt/goldex-ai && cd /opt/goldex-ai

# Python environment
python3.11 -m venv goldex-env
source goldex-env/bin/activate

# Install packages
pip install firebase-admin anthropic schedule requests python-dotenv
npm install -g pm2
npm init -y && npm install express firebase-admin puppeteer ws axios dotenv

echo "✅ Setup Complete!"