//
//  User.swift
//  CityXcape
//
//  Created by James Allan on 1/10/22.
//

import Foundation
import Firebase


struct User: Identifiable, Hashable {
    
    let id: String
    let displayName: String
    let profileImageUrl: String
    
    
    var bio: String?
    var fcmToken: String?
    var streetCred: Int?
    
    var verified: Date?
    var membership: Date?
    
    init(id: String, displayName: String, profileImageUrl: String) {
        
        self.id = id
        self.displayName = displayName
        self.profileImageUrl = profileImageUrl
        
    }
    
    init(data: [String: Any]?) {
        self.id = data?[UserField.providerId] as? String ?? ""
        self.displayName = data?[UserField.displayName] as? String ?? ""
        self.streetCred = data?[UserField.streetCred] as? Int ?? 0
        self.bio = data?[UserField.bio] as? String ?? ""
        self.fcmToken = data?[ UserField.fcmToken] as? String ?? ""
        self.profileImageUrl = data?[UserField.profileImageUrl] as? String ?? ""
        let timestamp = data?[UserField.dataCreated] as? Timestamp
        self.membership = timestamp?.dateValue()
    }
    
    init(comment: Comment) {
        self.id = comment.uid
        self.displayName = comment.username
        self.profileImageUrl = comment.imageUrl
        self.bio = comment.bio
    }
    
    init(userInfo: [AnyHashable: Any]) {
        self.id = userInfo["userid"] as? String ?? ""
        self.profileImageUrl = userInfo["profileUrl"] as? String ?? ""
        self.displayName = userInfo["userDisplayName"] as? String ?? ""
        let streetcred = userInfo["streetCred"] as? String ?? "0"
        self.streetCred = Int(streetcred)
        self.bio = userInfo["biography"] as? String ?? ""
        
    }
    
    
    
}
