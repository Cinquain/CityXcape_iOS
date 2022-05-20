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
    
    @AppStorage(CurrentUserDefaults.userId) var userId: String?

    
    @Published var showJourney: Bool = false
    @Published var showStats: Bool = false
    @Published var showStreetFollowers: Bool = false
    @Published var showWorld: Bool = false 
    
    @Published var showFollowing: Bool = false
    @Published var showStreetPass: Bool = false
    @Published var streetFollowers: [User] = []
    @Published var streetFollowing: [User] = []
    @Published var worldCompo: [String: Double] = [:]
    @Published var users: [User] = []
    @Published var alertMessage: String = ""
    @Published var showAlert: Bool = false
    

    
    var cancellable: AnyCancellable?
    let coreData = CoreDataManager.instance
    let manager = NotificationsManager.instance
    
    override init() {
        super.init()
        getStreetFollowers()
        getFollowing()
        setSubscribers()
        calculateWorld()
    }
    
    func generateColors() -> [Color] {
        var colors: [Color] = []
        (0...worldCompo.count).forEach { _ in
            colors.append(Color.random)
        }
        return colors
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
    
    func openInstagram(username: String)  {
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
    
    func calculateWorld()  {
        coreData.fetchSecretSpots()
        var worlds: [String] = []
        var worldDictionary: [String: Double] = [:]
        
        let spots = coreData.spotEntities.map({SecretSpot(entity: $0)})
        if spots.isEmpty {return}
        spots.forEach({worlds.append(contentsOf: $0.world.components(separatedBy: " "))})
        
        for word in worlds {
            let newWord = word
                        .replacingOccurrences(of: "#", with: "")
                        .replacingOccurrences(of: ",", with: "")
                        
            
            if word == "" {
                continue
            }
                
            if let count = worldDictionary[newWord] {
                worldDictionary[newWord] = count + 1
            } else {
                worldDictionary[newWord] = 1
            }
        }
      
        
        let sum = worldDictionary.reduce(0, {$0 + $1.value})
        
        self.worldCompo = worldDictionary
            .mapValues({($0 / sum).rounded(toPlaces: 2) * 100})
        
        
        var topworld = ""
        worldCompo.keys.forEach { key in
            if topworld == "" {
                topworld = key
            } else {
                if worldCompo[key]! > worldCompo[topworld]! {
                    topworld = key
                }
            }
        }
        topworld.capitalizeFirstLetter()
        print("top world is: \(topworld)")
        
        
        let userData: [String: Any] = [
            UserField.community: topworld,
            UserField.world : worldCompo
        ]
        guard let uid = userId else {return}
        AuthService.instance.updateUserField(uid: uid, data: userData)

    }
    
    
    
    
    
}
