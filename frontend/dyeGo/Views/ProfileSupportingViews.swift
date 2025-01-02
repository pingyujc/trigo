import SwiftUI

struct ProfileHeader: View {
    let user: User
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "person.circle.fill")
                .font(.system(size: 64))
                .foregroundColor(.blue)
            
            Text(user.name)
                .font(.title2)
            
            Text(user.email)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
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

struct OrderListView: View {
    let orders: [Order]
    
    var body: some View {
        List(orders) { order in
            Text("Order #\(order.id)")
        }
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