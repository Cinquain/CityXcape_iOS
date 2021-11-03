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
    
}
