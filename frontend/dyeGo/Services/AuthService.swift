import Foundation

class AuthService: ObservableObject {
    @Published var currentUser: User?
    @Published var isAuthenticated = false
    
    func signIn(email: String, password: String) async throws {
        // TODO: Implement authentication
    }
    
    func signUp(email: String, password: String) async throws {
        // TODO: Implement user creation
    }
    
    func signOut() async throws {
        // TODO: Implement sign out
    }
} 