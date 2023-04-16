//
//  PostTrailViewModel.swift
//  CityXcape
//
//  Created by James Allan on 6/17/22.
//

import Foundation
import Combine
import UIKit
import MapKit


class PostTrailViewModel: NSObject, ObservableObject {


    @Published var trailName: String = ""
    @Published var trailDetails: String = ""
    @Published var world: String = ""
    @Published var priceString: String = ""
    @Published var videoURL: URL?
    
    @Published var selectedImage: UIImage?
    @Published var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Published var showPicker: Bool = false 
    @Published var actionSheet: Bool = false
    @Published var showAlert: Bool = false 
    @Published var alertMessage: String = ""
    
    @Published var selectedSpots: [SecretSpot] = []
    @Published var allspots: [SecretSpot] = CoreDataManager.instance.spotEntities
                                                .map({SecretSpot(entity: $0)})
                                                .filter({$0.ownerId == User().id})
    @Published var showList: Bool = false
    @Published var showAllSpots: Bool = false
    @Published var showMap: Bool = false
    
    @Published var startDate: Date = Date()
    @Published var endDate: Date = Date()
    @Published var streetcred: Int = 1 
    
    var namePlaceHolder: String = "Name your trail"
    var worldPlaceHolder: String = "What Community? i.e: #Artists #Skaters"
    var detailsPlaceHolder: String = "Describe what this trail is"
    var datedescript: String = "Start Date"
    var datedescript2: String = "End Date"
    var pricePlaceHolder: String = "1"
    
    
    
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
    
    func showListMessage() -> String {
        if selectedSpots.count <= 1 {
            return "\(selectedSpots.count) spot selected"
        } else {
            return "\(selectedSpots.count) spots selected"
        }
    }
    
    func postTrailtoDb(location: MKMapItem, isHunt: Bool) {
        let user = User()
        let price = Int(priceString) ?? 10
        let image = selectedImage ?? UIImage()
        if isHunt {
            DataService.instance.createHunt(name: trailName, details: trailDetails, image: image, startDate: startDate, endDate: endDate, location: location, world: world, user: user, price: price, spots: selectedSpots, completion: { [weak self] result in
                guard let self = self else {return}
                switch result {
                    case .success(_):
                        self.alertMessage = "Successfully posted scavenger hunt"
                        self.showAlert.toggle()
                    case .failure(let error):
                        self.alertMessage = error.localizedDescription
                        self.showAlert.toggle()
                }
            })
        } else {
            DataService.instance.createTrail(name: trailName, details: trailDetails, image: image, world: world, user: user, price: price, location: location, spots: selectedSpots, completion: { [weak self] result in
                guard let self = self else {return}
                switch result {
                    case .success(_):
                        self.alertMessage = "Successfully posted trail"
                        self.showAlert.toggle()
                    case .failure(let error):
                        self.alertMessage = error.localizedDescription
                        self.showAlert.toggle()
                }
            })
        }
    }
    
    
    
}
