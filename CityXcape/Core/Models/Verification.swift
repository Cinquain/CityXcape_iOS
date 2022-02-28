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
    let verifierId: String
    let postId: String
    let spotOwnerId: String
    let city: String
    let country: String
    
    init(data: [String: Any]) {
        self.comment = data["comment"] as? String ?? ""
        self.imageUrl = data["imageUrl"] as? String ?? ""
        self.verifierId = data["verifierId"] as? String ?? ""
        self.spotOwnerId = data["spotOwnerId"] as? String ?? ""
        self.city = data["city"] as? String ?? ""
        self.country = data["country"] as? String ?? ""
        let timestamp = data["time"] as? Timestamp
        self.postId = data["postId"] as? String ?? ""
        self.time = timestamp?.dateValue() ?? Date()
    }
}
