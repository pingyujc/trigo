import SwiftUI
import Foundation

struct SearchView: View {
    @State private var searchText = ""
    @State private var selectedFilters: Set<Filter> = []
    @State private var sortOption: SortOption = .recent
    @State private var searchResults: [Item] = []
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                Text("BROWSE")
                    .font(.system(size: 28, weight: .bold))
                    .tracking(2)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 16)
                    .padding(.bottom, 16)
                
                // Search Bar
                SearchBar(text: $searchText)
                    .padding(.horizontal)
                    .padding(.bottom, 16)
                
                // Category Pills - Horizontal scroll of categories
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 24) {
                        Text("MAINS")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.gray)
                        
                        Text("BROWSE")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.black)
                        
                        Text("AIR MAX")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 32)
                }
                
                // Just Dropped Section
                VStack(alignment: .leading) {
                    CategorySectionView(title: "Just Dropped")
                        .padding(.bottom, 16)
                    
                    // Grid of results
                    if searchResults.isEmpty {
                        EmptyStateView()
                            .frame(maxWidth: .infinity)
                            .padding(.top, 32)
                    } else {
                        ScrollView {
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                                ForEach(searchResults) { item in
                                    SearchResultItem(item: item)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                
                Spacer()
            }
            .background(Color.white)
        }
//        .onChange(of: searchText) { _ in
//            performSearch()
//        }
    }
    
    private func toggleFilter(_ filter: Filter) {
        if selectedFilters.contains(filter) {
            selectedFilters.remove(filter)
        } else {
            selectedFilters.insert(filter)
        }
        performSearch()
    }
    
    private func performSearch() {
        // Implement search functionality
    }
}

// Supporting Views and Models
struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search", text: $text)
                .font(.system(size: 16))
                .autocapitalization(.none)
            
            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(12)
        .background(Color.customGray)
        .cornerRadius(8)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 48))
                .foregroundColor(.gray.opacity(0.6))
            
            Text("No results found")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.black)
            
            Text("Try adjusting your search criteria")
                .font(.system(size: 16))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
        .padding()
    }
}

struct SearchResultItem: View {
    let item: Item
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Image
            AsyncImage(url: item.imageURL) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Color.gray.opacity(0.2)
            }
            .frame(height: 160)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            // Year
            Text("2025")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.gray)
                .padding(.top, 4)
            
            // Product Name
            Text(item.title)
                .font(.system(size: 14, weight: .medium))
                .lineLimit(2)
                .foregroundColor(.black)
            
            // Price
            Text("$\(Int(item.price))")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.priceColor)
        }
    }
}

