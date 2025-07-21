//
//  APIConfiguration.swift
//  GOLDEX AI
//
//  Created by Goldex AI on 7/19/25.
//

import Foundation
import SwiftUI

// MARK: - API Configuration Manager
@MainActor
class APIConfiguration: ObservableObject {
    @Published var openAIKey: String = ""
    @Published var anthropicKey: String = ""
    @Published var supabaseKey: String = ""
    @Published var supabaseURL: String = ""
    @Published var coinexxAPIKey: String = ""
    @Published var telegramBotToken: String = ""
    @Published var isConfigured: Bool = false
    
    private let keychain = KeychainService()
    
    init() {
        loadConfiguration()
    }
    
    // MARK: - Load Configuration
    private func loadConfiguration() {
        openAIKey = keychain.load(key: "openai_api_key") ?? ""
        anthropicKey = keychain.load(key: "anthropic_api_key") ?? ""
        supabaseKey = keychain.load(key: "supabase_api_key") ?? ""
        supabaseURL = keychain.load(key: "supabase_url") ?? ""
        coinexxAPIKey = keychain.load(key: "coinexx_api_key") ?? ""
        telegramBotToken = keychain.load(key: "telegram_bot_token") ?? ""
        
        updateConfigurationStatus()
    }
    
    // MARK: - Save Configuration
    func saveConfiguration() {
        keychain.save(key: "openai_api_key", value: openAIKey)
        keychain.save(key: "anthropic_api_key", value: anthropicKey)
        keychain.save(key: "supabase_api_key", value: supabaseKey)
        keychain.save(key: "supabase_url", value: supabaseURL)
        keychain.save(key: "coinexx_api_key", value: coinexxAPIKey)
        keychain.save(key: "telegram_bot_token", value: telegramBotToken)
        
        // Also save to UserDefaults for GPTIntegration compatibility
        let apiKeys: [String: String] = [
            "openai_key": openAIKey,
            "anthropic_key": anthropicKey,
            "supabase_key": supabaseKey,
            "supabase_url": supabaseURL,
            "coinexx_key": coinexxAPIKey,
            "telegram_token": telegramBotToken
        ]
        
        if let data = try? JSONEncoder().encode(apiKeys) {
            UserDefaults.standard.set(data, forKey: "GOLDEX_API_KEYS")
        }
        
        updateConfigurationStatus()
    }
    
    // MARK: - Clear Configuration
    func clearConfiguration() {
        openAIKey = ""
        anthropicKey = ""
        supabaseKey = ""
        supabaseURL = ""
        coinexxAPIKey = ""
        telegramBotToken = ""
        
        keychain.delete(key: "openai_api_key")
        keychain.delete(key: "anthropic_api_key")
        keychain.delete(key: "supabase_api_key")
        keychain.delete(key: "supabase_url")
        keychain.delete(key: "coinexx_api_key")
        keychain.delete(key: "telegram_bot_token")
        
        UserDefaults.standard.removeObject(forKey: "GOLDEX_API_KEYS")
        
        updateConfigurationStatus()
    }
    
    // MARK: - Validation
    private func updateConfigurationStatus() {
        isConfigured = !openAIKey.isEmpty || !anthropicKey.isEmpty || !supabaseKey.isEmpty || !coinexxAPIKey.isEmpty
    }
    
    func validateOpenAIKey() -> Bool {
        return openAIKey.hasPrefix("sk-") && openAIKey.count > 20
    }
    
    func validateAnthropicKey() -> Bool {
        return anthropicKey.hasPrefix("sk-ant-") && anthropicKey.count > 20
    }
    
    func validateSupabaseConfig() -> Bool {
        return !supabaseKey.isEmpty && !supabaseURL.isEmpty && supabaseURL.contains("supabase.co")
    }
    
    func validateCoinexxKey() -> Bool {
        return !coinexxAPIKey.isEmpty && coinexxAPIKey.count > 10
    }
    
