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
    let followingImage: String?
    let followingDisplayName: String?
    let stampImageUrl: String?

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
        self.stampImageUrl = data[FeedField.stampImageUrl] as? String ?? nil
        self.followingImage = data[FeedField.followingImage] as? String ?? nil
        self.followingDisplayName = data[FeedField.followingName] as? String ?? nil
    }
    
    init(id: String, uid: String, username: String, userImageUrl: String, userBio: String, userRank: String, content: String, date: Date, type: FeedType, geohash: Double, longitude: Double, latitude: Double, spotId: String, userId: String, followingImage: String, followingDisplayName: String, stampImageUrl: String) {
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
        self.stampImageUrl = stampImageUrl
        self.followingDisplayName = followingDisplayName
        self.followingImage = followingImage
    }
    
    static let feed = Feed(id: "xyz456", uid: "L8f41O2WTbRKw8yitT6e", username: "Cinquain", userImageUrl: "https://firebasestorage.googleapis.com/v0/b/cityxcape-1e84f.appspot.com/o/users%2FL8f41O2WTbRKw8yitT6e%2FprofileImage?alt=media&token=c4bc2840-a6ee-49d0-a6ff-f4073b9f1073", userBio: "Yolo", userRank: "Informant", content: "Cinquain checked in The Magic Garden", date: Date(), type: .message, geohash: 737485, longitude: 15354546, latitude: 274748585, spotId: "0VThFqoWQrtowYjcFyTz", userId: "dUBOGyE5nTBR3GluH5uA", followingImage: "https://firebasestorage.googleapis.com/v0/b/cityxcape-1e84f.appspot.com/o/users%2FdUBOGyE5nTBR3GluH5uA%2FprofileImage?alt=media&token=dc5d16e3-e990-416b-9a9f-7afd18f51c2b", followingDisplayName: "Sarah", stampImageUrl: "https://firebasestorage.googleapis.com/v0/b/cityxcape-1e84f.appspot.com/o/users%2FL8f41O2WTbRKw8yitT6e%2F0VThFqoWQrtowYjcFyTz%2FverifiedImage?alt=media&token=c3238156-9a1f-4180-83de-efb8bc8f5af8")
}
