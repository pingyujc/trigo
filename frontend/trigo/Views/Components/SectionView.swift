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
    
    // Get only unique products based on ID
    private var uniqueProducts: [Product] {
        var uniqueIds = Set<String>()
        return products.filter { product in
            guard let id = product.id else { return false }
            let isNew = uniqueIds.insert(id).inserted
            return isNew
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Section title with horizontal lines on each side
            HStack {
                Spacer()
                Text(title.uppercased())
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.gray)
                    .tracking(1.5)
                Spacer()
            }
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.gray.opacity(0.3))
                    .padding(.horizontal, 20)
            )
            .padding(.top, 8)
            .padding(.bottom, 16)
            
            // Product cards in horizontal scroll with unique products
            if uniqueProducts.isEmpty {
                Text("No products available")
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 20)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(uniqueProducts) { product in
                            NavigationLink(destination: ProductDetailView(viewModel: ProductDetailViewModel(product: product))) {
                                ProductCard(product: product)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
} 

// Subtitle section view for categories like the reference images
struct CategorySectionView: View {
    let title: String
    
    var body: some View {
        HStack {
            Text(title.uppercased())
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.primary)
            
            Spacer()
            
            Text("Shop All")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.gray)
        }
        .padding(.horizontal)
        .padding(.top, 24)
        .padding(.bottom, 8)
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

