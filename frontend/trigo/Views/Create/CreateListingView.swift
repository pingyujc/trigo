import SwiftUI

struct CreateListingView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var productViewModel: ProductViewModel
    
    // Form fields
    @State private var selectedProductId: String
    @State private var price = ""
    @State private var notes = ""
    @State private var isLoading = true
    @State private var errorMessage: String?
    @State private var showError = false
    
    // Add optional parameter for pre-selected product
    let preSelectedProductId: String?
    
    init(preSelectedProductId: String? = nil) {
        self.preSelectedProductId = preSelectedProductId
        _selectedProductId = State(initialValue: preSelectedProductId ?? "")
    }
    
    var body: some View {
        NavigationView {
            Group {
                if isLoading {
                    VStack {
                        ProgressView("Loading products...")
                        if let error = productViewModel.error {
                            Text(error.localizedDescription)
                                .foregroundColor(.red)
                                .padding()
                        }
                    }
                } else {
                    Form {
                        Section(header: Text("Select Product")) {
                            if productViewModel.products.isEmpty {
                                Text("No products available")
                                    .foregroundColor(.secondary)
                            } else {
                                Picker("Select a Product", selection: $selectedProductId) {
                                    Text("Select a product").tag("")
                                    ForEach(productViewModel.products) { product in
                                        if let id = product.id {
                                            Text(product.title).tag(id)
                                        }
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                            }
                        }
                        
                        // Price
                        Section(header: Text("Price")) {
                            TextField("Enter price", text: $price)
                                .keyboardType(.decimalPad)
                        }
                        
                        // Notes
                        Section(header: Text("Notes (optional)")) {
                            TextEditor(text: $notes)
                                .frame(height: 100)
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
                    .disabled(!isValid || isLoading)
                }
            }
            .task {
                await loadProducts()
            }
            .alert("Error", isPresented: $showError) {
                Button("OK") {
                    errorMessage = nil
                }
            } message: {
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                }
            }
        }
    }
    
    private func loadProducts() async {
        isLoading = true
        
        // If products are empty, fetch them
        if productViewModel.products.isEmpty {
            do {
                try await productViewModel.fetchProducts()
            } catch {
                errorMessage = error.localizedDescription
                showError = true
                isLoading = false
                return
            }
        }
        
        // Now verify the preselected product
        if let productId = preSelectedProductId {
            print("Checking product ID:", productId)
            print("Available products:", productViewModel.products.map { $0.id })
            let productExists = productViewModel.products.contains { $0.id == productId }
            if !productExists {
                selectedProductId = ""
                errorMessage = "Selected product not found"
                showError = true
            }
        }
        
        isLoading = false
    }
    
    private var isValid: Bool {
        // check if we have selected a product id and a valid price
        selectedProductId != "" && !price.isEmpty && (Double(price) ?? 0) > 0
    }
    
    private func createListing() {
        guard let priceValue = Double(price) else {
            errorMessage = "Invalid price format"
            showError = true
            return
        }
        
        // Ensure a valid product ID is selected
        guard !selectedProductId.isEmpty else {
            errorMessage = "Please select a product"
            showError = true
            return
        }
        
        Task {
            do {
                try await productViewModel.createListing(
                    productId: selectedProductId,
                    price: priceValue,
                    notes: notes
                )
                dismiss()
            } catch {
                errorMessage = error.localizedDescription
                showError = true
            }
        }
    }
}

#Preview {
    CreateListingView()
        .environmentObject(ProductViewModel())
}
