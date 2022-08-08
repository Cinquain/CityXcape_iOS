//
//  Message.swift
//  CityXcape
//
//  Created by James Allan on 7/29/22.
//

import Foundation


struct Message: Identifiable, Hashable, Equatable {
    let id: String
    let user: User
    let date: Date
    let content: String
    
    
   func hash(into hasher: inout Hasher) {
       hasher.combine(id)
   }
   
   static func == (lhs: Message, rhs: Message) -> Bool {
       lhs.id == rhs.id
   }
   

}


