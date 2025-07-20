# 🚀 GOLDEX AI - MT5 Expert Advisor Setup Guide

## 📋 **What You'll Get:**
- **Real MT5 Expert Advisor** that connects to your Coinexx account (845514)
- **Automatic trade execution** from your iOS app signals
- **Risk management** with 2% max risk per trade
- **Real-time balance monitoring** and notifications
- **Professional trading statistics** and performance tracking

---

## 🔧 **Step 1: Install the Expert Advisor**

### **1.1 Download MetaTrader 5**
- Download MT5 from: https://www.metatrader5.com/
- Install on your computer (Windows/Mac)

### **1.2 Install the GOLDEX AI EA**
1. Open **MetaEditor** (comes with MT5)
2. Create new file: `File → New → Expert Advisor`
3. Name it: `GOLDEX_AI`
4. **Copy the entire EA code** from `GOLDEX_AI.mq5` into the editor
5. Save and **Compile** (F7)
6. Make sure compilation is successful ✅

---

## 🔐 **Step 2: Connect to Your Coinexx Account**

### **2.1 Account Details**
- **Account Number:** 845514
- **Password:** Jj0@AfHgVv7kpj
- **Server:** Coinexx-demo
- **Current Balance:** $1,270

### **2.2 Login to MT5**
1. Open MetaTrader 5
2. Click `File → Login to Trade Account`
3. Enter your credentials above
4. Select server: `Coinexx-demo`
5. Click **Login**

---

## 📊 **Step 3: Setup the Expert Advisor**

### **3.1 Add EA to Chart**
1. Open **XAUUSD** chart (1-minute or 5-minute timeframe)
2. Navigate to `Navigator → Expert Advisors`
3. Drag `GOLDEX_AI` onto the XAUUSD chart
4. **Allow live trading** when prompted ✅

### **3.2 Configure EA Settings**
When you drag the EA, you'll see these settings:

#### **🎯 GOLDEX AI SETTINGS**
- ✅ **Enable Auto Trading:** `true`
- ✅ **Enable Test Mode:** `true` (for more frequent signals)
- **Max Risk Per Trade:** `2.0%` (conservative for your $1,270 balance)
- **Max Daily Trades:** `5` (start conservative)
- **Max Daily Risk:** `10.0%` (daily limit)

#### **📡 SIGNAL SETTINGS**
- **Minimum Confidence:** `80%` (only high-confidence signals)
- **Signal Timeout:** `120 seconds`
- ✅ **Enable Scalp Mode:** `true`
- ✅ **Enable Swing Mode:** `true`

#### **💰 RISK MANAGEMENT**
- **Maximum Lot Size:** `0.05` (conservative for your balance)
- **Minimum Lot Size:** `0.01`
- **Risk:Reward Ratio:** `2.0` (2:1 ratio)
- **Max Spread:** `30 points`

#### **🔔 NOTIFICATIONS**
- ✅ **Enable Push Notifications:** `true`
- **Enable Email Notifications:** `false`
- ✅ **Enable Sound Alerts:** `true`

---

## 🎯 **Step 4: Test the System**

### **4.1 First Test**
1. **Start the EA** on XAUUSD chart
2. You should see: `"GOLDEX AI Expert Advisor Started"`
3. **Wait 30 seconds** - in test mode, it generates signals frequently
4. Watch for: `"✅ Trade Executed"` messages

### **4.2 What to Expect**
- **Test mode:** Signals every 30 seconds
- **Normal mode:** Signals every 5 minutes
- **Lot sizes:** 0.01-0.05 (very conservative)
- **Risk per trade:** Max 2% of $1,270 = $25.40

---

## 📱 **Step 5: Connect iOS App (Optional)**

### **5.1 iOS App Integration**
The EA can work standalone OR receive signals from your iOS app:

1. **Open your GOLDEX AI app**
2. Go to **"MT5 Setup"** tab
3. **Enable "Connect to MT5"**
4. The app will send signals to the EA automatically

### **5.2 Manual Trading Mode**
- Switch EA to **"Manual Trading Assistant"**
- iOS app provides exact trade instructions
- You execute trades manually following the instructions

---

## 🛡️ **Step 6: Risk Management & Safety**

### **6.1 Conservative Settings (Recommended)**