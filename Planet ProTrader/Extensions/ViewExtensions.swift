//
//  ViewExtensions.swift
//  Planet ProTrader
//
//  Essential view extensions and fixes
//  Created by Alex AI Assistant
//

import SwiftUI

// MARK: - Material Extensions

extension Material {
    static var ultraThinMaterial: Material {
        if #available(iOS 15.0, *) {
            return .ultraThinMaterial
        } else {
            return .regularMaterial
        }
    }
}

// MARK: - View Extensions for Compatibility

extension View {
    func finalHidden(_ shouldHide: Bool) -> some View {
        opacity(shouldHide ? 0 : 1)
    }
    
    func finalConditional<Content: View>(
        _ condition: Bool,
        @ViewBuilder content: @escaping (Self) -> Content
    ) -> AnyView {
        if condition {
            return AnyView(content(self))
        } else {
            return AnyView(self)
        }
    }
    
    @ViewBuilder
    func backgroundMaterial() -> some View {
        if #available(iOS 15.0, *) {
            self.background(.ultraThinMaterial)
        } else {
            self.background(Color(.systemGray6))
        }
    }
}

// MARK: - Color Extensions

extension Color {
    static let gold = Color.yellow
    static let brown = Color(red: 0.6, green: 0.4, blue: 0.2)
    
    static var quaternary: Color {
        if #available(iOS 17.0, *) {
            return Color(.quaternaryLabel)
        } else {
            return Color(.systemGray4)
        }
    }
}

// MARK: - ShapeStyle Extensions

extension ShapeStyle where Self == Color {
    static var gold: Color {
        return .yellow
    }
}

// MARK: - String Extensions

extension String {
    var finalDoubleValue: Double { Double(self) ?? 0.0 }
    var finalIntValue: Int { Int(self) ?? 0 }
    var finalBoolValue: Bool { self.lowercased() == "true" }
}

extension Optional where Wrapped == String {
    var finalOrEmpty: String { self ?? "" }
}

extension Optional where Wrapped == Double {
    var finalOrZero: Double { self ?? 0.0 }
}

// MARK: - Collection Extensions

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}

// MARK: - DateFormatter Extensions

extension DateFormatter {
    static var timestamp: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }
}

// MARK: - CGPoint Codable Support

extension CGPoint: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let x = try container.decode(CGFloat.self, forKey: .x)
        let y = try container.decode(CGFloat.self, forKey: .y)
        self.init(x: x, y: y)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(x, forKey: .x)
        try container.encode(y, forKey: .y)
    }
    
    private enum CodingKeys: String, CodingKey {
        case x, y
    }
}

// MARK: - Preview Support

extension PreviewProvider {
    static var previews: some View {
        Preview {
            // This will be overridden by actual preview implementations
            Text("Preview Content")
        }
    }
}

// MARK: - Ambiguous Preview Fix

struct Preview<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
    }
}

// MARK: - ObservedObject Binding Fixes

extension ObservedObject.Wrapper {
    subscript<Subject>(dynamicMember keyPath: ReferenceWritableKeyPath<ObjectType, Subject>) -> Binding<Subject> {
        return self.projectedValue[dynamicMember: keyPath]
    }
}

// MARK: - EnvironmentObject Binding Fixes  

extension EnvironmentObject.Wrapper {
    subscript<Subject>(dynamicMember keyPath: ReferenceWritableKeyPath<ObjectType, Subject>) -> Binding<Subject> {
        return self.projectedValue[dynamicMember: keyPath]
    }
}