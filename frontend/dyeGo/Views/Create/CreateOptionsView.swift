import SwiftUI

struct CreateOptionsView: View {
    @State private var showingListingSheet = false
    @State private var showingRequestSheet = false
    @EnvironmentObject var productViewModel: ProductViewModel
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("What would you like to create?")
                    .font(.headline)
                    .padding(.top, 30)
                
                NavigationLink(destination: CreateListingView()) {
                    HStack {
                        Image(systemName: "tag.fill")
                            .font(.title2)
                        VStack(alignment: .leading) {
                            Text("Make a Listing")
                                .font(.headline)
                            Text("Sell an item to potential buyers")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(10)
                    .shadow(radius: 2)
                }
                
                NavigationLink(destination: CreateRequestView()) {
                    HStack {
                        Image(systemName: "hand.raised.fill")
                            .font(.title2)
                        VStack(alignment: .leading) {
                            Text("Make a Request")
                                .font(.headline)
                            Text("Request an item you're looking for")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(10)
                    .shadow(radius: 2)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Create")
            .sheet(isPresented: $showingListingSheet) {
                CreateListingView()
                    .environmentObject(productViewModel)
            }
            .sheet(isPresented: $showingRequestSheet) {
                CreateRequestView()
                    .environmentObject(productViewModel)
            }
        }
    }
}

struct CreateOptionsView_Previews: PreviewProvider {
    static var previews: some View {
        CreateOptionsView()
    }
} 
