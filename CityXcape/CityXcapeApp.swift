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
import PartialSheet

@main
struct CityXcapeApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @AppStorage(CurrentUserDefaults.userId) var currentUserID: String?
    @StateObject private var store = Store()
    @State private var showLaunchView: Bool = true
    let router = Router.shared
    
    
    
    var body: some Scene {
        WindowGroup {
            if currentUserID == nil {
                SignUpView()
            } else
            {
                ZStack {
                    HomeView()
                        .attachPartialSheetToRoot()
                        .environmentObject(store)
                        .onOpenURL { url in
                            router.handleUrl(url: url)
                        }
                    
                    ZStack {
                        if showLaunchView {
                            LaunchView(showLaunchView: $showLaunchView)
                                .transition(.move(edge: .leading))
                        }
                    }
                    .zIndex(2)
                
                }
            }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {
    
    static var orientationLock = UIInterfaceOrientationMask.portrait
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print("Welcome to CityXcape")
        FirebaseApp.configure()
        
        registerForNotifications(app: application)
        return true
    }
    
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
 
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        
        print("Hello deep link")
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
                let incomingURL = userActivity.webpageURL,
                let components = NSURLComponents(url: incomingURL, resolvingAgainstBaseURL: true) else {
                return false
            }

            // Check for specific URL components that you need.
        guard let host = components.host else {print("No host found"); return false}
           
        print("DeepLink received and is \(host)")
        return true
    }
    
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("Register for notifications:", deviceToken)
    }
    
    
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Registered with FCM with token", fcmToken)
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }

  
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        if #available(iOS 14.0, *) {
            completionHandler([.list, .banner, .sound])
        } else {
            completionHandler(.alert)
        }
    }
    
    func application(application: UIApplication,  didReceiveRemoteNotification userInfo: [NSObject : AnyObject],  fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {

       print("Recived notification: \(userInfo)")

        completionHandler(.newData)

   }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        
        let userInfo = response.notification.request.content.userInfo
        print("the user info is", userInfo)
        
        if let spotId = userInfo["spotId"] as? String {
            NotificationsManager.instance.spotId = spotId
            NotificationsManager.instance.hasSpotNotification = true
            return
        }
        
        
        let user = User(userInfo: userInfo)
        NotificationsManager.instance.user = user
        NotificationsManager.instance.hasUserNotification = true
        completionHandler()
        
    }
    
    
     func registerForNotifications(app: UIApplication) {
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
                UNUserNotificationCenter.current().delegate = self

                
            } else {
                print("Authorization request was Denied")
                
            }
        }
        
        
        app.registerForRemoteNotifications()
    }
    
    
    
 
    
  
    
}
