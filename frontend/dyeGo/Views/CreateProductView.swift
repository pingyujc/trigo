import SwiftUI

struct CreateProductView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    @State private var price = ""
    @State private var description = ""
    @State private var selectedCategory: Category = .clothing
    @State private var selectedCountry: Country = .taiwan
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?
    
    var body: some View {
        NavigationView {
            Form {
                // Basic Info
                Section("Basic Information") {
                    TextField("Title", text: $title)
                    TextField("Price", text: $price)
                        .keyboardType(.decimalPad)
                    TextEditor(text: $description)
                        .frame(height: 100)
                }
                
                // Category & Country
                Section("Details") {
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(Category.allCases, id: \.self) { category in
                            Text(category.name).tag(category)
                        }
                    }
                    
                    Picker("Country", selection: $selectedCountry) {
                        ForEach(Country.allCases, id: \.self) { country in
                            Text(country.name).tag(country)
                        }
                    }
                }
                
                // Image Selection
                Section("Product Image") {
                    Button(action: { showImagePicker = true }) {
                        HStack {
                            Text(selectedImage == nil ? "Select Image" : "Change Image")
                            Spacer()
                            if let image = selectedImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 60)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Create Listing")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Post") { createProduct() }
                        .disabled(!isFormValid)
                }
            }
            .sheet(isPresented: $showImagePicker) {
//                ImagePicker(image: $selectedImage)
            }
        }
    }
    
    private var isFormValid: Bool {
        !title.isEmpty && !price.isEmpty && !description.isEmpty && selectedImage != nil
    }
    
    private func createProduct() {
        // This will be implemented later with backend
        // For now, just dismiss the view
        dismiss()
    }
}

// MARK: - Preview
struct CreateProductView_Previews: PreviewProvider {
    static var previews: some View {
        CreateProductView()
    }
} 
