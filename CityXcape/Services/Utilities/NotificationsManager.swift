//
//  NotificationsManager.swift
//  CityXcape
//
//  Created by James Allan on 11/2/21.
//

import Foundation
import Combine
import SwiftUI
import FirebaseMessaging


class NotificationsManager: ObservableObject {
    
    
    static let instance = NotificationsManager()
    private init() {}
    
    @Published var hasUserNotification: Bool = false
    @Published var user: User?
    
    @Published var hasSpotNotification: Bool = false
    @Published var spotId: String = ""
    
    
    let manager = UNUserNotificationCenter.current()
    
    func checkAuthorizationStatus(completion: @escaping (_ fcmToken: String?) -> ()) {
        
        
        manager.getNotificationSettings { [weak self] settings in
            
            if settings.authorizationStatus == .authorized {
                let fcmToken = Messaging.messaging().fcmToken
                completion(fcmToken)
            } else {
                completion(nil)
                self?.requestNotification()
            }
            
            
        }
    }
    
    
    fileprivate func requestNotification() {
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]

        manager.requestAuthorization(options: options) { granted, error in
            
            if let error = error {
                print("Error getting notification permission", error.localizedDescription)
                return
            }
            
            if granted {
                print("Authorization granted")
                let delegate = UIApplication.shared.delegate as? AppDelegate
                let app = UIApplication.shared
                delegate?.registerForNotifications(app: app)
            } else {
                print("Authorization request was Denied")
                
            }
        }
    }
}
