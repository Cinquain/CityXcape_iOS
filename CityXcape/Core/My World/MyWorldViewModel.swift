//
//  JourneyViewModel.swift
//  CityXcape
//
//  Created by James Allan on 9/11/21.
//

import Foundation
import SwiftUI
import Combine

class MyWorldViewModel: ObservableObject {
    @AppStorage(CurrentUserDefaults.userId) var userId: String?
    
    let manager = CoreDataManager.instance
    
    @Published var secretspots: [SecretSpot] = []
    @Published var users: [User] = []
    @Published var showOnboarding: Bool = false
    
    var cancellables = Set<AnyCancellable>()
    
    init() {
        
        manager.fetchSecretSpots()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.setupSubscribers()
        }
    }
    
    
    func getSavedSpotsForUser(uid: String) {
        
        DataService.instance.getSpotsFromWorld(userId: uid, coreData: true) { [weak self] returnedSpots in
            if returnedSpots.isEmpty {

                print("No Secret Spots in array")
                self?.showOnboarding = true
            } else {
                self?.secretspots = returnedSpots
                self?.showOnboarding = false
                print(returnedSpots)

            }
          
        }
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
    
    func setupSubscribers() {
        
        manager.$spotEntities
            .sink { entities in
                self.secretspots.removeAll()
                self.secretspots = entities.map({SecretSpot(entity: $0)})
                print("Loading from Core Data")
                if self.secretspots.isEmpty {
                    print("Core Data is Empty")
                    guard let userId = self.userId else {return}
                    self.getSavedSpotsForUser(uid: userId)
                }
            }
            .store(in: &cancellables)
        
    }
    
}
