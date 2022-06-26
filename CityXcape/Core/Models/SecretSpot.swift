//
//  SecretSpot.swift
//  CityXcape
//
//  Created by James Allan on 8/19/21.
//

import Firebase
import MapKit
import CoreLocation
import SwiftUI




struct SecretSpot:  Hashable, Identifiable, Equatable {
    
    let id: String
    var spotName: String
    var imageUrls: [String]
    var longitude: Double
    var latitude: Double
    var address: String
    var city: String
    var zipcode: Int
    var world: String
    var likedByUser: Bool
    
    let dateCreated: Date
    var price: Int
    var saveCounts: Int
    var isPublic: Bool
    var verified: Bool
    var likedCount: Int
    var viewCount: Int
    var commentCount: Int
    var verifierCount: Int
    var description: String?
    
    let ownerId: String
    var ownerDisplayName: String
    var ownerImageUrl: String
    var ownerIg: String?
    
    
    var distanceFromUser: Double {
        let manager = LocationService.instance.manager
        
        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
            let destination = CLLocation(latitude: latitude, longitude: longitude)
            let userlocation = CLLocation(latitude: (manager.location?.coordinate.latitude) ?? 0, longitude: (manager.location?.coordinate.longitude) ?? 0)
            let calculatedDistance = userlocation.distance(from: destination) * 0.000621
            return calculatedDistance
        } else {
            manager.requestWhenInUseAuthorization()
            return 0
        }

    }
    
    var country: String {
        let placemark = MKPlacemark(coordinate: .init(latitude: latitude, longitude: longitude))
        return placemark.country ?? ""
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
    
    
    init(postId: String, spotName: String, imageUrls: [String], longitude: Double, latitude: Double, address: String, description: String, city: String, zipcode: Int, world: String, dateCreated: Date, price: Int, viewCount: Int, saveCounts: Int, isPublic: Bool, ownerId: String, ownerDisplayName: String, ownerImageUrl: String, likeCount: Int, verifierCount: Int, commentCount: Int, didLike: Bool, verified: Bool) {

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
            self.verifierCount = verifierCount
            self.commentCount = commentCount
            self.likedByUser  = didLike
            self.verified = verified
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
            verifierCount = Int(entity.verifierCount)
            viewCount = Int(entity.viewCount)
            price = Int(entity.price)
            world = entity.world ?? ""
            zipcode = Int(entity.zipCode)
            address = entity.address ?? ""
            ownerDisplayName = entity.ownerDisplayName ?? ""
            likedCount = Int(entity.likedCount)
            likedByUser = entity.didLike
            verified = entity.verified
            verifierCount = Int(entity.verifierCount)
            commentCount = Int(entity.commentCount)
        }
    
    
    init(data: [String: Any]?) {
        
        let dateCreated = data?[SecretSpotField.dateCreated] as? Timestamp ?? Timestamp()
        let imageUrl = data?[SecretSpotField.spotImageUrl] as? String ?? ""
        let additionalImages = data?[SecretSpotField.spotImageUrls] as? [String] ?? []
        
        let date = dateCreated.dateValue()
        var spotImageUrls = [imageUrl]
        if !additionalImages.isEmpty {
            additionalImages.forEach { url in
                spotImageUrls.append(url)
            }
        }
        
        self.id = data?[SecretSpotField.spotId] as? String  ?? ""
        self.spotName = data?[SecretSpotField.spotName] as? String ?? ""
        self.imageUrls = spotImageUrls
        self.longitude = data?[SecretSpotField.longitude] as? Double ?? 0
        self.latitude = data?[SecretSpotField.latitude] as? Double ?? 0
        self.price = data?[SecretSpotField.price] as? Int ?? 0
        self.description = data?[SecretSpotField.description] as? String ?? ""
        self.city = data?[SecretSpotField.city] as? String ?? ""
        self.dateCreated = date
        self.ownerId = data?[SecretSpotField.ownerId] as? String ?? ""
        self.ownerDisplayName = data?[SecretSpotField.ownerDisplayName] as? String ?? ""
        self.ownerImageUrl = data?[SecretSpotField.ownerImageUrl] as? String ?? ""
        self.address = data?[SecretSpotField.address] as? String ?? ""
        self.zipcode = data?[SecretSpotField.zipcode] as? Int ?? 0
        self.saveCounts = data?[SecretSpotField.saveCount] as? Int ?? 0
        self.viewCount = data?[SecretSpotField.viewCount] as? Int ?? 0
        self.isPublic = data?[SecretSpotField.isPublic] as? Bool ?? false
        self.world = data?[SecretSpotField.world] as? String ?? ""
        self.likedCount = data?[SecretSpotField.likeCount] as? Int ?? 0
        self.verifierCount = data?[SecretSpotField.verifierCount] as? Int ?? 0
        self.commentCount = data?[SecretSpotField.commentCount] as? Int ?? 0
        self.ownerIg = data?[SecretSpotField.ownerIg] as? String ?? nil
        self.likedByUser = false
        self.verified = false
    }
    
    static let spot = SecretSpot(postId: "disnf", spotName: "The Magic Garden", imageUrls: ["https://firebasestorage.googleapis.com/v0/b/cityxcape-1e84f.appspot.com/o/posts%2F3rD6bKzwCbOEpfU51sYF%2F1?alt=media&token=2c45942e-5a44-4dd1-aa83-a678bb848c4b","https://cdn10.phillymag.com/wp-content/uploads/sites/3/2018/07/Emily-Smith-Cory-J-Popp-900x600.jpg", "https://apricotabroaddotco.files.wordpress.com/2019/03/philadelphia-magic-gardens.jpg"], longitude: 1010, latitude: 01202, address: "1229 Spann avenue", description: "This is the best secret spot in the world. Learn all about fractal mathematics", city: "Brooklyn", zipcode: 42304, world: "#Urbex", dateCreated: Date(), price: 1, viewCount: 1, saveCounts: 1, isPublic: true, ownerId: "q4SALDGpjtZLIVtVibHMQa8NpwD3", ownerDisplayName: "Cinquain", ownerImageUrl: "https://firebasestorage.googleapis.com/v0/b/cityxcape-1e84f.appspot.com/o/users%2FL8f41O2WTbRKw8yitT6e%2FprofileImage?alt=media&token=c4bc2840-a6ee-49d0-a6ff-f4073b9f1073", likeCount: 10, verifierCount: 0, commentCount: 0, didLike: true, verified: false)
    
    
}
