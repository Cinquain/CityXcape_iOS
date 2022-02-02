//
//  MissionViewModel.swift
//  CityXcape
//
//  Created by James Allan on 10/4/21.
//

import Foundation
import Combine
import SwiftUI
import MapKit





class MissionViewModel: ObservableObject {
    @AppStorage(CurrentUserDefaults.userId) var userId: String?

    @Published var standardMissions: [Mission] = []
    @Published var newSecretSpots: [SecretSpot] = []
    @Published var lastSecretSpot: String = ""
    @Published var hasPostedSpot : Bool = false
    @Published var hasNewSpots: Bool = false
    @Published var showAlert: Bool = false
    
    @Published var searchTerm: String = ""
    @Published var oldResults: [SecretSpot] = []
    
    init() {
       
        getNewSecretSpots()
        
        guard let uid = userId  else {return}

        DataService.instance.getSpotsFromWorld(userId: uid, coreData: false) { spots in
            
            let filteredSpots = spots.filter({$0.ownerId == uid})
            if filteredSpots.count > 0 {
                self.hasPostedSpot = true
            } else {
                let missionOne = Mission(title: "Post a Secret Spot", imageurl: "https://firebasestorage.googleapis.com/v0/b/cityxcape-1e84f.appspot.com/o/CityXcape%2Fexplore.png?alt=media&token=ffd05b82-46bf-48a7-8fd7-4d221d5cbf33", description: "Help the scout community grow by posting a secret spot. Secret Spots are cool places not known by most people. You get streetCred each time a user saves your spot.", world: "ScoutLife", region: "United States", bounty: 1, owner: "CityXcape", ownerImageUrl: "https://firebasestorage.googleapis.com/v0/b/cityxcape-1e84f.appspot.com/o/CityXcape%2Fcx.png?alt=media&token=42a71d38-592b-4879-9cf5-288956240eac")
                
                self.standardMissions.append(missionOne)
                self.standardMissions = self.standardMissions.unique()
            }
        }
    }
    
    func getNewSecretSpots() {
        
        DataService.instance.getNewSecretSpots(lastSecretSpot: lastSecretSpot) { [weak self] secretspots in
            print("This is secret spots inside mission model", secretspots)
            self?.newSecretSpots = secretspots
            
            if self?.newSecretSpots.count ?? 0 > 0 {
                print("User has new missions of \(self?.newSecretSpots.count ?? 0)")
                self?.hasNewSpots = true
            }
            
        }
    }
    
    func refreshSecretSpots() {
        
        DataService.instance.getNewSecretSpots(lastSecretSpot: lastSecretSpot) { [weak self] secretspots in
            print("This is secret spots inside mission model", secretspots)
            self?.newSecretSpots = secretspots
            
            if self?.newSecretSpots.count ?? 0 > 0 {
                print("User has new missions of \(self?.newSecretSpots.count ?? 0)")
                self?.hasNewSpots = true
            } else {
                self?.showAlert = true
            }
            
        }
        
    }
    
    
    func performSearch() {
        if oldResults.isEmpty {
            oldResults.append(contentsOf: newSecretSpots)
            let results = newSecretSpots.filter({$0.city.contains(searchTerm)
                || $0.world.contains(searchTerm.lowercased())})
            newSecretSpots = results
            return
        }
            let results = oldResults.filter({$0.city.contains(searchTerm)
                || $0.world.contains(searchTerm.lowercased())})
            newSecretSpots = results
        
    }
    
    func getDistanceMessage(spot: SecretSpot) -> String {
        
        if spot.distanceFromUser > 1 {
            return "\(String(format: "%.1f", spot.distanceFromUser)) miles"
        } else {
            return "\(String(format: "%.1f", spot.distanceFromUser)) mile"
        }
    }
    
    
    
}
