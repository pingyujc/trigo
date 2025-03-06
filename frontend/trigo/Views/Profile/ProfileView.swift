import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    
    var body: some View {
        NavigationView {
            if viewModel.isLoggedIn {
                List {
                    // Profile Header
                    ProfileHeader(user: viewModel.user)
                    
                    // Account Settings
                    Section("Account Settings") {
                        NavigationLink("Edit Profile") {
                            EditProfileView()
                        }
                        NavigationLink("Payment Methods") {
                            PaymentMethodsView()
                        }
                        NavigationLink("Preferences") {
                            PreferencesView()
                        }
                    }
                    
                    // Orders Section
                    Section("Orders") {
                        NavigationLink("Active Orders (\(viewModel.activeOrders.count))") {
                            OrderListView(orders: viewModel.activeOrders)
                        }
                        NavigationLink("Order History") {
                            OrderHistoryView()
                        }
                    }
                    

                    Section("Seller Dashboard") {
                        NavigationLink("Listed Items") {
                            ListedItemsView()
                        }
                        NavigationLink("Sales History") {
                            SalesHistoryView()
                        }
                        NavigationLink("Earnings") {
                            EarningsView()
                        }
                    }

                    
                    // Sign Out
                    Section {
                        Button("Sign Out", role: .destructive) {
                            viewModel.signOut()
                        }
                    }
                }
                .navigationTitle("Profile")
            } else {
                LoginPromptView(destination: .profile)
            }
        }
    }
}

// Add preview provider
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
} 
