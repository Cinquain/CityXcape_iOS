//
//  PublicStreetPassVM.swift
//  CityXcape
//
//  Created by James Allan on 5/21/22.
//

import Foundation
import SwiftUI


class PublicStreetPassVM: NSObject, ObservableObject {
    
    @Published var showJourney: Bool = false
    @Published var verifications: [Verification] = []
    
    override init() {
        super.init()
        
    }
    
    
     func getVerificationForUser(userId: String) {
        DataService.instance.getVerifications(uid: userId) { [weak self] verifications in
            guard let self = self else {return}
            self.verifications = verifications
            self.showJourney = true
        }
    }
    
    
    
    
}
