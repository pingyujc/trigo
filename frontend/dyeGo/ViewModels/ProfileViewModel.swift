import Foundation

class ProfileViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var user: User
    @Published var activeOrders: [Order] = []
    
    init() {
        // Temporary initialization with mock data
        self.user = User(
            id: "1",
            name: "Test User",
            email: "test@example.com",
            isSeller: false
        )
        
        // TODO: Replace with actual authentication check
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