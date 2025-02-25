//
//  TrendingView.swift
//  dyeGo
//
//  Created by Jonathan Chen on 12/26/24.
//

import SwiftUI

struct TrendingView: View {
    @State private var selectedCategory: Category? // Assuming you define this elsewhere
    @State private var selectedCountry: Country?
    @EnvironmentObject var productViewModel: ProductViewModel  // Use shared instance

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Trending Categories
//                    ScrollView(.horizontal, showsIndicators: false) {
//                        HStack(spacing: 12) {
//                            ForEach(Category.allCases, id: \.self) { category in
//                                CategoryButton(
//                                    category: category,
//                                    isSelected: selectedCategory == category,
//                                    action: { selectedCategory = category }
//                                )
//                            }
//                        }
//                        .padding(.horizontal)
//                    }
//                    Country filter
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(Country.allCases, id: \.self) { country in
                                CountryButton(
                                    country: country,
                                    isSelected: selectedCountry == country,
                                    action: { selectedCountry = country }
                                )
                            }
                        }
                        .padding(.horizontal)
                    }

                    // Trending Product Sections
                    LazyVStack(spacing: 20) {
//                        SectionView(title: "Recently Viewed", products: mockRecentlyViewed)
                        SectionView(title: "Trending Listings", products: productViewModel.getListings())
                        SectionView(title: "Trending Requests", products: productViewModel.getRequests())
                    }
                    .padding()
                }

            }
            .navigationTitle("Trending")
        }
    }
}




// Sample Data for Preview, currently not used
let mockRecentlyViewed = [
    Product(title: "Porche 911", price: 399.99, description: "Cool car.", image: "porche911"),
    Product(title: "G Wagon", price: 500, description: "Huge car.", image: "benzG500"),
    Product(title: "Lambo 5000", price: 1000, description: "Fast car.", image: "lambo5000"),
    Product(title: "McLaren P1", price: 1999, description: "Expensive car.", image: "mclarenP1")
]

let mockTrendingProducts = [
    Product(title: "Porche 911", price: 399.99, description: "Cool car.", image: "porche911"),
    Product(title: "G Wagon", price: 500, description: "Huge car.", image: "benzG500"),
    Product(title: "Lambo 5000", price: 1000, description: "Fast car.", image: "lambo5000"),
    Product(title: "McLaren P1", price: 1999, description: "Expensive car.", image: "mclarenP1")
]

let mockBuyAgain = [
    Product(title: "Porche 911", price: 399.99, description: "Cool car.", image: "porche911"),
    Product(title: "G Wagon", price: 500, description: "Huge car.", image: "benzG500"),
    Product(title: "Lambo 5000", price: 1000, description: "Fast car.", image: "lambo5000"),
    Product(title: "McLaren P1", price: 1999, description: "Expensive car.", image: "mclarenP1")
]

// Preview
#Preview {
    TrendingView()
}





