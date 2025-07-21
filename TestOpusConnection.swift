//
//  TestOpusConnection.swift
//  Planet ProTrader - Standalone Opus Test
//
//  Created by AI Assistant on 1/25/25.
//

import Foundation

print("🤖 OPUS API KEY SETUP & CONNECTION TEST")
print("=====================================")

// Save API key to keychain
let keychain = KeychainService()
let apiKey = "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"

keychain.save(key: "anthropic_api_key", value: apiKey)
print("✅ API Key saved to keychain!")

// Test the connection
print("🚀 Testing Opus API connection...")

guard let url = URL(string: "https://api.anthropic.com/v1/messages") else {
    print("❌ Invalid URL")
    exit(1)
}

var request = URLRequest(url: url)
request.httpMethod = "POST"
request.setValue("application/json", forHTTPHeaderField: "Content-Type")
request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
request.setValue("2023-06-01", forHTTPHeaderField: "anthropic-version")

let testMessage: [String: Any] = [
    "model": "claude-3-5-sonnet-20241022",
    "max_tokens": 50,
    "messages": [
        [
            "role": "user", 
            "content": "Say 'Claude is ready for Planet ProTrader autodebug!' in 10 words or less."
        ]
    ]
]

do {
    request.httpBody = try JSONSerialization.data(withJSONObject: testMessage)
    
    let semaphore = DispatchSemaphore(value: 0)
    var testResult = "❌ No response"
    
    URLSession.shared.dataTask(with: request) { data, response, error in
        defer { semaphore.signal() }
        
        if let error = error {
            testResult = "❌ Connection Error: \(error.localizedDescription)"
            return
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            testResult = "❌ Invalid response"
            return
        }
        
        print("📡 HTTP Status: \(httpResponse.statusCode)")
        
        if httpResponse.statusCode == 200, let data = data {
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let content = json["content"] as? [[String: Any]],
                   let firstContent = content.first,
                   let text = firstContent["text"] as? String {
                    testResult = "🎉 OPUS RESPONSE: \(text)\n✅ Opus API is ACTIVE and ready!"
                } else {
                    testResult = "❌ Failed to parse response"
                }
            } catch {
                testResult = "❌ JSON parsing error: \(error.localizedDescription)"
            }
        } else if let data = data, let errorData = String(data: data, encoding: .utf8) {
            testResult = "❌ API Error (\(httpResponse.statusCode)): \(errorData)"
        } else {
            testResult = "❌ API Error: \(httpResponse.statusCode)"
        }
    }.resume()
    
    semaphore.wait()
    print(testResult)
    
} catch {
    print("❌ Request setup error: \(error.localizedDescription)")
}

print("\n🚀 READY TO UNLEASH OPUS POWER IN YOUR APP!")

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