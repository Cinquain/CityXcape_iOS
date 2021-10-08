//
//  SecretSpot.swift
//  CityXcape
//
//  Created by James Allan on 8/19/21.
//

import Foundation
import MapKit
import CoreLocation

struct SecretSpot:  Hashable, Codable {
    
    var postId: String
    let spotName: String
    let imageUrl: String
    let longitude: Double
    let latitude: Double
    let address: String
    let city: String
    let zipcode: Int
    let world: String
    
    let dateCreated: Date
    let viewCount: Int
    let price: Int
    let saveCounts: Int

    let description: String?
    
    let ownerId: String
    let ownerDisplayName: String
    let ownerImageUrl: String
    

    enum CodingKeys: String, CodingKey {
        case postId = "spot_id"
        case spotName = "spot_name"
        case imageUrl = "spot_image_url"
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
    }
    
    var distanceFromUser: Double {
        let manager = LocationService.instance.manager
        
        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedWhenInUse {
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
    
}
