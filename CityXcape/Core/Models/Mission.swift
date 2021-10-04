//
//  Mission.swift
//  CityXcape
//
//  Created by James Allan on 10/4/21.
//

import Foundation



struct Mission: Hashable {
    
    let title: String
    let imageurl: String
    let description: String
    let world: String
    let region: String
    let bounty: Int
    let owner: String
    let ownerImageUrl: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
    
}
