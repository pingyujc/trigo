import SwiftUI

extension Color {
    // Base colors
    static let customBackground = Color(.systemBackground)
    static let customSecondaryBackground = Color(.secondarySystemBackground)
    static let customGray = Color(.systemGray6)
    static let customText = Color(.label)
    static let customSecondaryText = Color(.secondaryLabel)
    
    // Theme colors - inspired by the reference images
    static let primaryAccent = Color.black
    static let secondaryAccent = Color(hex: "FF3B30") // Bright red accent color
    static let brandColor = Color.black // Main brand color
    static let navBarBackground = Color.black
    static let navBarText = Color.white
    
    // Price colors
    static let priceColor = Color.black
    static let bidColor = Color(hex: "007AFF") // Blue color for bids
    
    // Background variations
    static let customBackgroundSecondary = Color(.secondarySystemBackground)
    static let customBackgroundTertiary = Color(.tertiarySystemBackground)
    static let cardBackground = Color.white
    
    // Text variations
    static let customTextSecondary = Color(.secondaryLabel)
    static let customTextTertiary = Color(.tertiaryLabel)
    static let categoryText = Color(.secondaryLabel)
    
    // Custom opacity backgrounds
    static let customOverlay = Color.black.opacity(0.05)
    static let customShadow = Color.black.opacity(0.1)
    
    // Utility initializer for hex colors
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
} 