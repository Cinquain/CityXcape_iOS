//
//  DataService.swift
//  CityXcape
//
//  Created by James Allan on 9/8/21.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import CoreLocation
import MapKit
import FirebaseMessaging
import GeoFire

class DataService {
    
    @AppStorage(CurrentUserDefaults.userId) var userId: String?
    @AppStorage(CurrentUserDefaults.profileUrl) var profileUrl: String?
    @AppStorage(CurrentUserDefaults.displayName) var displayName: String?
    @AppStorage(CurrentUserDefaults.wallet) var wallet: Int?
    @AppStorage(CurrentUserDefaults.bio) var bio: String?
    @AppStorage(CurrentUserDefaults.social) var social: String?
    @AppStorage(CurrentUserDefaults.rank) var rank: String?
    @AppStorage(CurrentUserDefaults.tribe) var tribe: String?
    @AppStorage(CurrentUserDefaults.tribeImageUrl) var tribeImageUrl: String?


    
    static let instance = DataService()
    let manager = CoreDataManager.instance
    let locationManager = LocationService.instance
    
    private init() {}
    
    private var REF_POST = DB_BASE.collection(ServerPath.posts)
    private var REF_USERS = DB_BASE.collection(ServerPath.users)
    private var REF_REPORTS = DB_BASE.collection(ServerPath.report)
    private var REF_WORLD = DB_BASE.collection(ServerPath.world)
    private var REF_FOLLOWERS = DB_BASE.collection(ServerPath.followers)
    private var REF_Rankings = DB_BASE.collection(ServerPath.rankings)
    private var REF_TRAILS = DB_BASE.collection(ServerPath.trail)
    private var REF_HUNTS = DB_BASE.collection(ServerPath.hunt)
    private var REF_CITY = DB_BASE.collection(ServerPath.cities)
    private var REF_FEED = DB_BASE.collection(ServerPath.feed)
    private var REF_WORLDS = DB_BASE.collection(ServerPath.worlds)
    private var REF_MESSAGES = DB_BASE.collection(ServerPath.messages)
    private var REF_RECENTMESSAGE = DB_BASE.collection(ServerPath.recentMessage)
    
    //MARK: CREATE FUNCTIONS
    
    func uploadSecretSpot(spotName: String, description: String, image: UIImage, price: Int, world: String, mapItem: MKMapItem, isPublic: Bool, completion: @escaping (_ success: Bool) -> ()) {
        
        let spotId = UUID().uuidString

        let address = mapItem.getAddress()
        let longitude = mapItem.placemark.coordinate.longitude
        let latitude = mapItem.placemark.coordinate.latitude
        var spotCity = mapItem.getCity()
        let zipCode = mapItem.getPostCode()
        let location = CLLocationCoordinate2D(latitude: mapItem.placemark.coordinate.latitude,
                                              longitude: mapItem.placemark.coordinate.longitude)
        let geohash = GFUtils.geoHash(forLocation: location)

        
        let userLong = locationManager.userlocation?.longitude ?? 0
        let userLat = locationManager.userlocation?.latitude ?? 0
        let userHash = GFUtils.geoHash(forLocation: CLLocationCoordinate2D(latitude: userLat, longitude: userLong))
        
        if spotCity == "" {
            location.fetchCityAndCountry { city, country, error in
                spotCity = city ?? ""
            }
        }
        
        
        guard let uid = userId,
              let ownerImageUrl = profileUrl,
              let ownerDisplayName = displayName,
              let bio = bio
        else {
            print("Error getting user defaults at DataService")
            return
        }
        let instagram = social ?? ""
        let rank = rank ?? "tourist"
        
        ImageManager.instance.uploadSecretSpotImage(image: image, postId: spotId) { [weak self] (urlString) in
            guard let self = self else {return}
        
            print("inside image upload")
            if urlString == "" {
                print("Error uploading video to spot")
                completion(false)
                return
            }
            
            if let downloadUrl = urlString {
                
                let spotData: [String: Any] = [
                    SecretSpotField.spotId: spotId,
                    SecretSpotField.spotName: spotName,
                    SecretSpotField.description: description,
                    SecretSpotField.spotImageUrl: downloadUrl,
                    SecretSpotField.address: address,
                    SecretSpotField.geohash: geohash,
                    SecretSpotField.latitude: latitude,
                    SecretSpotField.longitude: longitude,
                    SecretSpotField.ownerId: uid,
                    SecretSpotField.ownerImageUrl: ownerImageUrl,
                    SecretSpotField.ownerDisplayName: ownerDisplayName,
                    SecretSpotField.price: price,
                    SecretSpotField.viewCount: 1,
                    SecretSpotField.saveCount: 1,
                    SecretSpotField.city: spotCity,
                    SecretSpotField.zipcode: zipCode,
                    SecretSpotField.world: world,
                    SecretSpotField.isPublic: isPublic,
                    SecretSpotField.dateCreated: FieldValue.serverTimestamp(),
                    SecretSpotField.verifierCount: 0,
                    SecretSpotField.commentCount: 0,
                    SecretSpotField.ownerIg: instagram
                ]
                
                self.manager.addSpotEntity(spotId: spotId, spotName: spotName, description: description, longitude: longitude, latitude: latitude, imageUrls: [downloadUrl], address: address, uid: uid, ownerImageUrl: ownerImageUrl, ownerDisplayName: ownerDisplayName, price: 1, viewCount: 1, saveCount: 1, zipCode: Double(zipCode), world: world, isPublic: isPublic, dateCreated: Date(), city: spotCity, didLike: false, likedCount: 0, verifierCount: 0, commentCount: 0, social: instagram)
                
                if isPublic {
                    let document = self.REF_POST.document(spotId)
                    document.setData(spotData) { (error) in
                            if let err = error {
                                print("Error uploading secret spot to database", err.localizedDescription)
                                completion(false)
                                return
                            }
                            print("Successfully saved secret spots to public world")
                            //Save to Feed
                            let feedDocument = self.REF_FEED.document()
                            let feedId = feedDocument.documentID
                            let feedData: [String: Any] = [
                                FeedField.id: feedId,
                                FeedField.uid: uid,
                                FeedField.username: ownerDisplayName,
                                FeedField.profileUrl: ownerImageUrl,
                                FeedField.bio: bio,
                                FeedField.rank: rank,
                                FeedField.date: FieldValue.serverTimestamp(),
                                FeedField.content: spotName,
                                FeedField.type: FeedType.spot.rawValue,
                                FeedField.longitude: userLong,
                                FeedField.spotId: spotId,
                                FeedField.latitude: userLat,
                                FeedField.geohash: userHash,
                                FeedField.stampImageUrl: downloadUrl
                            ]
                        
                            feedDocument.setData(feedData)
                    }
                }
                
                if !isPublic {
                    guard let tribe = self.tribe else {return}
                    if tribe == "" {return}
                    let document = self.REF_WORLDS
                                        .document(tribe)
                                        .collection(ServerPath.posts)
                                        .document(spotId)
                    document.setData(spotData)
                }
                        
                //Save to user's world
                let userWorldRef = self.REF_WORLD.document(ServerPath.secret).collection(uid).document(spotId)
                let savedData: [String: Any] =
                    ["savedOn": FieldValue.serverTimestamp()]
                userWorldRef.setData(savedData)
                    
                //Increment User StreetCred
                let increment: Int64 = 1
                let userData : [String: Any] = [
                    UserField.streetCred : FieldValue.increment(increment)
                ]
                AuthService.instance.updateUserField(uid: uid, data: userData)

                //Increment user's rankings
                let rankData: [String: Any] = [
                    RankingField.totalSpots : FieldValue.increment(increment)
                ]
                self.REF_Rankings.document(uid).updateData(rankData)
                    
                    
                DispatchQueue.main.async {
                    completion(true)
                    return
                }
                
  
            //end of Image Manager
        }
    }
        
}
    
