import Foundation
import SwiftUI

class ProfileViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var user: User
    @Published var activeOrders: [Order] = []
    
    init() {
        // Initialize with mock data
        self.user = User(
            id: "1",
            name: "Test User",
            email: "test@example.com",
            username: "testuser"
        )
        
        checkAuthStatus()
    }
    
    private func checkAuthStatus() {
        // TODO: Implement actual auth check
        isLoggedIn = false
    }
    
    func signOut() {
        // TODO: Implement actual sign out
        isLoggedIn = false
    }
    
    func startSellerOnboarding() {
        // TODO: Implement seller onboarding
    }
}

// Temporary Order model for compilation
struct Order: Identifiable {
    let id: String
    // Add other order properties as needed
} 
