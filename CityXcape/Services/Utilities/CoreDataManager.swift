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
    
    
    func updateDescription(spotId: String, description: String) {
        let entity = spotEntities.first(where: {$0.spotId == spotId})
        entity?.spotDescription = description
        save()
    }
    
    
    func updateWorld(spotId: String, world: String) {
        let entity = spotEntities.first(where: {$0.spotId == spotId})
        entity?.world = world
        save()
    }
    
    func updateImage(spotId: String, index: Int, imageUrl: String) {
        let entity = spotEntities.first(where: {$0.spotId == spotId})
        entity?.imageUrls?.insert(imageUrl, at: index)
        save()
    }
    
    func addEntity(spotId: String, spotName: String, description: String, longitude: Double, latitude: Double, imageUrls: [String], address: String, uid: String, ownerImageUrl: String, ownerDisplayName: String, price: Double, viewCount: Double, saveCount: Double, zipCode: Double, world: String, isPublic: Bool, dateCreated: Date, city: String) {
        
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
        save()
        
    }
    
}
