import Foundation

// this file will be the util file for product stuff?
// fetching, and CRUD
// in the future will need to update this to support firebase or real database
// currently just using in memory storage
class ProductService {
    // Shared instance
    static let shared = ProductService()
    
    // In-memory storage
    private var products: [Product] = []
    
    // Private init to enforce singleton pattern
    private init() {
        // Initialize with some mock data
        self.products = [
            Product(
                id: "1",
                title: "Vintage Keychain",
                description: "Beautiful vintage keychain from Japan",
                category: .other,
                country: .japan,
                image: "keychain-1",
                viewCount: 120,
                favoriteCount: 45,
                listings: [],
                requests: []
            ),
            Product(
                id: "2",
                title: "Gaming Mouse",
                description: "High-performance gaming mouse",
                category: .electronics,
                country: .taiwan,
                image: "mouse-1",
                viewCount: 350,
                favoriteCount: 89,
                listings: [],
                requests: []
            ),
            Product(
                id: "3",
                title: "Vintage Leather Jacket",
                description: "Classic brown leather jacket",
                category: .other,
                country: .japan,
                image: "jacket-1",
                viewCount: 120,
                favoriteCount: 45,
                listings: [],
                requests: []
            ),
            Product(
                id: "4",
                title: "Nike Air Max 90",
                description: "Nike Air Max 90",
                category: .other,
                country: .japan,
                image: "airMax90",
                viewCount: 120,
                favoriteCount: 45,
                listings: [],
                requests: []
            ),
            Product(
                id: "5",
                title: "Denim Jeans",
                description: "Blue denim jeans",
                category: .other,
                country: .japan,
                image: "jean-1",
                viewCount: 120,
                favoriteCount: 45,
                listings: [],
                requests: []
            ),
            Product(
                id: "6",
                title: "Vintage Camera",
                description: "Vintage film cameras",
                category: .electronics,
                country: .japan,
                image: "camera-1",
                viewCount: 120,
                favoriteCount: 45,
                listings: [],
                requests: []
            ),
            Product(
                id: "7",
                title: "Porche 911",
                description: "911 supercar.",
                category: .other,
                country: .unitedStates,
                image: "porche911",
                viewCount: 120,
                favoriteCount: 45,
                listings: [],
                requests: []
            ),
            Product(
                id: "8",
                title: "Benz G500",
                description: "Huge car.",
                category: .other,
                country: .unitedStates,
                image: "benzG500",
                viewCount: 120,
                favoriteCount: 45,
                listings: [],
                requests: []
            ),
            Product(
                id: "9",
                title: "Lambo 5000",
                description: "Fast car.",
                category: .other,
                country: .unitedStates,
                image: "lambo5000",
                viewCount: 100,
                favoriteCount: 99,
                listings: [],
                requests: []
            ),
            Product(
                id: "10",
                title: "McLaren P1",
                description: "Expensive car.",
                category: .other,
                country: .unitedStates,
                image: "mclarenP1",
                viewCount: 100,
                favoriteCount: 99,
                listings: [],
                requests: []
            ),
            // Add more mock products as needed
        ]
    }
    
    // MARK: - Product Operations
    
    /// Fetch products with optional filters
    func fetchProducts(
        category: Category? = nil,
        country: Country? = nil,
        sortBy: SortOption = .recent
    ) async throws -> [Product] {
        // Start with all products
        var filteredProducts = products
        
        // Apply category filter if specified
        if let category = category {
            filteredProducts = filteredProducts.filter { $0.category == category }
        }
        
        // Apply country filter if specified
        if let country = country {
            filteredProducts = filteredProducts.filter { $0.country == country }
        }
        
        //        return filteredProducts
        //         Apply sorting
        switch sortBy {
        case .recent:
            return filteredProducts
        case .priceHighToLow:
            return filteredProducts.sorted { ($0.lowestListingPrice ?? 0) > ($1.lowestListingPrice ?? 0) }
        case .priceLowToHigh:
            return filteredProducts.sorted { ($0.lowestListingPrice ?? 0) < ($1.lowestListingPrice ?? 0) }
        case .mostViewed:
            return filteredProducts.sorted { $0.viewCount > $1.viewCount }
        case .mostFavorited:
            return filteredProducts.sorted { $0.favoriteCount > $1.favoriteCount }
        }
    }
    
    /// Search products by query
    func searchProducts(
        query: String,
        category: Category? = nil,
        country: Country? = nil,
        sortBy: SortOption = .recent
    ) async throws -> [Product] {
        let lowercasedQuery = query.lowercased()
        let allProducts = try await fetchProducts(category: category, country: country, sortBy: sortBy)
        return allProducts.filter { product in
            product.title.lowercased().contains(lowercasedQuery) ||
            product.description.lowercased().contains(lowercasedQuery)
        }
    }
    
    /// Get a single product by ID
    func getProduct(id: String) async throws -> Product {
        guard let product = products.first(where: { $0.id == id }) else {
            throw ProductError.notFound
        }
        return product
    }
    
    /// Create a new product
    func createProduct(_ product: Product) async throws {
        products.append(product)
    }
    
    /// Update an existing product
    func updateProduct(_ product: Product) async throws {
        guard let index = products.firstIndex(where: { $0.id == product.id })
        else {
            throw ProductError.notFound
        }
        products[index] = product
    }
    
    /// Delete a product
    func deleteProduct(id: String) async throws {
        guard let index = products.firstIndex(where: { $0.id == id }) else {
            throw ProductError.notFound
        }
        products.remove(at: index)
    }
    
    // MARK: - Listing Operations
    
    /// Add a listing to a product
    func addListing(_ listing: Listing, toProduct productId: String)
    async throws
    {
        guard let index = products.firstIndex(where: { $0.id == productId })
        else {
            throw ProductError.notFound
        }
        products[index].listings.append(listing)
    }
    
    /// Remove a listing from a product
    func removeListing(id: String, fromProduct productId: String) async throws {
        guard
            let productIndex = products.firstIndex(where: { $0.id == productId }
            )
        else {
            throw ProductError.notFound
        }
        products[productIndex].listings.removeAll { $0.id == id }
    }
    
    /// Create a new listing
    func createListing(_ listing: Listing) async throws {
        if let index = products.firstIndex(where: { $0.id == listing.productId }) {
            products[index].listings.append(listing)
        }
    }
    
    // MARK: - Request Operations
    
    /// Add a request to a product
    func addRequest(_ request: Request, toProduct productId: String)
    async throws
    {
        guard let index = products.firstIndex(where: { $0.id == productId })
        else {
            throw ProductError.notFound
        }
        products[index].requests.append(request)
    }
    
    /// Remove a request from a product
    func removeRequest(id: String, fromProduct productId: String) async throws {
        guard
            let productIndex = products.firstIndex(where: { $0.id == productId }
            )
        else {
            throw ProductError.notFound
        }
        products[productIndex].requests.removeAll { $0.id == id }
    }
    
    /// Create a new request
    func createRequest(_ request: Request) async throws {
        if let index = products.firstIndex(where: { $0.id == request.productId }) {
            products[index].requests.append(request)
        }
    }
    
    // MARK: - Errors
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
}
