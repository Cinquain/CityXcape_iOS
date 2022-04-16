//
//  StreetPassViewModel.swift
//  CityXcape
//
//  Created by James Allan on 4/4/22.
//

import Foundation
import Combine
import SwiftUI

class StreetPassViewModel: NSObject, ObservableObject {
    
    
    @Published var showJourney: Bool = false
    @Published var showStats: Bool = false
    @Published var showStreetFollowers: Bool = false
    
    
    @Published var showFollowing: Bool = false
    @Published var showStreetPass: Bool = false
    @Published var streetFollowers: [User] = []
    @Published var streetFollowing: [User] = []
    @Published var users: [User] = []
    @Published var alertMessage: String = ""
    @Published var showAlert: Bool = false
    
    var cancellable: AnyCancellable?
    let manager = NotificationsManager.instance
    
    override init() {
        super.init()
        getStreetFollowers()
        getFollowing()
        setSubscribers()
    }
    
    
    func getStreetFollowers() {
        
        DataService.instance.getStreetFollowers { [weak self] followers in
            self?.streetFollowers = followers
            self?.users = followers
        }
    }
    
    func getFollowing() {
        DataService.instance.getStreetFollowing { [weak self] following in
            self?.streetFollowing = following
        }
    }
    
    func unfollowerUser(uid: String) {
        
        DataService.instance.unfollowerUser(followingId: uid) { [weak self] success in
            if success {
                self?.alertMessage = "Successfuly unfollowed user"
                self?.showAlert.toggle()
                self?.streetFollowing.removeAll(where: {$0.id == uid})
            } else {
                self?.alertMessage = "Failed to unfollow user"
                self?.showAlert.toggle()
            }
        }
        
    }
    
    func followerUser(user: User) {
        
        manager.checkAuthorizationStatus { [weak self] fcmToken in
            
            if let token = fcmToken {
                
                DataService.instance.streetFollowUser(user: user, fcmToken: token) {  succcess in
                    if succcess {
                        self?.alertMessage = "Following \(user.displayName)"
                        self?.showAlert = true
                        self?.streetFollowing.append(user)
                    } else {
                        self?.alertMessage = "Cannot follow \(user.displayName)"
                        self?.showAlert = true
                    }
                }
                
            } else {
                self?.alertMessage = "Please give CityXcape notifications permission"
                self?.showAlert = true
            }
            
        }
        
    }
    
    func setSubscribers() {
        
      cancellable =  $showFollowing
            .sink { [weak self] boolen in
                if boolen {
                    self?.users = self?.streetFollowing ?? []
                } else {
                    self?.users = self?.streetFollowers ?? []
                }
            }
        
    }
    
    func openInstagram(username: String) {
            //Open in brower
        let appURL = URL(string: "instagram://user?username=\(username)")!
        let application = UIApplication.shared
        
        if application.canOpenURL(appURL) {
            application.open(appURL, options: [:])
        } else {
            let webURL = URL(string: "https://instagram.com/\(username)")!
            application.open(webURL)
        }
        
    }
    
    
    
    
    
}
