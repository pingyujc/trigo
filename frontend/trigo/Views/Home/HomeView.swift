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
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    // Featured Product
                    featuredProductView
                    
                    // Content Sections
                    VStack(spacing: 0) {
                        // Just Dropped Section
                        CategorySectionView(title: "Just Dropped")
                        SectionView(title: "Top Picks", products: viewModel.products)
                        
                        Divider()
                            .padding(.vertical, 24)
                        
                        // Categories Grid
                        shopByCategoryView
                    }
                }
                .background(Color.white)
            }
            .ignoresSafeArea(edges: .top)
            .overlay(
                // Logo Header like in reference image
                VStack {
                    Text("TRIGO")
                        .font(.system(size: 28, weight: .bold))
                        .tracking(2)
                        .padding(.top, 50)
                        .padding(.bottom, 12)
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                    
                    Spacer()
                }
                .edgesIgnoringSafeArea(.top)
                , alignment: .top
            )
            .task {
                // Setup and initial fetch when view appears
                await viewModel.setup()
            }
            .refreshable {
                // Pull to refresh
                do {
                    try await viewModel.fetchProducts()
                } catch {
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
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    // Featured Product View - like the Prada sunglasses in reference
    private var featuredProductView: some View {
        ZStack(alignment: .bottomLeading) {
            // Fixed height container to prevent layout shifts
            GeometryReader { geometry in
                if let featuredProduct = viewModel.products.first {
                    if let firstImageUrl = featuredProduct.imageUrls.first, let url = URL(string: firstImageUrl) {
                        CachedAsyncImage(url: url) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: geometry.size.width, height: 400)
                                .clipped()
                        } placeholder: {
                            Rectangle()
                                .fill(Color.customBackgroundSecondary)
                                .frame(width: geometry.size.width, height: 400)
                                .overlay(
                                    ProgressView()
                                        .scaleEffect(1.5)
                                )
                        }
                    } else {
                        // No image URLs
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: geometry.size.width, height: 400)
                            .overlay(
                                Image(systemName: "photo")
                                    .font(.system(size: 40))
                                    .foregroundColor(.gray)
                            )
                    }
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: geometry.size.width, height: 400)
                }
            }
            .frame(height: 400)
            
            // Product info overlay
            VStack(alignment: .leading, spacing: 4) {
                if let featuredProduct = viewModel.products.first {
                    Text(featuredProduct.category.rawValue)
                        .font(.system(size: 16))
                        .bold()
                    
                    Text(featuredProduct.title)
                        .font(.system(size: 26, weight: .bold))
                    
                    if let price = featuredProduct.lowestListingPrice {
                        Text("$\(Int(price))")
                            .font(.system(size: 20, weight: .bold))
                            .padding(.top, 4)
                    }
                } else {
                    Text("Featured Product")
                        .font(.system(size: 26, weight: .bold))
                    
                    Text("$390")
                        .font(.system(size: 20, weight: .bold))
                }
            }
            .padding(24)
            .foregroundColor(.white)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.black.opacity(0.7), Color.black.opacity(0)]),
                    startPoint: .bottom,
                    endPoint: .top
                )
            )
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(height: 400)
        .padding(.bottom, 32)
    }
    
    // Category Grid - like the SHOES, ELECTRONICS etc. in reference
    private var shopByCategoryView: some View {
        VStack(spacing: 0) {
            Text("SHOP BY CATEGORY")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.gray)
                .tracking(1.5)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.horizontal)
                .padding(.bottom, 24)
                .overlay(
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.gray.opacity(0.3))
                        .padding(.horizontal, 20)
                )
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                categoryCell(title: "SHOES", image: "shoes")
                categoryCell(title: "ELECTRONICS", image: "electronics")
                categoryCell(title: "APPAREL", image: "apparel")
                categoryCell(title: "BEAUTY", image: "beauty")
            }
            .padding(.horizontal)
            .padding(.bottom, 32)
        }
    }
    
    private func categoryCell(title: String, image: String) -> some View {
        VStack {
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 120)
                .clipShape(Rectangle())
            
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .padding(.vertical, 8)
        }
        .background(Color.white)
    }
}

// Preview
#Preview {
    HomeView()
}





