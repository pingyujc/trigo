import Foundation

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
    case clothing = "Clothing"
    case electronics = "Electronics"
    case home = "Home"
    case sports = "Sports"
    case other = "Other"
    
    var name: String { return self.rawValue }
}

enum Country: String, Codable, CaseIterable {
    case taiwan = "Taiwan"
    case japan = "Japan"
    case korea = "Korea"
    case unitedStates = "United States"
    case france = "France"
    
    var name: String { return self.rawValue }
}

// Supporting enum
enum SortOption: String, CaseIterable {
    case recent = "Most Recent"
    case priceHighToLow = "Price: High to Low"
    case priceLowToHigh = "Price: Low to High"
    case mostViewed = "Most Viewed"
    case mostFavorited = "Most Favorited"
    
    var displayName: String { rawValue }
}


enum Filter: CaseIterable {
    case inStock, freeShipping, onSale
    // Add more filters as needed
}

extension Filter {
    var displayName: String {
        switch self {
        case .inStock: return "In Stock"
        case .freeShipping: return "Free Shipping"
        case .onSale: return "On Sale"
        }
    }
} 
