import Foundation

enum Constants {
    enum Validation {
        static let minPasswordLength = 8
        static let maxTitleLength = 100
        static let maxDescriptionLength = 1000
    }
    
    enum UI {
        static let cornerRadius: CGFloat = 10
        static let padding: CGFloat = 16
        static let imageSize: CGFloat = 100
    }
    
    enum ErrorMessages {
        static let invalidEmail = "Please enter a valid email address"
        static let passwordTooShort = "Password must be at least 8 characters"
        static let passwordsDontMatch = "Passwords do not match"
    }
} 