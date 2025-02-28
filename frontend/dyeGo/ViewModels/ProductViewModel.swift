//
//  ProductViewModel.swift
//  dyeGo
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
}

