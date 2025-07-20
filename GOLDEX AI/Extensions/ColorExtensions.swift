import SwiftUI

extension Color {
    static let silver = Color(red: 0.753, green: 0.753, blue: 0.753)
    static let tan = Color(red: 0.824, green: 0.706, blue: 0.549)
    static let gold = Color(red: 1.0, green: 0.843, blue: 0.0)
    static let bronze = Color(red: 0.804, green: 0.498, blue: 0.196)
    
    // Professional color palette
    static let primaryGold = Color(red: 0.918, green: 0.722, blue: 0.224)
    static let darkGold = Color(red: 0.804, green: 0.580, blue: 0.078)
    static let lightGold = Color(red: 0.988, green: 0.847, blue: 0.427)
    
    static let deepBlue = Color(red: 0.086, green: 0.243, blue: 0.537)
    static let lightBlue = Color(red: 0.427, green: 0.643, blue: 0.867)
    
    static let darkGreen = Color(red: 0.133, green: 0.545, blue: 0.133)
    static let lightGreen = Color(red: 0.565, green: 0.933, blue: 0.565)
    
    static let darkRed = Color(red: 0.545, green: 0.000, blue: 0.000)
    static let lightRed = Color(red: 1.000, green: 0.412, blue: 0.412)
}

// MARK: - Gradient Extensions
extension Color {
    static let backgroundGradient = LinearGradient(
        colors: [
            Color(.systemBackground),
            Color(.systemBackground).opacity(0.95)
        ],
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let goldGradient = LinearGradient(
        colors: [Color.primaryGold, Color.darkGold],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let silverGradient = LinearGradient(
        colors: [Color.silver, Color.white, Color.silver],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let successGradient = LinearGradient(
        colors: [Color.lightGreen, Color.darkGreen],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let errorGradient = LinearGradient(
        colors: [Color.lightRed, Color.darkRed],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}