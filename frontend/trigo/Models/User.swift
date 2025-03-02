// Move User model to its own file
struct User: Identifiable, Codable {
    let id: String
    var name: String
    var email: String
    var isSeller: Bool
    var rating: Double?
} 