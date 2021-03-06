//
//  CoreDataManager.swift
//  CityXcape
//
//  Created by James Allan on 1/2/22.
//

import Foundation
import CoreData
import SwiftUI



class CoreDataManager {
    
    static let instance = CoreDataManager()
    @Published var spotEntities: [SecretSpotEntity] = []
    
    
    let container: NSPersistentContainer
    let context: NSManagedObjectContext
    
    private init() {
        
        container = NSPersistentContainer(name: "SecretSpotContainer")
        container.loadPersistentStores { description, error in
            
            if let error = error {
                print("Error loading persistent store", error.localizedDescription)
            }
            
        }
        context = container.viewContext
        context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump

    }
    
    func fetchSecretSpots() {
        let request = NSFetchRequest<SecretSpotEntity>(entityName: "SecretSpotEntity")
        do {
            spotEntities = try context.fetch(request)
        } catch let error {
            print("Error fetching secret spot entities", error.localizedDescription)
        }
    }
    
    
    func save() {
        do {
            try context.save()
        } catch let error {
            print("Error saving to Core Data", error.localizedDescription)
        }
    }
    
    
    func delete(spotId: String) {
        let entity = spotEntities.first(where: {$0.spotId == spotId})
        guard let entity = entity else {return}
        context.delete(entity)
        save()
    }
    
    
    func updateName(spotId: String, name: String) {
        let entity = spotEntities.first(where: {$0.spotId == spotId})
        entity?.spotName = name
        save()
    }
    
    func updateSocial(spotId: String, instagram: String) {
        let entity = spotEntities.first(where: {$0.spotId == spotId})
        entity?.ownerIg = instagram
        save()
    }
    
    
    func updateDescription(spotId: String, description: String) {
        let entity = spotEntities.first(where: {$0.spotId == spotId})
        entity?.spotDescription = description
        save()
    }
    
    func updateSaveCount(spotId: String, count: Double) {
        let entity = spotEntities.first(where: {$0.spotId == spotId})
        entity?.saveCount = count
        save()
    }
    
    func updateViewCount(spotId: String, count: Double) {
        let entity = spotEntities.first(where: {$0.spotId == spotId})
        entity?.viewCount = count
        save()
    }
    
    func updateLike(spotId: String, liked: Bool) {
        let entity = spotEntities.first(where: {$0.spotId == spotId})
        entity?.didLike = liked
        save()
    }
    
    func updateLikedCount(spotId: String, count: Double) {
        let entity = spotEntities.first(where: {$0.spotId == spotId})
        entity?.likedCount = count
        save()
    }
    
    func updateWorld(spotId: String, world: String) {
        let entity = spotEntities.first(where: {$0.spotId == spotId})
        entity?.world = world
        save()
    }
    
    func updateImage(spotId: String, index: Int, imageUrl: String) {
        let entity = spotEntities.first(where: {$0.spotId == spotId})
        entity?.imageUrls?[index] = imageUrl
        save()
    }
    
    func addImage(spotId: String, imageUrl: String) {
        let entity = spotEntities.first(where: {$0.spotId == spotId})
        entity?.imageUrls?.append(imageUrl)
    }
    
    func updateVerifierCount(spotId: String, count: Double) {
        let entity = spotEntities.first(where: {$0.spotId == spotId})
        entity?.verifierCount = count
        save()
    }
    
    func updateLocation(spotId: String, long: Double, lat: Double, city: String) {
        let entity = spotEntities.first(where: {$0.spotId == spotId})
        entity?.latitude = lat
        entity?.longitude = long
        entity?.city = city
        save()
    }
    
    func updateCommentCount(spotId: String, count: Int) {
        let entity = spotEntities.first(where: {$0.spotId == spotId})
        entity?.commentCount = Double(count)
        save()
    }
    
    func updatePrice(spotId: String, price: Int) {
        let entity = spotEntities.first(where: {$0.spotId == spotId})
        entity?.price = Double(price)
        save()
    }
    
    func updateLastVerified(spotId: String, date: Date) {
        let entity = spotEntities.first(where: {$0.spotId == spotId})
        entity?.lastVerified = date
        entity?.verifierCount += 1
        entity?.verified = true
        save()
    }
    
    func updateVerification(spotId: String, verified: Bool) {
        let entity = spotEntities.first(where: {$0.spotId == spotId})
        entity?.verified = verified
        entity?.verifierCount += 1
        entity?.lastVerified = Date()
        save()
    }
    
