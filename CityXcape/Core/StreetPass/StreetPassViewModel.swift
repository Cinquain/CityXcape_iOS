//
//  StreetPassViewModel.swift
//  CityXcape
//
//  Created by James Allan on 4/4/22.
//

import Combine
import SwiftUI

class StreetPassViewModel: NSObject, ObservableObject {
        
    @AppStorage(CurrentUserDefaults.userId) var userId: String?
    @AppStorage(CurrentUserDefaults.bio) var bio: String?
    @AppStorage(CurrentUserDefaults.profileUrl) var profileUrl: String?
    @AppStorage(CurrentUserDefaults.displayName) var displayName: String?
    @AppStorage(CurrentUserDefaults.wallet) var wallet: Int?
    
    @Published var showJourney: Bool = false
    @Published var showStats: Bool = false
    @Published var showStore: Bool = false 
    
    @Published var showStreetPass: Bool = false
    @Published var worldCompo: [String: Double] = [:]
    @Published var users: [User] = []
    @Published var alertMessage: String = ""
    @Published var error: String = ""
    @Published var showAlert: Bool = false
    
    @Published var showRanks: Bool = false 
    @Published var rank: String = ""
    @Published var ranking: [Rank] = []

    @Published var progressString: String = ""
    @Published var progressValue: CGFloat = 0
    @Published var totalStamps: Int = 0
    
    @Published var plugMode: Bool = false
    @Published var message: String = ""
    @Published var friends: [User] = []
    @Published var friend: User?
    @Published var showFriends: Bool = false 
    
    @Published var showLogView: Bool = false
    @Published var createNewMessage: Bool = false
    
    let coreData = CoreDataManager.instance
    let manager = NotificationsManager.instance
    
    override init() {
        super.init()
        calculateWorld()
        calculateRank()
        getScoutLeaders()
        fetchAllFriends()
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
    
    
    func handleStreetCredAlert() {
        message = "StreetCred is a currency that lets you save Secret Spots."
        AnalyticsService.instance.viewStreetpass()
        showAlert.toggle()
    }
    
    func turnOnPlugMode() {
        print("Plug mode is \(plugMode)")
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
    
    
    func calculateRank() {
        
        let allspots = coreData.spotEntities.map({SecretSpot(entity: $0)})
        let verifiedSpots = allspots.filter({$0.verified == true})
        totalStamps = verifiedSpots.count
        let ownerSpots = allspots.filter({$0.ownerId == userId})
        let totalSpotsPosted = ownerSpots.count
        let totalSaves = ownerSpots.reduce(0, {$0 + $1.saveCounts})
        let totalVerifications = ownerSpots.reduce(0, {$0 + $1.verifyCount})
        var totalCities: Int = 0
        var cities: [String: Int] = [:]
        verifiedSpots.forEach { spot in
            if let count = cities[spot.city] {
                cities[spot.city] = count + 1
            } else {
                cities[spot.city] = 1
                totalCities += 1
            }
        }
        
        (self.rank,
         self.progressString,
         self.progressValue) = Rank.calculateRank(totalSpotsPosted: totalSpotsPosted, totalSaves: totalSaves, totalStamps: totalStamps)
        
        guard let uid = userId else {return}
        guard let imageUrl = profileUrl else {return}
        guard let username = displayName else {return}
        guard let bio = bio else {return}
        guard let streetcred = wallet else {return}
        let ranking = Rank(id: uid, profileImageUrl: imageUrl, displayName: username, streetCred: streetcred, streetFollowers: 0, bio: bio, currentLevel: rank, totalSpots: totalSpotsPosted, totalStamps: totalStamps, totalSaves: totalSaves, totalUserVerifications: totalVerifications, totalPeopleMet: totalCities, totalCities: totalCities, progress: progressValue, social: nil)
       
        UserDefaults.standard.set(rank, forKey: CurrentUserDefaults.rank)
        DataService.instance.saveUserRanking(rank: ranking)
    }
    
    
    fileprivate func getScoutLeaders() {
        
        DataService.instance.getUserRankings { ranks in
            self.ranking = ranks
        }
    }
    
    
    func fetchAllFriends() {
        DataService.instance.getFriendsForUser { result in
            switch result {
                case .success(let returnedUsers):
                    self.friends = returnedUsers
                case .failure(let errorMessage):
                    self.error = errorMessage.localizedDescription
                    self.showAlert = true
            }
        }
    }
    
    
    func deleteFriend(user: User) {
        
        DataService.instance.removeFriendFromList(user: user) { [weak self] result in
            guard let self = self else {return}
            switch result {
                case .success(_):
                    self.alertMessage = "\(user.displayName) has been deleted as friend"
                    self.showAlert = true
                case .failure(let error):
                    self.alertMessage = error.localizedDescription
                    self.showAlert = true
            }
        }
    }
    
    func getFriendsText() -> String {
        if friends.count <= 1 {
            return "\(friends.count) Friend"
        } else {
            return "\(friends.count) Friends"
        }
    }
    
    
    
    
    
}
