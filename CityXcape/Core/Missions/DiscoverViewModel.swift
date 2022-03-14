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
    
    @Published var searchTerm: String = ""
    @Published var oldResults: [SecretSpot] = []
    
    init() {
       
        getNewSecretSpots()
    }
    
    func getNewSecretSpots() {
        
        DataService.instance.getNewSecretSpots(lastSecretSpot: lastSecretSpot) { [weak self] secretspots in
            print("This is secret spots inside mission model", secretspots)
            self?.allspots = secretspots
            self?.newSecretSpots = secretspots
            self?.finished = true
            
            if self?.newSecretSpots.count ?? 0 > 0 {
                print("User has \(self?.newSecretSpots.count ?? 0) new spots")
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
    
    
    func performSearch() {
        if oldResults.isEmpty {
            oldResults.append(contentsOf: newSecretSpots)
            let results = newSecretSpots.filter({$0.city.contains(searchTerm)
                || $0.world.contains(searchTerm.lowercased())})
            newSecretSpots = results
            return
        }
            let results = oldResults.filter({$0.city.contains(searchTerm)
                || $0.world.contains(searchTerm.lowercased())})
            newSecretSpots = results
        
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
            saved = true
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
                
                if let index = self?.newSecretSpots.firstIndex(of: spot) {
                    self?.newSecretSpots.remove(at: index)
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self?.saved = false
                }
            }
            
         
        } else {
            alertMessage = "Insufficient StreetCred. Your wallet has a balance of \(wallet) STC."
            showAlert.toggle()
        }
        
    }
    
    
    func dismissCard(spot: SecretSpot) {
        print("Removing from user's world")
        passed = true
        
        DataService.instance.dismissCard(spot: spot) { [weak self] success in
            if !success {
                print("Error dismissing card")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self?.passed.toggle()
                }
                return
            }
            
            print("successfully dismissed card to DB")
            AnalyticsService.instance.passedSecretSpot()
            
            if let index = self?.newSecretSpots.firstIndex(of: spot) {
                self?.newSecretSpots.remove(at: index)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self?.passed = false
            }
        }
        
   
        
    }
    
    
    
    
    
    
}
