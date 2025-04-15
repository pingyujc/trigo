//
//  SectionView.swift
//  trigo
//
//  Created by Jonathan Chen on 2/9/25.
//

import Foundation
import SwiftUI

struct ProductCard: View {
    let product: Product
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Image with cached loading - fixed size container to prevent layout shifts
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.customBackgroundSecondary)
                    .frame(width: 160, height: 160)
                
                if let firstImageUrl = product.imageUrls.first, let url = URL(string: firstImageUrl) {
                    CachedAsyncImage(url: url) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 160, height: 160)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    } placeholder: {
                        // Fixed size placeholder to match final image size
                        ProgressView()
                            .scaleEffect(1.0)
                            .frame(width: 160, height: 160)
                    }
                } else {
                    // Fallback for no image - fixed size
                    Image(systemName: "photo")
                        .font(.system(size: 40))
                        .foregroundColor(.gray)
                        .frame(width: 160, height: 160)
                }
            }
            .frame(width: 160, height: 160)
            
            // Fixed height for metadata to prevent shifts
            VStack(alignment: .leading, spacing: 4) {
                // Category label
                Text(product.category.rawValue.capitalized)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.gray)
                
                // Product Title - cleaner with truncation
                Text(product.title)
                    .font(.system(size: 14, weight: .medium))
                    .lineLimit(2)
                    .foregroundColor(.black)
                
                // Price information
                if let price = product.lowestListingPrice {
                    Text("$\(Int(price))")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.priceColor)
                } else if let highestBid = product.highestRequestPrice {
                    Text("$\(Int(highestBid))")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.bidColor)
                } else {
                    // Empty space holder to maintain consistent height
                    Text(" ")
                        .font(.system(size: 14))
                }
            }
            .frame(height: 70, alignment: .top) // Fixed height for metadata
        }
        .frame(width: 160)
        .padding(.bottom, 12)
    }
} 

#Preview {
    ProductCard(product: Product(
        id: "1",
        title: "Sample 911",
        description: "A sample product description",
        category: .other,
        country: .unitedStates,
        imageUrls: ["https://example.com/image.jpg"],
        viewCount: 0,
        favoriteCount: 0,
        listings: [],
        requests: []
    ))
    .padding()
}
