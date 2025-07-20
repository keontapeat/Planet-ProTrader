const admin = require('firebase-admin');
const WebSocket = require('ws');
const express = require('express');

class GoldexFirebaseSync {
    constructor() {
        this.initializeFirebase();
        this.setupWebSocketServer();
        this.setupExpressServer();
        this.startServices();
    }
    
    initializeFirebase() {
        const serviceAccount = require('/opt/goldex-ai/firebase-credentials.json');
        
        admin.initializeApp({
            credential: admin.credential.cert(serviceAccount),
            databaseURL: `https://${process.env.FIREBASE_PROJECT_ID}.firebaseio.com`,
            storageBucket: `${process.env.FIREBASE_PROJECT_ID}.appspot.com`
        });
        
        this.db = admin.firestore();
        this.messaging = admin.messaging();
        
        console.log('✅ Firebase initialized');
    }
    
    setupWebSocketServer() {
        this.wss = new WebSocket.Server({ port: 8080 });
        
        this.wss.on('connection', (ws) => {
            console.log('📱 SwiftUI app connected via WebSocket');
            
            // Send real-time signals to connected apps
            this.db.collection('signals')
                .where('delivered', '==', false)
                .onSnapshot((snapshot) => {
                    snapshot.docChanges().forEach((change) => {
                        if (change.type === 'added') {
                            const signal = change.doc.data();
                            
                            // Send to connected SwiftUI apps
                            ws.send(JSON.stringify({
                                type: 'NEW_SIGNAL',
                                data: signal,
                                timestamp: new Date().toISOString()
                            }));
                            
                            // Mark as delivered
                            change.doc.ref.update({ delivered: true });
                            
                            console.log(`📡 Signal delivered: ${signal.signal.signal} - ${signal.signal.confidence}%`);
                        }
                    });
                });
                
            // Send trade updates
            this.db.collection('trades')
                .where('app_notified', '==', false)
                .onSnapshot((snapshot) => {
                    snapshot.docChanges().forEach((change) => {
                        if (change.type === 'added' || change.type === 'modified') {
                            const trade = change.doc.data();
                            
                            ws.send(JSON.stringify({
                                type: 'TRADE_UPDATE',
                                data: trade,
                                timestamp: new Date().toISOString()
                            }));
                            
                            // Mark as notified
                            change.doc.ref.update({ app_notified: true });
                        }
                    });
                });
        });
        
        console.log('🔌 WebSocket server running on port 8080');
    }
    
    setupExpressServer() {
        this.app = express();
        this.app.use(express.json());
        
        // Health check endpoint
        this.app.get('/health', (req, res) => {
            res.json({
                status: 'healthy',
                timestamp: new Date().toISOString(),
                service: 'GOLDEX AI Firebase Sync'
            });
        });
        
        // Get latest signals
        this.app.get('/api/signals/latest', async (req, res) => {
            try {
                const snapshot = await this.db.collection('signals')
                    .orderBy('timestamp', 'desc')
                    .limit(10)
                    .get();
                    
                const signals = snapshot.docs.map(doc => ({
                    id: doc.id,
                    ...doc.data()
                }));
                
                res.json(signals);
            } catch (error) {
                res.status(500).json({ error: error.message });
            }
        });
        
        // Get active trades
        this.app.get('/api/trades/active', async (req, res) => {
            try {
                const snapshot = await this.db.collection('trades')
                    .where('status', '==', 'ACTIVE')
                    .get();
                    
                const trades = snapshot.docs.map(doc => ({
                    id: doc.id,
                    ...doc.data()
                }));
                
                res.json(trades);
            } catch (error) {
                res.status(500).json({ error: error.message });
            }
        });
        
        // Push notification endpoint
        this.app.post('/api/notify', async (req, res) => {
            try {
                const { title, body, data } = req.body;
                
                const message = {
                    notification: { title, body },
                    data: data || {},
                    topic: 'goldex-trading-signals'
                };
                
                const response = await this.messaging.send(message);
                res.json({ success: true, messageId: response });
                
            } catch (error) {
                res.status(500).json({ error: error.message });
            }
        });
        
        console.log('🌐 Express API server configured');
    }
    
    startServices() {
        const port = process.env.PORT || 3000;
        this.app.listen(port, () => {
            console.log(`🚀 GOLDEX AI Firebase Sync running on port ${port}`);
        });
    }
    
    async sendPushNotification(signal) {
        try {
            const message = {
                notification: {
                    title: `🎯 ${signal.signal} Signal - ${signal.confidence}%`,
                    body: `XAUUSD @ ${signal.entry_price} | R:R ${signal.risk_reward_ratio}:1`,
                },
                data: {
                    signal_id: signal.signal_id || '',
                    trade_id: signal.trade_id || '',
                    confidence: signal.confidence.toString(),
                    entry_price: signal.entry_price.toString()
                },
                topic: 'goldex-trading-signals'
            };
            
            const response = await this.messaging.send(message);
            console.log('📲 Push notification sent:', response);
            
        } catch (error) {
            console.error('❌ Push notification failed:', error);
        }
    }
}

// Start the Firebase sync service
new GoldexFirebaseSync();