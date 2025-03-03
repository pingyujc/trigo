import SwiftUI

extension Color {
    // Base colors
    static let customBackground = Color(.systemBackground)
    static let customGray = Color(.systemGray6)
    static let customText = Color(.label)
    static let customSecondaryText = Color(.secondaryLabel)
    
    // Theme colors
    static let primaryAccent = Color.blue
    static let secondaryAccent = Color.green
    static let errorColor = Color.red
    static let warningColor = Color.orange
    
    // Background variations
    static let customBackgroundSecondary = Color(.secondarySystemBackground)
    static let customBackgroundTertiary = Color(.tertiarySystemBackground)
    
    // Text variations
    static let customTextSecondary = Color(.secondaryLabel)
    static let customTextTertiary = Color(.tertiaryLabel)
    
    // Custom opacity backgrounds
    static let customOverlay = Color.black.opacity(0.1)
    static let customShadow = Color.black.opacity(0.1)
} 