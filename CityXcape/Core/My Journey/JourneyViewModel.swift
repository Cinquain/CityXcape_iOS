//
//  JourneyViewModel.swift
//  CityXcape
//
//  Created by James Allan on 9/11/21.
//

import Foundation
import SwiftUI

class JourneyViewModel: ObservableObject {
    @AppStorage(CurrentUserDefaults.userId) var userId: String?
    
    @Published var secretspots: [SecretSpot] = [SecretSpot]()
    
    init() {
        guard let userId = userId else {return}
        self.getSavedSpotsForUser(uid: userId)
    }
    
    
    func getSavedSpotsForUser(uid: String) {
        
        DataService.instance.downloadSavedPostForUser(userId: uid) { [weak self] returnedSpots in
            
            self?.secretspots = returnedSpots
        }
        
    }
}
