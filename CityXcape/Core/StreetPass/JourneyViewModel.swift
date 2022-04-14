//
//  JourneyViewModel.swift
//  CityXcape
//
//  Created by James Allan on 3/3/22.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class JourneyViewModel: NSObject, ObservableObject {
    
    
    @Published var verifications: [Verification] = []
    @Published var cities: [String: Int] = [:]
    @Published var showCollection: Bool = false
    @Published var showJournal: Bool = false
    @Published var alertMessage: String = ""
    @Published var showAlert: Bool = false

    override init() {
        super.init()
        getVerificationForUser()
    }
    
    fileprivate func getCities() {
            
        verifications.forEach { verification in

            if let count = cities[verification.city] {
                cities[verification.city] = count + 1
            } else {
            
                cities[verification.city] = 1
            }
        }
        
    }
    
    fileprivate func getVerificationForUser() {
        DataService.instance.getVerifications { [weak self] verifications in
            self?.verifications = verifications
            self?.getCities()
        }
    }
    
    
    func openJournal() {
        AnalyticsService.instance.checkedJournal()
        if verifications.isEmpty {
            alertMessage = "You have no stamps in your journal. \n Go check in a location to get stamped."
            showAlert = true
        } else {
            showJournal = true
        }
    }
    
    func openCollection() {
        AnalyticsService.instance.checkedCityStamp()
        if cities.isEmpty {
            alertMessage = "You have no cities stamped in your journal. \n Go check into a location to get stamped."
            showAlert = true
        } else {
            showCollection = true
        }
    }
    
    func locationMessage() -> String {
        if verifications.count > 1 {
            return "\(verifications.count) Locations"
        } else {
            return "\(verifications.count) Location"
        }
    }
    
    func cityMessage() -> String {
        if cities.keys.count > 1 {
            return "\(cities.keys.count) Cities"
        } else {
            return "\(cities.keys.count) City"
        }
    }
    
    
    
    
    
}
