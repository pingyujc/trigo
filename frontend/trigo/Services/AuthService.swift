import Foundation
import FirebaseAuth
import GoogleSignIn
import FirebaseFirestore
import FirebaseCore

enum AuthError: LocalizedError {
    case clientIDNotFound
    case signInFailed
    case userCreationFailed
    case userNotFound
    
    var errorDescription: String? {
        switch self {
        case .clientIDNotFound:
            return "Google Sign In configuration not found"
        case .signInFailed:
            return "Failed to sign in"
        case .userCreationFailed:
            return "Failed to create user"
        case .userNotFound:
            return "User not found"
        }
    }
}

@MainActor
class AuthService: ObservableObject {
    static let shared = AuthService()
    private let db = Firestore.firestore()
    
    @Published var currentUser: User?
    @Published var isAuthenticated = false
    
    private init() {
        // Set up auth state listener
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            Task { @MainActor in
                if let user = user {
                    do {
                        try await self?.fetchUserAndUpdate(userId: user.uid)
                    } catch {
                        print("Error fetching user: \(error)")
                        self?.currentUser = nil
                        self?.isAuthenticated = false
                    }
                } else {
                    self?.currentUser = nil
                    self?.isAuthenticated = false
                }
            }
        }
    }
    
    // MARK: - Google Sign In
    func signInWithGoogle() async throws -> User {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            throw AuthError.clientIDNotFound
        }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let windowScene = await UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = await windowScene.windows.first,
              let rootViewController = await window.rootViewController else {
            throw AuthError.signInFailed
        }
        
        // Start Google Sign In flow
        let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
        
        guard let idToken = result.user.idToken?.tokenString else {
            throw AuthError.signInFailed
        }
        
        // Create Firebase credential
        let credential = GoogleAuthProvider.credential(
            withIDToken: idToken,
            accessToken: result.user.accessToken.tokenString
        )
        
        // Sign in to Firebase
        let authResult = try await Auth.auth().signIn(with: credential)
        
        // Create or fetch user
        let user = try await createOrFetchUser(from: authResult.user)
        
        // Update on main thread
        await MainActor.run {
            self.currentUser = user
            self.isAuthenticated = true
        }
        
        return user
    }
    
    // MARK: - Email Sign In/Up
    func signUp(email: String, password: String, name: String, username: String) async throws -> User {
        let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
        
        let user = User(
            id: authResult.user.uid,
            name: name,
            email: email,
            username: username
        )
        
        try await createUser(user)
        
        // Update on main thread
        await MainActor.run {
            self.currentUser = user
            self.isAuthenticated = true
        }
        
        return user
    }
    
    func signIn(email: String, password: String) async throws -> User {
        let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
        let user = try await fetchUser(userId: authResult.user.uid)
        
        // Update on main thread
        await MainActor.run {
            self.currentUser = user
            self.isAuthenticated = true
        }
        
        return user
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
        // These updates are already on main thread since function is @MainActor
        self.currentUser = nil
        self.isAuthenticated = false
    }
    
    // MARK: - Helper Methods
    private func fetchUserAndUpdate(userId: String) async throws {
        let user = try await fetchUser(userId: userId)
        // Update on main thread
        self.currentUser = user
        self.isAuthenticated = true
    }
    
    private func createOrFetchUser(from firebaseUser: FirebaseAuth.User) async throws -> User {
        // Try to fetch existing user
        do {
            return try await fetchUser(userId: firebaseUser.uid)
        } catch AuthError.userNotFound {
            // Create new user if not found
            let newUser = User(
                id: firebaseUser.uid,
                name: firebaseUser.displayName ?? "User",
                email: firebaseUser.email ?? "",
                username: firebaseUser.email?.components(separatedBy: "@").first ?? "user"
            )
            
            try await createUser(newUser)
            return newUser
        }
    }
    
    private func fetchUser(userId: String) async throws -> User {
        let snapshot = try await db.collection("users")
            .document(userId)
            .getDocument()
        
        guard let data = snapshot.data() else {
            throw AuthError.userNotFound
        }
        
        return User(
            id: userId,  // Use the known userId instead of trying to decode it
            name: data["name"] as? String ?? "",
            email: data["email"] as? String ?? "",
            username: data["username"] as? String ?? ""
        )
    }
    
    private func createUser(_ user: User) async throws {
        guard let userId = user.id else {
            throw AuthError.userCreationFailed
        }
        
        // Create a copy of the user without an ID
        var newUser = user
        newUser.id = nil  // Clear the ID so Firestore doesn't try to encode it
        
        // Encode the user using Firestore.Encoder
        let userData = try Firestore.Encoder().encode(newUser)
        
        // Set the document with explicit ID
        try await db.collection("users")
            .document(userId)
            .setData(userData)
    }
} 
