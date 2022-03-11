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


class DataService {
    
    @AppStorage(CurrentUserDefaults.userId) var userId: String?
    @AppStorage(CurrentUserDefaults.profileUrl) var profileUrl: String?
    @AppStorage(CurrentUserDefaults.displayName) var displayName: String?
    @AppStorage(CurrentUserDefaults.wallet) var wallet: Int?


    
    static let instance = DataService()
    let manager = CoreDataManager.instance
    private init() {}
    
    private var REF_POST = DB_BASE.collection("posts")
    private var REF_USERS = DB_BASE.collection("users")
    private var REF_REPORTS = DB_BASE.collection("reports")
    private var REF_WORLD = DB_BASE.collection("world")
    
    //MARK: CREATE FUNCTIONS
    
    func uploadSecretSpot(spotName: String, description: String, image: UIImage, world: String, mapItem: MKMapItem, isPublic: Bool, completion: @escaping (_ success: Bool) -> ()) {
        
        let document = REF_POST.document()
        let spotId = document.documentID
        let address = mapItem.getAddress()
        let longitude = mapItem.placemark.coordinate.longitude
        let latitude = mapItem.placemark.coordinate.latitude
        let city = mapItem.getCity()
        let zipCode = mapItem.getPostCode()
        
        
        guard let uid = userId,
              let ownerImageUrl = profileUrl,
              let ownerDisplayName = displayName
        else {
            print("Error getting user defaults at DataService")
            return
        }
        
        let userWorldRef = REF_WORLD.document("private").collection(uid).document(spotId)
        ImageManager.instance.uploadSecretSpotImage(image: image, postId: spotId) { (urlString) in
            
            if let downloadUrl = urlString {
                
                
                let spotData: [String: Any] = [
                    SecretSpotField.spotId: spotId,
                    SecretSpotField.spotName: spotName,
                    SecretSpotField.description: description,
                    SecretSpotField.spotImageUrl: downloadUrl,
                    SecretSpotField.address: address,
                    SecretSpotField.latitude: latitude,
                    SecretSpotField.longitude: longitude,
                    SecretSpotField.ownerId: uid,
                    SecretSpotField.ownerImageUrl: ownerImageUrl,
                    SecretSpotField.ownerDisplayName: ownerDisplayName,
                    SecretSpotField.price: 1,
                    SecretSpotField.viewCount: 1,
                    SecretSpotField.saveCount: 1,
                    SecretSpotField.city: city,
                    SecretSpotField.zipcode: zipCode,
                    SecretSpotField.world: world,
                    SecretSpotField.isPublic: isPublic,
                    SecretSpotField.dateCreated: FieldValue.serverTimestamp()
                ]
                
                self.manager.addEntity(spotId: spotId, spotName: spotName, description: description, longitude: longitude, latitude: latitude, imageUrls: [downloadUrl], address: address, uid: uid, ownerImageUrl: ownerImageUrl, ownerDisplayName: ownerDisplayName, price: 1, viewCount: 1, saveCount: 1, zipCode: Double(zipCode), world: world, isPublic: isPublic, dateCreated: Date(), city: city, didLike: false, likedCount: 0)
                self.manager.fetchSecretSpots()
                
                document.setData(spotData) { (error) in
                    if let err = error {
                        print("Error uploading secret spot to database", err.localizedDescription)
                        completion(false)
                        return
                    } else {
                        
                    print("Successfully saved secret spots to public world")
                    let savedData: [String: Any] =
                        ["savedOn": FieldValue.serverTimestamp()]
                    userWorldRef.setData(savedData)
                    
                    //Increment User StreetCred
                    let increment: Int64 = 1
                    let walletData : [String: Any] = [
                        UserField.streetCred : FieldValue.increment(increment)
                    ]
                    AuthService.instance.updateUserField(uid: uid, data: walletData)
                        
                    completion(true)

                    return
                }
                
                }
        }
    }
        
}
    
