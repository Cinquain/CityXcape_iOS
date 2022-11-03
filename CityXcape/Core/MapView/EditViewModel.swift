//
//  EditViewModel.swift
//  CityXcape
//
//  Created by James Allan on 4/18/22.
//

import Combine
import FirebaseFirestore
import SwiftUI
import MapKit

class EditViewModel: ObservableObject {
    
    let manager = CoreDataManager.instance
    
    @Published var title: String = ""
    @Published var description: String = ""
    @Published var world: String = ""
    @Published var address: String = ""
    @Published var streetcred: String = "1"
    @Published var isLoading: Bool = false
    @Published var selectedMapItem: MKMapItem = MKMapItem()
    @Published var showCoordinates: Bool = false
    @Published var videoUrl: URL?
    @Published var isVideo: Bool = false
    
    @Published var editDescription: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var showMap: Bool = false 
    
    @Published var image: UIImage?
    @Published var index: Int = 0
    
    @State var imageOneString: String = ""
    @State var imageTwoString: String = ""
    @State var imageThreeString: String = ""
    
    
    @Published var showPicker: Bool = false
    @Published var sourceType: UIImagePickerController.SourceType = .photoLibrary

    
    
    
    
    
    
    
    func editSpotName(postId: String) {
        let data: [String: Any] = [
            SecretSpotField.spotName : title
        ]
        
        manager.updateName(spotId: postId, name: title)
        
        DataService.instance.updateSpotField(postId: postId, data: data) { [weak self] success in
            
            guard let self = self else {return}
            if success {
                self.alertMessage = "Successfully updated spot name"
                self.showAlert = true
                return
            } else {
                self.alertMessage = "Failed to update spot name"
                self.showAlert = true
                return
            }
        }
    }
    
    func getAddress() -> String {
        if showCoordinates {
            return selectedMapItem.getAddress()
        } else {
            return "Change Location"
        }
    }
    
    func updateLocation(spotId: String) {
        var spotCity = selectedMapItem.getCity()
        let long = selectedMapItem.placemark.coordinate.longitude
        let lat = selectedMapItem.placemark.coordinate.latitude
        let location = CLLocationCoordinate2D(latitude: selectedMapItem.placemark.coordinate.latitude,
                                              longitude: selectedMapItem.placemark.coordinate.longitude)
        if spotCity == "" {
            location.fetchCityAndCountry { city, _, error in
                spotCity = city ?? ""
            }
        }
      
        let data: [String: Any] = [
            SecretSpotField.longitude: long,
            SecretSpotField.latitude: lat,
            SecretSpotField.city: spotCity,
        ]
        
        DataService.instance.updateSpotField(postId: spotId, data: data) { [weak self] success in
            
            if success {
                self?.alertMessage = "Successfully updated spot location"
                self?.manager.updateLocation(spotId: spotId, long: long, lat: lat, city: spotCity)
                self?.showAlert = true
                return
            } else {
                self?.alertMessage = "Failed to update spot name"
                self?.showAlert = true
                return
            }
            
        }
        
    }
    
    
    func editSpotDescription(postId: String) {
        
        let data: [String: Any] = [
            SecretSpotField.description : description
        ]
        
        manager.updateDescription(spotId: postId, description: description)
        
        DataService.instance.updateSpotField(postId: postId, data: data) { [weak self] success in
            
            guard let self = self else {return}
            
            if success {
                self.alertMessage = "Successfully updated description"
                self.showAlert = true
                return
            } else {
                self.alertMessage = "Failed to update description"
                self.showAlert = true
                return
            }
        }
    }
    
    
    func editWorldTag(postId: String) {
        let hashtag = world.converToHashTag()
        
        let data: [String: Any] = [
            SecretSpotField.world : hashtag
        ]
        
        manager.updateWorld(spotId: postId, world: hashtag)
        
        DataService.instance.updateSpotField(postId: postId, data: data) { [weak self] success in
            guard let self = self else {return}
            
            if success {
                self.alertMessage = "Successfully updated World"
                self.showAlert = true
                return
            } else {
                self.alertMessage = "Failed to update World"
                self.showAlert = true
                return
            }
        }
    }
    
    func editPrice(postId: String) {
        
        let price = Int(streetcred) ?? 1
        
        let data: [String: Any] = [
            SecretSpotField.price: price
        ]
        
        manager.updatePrice(spotId: postId, price: price)
        
        DataService.instance.updateSpotField(postId: postId, data: data) { success in
            if success {
                self.alertMessage = "Successfully updated price"
                self.showAlert = true
                return
            } else {
                self.alertMessage = "Failed to update price"
                self.showAlert = true
                return
            }
        }
        
        
    }
    
