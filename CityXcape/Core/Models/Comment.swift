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
    
    
    init(id: String, user: User, comment: String) {
        self.id = id
        self.content = comment
        self.dateCreated = Date()
        self.uid = user.id
        self.username = user.displayName
        self.imageUrl = user.profileImageUrl
        self.bio = user.bio ?? ""
    }
    
    init(id: String, uid: String, username: String, imageUrl: String, bio: String, content: String, dateCreated: Date) {
        self.id = id
        self.uid = uid
        self.username = username
        self.imageUrl = imageUrl
        self.bio = bio
        self.content = content
        self.dateCreated = dateCreated
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
