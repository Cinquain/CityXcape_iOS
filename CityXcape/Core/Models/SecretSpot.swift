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

struct SecretSpot:  Hashable, Codable, Identifiable {
    
    let id: String
    var spotName: String
    var imageUrls: [String]
    var longitude: Double
    var latitude: Double
    var address: String
    var city: String
    var zipcode: Int
    var world: String
    var likedCount: Int
    var likedByUser: Bool
    
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
        case id = "spot_id"
        case spotName = "spot_name"
        case imageUrls = "spot_image_url"
        case longitude = "longitude"
        case latitude = "latitude"
        case description = "description"
        case city = "city"
        case dateCreated = "date_created"
        case likedCount = "like_count"
        case ownerId = "owner_id"
        case ownerDisplayName = "ownerDisplayName"
        case ownerImageUrl = "ownerImageUrl"
        case address = "address"
        case zipcode = "zipcode"
        case likedByUser = "did_like"
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
            let calculatedDistance = userlocation.distance(from: destination) * 0.000621
            return calculatedDistance
        } else {
            manager.requestWhenInUseAuthorization()
            return 0
        }

    }
    
    var distanceInFeet: Double {
        
        let manager = LocationService.instance.manager
        
        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
            let destination = CLLocation(latitude: latitude, longitude: longitude)
            let userlocation = CLLocation(latitude: (manager.location?.coordinate.latitude)!, longitude: (manager.location?.coordinate.longitude)!)
            let distance = userlocation.distance(from: destination) * 3.28084
            return distance.rounded()
        } else {
            manager.requestWhenInUseAuthorization()
            return 0
        }

    }
 
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: SecretSpot, rhs: SecretSpot) -> Bool {
        lhs.id == rhs.id
    }
    
    
    init(postId: String, spotName: String, imageUrls: [String], longitude: Double, latitude: Double, address: String, description: String, city: String, zipcode: Int, world: String, dateCreated: Date, price: Int, viewCount: Int, saveCounts: Int, isPublic: Bool, ownerId: String, ownerDisplayName: String, ownerImageUrl: String, likeCount: Int, didLike: Bool) {

            self.id = postId
            self.spotName = spotName
            self.imageUrls = imageUrls
            self.longitude = longitude
            self.latitude = latitude
            self.address = address
            self.description = description
            self.city = city
            self.zipcode = zipcode
            self.world = world
            self.dateCreated = dateCreated
            self.viewCount = viewCount
            self.saveCounts = saveCounts
            self.isPublic = isPublic
            self.ownerId = ownerId
            self.ownerDisplayName = ownerDisplayName
            self.ownerImageUrl = ownerImageUrl
            self.price = price
            self.likedCount = likeCount
            self.likedByUser = didLike
        }
        
        init(entity: SecretSpotEntity) {
            id = entity.spotId ?? ""
            spotName = entity.spotName ?? ""
            imageUrls = entity.imageUrls ?? [""]
            longitude = entity.longitude
            latitude = entity.latitude
            description = entity.spotDescription
            city = entity.city ?? ""
            dateCreated = entity.dateCreated ?? Date()
            ownerId = entity.ownerId ?? ""
            ownerImageUrl = entity.ownerImageUrl ?? ""
            isPublic = entity.isPublic
            saveCounts = Int(entity.saveCount)
            viewCount = Int(entity.viewCount)
            price = Int(entity.price)
            world = entity.world ?? ""
            zipcode = Int(entity.zipCode)
            address = entity.address ?? ""
            ownerDisplayName = entity.ownerDisplayName ?? ""
            likedCount = Int(entity.likedCount)
            likedByUser = entity.didLike
        }
    
    
}
