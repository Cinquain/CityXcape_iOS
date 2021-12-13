//
//  PostViewModel.swift
//  CityXcape
//
//  Created by James Allan on 12/3/21.
//

import SwiftUI
import MapKit


class PostViewModel: NSObject, ObservableObject {
    
    var worldPlaceHolder = "What community is this for?"
    var privatePlaceHolder = "Secret Spot is Private"
    var worldDefinition = "Different World Different Spots"
    var detailsPlaceHolder = "Describe what makes this spot is special"
    
    @Published var spotName: String = ""
    @Published var details: String = ""
    @Published var world: String = ""
    @Published var isPublic: Bool = true

    
    @Published var showPicker: Bool = false
    @Published var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Published var selectedImage: UIImage = UIImage()

    
    @Published var presentPopover: Bool = false
    @Published var showActionSheet: Bool = false
    @Published var buttonDisabled: Bool = false
    
    
    @Published var presentCompletion: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var addedImage: Bool = false

    
    
    func isReady(mapItem: MKMapItem)  {
        
        if isPublic == false {
            world = "Private"
        }
        
        if spotName.count > 4
            && addedImage == true
            && details.count > 10
            && world.count > 2
              {
            
            self.postSecretSpot(mapItem: mapItem)
            
        } else {
            
            if spotName.count < 4 {
                alertMessage = "Spot needs a title at least four characters long"
                showAlert.toggle()
                return
            }
            
            if details.count < 10 {
                alertMessage = "Description needs to be at least 10 characters long"
                showAlert.toggle()
                return
            }
            
            if world.count < 3 {
                alertMessage = "Please include a World. \n Your world should be at least 3 characters long"
                showAlert.toggle()
                return
            }
            
            if addedImage == false {
                alertMessage = "Please add an image for your spot"
                showAlert.toggle()
                return
            }
            
           
            
        }
    }
    
    func postSecretSpot(mapItem: MKMapItem) {

        buttonDisabled = true

        DataService.instance.uploadSecretSpot(spotName: spotName, description: details, image: selectedImage, world: world, mapItem: mapItem, isPublic: isPublic) { (success) in
            
            if success {
                self.buttonDisabled = false
                self.presentCompletion.toggle()
            } else {
                self.buttonDisabled = false
                self.showAlert.toggle()
                self.alertMessage = "Error posting Secret Spot 😤"
            }
        }
    }
    
    
    
}
