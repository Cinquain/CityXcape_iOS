//
//  AnalyticsViewModel.swift
//  CityXcape
//
//  Created by James Allan on 3/21/22.
//

import Foundation
import SwiftUI


class AnalyticsViewModel: NSObject, ObservableObject {
    
    @AppStorage(CurrentUserDefaults.userId) var userId: String?
    @AppStorage(CurrentUserDefaults.bio) var bio: String?
    @AppStorage(CurrentUserDefaults.wallet) var wallet: Int?
    @AppStorage(CurrentUserDefaults.profileUrl) var profileUrl: String?
    @AppStorage(CurrentUserDefaults.displayName) var username: String?
    
    let manager = CoreDataManager.instance
    
    @Published var showLeaderboard: Bool = false
    @Published var showRanks:Bool = false
    @Published var ranking: [Ranking] = []
    
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
    
    override init() {
        super.init()
        calculateRank()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.saveToLeaderboard()
        }
        getScoutLeaders()
    }


    func calculateRank() {
        let allspots = manager.spotEntities.map({SecretSpot(entity: $0)})
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
        
      
        if totalSpotsPosted == 0 {
            rank = Rank.Tourist.rawValue
            progressString = "Post 1 spot to reach the next level"
            progressValue = 0
            return
        } else if totalSpotsPosted < 3  {
            rank = Rank.Visitor.rawValue
            progressString = "Post \(3 - totalSpotsPosted) spots to reach the next level"
            progressValue =  CGFloat((totalSpotsPosted) / 3 * 200)
            return
        } else if totalSpotsPosted < 10 || totalSaves < 25 || totalStamps < 3 {
            rank = Rank.Observer.rawValue
            spotProgress = CGFloat(min(10, totalSpotsPosted))
            saveProgress = CGFloat(min(25, totalSaves))
            stampProgress = CGFloat(min(3, totalStamps))
            progressString = "\(min(10, totalSpotsPosted))/10 spots, \(min(25, totalSaves))/25 saves, \(min(3, totalStamps))/3 stamps remaining"
            progressValue =  (spotProgress + saveProgress + stampProgress) / 38 * 200
            print("progress value is \(progressValue)")
            return
        } else if totalSpotsPosted < 25 || totalSaves < 100  || totalStamps < 10{
            rank = Rank.Local.rawValue
            spotProgress = CGFloat(min(25, totalSpotsPosted))
            saveProgress = CGFloat(min(100, totalSaves))
            stampProgress = CGFloat(min(10, totalStamps))
            progressString = "\(min(25, totalSpotsPosted))/25 spots, \(min(100, totalSaves))/100 saves, \(min(10, totalStamps))/10 stamps remaining"
            progressValue =  (spotProgress + saveProgress + stampProgress) / 135 * 200
        } else if totalSpotsPosted < 50 || totalSaves < 250 || totalStamps < 50 {
            rank = Rank.Informant.rawValue
            spotProgress = CGFloat(min(50, totalSpotsPosted))
            saveProgress = CGFloat(min(250, totalSaves))
            stampProgress = CGFloat(min(50, totalStamps))
            progressString = "\(min(50, totalSpotsPosted))/50 spots, \(min(250, totalSaves))/250 saves, \(min(50, totalStamps))/50 stamps remaining"
            progressValue =  (spotProgress + saveProgress + stampProgress) / 350 * 200
            return
        } else if totalSpotsPosted < 100 || totalSaves < 1000 || totalStamps < 100 {
            rank = Rank.Scout.rawValue
            spotProgress = CGFloat(min(100, totalSpotsPosted))
            saveProgress = CGFloat(min(1000, totalSaves))
            stampProgress = CGFloat(min(100, totalStamps))
            progressString = "\(min(100, totalSpotsPosted))/100 spots, \(min(1000, totalSaves))/1K saves, \(min(100, totalStamps))/100 stamps remaining"
            progressValue =  (spotProgress + saveProgress + stampProgress) / 1200 * 200
            return
        } else if totalSpotsPosted < 300 || totalSaves < 5000 || totalStamps < 300 {
            rank = Rank.Recon.rawValue
            spotProgress = CGFloat(min(300, totalSpotsPosted))
            saveProgress = CGFloat(min(5000, totalSaves))
            stampProgress = CGFloat(min(300, totalStamps))
            progressString = "\(min(300, totalSpotsPosted))/300 spots, \(min(5000, totalSaves))/5K saves, \(min(300, totalStamps))/300 stamps remaining"
            progressValue =  (spotProgress + saveProgress + stampProgress) / 5600 * 200
            return
        } else if totalSpotsPosted < 1000 || totalSaves < 10000 || totalStamps < 1000 {
            rank = Rank.ForceRecon.rawValue
            spotProgress = CGFloat(min(1000, totalSpotsPosted))
            saveProgress = CGFloat(min(10000, totalSaves))
            stampProgress = CGFloat(min(1000, totalStamps))
            progressString = "\(min(1000, totalSpotsPosted))/1K spots, \(min(10000, totalSaves))/10K saves, \(min(1000, totalStamps))/1K stamps remaining"
            progressValue =  (spotProgress + saveProgress + stampProgress) / 12000 * 200
            return
        } else if totalSpotsPosted > 1000 && totalSaves > 10000 && totalStamps > 1000 {
            rank = Rank.Bond.rawValue
            progressString = "You are a Scout Chief"
            progressValue = 200
            return
        }
        
 

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
        let ranking = Ranking(id: uid, profileImageUrl: imageUrl, displayName: displayName, streetCred: streetcred, streetFollowers: 0, bio: bio, currentLevel: rank, totalSpots: totalSpotsPosted, totalStamps: totalStamps, totalSaves: totalSaves, totalUserVerifications: totalVerifications, totalPeopleMet: totalCities, totalCities: totalCities, progress: progressValue)
       
        DataService.instance.CreateUserRanking(rank: ranking)
    }
    
    
  

    

  
}
