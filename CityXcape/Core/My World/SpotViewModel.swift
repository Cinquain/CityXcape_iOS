//
//  SpotViewModel.swift
//  CityXcape
//
//  Created by James Allan on 11/22/21.
//

import SwiftUI
import CoreLocation
import Combine
import FirebaseFirestore
import JGProgressHUD_SwiftUI

class SpotViewModel: NSObject, ObservableObject {
    
    @AppStorage(CurrentUserDefaults.userId) var userId: String?
    @EnvironmentObject var hudCoordinator: JGProgressHUDCoordinator


    @Published var alertmessage: String = ""
    @Published var genericAlert: Bool = false
    
    @Published var alertMessage: String = ""
    @Published var showAlert: Bool = false
    @Published var showCheckin: Bool = false
    @Published var disableCheckin: Bool = false
    @Published var refresh: Bool = false

    
    @Published var newDescription: String = ""
    @Published var newWorld: String = ""
    @Published var newSpotName: String = ""
    @Published var newSpotImageUrl: String = ""

    
    @Published var showPicker: Bool = false
    @Published var addedImage: Bool = false
    @Published var imageSelected: SecretSpotImageNumb = .one
    @Published var selectedImage: UIImage = UIImage()
    @Published var selectedImageII: UIImage = UIImage()
    @Published var selectedImageIII: UIImage = UIImage()
    @Published var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    var amount: Float = 10

    let manager = CoreDataManager.instance
    var cancellables = Set<AnyCancellable>()
    
    override init() {
        super.init()
        
    }
    
