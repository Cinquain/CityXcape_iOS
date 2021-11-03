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
            } else {
                self?.hasUserMissions = false
            }
        }
        
        guard let uid = userId  else {return}

        DataService.instance.getSpotsFromWorld(userId: uid) { spots in
            
            let filteredSpots = spots.filter({$0.ownerId == uid})
            if filteredSpots.count > 0 {
                self.hasPostedSpot = true
            } else {
                let missionOne = Mission(title: "Post a Secret Spot", imageurl: "https://firebasestorage.googleapis.com/v0/b/cityxcape-1e84f.appspot.com/o/missions%2Fexplore.png?alt=media&token=9f2dfb67-6a1c-40f7-8a32-78273d4119f7", description: "Help the scout community grow by posting a secret spot. Secret Spots are cool places not known by most people. You get 1 StreetCred each time a user saves your spot.", world: "ScoutLife", region: "United States", bounty: 1, owner: "CityXcape", ownerImageUrl: "https://firebasestorage.googleapis.com/v0/b/cityxcape-1e84f.appspot.com/o/CityXcape%2Fcx.png?alt=media&token=4f8b0b0a-ea9d-412e-8e6f-dbd00960a6c7")
                
                self.standardMissions.append(missionOne)
            }
        }
        
     
        
       
        
    }
    
    

    
    
}