    // MARK: - Test Connections
    func testOpenAIConnection() async -> Bool {
        guard validateOpenAIKey() else { return false }
        
        // Test with a simple API call
        let url = URL(string: "https://api.openai.com/v1/models")!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(openAIKey)", forHTTPHeaderField: "Authorization")
        
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            return (response as? HTTPURLResponse)?.statusCode == 200
        } catch {
            return false
        }
    }
    
    func testAnthropicConnection() async -> Bool {
        guard validateAnthropicKey() else { return false }
        
        let url = URL(string: "https://api.anthropic.com/v1/messages")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(anthropicKey, forHTTPHeaderField: "x-api-key")
        request.setValue("2023-06-01", forHTTPHeaderField: "anthropic-version")
        
        let testMessage: [String: Any] = [
            "model": "claude-3-5-sonnet-20241022",
            "max_tokens": 10,
            "messages": [
                ["role": "user", "content": "Test"]
            ]
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: testMessage)
            let (_, response) = try await URLSession.shared.data(for: request)
            return (response as? HTTPURLResponse)?.statusCode == 200
        } catch {
            return false
        }
    }
    
    func testSupabaseConnection() async -> Bool {
        guard validateSupabaseConfig() else { return false }
        
        let url = URL(string: "\(supabaseURL)/rest/v1/")!
        var request = URLRequest(url: url)
        request.setValue(supabaseKey, forHTTPHeaderField: "apikey")
        
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            return (response as? HTTPURLResponse)?.statusCode == 200
        } catch {
            return false
        }
    }
}

// MARK: - Keychain Service
class KeychainService {
    func save(key: String, value: String) {
        let data = value.data(using: .utf8)!
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        
        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }
    
    func load(key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess,
              let data = result as? Data,
              let string = String(data: data, encoding: .utf8) else {
            return nil
        }
        
        return string
    }
    
    func delete(key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        
        SecItemDelete(query as CFDictionary)
    }
}

// MARK: - API Configuration View
struct APIConfigurationView: View {
    @StateObject private var config = APIConfiguration()
    @State private var showingSensitiveInfo = false
    @State private var testResults: [String: Bool] = [:]
    @State private var isTestingConnections = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    headerSection
                    
                    // OpenAI Configuration
                    openAISection
                    
                    // Anthropic Configuration
                    anthropicSection
                    
                    // Supabase Configuration
                    supabaseSection
                    
                    // Coinexx Configuration
                    coinexxSection
                    
                    // Telegram Configuration
                    telegramSection
                    
                    // Test Connections
                    testConnectionsSection
                    
