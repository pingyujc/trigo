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
    @AppStorage("defaultToSelling") private var defaultToSelling = false
    @State private var isSelling: Bool
    
    init(product: Product) {
        self.product = product
        // Initialize @State property using underscore syntax before self is used
        self._isSelling = State(wrappedValue: UserDefaults.standard.bool(forKey: "defaultToSelling"))
    }
    
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

                // Action Button and Toggle
                VStack(spacing: 8) {
                    Button(action: {
                        if isSelling {
                            print("Listed for sale: \(product.title)")
                        } else {
                            print("Added to cart: \(product.title)")
                        }
                    }) {
                        Text(isSelling ? "Sell Now" : "Add to Cart")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(isSelling ? Color.orange : Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(radius: 3)
                    }
                    
                    Button(action: {
                        isSelling.toggle()
                        defaultToSelling = isSelling // Save preference when toggled
                    }) {
                        Text(isSelling ? "Buy this item instead?" : "Sell this item instead?")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
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




