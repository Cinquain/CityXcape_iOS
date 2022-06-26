//
//  User.swift
//  CityXcape
//
//  Created by James Allan on 1/10/22.
//

import Foundation
import Firebase
import FirebaseMessaging


struct User: Identifiable, Hashable, Equatable {
    
    let id: String
    let displayName: String
    let profileImageUrl: String
    
    
    var bio: String?
    var fcmToken: String?
    var streetCred: Int?
    var social: String?
    var rank: String?
    var city: String?
    
    var verified: Date?
    var membership: Date?
    var world: [String: Double]?
    
    
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
    
    
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
        self.social = data?[UserField.ig] as? String ?? nil
        self.world = data?[UserField.world] as? [String: Double] ?? [:]
        self.rank = data?[UserField.rank] as? String ?? ""
        let timestamp = data?[UserField.dataCreated] as? Timestamp
        self.membership = timestamp?.dateValue()
    }
    
    init(spot: SecretSpot) {
        self.id = spot.ownerId
        self.displayName = spot.ownerDisplayName
        self.profileImageUrl = spot.ownerImageUrl
        self.social = spot.ownerIg ?? nil
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
        self.social = userInfo["instagram"] as? String ?? nil
        self.rank = userInfo["rank"] as? String ?? ""
    }
    
    init(rank: Rank) {
        self.id = rank.id
        self.displayName = rank.displayName
        self.profileImageUrl = rank.profileImageUrl
        self.social = rank.social ?? nil
        self.rank = rank.currentLevel 
    }
 
    init() {
        self.id = UserDefaults.standard.value(forKey: CurrentUserDefaults.userId) as? String ?? ""
        self.displayName = UserDefaults.standard.value(forKey: CurrentUserDefaults.displayName) as? String ?? ""
        self.profileImageUrl = UserDefaults.standard.value(forKey: CurrentUserDefaults.profileUrl) as? String ?? ""
        self.streetCred = UserDefaults.standard.value(forKey: CurrentUserDefaults.wallet) as? Int ?? 0
        self.bio = UserDefaults.standard.value(forKey: CurrentUserDefaults.bio) as? String ?? ""
        self.social = UserDefaults.standard.value(forKey: CurrentUserDefaults.social) as? String ?? ""
        self.fcmToken = Messaging.messaging().fcmToken
        self.rank = UserDefaults.standard.value(forKey: CurrentUserDefaults.rank) as? String ?? ""
        self.world = UserDefaults.standard.value(forKey: CurrentUserDefaults.world) as? [String: Double] ?? nil
        self.city = UserDefaults.standard.value(forKey: CurrentUserDefaults.city) as? String ?? ""
    }
    
    
    
}
