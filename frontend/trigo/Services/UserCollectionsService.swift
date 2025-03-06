import Foundation
import FirebaseFirestore

class UserCollectionsService {
    static let shared = UserCollectionsService()
    private let db = Firestore.firestore()
    
    private init() {}
    
    // MARK: - Listings
    func addListing(userId: String, productId: String, listingId: String) async throws {
        let userListing = UserListing(
            productId: productId,
            listingId: listingId,
            createdAt: Date()
        )
        try await User.listingsCollection(for: userId).addDocument(data: try userListing.asDictionary())
    }
    
    func removeListing(userId: String, listingId: String) async throws {
        let snapshot = try await User.listingsCollection(for: userId)
            .whereField("listingId", isEqualTo: listingId)
            .getDocuments()
        
        for document in snapshot.documents {
            try await document.reference.delete()
        }
    }
    
    func getUserListings(userId: String) async throws -> [UserListing] {
        let snapshot = try await User.listingsCollection(for: userId)
            .order(by: "createdAt", descending: true)
            .getDocuments()
        
        return try snapshot.documents.map { try $0.data(as: UserListing.self) }
    }
    
    // MARK: - Requests
    func addRequest(userId: String, productId: String, requestId: String) async throws {
        let userRequest = UserRequest(
            productId: productId,
            requestId: requestId,
            createdAt: Date()
        )
        try await User.requestsCollection(for: userId).addDocument(data: try userRequest.asDictionary())
    }
    
    func removeRequest(userId: String, requestId: String) async throws {
        let snapshot = try await User.requestsCollection(for: userId)
            .whereField("requestId", isEqualTo: requestId)
            .getDocuments()
        
        for document in snapshot.documents {
            try await document.reference.delete()
        }
    }
    
    func getUserRequests(userId: String) async throws -> [UserRequest] {
        let snapshot = try await User.requestsCollection(for: userId)
            .order(by: "createdAt", descending: true)
            .getDocuments()
        
        return try snapshot.documents.map { try $0.data(as: UserRequest.self) }
    }
    
    // MARK: - Favorites
    func addFavorite(userId: String, productId: String) async throws {
        let userFavorite = UserFavorite(
            productId: productId,
            addedAt: Date()
        )
        try await User.favoritesCollection(for: userId).addDocument(data: try userFavorite.asDictionary())
    }
    
    func removeFavorite(userId: String, productId: String) async throws {
        let snapshot = try await User.favoritesCollection(for: userId)
            .whereField("productId", isEqualTo: productId)
            .getDocuments()
        
        for document in snapshot.documents {
            try await document.reference.delete()
        }
    }
    
    func getUserFavorites(userId: String) async throws -> [UserFavorite] {
        let snapshot = try await User.favoritesCollection(for: userId)
            .order(by: "addedAt", descending: true)
            .getDocuments()
        
        return try snapshot.documents.map { try $0.data(as: UserFavorite.self) }
    }
    
    func isProductFavorited(userId: String, productId: String) async throws -> Bool {
        let snapshot = try await User.favoritesCollection(for: userId)
            .whereField("productId", isEqualTo: productId)
            .limit(to: 1)
            .getDocuments()
        
        return !snapshot.documents.isEmpty
    }
}

// Helper extension for Codable
extension Encodable {
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to convert to dictionary"])
        }
        return dictionary
    }
} 