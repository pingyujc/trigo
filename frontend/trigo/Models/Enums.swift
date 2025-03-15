import Foundation

// this is the enum for the app

// Models for the marketplace
struct Item: Identifiable {
    let id: String
    let title: String
    let description: String
    let price: Double
    let imageURL: URL
    let seller: User
    let category: Category
    let country: Country
    var isAvailable: Bool
    // Add more properties as needed
}

enum Category: String, Codable, CaseIterable {
    case electronics = "Electronics"
    case fashion = "Fashion"
    case collectibles = "Collectibles"
    case other = "Other"
    
    var name: String { return self.rawValue }
}

enum Country: String, Codable, CaseIterable {
    case japan = "Japan"
    case korea = "Korea"
    case taiwan = "Taiwan"
    case unitedStates = "United States"
    
    var name: String { return self.rawValue }
}

// Supporting enum
enum SortOption: String, CaseIterable {
    case recent = "Recent"
    case priceHighToLow = "Price: High to Low"
    case priceLowToHigh = "Price: Low to High"
    case mostViewed = "Most Viewed"
    case mostFavorited = "Most Favorited"
    
    var displayName: String { rawValue }
}

enum Filter: CaseIterable {
    case inStock, freeShipping, onSale
    
    var displayName: String {
        switch self {
        case .inStock: return "In Stock"
        case .freeShipping: return "Free Shipping"
        case .onSale: return "On Sale"
        }
    }
} 
