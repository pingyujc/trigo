//
//  ProductDetailView.swift
//  trigo
//
//  Created by Jonathan Chen on 2/9/25.
//

import Foundation
import SwiftUI

struct ProductDetailView: View {
    @StateObject private var viewModel: ProductDetailViewModel
    @EnvironmentObject private var productViewModel: ProductViewModel
    @State private var viewMode: ViewMode = .buy
    
    enum ViewMode {
        case buy, sell
        
        var title: String {
            switch self {
            case .buy: return "Buy"
            case .sell: return "Sell"
            }
        }
    }
    
    init(viewModel: ProductDetailViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Product Header - full width image
                Image(viewModel.product.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 350)
                    .clipped()
                
                // Product Info
                VStack(alignment: .leading, spacing: 24) {
                    // Year/season marker
                    Text("2025")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                        .padding(.top, 16)
                    
                    // Product Title
                    Text(viewModel.product.title)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.black)
                    
                    // Price
                    if let price = viewModel.product.lowestListingPrice {
                        Text("$\(Int(price))")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.priceColor)
                    }
                    
                    // Description
                    Text(viewModel.product.description)
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                        .padding(.top, 8)
                    
                    // Category and country info
                    HStack {
                        VStack(alignment: .leading) {
                            Text("CATEGORY")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.gray)
                            Text(viewModel.product.category.rawValue)
                                .font(.system(size: 14, weight: .medium))
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            Text("ORIGIN")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.gray)
                            Text(viewModel.product.country.rawValue)
                                .font(.system(size: 14, weight: .medium))
                        }
                    }
                    .padding(.vertical, 16)
                    
                    Divider()
                        .padding(.vertical, 8)
                    
                    // Buy/Sell Tabs
                    HStack(spacing: 0) {
                        tabButton(title: "Buy", isSelected: viewMode == .buy) {
                            viewMode = .buy
                        }
                        
                        tabButton(title: "Sell", isSelected: viewMode == .sell) {
                            viewMode = .sell
                        }
                    }
                    .padding(.vertical, 8)
                    
                    // Main Action Section
                    if viewMode == .buy {
                        BuySection(
                            product: viewModel.product,
                            listings: viewModel.product.listings.filter { $0.isActive }
                        )
                    } else {
                        SellSection(
                            product: viewModel.product,
                            requests: viewModel.product.requests.filter { $0.isActive }
                        )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 32)
            }
        }
        .edgesIgnoringSafeArea(.top)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func tabButton(title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(title)
                    .font(.system(size: 16, weight: isSelected ? .bold : .medium))
                    .foregroundColor(isSelected ? .black : .gray)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                
                if isSelected {
                    Rectangle()
                        .frame(height: 2)
                        .foregroundColor(.black)
                } else {
                    Rectangle()
                        .frame(height: 2)
                        .foregroundColor(.clear)
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
}

struct BuySection: View {
    let product: Product
    let listings: [Listing]
    
    var body: some View {
        VStack(spacing: 16) {
            ForEach(listings.sorted(by: { $0.price < $1.price })) { listing in
                HStack {
                    VStack(alignment: .leading) {
                        Text("$\(Int(listing.price))")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.black)
                    }
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Text("Buy")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 10)
                            .background(Color.black)
                            .cornerRadius(20)
                    }
                }
                .padding()
                .background(Color.customBackgroundSecondary)
                .cornerRadius(8)
            }
            
            if listings.isEmpty {
                Text("No listings available")
                    .foregroundColor(.secondary)
                    .padding()
            }
            
            // Create Request Button
            NavigationLink(
                destination: CreateRequestView(preSelectedProductId: product.id ?? "")
            ) {
                Text("Place Bid")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.bidColor)
                    .cornerRadius(30)
            }
            .disabled(product.id == nil)
            .padding(.top, 16)
        }
        .padding(.top, 16)
    }
}

struct SellSection: View {
    let product: Product
    let requests: [Request]
    
    var body: some View {
        VStack(spacing: 16) {
            ForEach(requests.sorted(by: { $0.maxBudget > $1.maxBudget }), id: \.id) { request in
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("$\(Int(request.maxBudget))")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.black)
                        
                        if let notes = request.notes, !notes.isEmpty {
                            Text(notes)
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                                .lineLimit(1)
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Text("Sell")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 10)
                            .background(Color.black)
                            .cornerRadius(20)
                    }
                }
                .padding()
                .background(Color.customBackgroundSecondary)
                .cornerRadius(8)
            }
            
            if requests.isEmpty {
                Text("No active requests")
                    .foregroundColor(.secondary)
                    .padding()
            }
            
            // Create Listing Button
            NavigationLink(
                destination: CreateListingView(preSelectedProductId: product.id ?? "")
            ) {
                Text("Create Listing")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.black)
                    .cornerRadius(30)
            }
            .disabled(product.id == nil)
            .padding(.top, 16)
        }
        .padding(.top, 16)
    }
}

#Preview {
    NavigationView {
        ProductDetailView(viewModel: ProductDetailViewModel(product: .sampleListing))
    }
}





