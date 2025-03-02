import Foundation
import SwiftUI

@MainActor
class ProductDetailViewModel: ObservableObject {
    @Published var product: Product
    @Published var isLoading = false
    @Published var error: Error?
    
    private let productService: ProductService
    
    init(product: Product, productService: ProductService = ProductService.shared) {
        self.product = product
        self.productService = productService
    }
    
    func addListing(_ listing: Listing) async throws {
        isLoading = true
        defer { isLoading = false }
        
        try await productService.addListing(listing, toProduct: product.id)
        try await refreshProduct()
    }
    
    func addRequest(_ request: Request) async throws {
        isLoading = true
        defer { isLoading = false }
        
        try await productService.addRequest(request, toProduct: product.id)
        try await refreshProduct()
    }
    
    private func refreshProduct() async throws {
        product = try await productService.getProduct(id: product.id)
    }
} 
