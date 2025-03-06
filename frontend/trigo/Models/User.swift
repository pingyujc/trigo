import Foundation
import FirebaseFirestore

// Move User model to its own file
struct User: Identifiable, Codable {
    @DocumentID var id: String?    // Firebase document ID
    var name: String
    var email: String
    var username: String
    
    // Initialize with default values
    init(id: String? = nil,
         name: String,
         email: String,
         username: String) {
        self.id = id
        self.name = name
        self.email = email
        self.username = username
    }
    
    // MARK: - Firestore Collection References
    
    // the listings created by this user
    static func listingsCollection(for userId: String) -> CollectionReference {
        return Firestore.firestore().collection("users").document(userId).collection("listings")
    }
    
    // the requests made by this user
    static func requestsCollection(for userId: String) -> CollectionReference {
        return Firestore.firestore().collection("users").document(userId).collection("requests")
    }
    
    // the favorites
    static func favoritesCollection(for userId: String) -> CollectionReference {
        return Firestore.firestore().collection("users").document(userId).collection("favorites")
    }
    
    // MARK: - Helper Methods
    var listingsRef: CollectionReference? {
        guard let userId = id else { return nil }
        return User.listingsCollection(for: userId)
    }
    
    var requestsRef: CollectionReference? {
        guard let userId = id else { return nil }
        return User.requestsCollection(for: userId)
    }
    
    var favoritesRef: CollectionReference? {
        guard let userId = id else { return nil }
        return User.favoritesCollection(for: userId)
    }
} 
