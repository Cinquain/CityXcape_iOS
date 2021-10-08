//
//  MissionViewModel.swift
//  CityXcape
//
//  Created by James Allan on 10/4/21.
//

import Foundation
import Combine
import MapKit



class MissionViewModel: ObservableObject {
    
    @Published var standardMissions: [Mission] = []
    
    
    
    
    init() {
        let missionOne = Mission(title: "Post a Secret Spot", imageurl: "https://firebasestorage.googleapis.com/v0/b/cityxcape-1e84f.appspot.com/o/missions%2Fexplore.jpg?alt=media&token=474e3d92-bf7a-4ce0-afc9-f996d5f96fd9", description: "Help the scout community grow by posting a secret spot. Secret Spots are cool places not known by most people. You get 5 StreetCred for posting your first spot.", world: "ScoutLife", region: "United States", bounty: 5, owner: "CityXcape", ownerImageUrl: "https://firebasestorage.googleapis.com/v0/b/cityxcape-1e84f.appspot.com/o/CityXcape%2Fcx.png?alt=media&token=4f8b0b0a-ea9d-412e-8e6f-dbd00960a6c7")
        
        standardMissions.append(missionOne)
    }
    
    
}
