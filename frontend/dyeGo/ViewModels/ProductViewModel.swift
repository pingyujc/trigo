//
//  ProductViewModel.swift
//  dyeGo
//
//  Created by Jonathan Chen on 2/24/25.
//
import Foundation
import SwiftUI

class ProductViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var listings: [Product] = []
    @Published var requests: [Product] = []

    init() {
        fetchProducts()
    }

    func fetchProducts() {
        // Sample data for now
        products = [
            Product(
                title: "Vintage Leather Jacket",
                price: 199.99,
                description:
                    "Classic brown leather jacket in excellent condition",
                image: "jacket1",
                type: .request
            ),
            Product(
                title: "Looking for Nike Air Max 90",
                price: 150.00,
                description: "Seeking Nike Air Max 90 in size US 10, any color",
                image: "shoes1",
                type: .request
            ),
            Product(
                title: "Denim Jeans",
                price: 89.99,
                description: "New blue denim jeans",
                image: "jeans1",
                type: .request
            ),
            Product(
                title: "Seeking Vintage Camera",
                price: 200.00,
                description: "Looking for any working vintage film cameras",
                image: "camera1",
                category: .electronics,
                type: .request
            ),
            Product(
                title: "Porche 911",
                price: 399.99,
                description: "Cool car.",
                image: "porche911",
                type: .listing
            ),
            Product(
                title: "G Wagon",
                price: 500,
                description: "Huge car.",
                image: "benzG500",
                type: .listing
            ),
            Product(
                title: "Lambo 5000",
                price: 1000,
                description: "Fast car.",
                image: "lambo5000",
                type: .listing
            ),
            Product(
                title: "McLaren P1",
                price: 1999,
                description: "Expensive car.",
                image: "mclarenP1",
                type: .listing
            ),
        ]

        // Filter products into listings and requests
        filterProducts()
    }

    private func filterProducts() {
        listings = products.filter { $0.type == .listing }
        requests = products.filter { $0.type == .request }
    }

    // Helper methods for different views
    func getListings() -> [Product] {
        return listings
    }

    func getRequests() -> [Product] {
        return requests
    }

    func getTrendingProducts(limit: Int = 10) -> [Product] {
        // For now, just return all products sorted by view count
        return products.sorted { $0.viewCount > $1.viewCount }.prefix(limit).map
        { $0 }
    }

    // Add new product
    func addProduct(_ product: Product) {
        products.append(product)
        filterProducts()
        print("Products count: \(products.count)")
        print("Listings count: \(listings.count)")
        print("Requests count: \(requests.count)")
    }

    func createListing(title: String, price: Double, description: String, image: String, category: Category = .clothing, country: Country = .unitedStates) {
        let newListing = Product(
            title: title,
            price: price,
            description: description,
            image: image,
            country: country,
            category: category,
            type: .listing
        )
        addProduct(newListing)
    }
    
    func createRequest(title: String, price: Double, description: String, image: String, category: Category = .clothing, country: Country = .unitedStates) {
        let newRequest = Product(
            title: title,
            price: price,
            description: description,
            image: image,
            country: country,
            category: category,
            type: .request
        )
        addProduct(newRequest)
    }
}
