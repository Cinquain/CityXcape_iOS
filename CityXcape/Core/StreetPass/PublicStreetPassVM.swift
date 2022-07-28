//
//  PublicStreetPassVM.swift
//  CityXcape
//
//  Created by James Allan on 5/21/22.
//

import Foundation
import SwiftUI


class PublicStreetPassVM: NSObject, ObservableObject {
    
    @Published var showJourney: Bool = false
    @Published var verifications: [Verification] = []
    @Published var alertMessage: String = ""
    @Published var showAlert: Bool = false
    
    override init() {
        super.init()
        
    }
    
    
     func getVerificationForUser(userId: String) {
        AnalyticsService.instance.checkUserJourney()
        DataService.instance.getVerifications(uid: userId) { [weak self] verifications in
            guard let self = self else {return}
            if verifications.count == 0 {
                self.alertMessage = "This user has been nowhere"
                self.showAlert = true
            } else {
                self.verifications = verifications
                self.showJourney = true
            }
        }
    }
    
    func streetFollowerUser(fcm: String, user: User) {
        DataService.instance.streetFollowUser(user: user, fcmToken: fcm) { [weak self] succcess in
            guard let self = self else {return}
            if succcess {
                self.alertMessage = "Street Following \(user.displayName)"
                self.showAlert = true
            } else {
                self.alertMessage = "Cannot street follow \(user.displayName)"
                self.showAlert = true
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
