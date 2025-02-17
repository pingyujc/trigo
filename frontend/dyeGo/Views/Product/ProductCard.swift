//
//  ProductCard.swift
//  dyeGo
//
//  Created by Jonathan Chen on 2/9/25.
//


import SwiftUI

struct ProductCard: View {
    let product: Product

    var body: some View {
        NavigationLink(destination: ProductDetailView(product: product)) {
            VStack {
                Image(product.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .cornerRadius(8)

                Text(product.title)
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 4)

                Text("$\(product.price, specifier: "%.2f")")
                    .font(.caption)
                    .foregroundColor(.green)
            }
            .frame(width: 120)
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
        }
        .buttonStyle(PlainButtonStyle()) // Removes default navigation button styling
    }
}

#Preview {
    NavigationView {
        ProductCard(product: Product(
            title: "LEGO Porsche 911",
            price: 99.99,
            description: "Cool car!",
            image: "porche911" // Make sure this matches an image in your assets
        ))
    }
}

