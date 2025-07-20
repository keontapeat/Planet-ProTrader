//
// GOLDEX AI Signal Bridge Server
// Connects iOS app to MT5 Expert Advisor
//

const net = require('net');
const http = require('http');
const url = require('url');

// Configuration
const MT5_PORT = 9090;
const HTTP_PORT = 8080;
const HOST = 'localhost';

// Store active connections
let mt5Connection = null;
let signalQueue = [];

// Create TCP server for MT5 EA connection
const mt5Server = net.createServer((socket) => {
    console.log('✅ MT5 EA connected');
    mt5Connection = socket;
    
    socket.on('data', (data) => {
        try {
            const message = JSON.parse(data.toString());
            console.log('📨 Received from MT5:', message);
            
            // Handle MT5 responses
            if (message.type === 'trade_result') {
                console.log(`🎯 Trade executed: ${message.success ? 'SUCCESS' : 'FAILED'}`);
            }
            
        } catch (error) {
            console.error('❌ Error parsing MT5 data:', error);
        }
    });
    
    socket.on('close', () => {
        console.log('⚠️ MT5 EA disconnected');
        mt5Connection = null;
    });
    
    socket.on('error', (error) => {
        console.error('❌ MT5 socket error:', error);
        mt5Connection = null;
    });
});

// Create HTTP server for iOS app
const httpServer = http.createServer((req, res) => {
    // Enable CORS
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
    res.setHeader('Access-Control-Allow-Headers', 'Content-Type');
    
    if (req.method === 'OPTIONS') {
        res.writeHead(200);
        res.end();
        return;
    }
    
    const parsedUrl = url.parse(req.url, true);
    
    if (req.method === 'POST' && parsedUrl.pathname === '/api/signal') {
        let body = '';
        
        req.on('data', (chunk) => {
            body += chunk.toString();
        });
        
        req.on('end', () => {
            try {
                const signal = JSON.parse(body);
                console.log('📱 Signal received from iOS app:', signal);
                
                // Send signal to MT5 EA
                if (mt5Connection && !mt5Connection.destroyed) {
                    const signalData = JSON.stringify({
                        type: 'signal',
                        data: signal,
                        timestamp: new Date().toISOString()
                    });
                    
                    mt5Connection.write(signalData);
                    console.log('📡 Signal forwarded to MT5 EA');
                    
                    res.writeHead(200, { 'Content-Type': 'application/json' });
                    res.end(JSON.stringify({
                        success: true,
                        message: 'Signal sent to MT5 EA'
                    }));
                } else {
                    console.log('❌ MT5 EA not connected');
                    res.writeHead(503, { 'Content-Type': 'application/json' });
                    res.end(JSON.stringify({
                        success: false,
                        message: 'MT5 EA not connected'
                    }));
                }
                
            } catch (error) {
                console.error('❌ Error processing signal:', error);
                res.writeHead(400, { 'Content-Type': 'application/json' });
                res.end(JSON.stringify({
                    success: false,
                    message: 'Invalid signal format'
                }));
            }
        });
    }
    
    else if (req.method === 'GET' && parsedUrl.pathname === '/api/status') {
        res.writeHead(200, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({
            mt5_connected: mt5Connection !== null,
            signals_queued: signalQueue.length,
            uptime: process.uptime(),
            timestamp: new Date().toISOString()
        }));
    }
    
    else {
        res.writeHead(404, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({
            success: false,
            message: 'Endpoint not found'
        }));
    }
});

// Start servers
mt5Server.listen(MT5_PORT, HOST, () => {
    console.log(`🚀 MT5 Bridge Server started on ${HOST}:${MT5_PORT}`);
    console.log('📡 Waiting for MT5 EA connection...');
});

httpServer.listen(HTTP_PORT, HOST, () => {
    console.log(`📱 HTTP API Server started on ${HOST}:${HTTP_PORT}`);
    console.log('🔗 iOS app can connect to: http://localhost:8080');
});

// Graceful shutdown
process.on('SIGINT', () => {
    console.log('\n🛑 Shutting down servers...');
    
    if (mt5Connection) {
        mt5Connection.end();
    }
    
    mt5Server.close(() => {
        console.log('✅ MT5 server closed');
    });
    
    httpServer.close(() => {
        console.log('✅ HTTP server closed');
        process.exit(0);
    });
});

console.log(`
🎯 GOLDEX AI Signal Bridge Server
================================
MT5 EA Port: ${MT5_PORT}
iOS API Port: ${HTTP_PORT}

Ready to connect your iOS app to your MT5 Expert Advisor!
`);