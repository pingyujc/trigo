//
//  SectionView.swift
//  dyeGo
//
//  Created by Jonathan Chen on 2/9/25.
//

import Foundation
import SwiftUI

struct SectionView: View {
	let title: String
	let products: [Product]
	var body: some View {
	    VStack(alignment: .leading) {
	        Text(title)
	            .font(.headline)
	            .padding(.bottom, 5)
	        ScrollView(.horizontal, showsIndicators: false) {
	            LazyHStack(spacing: 15) {
	                ForEach(products) { product in
	                    NavigationLink(destination: ProductDetailView(product: product)) {
	                        ProductCard(product: product)
	                    }
	                    .buttonStyle(PlainButtonStyle()) // Prevents default link styling
	                }
	            }
	        }
	    }
	}
}

#Preview {
    NavigationView {
        SectionView(
            title: "Popular Products",
            products: [
                Product(title: "Porche 911", price: 399.99, description: "Cool car.", image: "porche911"),
                Product(title: "G Wagon", price: 500, description: "Huge car.", image: "benzG500"),
                Product(title: "lmabo5000", price: 1000, description: "Fast car.", image: "lambo5000"),
                Product(title: "McLaren P1", price: 1999, description: "Expensive car.", image: "mclarenP1")


            ]
        )
    }
}

