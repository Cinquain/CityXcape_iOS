//
//  MessageViewModel.swift
//  CityXcape
//
//  Created by James Allan on 8/2/22.
//

import SwiftUI



class MessageViewModel: ObservableObject {

    @AppStorage(CurrentUserDefaults.userId) var userId: String?
    @AppStorage(CurrentUserDefaults.profileUrl) var profileUrl: String?
    @AppStorage(CurrentUserDefaults.displayName) var displayName: String?
    
    @Published var showLogView: Bool = false
    @Published var createNewMessage: Bool = false
    @Published var users: [User] = []
    @Published var user: User?
    
    let message = Message(id: "1234", user:  User(id: "gfhjdf", displayName: "Cinquain", profileImageUrl: "https://firebasestorage.googleapis.com/v0/b/cityxcape-1e84f.appspot.com/o/users%2FL8f41O2WTbRKw8yitT6e%2FprofileImage?alt=media&token=1a4c018a-d539-4c95-87ca-fdec61f8e73c"), date: Date(), content: "Message from user")
    
    
    init() {
        fetchAllFriends()
    }
    
    
    fileprivate func fetchAllFriends() {
        
    }
    
   
}
