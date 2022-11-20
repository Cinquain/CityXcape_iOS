//
//  ChatLogViewModel.swift
//  CityXcape
//
//  Created by James Allan on 8/9/22.
//

import SwiftUI
import Firebase


class ChatLogViewModel: ObservableObject {


    @Published var message: String = ""
    @Published var messages: [Message] = []
    @Published var count: Int = 0
    
    @Published var showLogView: Bool = false
    @Published var createNewMessage: Bool = false
    @Published var recentMessages: [RecentMessage] = []
    @Published var showMessage: Bool = false
    
    @Published var friends: [User] = []
    @Published var friend: User?
    @Published var showFriends: Bool = false 
    
    @Published var errorMessage: String = ""
    @Published var alertMessage: String = ""
    @Published var showAlert: Bool = false
    
    init() {

    }
    
    func sendMessage(user: User) {
        DataService.instance.sendMessage(user: user, content: message) { [weak self] result in
            guard let self = self else {return}
            switch result {
                case .success(let message):
                    print("Successfully sent message")
                    self.messages.append(message)
                    self.message = ""
                    self.count += 1
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func fetchMessages(userId: String) {
        
        DataService.instance.getMessagesForUser(userID: userId) { [weak self] result in
            guard let self = self else {return}
            switch result {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                case .success(let returnedMessages):
                    self.messages = returnedMessages
                    self.count += 1
            }
        }
        
    }
    
    func removeListener() {
        DataService.instance.removeChatListener()
    }
    
    
    
    func deleteRecentMessage(userId: String) {
        DataService.instance.deleteRecentMessages(user: userId)
    }
    
    
    func getRecentMessages() {
        DataService.instance.fetchRecentMessages { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let data):
                self.recentMessages = data.0
                self.count = data.1
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    
    
    func fetchAllFriends() {
        DataService.instance.getFriendsForUser { result in
            switch result {
                case .success(let returnedUsers):
                    self.friends = returnedUsers
                case .failure(let errorMessage):
                    self.errorMessage = errorMessage.localizedDescription
                    self.showAlert = true
            }
        }
    }
    
    
    func deleteFriend(user: User) {
        
        DataService.instance.removeFriendFromList(user: user) { [weak self] result in
            guard let self = self else {return}
            switch result {
                case .success(_):
                    self.alertMessage = "\(user.displayName) has been deleted as friend"
                    self.showAlert = true
                if let index = self.friends.firstIndex(of: user) {
                    self.friends.remove(at: index)
                }
                case .failure(let error):
                    self.alertMessage = error.localizedDescription
                    self.showAlert = true
                
            }
        }
    }
    
    func getFriendsText() -> String {
        if friends.count <= 1 {
            return "\(friends.count) Friend"
        } else {
            return "\(friends.count) Friends"
        }
    }
    
}