    func saveToUserWorld(spot: SecretSpot, completion: @escaping (_ success: Bool) -> ()) {
        guard let uid = userId, let imageUrl = profileUrl, let displayName = displayName, let bio = bio
        else {return}
        let spotId = spot.id
        let feedDocument = REF_FEED.document()
        let feedId = feedDocument.documentID

        //Save swipe to history
        let historyData: [String: Any] =
            ["savedOn": FieldValue.serverTimestamp()]
        REF_WORLD.document(ServerPath.history)
                        .collection(uid)
                        .document(spotId)
                        .setData(historyData)

        //Increment view and save count by one
        let increment: Int64 = 1
        let data: [String: Any] = [
            SecretSpotField.viewCount: FieldValue.increment(increment),
            SecretSpotField.saveCount : FieldValue.increment(increment)
        ]
        REF_POST.document(spot.id).updateData(data)
        

        //Save post id in user's world
        
        let savedData: [String: Any] =
            ["savedOn": FieldValue.serverTimestamp(),
             UserField.displayName: displayName,
             UserField.profileImageUrl: imageUrl,
             UserField.providerId: uid,
             UserField.bio: bio,
             UserField.ig: social ?? ""
            ]
        
        REF_WORLD.document(ServerPath.secret).collection(uid).document(spotId).setData(savedData)

        //Add user to saved collection in spot
        REF_POST.document(spotId).collection(ServerPath.save).document(uid).setData(savedData) { [weak self] error in
            guard let self = self else {return}
            if let error = error {
                print("Error saving user to saved collection of secret spot", error.localizedDescription)
                completion(false)
                return
            }
            
            //Decrement buyer wallet remotely
            let decrement: Int64 = -1
            let userData : [String: Any] = [
                UserField.streetCred : FieldValue.increment(decrement)
            ]
            AuthService.instance.updateUserField(uid: uid, data: userData)
            
            
            //Increment owner wallet
            let ownerId = spot.ownerId
            let ownerWalletData: [String: Any] = [
                UserField.streetCred : FieldValue.increment(increment)
            ]
            AuthService.instance.updateUserField(uid: ownerId, data: ownerWalletData)
            let rank = self.rank ?? "Tourist"
            let userLong = self.locationManager.userlocation?.longitude ?? 0
            let userLat = self.locationManager.userlocation?.latitude ?? 0
            let userHash = GFUtils.geoHash(forLocation: CLLocationCoordinate2D(latitude: userLat, longitude: userLong))
            
            let feedData: [String: Any] = [
                FeedField.id: feedId,
                FeedField.uid: uid,
                FeedField.username: displayName,
                FeedField.profileUrl: imageUrl,
                FeedField.bio: bio,
                FeedField.rank: rank,
                FeedField.date: FieldValue.serverTimestamp(),
                FeedField.content: spot.spotName,
                FeedField.type: FeedType.save.rawValue,
                FeedField.spotId: spotId,
                FeedField.longitude: userLong,
                FeedField.latitude: userLat,
                FeedField.geohash: userHash
            ]
            
            feedDocument.setData(feedData)
            completion(true)
            
        }

    }
    
    
    func shareSecretSpot(user: User, spot: SecretSpot, completion: @escaping(Result<String, Error>) -> Void) {
        guard let uid = userId, let imageUrl = profileUrl, let displayName = displayName, let bio = bio
        else {return}
        
        let data: [String: Any] = [
            "spotId": spot.id,
            "spot_imageUrl": spot.imageUrls,
            "spot_title": spot.spotName,
            "from_userId": uid,
            "from_userImage": imageUrl,
            "from_username": displayName,
            "timestamp": FieldValue.serverTimestamp()
        ]
        
        let feedDocument = REF_FEED.document()
        let feedId = feedDocument.documentID

        let feedData: [String: Any] = [
            FeedField.id: feedId,
            FeedField.uid: uid,
            FeedField.username: displayName,
            FeedField.profileUrl: imageUrl,
            FeedField.bio: bio,
            FeedField.rank: rank ?? "Tourist",
            FeedField.date: FieldValue.serverTimestamp(),
            FeedField.content: user.displayName,
            FeedField.type: FeedType.share.rawValue,
            FeedField.spotId: spot.id,
        ]
        
        REF_WORLD
            .document(ServerPath.shared)
            .collection(user.id)
            .document(spot.id)
            .setData(data) { error in
                if let error = error {
                    print("Error sharing spot with user", error.localizedDescription)
                    completion(.failure(error))
                    return
                }
                
                if spot.isPublic {
                    feedDocument.setData(feedData)
                }
                let message = "Successfully shared spot with \(user.displayName)"
                completion(.success(message))
            }
        
    }
    
    
    func createTrail(name: String, details: String, image: UIImage, world: String, user: User, price: Int, spots: [SecretSpot]) {
        
        let users = [user]
        let document = REF_TRAILS.document()
        let trailId = document.documentID
        let userWorldRef = REF_TRAILS.document(ServerPath.secure).collection(user.id).document(trailId)

        ImageManager.instance.uploadTrailImage(image: image, numb: 1, trailId: trailId) { result in
            switch result {
            case .success(let imageUrl):
                let data: [String: Any] = [
                    TrailField.id: trailId,
                    TrailField.name: name,
                    TrailField.description: details,
                    TrailField.imageUrls: [imageUrl],
                    TrailField.dateCreated : FieldValue.serverTimestamp(),
                    TrailField.ownerId: user.id,
                    TrailField.ownerName: user.displayName,
                    TrailField.ownerImage: user.profileImageUrl,
                    TrailField.ownerRank: user.rank ?? "tourist",
                    TrailField.world: world,
                    TrailField.price: price,
                    TrailField.spots : spots.map({$0.id}),
                    TrailField.users: users.map({$0.id})
                ]
                
                document.setData(data) { error in
                    
                    if let error = error {
                        print("Error uploading trail to database", error.localizedDescription)
                    }
                    
                    print("Successfully saved trail to database")
                    let savedData: [String: Any] =
                        ["savedOn": FieldValue.serverTimestamp()]
                    userWorldRef.setData(savedData)
                    
                    //Increment user's wallet and world
                    let increment: Int64 = 3
                    let userData : [String: Any] = [
                        UserField.world : [world: FieldValue.increment(increment)],
                        UserField.streetCred : FieldValue.increment(increment)
                    ]
                    
                    let rankData: [String: Any] = [
                        RankingField.totalTrails: FieldValue.increment(Int64(1))
                    ]
                    
                    //Save to users profile and rank
                    AuthService.instance.updateUserField(uid: user.id, data: userData)
                    self.REF_Rankings.document(user.id).updateData(rankData)
                }
            case .failure(let error):
                print("There was error uploading image", error.localizedDescription)
            }
        }
    }
    
    
    func createWorld(name: String, details: String, email: String, req: String, reqSpots: Int, reqStamps: Int, hashtags: String, price: Int, completion: @escaping (Result<String, Error>) -> ()) {
        guard let uid = userId, let displayName = displayName, let profileUrl = profileUrl else {return}
        
        let reference = REF_WORLDS.document(name)
        let userRef = REF_USERS.document(uid)
        let worldId = reference.documentID
        let fcmToken = Messaging.messaging().fcmToken ?? ""

        let bio = bio ?? ""
        let longitude = LocationService.instance.userlocation?.longitude ?? 0
        let latitude = LocationService.instance.userlocation?.latitude ?? 0
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let geohash = GFUtils.geoHash(forLocation: location)
        
        let dotData: [String: Any] = [
            UserField.displayName: displayName,
            UserField.providerId: uid,
            UserField.profileImageUrl: profileUrl,
            UserField.tribe: name,
            UserField.bio: bio,
            UserField.rank: rank ?? "Tourist",
            UserField.longitude: longitude,
            UserField.latitude: latitude,
            UserField.geohash: geohash,
            UserField.fcmToken: fcmToken
        ]
        
        let userData: [String: Any] = [
            UserField.tribe: name,
            UserField.tribeJoinDate: FieldValue.serverTimestamp()
        ]
        
           
            let data: [String: Any] = [
                WorldField.id: worldId,
                WorldField.ownerEmail: email,
                WorldField.ownerId: uid,
                WorldField.ownerName: displayName,
                WorldField.ownerImageUrl: profileUrl,
                WorldField.name: name,
                WorldField.description: details,
                WorldField.initiationFee: price,
                WorldField.reqSpots: reqSpots,
                WorldField.reqStamps: reqStamps,
                WorldField.membersCount: 1,
                WorldField.reqString: req,
                WorldField.monthlyFee: 0,
                WorldField.hashtags: hashtags,
                WorldField.spotCount: 0,
                WorldField.dateCreated: FieldValue.serverTimestamp(),
                WorldField.isPublic: true,
                WorldField.isApproved: false
            ]
            
            reference.setData(data) { error in
                if let error = error {
                    print("Error creating world in DB", error.localizedDescription)
                    completion(.failure(error))
                }
                
                let memberData: [String: Any] =  [
                    UserField.providerId: uid,
                    UserField.displayName: displayName,
                    UserField.profileImageUrl: profileUrl,
                    UserField.bio: bio,
                    UserField.fcmToken: fcmToken,
                    WorldField.dateJoined: FieldValue.serverTimestamp()
                ]
                
                
                reference.collection(ServerPath.members).document(uid).setData(memberData) { error in
                    if let error = error {
                        print("Error saving user to world collection", error.localizedDescription)
                        completion(.failure(error))
                    }
                    let message = "Successfully Created World, \n an admin will email you soon."
                    userRef.updateData(userData)
                    reference.collection(ServerPath.maps).document(uid).setData(dotData)
                    UserDefaults.standard.set(name, forKey: CurrentUserDefaults.tribe)
                    completion(.success(message))
                    
                }
                
            }
            
        
        
    
                            
    }
    
    
    func createHunt(name: String, details: String, image: UIImage, startDate: Date, endDate: Date, location: MKMapItem, world: String, user: User, price: Int, spots: [SecretSpot]) {
        
        let users = [user]
        let address = location.getAddress()
        let longitude = location.placemark.coordinate.longitude
        let latitude = location.placemark.coordinate.latitude
        let city = location.getCity()
        
        let document = REF_HUNTS.document()
        let huntId = document.documentID
        let userWorldRef = REF_HUNTS.document(ServerPath.secure).collection(user.id).document(huntId)

        ImageManager.instance.uploadHuntImage(image: image, num: 1, huntId: huntId) { result in
            switch result {
            case .success(let imageUrl):
                let data: [String: Any] = [
                    TrailField.id: huntId,
                    TrailField.name: name,
                    TrailField.description: details,
                    TrailField.imageUrls: [imageUrl],
                    TrailField.address: address,
                    TrailField.longitude : longitude,
                    TrailField.latitude : latitude,
                    TrailField.city : city,
                    TrailField.startDate: startDate,
                    TrailField.endDate : endDate,
                    TrailField.dateCreated : FieldValue.serverTimestamp(),
                    TrailField.ownerId: user.id,
                    TrailField.ownerName: user.displayName,
                    TrailField.ownerImage: user.profileImageUrl,
                    TrailField.ownerRank: user.rank ?? "tourist",
                    TrailField.world: world,
                    TrailField.price: price,
                    TrailField.spots : spots.map({$0.id}),
                    TrailField.users: users.map({$0.id})
                ]
                
                document.setData(data) { error in
                    
                    if let error = error {
                        print("Error uploading trail to database", error.localizedDescription)
                    }
                    
                    print("Successfully saved trail to database")
                    
                    //Save trail on User branch
                    let savedData: [String: Any] =
                        ["savedOn": FieldValue.serverTimestamp()]
                    userWorldRef.setData(savedData)
                    
                    //Increment user's wallet and world
                    let increment: Int64 = 3
                    let userData : [String: Any] = [
                        UserField.world : [world: FieldValue.increment(increment)],
                        UserField.streetCred : FieldValue.increment(increment)
                    ]
                    let rankData: [String: Any] = [
                        RankingField.totalHunts: FieldValue.increment(Int64(1))
                    ]
                    
                    //Save to users profile and rank
                    AuthService.instance.updateUserField(uid: user.id, data: userData)
                    self.REF_Rankings.document(user.id).updateData(rankData)
                }
            case .failure(let error):
                print("There was error uploading image", error.localizedDescription)
            }
        }
    }
    
    
    
    func postComment(postId: String, uid: String, username: String, bio: String, imageUrl: String, content: String, completion: @escaping (_ success: Bool, _ commentId: String?) -> ()) {
        
        let document = REF_POST.document(postId).collection("comments").document()
        let commentId = document.documentID
        
        let data: [String: Any] = [
            CommentField.id : commentId,
            CommentField.uid : uid,
            CommentField.username : username,
            CommentField.bio : bio,
            CommentField.imageUrl : imageUrl,
            CommentField.content : content,
            CommentField.dateCreated : FieldValue.serverTimestamp()
        ]
        
        
        let increment: Int64 = 1
        let SpotData: [String: Any] = [
            SecretSpotField.commentCount: FieldValue.increment(increment),
        ]
        REF_POST.document(postId).updateData(SpotData)
        
        document.setData(data) { error in
            if let error = error {
                print("Error uploading comment to DB", error.localizedDescription)
                completion(false, nil)
                return
            } else {
                AnalyticsService.instance.postedComment()
                completion(true, commentId)
                return
            }
        }
        
        
    }
    
    func postStampComment(spotId: String, content: String, verifierId: String, user: User, completion: @escaping (Result<String?, UploadError>) -> Void) {
        let reference = REF_WORLD.document("verified").collection(verifierId).document(spotId).collection("comments").document()
        let commentId = reference.documentID
        
        let data: [String: Any] = [
            CommentField.id : commentId,
            CommentField.uid : user.id,
            CommentField.username : user.displayName,
            CommentField.bio : user.bio,
            CommentField.imageUrl : user.profileImageUrl,
            CommentField.content : content,
            CommentField.dateCreated : FieldValue.serverTimestamp()
        ]
        
       
        
        reference.setData(data) { [weak self] error in
            if let error = error {
                completion(.failure(.failed))
            } else {
                let increment: Int64 = 1
                let checkinData: [String: Any] = [
                    CheckinField.commentCount: FieldValue.increment(increment),
                ]
                self?.REF_WORLD.document("verified").collection(verifierId).document(spotId).updateData(checkinData)
                AnalyticsService.instance.postedComment()
                completion(.success(commentId))
                return
            }
           
        }

    }
    
