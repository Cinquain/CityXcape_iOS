//
//  CityXcapeApp.swift
//  CityXcape
//
//  Created by James Allan on 8/17/21.
//

import SwiftUI
import Firebase
import GoogleSignIn

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

class AppDelegate: NSObject, UIApplicationDelegate {
  
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print("Welcome to CityXcape")
        FirebaseApp.configure()
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
    
    
}
