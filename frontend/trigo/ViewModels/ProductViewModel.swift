//
//  ProductViewModel.swift
//  trigo
//
//  Created by Jonathan Chen on 2/24/25.
//
import Foundation
import SwiftUI

@MainActor
class ProductViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var isLoading = false
    @Published var error: Error?
    @Published var selectedCategory: Category?
    @Published var selectedCountry: Country?
    @Published var sortOption: SortOption = .recent
    
    private let productService: ProductService
    
    // Remove @MainActor isolation from init
    nonisolated init(productService: ProductService = ProductService.shared) {
        self.productService = productService
    }
    
    // Add a separate setup method for async work
    func setup() async {
        await fetchProducts()
    }
    
    // Add this new method
    func createProduct(_ product: Product) async throws {
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await productService.createProduct(product)
            // Refresh the products list after creating
            await fetchProducts()
        } catch {
            self.error = error
            throw error
        }
    }
    
    // Main fetch function
    func fetchProducts() async {
        isLoading = true
        do {
            products = try await productService.fetchProducts(
                category: selectedCategory,
                country: selectedCountry,
                sortBy: sortOption
            )
        } catch {
            self.error = error
        }
        isLoading = false
    }
    
    // Apply filters and refresh
    func applyFilters(
        category: Category? = nil,
        country: Country? = nil
    ) async {
        self.selectedCategory = category
        self.selectedCountry = country
        await fetchProducts()
    }
    
    // Clear all filters
    func clearFilters() async {
        selectedCategory = nil
        selectedCountry = nil
        sortOption = .recent
        await fetchProducts()
    }
    
    // Search products
    func searchProducts(query: String) async {
        isLoading = true
        do {
            products = try await productService.searchProducts(
                query: query,
                category: selectedCategory,
                country: selectedCountry
            )
        } catch {
            self.error = error
        }
        isLoading = false
    }
    
    // Add these methods to ProductViewModel
    func createListing(productId: String, price: Double, notes: String?) async throws {
        isLoading = true
        defer { isLoading = false }
        
        let listing = Listing(
            id: UUID().uuidString,
            productId: productId,
            sellerId: "current-user-id", // You'll want to get this from your auth service
            price: price,
            condition: .new,  // You might want to make this configurable
            createdAt: Date(),
            isActive: true,
            notes: notes
        )
        
        do {
            try await productService.createListing(listing)
            await fetchProducts()  // Refresh products list
        } catch {
            self.error = error
            throw error
        }
    }
    
    func createRequest(productId: String, maxPrice: Double, notes: String?) async throws {
        isLoading = true
        defer { isLoading = false }
        
        let request = Request(
            id: UUID().uuidString,
            productId: productId,
            buyerId: "current-user-id", // You'll want to get this from your auth service
            maxBudget: maxPrice,
            createdAt: Date(),
            isActive: true,
            notes: notes
        )
        
        do {
            try await productService.createRequest(request)
            await fetchProducts()  // Refresh products list
        } catch {
            self.error = error
            throw error
        }
    }
}

