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
    private let authService: AuthService
    
    // Remove @MainActor isolation from init
    nonisolated init(productService: ProductService = ProductService.shared, authService: AuthService = AuthService.shared) {
        self.productService = productService
        self.authService = authService
    }
    
    // Add a separate setup method for async work
    func setup() async {
        print("Starting ProductViewModel setup")
        do {
            try await fetchProducts()
            print("ProductViewModel setup completed successfully")
        } catch {
            print("ProductViewModel setup failed: \(error)")
            self.error = error
        }
    }
    
    // Add this new method
    func createProduct(_ product: Product) async throws {
        isLoading = true
        defer { isLoading = false }
        
        print("Creating new product: \(product.title)")
        
        // Create a new product with default values
        var newProduct = product
        newProduct.viewCount = 0
        newProduct.favoriteCount = 0
        newProduct.listings = []
        newProduct.requests = []
        
        do {
            try await productService.createProduct(newProduct)
            print("Product created successfully")
            // Refresh the products list after creating
            try await fetchProducts()
        } catch {
            print("Error creating product: \(error)")
            self.error = error
            throw error
        }
    }
    
    // Main fetch function
    func fetchProducts() async throws {
        print("Fetching products with filters - category: \(String(describing: selectedCategory)), country: \(String(describing: selectedCountry))")
        isLoading = true
        defer { isLoading = false }
        
        do {
            products = try await productService.fetchProducts(
                category: selectedCategory,
                country: selectedCountry,
                sortBy: sortOption
            )
            print("Successfully fetched \(products.count) products")
            error = nil
        } catch {
            print("Error fetching products: \(error)")
            self.error = error
            throw error
        }
    }
    
    // Apply filters and refresh
    func applyFilters(
        category: Category? = nil,
        country: Country? = nil
    ) async {
        print("Applying filters - category: \(String(describing: category)), country: \(String(describing: country))")
        self.selectedCategory = category
        self.selectedCountry = country
        do {
            try await fetchProducts()
            print("Filters applied successfully")
        } catch {
            print("Error applying filters: \(error)")
            self.error = error
        }
    }
    
    // Clear all filters
    func clearFilters() async {
        print("Clearing all filters")
        selectedCategory = nil
        selectedCountry = nil
        sortOption = .recent
        do {
            try await fetchProducts()
            print("Filters cleared successfully")
        } catch {
            print("Error clearing filters: \(error)")
            self.error = error
        }
    }
    
    // Search products
    func searchProducts(query: String) async {
        print("Searching products with query: \(query)")
        isLoading = true
        defer { isLoading = false }
        
        do {
            products = try await productService.searchProducts(
                query: query,
                category: selectedCategory,
                country: selectedCountry
            )
            print("Search completed - found \(products.count) results")
            error = nil
        } catch {
            print("Error searching products: \(error)")
            self.error = error
        }
    }
    
    // Add these methods to ProductViewModel
    func createListing(productId: String, price: Double, notes: String?) async throws {
        guard let currentUser = authService.currentUser else {
            print("Error: No authenticated user found")
            throw AuthError.userNotFound
        }
        
        print("Creating listing for product: \(productId)")
        isLoading = true
        defer { isLoading = false }
        
        let listing = Listing(
            productId: productId,
            sellerId: currentUser.id!,
            price: price,
            createdAt: Date(),
            isActive: true,
            notes: notes
        )
        
        do {
            try await productService.createListing(listing)
            print("Listing created successfully")
            error = nil
        } catch {
            print("Error creating listing: \(error)")
            self.error = error
            throw error
        }
    }
    
    func createRequest(productId: String, maxPrice: Double, notes: String?) async throws {
        guard let currentUser = authService.currentUser else {
            print("Error: No authenticated user found")
            throw AuthError.userNotFound
        }
        
        print("Creating request for product: \(productId)")
        isLoading = true
        defer { isLoading = false }
        
        let request = Request(
            productId: productId,
            buyerId: currentUser.id!,
            maxBudget: maxPrice,
            createdAt: Date(),
            isActive: true,
            notes: notes
        )
        
        do {
            try await productService.createRequest(request)
            print("Request created successfully")
            error = nil
        } catch {
            print("Error creating request: \(error)")
            self.error = error
            throw error
        }
    }
}

