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


class DataService {
    
    
    static let instance = DataService()
    
    private var REF_POST = DB_BASE.collection("posts")
    //MARK: CREATE FUNCTIONS
    
    func uploadSecretSpot(spotName: String, address: String, image: UIImage, coordinates: CLLocationCoordinate2D, uid: String, completion: @escaping (_ success: Bool) -> ()) {
        
        let document = REF_POST.document()
        let spotId = document.documentID
        
        ImageManager.instance.uploadSecretSpotImage(image: image, postId: spotId) { (urlString) in
            
            if let downloadUrl = urlString {
                
                
                let spotData: [String: Any] = [
                    SecretSpotField.spotId: spotId,
                    SecretSpotField.spotName: spotName,
                    SecretSpotField.imageUrl: downloadUrl,
                    SecretSpotField.address: address,
                    SecretSpotField.latitude: coordinates.latitude,
                    SecretSpotField.longitude: coordinates.longitude,
                    SecretSpotField.ownerId: uid,
                    SecretSpotField.price: 1,
                    SecretSpotField.viewCount: 1,
                    SecretSpotField.saveCount: 1,
                    SecretSpotField.dateCreated: FieldValue.serverTimestamp()
                ]
                
                document.setData(spotData) { (error) in
                    if let err = error {
                        print("Error uploading secret spot to database", err.localizedDescription)
                        completion(false)
                        return
                    } else {
                    completion(true)
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
    
    
    private var REF_USERS = DB_BASE.collection("users")
    
    
    func updateProfileImage(userId: String, profileUrl: String) {
        
        REF_USERS.document(userId).setData([UserField.profileImageUrl: profileUrl], merge: true)
    }
}
