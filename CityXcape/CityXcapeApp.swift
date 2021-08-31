//
//  CityXcapeApp.swift
//  CityXcape
//
//  Created by James Allan on 8/17/21.
//

import SwiftUI

@main
struct CityXcapeApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
  
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print("Welcome to CityXcape")
        return true
    }
    
    
}
