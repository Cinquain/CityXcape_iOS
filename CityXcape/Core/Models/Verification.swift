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
    let imageUrl: String
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
