//
//  JourneyViewModel.swift
//  CityXcape
//
//  Created by James Allan on 9/11/21.
//

import Foundation
import SwiftUI

class MyWorldViewModel: ObservableObject {
    @AppStorage(CurrentUserDefaults.userId) var userId: String?
    
    @Published var secretspots: [SecretSpot] = []
    
    init() {
        guard let userId = userId else {return}
        self.getSavedSpotsForUser(uid: userId)
        
    }
    
    
    func getSavedSpotsForUser(uid: String) {
        
        DataService.instance.getSpotsFromWorld(userId: uid) { [weak self] returnedSpots in
            if returnedSpots.isEmpty {

                print("No Secret Spots in array")
            }
            self?.secretspots = returnedSpots
            print(returnedSpots)
        }
    }
    
    
}
