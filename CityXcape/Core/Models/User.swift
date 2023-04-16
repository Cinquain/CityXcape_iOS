//
//  User.swift
//  CityXcape
//
//  Created by James Allan on 1/10/22.
//

import Foundation
import Firebase
import CoreLocation
import FirebaseMessaging


struct User: Identifiable, Hashable, Equatable {
    
    let id: String
    let displayName: String
    let profileImageUrl: String
    
    
    var bio: String?
    var fcmToken: String?
    var streetCred: Double?
    var social: String?
    var rank: String?
    var city: String?
    var tribe: String?
    var tribeImageUrl: String?
    
    var longitude: Double?
    var latitude: Double?

    var verified: Date?
    var membership: Date?
    var world: [String: Double]?
    var newFriend: Bool?
    var postId: String?
    
    
    var distanceFromUser: Double {
        let manager = LocationService.instance.manager
        
        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
            let destination = CLLocation(latitude: latitude ?? 0, longitude: longitude ?? 0)
            let userlocation = CLLocation(latitude: (manager.location?.coordinate.latitude) ?? 0, longitude: (manager.location?.coordinate.longitude) ?? 0)
            let calculatedDistance = userlocation.distance(from: destination) * 0.000621
            return calculatedDistance
        } else {
            manager.requestWhenInUseAuthorization()
            return 0
        }

    }
    
    
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
    
    
    init(id: String, displayName: String, profileImageUrl: String) {
        self.id = id
        self.displayName = displayName
        self.profileImageUrl = profileImageUrl
        
    }
    
    init(data: [String: Any]?) {
        let uid = data?[UserField.provider] as? String ?? ""
        
        if uid == "" {
            self.id = data?[UserField.providerId] as? String ?? ""
        } else {
            self.id = uid
        }
        
        self.displayName = data?[UserField.displayName] as? String ?? ""
        self.streetCred = data?[UserField.streetCred] as? Double ?? 0
        self.bio = data?[UserField.bio] as? String ?? ""
        self.fcmToken = data?[ UserField.fcmToken] as? String ?? ""
        self.profileImageUrl = data?[UserField.profileImageUrl] as? String ?? ""
        self.social = data?[UserField.ig] as? String ?? nil
        self.world = data?[UserField.world] as? [String: Double] ?? [:]
        self.rank = data?[UserField.rank] as? String ?? "Tourist"
        let timestamp = data?[UserField.tribeJoinDate] as? Timestamp
        self.tribe = data?[UserField.tribe] as? String ?? ""
        self.longitude = data?[UserField.longitude] as? Double ?? 0
        self.latitude = data?[UserField.latitude] as? Double ?? 0
        self.tribeImageUrl = data?[UserField.tribeImageUrl] as? String ?? ""
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
    
    init(verification: Verification) {
        self.id = verification.verifierId
        self.displayName = verification.verifierName
        self.profileImageUrl  = verification.verifierImage
    }
    
    init(userInfo: [AnyHashable: Any]) {
        self.id = userInfo["userid"] as? String ?? ""
        self.profileImageUrl = userInfo["profileUrl"] as? String ?? ""
        self.displayName = userInfo["userDisplayName"] as? String ?? ""
        let streetcred = userInfo["streetCred"] as? String ?? "0"
        self.streetCred = Double(streetcred)
        self.bio = userInfo["biography"] as? String ?? ""
        self.tribe = userInfo["tribe"] as? String ?? ""
        let timestamp = userInfo["joinDate"] as? Timestamp
        self.membership = timestamp?.dateValue() ?? Date()
        self.tribeImageUrl = userInfo["tribeUrl"] as? String ?? ""
        self.social = userInfo["instagram"] as? String ?? nil
        self.rank = userInfo["rank"] as? String ?? ""
        if let _ = userInfo["friend"] as? String {
            self.newFriend = true
        }
        self.fcmToken = userInfo["fcmToken"] as? String ?? ""
    }
    
    init(rank: Rank) {
        self.id = rank.id
        self.displayName = rank.displayName
        self.profileImageUrl = rank.profileImageUrl
        self.social = rank.social ?? nil
        self.rank = rank.currentLevel 
    }
    
    init(feed: Feed) {
        self.id = feed.uid
        self.displayName = feed.username
        self.profileImageUrl = feed.userImageUrl
        self.bio = feed.userBio
        self.rank = feed.userRank
    }
    
    init(message: RecentMessage) {
        self.id = message.userId
        self.displayName = message.displayName
        self.profileImageUrl = message.profileUrl
        self.bio = message.bio
        self.rank = message.rank
    }
    
    init(trail: Trail) {
        self.id = trail.ownerId
        self.profileImageUrl = trail.ownerImageUrl
        self.displayName = trail.ownerDisplayName
        self.rank = trail.ownerRank
    }
 
    init() {
        self.id = UserDefaults.standard.value(forKey: CurrentUserDefaults.userId) as? String ?? ""
        self.displayName = UserDefaults.standard.value(forKey: CurrentUserDefaults.displayName) as? String ?? ""
        self.profileImageUrl = UserDefaults.standard.value(forKey: CurrentUserDefaults.profileUrl) as? String ?? ""
        self.streetCred = UserDefaults.standard.value(forKey: CurrentUserDefaults.wallet) as? Double ?? 0
        self.bio = UserDefaults.standard.value(forKey: CurrentUserDefaults.bio) as? String ?? ""
        self.social = UserDefaults.standard.value(forKey: CurrentUserDefaults.social) as? String ?? ""
        self.fcmToken = Messaging.messaging().fcmToken 
        self.rank = UserDefaults.standard.value(forKey: CurrentUserDefaults.rank) as? String ?? ""
        self.world = UserDefaults.standard.value(forKey: CurrentUserDefaults.world) as? [String: Double] ?? nil
        self.city = UserDefaults.standard.value(forKey: CurrentUserDefaults.city) as? String ?? ""
    }
    
    
    
}
