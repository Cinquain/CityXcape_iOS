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
    @Published var userMissions: [SecretSpot] = []
    @Published var lastSecretSpot: String = ""
    @Published var hasPostedSpot : Bool = false
    @Published var hasUserMissions: Bool = false
    
    init() {
        DataService.instance.getNewSecretSpots(lastSecretSpot: lastSecretSpot) { [weak self] secretspots in
            print("This is secret spots inside mission model", secretspots)
            self?.userMissions = secretspots
            
            if self?.userMissions.count ?? 0 > 0 {
                print("User has new missions of \(self?.userMissions.count ?? 0)")
                self?.hasUserMissions = true
            }
            
        }
        
        guard let uid = userId  else {return}

        DataService.instance.getSpotsFromWorld(userId: uid) { spots in
            
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
    
    

    
    
}
