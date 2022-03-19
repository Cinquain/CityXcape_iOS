//
//  Follower.swift
//  CityXcape
//
//  Created by James Allan on 3/19/22.
//

import Foundation

struct Follower: Identifiable, Hashable {
    
    let id: String
    let profileUrl: String
    let displayName: String
    let followingDate: Date
    
}
