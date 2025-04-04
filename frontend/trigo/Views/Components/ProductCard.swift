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
            // Image
            Image(product.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 160, height: 160)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            // Year or category label (inspired by the reference image)
            Text("2025")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.gray)
                .padding(.top, 4)
            
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
            }
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
        image: "porche911",
        viewCount: 0,
        favoriteCount: 0,
        listings: [],
        requests: []
    ))
    .padding()
    
}
