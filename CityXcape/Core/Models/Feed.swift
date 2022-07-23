//
//  Feed.swift
//  CityXcape
//
//  Created by James Allan on 7/17/22.
//

import Firebase
import MapKit
import CoreLocation
import SwiftUI

struct Feed: Hashable, Identifiable, Equatable {
    
    let id: String
    let uid: String
    let username: String
    let userImageUrl: String
    let userBio: String
    let userRank: String
    let content: String
    let date: Date
    let type: FeedType
    let geohash: Double
    let longitude: Double
    let latitude: Double
    
    let spotId: String?
    let userId: String?

    static func == (lhs: Feed, rhs: Feed) -> Bool {
        lhs.id == rhs.id
    }
    
    
    init(data: [String: Any]) {
        self.id = data[FeedField.id] as? String ?? ""
        self.uid = data[FeedField.uid] as? String ?? ""
        self.username = data[FeedField.username] as? String ?? ""
        self.userImageUrl = data[FeedField.profileUrl] as? String ?? ""
        self.userBio = data[FeedField.bio] as? String ?? ""
        self.userRank = data[FeedField.rank] as? String ?? ""
        self.content = data[FeedField.content] as? String ?? ""
        let time  = data[FeedField.date] as? Timestamp ?? Timestamp()
        self.date = time.dateValue()
        self.type = .init(rawValue: data[FeedField.type] as? String ?? "") ?? .spot
        self.geohash = data[FeedField.geohash] as? Double ?? 0
        self.longitude = data[FeedField.longitude] as? Double ?? 0
        self.latitude = data[FeedField.latitude] as? Double ?? 0
        self.spotId = data[FeedField.spotId] as? String ?? nil
        self.userId = data[FeedField.userId] as? String ?? nil
    }
    
    init(id: String, uid: String, username: String, userImageUrl: String, userBio: String, userRank: String, content: String, date: Date, type: FeedType, geohash: Double, longitude: Double, latitude: Double, spotId: String, userId: String) {
        self.id = id
        self.uid = uid
        self.username = username
        self.userImageUrl = userImageUrl
        self.userBio = userBio
        self.userRank = userRank
        self.content = content
        self.date = date
        self.type = type
        self.geohash = geohash
        self.longitude = longitude
        self.latitude = latitude
        self.spotId = spotId
        self.userId = userId
    }
    
    static let feed = Feed(id: "xyz456", uid: "abc123", username: "Cinquain", userImageUrl: "https://firebasestorage.googleapis.com/v0/b/cityxcape-1e84f.appspot.com/o/users%2FL8f41O2WTbRKw8yitT6e%2FprofileImage?alt=media&token=c4bc2840-a6ee-49d0-a6ff-f4073b9f1073", userBio: "Yolo", userRank: "Informant", content: "Cinquain checked in The Magic Garden", date: Date(), type: .message, geohash: 737485, longitude: 15354546, latitude: 274748585, spotId: "fisdhsfduf", userId: "abc123")
}
