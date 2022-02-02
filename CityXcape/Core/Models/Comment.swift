//
//  Comment.swift
//  CityXcape
//
//  Created by James Allan on 1/28/22.
//

import Foundation
import SwiftUI


struct Comment: Identifiable, Hashable {
    
    
    let id: String
    let uid: String
    let username: String
    let imageUrl: String
    let bio: String
    let content: String
    let dateCreated: Date
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