    func saveToUserWorld(spot: SecretSpot, completion: @escaping (_ success: Bool) -> ()) {
        
        let spotId = spot.id
        //Save swipe to history
        let historyData: [String: Any] =
            ["savedOn": FieldValue.serverTimestamp()]
        guard let uid = userId else {return}
        REF_WORLD.document("history").collection(uid).document(spotId).setData(historyData)
        
        //Increment view and save count by one
        let increment: Int64 = 1
        let data: [String: Any] = [
            SecretSpotField.viewCount: FieldValue.increment(increment),
            SecretSpotField.saveCount : FieldValue.increment(increment)
        ]
        REF_POST.document(spot.id).updateData(data)
        

        //Save post id in user's world
        guard let uid = userId else {return}
        let savedData: [String: Any] =
            ["savedOn": FieldValue.serverTimestamp()]
        REF_WORLD.document("private").collection(uid).document(spotId).setData(savedData)

        //Add user to saved collection in spot
        REF_POST.document(spotId).collection("savedBy").document(uid).setData(savedData) { error in
            if let error = error {
                print("Error saving user to saved collection of secret spot", error.localizedDescription)
                completion(false)
                return
            }
            print("Successful saved user to saved collection of secret spot")
            completion(true)
        }
        
        //Save to Core Data
        self.manager.addEntity(spotId: spot.id, spotName: spot.spotName, description: spot.description ?? "", longitude: spot.longitude, latitude: spot.latitude, imageUrls: spot.imageUrls, address: spot.address, uid: spot.ownerId, ownerImageUrl: spot.ownerImageUrl, ownerDisplayName: spot.ownerDisplayName, price: Double(spot.price), viewCount: Double(spot.viewCount), saveCount: Double(spot.saveCounts), zipCode: Double(spot.zipcode), world: spot.world, isPublic: spot.isPublic, dateCreated: spot.dateCreated, city: spot.city, didLike: false, likedCount: 0)
        
        
        //Decrement buyer wallet remotely
        let decrement: Int64 = -1
        let walletData : [String: Any] = [
            UserField.streetCred : FieldValue.increment(decrement)
        ]
        AuthService.instance.updateUserField(uid: uid, data: walletData)
        
        
        //Increment owner wallet
        let ownerId = spot.ownerId
        let ownerWalletData: [String: Any] = [
            UserField.streetCred : FieldValue.increment(increment)
        ]
        AuthService.instance.updateUserField(uid: ownerId, data: ownerWalletData)
       

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
    

    
    
    func verifySecretSpot(spot: SecretSpot, image: UIImage, comment: String, completion: @escaping (_ success: Bool, _ error: String?) ->()) {
        guard let uid = userId else {return}
        let postId = spot.id
        let ownerId = spot.ownerId
        
     
        ImageManager.instance.uploadVerifyImage(image: image, userId: uid, postId: postId) { [weak self] url in
            if let imageUrl = url {
                
                let checkinData: [String: Any] = [
                    "comment": comment,
                    "imageUrl": imageUrl,
                    "verifierId": uid,
                    "spotOwnerId": ownerId,
                    "postId": postId,
                    "city": spot.city,
                    "name": spot.spotName,
                    "latitude": spot.latitude,
                    "longitude": spot.longitude,
                    "country": spot.country,
                    "time": FieldValue.serverTimestamp()
                ]
                
                self?.REF_WORLD.document("verified").collection(uid).document(postId).setData(checkinData)
                
                self?.REF_POST.document(postId).collection("verifiers").document(uid).setData(checkinData) { error in
                    
                    if let error = error {
                        print("Error saving check-in to database", error.localizedDescription)
                        completion(false, error.localizedDescription)
                        return
                    }
                    
                    let verifierIncrement: Int64 = 3
                    let verifierWalletData: [String: Any] = [
                        UserField.streetCred : FieldValue.increment(verifierIncrement)
                    ]
                    
                    AuthService.instance.updateUserField(uid: uid, data: verifierWalletData)
                    
                    let ownerIncrement: Int64 = 1
                    let ownerWalletData: [String: Any] = [
                        UserField.streetCred : FieldValue.increment(ownerIncrement)
                    ]
                                
                    AuthService.instance.updateUserField(uid: ownerId, data: ownerWalletData)
                    
                    print("Successfully saved verification to DB")
                    completion(true, nil)
                }
            } else {
                let message = "Error uploading verification to Database"
                completion(false, message)
                print("Error uploading verification image to DB")
            }
        }
        
    }
    
    func getVerifications(completion: @escaping (_ verifications: [Verification]) ->()) {
        guard let uid = userId else {return}
        
        REF_WORLD.document("verified").collection(uid).getDocuments { querySnapshot, error in
            
            var verifications: [Verification] = []
            if let error = error {
                print("Error fetching verifications", error.localizedDescription)
                return
            }
            
            if let snapshot = querySnapshot, snapshot.count > 0 {
                snapshot.documents.forEach { document in
                    let data = document.data()
                    let verification = Verification(data: data)
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
    
    
    func getSpotsFromWorld(userId: String, coreData: Bool, completion: @escaping (_ spots: [SecretSpot]) -> ()) {
        REF_WORLD.document("private").collection(userId).addSnapshotListener { snapshot, error in
            var secretSpots = [SecretSpot]()
            let uid = userId
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
                        if
                        let name = data?[SecretSpotField.spotName] as? String,
                        let imageUrl = data?[SecretSpotField.spotImageUrl] as? String,
                        let longitude = data?[SecretSpotField.longitude] as? Double,
                        let latitude = data?[SecretSpotField.latitude] as? Double,
                        let description = data?[SecretSpotField.description] as? String,
                        let city = data?[SecretSpotField.city] as? String,
                        let dateCreated = data?[SecretSpotField.dateCreated] as? Timestamp,
                        let ownerId = data?[SecretSpotField.ownerId] as? String,
                        let postId = data?[SecretSpotField.spotId] as? String,
                        let ownerDisplayName = data?[SecretSpotField.ownerDisplayName] as? String,
                        let ownerImageUrl = data?[SecretSpotField.ownerImageUrl] as? String,
                        let address = data?[SecretSpotField.address] as? String,
                        let zipcode = data?[SecretSpotField.zipcode] as? Int,
                        let saveCounts = data?[SecretSpotField.saveCount] as? Int,
                        let viewCount = data?[SecretSpotField.viewCount] as? Int,
                        let isPublic = data?[SecretSpotField.isPublic] as? Bool,
                        let world = data?[SecretSpotField.world] as? String,
                        let price = data?[SecretSpotField.price] as? Int {
                            
                            let likedCount = data?[SecretSpotField.likeCount] as? Int ?? 0
                            var didLike: Bool = false
                            if let likedArray = data?[SecretSpotField.likedBy] as? [String] {
                                didLike = likedArray.contains(uid)
                            }
                            let date = dateCreated.dateValue()
                            var spotImageUrls = [imageUrl]
                            
                            let additionalImages = data?[SecretSpotField.spotImageUrls] as? [String] ?? []
                            if !additionalImages.isEmpty {
                                additionalImages.forEach { url in
                                    spotImageUrls.append(url)
                                }
                            }

                            let secretSpot = SecretSpot(postId: postId, spotName: name, imageUrls: spotImageUrls, longitude: longitude, latitude: latitude, address: address, description: description, city: city, zipcode: zipcode, world: world, dateCreated: date, price: price, viewCount: viewCount, saveCounts: saveCounts, isPublic: isPublic, ownerId: ownerId, ownerDisplayName: ownerDisplayName, ownerImageUrl: ownerImageUrl, likeCount: likedCount, didLike: didLike)
                            secretSpots.append(secretSpot)
                            
                            if coreData {
                                self.manager.addEntity(spotId: postId, spotName: name, description: description, longitude: longitude, latitude: latitude, imageUrls: spotImageUrls, address: address, uid: ownerId, ownerImageUrl: ownerImageUrl, ownerDisplayName: ownerDisplayName, price: Double(price), viewCount: Double(viewCount), saveCount: Double(saveCounts), zipCode: Double(zipcode), world: world, isPublic: isPublic, dateCreated: date, city: city, didLike: didLike, likedCount: likedCount)
                            }
//
                        }
                        
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
    
    func getNewSecretSpots(lastSecretSpot: String?, completion: @escaping (_ spots: [SecretSpot]) -> ()) {
        guard let uid = userId else {return}
        var history : [String] = []
        
        getUserHistory { [self] returnedHistory in
            history = returnedHistory
            print("printing history inside new spots", history)
            
            
            self.REF_POST
                .order(by: SecretSpotField.dateCreated, descending: true)
                .getDocuments { querysnapshot, error in
                    let results = self.getSecretSpotsFromSnapshot(querysnapshot: querysnapshot)
                    let filteredResults = results.filter({$0.isPublic == true
                                                            && $0.ownerId != uid
                                                            && !history.contains($0.id)})
                    completion(filteredResults)
                }
        }
        
     
            
//            .limit(to: 12)
    }
    
    func updateSecretSpot(spotId: String, completion: @escaping (_ spot: SecretSpot) -> ()) {
        guard let uid = userId else {return}
        REF_POST.document(spotId).getDocument { snaphot, error in
            
            if let error = error {
                print("Error finding secret spot", error.localizedDescription)
                return
            }
            
            guard let document = snaphot else {return}
            if
            let spotName = document.get(SecretSpotField.spotName) as? String,
            let imageUrl = document.get(SecretSpotField.spotImageUrl) as? String,
            let longitude = document.get(SecretSpotField.longitude) as? Double,
            let latitude = document.get(SecretSpotField.latitude) as? Double,
            let description = document.get(SecretSpotField.description) as? String,
            let city = document.get(SecretSpotField.city) as? String,
            let dateCreated = document.get(SecretSpotField.dateCreated) as? Timestamp,
            let ownerId = document.get(SecretSpotField.ownerId) as? String,
            let ownerDisplayName = document.get(SecretSpotField.ownerDisplayName) as? String,
            let ownerImageUrl = document.get(SecretSpotField.ownerImageUrl) as? String,
            let address = document.get(SecretSpotField.address) as? String,
            let zipcode = document.get(SecretSpotField.zipcode) as? Int,
            let isPublic = document.get(SecretSpotField.isPublic) as? Bool,
            let saveCounts = document.get(SecretSpotField.saveCount) as? Int,
            let viewCount = document.get(SecretSpotField.viewCount) as? Int,
            let world = document.get(SecretSpotField.world) as? String,
            let price = document.get(SecretSpotField.price) as? Int {
                
                let postId = document.documentID
                let date = dateCreated.dateValue()
                let likeCount = document.get(SecretSpotField.likeCount) as? Int ?? 0
                var likedByUser: Bool = false
                if let likedArrays = document.get(SecretSpotField.likedBy) as? [String] {
                    likedByUser = likedArrays.contains(uid)
                }
                
                
                let additionalImages = document.get(SecretSpotField.spotImageUrls) as? [String] ?? []
                var spotImageUrls = [imageUrl]
                if !additionalImages.isEmpty {
                    spotImageUrls.append(contentsOf: additionalImages)
                }

                let secretSpot = SecretSpot(postId: postId, spotName: spotName, imageUrls: spotImageUrls, longitude: longitude, latitude: latitude, address: address, description: description, city: city, zipcode: zipcode, world: world, dateCreated: date, price: price, viewCount: viewCount, saveCounts: saveCounts, isPublic: isPublic, ownerId: ownerId, ownerDisplayName: ownerDisplayName, ownerImageUrl: ownerImageUrl, likeCount: likeCount, didLike: likedByUser)
                self.manager.updatewithSpot(spot: secretSpot)
                completion(secretSpot)
                
        }
    }
}

    
    
    func getSecretSpotsFromSnapshot(querysnapshot: QuerySnapshot?) -> [SecretSpot] {
        var secretSpots = [SecretSpot]()
        let uid = userId ?? ""
        if let snapshot = querysnapshot, snapshot.documents.count > 0 {
            print("Found secret spots")
            snapshot.documents.forEach { document in
                if
                let spotName = document.get(SecretSpotField.spotName) as? String,
                let imageUrl = document.get(SecretSpotField.spotImageUrl) as? String,
                let longitude = document.get(SecretSpotField.longitude) as? Double,
                let latitude = document.get(SecretSpotField.latitude) as? Double,
                let description = document.get(SecretSpotField.description) as? String,
                let city = document.get(SecretSpotField.city) as? String,
                let dateCreated = document.get(SecretSpotField.dateCreated) as? Timestamp,
                let ownerId = document.get(SecretSpotField.ownerId) as? String,
                let ownerDisplayName = document.get(SecretSpotField.ownerDisplayName) as? String,
                let ownerImageUrl = document.get(SecretSpotField.ownerImageUrl) as? String,
                let address = document.get(SecretSpotField.address) as? String,
                let zipcode = document.get(SecretSpotField.zipcode) as? Int,
                let isPublic = document.get(SecretSpotField.isPublic) as? Bool,
                let saveCounts = document.get(SecretSpotField.saveCount) as? Int,
                let viewCount = document.get(SecretSpotField.viewCount) as? Int,
                let world = document.get(SecretSpotField.world) as? String,
                let price = document.get(SecretSpotField.price) as? Int {
                    
                    let postId = document.documentID
                    let date = dateCreated.dateValue()
                    let additionalImages = document.get(SecretSpotField.spotImageUrls) as? [String] ?? []
                    var spotImageUrls = [imageUrl]
                    if !additionalImages.isEmpty {
                        spotImageUrls.append(contentsOf: additionalImages)
                    }
                    let likedCount = document.get(SecretSpotField.likeCount) as? Int ?? 0
                    var didLike: Bool = false
                    if let likedArray = document.get(SecretSpotField.likedBy) as? [String] {
                        didLike = likedArray.contains(uid)
                    }

                    let secretSpot = SecretSpot(postId: postId, spotName: spotName, imageUrls: spotImageUrls, longitude: longitude, latitude: latitude, address: address, description: description, city: city, zipcode: zipcode, world: world, dateCreated: date, price: price, viewCount: viewCount, saveCounts: saveCounts, isPublic: isPublic, ownerId: ownerId, ownerDisplayName: ownerDisplayName, ownerImageUrl: ownerImageUrl, likeCount: likedCount, didLike: didLike)
                    secretSpots.append(secretSpot)
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
           
        REF_WORLD.document("history").collection(uid).getDocuments { querysnapshot, error in
            
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
                    
                    self.REF_USERS.document(id).getDocument { snapshot, error in
                        
                        if let error = error {
                            print("Could not find users", error.localizedDescription)
                        }
                        let data = snapshot?.data()
                        
                        if
                            let username = data?[UserField.displayName] as? String,
                            let bio = data?[UserField.bio] as? String,
                            let fcmToken = data?[UserField.fcmToken] as? String,
                            let profileUrl = data?[UserField.profileImageUrl] as? String,
                            let streetCred = data?[UserField.streetCred] as? Int
                        {
                            let user = User(id: id, displayName: username, profileImageUrl: profileUrl, bio: bio, fcmToken: fcmToken, streetCred: streetCred)
                            savedUsers.append(user)
                        }
                        
                        DispatchQueue.main.async {
                            completion(savedUsers)
                        }
                        
                    }
                }
                
            }
            
        }
    }
    
    func getVerifiersForSpot(postId: String, completion: @escaping (_ users: [User]) -> ()) {
        var savedUsers: [User] = []
        
        REF_POST.document(postId).collection("verifiers").getDocuments { snapshot, error in
            
            if snapshot?.count == 0 {
                print("No verifiers found")
                completion(savedUsers)
                return
            }
            
            if let snapshot = snapshot, snapshot.count > 0 {
                print("Found verifiers")
                
                snapshot.documents.forEach { document in
                    let id = document.documentID
                    let checkedIn = document.get("checked-in") as? Timestamp
                    let date = checkedIn?.dateValue()
                    
                    self.REF_USERS.document(id).getDocument { snapshot, error in
                        
                        if let error = error {
                            print("Could not find users", error.localizedDescription)
                        }
                        let data = snapshot?.data()
                        
                        if
                            let username = data?[UserField.displayName] as? String,
                            let bio = data?[UserField.bio] as? String,
                            let fcmToken = data?[UserField.fcmToken] as? String,
                            let profileUrl = data?[UserField.profileImageUrl] as? String,
                            let streetCred = data?[UserField.streetCred] as? Int
                        {
                            let user = User(id: id, displayName: username, profileImageUrl: profileUrl, bio: bio, fcmToken: fcmToken, streetCred: streetCred, verified: date)
                            savedUsers.append(user)
                        }
                        
                        DispatchQueue.main.async {
                            completion(savedUsers)
                        }
                        
                    }
                }
                
            }
            
        }
    }
    
    
    //MARK: UPDATE FUNCTIONS
    
    
    func updateProfileImage(userId: String, profileImageUrl: String) {
        
        REF_USERS.document(userId).setData([UserField.profileImageUrl : profileImageUrl], merge: true)
    }
    
    func updateUserBio(userId: String, bio: String) {
        REF_USERS.document(userId).setData([UserField.bio : bio], merge: true)
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
        
        REF_USERS.document(userId).setData([UserField.displayName : displayName], merge: true)
    }
//
    func updateDisplayNameOnPosts(userId: String, displayName: String) {

        getSpotsFromWorld(userId: userId, coreData: false) { secretSpots in
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

         getSpotsFromWorld(userId: uid, coreData: false) { secretspots in

            let filteredSpots = secretspots.filter({$0.ownerId == uid})

            filteredSpots.forEach { [weak self] spot in

                self?.REF_POST.document(spot.id).updateData(data)
            }
        }

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

        REF_POST.document(spotId).collection("savedBy").document(uid).delete()
        if spot.ownerId == uid {
            REF_POST.document(spotId).delete()
        }
        
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
    
    
    
}
