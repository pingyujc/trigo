//
//  Product.swift
//  dyeGo
//
//  Created by Jonathan Chen on 2/9/25.
//

import Foundation
// identifiable makes it able to use ID
// codable is for fireBase and api in the future

enum ProductType: String, Codable {
    case listing    // From sellers offering items
    case request    // From buyers seeking items
}

struct Product: Identifiable, Codable {
    let id: String
    let title: String
    let description: String
    let category: Category
    let country: Country
    var image: String
    
    // Statistics
    var viewCount: Int
    var favoriteCount: Int
    
    // Market Data
    var listings: [Listing]
    var requests: [Request]
    
    var lowestListingPrice: Double? {
        listings.filter { $0.isActive }.map { $0.price }.min()
    }
    
    var highestRequestPrice: Double? {
        requests.filter { $0.isActive }.map { $0.maxBudget }.max()
    }
    
}

struct Listing: Identifiable, Codable {
    let id: String
    let productId: String
    let sellerId: String
    let price: Double
    let condition: ItemCondition
    let createdAt: Date
    var isActive: Bool
    
    // Additional details
    var notes: String?
}

struct Request: Identifiable, Codable {
    let id: String
    let productId: String
    let buyerId: String
    let maxBudget: Double
    let createdAt: Date
    var isActive: Bool
    
    // Additional details
    var notes: String?
//    var urgencyLevel: UrgencyLevel
}

enum ItemCondition: String, Codable, CaseIterable {
    case new = "New"
    case likeNew = "Like New"
    case good = "Good"
    case fair = "Fair"
    
    var description: String {
        rawValue
    }
}

// Add preview data helper
extension Product {
    static var sampleListing: Product {
        Product(
            id: "sample-listing-1",
            title: "Sample Listing",
            description: "This is a sample product listing",
            category: .electronics,
            country: .unitedStates,
            image: "porche911",
            viewCount: 100,
            favoriteCount: 25,
            listings: [
                Listing(
                    id: "listing-1",
                    productId: "sample-listing-1",
                    sellerId: "seller-123",
                    price: 199.99,
                    condition: .new,
                    createdAt: Date(),
                    isActive: true
                )
            ],
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
            image: "camera-image",
            viewCount: 50,
            favoriteCount: 10,
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
