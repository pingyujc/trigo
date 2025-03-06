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
    
    /// Refreshes the product data from the service
    func refreshProduct() async throws {
        isLoading = true
        defer { isLoading = false }
        
        product = try await productService.getProduct(id: product.id)
    }
} 