    func openGoogleMap(spot: SecretSpot) {
        
        if (UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!)) {
            if let url = URL(string: "comgooglemaps-x-callback://?saddr=&daddr=\(spot.latitude),\(spot.longitude)&directionsmode=driving") {
                UIApplication.shared.open(url, options: [:])
            }
            
        } else {
            //Open in brower
            if let url = URL(string: "https://www.google.co.in/maps/dir/?saddr=&daddr=\(spot.latitude),\(spot.longitude)&directionsmode=driving") {
                UIApplication.shared.open(url)
            }
            
        }
    }
    
    func checkInSecretSpot(spot: SecretSpot) {
        disableCheckin = true
        AnalyticsService.instance.touchedVerification()
        let manager = LocationService.instance.manager
        
        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
            let manager = LocationService.instance.manager
            let spotLocation = CLLocation(latitude: spot.latitude, longitude: spot.longitude)
            let userLocation = CLLocation(latitude: (manager.location?.coordinate.latitude)!, longitude: (manager.location?.coordinate.longitude)!)
            let distance = userLocation.distance(from: spotLocation) * 3.28084
            let distanceInMiles = distance * 0.000621371
            let formattedDistance = String(format: "%.0f", distanceInMiles)
            print("\(distance) feet")
            if distance < 200 {
                DataService.instance.checkIfUserAlreadyVerified(spot: spot) {  doesExist in
                    
                    if doesExist {
                        self.alertMessage = "You've already verified this spot"
                        self.showAlert = true
                        self.disableCheckin = false
                        return
                        
                    } else {
                        DataService.instance.verifySecretSpot(spot: spot) { [weak self] success  in
                            
                            if !success {
                                print("Error saving checkin to database")
                                self?.alertMessage = "Error saving verification to database"
                                self?.showAlert = true
                                self?.disableCheckin = false
                                return
                            }
                            
                            print("Successfully saved verification to database")
                            AnalyticsService.instance.verify()
                            self?.showCheckin = true
                            
                        }
                    }
                }
            } else {
                alertMessage = "You need to be there to verify. \n You are \(formattedDistance) miles away."
                showAlert = true
                disableCheckin = false
            }
        } else {
            manager.requestWhenInUseAuthorization()
            disableCheckin = false
        }
        
        
    }
    
    func spotDistance(spot: SecretSpot) -> Double {
        
        let manager = LocationService.instance.manager
        let spotLocation = CLLocation(latitude: spot.latitude, longitude: spot.longitude)
        let userLocation = CLLocation(latitude: (manager.location?.coordinate.latitude)!, longitude: (manager.location?.coordinate.longitude)!)
        let distance = userLocation.distance(from: spotLocation) * 3.28084
     
        return distance
    
    }
    
    func showWorldDefinition(spot: SecretSpot) {
        self.alertMessage = "This spot is for the \(spot.world) community"
        self.showAlert = true
    }
    
    func editSpotDescription(postId: String) {
        
        let data: [String: Any] = [
            SecretSpotField.description : newDescription
        ]
        
        manager.updateDescription(spotId: postId, description: newDescription)
        
        DataService.instance.updateSpotField(postId: postId, data: data) { success in
            
            if success {
                
                self.alertmessage = "Successfully updated description"
                self.showAlert = true
                return
            } else {
                self.alertmessage = "Failed to update description"
                self.showAlert = true
                return
            }
            
        }
    }
    
    func editWorldTag(postId: String) {
        let hashtag = newWorld.converToHashTag()
        
        let data: [String: Any] = [
            SecretSpotField.world : hashtag
        ]
        
        manager.updateWorld(spotId: postId, world: hashtag)
        
        DataService.instance.updateSpotField(postId: postId, data: data) { success in
            
            if success {
                self.alertmessage = "Successfully updated World"
                self.showAlert = true
                return
            } else {
                self.alertmessage = "Failed to update World"
                self.showAlert = true
                return
            }
        }
    }
    
    func editSpotName(postId: String) {
        let data: [String: Any] = [
            SecretSpotField.spotName : newSpotName
        ]
        
        manager.updateName(spotId: postId, name: newSpotName)
        
        DataService.instance.updateSpotField(postId: postId, data: data) { success in
            
            if success {
                self.alertmessage = "Successfully updated spot name"
                self.showAlert = true
                return
            } else {
                self.alertmessage = "Failed to update spot name"
                self.showAlert = true
                return
            }
        }
    }
    
    func updateMainSpotImage(postId: String, completion: @escaping (_ url: String) -> ()) {
     
        ImageManager.instance.uploadSecretSpotImage(image: selectedImage, postId: postId) { downloadUrl in
            
            guard let url = downloadUrl else {return}
            completion(url)
            self.manager.updateImage(spotId: postId, index: 0, imageUrl: url)
            self.newSpotImageUrl = url
            
            let data: [String: Any] = [
                SecretSpotField.spotImageUrl : url
            ]
            
            DataService.instance.updateSpotField(postId: postId, data: data) { success in
                if success {
                    self.alertmessage = "Successfully updated image"
                    self.showAlert = true
                    return
                } else {
                    self.alertmessage = "Failed to upload image"
                    self.showAlert = true
                    return
                }
            }
            
        }
    }
    
    func updateAdditonalImage(postId: String, image: UIImage, number: Int,  completion: @escaping (_ url: String) -> ()) {

        ImageManager.instance.updateSecretSpotImage(image: image, postId: postId, number: number) { url in
           
            guard let downloadUrl = url else {return}
            completion(downloadUrl)
            let index = number - 1
            self.manager.updateImage(spotId: postId, index: index, imageUrl: downloadUrl)
            
            let data: [String: Any] = [
                SecretSpotField.spotImageUrls : FieldValue.arrayUnion([downloadUrl])
            ]
            
            DataService.instance.updateSpotField(postId: postId, data: data) { success in
                
                if success {
                    self.alertmessage = "Successfully added image"
                    self.showAlert = true
                    return
                } else {
                    self.alertmessage = "Failed to add new image"
                    self.showAlert = true
                    return
                }
                
            }
            
        }
        
    }
    
    func setupImageSubscriber() {
        $selectedImage
            .combineLatest($selectedImageII, $selectedImageIII)
            .sink { [weak self] _ in
                self?.addedImage = true
            }
            .store(in: &cancellables)
    }
    
    func reportPost(reason: String, spot: SecretSpot) {
          print("Reporting post")
          AnalyticsService.instance.reportPost()
          DataService.instance.uploadReports(reason: reason, postId: spot.postId) { success in
              
              if success {
                  self.alertmessage = "Thank you for reporting this spot. We will review it shortly!"
                  self.genericAlert.toggle()
              } else {
                  self.alertmessage = "There was an error reporting this secret spot. Please restart the app and try again."
                  self.genericAlert.toggle()
              }
          }

      }
    
    
    func deletePost(spot: SecretSpot, completion: @escaping (_ success: Bool) -> ()) {
        
        DataService.instance.deleteSecretSpot(spot: spot) { success in
           
           if success {
               self.alertmessage = "This secret spot has been removed from your world"
               self.genericAlert.toggle()
               AnalyticsService.instance.deletePost()
               completion(success)
           } else {
               self.alertmessage = "There was an error in deleting this spot. Restart the app and try again"
               self.genericAlert.toggle()
               completion(success)
           }
       }
   }
    
}
