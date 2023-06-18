//
//  WorldViewModel.swift
//  CityXcape
//
//  Created by James Allan on 9/28/22.
//

import SwiftUI
import Combine
import MapKit

class WorldViewModel: NSObject, ObservableObject {
    
    @AppStorage(CurrentUserDefaults.userId) var userId: String?
    @AppStorage(CurrentUserDefaults.tribe) var tribe: String?
    @AppStorage(CurrentUserDefaults.profileUrl) var profileUrl: String?
    @AppStorage(CurrentUserDefaults.displayName) var displayName: String?
    @AppStorage(CurrentUserDefaults.bio) var bio: String?
    @AppStorage(CurrentUserDefaults.wallet) var wallet: Int?
    @AppStorage(CurrentUserDefaults.incognito) var incognito: Bool?


    @Published var world: World?
    @Published var ranking: [Rank] = []
    @Published var worlds: [World] = []
    @Published var worldInvite: World?
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
    @Published var showHeatmap: Bool = false

    
    @Published var friendRequest: [User] = []
    @Published var showFriendRequest: Bool = false
    @Published var showWorldForm: Bool = false
    @Published var showInvite: Bool = false

    @Published var annotations: [MKPointAnnotation] = []
    @Published var users: [User] = []

    let manager = CoreDataManager.instance

    override init() {
        super.init()
        calculateRank()
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
            let remainingSpots = world.reqSpots - totalSpots
            let remainingStamps = world.reqStamps - totalStamps
            alertMessage = remainingStamps <= 0 ? "Post \(remainingSpots) more spots to join this world" : "Post \(remainingSpots) spots and get \(remainingStamps) stamp to join this world."
            showAlert.toggle()
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
                    self.calculateRank()
                    self.worlds = returnedWorlds
            }
        }
    }
    
    func fetchWorldInvitations() {
        DataService.instance.getWorldInvites { [weak self] result in
            guard let self = self else {return}
            
            switch result {
                case .failure(let error):
                    self.alertMessage = "No invitation found!"
                    self.showAlert.toggle()
                case .success(let world):
                    self.worldInvite = world
                    self.showInvite.toggle()
                }
        }
    }
    
    
    func fetchUsersFromWorld() {
        if tribe == nil || tribe == "" {
            alertMessage = "You need to be part of a community to see a heatmap. \n Go to Worlds under sandwich menu to join a community."
            showAlert.toggle()
            return
        }
        
        if incognito != nil && incognito == true {
            alertMessage = "Please disable Ghost Mode to see heatmap"
            showAlert.toggle()
            return
        }
        
        guard let tribe = tribe else {return}
        DataService.instance.getUsersFromWorldMap(world: tribe) { [weak self] result in
            guard let self = self else {return}
            switch result {
                case .failure(let error):
                    self.alertMessage = error.localizedDescription
                    self.showAlert.toggle()
                case .success(let users):
                    self.users = users
                self.users.forEach { user in
                    let annotation = MKPointAnnotation()
                    annotation.title = user.displayName
                    annotation.coordinate = .init(latitude: user.latitude ?? 0, longitude: user.longitude ?? 0)
                    annotation.subtitle  = "\(String(format: "%.1f", user.distanceFromUser)) mile away"
                    self.annotations.append(annotation)
                }
                self.showHeatmap.toggle()
                self.sendPushtoNearbyUsers()
            }
        }
    }
    
    func sendPushtoNearbyUsers() {
        let threshold: Double = 1
        users.forEach { user in
            let distance = user.distanceFromUser
            if distance < threshold {
                DataService.instance.notifyNearbyMember(user: user)
            }
        }
    }
    
    func calculateRank() {
        guard let uid = userId else {return}

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
