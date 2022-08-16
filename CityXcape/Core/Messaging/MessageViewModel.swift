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
    @Published var error: String = ""
    
    
    init() {
        fetchAllFriends()
    }
    
    
    fileprivate func fetchAllFriends() {
        DataService.instance.getFriendsForUser { result in
            switch result {
                case .success(let returnedUsers):
                    self.users = returnedUsers
                case .failure(let errorMessage):
                    self.error = errorMessage.localizedDescription
            }
        }
    }
    
   
}
