import SwiftUI

struct ProfileHeader: View {
    let user: User
    
    var body: some View {
        HStack(spacing: 16) {
            // Profile Image
            Image(systemName: "person.crop.circle.fill")
                .font(.system(size: 64))
                .foregroundColor(.black)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(user.name)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.black)
                
                Text(user.email)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                
                // Member since
                Text("Member since 2024")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                    .padding(.top, 4)
            }
            
            Spacer()
        }
        .padding(16)
        .background(Color.customBackgroundSecondary)
        .cornerRadius(12)
    }
}

// Placeholder views - implement these later with actual content
struct EditProfileView: View {
    var body: some View {
        Text("Edit Profile")
            .navigationTitle("Edit Profile")
    }
}

struct PaymentMethodsView: View {
    var body: some View {
        Text("Payment Methods")
            .navigationTitle("Payment Methods")
    }
}

struct PreferencesView: View {
    var body: some View {
        Text("Preferences")
            .navigationTitle("Preferences")
    }
}

struct ActiveOrdersView: View {
    var body: some View {
        Text("Active Orders")
            .navigationTitle("Active Orders")
    }
}

struct OrderHistoryView: View {
    var body: some View {
        Text("Order History")
            .navigationTitle("Order History")
    }
}

struct ListedItemsView: View {
    var body: some View {
        Text("Listed Items")
            .navigationTitle("Listed Items")
    }
}

struct SalesHistoryView: View {
    var body: some View {
        Text("Sales History")
            .navigationTitle("Sales History")
    }
}

struct EarningsView: View {
    var body: some View {
        Text("Earnings")
            .navigationTitle("Earnings")
    }
} 