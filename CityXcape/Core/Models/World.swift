//
//  World.swift
//  CityXcape
//
//  Created by James Allan on 9/10/22.
//

import SwiftUI
import Firebase

struct World: Identifiable, Hashable, Equatable {
    
    
    let id: String
    let name: String
    let description: String
    let hashtags: String
    let imageUrl: String
    let coverImageUrl: String
    let memberCount: Int
    let spotCount: Int
    let initationFee: Int
    let monthlyFee: Int
    let est: Date
    let ownerId: String
    let isPublic: Bool
    let ownerDisplayName: String
    let ownerImageUrl: String
    let ownerEmail: String
    let reqString: String
    let reqSpots: Int
    let reqStamps: Int
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: World, rhs: World) -> Bool {
        lhs.id == rhs.id
    }
    
    
    init(data: [String: Any]) {
        self.id = data[WorldField.id] as? String ?? ""
        self.name = data[WorldField.name] as? String ?? ""
        self.description = data[WorldField.description] as? String ?? ""
        self.hashtags = data[WorldField.hashtags] as? String ?? ""
        self.imageUrl = data[WorldField.imageUrl] as? String ?? ""
        self.spotCount = data[WorldField.spotCount] as? Int ?? 0
        self.memberCount = data[WorldField.membersCount]  as? Int ?? 1
        self.initationFee = data[WorldField.initiationFee] as? Int ?? 0
        self.monthlyFee = data[WorldField.monthlyFee] as? Int ?? 0
        let date = data[WorldField.dateCreated] as? Timestamp
        self.est = date?.dateValue() ?? Date()
        self.coverImageUrl = data[WorldField.coverImageUrl] as? String ?? ""
        self.ownerId = data[WorldField.ownerId] as? String ?? ""
        self.isPublic = data[WorldField.isPublic] as? Bool ?? true
        self.ownerDisplayName = data[WorldField.ownerName] as? String ?? ""
        self.ownerImageUrl = data[WorldField.ownerImageUrl] as? String ?? ""
        self.ownerEmail = data[WorldField.ownerEmail] as? String ?? ""
        self.reqString = data[WorldField.reqString] as? String ?? ""
        self.reqSpots = data[WorldField.reqSpots] as? Int ?? 0
        self.reqStamps = data[WorldField.reqStamps] as? Int ?? 0
    }
    
    
    
    
}
