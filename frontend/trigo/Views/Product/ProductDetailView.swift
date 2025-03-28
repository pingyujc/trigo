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
            VStack(spacing: 20) {
                // Product Header
                ProductHeaderView(product: viewModel.product)
                
                // Market Stats
                MarketStatsView(
                    lowestAsk: viewModel.product.lowestListingPrice ?? 0,
                    highestBid: viewModel.product.highestRequestPrice ?? 0
                )
                
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
                
                // Mode Switch Button
                Button(action: { viewMode = viewMode == .buy ? .sell : .buy }) {
                    Text(viewMode == .buy ? "Sell This Item Instead" : "Buy This Item Instead")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
                .padding(.top)
            }
            .padding()
        }
        .navigationTitle(viewModel.product.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ProductHeaderView: View {
    let product: Product
    
    var body: some View {
        VStack(spacing: 12) {
            // will switch to this when using firebase
//            AsyncImage(url: URL(string: product.image)) { image in
//                image.resizable().aspectRatio(contentMode: .fit)
//            } placeholder: {
//                Rectangle().fill(Color.gray.opacity(0.2))
//            }
//            .frame(height: 200)
            
            // use local storage for now
            Image(product.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 150)
                .clipped()
            Text(product.title)
                .font(.headline)
            
            HStack {
                Label(product.category.rawValue, systemImage: "tag")
                Spacer()
                Label(product.country.rawValue, systemImage: "globe")
            }
            .font(.caption)
            .foregroundColor(.secondary)
        }
    }
}

struct MarketStatsView: View {
    let lowestAsk: Double
    let highestBid: Double
    
    var body: some View {
        HStack(spacing: 20) {
            VStack {
                Text("Lowest Ask")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text("$\(lowestAsk, specifier: "%.2f")")
                    .font(.headline)
                    .foregroundColor(.green)
            }
            
            Divider()
            
            VStack {
                Text("Highest Bid")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text("$\(highestBid, specifier: "%.2f")")
                    .font(.headline)
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 1)
    }
}

struct BuySection: View {
    let product: Product
    let listings: [Listing]
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Available Listings")
                .font(.headline)
            
            ForEach(listings.sorted(by: { $0.price < $1.price })) { listing in
                HStack {
                    VStack(alignment: .leading) {
                        Text("$\(listing.price, specifier: "%.2f")")
                            .font(.title3)
                            .bold()
                    }
                    
                    Spacer()
                    
                    Text("Buy Now")
                        .foregroundColor(.green)
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(8)
                .shadow(radius: 1)
            }
            
            if listings.isEmpty {
                Text("No listings available")
                    .foregroundColor(.secondary)
                    .padding()
            }
            
            // Add Create Request Button
            NavigationLink(
                destination: CreateRequestView(preSelectedProductId: product.id ?? "")
            ) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Bid")
                }
                .foregroundColor(.green)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(.systemBackground))
                .cornerRadius(8)
                .shadow(radius: 1)
            }
            .disabled(product.id == nil)
        }
    }
}

struct SellSection: View {
    let product: Product
    let requests: [Request]
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Active Requests")
                .font(.headline)
            
            ForEach(requests.sorted(by: { $0.maxBudget > $1.maxBudget }), id: \.id) { request in
                HStack {
                    VStack(alignment: .leading) {
                        Text("$\(request.maxBudget, specifier: "%.2f")")
                            .font(.title3)
                            .bold()
                        Text(request.notes ?? "No additional notes")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Text("Sell Now")
                        .foregroundColor(.blue)
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(8)
                .shadow(radius: 1)
            }
            
            if requests.isEmpty {
                Text("No active requests")
                    .foregroundColor(.secondary)
                    .padding()
            }
            
            // Add Create Listing Button
            NavigationLink(
                destination: CreateListingView(preSelectedProductId: product.id ?? "")
            ) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Ask")
                }
                .foregroundColor(.blue)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(.systemBackground))
                .cornerRadius(8)
                .shadow(radius: 1)
            }
            .disabled(product.id == nil)
        }
    }
}

#Preview {
    NavigationView {
        ProductDetailView(viewModel: ProductDetailViewModel(product: .sampleListing))
    }
}





