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
    
    
    static let instance = DataService()
    
    private var REF_POST = DB_BASE.collection("posts")
    private var REF_USERS = DB_BASE.collection("users")
    private var REF_REPORTS = DB_BASE.collection("reports")
    //MARK: CREATE FUNCTIONS
    
    func uploadSecretSpot(spotName: String, description: String, image: UIImage, world: String, mapItem: MKMapItem, completion: @escaping (_ success: Bool) -> ()) {
        
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
        
        let userWorldRef = REF_USERS.document(uid).collection("world").document(spotId)
   

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
                    SecretSpotField.dateCreated: FieldValue.serverTimestamp()
                ]
                
                userWorldRef.setData(spotData)
                document.setData(spotData) { [weak self ](error) in
                    if let err = error {
                        print("Error uploading secret spot to database", err.localizedDescription)
                        completion(false)
                        return
                    } else {
                    completion(true)
                        let savedData: [String: Any] = [
                            "userId": uid,
                            "profileUrl": ownerImageUrl,
                            "displayName": ownerDisplayName,
                            "dateSaved": FieldValue.serverTimestamp()
                        ]
                        self?.REF_POST.document(spotId).collection("savedBy").document(uid).setData(savedData)
                    return
                }
                
                }
            } else {
                
                print("Error uploading spot photo to Firestore")
                completion(false)
                return
            }
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
    
    func downloadSavedPostForUser(userId: String, completion: @escaping (_ spots: [SecretSpot]) -> ()) {
        REF_USERS.document(userId).collection("world").addSnapshotListener { [self] (querysnapshot, error) in
            completion(self.getSecretSpotsFromSnapshot(querysnapshot: querysnapshot))
        }
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
                let saveCounts = document.get(SecretSpotField.saveCount) as? Int,
                let viewCount = document.get(SecretSpotField.viewCount) as? Int,
                let world = document.get(SecretSpotField.world) as? String,
                let price = document.get(SecretSpotField.price) as? Int {
                    
                    let postId = document.documentID
                    let date = dateCreated.dateValue()

                    let secretSpot = SecretSpot(postId: postId, spotName: spotName, imageUrl: imageUrl, longitude: longitude, latitude: latitude, address: address, city: city, zipcode: zipcode, world: world, dateCreated: date, viewCount: viewCount, price: price, saveCounts: saveCounts, description: description, ownerId: ownerId, ownerDisplayName: ownerDisplayName, ownerImageUrl: ownerImageUrl)
                    secretSpots.append(secretSpot)
                }
            }
            return secretSpots
        } else {
            print("No saved secret spots found in snapshot for this user")
            return secretSpots
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
    
    func updateDisplayNameOnPosts(userId: String, displayName: String) {
        
        downloadSavedPostForUser(userId: userId) { [weak self] secretSpots in
            
            for spot in secretSpots {
                self?.updatePostDisplayName(postID: spot.postId, displayName: displayName)
            }
        }
    }
    
    private func updatePostDisplayName(postID: String, displayName: String) {
        guard let uid = userId else {return}
        let data: [String : Any] = [
            SecretSpotField.ownerDisplayName: displayName
        ]
        
        REF_POST.document(postID).updateData(data)
        REF_USERS.document(uid).collection("world").document(postID).updateData(data)
    }
    
    //MARK: DELETE FUNCTIONS
    
    func deleteSecretSpot(spotId: String, completion: @escaping (_ success: Bool) -> ()) {
        guard let uid = userId else {return}
        
        REF_POST.document(spotId).delete()
        REF_USERS.document(uid).collection("world").document(spotId).delete { error in
            
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
