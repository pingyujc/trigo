import Foundation
import SwiftUI

// Import ProductError from our app module
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
    
    /// Refreshes the product data from the service
    func refreshProduct() async throws {
        guard let productId = product.id else {
            throw ProductError.invalidData
        }
        
        isLoading = true
        defer { isLoading = false }
        
        product = try await productService.getProduct(id: productId)
    }
} 
