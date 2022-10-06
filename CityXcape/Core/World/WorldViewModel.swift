//
//  WorldViewModel.swift
//  CityXcape
//
//  Created by James Allan on 9/28/22.
//

import SwiftUI
import Combine

class WorldViewModel: NSObject, ObservableObject {
    
    @AppStorage(CurrentUserDefaults.userId) var userId: String?
    @AppStorage(CurrentUserDefaults.tribe) var tribe: String?
    @AppStorage(CurrentUserDefaults.profileUrl) var profileUrl: String?
    @AppStorage(CurrentUserDefaults.displayName) var displayName: String?
    @AppStorage(CurrentUserDefaults.bio) var bio: String?
    @AppStorage(CurrentUserDefaults.wallet) var wallet: Int?
    

    @Published var world: World?
    @Published var ranking: [Rank] = []
    @Published var worlds: [World] = []
    @Published var rank: String = ""
    @Published var progressString: String = ""
    @Published var progressValue: CGFloat = 0
    @Published var totalStamps: Int = 0
    @Published var totalSpots: Int = 0
    @Published var totalCities: Int = 0
    @Published var secretspots: [SecretSpot] = []
    
    @Published var alertMessage: String = ""
    @Published var showAlert: Bool = false
    @Published var showLeaders: Bool = false
    @Published var showSpots: Bool = false

    
    @Published var friendRequest: [User] = []
    @Published var showFriendRequest: Bool = false
    @Published var showWorldForm: Bool = false
    
    let manager = CoreDataManager.instance

    override init() {
        super.init()
        self.fetchWorlds()
        self.calculateRank()
    }
    
    
    
    func loadWorld() {
        guard let tribe = tribe else {return}
        DataService.instance.getSpecificWorld(name: tribe) { [weak self] result in
            guard let self = self else {return}
            switch result{
            case .failure(let error):
                self.alertMessage = error.localizedDescription
                self.showAlert.toggle()
            case .success(let world):
                self.world = world
            }
        }
    }
    
    func isValid(world: World) -> Bool {
        guard let streetcred = wallet else {return false}
        if totalSpots >= world.reqSpots
            && totalStamps >= world.reqStamps
            && streetcred >= world.initationFee  {
            return true
        }
        else {
            return false
        }
    }
    
    func fetchWorlds() {
        DataService.instance.getPublicWorlds { [weak self] result in
            guard let self = self else {return}
            switch result {
                case .failure(let error):
                    print("Failed to get worlds")
                    self.alertMessage = error.localizedDescription
                    self.showAlert.toggle()
                case .success(let returnedWorlds):
                    print("Found worlds")
                    self.worlds = returnedWorlds
            }
        }
    }
    
    func calculateRank() {
        
        let allspots = manager.spotEntities.map({SecretSpot(entity: $0)})
        let verifiedSpots = allspots.filter({$0.verified == true})
        totalStamps = verifiedSpots.count
        let ownerSpots = allspots.filter({$0.ownerId == userId})
        totalSpots = ownerSpots.count
        let totalSaves = ownerSpots.reduce(0, {$0 + $1.saveCounts})
        let totalVerifications = ownerSpots.reduce(0, {$0 + $1.verifyCount})
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
         self.progressValue) = Rank.calculateRank(totalSpotsPosted: totalSpots, totalSaves: totalSaves, totalStamps: totalStamps)
        
        guard let uid = userId else {return}
        guard let imageUrl = profileUrl else {return}
        guard let username = displayName else {return}
        guard let bio = bio else {return}
        guard let streetcred = wallet else {return}
        let ranking = Rank(id: uid, profileImageUrl: imageUrl, displayName: username, streetCred: streetcred, streetFollowers: 0, bio: bio, currentLevel: rank, totalSpots: totalSpots, totalStamps: totalStamps, totalSaves: totalSaves, totalUserVerifications: totalVerifications, totalPeopleMet: totalCities, totalCities: totalCities, progress: progressValue, social: nil)
       
        UserDefaults.standard.set(rank, forKey: CurrentUserDefaults.rank)
        DataService.instance.saveUserRanking(rank: ranking)
        
    }
    
    
     func getScoutLeaders() {
        
        DataService.instance.getUserRankings { ranks in
            self.ranking = ranks
        }
    }
    
    func getFriendRequest() {
        DataService.instance.getFriendRequests() { [weak self] result in
            guard let self = self else {return}
            switch result {
                case .failure(let error):
                    self.alertMessage = error.localizedDescription
                    self.showAlert.toggle()
            case .success(let requests):
                if requests.isEmpty {
                    self.alertMessage = "No pending friend request"
                    self.showAlert.toggle()
                    return
                }
                self.friendRequest = requests
                self.showFriendRequest.toggle()
            }
        }
        
    }
    
    func loadUserSecretSpots() {
        guard let uid = userId else {return}
        let spots = manager.spotEntities.map({SecretSpot(entity: $0)}).filter({$0.ownerId == uid})
        if spots.isEmpty {
            alertMessage = "You have not posted any spots"
            showAlert.toggle()
            return
        }
        secretspots = spots
        showSpots.toggle()
    }

}
