const admin = require('firebase-admin');
const WebSocket = require('ws');

// Initialize Firebase
const serviceAccount = require('/opt/goldex-ai/firebase-key.json');
admin.initializeApp({
    credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

// WebSocket server for real-time updates
const wss = new WebSocket.Server({ port: 8080 });

wss.on('connection', (ws) => {
    console.log('📱 App connected');
    
    // Listen for new signals
    db.collection('signals')
        .where('delivered', '==', false)
        .onSnapshot((snapshot) => {
            snapshot.docChanges().forEach((change) => {
                if (change.type === 'added') {
                    const signal = change.doc.data();
                    
                    // Send to app
                    ws.send(JSON.stringify({
                        type: 'NEW_SIGNAL',
                        data: signal
                    }));
                    
                    // Mark delivered
                    change.doc.ref.update({ delivered: true });
                    
                    console.log('📡 Signal delivered to app');
                }
            });
        });
});

console.log('🔌 Firebase sync running on port 8080');