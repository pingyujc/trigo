import SwiftUI

struct CreateListingView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var productViewModel: ProductViewModel
    
    // Form fields
    @State private var selectedProductId: String = "1"
    @State private var price = ""
    @State private var notes = ""


    
    var body: some View {
        
        NavigationView {
            Form {
                // Product Selection
                // Debugging: Print the products list
                Text("Products count: \(productViewModel.products.count)")
                    .foregroundColor(.red)
                
                Section(header: Text("Select Product")) {
                    
                    Picker("Select a Product", selection: $selectedProductId) {
                        ForEach(productViewModel.products) { product in
                            Text(product.title).tag(product.id) // Use 'id' instead of 'product'
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
//                    Picker("Select a Product", selection: $selectedProduct) {
//                        Text("Product 1").tag("Product 1")
//                        Text("Product 2").tag("Product 2")
//                    }
//                    .pickerStyle(MenuPickerStyle())
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
            .onAppear {
                print("Products loaded in CreateListingView: \(productViewModel.products)")
            }
            .task {
                // Setup and initial fetch when view appears
                await productViewModel.setup()
            }
        }
    }
    
    private var isValid: Bool {
        // check if we have selected a product id and a valid price
        selectedProductId != "" && !price.isEmpty && (Double(price) ?? 0) > 0
    }
    
    private func createListing() {
        guard let priceValue = Double(price) else { return }
        
        // Ensure a valid product ID is selected
        guard !selectedProductId.isEmpty else { return }
        
        // Call the productViewModel to create the listing with just the product ID
        // productViewModel.createListing(productId: selectedProductId, price: priceValue, notes: notes)
        
        dismiss()
    }
}

#Preview {
    CreateListingView()
        .environmentObject(ProductViewModel())
}