    func likeVerification(postId: String, user: User, completion: @escaping (Result<String,Error>) -> Void) {
        guard let uid = userId, let imageUrl = profileUrl, let displayName = displayName else {return}
        let reference = REF_WORLD.document("verified")
                            .collection(user.id)
                            .document(postId)
        
        let increment: Int64 = 1
        let data: [String: Any] = [
            CheckinField.likeCount: FieldValue.increment(increment)
        ]
        let streetCred: Double = 0.1
        
        let userData : [String: Any] = [
            UserField.streetCred : FieldValue.increment(streetCred)
        ]
        AuthService.instance.updateUserField(uid: user.id, data: userData)

        reference.updateData(data)
        
        let likedData: [String: Any] = [
            UserField.providerId: uid,
            UserField.displayName: displayName,
            UserField.profileImageUrl: imageUrl,
            UserField.bio: bio ?? "",
            UserField.rank: rank ?? "Tourist",
            UserField.dataCreated: FieldValue.serverTimestamp()
        ]
        
        reference.collection("likedby")
            .document(uid)
            .setData(likedData) { error in
                if let error = error {
                    print("Error liking verification", error.localizedDescription)
                    completion(.failure(error))
                }
                
                let message = "Successfully liked \(user.displayName)'s stamp"
                completion(.success(message))
                
            }
        
    }
    
    
    func givePropsToUser(user: User, object: Verification, completion: @escaping (Result<String, Error>) -> Void) {
        guard let uid = userId, let imageUrl = profileUrl, let displayName = displayName else {return}
        
        let postId = object.postId
        let reference = REF_WORLD.document("verified")
                            .collection(user.id)
                            .document(postId)
        
        //Increment verifier wallet
        let streetCred: Int64 = 1
        let walletData: [String: Any] = [
            UserField.streetCred: FieldValue.increment(streetCred)
        ]
        AuthService.instance.updateUserField(uid: user.id, data: walletData)
        
     
        
        //Decrement User Wallet
        let decrement: Int64 = -1
        let userData: [String: Any] = [
            UserField.streetCred: FieldValue.increment(decrement)
        ]
        AuthService.instance.updateUserField(uid: uid, data: userData)

        
        //Increase the prop count of verification 
        let increment: Int64 = 1
        let data: [String: Any] = [
            CheckinField.props: FieldValue.increment(increment)
        ]
        reference.updateData(data)
        
        let propsData: [String: Any] = [
            UserField.providerId: uid,
            UserField.displayName: displayName,
            UserField.profileImageUrl: imageUrl,
            UserField.bio: bio ?? "",
            UserField.rank: rank ?? "Tourist",
            UserField.dataCreated: FieldValue.serverTimestamp()
        ]
        
        reference.collection("propsby")
            .document(uid)
            .setData(propsData) { error in
                if let error = error {
                    print("Error liking verification", error.localizedDescription)
                    completion(.failure(error))
                }
                
                let message = "Successfully gave props to \(user.displayName)"
                completion(.success(message))
                
            }
        
        
        let feedDocument = REF_FEED.document()
        
        let feedData: [String: Any] = [
            FeedField.id: object.verifierId,
            FeedField.uid: uid,
            FeedField.username: displayName,
            FeedField.profileUrl: imageUrl,
            FeedField.date: FieldValue.serverTimestamp(),
            FeedField.content: object.verifierName,
            FeedField.type: FeedType.props.rawValue,
            FeedField.spotId: object.postId,
        ]
        
        feedDocument.setData(feedData)

    }
    
    func sendMessage(user: User, content: String, completion: @escaping (Result<Message,UploadError>) -> ()) {
        guard let fromId = userId, let profileUrl = profileUrl, let bio = bio, let displayName = displayName, let rank = rank else {return}

        let senderDocument = REF_MESSAGES.document(fromId).collection(user.id).document()
        let recipientDocument = REF_MESSAGES.document(user.id).collection(fromId).document()
        
        let messageData: [String: Any] = [
            MessageField.id: senderDocument.documentID,
            MessageField.fromId: fromId,
            MessageField.toId: user.id,
            MessageField.content: content,
            MessageField.timestamp: FieldValue.serverTimestamp()
        ]
        
        let recentMessageData: [String: Any] = [
            MessageField.id: senderDocument.documentID,
            MessageField.timestamp: FieldValue.serverTimestamp(),
            MessageField.fromId: fromId,
            MessageField.profileUrl: profileUrl,
            MessageField.displayName: displayName,
            MessageField.rank: rank,
            MessageField.bio: bio,
            MessageField.toId: user.id,
            MessageField.content: content,
            MessageField.userId: fromId
        ]
        
        let message = Message(data: messageData)
        persistRecentMessage(toId: user.id, data: recentMessageData)
        
        recipientDocument.setData(messageData) { error in
            if let error = error {
                print("Error sending message to recipient", error.localizedDescription)
                completion(.failure(.failed))
            }
            
            senderDocument.setData(messageData) { error in
                if let error = error {
                    print("Error logging message to sender", error.localizedDescription)
                    completion(.failure(.failed))
                }
                DispatchQueue.main.async {
                    completion(.success(message))
                }
            }
        }
    }
    
    func persistRecentMessage(toId: String, data: [String: Any]) {
        guard let fromId = userId else {return}
        
        let document = REF_RECENTMESSAGE
                            .document(toId)
                            .collection("messages")
                            .document(fromId)
        
        
        document.setData(data)
    }
    
    func fetchRecentMessages(completion: @escaping (Result<([RecentMessage], Int), Error>) -> Void) {
        guard let uid = userId else {return}
        var messages: [RecentMessage] = []
        REF_RECENTMESSAGE
            .document(uid)
            .collection("messages")
            .addSnapshotListener { querySnapshot, error in
                
                if let error = error {
                    print("Error fetching recent messages", error.localizedDescription)
                    completion(.failure(error))
                }
                
                guard let snapshot = querySnapshot else {return}
                let count = snapshot.documentChanges.count
                snapshot.documentChanges.forEach({ change in
                    if change.type == .added {
                        let data = change.document.data()
                        let message = RecentMessage(data: data)
                        messages.insert(message, at: 0)
                    }
                })
                completion(.success((messages, count)))
            }
        
    }
    
    func deleteRecentMessages(user: String) {
        
        guard let uid = userId else {return}
        
        REF_RECENTMESSAGE
            .document(uid)
            .collection("messages")
            .document(user)
            .delete()
    }
    
    
    func downloadStampComments(verificationId: String, uid: String, completion: @escaping (_ comments: [Comment]) -> ()) {
        
        REF_WORLD.document("verified").collection(uid).document(verificationId).collection("comments").order(by: CommentField.dateCreated, descending: false).getDocuments { querysnapshot, error in
            guard let snapshot = querysnapshot else {return}
            DispatchQueue.main.async {
                completion(self.getCommentsFromSnapshot(snapshot: snapshot))
            }
        }
        
    }
    
    func postFeedMessage(content: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let uid = userId, let imageUrl = profileUrl, let displayName = displayName, let bio = bio
        else {return}
        let feedDocument = REF_FEED.document()
        let feedId = feedDocument.documentID
        
        let rank = self.rank ?? "Tourist"
        let userLong = self.locationManager.userlocation?.longitude ?? 0
        let userLat = self.locationManager.userlocation?.latitude ?? 0
        let userHash = GFUtils.geoHash(forLocation: CLLocationCoordinate2D(latitude: userLat, longitude: userLong))
        
        let feedData: [String: Any] = [
            FeedField.id: feedId,
            FeedField.uid: uid,
            FeedField.username: displayName,
            FeedField.profileUrl: imageUrl,
            FeedField.bio: bio,
            FeedField.rank: rank,
            FeedField.date: FieldValue.serverTimestamp(),
            FeedField.content: content,
            FeedField.type: FeedType.message.rawValue,
            FeedField.longitude: userLong,
            FeedField.latitude: userLat,
            FeedField.geohash: userHash
        ]
        
        feedDocument.setData(feedData) { error in
            
            if let error = error {
                print("Error sending feed to FB", error.localizedDescription)
                completion(.failure(error))
            }
            
            let decrement: Int64  = -1
            let walletData: [String: Any] = [
                UserField.streetCred : FieldValue.increment(decrement)
            ]
            
            AuthService.instance.updateUserField(uid: uid, data: walletData)
            completion(.success(true))
            
        }
        
        
    }
    

    func checkIfVerificationExist(spotId: String, completion: @escaping(Result<Bool,Error>) -> Void) {
        guard let uid = userId else {return}
        
        let ref = REF_WORLD.document(ServerPath.verified).collection(uid).document(spotId)
        
        ref.getDocument { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let snapshot = snapshot else {completion(.success(false)); return}
            if snapshot.exists {
                completion(.success(true))
            }
        }
    }
    
    
    func updateStamp(spot: SecretSpot, image: UIImage?, comment: String?, completion: @escaping (Result<Bool, Error>) -> ()) {
        guard let uid = userId, let profileUrl = profileUrl, let bio = bio, let displayName = displayName else {return}
        let postId = spot.id
        let ownerId = spot.ownerId
        let feedDocument = REF_FEED.document()
        let feedId = feedDocument.documentID
        
        let ref = REF_WORLD.document(ServerPath.verified).collection(uid).document(postId)
        let dateFormatter = DateFormatter()
        let date = Date()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMMd")
        let time = dateFormatter.string(from: date)
        

        let updateData: [String: Any] = [
            CheckinField.timestamp: FieldValue.serverTimestamp(),
            CheckinField.verifierImage : profileUrl,
            CheckinField.checkins: [time:FieldValue.serverTimestamp()]
        ]
        
        if let image = image {
            let imageSaver = ImageSaver()
            imageSaver.writeToPhotoAlbum(image: image)
            ImageManager.instance.uploadVerifyImage(image: image, userId: uid, postId: postId) { url in
                if let imageUrl = url {
                    let imageData: [String: Any] = [
                        CheckinField.image: imageUrl
                    ]
                    ref.updateData(imageData)
                }
            }
        }
        
        if let comment = comment {
            if !comment.isEmpty {
                let commentData: [String: Any] = [
                    CheckinField.comment: comment
                ]
                ref.updateData(commentData)
            }
        }
        
        ref.setData(updateData, merge: true) { [weak self] error in
            guard let self = self else {return}
            if let error = error {
                completion(.failure(error))
                return
            }
            //Update verifier wallet
            let checkinIncrement: Int64 = 1
            let verifierWalletData: [String: Any] = [
                UserField.streetCred : FieldValue.increment(checkinIncrement)
            ]
            let verifierRankData: [String: Any] = [
                RankingField.totalStamps: FieldValue.increment(checkinIncrement)
            ]
            self.REF_Rankings.document(uid).updateData(verifierRankData)
            AuthService.instance.updateUserField(uid: uid, data: verifierWalletData)
            //Update owner wallet
            let ownerWalletData: [String: Any] = [
                UserField.streetCred : FieldValue.increment(checkinIncrement)
            ]
           
            let ownerRankData: [String: Any] = [
                RankingField.totalVerifications: FieldValue.increment(checkinIncrement)
            ]
            self.REF_Rankings.document(ownerId).updateData(ownerRankData)
            AuthService.instance.updateUserField(uid: ownerId, data: ownerWalletData)
            
            //Update Last Verified
            self.manager.updateLastVerified(spotId: postId, date: Date())
            
            //Update Feed
            let rank = self.rank ?? "Tourist"
            let userLong = self.locationManager.userlocation?.longitude ?? 0
            let userLat = self.locationManager.userlocation?.latitude ?? 0
            let userHash = GFUtils.geoHash(forLocation: CLLocationCoordinate2D(latitude: userLat, longitude: userLong))
            
            let feedData: [String: Any] = [
                FeedField.id: feedId,
                FeedField.uid: uid,
                FeedField.username: displayName,
                FeedField.profileUrl: profileUrl,
                FeedField.bio: bio,
                FeedField.rank: rank,
                FeedField.date: FieldValue.serverTimestamp(),
                FeedField.content: spot.spotName,
                FeedField.type: FeedType.stamp.rawValue,
                FeedField.spotId: postId,
                FeedField.longitude: userLong,
                FeedField.latitude: userLat,
                FeedField.geohash: userHash
            ]
            
            feedDocument.setData(feedData)
            completion(.success(true))
        }
        
    }
    
    
    
