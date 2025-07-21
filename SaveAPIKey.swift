//
//  SaveAPIKey.swift
//  Planet ProTrader
//
//  Created by AI Assistant on 1/25/25.
//

import Foundation

// MARK: - Save Anthropic API Key to Keychain
func saveAnthropicKey() {
    let keychain = KeychainService()
    let anthropicKey = "SECURE_API_KEY_FROM_KEYCHAIN"
    
    keychain.save(key: "anthropic_api_key", value: anthropicKey)
    print("✅ Anthropic API key saved successfully!")
}

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
}