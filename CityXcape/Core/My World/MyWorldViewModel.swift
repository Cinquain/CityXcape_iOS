//
//  JourneyViewModel.swift
//  CityXcape
//
//  Created by James Allan on 9/11/21.
//

import Foundation
import SwiftUI
import Combine

class MyWorldViewModel: NSObject, ObservableObject {
    @AppStorage(CurrentUserDefaults.userId) var userId: String?
    
    let manager = CoreDataManager.instance
    
    @Published var allSpots: [SecretSpot] = []
    @Published var currentSpots: [SecretSpot] = []
    @Published var users: [User] = []
    @Published var showOnboarding: Bool = false
    @Published var showVisited: Bool = false
    
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @State var searchTerm: String = ""
    
    
    var cancellables = Set<AnyCancellable>()
    
    override init() {
        super.init()
        setupToggleObserver()
    }
    
        
    
    func getSavedSpotsForUser(uid: String) {
        
        DataService.instance.getSpotsFromWorld(userId: uid, coreData: true) { [weak self] returnedSpots in
            
            guard let strongself = self else {return}
            if returnedSpots.isEmpty {

                print("No Secret Spots in array")
                self?.showOnboarding = true
            } else {
                self?.allSpots = returnedSpots
                self?.currentSpots = strongself.allSpots.filter({$0.verified == false})
                self?.showOnboarding = false
                print(returnedSpots)

            }
          
        }
    }
    
    func setupToggleObserver() {
        
        $showVisited
            .sink { [weak self] showVisited in
                guard let self = self else {return}
                if showVisited {
                    self.currentSpots = self.allSpots.filter({$0.verified == true})
                } else {
                    self.currentSpots = self.allSpots.filter({$0.verified == false})
                }
            }
            .store(in: &cancellables)
    }
    
    func openGoogleMap(spot: SecretSpot) {
        
        if (UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!)) {
            if let url = URL(string: "comgooglemaps-x-callback://?saddr=&daddr=\(spot.latitude),\(spot.longitude)&directionsmode=driving") {
                UIApplication.shared.open(url, options: [:])
            }
            
        } else {
            //Open in brower
            if let url = URL(string: "https://www.google.co.in/maps/dir/?saddr=&daddr=\(spot.latitude),\(spot.longitude)&directionsmode=driving") {
                UIApplication.shared.open(url)
            }
            
        }
    }
    
    
    func getSavedbyUsers(postId: String) {
        
        
        DataService.instance.getUsersForSpot(postId: postId, path: "savedBy") { savedUsers in
            if savedUsers.isEmpty {
                print("No users saved this secret spot")
                self.users = []
            } else {
                self.users = savedUsers
            }
        }
    }
    
    func getVerifiedUsers(postId: String) {
        
        
        DataService.instance.getUsersForSpot(postId: postId, path: "verifiers") { verifiedUsers in
            if verifiedUsers.isEmpty {
                print("No users verified this spot")
                self.users = []
            } else {
                self.users = verifiedUsers
            }
        }
    }
    
    func formatSecretSpots() {
        
        let spots = manager.spotEntities.map({SecretSpot(entity: $0)})
        if spots.isEmpty {
            print("Core Data is Empty")
            guard let userId = self.userId else {return}
            self.getSavedSpotsForUser(uid: userId)
        } else {
            print("Core Data Entities Found!")
            self.allSpots.removeAll()
            self.allSpots = spots
            self.currentSpots = self.allSpots.filter({$0.verified == false})
        }
            
    }
    
    func getDistanceMessage(spot: SecretSpot) -> String {
        
        if spot.distanceFromUser > 1 {
            return "\(String(format: "%.1f", spot.distanceFromUser)) miles"
        } else {
            return "\(String(format: "%.1f", spot.distanceFromUser)) mile"
        }
    }
    

    
    
}