    func findIndexof(url: String, spot: SecretSpot) {
        guard let index = spot.imageUrls.firstIndex(of: url) else {return}
        self.index = index
    }

        
    func updateMainSpotImage(postId: String, completion: @escaping (_ url: String?) -> ()) {
        if let newImage = image {
            //Delete file in bucket (index starts at 1)
            isLoading = true
            print("Found Image")
            print("Deleting main image in bucket")
            ImageManager.instance.deleteSecretSpotImage(postId: postId, imageNumb: 1)
            
            ImageManager.instance.uploadSecretSpotImage(image: newImage, postId: postId) {[weak self ] downloadUrl in
                guard let self = self else {return}
                guard let url = downloadUrl else {return}
                self.imageOneString = url
                
                //Deletes old url at core data and replace it with new one (index starts at 0)
                print("Updating image in core data")
                self.manager.updateImage(spotId: postId, index: 0, imageUrl: url)
                
                let data: [String: Any] = [
                    SecretSpotField.spotImageUrl : url
                ]
                
                print("update image to database")
                DataService.instance.updateSpotField(postId: postId, data: data) { success in
                    if success {
                        self.isLoading = false
                        self.alertMessage = "Successfully updated image"
                        self.showAlert = true
                        completion(url)
                        return
                    } else {
                        self.isLoading = false
                        self.alertMessage = "Failed to upload image"
                        self.showAlert = true
                        completion(nil)
                        return
                    }
                }
                
            }
        } else {
            self.alertMessage = "No image found"
            self.showAlert = true
            completion(nil)
            return
        }
    }
    
    func updateExtraImage(postId: String, oldUrl: String, completion: @escaping (_ url: String?) -> ()) {
        
        guard let newImage = image else {return}
        isLoading = true
        ImageManager.instance.deleteSecretSpotImage(postId: postId, imageNumb: index + 1)

        ImageManager.instance.updateSecretSpotImage(image: newImage, postId: postId, number: index + 1) { [weak self] url in
            guard let self = self else {return}
            guard let downloadUrl = url else {return}
            self.imageTwoString = downloadUrl
            
            self.manager.updateImage(spotId: postId, index: self.index, imageUrl: downloadUrl)

            let deleteData: [String: Any] = [
                SecretSpotField.spotImageUrls : FieldValue.arrayRemove([oldUrl]),
            ]
            
            DataService.instance.updateSpotField(postId: postId, data: deleteData) { success in
                if success {
                    
                        let data: [String: Any] = [
                            SecretSpotField.spotImageUrls : FieldValue.arrayUnion([downloadUrl])
                        ]
                    
                    
                    DataService.instance.updateSpotField(postId: postId, data: data) { success in
                        
                        if success {
                            self.isLoading = false
                            self.alertMessage = "Successfully added image"
                            self.showAlert = true
                            completion(downloadUrl)
                            return
                        } else {
                            self.isLoading = false
                            self.alertMessage = "Failed to add new image"
                            self.showAlert = true
                            completion(nil)
                            return
                        }
                        
                    }
                } else {
                    self.isLoading = false
                    self.alertMessage = "Could not find old image to replace"
                    self.showAlert = true
                    return
                }
                
                
            }
            
        }
        
    }
    
    func addImage(postId: String, completion: @escaping (_ url: String?) -> ()) {
        
        guard let newImage = image else {return}
        isLoading = true
        ImageManager.instance.updateSecretSpotImage(image: newImage, postId: postId, number: self.index + 1) { [weak self] url in
            guard let self = self else {return}
            guard let downloadUrl = url else {return}
            
            self.manager.addImage(spotId: postId, imageUrl: downloadUrl)
        
                let data: [String: Any] = [
                    SecretSpotField.spotImageUrls : FieldValue.arrayUnion([downloadUrl])
                ]
            
            
            DataService.instance.updateSpotField(postId: postId, data: data) { success in
                
                if success {
                    self.isLoading = false
                    self.alertMessage = "Successfully added image"
                    self.showAlert = true
                    completion(downloadUrl)
                    return
                } else {
                    self.isLoading = false
                    self.alertMessage = "Failed to add new image"
                    self.showAlert = true
                    completion(nil)
                    return
                }
                
            }
            
        }
    }
    
    
    func deleteImage(postId: String, url: String) {
        self.isLoading = true
        let data: [String: Any] = [
            SecretSpotField.spotImageUrls : FieldValue.arrayRemove([url])
        ]

        DataService.instance.updateSpotField(postId: postId, data: data) { [weak self] success in
            guard let self = self else {return}
            if success {
                self.isLoading = false
                self.alertMessage = "Successfully deleted image"
                self.showAlert = true
                return
            } else {
                self.isLoading = false
                self.alertMessage = "Failed to delete new image"
                self.showAlert = true
                return
            }
        }
        
    }
    
    
    
    
    //End of class
}
