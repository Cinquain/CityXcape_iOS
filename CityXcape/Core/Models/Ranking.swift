//
//  Ranking.swift
//  CityXcape
//
//  Created by James Allan on 3/19/22.
//

import Foundation


struct Ranking: Identifiable, Hashable {
    
    let id: String
    let profileImageUrl: String
    let displayName: String
    let streetCred: Int
    let streetFollowers: Int
    
    let currentLevel: Rank
    let nextLevel: Rank
    let spotsPosted: Int
    let checkIns: Int
    let peopleMet: Int
    let cities: [String]
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
     case Bond
}
