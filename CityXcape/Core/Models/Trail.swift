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
    var spots: [String]
    var users: [String]
    
    var startTime: Date?
    var endTime: Date?
    var longitude: Double?
    var latitude: Double?
    
    static func == (lhs: Trail, rhs: Trail) -> Bool {
        lhs.id == rhs.id
    }
    
    init(data: [String:Any]?) {
        self.id = data?[TrailField.id] as? String ?? ""
        self.name = data?[TrailField.name] as? String ?? ""
        self.imageUrls = data?[TrailField.imageUrls] as? [String] ?? []
        self.description = data?[TrailField.description] as? String ?? ""
        self.ownerId = data?[TrailField.ownerId] as? String ?? ""
        self.ownerDisplayName = data?[TrailField.ownerName] as? String ?? ""
        self.ownerImageUrl = data?[TrailField.ownerImage] as? String ?? ""
        self.ownerRank = data?[TrailField.ownerRank] as? String ?? ""
        self.price  = data?[TrailField.price] as? Int ?? 10
        self.spots = data?[TrailField.spots] as? [String] ?? []
        self.users = data?[TrailField.users] as? [String] ?? []
    }
    
    init(huntData: [String: Any]?) {
        self.id = huntData?[TrailField.id] as? String ?? ""
        self.name = huntData?[TrailField.name] as? String ?? ""
        self.imageUrls = huntData?[TrailField.imageUrls] as? [String] ?? []
        self.description = huntData?[TrailField.description] as? String ?? ""
        self.ownerId = huntData?[TrailField.ownerId] as? String ?? ""
        self.ownerDisplayName = huntData?[TrailField.ownerName] as? String ?? ""
        self.ownerImageUrl = huntData?[TrailField.ownerImage] as? String ?? ""
        self.ownerRank = huntData?[TrailField.ownerRank] as? String ?? ""
        self.price  = huntData?[TrailField.price] as? Int ?? 10
        self.spots = huntData?[TrailField.spots] as? [String] ?? []
        self.users = huntData?[TrailField.users] as? [String] ?? []
        
        self.startTime = huntData?[TrailField.startDate] as? Date ?? Date()
        self.endTime = huntData?[TrailField.endDate] as? Date ?? Date()
        self.longitude = huntData?[TrailField.longitude] as? Double ?? 0.0
        self.latitude = huntData?[TrailField.latitude] as? Double ?? 0.0
    }
    
}
