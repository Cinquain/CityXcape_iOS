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
        
        let spotId = spot.postId
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
        REF_POST.document(spot.postId).updateData(data)
        

        //Save post id in user's world
        guard let uid = userId else {return}
        let savedData: [String: Any] =
            ["savedOn": FieldValue.serverTimestamp()]
        REF_WORLD.document("private").collection(uid).document(spotId).setData(savedData)

        //Add user to saved collection in spot
        REF_POST.document(spotId).collection("savedBy").document(uid).setData(savedData) { error in
            if let error = error {
                print("Error saving user to saved collection of secret spot")
                completion(false)
                return
            }
            print("Successful saved user to saved collection of secret spot")
            completion(true)
        }
        
        
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
    
    func dismissCard(spot: SecretSpot, completion: @escaping (_ success: Bool) -> ()) {
      
        let spotId = spot.postId
        
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
        
        REF_POST.document(spot.postId).updateData(data) { error in
            if let error = error {
                print("There was an error updating view card while dismissing card")
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
                    
                    let spotId  = snapshot.documentID
                    
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
    
    
    func getSpotsFromWorld(userId: String, completion: @escaping (_ spots: [SecretSpot]) -> ()) {
        REF_WORLD.document("private").collection(userId).addSnapshotListener { snapshot, error in
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
                            let date = dateCreated.dateValue()

                            let secretSpot = SecretSpot(postId: postId, spotName: name, imageUrl: imageUrl, longitude: longitude, latitude: latitude, address: address, city: city, zipcode: zipcode, world: world, dateCreated: date, viewCount: viewCount, price: price, saveCounts: saveCounts, isPublic: isPublic, description: description, ownerId: ownerId, ownerDisplayName: ownerDisplayName, ownerImageUrl: ownerImageUrl)
                            secretSpots.append(secretSpot)
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
        
        getUserHistory { returnedHistory in
            history = returnedHistory
            print("printing history inside new spots", history)
        }
        
        REF_POST
            .order(by: SecretSpotField.dateCreated, descending: true)
            .getDocuments { querysnapshot, error in
                let results = self.getSecretSpotsFromSnapshot(querysnapshot: querysnapshot)
                let filteredResults = results.filter({$0.isPublic == true
                                                        && $0.ownerId != uid
                                                        && !history.contains($0.postId)})
                completion(filteredResults)
            }
            
//            .limit(to: 12)
    }

    
    
    func getSecretSpotsFromSnapshot(querysnapshot: QuerySnapshot?) -> [SecretSpot] {
        var secretSpots = [SecretSpot]()
        
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

                    let secretSpot = SecretSpot(postId: postId, spotName: spotName, imageUrl: imageUrl, longitude: longitude, latitude: latitude, address: address, city: city, zipcode: zipcode, world: world, dateCreated: date, viewCount: viewCount, price: price, saveCounts: saveCounts, isPublic: isPublic, description: description, ownerId: ownerId, ownerDisplayName: ownerDisplayName, ownerImageUrl: ownerImageUrl)
                    secretSpots.append(secretSpot)
                }
            }
            return secretSpots
        } else {
            print("No saved secret spots found in snapshot for this user")
            return secretSpots
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
    //MARK: UPDATE FUNCTIONS
    
    
    func updateProfileImage(userId: String, profileImageUrl: String) {
        
        REF_USERS.document(userId).setData([UserField.profileImageUrl : profileImageUrl], merge: true)
    }
    
    func updateUserBio(userId: String, bio: String) {
        REF_USERS.document(userId).setData([UserField.bio : bio], merge: true)
    }
    
    func updateUserDisplayName(userId: String, displayName: String) {
        
        REF_USERS.document(userId).setData([UserField.displayName : displayName], merge: true)
    }
//
    func updateDisplayNameOnPosts(userId: String, displayName: String) {

        getSpotsFromWorld(userId: userId) { secretSpots in
            let filteredSpots = secretSpots.filter({$0.ownerId == userId})

            for spot in filteredSpots {
                self.updatePostDisplayName(postID: spot.postId, displayName: displayName)
            }


        }


    }
    
    private func updatePostDisplayName(postID: String, displayName: String) {
        guard let uid = userId else {return}
        let data: [String : Any] = [
            SecretSpotField.ownerDisplayName: displayName
        ]
        
        REF_POST.document(postID).updateData(data)
    }
    
     func updatePostProfileImageUrl(profileUrl: String) {
        guard let uid = userId else {return}
        let data: [String: Any] = [
            SecretSpotField.ownerImageUrl: profileUrl
        ]

        getSpotsFromWorld(userId: uid) { secretspots in

            let filteredSpots = secretspots.filter({$0.ownerId == uid})

            filteredSpots.forEach { [weak self] spot in

                self?.REF_POST.document(spot.postId).updateData(data)
            }
        }

    }
//
    
    //MARK: DELETE FUNCTIONS
    
    func deleteSecretSpot(spot: SecretSpot, completion: @escaping (_ success: Bool) -> ()) {
        guard let uid = userId else {return}
        let spotId = spot.postId

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
