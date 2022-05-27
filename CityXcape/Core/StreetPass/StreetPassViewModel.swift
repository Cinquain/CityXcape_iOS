//
//  StreetPassViewModel.swift
//  CityXcape
//
//  Created by James Allan on 4/4/22.
//

import Foundation
import Combine
import SwiftUI

class StreetPassViewModel: NSObject, ObservableObject {
    
    @AppStorage(CurrentUserDefaults.userId) var userId: String?

    
    @Published var showJourney: Bool = false
    @Published var showStats: Bool = false
    @Published var showWorld: Bool = false
    
    @Published var showStreetPass: Bool = false
    @Published var worldCompo: [String: Double] = [:]
    @Published var users: [User] = []
    @Published var alertMessage: String = ""
    @Published var showAlert: Bool = false
    

    
    let coreData = CoreDataManager.instance
    let manager = NotificationsManager.instance
    
    override init() {
        super.init()
        calculateWorld()
    }
    
    func generateColors() -> [Color] {
        var colors: [Color] = []
        (0...worldCompo.count).forEach { _ in
            colors.append(Color.random)
        }
        return colors
    }

    
    func openInstagram(username: String)  {
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
    
    func calculateWorld()  {
        coreData.fetchSecretSpots()
        var worlds: [String] = []
        var worldDictionary: [String: Double] = [:]
        
        let spots = coreData.spotEntities.map({SecretSpot(entity: $0)})
        if spots.isEmpty {return}
        spots.forEach({worlds.append(contentsOf: $0.world.components(separatedBy: " "))})
        
        for word in worlds {
            let newWord = word
                        .replacingOccurrences(of: "#", with: "")
                        .replacingOccurrences(of: ",", with: "")
                        
            
            if word == "" {
                continue
            }
                
            if let count = worldDictionary[newWord] {
                worldDictionary[newWord] = count + 1
            } else {
                worldDictionary[newWord] = 1
            }
        }
      
        
        let sum = worldDictionary.reduce(0, {$0 + $1.value})
        
        self.worldCompo = worldDictionary
            .mapValues({($0 / sum).rounded(toPlaces: 2) * 100})
        
        
        var topworld = ""
        worldCompo.keys.forEach { key in
            if topworld == "" {
                topworld = key
            } else {
                if worldCompo[key]! > worldCompo[topworld]! {
                    topworld = key
                }
            }
        }
        topworld.capitalizeFirstLetter()
        print("top world is: \(topworld)")
        
        
        let userData: [String: Any] = [
            UserField.community: topworld,
            UserField.world : worldCompo
        ]
        guard let uid = userId else {return}
        AuthService.instance.updateUserField(uid: uid, data: userData)

    }
    
    
    
    
    
}
