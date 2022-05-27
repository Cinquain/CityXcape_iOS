//
//  AnalyticsViewModel.swift
//  CityXcape
//
//  Created by James Allan on 3/21/22.
//

import Foundation
import SwiftUI
import Combine


class AnalyticsViewModel: NSObject, ObservableObject {
    
    @AppStorage(CurrentUserDefaults.userId) var userId: String?
    @AppStorage(CurrentUserDefaults.bio) var bio: String?
    @AppStorage(CurrentUserDefaults.wallet) var wallet: Int?
    @AppStorage(CurrentUserDefaults.profileUrl) var profileUrl: String?
    @AppStorage(CurrentUserDefaults.displayName) var username: String?

    
    
    @Published var showLeaderboard: Bool = false
    @Published var showStreetFollowers: Bool = false
    @Published var showFollowing: Bool = false

    @Published var users: [User] = []
    @Published var streetFollowers: [User] = []
    @Published var streetFollowing: [User] = []
    
    @Published var showRanks:Bool = false
    @Published var ranking: [Rank] = []
    
    @Published var alertMessage: String = ""
    @Published var showAlert: Bool = false
    
    @Published var ownerSpots: [SecretSpot] = []
    @Published var totalSpotsPosted: Int = 0
    @Published var totalStamps: Int  = 0
    @Published var totalCheckins: Int = 0
    @Published var totalVerifications: Int = 0
    @Published var totalViews: Int = 0
    @Published var totalSaves: Int = 0
    @Published var rank: String = ""
    @Published var progressString: String = ""
    @Published var progressValue: CGFloat = 0
    @Published var cities: [String: Int] = [:]
    @Published var totalCities: Int = 0
    
    var spotProgress: CGFloat = 0
    var stampProgress: CGFloat = 0
    var saveProgress: CGFloat = 0
    let coreData = CoreDataManager.instance
    let manager = NotificationsManager.instance
    var cancellable: AnyCancellable?
    
    override init() {
        super.init()
        getStreetFollowers()
        calculateRank()
        getFollowing()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.saveToLeaderboard()
        }
        getScoutLeaders()
    }


    func calculateRank() {
        
        let allspots = coreData.spotEntities.map({SecretSpot(entity: $0)})
        let verifiedSpots = allspots.filter({$0.verified == true})
        totalStamps = verifiedSpots.count
        ownerSpots = allspots.filter({$0.ownerId == userId})
        totalSpotsPosted = ownerSpots.count
        totalSaves = ownerSpots.reduce(0, {$0 + $1.saveCounts})
        totalViews = ownerSpots.reduce(0, {$0 + $1.viewCount})
        totalVerifications = ownerSpots.reduce(0, {$0 + $1.verifierCount})
        
        verifiedSpots.forEach { spot in
            if let count = cities[spot.city] {
                self.cities[spot.city] = count + 1
            } else {
                self.cities[spot.city] = 1
                totalCities += 1
            }
        }
        
        (self.rank,
         self.progressString,
         self.progressValue) = Rank.calculateRank(totalSpotsPosted: totalSpotsPosted, totalSaves: totalSaves, totalStamps: totalStamps)
        
        saveToLeaderboard()

    }
    
    
    fileprivate func getScoutLeaders() {
        
        DataService.instance.getUserRankings { ranks in
            self.ranking = ranks
        }
    }
    
    func saveToLeaderboard() {
        guard let uid = userId else {return}
        guard let imageUrl = profileUrl else {return}
        guard let displayName = username else {return}
        guard let bio = bio else {return}
        guard let streetcred = wallet else {return}
        let ranking = Rank(id: uid, profileImageUrl: imageUrl, displayName: displayName, streetCred: streetcred, streetFollowers: 0, bio: bio, currentLevel: rank, totalSpots: totalSpotsPosted, totalStamps: totalStamps, totalSaves: totalSaves, totalUserVerifications: totalVerifications, totalPeopleMet: totalCities, totalCities: totalCities, progress: progressValue, social: nil)
        let userData : [String: Any] = [
            UserField.rank: rank
        ]
        AuthService.instance.updateUserField(uid: uid, data: userData)
        DataService.instance.saveUserRanking(rank: ranking)
    }
    
    
    
    func getStreetFollowers() {
        
        DataService.instance.getStreetFollowers { [weak self] followers in
            self?.streetFollowers = followers
            self?.users = followers
        }
    }
    
    func getFollowing() {
        DataService.instance.getStreetFollowing { [weak self] following in
            self?.streetFollowing = following
        }
    }
    
    
    func unfollowerUser(uid: String) {
        
        DataService.instance.unfollowerUser(followingId: uid) { [weak self] success in
            if success {
                self?.alertMessage = "Successfuly unfollowed user"
                self?.showAlert.toggle()
                self?.streetFollowing.removeAll(where: {$0.id == uid})
            } else {
                self?.alertMessage = "Failed to unfollow user"
                self?.showAlert.toggle()
            }
        }
        
    }
    
    func followerUser(user: User) {
        
        manager.checkAuthorizationStatus { [weak self] fcmToken in
            
            if let token = fcmToken {
                
                DataService.instance.streetFollowUser(user: user, fcmToken: token) {  succcess in
                    if succcess {
                        self?.alertMessage = "Following \(user.displayName)"
                        self?.showAlert = true
                        self?.streetFollowing.append(user)
                    } else {
                        self?.alertMessage = "Cannot follow \(user.displayName)"
                        self?.showAlert = true
                    }
                }
                
            } else {
                self?.alertMessage = "Please give CityXcape notifications permission"
                self?.showAlert = true
            }
            
        }
        
    }
    
    
    func setSubscribers() {
        
      cancellable =  $showFollowing
            .sink { [weak self] boolen in
                if boolen {
                    self?.users = self?.streetFollowing ?? []
                } else {
                    self?.users = self?.streetFollowers ?? []
                }
            }
        
    }
    
    
    
  

    

  
}
