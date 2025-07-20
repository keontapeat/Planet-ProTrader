struct MainTabView: View {
    @StateObject private var opusManager = OpusAutodebugService()
    @State private var showingOpusInterface = false
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            
            ProTraderBotView()
                .tabItem {
                    Image(systemName: "robot.fill")
                    Text("ProTrader")
                }
            
            // ADD LIVE TRADING TAB
            LiveBotTradingView()
                .tabItem {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                    Text("Live Trading")
                }
            
            // ADD MARKETX TAB
            BotMarketplaceView()
                .tabItem {
                    Image(systemName: "storefront.fill")
                    Text("MarketX")
                }
            
            FeedMeView()
                .tabItem {
                    Image(systemName: "brain.head.profile.fill")
                    Text("Feed Me")
                }
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
        }
        .overlay(
            // OPUS FLOATING INTERFACE
            VStack {
                HStack {
                    // Opus status indicator
                    Button(action: {
                        showingOpusInterface.toggle()
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: "brain.head.profile.fill")
                                .foregroundColor(opusManager.isActive ? DesignSystem.primaryGold : .secondary)
                                .font(.caption)
                            
                            if opusManager.isActive {
                                Circle()
                                    .fill(Color.green)
                                    .frame(width: 6, height: 6)
                                    .scaleEffect(1.2)
                                    .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: opusManager.isActive)
                            }
                            
                            Text("OPUS")
                                .font(.caption2)
                                .fontWeight(.bold)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color(.systemBackground))
                                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                        )
                    }
                    
                    Spacer()
                }
                
                Spacer()
            }
            .padding()
        )
        .sheet(isPresented: $showingOpusInterface) {
            OpusDebugInterface()
                .presentationDetents([.medium, .large])
        }
        .onAppear {
            // AUTO-START OPUS POWER!
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                opusManager.unleashOpusPower()
            }
        }
    }
}