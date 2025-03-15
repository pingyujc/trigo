import Foundation
import FirebaseFirestore

// this file will be the util file for product stuff?
// fetching, and CRUD
// in the future will need to update this to support firebase or real database
// currently just using in memory storage
class ProductService {
    // Shared instance
    static let shared = ProductService()
    
    // In-memory storage
    // private var products: [Product] = []
    
    private let db = Firestore.firestore()
    private let userCollectionsService = UserCollectionsService.shared
    
    // Private init to enforce singleton pattern
    // private init() {
    //     // Initialize with some mock data
    //     self.products = [
    //         Product(
    //             id: "1",
    //             title: "Vintage Keychain",
    //             description: "Beautiful vintage keychain from Japan",
    //             category: .other,
    //             country: .japan,
    //             image: "keychain-1",
    //             viewCount: 120,
    //             favoriteCount: 45,
    //             listings: [],
    //             requests: []
    //         ),
    //         Product(
    //             id: "2",
    //             title: "Gaming Mouse",
    //             description: "High-performance gaming mouse",
    //             category: .electronics,
    //             country: .taiwan,
    //             image: "mouse-1",
    //             viewCount: 350,
    //             favoriteCount: 89,
    //             listings: [],
    //             requests: []
    //         ),
    //         Product(
    //             id: "3",
    //             title: "Vintage Leather Jacket",
    //             description: "Classic brown leather jacket",
    //             category: .other,
    //             country: .japan,
    //             image: "jacket-1",
    //             viewCount: 120,
    //             favoriteCount: 45,
    //             listings: [],
    //             requests: []
    //         ),
    //         Product(
    //             id: "4",
    //             title: "Nike Air Max 90",
    //             description: "Nike Air Max 90",
    //             category: .other,
    //             country: .japan,
    //             image: "airMax90",
    //             viewCount: 120,
    //             favoriteCount: 45,
    //             listings: [],
    //             requests: []
    //         ),
    //         Product(
    //             id: "5",
    //             title: "Denim Jeans",
    //             description: "Blue denim jeans",
    //             category: .other,
    //             country: .japan,
    //             image: "jean-1",
    //             viewCount: 120,
    //             favoriteCount: 45,
    //             listings: [],
    //             requests: []
    //         ),
    //         Product(
    //             id: "6",
    //             title: "Vintage Camera",
    //             description: "Vintage film cameras",
    //             category: .electronics,
    //             country: .japan,
    //             image: "camera-1",
    //             viewCount: 120,
    //             favoriteCount: 45,
    //             listings: [],
    //             requests: []
    //         ),
    //         Product(
    //             id: "7",
    //             title: "Porche 911",
    //             description: "911 supercar.",
    //             category: .other,
    //             country: .unitedStates,
    //             image: "porche911",
    //             viewCount: 120,
    //             favoriteCount: 45,
    //             listings: [],
    //             requests: []
    //         ),
    //         Product(
    //             id: "8",
    //             title: "Benz G500",
    //             description: "Huge car.",
    //             category: .other,
    //             country: .unitedStates,
    //             image: "benzG500",
    //             viewCount: 120,
    //             favoriteCount: 45,
    //             listings: [],
    //             requests: []
    //         ),
    //         Product(
    //             id: "9",
    //             title: "Lambo 5000",
    //             description: "Fast car.",
    //             category: .other,
    //             country: .unitedStates,
    //             image: "lambo5000",
    //             viewCount: 100,
    //             favoriteCount: 99,
    //             listings: [],
    //             requests: []
    //         ),
    //         Product(
    //             id: "10",
    //             title: "McLaren P1",
    //             description: "Expensive car.",
    //             category: .other,
    //             country: .unitedStates,
    //             image: "mclarenP1",
    //             viewCount: 100,
    //             favoriteCount: 99,
    //             listings: [],
    //             requests: []
    //         ),
    //         // Add more mock products as needed
    //     ]
    // }
    private init() {}
    
