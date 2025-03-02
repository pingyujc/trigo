//
//  CreateProductView.swift
//  trigo
//
//  Created by Jonathan Chen on 2/28/25.
//

import SwiftUI

struct CreateProductView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var productViewModel: ProductViewModel
    
    // Form fields
    @State private var title = ""
    @State private var description = ""
    @State private var selectedCategory: Category = .other
    @State private var selectedCountry: Country = .unitedStates
    @State private var image = "placeholder-image"
    
    // Image picker states
    @State private var selectedUIImage: UIImage?
    @State private var isImagePickerPresented = false
    
    var body: some View {
        NavigationView {
            Form {
                // Title
                Section(header: Text("Title")) {
                    TextField("Enter product title", text: $title)
                }
                
                // Description
                Section(header: Text("Description")) {
                    TextEditor(text: $description)
                        .frame(height: 100)
                        .placeholder(when: description.isEmpty) {
                            Text("Describe your product...")
                                .foregroundColor(.gray)
                        }
                }
                
                // Category
                Section(header: Text("Category")) {
                    Picker("Select Category", selection: $selectedCategory) {
                        ForEach(Category.allCases, id: \.self) { category in
                            Text(category.rawValue.capitalized)
                                .tag(category)
                        }
                    }
                }
                
                // Country
                Section(header: Text("Country")) {
                    Picker("Select Country", selection: $selectedCountry) {
                        ForEach(Country.allCases, id: \.self) { country in
                            Text(country.rawValue)
                                .tag(country)
                        }
                    }
                }
                
                // Image Selection
                Section(header: Text("Product Image")) {
//                    VStack {
//                        if let image = selectedUIImage {
//                            Image(uiImage: image)
//                                .resizable()
//                                .scaledToFit()
//                                .frame(height: 200)
//                                .frame(maxWidth: .infinity)
//                                .clipShape(RoundedRectangle(cornerRadius: 10))
//                        } else {
//                            Image(systemName: "photo")
//                                .resizable()
//                                .scaledToFit()
//                                .frame(height: 200)
//                                .frame(maxWidth: .infinity)
//                                .foregroundColor(.gray)
//                        }
//                        
//                        Button(action: {
//                            isImagePickerPresented = true
//                        }) {
//                            HStack {
//                                Image(systemName: "photo.fill")
//                                Text(selectedUIImage == nil ? "Select Image" : "Change Image")
//                            }
//                            .frame(maxWidth: .infinity)
//                        }
//                        .buttonStyle(.bordered)
//                        .padding(.top, 8)
//                    }
                }
            }
            .navigationTitle("Create Product")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Create") {
                        createProduct()
                    }
                    .disabled(!isValid)
                }
            }
//            .sheet(isPresented: $isImagePickerPresented) {
//                ImagePicker(selectedImage: $selectedUIImage)
//            }
        }
    }
    
    private var isValid: Bool {
        !title.isEmpty && !description.isEmpty  // Remove image requirement
    }
    
    private func createProduct() {
        let newProduct = Product(
            id: UUID().uuidString,
            title: title,
            description: description,
            category: selectedCategory,
            country: selectedCountry,
            image: title.lowercased().replacingOccurrences(of: " ", with: "-"),  // Use title as image name
            viewCount: 0,
            favoriteCount: 0,
            listings: [],
            requests: []
        )
        
        Task {
            do {
                try await productViewModel.createProduct(newProduct)
                dismiss()
            } catch {
                print("Error creating product: \(error)")
            }
        }
    }
}

#Preview {
    CreateProductView()
        .environmentObject(ProductViewModel())
}

