import SwiftUI

struct CreateRequestView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var productViewModel: ProductViewModel
    
    // Form fields
    @State private var title = ""
    @State private var maxPrice = ""
    @State private var description = ""
    @State private var selectedCategory: Category = .clothing
    @State private var selectedCountry: Country = .unitedStates
    @State private var image = "" // Optional for requests
    
    var body: some View {
        NavigationView {
            Form {
                // Title
                Section(header: Text("What are you looking for?")) {
                    TextField("Enter title", text: $title)
                }
                
                // Price
                Section(header: Text("Maximum Price")) {
                    TextField("Enter maximum price", text: $maxPrice)
                        .keyboardType(.decimalPad)
                }
                
                // Description
                Section(header: Text("Details")) {
                    TextEditor(text: $description)
                        .frame(height: 100)
                        .placeholder(when: description.isEmpty) {
                            Text("Describe what you're looking for (condition, size, color, etc.)")
                                .foregroundColor(.gray)
                        }
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
            .navigationTitle("Create Request")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Post") {
                        createRequest()
                    }
                    .disabled(!isValid)
                }
            }
        }
    }
    
    private var isValid: Bool {
        !title.isEmpty && 
        !maxPrice.isEmpty && 
        !description.isEmpty &&
        (Double(maxPrice) ?? 0) > 0
    }
    
    private func createRequest() {
        guard let priceValue = Double(maxPrice) else { return }
        
        productViewModel.createRequest(
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

// Helper view modifier for placeholder text in TextEditor
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
        
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

#Preview {
    CreateRequestView()
        .environmentObject(ProductViewModel())
} 
