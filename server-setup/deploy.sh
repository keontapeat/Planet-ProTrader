#!/bin/bash
# GOLDEX AI™ Complete Deployment Script

set -e
echo "🚀 Deploying GOLDEX AI™ to Hetzner Cloud..."

# Copy files to server
scp -r . root@YOUR_SERVER_IP:/opt/goldex-ai/

# Connect and deploy
ssh root@YOUR_SERVER_IP << 'EOF'
cd /opt/goldex-ai

# Activate Python environment
source goldex-env/bin/activate

# Install dependencies if not already installed
pip install -r requirements.txt 2>/dev/null || echo "Requirements already installed"
npm install

# Create systemd service for trading bot
cat > /etc/systemd/system/goldex-trading-bot.service << 'EOL'
[Unit]
Description=GOLDEX AI Trading Bot
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/opt/goldex-ai
Environment=PATH=/opt/goldex-ai/goldex-env/bin
ExecStart=/opt/goldex-ai/goldex-env/bin/python goldex-trading-bot.py
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOL

# Start services
systemctl daemon-reload
systemctl enable goldex-trading-bot
systemctl start goldex-trading-bot

# Start Node.js services with PM2
pm2 start firebase-sync.js --name "firebase-sync"
pm2 start screenshot-service.js --name "screenshots"
pm2 startup
pm2 save

echo "✅ GOLDEX AI™ deployed successfully!"
echo "🔍 Check status with: systemctl status goldex-trading-bot"
echo "📊 Monitor with: pm2 monit"
EOF