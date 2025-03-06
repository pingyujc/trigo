import Foundation
import FirebaseFirestore

// Reference to a listing in a user's listings subcollection
struct UserListing: Identifiable, Codable {
    @DocumentID var id: String?
    let productId: String
    let listingId: String  // Reference to products/{productId}/listings/{listingId}
    let createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case productId
        case listingId
        case createdAt
    }
}

// Reference to a request in a user's requests subcollection
struct UserRequest: Identifiable, Codable {
    @DocumentID var id: String?
    let productId: String
    let requestId: String  // Reference to products/{productId}/requests/{requestId}
    let createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case productId
        case requestId
        case createdAt
    }
}

// A favorite product in a user's favorites subcollection
struct UserFavorite: Identifiable, Codable {
    @DocumentID var id: String?
    let productId: String
    let addedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case productId
        case addedAt
    }
} 