//
//  ProductCard.swift
//  trigo
//
//  Created by Jonathan Chen on 2/9/25.
//


import SwiftUI
struct ProductCard: View {
    let product: Product
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Image container with fixed dimensions
            ZStack {
                Color(.systemGray6) // Background color for missing images
                Image(product.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipped()
            }
            .frame(width: 200, height: 150) // Fixed size for image container
            
            Spacer()
                .frame(height: 8) // Add fixed spacing between image and content
            
            // Product info
            VStack(alignment: .leading, spacing: 4) {
                Text(product.title)
                    .font(.headline)
                    .lineLimit(2)
                    .frame(height: 50) // Fixed height for title
                
                // Price info
                Group {
                    if let lowestPrice = product.lowestListingPrice {
                        Text("$\(lowestPrice, specifier: "%.2f")")
                            .foregroundColor(.green)
                    } else if let highestBid = product.highestRequestPrice {
                        Text("Highest Bid: $\(highestBid, specifier: "%.2f")")
                            .foregroundColor(.blue)
                    } else {
                        Text("No Price") // Placeholder to maintain consistent height
                            .foregroundColor(.gray)
                    }
                }
                .font(.subheadline)
                .frame(height: 20) // Fixed height for price
                
                // Stats
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
            .frame(width: 200) // Same width as image
        }
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 2)
        .frame(width: 200, height: 250) // Fixed overall dimensions
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