    // MARK: - Product Operations
    
    /// Fetch products with optional filters
    func fetchProducts(
        category: Category? = nil,
        country: Country? = nil,
        sortBy: SortOption = .recent
    ) async throws -> [Product] {
        var query = db.collection("products").limit(to: 50)
        
        // Apply filters
        if let category = category {
            query = query.whereField("category", isEqualTo: category.rawValue)
        }
        if let country = country {
            query = query.whereField("country", isEqualTo: country.rawValue)
        }
        
        // Apply sorting
        switch sortBy {
        case .recent:
            query = query.order(by: "createdAt", descending: true)
        case .priceHighToLow:
            query = query.order(by: "lowestListingPrice", descending: true)
        case .priceLowToHigh:
            query = query.order(by: "lowestListingPrice", descending: false)
        case .mostViewed:
            query = query.order(by: "viewCount", descending: true)
        case .mostFavorited:
            query = query.order(by: "favoriteCount", descending: true)
        }
        
        let snapshot = try await query.getDocuments()
        var products = try snapshot.documents.map { try $0.data(as: Product.self) }
        
        // Fetch listings and requests for each product
        for i in products.indices {
            
            // Safely unwrap the product ID
            guard let productId = products[i].id else {
                print("Product ID is nil for product at index \(i)")
                continue // Skip this product if ID is nil
            }
            
            products[i].listings = try await getListings(for: products[i].id!)
            products[i].requests = try await getRequests(for: products[i].id!)
        }
        
        return products
    }
    
    /// Search products by query
    func searchProducts(
        query: String,
        category: Category? = nil,
        country: Country? = nil,
        sortBy: SortOption = .recent
    ) async throws -> [Product] {
        // Note: For proper text search, you might want to use Algolia or Firebase Extensions
        let products = try await fetchProducts(category: category, country: country, sortBy: sortBy)
        let lowercasedQuery = query.lowercased()
        return products.filter { product in
            product.title.lowercased().contains(lowercasedQuery) ||
            product.description.lowercased().contains(lowercasedQuery)
        }
    }
    
    /// Get a single product by ID
    func getProduct(id: String) async throws -> Product {
        // fetch by id
        let docRef = db.collection("products").document(id)
        let document = try await docRef.getDocument()
        
        guard var product = try? document.data(as: Product.self) else {
            throw ProductError.notFound
        }
        
        // Fetch listings and requests
        product.listings = try await getListings(for: id)
        product.requests = try await getRequests(for: id)
        
        return product
    }
    
    /// Create a new product
    func createProduct(_ product: Product) async throws {
        // get the ref of the 'products' in the db
        let productRef = db.collection("products").document()
        
        // Create a copy of the product without an ID (since Firestore will assign one)
        var newProduct = product
        newProduct.id = nil  // Clear the ID so Firestore assigns one
        
        // Encode the product using Firestore.Encoder
        var productData = try Firestore.Encoder().encode(newProduct)
        
        // Add server timestamp and default values
        productData["createdAt"] = FieldValue.serverTimestamp()
        productData["viewCount"] = 0
        productData["favoriteCount"] = 0
        
        // Set null for optional price fields if they don't exist
        if productData["lowestListingPrice"] == nil {
            productData["lowestListingPrice"] = NSNull()
        }
        
        if productData["highestRequestPrice"] == nil {
            productData["highestRequestPrice"] = NSNull()
        }
        
        try await productRef.setData(productData)
    }
    
    /// Update an existing product
    func updateProduct(_ product: Product) async throws {
        guard let id = product.id else {
            throw ProductError.invalidData
        }
        let productRef = db.collection("products").document(id)
        try await productRef.setData(try product.asDictionary(), merge: true)
    }
    
    /// Delete a product
    func deleteProduct(id: String) async throws {
        try await db.collection("products").document(id).delete()
    }
    
    // MARK: - Listing Operations
    
