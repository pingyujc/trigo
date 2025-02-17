import SwiftUI

struct CreateRequestView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    @State private var maxBudget = ""
    @State private var description = ""
    @State private var selectedCategory: Category = .clothing
    @State private var selectedCountry: Country = .taiwan
    @State private var showImagePicker = false
    @State private var referenceImage: UIImage?
    @State private var urgencyLevel: UrgencyLevel = .normal
    
    enum UrgencyLevel: String, CaseIterable {
        case low = "Low"
        case normal = "Normal"
        case high = "High"
        
        var name: String { return self.rawValue }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("What are you looking for?") {
                    TextField("Title", text: $title)
                        .textInputAutocapitalization(.never)
                    TextField("Maximum Budget", text: $maxBudget)
                        .keyboardType(.decimalPad)
                    TextEditor(text: $description)
                        .frame(height: 100)
                }
                
                Section("Details") {
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(Category.allCases, id: \.self) { category in
                            Text(category.name).tag(category)
                        }
                    }
                    
                    Picker("Preferred Country", selection: $selectedCountry) {
                        ForEach(Country.allCases, id: \.self) { country in
                            Text(country.name).tag(country)
                        }
                    }
                    
                    Picker("Urgency Level", selection: $urgencyLevel) {
                        ForEach(UrgencyLevel.allCases, id: \.self) { level in
                            Text(level.name).tag(level)
                        }
                    }
                }
                
                Section("Reference Image (Optional)") {
                    Button(action: { showImagePicker = true }) {
                        HStack {
                            Text(referenceImage == nil ? "Add Reference Image" : "Change Image")
                            Spacer()
                            if let image = referenceImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 60)
                                    .cornerRadius(8)
                            }
                        }
                    }
                }
                
                Section("Note") {
                    Text("Sellers will be able to respond to your request with their offers.")
                        .foregroundColor(.gray)
                        .font(.footnote)
                }
            }
            .navigationTitle("Create Request")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Post Request") { createRequest() }
                        .disabled(!isFormValid)
                }
            }
            .sheet(isPresented: $showImagePicker) {
//                ImagePicker(image: $referenceImage)
            }
        }
    }
    
    private var isFormValid: Bool {
        !title.isEmpty && 
        !maxBudget.isEmpty && 
        !description.isEmpty &&
        Double(maxBudget) != nil // Ensures budget is a valid number
    }
    
    private func createRequest() {
        // This will be implemented later with backend
        // For now, just dismiss the view
        dismiss()
    }
}

struct CreateRequestView_Previews: PreviewProvider {
    static var previews: some View {
        CreateRequestView()
    }
} 
