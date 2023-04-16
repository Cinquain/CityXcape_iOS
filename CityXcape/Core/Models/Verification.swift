//
//  Verification.swift
//  CityXcape
//
//  Created by James Allan on 2/28/22.
//

import Foundation
import Firebase


struct Verification: Identifiable, Hashable {
    
    var id: String { return postId }
    var imageUrl: String
    let comment: String
    let time: Date
    let name: String
    let verifierId: String
    let postId: String
    let likedIds: [String]
    let propIds: [String]
    let latitude: Double
    let longitude: Double
    let spotOwnerId: String
    let city: String
    let country: String
    let checkinCount: Int
    let imageCollection: [String]
    let verifierName: String
    let verifierImage: String
    
    init(data: [String: Any]) {
        self.comment = data[CheckinField.comment] as? String ?? ""
        self.imageUrl = data[CheckinField.image] as? String ?? ""
        self.verifierId = data[CheckinField.verifierId] as? String ?? ""
        self.spotOwnerId = data[CheckinField.spotOwnerId] as? String ?? ""
        self.city = data[CheckinField.city] as? String ?? ""
        self.country = data[CheckinField.country] as? String ?? ""
        let timestamp = data[CheckinField.timestamp] as? Timestamp
        self.latitude = data[CheckinField.latitude] as? Double ?? 0
        self.longitude = data[CheckinField.longitude] as? Double ?? 0
        self.postId = data[CheckinField.spotId] as? String ?? ""
        self.time = timestamp?.dateValue() ?? Date()
        self.name = data[CheckinField.spotName] as? String ?? ""
        self.verifierName = data[CheckinField.veriferName] as? String ?? ""
        self.verifierImage = data[CheckinField.verifierImage] as? String ?? ""
        self.checkinCount = data[CheckinField.checkinCount] as? Int ?? 1
        self.imageCollection = data[CheckinField.imageCollection] as? [String] ?? [self.imageUrl]
        self.likedIds = data[CheckinField.likedIds] as? [String] ?? []
        self.propIds = data[CheckinField.propIds] as? [String] ?? []
    }
    
    
    init(entity: VerificationEntity) {
        self.postId = entity.postId ?? ""
        self.imageUrl = entity.imageUrl ?? ""
        self.country = entity.country ?? ""
        self.comment = entity.comment ?? ""
        self.time = entity.timestamp ?? Date()
        self.name = entity.name ?? ""
        self.verifierId = entity.verifierId ?? ""
        self.verifierName = entity.verifierName ?? ""
        self.verifierImage = entity.verifierImage ?? ""
        self.latitude = entity.latitude
        self.longitude = entity.longitude
        self.spotOwnerId = entity.spotOwnerId ?? ""
        self.city = entity.city ?? ""
        self.checkinCount = Int(entity.checkincount)
        self.imageCollection = entity.imageUrls ?? [entity.imageUrl ?? ""]
        self.likedIds = entity.likedIds ?? []
        self.propIds = entity.propIds ?? []
    }
    
    init(userInfo: [AnyHashable: Any]) {
        self.postId =  userInfo["postId"] as? String ?? ""
        self.name = userInfo["stampName"] as? String ?? ""
        self.imageUrl =  userInfo["image"] as? String ?? ""
        self.comment =  userInfo["content"] as? String ?? ""
        let timestamp = userInfo["time"] as? String ?? ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"
        self.time = dateFormatter.date(from: timestamp) ?? Date()
        let lat =  userInfo["latitude"] as? String ?? ""
        let long =  userInfo["longitude"] as? String ?? ""
        self.latitude = Double(lat) ?? 0
        self.longitude = Double(long) ?? 0
        self.city =  userInfo["city"] as? String ?? ""
        self.country =  userInfo["country"] as? String ?? ""
        self.spotOwnerId =  userInfo["ownerId"] as? String ?? ""
        self.verifierId =  userInfo["verifierId"] as? String ?? ""
        self.verifierName =  userInfo["verifierName"] as? String ?? ""
        self.verifierImage =  userInfo["verifierImage"] as? String ?? ""
        self.checkinCount = userInfo[CheckinField.checkinCount] as? Int ?? 1
        self.imageCollection = userInfo[CheckinField.imageCollection] as? [String] ?? []
        self.likedIds = userInfo[CheckinField.likedIds] as? [String] ?? []
        self.propIds = userInfo[CheckinField.propIds] as? [String] ?? []
    }
    
    
    static let data: [String: Any] = [
        CheckinField.spotName : "Dance Competion",
        CheckinField.image: "https://pics.filmaffinity.com/White_Chicks-973832641-large.jpg",
        CheckinField.commentCount : 32,
        CheckinField.city: "New York",
        CheckinField.spotId: "12384855",
        CheckinField.verifierId: "abhfurgg",
        CheckinField.veriferName: "Cinquain",
        CheckinField.checkinCount: 25,
        CheckinField.country: "US",
        CheckinField.verifierImage: "https://firebasestorage.googleapis.com/v0/b/cityxcape-1e84f.appspot.com/o/users%2FL8f41O2WTbRKw8yitT6e%2FprofileImage?alt=media&token=1a4c018a-d539-4c95-87ca-fdec61f8e73c",
        CheckinField.comment: "This place is the bomb",
        CheckinField.longitude: -93.25519901402119,
        CheckinField.latitude: 44.97849074790292,
        CheckinField.spotOwnerId : "ahfuigog",
        CheckinField.timestamp: Date(),
        CheckinField.imageCollection: ["https://firebasestorage.googleapis.com/v0/b/cityxcape-1e84f.appspot.com/o/posts%2Fw3QA4EFQ1j0yJeCSWyww%2F1?alt=media&token=22fd7993-9352-4798-851a-18fa0a60800b", "https://pics.filmaffinity.com/White_Chicks-973832641-large.jpg"],
        CheckinField.likedIds: ["abxuf", "ajfjg", "gjfdjhd"]
    ]
    
    static let demo = Verification(data: data)
    

}
