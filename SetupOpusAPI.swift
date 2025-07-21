//
//  SetupOpusAPI.swift
//  Planet ProTrader
//
//  Created by AI Assistant on 1/25/25.
//

import Foundation

// MARK: - One-time setup script to save your Anthropic API key
// Run this once to save your API key to keychain

func setupAnthropicAPIKey() {
    let keychain = KeychainService()
    
    // Replace this with your actual Anthropic API key
    // It should start with "sk-ant-"
    let anthropicKey = "YOUR_ANTHROPIC_API_KEY_HERE"
    
    // Save to keychain
    keychain.save(key: "anthropic_api_key", value: anthropicKey)
    
    print("✅ Anthropic API key saved to keychain!")
    print("🚀 Ready to unleash Opus power!")
}

// MARK: - Helper class (duplicate for this setup file)
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
}