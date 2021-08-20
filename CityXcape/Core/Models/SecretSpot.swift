//
//  SecretSpot.swift
//  CityXcape
//
//  Created by James Allan on 8/19/21.
//

import Foundation


struct SecretSpot: Identifiable, Hashable, Codable {
    
    var id: String = UUID().uuidString
    
    let name: String
    let imageUrl: String
    let distance: Double
    
    
}
