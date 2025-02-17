import SwiftUI

struct CreateOptionsView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("What would you like to create?")
                    .font(.headline)
                    .padding(.top, 30)
                
                NavigationLink(destination: CreateProductView()) {
                    HStack {
                        Image(systemName: "tag.fill")
                            .font(.title2)
                        VStack(alignment: .leading) {
                            Text("List a Product")
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
        }
    }
}

struct CreateOptionsView_Previews: PreviewProvider {
    static var previews: some View {
        CreateOptionsView()
    }
} 