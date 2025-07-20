const puppeteer = require('puppeteer');
const express = require('express');
const admin = require('firebase-admin');

class TradingViewScreenshotService {
    constructor() {
        this.browser = null;
        this.page = null;
        this.setupExpressServer();
        this.initializeBrowser();
    }
    
    async initializeBrowser() {
        try {
            this.browser = await puppeteer.launch({
                headless: true,
                args: [
                    '--no-sandbox',
                    '--disable-setuid-sandbox',
                    '--disable-dev-shm-usage',
                    '--disable-gpu'
                ]
            });
            
            this.page = await this.browser.newPage();
            await this.page.setViewport({ width: 1920, height: 1080 });
            
            console.log('✅ Puppeteer browser initialized');
        } catch (error) {
            console.error('❌ Browser initialization failed:', error);
        }
    }
    
    setupExpressServer() {
        this.app = express();
        this.app.use(express.json());
        
        // Capture screenshot endpoint
        this.app.post('/capture', async (req, res) => {
            try {
                const { trade_id, symbol = 'XAUUSD', timeframe = '5m' } = req.body;
                
                const screenshot = await this.captureChart(symbol, timeframe, trade_id);
                
                if (screenshot) {
                    res.json({
                        success: true,
                        trade_id,
                        screenshot_url: screenshot.url,
                        filename: screenshot.filename
                    });
                } else {
                    res.status(500).json({ error: 'Screenshot capture failed' });
                }
                
            } catch (error) {
                res.status(500).json({ error: error.message });
            }
        });
        
        const port = 3001;
        this.app.listen(port, () => {
            console.log(`📷 Screenshot service running on port ${port}`);
        });
    }
    
    async captureChart(symbol = 'XAUUSD', timeframe = '5m', trade_id = null) {
        try {
            if (!this.page) {
                await this.initializeBrowser();
            }
            
            // Navigate to TradingView
            const url = `https://www.tradingview.com/chart/?symbol=OANDA:${symbol}&interval=${timeframe}`;
            await this.page.goto(url, { 
                waitUntil: 'networkidle2',
                timeout: 60000 
            });
            
            // Wait for chart to fully load
            await this.page.waitForSelector('.chart-container', { timeout: 30000 });
            await this.page.waitForTimeout(5000); // Additional wait for chart data
            
            // Remove ads and overlays
            await this.page.evaluate(() => {
                // Remove common ad elements
                const selectors = [
                    '.js-rootresizer__contents',
                    '.tv-dialog__modal-wrap',
                    '.tv-float-toolbar',
                    '.tv-header',
                    '.tv-footer'
                ];
                
                selectors.forEach(selector => {
                    const elements = document.querySelectorAll(selector);
                    elements.forEach(el => el.style.display = 'none');
                });
            });
            
            // Take screenshot
            const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
            const filename = `${symbol}_${timeframe}_${timestamp}${trade_id ? '_' + trade_id : ''}.png`;
            
            const screenshot = await this.page.screenshot({
                type: 'png',
                fullPage: false,
                clip: { x: 0, y: 100, width: 1920, height: 900 }
            });
            
            // Upload to Firebase Storage
            const bucket = admin.storage().bucket();
            const file = bucket.file(`screenshots/${filename}`);
            
            await file.save(screenshot, {
                metadata: {
                    contentType: 'image/png',
                    metadata: {
                        symbol,
                        timeframe,
                        trade_id: trade_id || 'manual',
                        timestamp
                    }
                }
            });
            
            // Make file publicly accessible
            await file.makePublic();
            
            const publicUrl = `https://storage.googleapis.com/${bucket.name}/screenshots/${filename}`;
            
            // Save screenshot reference to Firestore
            await admin.firestore().collection('screenshots').add({
                filename,
                url: publicUrl,
                symbol,
                timeframe,
                trade_id,
                timestamp: admin.firestore.Timestamp.now(),
                size: screenshot.length
            });
            
            console.log(`📸 Screenshot captured: ${filename}`);
            
            return {
                filename,
                url: publicUrl,
                size: screenshot.length
            };
            
        } catch (error) {
            console.error('❌ Screenshot capture failed:', error);
            return null;
        }
    }
    
    async close() {
        if (this.browser) {
            await this.browser.close();
        }
    }
}

// Start the screenshot service
new TradingViewScreenshotService();

// Graceful shutdown
process.on('SIGINT', async () => {
    console.log('🛑 Shutting down screenshot service...');
    process.exit(0);
});