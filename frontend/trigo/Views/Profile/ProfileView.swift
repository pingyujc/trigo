import SwiftUI

struct ProfileView: View {
    @StateObject private var authService = AuthService.shared
    
    var body: some View {
        NavigationView {
            if authService.isAuthenticated {
                ScrollView {
                    VStack(spacing: 0) {
                        // Header
                        Text("PROFILE")
                            .font(.system(size: 28, weight: .bold))
                            .tracking(2)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.top, 16)
                            .padding(.bottom, 24)
                        
                        // Profile Header
                        if let user = authService.currentUser {
                            ProfileHeader(user: user)
                                .padding(.horizontal)
                                .padding(.bottom, 32)
                        }
                        
                        // Profile Sections
                        VStack(spacing: 24) {
                            profileSection(title: "Account Settings", items: [
                                ProfileMenuItem(title: "Edit Profile", icon: "person.crop.circle"),
                                ProfileMenuItem(title: "Payment Methods", icon: "creditcard"),
                                ProfileMenuItem(title: "Preferences", icon: "gear")
                            ])
                            
                            profileSection(title: "Orders", items: [
                                ProfileMenuItem(title: "Active Orders", icon: "clock"),
                                ProfileMenuItem(title: "Order History", icon: "clock.arrow.circlepath")
                            ])
                            
                            profileSection(title: "Seller Dashboard", items: [
                                ProfileMenuItem(title: "Listed Items", icon: "tag"),
                                ProfileMenuItem(title: "Sales History", icon: "chart.bar"),
                                ProfileMenuItem(title: "Earnings", icon: "dollarsign.circle")
                            ])
                            
                            // Sign Out Button
                            Button(action: signOut) {
                                Text("Sign Out")
                                    .font(.system(size: 16, weight: .bold))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .foregroundColor(.white)
                                    .background(Color.black)
                                    .cornerRadius(30)
                            }
                            .padding(.horizontal)
                            .padding(.top, 16)
                            .padding(.bottom, 40)
                        }
                    }
                }
                .background(Color.white)
            } else {
                LoginPromptView(destination: .profile)
            }
        }
        .onAppear {
            // Debug logging
            print("ProfileView appeared - isAuthenticated: \(authService.isAuthenticated)")
            print("ProfileView appeared - currentUser: \(String(describing: authService.currentUser?.name))")
        }
        .onChange(of: authService.isAuthenticated) { isAuth in
            print("ProfileView - isAuthenticated changed to: \(isAuth)")
        }

    }
    
    private func signOut() {
        do {
            try authService.signOut()
            print("ProfileView - Sign out successful")
            // AuthService automatically updates isAuthenticated - no need for manual updates
        } catch {
            print("ProfileView - Sign out error: \(error.localizedDescription)")
        }
    }
    
    @ViewBuilder
    private func profileSection(title: String, items: [ProfileMenuItem]) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            // Section Title
            Text(title.uppercased())
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.gray)
                .tracking(1.5)
                .padding(.horizontal)
                .padding(.bottom, 16)
            
            // Menu Items
            ForEach(items, id: \.title) { item in
                NavigationLink(destination: destinationView(for: item.title)) {
                    HStack(spacing: 16) {
                        Image(systemName: item.icon)
                            .font(.system(size: 18))
                            .foregroundColor(.black)
                            .frame(width: 24, height: 24)
                        
                        Text(item.title)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.black)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 14)
                    .padding(.horizontal)
                }
                .buttonStyle(PlainButtonStyle())
                
                Divider()
                    .padding(.leading, 56)
            }
        }
    }
    
    @ViewBuilder
    private func destinationView(for title: String) -> some View {
        switch title {
        case "Edit Profile":
            EditProfileView()
        case "Payment Methods":
            PaymentMethodsView()
        case "Preferences":
            PreferencesView()
        case "Active Orders":
            ActiveOrdersView()
        case "Order History":
            OrderHistoryView()
        case "Listed Items":
            ListedItemsView()
        case "Sales History":
            SalesHistoryView()
        case "Earnings":
            EarningsView()
        default:
            EmptyView()
        }
    }
}

struct ProfileMenuItem {
    let title: String
    let icon: String
}

// Add preview provider
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
} 

