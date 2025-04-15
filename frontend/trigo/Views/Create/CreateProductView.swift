//
//  CreateProductView.swift
//  trigo
//
//  Created by Jonathan Chen on 2/28/25.
//

import SwiftUI
import PhotosUI
import FirebaseStorage

struct CreateProductView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var productViewModel: ProductViewModel
    
    // Form fields
    @State private var title = ""
    @State private var description = ""
    @State private var selectedCategory: Category = .other
    @State private var selectedCountry: Country = .unitedStates
    
    // Image picker states
    @State private var selectedImages: [UIImage] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var showError = false
    
    // PhotosPicker selection state
    @State private var selectedItems: [PhotosPickerItem] = []
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 8) {
                    Text("CREATE PRODUCT")
                        .font(.system(size: 28, weight: .bold))
                        .tracking(2)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .padding(.top, 16)
                .padding(.bottom, 32)
                
                // Form Fields
                VStack(spacing: 24) {
                    // Title field
                    formField(
                        title: "PRODUCT TITLE",
                        content: {
                            TextField("Enter product title", text: $title)
                                .font(.system(size: 16))
                                .padding()
                                .background(Color.customBackgroundSecondary)
                                .cornerRadius(8)
                        }
                    )
                    // Image Selection
                    formField(
                        title: "PRODUCT IMAGES",
                        content: {
                            VStack(spacing: 12) {
                                // Image preview
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 10) {
                                        if selectedImages.isEmpty {
                                            imagePreviewPlaceholder
                                        } else {
                                            ForEach(0..<selectedImages.count, id: \.self) { index in
                                                imagePreview(image: selectedImages[index], index: index)
                                            }
                                        }
                                    }
                                    .padding(.horizontal, 4)
                                }
                                .frame(height: 120)
                                
                                // PhotosPicker
                                PhotosPicker(
                                    selection: $selectedItems,
                                    maxSelectionCount: 5,
                                    matching: .images
                                ) {
                                    Text("Select Images")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 12)
                                        .background(Color.black)
                                        .cornerRadius(8)
                                }
                            }
                        }
                    )
                    // Description field
                    formField(
                        title: "DESCRIPTION",
                        content: {
                            ZStack(alignment: .topLeading) {
                                TextEditor(text: $description)
                                    .font(.system(size: 16))
                                    .frame(height: 120)
                                    .padding(4)
                                    .background(Color.customBackgroundSecondary)
                                    .cornerRadius(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                    )
                                
                                if description.isEmpty {
                                    Text("Describe your product...")
                                        .font(.system(size: 16))
                                        .foregroundColor(.gray)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 16)
                                        .allowsHitTesting(false)
                                }
                            }
                        }
                    )
                    
                    // Category field
                    formField(
                        title: "CATEGORY",
                        content: {
                            Menu {
                                ForEach(Category.allCases, id: \.self) { category in
                                    Button {
                                        selectedCategory = category
                                    } label: {
                                        Text(category.rawValue.capitalized)
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(selectedCategory.rawValue.capitalized)
                                        .font(.system(size: 16))
                                        .foregroundColor(.black)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                .background(Color.customBackgroundSecondary)
                                .cornerRadius(8)
                            }
                        }
                    )
                    
                    // Country field
                    formField(
                        title: "COUNTRY",
                        content: {
                            Menu {
                                ForEach(Country.allCases, id: \.self) { country in
                                    Button {
                                        selectedCountry = country
                                    } label: {
                                        Text(country.rawValue)
                                    }
                                } 
                            } label: {
                                HStack {
                                    Text(selectedCountry.rawValue)
                                        .font(.system(size: 16))
                                        .foregroundColor(.black)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                .background(Color.customBackgroundSecondary)
                                .cornerRadius(8)
                            }
                        }
                    )
                    
                    // Create Button
                    Button(action: createProduct) {
                        if isLoading {
                            ProgressView()
                                .tint(.white)
                                .scaleEffect(1.2)
                        } else {
                            Text("Create Product")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(isValid ? Color.black : Color.gray)
                    .cornerRadius(30)
                    .disabled(!isValid || isLoading)
                    .padding(.top, 16)
                    
                    // Cancel Button
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
                    .disabled(isLoading)
                }
                .padding(.horizontal, 20)
            }
            .background(Color.white)
        }
        .navigationBarHidden(true)
        .onChange(of: selectedItems) { newItems in
            Task {
                await loadSelectedImages(from: newItems)
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
    
    private var imagePreviewPlaceholder: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(Color.customBackgroundSecondary)
            .frame(width: 120, height: 120)
            .overlay(
                VStack(spacing: 8) {
                    Image(systemName: "photo")
                        .font(.system(size: 24))
                        .foregroundColor(.gray)
                    
                    Text("No Images")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
            )
    }
    
    private func imagePreview(image: UIImage, index: Int) -> some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFill()
            .frame(width: 120, height: 120)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
            .overlay(
                Button(action: {
                    selectedImages.remove(at: index)
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .background(Circle().fill(Color.black.opacity(0.7)))
                }
                .padding(5),
                alignment: .topTrailing
            )
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
    
    private var isValid: Bool {
        !title.isEmpty && !description.isEmpty && !selectedImages.isEmpty
    }
    
    private func loadSelectedImages(from items: [PhotosPickerItem]) async {
        var newImages: [UIImage] = []
        
        for item in items {
            if let data = try? await item.loadTransferable(type: Data.self),
               let image = UIImage(data: data) {
                newImages.append(image)
            }
        }
        
        // Update UI on main thread
        DispatchQueue.main.async {
            self.selectedImages = newImages
        }
    }
    
    private func createProduct() {
        guard !selectedImages.isEmpty else {
            errorMessage = "Please select at least one image"
            showError = true
            return
        }
        
        isLoading = true
        
        Task {
            do {
                // 1. Upload images to Firebase Storage and get URLs
                let imageUrls = try await uploadImages(selectedImages)
                
                // 2. Create product with image URLs
                let newProduct = Product(
                    title: title,
                    description: description,
                    category: selectedCategory,
                    country: selectedCountry,
                    imageUrls: imageUrls,
                    viewCount: 0,
                    favoriteCount: 0,
                    listings: [],
                    requests: []
                )
                
                // 3. Save product to Firestore
                try await productViewModel.createProduct(newProduct)
                
                // 4. Dismiss view on successful creation
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.dismiss()
                }
            } catch {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.errorMessage = error.localizedDescription
                    self.showError = true
                }
            }
        }
    }
    
    private func uploadImages(_ images: [UIImage]) async throws -> [String] {
        var urls: [String] = []
        
        // Create a reference to Firebase Storage
        let storage = Storage.storage()
        
        for (index, image) in images.enumerated() {
            // 1. Compress the image
            guard let imageData = image.jpegData(compressionQuality: 0.7) else {
                throw NSError(domain: "app.trigo", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to compress image"])
            }
            
            // 2. Create a unique path for the image
            let uuid = UUID().uuidString
            let imagePath = "products/\(uuid)-\(index).jpg"
            let storageRef = storage.reference().child(imagePath)
            
            // 3. Upload the image
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            // 4. Upload and await the result
            _ = try await storageRef.putDataAsync(imageData, metadata: metadata)
            
            // 5. Get the download URL
            let downloadURL = try await storageRef.downloadURL()
            urls.append(downloadURL.absoluteString)
        }
        
        return urls
    }
}

#Preview {
    CreateProductView()
        .environmentObject(ProductViewModel())
}

