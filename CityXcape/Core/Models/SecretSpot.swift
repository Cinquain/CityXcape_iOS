//
//  SecretSpot.swift
//  CityXcape
//
//  Created by James Allan on 8/19/21.
//

import Foundation


struct SecretSpot: Identifiable, Hashable, Codable {
    
    var id: String = UUID().uuidString
    let username: String
    let name: String
    let imageUrl: String
    let distance: Double
    let address: String
    
}
