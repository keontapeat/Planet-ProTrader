//
//  VoiceCommandService.swift - Revolutionary Voice Trading System
//  GOLDEX AI - "Hey GOLDEX, make me rich!" 🗣️💰
//
//  Created by AI Assistant on 7/18/25.
//

import Speech
import AVFoundation
import SwiftUI
import Combine

@MainActor
class VoiceCommandService: NSObject, ObservableObject {
    
    // MARK: - Published Properties
    @Published var isListening = false
    @Published var isVoiceEnabled = false
    @Published var lastCommand = ""
    @Published var voiceResponse = ""
    @Published var recognitionAccuracy: Float = 0.0
    @Published var supportedCommands: [VoiceCommand] = []
    @Published var commandHistory: [VoiceCommandHistory] = []
    @Published var voicePersonality: VoicePersonality = .professional
    
    // MARK: - Speech Recognition
    private let speechRecognizer = SFSpeechRecognizer()
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    // MARK: - Text to Speech
    private let synthesizer = AVSpeechSynthesizer()
    
    // MARK: - Command Processing
    private var tradingViewModel: TradingViewModel?
    private var portfolioData: [String: Any] = [:]
    
    enum VoicePersonality: String, CaseIterable {
        case professional = "Professional Trader"
        case enthusiastic = "Enthusiastic Coach"
        case calm = "Zen Master"
        case military = "Drill Sergeant"
        
        var voice: String {
            switch self {
            case .professional: return "com.apple.ttsbundle.Samantha-compact"
            case .enthusiastic: return "com.apple.ttsbundle.Alex-compact" 
            case .calm: return "com.apple.ttsbundle.Victoria-compact"
            case .military: return "com.apple.ttsbundle.Daniel-compact"
            }
        }
        
        var responseStyle: ResponseStyle {
            switch self {
            case .professional: return .formal
            case .enthusiastic: return .energetic
            case .calm: return .peaceful
            case .military: return .commanding
            }
        }
    }
    
    enum ResponseStyle {
        case formal, energetic, peaceful, commanding
    }
    
    override init() {
        super.init()
        setupVoiceCommands()
        requestPermissions()
    }
    
    // MARK: - Setup
    
    private func setupVoiceCommands() {
        supportedCommands = [
            // Trading Commands
            VoiceCommand(
                trigger: ["buy", "purchase", "long"],
                action: .trade,
                examples: ["Buy XAUUSD", "Purchase gold", "Go long on EUR USD"],
                description: "Execute a buy order"
            ),
            VoiceCommand(
                trigger: ["sell", "short", "dump"],
                action: .trade,
                examples: ["Sell XAUUSD", "Short gold", "Dump my position"],
                description: "Execute a sell order"
            ),
            
            // Portfolio Commands  
            VoiceCommand(
                trigger: ["show", "display", "portfolio", "balance", "pnl"],
                action: .showPortfolio,
                examples: ["Show my portfolio", "Display balance", "What's my P&L"],
                description: "Display portfolio information"
            ),
            
            // Analysis Commands
            VoiceCommand(
                trigger: ["analyze", "analysis", "setup", "signal"],
                action: .analyze,
                examples: ["Analyze XAUUSD", "What's the setup", "Any signals"],
                description: "Analyze market conditions"
            ),
            
            // Backtesting Commands
            VoiceCommand(
                trigger: ["backtest", "replay", "test", "simulate"],
                action: .backtest,
                examples: ["Start backtest", "Replay last week", "Test my strategy"],
                description: "Start backtesting session"
            ),
            
            // Bot Commands
            VoiceCommand(
                trigger: ["bot", "ai", "assistant", "activate"],
                action: .botControl,
                examples: ["Activate bots", "AI assistant", "Wake up the bots"],
                description: "Control AI trading bots"
            ),
            
            // News & Market Commands
            VoiceCommand(
                trigger: ["news", "market", "events", "calendar"],
                action: .marketNews,
                examples: ["Show market news", "Any events today", "Economic calendar"],
                description: "Display market news and events"
            ),
            
            // Position Management
            VoiceCommand(
                trigger: ["close", "exit", "stop", "take profit"],
                action: .positionManagement,
                examples: ["Close all positions", "Exit XAUUSD", "Take profit on gold"],
                description: "Manage existing positions"
            ),
            
            // Settings & Help
            VoiceCommand(
                trigger: ["help", "commands", "settings", "tutorial"],
                action: .help,
                examples: ["Show help", "What commands", "Voice settings"],
                description: "Display help and settings"
            ),
            
            // Fun Commands
            VoiceCommand(
                trigger: ["make me rich", "profit", "money", "legendary"],
                action: .motivational,
                examples: ["Make me rich", "Show me the money", "Let's get legendary"],
                description: "Motivational responses"
            )
        ]
    }
    
