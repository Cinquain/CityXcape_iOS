//
//  Product.swift
//  CityXcape
//
//  Created by James Allan on 6/13/22.
//

import Foundation


struct Product: Equatable, Hashable, Identifiable {
    var id: String
    var name: String
    var imageNames: [String]
    var price: Double
    var description: String
    
    static func == (lhs: Product, rhs: Product) -> Bool {
        lhs.id == rhs.id
    }
    
    static let demo = Product(id: "com.cityportal.CityXcape.streetcred", name: "100 StreetCred", imageNames: ["StoreSTC"], price: 9.99, description: "Get 100 StreetCred to save secret spots, message users, and utilize other CityXcape features.")
}


