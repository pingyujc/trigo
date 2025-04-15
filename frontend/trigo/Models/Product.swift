//
//  Product.swift
//  trigo
//
//  Created by Jonathan Chen on 2/9/25.
//

import Foundation
import FirebaseFirestore

// identifiable makes it able to use ID
// codable is for fireBase and api in the future

enum ProductType: String, Codable {
    case listing    // From sellers offering items
    case request    // From buyers seeking items
}

struct Product: Identifiable, Codable {
    @DocumentID var id: String?
    var title: String
    var description: String
    var category: Category
    var country: Country
    var imageUrls: [String]  // storing multiple images ulrs

    // Statistics
    var viewCount: Int
    var favoriteCount: Int
    var lowestListingPrice: Double?
    var highestRequestPrice: Double?

    // Market Data
    var listings: [Listing]
    var requests: [Request]

    // Computed properties for local use
    var currentLowestListingPrice: Double? {
        listings.filter { $0.isActive }.min { $0.price < $1.price }?.price
    }

    var currentHighestRequestPrice: Double? {
        requests.filter { $0.isActive }.max { $0.maxBudget < $1.maxBudget }?.maxBudget
    }

    // Regular init
    init(
        id: String? = nil,
        title: String,
        description: String,
        category: Category,
        country: Country,
        imageUrls: [String] = [],  // Updated parameter
        viewCount: Int = 0,
        favoriteCount: Int = 0,
        lowestListingPrice: Double? = nil,
        highestRequestPrice: Double? = nil,
        listings: [Listing] = [],
        requests: [Request] = []
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.category = category
        self.country = country
        self.imageUrls = imageUrls
        self.viewCount = viewCount
        self.favoriteCount = favoriteCount
        self.lowestListingPrice = lowestListingPrice
        self.highestRequestPrice = highestRequestPrice
        self.listings = listings
        self.requests = requests
    }
}

struct Listing: Identifiable, Codable {
    @DocumentID var id: String?
    let productId: String
    let sellerId: String
    let price: Double
    let createdAt: Date
    var isActive: Bool

    // Additional details
    var notes: String?
}

struct Request: Identifiable, Codable {
    @DocumentID var id: String?
    let productId: String
    let buyerId: String
    let maxBudget: Double
    let createdAt: Date
    var isActive: Bool

    // Additional details
    var notes: String?
}

// Add preview data helper
extension Product {
    static var sampleListing: Product {
        Product(
            id: "1",
            title: "Sample Product",
            description: "This is a sample product description",
            category: .electronics,
            country: .japan,
            imageUrls: [],
            viewCount: 100,
            favoriteCount: 50,
            lowestListingPrice: nil,
            highestRequestPrice: nil,
            listings: [],
            requests: []
        )
    }

    static var sampleRequest: Product {
        Product(
            id: "sample-request-1",
            title: "Looking for Vintage Camera",
            description: "Seeking a vintage Polaroid camera in good condition",
            category: .electronics,
            country: .unitedStates,
            imageUrls: [],
            viewCount: 50,
            favoriteCount: 10,
            lowestListingPrice: nil,
            highestRequestPrice: 150.00,
            listings: [],
            requests: [
                Request(
                    id: "request-1",
                    productId: "sample-request-1",
                    buyerId: "buyer-456",
                    maxBudget: 150.00,
                    createdAt: Date(),
                    isActive: true,
                    notes: "Preferably with original packaging"
                )
            ]
        )
    }
}