    func addEntity(spotId: String, spotName: String, description: String, longitude: Double, latitude: Double, imageUrls: [String], address: String, uid: String, ownerImageUrl: String, ownerDisplayName: String, price: Double, viewCount: Double, saveCount: Double, zipCode: Double, world: String, isPublic: Bool, dateCreated: Date, city: String, didLike: Bool, likedCount: Int, verifierCount: Int, commentCount: Int, social: String) {
        
        let secretSpotEntity = SecretSpotEntity(context: context)
        secretSpotEntity.spotId = spotId
        secretSpotEntity.spotName = spotName
        secretSpotEntity.spotDescription = description
        secretSpotEntity.longitude = longitude
        secretSpotEntity.latitude = latitude
        secretSpotEntity.imageUrls = imageUrls
        secretSpotEntity.address = address
        secretSpotEntity.ownerId = uid
        secretSpotEntity.ownerImageUrl = ownerImageUrl
        secretSpotEntity.ownerDisplayName = ownerDisplayName
        secretSpotEntity.price = price
        secretSpotEntity.viewCount = viewCount
        secretSpotEntity.saveCount = saveCount
        secretSpotEntity.zipCode = zipCode
        secretSpotEntity.world = world
        secretSpotEntity.isPublic = isPublic
        secretSpotEntity.dateCreated = dateCreated
        secretSpotEntity.city = city
        secretSpotEntity.verifierCount = Double(verifierCount)
        secretSpotEntity.didLike = didLike
        secretSpotEntity.likedCount = Double(likedCount)
        secretSpotEntity.verified = false
        secretSpotEntity.commentCount = Double(commentCount)
        secretSpotEntity.ownerIg = social
        save()
        
    }
    
    func addEntityFromSpot(spot: SecretSpot) {
        let secretSpotEntity = SecretSpotEntity(context: context)
        secretSpotEntity.spotId = spot.id
        secretSpotEntity.spotName = spot.spotName
        secretSpotEntity.spotDescription = spot.description
        secretSpotEntity.longitude = spot.longitude
        secretSpotEntity.latitude = spot.latitude
        secretSpotEntity.imageUrls = spot.imageUrls
        secretSpotEntity.address = spot.address
        secretSpotEntity.ownerId = spot.ownerId
        secretSpotEntity.ownerImageUrl = spot.ownerImageUrl
        secretSpotEntity.ownerDisplayName = spot.ownerDisplayName
        secretSpotEntity.price = Double(spot.price)
        secretSpotEntity.viewCount = Double(spot.viewCount)
        secretSpotEntity.saveCount = Double(spot.saveCounts)
        secretSpotEntity.zipCode = Double(spot.zipcode)
        secretSpotEntity.world = spot.world
        secretSpotEntity.isPublic = spot.isPublic
        secretSpotEntity.dateCreated = spot.dateCreated
        secretSpotEntity.city = spot.city
        secretSpotEntity.verifierCount = Double(spot.verifyCount)
        secretSpotEntity.didLike = spot.likedByUser
        secretSpotEntity.likedCount = Double(spot.likedCount)
        secretSpotEntity.verified = spot.verified
        secretSpotEntity.commentCount = Double(spot.commentCount)
        secretSpotEntity.ownerIg = spot.ownerIg
        save()
        
    }
    
    func updateEntity(spotId: String, spotName: String, description: String, longitude: Double, latitude: Double, imageUrls: [String], address: String, uid: String, ownerImageUrl: String, ownerDisplayName: String, price: Double, viewCount: Double, saveCount: Double, zipCode: Double, world: String, isPublic: Bool, dateCreated: Date, city: String, didLike: Bool, likedCount: Int, verifierCount: Int, commentCount: Int, social: String) {
        
        let entity = spotEntities.first(where: {$0.spotId == spotId})
        entity?.spotName = spotName
        entity?.spotDescription = description
        entity?.longitude = longitude
        entity?.latitude = latitude
        entity?.imageUrls = imageUrls
        entity?.address = address
        entity?.ownerImageUrl = ownerImageUrl
        entity?.ownerDisplayName = ownerDisplayName
        entity?.price = price
        entity?.viewCount = viewCount
        entity?.saveCount = saveCount
        entity?.zipCode = zipCode
        entity?.world = world
        entity?.isPublic = isPublic
        entity?.city = city
        entity?.didLike = didLike
        entity?.verifierCount = Double(verifierCount)
        entity?.likedCount = Double(likedCount)
        entity?.commentCount = Double(commentCount)
        entity?.ownerIg = social
        save()
        
    }
    
    func updatewithSpot(spot: SecretSpot) {
        
        let entity = spotEntities.first(where: {$0.spotId == spot.id})
        entity?.spotName = spot.spotName
        entity?.spotDescription = spot.description
        entity?.longitude = spot.longitude
        entity?.latitude = spot.latitude
        entity?.imageUrls = spot.imageUrls
        entity?.address = spot.address
        entity?.ownerImageUrl = spot.ownerImageUrl
        entity?.ownerDisplayName = spot.ownerDisplayName
        entity?.price = Double(spot.price)
        entity?.viewCount = Double(spot.viewCount)
        entity?.saveCount = Double(spot.saveCounts)
        entity?.zipCode = Double(spot.zipcode)
        entity?.world = spot.world
        entity?.isPublic = spot.isPublic
        entity?.city = spot.city
        entity?.likedCount = Double(spot.likedCount)
        entity?.didLike = spot.likedByUser
        entity?.verifierCount = Double(spot.verifyCount)
        entity?.commentCount = Double(spot.commentCount)
        entity?.ownerIg = spot.ownerIg
        save()
        fetchSecretSpots()
    }
    
}
