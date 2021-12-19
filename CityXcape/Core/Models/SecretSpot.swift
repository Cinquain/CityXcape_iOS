//
//  SecretSpot.swift
//  CityXcape
//
//  Created by James Allan on 8/19/21.
//

import Foundation
import MapKit
import CoreLocation
import SwiftUI

struct SecretSpot:  Hashable, Codable {
    
    
   
    let postId: String
    var spotName: String
    var imageUrls: [String]
    var longitude: Double
    var latitude: Double
    var address: String
    var city: String
    var zipcode: Int
    var world: String
    
    let dateCreated: Date
    var viewCount: Int
    var price: Int
    var saveCounts: Int
    var isPublic: Bool

    var description: String?
    
    let ownerId: String
    var ownerDisplayName: String
    var ownerImageUrl: String
    

    enum CodingKeys: String, CodingKey {
        case postId = "spot_id"
        case spotName = "spot_name"
        case imageUrls = "spot_image_url"
        case longitude = "longitude"
        case latitude = "latitude"
        case description = "description"
        case city = "city"
        case dateCreated = "date_created"
        case ownerId = "owner_id"
        case ownerDisplayName = "ownerDisplayName"
        case ownerImageUrl = "ownerImageUrl"
        case address = "address"
        case zipcode = "zipcode"
        case saveCounts = "save_count"
        case viewCount = "view_count"
        case price = "price"
        case world = "world"
        case isPublic = "public"
    }
    
    
    var distanceFromUser: Double {
        let manager = LocationService.instance.manager
        
        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
            let destination = CLLocation(latitude: latitude, longitude: longitude)
            let userlocation = CLLocation(latitude: (manager.location?.coordinate.latitude)!, longitude: (manager.location?.coordinate.longitude)!)
            return userlocation.distance(from: destination) * 0.000621
        } else {
            manager.requestWhenInUseAuthorization()
            return 0
        }

    }
 
    func hash(into hasher: inout Hasher) {
        hasher.combine(postId)
    }
    
    static func == (lhs: SecretSpot, rhs: SecretSpot) -> Bool {
        lhs.postId == rhs.postId
    }
    
    
}