    func verifySecretSpot(spot: SecretSpot, image: UIImage, comment: String, completion: @escaping (_ success: Bool, _ error: String?) ->()) {
        guard let uid = userId, let username = displayName, let profileUrl = profileUrl, let bio = bio else {return}
        let feedDocument = REF_FEED.document()
        let feedId = feedDocument.documentID
        let postId = spot.id
        let ownerId = spot.ownerId
       
        
        let dateFormatter = DateFormatter()
        let date = Date()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMMd")
        let time = dateFormatter.string(from: date)
     
        ImageManager.instance.uploadVerifyImage(image: image, userId: uid, postId: postId) { [weak self] url in
            if let imageUrl = url {
                
                let checkinData: [String: Any] = [
                    CheckinField.comment: comment,
                    CheckinField.image: imageUrl,
                    CheckinField.veriferName: username,
                    CheckinField.verifierImage: profileUrl,
                    CheckinField.verifierId: uid,
                    CheckinField.spotOwnerId: ownerId,
                    CheckinField.spotId: postId,
                    CheckinField.city: spot.city,
                    CheckinField.spotName: spot.spotName,
                    CheckinField.latitude: spot.latitude,
                    CheckinField.longitude: spot.longitude,
                    CheckinField.country: spot.country,
                    CheckinField.timestamp: FieldValue.serverTimestamp(),
                    CheckinField.checkins: [time:FieldValue.serverTimestamp()]
                ]
                
                self?.REF_WORLD.document(ServerPath.verified).collection(uid).document(postId).setData(checkinData)
                
                let checkinIncrement: Int64 = 1
                let fieldUpdate: [String: Any] = [
                    SecretSpotField.verifierImages: FieldValue.arrayUnion([imageUrl]),
                    SecretSpotField.verifierCount: checkinIncrement
                ]
                
                self?.REF_POST.document(postId).updateData(fieldUpdate)
                
                self?.REF_POST.document(postId).collection("verifiers").document(uid).setData(checkinData) { [weak self] error in
                    guard let self = self else {return}
                    if let error = error {
                        print("Error saving check-in to database", error.localizedDescription)
                        completion(false, error.localizedDescription)
                        return
                    }
                    
                    let oneIncrement: Int64 = 1
                    let verifierIncrement: Int64 = 3
                    
                    //Update verifier info
                    let verifierWalletData: [String: Any] = [
                        UserField.streetCred : FieldValue.increment(verifierIncrement)
                    ]
                    let verifierRankData: [String: Any] = [
                        RankingField.totalStamps: FieldValue.increment(oneIncrement)
                    ]
                    self.REF_Rankings.document(uid).updateData(verifierRankData)
                    AuthService.instance.updateUserField(uid: uid, data: verifierWalletData)
                    
                    
                    //Update owner info
                    let ownerWalletData: [String: Any] = [
                        UserField.streetCred : FieldValue.increment(oneIncrement)
                    ]
                   
                    let ownerRankData: [String: Any] = [
                        RankingField.totalVerifications: FieldValue.increment(oneIncrement)
                    ]
                    self.REF_Rankings.document(ownerId).updateData(ownerRankData)
                    AuthService.instance.updateUserField(uid: ownerId, data: ownerWalletData)
                    
                    //Update Feed
                    let rank = self.rank ?? "Tourist"
                    let userLong = self.locationManager.userlocation?.longitude ?? 0
                    let userLat = self.locationManager.userlocation?.latitude ?? 0
                    let userHash = GFUtils.geoHash(forLocation: CLLocationCoordinate2D(latitude: userLat, longitude: userLong))
                    
                    let feedData: [String: Any] = [
                        FeedField.id: feedId,
                        FeedField.uid: uid,
                        FeedField.username: username,
                        FeedField.profileUrl: profileUrl,
                        FeedField.bio: bio,
                        FeedField.rank: rank,
                        FeedField.date: FieldValue.serverTimestamp(),
                        FeedField.content: spot.spotName,
                        FeedField.type: FeedType.stamp.rawValue,
                        FeedField.spotId: postId,
                        FeedField.longitude: userLong,
                        FeedField.latitude: userLat,
                        FeedField.geohash: userHash
                    ]
                    
                    feedDocument.setData(feedData)
                    completion(true, nil)
                }
            } else {
                let message = "Error uploading verification to Database"
                completion(false, message)
                print("Error uploading verification image to DB")
            }
        }
        
    }
    
    func changeStampPhoto(postId: String, image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        guard let uid = userId else {return}
        let ref = REF_WORLD.document(ServerPath.verified).collection(uid).document(postId)
        
        let decrement: Int64 = -1
        let walletData: [String: Any] = [
            UserField.streetCred : FieldValue.increment(decrement)
        ]
        AuthService.instance.updateUserField(uid: uid, data: walletData)

        ImageManager.instance.uploadVerifyImage(image: image, userId: uid, postId: postId) { url in
            if let imageUrl = url {
                let imageData: [String: Any] = [
                    CheckinField.image: imageUrl
                ]
                
                ref.updateData(imageData) { error in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    
                    completion(.success(imageUrl))
                }
                
            }
        }
        
    }
    
    func getVerifications(uid: String, completion: @escaping (_ verifications: [Verification]) ->()) {
        
        REF_WORLD.document("verified").collection(uid).getDocuments { [weak self] querySnapshot, error in
            guard let self = self else {return}
            
            var verifications: [Verification] = []
            if let error = error {
                print("Error fetching verifications", error.localizedDescription)
                return
            }
            
            if let snapshot = querySnapshot, snapshot.count > 0 {
                snapshot.documents.forEach { document in
                    let data = document.data()
                    let verification = Verification(data: data)
                    self.manager.addStampEntity(verification: verification)
                    verifications.append(verification)
                }
                completion(verifications)
            }
            
        }
    }
    
    
    
    
    func checkIfUserAlreadyVerified(spot: SecretSpot, completion: @escaping (_ doesExist: Bool) ->()) {
        guard let uid = userId else {return}
        let postId = spot.id
        
        REF_WORLD.document("verified").collection(uid).document(postId).getDocument { snapshot, error in
            
            if let error = error {
                print("Error getting document", error.localizedDescription)
                return
            }
            
            guard let data = snapshot else {return}
            if data.exists {
                completion(true)
                return
            } else {
                completion(false)
                return
            }
            
        }
    }
    
    
    func dismissCard(spot: SecretSpot, completion: @escaping (_ success: Bool) -> ()) {
      
        let spotId = spot.id
        
        //save swipe to history
        let historyData: [String: Any] =
            ["passedOn": FieldValue.serverTimestamp()]
        guard let uid = userId else {return}
        REF_WORLD.document("history").collection(uid).document(spotId).setData(historyData)
        
        
        //Increment view by one
        let increment: Int64 = 1
        let data: [String: Any] = [
            SecretSpotField.viewCount: FieldValue.increment(increment)
        ]
        
        REF_POST.document(spot.id).updateData(data) { error in
            if let error = error {
                print("There was an error updating view card while dismissing card", error.localizedDescription)
                completion(false)
                return
            }
            
            print("Successfully updated view count while dismissing card")
            completion(true)
        }
        
    }
    
    func uploadReports(reason: String, postId: String, completion: @escaping (_ success: Bool) -> ()) {
        guard let uid = userId else {return}
        
        let data: [String:Any] = [
            DatabaseReportField.content: reason,
            DatabaseReportField.postId: postId,
            DatabaseReportField.ownerId: uid,
            DatabaseReportField.dateCreated: FieldValue.serverTimestamp()
        ]
        
        REF_REPORTS.addDocument(data: data) { err in
            
            if let error = err {
                print("Error reporting secret spot", error.localizedDescription)
                completion(false)
                return
            } else {
                print("Successfully reported secret spot")
                completion(true)
                return
            }
        }
    }
    
    
    
    //MARK: GET FUNCTIONS
    
//    func downloadSavedPostForUser(userId: String, completion: @escaping (_ spots: [SecretSpot]) -> ()) {
//        REF_USERS.document(userId).collection("world").addSnapshotListener { [self] (querysnapshot, error) in
//            completion(self.getSecretSpotsFromSnapshot(querysnapshot: querysnapshot))
//        }
//    }
    
    func fetchFriendRequest(completion: @escaping (Result<[User],Error>) -> () ) {
        
        guard let uid = userId else {return}
        var friends: [User] = []
        REF_USERS
            .document(uid)
            .collection(ServerPath.request)
            .getDocuments { snapshot, error in
                
                if let error = error {
                    print("Error fetching friend request", error.localizedDescription)
                    completion(.failure(error))
                    return
                }
                
                guard let snapshot = snapshot else {return}
                if snapshot.isEmpty {
                    completion(.success(friends))
                    return
                }
                
                snapshot.documents.forEach { document in
                    let data = document.data()
                    let user = User(data: data)
                    friends.append(user)
                }
                completion(.success(friends))
                
            }
        
    }
    
    func fetchWorldRequest(completion: @escaping (Result<[World],Error>) -> () ) {
        guard let uid = userId else {return}
        
        var worlds:[World] = []
        
        REF_USERS
            .document(uid)
            .collection(ServerPath.invite)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching world invitations", error.localizedDescription)
                    completion(.failure(error))
                    return
                }
                
                guard let snapshot = snapshot else {return}
                snapshot.documents.forEach { document in
                    let data = document.data()
                    let world = World(data: data)
                    worlds.append(world)
                }
                