    /// Create a new listing
    func createListing(_ listing: Listing) async throws {
        // 1. Add listing to product's listings collection
        let listingRef = db.collection("products")
            .document(listing.productId)
            .collection("listings")
            .document()
        
        // Create a copy of the listing without an ID
        var newListing = listing
        newListing.id = nil  // Clear the ID so Firestore assigns one
        
        // Encode the listing using Firestore.Encoder
        var listingData = try Firestore.Encoder().encode(newListing)
        listingData["createdAt"] = FieldValue.serverTimestamp()
        
        try await listingRef.setData(listingData)
        
        // 2. Add reference to user's listings collection
        try await userCollectionsService.addListing(
            userId: listing.sellerId,
            productId: listing.productId,
            listingId: listingRef.documentID
        )
        
        // 3. Update product's lowest listing price
        let product = try await getProduct(id: listing.productId)
        if let lowestPrice = product.currentLowestListingPrice {
            try await db.collection("products")
                .document(listing.productId)
                .updateData([
                    "lowestListingPrice": lowestPrice
                ])
        }
    }
    
    /// Get listings for a product
    func getListings(for productId: String) async throws -> [Listing] {
        let snapshot = try await db.collection("products")
            .document(productId)
            .collection("listings")
            .getDocuments()
        
        return try snapshot.documents.map { try $0.data(as: Listing.self) }
    }
    
    /// Remove a listing
    func removeListing(id: String, fromProduct productId: String, sellerId: String) async throws {
        // 1. Remove from product's listings
        try await db.collection("products")
            .document(productId)
            .collection("listings")
            .document(id)
            .delete()
        
        // 2. Remove from user's listings
        try await userCollectionsService.removeListing(userId: sellerId, listingId: id)
        
        // 3. Update product's lowest listing price
        let product = try await getProduct(id: productId)
        if let lowestPrice = product.lowestListingPrice {
            try await db.collection("products")
                .document(productId)
                .updateData(["lowestListingPrice": lowestPrice])
        }
    }
    
    // MARK: - Request Operations
    
    /// Create a new request
    func createRequest(_ request: Request) async throws {
        // 1. Add request to product's requests collection
        let requestRef = db.collection("products")
            .document(request.productId)
            .collection("requests")
            .document()
        
        // Create a copy of the request without an ID
        var newRequest = request
        newRequest.id = nil  // Clear the ID so Firestore assigns one
        
        // Encode the request using Firestore.Encoder
        var requestData = try Firestore.Encoder().encode(newRequest)
        requestData["createdAt"] = FieldValue.serverTimestamp()
        
        try await requestRef.setData(requestData)
        
        // 2. Add reference to user's requests collection
        try await userCollectionsService.addRequest(
            userId: request.buyerId,
            productId: request.productId,
            requestId: requestRef.documentID
        )
        
        // 3. Update product's highest request price
        let product = try await getProduct(id: request.productId)
        if let highestPrice = product.currentHighestRequestPrice {
            try await db.collection("products")
                .document(request.productId)
                .updateData([
                    "highestRequestPrice": highestPrice
                ])
        }
    }
    
    /// Get requests for a product
    func getRequests(for productId: String) async throws -> [Request] {
        let snapshot = try await db.collection("products")
            .document(productId)
            .collection("requests")
            .getDocuments()
        
        return try snapshot.documents.map { try $0.data(as: Request.self) }
    }
    
    /// Remove a request
    func removeRequest(id: String, fromProduct productId: String, buyerId: String) async throws {
        // 1. Remove from product's requests
        try await db.collection("products")
            .document(productId)
            .collection("requests")
            .document(id)
            .delete()
        
        // 2. Remove from user's requests
        try await userCollectionsService.removeRequest(userId: buyerId, requestId: id)
        
        // 3. Update product's highest request price
        let product = try await getProduct(id: productId)
        if let highestPrice = product.highestRequestPrice {
            try await db.collection("products")
                .document(productId)
                .updateData(["highestRequestPrice": highestPrice])
        }
    }
}
