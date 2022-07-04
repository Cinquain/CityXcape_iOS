//
//  NotificationsManager.swift
//  CityXcape
//
//  Created by James Allan on 11/2/21.
//

import Combine
import SwiftUI
import FirebaseMessaging
import MapKit


class NotificationsManager: ObservableObject {
    
    
    static let instance = NotificationsManager()
    @Published var showPublicPass: Bool = false
    

    @Published var hasUserNotification: Bool = false
    @Published var user: User?
    
    @Published var hasSpotNotification: Bool = false
    @Published var spotId: String?
    @Published var stamp: Verification?
    
    let dataManager = CoreDataManager.instance
    
    let manager = UNUserNotificationCenter.current()
    
    private init() {
        setupLocationlNotifications()
    }
    
    
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
    
    
    fileprivate func setupLocationlNotifications() {
        let allspots = dataManager
                        .spotEntities.map({SecretSpot(entity: $0)})
      
        allspots.forEach { spot in
            
            let content = UNMutableNotificationContent()
            content.title = "\(spot.spotName) is nearby"
            content.subtitle = "Go inside to get your stamp"
            content.sound = .default
            content.badge = 1
            
            let coordinate = CLLocationCoordinate2D(latitude: spot.latitude, longitude: spot.longitude)
            let region = CLCircularRegion(center: coordinate, radius: 500, identifier: spot.spotName)
            region.notifyOnEntry = true
            region.notifyOnExit = false
            let trigger = UNLocationNotificationTrigger(region: region, repeats: true)
            let request = UNNotificationRequest(identifier: spot.spotName, content: content, trigger: trigger)
            manager.add(request)
            
        }
        print("Location notification scheduled")
        
    }
}
