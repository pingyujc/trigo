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
            ScrollView {
                VStack(spacing: 0) {
                    // Header
                    Text("CREATE")
                        .font(.system(size: 28, weight: .bold))
                        .tracking(2)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 16)
                        .padding(.bottom, 32)
                    
                    // Create Options
                    VStack(spacing: 20) {
                        ForEach(CreateOption.allCases, id: \.self) { option in
                            createOptionCard(option: option)
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .background(Color.white)
            }
        }
        .environmentObject(productViewModel)
    }
    
    @ViewBuilder
    private func createOptionCard(option: CreateOption) -> some View {
        NavigationLink(destination: destinationView(for: option)) {
            HStack(spacing: 16) {
                // Icon
                Image(systemName: option.icon)
                    .font(.system(size: 24))
                    .foregroundColor(.black)
                    .frame(width: 40, height: 40)
                
                // Option text
                VStack(alignment: .leading, spacing: 4) {
                    Text(option.rawValue)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black)
                    
                    Text(option.description)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .lineLimit(2)
                }
                
                Spacer()
                
                // Chevron
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            .padding(20)
            .background(Color.customBackgroundSecondary)
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
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
