//
//  ProductDetailView.swift
//  dyeGo
//
//  Created by Jonathan Chen on 2/9/25.
//

import Foundation
import SwiftUI

struct ProductDetailView: View {
    let product: Product

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                
                // Display Image
                Image(product.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: 300)
                    .cornerRadius(10)
                    .shadow(radius: 5)

                // Product Title
                Text(product.title)
                    .font(.title)
                    .bold()
                    .padding(.horizontal)

                // Product Price
                Text("$\(product.price, specifier: "%.2f")")
                    .font(.title2)
                    .foregroundColor(.green)
                    .bold()
                    .padding(.horizontal)

                // Product Description
                Text(product.description)
                    .font(.body)
                    .padding(.horizontal)

                // Add to Cart Button
                // action is not doing anything at this moment but printing, will implement backend in the future
                Button(action: {
                    print("Added to cart: \(product.title)")
                }) {
                    Text("Add to Cart")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 3)
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationTitle(product.title)
    }
}

// Add preview provider
#Preview {
    let sampleProduct = Product(
        title: "LEGO Porsche 911",
        price: 99.99,
        description: "Cool car!",
        image: "porche911" // Make sure this matches an image in your assets
    )
    
    ProductDetailView(product: sampleProduct)
}




