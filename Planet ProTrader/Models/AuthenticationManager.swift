//
//  AuthenticationManager.swift
//  Planet ProTrader
//
//  Created by AI Assistant on 1/25/25.
//

import SwiftUI
import Foundation
import FirebaseAuth
import FirebaseFirestore

@MainActor
class AuthenticationManager: ObservableObject {
    @Published var user: FirebaseAuth.User?
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var errorMessage = ""
    
    private let db = Firestore.firestore()
    
    init() {
        // Check current authentication state
        if let currentUser = Auth.auth().currentUser {
            self.user = currentUser
            self.isAuthenticated = true
        }
        
        // Listen for authentication state changes
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            Task { @MainActor in
                self?.user = user
                self?.isAuthenticated = user != nil
            }
        }
    }
    
    func signIn(username: String, password: String) async {
        isLoading = true
        errorMessage = ""
        
        do {
            // For demo purposes, we'll use email format
            let email = username.contains("@") ? username : "\(username)@goldex.ai"
            
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            
            // Update user info
            self.user = result.user
            self.isAuthenticated = true
            
            // Update user profile in Firestore
            try await updateUserProfile(user: result.user)
            
        } catch {
            self.errorMessage = "Sign in failed: \(error.localizedDescription)"
            print("Authentication error: \(error)")
        }
        
        isLoading = false
    }
    
    func signUp(username: String, email: String, password: String) async {
        isLoading = true
        errorMessage = ""
        
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            
            // Update display name
            let changeRequest = result.user.createProfileChangeRequest()
            changeRequest.displayName = username
            try await changeRequest.commitChanges()
            
            self.user = result.user
            self.isAuthenticated = true
            
            // Create user profile in Firestore
            try await createUserProfile(user: result.user, username: username)
            
        } catch {
            self.errorMessage = "Sign up failed: \(error.localizedDescription)"
            print("Authentication error: \(error)")
        }
        
        isLoading = false
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            user = nil
            isAuthenticated = false
        } catch {
            errorMessage = "Sign out failed: \(error.localizedDescription)"
        }
    }
    
    func resetPassword(email: String) async {
        isLoading = true
        errorMessage = ""
        
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
        } catch {
            errorMessage = "Password reset failed: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    private func createUserProfile(user: FirebaseAuth.User, username: String) async throws {
        let userData: [String: Any] = [
            "uid": user.uid,
            "username": username,
            "email": user.email ?? "",
            "createdAt": Date(),
            "lastLoginAt": Date(),
            "isProMember": false,
            "totalTrades": 0,
            "winRate": 0.0,
            "totalProfit": 0.0,
            "preferredTimeframes": ["1h", "4h", "1d"],
            "notifications": [
                "tradeSignals": true,
                "accountUpdates": true,
                "marketNews": true
            ]
        ]
        
        try await db.collection("users").document(user.uid).setData(userData)
    }
    
    private func updateUserProfile(user: FirebaseAuth.User) async throws {
        let updateData: [String: Any] = [
            "lastLoginAt": Date(),
            "isOnline": true
        ]
        
        try await db.collection("users").document(user.uid).updateData(updateData)
    }
}

// MARK: - User Profile Extensions
extension AuthenticationManager {
    var currentUserId: String? {
        user?.uid
    }
    
    var currentUserEmail: String? {
        user?.email
    }
    
    var currentUserDisplayName: String? {
        user?.displayName
    }
    
    var isEmailVerified: Bool {
        user?.isEmailVerified ?? false
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthenticationManager())
}