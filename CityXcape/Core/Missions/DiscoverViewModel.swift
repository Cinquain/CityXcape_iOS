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
    
    @Published var finished: Bool = false
    @Published var saved: Bool = false
    @Published var passed: Bool = false
    
    @Published var rankings: [Ranking] = []
    @Published var showStreetPass: Bool = false

    init() {
        getScoutLeaders()
        getNewSecretSpots()
        subscribetoRouter()
    }
    
    func getNewSecretSpots() {
        
        DataService.instance.getNewSecretSpots(lastSecretSpot: lastSecretSpot) { [weak self] secretspots in
            print("This is secret spots inside mission model", secretspots)
            self?.allspots = secretspots
            self?.newSecretSpots = secretspots
            self?.finished = true
            
            if self?.newSecretSpots.count ?? 0 > 0 {
                self?.hasNewSpots = true
            }
            
        }
    }
    
    
    func refreshSecretSpots() {
        
        DataService.instance.getNewSecretSpots(lastSecretSpot: lastSecretSpot) { [weak self] secretspots in
            print("This is secret spots inside mission model", secretspots)
            self?.newSecretSpots = secretspots
            
            if self?.newSecretSpots.count ?? 0 > 0 {
                print("User has new missions of \(self?.newSecretSpots.count ?? 0)")
                self?.hasNewSpots = true
            } else {
                self?.alertMessage = "No new spot recently posted 😭"
                self?.showAlert = true
            }
            
        }
        
    }
    
    
    func performSearch(searchTerm: String) {
        if searchTerm.isEmpty {
            newSecretSpots = allspots
            return
        }
        newSecretSpots = allspots.filter({$0.city.lowercased().contains(searchTerm.lowercased())
                            || $0.world.lowercased().contains(searchTerm.lowercased())
                            || $0.spotName.lowercased().contains(searchTerm.lowercased())})
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
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    self?.saved = false
                    self?.manager.addEntityFromSpot(spot: spot)
                    
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    if let index = self?.newSecretSpots.firstIndex(of: spot) {
                        self?.newSecretSpots.remove(at: index)
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
    
    
    
    func streetFollow(rank: Ranking, fcm: String) {
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
    
    

    
    
}
