//
//  AuthService.swift
//  CityXcape
//
//  Created by James Allan on 9/2/21.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseMessaging


let DB_BASE = Firestore.firestore()


class AuthService {
    
    
    static let instance = AuthService()
    private init() {}
    
    private var REF_USERS = DB_BASE.collection("users")
    
    func loginUserToFirebase(credential: AuthCredential, completion: @escaping (_ providerId: String?, _ error: Bool, _ isNewUser: Bool?, _ userId: String?) -> ()) {
        
        
        Auth.auth().signIn(with: credential) { result, error in
            
            if error != nil {
                print("Error logging in to Firebase")
                completion(nil, true, nil, nil)
                return
            }
            
            guard let providerId = result?.user.uid else {
                print("Error gettign user Id")
                completion(nil, true, nil, nil)
                return
            }
            
            self.checkIfUserExistsInDatabase(providerID: providerId) { (returnedUserId) in
                
                if let userId = returnedUserId {
                    //User exist, log in to app
                    completion(providerId, false, false, userId)
                } else {
                    //User does not exist, continue onboarding new user
                    completion(providerId, false, true, nil)
                }
            }            
        }
        
    }
    
    func loginUserToApp(userId: String, completion: @escaping (_ success: Bool) -> ()) {
        
        getUserInfo(forUserID: userId) { (name, bio, streetcred, profileUrl) in
            if let name = name,
               let bio = bio,
               let streetcred = streetcred,
               let profileurl = profileUrl {
                print("Success getting user info while logging in")
                completion(true)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    
                    UserDefaults.standard.set(userId, forKey: CurrentUserDefaults.userId)
                    UserDefaults.standard.set(name, forKey: CurrentUserDefaults.displayName)
                    UserDefaults.standard.set(bio, forKey: CurrentUserDefaults.bio)
                    UserDefaults.standard.set(streetcred, forKey: CurrentUserDefaults.wallet)
                    UserDefaults.standard.set(profileurl, forKey: CurrentUserDefaults.profileUrl)
                    
                }
                
            } else {
                print("Error getting user info while logging in")
                completion(false)
            }
            
        }
    }
    
    
    func logOutUser(completion: @escaping (_ success: Bool) -> ()) {
        
        do {
            try Auth.auth().signOut()
        } catch {
            completion(false)
            print("Error \(error.localizedDescription)")
            return
        }
        
        completion(true)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let dictionary = UserDefaults.standard.dictionaryRepresentation()
            
            dictionary.keys.forEach { (key) in
                UserDefaults.standard.removeObject(forKey: key)
            }
        }
        
    }
    
    func createNewUserInDatabase(name: String, email: String, providerId: String, provider: String, profileImage: UIImage, completion: @escaping (_ userId: String?) -> ()) {
        
        let document = REF_USERS.document()
        let userId = document.documentID
        var profileImageUrl = ""
        let fcmToken = Messaging.messaging().fcmToken ?? ""
        
        ImageManager.instance.uploadProfileImage(uid: userId, image: profileImage) { (imageUrl) in
            guard let url = imageUrl else {return}
            profileImageUrl = url
            
            let userData: [String: Any] = [
                UserField.displayName: name,
                UserField.email: email,
                UserField.providerId: providerId,
                UserField.provider: userId,
                UserField.streetCred: 0,
                UserField.fcmToken: fcmToken,
                UserField.bio: "",
                UserField.profileImageUrl: profileImageUrl,
                UserField.dataCreated: FieldValue.serverTimestamp()
            ]
            
            document.setData(userData) { (error) in
                if let error = error {
                    print("Error uploading data to user document.", error.localizedDescription)
                    completion(nil)
                } else {
                    completion(userId)
                }
            }
        }
        
        
    }
    
    
    private func checkIfUserExistsInDatabase(providerID: String, completion: @escaping (_ existingUserId: String?) -> ()) {
        
        REF_USERS.whereField(UserField.providerId, isEqualTo: providerID).getDocuments { (snapshot, error) in
            
            if let snapshot = snapshot,
               snapshot.count > 0,
               let document = snapshot.documents.first {
                let existingUserId = document.documentID
                print("Found User")
                completion(existingUserId)
            } else {
                completion(nil)
                print("Did not find user")
                return
            }
            
        }
    }
    
    func getUserInfo(forUserID userId: String, completion: @escaping (_ name: String?, _ bio: String?,_ streetcred: Int?, _ imageUrl: String?) -> ()) {
        
        REF_USERS.document(userId).getDocument { (snapshot, error) in
                        
            if let document = snapshot,
               let name = document.get(UserField.displayName) as? String,
               let bio = document.get(UserField.bio) as? String,
               let streetCred = document.get(UserField.streetCred) as? Int,
               let imageUrl = document.get(UserField.profileImageUrl) as? String {
                completion(name, bio, streetCred, imageUrl)
                return
            } else {
                print("Error getting user info", error?.localizedDescription)
                completion(nil, nil,nil, nil)
                return
            }
               
        }
    }
    
    //MARK: UPDATE USER FUNCTIONS
    
    func updateUserDisplayName(userId: String, displayName: String, completion: @escaping (_ success: Bool) -> ()) {
        let data : [String:Any] = [
            UserField.displayName: displayName
        ]
        
        REF_USERS.document(userId).updateData(data) { error in
            
            if let error = error {
                print("Error updating user display nane", error.localizedDescription)
                completion(false)
                return
            } else {
                completion(true)
                return
            }
        }
    }
    
    func updateUserField(uid: String, data: [String: Any]) {
        REF_USERS.document(uid).updateData(data)
    }
    
    func updateUserBio(userId: String, bio: String, completion: @escaping (_ success: Bool) -> ()) {
        let data : [String:Any] = [
            UserField.bio: bio
        ]
        
        REF_USERS.document(userId).updateData(data) { error in
            
            if let error = error {
                print("Error updating user display nane", error.localizedDescription)
                completion(false)
                return
            } else {
                completion(true)
                return
            }
        }
    }
}
