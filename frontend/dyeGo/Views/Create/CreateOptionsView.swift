import SwiftUI

struct CreateOptionsView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var productViewModel = ProductViewModel()
    @State private var selectedOption: CreateOption?
    
    enum CreateOption: String, CaseIterable {
        case product = "Product"
        case listing = "Listing"
        case request = "Request"
        
        var description: String {
            switch self {
            case .product:
                return "Create a new product that others can list or request"
            case .listing:
                return "List an existing product for sale"
            case .request:
                return "Request to buy an existing product"
            }
        }
        
        var icon: String {
            switch self {
            case .product:
                return "cube.box"
            case .listing:
                return "tag"
            case .request:
                return "hand.raised"
            }
        }
    }
    
    var body: some View {
        NavigationView {
            List(CreateOption.allCases, id: \.self) { option in
                NavigationLink(
                    destination: destinationView(for: option)
                ) {
                    HStack {
                        Image(systemName: option.icon)
                            .foregroundColor(.blue)
                            .frame(width: 30)
                        
                        VStack(alignment: .leading) {
                            Text(option.rawValue)
                                .font(.headline)
                            Text(option.description)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle("Create New")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
        .environmentObject(productViewModel)
    }
    
    @ViewBuilder
    private func destinationView(for option: CreateOption) -> some View {
        switch option {
        case .product:
            CreateProductView()
        case .listing:
            CreateListingView(preSelectedProductId: nil)
        case .request:
            CreateRequestView(preSelectedProductId: nil)
        }
    }
}

#Preview {
    CreateOptionsView()
} 