                completion(.success(worlds))
            
            }
    }
    
    func checkIfUserHasSpots(uid: String, completion: @escaping (_ true: Bool) -> ()) {
        
        REF_WORLD.document("private").collection(uid).getDocuments { querysnapshot, error in
            
            if let error = error {
                print("Error getting user spots", error.localizedDescription)
                return
            }
            
            if let querysnapshot = querysnapshot, querysnapshot.count > 0 {
                querysnapshot.documents.forEach { snapshot in
                    
                    
                    self.REF_POST.whereField(SecretSpotField.ownerId, isEqualTo: uid).getDocuments { querySnapshot, err in
                        
                        if let error = err {
                            print("Error checking if user has spots", error.localizedDescription)
                            return
                        }
                        
                        if let snapshot = querySnapshot, snapshot.count > 0 {
                            completion(true)
                            print("User has already posted a Secret Spot")
                        } else {
                            completion(false)
                            print("User has not posted a Secret Spot")
                        }
                        
                    }
                }
            }
        }
    }
    
    func getPublicWorlds(completion: @escaping (Result<[World],Error>) -> ()) {
        
        var worlds: [World] = []
        REF_WORLDS
            .whereField(WorldField.isPublic, isEqualTo: true)
            .getDocuments { snapshot, error in
            if let error = error {
                print("Error pulling worlds from database", error.localizedDescription)
                completion(.failure(error))
            }
            
            guard let snapshot = snapshot, snapshot.documents.count >= 1 else {return}

            snapshot.documents.forEach { document in
                let data = document.data()
                let world = World(data: data)
                worlds.append(world)
            }
            completion(.success(worlds))
        }
    }
    
    func getSpecificWorld(name: String, completion: @escaping (Result<World, Error>) -> ()) {
        REF_WORLDS
            .whereField(WorldField.name, isEqualTo: name)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error finding specific world", error.localizedDescription)
                    completion(.failure(error))
                }
                
                guard let data = snapshot?.documents.first?.data() else {return}
                let world = World(data: data)
                completion(.success(world))
            }
    }
    
    func getWorldInvites(completion: @escaping (Result<World, Error>) -> ()) {
        guard let uid = userId else {return}
        REF_USERS
            .document(uid)
            .collection(ServerPath.invite)
            .getDocuments { [weak self] querySnapshot, error in
                guard let self = self else {return}
                if let error = error {
                    print("Error fetching invitations for user", error.localizedDescription)
                    return
                }
                
                guard let snapshot = querySnapshot else {
                    print("No invitation found")
                    return}
                
                if snapshot.isEmpty {
                    let error = NetworkError.empty
                    completion(.failure(error))
                }
                
                snapshot.documents.forEach { document in
                    let data = document.data()
                    let name = data[UserField.tribe] as? String  ?? ""
                    print("World name is", name)
                    self.getSpecificWorld(name: name) { result in
                        switch result {
                        case .failure(let error):
                            print("Error fetching world", error.localizedDescription)
                            completion(.failure(error))
                        case .success(let world):
                            completion(.success(world))
                        }
                    }
                    
                }
            }
        
    }
    
    func denyInvitation(name: String,completion: @escaping (Result<Bool, Error>) -> ()) {
        guard let uid = userId else {return}
        REF_USERS
            .document(uid)
            .collection(ServerPath.invite)
            .document(name)
            .delete()
        completion(.success(true))
    }
    
    func sendWorldInvite(user: User, competion: @escaping (Result<String, Error>) -> ()) {
        guard let uid = userId, let imageUrl = profileUrl, let displayName = displayName, let tribe = tribe
        else {return}
        
        let inviteData: [String: Any] = [
            UserField.displayName: displayName,
            UserField.providerId: uid,
            UserField.profileImageUrl: imageUrl,
            UserField.tribeImageUrl: tribeImageUrl ?? "",
            UserField.tribe: tribe,
            UserField.dataCreated: FieldValue.serverTimestamp()
        ]
        
        REF_USERS
            .document(user.id)
            .collection(ServerPath.invite)
            .document(tribe)
            .setData(inviteData) { error in
                
                if let error = error {
                    print("Error finding user in collection", error.localizedDescription)
                    competion(.failure(error))
                }
                
                let message = "Successfully sent invitation"
                competion(.success(message))
            }
    }
    
    
    
    func joinWorld(world: World, completion: @escaping (Result<String, Error>) -> ()) {
        
        guard let uid = userId, let imageUrl = profileUrl, let displayName = displayName else {return}
        
        let fcmToken = Messaging.messaging().fcmToken ?? ""
        //Set User defaults
        UserDefaults.standard.set(world.name, forKey: CurrentUserDefaults.tribe)
        UserDefaults.standard.set(world.imageUrl, forKey: CurrentUserDefaults.tribeImageUrl)
        
        
        let data: [String: Any] = [
            UserField.tribe: world.name,
            UserField.tribeImageUrl: world.imageUrl,
            UserField.providerId: uid,
            UserField.displayName: displayName,
            UserField.bio: bio ?? "",
            UserField.profileImageUrl: imageUrl,
            UserField.fcmToken: fcmToken,
            WorldField.dateJoined: FieldValue.serverTimestamp()
        ]
        
        
        let userData: [String: Any] = [
            UserField.tribe: world.name,
            UserField.tribeImageUrl: world.imageUrl,
            UserField.tribeJoinDate: FieldValue.serverTimestamp()
        ]
        
        AuthService.instance.updateUserField(uid: uid, data: userData)
        
        let longitude = LocationService.instance.userlocation?.longitude ?? 0
        let latitude = LocationService.instance.userlocation?.latitude ?? 0
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let geohash = GFUtils.geoHash(forLocation: location)
        
        let dotData: [String: Any] = [
            UserField.displayName: displayName,
            UserField.providerId: uid,
            UserField.profileImageUrl: imageUrl,
            UserField.tribe: world.name,
            UserField.tribeImageUrl: world.imageUrl,
            UserField.bio: bio ?? "",
            UserField.rank: rank ?? "Tourist",
            UserField.longitude: longitude,
            UserField.latitude: latitude,
            UserField.geohash: geohash,
            UserField.fcmToken: fcmToken
        ]
        
        REF_WORLDS.document(world.name).collection(ServerPath.maps).document(uid).setData(dotData)

        REF_WORLDS
            .document(world.name)
            .collection(ServerPath.members)
            .document(uid)
            .setData(data) { [weak self] error in
                
                guard let self = self else {return}
                
                if let error = error {
                    print("error adding user as new world member", error.localizedDescription)
                    return
                }
                
                let message = "Successfully joined the \(world.name) community"
                                
                let increment: Int64 = 1
                let incremementData: [String: Any] = [
                    WorldField.membersCount: FieldValue.increment(increment)
                ]
                
                self.REF_WORLDS.document(world.name).updateData(incremementData)
                self.REF_USERS.document(uid).collection(ServerPath.invite).document(world.name).delete()
                
                completion(.success(message))
            }
    
    }
    
    func getCityFeed(completion: @escaping (Result<[Feed],Error>) -> Void) {
        var feeds: [Feed] = []
        REF_FEED
            .order(by: FeedField.date, descending: true)
            .limit(to: 15)
            .getDocuments { querySnapshot, error in
                
                if let error = error {
                    print("Error fetching feed from database", error.localizedDescription)
                    completion(.failure(error))
                }
                
                querySnapshot?.documents.forEach({ document in
                        let data = document.data()
                        let feed = Feed(data: data)
                        feeds.insert(feed, at: 0)
                })
                completion(.success(feeds))

            }
    }
    
    func getMessagesForUser(userID: String, completion: @escaping (Result<[Message], NetworkError>) -> ()) {
        guard let uid = userId else {return}
        var messages: [Message] = []
        REF_MESSAGES
            .document(uid)
            .collection(userID)
            .addSnapshotListener { querySnapshot, error in
                
                if let error = error {
                    print("Error finding message collection for user", error.localizedDescription)
                    completion(.failure(.failed))
                }
                
                querySnapshot?.documentChanges.forEach({ change in
                    if change.type == .added {
                        let data = change.document.data()
                        let message = Message(data: data)
                        messages.append(message)
                    }
                })
                DispatchQueue.main.async {
                    completion(.success(messages))
                }
            }
        
    }
    
    
    func getSpotsFromWorld(userId: String, completion: @escaping (_ spots: [SecretSpot]) -> ()) {
        REF_WORLD.document("private").collection(userId).getDocuments { snapshot, error in
            var secretSpots = [SecretSpot]()
            
            if let error = error {
                print("Error fetching the secret spots from user's branch", error.localizedDescription)
                return
            }


            if let snapshot = snapshot, snapshot.documents.count > 0 {
                print("Found Secret Spots in User's World")
                snapshot.documents.forEach { document in
                    print("Found document")
                    let spotId = document.documentID
                    self.REF_POST.document(spotId).getDocument { document, error in
                        let data = document?.data()
                        let spot = SecretSpot(data: data)
                        if let spot = spot {
                            secretSpots.append(spot)
                            CoreDataManager.instance.addEntityFromSpot(spot: spot)
                        }
                        
                        //Save to core data here!
                        
                        DispatchQueue.main.async {
                            completion(secretSpots)
                        }
                }
            }
               
            } else {
                completion([])
                print("No secret spot found in user's private world")
            }
    }
        
}
    
    func getUsersFromWorldMap(world: String, completion: @escaping (Result<[User], Error>) -> ()) {
        var users: [User] = []
        
        REF_WORLDS
            .document(world)
            .collection(ServerPath.maps)
            .getDocuments { querySnapshot, error in
                if let error = error {
                    print("Error fetching users from world", error.localizedDescription)
                    completion(.failure(error))
                    return
                }
                
                guard let snapshot = querySnapshot else {return}
                
                if snapshot.isEmpty {
                    print("World map is empty")
                    completion(.success(users))
                    return
                }
                
                snapshot.documents.forEach { document in
                    let data = document.data()
                    let user = User(data: data)
                    users.append(user)
                }
                completion(.success(users))
            }
    }
    
    func notifyNearbyMember(user: User) {
        guard let uid = userId, let imageUrl = profileUrl, let displayName = displayName, let tribe = tribe else {return}
        let fcmToken = Messaging.messaging().fcmToken ?? ""
        let rank = rank ?? ""
        let bio = bio ?? ""
    
        
        let data: [String:Any] = [
            UserField.providerId: uid,
            UserField.profileImageUrl: imageUrl,
            UserField.displayName: displayName,
            UserField.fcmToken: fcmToken,
            UserField.bio: bio,
            UserField.rank: rank,
            UserField.nearbyToken: user.fcmToken ?? "",
            UserField.tribe: tribe
        ]
        
        REF_USERS
            .document(user.id)
            .collection(ServerPath.nearby)
            .document(uid)
            .setData(data)
        
    }
    
    
    func getNewSecretSpots(completion: @escaping (Result<[SecretSpot], Error>) -> ()) {
        var history : [String] = []

        guard let uid = userId else
            {
            REF_POST
                .order(by: SecretSpotField.dateCreated, descending: true)
                .limit(to: 100)
                .getDocuments { snapshot, error in
                    if let error = error {
                        print("error fetching spots for public world", error.localizedDescription)
                        completion(.failure(error))
                        return
                    }
                    let results = self.getSecretSpotsFromSnapshot(querysnapshot: snapshot)
                    completion(.success(results))
            }
            return
        }
        
        getUserHistory { [weak self] returnedHistory in
            
            history = returnedHistory
            guard let self = self else {return}

            self.REF_POST
                .order(by: SecretSpotField.dateCreated, descending: true)
                .getDocuments { querysnapshot, error in
                    if let error = error {
                        print("Error fetching secret spots", error.localizedDescription)
                        completion(.failure(error))
                        return
                    }
                    let results = self.getSecretSpotsFromSnapshot(querysnapshot: querysnapshot)
                    var filteredResults = results.filter({  $0.ownerId != uid &&
                                                            !history.contains($0.id)})
                    
                    guard let tribe = self.tribe else {completion(.success(filteredResults)); return}
                    if tribe == "" {completion(.success(filteredResults)); return}
                    self.REF_WORLDS
                        .document(tribe)
                        .collection(ServerPath.posts)
                        .getDocuments { querySnapshot, error in
                            guard let snapshot = querySnapshot else {completion(.success(filteredResults)); return}
                            if snapshot.isEmpty {completion(.success(filteredResults)); print("World spots is empty"); return}
                            let worldSpots = self.getSecretSpotsFromSnapshot(querysnapshot: querySnapshot)
                            let filteredWorld = worldSpots.filter({  $0.ownerId != uid &&
                                                                    !history.contains($0.id)})
                            filteredResults.insert(contentsOf: filteredWorld, at: 0)
                            completion(.success(filteredResults))
                        }
                
                }
            
        }
     
    }
    
    func getSpecificSpot(postId: String, completion: @escaping (Result<SecretSpot, Error>) -> Void) {
        
        REF_POST
            .document(postId)
            .getDocument { querySnapshot, error in
                if let error = error {
                    print("Error finding specific spot in world", error.localizedDescription)
                    completion(.failure(error))
                    return
                }
                guard let snapshot = querySnapshot else {return}
                let data = snapshot.data()
                let secretSpot = SecretSpot(data: data)
                if let spot = secretSpot {
                    completion(.success(spot))
                }
            }
    }
    
    func getSpecificWorldSpot(postId: String, completion: @escaping (Result<SecretSpot, Error>) -> Void) {
        guard let tribe = tribe else {return}
        if tribe == "" {return}
        
        REF_WORLDS
            .document(tribe)
            .collection(ServerPath.posts)
            .document(postId)
            .getDocument { querySnapshot, error in
                if let error = error {
                    print("Error finding specific spot in world", error.localizedDescription)
                    completion(.failure(error))
                    return
                }
                guard let snapshot = querySnapshot else {return}
                let data = snapshot.data()
                let secretSpot = SecretSpot(data: data)
                if let spot = secretSpot {
                    completion(.success(spot))
                }
            }
        
    }
    
    func getSpecificVerification(postId: String, uid: String, completion: @escaping (Result<Verification, NetworkError>) -> Void) {
        
        
        REF_WORLD
            .document(ServerPath.verified)
            .collection(uid)
            .document(postId)
            .getDocument { snapshot, error in
                if let error = error {
                    print("Error retrieving verification object", error.localizedDescription)
                    completion(.failure(.failed))
                }
                print("Found specific verification")
                guard let data = snapshot?.data() else {return}
                print("Data is found")
                let verification = Verification(data: data)
                print(verification)
                completion(.success(verification))
                
            }
        
    }
    
    
    func refreshSecretSpots(completion: @escaping (_ spots: [SecretSpot]) -> ()) {
        guard let uid = userId else {return}
        var history: [String] = []
        var lastSnapshot: QueryDocumentSnapshot?

        getUserHistory { [weak self] returnedHistory in
            guard let self = self else {return}
            history = returnedHistory
            
            if let snapshot = lastSnapshot {
                self.REF_POST
                    .start(afterDocument: snapshot)
                    .limit(to: 30)
                    .getDocuments { querysnapshot, error in
                        let results = self.getSecretSpotsFromSnapshot(querysnapshot: querysnapshot)
                        let filteredResults = results.filter({$0.isPublic == true
                                                                && $0.ownerId != uid
                                                                && !history.contains($0.id)})
                        completion(filteredResults)
                        lastSnapshot = querysnapshot?.documents.last
                    }
            } else {
                self.REF_POST
                    .limit(to: 30)
                    .getDocuments { querysnapshot, error in
                        let results = self.getSecretSpotsFromSnapshot(querysnapshot: querysnapshot)
                        let filteredResults = results.filter({$0.isPublic == true
                                                                && $0.ownerId != uid
                                                                && !history.contains($0.id)})
                        completion(filteredResults)
                        lastSnapshot = querysnapshot?.documents.last
            }
           
        }
        
    }
    
}
    
    func fetchAllUserFriends(completion: @escaping (Result<[User],NetworkError>) -> Void) {
        guard let uid = userId else {return}
        var users: [User] = []
        REF_WORLD
            .document(ServerPath.friends)
            .collection(uid)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error finding friends in user path", error.localizedDescription)
                    completion(.failure(.failed))
                    return
                }
                
                guard let snapshot = snapshot, snapshot.documents.count > 0 else {return}
                snapshot.documents.forEach { document in
                    let data = document.data()
                    let user = User(data: data)
                    users.append(user)
                }
                completion(.success(users))
                
            }
          
    }
    
    
    func saveNewUserAsFriend(user: User, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        guard let uid = userId,
        let imageUrl = profileUrl,
        let username = displayName,
        let bio = bio, let rank = rank else {return}
        
        let feedDoc = REF_FEED.document()
        let feedId = feedDoc.documentID
        
        let userData: [String: Any] = [
            UserField.providerId: uid,
            UserField.displayName: username,
            UserField.profileImageUrl: imageUrl,
            UserField.bio: bio,
            UserField.rank: rank,
            UserField.dataCreated: FieldValue.serverTimestamp()
        ]
        
        let requesterData: [String: Any] = [
            UserField.providerId: user.id,
            UserField.displayName: user.displayName,
            UserField.profileImageUrl: user.profileImageUrl,
            UserField.fcmToken: user.fcmToken ?? "",
            UserField.bio: user.bio ?? "",
            UserField.rank: user.rank ?? "Tourist",
            UserField.dataCreated: FieldValue.serverTimestamp()
        ]
        
    
        
        let  feedData: [String: Any] = [
            FeedField.id: feedId,
            FeedField.uid: uid,
            FeedField.username: username,
            FeedField.profileUrl: imageUrl,
            FeedField.bio: bio,
            FeedField.rank: rank,
            FeedField.date: FieldValue.serverTimestamp(),
            FeedField.content: user.displayName,
            FeedField.type: FeedType.friends.rawValue,
            FeedField.userId: user.id,
            FeedField.followingImage: user.profileImageUrl,
            FeedField.followingName: user.displayName,
        ]
        
        feedDoc.setData(feedData)
        
        //Set at requestor's branch
        REF_WORLD
            .document(ServerPath.friends)
            .collection(user.id)
            .document(uid)
            .setData(userData)
        
        //Set at user branch
        REF_WORLD
            .document(ServerPath.friends)
            .collection(uid)
            .document(user.id)
            .setData(requesterData) { [weak self] error in
                if let error = error {
                    print("Error saving user to DB", error.localizedDescription)
                    completion(.failure(.failed))
                    return
                }
                
                //Delete user in request branch
                self?.REF_USERS
                    .document(uid)
                    .collection(ServerPath.request)
                    .document(user.id)
                    .delete()
                
                completion(.success(true))
            }
    }
    
 
    func getFriendRequests(completion: @escaping (Result<[User], NetworkError>) -> Void) {
        guard let uid = userId else {return}
        var users: [User] = []

        REF_USERS
            .document(uid)
            .collection(ServerPath.request)
            .getDocuments { querySnapshot, error in
                
                if let error = error {
                    print("Error finding friends for user", error.localizedDescription)
                    completion(.failure(.failed))
                }
                

                guard let snapshot = querySnapshot else {return}
                
                for document in snapshot.documents {
                    let data = document.data()
                    let id = document.documentID
                    let bio = data[UserField.bio] as? String ?? ""
                    let displayName = data[UserField.displayName] as? String ?? ""
                    let profileUrl = data["profileUrl"] as? String ?? ""
                    let fcmToken = data[UserField.fcmToken] as? String ?? ""
                    var user = User(id: id, displayName: displayName, profileImageUrl: profileUrl)
                    user.bio = bio
                    user.fcmToken = fcmToken
                    user.newFriend = true
                    users.append(user)
                }
                completion(.success(users))
                
            }
    }
    
    func getFriendsForUser(completion: @escaping (Result<[User], NetworkError>) -> Void) {
        guard let uid = userId else {return}
        var users: [User] = []
        REF_WORLD
            .document(ServerPath.friends)
            .collection(uid)
            .getDocuments { querySnapshot, error in
                
                if let error = error {
                    print("Error finding friends for user", error.localizedDescription)
                    completion(.failure(.failed))
                }
                
                guard let snapshot = querySnapshot, snapshot.count > 0 else {return}
                
                snapshot.documents.forEach { document in
                    let data = document.data()
                    let user = User(data: data)
                    users.append(user)
                }
                completion(.success(users))
                
            }
    }
    
    
    func sendFriendRequest(friendId: String, token: String, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        guard let uid = userId,
            let imageUrl = profileUrl,
            let username = displayName,
            let bio = bio, let rank = rank else {return}
        
        let data: [String: Any] = [
            "uid": uid,
            "displayName": username,
            "profileUrl": imageUrl,
            "bio": bio,
            "fcmToken": token,
            "rank": rank,
            "requestedOn": FieldValue.serverTimestamp()
        ]
        
        REF_USERS
            .document(friendId)
            .collection(ServerPath.request)
            .document(uid)
            .setData(data) { error in
                if let error = error {
                    print("Error making friend request", error.localizedDescription)
                    completion(.failure(.failed))
                    return
                }
                print("Successfully made friend request")
                let decrement: Int64 = -3
                let walletData: [String: Any] = [UserField.streetCred: FieldValue.increment(decrement)]
                AuthService.instance.updateUserField(uid: uid, data: walletData)
                completion(.success(true))
            }
            
    }
    
    
    
    func saveUserRanking(rank: Rank) {
        guard let tribe = tribe, let uid = userId else {return}
        if tribe == "" {return}
        let document = REF_WORLDS.document(tribe).collection(WorldField.ranks).document(uid)

        let data: [String: Any] = [
            RankingField.id: rank.id,
            RankingField.profileUrl: rank.profileImageUrl,
            RankingField.displayName: rank.displayName,
            RankingField.streetcred: rank.streetCred,
            RankingField.streetFollowers: rank.streetFollowers,
            RankingField.bio: rank.bio,
            RankingField.level: rank.currentLevel,
            RankingField.totalSpots: rank.totalSpots,
            RankingField.totalStamps: rank.totalStamps,
            RankingField.totalSaves: rank.totalSaves,
            RankingField.totalCities: rank.totalCities,
            RankingField.totalPeopleMet: rank.totalPeopleMet,
            RankingField.totalVerifications: rank.totalUserVerifications,
            RankingField.progress: rank.progress,
        ]

        document.setData(data, merge: true) { error in
            if let error = error {
                print("Failed to write ranks to Firebase", error.localizedDescription)
                return
            }

            print("Ranking uploaded to DB")
        }
//
    }
    
    func streetFollowUser(user: User, fcmToken: String, completion: @escaping (_ succcess: Bool) -> ()) {
        
        guard let uid = userId, let imageUrl = profileUrl, let displayName = displayName, let bio = bio else {return}
        let following = REF_WORLD.document(ServerPath.followers).collection(user.id).document(uid)
        let follower = REF_WORLD.document(ServerPath.following).collection(uid).document(user.id)
        let feedDocument = REF_FEED.document()
        let feedId = feedDocument.documentID

        let followerData: [String: Any] = [
            UserField.providerId: uid,
            UserField.profileImageUrl: imageUrl,
            UserField.displayName: displayName,
            UserField.fcmToken: fcmToken,
            UserField.dataCreated: FieldValue.serverTimestamp(),
        ]
        
        let followingData: [String: Any] = [
            UserField.providerId: user.id,
            UserField.profileImageUrl: user.profileImageUrl,
            UserField.displayName: user.displayName
        ]
        
        follower.setData(followingData)
        
        let rank = self.rank ?? "Tourist"
        let userLong = self.locationManager.userlocation?.longitude ?? 0
        let userLat = self.locationManager.userlocation?.latitude ?? 0
        let userHash = GFUtils.geoHash(forLocation: CLLocationCoordinate2D(latitude: userLat, longitude: userLong))
        
        let feedData: [String: Any] = [
            FeedField.id: feedId,
            FeedField.uid: uid,
            FeedField.username: displayName,
            FeedField.profileUrl: imageUrl,
            FeedField.bio: bio,
            FeedField.rank: rank,
            FeedField.date: FieldValue.serverTimestamp(),
            FeedField.content: user.displayName,
            FeedField.type: FeedType.streetFollow.rawValue,
            FeedField.userId: user.id,
            FeedField.followingImage: user.profileImageUrl,
            FeedField.followingName: user.displayName,
            FeedField.longitude: userLong,
            FeedField.latitude: userLat,
            FeedField.geohash: userHash
        ]
        
        feedDocument.setData(feedData)
        
        //Decrement follower's wallet remotely
        let decrement: Int64 = -1
        let followerWallet : [String: Any] = [
            UserField.streetCred : FieldValue.increment(decrement)
        ]
        AuthService.instance.updateUserField(uid: uid, data: followerWallet)
        
        //Increment following's wallet remotely
        let increment: Int64 = 1
        let follwingWallet: [String: Any] = [
            UserField.streetCred : FieldValue.increment(increment)
        ]
        AuthService.instance.updateUserField(uid: user.id, data: follwingWallet)

     
        following.setData(followerData) { error in
            if let err = error {
                print("Error saving new Street Follower", err.localizedDescription)
                completion(false)
                return
            }
            
            completion(true)
            
        }
        
    }
    
    
    func getStreetFollowers(completion: @escaping ([User]) -> ()) {
        guard let uid = userId else {return}
        var users: [User] = []
        let document = REF_WORLD.document(ServerPath.followers).collection(uid)
        
        document.getDocuments { querySnapshot, error in
            
            if let err = error {
                print("Error finding followers", err.localizedDescription)
                completion(users)
                return
            }
            if let snapshot = querySnapshot, snapshot.count > 0 {
                snapshot.documents.forEach { document in
                    
                    let data = document.data()
                    let user = User(data: data)
                    users.append(user)
                    
                }
                completion(users)
            }
        }
    }
    
    func getStreetFollowing(completion: @escaping ([User]) -> ()) {
        guard let uid = userId else {return}
        var users: [User] = []
        let document = REF_WORLD.document(ServerPath.following).collection(uid)
        
        document.getDocuments { querySnapshot, error in
            if let err = error {
                print("Error finding following", err.localizedDescription)
                return
            }
            
            if let snapshot = querySnapshot, snapshot.count > 0 {
                
                snapshot.documents.forEach { document in
                    let data = document.data()
                    let user = User(data: data)
                    users.append(user)
                }
                completion(users)
            }
        }
    }
    
    
    func unfollowerUser(followingId: String, completion: @escaping (_ success: Bool) -> ()) {
        guard let uid = userId else {return}
        let following = REF_WORLD.document(ServerPath.followers)
                    .collection(followingId)
                    .document(uid)
        
        let follower = REF_WORLD.document(ServerPath.following).collection(uid).document(followingId)
        
        follower.delete()
        following.delete { error  in
            if let error = error {
                print("Error unfollowing user", error.localizedDescription)
                completion(false)
                return
            }
            completion(true)
        }
        
    }
    
    func searchForUsersWith(name: String, completion: @escaping (Result<[User], Error>) -> Void) {
        var users: [User] = []
        REF_USERS
            .whereField(UserField.displayName, isEqualTo: name)
            .limit(to: 12)
            .getDocuments { querySnapshot, error in
                if let error = error {
                    print("Error performing user searches", error.localizedDescription)
                    completion(.failure(error))
                }
                
                guard let snapshot = querySnapshot, snapshot.documents.count >= 1
                    else{
                    print("snapshot for user search is empty")
                    completion(.success(users))
                    return}
                snapshot.documents.forEach { document in
                    let data = document.data()
                    let user = User(data: data)
                    users.append(user)
                }
                completion(.success(users))
            }
    }
    
    func searchForSecretSpotby(name: String, completion: @escaping (Result<[SecretSpot], Error>) -> ()) {
        var spots: [SecretSpot] = []
        
        REF_POST
            .whereField(SecretSpotField.city, isEqualTo: name)
            .whereField(SecretSpotField.isPublic, isEqualTo: true)
            .limit(to: 35)
            .getDocuments { querySnapshot, error in
                if let error = error {
                    print("Error finding secret spot in search", error.localizedDescription)
                    completion(.failure(error))
                }
                
                guard let snapshot = querySnapshot, snapshot.count >= 1 else {
                    print("snapshot is empty")
                    completion(.success(spots))
                    return}
                
                snapshot.documents.forEach { document in
                    let data = document.data()
                    let spot = SecretSpot(data: data)
                    if let spot = spot {
                        spots.append(spot)
                    }
                }
                completion(.success(spots))
            }
    }
    
    
    func getUserRankings(completion: @escaping (_ ranks: [Rank]) -> ()) {
        guard let tribe = tribe else {return}
        if tribe == "" {return}
        let ref = REF_WORLDS.document(tribe).collection(WorldField.ranks)
        var rankings: [Rank] = []
        ref.order(by: RankingField.totalSpots, descending: true)
            .limit(to: 10)
            .getDocuments { snapshot, error in
                
                if let error = error {
                    print("Error fetching user rankings", error.localizedDescription)
                }
                
                guard let documents = snapshot?.documents else {return}
                
                documents.forEach { document in
                    
                    let data = document.data()
                    let rank = Rank(data: data)
                    rankings.append(rank)
                    
                }
                completion(rankings)
            }
    }
    
    
    
    func updateSecretSpot(spotId: String, isPublic: Bool, completion: @escaping (_ success: Bool) -> ()) {
        
        if isPublic {
            REF_POST.document(spotId).getDocument { snapshot, error in
                
                if let error = error {
                    print("Error finding secret spot", error.localizedDescription)
                    return
                }
                
                guard let document = snapshot else {return}
                if !document.exists {
                    CoreDataManager.instance.delete(spotId: spotId)
                    completion(false)
                }
                self.updatePostViewCount(postId: spotId)
                let data = document.data()
                let secretSpot = SecretSpot(data: data)
                if let spot = secretSpot {
                    print("Secret Spot Updated")
                    self.manager.updatewithSpot(spot: spot)
                    completion(true)
                }
            }
        } else {
            guard let tribe = tribe else {return}
            if tribe == "" {return}
            REF_WORLDS
                .document(tribe)
                .collection(ServerPath.posts)
                .document(spotId)
                .getDocument { snapshot, error in
                    if let error = error {
                        print("Error finding secret spot", error.localizedDescription)
                        return
                    }
                    
                    guard let document = snapshot else {return}
                    if !document.exists {
                        CoreDataManager.instance.delete(spotId: spotId)
                        completion(false)
                    }
                    self.updatePostViewCount(postId: spotId)
                    let data = document.data()
                    let secretSpot = SecretSpot(data: data)
                    if let spot = secretSpot {
                        print("Secret Spot Updated")
                        self.manager.updatewithSpot(spot: spot)
                        completion(true)
                    }
                }
        }
    }

    
    
    func getSecretSpotsFromSnapshot(querysnapshot: QuerySnapshot?) -> [SecretSpot] {
        var secretSpots = [SecretSpot]()
        if let snapshot = querysnapshot, snapshot.documents.count > 0 {
            print("Found secret spots")
            snapshot.documents.forEach { document in
                
                let data = document.data()
                let spot = SecretSpot(data: data)
                if let spot = spot {
                    secretSpots.append(spot)
                }
            }
            return secretSpots
        } else {
            print("No saved secret spots found in snapshot for this user")
            return secretSpots
        }
    }
    
    
    func downloadComments(postId: String, completion: @escaping (_ comments: [Comment]) -> ()) {
        
        REF_POST.document(postId).collection("comments").order(by: CommentField.dateCreated, descending: false).getDocuments { querysnapshot, error in
            guard let snapshot = querysnapshot else {return}
            completion(self.getCommentsFromSnapshot(snapshot: snapshot))
        }
        
    }
    
    private func getCommentsFromSnapshot(snapshot: QuerySnapshot?) -> [Comment] {
        var comments: [Comment] = []
        
        if let snapshot = snapshot, snapshot.count > 0 {
            
            for document in snapshot.documents {
                if
                    let uid = document.get(CommentField.uid) as? String,
                    let username = document.get(CommentField.username) as? String,
                    let content = document.get(CommentField.content) as? String,
                    let timestamp = document.get(CommentField.dateCreated) as? Timestamp,
                    let imageUrl = document.get(CommentField.imageUrl) as? String,
                    let bio = document.get(CommentField.bio) as? String {
                    
                    let id = document.documentID
                    let date = timestamp.dateValue()
                    let comment = Comment(id: id, uid: uid, username: username, imageUrl: imageUrl, bio: bio, content: content, dateCreated: date)
                    comments.append(comment)
                    
                }
                
            }
            return comments

        } else {
            print("No comments for this spot")
            return comments
        }
    }
    
    
    func getUserHistory(completion: @escaping ([String]) -> ())  {
        var history: [String] = []
        guard let uid = userId else { return }
           
        REF_WORLD
            .document("history")
            .collection(uid)
            .getDocuments { querysnapshot, error in
            
            if let error = error {
                print("Erorr fetching user spots", error.localizedDescription)
            }
            querysnapshot?.documents.forEach({ document in
                history.append(document.documentID)
            })
            print("printing history inside function", history)
            completion(history)
        }
        
    }
    
    
    func getUsersForSpot(postId: String, path: String, completion: @escaping (_ users: [User]) -> ()) {
        var savedUsers: [User] = []
        
        REF_POST.document(postId).collection(path).getDocuments { snapshot, error in
            
            if snapshot?.count == 0 {
                let count: Double = 0
                self.manager.updateSaveCount(spotId: postId, count: count)
                completion(savedUsers)
                return
            }
            
            if let snapshot = snapshot, snapshot.count > 0 {
                print("Found users")
                let count = snapshot.count
                self.manager.updateSaveCount(spotId: postId, count: Double(count))
                
                snapshot.documents.forEach { document in
                    let id = document.documentID
                    let data = document.data()
                    let timestamp = data["savedOn"] as? Timestamp
                    let date = timestamp?.dateValue()
                
                    
                    self.REF_USERS.document(id).getDocument { snapshot, error in
                        
                        if let error = error {
                            print("Could not find users", error.localizedDescription)
                        }
                        let data = snapshot?.data()
                        
                        var user = User(data: data)
                        user.verified = date
                        savedUsers.append(user)
                        
                        DispatchQueue.main.async {
                            completion(savedUsers)
                        }
                        
                    }
                }
                
            }
            
        }
    }
    
    func getVerifiersForSpot(postId: String, completion: @escaping (_ users: [User]) -> ()) {
        var verifiedUsers: [User] = []
        
        REF_POST.document(postId).collection("verifiers").getDocuments { snapshot, error in
            
            if let err = error {
                print("Error finding verifiers for secret spot", err.localizedDescription)
                completion(verifiedUsers)
                return
            }
            
            if snapshot?.count == 0 {
                print("No verifiers found")
                let count: Double = 0
                self.manager.updateVerifierCount(spotId: postId, count: count)
                completion(verifiedUsers)
                return
            }
            
            if let snapshot = snapshot {
                print("Found verifiers")
                let count: Double = Double(snapshot.count)
                self.manager.updateVerifierCount(spotId: postId, count: count)
                
                snapshot.documents.forEach { document in
                    let id = document.documentID
                    let data = document.data()
                    let timestamp = data[CheckinField.timestamp] as? Timestamp
                    let date = timestamp?.dateValue()
                    
                    self.REF_USERS.document(id).getDocument { snapshot, error in
                        
                        if let error = error {
                            print("Could not find users", error.localizedDescription)
                        }
                        let data = snapshot?.data()
                        var user = User(data: data)
                        user.verified = date
                        verifiedUsers.append(user)

                        DispatchQueue.main.async {
                            completion(verifiedUsers)
                        }
                        
                    }
                }
                
            }
            
        }
    }
    
    
    //MARK: UPDATE FUNCTIONS
    
    
    func updateProfileImage(userId: String, profileImageUrl: String) {
        let data: [String: Any] = [
            UserField.profileImageUrl: profileImageUrl
        ]
        
        let rankData: [String: Any] =  [RankingField.profileUrl: profileImageUrl]
        REF_USERS.document(userId).setData(data, merge: true)
        
        if tribe != nil && tribe != "" {
            guard let worldName = tribe else {return}
            REF_WORLDS
                .document(worldName)
                .collection(ServerPath.members)
                .document(userId)
                .updateData(data)
            
            REF_WORLDS
                .document(worldName)
                .collection(ServerPath.maps)
                .document(userId)
                .updateData(data)
            
            REF_WORLDS
                .document(worldName)
                .collection(ServerPath.rankings)
                .document(userId)
                .updateData(rankData)
        }
        
        let spots = manager.spotEntities.map({SecretSpot(entity: $0)}).filter({$0.ownerId == userId})
        let spotData: [String: Any] = [SecretSpotField.ownerImageUrl: profileImageUrl]
        spots.forEach { spot in
            REF_POST
                .document(spot.id)
                .updateData(spotData)
        }
    }
    
    func updateUserBio(userId: String, bio: String) {
        let data: [String: Any] = [UserField.bio: bio]

        REF_USERS.document(userId).updateData(data)
        
        if tribe != nil && tribe != "" {
            guard let worldName = tribe else {return}
            REF_WORLDS
                .document(worldName)
                .collection(ServerPath.members)
                .document(userId)
                .updateData(data)
            
            REF_WORLDS
                .document(worldName)
                .collection(ServerPath.maps)
                .document(userId)
                .updateData(data)
            
            REF_WORLDS
                .document(worldName)
                .collection(ServerPath.rankings)
                .document(userId)
                .updateData(data)
        }
    }
    
    func updateSpotField(postId: String, data: [String: Any], completion: @escaping (_ success: Bool) -> ()) {
        REF_POST.document(postId).updateData(data) { error in
            
            if let error = error {
                print("Error updating secret spot field", error.localizedDescription)
                completion(false)
                return
            }
            print("Successfully updated secret spot field")
            completion(true)
            return
        }
    }
    
    func updateUserDisplayName(userId: String, displayName: String) {
        let data: [String: Any] = [UserField.displayName: displayName]
        
        REF_USERS.document(userId).updateData(data)
        
        if tribe != nil && tribe != "" {
            guard let worldName = tribe else {return}
            REF_WORLDS
                .document(worldName)
                .collection(ServerPath.members)
                .document(userId)
                .updateData(data)
            
            REF_WORLDS
                .document(worldName)
                .collection(ServerPath.maps)
                .document(userId)
                .updateData(data)
            
            REF_WORLDS
                .document(worldName)
                .collection(ServerPath.rankings)
                .document(userId)
                .updateData(data)
        }
        
    }
    
    func updateTribeMap(_ location: CLLocationCoordinate2D) {
        guard let tribe = tribe, let uid = userId, let profileUrl = profileUrl else {return}
        if tribe == "" {return}
        
        let longitude = location.longitude
        let latitude = location.latitude
        let geohash = GFUtils.geoHash(forLocation: .init(latitude: latitude, longitude: longitude))

        
        let data: [String: Any] = [
            WorldField.longitude: longitude,
            WorldField.latitude: latitude,
            WorldField.timestamp: FieldValue.serverTimestamp(),
            WorldField.geohash: geohash,
            WorldField.profileUrl: profileUrl
        ]
        
        REF_WORLDS
            .document(tribe)
            .collection(ServerPath.maps)
            .document(uid)
            .setData(data, merge: true)
    }

