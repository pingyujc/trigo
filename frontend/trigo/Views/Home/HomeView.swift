//
//  TrendingView.swift
//  trigo
//
//  Created by Jonathan Chen on 12/26/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel: ProductViewModel
    @State private var selectedCountry: Country?
    @State private var searchText = ""
    
    init(viewModel: ProductViewModel = ProductViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("What are you looking for?", text: $searchText)
                    }
                    .padding()
                    .background(Color(.systemGray6).opacity(0.8))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
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
                    
                    // Content Sections
                    VStack(spacing: 32) {
                        // Trending Listings Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Trending Listings")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.horizontal)
                            
                            SectionView(title: "Trending Listings", products: viewModel.products)
                        }
                        
                        // Trending Requests Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Trending Requests")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.horizontal)
                            
                            SectionView(title: "Trending Requests", products: viewModel.products)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Welcome to home page")
            .navigationBarTitleDisplayMode(.large)
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
                do {
                    try await viewModel.fetchProducts()
                    print("Products refreshed successfully")
                } catch {
                    print("Error refreshing products: \(error)")
                    viewModel.error = error
                }
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
    HomeView()
}





