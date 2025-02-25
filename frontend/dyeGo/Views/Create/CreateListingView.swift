import SwiftUI

struct CreateListingView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var productViewModel: ProductViewModel
    
    // Form fields
    @State private var title = ""
    @State private var price = ""
    @State private var description = ""
    @State private var selectedCategory: Category = .clothing
    @State private var selectedCountry: Country = .unitedStates
    @State private var image = "" // You might want to replace this with proper image handling
    
    var body: some View {
        NavigationView {
            Form {
                // Title
                Section(header: Text("Title")) {
                    TextField("Enter title", text: $title)
                }
                
                // Price
                Section(header: Text("Price")) {
                    TextField("Enter price", text: $price)
                        .keyboardType(.decimalPad)
                }
                
                // Description
                Section(header: Text("Description")) {
                    TextEditor(text: $description)
                        .frame(height: 100)
                }
                
                // Category
                Section(header: Text("Category")) {
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(Category.allCases, id: \.self) { category in
                            Text(category.rawValue.capitalized)
                                .tag(category)
                        }
                    }
                }
                
                // Country
                Section(header: Text("Country")) {
                    Picker("Country", selection: $selectedCountry) {
                        ForEach(Country.allCases, id: \.self) { country in
                            Text(country.rawValue)
                                .tag(country)
                        }
                    }
                }
            }
            .navigationTitle("Create Listing")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Post") {
                        createListing()
                    }
                    .disabled(!isValid)
                }
            }
        }
    }
    
    private var isValid: Bool {
        !title.isEmpty && 
        !price.isEmpty && 
        !description.isEmpty &&
        (Double(price) ?? 0) > 0
    }
    
    private func createListing() {
        guard let priceValue = Double(price) else { return }
        
        productViewModel.createListing(
            title: title,
            price: priceValue,
            description: description,
            image: image,
            category: selectedCategory,
            country: selectedCountry
        )
        
        dismiss()
    }
}

#Preview {
    CreateListingView()
        .environmentObject(ProductViewModel())
}
