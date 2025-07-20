struct HomeView: View {
    @StateObject private var walletManager = WalletManager()
    @StateObject private var opusManager = OpusAutodebugService()
    @State private var showingBotCreation = false
    @State private var selectedTimeframe: TimeFrame = .day
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Existing content...
                    
                    // ADD OPUS STATUS CARD
                    opusStatusCard
                    
                    // Your existing cards...
                    portfolioOverviewCard
                    quickStatsGrid
                    topPerformingBotsSection
                    recentActivitySection
                }
                .padding()
            }
            .navigationTitle("GOLDEX AI")
            .navigationBarTitleDisplayMode(.large)
        }
        .onAppear {
            loadPortfolioData()
            // Start Opus if not already running
            if !opusManager.isActive {
                opusManager.unleashOpusPower()
            }
        }
    }
    
    // ADD OPUS STATUS CARD
    private var opusStatusCard: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "brain.head.profile.fill")
                    .foregroundColor(DesignSystem.primaryGold)
                    .font(.title2)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("OPUS AI AUTOPILOT")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(DesignSystem.primaryGold)
                    
                    Text(opusManager.isActive ? "🧠 Analyzing & Optimizing..." : "Ready to unleash")
                        .font(.caption)
                        .foregroundColor(opusManager.isActive ? .green : .secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Fixes: \(opusManager.errorsFixed)")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                    
                    Text("Speed: +\(Int(opusManager.performanceGains))%")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                }
            }
            
            if opusManager.isActive {
                HStack {
                    Text("Status: \(opusManager.currentStatus)")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    if !opusManager.recentFixes.isEmpty {
                        Text("Latest: \(opusManager.recentFixes.last?.improvement ?? "")")
                            .font(.caption2)
                            .foregroundColor(.blue)
                            .lineLimit(1)
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(DesignSystem.primaryGold.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(DesignSystem.primaryGold.opacity(0.3), lineWidth: 1)
                )
        )
        .onTapGesture {
            if !opusManager.isActive {
                opusManager.unleashOpusPower()
            }
        }
    }