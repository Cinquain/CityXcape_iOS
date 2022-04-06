//
//  StreetPassViewModel.swift
//  CityXcape
//
//  Created by James Allan on 4/4/22.
//

import Foundation
import Combine

class StreetPassViewModel: NSObject, ObservableObject {
    
    
    @Published var showJourney: Bool = false
    @Published var showStats: Bool = false
    @Published var showStreetFollowers: Bool = false
    
    
    @Published var showFollowing: Bool = false
    @Published var showStreetPass: Bool = false
    @Published var streetFollowers: [User] = []
    
    @Published var alertMessage: String = ""
    @Published var showAlert: Bool = false
    
    
    override init() {
        super.init()
        getStreetFollowers()
    }
    
    
    func getStreetFollowers() {
        
        DataService.instance.getStreetFollowers { [weak self] followers in
            self?.streetFollowers = followers
        }
    }
    
    func unfollowerUser(uid: String) {
        
        DataService.instance.unfollowerUser(followingId: uid) { [weak self] success in
            if success {
                self?.alertMessage = "Successfuly unfollowed user"
                self?.showAlert.toggle()
            } else {
                self?.alertMessage = "Failed to unfollow user"
                self?.showAlert.toggle()
            }
        }
        
    }
    
    func followerUser(uid: String, name: String, fcm: String) {
        
        DataService.instance.streetFollowUser(followingId: uid, fcmToken: fcm) { [weak self] success in
            if success {
                self?.alertMessage = "Successfuly following \(name)"
                self?.showAlert.toggle()
            } else {
                self?.alertMessage = "Failed to follow \(name)"
                self?.showAlert.toggle()
            }
        }
        
        
    }
    
    
}
