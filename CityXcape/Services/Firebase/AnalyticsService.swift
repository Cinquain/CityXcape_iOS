//
//  AnalyticsService.swift
//  CityXcape
//
//  Created by James Allan on 11/2/21.
//

import Foundation
import FirebaseAnalytics




class AnalyticsService {
    
    
    
    static let instance = AnalyticsService()
    
    
    func postSecretSpot() {
        Analytics.logEvent("spot_created", parameters: nil)
    }
    
    func savedSecretSpot() {
        Analytics.logEvent("save", parameters: nil)
    }
    
    func passedSecretSpot() {
        Analytics.logEvent("pass", parameters: nil)
    }
    
    func touchedSettings() {
        Analytics.logEvent("touched_settings", parameters: nil)
    }
    
    func createdBio() {
        Analytics.logEvent("created_bio", parameters: nil)
    }
    
    func touchedStreetCred() {
        Analytics.logEvent("touched_streetcrd", parameters: nil)
    }
    
    func viewedMission() {
        Analytics.logEvent("viewed_mission", parameters: nil)
    }
    
    func acceptedMission() {
        Analytics.logEvent("accepted_mission", parameters: nil)
    }
    
    func dismissedMission() {
        Analytics.logEvent("dismissed_mission", parameters: nil)
    }
    
    func viewedSecretSpot() {
        Analytics.logEvent("viewed_spot", parameters: nil)
    }
    
    func triedMessagingUser() {
        Analytics.logEvent("messaged_user", parameters: nil)
    }
    
}
