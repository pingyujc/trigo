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
    
    // initializer
    init(id: String = UUID().uuidString,
         title: String,
         price: Double,
         description: String,
         image: String) {
        self.id = id
        self.title = title
        self.price = price
        self.description = description
        self.image = image
    }
}
