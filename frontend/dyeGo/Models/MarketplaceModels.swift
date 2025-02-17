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

struct User: Identifiable {
    let id: String
    var name: String
    var email: String
    var isSeller: Bool
    var rating: Double?
    // Add more properties as needed
}

enum Category: String, Codable, CaseIterable {
    case clothing = "Clothing"
    case electronics = "Electronics"
    case home = "Home"
    case sports = "Sports"
    
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

enum SortOption: CaseIterable {
    case recent, priceAsc, priceDesc, popular
    
    var displayName: String {
        switch self {
        case .recent: return "Most Recent"
        case .priceAsc: return "Price: Low to High"
        case .priceDesc: return "Price: High to Low"
        case .popular: return "Most Popular"
        }
    }
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
