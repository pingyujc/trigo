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
        VStack(alignment: .leading) {
            // Image
            Image(product.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 200, height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
            // Product Info
            VStack(alignment: .leading, spacing: 8) {
                Text(product.title)
                    .font(.headline)
                    .lineLimit(2)
                    .foregroundColor(.primary)
                
                if let price = product.lowestListingPrice {
                    Text("$\(price, specifier: "%.2f")")
                        .font(.subheadline)
                        .foregroundColor(.green)
                } else if let highestBid = product.highestRequestPrice {
                    Text("Highest Bid: $\(highestBid, specifier: "%.2f")")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
                
                HStack {
                    Label("\(product.viewCount)", systemImage: "eye")
                    Spacer()
                    Label("\(product.favoriteCount)", systemImage: "heart")
                }
                .font(.caption)
                .foregroundColor(.gray)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 8)
        }
        .frame(width: 200)
        .background(Color.customBackground)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
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
