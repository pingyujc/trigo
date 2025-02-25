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

                // Add product type indicator
                HStack {
                    Image(systemName: product.type == .listing ? "tag" : "magnifyingglass")
                    Text(product.type == .listing ? "Listed for Sale" : "Buying Request")
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                
                // Action button and toggle
                VStack(spacing: 8) {
                    Button(action: {
                        if isSelling {
                            print("Response to \(product.type == .listing ? "listing" : "request"): \(product.title)")
                        } else {
                            print(product.type == .listing ? "Added to cart" : "Created similar request")
                        }
                    }) {
                        Text(buttonTitle)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(buttonColor)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(radius: 3)
                    }
                    
                    Button(action: {
                        isSelling.toggle()
                        defaultToSelling = isSelling
                    }) {
                        Text(toggleText)
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
    
    // Helper computed properties for button states
    private var buttonTitle: String {
        switch (product.type, isSelling) {
        case (.listing, false):
            return "Add to Cart"
        case (.listing, true):
            return "Sell Similar Item"
        case (.request, false):
            return "Make Similar Request"
        case (.request, true):
            return "Fulfill This Request"
        }
    }
    
    private var buttonColor: Color {
        switch (product.type, isSelling) {
        case (.listing, false), (.request, false):
            return .blue
        case (.listing, true), (.request, true):
            return .orange
        }
    }
    
    private var toggleText: String {
        switch (product.type, isSelling) {
        case (.listing, false):
            return "Sell similar item instead?"
        case (.listing, true):
            return "Buy this item instead?"
        case (.request, false):
            return "Fulfill this request instead?"
        case (.request, true):
            return "Make similar request instead?"
        }
    }
}

// Preview
#Preview {
    NavigationView {
        ProductDetailView(product: .sampleListing)
    }
}

#Preview("Request Preview") {
    NavigationView {
        ProductDetailView(product: .sampleRequest)
    }
}




