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
    let latitude: Double
    let longitude: Double
    let spotOwnerId: String
    let city: String
    let country: String
    
    let commentCount: Int?
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
        self.commentCount = data[CheckinField.commentCount] as? Int? ?? 0
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
        let count = userInfo["count"] as? String ?? ""
        self.latitude = Double(lat) ?? 0
        self.longitude = Double(long) ?? 0
        self.city =  userInfo["city"] as? String ?? ""
        self.country =  userInfo["country"] as? String ?? ""
        self.spotOwnerId =  userInfo["ownerId"] as? String ?? ""
        self.commentCount =  Int(count) ?? 0
        self.verifierId =  userInfo["verifierId"] as? String ?? ""
        self.verifierName =  userInfo["verifierName"] as? String ?? ""
        self.verifierImage =  userInfo["verifierImage"] as? String ?? ""
    }
    
    static let data: [String: Any] = [
        CheckinField.spotName : "Dance Competion",
        CheckinField.image: "https://pics.filmaffinity.com/White_Chicks-973832641-large.jpg",
        CheckinField.commentCount : 32,
        CheckinField.city: "New York",
        CheckinField.spotId: "12384855",
        CheckinField.verifierId: "abhfurgg",
        CheckinField.veriferName: "Cinquain",
        CheckinField.country: "US",
        CheckinField.verifierImage: "https://firebasestorage.googleapis.com/v0/b/cityxcape-1e84f.appspot.com/o/users%2FL8f41O2WTbRKw8yitT6e%2FprofileImage?alt=media&token=1a4c018a-d539-4c95-87ca-fdec61f8e73c",
        CheckinField.comment: "This place is the bomb",
        CheckinField.longitude: -93.25519901402119,
        CheckinField.latitude: 44.97849074790292,
        CheckinField.spotOwnerId : "ahfuigog",
        CheckinField.timestamp: Date()
    ]
    
    static let demo = Verification(data: data)
    

}
