//
//  Ranking.swift
//  CityXcape
//
//  Created by James Allan on 3/19/22.
//

import Foundation
import UIKit


struct Ranking: Identifiable, Hashable {
    
    let id: String
    let profileImageUrl: String
    let displayName: String
    let streetCred: Int
    let streetFollowers: Int
    let bio: String
    
    let currentLevel: String
    let totalSpots: Int
    let totalStamps: Int
    let totalSaves: Int 
    let totalUserVerifications: Int
    let totalPeopleMet: Int
    let totalCities: Int
    let progress: CGFloat
    
    
    init(id: String, profileImageUrl: String, displayName: String, streetCred: Int, streetFollowers: Int, bio: String, currentLevel: String, totalSpots: Int, totalStamps: Int, totalSaves: Int, totalUserVerifications: Int, totalPeopleMet: Int, totalCities: Int, progress: CGFloat) {
        
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
    }
}

enum Rank: String {
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
