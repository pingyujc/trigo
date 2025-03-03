//
//  SectionView.swift
//  trigo
//
//  Created by Jonathan Chen on 2/9/25.
//

import Foundation
import SwiftUI

struct SectionView: View {
    let title: String
    let products: [Product]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(products) { product in
                        NavigationLink(destination: ProductDetailView(viewModel: ProductDetailViewModel(product: product))) {
                            ProductCard(product: product)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
} 

#Preview {
	// Create sample products for preview
	let sampleProducts = [
		Product.sampleListing,
		Product.sampleRequest,
		Product.sampleListing
	]
	
	return NavigationView {
		SectionView(title: "Trending Products", products: sampleProducts)
	}
}

