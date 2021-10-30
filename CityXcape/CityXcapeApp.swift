//
//  CityXcapeApp.swift
//  CityXcape
//
//  Created by James Allan on 8/17/21.
//

import SwiftUI
import Firebase
import GoogleSignIn
import UserNotifications
import FirebaseMessaging

@main
struct CityXcapeApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @AppStorage(CurrentUserDefaults.userId) var currentUserID: String?
    
    var body: some Scene {
        WindowGroup {
            if currentUserID == nil {
                SignUpView()
            } else
            {
                HomeView()
            }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {
  
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print("Welcome to CityXcape")
        FirebaseApp.configure()
        
        registerForNotifications(app: application)
        
        return true
    }
    
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("Register for notifications:", deviceToken)
    }
    
    
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Registered with FCM with token", fcmToken)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        if #available(iOS 14.0, *) {
            completionHandler([.list, .banner, .sound])
        } else {
            completionHandler(.alert)
        }
    }
    
    
    fileprivate func registerForNotifications(app: UIApplication) {
        print("Registering for push notifications")
        
        Messaging.messaging().delegate = self
        
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        
        UNUserNotificationCenter.current().requestAuthorization(options: options) { granted, error in
            
            if let error = error {
                print("Error getting notification permission", error.localizedDescription)
                return
            }
            
            if granted {
                print("Authorization granted")
                
                
            } else {
                print("Authorization request was Denied")
                
            }
        }
        
        
        app.registerForRemoteNotifications()
    }
    
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
    
    
}
