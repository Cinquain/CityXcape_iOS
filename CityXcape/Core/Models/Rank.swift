//
//  Ranking.swift
//  CityXcape
//
//  Created by James Allan on 3/19/22.
//

import Foundation
import UIKit


struct Rank: Identifiable, Hashable {
    
    let id: String
    let profileImageUrl: String
    let displayName: String
    let streetCred: Int
    let streetFollowers: Int
    let bio: String
    let social: String?
    
    let currentLevel: String
    let totalSpots: Int
    let totalStamps: Int
    let totalSaves: Int 
    let totalUserVerifications: Int
    let totalPeopleMet: Int
    let totalCities: Int
    let progress: CGFloat
    
    
    init(id: String, profileImageUrl: String, displayName: String, streetCred: Int, streetFollowers: Int, bio: String, currentLevel: String, totalSpots: Int, totalStamps: Int, totalSaves: Int, totalUserVerifications: Int, totalPeopleMet: Int, totalCities: Int, progress: CGFloat, social: String?) {
        
        self.id = id
        self.profileImageUrl = profileImageUrl
        self.displayName = displayName
        self.streetCred = streetCred
        self.streetFollowers = streetFollowers
        self.bio = bio
        self.currentLevel = currentLevel
        self.totalSpots = totalSpots
        self.totalStamps = totalStamps
        self.totalSaves = totalSaves
        self.totalUserVerifications = totalUserVerifications
        self.totalPeopleMet = totalPeopleMet
        self.totalCities = totalCities
        self.progress = progress
        self.social = social
    }
    
    
    init(data: [String: Any]?) {
        self.id = data?[RankingField.id] as? String ?? ""
        self.profileImageUrl = data?[RankingField.profileUrl] as? String ?? ""
        self.displayName = data?[RankingField.displayName] as? String ?? ""
        self.streetCred = data?[RankingField.streetcred] as? Int ?? 0
        self.streetFollowers = data?[RankingField.streetFollowers] as? Int ?? 0
        self.bio = data?[RankingField.bio] as? String ?? ""
        self.currentLevel = data?[RankingField.level] as? String ?? ""
        self.totalSpots = data?[RankingField.totalSpots] as? Int ?? 0
        self.totalStamps = data?[RankingField.totalStamps] as? Int ?? 0
        self.totalSaves = data?[RankingField.totalSaves] as? Int ?? 0
        self.totalUserVerifications = data?[RankingField.totalVerifications] as? Int ?? 0
        self.totalPeopleMet = data?[RankingField.totalPeopleMet] as? Int ?? 0
        self.totalCities = data?[RankingField.totalCities] as? Int ?? 0
        self.progress = data?[RankingField.progress] as? CGFloat ?? 0
        self.social = data?[RankingField.ig] as? String ?? nil
    }
    
    
    static func calculateRank(totalSpotsPosted: Int, totalSaves: Int, totalStamps: Int) -> (rank: String, nextStep: String, progress: CGFloat) {
            var rank = Ranking.Tourist.rawValue
            var progressDescription = ""
            var progressValue: CGFloat = 0
          if totalSpotsPosted == 0 {
             progressDescription = "Post 1 spot to reach the next level"
             return (rank, progressDescription, progressValue)
          } else if totalSpotsPosted < 3  {
              rank = Ranking.Visitor.rawValue
              progressDescription = "Post \(3 - totalSpotsPosted) spots to reach the next level"
              progressValue =  CGFloat((totalSpotsPosted) / 3 * 200)
              return (rank, progressDescription, progressValue)
          } else if totalSpotsPosted < 10 || totalStamps < 3 {
              rank = Ranking.Observer.rawValue
              if totalStamps < 3 {progressDescription = "Get \(3 - totalStamps) stamps to reach the next level" }
              if totalSpotsPosted < 10 {progressDescription = "Post \(10 - totalSpotsPosted) spots to reach the next level"}
              let spotProgress = CGFloat(min(10, totalSpotsPosted))
              let stampProgress = CGFloat(min(3, totalStamps))
              progressValue =  (spotProgress + stampProgress) / 13 * 200
              return (rank, progressDescription, progressValue)
          } else if totalSpotsPosted < 25 || totalStamps < 10{
              rank = Ranking.Local.rawValue
              let spotProgress = CGFloat(min(25, totalSpotsPosted))
              let stampProgress = CGFloat(min(10, totalStamps))
              if totalStamps < 10 {progressDescription = "Get \(10 - totalStamps) Stamps to reach the next level" }
              if totalSpotsPosted < 25 {progressDescription = "Post \(25 - totalSpotsPosted) spots to reach the next level"}
              progressValue =  (spotProgress + stampProgress) / 35 * 200
              return (rank, progressDescription, progressValue)
          } else if totalSpotsPosted < 50 || totalSaves < 50 || totalStamps < 25 {
              rank = Ranking.Informant.rawValue
              let spotProgress = CGFloat(min(50, totalSpotsPosted))
              let saveProgress = CGFloat(min(50, totalSaves))
              let stampProgress = CGFloat(min(25, totalStamps))
              if totalStamps < 25 {progressDescription = "Get \(25 - totalStamps) stamps to reach the next level" }
              if totalSpotsPosted < 50 {progressDescription = "Post \(50 - totalSpotsPosted) spots to reach the next level"}
              if totalSaves < 50 {progressDescription = "Get \(50 - totalSaves) saves from other users"}
              progressValue =  (spotProgress + saveProgress + stampProgress) / 125 * 200
              return (rank, progressDescription, progressValue)
          } else if totalSpotsPosted < 100 || totalSaves < 100 || totalStamps < 50 {
              rank = Ranking.Scout.rawValue
              let spotProgress = CGFloat(min(100, totalSpotsPosted))
              let saveProgress = CGFloat(min(100, totalSaves))
              let stampProgress = CGFloat(min(50, totalStamps))
              if totalStamps < 100 {progressDescription = "Get \(50 - totalStamps) stamps to reach the next level" }
              if totalSpotsPosted < 100 {progressDescription = "Post \(100 - totalSpotsPosted) spots to reach the next level"}
              if totalSaves < 100 {progressDescription = "Get \(100 - totalSaves) saves from other users"}
              progressValue =  (spotProgress + saveProgress + stampProgress) / 250 * 200
              return (rank, progressDescription, progressValue)
          } else if totalSpotsPosted < 300 || totalSaves < 300 || totalStamps < 300 {
              rank = Ranking.Recon.rawValue
              let spotProgress = CGFloat(min(300, totalSpotsPosted))
              let saveProgress = CGFloat(min(300, totalSaves))
              let stampProgress = CGFloat(min(300, totalStamps))
              if totalStamps < 300 {progressDescription = "Get \(300 - totalStamps) stamps to reach the next level" }
              if totalSpotsPosted < 300 {progressDescription = "Post \(300 - totalSpotsPosted) spots to reach the next level"}
              if totalSaves < 300 {progressDescription = "Get \(300 - totalSaves) saves from other users"}
              progressValue =  (spotProgress + saveProgress + stampProgress) / 900 * 200
              return (rank, progressDescription, progressValue)
          } else if totalSpotsPosted < 1000 || totalSaves < 1000 || totalStamps < 1000 {
              rank = Ranking.ForceRecon.rawValue
              let spotProgress = CGFloat(min(1000, totalSpotsPosted))
              let saveProgress = CGFloat(min(1000, totalSaves))
              let stampProgress = CGFloat(min(1000, totalStamps))
              if totalStamps < 1000 {progressDescription = "Get \(1000 - totalStamps) stamps to reach the next level" }
              if totalSpotsPosted < 1000 {progressDescription = "Post \(1000 - totalSpotsPosted) spots to reach the next level"}
              if totalSaves < 1000 {progressDescription = "Get \(1000 - totalSaves) saves from other users"}
              progressValue =  (spotProgress + saveProgress + stampProgress) / 3000 * 200
              return (rank, progressDescription, progressValue)
          } else if totalSpotsPosted > 1000 && totalSaves > 1000 && totalStamps > 1000 {
              rank = Ranking.Bond.rawValue
              progressDescription = "You are a Top Spy!"
              progressValue = 200
              return (rank, progressDescription, progressValue)
          }
        return ("Tourist", "Post 1 spot to reach the next level!", 0.0)
    }
    
}

enum Ranking: String {
     case Tourist
     case Visitor
     case Observer
     case Local
     case Informant
     case Scout
     case Recon
     case ForceRecon
     case Bond = "007"
}
