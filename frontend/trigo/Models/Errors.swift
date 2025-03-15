import Foundation

enum ProductError: LocalizedError {
    case notFound
    case invalidData
    
    var errorDescription: String? {
        switch self {
        case .notFound:
            return "Product not found"
        case .invalidData:
            return "Invalid product data"
        }
    }
} 