                    // Save/Clear Actions
                    actionsSection
                }
                .padding(.horizontal, 20)
            }
            .background(DesignSystem.backgroundGradient)
            .navigationTitle("API Configuration")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(DesignSystem.primaryGold)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        config.saveConfiguration()
                        dismiss()
                    }
                    .foregroundColor(DesignSystem.primaryGold)
                    .fontWeight(.semibold)
                }
            }
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 16) {
            Image(systemName: "key.fill")
                .font(.system(size: 48, weight: .bold))
                .foregroundStyle(
                    LinearGradient(
                        colors: [DesignSystem.primaryGold, DesignSystem.accentOrange],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            VStack(spacing: 8) {
                Text("🔐 API CONFIGURATION")
                    .font(DesignSystem.typography.headlineLarge)
                    .foregroundColor(DesignSystem.primaryText)
                
                Text("Configure your API keys for full ProTrader Army functionality")
                    .font(DesignSystem.typography.bodyMedium)
                    .foregroundColor(DesignSystem.secondaryText)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.top, 20)
    }
    
    // MARK: - OpenAI Section
    private var openAISection: some View {
        ConfigurationSection(
            title: "OpenAI GPT-4",
            description: "Required for GPT-4 Oracle trading assistant",
            icon: "brain.head.profile",
            isValid: config.validateOpenAIKey()
        ) {
            SecureField("sk-...", text: $config.openAIKey)
                .textFieldStyle(.roundedBorder)
                .font(.system(.body, design: .monospaced))
        }
    }
    
    // MARK: - Anthropic Section
    private var anthropicSection: some View {
        ConfigurationSection(
            title: "Anthropic Claude Opus",
            description: "Required for Opus Hyper AI autodebug system",
            icon: "cpu.fill",
            isValid: config.validateAnthropicKey()
        ) {
            SecureField("sk-ant-...", text: $config.anthropicKey)
                .textFieldStyle(.roundedBorder)
                .font(.system(.body, design: .monospaced))
        }
    }
    
    // MARK: - Supabase Section
    private var supabaseSection: some View {
        ConfigurationSection(
            title: "Supabase Database",
            description: "For storing bot training data and performance metrics",
            icon: "cylinder.fill",
            isValid: config.validateSupabaseConfig()
        ) {
            VStack(spacing: 12) {
                TextField("Supabase URL", text: $config.supabaseURL)
                    .textFieldStyle(.roundedBorder)
                    .autocapitalization(.none)
                    .keyboardType(.URL)
                
                SecureField("Supabase API Key", text: $config.supabaseKey)
                    .textFieldStyle(.roundedBorder)
                    .font(.system(.body, design: .monospaced))
            }
        }
    }
    
    // MARK: - Coinexx Section
    private var coinexxSection: some View {
        ConfigurationSection(
            title: "Coinexx Trading",
            description: "For live trading integration",
            icon: "chart.xyaxis.line",
            isValid: config.validateCoinexxKey()
        ) {
            SecureField("Coinexx API Key", text: $config.coinexxAPIKey)
                .textFieldStyle(.roundedBorder)
                .font(.system(.body, design: .monospaced))
        }
    }
    
    // MARK: - Telegram Section
    private var telegramSection: some View {
        ConfigurationSection(
            title: "Telegram Notifications",
            description: "Optional: Get trading alerts via Telegram",
            icon: "paperplane.fill",
            isValid: !config.telegramBotToken.isEmpty
        ) {
            TextField("Bot Token", text: $config.telegramBotToken)
                .textFieldStyle(.roundedBorder)
                .font(.system(.body, design: .monospaced))
        }
    }
    
    // MARK: - Test Connections Section
    private var testConnectionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("🧪 TEST CONNECTIONS")
                .font(DesignSystem.typography.headlineMedium)
                .foregroundColor(DesignSystem.primaryText)
            
            VStack(spacing: 12) {
                TestConnectionRow(
                    service: "OpenAI GPT-4",
                    isValid: config.validateOpenAIKey(),
                    testResult: testResults["openai"],
                    action: {
                        await testOpenAI()
                    }
                )
                
                TestConnectionRow(
                    service: "Anthropic Claude Opus",
                    isValid: config.validateAnthropicKey(),
                    testResult: testResults["anthropic"],
                    action: {
                        await testAnthropic()
                    }
                )
                
                TestConnectionRow(
                    service: "Supabase",
                    isValid: config.validateSupabaseConfig(),
                    testResult: testResults["supabase"],
                    action: {
                        await testSupabase()
                    }
                )
            }
            .disabled(isTestingConnections)
        }
    }
    
    // MARK: - Actions Section
    private var actionsSection: some View {
        VStack(spacing: 12) {
            Button(action: {
                config.saveConfiguration()
            }) {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                    Text("Save Configuration")
                }
                .font(DesignSystem.typography.bodyMedium)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(
                    LinearGradient(
                        colors: [DesignSystem.primaryGold, DesignSystem.accentOrange],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(12)
            }
            
            Button(action: {
                config.clearConfiguration()
            }) {
                HStack {
                    Image(systemName: "trash")
                    Text("Clear All Keys")
                }
                .font(DesignSystem.typography.bodyMedium)
                .foregroundColor(.red)
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(Color.red.opacity(0.1))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.red.opacity(0.3), lineWidth: 1)
                )
            }
        }
    }
    
    // MARK: - Helper Functions
    private func testOpenAI() async {
        isTestingConnections = true
        testResults["openai"] = await config.testOpenAIConnection()
        isTestingConnections = false
    }
    
    private func testAnthropic() async {
        isTestingConnections = true
        testResults["anthropic"] = await config.testAnthropicConnection()
        isTestingConnections = false
    }
    
    private func testSupabase() async {
        isTestingConnections = true
        testResults["supabase"] = await config.testSupabaseConnection()
        isTestingConnections = false
    }
}

// MARK: - Supporting Views

struct ConfigurationSection<Content: View>: View {
    let title: String
    let description: String
    let icon: String
    let isValid: Bool
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(isValid ? .green : DesignSystem.primaryGold)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(DesignSystem.typography.headlineSmall)
                        .foregroundColor(DesignSystem.primaryText)
                    
                    Text(description)
                        .font(DesignSystem.typography.captionMedium)
                        .foregroundColor(DesignSystem.secondaryText)
                }
                
                Spacer()
                
                if isValid {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                }
            }
            
            content
        }
        .padding(20)
        .background(DesignSystem.cardBackground)
        .cornerRadius(16)
    }
}

struct TestConnectionRow: View {
    let service: String
    let isValid: Bool
    let testResult: Bool?
    let action: () async -> Void
    
    var body: some View {
        HStack {
            Text(service)
                .font(DesignSystem.typography.bodyMedium)
                .foregroundColor(DesignSystem.primaryText)
            
            Spacer()
            
            if let result = testResult {
                Image(systemName: result ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .foregroundColor(result ? .green : .red)
            }
            
            Button("Test") {
                Task {
                    await action()
                }
            }
            .buttonStyle(.bordered)
            .controlSize(.small)
            .tint(DesignSystem.primaryGold)
            .disabled(!isValid)
        }
    }
}

#Preview {
    APIConfigurationView()
}