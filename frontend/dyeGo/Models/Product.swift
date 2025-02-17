//
//  Product.swift
//  dyeGo
//
//  Created by Jonathan Chen on 2/9/25.
//

import Foundation
// identifiable makes it able to use ID
// codable is for fireBase and api in the future
struct Product: Identifiable, Codable {
    let id: String
    let title: String
    let price: Double
    let description: String
    let image: String
    let country: Country
    let category: Category
    let sellerId: String
    let createdAt: Date
    var isAvailable: Bool
    var viewCount: Int
    var likeCount: Int
    
    // initializer
    init(id: String = UUID().uuidString,
         title: String,
         price: Double,
         description: String,
         image: String,
         country: Country = .unitedStates,
         category: Category = .clothing,
         sellerId: String = "",
         createdAt: Date = Date(),
         isAvailable: Bool = true,
         viewCount: Int = 0,
         likeCount: Int = 0) {
        self.id = id
        self.title = title
        self.price = price
        self.description = description
        self.image = image
        self.country = country
        self.category = category
        self.sellerId = sellerId
        self.createdAt = createdAt
        self.isAvailable = isAvailable
        self.viewCount = viewCount
        self.likeCount = likeCount
    }
}
