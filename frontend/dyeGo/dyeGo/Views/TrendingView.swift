//
//  TrendingView.swift
//  dyeGo
//
//  Created by Jonathan Chen on 12/26/24.
//

import SwiftUI

struct TrendingView: View {
    @State private var trendingItems: [Item] = [] // We'll need to create this model
    @State private var selectedCategory: Category? // We'll need to create this model
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    // Trending Categories
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(Category.allCases, id: \.self) { category in
                                CategoryButton(
                                    category: category,
                                    isSelected: selectedCategory == category,
                                    action: { selectedCategory = category }
                                )
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Trending Items Grid
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        ForEach(trendingItems) { item in
                            ItemCard(item: item)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Trending")
            .refreshable {
                // Refresh trending items
                await loadTrendingItems()
            }
        }
    }
    
    private func loadTrendingItems() async {
        // Implement API call to fetch trending items
    }
}

// Supporting Views
struct CategoryButton: View {
    let category: Category
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(category.name)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.blue : Color.gray.opacity(0.1))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(20)
        }
    }
}

struct ItemCard: View {
    let item: Item
    
    var body: some View {
        VStack(alignment: .leading) {
            // Item Image
            AsyncImage(url: item.imageURL) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                ProgressView()
            }
            .frame(height: 150)
            .clipped()
            .cornerRadius(8)
            
            // Item Details
            Text(item.title)
                .font(.headline)
                .lineLimit(2)
            
            HStack {
                Text("$\(item.price, specifier: "%.2f")")
                    .font(.subheadline)
                    .bold()
                
                Spacer()
                
                // Quick Order Button
                Button(action: {
                    // Implement quick order functionality
                }) {
                    Text("Quick Buy")
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(4)
                }
            }
        }
        .padding(8)
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(12)
    }
}

struct TrendingView_Previews: PreviewProvider {
    static var previews: some View {
        TrendingView()
    }
}