//
    func updateDisplayNameOnPosts(userId: String, displayName: String) {

        getSpotsFromWorld(userId: userId) { secretSpots in
            let filteredSpots = secretSpots.filter({$0.ownerId == userId})

            for spot in filteredSpots {
                self.updatePostDisplayName(postID: spot.id, displayName: displayName)
            }
        }

    }
    
    private func updatePostDisplayName(postID: String, displayName: String) {
        let data: [String : Any] = [
            SecretSpotField.ownerDisplayName: displayName
        ]
        
        REF_POST.document(postID).updateData(data)
    }
    
    func updatePostViewCount(postId: String) {
        
        let increment: Int64 = 1
        
        let data: [String: Any] = [
            SecretSpotField.viewCount: FieldValue.increment(increment)
        ]
        
        REF_POST.document(postId).updateData(data)
        
    }
    
     func updatePostProfileImageUrl(profileUrl: String) {
        guard let uid = userId else {return}
        let data: [String: Any] = [
            SecretSpotField.ownerImageUrl: profileUrl
        ]

         getSpotsFromWorld(userId: uid) { secretspots in

            let filteredSpots = secretspots.filter({$0.ownerId == uid})

            filteredSpots.forEach { [weak self] spot in

                self?.REF_POST.document(spot.id).updateData(data)
            }
        }

    }
    
    func updateSocialMediaUrl(ig: String) {
       guard let uid = userId else {return}
       let document = REF_POST
       let data: [String: Any] = [
           SecretSpotField.ownerIg: ig
       ]
        //Update DB & Core Data
        let ownerSpots = manager.spotEntities
                        .map({SecretSpot(entity: $0)})
                        .filter({$0.ownerId == uid})
        ownerSpots.forEach({document.document($0.id).updateData(data)})
        ownerSpots.forEach({manager.updateSocial(spotId: $0.id, instagram: ig)})

   }
    
    
    
    
    func likeSpot(postId: String) {
        guard let uid = userId else {return}
        let increment: Int64 = 1
        let data: [String: Any] = [
            SecretSpotField.likeCount: FieldValue.increment(increment),
            SecretSpotField.likedBy: FieldValue.arrayUnion([uid])
        ]
        
        REF_POST.document(postId).updateData(data)
    }
    
    
    func unliKeSpot(postId: String) {
        
        guard let uid = userId else {return}
        let decrement: Int64 = -1
        
        let data: [String: Any] = [
            SecretSpotField.likeCount: FieldValue.increment(decrement),
            SecretSpotField.likedBy: FieldValue.arrayRemove([uid])
        ]
        
        REF_POST.document(postId).updateData(data)
    }
    
    
