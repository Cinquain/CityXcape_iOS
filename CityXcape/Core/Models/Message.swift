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
    
    init(id: String, data: [String: Any]) {
        self.id = id
        self.fromId = data[MessageField.fromId] as? String ?? ""
        self.toId = data[MessageField.toId] as? String ?? ""
        self.content = data[MessageField.content] as? String ?? ""
        let time = data[MessageField.timestamp] as? Timestamp
        self.date = time?.dateValue() ?? Date()
    }
   

}


