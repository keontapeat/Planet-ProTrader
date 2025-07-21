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
    let anthropicKey = "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"
    
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