//
    
    //MARK: DELETE FUNCTIONS
    
    func deleteSecretSpot(spot: SecretSpot, completion: @escaping (_ success: Bool) -> ()) {
        guard let uid = userId else {return}
        let spotId = spot.id
        
        //Delete user from save collection
        REF_POST.document(spotId).collection("savedBy").document(uid).delete()
    
//        Delete spot it is owned by user
        if spot.ownerId == uid {
            if spot.isPublic {
                self.REF_POST.document(spotId).delete()
            } else {
                guard let tribe = tribe else {return}
                if tribe == "" {return}
                REF_WORLDS.document(tribe).collection(ServerPath.posts).document(spotId).delete()
            }
        }
                
//        Delete spot from user's private world
        REF_WORLD.document("private").collection(uid).document(spotId).delete { error in

            if let error = error {
                print("Error deleting secret spot", error.localizedDescription)
                return
            } else {
                print("Success deleting secret spot")
                completion(true)
                return
            }
        }
        
    }
    
    
    func deleteFriendRequest(user: User, completion: @escaping (Result<String, Error>) -> Void) {
        guard let uid = userId else {return}
        
        REF_USERS
            .document(uid)
            .collection(ServerPath.request)
            .document(user.id)
            .delete { errror in
                if let error = errror {
                    print("Error deleting request in database", errror?.localizedDescription)
                    completion(.failure(error))
                    return
                }
                
                let message = "Successfully deleted request"
                completion(.success(message))
                
            }
    }
    
    
    func removeFriendFromList(user: User, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let uid = userId else {return}
        
        REF_WORLD
            .document(ServerPath.friends)
            .collection(uid)
            .document(user.id)
            .delete()
        
        REF_WORLD
            .document(ServerPath.friends)
            .collection(user.id)
            .document(uid)
            .delete { error in
                
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                completion(.success(true))
                
            }
        
    }
    
    
}
