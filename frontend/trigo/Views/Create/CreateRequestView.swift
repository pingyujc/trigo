import SwiftUI

struct CreateRequestView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var productViewModel: ProductViewModel
    
    // Form fields
    @State private var selectedProductId: String = "1"
    // default this to 1 just for MVP, to make sure the picker can select the right products
    @State private var maxPrice = ""
    @State private var notes = ""
    
    // Add optional parameter for pre-selected product
    let preSelectedProductId: String?
    
    init(preSelectedProductId: String? = nil) {
        self.preSelectedProductId = preSelectedProductId
    }
    
    var body: some View {
        NavigationView {
            Form {
                // Product Selection
                Section(header: Text("Select Product")) {
                    Picker("Select a Product", selection: $selectedProductId) {
                        ForEach(productViewModel.products) { product in
                            Text(product.title).tag(product.id) // Use 'id' instead of 'product'
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                
                // Maximum Price
                Section(header: Text("Maximum Price")) {
                    TextField("Enter maximum price", text: $maxPrice)
                        .keyboardType(.decimalPad)
                }
                
                // Notes
                Section(header: Text("Notes (optional)")) {
                    TextEditor(text: $notes)
                        .frame(height: 100)
                        .placeholder(when: notes.isEmpty) {
                            Text("Describe what you're looking for (condition, size, color, etc.)")
                                .foregroundColor(.gray)
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
            .onAppear {
//                print("Products loaded in createRequestView: \(productViewModel.products)")
                print("Number of Products in createRequestView: \(productViewModel.products.count)")

                if let productId = preSelectedProductId {
                    selectedProductId = productId
                }
            }
            .task {
                // Setup and initial fetch when view appears
                await productViewModel.setup()
            }

        }
    }
    
    private var isValid: Bool {
        selectedProductId != "" && !maxPrice.isEmpty && (Double(maxPrice) ?? 0) > 0
    }
    
    private func createRequest() {
        guard let priceValue = Double(maxPrice) else { return }
        
        // Ensure a valid product ID is selected
        guard !selectedProductId.isEmpty else { return }
        
        Task {
            do {
                try await productViewModel.createRequest(
                    productId: selectedProductId,
                    maxPrice: priceValue,
                    notes: notes
                )
                dismiss()
            } catch {
                print("Error creating request: \(error)")
            }
        }
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
