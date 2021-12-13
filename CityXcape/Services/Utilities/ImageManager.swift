//
//  ImageManager.swift
//  CityXcape
//
//  Created by James Allan on 9/3/21.
//

import Foundation
import FirebaseStorage

let imageCache = NSCache<AnyObject, UIImage>()

class ImageManager {
    
    static let instance = ImageManager()
    
    private var REF_STORE = Storage.storage()
    
    //MARK: PUBLIC FUNCTIONS
    func uploadProfileImage(uid: String, image: UIImage, completion: @escaping (_ url: String?) -> ()) {
        
        let path = getProfileImagePath(uid: uid)
        
        uploadImage(path: path, image: image) { (success, downloadUrl) in
            if success {
                completion(downloadUrl)
            }
        }
        
    }
    
    func uploadSecretSpotImage(image: UIImage, postId: String, completion: @escaping (_ url: String?) -> ()) {
        
        let path = getSpotImagePath(spotId: postId, imageNum: 1)
        
        uploadImage(path: path, image: image) { (success, downloadUrl) in
            if success {
                completion(downloadUrl)
            }
        }
    }
    
    func updateSecretSpotImage(image: UIImage, postId: String, number: Int, completion: @escaping (_ url: String?) -> ()) {
        
        let path = getSpotImagePath(spotId: postId, imageNum: number)
        
        uploadImage(path: path, image: image) { success, imageUrl in
            if success {
                completion(imageUrl)
            }
        }
        
    }
    
    func downloadProfileImage(userId: String, completion: @escaping (_ image: UIImage?) -> ()) {
        
        let path = getProfileImagePath(uid: userId)
        
        downloadImage(path: path) { foundImage in
            completion(foundImage)
        }
        
    }
    
    //MARK: PRIVATE FUNCTIONS
    fileprivate func getProfileImagePath(uid: String) -> StorageReference {
        
        let userPath = "users/\(uid)/profileImage"
        let storagePath = REF_STORE.reference(withPath: userPath)
        return storagePath
    }
    
    fileprivate func getSpotImagePath(spotId: String, imageNum: Int) -> StorageReference {
        let postPath = "posts/\(spotId)/\(imageNum)"
        let storagePath = REF_STORE.reference(withPath: postPath)
        return storagePath
    }
    
    
    fileprivate func uploadImage(path: StorageReference, image: UIImage, completion: @escaping (_ success: Bool, _ imageUrl: String?) -> ()) {
        
        var compression: CGFloat = 1.0
        let maxFileSize: Int = 500 * 500
        let maxCompression: CGFloat = 0.25
        
        guard var originalData = image.jpegData(compressionQuality: compression) else {
            print("Error getting data from image")
            completion(false, nil)
            return
        }
        
        while (originalData.count > maxFileSize) && (compression > maxCompression) {
            compression -= 0.05
            if let compressedData = image.jpegData(compressionQuality: compression) {
                originalData = compressedData
            }
        }
        
        guard let finalData = image.jpegData(compressionQuality: compression) else {
            print("Error getting data from image")
            completion(false, nil)
            return
        }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        path.putData(finalData, metadata: metadata) { (meta, error) in
            
            if let error = error {
                print("Error uploading image", error.localizedDescription)
                completion(false, nil)
                return
            } else {
                path.downloadURL { (url, err) in
                    guard let downloadUrl = url?.absoluteString else {
                        print("Error getting user profile url")
                        completion(false, nil)
                        return
                    }
                    
                    completion(true, downloadUrl)
                }
            }
        
        }
        
    }
    
    fileprivate func downloadImage(path: StorageReference, completion: @escaping (_ image: UIImage?) -> ()) {
        
        if let cachedImage = imageCache.object(forKey: path) {
            completion(cachedImage)
            print("Image is found in cahce")
            return
        }
        
        path.getData(maxSize: 27 * 1024 * 1024) { (data, error) in
            
            if let imageData = data,
               let image = UIImage(data: imageData) {
                imageCache.setObject(image, forKey: path)
                completion(image)
                return
            } else {
                print("Error getting data from path for image")
                completion(nil)
                return
            }
            
        }
        
    }
    
}
