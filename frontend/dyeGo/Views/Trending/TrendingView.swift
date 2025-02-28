//
//  TrendingView.swift
//  dyeGo
//
//  Created by Jonathan Chen on 12/26/24.
//

import SwiftUI

struct TrendingView: View {
    @StateObject private var viewModel: ProductViewModel
    @State private var selectedCountry: Country?
    
    init(viewModel: ProductViewModel = ProductViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Country filter
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(Country.allCases, id: \.self) { country in
                                CountryButton(
                                    country: country,
                                    isSelected: selectedCountry == country,
                                    action: {
                                        selectedCountry = country
                                        Task {
                                            await viewModel.applyFilters(country: country)
                                        }
                                    }
                                )
                            }
                        }
                        .padding(.horizontal)   
                    }

//                     Products Grid
//                    LazyVGrid(columns: [
//                        GridItem(.flexible()),
//                        GridItem(.flexible())
//                    ], spacing: 16) {
//                        ForEach(viewModel.products) { product in
//                            NavigationLink(destination: ProductDetailView(viewModel: ProductDetailViewModel(product: product))) {
//                                ProductCard(product: product)
//                            }
//                        }
//                    }
//                    .padding()
                    LazyVStack(spacing: 20) {
//                        SectionView(title: "Recently Viewed", products: mockRecentlyViewed)
                        SectionView(title: "Trending Listings", products: viewModel.products)
                        SectionView(title: "Trending Requests", products: viewModel.products)
                    }
                    .padding()
                    .onAppear {
                        print("Products loaded in CreateListingView: \(viewModel.products)")
                    }
                }
            }
            .navigationTitle("Trending")
            .task {
                // Setup and initial fetch when view appears
                await viewModel.setup()
            }
            .onChange(of: selectedCountry) { oldCountry, newCountry in
                // Handle country filter changes
                Task {
                    await viewModel.applyFilters(country: newCountry)
                }
            }
            .refreshable {
                // Pull to refresh
                await viewModel.fetchProducts()
            }
            // Show loading indicator
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                }
            }
            // Show error if any
            .alert("Error", isPresented: .constant(viewModel.error != nil)) {
                Button("OK") {
                    viewModel.error = nil
                }
            } message: {
                Text(viewModel.error?.localizedDescription ?? "Unknown error")
            }
        }
    }
}

// Preview
#Preview {
    TrendingView()
}





