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


class DiscoverViewModel: ObservableObject {
    
    
    @AppStorage(CurrentUserDefaults.userId) var userId: String?
    @AppStorage(CurrentUserDefaults.wallet) var wallet: Int?

    let notificationManager = NotificationsManager.instance
    let manager = CoreDataManager.instance
    let router = Router.shared
    var cancellable = Set<AnyCancellable>()
    
    @Published var allspots: [SecretSpot] = []
    @Published var newSecretSpots: [SecretSpot] = []
    @Published var lastSecretSpot: String = ""
    @Published var hasPostedSpot : Bool = false
    @Published var hasNewSpots: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var searchTerm: String = ""

    @Published var finished: Bool = false
    @Published var saved: Bool = false
    @Published var passed: Bool = false
    
    @Published var rankings: [Rank] = []
    @Published var showStreetPass: Bool = false
    @Published var newlySaved: Int = 0
    @Published var isSearching: Bool = false

    init() {
        if notificationManager.hasSpotNotification {
            if let postId = notificationManager.spotId {
                findSpecificSpot(spotId: postId)
            }
        }
        getScoutLeaders()
        getNewSecretSpots()
    }
    
    func getNewSecretSpots() {
        
        DataService.instance.getNewSecretSpots() { [weak self] secretspots in
            self?.allspots = secretspots
            self?.newSecretSpots = secretspots
            self?.finished = true
            
            if self?.newSecretSpots.count ?? 0 > 0 {
                self?.hasNewSpots = true
            }
            
        }
    }
    
    func findSpecificSpot(spotId: String) {
        DataService.instance.getSpecificSpot(postId: spotId) { result in
            switch result {
            case .failure(let error):
                print("error fetching spot", error.localizedDescription)
            case .success(let spot):
                self.newSecretSpots.removeAll()
                self.allspots.append(spot)
                self.newSecretSpots.insert(spot, at: 0)
            }
        }
    }
    
  
    
    func refreshSecretSpots() {
        
        DataService.instance.refreshSecretSpots { [weak self] secretspots in
            self?.newSecretSpots = secretspots
            self?.subscribetoRouter()

            if self?.newSecretSpots.count ?? 0 > 0 {
                print("User has new missions of \(self?.newSecretSpots.count ?? 0)")
                self?.hasNewSpots = true
            } else {
                self?.alertMessage = "No new spot recently posted 😭"
                self?.showAlert = true
            }
        }
        
    }
    
    
    func performSearch() {
        if searchTerm.isEmpty {
            newSecretSpots = allspots
            isSearching = false 
            return
        }
        newSecretSpots = allspots.filter({$0.city.lowercased().contains(searchTerm.lowercased())
                            || $0.world.lowercased().contains(searchTerm.lowercased())
                            || $0.spotName.lowercased().contains(searchTerm.lowercased())})
        isSearching = false
    }
    
    
    func getDistanceMessage(spot: SecretSpot) -> String {
        
        if spot.distanceFromUser > 1 {
            return "\(String(format: "%.1f", spot.distanceFromUser)) miles"
        } else {
            return "\(String(format: "%.1f", spot.distanceFromUser)) mile"
        }
    }
    
    
    
    func saveCardToUserWorld(spot: SecretSpot) {
        guard var wallet = wallet else {return}
        
        if wallet >= spot.price {
            //Decremement wallet locally
            wallet -= spot.price
            UserDefaults.standard.set(wallet, forKey: CurrentUserDefaults.wallet)
            print("Saving to user's world")
            //Save to DB
            DataService.instance.saveToUserWorld(spot: spot) { [weak self] success in
                
                if !success {
                    print("Error saving to user's world")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self?.saved = false
                    }
                    return
                }
                print("successfully saved spot to user's world")
                AnalyticsService.instance.savedSecretSpot()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                    guard let self = self else {return}
                    self.saved = false
                    self.manager.addEntityFromSpot(spot: spot)
                    self.calculateWorld()
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    if let index = self?.newSecretSpots.firstIndex(of: spot) {
                        self?.newSecretSpots.remove(at: index)
                        self?.newlySaved += 1
                    }
                }
            }
            
         
        } else {
            saved = false
            alertMessage = "Insufficient StreetCred. Your wallet has a balance of \(wallet) STC."
            showAlert.toggle()
        }
        
    }
    
    
    func dismissCard(spot: SecretSpot) {
        print("Removing from user's world")
        
        DataService.instance.dismissCard(spot: spot) { [weak self] success in
            if !success {
                print("Error dismissing card")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self?.passed = false 
                }
                return
            }
            
            print("successfully dismissed card to DB")
            AnalyticsService.instance.passedSecretSpot()
            self?.passed = false

            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if let index = self?.newSecretSpots.firstIndex(of: spot) {
                    self?.newSecretSpots.remove(at: index)
                }
            }
        }
        
    }
    
    
    
    func streetFollow(rank: Rank, fcm: String) {
        let user = User(rank: rank)
        DataService.instance.streetFollowUser(user: user, fcmToken: fcm) { [weak self] succcess in
            if succcess {
                self?.alertMessage = "Following \(rank.displayName)"
                self?.showAlert = true
            } else {
                self?.alertMessage = "Cannot follow \(rank.displayName)"
                self?.showAlert = true
            }
        }
        
    }
    
    
    fileprivate func getScoutLeaders() {
        
        DataService.instance.getUserRankings { ranks in
            self.rankings = ranks
        }
    }
    
    fileprivate func subscribetoRouter() {
         router.$postId
                .combineLatest(notificationManager.$spotId)
                .sink { [weak self] (id1, id2) in
                    guard let self = self else {return}
                    
                    if id1 != nil {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.newSecretSpots = self.allspots.filter({$0.id == id1})
                            self.router.postId = nil
                        }
                    } else if id2 != nil {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.newSecretSpots = self.allspots.filter({$0.id == id2})
                            self.notificationManager.spotId = nil
                        }
                    }
                  
                }
                .store(in: &cancellable)
    }
    
    
    func calculateWorld()  {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else {return}
            self.manager.fetchSecretSpots()
            var worlds: [String] = []
            var worldDictionary: [String: Double] = [:]
            let spots = self.manager.spotEntities.map({SecretSpot(entity: $0)})
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
            let worldCompo = worldDictionary
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
            
            
            let userData: [String: Any] = [
                UserField.world : worldCompo
            ]
            guard let uid = self.userId else {return}
            print("updating User's world")
            
            AuthService.instance.updateUserField(uid: uid, data: userData)
        }

    }

    
    

    
    
}
