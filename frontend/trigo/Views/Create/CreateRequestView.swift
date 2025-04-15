import SwiftUI

struct CreateRequestView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var productViewModel: ProductViewModel
    
    // Form fields
    @State private var selectedProductId: String = ""
    @State private var maxPrice = ""
    @State private var notes = ""
    @State private var isLoading = true
    @State private var errorMessage: String?
    @State private var showError = false
    
    // Store pre-selected product id
    private let preSelectedProductId: String?
    
    init(preSelectedProductId: String? = nil) {
        self.preSelectedProductId = preSelectedProductId
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                headerView
                
                if isLoading {
                    loadingView
                } else {
                    formFieldsView
                }
            }
            .background(Color.white)
        }
        .navigationBarHidden(true)
        .task {
            await loadProducts()
        }
        .onAppear {
            // Set the pre-selected product ID here after view is created
            if let productId = preSelectedProductId {
                selectedProductId = productId
            }
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
    
    // MARK: - View Components
    
    private var headerView: some View {
        VStack(spacing: 8) {
            Text("CREATE REQUEST")
                .font(.system(size: 28, weight: .bold))
                .tracking(2)
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(.top, 16)
        .padding(.bottom, 32)
    }
    
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)
                .padding(.top, 40)
            
            Text("Loading products...")
                .font(.system(size: 16))
                .foregroundColor(.gray)
            
            if let error = productViewModel.error {
                Text(error.localizedDescription)
                    .font(.system(size: 14))
                    .foregroundColor(.secondaryAccent)
                    .padding(.top, 16)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
        }
        .padding(.top, 60)
    }
    
    private var formFieldsView: some View {
        VStack(spacing: 24) {
            // Product Selection
            productSelectionField
            
            // Max Price field
            maxPriceField
            
            // Notes field
            notesField
            
            // Action Buttons
            requestButton
            cancelButton
        }
        .padding(.horizontal, 20)
    }
    
    private var productSelectionField: some View {
        formField(
            title: "SELECT PRODUCT",
            content: {
                if productViewModel.products.isEmpty {
                    Text("No products available")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.customBackgroundSecondary)
                        .cornerRadius(8)
                } else {
                    Menu {
                        ForEach(productViewModel.products) { product in
                            if let id = product.id {
                                Button {
                                    selectedProductId = id
                                } label: {
                                    Text(product.title)
                                }
                            } else {
                                // Fallback for products without ID
                                Text("Product missing ID")
                                    .foregroundColor(.gray)
                                    .disabled(true)
                            }
                        }
                        
                        // Ensure we always have at least one item
                        if productViewModel.products.allSatisfy({ $0.id == nil }) {
                            Text("No valid products")
                                .foregroundColor(.gray)
                                .disabled(true)
                        }
                    } label: {
                        HStack {
                            if selectedProductId.isEmpty {
                                Text("Select a product")
                                    .font(.system(size: 16))
                                    .foregroundColor(.gray)
                            } else if let product = productViewModel.products.first(where: { $0.id == selectedProductId }) {
                                Text(product.title)
                                    .font(.system(size: 16))
                                    .foregroundColor(.black)
                            } else {
                                Text("Select a product")
                                    .font(.system(size: 16))
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.down")
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color.customBackgroundSecondary)
                        .cornerRadius(8)
                    }
                }
            }
        )
    }
    
    private var maxPriceField: some View {
        formField(
            title: "MAXIMUM PRICE",
            content: {
                HStack {
                    Text("$")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.black)
                    
                    TextField("Enter maximum price", text: $maxPrice)
                        .font(.system(size: 16))
                        .keyboardType(.decimalPad)
                }
                .padding()
                .background(Color.customBackgroundSecondary)
                .cornerRadius(8)
            }
        )
    }
    
    private var notesField: some View {
        formField(
            title: "NOTES (OPTIONAL)",
            content: {
                ZStack(alignment: .topLeading) {
                    TextEditor(text: $notes)
                        .font(.system(size: 16))
                        .frame(height: 120)
                        .padding(4)
                        .background(Color.customBackgroundSecondary)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )
                    
                    if notes.isEmpty {
                        Text("Describe what you're looking for (condition, size, color, etc.)")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 16)
                            .allowsHitTesting(false)
                    }
                }
            }
        )
    }
    
    private var requestButton: some View {
        Button(action: createRequest) {
            Text("Place Request")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(isValid ? Color.bidColor : Color.gray)
                .cornerRadius(30)
        }
        .disabled(!isValid)
        .padding(.top, 16)
    }
    
    private var cancelButton: some View {
        Button(action: {
            dismiss()
        }) {
            Text("Cancel")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
        }
        .padding(.bottom, 40)
    }
    
    @ViewBuilder
    private func formField<Content: View>(title: String, @ViewBuilder content: @escaping () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.gray)
            
            content()
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
        selectedProductId != "" && !maxPrice.isEmpty && (Double(maxPrice) ?? 0) > 0
    }
    
    private func createRequest() {
        guard let priceValue = Double(maxPrice) else {
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
                try await productViewModel.createRequest(
                    productId: selectedProductId,
                    maxPrice: priceValue,
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
    CreateRequestView()
        .environmentObject(ProductViewModel())
} 
