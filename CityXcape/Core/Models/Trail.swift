//
//  Trail.swift
//  CityXcape
//
//  Created by James Allan on 6/17/22.
//

import Foundation


struct Trail: Identifiable, Equatable {
    
    var id: String
    var name: String
    var imageUrls: [String]
    var description: String
    var ownerId: String
    var ownerDisplayName: String
    var ownerImageUrl: String
    var ownerRank: String
    var price: Int
    var spots: [SecretSpot]
    var users: [User]
    
    
    var startTime: Date?
    var endTime: Date?
    var longitude: Double?
    var latitude: Double?
    
    static func == (lhs: Trail, rhs: Trail) -> Bool {
        lhs.id == rhs.id
    }
    
}
