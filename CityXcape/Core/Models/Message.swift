//
//  Message.swift
//  CityXcape
//
//  Created by James Allan on 7/29/22.
//

import Foundation
import Firebase

struct Message: Identifiable, Hashable, Equatable {
    let id: String
    let fromId: String
    let toId: String
    let date: Date
    let content: String
    
    
   func hash(into hasher: inout Hasher) {
       hasher.combine(id)
   }
   
   static func == (lhs: Message, rhs: Message) -> Bool {
       lhs.id == rhs.id
   }
    
    init(data: [String: Any]) {
        self.id = data[MessageField.id] as? String ?? ""
        self.fromId = data[MessageField.fromId] as? String ?? ""
        self.toId = data[MessageField.toId] as? String ?? ""
        self.content = data[MessageField.content] as? String ?? ""
        let time = data[MessageField.timestamp] as? Timestamp
        self.date = time?.dateValue() ?? Date()
    }

}

struct RecentMessage: Identifiable, Hashable, Equatable {
    let id: String
    let fromId: String
    let toId: String
    let date: Date
    let content: String
    let profileUrl: String
    let displayName: String
    let bio: String
    let rank: String
    let userId: String
    
    init(data: [String: Any]) {
        self.id = data[MessageField.id] as? String ?? ""
        self.fromId = data[MessageField.fromId] as? String ?? ""
        self.toId = data[MessageField.toId] as? String ?? ""
        self.content = data[MessageField.content] as? String ?? ""
        let time = data[MessageField.timestamp] as? Timestamp
        self.date = time?.dateValue() ?? Date()
        self.profileUrl = data[MessageField.profileUrl] as? String ?? ""
        self.displayName = data[MessageField.displayName] as? String ?? ""
        self.bio = data[MessageField.bio] as? String ?? ""
        self.rank = data[MessageField.rank] as? String ?? ""
        self.userId = data[MessageField.userId] as? String ?? ""
    }
    

    
}
