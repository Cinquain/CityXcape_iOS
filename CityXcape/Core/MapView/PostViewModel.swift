//
//  PostViewModel.swift
//  CityXcape
//
//  Created by James Allan on 12/3/21.
//

import SwiftUI
import MapKit


class PostViewModel: NSObject, ObservableObject {
    
    var worldPlaceHolder = "example: #Skaters"
    var privatePlaceHolder = "Secret Spot is Private"
    var worldDefinition = "Different World Different Spots"
    var detailsPlaceHolder = "Describe what makes this spot is special"
    var pricePlaceHolder = " 1"
    
    @Published var spotName: String = ""
    @Published var details: String = ""
    @Published var world: String = ""
    @Published var isPublic: Bool = true
    @Published var refresh: Bool = false
    @Published var priceString: String = ""
    @Published var isLoading: Bool = false
    var price: Int = 1

    
    @Published var showPicker: Bool = false
    @Published var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Published var selectedImage: UIImage?

    
    @Published var presentPopover: Bool = false
    @Published var showActionSheet: Bool = false
    @Published var buttonDisabled: Bool = false
    
    
    @Published var presentCompletion: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""

    
    
    func isReady(mapItem: MKMapItem)  {
        price = Int(priceString) ?? 1
        
        if isPublic == false {
            world = "Private"
        }
        
        if spotName.count > 4
            && selectedImage != nil
            && details.count > 10
            && world.count >= 2
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
            
            if selectedImage == nil {
                alertMessage = "Please add an image for your spot"
                showAlert.toggle()
                return
            }
            
           
            
        }
    }
    
    func postSecretSpot(mapItem: MKMapItem) {
        isLoading = true
        buttonDisabled = true
        guard let image = selectedImage else {return}
        
        DataService.instance.uploadSecretSpot(spotName: spotName, description: details, image: image, price: price, world: world, mapItem: mapItem, isPublic: isPublic) { [weak self] (success) in
            guard let self = self else {return}
            if success {
                self.isLoading = false
                self.buttonDisabled = false
                self.presentCompletion.toggle()
            } else {
                self.isLoading = false
                self.buttonDisabled = false
                self.showAlert.toggle()
                self.alertMessage = "Error posting Secret Spot 😤"
            }
        }
    }
    
    
    func converToHashTag() {
        
        var newWords = [String]()
        let wordsArray = world.components(separatedBy:" ")
            
        
        for word in wordsArray {
            if word.count > 0 {
                
                if word.contains("#") {
                    let newWord = word.replacingOccurrences(of: "#", with: "")
                                    
                    newWords.append("#\(newWord.capitalizingFirstLetter())")
                } else {
                    let newWord = "#\(word.capitalizingFirstLetter())"
                    newWords.append(newWord)
                }
            }
            
         
        }
        world = ""
//        newWords.forEach({ world += " \($0)"})
        var count = 1
        for word in newWords {
            if count == 4 {
                break
            }
            world += " \(word)"
            count += 1
            
        }
    }
    
    
}