    private func requestPermissions() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            DispatchQueue.main.async {
                switch authStatus {
                case .authorized:
                    self.isVoiceEnabled = true
                case .denied, .restricted, .notDetermined:
                    self.isVoiceEnabled = false
                @unknown default:
                    self.isVoiceEnabled = false
                }
            }
        }
        
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            DispatchQueue.main.async {
                if !granted {
                    self.isVoiceEnabled = false
                }
            }
        }
    }
    
    // MARK: - Voice Recognition
    
    func startListening() {
        guard isVoiceEnabled else { return }
        
        // Cancel previous tasks
        recognitionTask?.cancel()
        recognitionTask = nil
        
        // Configure audio session
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try? audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        
        // Create recognition request
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else { return }
        
        recognitionRequest.shouldReportPartialResults = true
        
        // Create recognition task
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { result, error in
            var isFinal = false
            
            if let result = result {
                let bestString = result.bestTranscription.formattedString
                DispatchQueue.main.async {
                    self.lastCommand = bestString
                    self.recognitionAccuracy = result.bestTranscription.segments.last?.confidence ?? 0.0
                }
                isFinal = result.isFinal
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                self.audioEngine.inputNode.removeTap(onBus: 0)
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                DispatchQueue.main.async {
                    self.isListening = false
                    if !self.lastCommand.isEmpty {
                        self.processVoiceCommand(self.lastCommand)
                    }
                }
            }
        }
        
        // Configure audio input
        let recordingFormat = audioEngine.inputNode.outputFormat(forBus: 0)
        audioEngine.inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        try? audioEngine.start()
        isListening = true
    }
    
    func stopListening() {
        audioEngine.stop()
        recognitionRequest?.endAudio()
        isListening = false
    }
    
    // MARK: - Command Processing
    
    private func processVoiceCommand(_ command: String) {
        let lowercaseCommand = command.lowercased()
        
        // Find matching command
        var matchedCommand: VoiceCommand?
        for voiceCommand in supportedCommands {
            for trigger in voiceCommand.trigger {
                if lowercaseCommand.contains(trigger.lowercased()) {
                    matchedCommand = voiceCommand
                    break
                }
            }
            if matchedCommand != nil { break }
        }
        
        guard let command = matchedCommand else {
            respondWithVoice("I didn't understand that command. Say 'help' for available commands.")
            return
        }
        
        // Execute command
        executeCommand(command, originalText: lowercaseCommand)
        
        // Add to history
        let historyEntry = VoiceCommandHistory(
            id: UUID().uuidString,
            timestamp: Date(),
            command: lastCommand,
            action: command.action,
            response: voiceResponse,
            success: true
        )
        commandHistory.insert(historyEntry, at: 0)
        
        // Keep only last 50 entries
        if commandHistory.count > 50 {
            commandHistory.removeLast()
        }
    }
    
    private func executeCommand(_ command: VoiceCommand, originalText: String) {
        switch command.action {
        case .trade:
            handleTradeCommand(originalText)
        case .showPortfolio:
            handlePortfolioCommand()
        case .analyze:
            handleAnalysisCommand(originalText)
        case .backtest:
            handleBacktestCommand()
        case .botControl:
            handleBotControlCommand(originalText)
        case .marketNews:
            handleMarketNewsCommand()
        case .positionManagement:
            handlePositionManagementCommand(originalText)
        case .help:
            handleHelpCommand()
        case .motivational:
            handleMotivationalCommand()
        }
    }
    
    // MARK: - Command Handlers
    
    private func handleTradeCommand(_ text: String) {
        // Extract symbol and direction
        let symbols = ["XAUUSD", "EURUSD", "GBPUSD", "USDJPY", "gold", "eur", "gbp", "jpy"]
        var detectedSymbol = "XAUUSD" // default
        
        for symbol in symbols {
            if text.contains(symbol.lowercased()) {
                detectedSymbol = symbol.uppercased()
                if symbol == "gold" { detectedSymbol = "XAUUSD" }
                break
            }
        }
        
        let isBuy = text.contains("buy") || text.contains("long") || text.contains("purchase")
        let direction = isBuy ? "BUY" : "SELL"
        
        let responses = generateTradeResponse(symbol: detectedSymbol, direction: direction)
        respondWithVoice(responses.randomElement()!)
    }
    
    private func handlePortfolioCommand() {
        // Mock portfolio data - replace with real data
        let balance = 10545.67
        let pnl = 234.50
        let openPositions = 3
        
        let responses = generatePortfolioResponse(balance: balance, pnl: pnl, openPositions: openPositions)
        respondWithVoice(responses.randomElement()!)
    }
    
    private func handleAnalysisCommand(_ text: String) {
        let responses = generateAnalysisResponse()
        respondWithVoice(responses.randomElement()!)
    }
    
    private func handleBacktestCommand() {
        let responses = generateBacktestResponse()
        respondWithVoice(responses.randomElement()!)
    }
    
    private func handleBotControlCommand(_ text: String) {
        let responses = generateBotControlResponse()
        respondWithVoice(responses.randomElement()!)
    }
    
    private func handleMarketNewsCommand() {
        let responses = generateMarketNewsResponse()
        respondWithVoice(responses.randomElement()!)
    }
    
    private func handlePositionManagementCommand(_ text: String) {
        let responses = generatePositionManagementResponse()
        respondWithVoice(responses.randomElement()!)
    }
    
    private func handleHelpCommand() {
        let commandCount = supportedCommands.count
        respondWithVoice("I can help you with \(commandCount) different types of commands. You can say things like 'buy gold', 'show portfolio', 'analyze XAUUSD', or 'start backtest'. What would you like to do?")
    }
    
    private func handleMotivationalCommand() {
        let responses = generateMotivationalResponse()
        respondWithVoice(responses.randomElement()!)
    }
    
    // MARK: - Response Generators
    
    private func generateTradeResponse(symbol: String, direction: String) -> [String] {
        switch voicePersonality.responseStyle {
        case .formal:
            return [
                "Analyzing \(direction) order for \(symbol). Please confirm your position size.",
                "Preparing to execute \(direction) order on \(symbol). Risk management parameters are being calculated.",
                "Market conditions analyzed. Ready to place \(direction) order for \(symbol)."
            ]
        case .energetic:
            return [
                "YES! Let's \(direction) \(symbol)! This could be LEGENDARY!",
                "BOOM! \(direction) order for \(symbol) coming right up! Let's make some money!",
                "OH YEAH! Time to \(direction) \(symbol)! This is going to be EPIC!"
            ]
        case .peaceful:
            return [
                "Calmly preparing your \(direction) order for \(symbol). Breathe and trust the process.",
                "With patience and discipline, we'll execute this \(direction) on \(symbol).",
                "Inner peace achieved. Your \(direction) order for \(symbol) is being prepared mindfully."
            ]
        case .commanding:
            return [
                "ROGER! \(direction) ORDER FOR \(symbol) ACKNOWLEDGED! EXECUTING IMMEDIATELY!",
                "AFFIRMATIVE! PREPARING TO \(direction) \(symbol)! MISSION PARAMETERS CONFIRMED!",
                "COPY THAT! \(direction) POSITION ON \(symbol) IS A GO! DEPLOYING CAPITAL!"
            ]
        }
    }
    
    private func generatePortfolioResponse(balance: Double, pnl: Double, openPositions: Int) -> [String] {
        let balanceStr = String(format: "%.2f", balance)
        let pnlStr = String(format: "%.2f", abs(pnl))
        let pnlDirection = pnl >= 0 ? "profit" : "loss"
        
        switch voicePersonality.responseStyle {
        case .formal:
            return [
                "Current account balance is $\(balanceStr). You have \(openPositions) open positions with a \(pnlDirection) of $\(pnlStr).",
                "Portfolio status: $\(balanceStr) balance, \(openPositions) active trades, current \(pnlDirection) of $\(pnlStr).",
                "Account summary: Balance $\(balanceStr), \(openPositions) positions, \(pnlDirection) of $\(pnlStr)."
            ]
        case .energetic:
            if pnl >= 0 {
                return [
                    "AWESOME! You've got $\(balanceStr) in your account with $\(pnlStr) in PROFITS! \(openPositions) trades are CRUSHING IT!",
                    "BOOM! $\(balanceStr) balance and you're UP $\(pnlStr)! Those \(openPositions) trades are LEGENDARY!",
                    "YES! $\(balanceStr) strong with $\(pnlStr) PROFITS! Your \(openPositions) positions are ON FIRE!"
                ]
            } else {
                return [
                    "You've got $\(balanceStr) balance. Don't worry about the $\(pnlStr) drawdown - COMEBACKS ARE LEGENDARY!",
                    "Balance is $\(balanceStr). That $\(pnlStr) loss is just tuition! You're learning and growing!",
                    "$\(balanceStr) in the account. The $\(pnlStr) loss is temporary - CHAMPIONS BOUNCE BACK!"
                ]
            }
        case .peaceful:
            return [
                "Your balance flows peacefully at $\(balanceStr). With \(openPositions) positions and $\(pnlStr) \(pnlDirection), all is as it should be.",
                "Balance of $\(balanceStr) reflects your journey. \(openPositions) trades with $\(pnlStr) \(pnlDirection) - trust the process.",
                "Harmony in your $\(balanceStr) balance. \(openPositions) positions show $\(pnlStr) \(pnlDirection) - stay centered."
            ]
        case .commanding:
            return [
                "BALANCE REPORT: $\(balanceStr)! \(openPositions) ACTIVE POSITIONS! \(pnlDirection.uppercased()) OF $\(pnlStr)! MISSION STATUS CONFIRMED!",
                "ACCOUNT STATUS: $\(balanceStr) SECURED! \(openPositions) TRADES DEPLOYED! \(pnlDirection.uppercased()): $\(pnlStr)!",
                "FINANCIAL POSITION: $\(balanceStr) LOCKED AND LOADED! \(openPositions) POSITIONS ACTIVE! \(pnlDirection.uppercased()): $\(pnlStr)!"
            ]
        }
    }
    
    private func generateAnalysisResponse() -> [String] {
        switch voicePersonality.responseStyle {
        case .formal:
            return [
                "Market analysis indicates strong bullish momentum on Gold. Entry opportunities detected at current levels.",
                "Technical analysis shows favorable conditions. Multiple timeframe alignment suggests high probability setup.",
                "Current market structure analysis complete. Institutional levels identified for optimal entry."
            ]
        case .energetic:
            return [
                "OH WOW! The charts are looking INCREDIBLE! This setup is absolutely LEGENDARY!",
                "DUDE! The analysis is showing MASSIVE potential! This could be the trade of the CENTURY!",
                "HOLY GRAIL SETUP DETECTED! The stars are aligning for something ABSOLUTELY LEGENDARY!"
            ]
        case .peaceful:
            return [
                "The market whispers of opportunity. Price flows with natural rhythm toward value zones.",
                "Charts reveal harmony between buyers and sellers. Patient observation shows the path forward.",
                "Market energy flows peacefully toward equilibrium. The wise trader sees the pattern."
            ]
        case .commanding:
            return [
                "ANALYSIS COMPLETE! TARGETS IDENTIFIED! ENTRY ZONES LOCKED! READY FOR DEPLOYMENT!",
                "MARKET INTELLIGENCE GATHERED! HIGH PROBABILITY SETUP CONFIRMED! MISSION IS A GO!",
                "TACTICAL ANALYSIS FINISHED! ENTRY PARAMETERS SET! AWAITING EXECUTION ORDERS!"
            ]
        }
    }
    
    private func generateBacktestResponse() -> [String] {
        switch voicePersonality.responseStyle {
        case .formal:
            return [
                "Backtesting engine initialized. Historical data analysis commencing with Mark Douglas psychology integration.",
                "Strategy testing protocol activated. Preparing comprehensive performance analysis.",
                "Backtest simulation starting. Historical market replay with advanced analytics enabled."
            ]
        case .energetic:
            return [
                "BACKTEST TIME! Let's see how LEGENDARY your strategy performs! This is going to be EPIC!",
                "YES! Time to CRUSH some historical data! Your strategy is about to get TESTED!",
                "BOOM! Backtesting engine is FIRED UP! Let's make this strategy LEGENDARY!"
            ]
        case .peaceful:
            return [
                "Gently entering the realm of historical wisdom. Your strategy will be tested with mindfulness.",
                "The backtest begins its peaceful journey through market memory. Trust the process.",
                "Historical patterns will reveal their secrets. Patience as we explore your strategy's path."
            ]
        case .commanding:
            return [
                "BACKTEST PROTOCOL INITIATED! HISTORICAL DATA LOCKED AND LOADED! ENGAGING SIMULATION!",
                "STRATEGY TESTING COMMENCING! ALL SYSTEMS GO! PREPARING FOR HISTORICAL DEPLOYMENT!",
                "BACKTEST MISSION LAUNCHED! ANALYZING HISTORICAL PERFORMANCE! STANDBY FOR RESULTS!"
            ]
        }
    }
    
    private func generateBotControlResponse() -> [String] {
        switch voicePersonality.responseStyle {
        case .formal:
            return [
                "AI trading bots are now active. Mark Douglas psychology principles engaged. Monitoring market conditions.",
                "Bot army deployed successfully. 5000+ AI traders now analyzing markets with probabilistic thinking.",
                "Artificial intelligence systems activated. Bots are now trading with disciplined psychology."
            ]
        case .energetic:
            return [
                "THE BOTS ARE AWAKE! 5000+ AI TRADERS ARE READY TO MAKE YOU LEGENDARY!",
                "BOOM! Your bot army is ACTIVATED! They're going to CRUSH the markets!",
                "YES! The AI revolution is HERE! Your bots are going to be ABSOLUTELY LEGENDARY!"
            ]
        case .peaceful:
            return [
                "Your digital trading companions have awakened. They will trade with Zen-like discipline.",
                "The bot collective stirs to life. They will execute trades with calm precision and Mark Douglas wisdom.",
                "AI consciousness activated. Your bots will trade with enlightened patience."
            ]
        case .commanding:
            return [
                "BOT ARMY ACTIVATED! 5000+ AI SOLDIERS DEPLOYED! READY FOR MARKET COMBAT!",
                "ARTIFICIAL INTELLIGENCE UNITS ONLINE! TRADING PROTOCOLS ENGAGED! MISSION READY!",
                "ROBOT BATTALION OPERATIONAL! AI TRADERS LOCKED AND LOADED! EXECUTING ORDERS!"
            ]
        }
    }
    
    private func generateMarketNewsResponse() -> [String] {
        switch voicePersonality.responseStyle {
        case .formal:
            return [
                "Current market news indicates USD strength ahead of Federal Reserve announcement. Gold showing consolidation patterns.",
                "Economic calendar shows high-impact news events scheduled. Market volatility expected during New York session.",
                "Latest market intelligence suggests institutional accumulation in precious metals sector."
            ]
        case .energetic:
            return [
                "BREAKING NEWS! The markets are about to go CRAZY! Fed announcement could make this LEGENDARY!",
                "OH MY GOSH! The news is looking INCREDIBLE for gold! This could be MASSIVE!",
                "HUGE NEWS ALERT! Something BIG is happening! This could be the opportunity of a LIFETIME!"
            ]
        case .peaceful:
            return [
                "Market news flows gently across the trading floor. Fed whispers suggest change in the wind.",
                "Economic currents shift subtly. The wise trader observes these news patterns with detachment.",
                "News events ripple through market consciousness. Stay centered amid the information storm."
            ]
        case .commanding:
            return [
                "NEWS INTELLIGENCE REPORT! FED ANNOUNCEMENT INCOMING! PREPARE FOR MARKET VOLATILITY!",
                "ECONOMIC DATA ALERT! HIGH IMPACT NEWS DETECTED! ALL UNITS STANDBY FOR DEPLOYMENT!",
                "MARKET INTELLIGENCE UPDATE! NEWS EVENTS LOCKED! TACTICAL ADVANTAGE CONFIRMED!"
            ]
        }
    }
    
    private func generatePositionManagementResponse() -> [String] {
        switch voicePersonality.responseStyle {
        case .formal:
            return [
                "Position management protocol activated. Analyzing current trades for optimal exit strategies.",
                "Trade management system engaged. Calculating risk-reward ratios for position adjustments.",
                "Portfolio positions under review. Risk management parameters being optimized."
            ]
        case .energetic:
            return [
                "POSITION MANAGEMENT TIME! Let's LOCK IN those profits and make this LEGENDARY!",
                "YES! Time to manage those trades like a CHAMPION! Profit protection activated!",
                "BOOM! Position management mode ON! Let's secure these LEGENDARY gains!"
            ]
        case .peaceful:
            return [
                "Gently tending to your market garden. Positions will be nurtured with mindful care.",
                "Like a gardener pruning roses, we'll manage positions with patience and wisdom.",
                "Position harmony will be restored. Trust in the natural flow of profit taking."
            ]
        case .commanding:
            return [
                "POSITION MANAGEMENT PROTOCOL ENGAGED! SECURING PROFITS! MINIMIZING RISK EXPOSURE!",
                "TRADE MANAGEMENT SYSTEMS ONLINE! PROFIT EXTRACTION MISSION ACTIVATED!",
                "POSITION CONTROL INITIATED! RISK PARAMETERS ADJUSTED! MISSION PARAMETERS SECURED!"
            ]
        }
    }
    
    private func generateMotivationalResponse() -> [String] {
        switch voicePersonality.responseStyle {
        case .formal:
            return [
                "Success in trading requires discipline, patience, and continuous learning. Your journey toward profitability continues.",
                "Wealth creation through trading demands consistent execution of proven strategies. Stay focused on your goals.",
                "Financial independence is achieved through disciplined trading and proper risk management. You're on the right path."
            ]
        case .energetic:
            return [
                "YOU'RE GOING TO BE ABSOLUTELY LEGENDARY! This is YOUR time to SHINE!",
                "YES! You're destined for GREATNESS! Those profits are coming YOUR way!",
                "BOOM! You're about to become the MOST LEGENDARY trader EVER! I believe in you!",
                "OH MY GOSH! You're going to CRUSH the markets and become RIDICULOUSLY successful!"
            ]
        case .peaceful:
            return [
                "Wealth flows to those who trade with inner peace. Your journey unfolds naturally toward abundance.",
                "Like a river flowing to the ocean, your profits will come with patience and mindfulness.",
                "Trust in your trading journey. Success blooms for those who remain centered and disciplined."
            ]
        case .commanding:
            return [
                "YOU ARE A TRADING WARRIOR! VICTORY IS YOUR DESTINY! DOMINATE THOSE MARKETS!",
                "SOLDIER! YOU HAVE THE TOOLS FOR SUCCESS! NOW GO CONQUER THE FINANCIAL BATTLEFIELD!",
                "CHAMPION! YOUR MISSION IS PROFIT! EXECUTE YOUR STRATEGY WITH MILITARY PRECISION!"
            ]
        }
    }
    
    // MARK: - Text to Speech
    
    private func respondWithVoice(_ text: String) {
        voiceResponse = text
        
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(identifier: voicePersonality.voice) ?? AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5
        utterance.pitchMultiplier = 1.0
        utterance.volume = 1.0
        
        synthesizer.speak(utterance)
    }
    
    // MARK: - Public Interface
    
    func toggleListening() {
        if isListening {
            stopListening()
        } else {
            startListening()
        }
    }
    
    func setVoicePersonality(_ personality: VoicePersonality) {
        voicePersonality = personality
    }
    
    func getCommandHistory() -> [VoiceCommandHistory] {
        return Array(commandHistory.prefix(20))
    }
    
    func clearCommandHistory() {
        commandHistory.removeAll()
    }
}

// MARK: - Supporting Data Structures

struct VoiceCommand {
    let trigger: [String]
    let action: VoiceAction
    let examples: [String]
    let description: String
}

enum VoiceAction: String, CaseIterable {
    case trade = "TRADE"
    case showPortfolio = "PORTFOLIO"
    case analyze = "ANALYZE"
    case backtest = "BACKTEST"
    case botControl = "BOT_CONTROL"
    case marketNews = "MARKET_NEWS"
    case positionManagement = "POSITION_MANAGEMENT"
    case help = "HELP"
    case motivational = "MOTIVATIONAL"
}

struct VoiceCommandHistory: Identifiable {
    let id: String
    let timestamp: Date
    let command: String
    let action: VoiceAction
    let response: String
    let success: Bool
}

#Preview {
    VStack {
        Text("🗣️ Voice Command Service")
            .font(.title)
            .padding()
        
        Text("\"Hey GOLDEX, make me rich!\"")
            .font(.headline)
            .foregroundColor(.green)
    }
}